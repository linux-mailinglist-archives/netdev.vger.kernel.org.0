Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 242B03E0446
	for <lists+netdev@lfdr.de>; Wed,  4 Aug 2021 17:36:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239100AbhHDPgo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Aug 2021 11:36:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239043AbhHDPgo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Aug 2021 11:36:44 -0400
Received: from mail-il1-x12b.google.com (mail-il1-x12b.google.com [IPv6:2607:f8b0:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C19AC06179A
        for <netdev@vger.kernel.org>; Wed,  4 Aug 2021 08:36:31 -0700 (PDT)
Received: by mail-il1-x12b.google.com with SMTP id h18so2039083ilc.5
        for <netdev@vger.kernel.org>; Wed, 04 Aug 2021 08:36:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=sBctOm9jo5QD+uuBod5VZHnVWZyYPdJk8fSVF+UMMgU=;
        b=sQMMTp1ateLavvDkAiOr9DzhT8dD74LZ0m26c/vnXRq3ZFK6Uc716GC5zveEO2uVqm
         ro2Zgfyoq/3CB9x5KM/jcMNgmcqB5lhmqBilF3HqqOdYXoRFe6hGqNaVkQX0ZbSGmLAE
         yPOr8YTphtRhDYE4wsqZ4pKTlbTOKhsX6h5pTiFKJS0TIobB/fu+bClYgcucnxTx2k3c
         edGpUWO/GFwjR2jwF9RE7lxd8sJTNnTDhQ2dG+f9NG9fpmzzIobs3ahL61+gFwxypN00
         qMyNjYj197c6D0QWsGh2uGoAb80AIS6I38ZyBzHqhTJfv+5phRMsNIC0ESSyfYKDjLI2
         3Ttw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=sBctOm9jo5QD+uuBod5VZHnVWZyYPdJk8fSVF+UMMgU=;
        b=ZUq1zKAYok8voX0WYgTKSPMr58H5xp1vqw4GW50jbxOkJaqLB/lmq76TQgnQB9byDG
         v/8oA5dQTL7MaPO2vdDDUZlKO5QStDfqdhqH6iYH18RJjelbQ3G1JihlE5NcZxZUQKaB
         r19FV9GtTdw1kNclMDo0G4EPAuj3rPT6QAx/o2wGUxLUurEqQ1GEstcUUefetQuesINC
         Y1W8NOoO4+E2MDql9x9HEOxSh/zuhHyePBSix6g+x8j1+VkUlYMNnZBpKh1OAxXPruIU
         LIpKSDJiIzjvH8ggovDbav+TN+F5L1uBR7K9LFOJg5XFJ8HQtW6M9qQby08GhO6gtJNV
         +4iw==
X-Gm-Message-State: AOAM531LAD0dkV+t7Vmx6Xxe6SwfA39VOBqHYkGAmiecCqnSXRisLwGn
        JlCQxfaqV9DI03qXm0SibggPkg==
X-Google-Smtp-Source: ABdhPJzQMQi2ZAyoyzj82QF+AzQ7MZR3Vqw2qOJ0h9KfHXaWroo01MD84eUqeFO63QeoIb6XfoyuUg==
X-Received: by 2002:a05:6e02:ef4:: with SMTP id j20mr107037ilk.246.1628091390668;
        Wed, 04 Aug 2021 08:36:30 -0700 (PDT)
Received: from presto.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id z11sm1687480ioh.14.2021.08.04.08.36.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Aug 2021 08:36:30 -0700 (PDT)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     bjorn.andersson@linaro.org, evgreen@chromium.org,
        cpratapa@codeaurora.org, subashab@codeaurora.org, elder@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 1/6] net: ipa: don't suspend/resume modem if not up
Date:   Wed,  4 Aug 2021 10:36:21 -0500
Message-Id: <20210804153626.1549001-2-elder@linaro.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210804153626.1549001-1-elder@linaro.org>
References: <20210804153626.1549001-1-elder@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The modem network device is set up by ipa_modem_start().  But its
TX queue is not actually started and endpoints enabled until it is
opened.

So avoid stopping the modem network device TX queue and disabling
endpoints on suspend or stop unless the netdev is marked UP.  And
skip attempting to resume unless it is UP.

Signed-off-by: Alex Elder <elder@linaro.org>
---
 drivers/net/ipa/ipa_modem.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ipa/ipa_modem.c b/drivers/net/ipa/ipa_modem.c
index 4ea8287e9d237..663a610979e70 100644
--- a/drivers/net/ipa/ipa_modem.c
+++ b/drivers/net/ipa/ipa_modem.c
@@ -178,6 +178,9 @@ void ipa_modem_suspend(struct net_device *netdev)
 	struct ipa_priv *priv = netdev_priv(netdev);
 	struct ipa *ipa = priv->ipa;
 
+	if (!(netdev->flags & IFF_UP))
+		return;
+
 	netif_stop_queue(netdev);
 
 	ipa_endpoint_suspend_one(ipa->name_map[IPA_ENDPOINT_AP_MODEM_RX]);
@@ -194,6 +197,9 @@ void ipa_modem_resume(struct net_device *netdev)
 	struct ipa_priv *priv = netdev_priv(netdev);
 	struct ipa *ipa = priv->ipa;
 
+	if (!(netdev->flags & IFF_UP))
+		return;
+
 	ipa_endpoint_resume_one(ipa->name_map[IPA_ENDPOINT_AP_MODEM_TX]);
 	ipa_endpoint_resume_one(ipa->name_map[IPA_ENDPOINT_AP_MODEM_RX]);
 
@@ -265,9 +271,11 @@ int ipa_modem_stop(struct ipa *ipa)
 	/* Prevent the modem from triggering a call to ipa_setup() */
 	ipa_smp2p_disable(ipa);
 
-	/* Stop the queue and disable the endpoints if it's open */
+	/* Clean up the netdev and endpoints if it was started */
 	if (netdev) {
-		(void)ipa_stop(netdev);
+		/* If it was opened, stop it first */
+		if (netdev->flags & IFF_UP)
+			(void)ipa_stop(netdev);
 		ipa->name_map[IPA_ENDPOINT_AP_MODEM_RX]->netdev = NULL;
 		ipa->name_map[IPA_ENDPOINT_AP_MODEM_TX]->netdev = NULL;
 		ipa->modem_netdev = NULL;
-- 
2.27.0

