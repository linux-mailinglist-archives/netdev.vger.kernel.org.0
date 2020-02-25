Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1400516BA57
	for <lists+netdev@lfdr.de>; Tue, 25 Feb 2020 08:15:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729417AbgBYHPj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Feb 2020 02:15:39 -0500
Received: from mail-wr1-f65.google.com ([209.85.221.65]:33049 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729304AbgBYHPh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Feb 2020 02:15:37 -0500
Received: by mail-wr1-f65.google.com with SMTP id u6so13385574wrt.0;
        Mon, 24 Feb 2020 23:15:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=ArTAv9akc7/LkDwjVGNvRKjk3sNTR9LtjKLQSrks0NI=;
        b=MC4+e4ife2Gh64bc+EMgs/BG3MJuzNXdKx07cPWb8fE+IasPplxhjc9iKuE+CDe5Y/
         FXN9Ys8T/wrGEohteL4dNX2p233OmXqhXS9IcCPcFOI0NnLHSptilSvTMQZvmJ1FnEnf
         K70iLwE/h7c5RibI7XjnPvd53atMlbgyXpq+AZhcLW+B2sJ8detn6G6uD8xO2jZyBKRy
         9/sxOUwOba8qaC8Jbb4yE8OLmGwpkb+qp2OyluKeFUnzREqPQYmE/PPZe84UDfpAmd7/
         YrxD/RgKzda2GZJHnD1ar/UDxVCgbfP/p9XWl+77TqalROJYpr4VWhMh6B67qDbMRv/9
         TH6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ArTAv9akc7/LkDwjVGNvRKjk3sNTR9LtjKLQSrks0NI=;
        b=l2wYxQ0qPeEr87SWxEJy2OMmxG1BxqiKT/VaAnA5xn7SDLmlA91YMCZFFrM1oNmXHT
         Fk3jytfAYxWhDnnWFkGc3SfYZuI3uiG5dgc1qNjmWOhuBioO5c6H+5efuQxkX1wLvQHj
         px2uQkzwVuH3doM2uiALxPpKzkYmiko57xoyV765kwSOM2CTerfst4YM+qmnyaQLMgPD
         JRzc/+J73RaYIZ2IzjEpLl5Blr6b+lXFv5nFS7IGMEDR5md9zXNiPjPNaPE2cvDr649p
         BSuLsvWN5TCz98mB3T2UDx/lTB+iG+/+71P1jj/IBmBpPMSAYQnaYYtchJq64rXFNlDE
         tIiw==
X-Gm-Message-State: APjAAAUlvI4vJ+OcQqmACgYTyCYTglrcpN0tWuAG6Sobo5aHvIBqVb2A
        mmJ5z+5Q17oJEIoqJEXpHjE=
X-Google-Smtp-Source: APXvYqy704kFsRRnKtcQSoh4hwSgxANV9/Noxui7kaUUbuPb/g1nSEMuKwvVA1VKPuNfK7wgJqQDtQ==
X-Received: by 2002:adf:f310:: with SMTP id i16mr73552955wro.326.1582614934975;
        Mon, 24 Feb 2020 23:15:34 -0800 (PST)
Received: from ?IPv6:2003:ea:8f29:6000:6c81:a415:de47:1314? (p200300EA8F2960006C81A415DE471314.dip0.t-ipconnect.de. [2003:ea:8f29:6000:6c81:a415:de47:1314])
        by smtp.googlemail.com with ESMTPSA id d13sm23566806wrc.64.2020.02.24.23.15.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 24 Feb 2020 23:15:34 -0800 (PST)
Subject: [PATCH v2 8/8] sound: bt87x: use pci_status_get_and_clear_errors
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
Message-ID: <76570497-71b6-f507-8743-77ab4b4e51a5@gmail.com>
Date:   Tue, 25 Feb 2020 08:14:51 +0100
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



