Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A05616CFDA3
	for <lists+netdev@lfdr.de>; Thu, 30 Mar 2023 10:03:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230033AbjC3IDI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Mar 2023 04:03:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229989AbjC3IDB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Mar 2023 04:03:01 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33E5E19B5
        for <netdev@vger.kernel.org>; Thu, 30 Mar 2023 01:03:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C08D561F15
        for <netdev@vger.kernel.org>; Thu, 30 Mar 2023 08:03:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A72B7C433EF;
        Thu, 30 Mar 2023 08:02:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680163380;
        bh=QmLangSyHAGlJ7U06UIlrZtPMmZnLJd7KBG9veM9zeg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DynM8cfwwZ925zftG7+uqFgWFbI+TFx9zJd/MiOZvpJ+1FfD1HSbPI314q6/IITr+
         tJuJeG3ONUK8AOQZ/YnwUFC15iDRvO9k9OXJOxHKgDP09TYdF+4IpY8EWbBxCKX2zG
         2u1Li8P1BgA9U7VSGsTUwjBm+CXb8LX56/bfpnz+ZwIGj9qG7X0Q8HY/zH449FjRRF
         YMhMqM662agJpwo0oK1or4yYmr76SPkZrcitw1Q/x6jrVBnL/vUhfklyxQqUxSdDI3
         bKi0Tk+e0YL/nXbAVBf8lMzyP0XTwcnQaGN6pGtdsFF7/8z5sxs0Ctk8lLh4337yJr
         tmQNzgWb8O/Fw==
From:   Leon Romanovsky <leon@kernel.org>
To:     Paolo Abeni <pabeni@redhat.com>, Jakub Kicinski <kuba@kernel.org>,
        "David S . Miller" <davem@davemloft.net>
Cc:     Leon Romanovsky <leonro@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        linux-netdev <netdev@vger.kernel.org>,
        Raed Salem <raeds@nvidia.com>,
        Eric Dumazet <edumazet@google.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Steffen Klassert <steffen.klassert@secunet.com>
Subject: [PATCH net-next 02/10] net/mlx5e: Prevent zero IPsec soft/hard limits
Date:   Thu, 30 Mar 2023 11:02:23 +0300
Message-Id: <80d0ba33e21fb28b1b91d306d1da39df3d990b68.1680162300.git.leonro@nvidia.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <cover.1680162300.git.leonro@nvidia.com>
References: <cover.1680162300.git.leonro@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Leon Romanovsky <leonro@nvidia.com>

Hardware triggers limit events when the packets arrive and are processed
through the device. In case zero was configured as a limit, the HW won't
be able to arm event as it happens at the end of execution pipeline.

Let's prevent such configuration.

Reviewed-by: Raed Salem <raeds@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
index 91fa0a366316..c2e4f30d1f76 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
@@ -283,6 +283,11 @@ static int mlx5e_xfrm_validate_state(struct mlx5_core_dev *mdev,
 			NL_SET_ERR_MSG_MOD(extack, "Hard packet limit must be greater than soft one");
 			return -EINVAL;
 		}
+
+		if (!x->lft.soft_packet_limit || !x->lft.hard_packet_limit) {
+			NL_SET_ERR_MSG_MOD(extack, "Soft/hard packet limits can't be 0");
+			return -EINVAL;
+		}
 		break;
 	default:
 		NL_SET_ERR_MSG_MOD(extack, "Unsupported xfrm offload type");
-- 
2.39.2

