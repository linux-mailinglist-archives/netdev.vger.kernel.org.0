Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EED572A85EA
	for <lists+netdev@lfdr.de>; Thu,  5 Nov 2020 19:15:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732004AbgKESOY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Nov 2020 13:14:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731919AbgKESOU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Nov 2020 13:14:20 -0500
Received: from mail-io1-xd41.google.com (mail-io1-xd41.google.com [IPv6:2607:f8b0:4864:20::d41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD2F3C0613D6
        for <netdev@vger.kernel.org>; Thu,  5 Nov 2020 10:14:19 -0800 (PST)
Received: by mail-io1-xd41.google.com with SMTP id o11so2723687ioo.11
        for <netdev@vger.kernel.org>; Thu, 05 Nov 2020 10:14:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=p+lkfd8xMKlo1Fg15MYQXX13b5bJPl5MqK8isupI+zY=;
        b=Xd7E8c5UVRgw6M2CE8n9jkv80c1qgMiEED3CZbYX8wyixcJagtFs1SVogEQ8H53MGj
         ewUp/IXwMLLGFnoWUi+890+XX00Na2oPbDdKQy0hz4r+y70+Ncw/Mqt1FUXYv2PQHKaP
         Ox5KwPXelQQi5x4XRpCOoqcTTVEp3nQv+SGS8U3CE7kT+qaexwQGu0hQXMdPzczPlmv2
         uXWtBX2lzSEan4viE9Iez1XK7KaP/9dpC9pq2mOK//nKcmKEo3Touk/XT0hd4PBTsMDZ
         vIfILeVnbFuCD5ELe+yY00yW/dntYgzvk7Yh7HnsJboPGZl9Zf851cbMJTWmh08vdQ0u
         4Lsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=p+lkfd8xMKlo1Fg15MYQXX13b5bJPl5MqK8isupI+zY=;
        b=pmxFchuZv/wtkS9YpVDJixdEMzTweVbOqgH30/5ncGRVF9blclZ52cB4FqKZnxkGFJ
         IETu0f/Ol9k5bMM+f3HJ2HalfEPgyAVA7xSda9nN7HcXWnVL3Lokr7FpolkTzc5DrlCw
         C/px+1ETe6nyXZZV67EIJ0KACGCcoEvMIgpufZWxkJVLMlaBq+ZVgcQ9jihmKCb1GkBg
         pc/CCixViU+frl2Szfn45MOWgtT7TTq18G712os59iinRI1Dkwx6S+8NTorMPG2g0iMm
         k3CUptUfnaISFltJNcErUULJgTzwM1k5ITlekcDMK6/SvzCy8KBCu2oB0im0LgJT0d1t
         TXfw==
X-Gm-Message-State: AOAM533cUpqwSEK965SLiNf8cTCvGTW3xCPIlK/TF8ELJclsis0uCVC9
        1SsWmUxc/4KfV+ID++gHigkUCg==
X-Google-Smtp-Source: ABdhPJyfytA1TA5Rba38RR639yfhES6pERqC7RNEI+GN6ppsKgs9uPUaJJRyOIC0FsCJvFvFqhlyjw==
X-Received: by 2002:a02:c64f:: with SMTP id k15mr3122009jan.75.1604600059034;
        Thu, 05 Nov 2020 10:14:19 -0800 (PST)
Received: from beast.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id o19sm1554136ilt.24.2020.11.05.10.14.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Nov 2020 10:14:18 -0800 (PST)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     evgreen@chromium.org, subashab@codeaurora.org,
        cpratapa@codeaurora.org, bjorn.andersson@linaro.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 05/13] net: ipa: disable all GSI interrupt types initially
Date:   Thu,  5 Nov 2020 12:13:59 -0600
Message-Id: <20201105181407.8006-6-elder@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20201105181407.8006-1-elder@linaro.org>
References: <20201105181407.8006-1-elder@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Introduce gsi_irq_setup() and gsi_irq_teardown() to disable all
GSI interrupts when first setting up GSI hardware, and to clean
things up when we're done.

Re-enable all GSI interrupt types in gsi_irq_enable(), but do
so only after each of the type-specific interrupt masks has
been configured.  Similarly, disable all interrupt types in
gsi_irq_disable()--first--before zeroing out the type-specific
masks.

Signed-off-by: Alex Elder <elder@linaro.org>
---
 drivers/net/ipa/gsi.c | 42 ++++++++++++++++++++++++++++++++----------
 1 file changed, 32 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ipa/gsi.c b/drivers/net/ipa/gsi.c
index da5204268df29..669d7496f8bdb 100644
--- a/drivers/net/ipa/gsi.c
+++ b/drivers/net/ipa/gsi.c
@@ -230,6 +230,18 @@ static u32 gsi_channel_id(struct gsi_channel *channel)
 	return channel - &channel->gsi->channel[0];
 }
 
