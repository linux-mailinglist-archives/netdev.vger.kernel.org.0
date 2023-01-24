Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 633B5679766
	for <lists+netdev@lfdr.de>; Tue, 24 Jan 2023 13:15:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233472AbjAXMPj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Jan 2023 07:15:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233448AbjAXMPi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Jan 2023 07:15:38 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA29645201;
        Tue, 24 Jan 2023 04:15:32 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id D3644CE1AE2;
        Tue, 24 Jan 2023 12:15:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64974C4339B;
        Tue, 24 Jan 2023 12:15:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674562529;
        bh=tcMiwRJ5LZ16nTM2ZXcPFHoJ273vNAD9QNT1hf7PpJ0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tf12cMDAn6grw+KP2FN5/pkaCe5oJ9gQpLI/1zz0nX55VmccBAwX4L5zVweS8WpV6
         K4GDGpaT+TZXYYNF2a7eEdBnrOt0wadpL/2qPPVqR/YybQT23z9UUnr4eaeUk0YLsF
         GuBd3w++hhC4LACjnXRJGCez7fIoYe24dsZv1euBJiZCcdUKrCsGanBgGLEYcGJSYJ
         v5nhaxxUNHdYaB7wFCN+P3hK9nyYXt2lON4ylE9ueuJzuPceNJP1cg+j5oezpWXbBV
         abrGxSvFLqti+S+s9Tj9yhhKlTDjtEeC4FlRfq7PJkvOMqCGU91aBES3aFWhV9BnZX
         cSkkGYlhLjgEQ==
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
Subject: [PATCH net-next v1 05/10] netdevsim: Fill IPsec state validation failure reason
Date:   Tue, 24 Jan 2023 13:55:01 +0200
Message-Id: <87ca361391c6cc2dcd10e8013836b33ecbe00b57.1674560845.git.leon@kernel.org>
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
 drivers/net/netdevsim/ipsec.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/drivers/net/netdevsim/ipsec.c b/drivers/net/netdevsim/ipsec.c
index 84a02d69abad..f0d58092e7e9 100644
--- a/drivers/net/netdevsim/ipsec.c
+++ b/drivers/net/netdevsim/ipsec.c
@@ -140,25 +140,24 @@ static int nsim_ipsec_add_sa(struct xfrm_state *xs,
 	ipsec = &ns->ipsec;
 
 	if (xs->id.proto != IPPROTO_ESP && xs->id.proto != IPPROTO_AH) {
-		netdev_err(dev, "Unsupported protocol 0x%04x for ipsec offload\n",
-			   xs->id.proto);
+		NL_SET_ERR_MSG_MOD(extack, "Unsupported protocol for ipsec offload");
 		return -EINVAL;
 	}
 
 	if (xs->calg) {
-		netdev_err(dev, "Compression offload not supported\n");
+		NL_SET_ERR_MSG_MOD(extack, "Compression offload not supported");
 		return -EINVAL;
 	}
 
 	if (xs->xso.type != XFRM_DEV_OFFLOAD_CRYPTO) {
-		netdev_err(dev, "Unsupported ipsec offload type\n");
+		NL_SET_ERR_MSG_MOD(extack, "Unsupported ipsec offload type");
 		return -EINVAL;
 	}
 
 	/* find the first unused index */
 	ret = nsim_ipsec_find_empty_idx(ipsec);
 	if (ret < 0) {
-		netdev_err(dev, "No space for SA in Rx table!\n");
+		NL_SET_ERR_MSG_MOD(extack, "No space for SA in Rx table!");
 		return ret;
 	}
 	sa_idx = (u16)ret;
@@ -173,7 +172,7 @@ static int nsim_ipsec_add_sa(struct xfrm_state *xs,
 	/* get the key and salt */
 	ret = nsim_ipsec_parse_proto_keys(xs, sa.key, &sa.salt);
 	if (ret) {
-		netdev_err(dev, "Failed to get key data for SA table\n");
+		NL_SET_ERR_MSG_MOD(extack, "Failed to get key data for SA table");
 		return ret;
 	}
 
-- 
2.39.1

