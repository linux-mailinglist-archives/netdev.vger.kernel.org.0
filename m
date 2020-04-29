Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7CD041BE7AB
	for <lists+netdev@lfdr.de>; Wed, 29 Apr 2020 21:49:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727846AbgD2TsJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Apr 2020 15:48:09 -0400
Received: from correo.us.es ([193.147.175.20]:50004 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726456AbgD2TsI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 29 Apr 2020 15:48:08 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id E5396E170A
        for <netdev@vger.kernel.org>; Wed, 29 Apr 2020 21:42:49 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id D5477BAAB4
        for <netdev@vger.kernel.org>; Wed, 29 Apr 2020 21:42:49 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id CAC79BAAB1; Wed, 29 Apr 2020 21:42:49 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,URIBL_BLOCKED,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id CDFF6DA7B2;
        Wed, 29 Apr 2020 21:42:47 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Wed, 29 Apr 2020 21:42:47 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from localhost.localdomain (unknown [90.77.255.23])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id A990942EF9E1;
        Wed, 29 Apr 2020 21:42:47 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 1/6] netfilter: nf_conntrack: add IPS_HW_OFFLOAD status bit
Date:   Wed, 29 Apr 2020 21:42:38 +0200
Message-Id: <20200429194243.22228-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200429194243.22228-1-pablo@netfilter.org>
References: <20200429194243.22228-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Bodong Wang <bodong@mellanox.com>

This bit indicates that the conntrack entry is offloaded to hardware
flow table. nf_conntrack entry will be tagged with [HW_OFFLOAD] if
it's offload to hardware.

cat /proc/net/nf_conntrack
	ipv4 2 tcp 6 \
	src=1.1.1.17 dst=1.1.1.16 sport=56394 dport=5001 \
	src=1.1.1.16 dst=1.1.1.17 sport=5001 dport=56394 [HW_OFFLOAD] \
	mark=0 zone=0 use=3

Note that HW_OFFLOAD/OFFLOAD/ASSURED are mutually exclusive.

Changelog:

* V1->V2:
- Remove check of lastused from stats. It was meant for cases such
  as removing driver module while traffic still running. Better to
  handle such cases from garbage collector.

Signed-off-by: Bodong Wang <bodong@mellanox.com>
Reviewed-by: Oz Shlomo <ozsh@mellanox.com>
Reviewed-by: Paul Blakey <paulb@mellanox.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/uapi/linux/netfilter/nf_conntrack_common.h | 8 ++++++--
 net/netfilter/nf_conntrack_standalone.c            | 4 +++-
 net/netfilter/nf_flow_table_offload.c              | 3 +++
 3 files changed, 12 insertions(+), 3 deletions(-)

diff --git a/include/uapi/linux/netfilter/nf_conntrack_common.h b/include/uapi/linux/netfilter/nf_conntrack_common.h
index b6f0bb1dc799..4b3395082d15 100644
--- a/include/uapi/linux/netfilter/nf_conntrack_common.h
+++ b/include/uapi/linux/netfilter/nf_conntrack_common.h
@@ -114,15 +114,19 @@ enum ip_conntrack_status {
 	IPS_OFFLOAD_BIT = 14,
 	IPS_OFFLOAD = (1 << IPS_OFFLOAD_BIT),
 
+	/* Conntrack has been offloaded to hardware. */
+	IPS_HW_OFFLOAD_BIT = 15,
+	IPS_HW_OFFLOAD = (1 << IPS_HW_OFFLOAD_BIT),
+
 	/* Be careful here, modifying these bits can make things messy,
 	 * so don't let users modify them directly.
 	 */
 	IPS_UNCHANGEABLE_MASK = (IPS_NAT_DONE_MASK | IPS_NAT_MASK |
 				 IPS_EXPECTED | IPS_CONFIRMED | IPS_DYING |
 				 IPS_SEQ_ADJUST | IPS_TEMPLATE | IPS_UNTRACKED |
-				 IPS_OFFLOAD),
+				 IPS_OFFLOAD | IPS_HW_OFFLOAD),
 
-	__IPS_MAX_BIT = 15,
+	__IPS_MAX_BIT = 16,
 };
 
 /* Connection tracking event types */
diff --git a/net/netfilter/nf_conntrack_standalone.c b/net/netfilter/nf_conntrack_standalone.c
index 9b57330c81f8..5a3e6c43ee68 100644
--- a/net/netfilter/nf_conntrack_standalone.c
+++ b/net/netfilter/nf_conntrack_standalone.c
@@ -348,7 +348,9 @@ static int ct_seq_show(struct seq_file *s, void *v)
 	if (seq_print_acct(s, ct, IP_CT_DIR_REPLY))
 		goto release;
 
-	if (test_bit(IPS_OFFLOAD_BIT, &ct->status))
+	if (test_bit(IPS_HW_OFFLOAD_BIT, &ct->status))
+		seq_puts(s, "[HW_OFFLOAD] ");
+	else if (test_bit(IPS_OFFLOAD_BIT, &ct->status))
 		seq_puts(s, "[OFFLOAD] ");
 	else if (test_bit(IPS_ASSURED_BIT, &ct->status))
 		seq_puts(s, "[ASSURED] ");
diff --git a/net/netfilter/nf_flow_table_offload.c b/net/netfilter/nf_flow_table_offload.c
index e3b099c14eff..a2abb0feab7f 100644
--- a/net/netfilter/nf_flow_table_offload.c
+++ b/net/netfilter/nf_flow_table_offload.c
@@ -754,12 +754,15 @@ static void flow_offload_work_add(struct flow_offload_work *offload)
 	err = flow_offload_rule_add(offload, flow_rule);
 	if (err < 0)
 		set_bit(NF_FLOW_HW_REFRESH, &offload->flow->flags);
+	else
+		set_bit(IPS_HW_OFFLOAD_BIT, &offload->flow->ct->status);
 
 	nf_flow_offload_destroy(flow_rule);
 }
 
 static void flow_offload_work_del(struct flow_offload_work *offload)
 {
+	clear_bit(IPS_HW_OFFLOAD_BIT, &offload->flow->ct->status);
 	flow_offload_tuple_del(offload, FLOW_OFFLOAD_DIR_ORIGINAL);
 	flow_offload_tuple_del(offload, FLOW_OFFLOAD_DIR_REPLY);
 	set_bit(NF_FLOW_HW_DEAD, &offload->flow->flags);
-- 
2.20.1

