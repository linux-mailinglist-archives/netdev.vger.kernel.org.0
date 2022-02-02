Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B79B4A6B37
	for <lists+netdev@lfdr.de>; Wed,  2 Feb 2022 06:06:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244721AbiBBFGz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Feb 2022 00:06:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232018AbiBBFGn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Feb 2022 00:06:43 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A2B6C06173B
        for <netdev@vger.kernel.org>; Tue,  1 Feb 2022 21:06:43 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E3452B83014
        for <netdev@vger.kernel.org>; Wed,  2 Feb 2022 05:06:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61642C340EF;
        Wed,  2 Feb 2022 05:06:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643778401;
        bh=z7vzL+i+uK9cGK1Y53/ISdws27w6GM02cmhxHx4fvC8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Hfh2hP1ssbWcngBECEKsvkKOW7dJ8UKvDWXYbhnEkHLGaDWTAykre8hLfjMasNdU9
         8uw2jvq86UWYL3bm2Go1UBBq1SLqmr+2SE0Fc6TGqKZ2usjI2BQkKKKg2IXizrN+Cg
         iinTEIbUSyx99nCL14cYu5tzVtCM8ENDk48fT6MFzPP6lMRMlGOFk25IZNXAT74ALH
         fMtACLeXNLfMLl3heHIg2PdZtdPvaXykhhT48TpOd9hf6d6NETAcXf+QCLWtVnufmG
         zhCQ7c7YLzYeYuEGhjXG8NSQXTVPf6tvCZGS1ZvuayrsTwZi8Pqd0Lj8/GI6M0ClI3
         nP/52TzgEFUbA==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Kees Cook <keescook@chromium.org>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net 17/18] net/mlx5e: Use struct_group() for memcpy() region
Date:   Tue,  1 Feb 2022 21:04:03 -0800
Message-Id: <20220202050404.100122-18-saeed@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220202050404.100122-1-saeed@kernel.org>
References: <20220202050404.100122-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Kees Cook <keescook@chromium.org>

In preparation for FORTIFY_SOURCE performing compile-time and run-time
field bounds checking for memcpy(), memmove(), and memset(), avoid
intentionally writing across neighboring fields.

Use struct_group() in struct vlan_ethhdr around members h_dest and
h_source, so they can be referenced together. This will allow memcpy()
and sizeof() to more easily reason about sizes, improve readability,
and avoid future warnings about writing beyond the end of h_dest.

"pahole" shows no size nor member offset changes to struct vlan_ethhdr.
"objdump -d" shows no object code changes.

Fixes: 34802a42b352 ("net/mlx5e: Do not modify the TX SKB")
Signed-off-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_tx.c | 2 +-
 include/linux/if_vlan.h                         | 6 ++++--
 2 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c
index 7fd33b356cc8..ee7ecb88adc1 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c
@@ -208,7 +208,7 @@ static inline void mlx5e_insert_vlan(void *start, struct sk_buff *skb, u16 ihs)
 	int cpy1_sz = 2 * ETH_ALEN;
 	int cpy2_sz = ihs - cpy1_sz;
 
-	memcpy(vhdr, skb->data, cpy1_sz);
+	memcpy(&vhdr->addrs, skb->data, cpy1_sz);
 	vhdr->h_vlan_proto = skb->vlan_proto;
 	vhdr->h_vlan_TCI = cpu_to_be16(skb_vlan_tag_get(skb));
 	memcpy(&vhdr->h_vlan_encapsulated_proto, skb->data + cpy1_sz, cpy2_sz);
diff --git a/include/linux/if_vlan.h b/include/linux/if_vlan.h
index 8420fe504927..2be4dd7e90a9 100644
--- a/include/linux/if_vlan.h
+++ b/include/linux/if_vlan.h
@@ -46,8 +46,10 @@ struct vlan_hdr {
  *	@h_vlan_encapsulated_proto: packet type ID or len
  */
 struct vlan_ethhdr {
-	unsigned char	h_dest[ETH_ALEN];
-	unsigned char	h_source[ETH_ALEN];
+	struct_group(addrs,
+		unsigned char	h_dest[ETH_ALEN];
+		unsigned char	h_source[ETH_ALEN];
+	);
 	__be16		h_vlan_proto;
 	__be16		h_vlan_TCI;
 	__be16		h_vlan_encapsulated_proto;
-- 
2.34.1

