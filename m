Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3512052BAA5
	for <lists+netdev@lfdr.de>; Wed, 18 May 2022 14:39:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236922AbiERMdo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 May 2022 08:33:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236903AbiERMct (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 May 2022 08:32:49 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75C23712DC;
        Wed, 18 May 2022 05:29:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EFBFF61290;
        Wed, 18 May 2022 12:29:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 357D3C385AA;
        Wed, 18 May 2022 12:29:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652876951;
        bh=Z0yLV7OaN3ICxtsmf7PdR/dPOvR2eTHVeN76hlLFETA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=E5+7vZdU9hk/yanQUKyz2j3s1E2njcyKXXjCaMsQOZtU8blgrc/vDWFgro3ZwsJ6T
         mjZCzTP+FW2tibPeJAXbTsDWJBVs5BjaVJrHhlVGOXwHlXfs05DUwMT7wzMQuRLVp5
         Rc/2E9r+Wb5yWHI3zSzkLofMaJOIkNIPhO/xEsu85XsEBgh/qEeJOB1ruVe95m0MKu
         9mSKUjv3vuzazUhDhA/gXXJBymqAquQe4hvz039pnstsNPTVEsv8p/8W27rDCXTLUz
         Zsh4G1N2o1aEDs/2Po1ihGpmKslp3FwjRjJScVYntnBAMdOR5F3II2sn4ApkxWDpba
         9FH9egj2YYDmw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Grant Grundler <grundler@chromium.org>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, irusskikh@marvell.com,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 09/13] net: atlantic: reduce scope of is_rsc_complete
Date:   Wed, 18 May 2022 08:28:40 -0400
Message-Id: <20220518122844.343220-9-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220518122844.343220-1-sashal@kernel.org>
References: <20220518122844.343220-1-sashal@kernel.org>
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

[ Upstream commit 79784d77ebbd3ec516b7a5ce555d979fb7946202 ]

Don't defer handling the err case outside the loop. That's pointless.

And since is_rsc_complete is only used inside this loop, declare
it inside the loop to reduce it's scope.

Signed-off-by: Grant Grundler <grundler@chromium.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/aquantia/atlantic/aq_ring.c | 13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_ring.c b/drivers/net/ethernet/aquantia/atlantic/aq_ring.c
index 7cf5a48e9a7d..339efdfb1d49 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_ring.c
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_ring.c
@@ -345,7 +345,6 @@ int aq_ring_rx_clean(struct aq_ring_s *self,
 		     int budget)
 {
 	struct net_device *ndev = aq_nic_get_ndev(self->aq_nic);
-	bool is_rsc_completed = true;
 	int err = 0;
 
 	for (; (self->sw_head != self->hw_head) && budget;
@@ -365,6 +364,8 @@ int aq_ring_rx_clean(struct aq_ring_s *self,
 		if (!buff->is_eop) {
 			buff_ = buff;
 			do {
+				bool is_rsc_completed = true;
+
 				if (buff_->next >= self->size) {
 					err = -EIO;
 					goto err_exit;
@@ -376,18 +377,16 @@ int aq_ring_rx_clean(struct aq_ring_s *self,
 							    next_,
 							    self->hw_head);
 
-				if (unlikely(!is_rsc_completed))
-					break;
+				if (unlikely(!is_rsc_completed)) {
+					err = 0;
+					goto err_exit;
+				}
 
 				buff->is_error |= buff_->is_error;
 				buff->is_cso_err |= buff_->is_cso_err;
 
 			} while (!buff_->is_eop);
 
-			if (!is_rsc_completed) {
-				err = 0;
-				goto err_exit;
-			}
 			if (buff->is_error ||
 			    (buff->is_lro && buff->is_cso_err)) {
 				buff_ = buff;
-- 
2.35.1

