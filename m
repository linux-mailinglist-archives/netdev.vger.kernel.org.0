Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 06D971D3D02
	for <lists+netdev@lfdr.de>; Thu, 14 May 2020 21:17:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730326AbgENTLM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 May 2020 15:11:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:50432 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728272AbgENSwU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 14 May 2020 14:52:20 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1A6D82065F;
        Thu, 14 May 2020 18:52:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589482338;
        bh=P3vnlNl2kfwRlE3gX2+SClcTGmFVrHC5ebGzq7c4wOo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YPFph8CwrlFqVgu9IDDHSXFMzEkAdluKJdb3Jjhf9FlBXh4p+hV9lOFpbAlN9ODPt
         wn9xQdkxJYctgVJyEj97c7SAxGMu5CRGBR3epu8JN/F2uxfJLgOMWaPMCptA3FdkOS
         MpchYoJqiS6BdY6r8RteVU63Oq6tDkb+l18QC524=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Alex Elder <elder@linaro.org>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.6 23/62] net: ipa: fix a bug in ipa_endpoint_stop()
Date:   Thu, 14 May 2020 14:51:08 -0400
Message-Id: <20200514185147.19716-23-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200514185147.19716-1-sashal@kernel.org>
References: <20200514185147.19716-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alex Elder <elder@linaro.org>

[ Upstream commit 713b6ebb4c376b3fb65fdceb3b59e401c93248f9 ]

In ipa_endpoint_stop(), for TX endpoints we set the number of retries
to 0.  When we break out of the loop, retries being 0 means we return
EIO rather than the value of ret (which should be 0).

Fix this by using a non-zero retry count for both RX and TX
channels, and just break out of the loop after calling
gsi_channel_stop() for TX channels.  This way only RX channels
will retry, and the retry count will be non-zero at the end
for TX channels (so the proper value gets returned).

Signed-off-by: Alex Elder <elder@linaro.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ipa/ipa_endpoint.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ipa/ipa_endpoint.c b/drivers/net/ipa/ipa_endpoint.c
index 915b4cd05dd29..78ed431e6eb86 100644
--- a/drivers/net/ipa/ipa_endpoint.c
+++ b/drivers/net/ipa/ipa_endpoint.c
@@ -1284,7 +1284,7 @@ static int ipa_endpoint_stop_rx_dma(struct ipa *ipa)
  */
 int ipa_endpoint_stop(struct ipa_endpoint *endpoint)
 {
-	u32 retries = endpoint->toward_ipa ? 0 : IPA_ENDPOINT_STOP_RX_RETRIES;
+	u32 retries = IPA_ENDPOINT_STOP_RX_RETRIES;
 	int ret;
 
 	do {
@@ -1292,12 +1292,9 @@ int ipa_endpoint_stop(struct ipa_endpoint *endpoint)
 		struct gsi *gsi = &ipa->gsi;
 
 		ret = gsi_channel_stop(gsi, endpoint->channel_id);
-		if (ret != -EAGAIN)
+		if (ret != -EAGAIN || endpoint->toward_ipa)
 			break;
 
-		if (endpoint->toward_ipa)
-			continue;
-
 		/* For IPA v3.5.1, send a DMA read task and check again */
 		if (ipa->version == IPA_VERSION_3_5_1) {
 			ret = ipa_endpoint_stop_rx_dma(ipa);
-- 
2.20.1

