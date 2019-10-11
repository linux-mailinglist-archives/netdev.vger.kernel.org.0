Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1A4A4D4795
	for <lists+netdev@lfdr.de>; Fri, 11 Oct 2019 20:28:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728852AbfJKS2X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Oct 2019 14:28:23 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:38195 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728587AbfJKS2W (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Oct 2019 14:28:22 -0400
Received: by mail-pg1-f196.google.com with SMTP id x10so6255502pgi.5
        for <netdev@vger.kernel.org>; Fri, 11 Oct 2019 11:28:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=8oCcxD88VFm1cXltnKInhOC0dvYbRf3OZje5KuISZ28=;
        b=DmSSa+o/fbCnmcSE8r3LLdGEcw4nF+cZDPt6n9Uav/Mh/6eUQUBdpUuOVjFil99enF
         yW+l+bqqnjB2LexYRbSpMwtzwWFE8E9D/KnGVyNJulBfAtHABiiSDzWBGbr2X/OK+XT8
         L9Hviw5kazL60EJ6JyhVmA3PsPTO5Un7UcOuq97b7+LwEoOnaInyOvbl78GA8DDCEIu4
         pKdxSQq3K3wzCSHxveT1nB+mV+iSi/AR5oKe8Z4vigMNNzWYy96byVbfG3DpQQRkesij
         1jl1r0OfXGl8OxMN96Wtp706aglMlW6IEQw6UURw+hIsGYJAX+wP3AqwzZkaV0dSvvrt
         Iz+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=8oCcxD88VFm1cXltnKInhOC0dvYbRf3OZje5KuISZ28=;
        b=TEv+Pd+VKa/hXBkygxEWVrTWao9DYMIky7TUxfP+gKCRPczH+6CVZmW8i9d4vejsDo
         XMf6gdpg6YoTfC0gQhgOIubvvwVqt9n8vHRX0u/mVAivSjqn/YCQdAUROm+Wj7y+eeWA
         u/ilti9KHvxSrlvLlm4LjaOwLbT3fuIJEkTCpcDuxIkaVcfurNvhtnRi25JXyT9ivI1P
         5ee3IMa4BPdAA491Wp3BOBy3G4kcR0Fx4mXgP5pVtoIm+aGm/bXASSm4i5z9LbC07I1z
         XTvEtHf1pCV62FhkSMQ2UkC10UFEWLVNwqDCaoNyH705qa5DGoYX6VeAsa/2GU/pTe4n
         yqGA==
X-Gm-Message-State: APjAAAXtAC4gcYfNE6aj/vjgDcRdkcGYdu4zbhujVBar+6Az9SAiVMxr
        ueyH2GcO4p6t65OOTLQJ6NMS9w==
X-Google-Smtp-Source: APXvYqw0pkpNYcFqFnQAxe70uYZ67hQnflJjxtKuMR2lnBw5aheockxkUpH2gAVY12yHDaYAukkmnw==
X-Received: by 2002:a17:90b:288:: with SMTP id az8mr19023217pjb.18.1570818501530;
        Fri, 11 Oct 2019 11:28:21 -0700 (PDT)
Received: from localhost.localdomain (104-188-17-28.lightspeed.sndgca.sbcglobal.net. [104.188.17.28])
        by smtp.gmail.com with ESMTPSA id a11sm8652343pfo.165.2019.10.11.11.28.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Oct 2019 11:28:20 -0700 (PDT)
From:   Bjorn Andersson <bjorn.andersson@linaro.org>
To:     Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     ath10k@lists.infradead.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Niklas Cassel <niklas.cassel@linaro.org>
Subject: [PATCH v2] ath10k: Correct error handling of dma_map_single()
Date:   Fri, 11 Oct 2019 11:28:17 -0700
Message-Id: <20191011182817.194565-1-bjorn.andersson@linaro.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191010162653.141303-1-bjorn.andersson@linaro.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The return value of dma_map_single() should be checked for errors using
dma_mapping_error() and the skb has been dequeued so it needs to be
freed.

Fixes: 1807da49733e ("ath10k: wmi: add management tx by reference support over wmi")
Reported-by: Niklas Cassel <niklas.cassel@linaro.org>
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
---

Changes since v1:
- Free the dequeued skb

 drivers/net/wireless/ath/ath10k/mac.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index 3d2c8fcba952..e8bdb2ba9b18 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -3904,8 +3904,10 @@ void ath10k_mgmt_over_wmi_tx_work(struct work_struct *work)
 			     ar->running_fw->fw_file.fw_features)) {
 			paddr = dma_map_single(ar->dev, skb->data,
 					       skb->len, DMA_TO_DEVICE);
-			if (!paddr)
+			if (dma_mapping_error(ar->dev, paddr)) {
+				ieee80211_free_txskb(ar->hw, skb);
 				continue;
+			}
 			ret = ath10k_wmi_mgmt_tx_send(ar, skb, paddr);
 			if (ret) {
 				ath10k_warn(ar, "failed to transmit management frame by ref via WMI: %d\n",
-- 
2.23.0

