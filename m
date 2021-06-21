Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE9FA3AF8D8
	for <lists+netdev@lfdr.de>; Tue, 22 Jun 2021 00:54:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232376AbhFUW5F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Jun 2021 18:57:05 -0400
Received: from mga14.intel.com ([192.55.52.115]:11261 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232347AbhFUW5C (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 21 Jun 2021 18:57:02 -0400
IronPort-SDR: +WMeFMPgresW7REpd1C1rY7czscRzjlNZYKu0Fhfw94ONpy3t5N3AEmDBT/0g7htfVBs+ZKkK3
 II39aYve5Qaw==
X-IronPort-AV: E=McAfee;i="6200,9189,10022"; a="206768521"
X-IronPort-AV: E=Sophos;i="5.83,290,1616482800"; 
   d="scan'208";a="206768521"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Jun 2021 15:54:43 -0700
IronPort-SDR: uO2i8dVA8WaId42SIM1vgXuswMq/tkTfwCRuyhTRge140t9kkeBDRS1EI7Ltzrh2g4eBl9aR+4
 jWWwr90jzaBg==
X-IronPort-AV: E=Sophos;i="5.83,290,1616482800"; 
   d="scan'208";a="486673973"
Received: from mjmartin-desk2.amr.corp.intel.com (HELO mjmartin-desk2.intel.com) ([10.209.74.136])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Jun 2021 15:54:42 -0700
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Paolo Abeni <pabeni@redhat.com>, davem@davemloft.net,
        kuba@kernel.org, matthieu.baerts@tessares.net,
        mptcp@lists.linux.dev,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: [PATCH net-next 5/6] mptcp: add MIB counter for invalid mapping
Date:   Mon, 21 Jun 2021 15:54:37 -0700
Message-Id: <20210621225438.10777-6-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210621225438.10777-1-mathew.j.martineau@linux.intel.com>
References: <20210621225438.10777-1-mathew.j.martineau@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Paolo Abeni <pabeni@redhat.com>

Account this exceptional events for better introspection.

Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---
 net/mptcp/mib.c     | 1 +
 net/mptcp/mib.h     | 1 +
 net/mptcp/subflow.c | 4 +++-
 3 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/net/mptcp/mib.c b/net/mptcp/mib.c
index e7e60bc1fb96..52ea2517e856 100644
--- a/net/mptcp/mib.c
+++ b/net/mptcp/mib.c
@@ -25,6 +25,7 @@ static const struct snmp_mib mptcp_snmp_list[] = {
 	SNMP_MIB_ITEM("MPJoinAckHMacFailure", MPTCP_MIB_JOINACKMAC),
 	SNMP_MIB_ITEM("DSSNotMatching", MPTCP_MIB_DSSNOMATCH),
 	SNMP_MIB_ITEM("InfiniteMapRx", MPTCP_MIB_INFINITEMAPRX),
+	SNMP_MIB_ITEM("DSSNoMatchTCP", MPTCP_MIB_DSSTCPMISMATCH),
 	SNMP_MIB_ITEM("DataCsumErr", MPTCP_MIB_DATACSUMERR),
 	SNMP_MIB_ITEM("OFOQueueTail", MPTCP_MIB_OFOQUEUETAIL),
 	SNMP_MIB_ITEM("OFOQueue", MPTCP_MIB_OFOQUEUE),
diff --git a/net/mptcp/mib.h b/net/mptcp/mib.h
index 92e56c0cfbdd..193466c9b549 100644
--- a/net/mptcp/mib.h
+++ b/net/mptcp/mib.h
@@ -18,6 +18,7 @@ enum linux_mptcp_mib_field {
 	MPTCP_MIB_JOINACKMAC,		/* HMAC was wrong on ACK + MP_JOIN */
 	MPTCP_MIB_DSSNOMATCH,		/* Received a new mapping that did not match the previous one */
 	MPTCP_MIB_INFINITEMAPRX,	/* Received an infinite mapping */
+	MPTCP_MIB_DSSTCPMISMATCH,	/* DSS-mapping did not map with TCP's sequence numbers */
 	MPTCP_MIB_DATACSUMERR,		/* The data checksum fail */
 	MPTCP_MIB_OFOQUEUETAIL,	/* Segments inserted into OoO queue tail */
 	MPTCP_MIB_OFOQUEUE,		/* Segments inserted into OoO queue */
diff --git a/net/mptcp/subflow.c b/net/mptcp/subflow.c
index 8976ff586b87..585951e7e52f 100644
--- a/net/mptcp/subflow.c
+++ b/net/mptcp/subflow.c
@@ -1046,8 +1046,10 @@ static enum mapping_status get_mapping_status(struct sock *ssk,
 	/* we revalidate valid mapping on new skb, because we must ensure
 	 * the current skb is completely covered by the available mapping
 	 */
-	if (!validate_mapping(ssk, skb))
+	if (!validate_mapping(ssk, skb)) {
+		MPTCP_INC_STATS(sock_net(ssk), MPTCP_MIB_DSSTCPMISMATCH);
 		return MAPPING_INVALID;
+	}
 
 	skb_ext_del(skb, SKB_EXT_MPTCP);
 
-- 
2.32.0

