Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD3672CE7CB
	for <lists+netdev@lfdr.de>; Fri,  4 Dec 2020 06:49:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727756AbgLDFsk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Dec 2020 00:48:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726473AbgLDFsk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Dec 2020 00:48:40 -0500
Received: from mail-pl1-x641.google.com (mail-pl1-x641.google.com [IPv6:2607:f8b0:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58A7BC061A54
        for <netdev@vger.kernel.org>; Thu,  3 Dec 2020 21:48:25 -0800 (PST)
Received: by mail-pl1-x641.google.com with SMTP id bj5so2514159plb.4
        for <netdev@vger.kernel.org>; Thu, 03 Dec 2020 21:48:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=y7EynX2L+/K+TDAwkM7wF7so7EiYohDxo9L9/ds5HxU=;
        b=H6nL9Jq4aDTLP8qbq6Y02TOyqRE08gsiDtoO15tsbpVX7cB/i9ibNE0yDRgg3n00bC
         byrqROhSjTDGk5u6vUNpXHeW7VV2exRWPMeR6nNbqaJwFqCvy+lHRwJJ+21yfmLgyjDd
         m2WAFi58qCwbj7XzG+c0Nd+zbfAfGZexVWcIwyP0qvQU9doKhCHON8gH8geQ5zP7Ij/I
         W5Ff2xPHZqwTPSFfBruxNU1tbo3v6re5gjIMJl4mJZOZ8/QHPSHCtd0Nyp8fgihbCz+W
         ZeUKRcVpncgyn796F2Qrnl/DFReTCCcVCwcKJfdhpgaYY4+N8ls5f9sgVg//Tn7fgzCx
         Z/0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=y7EynX2L+/K+TDAwkM7wF7so7EiYohDxo9L9/ds5HxU=;
        b=RKcBXs3oDFjCDdZb6AASopQ4dqGToAp9OYewtagg7lmwDdcRexABitjsnpw9vM4ave
         FpTMhghBm9jaGJal0ZOxM3VssKez1q2XIcScrr6gEvWcwCfxXedfXhUalJ5Ht04tidlp
         e82gOF9rQm8L0gvp5W8rnqPYg5pK8WpBZaOj2MJcE1PwhIC91hYYCMDjMciaWEShpMiG
         S7Z+xRC7xW01O9zq5pOXPVjbqD0GIT0+ddiTtUuqMDoPV8zOSY4kGiW+YeyHTW9Z2dO/
         ucitRLXWXWPtTr1Rmbi9Yp95+rqH3gUYpk37vg6l2PcBG9DBitz82C7F7OJ1UvhJKbxE
         kCaQ==
X-Gm-Message-State: AOAM533rXha/NOgMXS61k2rOTB87ixqmFn1hCuteunP9HrHKHTITl9SG
        WIkBdJrKO31Pfjnh20V1Xm4=
X-Google-Smtp-Source: ABdhPJwdEHgnTwQsD940zDi5R7RTLwXOPAjQUhpUqhEfDk/zxQdrhN+R1gwvymooGDA741PaCp7+2A==
X-Received: by 2002:a17:90a:4f03:: with SMTP id p3mr2673793pjh.69.1607060904946;
        Thu, 03 Dec 2020 21:48:24 -0800 (PST)
Received: from DESKTOP-8REGVGF.localdomain ([211.25.125.254])
        by smtp.gmail.com with ESMTPSA id u205sm3542134pfc.146.2020.12.03.21.48.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Dec 2020 21:48:24 -0800 (PST)
From:   Sieng Piaw Liew <liew.s.piaw@gmail.com>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     bcm-kernel-feedback-list@broadcom.com,
        Sieng Piaw Liew <liew.s.piaw@gmail.com>,
        netdev@vger.kernel.org
Subject: [PATCH net-next] bcm63xx_enet: alloc rx skb with NET_IP_ALIGN
Date:   Fri,  4 Dec 2020 13:46:15 +0800
Message-Id: <20201204054616.26876-3-liew.s.piaw@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201204054616.26876-1-liew.s.piaw@gmail.com>
References: <20201204054616.26876-1-liew.s.piaw@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use netdev_alloc_skb_ip_align on newer SoCs with integrated switch
(enetsw) when refilling RX. Increases packet processing performance
by 30% (with netif_receive_skb_list).

Non-enetsw SoCs cannot function with the extra pad so continue to use
the regular netdev_alloc_skb.

Tested on BCM6328 320 MHz and iperf3 -M 512 to measure packet/sec
performance.

Before:
[ ID] Interval Transfer Bandwidth Retr
[ 4] 0.00-30.00 sec 120 MBytes 33.7 Mbits/sec 277 sender
[ 4] 0.00-30.00 sec 120 MBytes 33.5 Mbits/sec receiver

After (+netif_receive_skb_list):
[ 4] 0.00-30.00 sec 155 MBytes 43.3 Mbits/sec 354 sender
[ 4] 0.00-30.00 sec 154 MBytes 43.1 Mbits/sec receiver

Signed-off-by: Sieng Piaw Liew <liew.s.piaw@gmail.com>
---
 drivers/net/ethernet/broadcom/bcm63xx_enet.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/broadcom/bcm63xx_enet.c b/drivers/net/ethernet/broadcom/bcm63xx_enet.c
index c1eba5fa3258..92bff4758216 100644
--- a/drivers/net/ethernet/broadcom/bcm63xx_enet.c
+++ b/drivers/net/ethernet/broadcom/bcm63xx_enet.c
@@ -237,7 +237,10 @@ static int bcm_enet_refill_rx(struct net_device *dev)
 		desc = &priv->rx_desc_cpu[desc_idx];
 
 		if (!priv->rx_skb[desc_idx]) {
-			skb = netdev_alloc_skb(dev, priv->rx_skb_size);
+			if (priv->enet_is_sw)
+				skb = netdev_alloc_skb_ip_align(dev, priv->rx_skb_size);
+			else
+				skb = netdev_alloc_skb(dev, priv->rx_skb_size);
 			if (!skb)
 				break;
 			priv->rx_skb[desc_idx] = skb;
-- 
2.17.1

