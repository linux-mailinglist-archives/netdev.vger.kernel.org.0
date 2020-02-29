Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C3A4A1749A3
	for <lists+netdev@lfdr.de>; Sat, 29 Feb 2020 23:29:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727706AbgB2W3j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 29 Feb 2020 17:29:39 -0500
Received: from mail-wm1-f68.google.com ([209.85.128.68]:36282 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727683AbgB2W3h (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 29 Feb 2020 17:29:37 -0500
Received: by mail-wm1-f68.google.com with SMTP id g83so4986254wme.1;
        Sat, 29 Feb 2020 14:29:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=ArTAv9akc7/LkDwjVGNvRKjk3sNTR9LtjKLQSrks0NI=;
        b=KTjP3MnXb3IuC17bTkl0ejBvKT9Av9U/SFFskEbtdMsCVKLvXyFvSi+aOCBLj+zIDQ
         q14C0rai6OSDkiCQCFm4nXrbLC4MNqQM4H59v2hZm7cU99aKVP11LSRCoHb8gc4df5JV
         NZSt4dtNMS5U5j62NRFBH6+e14MEdEIRy0y3F28lNynncr8/IRqBabT0YYv03Zx8vG5Q
         aJxCPgm89P4xXot19eR0FapPagr9vdMjBgoqHMub62EA4OCUX5dp5JWz9qUmm/ZELYlO
         B10fGE+Vmz2OuMbEwwyMUwTiP82wOnK+I9DtyfIrtbxPVSEAHRiAkYWbGF2xIl3HS+i6
         Syug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ArTAv9akc7/LkDwjVGNvRKjk3sNTR9LtjKLQSrks0NI=;
        b=E6mWfZMV2E9kFuJ8aBl923jS5c6LMo12S0qKtur2zIFtMNR/egANVZEiwERytWikvT
         vz2jp+25l/v1nBVvoYfyy+3UzKMMXcMC0bWW4uXSF5Dv+FAR2OKkNX9wR1LzhWlhj2pR
         o4NmBGBREyLsbCWflNhLi4rmN0B4u50Gg05yBqJqrcF3wU5EGJjwUySaIWSr1IkcuBHQ
         eUipDqj4ajJyycZDQZYmh6LRSTBRl2tclDCN0dFSDWEOBnmH06MRANcohy41W1dA9bEK
         8xgK6twmLQZKFw3vLyQWdf5ObN2SaiFurND3CJrvZ2LdR+zgcd4QFoBajaPGDTvA0k9r
         Z/LA==
X-Gm-Message-State: APjAAAX178ymRNX+c9Je9i/6wbrRMV4t4CC44jebkQ30KzlaNfcmZame
        y3kG9F3pYanO3fLvh1mbhxM=
X-Google-Smtp-Source: APXvYqz8zstsmbCwyCSgdDGDvjCyOgoD6VFSBh/oElf4FvZFQ/a9OG+ckjo41iEPN8XCm++cEHZ2Fg==
X-Received: by 2002:a7b:cb46:: with SMTP id v6mr4613642wmj.0.1583015375725;
        Sat, 29 Feb 2020 14:29:35 -0800 (PST)
Received: from ?IPv6:2003:ea:8f29:6000:7150:76fe:91ca:7ab5? (p200300EA8F296000715076FE91CA7AB5.dip0.t-ipconnect.de. [2003:ea:8f29:6000:7150:76fe:91ca:7ab5])
        by smtp.googlemail.com with ESMTPSA id e11sm18699606wrm.80.2020.02.29.14.29.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 29 Feb 2020 14:29:35 -0800 (PST)
Subject: [PATCH v4 10/10] sound: bt87x: use pci_status_get_and_clear_errors
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
References: <adeb9e6e-9be6-317f-3fc0-a4e6e6af5f81@gmail.com>
Message-ID: <6362e866-9ce3-31f5-3357-9f086eedf11e@gmail.com>
Date:   Sat, 29 Feb 2020 23:29:07 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <adeb9e6e-9be6-317f-3fc0-a4e6e6af5f81@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use new helper pci_status_get_and_clear_errors() to simplify the code.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 sound/pci/bt87x.c | 7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/sound/pci/bt87x.c b/sound/pci/bt87x.c
index 8c48864c8..656750466 100644
--- a/sound/pci/bt87x.c
+++ b/sound/pci/bt87x.c
@@ -271,13 +271,8 @@ static void snd_bt87x_free_risc(struct snd_bt87x *chip)
 
 static void snd_bt87x_pci_error(struct snd_bt87x *chip, unsigned int status)
 {
-	u16 pci_status;
+	int pci_status = pci_status_get_and_clear_errors(chip->pci);
 
-	pci_read_config_word(chip->pci, PCI_STATUS, &pci_status);
-	pci_status &= PCI_STATUS_PARITY | PCI_STATUS_SIG_TARGET_ABORT |
-		PCI_STATUS_REC_TARGET_ABORT | PCI_STATUS_REC_MASTER_ABORT |
-		PCI_STATUS_SIG_SYSTEM_ERROR | PCI_STATUS_DETECTED_PARITY;
-	pci_write_config_word(chip->pci, PCI_STATUS, pci_status);
 	if (pci_status != PCI_STATUS_DETECTED_PARITY)
 		dev_err(chip->card->dev,
 			"Aieee - PCI error! status %#08x, PCI status %#04x\n",
-- 
2.25.1


