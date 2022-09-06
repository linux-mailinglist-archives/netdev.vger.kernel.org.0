Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A2FB35ADEEE
	for <lists+netdev@lfdr.de>; Tue,  6 Sep 2022 07:31:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232658AbiIFFVt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Sep 2022 01:21:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232628AbiIFFVp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Sep 2022 01:21:45 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 382356CF64
        for <netdev@vger.kernel.org>; Mon,  5 Sep 2022 22:21:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4B45AB81624
        for <netdev@vger.kernel.org>; Tue,  6 Sep 2022 05:21:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4B89C433B5;
        Tue,  6 Sep 2022 05:21:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1662441700;
        bh=ofrt/h68tYS/wlb2IuElG7h7AQ5WuQ+f9NdBkh1YL7E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LxYoZxakuoaUpLBkhUcnmCeXnALLsADXAV3M+eR54VxIURv3/4sJLpYEqW/pK5Qb5
         YGlRa36b66IvNl6Q5NxSIFr1d1l3HmwoNUdL4oCbBnonHofcMm1OZ554IHm+vgZNNK
         Hfc5n3kd47DYl8hVmAl0QqT4/7O37fDutwV8KEHtj39+EYo7rrTJWOXhG2D6eCVzSK
         mAEAjnOl03nq+POcX1KUsSWaR9JdMPPA2orGpsuyGZdIBPXzY8i1uJ6yzMGwwNRpbp
         XKCZTzxCx8DHuGkFybS02+ctjnd7TFY2Sb+LPDwcfN0w1tbRhWHE0Dartr8/UQ0QSI
         m8h0DLKOwS1fg==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Lior Nahmanson <liorna@nvidia.com>,
        Raed Salem <raeds@nvidia.com>
Subject: [PATCH net-next V2 02/17] net/macsec: Add MACsec skb_metadata_dst Rx Data path support
Date:   Mon,  5 Sep 2022 22:21:14 -0700
Message-Id: <20220906052129.104507-3-saeed@kernel.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220906052129.104507-1-saeed@kernel.org>
References: <20220906052129.104507-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Lior Nahmanson <liorna@nvidia.com>

Like in the Tx changes, if there are more than one MACsec device with
the same MAC address as in the packet's destination MAC, the packet will
be forward only to this device and not neccessarly to the desired one.

Offloading device drivers will mark offloaded MACsec SKBs with the
corresponding SCI in the skb_metadata_dst so the macsec rx handler will
know to which port to divert those skbs, instead of wrongly solely
relaying on dst MAC address comparison.

Signed-off-by: Lior Nahmanson <liorna@nvidia.com>
Reviewed-by: Raed Salem <raeds@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/macsec.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/macsec.c b/drivers/net/macsec.c
index c190dc019717..e781b3e22aac 100644
--- a/drivers/net/macsec.c
+++ b/drivers/net/macsec.c
@@ -1025,11 +1025,13 @@ static enum rx_handler_result handle_not_macsec(struct sk_buff *skb)
 	/* Deliver to the uncontrolled port by default */
 	enum rx_handler_result ret = RX_HANDLER_PASS;
 	struct ethhdr *hdr = eth_hdr(skb);
+	struct metadata_dst *md_dst;
 	struct macsec_rxh_data *rxd;
 	struct macsec_dev *macsec;
 
 	rcu_read_lock();
 	rxd = macsec_data_rcu(skb->dev);
+	md_dst = skb_metadata_dst(skb);
 
 	list_for_each_entry_rcu(macsec, &rxd->secys, secys) {
 		struct sk_buff *nskb;
@@ -1040,6 +1042,10 @@ static enum rx_handler_result handle_not_macsec(struct sk_buff *skb)
 		 * the SecTAG, so we have to deduce which port to deliver to.
 		 */
 		if (macsec_is_offloaded(macsec) && netif_running(ndev)) {
+			if (md_dst && md_dst->type == METADATA_MACSEC &&
+			    (!find_rx_sc(&macsec->secy, md_dst->u.macsec_info.sci)))
+				continue;
+
 			if (ether_addr_equal_64bits(hdr->h_dest,
 						    ndev->dev_addr)) {
 				/* exact match, divert skb to this port */
-- 
2.37.2

