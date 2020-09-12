Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 638E02676F3
	for <lists+netdev@lfdr.de>; Sat, 12 Sep 2020 02:48:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726027AbgILAsn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Sep 2020 20:48:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725919AbgILApj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Sep 2020 20:45:39 -0400
Received: from mail-io1-xd43.google.com (mail-io1-xd43.google.com [IPv6:2607:f8b0:4864:20::d43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63204C061796
        for <netdev@vger.kernel.org>; Fri, 11 Sep 2020 17:45:38 -0700 (PDT)
Received: by mail-io1-xd43.google.com with SMTP id b6so12923611iof.6
        for <netdev@vger.kernel.org>; Fri, 11 Sep 2020 17:45:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ulGFoS8Vx9LeLAE5Vy9/f1b+pYTcrEaaGPkRjEnG1KY=;
        b=K+mVgQu+oSo9vWRD4jJE/SK9uOM+v4E6cWcQn7Aq3pD/f6l056Hn89GU9pYQs3Q2/0
         uUrarKtzEYPKkRnlJ9xcvtcM7EPjbsk6YmktikCBg6CUWpU08oavMLvd0kBk2eKIcpF5
         LxewxZQ/4qm9keu+acjXY7+VSMDAhLjBs1S0h8QF0n6szP0tXyhf3xZSo46MkA3EeON9
         Rk8IAjAJdEZTjvagrLRGOmGgpoRm57x/kqJ+R8tciZHPOqDAQScs6NuZ9Jr+tQOw3qZk
         csY7Pl3m+7q4dLqLQLN7HJG3/rr+G1pkOo0FgjFcHTD8tEEFMuEyd/f9LTm02g3xelxH
         A3dw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ulGFoS8Vx9LeLAE5Vy9/f1b+pYTcrEaaGPkRjEnG1KY=;
        b=mgW/v1wP9biAftuR1DrCWmTC+U7mzNu7fVAFYPNwhatu3uODfqgIxjiUl4NswYe3w+
         Khj0tn1aUG/5EqOAikkVz0NaV/GC6H33JWA/+NULKwdazLZvvsbDboBXkrVXIwiA3ajg
         rzqUCsYZplSytf1sHhNwnKJKI+SLgHgpx09Q1/4yIgMbIDHRPjgQKQhWLX2C+L0ctsNR
         txZhtTZr99NjjKRNi0yDoHvw0e5LqO5cAoJixJxRuPtoi6aVJVwN2rxm7D231vKo4vuF
         XvsBaJ6eCawmMjTn3FdJHL8AyMxbbL6IHEJCq1G92TH3ba0bPplm/p4bSSd8W8jrPv0d
         s45A==
X-Gm-Message-State: AOAM531KVJC+PzLKKYZ05OSg8JSaXeMxuCSSTj4z9DMf+fNId6ypfg8q
        yasUhNg9HKSn1bmt9yaN8cNMtw==
X-Google-Smtp-Source: ABdhPJxWJT+vVKiCBt+985pgzDtzYEHz9H03UXv8Xj5pLNbcgZF2oWfJW8MvtHPrZZfnF09g2ofJJw==
X-Received: by 2002:a05:6638:22f:: with SMTP id f15mr4289906jaq.45.1599871537684;
        Fri, 11 Sep 2020 17:45:37 -0700 (PDT)
Received: from beast.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id z4sm2107807ilh.45.2020.09.11.17.45.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Sep 2020 17:45:37 -0700 (PDT)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     evgreen@chromium.org, subashab@codeaurora.org,
        cpratapa@codeaurora.org, bjorn.andersson@linaro.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next v2 2/7] net: ipa: replace ipa->suspend_ref with a flag bit
Date:   Fri, 11 Sep 2020 19:45:27 -0500
Message-Id: <20200912004532.1386-3-elder@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200912004532.1386-1-elder@linaro.org>
References: <20200912004532.1386-1-elder@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

For suspend/resume, we currently take an extra clock reference to
prevent the IPA clock from being shut down until a power management
suspend request arrives.  An atomic field in the IPA structure is
used to indicate whether this reference has been taken.

Instead, introduce a new flags bitmap in the IPA structure, and use
a single bit in that bitmap rather than the atomic to indicate
whether we have taken the special IPA clock reference.

Signed-off-by: Alex Elder <elder@linaro.org>
---
v2: New patch to use a bitmap bit rather than an atomic_t.

 drivers/net/ipa/ipa.h      | 14 ++++++++++++--
 drivers/net/ipa/ipa_main.c | 14 +++++++-------
 2 files changed, 19 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ipa/ipa.h b/drivers/net/ipa/ipa.h
index 407fee841a9a8..e02fe979b645b 100644
--- a/drivers/net/ipa/ipa.h
+++ b/drivers/net/ipa/ipa.h
@@ -27,15 +27,25 @@ struct ipa_clock;
 struct ipa_smp2p;
 struct ipa_interrupt;
 
+/**
+ * enum ipa_flag - IPA state flags
+ * @IPA_FLAG_CLOCK_HELD:	Whether IPA clock is held to prevent suspend
+ * @IPA_FLAG_COUNT:		Number of defined IPA flags
+ */
+enum ipa_flag {
+	IPA_FLAG_CLOCK_HELD,
+	IPA_FLAG_COUNT,		/* Last; not a flag */
+};
+
 /**
  * struct ipa - IPA information
  * @gsi:		Embedded GSI structure
+ * @flags:		Boolean state flags
  * @version:		IPA hardware version
  * @pdev:		Platform device
  * @modem_rproc:	Remoteproc handle for modem subsystem
  * @smp2p:		SMP2P information
  * @clock:		IPA clocking information
- * @suspend_ref:	Whether clock reference preventing suspend taken
  * @table_addr:		DMA address of filter/route table content
  * @table_virt:		Virtual address of filter/route table content
  * @interrupt:		IPA Interrupt information
@@ -70,6 +80,7 @@ struct ipa_interrupt;
  */
 struct ipa {
 	struct gsi gsi;
+	DECLARE_BITMAP(flags, IPA_FLAG_COUNT);
 	enum ipa_version version;
 	struct platform_device *pdev;
 	struct rproc *modem_rproc;
@@ -77,7 +88,6 @@ struct ipa {
 	void *notifier;
 	struct ipa_smp2p *smp2p;
 	struct ipa_clock *clock;
-	atomic_t suspend_ref;
 
 	dma_addr_t table_addr;
 	__le64 *table_virt;
diff --git a/drivers/net/ipa/ipa_main.c b/drivers/net/ipa/ipa_main.c
index 1fdfec41e4421..409375b96eb8f 100644
--- a/drivers/net/ipa/ipa_main.c
+++ b/drivers/net/ipa/ipa_main.c
@@ -84,7 +84,7 @@ static void ipa_suspend_handler(struct ipa *ipa, enum ipa_irq_id irq_id)
 	 * endpoints will be resumed as a result.  This reference will
 	 * be dropped when we get a power management suspend request.
 	 */
-	if (!atomic_xchg(&ipa->suspend_ref, 1))
+	if (!test_and_set_bit(IPA_FLAG_CLOCK_HELD, ipa->flags))
 		ipa_clock_get(ipa);
 
 	/* Acknowledge/clear the suspend interrupt on all endpoints */
@@ -508,7 +508,7 @@ static int ipa_config(struct ipa *ipa, const struct ipa_data *data)
 	 * is held after initialization completes, and won't get dropped
 	 * unless/until a system suspend request arrives.
 	 */
-	atomic_set(&ipa->suspend_ref, 1);
+	__set_bit(IPA_FLAG_CLOCK_HELD, ipa->flags);
 	ipa_clock_get(ipa);
 
 	ipa_hardware_config(ipa);
@@ -544,7 +544,7 @@ static int ipa_config(struct ipa *ipa, const struct ipa_data *data)
 err_hardware_deconfig:
 	ipa_hardware_deconfig(ipa);
 	ipa_clock_put(ipa);
-	atomic_set(&ipa->suspend_ref, 0);
+	__clear_bit(IPA_FLAG_CLOCK_HELD, ipa->flags);
 
 	return ret;
 }
@@ -562,7 +562,7 @@ static void ipa_deconfig(struct ipa *ipa)
 	ipa_endpoint_deconfig(ipa);
 	ipa_hardware_deconfig(ipa);
 	ipa_clock_put(ipa);
-	atomic_set(&ipa->suspend_ref, 0);
+	__clear_bit(IPA_FLAG_CLOCK_HELD, ipa->flags);
 }
 
 static int ipa_firmware_load(struct device *dev)
@@ -777,7 +777,7 @@ static int ipa_probe(struct platform_device *pdev)
 	dev_set_drvdata(dev, ipa);
 	ipa->modem_rproc = rproc;
 	ipa->clock = clock;
-	atomic_set(&ipa->suspend_ref, 0);
+	__clear_bit(IPA_FLAG_CLOCK_HELD, ipa->flags);
 	ipa->wakeup_source = wakeup_source;
 	ipa->version = data->version;
 
@@ -913,7 +913,7 @@ static int ipa_suspend(struct device *dev)
 	struct ipa *ipa = dev_get_drvdata(dev);
 
 	ipa_clock_put(ipa);
-	atomic_set(&ipa->suspend_ref, 0);
+	__clear_bit(IPA_FLAG_CLOCK_HELD, ipa->flags);
 
 	return 0;
 }
@@ -933,7 +933,7 @@ static int ipa_resume(struct device *dev)
 	/* This clock reference will keep the IPA out of suspend
 	 * until we get a power management suspend request.
 	 */
-	atomic_set(&ipa->suspend_ref, 1);
+	__set_bit(IPA_FLAG_CLOCK_HELD, ipa->flags);
 	ipa_clock_get(ipa);
 
 	return 0;
-- 
2.20.1

