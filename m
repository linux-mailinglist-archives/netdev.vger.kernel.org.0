Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E08024BC235
	for <lists+netdev@lfdr.de>; Fri, 18 Feb 2022 22:36:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239967AbiBRVgN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Feb 2022 16:36:13 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:40640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239945AbiBRVgK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Feb 2022 16:36:10 -0500
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD18A108565
        for <netdev@vger.kernel.org>; Fri, 18 Feb 2022 13:35:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1645220153; x=1676756153;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=XkVHPDIyBkaH3q1Z9MjQ0riJxIyyJNcm/+ZtjZLixX0=;
  b=NqkhwMFTDrMq96REIxOsztJxyAWeY9zQefer2wo6Wpq5NpmgC6fphp4P
   PfgrivMcWmvL9UeXUmy6S/zzsQH/0oykcYKHYuQIxchTB8Ivk3I6gSXH0
   TaZ2IwY/4bScQLak2HQMeGr/XNrLLffIcKR+Tkj2ZqO8T0i0LGuKMenGm
   ZaCAZePd/6wYOqlQCjj+Dg72OPDFy1K8ksLog0gdnfBp0LS8O+6tyUysn
   kLA9FeViQ1ujoDwlopHnWstpZK3uBgEwddLcX0WZbH7LUvRKPPFUuHUuD
   5EYBRk4PCnl51xxUoT4vs6tQY47o0LOORUVsJVHTKDotfz1Nkk0xCqhE6
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10262"; a="251176201"
X-IronPort-AV: E=Sophos;i="5.88,379,1635231600"; 
   d="scan'208";a="251176201"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Feb 2022 13:35:53 -0800
X-IronPort-AV: E=Sophos;i="5.88,379,1635231600"; 
   d="scan'208";a="605664080"
Received: from mjmartin-desk2.amr.corp.intel.com (HELO mjmartin-desk2.intel.com) ([10.209.65.242])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Feb 2022 13:35:52 -0800
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Paolo Abeni <pabeni@redhat.com>, davem@davemloft.net,
        kuba@kernel.org, matthieu.baerts@tessares.net,
        geliang.tang@suse.com, mptcp@lists.linux.dev,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: [PATCH net 5/7] mptcp: add mibs counter for ignored incoming options
Date:   Fri, 18 Feb 2022 13:35:42 -0800
Message-Id: <20220218213544.70285-6-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220218213544.70285-1-mathew.j.martineau@linux.intel.com>
References: <20220218213544.70285-1-mathew.j.martineau@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Paolo Abeni <pabeni@redhat.com>

The MPTCP in kernel path manager has some constraints on incoming
addresses announce processing, so that in edge scenarios it can
end-up dropping (ignoring) some of such announces.

The above is not very limiting in practice since such scenarios are
very uncommon and MPTCP will recover due to ADD_ADDR retransmissions.

This patch adds a few MIB counters to account for such drop events
to allow easier introspection of the critical scenarios.

Fixes: f7efc7771eac ("mptcp: drop argument port from mptcp_pm_announce_addr")
Reviewed-by: Matthieu Baerts <matthieu.baerts@tessares.net>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---
 net/mptcp/mib.c | 2 ++
 net/mptcp/mib.h | 2 ++
 net/mptcp/pm.c  | 8 ++++++--
 3 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/net/mptcp/mib.c b/net/mptcp/mib.c
