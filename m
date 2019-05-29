Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B4C5A2DBC6
	for <lists+netdev@lfdr.de>; Wed, 29 May 2019 13:26:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726963AbfE2LZ6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 May 2019 07:25:58 -0400
Received: from mail.us.es ([193.147.175.20]:53018 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726916AbfE2LZ4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 29 May 2019 07:25:56 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 05ACDC1B69
        for <netdev@vger.kernel.org>; Wed, 29 May 2019 13:25:55 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id E8F63DA70E
        for <netdev@vger.kernel.org>; Wed, 29 May 2019 13:25:54 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id DE9B8DA709; Wed, 29 May 2019 13:25:54 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id CCD55DA707;
        Wed, 29 May 2019 13:25:52 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Wed, 29 May 2019 13:25:52 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (sys.soleta.eu [212.170.55.40])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 33C874265A32;
        Wed, 29 May 2019 13:25:52 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        nikolay@cumulusnetworks.com, roopa@cumulusnetworks.com
Subject: [PATCH net-next,v3 9/9] netfilter: nf_conntrack_bridge: register inet conntrack for bridge
Date:   Wed, 29 May 2019 13:25:39 +0200
Message-Id: <20190529112539.2126-10-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190529112539.2126-1-pablo@netfilter.org>
References: <20190529112539.2126-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch enables IPv4 and IPv6 conntrack from the bridge to deal with
local traffic. Hence, packets that are passed up to the local input path
are confirmed later on from the {ipv4,ipv6}_confirm() hooks.

For packets leaving the IP stack (ie. output path), fragmentation occurs
after the inet postrouting hook. Therefore, the bridge local out and
postrouting bridge hooks see fragments with conntrack objects, which is
inconsistent. In this case, we could defragment again from the bridge
output hook, but this is expensive. The recommended filtering spot for
outgoing locally generated traffic leaving through the bridge interface
is to use the classic IPv4/IPv6 output hook, which comes earlier.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_conntrack_proto.c | 58 +++++++++++++++++++++++++++-----------
 1 file changed, 42 insertions(+), 16 deletions(-)

diff --git a/net/netfilter/nf_conntrack_proto.c b/net/netfilter/nf_conntrack_proto.c
index 7e2e8b8d6ebe..a0560d175a7f 100644
--- a/net/netfilter/nf_conntrack_proto.c
+++ b/net/netfilter/nf_conntrack_proto.c
@@ -560,38 +560,64 @@ static void nf_ct_netns_do_put(struct net *net, u8 nfproto)
 	mutex_unlock(&nf_ct_proto_mutex);
 }
 
-int nf_ct_netns_get(struct net *net, u8 nfproto)
+static int nf_ct_netns_inet_get(struct net *net)
 {
 	int err;
 
-	if (nfproto == NFPROTO_INET) {
-		err = nf_ct_netns_do_get(net, NFPROTO_IPV4);
-		if (err < 0)
-			goto err1;
-		err = nf_ct_netns_do_get(net, NFPROTO_IPV6);
-		if (err < 0)
-			goto err2;
-	} else {
-		err = nf_ct_netns_do_get(net, nfproto);
-		if (err < 0)
-			goto err1;
-	}
-	return 0;
+	err = nf_ct_netns_do_get(net, NFPROTO_IPV4);
+	if (err < 0)
+		goto err1;
+	err = nf_ct_netns_do_get(net, NFPROTO_IPV6);
+	if (err < 0)
+		goto err2;
 
+	return err;
 err2:
 	nf_ct_netns_put(net, NFPROTO_IPV4);
 err1:
 	return err;
 }
+
+int nf_ct_netns_get(struct net *net, u8 nfproto)
+{
+	int err;
+
+	switch (nfproto) {
+	case NFPROTO_INET:
+		err = nf_ct_netns_inet_get(net);
+		break;
+	case NFPROTO_BRIDGE:
+		err = nf_ct_netns_do_get(net, NFPROTO_BRIDGE);
+		if (err < 0)
+			return err;
+
+		err = nf_ct_netns_inet_get(net);
+		if (err < 0) {
+			nf_ct_netns_put(net, NFPROTO_BRIDGE);
+			return err;
+		}
+		break;
+	default:
+		err = nf_ct_netns_do_get(net, nfproto);
+		break;
+	}
+	return err;
+}
 EXPORT_SYMBOL_GPL(nf_ct_netns_get);
 
 void nf_ct_netns_put(struct net *net, uint8_t nfproto)
 {
-	if (nfproto == NFPROTO_INET) {
+	switch (nfproto) {
+	case NFPROTO_BRIDGE:
+		nf_ct_netns_do_put(net, NFPROTO_BRIDGE);
+		/* fall through */
+	case NFPROTO_INET:
 		nf_ct_netns_do_put(net, NFPROTO_IPV4);
 		nf_ct_netns_do_put(net, NFPROTO_IPV6);
-	} else {
+		break;
+	default:
 		nf_ct_netns_do_put(net, nfproto);
+		break;
 	}
 }
 EXPORT_SYMBOL_GPL(nf_ct_netns_put);
-- 
2.11.0

