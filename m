Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 67B5A3ADC12
	for <lists+netdev@lfdr.de>; Sun, 20 Jun 2021 01:24:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230118AbhFSX1B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 19 Jun 2021 19:27:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230043AbhFSX0z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 19 Jun 2021 19:26:55 -0400
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 128B4C061760;
        Sat, 19 Jun 2021 16:24:42 -0700 (PDT)
Received: by mail-pj1-x102f.google.com with SMTP id o88-20020a17090a0a61b029016eeb2adf66so10095302pjo.4;
        Sat, 19 Jun 2021 16:24:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=aUiuab4URXt7mOaGUaiOzcVBQQH+x06S+qB6OtAcYzM=;
        b=tQomCpTSA8sohrggrR83XnSJyFfahJwMbYCRorAHoFscfqRDBjRnQ0OF/4yBuFGHMS
         nKkdk6ogPkr63n6fZxkd1VSHwfi3krYVnRUNgItUfCvFOLV/eeNmDwB6z7N/hKfLUY/p
         iFYNX+dthgQoAVWOkwpMBoCph3WCnKVEQKbyG6NnlBFIgQWaN20+RHdgX5hb95lV6Pwy
         d9290EnaHtMvgKTsr5avGU24hcRmE2S5VNOZ8L3Bl7s5KnAhvdAqOD5lFthL141704nD
         FUkSvl5gm0Po1z+4AKDynKNIirtxdr7pYwuWLNIzjUN2OvRQ5PhB2GRP9Ux3hbzevG/K
         iSuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=aUiuab4URXt7mOaGUaiOzcVBQQH+x06S+qB6OtAcYzM=;
        b=o/H0UeR/jKpDsz0OW0WlOT0fw98z2B3uGIPqiA6UU0bsKpw5+ksnqv7VWBsHXvn7/7
         vz0dpRxKKzLakTRZsnxkINR2miF14FY0QgomFTzfBiCCvQkVlqwOnHSHyySlEd+GKutX
         c/QZbWOueOs/Wz+Vk0cM62ZPCSDiYETAQZdJUQFUGC6NqN2IuYuT7MVoUjsPjDswmcnx
         8lfGT9sKcrYOOTZU6jFDsU3vNfMP+mtyZDniid/B2aWK9vsTD/sKFYcXRm1xn3VWcSCo
         ktTU+BYGplKGA3fr8yzhorp20GvgxcdvyazeAgzDXRbIFiWp/412yd0MRL3zgTEUupPS
         UYgA==
X-Gm-Message-State: AOAM533Pt1vwL4GfF030Xpp7mWu3MC+EulIJZpNOJvVHMuwniBKSYZOT
        KlQZgxG67R2U1R8ef2dq1OA=
X-Google-Smtp-Source: ABdhPJxuGWCTGU8ZV/mjRUxLaySOLhuVkqeIc45o8gFc105KC1eGwB9oGMjDD8qRkcbKTNVdYSteNw==
X-Received: by 2002:a17:902:b110:b029:121:74a8:25e5 with SMTP id q16-20020a170902b110b029012174a825e5mr9243211plr.44.1624145081647;
        Sat, 19 Jun 2021 16:24:41 -0700 (PDT)
Received: from xplor.waratah.dyndns.org (222-152-189-137-fibre.sparkbb.co.nz. [222.152.189.137])
        by smtp.gmail.com with ESMTPSA id w123sm4398194pff.186.2021.06.19.16.24.40
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 19 Jun 2021 16:24:41 -0700 (PDT)
Received: by xplor.waratah.dyndns.org (Postfix, from userid 1000)
        id D73C83603E5; Sun, 20 Jun 2021 11:24:37 +1200 (NZST)
From:   Michael Schmitz <schmitzmic@gmail.com>
To:     linux-m68k@vger.kernel.org, geert@linux-m68k.org
Cc:     alex@kazik.de, Michael Schmitz <schmitzmic@gmail.com>,
        netdev@vger.kernel.org
Subject: [PATCH netdev v6 3/3] net/8390: apne.c - autoprobe 100 Mbit mode in apne.c driver
Date:   Sun, 20 Jun 2021 11:24:33 +1200
Message-Id: <1624145073-12674-4-git-send-email-schmitzmic@gmail.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1624145073-12674-1-git-send-email-schmitzmic@gmail.com>
References: <1624145073-12674-1-git-send-email-schmitzmic@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add experimental autoprobe code to detect 16 bit/100 MBit
cards to the APNE driver. Autoprobe uses the same code utilized
in apne_probe1 to identify the 8390 chip - failure to identify
the chip in 8 bit mode will switch the PCMCIA interface to 16
bit mode. This code is still untested!

This patch depends on patch "m68k: io_mm.h - add APNE 100
MBit support" sent to linux-m68k, and must not be applied
before that one!

CC: netdev@vger.kernel.org
Link: https://lore.kernel.org/r/1622958877-2026-1-git-send-email-schmitzmic@gmail.com
Signed-off-by: Michael Schmitz <schmitzmic@gmail.com>
---
 drivers/net/ethernet/8390/apne.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/drivers/net/ethernet/8390/apne.c b/drivers/net/ethernet/8390/apne.c
index 4dd721e..ec165f8 100644
--- a/drivers/net/ethernet/8390/apne.c
+++ b/drivers/net/ethernet/8390/apne.c
@@ -156,6 +156,22 @@ struct net_device * __init apne_probe(int unit)
 		return ERR_PTR(-ENODEV);
 	}
 
+	/* Reset card. Who knows what dain-bramaged state it was left in. */
+	{
+		unsigned long reset_end_time = jiffies + msecs_to_jiffies(20);
+
+		outb(inb(IOBASE + NE_RESET), IOBASE + NE_RESET);
+
+		while ((inb(IOBASE + NE_EN0_ISR) & ENISR_RESET) == 0)
+			if (time_after(jiffies, reset_end_time)) {
+				pr_info("Card not found (no reset ack).\n");
+				isa_type = ISA_TYPE_AG16;
+				break;
+			}
+
+		outb(0xff, IOBASE + NE_EN0_ISR);		/* Ack all intr. */
+	}
+
 	dev = alloc_ei_netdev();
 	if (!dev)
 		return ERR_PTR(-ENOMEM);
-- 
2.7.4

