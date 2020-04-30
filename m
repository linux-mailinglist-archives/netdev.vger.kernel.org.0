Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2DE5A1C0A2A
	for <lists+netdev@lfdr.de>; Fri,  1 May 2020 00:13:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727891AbgD3WNe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Apr 2020 18:13:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727074AbgD3WNc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Apr 2020 18:13:32 -0400
Received: from mail-qk1-x741.google.com (mail-qk1-x741.google.com [IPv6:2607:f8b0:4864:20::741])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16DECC035494
        for <netdev@vger.kernel.org>; Thu, 30 Apr 2020 15:13:32 -0700 (PDT)
Received: by mail-qk1-x741.google.com with SMTP id c63so7555237qke.2
        for <netdev@vger.kernel.org>; Thu, 30 Apr 2020 15:13:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=1eX7WSK+5t5gndojFUhLnWThbbKlBFG3tYGdIpF55Xw=;
        b=ks5peESQSMAP6mY2kYfPMOd79E2Eo9HhU4hymwuP408laGbs3/CSQho1C9UKZzUJes
         Xs8/wUEc+G9aBGnCSbiqbZoESQNDCLqPLTja+Hu3cGlcX+hku+LAUUltTeC6NbbpWPum
         EAYB541Wf5S0wAd/yy1xuCAqH04URkMgJYpvUTkeT8AYzYTifFCwEiYPtAKL7okAgT3O
         EBJMFjVOlXTPfuF9yFFXYXa0U5Az+idqTbj0CbyPYkOWrQ3TRmMpeveUDFkmKS1cG4Nb
         3tBr4zb6muxFs8j2yI6yuJNH50PjfkDVWpSYzf9J9WtICxJgJcuuAvCErYB6mO/kLE+1
         zD2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=1eX7WSK+5t5gndojFUhLnWThbbKlBFG3tYGdIpF55Xw=;
        b=A6lHSNvU4mckCMJthsZXCOIFU6g4+FSxfDdos+sBluZTWl6nfmMgUgjQuZ32Aucex+
         UXIx8n6bARbmP/nRbJj1cqMM1IHfiX1Tw12xH6DWjnTUlY2us5Y/OPfA+hgmNRNsih30
         7++zYaMeqdCnBo94deg8dS3tXa8NrKK+WjqBaFgCAVgbdbdm6/R3nTQgDqjheYOlF4i/
         /ZXkws3AijYfhfwHDxZOSMOPxy1PVG8G/pIcj1Jt/X2neqrz+WC6u4aNi8aznYOQiyW+
         TOLO7obYl2jXzFfIOqKDoac6DwpVSiyfxRjfL6UsBnoH28J3p0BlxJfPx4BBNrvjNml7
         s6ig==
X-Gm-Message-State: AGi0PuaqPAgX5volELrrgxBjK1oQvOfCSq3nBxVbdPL85hkgae7wrCJL
        ZKms42kmMlk5BEFyCTfTjZptjg==
X-Google-Smtp-Source: APiQypI8kggB1A0qQmfq8hwvIIINcSUXJaqfoU3LwqJLGrR9yx3XKlkQsTZfYm2YLsiturKSmp7T2Q==
X-Received: by 2002:a05:620a:c8c:: with SMTP id q12mr781886qki.74.1588284811293;
        Thu, 30 Apr 2020 15:13:31 -0700 (PDT)
Received: from beast.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id w42sm957028qtj.63.2020.04.30.15.13.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Apr 2020 15:13:30 -0700 (PDT)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net
Cc:     evgreen@chromium.org.net, subashab@codeaurora.org,
        cpratapa@codeaurora.org, bjorn.andersson@linaro.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 1/2] net: ipa: pass channel pointer to gsi_channel_state()
Date:   Thu, 30 Apr 2020 17:13:22 -0500
Message-Id: <20200430221323.5449-2-elder@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200430221323.5449-1-elder@linaro.org>
References: <20200430221323.5449-1-elder@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Pass a channel pointer rather than a GSI pointer and channel ID to
gsi_channel_state().

Signed-off-by: Alex Elder <elder@linaro.org>
---
 drivers/net/ipa/gsi.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ipa/gsi.c b/drivers/net/ipa/gsi.c
index 845478a19a4f..6946c39b664a 100644
--- a/drivers/net/ipa/gsi.c
+++ b/drivers/net/ipa/gsi.c
@@ -416,12 +416,13 @@ static void gsi_evt_ring_de_alloc_command(struct gsi *gsi, u32 evt_ring_id)
 }
 
 /* Return the hardware's notion of the current state of a channel */
-static enum gsi_channel_state
-gsi_channel_state(struct gsi *gsi, u32 channel_id)
+static enum gsi_channel_state gsi_channel_state(struct gsi_channel *channel)
 {
+	u32 channel_id = gsi_channel_id(channel);
+	void *virt = channel->gsi->virt;
 	u32 val;
 
-	val = ioread32(gsi->virt + GSI_CH_C_CNTXT_0_OFFSET(channel_id));
+	val = ioread32(virt + GSI_CH_C_CNTXT_0_OFFSET(channel_id));
 
 	return u32_get_bits(val, CHSTATE_FMASK);
 }
@@ -453,7 +454,7 @@ static int gsi_channel_alloc_command(struct gsi *gsi, u32 channel_id)
 	int ret;
 
 	/* Get initial channel state */
-	channel->state = gsi_channel_state(gsi, channel_id);
+	channel->state = gsi_channel_state(channel);
 
 	if (channel->state != GSI_CHANNEL_STATE_NOT_ALLOCATED)
 		return -EINVAL;
@@ -940,7 +941,7 @@ static void gsi_isr_chan_ctrl(struct gsi *gsi)
 		channel_mask ^= BIT(channel_id);
 
 		channel = &gsi->channel[channel_id];
-		channel->state = gsi_channel_state(gsi, channel_id);
+		channel->state = gsi_channel_state(channel);
 
 		complete(&channel->completion);
 	}
-- 
2.20.1

