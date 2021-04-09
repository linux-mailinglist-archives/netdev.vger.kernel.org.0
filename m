Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 678FD3590FC
	for <lists+netdev@lfdr.de>; Fri,  9 Apr 2021 02:41:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233141AbhDIAjX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Apr 2021 20:39:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232996AbhDIAjW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Apr 2021 20:39:22 -0400
Received: from mail-qt1-x829.google.com (mail-qt1-x829.google.com [IPv6:2607:f8b0:4864:20::829])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD707C061760;
        Thu,  8 Apr 2021 17:39:10 -0700 (PDT)
Received: by mail-qt1-x829.google.com with SMTP id u8so2962319qtq.12;
        Thu, 08 Apr 2021 17:39:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=OvFnHWl8/4Gx0jlI2rHNT0cAkiLDkU+mFrazaADwN18=;
        b=JBZtwNsEfIwjHe5297rgjYqVHfpF0YZC0D3V7g4PPOea6/+RtR4APk9xOnSnalyyLn
         7bHYHPDFY+AzHIheWawwullU/JSjrvSWEzHdFQ3iQirGf6/AzhClMsMbqXIRQvclb9hl
         4UIZqXE6fIXz6llMYGGubgRBx9P/udBISzAOTRGh6fQgQCiw/Ttp786+Ay4NwswxiHQ7
         TLo3qEmaRCA6hC/I11cTA5WTs1zcpnBBzZgVuJ0S1O8pchYh2UoA22XPCtHlqK8r+x03
         e9A4xy8f+5HFq1ki7FZVjx0to3nVIFG4+9HR5rKyfkEiTipta727mdcJedxQqmaaOEPl
         eV0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=OvFnHWl8/4Gx0jlI2rHNT0cAkiLDkU+mFrazaADwN18=;
        b=XBAtU5vhiUnoyU6fVnltVze+m1tfHowhf9AAR0O4BgFg96ZgNOJ20Td3TkXmVmFbAH
         xLoiJUkw3eAnK3YzomlcAcMMpEgVDW1PsHWPm30z9DOs9FVdJF1ntstqFGpeuAzhAxvK
         dtFBt+Rb2xeue2MaS3x46K3cPlMbKATZtJ2loulKA9qGrRiRX8Mvk6H+K8CGW8YnGi2b
         aDVyVlydRBfyEqjXfT0xc6aAiEYr8Qd8Al+ac3enkjI+1E8wrtpyWBAwQQF/0H7TlPVZ
         gGnH0PKBdicEnysPHokTNNieCndCvuINsdrT0+8j71kdrBH16/w+JxGuOWK3WueOEzzP
         fjow==
X-Gm-Message-State: AOAM533kA372PgWQQ4ng+muemxEGC+gVvqSk4R3LNxbNbes62NZUKHJl
        h2cNaeKlr2224wSiIhEMh/E=
X-Google-Smtp-Source: ABdhPJzkeKXFzOvud5n5WrTedvzKVK/dvgDboBn4SoZixRuf6/pMOJWaID5PesTPaHOXYsWfZYbe3A==
X-Received: by 2002:a05:622a:1103:: with SMTP id e3mr10594081qty.346.1617928749337;
        Thu, 08 Apr 2021 17:39:09 -0700 (PDT)
Received: from localhost.localdomain ([198.52.185.246])
        by smtp.gmail.com with ESMTPSA id f12sm819766qti.63.2021.04.08.17.39.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Apr 2021 17:39:09 -0700 (PDT)
From:   Sven Van Asbroeck <thesven73@gmail.com>
X-Google-Original-From: Sven Van Asbroeck <TheSven73@gmail.com>
To:     Bryan Whitehead <bryan.whitehead@microchip.com>,
        David S Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        George McCollister <george.mccollister@gmail.com>
Cc:     Sven Van Asbroeck <thesven73@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>, UNGLinuxDriver@microchip.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net v1] lan743x: fix ethernet frame cutoff issue
Date:   Thu,  8 Apr 2021 20:39:04 -0400
Message-Id: <20210409003904.8957-1-TheSven73@gmail.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sven Van Asbroeck <thesven73@gmail.com>

The ethernet frame length is calculated incorrectly. Depending on
the value of RX_HEAD_PADDING, this may result in ethernet frames
that are too short (cut off at the end), or too long (garbage added
to the end).

Fix by calculating the ethernet frame length correctly. For added
clarity, use the ETH_FCS_LEN constant in the calculation.

Many thanks to Heiner Kallweit for suggesting this solution. 

Fixes: 3e21a10fdea3 ("lan743x: trim all 4 bytes of the FCS; not just 2")
Link: https://lore.kernel.org/lkml/20210408172353.21143-1-TheSven73@gmail.com/
Signed-off-by: Sven Van Asbroeck <thesven73@gmail.com>
---

Tree: git://git.kernel.org/pub/scm/linux/kernel/git/davem/net.git # 864db232dc70

To: Bryan Whitehead <bryan.whitehead@microchip.com>
To: "David S. Miller" <davem@davemloft.net>
To: Jakub Kicinski <kuba@kernel.org>
To: George McCollister <george.mccollister@gmail.com>
Cc: Heiner Kallweit <hkallweit1@gmail.com>
Cc: Andrew Lunn <andrew@lunn.ch>
Cc: UNGLinuxDriver@microchip.com
Cc: netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org

 drivers/net/ethernet/microchip/lan743x_main.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/microchip/lan743x_main.c b/drivers/net/ethernet/microchip/lan743x_main.c
index 1c3e204d727c..7b6794aa8ea9 100644
--- a/drivers/net/ethernet/microchip/lan743x_main.c
+++ b/drivers/net/ethernet/microchip/lan743x_main.c
@@ -885,8 +885,8 @@ static int lan743x_mac_set_mtu(struct lan743x_adapter *adapter, int new_mtu)
 	}
 
 	mac_rx &= ~(MAC_RX_MAX_SIZE_MASK_);
-	mac_rx |= (((new_mtu + ETH_HLEN + 4) << MAC_RX_MAX_SIZE_SHIFT_) &
-		  MAC_RX_MAX_SIZE_MASK_);
+	mac_rx |= (((new_mtu + ETH_HLEN + ETH_FCS_LEN)
+		  << MAC_RX_MAX_SIZE_SHIFT_) & MAC_RX_MAX_SIZE_MASK_);
 	lan743x_csr_write(adapter, MAC_RX, mac_rx);
 
 	if (enabled) {
@@ -1944,7 +1944,7 @@ static int lan743x_rx_init_ring_element(struct lan743x_rx *rx, int index)
 	struct sk_buff *skb;
 	dma_addr_t dma_ptr;
 
-	buffer_length = netdev->mtu + ETH_HLEN + 4 + RX_HEAD_PADDING;
+	buffer_length = netdev->mtu + ETH_HLEN + ETH_FCS_LEN + RX_HEAD_PADDING;
 
 	descriptor = &rx->ring_cpu_ptr[index];
 	buffer_info = &rx->buffer_info[index];
@@ -2040,7 +2040,7 @@ lan743x_rx_trim_skb(struct sk_buff *skb, int frame_length)
 		dev_kfree_skb_irq(skb);
 		return NULL;
 	}
-	frame_length = max_t(int, 0, frame_length - RX_HEAD_PADDING - 4);
+	frame_length = max_t(int, 0, frame_length - ETH_FCS_LEN);
 	if (skb->len > frame_length) {
 		skb->tail -= skb->len - frame_length;
 		skb->len = frame_length;
-- 
2.17.1

