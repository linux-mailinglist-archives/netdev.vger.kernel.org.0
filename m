Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E761D30CD35
	for <lists+netdev@lfdr.de>; Tue,  2 Feb 2021 21:43:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233370AbhBBUlI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Feb 2021 15:41:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232860AbhBBUky (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Feb 2021 15:40:54 -0500
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF08FC0613D6;
        Tue,  2 Feb 2021 12:40:13 -0800 (PST)
Received: by mail-wr1-x42a.google.com with SMTP id l12so21881744wry.2;
        Tue, 02 Feb 2021 12:40:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=ORPezsdgKuM/UizLE6LMgwfCKfuf7GSRSsDWm72yA2k=;
        b=XXjimafFVrRwYXC3f4KzfMEMIgZK+AgRXNUhzTmlFs/9Rwf9hMktTDmyx0Of3R4Rhw
         B0fsFZqZ13gFc+umECAm4WtaLkFZRg3IvzbGq075P3wuaCAE5/8XWs1orrkBI8+WPNBN
         BvWTv4s6Cwf+l72RlHC74vy2ghmgijRPRpueDn3JVELfUyw74kn0HDXl9icacL1OUSfA
         JtV59ph8bxnzX0Ipf7X4tT8BnyqrjefbupLw0RCMbCwISJCs4V7QDR9FW5XYnQ44p5/E
         lh/NkNdP7zKuSEeP32Q/t+H0cZy5ZQnzOdH66oy98JSiQhkwmEJj71KDoHFab+Tjf8XY
         4tNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ORPezsdgKuM/UizLE6LMgwfCKfuf7GSRSsDWm72yA2k=;
        b=jocRlfnGqPFhHT8YAtd00bY1cJ1HRsxAiP1DhJauBlr4H/Wc7MelDv4W2qThdPJYjH
         6zsj42pd/738LfOQyOVQvrMhFLEnKhgJWEj6coubIC69qobyFDfD0GgvKxzMM1BVb2Bi
         FHCjqzADYS6QNcvAowjRgY/n2PoAkQfX3l2xgv0nw4Rr5EUrxWjZKVJDfPJYkgaZjbYj
         6pdd/bcE7MGE5ee5dQ4wpLnFd5VNgN1ON0lYKgXGqhtToyB9FKgs0uf8RbnFvziq5adP
         9SqBvYPSOI13DM5ZePY0mMEV+MAmz0vDKvDJbY3e1Zo45zUx7EZAyrxZH5n6u4O+JZj9
         cGSA==
X-Gm-Message-State: AOAM532cbMiVfL2UoEcOIo2anp3hcvrk+lHgzssTrjkZZfSOY5y9L4sY
        ahmHPaMITlgHPY3K6qaKQh3ETuduEso=
X-Google-Smtp-Source: ABdhPJxp9DC7uhjPrkUTMD6bKCFlKP7wDtWxA5rjqx4JSXwKU54DXdkpkMG7K/iedVAxe4/B/ZDDuw==
X-Received: by 2002:a5d:6912:: with SMTP id t18mr25891517wru.268.1612298412322;
        Tue, 02 Feb 2021 12:40:12 -0800 (PST)
Received: from ?IPv6:2003:ea:8f1f:ad00:e887:ce1a:5d1d:a96e? (p200300ea8f1fad00e887ce1a5d1da96e.dip0.t-ipconnect.de. [2003:ea:8f1f:ad00:e887:ce1a:5d1d:a96e])
        by smtp.googlemail.com with ESMTPSA id i59sm36440916wri.3.2021.02.02.12.40.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 02 Feb 2021 12:40:11 -0800 (PST)
Subject: [PATCH net-next 3/4] PCI/VPD: Change Chelsio T4 quirk to provide
 access to full virtual EEPROM address space
From:   Heiner Kallweit <hkallweit1@gmail.com>
To:     Raju Rangoju <rajur@chelsio.com>, Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Bjorn Helgaas <bhelgaas@google.com>
Cc:     "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <b07dc99d-7fd0-48c0-3fc4-89cda90ee5d7@gmail.com>
Message-ID: <3db0112d-8767-fd9a-4e65-ad97a284a866@gmail.com>
Date:   Tue, 2 Feb 2021 21:38:41 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <b07dc99d-7fd0-48c0-3fc4-89cda90ee5d7@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

cxgb4 uses the full VPD address space for accessing its EEPROM (with some
mapping, see t4_eeprom_ptov()). In cudbg_collect_vpd_data() it sets the
VPD len to 32K (PCI_VPD_MAX_SIZE), and then back to 2K (CUDBG_VPD_PF_SIZE).
Having official (structured) and unofficial (unstructured) VPD data
violates the PCI spec, let's set VPD len according to all data that can be
accessed via PCI VPD access, no matter of its structure.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/pci/vpd.c | 11 +++--------
 1 file changed, 3 insertions(+), 8 deletions(-)

diff --git a/drivers/pci/vpd.c b/drivers/pci/vpd.c
index db86fe226..90f17f3b7 100644
--- a/drivers/pci/vpd.c
+++ b/drivers/pci/vpd.c
@@ -630,16 +630,11 @@ static void quirk_chelsio_extend_vpd(struct pci_dev *dev)
 	int func = (dev->device & 0x0f00) >>  8;
 
 	/*
-	 * If this is a T4 or later based adapter, the special VPD is at offset
-	 * 0x400 for the Physical Functions (the SR-IOV Virtual Functions have
-	 * no VPD Capabilities). The PCI VPD Access core routines will normally
-	 * compute the size of the VPD by parsing the VPD Data Structure at
-	 * offset 0x000.  This will result in silent failures when attempting
-	 * to accesses these other VPD areas which are beyond those computed
-	 * limits.
+	 * If this is a T4 or later based adapter, provide access to the full
+	 * virtual EEPROM address space.
 	 */
 	if (chip >= 0x4 && func < 0x8)
-		pci_set_vpd_size(dev, 2048);
+		pci_set_vpd_size(dev, PCI_VPD_MAX_SIZE);
 }
 
 DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_CHELSIO, PCI_ANY_ID,
-- 
2.30.0


