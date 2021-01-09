Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 857DE2EFC71
	for <lists+netdev@lfdr.de>; Sat,  9 Jan 2021 01:52:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727037AbhAIAt4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Jan 2021 19:49:56 -0500
Received: from mga03.intel.com ([134.134.136.65]:32283 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726300AbhAIAtz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 8 Jan 2021 19:49:55 -0500
IronPort-SDR: 8TuaE/zEZhZP+KkBCtln8zv7vRaNwnxxNr9Mm+XTf1QXO4QJbJLz1EGmCkmbm5C6cwUonpqlD3
 60uRZNS+b0lQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9858"; a="177771958"
X-IronPort-AV: E=Sophos;i="5.79,333,1602572400"; 
   d="scan'208";a="177771958"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jan 2021 16:48:09 -0800
IronPort-SDR: fHga6fIB3bhxhNfBD487jkjyGWP5YbdiCVqMJZG04osnEBwnJkEFR19SSD6jV75dygvCTDo2yP
 wdwj1/dleKJw==
X-IronPort-AV: E=Sophos;i="5.79,333,1602572400"; 
   d="scan'208";a="423124504"
Received: from mjmartin-nuc02.amr.corp.intel.com ([10.251.4.171])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jan 2021 16:48:09 -0800
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Geliang Tang <geliangtang@gmail.com>, davem@davemloft.net,
        kuba@kernel.org, mptcp@lists.01.org,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: [PATCH net-next 7/8] mptcp: add the mibs for MP_PRIO
Date:   Fri,  8 Jan 2021 16:48:01 -0800
Message-Id: <20210109004802.341602-8-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210109004802.341602-1-mathew.j.martineau@linux.intel.com>
References: <20210109004802.341602-1-mathew.j.martineau@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Geliang Tang <geliangtang@gmail.com>

This patch added the mibs for MP_PRIO, MPTCP_MIB_MPPRIOTX for transmitting
of the MP_PRIO suboption, and MPTCP_MIB_MPPRIORX for receiving of it.

Signed-off-by: Geliang Tang <geliangtang@gmail.com>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---
 net/mptcp/mib.c        | 2 ++
 net/mptcp/mib.h        | 2 ++
 net/mptcp/options.c    | 1 +
 net/mptcp/pm_netlink.c | 2 ++
 4 files changed, 7 insertions(+)

diff --git a/net/mptcp/mib.c b/net/mptcp/mib.c
index b921cbdd9aaa..8ca196489893 100644
--- a/net/mptcp/mib.c
+++ b/net/mptcp/mib.c
@@ -31,6 +31,8 @@ static const struct snmp_mib mptcp_snmp_list[] = {
 	SNMP_MIB_ITEM("EchoAdd", MPTCP_MIB_ECHOADD),
 	SNMP_MIB_ITEM("RmAddr", MPTCP_MIB_RMADDR),
 	SNMP_MIB_ITEM("RmSubflow", MPTCP_MIB_RMSUBFLOW),
+	SNMP_MIB_ITEM("MPPrioTx", MPTCP_MIB_MPPRIOTX),
+	SNMP_MIB_ITEM("MPPrioRx", MPTCP_MIB_MPPRIORX),
 	SNMP_MIB_SENTINEL
 };
 
diff --git a/net/mptcp/mib.h b/net/mptcp/mib.h
index 47bcecce1106..63914a5ef6a5 100644
--- a/net/mptcp/mib.h
+++ b/net/mptcp/mib.h
@@ -24,6 +24,8 @@ enum linux_mptcp_mib_field {
 	MPTCP_MIB_ECHOADD,		/* Received ADD_ADDR with echo-flag=1 */
 	MPTCP_MIB_RMADDR,		/* Received RM_ADDR */
 	MPTCP_MIB_RMSUBFLOW,		/* Remove a subflow */
+	MPTCP_MIB_MPPRIOTX,		/* Transmit a MP_PRIO */
+	MPTCP_MIB_MPPRIORX,		/* Received a MP_PRIO */
 	__MPTCP_MIB_MAX
 };
 
diff --git a/net/mptcp/options.c b/net/mptcp/options.c
index adfa96dd991c..c9643344a8d7 100644
--- a/net/mptcp/options.c
+++ b/net/mptcp/options.c
@@ -1034,6 +1034,7 @@ void mptcp_incoming_options(struct sock *sk, struct sk_buff *skb)
 
 	if (mp_opt.mp_prio) {
 		mptcp_pm_mp_prio_received(sk, mp_opt.backup);
+		MPTCP_INC_STATS(sock_net(sk), MPTCP_MIB_MPPRIORX);
 		mp_opt.mp_prio = 0;
 	}
 
diff --git a/net/mptcp/pm_netlink.c b/net/mptcp/pm_netlink.c
index 8f80099f1657..9b1f6298bbdb 100644
--- a/net/mptcp/pm_netlink.c
+++ b/net/mptcp/pm_netlink.c
@@ -452,6 +452,7 @@ int mptcp_pm_nl_mp_prio_send_ack(struct mptcp_sock *msk,
 
 	mptcp_for_each_subflow(msk, subflow) {
 		struct sock *ssk = mptcp_subflow_tcp_sock(subflow);
+		struct sock *sk = (struct sock *)msk;
 		struct mptcp_addr_info local;
 
 		local_address((struct sock_common *)ssk, &local);
@@ -461,6 +462,7 @@ int mptcp_pm_nl_mp_prio_send_ack(struct mptcp_sock *msk,
 		subflow->backup = bkup;
 		subflow->send_mp_prio = 1;
 		subflow->request_bkup = bkup;
+		__MPTCP_INC_STATS(sock_net(sk), MPTCP_MIB_MPPRIOTX);
 
 		spin_unlock_bh(&msk->pm.lock);
 		pr_debug("send ack for mp_prio");
-- 
2.30.0

