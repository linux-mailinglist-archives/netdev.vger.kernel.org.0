Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B0917404D23
	for <lists+netdev@lfdr.de>; Thu,  9 Sep 2021 14:02:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240716AbhIIMA4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Sep 2021 08:00:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:34238 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244637AbhIIL6K (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 9 Sep 2021 07:58:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B3A7261401;
        Thu,  9 Sep 2021 11:45:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631187938;
        bh=I/M4pNGONIV9TaA3hI99k3VsD8Y6fqB+aAbLwvsHbM4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BIVZNbKzikd5eZU/X0Wk/Q2zE1zyhhbxeF2wFwgrTGe3Zvb9qMQ4Rvb2j6HHSxTi5
         lUjR6ey9R+scQ+2z9Fr5rOLlCTnwdigDcpO7w/me1sRkj+zcvu9pr20Qz87AQIwQJA
         Us2sfle0X9CDYgD4p166L6swJ4xbSS+dFjrVXMzHbum7MqDZsPpCAIemzDfg3JXQYs
         18Ltd914dU1dgNn++uRBQrmkvxUFrlSmNLT9aIzfdU3GIKux1Hjpk0y0UTxTNBHwt9
         1Zc7R9Q4GUdUYqyOxtUHNS1mJKVlpDMbdhKBLEaLa4LBk6FuFGJFuOtUm40j9jlVlO
         c9M4icJkXfCXA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Yonglong Li <liyonglong@chinatelecom.cn>,
        Geliang Tang <geliangtang@gmail.com>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org,
        mptcp@lists.linux.dev
Subject: [PATCH AUTOSEL 5.14 209/252] mptcp: fix ADD_ADDR and RM_ADDR maybe flush addr_signal each other
Date:   Thu,  9 Sep 2021 07:40:23 -0400
Message-Id: <20210909114106.141462-209-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210909114106.141462-1-sashal@kernel.org>
References: <20210909114106.141462-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yonglong Li <liyonglong@chinatelecom.cn>

[ Upstream commit 119c022096f5805680c79dfa74e15044c289856d ]

ADD_ADDR shares pm.addr_signal with RM_ADDR, so after RM_ADDR/ADD_ADDR
has done, we should not clean ADD_ADDR/RM_ADDR's addr_signal.

Co-developed-by: Geliang Tang <geliangtang@gmail.com>
Signed-off-by: Geliang Tang <geliangtang@gmail.com>
Signed-off-by: Yonglong Li <liyonglong@chinatelecom.cn>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mptcp/pm.c | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/net/mptcp/pm.c b/net/mptcp/pm.c
index 639271e09604..f47b71a21b7e 100644
--- a/net/mptcp/pm.c
+++ b/net/mptcp/pm.c
@@ -253,6 +253,7 @@ bool mptcp_pm_add_addr_signal(struct mptcp_sock *msk, unsigned int remaining,
 			      struct mptcp_addr_info *saddr, bool *echo, bool *port)
 {
 	int ret = false;
+	u8 add_addr;
 
 	spin_lock_bh(&msk->pm.lock);
 
@@ -267,7 +268,11 @@ bool mptcp_pm_add_addr_signal(struct mptcp_sock *msk, unsigned int remaining,
 		goto out_unlock;
 
 	*saddr = msk->pm.local;
-	WRITE_ONCE(msk->pm.addr_signal, 0);
+	if (*echo)
+		add_addr = msk->pm.addr_signal & ~BIT(MPTCP_ADD_ADDR_ECHO);
+	else
+		add_addr = msk->pm.addr_signal & ~BIT(MPTCP_ADD_ADDR_SIGNAL);
+	WRITE_ONCE(msk->pm.addr_signal, add_addr);
 	ret = true;
 
 out_unlock:
@@ -279,6 +284,7 @@ bool mptcp_pm_rm_addr_signal(struct mptcp_sock *msk, unsigned int remaining,
 			     struct mptcp_rm_list *rm_list)
 {
 	int ret = false, len;
+	u8 rm_addr;
 
 	spin_lock_bh(&msk->pm.lock);
 
@@ -286,16 +292,17 @@ bool mptcp_pm_rm_addr_signal(struct mptcp_sock *msk, unsigned int remaining,
 	if (!mptcp_pm_should_rm_signal(msk))
 		goto out_unlock;
 
+	rm_addr = msk->pm.addr_signal & ~BIT(MPTCP_RM_ADDR_SIGNAL);
 	len = mptcp_rm_addr_len(&msk->pm.rm_list_tx);
 	if (len < 0) {
-		WRITE_ONCE(msk->pm.addr_signal, 0);
+		WRITE_ONCE(msk->pm.addr_signal, rm_addr);
 		goto out_unlock;
 	}
 	if (remaining < len)
 		goto out_unlock;
 
 	*rm_list = msk->pm.rm_list_tx;
-	WRITE_ONCE(msk->pm.addr_signal, 0);
+	WRITE_ONCE(msk->pm.addr_signal, rm_addr);
 	ret = true;
 
 out_unlock:
-- 
2.30.2

