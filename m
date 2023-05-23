Return-Path: <netdev+bounces-4537-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id E61E670D342
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 07:43:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B64781C20C88
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 05:43:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BF34E1C743;
	Tue, 23 May 2023 05:42:56 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C6FF1B8FB
	for <netdev@vger.kernel.org>; Tue, 23 May 2023 05:42:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52E2EC433A4;
	Tue, 23 May 2023 05:42:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1684820575;
	bh=8PxXyfAGRtErlXIUcijpiHQycAdYxBy17NSdgEDOziA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GF231bWqMM5M+p+yFaTk/2vpUOxcVqanHPyqAEqMR6fQIZTlfzyK1KCuwgLTT45fF
	 yHp2oRIxKNz7CY3G0uEo7eh8XNSOcKu5kJWRcZufUZLC7sxC/L88c3Q3eUlJdaDuHy
	 WEN6wEaPiOnciVptEIp+w8KB5eAyGt1Gt63XkKvEsKHamdm0KOWojo00YzHLLB0y/v
	 tTmeON4x8OfaVrxDJ3jBIuMn6x/BpropSIAGFdXzus06IrL5rmTPq2BL2JGur+KJ47
	 FOJd3+i192cNRp3W76ihAq703Tiev4EpMqxBwfJHurx6+8qNMgyUb6kkGjbbNfFoL6
	 kvcf6oD8yKApg==
From: Saeed Mahameed <saeed@kernel.org>
To: "David S. Miller" <davem@davemloft.net>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Eric Dumazet <edumazet@google.com>
Cc: Saeed Mahameed <saeedm@nvidia.com>,
	netdev@vger.kernel.org,
	Tariq Toukan <tariqt@nvidia.com>,
	Erez Shitrit <erezsh@nvidia.com>,
	Alex Vesker <valex@nvidia.com>
Subject: [net 03/15] net/mlx5: DR, Fix crc32 calculation to work on big-endian (BE) CPUs
Date: Mon, 22 May 2023 22:42:30 -0700
Message-Id: <20230523054242.21596-4-saeed@kernel.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230523054242.21596-1-saeed@kernel.org>
References: <20230523054242.21596-1-saeed@kernel.org>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Erez Shitrit <erezsh@nvidia.com>

When calculating crc for hash index we use the function crc32 that
calculates for little-endian (LE) arch.
Then we convert it to network endianness using htonl(), but it's wrong
to do the conversion in BE archs since the crc32 value is already LE.

The solution is to switch the bytes from the crc result for all types
of arc.

Fixes: 40416d8ede65 ("net/mlx5: DR, Replace CRC32 implementation to use kernel lib")
Signed-off-by: Erez Shitrit <erezsh@nvidia.com>
Reviewed-by: Alex Vesker <valex@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste.c
index 9413aaf51251..e94fbb015efa 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste.c
@@ -15,7 +15,8 @@ static u32 dr_ste_crc32_calc(const void *input_data, size_t length)
 {
 	u32 crc = crc32(0, input_data, length);
 
-	return (__force u32)htonl(crc);
+	return (__force u32)((crc >> 24) & 0xff) | ((crc << 8) & 0xff0000) |
+			    ((crc >> 8) & 0xff00) | ((crc << 24) & 0xff000000);
 }
 
 bool mlx5dr_ste_supp_ttl_cs_recalc(struct mlx5dr_cmd_caps *caps)
-- 
2.40.1


