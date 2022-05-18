Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8E5A652BACD
	for <lists+netdev@lfdr.de>; Wed, 18 May 2022 14:39:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237327AbiERMfW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 May 2022 08:35:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236967AbiERMem (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 May 2022 08:34:42 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D8CF195900;
        Wed, 18 May 2022 05:30:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DEF98616CC;
        Wed, 18 May 2022 12:30:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8121C34100;
        Wed, 18 May 2022 12:30:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652877016;
        bh=4otzz0Ek9YgjFM5VEIzznDR47c+nrHLEJbYejAR82I8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=keDaN/k9ON2ceY+tviXcvOkzmfZElVdZlBa32/uydt8s8cbyv76Nexi9Gjo2tV810
         3vekS/Yj+nlyCvGtS2FWHNEwzzEG/8bymMvTlivmcmO5+dT+yRKbLHZWYBMnafbwTD
         jdJM4DgURW3kHaT+FuhZHN93Demqgg78LwvnbYEsxhr49w4oArmEiWNoTenYyf1ClA
         BuM58SUYsRc1xFrJhbLmXVkiMBHwMTDZFF9naL/E+AZjwoCwJaksELzh1GR8oDIK+S
         Md/Cb/3fPNLPHvzjHJbm1iFbAp+/YCciRieKfk8Aj9v5ihivv2Qzerq1ApOjCrSJKQ
         5aPn/O2JNg/kw==
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
Subject: [PATCH AUTOSEL 4.14 5/5] net: atlantic: verify hw_head_ lies within TX buffer ring
Date:   Wed, 18 May 2022 08:30:00 -0400
Message-Id: <20220518123000.343787-5-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220518123000.343787-1-sashal@kernel.org>
References: <20220518123000.343787-1-sashal@kernel.org>
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
index 1c1bb074f664..066abf9dc91e 100644
--- a/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_b0.c
+++ b/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_b0.c
@@ -625,6 +625,13 @@ static int hw_atl_b0_hw_ring_tx_head_update(struct aq_hw_s *self,
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

