Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA32F262081
	for <lists+netdev@lfdr.de>; Tue,  8 Sep 2020 22:12:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730115AbgIHUMS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Sep 2020 16:12:18 -0400
Received: from correo.us.es ([193.147.175.20]:33090 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730131AbgIHPLS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 8 Sep 2020 11:11:18 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 2DDD01F0D04
        for <netdev@vger.kernel.org>; Tue,  8 Sep 2020 17:09:56 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 21260DA791
        for <netdev@vger.kernel.org>; Tue,  8 Sep 2020 17:09:56 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 20472DA78D; Tue,  8 Sep 2020 17:09:56 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,URIBL_BLOCKED,USER_IN_WELCOMELIST,USER_IN_WHITELIST
        autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id E3C1ADA797;
        Tue,  8 Sep 2020 17:09:53 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Tue, 08 Sep 2020 17:09:53 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from localhost.localdomain (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPSA id BA7BB4301DE2;
        Tue,  8 Sep 2020 17:09:53 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH 3/5] netfilter: ctnetlink: fix mark based dump filtering regression
Date:   Tue,  8 Sep 2020 17:09:45 +0200
Message-Id: <20200908150947.12623-4-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200908150947.12623-1-pablo@netfilter.org>
References: <20200908150947.12623-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Martin Willi <martin@strongswan.org>

conntrack mark based dump filtering may falsely skip entries if a mask
is given: If the mask-based check does not filter out the entry, the
else-if check is always true and compares the mark without considering
the mask. The if/else-if logic seems wrong.

Given that the mask during filter setup is implicitly set to 0xffffffff
if not specified explicitly, the mark filtering flags seem to just
complicate things. Restore the previously used approach by always
matching against a zero mask is no filter mark is given.

Fixes: cb8aa9a3affb ("netfilter: ctnetlink: add kernel side filtering for dump")
Signed-off-by: Martin Willi <martin@strongswan.org>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_conntrack_netlink.c | 19 +++----------------
 1 file changed, 3 insertions(+), 16 deletions(-)

diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index d65846aa8059..c3a4214dc958 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -851,7 +851,6 @@ static int ctnetlink_done(struct netlink_callback *cb)
 }
 
 struct ctnetlink_filter {
-	u_int32_t cta_flags;
 	u8 family;
 
 	u_int32_t orig_flags;
@@ -906,10 +905,6 @@ static int ctnetlink_parse_tuple_filter(const struct nlattr * const cda[],
 					 struct nf_conntrack_zone *zone,
 					 u_int32_t flags);
 
-/* applied on filters */
-#define CTA_FILTER_F_CTA_MARK			(1 << 0)
-#define CTA_FILTER_F_CTA_MARK_MASK		(1 << 1)
-
 static struct ctnetlink_filter *
 ctnetlink_alloc_filter(const struct nlattr * const cda[], u8 family)
 {
@@ -930,14 +925,10 @@ ctnetlink_alloc_filter(const struct nlattr * const cda[], u8 family)
 #ifdef CONFIG_NF_CONNTRACK_MARK
 	if (cda[CTA_MARK]) {
 		filter->mark.val = ntohl(nla_get_be32(cda[CTA_MARK]));
-		filter->cta_flags |= CTA_FILTER_FLAG(CTA_MARK);
-
-		if (cda[CTA_MARK_MASK]) {
+		if (cda[CTA_MARK_MASK])
 			filter->mark.mask = ntohl(nla_get_be32(cda[CTA_MARK_MASK]));
-			filter->cta_flags |= CTA_FILTER_FLAG(CTA_MARK_MASK);
-		} else {
+		else
 			filter->mark.mask = 0xffffffff;
-		}
 	} else if (cda[CTA_MARK_MASK]) {
 		err = -EINVAL;
 		goto err_filter;
@@ -1117,11 +1108,7 @@ static int ctnetlink_filter_match(struct nf_conn *ct, void *data)
 	}
 
 #ifdef CONFIG_NF_CONNTRACK_MARK
-	if ((filter->cta_flags & CTA_FILTER_FLAG(CTA_MARK_MASK)) &&
-	    (ct->mark & filter->mark.mask) != filter->mark.val)
-		goto ignore_entry;
-	else if ((filter->cta_flags & CTA_FILTER_FLAG(CTA_MARK)) &&
-		 ct->mark != filter->mark.val)
+	if ((ct->mark & filter->mark.mask) != filter->mark.val)
 		goto ignore_entry;
 #endif
 
-- 
2.20.1

