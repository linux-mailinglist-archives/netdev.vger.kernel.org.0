Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D10DD406736
	for <lists+netdev@lfdr.de>; Fri, 10 Sep 2021 08:28:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231240AbhIJG3i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Sep 2021 02:29:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231183AbhIJG31 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Sep 2021 02:29:27 -0400
Received: from mail-wm1-x32f.google.com (mail-wm1-x32f.google.com [IPv6:2a00:1450:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0CFBBC061756;
        Thu,  9 Sep 2021 23:28:17 -0700 (PDT)
Received: by mail-wm1-x32f.google.com with SMTP id u15-20020a05600c19cf00b002f6445b8f55so603515wmq.0;
        Thu, 09 Sep 2021 23:28:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=z25soX/dlUjEEze8+LybPfo7Hfy5/6i6KwpPFbn2xqc=;
        b=L6iEN54AZrSuMIdo3he4EZqUvaIEswWiGTEzCh+r3K959/LFe7fnxsT13JVLgsfmNI
         JhwshUeUqjgV40Q3SvqkRhmdOoosCNEHql5ZvabmKSflhIG+Fg30BpNGsim383mDcf5D
         Tyy2/1xSEjW5yK0o+p2ld5/plutrFxYz9i/dicdBfuRkngAwKivl39qCzD1CyxLMlOQp
         8hGeC73j5JY4DVBtah+1kp8DL27rHqo4zxH9atDyXcKsEzOetXCWOggQeoGO5e5HhVui
         Xn09cFmtpyrudUwi4pmQVMugWLJsvoVo5J6onRYwTfs9iEC9RJWrSFJjcYoywwypp/ba
         CBJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=z25soX/dlUjEEze8+LybPfo7Hfy5/6i6KwpPFbn2xqc=;
        b=MhhK06GFYqCQBvQdlQt92s7va4Te+FRALIv/XDej6p0mtytpPuCIDhBKLH6kTRlIPW
         h6NzVa/m9gdcfJzYbnDStcpr0WptFV2kowEUsu3GuaBOrqN78Yz+Li7od+4QdPMud4Lx
         IjLwXM/DKVXIXnzMTIlSg+qUwHprTJfrhQYsG+1B25TNVvQBuh9umNFfBXHHa5j72Q+0
         OzB7yq/sHaeJmPMdzK1PQOyiR/IejWV3KRcF7xClZmhXvOyz8V6FIzpfcVhbTbXtuVG+
         +CykRPbWHO1OuZZDbOcD/s4uR8lVk+cEJTpsunV0VebFbCv8J+saGzMrGJKmgT3QrnDL
         m+DQ==
X-Gm-Message-State: AOAM531l96AO5cgwSo/hl+EtmQ+WI6/YWJ0keWcCVhUanim1RK30X+dD
        Zk2wrxCtUXzULGh4MyM+Lvd9cmjagX4=
X-Google-Smtp-Source: ABdhPJyT/aWoWzBCHEMqDL2HQFqk5MhD3qCvPcpPjc1egEadO1akp4XRmQuAnWnGgj1gHVVAE6nY1w==
X-Received: by 2002:a7b:c5d8:: with SMTP id n24mr6708628wmk.51.1631255295419;
        Thu, 09 Sep 2021 23:28:15 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f08:4500:c9c:396a:4a57:ee58? (p200300ea8f0845000c9c396a4a57ee58.dip0.t-ipconnect.de. [2003:ea:8f08:4500:c9c:396a:4a57:ee58])
        by smtp.googlemail.com with ESMTPSA id v10sm3813961wrg.15.2021.09.09.23.28.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 09 Sep 2021 23:28:15 -0700 (PDT)
Subject: [PATCH 4/5] cxgb3: Use VPD API in t3_seeprom_wp()
From:   Heiner Kallweit <hkallweit1@gmail.com>
To:     Bjorn Helgaas <bhelgaas@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Raju Rangoju <rajur@chelsio.com>
Cc:     "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <ba0b18a3-64d8-d72f-9e9f-ad3e4d7ae3b8@gmail.com>
Message-ID: <f768fdbe-3a16-d539-57d2-c7c908294336@gmail.com>
Date:   Fri, 10 Sep 2021 08:25:49 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <ba0b18a3-64d8-d72f-9e9f-ad3e4d7ae3b8@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use standard VPD API to replace t3_seeprom_write(), this prepares for
removing this function. Chelsio T3 maps the EEPROM write protect flag
to an arbitrary place in VPD address space, therefore we have to use
pci_write_vpd_any().

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/ethernet/chelsio/cxgb3/t3_hw.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/chelsio/cxgb3/t3_hw.c b/drivers/net/ethernet/chelsio/cxgb3/t3_hw.c
index 4ecf40b02..ec4b49ebe 100644
--- a/drivers/net/ethernet/chelsio/cxgb3/t3_hw.c
+++ b/drivers/net/ethernet/chelsio/cxgb3/t3_hw.c
@@ -642,7 +642,14 @@ int t3_seeprom_write(struct adapter *adapter, u32 addr, __le32 data)
  */
 int t3_seeprom_wp(struct adapter *adapter, int enable)
 {
-	return t3_seeprom_write(adapter, EEPROM_STAT_ADDR, enable ? 0xc : 0);
+	u32 data = enable ? 0xc : 0;
+	int ret;
+
+	/* EEPROM_STAT_ADDR is outside VPD area, use pci_write_vpd_any() */
+	ret = pci_write_vpd_any(adapter->pdev, EEPROM_STAT_ADDR, sizeof(u32),
+				&data);
+
+	return ret < 0 ? ret : 0;
 }
 
 static int vpdstrtouint(char *s, u8 len, unsigned int base, unsigned int *val)
-- 
2.33.0


