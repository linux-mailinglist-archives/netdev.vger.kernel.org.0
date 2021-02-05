Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 148933114EC
	for <lists+netdev@lfdr.de>; Fri,  5 Feb 2021 23:23:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233202AbhBEWSa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Feb 2021 17:18:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232236AbhBEOcQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Feb 2021 09:32:16 -0500
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D89DC061793;
        Fri,  5 Feb 2021 08:09:17 -0800 (PST)
Received: by mail-ed1-x52b.google.com with SMTP id t5so9338536eds.12;
        Fri, 05 Feb 2021 08:09:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=wxlenn/Tv/yLURp6IteuVrvWieBU43C0FAD9g2/etSo=;
        b=ij3zbJCEpwTPf87zbOsYISZsPUb19idDDJrvE9XM9xCFnOsUZuWvG1/R7CMjTzKZOz
         SPZDW6DAOXZ29sMw9E7vWDRffLvKP5C9QA88NmNAS91+8pdGpGuJUajrXnK8+P+UQcA/
         Zp6z0TSVOs2T+MeyF11pVqY04pi1OFKpA7XxVp2uX7QVTXoFe7F8ygwkGHHbfPx8iqYV
         8mRUJMqmXttocyjGjO3K/tZKKipSjDhYQaQlntMOw2jMLEXczBDForO0g2vBOsQwzvEc
         YoD9NW/EMcGxEmrfn0geD/rcxPo19VAIHTj45GMyigHnbD5iwO6vWyfemRMnP0d+e17f
         6UeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=wxlenn/Tv/yLURp6IteuVrvWieBU43C0FAD9g2/etSo=;
        b=SNeSjFM69Ygn2KfrwXzzKebk3qAo+Aqc913jR9GqkJgoIXLCiG7ZfcSWIBq6gvhaGy
         zlQ4W3vM7pVyIFUA+Not3PQfF3eZmqq+GQgDj5dmtbnv8XricM2TW08+W8BRdaUQ6z81
         WaQ4gWR3WoWMb/fP8+1p1s0buHkXFe3W8MPAUIEoA9CF7yA3hp3SdsovZg8el6EjmirN
         wCzZLwGmt0uVcHejLQnMRkWaEZszEezpuc6Dzm3k3Vc2x5oRYM7ZhcNl44rzTqTuvw1z
         dD8ivxMP6l8yDKzzNZlBXDv7da7to6Y61JjjtU+2s13ljlo+B8IcZAS54e+FsSOVxx/G
         JJyg==
X-Gm-Message-State: AOAM53240gnZQdJlzFvAkD5exYH2lcQ6FyrXFaKYN8+PvGW4gHr9hsWN
        XDoWuf/N/QssbZ5HpkJxrlXKKCZn6zMEmw==
X-Google-Smtp-Source: ABdhPJxs0PygHnzvsetjZYcjTSHc63XTRUDWqQp4+9fNmj229VOdhcZh+uFAJMg2aNXDZNNIHyVO6Q==
X-Received: by 2002:adf:dd83:: with SMTP id x3mr5230018wrl.421.1612535188425;
        Fri, 05 Feb 2021 06:26:28 -0800 (PST)
Received: from ?IPv6:2003:ea:8f1f:ad00:9118:8653:7e7:879e? (p200300ea8f1fad009118865307e7879e.dip0.t-ipconnect.de. [2003:ea:8f1f:ad00:9118:8653:7e7:879e])
        by smtp.googlemail.com with ESMTPSA id o12sm12235744wrx.82.2021.02.05.06.26.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 05 Feb 2021 06:26:27 -0800 (PST)
Subject: [PATCH net-next v2 2/3] PCI/VPD: Change Chelsio T4 quirk to provide
 access to full virtual address space
From:   Heiner Kallweit <hkallweit1@gmail.com>
To:     Raju Rangoju <rajur@chelsio.com>, Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Bjorn Helgaas <bhelgaas@google.com>
Cc:     "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <8edfa4ae-1e78-249d-14fb-0e44a2c51864@gmail.com>
Message-ID: <0e55480b-67cb-8a2f-fb82-734d4b1b0eb0@gmail.com>
Date:   Fri, 5 Feb 2021 15:26:25 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <8edfa4ae-1e78-249d-14fb-0e44a2c51864@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

cxgb4 uses the full VPD address space for accessing its EEPROM (with some
mapping, see t4_eeprom_ptov()). In cudbg_collect_vpd_data() it sets the
VPD len to 32K (PCI_VPD_MAX_SIZE), and then back to 2K (CUDBG_VPD_PF_SIZE).
Having official (structured) and inofficial (unstructured) VPD data
violates the PCI spec, let's set VPD len according to all data that can be
accessed via PCI VPD access, no matter of its structure.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/pci/vpd.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/pci/vpd.c b/drivers/pci/vpd.c
index 7915d10f9..06a7954d0 100644
--- a/drivers/pci/vpd.c
+++ b/drivers/pci/vpd.c
@@ -633,9 +633,8 @@ static void quirk_chelsio_extend_vpd(struct pci_dev *dev)
 	/*
 	 * If this is a T3-based adapter, there's a 1KB VPD area at offset
 	 * 0xc00 which contains the preferred VPD values.  If this is a T4 or
-	 * later based adapter, the special VPD is at offset 0x400 for the
-	 * Physical Functions (the SR-IOV Virtual Functions have no VPD
-	 * Capabilities).  The PCI VPD Access core routines will normally
+	 * later based adapter, provide access to the full virtual EEPROM
+	 * address space. The PCI VPD Access core routines will normally
 	 * compute the size of the VPD by parsing the VPD Data Structure at
 	 * offset 0x000.  This will result in silent failures when attempting
 	 * to accesses these other VPD areas which are beyond those computed
@@ -644,7 +643,7 @@ static void quirk_chelsio_extend_vpd(struct pci_dev *dev)
 	if (chip == 0x0 && prod >= 0x20)
 		pci_set_vpd_size(dev, 8192);
 	else if (chip >= 0x4 && func < 0x8)
-		pci_set_vpd_size(dev, 2048);
+		pci_set_vpd_size(dev, PCI_VPD_MAX_SIZE);
 }
 
 DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_CHELSIO, PCI_ANY_ID,
-- 
2.30.0


