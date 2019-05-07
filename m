Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B0BA915BF7
	for <lists+netdev@lfdr.de>; Tue,  7 May 2019 07:59:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727557AbfEGFgo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 May 2019 01:36:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:56542 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728142AbfEGFgm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 7 May 2019 01:36:42 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 14C4420989;
        Tue,  7 May 2019 05:36:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557207401;
        bh=PAJbD/nVxOh97/0w5rpO4ePGdhs/onBSViaK+uXO4gY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EYg91JQpUvw3BCudCUYNOpBvwMlvg1uNoxGJTzhNqOmw/puo9KK6qHkwWzTdc3PfK
         2YKvdB5awOw6ME4SDIbWA8pvkjJ7P4EetcM2aqqCiKXgt2w3wyiSMO1TYYbjh14I2v
         cFKmmbFxXtiUCsp7aWwbbu8u8DfiaIVCWTh+7MVY=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 24/81] mISDN: Check address length before reading address family
Date:   Tue,  7 May 2019 01:34:55 -0400
Message-Id: <20190507053554.30848-24-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190507053554.30848-1-sashal@kernel.org>
References: <20190507053554.30848-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>

[ Upstream commit 238ffdc49ef98b15819cfd5e3fb23194e3ea3d39 ]

KMSAN will complain if valid address length passed to bind() is shorter
than sizeof("struct sockaddr_mISDN"->family) bytes.

Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/isdn/mISDN/socket.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/isdn/mISDN/socket.c b/drivers/isdn/mISDN/socket.c
index 18c0a1281914..b2abc44fa5cb 100644
--- a/drivers/isdn/mISDN/socket.c
+++ b/drivers/isdn/mISDN/socket.c
@@ -711,10 +711,10 @@ base_sock_bind(struct socket *sock, struct sockaddr *addr, int addr_len)
 	struct sock *sk = sock->sk;
 	int err = 0;
 
-	if (!maddr || maddr->family != AF_ISDN)
+	if (addr_len < sizeof(struct sockaddr_mISDN))
 		return -EINVAL;
 
-	if (addr_len < sizeof(struct sockaddr_mISDN))
+	if (!maddr || maddr->family != AF_ISDN)
 		return -EINVAL;
 
 	lock_sock(sk);
-- 
2.20.1

