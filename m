Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 760B52EBCED
	for <lists+netdev@lfdr.de>; Wed,  6 Jan 2021 12:02:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725952AbhAFLC0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jan 2021 06:02:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725828AbhAFLC0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Jan 2021 06:02:26 -0500
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7EE8C06134C;
        Wed,  6 Jan 2021 03:01:45 -0800 (PST)
Received: by mail-ed1-x533.google.com with SMTP id cw27so4019092edb.5;
        Wed, 06 Jan 2021 03:01:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:subject:to:cc:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=dPi8IdbBcNv9wj9yI9qcONwQntCJCsBInMqZrtHgTKw=;
        b=dTULatdk0SPatpEuHgXY3Iykc+DilOJqczC9Hvw2GVPxMc+CSyYn1kA/p52enVMlc3
         wGo5fE6XNaJVcXBwiET0mPXtroOF/z+FAJwRXQJthK+lsni9HZJZBoygso6kBV1FxG67
         k7k3kSAF4Yr8W6LpoTkj7yFaa8yZUh/1AuqmW51KrruoaUkw1bHtk1FAOVCh70vpQwoD
         sL41yvPg0VDSfp2VO+ZhlLIsQzbMV4lbyJs44Z+dGq/xXrt6lYayqvD1jhm5eeuisaG8
         kGmq1o0NP7+dClvJhsb98/KBpOaSeFL/br31CQ9b/TymiWnmLT1okMf+gf8MQWGxg2K/
         rm0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:subject:to:cc:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=dPi8IdbBcNv9wj9yI9qcONwQntCJCsBInMqZrtHgTKw=;
        b=T82shlvNcSD1wNWq73gMED5eK57h17pBUs056YciL2TQEC/JcoS4hLLPrd6nA5/qYT
         qpkjW/ChWYm09CWe/7UtkXeKF7Jt8YLAGl4/h2Z6AIzOJPF0nz+JeGtnqad7sfALAr91
         9ZnqMqWVd6h81eHsn9W0eLfgsrOpRaSNTt3KJmVYEQWOUyvnSImL633FPbcN+pOQQxtX
         dvXYAPyT7OkeKvstvWcOL+zgTBg5gpbTMcfmbthuk93gSn70gLtiyT1VOfWM6ZbhB/Sp
         qDUsCrtcB1C7I16bW2YRMmhNjnlKZG+A8ACL49wKCULWvyWkDhu2V/AmSugO6+mbO/aW
         juCQ==
X-Gm-Message-State: AOAM533M96j9XUyViOHzPoHPC7u7o54Ij/c39gz3GkIfUa+7b2sV1zTj
        cBfuQJ/LmrwSZhDJR4wy28ho++pQc/E=
X-Google-Smtp-Source: ABdhPJxfpnE5sBWuczGFK++KQ6dit7CZT/PMGyLQ9v5jVtru2zyi6PIoUIhqm+mRHzB/wHCRvNPgNA==
X-Received: by 2002:a50:cd57:: with SMTP id d23mr3592141edj.95.1609930904143;
        Wed, 06 Jan 2021 03:01:44 -0800 (PST)
Received: from ?IPv6:2003:ea:8f06:5500:e1db:b990:7e09:f1cf? (p200300ea8f065500e1dbb9907e09f1cf.dip0.t-ipconnect.de. [2003:ea:8f06:5500:e1db:b990:7e09:f1cf])
        by smtp.googlemail.com with ESMTPSA id ck27sm1317242edb.13.2021.01.06.03.01.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 06 Jan 2021 03:01:43 -0800 (PST)
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: [PATCH v2 0/3] PCI: Disable parity checking if broken_parity is set
To:     Bjorn Helgaas <bhelgaas@google.com>,
        Russell King - ARM Linux <linux@armlinux.org.uk>,
        Realtek linux nic maintainers <nic_swsd@realtek.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Message-ID: <bbc33d9b-af7c-8910-cdb3-fa3e3b2e3266@gmail.com>
Date:   Wed, 6 Jan 2021 12:01:36 +0100
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

