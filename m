Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 237B1406727
	for <lists+netdev@lfdr.de>; Fri, 10 Sep 2021 08:20:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231129AbhIJGVr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Sep 2021 02:21:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230467AbhIJGVr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Sep 2021 02:21:47 -0400
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82089C061574;
        Thu,  9 Sep 2021 23:20:36 -0700 (PDT)
Received: by mail-wr1-x42b.google.com with SMTP id i23so1029188wrb.2;
        Thu, 09 Sep 2021 23:20:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:cc:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=y6dZT2c2pP0I23V365/4zZiIEmdIs5esWRP7Tih9j94=;
        b=j7/8Scsuye+ggI10v4RHijARF+Bh9ZXltP6peecNiP2r6pMDpR9nMiC/jeiN5ZmPjq
         zOrCzzllxtJ0TEDHOwLc0GS1FUtH8tR/Xh1Cojo85kEdexaE4Z+Ib5MSekspU/2rdomz
         Z1mtClNfvI4jyg94RhFIgVoEhlGHg8YK3dXiJwGcyBhNvjvWfdbGBHLrXRgzOeN1Xcrt
         ZrfABHdJ3KZcoNzfsXT+R8lm+BFVGBbGhByxnmbqgl9luHbSGJlpgbU/7SDFuJXDKHi9
         PE4DfUSFF+gGGBv7a/2lHWrgt86jf8CGkdHWlbnWgnn0NXcM6pdmi8BEq/ix0FImxu45
         /9cg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:to:cc:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=y6dZT2c2pP0I23V365/4zZiIEmdIs5esWRP7Tih9j94=;
        b=F/btKzut8YcNRda6op0jAxlDNNdENa3tZP/Y5oTp1sB0HhySS5vwhDl/uCL7umB9bA
         dF99JMPWvktUo5J4uDLNoprPKX/K8i3Osv7gBuZ1p9TzwLWtPrMtJh3x7FjyN9/4l/U1
         tQdO13q3VugkgiIAReZ5fO+Byl6TAB7i2mnkzuInroPt7MvQjpYF5WbGV7qRJdYEThfb
         DqBBVmCqzCIoK/cJcVG+dj575sk4qWDGyCK5tV6K1iqFqR2PQfkGXhHGItKb0JuIiKZ0
         TSWUuPqOpdZnp9LUpoSt7+7f9Je++1MkftI8kYOIvt0SQMaujSmJ9sigJREwAzur1vRn
         /gLg==
X-Gm-Message-State: AOAM531kr86d9GYfng+Z7n9V4wBxK2XrO0t18kM3zm4U7/Z8hjIohvpy
        cNr7WZvg7vqHD9FdvJqGlV/stSdUIZw=
X-Google-Smtp-Source: ABdhPJxbLvZnUcC3qWb0Thc8U9EgbVvDcw77phStyrlgOGji0jhQ50DRSvtjSixqotdJatS0vgbQJw==
X-Received: by 2002:adf:b78d:: with SMTP id s13mr7886227wre.344.1631254834843;
        Thu, 09 Sep 2021 23:20:34 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f08:4500:c9c:396a:4a57:ee58? (p200300ea8f0845000c9c396a4a57ee58.dip0.t-ipconnect.de. [2003:ea:8f08:4500:c9c:396a:4a57:ee58])
        by smtp.googlemail.com with ESMTPSA id t9sm4160968wrg.4.2021.09.09.23.20.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 09 Sep 2021 23:20:34 -0700 (PDT)
To:     Bjorn Helgaas <bhelgaas@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Raju Rangoju <rajur@chelsio.com>
Cc:     "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: [PATCH 0/5] PCI/VPD: Add and use pci_read/write_vpd_any()
Message-ID: <ba0b18a3-64d8-d72f-9e9f-ad3e4d7ae3b8@gmail.com>
Date:   Fri, 10 Sep 2021 08:20:23 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In certain cases we need a variant of pci_read_vpd()/pci_write_vpd() that
does not check against dev->vpd.len. Such cases are:
- reading VPD if dev->vpd.len isn't set yet (in pci_vpd_size())
- devices that map non-VPD information to arbitrary places in VPD address
  space (example: Chelsio T3 EEPROM write-protect flag)
Therefore add function variants that check against PCI_VPD_MAX_SIZE only.

Make the cxgb3 driver the first user of the new functions.

Preferably this series should go through the PCI tree.

Heiner Kallweit (5):
  PCI/VPD: Add pci_read/write_vpd_any()
  PCI/VPD: Use pci_read_vpd_any() in pci_vpd_size()
  cxgb3: Remove t3_seeprom_read and use VPD API
  cxgb3: Use VPD API in t3_seeprom_wp()
  cxgb3: Remove seeprom_write and user VPD API

 drivers/net/ethernet/chelsio/cxgb3/common.h   |  2 -
 .../net/ethernet/chelsio/cxgb3/cxgb3_main.c   | 38 +++----
 drivers/net/ethernet/chelsio/cxgb3/t3_hw.c    | 98 +++----------------
 drivers/pci/vpd.c                             | 79 ++++++++++-----
 include/linux/pci.h                           |  2 +
 5 files changed, 83 insertions(+), 136 deletions(-)

-- 
2.33.0

