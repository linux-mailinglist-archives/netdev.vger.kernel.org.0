Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 764CB52BAD3
	for <lists+netdev@lfdr.de>; Wed, 18 May 2022 14:39:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237006AbiERMef (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 May 2022 08:34:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237096AbiERMdd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 May 2022 08:33:33 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B16C170642;
        Wed, 18 May 2022 05:29:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CD149B81F43;
        Wed, 18 May 2022 12:29:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24E6EC385A5;
        Wed, 18 May 2022 12:29:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652876985;
        bh=Bn5iKQ4JY22ozgqp12txf8GMnQ2eSsU/MfN2HFCD7Ew=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rkoFEp3sxZT2ywPXL5myDInYItF3QPkfOPF4O4oZhVWbJo9teaVVKq8M5EQ33b0Vn
         FsDQfeSEFKjriYb1cr4/tq2k2Siq7ebONAWCjD/1jB/o6cgPJE3ffQFw1XRsJ1C+14
         AliGXew3bo9c1OOOjExkMhaGee0sA6L/YiyV5VQ+V1N+Z7X5XEvNGAoZa5z6BenvLh
         l0VoHZ9fMT3zdjQuJsWysSBSoUeQBj4mmGQoHLN4k8eXFMvgiz5Rn8aj/o1LCfEk5O
         2FpmFP/aTwUjaQ90toDk4eqsgLyaQBZr3KUYOHFc60tPAzQeWNJXHU5hwkiXvaE32A
         TSURlUO4voqmQ==
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
Subject: [PATCH AUTOSEL 5.4 6/6] net: atlantic: verify hw_head_ lies within TX buffer ring
Date:   Wed, 18 May 2022 08:29:29 -0400
Message-Id: <20220518122929.343615-6-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220518122929.343615-1-sashal@kernel.org>
References: <20220518122929.343615-1-sashal@kernel.org>
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
index 2ad3fa6316ce..cb5954eeb409 100644
--- a/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_b0.c
+++ b/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_b0.c
@@ -674,6 +674,13 @@ static int hw_atl_b0_hw_ring_tx_head_update(struct aq_hw_s *self,
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