index 3240b72271a7..7558802a1435 100644
--- a/net/mptcp/mib.c
+++ b/net/mptcp/mib.c
@@ -35,12 +35,14 @@ static const struct snmp_mib mptcp_snmp_list[] = {
 	SNMP_MIB_ITEM("AddAddr", MPTCP_MIB_ADDADDR),
 	SNMP_MIB_ITEM("EchoAdd", MPTCP_MIB_ECHOADD),
 	SNMP_MIB_ITEM("PortAdd", MPTCP_MIB_PORTADD),
+	SNMP_MIB_ITEM("AddAddrDrop", MPTCP_MIB_ADDADDRDROP),
 	SNMP_MIB_ITEM("MPJoinPortSynRx", MPTCP_MIB_JOINPORTSYNRX),
 	SNMP_MIB_ITEM("MPJoinPortSynAckRx", MPTCP_MIB_JOINPORTSYNACKRX),
 	SNMP_MIB_ITEM("MPJoinPortAckRx", MPTCP_MIB_JOINPORTACKRX),
 	SNMP_MIB_ITEM("MismatchPortSynRx", MPTCP_MIB_MISMATCHPORTSYNRX),
 	SNMP_MIB_ITEM("MismatchPortAckRx", MPTCP_MIB_MISMATCHPORTACKRX),
 	SNMP_MIB_ITEM("RmAddr", MPTCP_MIB_RMADDR),
+	SNMP_MIB_ITEM("RmAddrDrop", MPTCP_MIB_RMADDRDROP),
 	SNMP_MIB_ITEM("RmSubflow", MPTCP_MIB_RMSUBFLOW),
 	SNMP_MIB_ITEM("MPPrioTx", MPTCP_MIB_MPPRIOTX),
 	SNMP_MIB_ITEM("MPPrioRx", MPTCP_MIB_MPPRIORX),
diff --git a/net/mptcp/mib.h b/net/mptcp/mib.h
index ecd3d8b117e0..2966fcb6548b 100644
--- a/net/mptcp/mib.h
+++ b/net/mptcp/mib.h
@@ -28,12 +28,14 @@ enum linux_mptcp_mib_field {
 	MPTCP_MIB_ADDADDR,		/* Received ADD_ADDR with echo-flag=0 */
 	MPTCP_MIB_ECHOADD,		/* Received ADD_ADDR with echo-flag=1 */
 	MPTCP_MIB_PORTADD,		/* Received ADD_ADDR with a port-number */
+	MPTCP_MIB_ADDADDRDROP,		/* Dropped incoming ADD_ADDR */
 	MPTCP_MIB_JOINPORTSYNRX,	/* Received a SYN MP_JOIN with a different port-number */
 	MPTCP_MIB_JOINPORTSYNACKRX,	/* Received a SYNACK MP_JOIN with a different port-number */
 	MPTCP_MIB_JOINPORTACKRX,	/* Received an ACK MP_JOIN with a different port-number */
 	MPTCP_MIB_MISMATCHPORTSYNRX,	/* Received a SYN MP_JOIN with a mismatched port-number */
 	MPTCP_MIB_MISMATCHPORTACKRX,	/* Received an ACK MP_JOIN with a mismatched port-number */
 	MPTCP_MIB_RMADDR,		/* Received RM_ADDR */
+	MPTCP_MIB_RMADDRDROP,		/* Dropped incoming RM_ADDR */
 	MPTCP_MIB_RMSUBFLOW,		/* Remove a subflow */
 	MPTCP_MIB_MPPRIOTX,		/* Transmit a MP_PRIO */
 	MPTCP_MIB_MPPRIORX,		/* Received a MP_PRIO */
diff --git a/net/mptcp/pm.c b/net/mptcp/pm.c
index 696b2c4613a7..7bea318ac5f2 100644
--- a/net/mptcp/pm.c
+++ b/net/mptcp/pm.c
@@ -213,6 +213,8 @@ void mptcp_pm_add_addr_received(struct mptcp_sock *msk,
 		mptcp_pm_add_addr_send_ack(msk);
 	} else if (mptcp_pm_schedule_work(msk, MPTCP_PM_ADD_ADDR_RECEIVED)) {
 		pm->remote = *addr;
+	} else {
+		__MPTCP_INC_STATS(sock_net((struct sock *)msk), MPTCP_MIB_ADDADDRDROP);
 	}
 
 	spin_unlock_bh(&pm->lock);
@@ -253,8 +255,10 @@ void mptcp_pm_rm_addr_received(struct mptcp_sock *msk,
 		mptcp_event_addr_removed(msk, rm_list->ids[i]);
 
 	spin_lock_bh(&pm->lock);
-	mptcp_pm_schedule_work(msk, MPTCP_PM_RM_ADDR_RECEIVED);
-	pm->rm_list_rx = *rm_list;
+	if (mptcp_pm_schedule_work(msk, MPTCP_PM_RM_ADDR_RECEIVED))
+		pm->rm_list_rx = *rm_list;
+	else
+		__MPTCP_INC_STATS(sock_net((struct sock *)msk), MPTCP_MIB_RMADDRDROP);
 	spin_unlock_bh(&pm->lock);
 }
 
-- 
2.35.1

