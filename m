Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 78309507768
	for <lists+netdev@lfdr.de>; Tue, 19 Apr 2022 20:15:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356225AbiDSSPH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Apr 2022 14:15:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356323AbiDSSOj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Apr 2022 14:14:39 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0ED683DA5F;
        Tue, 19 Apr 2022 11:11:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 6AE8DCE188A;
        Tue, 19 Apr 2022 18:11:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D98DC385A5;
        Tue, 19 Apr 2022 18:11:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1650391908;
        bh=td2dPsECXqyRY/ABkxSK/V+113r84hWAnEKvyOEtiLI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RgWQt+PRjPseSIzlB9vmCci6MBOFTpPL9fYs7lNsAgDhOJsj0ipoMjohgq60xFG9C
         253Y+jOD5Yj9Ud4iuL0pAJtKVUgsT3SEUc0CzXZSDr4BvtbQIJLJ68IHVaG1WIrBE5
         n3EjnfSis2lzY99cqNRUUnfAi3SxWHRetkbgGv6bTzbRrrDFPBrsNahGjoRjDaAzUb
         S4y0klIY0Ous6sQcBVdCsRBf+lz67NfK2qXYz8RuqOjkFtnwA5ZmeoVjiWaXMiXKbX
         fBo85jqREeS2OBafA+J43mwo2nl190r6XhU3KWAq5su0yxspJPGNp+bVNa99QNAeqN
         VLg+fIY6/FbfQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Kai-Heng Feng <kai.heng.feng@canonical.com>,
        Mario Limonciello <mario.limonciello@amd.com>,
        Igor Russkikh <irusskikh@marvell.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>, davem@davemloft.net,
        pabeni@redhat.com, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.17 14/34] net: atlantic: Avoid out-of-bounds indexing
Date:   Tue, 19 Apr 2022 14:10:41 -0400
Message-Id: <20220419181104.484667-14-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220419181104.484667-1-sashal@kernel.org>
References: <20220419181104.484667-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Kai-Heng Feng <kai.heng.feng@canonical.com>

[ Upstream commit 8d3a6c37d50d5a0504c126c932cc749e6dd9c78f ]

UBSAN warnings are observed on atlantic driver:
[ 294.432996] UBSAN: array-index-out-of-bounds in /build/linux-Qow4fL/linux-5.15.0/drivers/net/ethernet/aquantia/atlantic/aq_nic.c:484:48
[ 294.433695] index 8 is out of range for type 'aq_vec_s *[8]'

The ring is dereferenced right before breaking out the loop, to prevent
that from happening, only use the index in the loop to fix the issue.

BugLink: https://bugs.launchpad.net/bugs/1958770
Tested-by: Mario Limonciello <mario.limonciello@amd.com>
Signed-off-by: Kai-Heng Feng <kai.heng.feng@canonical.com>
Reviewed-by: Igor Russkikh <irusskikh@marvell.com>
Link: https://lore.kernel.org/r/20220408022204.16815-1-kai.heng.feng@canonical.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/ethernet/aquantia/atlantic/aq_nic.c   |  8 +++----
 .../net/ethernet/aquantia/atlantic/aq_vec.c   | 24 +++++++++----------
 2 files changed, 16 insertions(+), 16 deletions(-)

diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_nic.c b/drivers/net/ethernet/aquantia/atlantic/aq_nic.c
index 33f1a1377588..24d715c28a35 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_nic.c
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_nic.c
@@ -486,8 +486,8 @@ int aq_nic_start(struct aq_nic_s *self)
 	if (err < 0)
 		goto err_exit;
 
