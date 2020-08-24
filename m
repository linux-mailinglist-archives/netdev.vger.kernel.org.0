Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6204724FCC2
	for <lists+netdev@lfdr.de>; Mon, 24 Aug 2020 13:40:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727869AbgHXLkJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Aug 2020 07:40:09 -0400
Received: from correo.us.es ([193.147.175.20]:41830 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727878AbgHXLj4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 24 Aug 2020 07:39:56 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id AE3E381A31
        for <netdev@vger.kernel.org>; Mon, 24 Aug 2020 13:39:50 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id E2B2CFC5E4
        for <netdev@vger.kernel.org>; Mon, 24 Aug 2020 13:39:49 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id AC6B8E150E; Mon, 24 Aug 2020 13:39:48 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WELCOMELIST,USER_IN_WHITELIST autolearn=disabled
        version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id D9EF7DA78D;
        Mon, 24 Aug 2020 13:39:45 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Mon, 24 Aug 2020 13:39:45 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from localhost.localdomain (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPSA id 3163742EE38E;
        Mon, 24 Aug 2020 13:39:46 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH 1/6] netfilter: conntrack: allow sctp hearbeat after connection re-use
Date:   Mon, 24 Aug 2020 13:39:36 +0200
Message-Id: <20200824113941.25423-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200824113941.25423-1-pablo@netfilter.org>
References: <20200824113941.25423-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

If an sctp connection gets re-used, heartbeats are flagged as invalid
because their vtag doesn't match.

Handle this in a similar way as TCP conntrack when it suspects that the
endpoints and conntrack are out-of-sync.

When a HEARTBEAT request fails its vtag validation, flag this in the
conntrack state and accept the packet.

When a HEARTBEAT_ACK is received with an invalid vtag in the reverse
direction after we allowed such a HEARTBEAT through, assume we are
out-of-sync and re-set the vtag info.

v2: remove left-over snippet from an older incarnation that moved
    new_state/old_state assignments, thats not needed so keep that
    as-is.

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/linux/netfilter/nf_conntrack_sctp.h |  2 ++
 net/netfilter/nf_conntrack_proto_sctp.c     | 39 ++++++++++++++++++---
 2 files changed, 37 insertions(+), 4 deletions(-)

diff --git a/include/linux/netfilter/nf_conntrack_sctp.h b/include/linux/netfilter/nf_conntrack_sctp.h
index 9a33f171aa82..625f491b95de 100644
--- a/include/linux/netfilter/nf_conntrack_sctp.h
+++ b/include/linux/netfilter/nf_conntrack_sctp.h
@@ -9,6 +9,8 @@ struct ip_ct_sctp {
 	enum sctp_conntrack state;
 
 	__be32 vtag[IP_CT_DIR_MAX];
+	u8 last_dir;
+	u8 flags;
 };
 
 #endif /* _NF_CONNTRACK_SCTP_H */
diff --git a/net/netfilter/nf_conntrack_proto_sctp.c b/net/netfilter/nf_conntrack_proto_sctp.c
index 4f897b14b606..810cca24b399 100644
--- a/net/netfilter/nf_conntrack_proto_sctp.c
+++ b/net/netfilter/nf_conntrack_proto_sctp.c
@@ -62,6 +62,8 @@ static const unsigned int sctp_timeouts[SCTP_CONNTRACK_MAX] = {
 	[SCTP_CONNTRACK_HEARTBEAT_ACKED]	= 210 SECS,
 };
 
+#define	SCTP_FLAG_HEARTBEAT_VTAG_FAILED	1
+
 #define sNO SCTP_CONNTRACK_NONE
 #define	sCL SCTP_CONNTRACK_CLOSED
 #define	sCW SCTP_CONNTRACK_COOKIE_WAIT
@@ -369,6 +371,7 @@ int nf_conntrack_sctp_packet(struct nf_conn *ct,
 	u_int32_t offset, count;
 	unsigned int *timeouts;
 	unsigned long map[256 / sizeof(unsigned long)] = { 0 };
+	bool ignore = false;
 
 	if (sctp_error(skb, dataoff, state))
 		return -NF_ACCEPT;
@@ -427,15 +430,39 @@ int nf_conntrack_sctp_packet(struct nf_conn *ct,
 			/* Sec 8.5.1 (D) */
 			if (sh->vtag != ct->proto.sctp.vtag[dir])
 				goto out_unlock;
-		} else if (sch->type == SCTP_CID_HEARTBEAT ||
-			   sch->type == SCTP_CID_HEARTBEAT_ACK) {
+		} else if (sch->type == SCTP_CID_HEARTBEAT) {
+			if (ct->proto.sctp.vtag[dir] == 0) {
+				pr_debug("Setting %d vtag %x for dir %d\n", sch->type, sh->vtag, dir);
+				ct->proto.sctp.vtag[dir] = sh->vtag;
+			} else if (sh->vtag != ct->proto.sctp.vtag[dir]) {
+				if (test_bit(SCTP_CID_DATA, map) || ignore)
+					goto out_unlock;
+
+				ct->proto.sctp.flags |= SCTP_FLAG_HEARTBEAT_VTAG_FAILED;
+				ct->proto.sctp.last_dir = dir;
+				ignore = true;
+				continue;
+			} else if (ct->proto.sctp.flags & SCTP_FLAG_HEARTBEAT_VTAG_FAILED) {
+				ct->proto.sctp.flags &= ~SCTP_FLAG_HEARTBEAT_VTAG_FAILED;
+			}
+		} else if (sch->type == SCTP_CID_HEARTBEAT_ACK) {
 			if (ct->proto.sctp.vtag[dir] == 0) {
 				pr_debug("Setting vtag %x for dir %d\n",
 					 sh->vtag, dir);
 				ct->proto.sctp.vtag[dir] = sh->vtag;
 			} else if (sh->vtag != ct->proto.sctp.vtag[dir]) {
-				pr_debug("Verification tag check failed\n");
-				goto out_unlock;
+				if (test_bit(SCTP_CID_DATA, map) || ignore)
+					goto out_unlock;
+
+				if ((ct->proto.sctp.flags & SCTP_FLAG_HEARTBEAT_VTAG_FAILED) == 0 ||
+				    ct->proto.sctp.last_dir == dir)
+					goto out_unlock;
+
+				ct->proto.sctp.flags &= ~SCTP_FLAG_HEARTBEAT_VTAG_FAILED;
+				ct->proto.sctp.vtag[dir] = sh->vtag;
+				ct->proto.sctp.vtag[!dir] = 0;
+			} else if (ct->proto.sctp.flags & SCTP_FLAG_HEARTBEAT_VTAG_FAILED) {
+				ct->proto.sctp.flags &= ~SCTP_FLAG_HEARTBEAT_VTAG_FAILED;
 			}
 		}
 
@@ -470,6 +497,10 @@ int nf_conntrack_sctp_packet(struct nf_conn *ct,
 	}
 	spin_unlock_bh(&ct->lock);
 
+	/* allow but do not refresh timeout */
+	if (ignore)
+		return NF_ACCEPT;
+
 	timeouts = nf_ct_timeout_lookup(ct);
 	if (!timeouts)
 		timeouts = nf_sctp_pernet(nf_ct_net(ct))->timeouts;
-- 
2.20.1

