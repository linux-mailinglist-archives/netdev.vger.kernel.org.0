Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5399B677D74
	for <lists+netdev@lfdr.de>; Mon, 23 Jan 2023 15:01:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232101AbjAWOBz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Jan 2023 09:01:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232097AbjAWOBx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Jan 2023 09:01:53 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3802A2412A;
        Mon, 23 Jan 2023 06:01:30 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C16D260F2F;
        Mon, 23 Jan 2023 14:01:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F83AC433D2;
        Mon, 23 Jan 2023 14:01:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674482489;
        bh=GleyYOFN9Inb6Jktq6moCT30z9tyU4vJ+NL054LW1jU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hLzwgeiqh9Ldxq4BxKziSWVt6KJ8tY1sgy/nUMu4M3KU2+4JMgghLjmEnXPeNN5l/
         SeIUj/93r6bwrnvbNeO1R/kCVqAdVxbExJkj60CRALCW2TTOrTlqFHzN9GYiDGUyVb
         av1spA4CmkOpmwgCTfWAPGBOrA+HHMzJKZ+ddNtJGYBSzwdB5Zn4G2Ojff1hhtzp4Q
         Lh/Lynu78AuHrYa1Z4/LTbyH6NMr3IA5qHIV/G54QuqTG7nUs2GduohbmkA5womajB
         65t15xOk7RbsmFIevn7PXQBqbgRfLAMCZPBN/Mmv5Jn3h+9yXKnb07HAWvyB/8455a
         +zaSVoXMQ332A==
From:   Leon Romanovsky <leon@kernel.org>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Steffen Klassert <steffen.klassert@secunet.com>
Cc:     Leon Romanovsky <leonro@nvidia.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        Ayush Sawal <ayush.sawal@chelsio.com>,
        Eric Dumazet <edumazet@google.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        intel-wired-lan@lists.osuosl.org,
        Jay Vosburgh <j.vosburgh@gmail.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org,
        netdev@vger.kernel.org, oss-drivers@corigine.com,
        Paolo Abeni <pabeni@redhat.com>,
        Raju Rangoju <rajur@chelsio.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Simon Horman <simon.horman@corigine.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Veaceslav Falico <vfalico@gmail.com>
Subject: [PATCH net-next 07/10] ixgbevf: fill IPsec state validation failure reason
Date:   Mon, 23 Jan 2023 16:00:20 +0200
Message-Id: <7266423af6d87245a9c6b6b6e5e4383738546d35.1674481435.git.leon@kernel.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <cover.1674481435.git.leon@kernel.org>
References: <cover.1674481435.git.leon@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Leon Romanovsky <leonro@nvidia.com>

Rely on extack to return failure reason.

Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: Leon Romanovsky <leon@kernel.org>
---
 drivers/net/ethernet/intel/ixgbevf/ipsec.c | 17 ++++++++---------
 1 file changed, 8 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/intel/ixgbevf/ipsec.c b/drivers/net/ethernet/intel/ixgbevf/ipsec.c
index 752b9df4fb51..66cf17f19408 100644
--- a/drivers/net/ethernet/intel/ixgbevf/ipsec.c
+++ b/drivers/net/ethernet/intel/ixgbevf/ipsec.c
@@ -272,18 +272,17 @@ static int ixgbevf_ipsec_add_sa(struct xfrm_state *xs,
 	ipsec = adapter->ipsec;
 
 	if (xs->id.proto != IPPROTO_ESP && xs->id.proto != IPPROTO_AH) {
-		netdev_err(dev, "Unsupported protocol 0x%04x for IPsec offload\n",
-			   xs->id.proto);
+		NL_SET_ERR_MSG_MOD(extack, "Unsupported protocol for IPsec offload");
 		return -EINVAL;
 	}
 
 	if (xs->props.mode != XFRM_MODE_TRANSPORT) {
-		netdev_err(dev, "Unsupported mode for ipsec offload\n");
+		NL_SET_ERR_MSG_MOD(extack, "Unsupported mode for ipsec offload");
 		return -EINVAL;
 	}
 
 	if (xs->xso.type != XFRM_DEV_OFFLOAD_CRYPTO) {
-		netdev_err(dev, "Unsupported ipsec offload type\n");
+		NL_SET_ERR_MSG_MOD(extack, "Unsupported ipsec offload type");
 		return -EINVAL;
 	}
 
@@ -291,14 +290,14 @@ static int ixgbevf_ipsec_add_sa(struct xfrm_state *xs,
 		struct rx_sa rsa;
 
 		if (xs->calg) {
-			netdev_err(dev, "Compression offload not supported\n");
+			NL_SET_ERR_MSG_MOD(extack, "Compression offload not supported");
 			return -EINVAL;
 		}
 
 		/* find the first unused index */
 		ret = ixgbevf_ipsec_find_empty_idx(ipsec, true);
 		if (ret < 0) {
-			netdev_err(dev, "No space for SA in Rx table!\n");
+			NL_SET_ERR_MSG_MOD(extack, "No space for SA in Rx table!");
 			return ret;
 		}
 		sa_idx = (u16)ret;
@@ -313,7 +312,7 @@ static int ixgbevf_ipsec_add_sa(struct xfrm_state *xs,
 		/* get the key and salt */
 		ret = ixgbevf_ipsec_parse_proto_keys(xs, rsa.key, &rsa.salt);
 		if (ret) {
-			netdev_err(dev, "Failed to get key data for Rx SA table\n");
+			NL_SET_ERR_MSG_MOD(extack, "Failed to get key data for Rx SA table");
 			return ret;
 		}
 
@@ -352,7 +351,7 @@ static int ixgbevf_ipsec_add_sa(struct xfrm_state *xs,
 		/* find the first unused index */
 		ret = ixgbevf_ipsec_find_empty_idx(ipsec, false);
 		if (ret < 0) {
-			netdev_err(dev, "No space for SA in Tx table\n");
+			NL_SET_ERR_MSG_MOD(extack, "No space for SA in Tx table");
 			return ret;
 		}
 		sa_idx = (u16)ret;
@@ -366,7 +365,7 @@ static int ixgbevf_ipsec_add_sa(struct xfrm_state *xs,
 
 		ret = ixgbevf_ipsec_parse_proto_keys(xs, tsa.key, &tsa.salt);
 		if (ret) {
-			netdev_err(dev, "Failed to get key data for Tx SA table\n");
+			NL_SET_ERR_MSG_MOD(extack, "Failed to get key data for Tx SA table");
 			memset(&tsa, 0, sizeof(tsa));
 			return ret;
 		}
-- 
2.39.1

