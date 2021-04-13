Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD6F935E3B6
	for <lists+netdev@lfdr.de>; Tue, 13 Apr 2021 18:22:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229911AbhDMQWR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Apr 2021 12:22:17 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:33289 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243945AbhDMQWM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Apr 2021 12:22:12 -0400
Received: from [179.93.186.178] (helo=localhost.localdomain)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <cascardo@canonical.com>)
        id 1lWLnQ-0002gG-O5; Tue, 13 Apr 2021 16:21:49 +0000
From:   Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
To:     linux-bluetooth@vger.kernel.org
Cc:     netdev@vger.kernel.org, kuba@kernel.org, davem@davemloft.net,
        isdn@linux-pingi.de, marcel@holtmann.org, johan.hedberg@gmail.com,
        luiz.dentz@gmail.com,
        Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
Subject: [PATCH] net: bluetooth: cmtp: fix file refcount when cmtp_attach_device fails
Date:   Tue, 13 Apr 2021 13:21:03 -0300
Message-Id: <20210413162103.435467-1-cascardo@canonical.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When cmtp_attach_device fails, cmtp_add_connection returns the error value
which leads to the caller to doing fput through sockfd_put. But
cmtp_session kthread, which is stopped in this path will also call fput,
leading to a potential refcount underflow or a use-after-free.

Add a refcount before we signal the kthread to stop. The kthread will try
to grab the cmtp_session_sem mutex before doing the fput, which is held
when get_file is called, so there should be no races there.

Reported-by: Ryota Shiga
Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
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
2.27.0

