Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C181E5B51FB
	for <lists+netdev@lfdr.de>; Mon, 12 Sep 2022 01:41:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229662AbiIKXlf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 11 Sep 2022 19:41:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229597AbiIKXlb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 11 Sep 2022 19:41:31 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A29D727145
        for <netdev@vger.kernel.org>; Sun, 11 Sep 2022 16:41:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0C34DB80B54
        for <netdev@vger.kernel.org>; Sun, 11 Sep 2022 23:41:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73D0EC433C1;
        Sun, 11 Sep 2022 23:41:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1662939683;
        bh=I1gADSbku4XFnO8crI8uwG5x6KEk7RY4URBOXj8TTuc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LY3QxDTrokT0OEBnmT+6ZLlMrtUHXKDKLLgjg/gM9Q5lFWjRBs4SxFD3H4IZzaTUE
         3t+FuIZKzHDquBMQt12JcoaNn7/PccVLUNJ8MwoWIy5md9CyJ2rmAC4QAuY+8lgu9l
         z8iQZ2Rt/8TxS/wrbmu3+a9BvLmA8Gya+wJSumlsEBaaqfikOIoXnP9FaMLG1VjH3f
         8KYchwDRkYoHnf4bawqDwBidpH/ogBIOqhP3UYejuN8Nk0tsIUzs8hWugVikEnKlCi
         OLV4/gv2M/pmWXFZ4YSAdVpONJts5c+RfNFrO+cwNt9eEcsxMKQBvwvf2UlJgEvs0x
         qzE3EJk2jVQnw==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Emeel Hakim <ehakim@nvidia.com>
Subject: [PATCH net-next 01/10] net: macsec: Expose extended packet number (EPN) properties to macsec offload
Date:   Mon, 12 Sep 2022 00:40:50 +0100
Message-Id: <20220911234059.98624-2-saeed@kernel.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220911234059.98624-1-saeed@kernel.org>
References: <20220911234059.98624-1-saeed@kernel.org>
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

From: Emeel Hakim <ehakim@nvidia.com>

Currently macsec invokes HW offload path before reading extended packet
number (EPN) related user properties i.e. salt and short secure channel
identifier (ssci), hence preventing macsec EPN HW offload.
Expose those by moving macsec EPN properties reading prior to HW offload
path.

Signed-off-by: Emeel Hakim <ehakim@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/macsec.c | 24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

diff --git a/drivers/net/macsec.c b/drivers/net/macsec.c
index 830fed3914b6..617f850bdb3a 100644
--- a/drivers/net/macsec.c
+++ b/drivers/net/macsec.c
@@ -1828,6 +1828,12 @@ static int macsec_add_rxsa(struct sk_buff *skb, struct genl_info *info)
 
 	rx_sa->sc = rx_sc;
 
+	if (secy->xpn) {
+		rx_sa->ssci = nla_get_ssci(tb_sa[MACSEC_SA_ATTR_SSCI]);
+		nla_memcpy(rx_sa->key.salt.bytes, tb_sa[MACSEC_SA_ATTR_SALT],
+			   MACSEC_SALT_LEN);
+	}
+
 	/* If h/w offloading is available, propagate to the device */
 	if (macsec_is_offloaded(netdev_priv(dev))) {
 		const struct macsec_ops *ops;
@@ -1850,12 +1856,6 @@ static int macsec_add_rxsa(struct sk_buff *skb, struct genl_info *info)
 			goto cleanup;
 	}
 
-	if (secy->xpn) {
-		rx_sa->ssci = nla_get_ssci(tb_sa[MACSEC_SA_ATTR_SSCI]);
-		nla_memcpy(rx_sa->key.salt.bytes, tb_sa[MACSEC_SA_ATTR_SALT],
-			   MACSEC_SALT_LEN);
-	}
-
 	nla_memcpy(rx_sa->key.id, tb_sa[MACSEC_SA_ATTR_KEYID], MACSEC_KEYID_LEN);
 	rcu_assign_pointer(rx_sc->sa[assoc_num], rx_sa);
 
@@ -2070,6 +2070,12 @@ static int macsec_add_txsa(struct sk_buff *skb, struct genl_info *info)
 	if (assoc_num == tx_sc->encoding_sa && tx_sa->active)
 		secy->operational = true;
 
+	if (secy->xpn) {
+		tx_sa->ssci = nla_get_ssci(tb_sa[MACSEC_SA_ATTR_SSCI]);
+		nla_memcpy(tx_sa->key.salt.bytes, tb_sa[MACSEC_SA_ATTR_SALT],
+			   MACSEC_SALT_LEN);
+	}
+
 	/* If h/w offloading is available, propagate to the device */
 	if (macsec_is_offloaded(netdev_priv(dev))) {
 		const struct macsec_ops *ops;
@@ -2092,12 +2098,6 @@ static int macsec_add_txsa(struct sk_buff *skb, struct genl_info *info)
 			goto cleanup;
 	}
 
-	if (secy->xpn) {
-		tx_sa->ssci = nla_get_ssci(tb_sa[MACSEC_SA_ATTR_SSCI]);
-		nla_memcpy(tx_sa->key.salt.bytes, tb_sa[MACSEC_SA_ATTR_SALT],
-			   MACSEC_SALT_LEN);
-	}
-
 	nla_memcpy(tx_sa->key.id, tb_sa[MACSEC_SA_ATTR_KEYID], MACSEC_KEYID_LEN);
 	rcu_assign_pointer(tx_sc->sa[assoc_num], tx_sa);
 
-- 
2.37.3

