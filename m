Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD17B3BCE7E
	for <lists+netdev@lfdr.de>; Tue,  6 Jul 2021 13:26:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233865AbhGFL0a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Jul 2021 07:26:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:56058 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233772AbhGFLWk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 6 Jul 2021 07:22:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A82E561CCE;
        Tue,  6 Jul 2021 11:17:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625570279;
        bh=iDdTHi8fF05/l89Ec0k1cfTqdGzT83J5qDlWvN6L4fI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=e8F6RTuywiQGJSC2XwYO1+sKpMx9higM+x+gK1mOeaVJ2c+4EvaaPnE+ErBiv7KX+
         WbcWaeYE6L2ZLKwaWqWY4oyTB54gDUyzqYR58AaDz/4PZD6nKRvozEz8fRWKvzwANE
         rpFyg74fRSTY/hogYOGykM9ARlZLTYuPz41P0sm4A/R65ItUQe4naIOtjMGtxCTL6X
         uxr20t8PS0dvaoyhj1gg3CqHhv0ossfHsmG+GQmLngM/jwHA+Img7iPQFonWJg/mKO
         FVn4rFtomKN2mOZ3ArqPRY5p5YIqvkfFGFC+6FFULOF0I3Sy7EMWOJWsZxvk6T+57E
         vJzUaNIIvQPbw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Thadeu Lima de Souza Cascardo <cascardo@canonical.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org,
        linux-bluetooth@vger.kernel.org
Subject: [PATCH AUTOSEL 5.13 171/189] Bluetooth: cmtp: fix file refcount when cmtp_attach_device fails
Date:   Tue,  6 Jul 2021 07:13:51 -0400
Message-Id: <20210706111409.2058071-171-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210706111409.2058071-1-sashal@kernel.org>
References: <20210706111409.2058071-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Thadeu Lima de Souza Cascardo <cascardo@canonical.com>

[ Upstream commit 3cfdf8fcaafa62a4123f92eb0f4a72650da3a479 ]

When cmtp_attach_device fails, cmtp_add_connection returns the error value
which leads to the caller to doing fput through sockfd_put. But
cmtp_session kthread, which is stopped in this path will also call fput,
leading to a potential refcount underflow or a use-after-free.

Add a refcount before we signal the kthread to stop. The kthread will try
to grab the cmtp_session_sem mutex before doing the fput, which is held
when get_file is called, so there should be no races there.

Reported-by: Ryota Shiga
Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
Signed-off-by: Marcel Holtmann <marcel@holtmann.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/cmtp/core.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/net/bluetooth/cmtp/core.c b/net/bluetooth/cmtp/core.c
index 07cfa3249f83..0a2d78e811cf 100644
--- a/net/bluetooth/cmtp/core.c
+++ b/net/bluetooth/cmtp/core.c
@@ -392,6 +392,11 @@ int cmtp_add_connection(struct cmtp_connadd_req *req, struct socket *sock)
 	if (!(session->flags & BIT(CMTP_LOOPBACK))) {
 		err = cmtp_attach_device(session);
 		if (err < 0) {
+			/* Caller will call fput in case of failure, and so
+			 * will cmtp_session kthread.
+			 */
+			get_file(session->sock->file);
+
 			atomic_inc(&session->terminate);
 			wake_up_interruptible(sk_sleep(session->sock->sk));
 			up_write(&cmtp_session_sem);
-- 
2.30.2

