Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D18C22D4F2E
	for <lists+netdev@lfdr.de>; Thu, 10 Dec 2020 01:00:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728504AbgLIX6w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Dec 2020 18:58:52 -0500
Received: from mga06.intel.com ([134.134.136.31]:19330 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726812AbgLIX6v (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 9 Dec 2020 18:58:51 -0500
IronPort-SDR: Y921I2bup8t09fcWR88PEcbPE4cXaxbZHuuiWjLTFaQvRCoVxizEhe0RFagTBMG2eKwtxyz4JQ
 1pIjKHOBKSUQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9830"; a="235763098"
X-IronPort-AV: E=Sophos;i="5.78,407,1599548400"; 
   d="scan'208";a="235763098"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Dec 2020 15:51:40 -0800
IronPort-SDR: aB9qkDaDepvuGXT/0X4GRM116QmL7pYQ20Kwov/Uyt8mh1PK3t2fE5AE1kmJKA4BSbrit/gPIJ
 SvvvKzACTBWg==
X-IronPort-AV: E=Sophos;i="5.78,407,1599548400"; 
   d="scan'208";a="318582195"
Received: from mjmartin-nuc02.amr.corp.intel.com ([10.254.111.12])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Dec 2020 15:51:40 -0800
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Geliang Tang <geliangtang@gmail.com>, davem@davemloft.net,
        kuba@kernel.org, mptcp@lists.01.org,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: [PATCH net-next 09/11] mptcp: drop rm_addr_signal flag
Date:   Wed,  9 Dec 2020 15:51:26 -0800
Message-Id: <20201209235128.175473-10-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201209235128.175473-1-mathew.j.martineau@linux.intel.com>
References: <20201209235128.175473-1-mathew.j.martineau@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Geliang Tang <geliangtang@gmail.com>

This patch reused add_addr_signal for the RM_ADDR announcing signal, by
defining a new ADD_ADDR status named MPTCP_RM_ADDR_SIGNAL. Then the flag
rm_addr_signal in PM could be dropped.

Signed-off-by: Geliang Tang <geliangtang@gmail.com>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---
 net/mptcp/pm.c       | 18 +++++++++++++++---
 net/mptcp/protocol.h |  4 ++--
 2 files changed, 17 insertions(+), 5 deletions(-)

diff --git a/net/mptcp/pm.c b/net/mptcp/pm.c
index ac590274b048..b5a0b8d231c6 100644
--- a/net/mptcp/pm.c
+++ b/net/mptcp/pm.c
@@ -20,6 +20,11 @@ int mptcp_pm_announce_addr(struct mptcp_sock *msk,
 
 	pr_debug("msk=%p, local_id=%d", msk, addr->id);
 
+	if (add_addr) {
+		pr_warn("addr_signal error, add_addr=%d", add_addr);
+		return -EINVAL;
+	}
+
 	msk->pm.local = *addr;
 	add_addr |= BIT(MPTCP_ADD_ADDR_SIGNAL);
 	if (echo)
@@ -34,10 +39,18 @@ int mptcp_pm_announce_addr(struct mptcp_sock *msk,
 
 int mptcp_pm_remove_addr(struct mptcp_sock *msk, u8 local_id)
 {
+	u8 rm_addr = READ_ONCE(msk->pm.add_addr_signal);
+
 	pr_debug("msk=%p, local_id=%d", msk, local_id);
 
+	if (rm_addr) {
+		pr_warn("addr_signal error, rm_addr=%d", rm_addr);
+		return -EINVAL;
+	}
+
 	msk->pm.rm_id = local_id;
-	WRITE_ONCE(msk->pm.rm_addr_signal, true);
+	rm_addr |= BIT(MPTCP_RM_ADDR_SIGNAL);
+	WRITE_ONCE(msk->pm.add_addr_signal, rm_addr);
 	return 0;
 }
 
@@ -237,7 +250,7 @@ bool mptcp_pm_rm_addr_signal(struct mptcp_sock *msk, unsigned int remaining,
 		goto out_unlock;
 
 	*rm_id = msk->pm.rm_id;
-	WRITE_ONCE(msk->pm.rm_addr_signal, false);
+	WRITE_ONCE(msk->pm.add_addr_signal, 0);
 	ret = true;
 
 out_unlock:
@@ -259,7 +272,6 @@ void mptcp_pm_data_init(struct mptcp_sock *msk)
 	msk->pm.rm_id = 0;
 	WRITE_ONCE(msk->pm.work_pending, false);
 	WRITE_ONCE(msk->pm.add_addr_signal, 0);
-	WRITE_ONCE(msk->pm.rm_addr_signal, false);
 	WRITE_ONCE(msk->pm.accept_addr, false);
 	WRITE_ONCE(msk->pm.accept_subflow, false);
 	msk->pm.status = 0;
diff --git a/net/mptcp/protocol.h b/net/mptcp/protocol.h
index cda84b892182..4dbb75b8ee33 100644
--- a/net/mptcp/protocol.h
+++ b/net/mptcp/protocol.h
@@ -174,6 +174,7 @@ enum mptcp_add_addr_status {
 	MPTCP_ADD_ADDR_ECHO,
 	MPTCP_ADD_ADDR_IPV6,
 	MPTCP_ADD_ADDR_PORT,
+	MPTCP_RM_ADDR_SIGNAL,
 };
 
 struct mptcp_pm_data {
@@ -184,7 +185,6 @@ struct mptcp_pm_data {
 	spinlock_t	lock;		/*protects the whole PM data */
 
 	u8		add_addr_signal;
-	bool		rm_addr_signal;
 	bool		server_side;
 	bool		work_pending;
 	bool		accept_addr;
@@ -579,7 +579,7 @@ static inline bool mptcp_pm_should_add_signal_port(struct mptcp_sock *msk)
 
 static inline bool mptcp_pm_should_rm_signal(struct mptcp_sock *msk)
 {
-	return READ_ONCE(msk->pm.rm_addr_signal);
+	return READ_ONCE(msk->pm.add_addr_signal) & BIT(MPTCP_RM_ADDR_SIGNAL);
 }
 
 static inline unsigned int mptcp_add_addr_len(int family, bool echo, bool port)
-- 
2.29.2

