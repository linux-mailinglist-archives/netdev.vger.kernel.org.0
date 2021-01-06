Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8ECA92EC2B8
	for <lists+netdev@lfdr.de>; Wed,  6 Jan 2021 18:50:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727021AbhAFRuS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jan 2021 12:50:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726165AbhAFRuR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Jan 2021 12:50:17 -0500
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B9E8C061575;
        Wed,  6 Jan 2021 09:49:37 -0800 (PST)
Received: by mail-ej1-x630.google.com with SMTP id lt17so6222182ejb.3;
        Wed, 06 Jan 2021 09:49:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:subject:to:cc:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=JuHR3UWCCeq452V9BHavJMn59/50F/mGgP61pi3yT34=;
        b=ljD9/4NN9tbpdf9CBJSPvqUvjlQBBAjU7Q51UgK97i8O3lj2uAY3Kyb58eZnyAVXbo
         wiWJjq6CxQA3rZCnhvfwjAaeNiqcLKhxmIXQC8bEAZuoX71zf3YlMdJx/v94ozy5/N2H
         aiUlLhInBuNnQ0YVjsdxA883vmNmPxELsz7ohzvmCYoroqc0jvuJ+WmAHrT8K0CHBpt/
         yk771U5enCIE2f+MqSdDaI1XyCj//5cxGX3Xk6SgbC0IdoDL1iP50qxkR8sp1rWMxv4q
         iKo1bl80cM9LT/GukZoRlN+IK8DqYkMxxpEslqUGwBdC+gB06ZhC8IHq0vwYFoSjizZn
         fCKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:subject:to:cc:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=JuHR3UWCCeq452V9BHavJMn59/50F/mGgP61pi3yT34=;
        b=Ww7tLaAdGha7lYRT/gKI2e9lW136cJEJqMckXQb6G7M3VVx4CAYvFBesyXUDLY8T+Z
         wiwbYh+ZjwHMRvx79+HbtZD4ZO2vr9zvEZLA5lgYhQP0eKnPMax2MkRPHoMbj6xJkU8T
         T/e2So5SO4/RrUsmqBy/1v4YSLUd0WSxzUZak/Fl/4l/TL0whqs/KykgJpbSu6HeeugN
         NrbfuetvPhTYnZY2qmTY/QJBO8czoVuD7oee3eHw73xlZs1j6ElAsMGl6PslIUVW2daU
         kMAH5qhb64v7qdD6AQ4JUdZS8QJS1bUMRmMGLsiYu10AXRL0vRBTHgXVOrj7diyRWIX4
         30hw==
X-Gm-Message-State: AOAM530Ab6dSX0PPmac0xS4oQ8SDhgZr4cv8lK2OFMKVwGyg+KIkDXY6
        xsEpPGPyadfp7c/XBHX/WwlmRhVvKM0=
X-Google-Smtp-Source: ABdhPJwPd5pH/anX6bdK5kfoTJJI3XsIWTyaHLT/ew888fUZH+Y1kAz2elvCu9cNj1jqchs1HQaInA==
X-Received: by 2002:a17:906:4705:: with SMTP id y5mr3567123ejq.112.1609955376083;
        Wed, 06 Jan 2021 09:49:36 -0800 (PST)
Received: from ?IPv6:2003:ea:8f06:5500:e1db:b990:7e09:f1cf? (p200300ea8f065500e1dbb9907e09f1cf.dip0.t-ipconnect.de. [2003:ea:8f06:5500:e1db:b990:7e09:f1cf])
        by smtp.googlemail.com with ESMTPSA id n20sm1528388ejo.83.2021.01.06.09.49.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 06 Jan 2021 09:49:35 -0800 (PST)
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: [PATCH v3 0/3] PCI: Disable parity checking if broken_parity is set
To:     Bjorn Helgaas <bhelgaas@google.com>,
        Russell King - ARM Linux <linux@armlinux.org.uk>,
        Realtek linux nic maintainers <nic_swsd@realtek.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Message-ID: <992c800e-2e12-16b0-4845-6311b295d932@gmail.com>
Date:   Wed, 6 Jan 2021 18:49:32 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If we know that a device has broken parity checking, then disable it.
This avoids quirks like in r8169 where on the first parity error
interrupt parity checking will be disabled if broken_parity_status
is set. Make pci_quirk_broken_parity() public so that it can be used
by platform code, e.g. for Thecus N2100.

v2:
- reduce scope of N2100 change to using the new PCI core quirk
v3:
- improve commit message of patch 2

Heiner Kallweit (3):
  PCI: Disable parity checking if broken_parity_status is set
  ARM: iop32x: improve N2100 PCI broken parity quirk
  r8169: simplify broken parity handling now that PCI core takes care

 arch/arm/mach-iop32x/n2100.c              |  2 +-
 drivers/net/ethernet/realtek/r8169_main.c | 14 --------------
 drivers/pci/quirks.c                      | 17 +++++++++++------
 include/linux/pci.h                       |  2 ++
 4 files changed, 14 insertions(+), 21 deletions(-)

-- 
2.30.0

