Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8173A16C362
	for <lists+netdev@lfdr.de>; Tue, 25 Feb 2020 15:08:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730684AbgBYOIm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Feb 2020 09:08:42 -0500
Received: from mail-wm1-f65.google.com ([209.85.128.65]:54754 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730656AbgBYOIk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Feb 2020 09:08:40 -0500
Received: by mail-wm1-f65.google.com with SMTP id z12so3128591wmi.4;
        Tue, 25 Feb 2020 06:08:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=ArTAv9akc7/LkDwjVGNvRKjk3sNTR9LtjKLQSrks0NI=;
        b=PDKxN0RElw9PRyO7fCZpANrOwsGJl2RaUOMlQzrM7ZJK3fzkzEvP3QXaZEMAVDMJSq
         e+VsxVTXWKfkY29br29pSKRAFu5G4RGnDvBXYjmT6QGx85wCq5n583l5bLfm0+CyOE+q
         Fze8QB9Ivdwg1/BqVYoOk9rfjbSDtIRovJEOhuMwRB19xdbDU2GLsoQxhLhwPF9LgAVY
         TtO3bLG+eb+8+c4YNhY/p+iIg8inXXVLUBn3A/luUUVFOidgnsE58riyBV1l/sfgplRe
         Rv/g+fTbTotfZZCY9WnRzssSwVi9IdWOSCl47M4YnNPz6kpQrHyDQo4j2OHULr7OlRek
         gXsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ArTAv9akc7/LkDwjVGNvRKjk3sNTR9LtjKLQSrks0NI=;
        b=XVMnifHkh5KwvGmu1PD3LmKaVf1TJVErxbAYHWFunX2uYQ2BHmYtODAaz05kqATHIN
         40NJCkR6Ji2wrGwNDppoTw74UuQhd5jcYHZZMv2AOXK4HzGHNsOBLWQ82es2qHSCzzbx
         4PHGwnK6A785fmza8FgbpkUNIALBGhVHM+G0wcdQUN+QTM13L4b+sJ/nNUpdiX1kuipc
         9TsLtvpaDC4rsPcmgysZPqRlbMf1wKUG0csPN8mxXRQcqiXBjfyKsYw/TqcJSeb60ibg
         DMlp+gHr9XyyBNNHz9M7YDU/9xWyn5K/Lfv2T4QwPSd3htf3wypZEmc7AWNJftzk2+Y9
         EyNg==
X-Gm-Message-State: APjAAAXm4ru3rdBXJ3+Hat/7SK/bYiAuDyGpMoOlHcChusI0aXHBG8v1
        6pPyNYK48uxjvisCDGvTuvQ=
X-Google-Smtp-Source: APXvYqzd4tD4DjZdUUgUg6ejSYxE3QSi9zi7vDtqJz1qP/UD58J1AlJbu8Ldj1JNBzQ4/T63qUh46Q==
X-Received: by 2002:a1c:208a:: with SMTP id g132mr4839399wmg.143.1582639718246;
        Tue, 25 Feb 2020 06:08:38 -0800 (PST)
Received: from ?IPv6:2003:ea:8f29:6000:30a8:e117:ed7d:d145? (p200300EA8F29600030A8E117ED7DD145.dip0.t-ipconnect.de. [2003:ea:8f29:6000:30a8:e117:ed7d:d145])
        by smtp.googlemail.com with ESMTPSA id u8sm4315813wmm.15.2020.02.25.06.08.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 25 Feb 2020 06:08:37 -0800 (PST)
Subject: [PATCH v3 8/8] sound: bt87x: use pci_status_get_and_clear_errors
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
References: <20ca7c1f-7530-2d89-40a6-d97a65aa25ef@gmail.com>
Message-ID: <357c0134-c927-6a97-4333-310983b63ed9@gmail.com>
Date:   Tue, 25 Feb 2020 15:07:43 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20ca7c1f-7530-2d89-40a6-d97a65aa25ef@gmail.com>
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




