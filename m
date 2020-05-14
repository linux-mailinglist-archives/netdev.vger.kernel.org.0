Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB76F1D3B2D
	for <lists+netdev@lfdr.de>; Thu, 14 May 2020 21:05:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729538AbgENSz5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 May 2020 14:55:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:56706 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729525AbgENSz4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 14 May 2020 14:55:56 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 99BFA207E8;
        Thu, 14 May 2020 18:55:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589482555;
        bh=QN7DanSw/R5a5ejEmnces8IxIoCcRieV2B+iz4eTOR8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Sxr80rahmF7dihLT4N3DSEunJ08o0767LUYdnxdTzuiRRbG+mBj6Wi7RmFMqzXIRn
         M7MuHflavdaJTixZ1B5ursk1TEPsPBI18zS8xLxI1Hx33az7RGCAOjYLj36depngSA
         vDMjug72tEqqLdNx4qXcSAKHKeXtGYf7yDahWBrs=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     George Spelvin <lkml@sdf.org>, Sven Eckelmann <sven@narfation.org>,
        Simon Wunderlich <sw@simonwunderlich.de>,
        Sasha Levin <sashal@kernel.org>,
        b.a.t.m.a.n@lists.open-mesh.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 04/27] batman-adv: fix batadv_nc_random_weight_tq
Date:   Thu, 14 May 2020 14:55:27 -0400
Message-Id: <20200514185550.21462-4-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200514185550.21462-1-sashal@kernel.org>
References: <20200514185550.21462-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: George Spelvin <lkml@sdf.org>

[ Upstream commit fd0c42c4dea54335967c5a86f15fc064235a2797 ]

and change to pseudorandom numbers, as this is a traffic dithering
operation that doesn't need crypto-grade.

The previous code operated in 4 steps:

1. Generate a random byte 0 <= rand_tq <= 255
2. Multiply it by BATADV_TQ_MAX_VALUE - tq
3. Divide by 255 (= BATADV_TQ_MAX_VALUE)
4. Return BATADV_TQ_MAX_VALUE - rand_tq

This would apperar to scale (BATADV_TQ_MAX_VALUE - tq) by a random
value between 0/255 and 255/255.

But!  The intermediate value between steps 3 and 4 is stored in a u8
variable.  So it's truncated, and most of the time, is less than 255, after
which the division produces 0.  Specifically, if tq is odd, the product is
always even, and can never be 255.  If tq is even, there's exactly one
random byte value that will produce a product byte of 255.

Thus, the return value is 255 (511/512 of the time) or 254 (1/512
of the time).

If we assume that the truncation is a bug, and the code is meant to scale
the input, a simpler way of looking at it is that it's returning a random
value between tq and BATADV_TQ_MAX_VALUE, inclusive.

Well, we have an optimized function for doing just that.

Fixes: 3c12de9a5c75 ("batman-adv: network coding - code and transmit packets if possible")
Signed-off-by: George Spelvin <lkml@sdf.org>
Signed-off-by: Sven Eckelmann <sven@narfation.org>
Signed-off-by: Simon Wunderlich <sw@simonwunderlich.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/batman-adv/network-coding.c | 9 +--------
 1 file changed, 1 insertion(+), 8 deletions(-)

diff --git a/net/batman-adv/network-coding.c b/net/batman-adv/network-coding.c
index a7b5cf08d3630..09549885cd147 100644
--- a/net/batman-adv/network-coding.c
+++ b/net/batman-adv/network-coding.c
@@ -1012,15 +1012,8 @@ static struct batadv_nc_path *batadv_nc_get_path(struct batadv_priv *bat_priv,
  */
 static u8 batadv_nc_random_weight_tq(u8 tq)
 {
-	u8 rand_val, rand_tq;
-
-	get_random_bytes(&rand_val, sizeof(rand_val));
-
 	/* randomize the estimated packet loss (max TQ - estimated TQ) */
-	rand_tq = rand_val * (BATADV_TQ_MAX_VALUE - tq);
-
-	/* normalize the randomized packet loss */
-	rand_tq /= BATADV_TQ_MAX_VALUE;
+	u8 rand_tq = prandom_u32_max(BATADV_TQ_MAX_VALUE + 1 - tq);
 
 	/* convert to (randomized) estimated tq again */
 	return BATADV_TQ_MAX_VALUE - rand_tq;
-- 
2.20.1

