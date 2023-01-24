Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C60E2679774
	for <lists+netdev@lfdr.de>; Tue, 24 Jan 2023 13:16:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233564AbjAXMQG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Jan 2023 07:16:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233542AbjAXMP7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Jan 2023 07:15:59 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A616457DD;
        Tue, 24 Jan 2023 04:15:48 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2ACE7B81142;
        Tue, 24 Jan 2023 12:15:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0EDC1C4339B;
        Tue, 24 Jan 2023 12:15:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674562545;
        bh=zun5JgndHtJIzbIsz3B4MBY+SwvMGsLucQPZaw1nVtE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bzXc1VnMqRelQRqJN5SiPSywszwi7j7elU1wP0YQU0JkjFCZ+YeG1N6r0fFJuSJYe
         3HIROMxUBuVZg4XUcciC49ApZqqSVm2MOaef0s0oJ11a2MBHS0BX8N94gm8aVfRpj7
         g1OHW1DcYAATx9zWSAZbOQfzgEFlgW8NMbiPwpnZv/rwWgWEyfR8lqW1UG31EvE30N
         ZwIjNRyjNH9lnPa3pbAsjBqQ9OcQQP9iTF2UIm1lTOG/JtzPpzkLjS9Dif3Fl233Ac
         Zr5K8nMPF2sedx7ga1AG96Q3XpSH6dp52LcpWPPiqk/bQ7ORdxflFSF+43lSME87m8
         dcLmMpJp0nRNQ==
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
Subject: [PATCH net-next v1 06/10] nfp: fill IPsec state validation failure reason
Date:   Tue, 24 Jan 2023 13:55:02 +0200
Message-Id: <3acc2d1ac500ddf10d44176075f77b59803f16de.1674560845.git.leon@kernel.org>
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

Reviewed-by: Simon Horman <simon.horman@corigine.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 .../net/ethernet/netronome/nfp/crypto/ipsec.c | 38 +++++++++----------
 1 file changed, 19 insertions(+), 19 deletions(-)

diff --git a/drivers/net/ethernet/netronome/nfp/crypto/ipsec.c b/drivers/net/ethernet/netronome/nfp/crypto/ipsec.c
index 41b98f2b7402..b44263177981 100644
--- a/drivers/net/ethernet/netronome/nfp/crypto/ipsec.c
+++ b/drivers/net/ethernet/netronome/nfp/crypto/ipsec.c
@@ -282,7 +282,7 @@ static int nfp_net_xfrm_add_state(struct xfrm_state *x,
 		cfg->ctrl_word.mode = NFP_IPSEC_PROTMODE_TRANSPORT;
 		break;
 	default:
-		nn_err(nn, "Unsupported mode for xfrm offload\n");
+		NL_SET_ERR_MSG_MOD(extack, "Unsupported mode for xfrm offload");
 		return -EINVAL;
 	}
 
@@ -294,17 +294,17 @@ static int nfp_net_xfrm_add_state(struct xfrm_state *x,
 		cfg->ctrl_word.proto = NFP_IPSEC_PROTOCOL_AH;
 		break;
 	default:
-		nn_err(nn, "Unsupported protocol for xfrm offload\n");
+		NL_SET_ERR_MSG_MOD(extack, "Unsupported protocol for xfrm offload");
 		return -EINVAL;
 	}
 
 	if (x->props.flags & XFRM_STATE_ESN) {
-		nn_err(nn, "Unsupported XFRM_REPLAY_MODE_ESN for xfrm offload\n");
+		NL_SET_ERR_MSG_MOD(extack, "Unsupported XFRM_REPLAY_MODE_ESN for xfrm offload");
 		return -EINVAL;
 	}
 
 	if (x->xso.type != XFRM_DEV_OFFLOAD_CRYPTO) {
-		nn_err(nn, "Unsupported xfrm offload tyoe\n");
+		NL_SET_ERR_MSG_MOD(extack, "Unsupported xfrm offload type");
 		return -EINVAL;
 	}
 
