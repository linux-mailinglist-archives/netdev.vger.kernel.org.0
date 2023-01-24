Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 97E8967976F
	for <lists+netdev@lfdr.de>; Tue, 24 Jan 2023 13:15:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233527AbjAXMPx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Jan 2023 07:15:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233391AbjAXMPr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Jan 2023 07:15:47 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D57045225;
        Tue, 24 Jan 2023 04:15:42 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2C2FB61155;
        Tue, 24 Jan 2023 12:15:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CAD39C433D2;
        Tue, 24 Jan 2023 12:15:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674562541;
        bh=j/LUFLtGTe8h6SuWbBFnx6+OY1rNANjavJbH6/Fbit0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FpcLLTE7debXojcHc8IiLRrjP8hoWhnK9pC9ARBDJveWOoU/evGnB3GItD6H7QJ+b
         xv6PbFME90YHicC1R0NI6cNqBW6HqmWLlfHRr8sn4wDsaM29YYhILkSMYs3b46tfEq
         LALEER1AxBAxJ1TKvGpILrQCX3iMuqKzJrJs0eAqz9hEpFHvyuXQh6OEcmEt6hAoYr
         P9Mp/dqLpwJ49L2mqlS1696/DHbpR1NVAp8qeo1naqXE6q8xmHOW0/Ivc36eOBr2M2
         7Mr1hAbQqY82xkKAHZJ/ZZ3IqbDSsscNM6j2Jkh64ISLQbg6jbOn5lHf4hL2LwKSt+
         2KDUYkLG7mODg==
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
Subject: [PATCH net-next v1 08/10] ixgbe: fill IPsec state validation failure reason
Date:   Tue, 24 Jan 2023 13:55:04 +0200
Message-Id: <4e932956112ee5d80e585c863f31a3ffa6e2dff5.1674560845.git.leon@kernel.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <cover.1674560845.git.leon@kernel.org>
References: <cover.1674560845.git.leon@kernel.org>
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
---
 .../net/ethernet/intel/ixgbe/ixgbe_ipsec.c    | 21 +++++++++----------
 1 file changed, 10 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_ipsec.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_ipsec.c
index 07c37dc619e8..13a6fca31004 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_ipsec.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_ipsec.c
@@ -572,23 +572,22 @@ static int ixgbe_ipsec_add_sa(struct xfrm_state *xs,
 	int i;
 
 	if (xs->id.proto != IPPROTO_ESP && xs->id.proto != IPPROTO_AH) {
-		netdev_err(dev, "Unsupported protocol 0x%04x for ipsec offload\n",
-			   xs->id.proto);
+		NL_SET_ERR_MSG_MOD(extack, "Unsupported protocol for ipsec offload");
 		return -EINVAL;
 	}
 
 	if (xs->props.mode != XFRM_MODE_TRANSPORT) {
-		netdev_err(dev, "Unsupported mode for ipsec offload\n");
+		NL_SET_ERR_MSG_MOD(extack, "Unsupported mode for ipsec offload");
 		return -EINVAL;
 	}
 
 	if (ixgbe_ipsec_check_mgmt_ip(xs)) {
-		netdev_err(dev, "IPsec IP addr clash with mgmt filters\n");
+		NL_SET_ERR_MSG_MOD(extack, "IPsec IP addr clash with mgmt filters");
 		return -EINVAL;
 	}
 
 	if (xs->xso.type != XFRM_DEV_OFFLOAD_CRYPTO) {
-		netdev_err(dev, "Unsupported ipsec offload type\n");
+		NL_SET_ERR_MSG_MOD(extack, "Unsupported ipsec offload type");
 		return -EINVAL;
 	}
 
@@ -596,14 +595,14 @@ static int ixgbe_ipsec_add_sa(struct xfrm_state *xs,
 		struct rx_sa rsa;
 
 		if (xs->calg) {
-			netdev_err(dev, "Compression offload not supported\n");
+			NL_SET_ERR_MSG_MOD(extack, "Compression offload not supported");
 			return -EINVAL;
 		}
 
 		/* find the first unused index */
 		ret = ixgbe_ipsec_find_empty_idx(ipsec, true);
 		if (ret < 0) {
-			netdev_err(dev, "No space for SA in Rx table!\n");
+			NL_SET_ERR_MSG_MOD(extack, "No space for SA in Rx table!");
 			return ret;
 		}
 		sa_idx = (u16)ret;
@@ -618,7 +617,7 @@ static int ixgbe_ipsec_add_sa(struct xfrm_state *xs,
 		/* get the key and salt */
 		ret = ixgbe_ipsec_parse_proto_keys(xs, rsa.key, &rsa.salt);
 		if (ret) {
-			netdev_err(dev, "Failed to get key data for Rx SA table\n");
+			NL_SET_ERR_MSG_MOD(extack, "Failed to get key data for Rx SA table");
 			return ret;
 		}
 
@@ -678,7 +677,7 @@ static int ixgbe_ipsec_add_sa(struct xfrm_state *xs,
 
 		} else {
 			/* no match and no empty slot */
-			netdev_err(dev, "No space for SA in Rx IP SA table\n");
+			NL_SET_ERR_MSG_MOD(extack, "No space for SA in Rx IP SA table");
 			memset(&rsa, 0, sizeof(rsa));
 			return -ENOSPC;
 		}
@@ -713,7 +712,7 @@ static int ixgbe_ipsec_add_sa(struct xfrm_state *xs,
 		/* find the first unused index */
 		ret = ixgbe_ipsec_find_empty_idx(ipsec, false);
 		if (ret < 0) {
-			netdev_err(dev, "No space for SA in Tx table\n");
+			NL_SET_ERR_MSG_MOD(extack, "No space for SA in Tx table");
 			return ret;
 		}
 		sa_idx = (u16)ret;
@@ -727,7 +726,7 @@ static int ixgbe_ipsec_add_sa(struct xfrm_state *xs,
 
 		ret = ixgbe_ipsec_parse_proto_keys(xs, tsa.key, &tsa.salt);
 		if (ret) {
-			netdev_err(dev, "Failed to get key data for Tx SA table\n");
+			NL_SET_ERR_MSG_MOD(extack, "Failed to get key data for Tx SA table");
 			memset(&tsa, 0, sizeof(tsa));
 			return ret;
 		}
-- 
2.39.1

