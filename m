Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CBAEA24C265
	for <lists+netdev@lfdr.de>; Thu, 20 Aug 2020 17:44:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728676AbgHTPoK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Aug 2020 11:44:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728209AbgHTPoF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Aug 2020 11:44:05 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49EFDC061385
        for <netdev@vger.kernel.org>; Thu, 20 Aug 2020 08:44:05 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id r1so2748711ybg.4
        for <netdev@vger.kernel.org>; Thu, 20 Aug 2020 08:44:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:message-id:mime-version:subject:from:to:cc;
        bh=0ArkVR3Ghyb1QqtalxYRj9S2l5aW0CmlTOA2cS5QLQ4=;
        b=i5VdMJxBN+odQeLIr3AmJHk0+S9d7+BGWCCcx9JXkOkPo3hxxUDUzIjUYZjIyjapUt
         dCbge+gsAKYH27OSM0ncEZw3Krxfx6m7LbPqD1H7tS8wO+EvHREBYfx0HauvK9v/8ZlP
         eJsb8LYAm4HM1833BElwIVMTOlhQeFrL6Sk7Bmf9kisMPeNgyyMNGVedr3AzE4tM6G1Z
         sY5JR1DZ9tHBrfSImqCAcXmWenBnGSiCrflJCCPSYOK5dCJKH00+6ZFDT3Vz+f5/DgV4
         Bn5KMtbEcoKfIuj32zmNATQovVU7YaL9Aw0sZecKqYnWhcRLGzQY1hZziwXCgrlR3fd6
         P0Og==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:message-id:mime-version:subject:from
         :to:cc;
        bh=0ArkVR3Ghyb1QqtalxYRj9S2l5aW0CmlTOA2cS5QLQ4=;
        b=XRIsJ7rAbueOBxSRbo80Z546PdxuxVdjGd9YADb0jDRgv9MezkZt9PagRj9IhROFT7
         UxOVQ/Oh4d5sNrT0oc1rDkayBRnaMW/s+mqOpFnOBU4F+HAlr+5sFa+DtXOBbQT29Ck2
         Yse2xadnfJyGWkO4EOoFcr+9lWajT5UUz7z8xcGb3ATQMdUrLhNK7JS0BBcZmzzKivm9
         dBGloLsSzqqBONCLPXhjkP/78jxuStbUv5PZvyxfvU/9V8eYZohVxhJwBd7cIoUl+U1S
         dvBgIpHamicpKRHmCbV8YHPoFAZuAomhh2zUpTaNZwi439SHU9uZoGT18i94Mh9nx2fT
         SCzw==
X-Gm-Message-State: AOAM5339EhW/INqdvFKzky2H/nkgY0oXEeGMapSiqwb0vPM04r54bC3O
        RSo2sT7hsoK5AW8SIm18Z0sPy1AT8Pc65w==
X-Google-Smtp-Source: ABdhPJxiwHJ4+cnIR4CCL8Eu94XsAqPHppbclXmSvEIt7gDc3/YCxY2ZRc7d0DppVs6z/7dWKHaGj1z3C4zWmQ==
X-Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:7220:84ff:fe09:1424])
 (user=edumazet job=sendgmr) by 2002:a25:bdd3:: with SMTP id
 g19mr5935816ybk.338.1597938244200; Thu, 20 Aug 2020 08:44:04 -0700 (PDT)
Date:   Thu, 20 Aug 2020 08:43:59 -0700
Message-Id: <20200820154359.1806305-1-edumazet@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.28.0.220.ged08abb693-goog
Subject: [PATCH net-next] net: zerocopy: combine pages in zerocopy_sg_from_iter()
From:   Eric Dumazet <edumazet@google.com>
To:     "David S . Miller" <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Willem de Bruijn <willemb@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently, tcp sendmsg(MSG_ZEROCOPY) is building skbs with order-0 fragments.
Compared to standard sendmsg(), these skbs usually contain up to 16 fragments
on arches with 4KB page sizes, instead of two.

This adds considerable costs on various ndo_start_xmit() handlers,
especially when IOMMU is in the picture.

As high performance applications are often using huge pages,
we can try to combine adjacent pages belonging to same
compound page.

Tested on AMD Rome platform, with IOMMU, nominal single TCP flow speed
is roughly doubled (~55Gbit -> ~100Gbit), when user application
is using hugepages.

For reference, nominal single TCP flow speed on this platform
without MSG_ZEROCOPY is ~65Gbit.

Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Willem de Bruijn <willemb@google.com>
---
 net/core/datagram.c | 33 +++++++++++++++++++++++++++++----
 1 file changed, 29 insertions(+), 4 deletions(-)

diff --git a/net/core/datagram.c b/net/core/datagram.c
index 639745d4f3b94a248da9a685f45158410a85bec7..9fcaa544f11a92f1b833d03e9db0863c32905673 100644
--- a/net/core/datagram.c
+++ b/net/core/datagram.c
@@ -623,10 +623,11 @@ int __zerocopy_sg_from_iter(struct sock *sk, struct sk_buff *skb,
 
 	while (length && iov_iter_count(from)) {
 		struct page *pages[MAX_SKB_FRAGS];
+		struct page *last_head = NULL;
 		size_t start;
 		ssize_t copied;
 		unsigned long truesize;
-		int n = 0;
+		int refs, n = 0;
 
 		if (frag == MAX_SKB_FRAGS)
 			return -EMSGSIZE;
@@ -649,13 +650,37 @@ int __zerocopy_sg_from_iter(struct sock *sk, struct sk_buff *skb,
 		} else {
 			refcount_add(truesize, &skb->sk->sk_wmem_alloc);
 		}
-		while (copied) {
+		for (refs = 0; copied != 0; start = 0) {
 			int size = min_t(int, copied, PAGE_SIZE - start);
-			skb_fill_page_desc(skb, frag++, pages[n], start, size);
-			start = 0;
+			struct page *head = compound_head(pages[n]);
+
+			start += (pages[n] - head) << PAGE_SHIFT;
 			copied -= size;
 			n++;
+			if (frag) {
+				skb_frag_t *last = &skb_shinfo(skb)->frags[frag - 1];
+
+				if (head == skb_frag_page(last) &&
+				    start == skb_frag_off(last) + skb_frag_size(last)) {
+					skb_frag_size_add(last, size);
+					/* We combined this page, we need to release
+					 * a reference. Since compound pages refcount
+					 * is shared among many pages, batch the refcount
+					 * adjustments to limit false sharing.
+					 */
+					last_head = head;
+					refs++;
+					continue;
+				}
+			}
+			if (refs) {
+				page_ref_sub(last_head, refs);
+				refs = 0;
+			}
+			skb_fill_page_desc(skb, frag++, head, start, size);
 		}
+		if (refs)
+			page_ref_sub(last_head, refs);
 	}
 	return 0;
 }
-- 
2.28.0.220.ged08abb693-goog

