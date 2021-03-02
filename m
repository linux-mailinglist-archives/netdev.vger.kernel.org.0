Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 91CFB32A32F
	for <lists+netdev@lfdr.de>; Tue,  2 Mar 2021 16:02:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377988AbhCBItT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Mar 2021 03:49:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347668AbhCBFws (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Mar 2021 00:52:48 -0500
Received: from mail-io1-xd35.google.com (mail-io1-xd35.google.com [IPv6:2607:f8b0:4864:20::d35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6832DC06178C;
        Mon,  1 Mar 2021 21:51:53 -0800 (PST)
Received: by mail-io1-xd35.google.com with SMTP id u8so20449552ior.13;
        Mon, 01 Mar 2021 21:51:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=tuNxshL7uUmmItBqTOx/3A5Lp41lnCj/YwZnTkT/mR4=;
        b=XPD0Fyt1NQVUlQltmLLtjlPLCWDieEczpPB3fpXxGBUq3/evqaRgZtzaXUsfJbdEdl
         Y6lT3FW0I2ha9dgv4w6+pS5WUnXrufzn8Ur2FKL8UXurggn2dge+YIHp5u/10pguyVlq
         tVnh8YtvBLjRH3Tub1Yff+OUQSdwwWDkKt7nGIDKk7jc4jTHCOYZmPlBIXQvxIY69N3K
         SjeIjlu4J8YZf+W9BSndlUi0qD75dhw84h/BiRsfoQK+rukqxg5F33wpGiVuBF4fPQnc
         WHqr75yLVsiRcTNYIzLelEpTA56XLe5NNjr7nWv7xbKt1vFHI2D0lbKMHIsc7FPZfL4B
         fRdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=tuNxshL7uUmmItBqTOx/3A5Lp41lnCj/YwZnTkT/mR4=;
        b=enC/1CyY/xpYu3veR1TS4pNvLdPrd1gLBxzjRm7L8WbHtL1hRleyrlfNgw3rJwkDin
         cMcbon1GJSEM90/Cx1tbaVfKqOPIIDNdFqb/AqRXzgmQu53t5Ouiu3HxPcnoK/g0G+2q
         56UOocOoj0n7BkL1d6eexTYRiBH2Wtfb8SbVsfm+c19W4ztP3Vu7x7XrgOJVYI6Z/2fR
         4ZbUaYas4uhLpOjkpaWY/EQfJRS8ExWw0dItzUh4YTlgGmzq+bWkrf3jH9aOFcjVEQk5
         Ee4eOzgob/NOQLxjFAuimgoAI2qE/RCC0Otez3/vuBitY9B7qKR6CcpkVkUUG4TGFdfP
         hpAw==
X-Gm-Message-State: AOAM533fACvu847hYm+Q4P6udqmnSPea2gEX2EyyXPgn3zKtoHCPs2WL
        RsWHWw4oPgCQheHbc2gpVXBtgVSOjWvNTKejXKeDrpifo/x3FA==
X-Google-Smtp-Source: ABdhPJyOUt2jEocW4zN2xTl0L+d3tWde2fiwbf1qPB9W5FiYrqXNMvb2k4wjKeWT6qCwWzW2PLGEniB6jwNO9IlRHKk=
X-Received: by 2002:a5e:cb4d:: with SMTP id h13mr10886486iok.68.1614664312602;
 Mon, 01 Mar 2021 21:51:52 -0800 (PST)
MIME-Version: 1.0
From:   DENG Qingfang <dqfext@gmail.com>
Date:   Tue, 2 Mar 2021 13:51:42 +0800
Message-ID: <CALW65jatBuoE=NDRqccfiMVugPh5eeYSf-9a9qWYhvvszD2Jiw@mail.gmail.com>
Subject: dsa_master_find_slave()'s time complexity and potential performance hit
To:     netdev <netdev@vger.kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        linux-kernel@vger.kernel.org,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>
Cc:     Birger Koblitz <git@birger-koblitz.de>,
        =?UTF-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>,
        Stijn Segers <foss@volatilesystems.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Since commit 7b9a2f4bac68 ("net: dsa: use ports list to find slave"),
dsa_master_find_slave() has been iterating over a linked list instead
of accessing arrays, making its time complexity O(n).
The said function is called frequently in DSA RX path, so it may cause
a performance hit, especially for switches that have many ports (20+)
such as RTL8380/8390/9300 (There is a downstream DSA driver for it,
see https://github.com/openwrt/openwrt/tree/openwrt-21.02/target/linux/realtek/files-5.4/drivers/net/dsa/rtl83xx).
I don't have one of those switches, so I can't test if the performance
impact is huge or not.
