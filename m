Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 07596136128
	for <lists+netdev@lfdr.de>; Thu,  9 Jan 2020 20:35:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730825AbgAITfp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jan 2020 14:35:45 -0500
Received: from mail-wr1-f67.google.com ([209.85.221.67]:35701 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730740AbgAITfo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Jan 2020 14:35:44 -0500
Received: by mail-wr1-f67.google.com with SMTP id g17so8681932wro.2
        for <netdev@vger.kernel.org>; Thu, 09 Jan 2020 11:35:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=faJc05eiCFXD6NkK/NG5YU4KFjBxTKDLFIHM/Oa7UWM=;
        b=Bm4xZPhWG8FUkkxFV4AqOicM2wyma86QrGmkmshMblyvmOce5xWQp9zuea8CmXA11l
         NjGaLwr05PAJ5YGuFy7+JN3l9JFgBZEe8iCCpoXe+xXHcRorWSeVkiC95o7GmnUhCmRR
         zTlo44gzPS/8iSbrjpSjDH04n95B17SBnY5/J6d2nispb6h3pYQD6+uPGRhrvid+jDqV
         61vdrHHh6H47wDy5n/DdmF/gR/jrCrzc0THlcFWHbRn4/dEpvB7YlQDCryfoCMsddrZs
         erFpSZ8nMaesC4khiTj9XHVAzkogyhk0eQB8hfFBL1RChQBdQyvGLxkobsTVqXOl9hj+
         Vq1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=faJc05eiCFXD6NkK/NG5YU4KFjBxTKDLFIHM/Oa7UWM=;
        b=ISHP+PBMg8HUWr/boc36VQve3mlxwgBz798s3YSSFJbKpZKOd5IJLycQ2TtXqOQIYE
         t8wnFYsw7Z6hD8yX+h94YYzDB5L4Ba3YRwknZaFPkwLlAiCmZU2FwXziMxLlMeSa8apD
         OnLdokxehkGXNs0hz8ryXmif0ZaLkpyKdnYQJEgB04ZN9+teh12OtpVMFrXEJFIZJ+WO
         QvDR1IclHXee5MimRBX6CEVsARD46SlC97A5cfd8tofRq1AO/S/UdPYK5azc/iBonndu
         4ai662daj51n6aLcaoL7DvwWHpxXf0ABZvDbt8CSX9n9Mg4tvSaU664O67uaO1sj+rbw
         qAXQ==
X-Gm-Message-State: APjAAAWaOir3rrxa37dmWUvgoOtDD9YJfBp0GCqSFz3jCh/VFTDL+orv
        boT8rdlDH+cLjqhUvIT2dxnjRVKU
X-Google-Smtp-Source: APXvYqz231FHSseYVQ/+gZrzjNl+nl/+yl62zC7WMp8Nd73N7V4Rj6r1T+B0GIkVv3jChIpet7Bkhw==
X-Received: by 2002:adf:ef49:: with SMTP id c9mr12302943wrp.292.1578598542637;
        Thu, 09 Jan 2020 11:35:42 -0800 (PST)
Received: from [192.168.178.85] (pD9F901D9.dip0.t-ipconnect.de. [217.249.1.217])
        by smtp.googlemail.com with ESMTPSA id s19sm3725487wmj.33.2020.01.09.11.35.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 09 Jan 2020 11:35:42 -0800 (PST)
Subject: [PATCH net-next 08/15] r8169: move disabling MAC EEE for
 RTL8402/RTL8106e
From:   Heiner Kallweit <hkallweit1@gmail.com>
To:     Realtek linux nic maintainers <nic_swsd@realtek.com>,
        David Miller <davem@davemloft.net>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <7e03fe05-ba95-c3c0-9a68-306b6450a141@gmail.com>
Message-ID: <878c74ef-566d-1b21-b5cb-6d550ac25095@gmail.com>
Date:   Thu, 9 Jan 2020 20:30:00 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.1
MIME-Version: 1.0
In-Reply-To: <7e03fe05-ba95-c3c0-9a68-306b6450a141@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Move configuring EEE on MAC side out of the PHY configuration.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/ethernet/realtek/r8169_main.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index d157c971c..3fb3f2ac6 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -3400,7 +3400,6 @@ static void rtl8402_hw_phy_config(struct rtl8169_private *tp,
 	rtl_apply_firmware(tp);
 
 	/* EEE setting */
-	rtl_eri_write(tp, 0x1b0, ERIAR_MASK_0011, 0x0000);
 	rtl_writephy(tp, 0x1f, 0x0004);
 	rtl_writephy(tp, 0x10, 0x401f);
 	rtl_writephy(tp, 0x19, 0x7030);
@@ -3423,7 +3422,6 @@ static void rtl8106e_hw_phy_config(struct rtl8169_private *tp,
 
 	rtl_apply_firmware(tp);
 
-	rtl_eri_write(tp, 0x1b0, ERIAR_MASK_0011, 0x0000);
 	rtl_writephy_batch(phydev, phy_reg_init);
 }
 
@@ -4983,6 +4981,9 @@ static void rtl_hw_start_8402(struct rtl8169_private *tp)
 	rtl_eri_write(tp, 0xb8, ERIAR_MASK_0011, 0x0000);
 	rtl_w0w1_eri(tp, 0x0d4, ERIAR_MASK_0011, 0x0e00, 0xff00);
 
+	/* disable EEE */
+	rtl_eri_write(tp, 0x1b0, ERIAR_MASK_0011, 0x0000);
+
 	rtl_pcie_state_l2l3_disable(tp);
 }
 
@@ -4999,6 +5000,9 @@ static void rtl_hw_start_8106(struct rtl8169_private *tp)
 
 	rtl_eri_write(tp, 0x1d0, ERIAR_MASK_0011, 0x0000);
 
+	/* disable EEE */
+	rtl_eri_write(tp, 0x1b0, ERIAR_MASK_0011, 0x0000);
+
 	rtl_pcie_state_l2l3_disable(tp);
 	rtl_hw_aspm_clkreq_enable(tp, true);
 }
-- 
2.24.1


