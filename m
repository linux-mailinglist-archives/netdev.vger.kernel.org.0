Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0BB6A66391F
	for <lists+netdev@lfdr.de>; Tue, 10 Jan 2023 07:12:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229952AbjAJGMm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Jan 2023 01:12:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230361AbjAJGMI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Jan 2023 01:12:08 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82F8043DA5
        for <netdev@vger.kernel.org>; Mon,  9 Jan 2023 22:11:52 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EDD81B81114
        for <netdev@vger.kernel.org>; Tue, 10 Jan 2023 06:11:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8310BC433EF;
        Tue, 10 Jan 2023 06:11:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673331109;
        bh=bjrhiK+vaZg4iVsXupldSBQ1hTV2x8Hy5WVJRw6MjEY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Z/3skOsbNExStNPRdvg5G+AeUGTM8CCAoPyjtZEEP90fe1AnkDc03UAdiv56Bl+cM
         Z9aIls/lkQjgzI/+pa554dtw84BhRTwH9OsspRkhp8nQ+7kpu0QDy4AnWKEA9f+s1k
         pMt31UZowGPS0ao0zt4xqk6rPyGXSxlyPU3HU9GbzPn/+pryM03opx4nteZb+ra8Ct
         R3iD21EiYsGMZ9XOsS5lPAaJSF7q9Gi9rfGnATJCcVlpWw0/ME+0i6C9NE7655aMah
         G1Qp/jnbu62mNX1u14aosBCQJciVBofAMSWof/8UMbjZHFOdqQYL5vV8631hXw24kn
         bnYadJdX0i+GQ==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>, Gavin Li <gavinl@nvidia.com>,
        Maor Dickman <maord@nvidia.com>
Subject: [net 13/16] net/mlx5e: Don't support encap rules with gbp option
Date:   Mon,  9 Jan 2023 22:11:20 -0800
Message-Id: <20230110061123.338427-14-saeed@kernel.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230110061123.338427-1-saeed@kernel.org>
References: <20230110061123.338427-1-saeed@kernel.org>
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

From: Gavin Li <gavinl@nvidia.com>

Previously, encap rules with gbp option would be offloaded by mistake but
driver does not support gbp option offload.

To fix this issue, check if the encap rule has gbp option and don't
offload the rule

Fixes: d8f9dfae49ce ("net: sched: allow flower to match vxlan options")
Signed-off-by: Gavin Li <gavinl@nvidia.com>
Reviewed-by: Maor Dickman <maord@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_vxlan.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_vxlan.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_vxlan.c
index fd07c4cbfd1d..1f62c702b625 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_vxlan.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_vxlan.c
@@ -88,6 +88,8 @@ static int mlx5e_gen_ip_tunnel_header_vxlan(char buf[],
 	struct udphdr *udp = (struct udphdr *)(buf);
 	struct vxlanhdr *vxh;
 
+	if (tun_key->tun_flags & TUNNEL_VXLAN_OPT)
+		return -EOPNOTSUPP;
 	vxh = (struct vxlanhdr *)((char *)udp + sizeof(struct udphdr));
 	*ip_proto = IPPROTO_UDP;
 
-- 
2.39.0

