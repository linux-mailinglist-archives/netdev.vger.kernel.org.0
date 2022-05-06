Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3B45851DE25
	for <lists+netdev@lfdr.de>; Fri,  6 May 2022 19:08:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1444107AbiEFRL7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 May 2022 13:11:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1444103AbiEFRLu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 May 2022 13:11:50 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28B4C6EC63
        for <netdev@vger.kernel.org>; Fri,  6 May 2022 10:08:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BB007620A4
        for <netdev@vger.kernel.org>; Fri,  6 May 2022 17:08:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D759BC385B4;
        Fri,  6 May 2022 17:08:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651856881;
        bh=7MEfFfBWj67o0eLjWbCVhM8Q6WZbKnmQYW9UoRjwsOI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ROT1YSmQ3TKUMy3diWfC4g7o0vUjMErR1Dil1ubvEL2RPOHeVlQBDGBxMnMjH2c7w
         ulDAEHmCmbU/dRIHq8clw5UL0vfDzUlx/5zW27Mt35+hyFl6qAEMILCyXQ3cJoVWzD
         7k+HgYiisiVyTOQH+bYOtWPVOWGrzlG3mmJg45GtN2NnlHWk7Z0r/3SqlZSx3AogAb
         wEBKAd/Uvrg3a/Xe94ykKM8eR/3IeTTK+mK25O1XvxVCYs6RfKpCEv04li5YbiwHUV
         9DC46LBcg7NbSry+LUmWdTQxZahWJjCm5F0rrg8CKx49HN2VyfTIakK8WI4asYECuC
         1od37d+JMCUHg==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, pabeni@redhat.com, edumazet@google.com,
        Jakub Kicinski <kuba@kernel.org>, mst@redhat.com,
        jasowang@redhat.com, virtualization@lists.linux-foundation.org
Subject: [PATCH net-next 5/6] net: virtio: switch to netif_napi_add_weight()
Date:   Fri,  6 May 2022 10:07:50 -0700
Message-Id: <20220506170751.822862-6-kuba@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220506170751.822862-1-kuba@kernel.org>
References: <20220506170751.822862-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

virtio netdev driver uses a custom napi weight, switch to the new
API for setting custom weight.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
CC: mst@redhat.com
CC: jasowang@redhat.com
CC: virtualization@lists.linux-foundation.org
---
 drivers/net/virtio_net.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index ebb98b796352..db05b5e930be 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -3313,8 +3313,8 @@ static int virtnet_alloc_queues(struct virtnet_info *vi)
 	INIT_DELAYED_WORK(&vi->refill, refill_work);
 	for (i = 0; i < vi->max_queue_pairs; i++) {
 		vi->rq[i].pages = NULL;
-		netif_napi_add(vi->dev, &vi->rq[i].napi, virtnet_poll,
-			       napi_weight);
+		netif_napi_add_weight(vi->dev, &vi->rq[i].napi, virtnet_poll,
+				      napi_weight);
 		netif_napi_add_tx_weight(vi->dev, &vi->sq[i].napi,
 					 virtnet_poll_tx,
 					 napi_tx ? napi_weight : 0);
-- 
2.34.1

