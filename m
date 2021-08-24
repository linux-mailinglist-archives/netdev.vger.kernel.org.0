Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 829883F5820
	for <lists+netdev@lfdr.de>; Tue, 24 Aug 2021 08:23:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229854AbhHXGYU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Aug 2021 02:24:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231235AbhHXGYR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Aug 2021 02:24:17 -0400
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4398C061575
        for <netdev@vger.kernel.org>; Mon, 23 Aug 2021 23:23:33 -0700 (PDT)
Received: by mail-wr1-x435.google.com with SMTP id q11so2586666wrr.9
        for <netdev@vger.kernel.org>; Mon, 23 Aug 2021 23:23:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=SIKyiSZ+d+M/igAPc9ra20AKEesTj5wsdS30cTuB/6g=;
        b=DLiU4Ow8wy+TAAWh+TiVtBEmivtxK9afYyqjiMpsPn7054s0Ru2ajGtbUsjTMYrY9M
         Virbaekd7umPoOXdMc3UV+oP7HDhpY0WPQjC7G1KacOunrQSLdlJFSZ0IdQYH2eST3Cz
         0CUGE8JOsAaSDb5LXsOr/OaQ1qtQbTbxr/lLIDzoZ38DdQScPBaMsvndGDUhFGT+Jh/C
         bF2S8s77uUSSi7IUZIX72vk4dUGc4TBIHewOKgXz0y+d0D1FteCwK22buGCcmIKXBc9p
         E7PcMF0hET8qSwUnE5rFU1OfRNo7nIh4FUb5r/yYBdl3D1tSThP7tGWm+m/9qQa72YAR
         pBfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=SIKyiSZ+d+M/igAPc9ra20AKEesTj5wsdS30cTuB/6g=;
        b=cNOQzEfqgjnS3cA40tCohWRVaLSknQ0NcaFgg+mDkdQFQWgdzJOC8kX1JyohLwBJNu
         UP1Da4jfQEehWT5POohU4TY4UGzsILvFloIhA40tHtDjddN5efHTIiR3ak/AfD9HF/3J
         d+1Sm0zeCsrfVf7UzdcR4ifZ6hp0GcINil7IdYEMOeJhuL0O6oYTIIDiXILv6UIHwLWT
         twpDkiwjI9dqIrnmBuyazmE4V5g+vPYO2EYuysSrmHUEdLJgV43sPibT6VcslAIJXm4O
         09MKkhRRSLd/KLXHvG/PdHgJFl9QUDlgpWWWVBNJem/zG9bGL694sOsk+rHT/t9AgAZ0
         rfGA==
X-Gm-Message-State: AOAM53106534PP7ehXV0nZ+yYy10+wTf2gs0ANZZxDQGyQT4c9DBFi0s
        CFcwbe2FYz51ttVRk3r+c5ebkFtMpbvDKQ==
X-Google-Smtp-Source: ABdhPJze9BJILpRR/y1QmG4d+1eExXhcs7iALz3aHxQw6frlQsen3imBUCC9CAhQubu6gIqyUkYRVA==
X-Received: by 2002:a5d:548e:: with SMTP id h14mr12304556wrv.7.1629786211387;
        Mon, 23 Aug 2021 23:23:31 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f08:4500:2c7f:74ed:78b3:5e87? (p200300ea8f0845002c7f74ed78b35e87.dip0.t-ipconnect.de. [2003:ea:8f08:4500:2c7f:74ed:78b3:5e87])
        by smtp.googlemail.com with ESMTPSA id g35sm1486161wmp.9.2021.08.23.23.23.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 23 Aug 2021 23:23:31 -0700 (PDT)
From:   Heiner Kallweit <hkallweit1@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Realtek linux nic maintainers <nic_swsd@realtek.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: [PATCH net-next] r8169: enable ASPM L0s state
Message-ID: <f159f2ba-d88e-aaa3-3409-ba831de55f1d@gmail.com>
Date:   Tue, 24 Aug 2021 08:23:20 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

ASPM is disabled completely because we've seen different types of
problems in the past. However it seems these problems occurred with
L1 or L1 sub-states only. On all the chip versions I've seen the
acceptable L0s exit latency is 512ns. This should be short enough not
to cause problems. If the actual L0s exit latency of the PCIe link
is bigger than 512ns then the PCI core will disable L0s anyway.
So let's give it a try and disable L1 and L1 sub-states only.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/ethernet/realtek/r8169_main.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index 7a69b4685..9ea59efd0 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -5281,11 +5281,10 @@ static int rtl_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 	if (rc)
 		return rc;
 
-	/* Disable ASPM completely as that cause random device stop working
+	/* Disable ASPM L1 as that cause random device stop working
 	 * problems as well as full system hangs for some PCIe devices users.
 	 */
-	rc = pci_disable_link_state(pdev, PCIE_LINK_STATE_L0S |
-					  PCIE_LINK_STATE_L1);
+	rc = pci_disable_link_state(pdev, PCIE_LINK_STATE_L1);
 	tp->aspm_manageable = !rc;
 
 	/* enable device (incl. PCI PM wakeup and hotplug setup) */
-- 
2.33.0

