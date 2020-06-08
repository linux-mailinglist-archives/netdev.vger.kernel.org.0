Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 09BD11F2F5A
	for <lists+netdev@lfdr.de>; Tue,  9 Jun 2020 02:50:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732461AbgFIAto (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Jun 2020 20:49:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:56910 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728740AbgFHXKl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 8 Jun 2020 19:10:41 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1DDF8208FE;
        Mon,  8 Jun 2020 23:10:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591657841;
        bh=/WXHUUPc1w97z44Y0YVUkz4p30wFHJ30MGCDQ+SgazA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=snqut+Tl/I+yd/9hD/fbPvVLEMVTIXg20kbpJsJfHLdMNak9uUFjDcs1/CdKm982P
         axEI+dM5VUtgpqtQ1Uw7Sp6Smw49Uha+cUUb/ms3pkaXXLbIprktRWumWPjWwNqYdr
         Q7TRwqhmGqNBN8jzkjeFUR01c5AnoVb9kEMcZC/k=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Alex Elder <elder@linaro.org>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.7 209/274] net: ipa: do not clear interrupt in gsi_channel_start()
Date:   Mon,  8 Jun 2020 19:05:02 -0400
Message-Id: <20200608230607.3361041-209-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200608230607.3361041-1-sashal@kernel.org>
References: <20200608230607.3361041-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alex Elder <elder@linaro.org>

[ Upstream commit 195ef57f870070cb02f2f3b99a63d69e8e8f798e ]

In gsi_channel_start() there is harmless-looking comment "Clear the
channel's event ring interrupt in case it's pending".  The intent
was to avoid getting spurious interrupts when first bringing up a
channel.

However we now use channel stop/start to implement suspend and
resume, and an interrupt pending at the time we resume is actually
something we don't want to ignore.

The very first time we bring up the channel we do not expect an
interrupt to be pending, and even if it were, the effect would
simply be to schedule NAPI on that channel, which would find nothing
to do, which is not a problem.

Stop clearing any pending IEOB interrupt in gsi_channel_start().
That leaves one caller of the trivial function gsi_isr_ieob_clear().
Get rid of that function and just open-code it in gsi_isr_ieob()
instead.

This fixes a problem where suspend/resume IPA v4.2 would get stuck
when resuming after a suspend.

Signed-off-by: Alex Elder <elder@linaro.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ipa/gsi.c | 11 +----------
 1 file changed, 1 insertion(+), 10 deletions(-)

diff --git a/drivers/net/ipa/gsi.c b/drivers/net/ipa/gsi.c
index 8d9ca1c335e8..043a675e1be1 100644
--- a/drivers/net/ipa/gsi.c
+++ b/drivers/net/ipa/gsi.c
@@ -238,11 +238,6 @@ static void gsi_irq_ieob_enable(struct gsi *gsi, u32 evt_ring_id)
 	iowrite32(val, gsi->virt + GSI_CNTXT_SRC_IEOB_IRQ_MSK_OFFSET);
 }
 
-static void gsi_isr_ieob_clear(struct gsi *gsi, u32 mask)
-{
-	iowrite32(mask, gsi->virt + GSI_CNTXT_SRC_IEOB_IRQ_CLR_OFFSET);
-}
-
 static void gsi_irq_ieob_disable(struct gsi *gsi, u32 evt_ring_id)
 {
 	u32 val;
@@ -756,7 +751,6 @@ static void gsi_channel_deprogram(struct gsi_channel *channel)
 int gsi_channel_start(struct gsi *gsi, u32 channel_id)
 {
 	struct gsi_channel *channel = &gsi->channel[channel_id];
-	u32 evt_ring_id = channel->evt_ring_id;
 	int ret;
 
 	mutex_lock(&gsi->mutex);
@@ -765,9 +759,6 @@ int gsi_channel_start(struct gsi *gsi, u32 channel_id)
 
 	mutex_unlock(&gsi->mutex);
 
-	/* Clear the channel's event ring interrupt in case it's pending */
-	gsi_isr_ieob_clear(gsi, BIT(evt_ring_id));
-
 	gsi_channel_thaw(channel);
 
 	return ret;
@@ -1071,7 +1062,7 @@ static void gsi_isr_ieob(struct gsi *gsi)
 	u32 event_mask;
 
 	event_mask = ioread32(gsi->virt + GSI_CNTXT_SRC_IEOB_IRQ_OFFSET);
-	gsi_isr_ieob_clear(gsi, event_mask);
+	iowrite32(event_mask, gsi->virt + GSI_CNTXT_SRC_IEOB_IRQ_CLR_OFFSET);
 
 	while (event_mask) {
 		u32 evt_ring_id = __ffs(event_mask);
-- 
2.25.1