+/* Turn off all GSI interrupts initially */
+static void gsi_irq_setup(struct gsi *gsi)
+{
+	iowrite32(0, gsi->virt + GSI_CNTXT_TYPE_IRQ_MSK_OFFSET);
+}
+
+/* Turn off all GSI interrupts when we're all done */
+static void gsi_irq_teardown(struct gsi *gsi)
+{
+	iowrite32(0, gsi->virt + GSI_CNTXT_TYPE_IRQ_MSK_OFFSET);
+}
+
 static void gsi_irq_ieob_enable(struct gsi *gsi, u32 evt_ring_id)
 {
 	u32 val;
@@ -253,14 +265,6 @@ static void gsi_irq_enable(struct gsi *gsi)
 {
 	u32 val;
 
-	val = BIT(GSI_CH_CTRL);
-	val |= BIT(GSI_EV_CTRL);
-	val |= BIT(GSI_GLOB_EE);
-	val |= BIT(GSI_IEOB);
-	/* We don't use inter-EE channel or event control interrupts */
-	val |= BIT(GSI_GENERAL);
-	iowrite32(val, gsi->virt + GSI_CNTXT_TYPE_IRQ_MSK_OFFSET);
-
 	val = GENMASK(gsi->channel_count - 1, 0);
 	iowrite32(val, gsi->virt + GSI_CNTXT_SRC_CH_IRQ_MSK_OFFSET);
 
@@ -276,17 +280,27 @@ static void gsi_irq_enable(struct gsi *gsi)
 	/* Never enable GSI_BREAK_POINT */
 	val = GSI_CNTXT_GSI_IRQ_ALL & ~BREAK_POINT_FMASK;
 	iowrite32(val, gsi->virt + GSI_CNTXT_GSI_IRQ_EN_OFFSET);
+
+	/* Finally enable the interrupt types we use */
+	val = BIT(GSI_CH_CTRL);
+	val |= BIT(GSI_EV_CTRL);
+	val |= BIT(GSI_GLOB_EE);
+	val |= BIT(GSI_IEOB);
+	/* We don't use inter-EE channel or event interrupts */
+	val |= BIT(GSI_GENERAL);
+	iowrite32(val, gsi->virt + GSI_CNTXT_TYPE_IRQ_MSK_OFFSET);
 }
 
 /* Disable all GSI_interrupt types */
 static void gsi_irq_disable(struct gsi *gsi)
 {
+	iowrite32(0, gsi->virt + GSI_CNTXT_TYPE_IRQ_MSK_OFFSET);
+
 	iowrite32(0, gsi->virt + GSI_CNTXT_GSI_IRQ_EN_OFFSET);
 	iowrite32(0, gsi->virt + GSI_CNTXT_GLOB_IRQ_EN_OFFSET);
 	iowrite32(0, gsi->virt + GSI_CNTXT_SRC_IEOB_IRQ_MSK_OFFSET);
 	iowrite32(0, gsi->virt + GSI_CNTXT_SRC_EV_CH_IRQ_MSK_OFFSET);
 	iowrite32(0, gsi->virt + GSI_CNTXT_SRC_CH_IRQ_MSK_OFFSET);
-	iowrite32(0, gsi->virt + GSI_CNTXT_TYPE_IRQ_MSK_OFFSET);
 }
 
 /* Return the virtual address associated with a ring index */
@@ -1683,6 +1697,7 @@ int gsi_setup(struct gsi *gsi)
 {
 	struct device *dev = gsi->dev;
 	u32 val;
+	int ret;
 
 	/* Here is where we first touch the GSI hardware */
 	val = ioread32(gsi->virt + GSI_GSI_STATUS_OFFSET);
@@ -1691,6 +1706,8 @@ int gsi_setup(struct gsi *gsi)
 		return -EIO;
 	}
 
+	gsi_irq_setup(gsi);
+
 	val = ioread32(gsi->virt + GSI_GSI_HW_PARAM_2_OFFSET);
 
 	gsi->channel_count = u32_get_bits(val, NUM_CH_PER_EE_FMASK);
@@ -1723,13 +1740,18 @@ int gsi_setup(struct gsi *gsi)
 	/* Writing 1 indicates IRQ interrupts; 0 would be MSI */
 	iowrite32(1, gsi->virt + GSI_CNTXT_INTSET_OFFSET);
 
-	return gsi_channel_setup(gsi);
+	ret = gsi_channel_setup(gsi);
+	if (ret)
+		gsi_irq_teardown(gsi);
+
+	return ret;
 }
 
 /* Inverse of gsi_setup() */
 void gsi_teardown(struct gsi *gsi)
 {
 	gsi_channel_teardown(gsi);
+	gsi_irq_teardown(gsi);
 }
 
 /* Initialize a channel's event ring */
-- 
2.20.1

