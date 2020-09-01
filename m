Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3BC5A2588B7
	for <lists+netdev@lfdr.de>; Tue,  1 Sep 2020 09:06:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726586AbgIAHGC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Sep 2020 03:06:02 -0400
Received: from sitav-80046.hsr.ch ([152.96.80.46]:34144 "EHLO
        mail.strongswan.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726044AbgIAHF7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Sep 2020 03:05:59 -0400
X-Greylist: delayed 570 seconds by postgrey-1.27 at vger.kernel.org; Tue, 01 Sep 2020 03:05:58 EDT
Received: from think.wlp.is (unknown [185.12.128.225])
        by mail.strongswan.org (Postfix) with ESMTPSA id 306AD40412;
        Tue,  1 Sep 2020 08:56:26 +0200 (CEST)
From:   Martin Willi <martin@strongswan.org>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org, netdev@vger.kernel.org,
        Florent Fourcot <florent.fourcot@wifirst.fr>,
        Romain Bellan <romain.bellan@wifirst.fr>
Subject: [PATCH nf] netfilter: ctnetlink: fix mark based dump filtering regression
Date:   Tue,  1 Sep 2020 08:56:19 +0200
Message-Id: <20200901065619.4484-1-martin@strongswan.org>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

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
---
 net/netfilter/nf_conntrack_netlink.c | 19 +++----------------
 1 file changed, 3 insertions(+), 16 deletions(-)

diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index 832eabecfbdd..9bb82fcb7d6c 100644
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
2.25.1

