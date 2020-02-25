Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E707B16BA5B
	for <lists+netdev@lfdr.de>; Tue, 25 Feb 2020 08:15:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729382AbgBYHPh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Feb 2020 02:15:37 -0500
Received: from mail-wr1-f68.google.com ([209.85.221.68]:33993 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729335AbgBYHPe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Feb 2020 02:15:34 -0500
Received: by mail-wr1-f68.google.com with SMTP id z15so5020364wrl.1;
        Mon, 24 Feb 2020 23:15:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=JL4Q1l1W07XAcq8S0r/D3xLT9kgasro6XokOt1NtSiI=;
        b=sNgOVtUtBVH9g4vHbaTnPbYePvXiqDx75+340BiDMuOpXp9D2fUVOG6x/LF5k/VJCF
         yJiA9O46SYgz5H3XqhRYwI86U12ki8T0PVox6cPpFwiryC84YBQIBAOMXaWeHDmOK2+n
         kwJCyypXPel8Ywhsak/7vYtGrGu7Yw+miyVBkLOt+vbOs8a+58S9HCXdIP64oPLNtSIo
         jubXOnuK55vYfMDCEMNQWBOumuubD17x9fPi9Vr/EnTBvxh1hmyNNmmr4HG65Igq2U6w
         EFAAqj56T90TCqBTAF82BGtkG3jmezYa2RCTcu7bbrcPneGjAexqEuxGZpC9Iu/CF3UC
         xWew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=JL4Q1l1W07XAcq8S0r/D3xLT9kgasro6XokOt1NtSiI=;
        b=sh7sk24Npz78ufkrrn5LIwu+1X6tmJuFgeAl7ED6NKTmzoCdbEuth8AGddzShqzdzF
         Bbla7Yu7FmOTZ/epUm3CL/LFKUNCtM+SDHaZ54AIUZet8lXCXYXjkHWTb12TbR58fAwT
         E5SC4rHGNdRhcymYzxb2lbVS/wV0piD05MgygQ9qSRLTSOGA9W0e1t4KVQZr2fcbdE2d
         DNL9DNFjSmocg4CAhKTyTKdG8+qJbMV2UDe417lDZUyCG5ywBxTLn0ojqVxZYiESgH5G
         7tyFFFOe2sDoPaqCyGM5Q8TUI2UfkrTlF7U3orChL6yYDuzrVRrOMm0HSZ6vf3mBYxFv
         z6UQ==
X-Gm-Message-State: APjAAAUYifxsp6KWEKzcdmpMQ24JnTAX7W98ISWq/3MTamvSUbMyPGB2
        tMt4yfyqPQp8WcLJkqrJ5Rk=
X-Google-Smtp-Source: APXvYqxRH1CfkaC6NYmv8P3XK4t9Z0BT0pxO8BzU8Jd3hsvMCCwytEBSex/5aJ0YLvHECYsEOiRDMA==
X-Received: by 2002:a5d:4446:: with SMTP id x6mr70507172wrr.312.1582614932475;
        Mon, 24 Feb 2020 23:15:32 -0800 (PST)
Received: from ?IPv6:2003:ea:8f29:6000:6c81:a415:de47:1314? (p200300EA8F2960006C81A415DE471314.dip0.t-ipconnect.de. [2003:ea:8f29:6000:6c81:a415:de47:1314])
        by smtp.googlemail.com with ESMTPSA id u62sm2970426wmu.17.2020.02.24.23.15.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 24 Feb 2020 23:15:32 -0800 (PST)
Subject: [PATCH v2 6/8] net: skfp: use PCI_STATUS_ERROR_BITS
From:   Heiner Kallweit <hkallweit1@gmail.com>
To:     Bjorn Helgaas <bhelgaas@google.com>,
        Realtek linux nic maintainers <nic_swsd@realtek.com>,
        David Miller <davem@davemloft.net>,
        Mirko Lindner <mlindner@marvell.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Clemens Ladisch <clemens@ladisch.de>,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.com>
Cc:     "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        alsa-devel@alsa-project.org
References: <c1a84adc-a864-4f46-c8de-7ea533a7fdc3@gmail.com>
Message-ID: <63935965-d8e9-cbc1-99ed-a7f0c1180c99@gmail.com>
Date:   Tue, 25 Feb 2020 08:12:49 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <c1a84adc-a864-4f46-c8de-7ea533a7fdc3@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use new constant PCI_STATUS_ERROR_BITS to simplify the code.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/fddi/skfp/drvfbi.c  | 2 +-
 drivers/net/fddi/skfp/h/skfbi.h | 5 -----
 2 files changed, 1 insertion(+), 6 deletions(-)

diff --git a/drivers/net/fddi/skfp/drvfbi.c b/drivers/net/fddi/skfp/drvfbi.c
index 9c8aa3a95..d5937aff5 100644
--- a/drivers/net/fddi/skfp/drvfbi.c
+++ b/drivers/net/fddi/skfp/drvfbi.c
@@ -112,7 +112,7 @@ static void card_start(struct s_smc *smc)
 	 */
 	outp(ADDR(B0_TST_CTRL), TST_CFG_WRITE_ON) ;	/* enable for writes */
 	word = inpw(PCI_C(PCI_STATUS)) ;
-	outpw(PCI_C(PCI_STATUS), word | PCI_ERRBITS) ;
+	outpw(PCI_C(PCI_STATUS), word | PCI_STATUS_ERROR_BITS) ;
 	outp(ADDR(B0_TST_CTRL), TST_CFG_WRITE_OFF) ;	/* disable writes */
 
 	/*
diff --git a/drivers/net/fddi/skfp/h/skfbi.h b/drivers/net/fddi/skfp/h/skfbi.h
index 480795681..ccee00b71 100644
--- a/drivers/net/fddi/skfp/h/skfbi.h
+++ b/drivers/net/fddi/skfp/h/skfbi.h
@@ -33,11 +33,6 @@
  */
 #define I2C_ADDR_VPD	0xA0	/* I2C address for the VPD EEPROM */ 
 
-
-#define PCI_ERRBITS	(PCI_STATUS_DETECTED_PARITY | PCI_STATUS_SIG_SYSTEM_ERROR | PCI_STATUS_REC_MASTER_ABORT | PCI_STATUS_SIG_TARGET_ABORT | PCI_STATUS_PARITY)
-
-
-
 /*
  *	Control Register File:
  *	Bank 0
-- 
2.25.1



