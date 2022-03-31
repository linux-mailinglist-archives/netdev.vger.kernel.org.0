Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 908CF4ED7CB
	for <lists+netdev@lfdr.de>; Thu, 31 Mar 2022 12:33:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234601AbiCaKfL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 31 Mar 2022 06:35:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234169AbiCaKfI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 31 Mar 2022 06:35:08 -0400
Received: from mail-wm1-x334.google.com (mail-wm1-x334.google.com [IPv6:2a00:1450:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 601B45FD7
        for <netdev@vger.kernel.org>; Thu, 31 Mar 2022 03:33:19 -0700 (PDT)
Received: by mail-wm1-x334.google.com with SMTP id q20so13989475wmq.1
        for <netdev@vger.kernel.org>; Thu, 31 Mar 2022 03:33:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=JoGwSwSU8uutbdS3S0I8T9xBV6Zm+XJOdqpM7/pDlgo=;
        b=G4esZQzoBsSVTHm1keDdmfVUwId5+2O0OiGsy2IhOxakF5uBbEnbpv/T95xVHxJbWN
         fxdnrCZpiFQYl2nZ7bC+11LabNjiD+441/MMGPPum+0eksoL2c5CKqcjzyMCxOIQkLNV
         eTeOzjV0tpFtx3/n2LHn2O2eYvuaDx2Xd5FEpDNAtrpitDsgvsqsqrus06Z7JSs1Y41S
         v0tI8LbNQBY1/XVNae/8E5L22pLl6DawNOM2VopL4IUcgIb9MKOoCkxwE7Lahrwf/KWx
         RRvKn7mRki/Kfis3KaM/RMr+P1CYVGJx2am7hcw33YlxGY9bwCTphmHglXXWS01AjcjP
         W/nw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=JoGwSwSU8uutbdS3S0I8T9xBV6Zm+XJOdqpM7/pDlgo=;
        b=R5MpiYNMTWnfrvWHqbpFh8GOzMFSMqsWSnbyqev+tn5mHoi7pX6mWjp2oHGD+ujWR7
         P/HDW+Ozg25vRD80PaTs4E0a86Ep8TBW4DqIefe12ihMis2nqd68vTEUa+VsJTLbfcBG
         viSpsGHN/lJ0yijUPh0By+jwgAkg6bMccjOR4W5E/0cuXo4FBSHvnBSmB3wPZlkuZwlF
         AFEywAFNv9SOrx0KG8nJMvaciBZVCFD+rQD2uVh7TG0fOTBvLpKru5wlrFfuHFxBuNTY
         h+5qm95lpWHZFqGvJY5/GqCDJnkZ+0wbaCgAU5+JT4mVEcw075gLnCIv54KBcpR7FMI7
         a/Nw==
X-Gm-Message-State: AOAM530WbvEAPspw/Qie1IkIcmTID8W4K3ivMwUgKXk8O+Lhl1jkhmcb
        itoU0chpgF6DME6dntjWkgCI7A==
X-Google-Smtp-Source: ABdhPJxYPMh47EYs7L8x150NHd3XCU53w3yuSvRDa0Dm6dWHnkuk5paDxYmNE9SHMEX/Aia6wYqHOA==
X-Received: by 2002:a05:600c:1909:b0:38c:e8f3:8e3d with SMTP id j9-20020a05600c190900b0038ce8f38e3dmr4194629wmq.152.1648722797915;
        Thu, 31 Mar 2022 03:33:17 -0700 (PDT)
Received: from localhost.localdomain (cpc92880-cmbg19-2-0-cust679.5-4.cable.virginm.net. [82.27.106.168])
        by smtp.gmail.com with ESMTPSA id a11-20020a056000188b00b00204109f7826sm21933677wri.28.2022.03.31.03.33.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 31 Mar 2022 03:33:17 -0700 (PDT)
From:   Jean-Philippe Brucker <jean-philippe@linaro.org>
To:     ilias.apalodimas@linaro.org, alexanderduyck@fb.com,
        linyunsheng@huawei.com
Cc:     hawk@kernel.org, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org,
        Jean-Philippe Brucker <jean-philippe@linaro.org>
Subject: [PATCH net v3] skbuff: fix coalescing for page_pool fragment recycling
Date:   Thu, 31 Mar 2022 11:24:41 +0100
Message-Id: <20220331102440.1673-1-jean-philippe@linaro.org>
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

    In skb_try_coalesce(), __skb_frag_ref() takes a page reference to
    PAGE2, where it should instead have increased the page_pool frag
    reference, pp_frag_count. Without coalescing, when releasing both
    SKB2 and SKB3, a single reference to PAGE2 would be dropped. Now
    when releasing SKB1 and SKB2, two references to PAGE2 will be
    dropped, resulting in underflow.

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

Change the logic that checks whether pp_recycle SKBs can be coalesced.
We still reject differing pp_recycle between 'from' and 'to' SKBs, but
in order to avoid the situation described above, we also reject
coalescing when both 'from' and 'to' are pp_recycled and 'from' is
cloned.

The new logic allows coalescing a cloned pp_recycle SKB into a page
refcounted one, because in this case the release (4) will drop the right
reference, the one taken by skb_try_coalesce().

Fixes: 53e0961da1c7 ("page_pool: add frag page recycling support in page pool")
Suggested-by: Alexander Duyck <alexanderduyck@fb.com>
Signed-off-by: Jean-Philippe Brucker <jean-philippe@linaro.org>
---
v2: https://lore.kernel.org/netdev/20220328132258.78307-1-jean-philippe@linaro.org/
v1: https://lore.kernel.org/netdev/20220324172913.26293-1-jean-philippe@linaro.org/
---
 net/core/skbuff.c | 15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index ea51e23e9247..2d6ef6d7ebf5 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -5244,11 +5244,18 @@ bool skb_try_coalesce(struct sk_buff *to, struct sk_buff *from,
 	if (skb_cloned(to))
 		return false;
 
-	/* The page pool signature of struct page will eventually figure out
-	 * which pages can be recycled or not but for now let's prohibit slab
-	 * allocated and page_pool allocated SKBs from being coalesced.
+	/* In general, avoid mixing slab allocated and page_pool allocated
+	 * pages within the same SKB. However when @to is not pp_recycle and
+	 * @from is cloned, we can transition frag pages from page_pool to
+	 * reference counted.
+	 *
+	 * On the other hand, don't allow coalescing two pp_recycle SKBs if
+	 * @from is cloned, in case the SKB is using page_pool fragment
+	 * references (PP_FLAG_PAGE_FRAG). Since we only take full page
+	 * references for cloned SKBs at the moment that would result in
+	 * inconsistent reference counts.
 	 */
-	if (to->pp_recycle != from->pp_recycle)
+	if (to->pp_recycle != (from->pp_recycle && !skb_cloned(from)))
 		return false;
 
 	if (len <= skb_tailroom(to)) {
-- 
2.25.1