@@ -321,7 +321,7 @@ static int nfp_net_xfrm_add_state(struct xfrm_state *x,
 		if (x->aead) {
 			trunc_len = -1;
 		} else {
-			nn_err(nn, "Unsupported authentication algorithm\n");
+			NL_SET_ERR_MSG_MOD(extack, "Unsupported authentication algorithm");
 			return -EINVAL;
 		}
 		break;
@@ -345,19 +345,19 @@ static int nfp_net_xfrm_add_state(struct xfrm_state *x,
 		set_sha2_512hmac(cfg, &trunc_len);
 		break;
 	default:
-		nn_err(nn, "Unsupported authentication algorithm\n");
+		NL_SET_ERR_MSG_MOD(extack, "Unsupported authentication algorithm");
 		return -EINVAL;
 	}
 
 	if (!trunc_len) {
-		nn_err(nn, "Unsupported authentication algorithm trunc length\n");
+		NL_SET_ERR_MSG_MOD(extack, "Unsupported authentication algorithm trunc length");
 		return -EINVAL;
 	}
 
 	if (x->aalg) {
 		key_len = DIV_ROUND_UP(x->aalg->alg_key_len, BITS_PER_BYTE);
 		if (key_len > sizeof(cfg->auth_key)) {
-			nn_err(nn, "Insufficient space for offloaded auth key\n");
+			NL_SET_ERR_MSG_MOD(extack, "Insufficient space for offloaded auth key");
 			return -EINVAL;
 		}
 		for (i = 0; i < key_len / sizeof(cfg->auth_key[0]) ; i++)
@@ -379,12 +379,12 @@ static int nfp_net_xfrm_add_state(struct xfrm_state *x,
 	case SADB_X_EALG_AES_GCM_ICV16:
 	case SADB_X_EALG_NULL_AES_GMAC:
 		if (!x->aead) {
-			nn_err(nn, "Invalid AES key data\n");
+			NL_SET_ERR_MSG_MOD(extack, "Invalid AES key data");
 			return -EINVAL;
 		}
 
 		if (x->aead->alg_icv_len != 128) {
-			nn_err(nn, "ICV must be 128bit with SADB_X_EALG_AES_GCM_ICV16\n");
+			NL_SET_ERR_MSG_MOD(extack, "ICV must be 128bit with SADB_X_EALG_AES_GCM_ICV16");
 			return -EINVAL;
 		}
 		cfg->ctrl_word.cimode = NFP_IPSEC_CIMODE_CTR;
@@ -392,23 +392,23 @@ static int nfp_net_xfrm_add_state(struct xfrm_state *x,
 
 		/* Aead->alg_key_len includes 32-bit salt */
 		if (set_aes_keylen(cfg, x->props.ealgo, x->aead->alg_key_len - 32)) {
-			nn_err(nn, "Unsupported AES key length %d\n", x->aead->alg_key_len);
+			NL_SET_ERR_MSG_MOD(extack, "Unsupported AES key length");
 			return -EINVAL;
 		}
 		break;
 	case SADB_X_EALG_AESCBC:
 		cfg->ctrl_word.cimode = NFP_IPSEC_CIMODE_CBC;
 		if (!x->ealg) {
-			nn_err(nn, "Invalid AES key data\n");
+			NL_SET_ERR_MSG_MOD(extack, "Invalid AES key data");
 			return -EINVAL;
 		}
 		if (set_aes_keylen(cfg, x->props.ealgo, x->ealg->alg_key_len) < 0) {
-			nn_err(nn, "Unsupported AES key length %d\n", x->ealg->alg_key_len);
+			NL_SET_ERR_MSG_MOD(extack, "Unsupported AES key length");
 			return -EINVAL;
 		}
 		break;
 	default:
-		nn_err(nn, "Unsupported encryption algorithm for offload\n");
+		NL_SET_ERR_MSG_MOD(extack, "Unsupported encryption algorithm for offload");
 		return -EINVAL;
 	}
 
@@ -419,7 +419,7 @@ static int nfp_net_xfrm_add_state(struct xfrm_state *x,
 		key_len -= salt_len;
 
 		if (key_len > sizeof(cfg->ciph_key)) {
-			nn_err(nn, "aead: Insufficient space for offloaded key\n");
+			NL_SET_ERR_MSG_MOD(extack, "aead: Insufficient space for offloaded key");
 			return -EINVAL;
 		}
 
@@ -435,7 +435,7 @@ static int nfp_net_xfrm_add_state(struct xfrm_state *x,
 		key_len = DIV_ROUND_UP(x->ealg->alg_key_len, BITS_PER_BYTE);
 
 		if (key_len > sizeof(cfg->ciph_key)) {
-			nn_err(nn, "ealg: Insufficient space for offloaded key\n");
+			NL_SET_ERR_MSG_MOD(extack, "ealg: Insufficient space for offloaded key");
 			return -EINVAL;
 		}
 		for (i = 0; i < key_len / sizeof(cfg->ciph_key[0]) ; i++)
@@ -458,7 +458,7 @@ static int nfp_net_xfrm_add_state(struct xfrm_state *x,
 		}
 		break;
 	default:
-		nn_err(nn, "Unsupported address family\n");
+		NL_SET_ERR_MSG_MOD(extack, "Unsupported address family");
 		return -EINVAL;
 	}
 
@@ -473,7 +473,7 @@ static int nfp_net_xfrm_add_state(struct xfrm_state *x,
 	err = xa_alloc(&nn->xa_ipsec, &saidx, x,
 		       XA_LIMIT(0, NFP_NET_IPSEC_MAX_SA_CNT - 1), GFP_KERNEL);
 	if (err < 0) {
-		nn_err(nn, "Unable to get sa_data number for IPsec\n");
+		NL_SET_ERR_MSG_MOD(extack, "Unable to get sa_data number for IPsec");
 		return err;
 	}
 
@@ -481,7 +481,7 @@ static int nfp_net_xfrm_add_state(struct xfrm_state *x,
 	err = nfp_ipsec_cfg_cmd_issue(nn, NFP_IPSEC_CFG_MSSG_ADD_SA, saidx, &msg);
 	if (err) {
 		xa_erase(&nn->xa_ipsec, saidx);
-		nn_err(nn, "Failed to issue IPsec command err ret=%d\n", err);
+		NL_SET_ERR_MSG_MOD(extack, "Failed to issue IPsec command");
 		return err;
 	}
 
-- 
2.39.1

