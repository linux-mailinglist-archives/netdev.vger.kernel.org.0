Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F0B904E6849
	for <lists+netdev@lfdr.de>; Thu, 24 Mar 2022 19:03:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352462AbiCXSFL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Mar 2022 14:05:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236126AbiCXSFK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Mar 2022 14:05:10 -0400
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E552EB6D3C
        for <netdev@vger.kernel.org>; Thu, 24 Mar 2022 11:03:35 -0700 (PDT)
Received: by mail-wr1-x435.google.com with SMTP id t11so7750475wrm.5
        for <netdev@vger.kernel.org>; Thu, 24 Mar 2022 11:03:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=owmLfPpYYMaBVtY6mbM4OZ45C3yXrEZ2FlA+mb8/5O8=;
        b=j1/rXUfeGCP/VsM4CEjyqLf5+myIbJ3gpBMpVPm6wQu4qQlatePT6N9JZ+9R8MNSCu
         eKumeY2uZTfYjddt8LmOUe4zph4GvQJegwxgARresholsY2s0BMAUmeA5NtBxTsObvFt
         ZGPbbQ7iu8DXYy2C2trReZ4gt3nai5AGqQmkP6qPajhLraux686HBS+C0s8FNhZxAWfo
         8hRvFvW64F6hzSS65Din/R0mZ9sXOl0y6ddP8p1d9UjSI8Mj67Yf+yt3ZpD5s7brdc3j
         Qcgig6/iZAHK7cHzGGPuV/Lw/MkmmHpithPsqcGmz+6RonCJBMYVi7n02ZJ2CIwr94N5
         4nww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=owmLfPpYYMaBVtY6mbM4OZ45C3yXrEZ2FlA+mb8/5O8=;
        b=ACFBPGI8FoagLD2qkXynVhLJ2L3FwGQ+UJbkX4Pg2PgmKuWiFIYAdqJueWzuSJ7r2A
         oMeDnb3Df4YzId73poSAktoOYgVl8eF0pPESUENsfy5GGWrOXKz1bkt0+fv+c8OG3tr2
         3xF0jwulA5CjQ8ZIcwgWj6pdXxOO3cH6qECbKUsnHbKmWW9Cbu3QlUI1xSHVZlelXndW
         etZ9oqX0NJK21o9QHhiyE78SkkP6DAoBuWVxxDXfd0BW0ky88YjzF2GcuRMB79WnNy0K
         9iE+Z5Ch5w59YQ0eBv9ORlZ34M9mF7mn72xrsojwA//GIElT/KVfkdBPntR0JikaMFeI
         aHjw==
X-Gm-Message-State: AOAM532AsiGeagc8cMSk1A0n8/Er+1KInVporDjmESWcRLOl4rA74t2M
        KA2RyRJ28IaWoRj/+Y4ZLsQ7Tg==
X-Google-Smtp-Source: ABdhPJy+Ewv3aODlyZ46WFEbfeQ/vNJrykbM7se193mWm+x4dLRrKa38PgpkRQGMxLbx24p6L28kXw==
X-Received: by 2002:a5d:6405:0:b0:204:1ef:56e8 with SMTP id z5-20020a5d6405000000b0020401ef56e8mr5659489wru.677.1648145014460;
        Thu, 24 Mar 2022 11:03:34 -0700 (PDT)
Received: from localhost.localdomain (cpc92880-cmbg19-2-0-cust679.5-4.cable.virginm.net. [82.27.106.168])
        by smtp.gmail.com with ESMTPSA id l10-20020a05600002aa00b0020414b4e75fsm3740220wry.85.2022.03.24.11.03.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Mar 2022 11:03:34 -0700 (PDT)
From:   Jean-Philippe Brucker <jean-philippe@linaro.org>
To:     ilias.apalodimas@linaro.org, hawk@kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, linyunsheng@huawei.com,
        Jean-Philippe Brucker <jean-philippe@linaro.org>
Subject: [PATCH net] skbuff: disable coalescing for page_pool recycling
Date:   Thu, 24 Mar 2022 17:29:15 +0000
Message-Id: <20220324172913.26293-1-jean-philippe@linaro.org>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix a use-after-free when using page_pool with page fragments. We
encountered this problem during normal RX in the hns3 driver:

