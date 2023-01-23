Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6B432677D7F
	for <lists+netdev@lfdr.de>; Mon, 23 Jan 2023 15:02:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232131AbjAWOC3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Jan 2023 09:02:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231718AbjAWOC2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Jan 2023 09:02:28 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7F162684B;
        Mon, 23 Jan 2023 06:02:05 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7701E60F23;
        Mon, 23 Jan 2023 14:02:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1610C4339B;
        Mon, 23 Jan 2023 14:02:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674482524;
        bh=2koP5//xkTzgsmmy1BbG7loZjicRFY5VECy1fq44Znk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sdg/4hdLhpt0u5h21aNc22vUYBxPWpOwMUqjEfjhM+OnOVc+soJhjuZT3kKxtTmay
         jHfCgDhM5NNam5YWMdhNF4DSzS091ErMxhpw8yENde+tLMp+OXcAUPxQmn7+aCFOij
         VBfUVPlKzadzzN5crJoCEpead39kBfHQ8dXoGQAiozWuR7RZfLbDsYgiPudru+9fqD
         OCXuRM/JZHDEK1Kyn0damGAfhpdqbBT8KfNHIrP9TbWbwis4EkLGTYxz/1tkmkLjAI
         9FZ9X7rGtHrPLu5MWvtdunG5xEAfVmQczv1h/HlFU9rYmTkCuSDTOmC3pWc4kF8Zvn
         iLli68aWkXFTQ==
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
Subject: [PATCH net-next 10/10] cxgb4: fill IPsec state validation failure reason
Date:   Mon, 23 Jan 2023 16:00:23 +0200
Message-Id: <9b45993fb96b6faa2b65f3dd78e677a54eeeec31.1674481435.git.leon@kernel.org>
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
index ac2ea6206af1..98222b67d036 100644
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
+		NL_SET_ERR_MSG_MOD("Cannot offload xfrm states without aead");
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

