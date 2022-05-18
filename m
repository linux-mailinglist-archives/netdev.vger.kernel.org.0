Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 94CC952BA84
	for <lists+netdev@lfdr.de>; Wed, 18 May 2022 14:39:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236872AbiERMdQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 May 2022 08:33:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236803AbiERMcs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 May 2022 08:32:48 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A21655DA59;
        Wed, 18 May 2022 05:29:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 00BB96164C;
        Wed, 18 May 2022 12:28:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1499DC385AA;
        Wed, 18 May 2022 12:28:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652876912;
        bh=IUN29lJ+JAwPbvxgjq8dqn4ODUTyFTt6/A5kJgrGy2w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EKVPJ26QzvGYxde8mGPji/q82kmOJoyS6MPQqckY/K6vZSmFOd+Ed1kkgxD8BDj1g
         rkYKqzXB4VL40LQFdYNGZLok1ooLzritr5NHRE5suCgarMnQQ10lvCJC4EaJAS7jii
         O6M1HIsRPJXthLjhuRqsGi/agOKSevdlKW+uDf5kzwwL2aABLdxt2EQDs1ynbkXUQ7
         Krzue4Rybgyr1ASQ12K5r9eWEcVGOQl+/Cuxf8Ea41kO48cM8DX/fNadaXOdsl3+mI
         +QQ4yxNnkYkqgyKuo2EpekmwZ/e86wmL6oXw+RkCYNCcQJ9Zgm1AJWoZsrlY1hgK0l
         IT7LARBt9csdw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Grant Grundler <grundler@chromium.org>,
        Aashay Shringarpure <aashay@google.com>,
        Yi Chou <yich@google.com>,
        Shervin Oloumi <enlightened@google.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, irusskikh@marvell.com,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 15/17] net: atlantic: verify hw_head_ lies within TX buffer ring
Date:   Wed, 18 May 2022 08:27:49 -0400
Message-Id: <20220518122753.342758-15-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220518122753.342758-1-sashal@kernel.org>
References: <20220518122753.342758-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Grant Grundler <grundler@chromium.org>

[ Upstream commit 2120b7f4d128433ad8c5f503a9584deba0684901 ]

Bounds check hw_head index provided by NIC to verify it lies
within the TX buffer ring.

Reported-by: Aashay Shringarpure <aashay@google.com>
Reported-by: Yi Chou <yich@google.com>
Reported-by: Shervin Oloumi <enlightened@google.com>
Signed-off-by: Grant Grundler <grundler@chromium.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_b0.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_b0.c b/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_b0.c
index 9f1b15077e7d..45c17c585d74 100644
--- a/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_b0.c
+++ b/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_b0.c
@@ -889,6 +889,13 @@ int hw_atl_b0_hw_ring_tx_head_update(struct aq_hw_s *self,
 		err = -ENXIO;
 		goto err_exit;
 	}
+
+	/* Validate that the new hw_head_ is reasonable. */
+	if (hw_head_ >= ring->size) {
+		err = -ENXIO;
+		goto err_exit;
+	}
+
 	ring->hw_head = hw_head_;
 	err = aq_hw_err_from_flags(self);
 
-- 
2.35.1

