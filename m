Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA155262C51
	for <lists+netdev@lfdr.de>; Wed,  9 Sep 2020 11:45:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729251AbgIIJo6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Sep 2020 05:44:58 -0400
Received: from correo.us.es ([193.147.175.20]:34970 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729048AbgIIJme (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 9 Sep 2020 05:42:34 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id A9D0F2EFEAA
        for <netdev@vger.kernel.org>; Wed,  9 Sep 2020 11:42:29 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 9924EDA90C
        for <netdev@vger.kernel.org>; Wed,  9 Sep 2020 11:42:29 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 8B588DA8FF; Wed,  9 Sep 2020 11:42:29 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,URIBL_BLOCKED,USER_IN_WELCOMELIST,USER_IN_WHITELIST
        autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 4CC79DA7E1;
        Wed,  9 Sep 2020 11:42:27 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Wed, 09 Sep 2020 11:42:27 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from localhost.localdomain (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPSA id 217414301DE4;
        Wed,  9 Sep 2020 11:42:27 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 05/13] netfilter: conntrack: remove ignore stats
Date:   Wed,  9 Sep 2020 11:42:11 +0200
Message-Id: <20200909094219.17732-6-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200909094219.17732-1-pablo@netfilter.org>
References: <20200909094219.17732-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

This counter increments when nf_conntrack_in sees a packet that already
has a conntrack attached or when the packet is marked as UNTRACKED.
Neither is an error.

The former is normal for loopback traffic.  The second happens for
certain ICMPv6 packets or when nftables/ip(6)tables rules are in place.

In case someone needs to count UNTRACKED packets, or packets
that are marked as untracked before conntrack_in this can be done with
both nftables and ip(6)tables rules.

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/linux/netfilter/nf_conntrack_common.h      | 1 -
 include/uapi/linux/netfilter/nfnetlink_conntrack.h | 2 +-
 net/netfilter/nf_conntrack_core.c                  | 4 +---
 net/netfilter/nf_conntrack_netlink.c               | 1 -
 net/netfilter/nf_conntrack_standalone.c            | 2 +-
 5 files changed, 3 insertions(+), 7 deletions(-)

diff --git a/include/linux/netfilter/nf_conntrack_common.h b/include/linux/netfilter/nf_conntrack_common.h
index 1db83c931d9c..96b90d7e361f 100644
--- a/include/linux/netfilter/nf_conntrack_common.h
+++ b/include/linux/netfilter/nf_conntrack_common.h
@@ -8,7 +8,6 @@
 struct ip_conntrack_stat {
 	unsigned int found;
 	unsigned int invalid;
-	unsigned int ignore;
 	unsigned int insert;
 	unsigned int insert_failed;
 	unsigned int drop;
diff --git a/include/uapi/linux/netfilter/nfnetlink_conntrack.h b/include/uapi/linux/netfilter/nfnetlink_conntrack.h
index 262881792671..3e471558da82 100644
--- a/include/uapi/linux/netfilter/nfnetlink_conntrack.h
+++ b/include/uapi/linux/netfilter/nfnetlink_conntrack.h
@@ -247,7 +247,7 @@ enum ctattr_stats_cpu {
 	CTA_STATS_FOUND,
 	CTA_STATS_NEW,		/* no longer used */
 	CTA_STATS_INVALID,
-	CTA_STATS_IGNORE,
+	CTA_STATS_IGNORE,	/* no longer used */
 	CTA_STATS_DELETE,	/* no longer used */
 	CTA_STATS_DELETE_LIST,	/* no longer used */
 	CTA_STATS_INSERT,
diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index 3cfbafdff941..a111bcf1b93c 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -1800,10 +1800,8 @@ nf_conntrack_in(struct sk_buff *skb, const struct nf_hook_state *state)
 	if (tmpl || ctinfo == IP_CT_UNTRACKED) {
 		/* Previously seen (loopback or untracked)?  Ignore. */
 		if ((tmpl && !nf_ct_is_template(tmpl)) ||
-		     ctinfo == IP_CT_UNTRACKED) {
-			NF_CT_STAT_INC_ATOMIC(state->net, ignore);
+		     ctinfo == IP_CT_UNTRACKED)
 			return NF_ACCEPT;
-		}
 		skb->_nfct = 0;
 	}
 
diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index 832eabecfbdd..c64f23a8f373 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -2509,7 +2509,6 @@ ctnetlink_ct_stat_cpu_fill_info(struct sk_buff *skb, u32 portid, u32 seq,
 
 	if (nla_put_be32(skb, CTA_STATS_FOUND, htonl(st->found)) ||
 	    nla_put_be32(skb, CTA_STATS_INVALID, htonl(st->invalid)) ||
-	    nla_put_be32(skb, CTA_STATS_IGNORE, htonl(st->ignore)) ||
 	    nla_put_be32(skb, CTA_STATS_INSERT, htonl(st->insert)) ||
 	    nla_put_be32(skb, CTA_STATS_INSERT_FAILED,
 				htonl(st->insert_failed)) ||
diff --git a/net/netfilter/nf_conntrack_standalone.c b/net/netfilter/nf_conntrack_standalone.c
index a604f43e3e6b..b673a03624d2 100644
--- a/net/netfilter/nf_conntrack_standalone.c
+++ b/net/netfilter/nf_conntrack_standalone.c
@@ -439,7 +439,7 @@ static int ct_cpu_seq_show(struct seq_file *seq, void *v)
 		   st->found,
 		   0,
 		   st->invalid,
-		   st->ignore,
+		   0,
 		   0,
 		   0,
 		   st->insert,
-- 
2.20.1

