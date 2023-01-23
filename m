Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6B814677D70
	for <lists+netdev@lfdr.de>; Mon, 23 Jan 2023 15:01:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232091AbjAWOBu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Jan 2023 09:01:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232095AbjAWOBq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Jan 2023 09:01:46 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1740A2798F;
        Mon, 23 Jan 2023 06:01:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6D32560F37;
        Mon, 23 Jan 2023 14:01:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10E01C433EF;
        Mon, 23 Jan 2023 14:01:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674482479;
        bh=QarXgBmFo9Lr1ix7J8WZiX91oF3jhpemgSzB0Bn6K10=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bTwOrd2zcI9ksQxLCUmrMCV5yAAHTB8YtbEMlg7vVQNFLQgPR/f79/UKyUDh9UDOf
         2EuHvzoa+/c60M0kUCDlDO9bIGcRG7b/OCPyc7XnoeQk8rnE+Hc4tt+TzQOd9HBEEd
         CaAd1C+YsB2r/VQzD4x0qcP2yRU9e+M5VdAwx5XNkreAd5PKvSLRa+qRWO1w2/zFZl
         WK2QcJnnC+0lMJdJ41IEZRQIraC4t050iX1w4RUwxkd0twgpjbqnU8ddSbjddBmypW
         m6emc0N3yhYQdNqqhEgMAJQZotfcAqrUlG57C1pChgpaKt9dtrpfW40QCve+Dx+uzE
         zXg9zoUMc8MVQ==
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
Subject: [PATCH net-next 05/10] netdevsim: Fill IPsec state validation failure reason
Date:   Mon, 23 Jan 2023 16:00:18 +0200
Message-Id: <cef36e8974c9eb4f00638dbd6358433261186a62.1674481435.git.leon@kernel.org>
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

