Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 148784CCCDE
	for <lists+netdev@lfdr.de>; Fri,  4 Mar 2022 06:15:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230244AbiCDFPz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Mar 2022 00:15:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238004AbiCDFPy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Mar 2022 00:15:54 -0500
X-Greylist: delayed 388 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 03 Mar 2022 21:15:02 PST
Received: from smtp-relay-canonical-0.canonical.com (smtp-relay-canonical-0.canonical.com [185.125.188.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 631769285C
        for <netdev@vger.kernel.org>; Thu,  3 Mar 2022 21:15:02 -0800 (PST)
Received: from HP-EliteBook-840-G7.. (36-229-235-123.dynamic-ip.hinet.net [36.229.235.123])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-canonical-0.canonical.com (Postfix) with ESMTPSA id 64BD03F615;
        Fri,  4 Mar 2022 05:08:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1646370507;
        bh=sGlok+QxXUJMqxle/m0fwKdw/UVUhMjtd+mUVGGBQug=;
        h=From:To:Cc:Subject:Date:Message-Id:MIME-Version;
        b=C0fM7Z9SylA6Gc1x6MFjBXU5FpPTseKi1N3wNeavs+9hsXsa91vvqz/anhZsFCn8v
         re3VYGz5p/td6kprV+MfW/VfQSUH71pajbGIEYJuxSqKhlE8Ks39QRkXC96TurYkcG
         tET3QuFDBjl13+MalZeaZGKtULAtPkCNNRTDM9wkbkSPjO455Wl4wn1t4El5Ei3FJ4
         OxIaWKHPFb6rtJjQoEPcNLWfptnZzkU6YiNnBXZK4yb0nO83H7vso8ZnCYKXiyxLzz
         i3Hbv/RrDgCMnU6DOzs2pVACaCMfg/x/wL61wWMnTriqKXtR0HTahdJx4OMQGC94Ey
         fxifyRuHp7dvQ==
From:   Kai-Heng Feng <kai.heng.feng@canonical.com>
To:     irusskikh@marvell.com, davem@davemloft.net, kuba@kernel.org
Cc:     Kai-Heng Feng <kai.heng.feng@canonical.com>,
        Mario Limonciello <mario.limonciello@amd.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] net: atlantic: Avoid out-of-bounds indexing
Date:   Fri,  4 Mar 2022 13:08:12 +0800
Message-Id: <20220304050812.7472-1-kai.heng.feng@canonical.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

UBSAN warnings are observed on atlantic driver:
[ 294.432996] UBSAN: array-index-out-of-bounds in /build/linux-Qow4fL/linux-5.15.0/drivers/net/ethernet/aquantia/atlantic/aq_nic.c:484:48
[ 294.433695] index 8 is out of range for type 'aq_vec_s *[8]'

The index is assigned right before breaking out the loop, so there's no actual
deferencing happening.

So only use the index inside the loop to fix the issue.

BugLink: https://bugs.launchpad.net/bugs/1958770
Tested-by: Mario Limonciello <mario.limonciello@amd.com>
Signed-off-by: Kai-Heng Feng <kai.heng.feng@canonical.com>
---
 .../net/ethernet/aquantia/atlantic/aq_vec.c   | 24 +++++++++----------
 1 file changed, 12 insertions(+), 12 deletions(-)

diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_vec.c b/drivers/net/ethernet/aquantia/atlantic/aq_vec.c
index f4774cf051c97..6ab1f3212d246 100644
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
2.34.1

