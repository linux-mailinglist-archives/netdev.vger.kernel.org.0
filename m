Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7C3FF4E9806
	for <lists+netdev@lfdr.de>; Mon, 28 Mar 2022 15:25:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243152AbiC1N11 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Mar 2022 09:27:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229531AbiC1N1Z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Mar 2022 09:27:25 -0400
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 602984B1EB
        for <netdev@vger.kernel.org>; Mon, 28 Mar 2022 06:25:44 -0700 (PDT)
Received: by mail-ed1-x52a.google.com with SMTP id h1so16932532edj.1
        for <netdev@vger.kernel.org>; Mon, 28 Mar 2022 06:25:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=0fadutzh9QJThZQKUrwSYWb7LO8Q+i8RmuTE9HUwT9U=;
        b=ZP0odGqF/WdDVnic6VVeZH3YUu8LZK9a9yvvtBgSas6k/PqWLdB/0tZmXprg7lGiR2
         oxQKWLaW3Bq97/29ucyHg0K6u5S8xoDrBchBp4HINj3Xe4zej7g2GZ7VOob680QW2hVD
         61hRaazT/ZYQVZCpY2PSz9E4TNSiUTOAeDAaOSi7UQaeBj5vB5AqMi3llIeJS++AftGB
         huP8l46YMWd9yT3Z2aYAm33LPIN/T+LsFUfivuW+8ZsMJ/Zn+tR57/yJLt/eSOytT2wh
         kOiwTpP4tpNh4csCvZICFV/lPYOTk/f4+sl+EPZodTCsJoUt3TWG1V3A6Izij7n5wy4c
         UEBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=0fadutzh9QJThZQKUrwSYWb7LO8Q+i8RmuTE9HUwT9U=;
        b=HdhIdF6Kk4pvZJ63A7vMf1vV0AC0IyK4TFIzQx+quFNnmKOOE0VS8OWvwaHU3kmqIJ
         6nlXdsv4947xSwp342oyl7F47jjHqZIYArGuYArr+wmBufK1xGa13lLzG9L6XSaa8tZj
         28B5J6gNpCFH1N2KJPbw7gC+J6SXqTDT7YdxDX5BcKzKh1SKVZAyeLSzclqBGcZY2GR8
         PR4In7tBJ5DIw92dMlCcWVh04b4G4qJ2vxk8y3W58uNmSux3qmPDWsIdRSryyh+3ro18
         CGCQBFNr2WWO9qj6Srx4GkNuKfg85aVzN42RofqqpsRFx/ulkCqf43LqNzfjtTIO91AZ
         1yuw==
X-Gm-Message-State: AOAM532eHjhriirCcutzzmx7KG7dkbsgosdpww7biw/xAm2TPKLpZ6BX
        t+04jYu1+E89H+dnGTDyzifAqA==
X-Google-Smtp-Source: ABdhPJzjye18EveAa6bSeVbFat8WE9/6MWfp9Qlhm3iazlG1FsZMjcTVz1Evm6AeMKRWhWpekTZKrg==
X-Received: by 2002:aa7:c1cd:0:b0:419:fdb:e17e with SMTP id d13-20020aa7c1cd000000b004190fdbe17emr16281779edp.364.1648473942858;
        Mon, 28 Mar 2022 06:25:42 -0700 (PDT)
Received: from localhost.localdomain (cpc92880-cmbg19-2-0-cust679.5-4.cable.virginm.net. [82.27.106.168])
        by smtp.gmail.com with ESMTPSA id y16-20020aa7d510000000b004197c1cec7dsm6984977edq.6.2022.03.28.06.25.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Mar 2022 06:25:42 -0700 (PDT)
From:   Jean-Philippe Brucker <jean-philippe@linaro.org>
To:     ilias.apalodimas@linaro.org, hawk@kernel.org,
        alexanderduyck@fb.com, linyunsheng@huawei.com
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org,
        Jean-Philippe Brucker <jean-philippe@linaro.org>
Subject: [PATCH net v2] skbuff: disable coalescing for page_pool fragment recycling
Date:   Mon, 28 Mar 2022 14:22:59 +0100
Message-Id: <20220328132258.78307-1-jean-philippe@linaro.org>
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

    In tcp_try_coalesce(), __skb_frag_ref() takes a page reference to
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

Prevent coalescing the SKB if it may hold shared page_pool fragment
references.

Fixes: 53e0961da1c7 ("page_pool: add frag page recycling support in page pool")
Signed-off-by: Jean-Philippe Brucker <jean-philippe@linaro.org>
---
 net/core/skbuff.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index 10bde7c6db44..56b45b9f0b4d 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -5276,6 +5276,13 @@ bool skb_try_coalesce(struct sk_buff *to, struct sk_buff *from,
 	if (skb_cloned(to))
 		return false;
 
+	/* We don't support taking page_pool frag references at the moment.
+	 * If the SKB is cloned and could have page_pool frag references, don't
+	 * coalesce it.
+	 */
+	if (skb_cloned(from) && from->pp_recycle)
+		return false;
+
 	/* The page pool signature of struct page will eventually figure out
 	 * which pages can be recycled or not but for now let's prohibit slab
 	 * allocated and page_pool allocated SKBs from being coalesced.
-- 
2.35.1

