Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 819FA15398A
	for <lists+netdev@lfdr.de>; Wed,  5 Feb 2020 21:32:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727116AbgBEUcP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Feb 2020 15:32:15 -0500
Received: from mail-pj1-f68.google.com ([209.85.216.68]:55865 "EHLO
        mail-pj1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726534AbgBEUcO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Feb 2020 15:32:14 -0500
Received: by mail-pj1-f68.google.com with SMTP id d5so1462359pjz.5;
        Wed, 05 Feb 2020 12:32:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=5k3GTO4Ci6TDhcdvKol5kmWU37sOCm3ftBm1LMOT+MM=;
        b=EoTJJkWz3RFGJjnoqsl1kIYmXpckaA6QnVfPv57Gaoqksw6p/PLC0FZMtQHJMHC+u3
         cEoZttq7yhX163EL+5v2FPuvlZaiUrLevVt8kZhCmrZUiESbOc6LOJpjyShRsU/KzG+a
         Wl8LAs/yQOKzTZiHESFFZBd6vpwXffJTtoUj/UuwG4DilKnhAfQMNjN6h2q8MxsWiNzX
         8WF8VLXdHsQiW63sillbtyQnFRBQPtCUok0Lv6XOQlIhfAxggGEddsjsiY57920Eql60
         LBnPE4qS0goIwf3CCK8RBgZdRhuUoAPTm4DKe0vpN7R3wY8gLnAn9/SfETvunDcaWDRW
         FzqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=5k3GTO4Ci6TDhcdvKol5kmWU37sOCm3ftBm1LMOT+MM=;
        b=qJm8irkng4140OQf8VmFGck1/4K7U3QL+8YF/3vdbVtQRNh7FIm6obz6qIH3kVpRCV
         9vPRixNvXYzJ6zaEnlN5UrnpojInpMcErWbInlOemdbyZAJmZwgUncmITxiD/QA00jY7
         YtpssumXDHSnn2SiJWqHp/uWoVnMP9rjHYJCcBUeVfUBpEDAB8oMBty7OXXuZj4aSlV1
         A+3zsy+9Tp8/qSGcgQ5ft5kjJyqoICwuHCibl91cEANGZGMw91UQjJnIjxxtSZY0wa5y
         HW/x0fJqkfivpgsIcokOE8KFFdX3vaYAfUn+AcCULb/zdW/W7q8E7v0CeU1J4uB+/RXL
         6SZA==
X-Gm-Message-State: APjAAAXm7+a5v+lD7BNBysJtOmf9S08q+xxiFgk0KZIIJkLc+1E79/50
        cbIbP+NlEGBhV39CWvc4zixMrUiA
X-Google-Smtp-Source: APXvYqzlQzWTQdLMhCSUkxHMjXcnATWIB7EGLMW8mc1KF/nm7DXsGGrcx1r2LZ4t6dL1GVUamCo7Ng==
X-Received: by 2002:a17:90a:8545:: with SMTP id a5mr7666841pjw.43.1580934733817;
        Wed, 05 Feb 2020 12:32:13 -0800 (PST)
Received: from fainelli-desktop.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id a22sm375939pfk.108.2020.02.05.12.32.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Feb 2020 12:32:13 -0800 (PST)
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        bcm-kernel-feedback-list@broadcom.com (open list:BROADCOM SYSTEMPORT
        ETHERNET DRIVER), linux-kernel@vger.kernel.org (open list)
Subject: [PATCH net] net: systemport: Avoid RBUF stuck in Wake-on-LAN mode
Date:   Wed,  5 Feb 2020 12:32:04 -0800
Message-Id: <20200205203204.14511-1-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

After a number of suspend and resume cycles, it is possible for the RBUF
to be stuck in Wake-on-LAN mode, despite the MPD enable bit being
cleared which instructed the RBUF to exit that mode.

Avoid creating that problematic condition by clearing the RX_EN and
TX_EN bits in the UniMAC prior to disable the Magic Packet Detector
logic which is guaranteed to make the RBUF exit Wake-on-LAN mode.

Fixes: 83e82f4c706b ("net: systemport: add Wake-on-LAN support")
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
 drivers/net/ethernet/broadcom/bcmsysport.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/ethernet/broadcom/bcmsysport.c b/drivers/net/ethernet/broadcom/bcmsysport.c
index f07ac0e0af59..e0611cba87f9 100644
--- a/drivers/net/ethernet/broadcom/bcmsysport.c
+++ b/drivers/net/ethernet/broadcom/bcmsysport.c
@@ -2736,6 +2736,9 @@ static int __maybe_unused bcm_sysport_resume(struct device *d)
 
 	umac_reset(priv);
 
+	/* Disable the UniMAC RX/TX */
+	umac_enable_set(priv, CMD_RX_EN | CMD_TX_EN, 0);
+
 	/* We may have been suspended and never received a WOL event that
 	 * would turn off MPD detection, take care of that now
 	 */
-- 
2.17.1

