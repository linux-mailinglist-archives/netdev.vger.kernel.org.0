Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 04B70677D7A
	for <lists+netdev@lfdr.de>; Mon, 23 Jan 2023 15:02:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232129AbjAWOCL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Jan 2023 09:02:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232120AbjAWOCL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Jan 2023 09:02:11 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5179274A8;
        Mon, 23 Jan 2023 06:01:49 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 282B9B80DC5;
        Mon, 23 Jan 2023 14:01:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02352C4339C;
        Mon, 23 Jan 2023 14:01:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674482506;
        bh=MdgE76ZIYPnwnpIjo3cBmycH+MxEMGlO/hmvEyoi2dI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tM/3twtKfrge9uvR1dy955kGQxion90wQEAMzHF6sGxK1tX13VUvDHXB3f5IlEeJA
         iCDhitkHJq22Oj1KMmXHvvFICMOo3L66SwmSOAgIb57qT5KJOG/upioQnzKa0Nmbee
         HnmU+HiXz8tm62j/88t27PaYY0tA32T3xaRTdvXdA3353+m6FcZmia4FJ3qySFBfow
         OxIFkGUr8I0CjJZGVyN2bdei0u4WuVj/uslOozZNmlSXdDWcZO/1Wl4Vc73kMVTrIt
         +erqFLC/5oDmjdr5H/oG90yem+Gayp9m5lq5CSBWThkn2H3mxTZt9cC0IQxUqf68mI
         zuiT+US7/Puhg==
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
Subject: [PATCH net-next 08/10] ixgbe: fill IPsec state validation failure reason
Date:   Mon, 23 Jan 2023 16:00:21 +0200
Message-Id: <09357c6f977e38179a717c5957004ecc4ded2713.1674481435.git.leon@kernel.org>
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