-	for (i = 0U, aq_vec = self->aq_vec[0];
-		self->aq_vecs > i; ++i, aq_vec = self->aq_vec[i]) {
+	for (i = 0U; self->aq_vecs > i; ++i) {
+		aq_vec = self->aq_vec[i];
 		err = aq_vec_start(aq_vec);
 		if (err < 0)
 			goto err_exit;
@@ -517,8 +517,8 @@ int aq_nic_start(struct aq_nic_s *self)
 		mod_timer(&self->polling_timer, jiffies +
 			  AQ_CFG_POLLING_TIMER_INTERVAL);
 	} else {
-		for (i = 0U, aq_vec = self->aq_vec[0];
-			self->aq_vecs > i; ++i, aq_vec = self->aq_vec[i]) {
+		for (i = 0U; self->aq_vecs > i; ++i) {
+			aq_vec = self->aq_vec[i];
 			err = aq_pci_func_alloc_irq(self, i, self->ndev->name,
 						    aq_vec_isr, aq_vec,
 						    aq_vec_get_affinity_mask(aq_vec));
diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_vec.c b/drivers/net/ethernet/aquantia/atlantic/aq_vec.c
index f4774cf051c9..6ab1f3212d24 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_vec.c
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_vec.c
@@ -43,8 +43,8 @@ static int aq_vec_poll(struct napi_struct *napi, int budget)
 	if (!self) {
 		err = -EINVAL;
 	} else {
-		for (i = 0U, ring = self->ring[0];
-			self->tx_rings > i; ++i, ring = self->ring[i]) {
+		for (i = 0U; self->tx_rings > i; ++i) {
+			ring = self->ring[i];
 			u64_stats_update_begin(&ring[AQ_VEC_RX_ID].stats.rx.syncp);
 			ring[AQ_VEC_RX_ID].stats.rx.polls++;
 			u64_stats_update_end(&ring[AQ_VEC_RX_ID].stats.rx.syncp);
@@ -182,8 +182,8 @@ int aq_vec_init(struct aq_vec_s *self, const struct aq_hw_ops *aq_hw_ops,
 	self->aq_hw_ops = aq_hw_ops;
 	self->aq_hw = aq_hw;
 
-	for (i = 0U, ring = self->ring[0];
-		self->tx_rings > i; ++i, ring = self->ring[i]) {
+	for (i = 0U; self->tx_rings > i; ++i) {
+		ring = self->ring[i];
 		err = aq_ring_init(&ring[AQ_VEC_TX_ID], ATL_RING_TX);
 		if (err < 0)
 			goto err_exit;
@@ -224,8 +224,8 @@ int aq_vec_start(struct aq_vec_s *self)
 	unsigned int i = 0U;
 	int err = 0;
 
-	for (i = 0U, ring = self->ring[0];
-		self->tx_rings > i; ++i, ring = self->ring[i]) {
+	for (i = 0U; self->tx_rings > i; ++i) {
+		ring = self->ring[i];
 		err = self->aq_hw_ops->hw_ring_tx_start(self->aq_hw,
 							&ring[AQ_VEC_TX_ID]);
 		if (err < 0)
@@ -248,8 +248,8 @@ void aq_vec_stop(struct aq_vec_s *self)
 	struct aq_ring_s *ring = NULL;
 	unsigned int i = 0U;
 
-	for (i = 0U, ring = self->ring[0];
-		self->tx_rings > i; ++i, ring = self->ring[i]) {
+	for (i = 0U; self->tx_rings > i; ++i) {
+		ring = self->ring[i];
 		self->aq_hw_ops->hw_ring_tx_stop(self->aq_hw,
 						 &ring[AQ_VEC_TX_ID]);
 
@@ -268,8 +268,8 @@ void aq_vec_deinit(struct aq_vec_s *self)
 	if (!self)
 		goto err_exit;
 
-	for (i = 0U, ring = self->ring[0];
-		self->tx_rings > i; ++i, ring = self->ring[i]) {
+	for (i = 0U; self->tx_rings > i; ++i) {
+		ring = self->ring[i];
 		aq_ring_tx_clean(&ring[AQ_VEC_TX_ID]);
 		aq_ring_rx_deinit(&ring[AQ_VEC_RX_ID]);
 	}
@@ -297,8 +297,8 @@ void aq_vec_ring_free(struct aq_vec_s *self)
 	if (!self)
 		goto err_exit;
 
-	for (i = 0U, ring = self->ring[0];
-		self->tx_rings > i; ++i, ring = self->ring[i]) {
+	for (i = 0U; self->tx_rings > i; ++i) {
+		ring = self->ring[i];
 		aq_ring_free(&ring[AQ_VEC_TX_ID]);
 		if (i < self->rx_rings)
 			aq_ring_free(&ring[AQ_VEC_RX_ID]);
-- 
2.35.1

