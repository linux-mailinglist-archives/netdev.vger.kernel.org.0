Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2BD5E454F38
	for <lists+netdev@lfdr.de>; Wed, 17 Nov 2021 22:21:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232360AbhKQVY0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Nov 2021 16:24:26 -0500
Received: from smtp09.smtpout.orange.fr ([80.12.242.131]:51926 "EHLO
        smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230076AbhKQVYZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Nov 2021 16:24:25 -0500
Received: from pop-os.home ([86.243.171.122])
        by smtp.orange.fr with ESMTPA
        id nSMqmk6KTf6fnnSMrmnmUR; Wed, 17 Nov 2021 22:21:23 +0100
X-ME-Helo: pop-os.home
X-ME-Auth: YWZlNiIxYWMyZDliZWIzOTcwYTEyYzlhMmU3ZiQ1M2U2MzfzZDfyZTMxZTBkMTYyNDBjNDJlZmQ3ZQ==
X-ME-Date: Wed, 17 Nov 2021 22:21:23 +0100
X-ME-IP: 86.243.171.122
From:   Christophe JAILLET <christophe.jaillet@wanadoo.fr>
To:     jesse.brandeburg@intel.com, anthony.l.nguyen@intel.com,
        davem@davemloft.net, kuba@kernel.org
Cc:     intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Subject: [PATCH] ice: Slightly simply ice_find_free_recp_res_idx
Date:   Wed, 17 Nov 2021 22:21:19 +0100
Message-Id: <dc5cd04eed7dd3100f5860acaa995efa40ddecc8.1637183999.git.christophe.jaillet@wanadoo.fr>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The 'possible_idx' bitmap is set just after it is zeroed, so we can save
the first step.

The 'free_idx' bitmap is used only at the end of the function as the
result of a bitmap xor operation. So there is no need to explicitly
zero it before.

So, slightly simply the code and remove 2 useless 'bitmap_zero()' call

Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
---
I don't think it will make any differences in RL. ICE_MAX_FV_WORDS is
just 48 (bits), so 1 or 2 longs
---
 drivers/net/ethernet/intel/ice/ice_switch.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_switch.c b/drivers/net/ethernet/intel/ice/ice_switch.c
index 793f4a9fc2cd..78bfb9fd318d 100644
--- a/drivers/net/ethernet/intel/ice/ice_switch.c
+++ b/drivers/net/ethernet/intel/ice/ice_switch.c
@@ -4071,10 +4071,8 @@ ice_find_free_recp_res_idx(struct ice_hw *hw, const unsigned long *profiles,
 	DECLARE_BITMAP(used_idx, ICE_MAX_FV_WORDS);
 	u16 bit;
 
-	bitmap_zero(possible_idx, ICE_MAX_FV_WORDS);
 	bitmap_zero(recipes, ICE_MAX_NUM_RECIPES);
 	bitmap_zero(used_idx, ICE_MAX_FV_WORDS);
-	bitmap_zero(free_idx, ICE_MAX_FV_WORDS);
 
 	bitmap_set(possible_idx, 0, ICE_MAX_FV_WORDS);
 
-- 
2.30.2