(1) Initially we have three descriptors in the RX queue. The first one
    allocates PAGE1 through page_pool, and the other two allocate one
    half of PAGE2 each. Page references look like this:

                RX_BD1 _______ PAGE1
                RX_BD2 _______ PAGE2
                RX_BD3 _________/

(2) Handle RX on the first descriptor. Allocate SKB1, eventually added
    to the receive queue by tcp_queue_rcv().

(3) Handle RX on the second descriptor. Allocate SKB2 and pass it to
    netif_receive_skb():

    netif_receive_skb(SKB2)
      ip_rcv(SKB2)
        SKB3 = skb_clone(SKB2)

    SKB2 and SKB3 share a reference to PAGE2 through
    skb_shinfo()->dataref. The other ref to PAGE2 is still held by
    RX_BD3:

                      SKB2 ---+- PAGE2
                      SKB3 __/   /
                RX_BD3 _________/

 (3b) Now while handling TCP, coalesce SKB3 with SKB1:

      tcp_v4_rcv(SKB3)
        tcp_try_coalesce(to=SKB1, from=SKB3)    // succeeds
        kfree_skb_partial(SKB3)
          skb_release_data(SKB3)                // drops one dataref

                      SKB1 _____ PAGE1
                           \____
                      SKB2 _____ PAGE2
                                 /
                RX_BD3 _________/

    The problem is here: both SKB1 and SKB2 point to PAGE2 but SKB1 does
    not actually hold a reference to PAGE2. Without coalescing, when
    releasing both SKB2 and SKB3, a single reference to PAGE2 would be
    dropped. Now when releasing SKB1 and SKB2, two references to PAGE2
    will be dropped, resulting in underflow.

 (3c) Drop SKB2:

      af_packet_rcv(SKB2)
        consume_skb(SKB2)
          skb_release_data(SKB2)                // drops second dataref
            page_pool_return_skb_page(PAGE2)    // drops one pp_frag_count

                      SKB1 _____ PAGE1
                           \____
                                 PAGE2
                                 /
                RX_BD3 _________/

(4) Userspace calls recvmsg()
    Copies SKB1 and releases it. Since SKB3 was coalesced with SKB1, we
    release the SKB3 page as well:

    tcp_eat_recv_skb(SKB1)
      skb_release_data(SKB1)
        page_pool_return_skb_page(PAGE1)
        page_pool_return_skb_page(PAGE2)        // drops second pp_frag_count

(5) PAGE2 is freed, but the third RX descriptor was still using it!
    In our case this causes IOMMU faults, but it would silently corrupt
    memory if the IOMMU was disabled.

A proper implementation would probably take another reference from the
page_pool at step (3b), but that seems too complicated for a fix. Keep
it simple for now, prevent coalescing for page_pool users.

Fixes: 53e0961da1c7 ("page_pool: add frag page recycling support in page pool")
Signed-off-by: Jean-Philippe Brucker <jean-philippe@linaro.org>
---

The Fixes tag says frag page recycling but I'm not sure, does it not
also affect full page recycling?  Coalescing is one case, are there
other places where we move page fragments between skbuffs?  I'm still
too unfamiliar with this code to figure it out.

Previously discussed here:
https://lore.kernel.org/netdev/YfFbDivUPbpWjh%2Fm@myrica/
---
 net/core/skbuff.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index 10bde7c6db44..431f7ce88049 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -5276,11 +5276,11 @@ bool skb_try_coalesce(struct sk_buff *to, struct sk_buff *from,
 	if (skb_cloned(to))
 		return false;
 
-	/* The page pool signature of struct page will eventually figure out
-	 * which pages can be recycled or not but for now let's prohibit slab
-	 * allocated and page_pool allocated SKBs from being coalesced.
+	/* Prohibit adding page_pool allocated SKBs, because that would require
+	 * transferring the page fragment reference. For now let's also prohibit
+	 * slab allocated and page_pool allocated SKBs from being coalesced.
 	 */
-	if (to->pp_recycle != from->pp_recycle)
+	if (to->pp_recycle || from->pp_recycle)
 		return false;
 
 	if (len <= skb_tailroom(to)) {
-- 
2.35.1

