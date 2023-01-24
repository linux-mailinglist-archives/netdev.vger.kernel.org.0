Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 884AA67977A
	for <lists+netdev@lfdr.de>; Tue, 24 Jan 2023 13:16:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233528AbjAXMQP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Jan 2023 07:16:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233568AbjAXMQI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Jan 2023 07:16:08 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B75B45238;
        Tue, 24 Jan 2023 04:15:53 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id A0A95CE1AAB;
        Tue, 24 Jan 2023 12:15:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 204F8C433EF;
        Tue, 24 Jan 2023 12:15:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674562549;
        bh=RpX7iZkdptF87mKyZHrYIriEZzQuyQXG5qUkXBzQrOg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TcaX6IdH6AEUWngjBLgqsdGFkcPrm3myExN7+YdOGmmoVWkswOcPh8ahoNshqdGeJ
         SAwpYlpg4wDb8eZUfmSa9jXKJ3KzW94kHUrKsHMQ8AzZkw7EqDYprtm2DqjEqHHId0
         TonTleYh6AgUmFbX9qa+pRt9QG2W7rfSML22OsJ0KfubrmEZW67ntAmrM5D9nzSUXr
         UXqag3rVYFL7bf6vMkYS7mG5NSivTfxoteNRY9uQ30W2vUV697fdvUbPuPieeOL0ag
         30Ameqoi39DCpbk6RZX/QIP0GHJfW7bhN36lXz5bF0CLr8rBk/O3h0Le4T+wxlkbes
         ALHW73dpLXTJg==
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
Subject: [PATCH net-next v1 10/10] cxgb4: fill IPsec state validation failure reason
Date:   Tue, 24 Jan 2023 13:55:06 +0200
Message-Id: <26b5ef7f0777cf1c310e21c76442ac45bdb1eb13.1674560845.git.leon@kernel.org>
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
 .../net/ethernet/chelsio/cxgb4/cxgb4_main.c   |  3 +-
 .../inline_crypto/ch_ipsec/chcr_ipsec.c       | 28 +++++++++----------
 2 files changed, 15 insertions(+), 16 deletions(-)

diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c
index 6c0a41f3ae44..7db2403c4c9c 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c
@@ -6497,8 +6497,7 @@ static int cxgb4_xfrm_add_state(struct xfrm_state *x,
 	int ret;
 
 	if (!mutex_trylock(&uld_mutex)) {
-		dev_dbg(adap->pdev_dev,
-			"crypto uld critical resource is under use\n");
+		NL_SET_ERR_MSG_MOD(extack, "crypto uld critical resource is under use");
 		return -EBUSY;
 	}
 	ret = chcr_offload_state(adap, CXGB4_XFRMDEV_OPS);
diff --git a/drivers/net/ethernet/chelsio/inline_crypto/ch_ipsec/chcr_ipsec.c b/drivers/net/ethernet/chelsio/inline_crypto/ch_ipsec/chcr_ipsec.c
index ac2ea6206af1..3731c93f8f95 100644
--- a/drivers/net/ethernet/chelsio/inline_crypto/ch_ipsec/chcr_ipsec.c
+++ b/drivers/net/ethernet/chelsio/inline_crypto/ch_ipsec/chcr_ipsec.c
@@ -234,59 +234,59 @@ static int ch_ipsec_xfrm_add_state(struct xfrm_state *x,
 	int res = 0;
 
 	if (x->props.aalgo != SADB_AALG_NONE) {
-		pr_debug("Cannot offload authenticated xfrm states\n");
+		NL_SET_ERR_MSG_MOD(extack, "Cannot offload authenticated xfrm states");
 		return -EINVAL;
 	}
 	if (x->props.calgo != SADB_X_CALG_NONE) {
-		pr_debug("Cannot offload compressed xfrm states\n");
+		NL_SET_ERR_MSG_MOD(extack, "Cannot offload compressed xfrm states");
 		return -EINVAL;
 	}
 	if (x->props.family != AF_INET &&
 	    x->props.family != AF_INET6) {
-		pr_debug("Only IPv4/6 xfrm state offloaded\n");
+		NL_SET_ERR_MSG_MOD(extack, "Only IPv4/6 xfrm state offloaded");
 		return -EINVAL;
 	}
 	if (x->props.mode != XFRM_MODE_TRANSPORT &&
 	    x->props.mode != XFRM_MODE_TUNNEL) {
-		pr_debug("Only transport and tunnel xfrm offload\n");
+		NL_SET_ERR_MSG_MOD(extack, "Only transport and tunnel xfrm offload");
 		return -EINVAL;
 	}
 	if (x->id.proto != IPPROTO_ESP) {
-		pr_debug("Only ESP xfrm state offloaded\n");
+		NL_SET_ERR_MSG_MOD(extack, "Only ESP xfrm state offloaded");
 		return -EINVAL;
 	}
 	if (x->encap) {
-		pr_debug("Encapsulated xfrm state not offloaded\n");
+		NL_SET_ERR_MSG_MOD(extack, "Encapsulated xfrm state not offloaded");
 		return -EINVAL;
 	}
 	if (!x->aead) {
-		pr_debug("Cannot offload xfrm states without aead\n");
+		NL_SET_ERR_MSG_MOD(extack, "Cannot offload xfrm states without aead");
 		return -EINVAL;
 	}
 	if (x->aead->alg_icv_len != 128 &&
 	    x->aead->alg_icv_len != 96) {
-		pr_debug("Cannot offload xfrm states with AEAD ICV length other than 96b & 128b\n");
-	return -EINVAL;
+		NL_SET_ERR_MSG_MOD(extack, "Cannot offload xfrm states with AEAD ICV length other than 96b & 128b");
+		return -EINVAL;
 	}
 	if ((x->aead->alg_key_len != 128 + 32) &&
 	    (x->aead->alg_key_len != 256 + 32)) {
-		pr_debug("cannot offload xfrm states with AEAD key length other than 128/256 bit\n");
+		NL_SET_ERR_MSG_MOD(extack, "cannot offload xfrm states with AEAD key length other than 128/256 bit");
 		return -EINVAL;
 	}
 	if (x->tfcpad) {
-		pr_debug("Cannot offload xfrm states with tfc padding\n");
+		NL_SET_ERR_MSG_MOD(extack, "Cannot offload xfrm states with tfc padding");
 		return -EINVAL;
 	}
 	if (!x->geniv) {
-		pr_debug("Cannot offload xfrm states without geniv\n");
+		NL_SET_ERR_MSG_MOD(extack, "Cannot offload xfrm states without geniv");
 		return -EINVAL;
 	}
 	if (strcmp(x->geniv, "seqiv")) {
-		pr_debug("Cannot offload xfrm states with geniv other than seqiv\n");
+		NL_SET_ERR_MSG_MOD(extack, "Cannot offload xfrm states with geniv other than seqiv");
 		return -EINVAL;
 	}
 	if (x->xso.type != XFRM_DEV_OFFLOAD_CRYPTO) {
-		pr_debug("Unsupported xfrm offload\n");
+		NL_SET_ERR_MSG_MOD(extack, "Unsupported xfrm offload");
 		return -EINVAL;
 	}
 
-- 
2.39.1

