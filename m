Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4CBF25424F5
	for <lists+netdev@lfdr.de>; Wed,  8 Jun 2022 08:53:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231557AbiFHDnm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jun 2022 23:43:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232025AbiFHDm5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jun 2022 23:42:57 -0400
Received: from mout02.posteo.de (mout02.posteo.de [185.67.36.66])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81E2821DA14
        for <netdev@vger.kernel.org>; Tue,  7 Jun 2022 17:53:10 -0700 (PDT)
Received: from submission (posteo.de [185.67.36.169]) 
        by mout02.posteo.de (Postfix) with ESMTPS id 9BCAD240109
        for <netdev@vger.kernel.org>; Wed,  8 Jun 2022 02:44:17 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=posteo.at; s=2017;
        t=1654649057; bh=Yf4sDEoLCkYKu/WIf4AhczsOZG7t0ytvtN262rM88qg=;
        h=Date:To:Cc:From:Subject:From;
        b=NcGG/Sxx6H7OAV6f7JGurh9rmm0dhvH+EHB2tipft5wPFzb4LEXlBQdwFuArCfNNU
         rEX0wkQJbqM4AjDIi9C+EmOZcSfpK5tIoJ9K2u1VgXkAkvNlCqiLXW/HdGUr+gjJKa
         MFyhYvsjrgK6iKvUYxNL934zVWgyMd0wE5qrV5PM+695c5rRgKdLPnZdK6jvJodPYY
         xmN31Sqj7qwti7yB8/6pqLUBXMFJ0YcP7xHMBYk+bjDFeyRnFhUQ670cHKluU1KgmG
         DcdlCRcFg4y2T/2gBjlms9kWSkL2JlDwrV35NHC3CX6Jqo60BuxNo5P0FxctwAAagh
         PHue2bO84FlFw==
Received: from customer (localhost [127.0.0.1])
        by submission (posteo.de) with ESMTPSA id 4LHpQ81JVtz6tmT;
        Wed,  8 Jun 2022 02:44:16 +0200 (CEST)
Message-ID: <9ebb43ee-52a1-c77d-d609-ca447a32f3e6@posteo.at>
Date:   Wed,  8 Jun 2022 00:44:15 +0000
MIME-Version: 1.0
Content-Language: en-US
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     nic_swsd@realtek.com, netdev@vger.kernel.org,
        regressions@lists.linux.dev, Jakub Kicinski <kuba@kernel.org>
From:   Bernhard Hampel-Waffenthal <bernhard.hampelw@posteo.at>
Subject: [REGRESSION] r8169: RTL8168h "transmit queue 0 timed out" after ASPM
 L1 enablement
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

#regzbot introduced: 4b5f82f6aaef3fa95cce52deb8510f55ddda6a71

Hi,

since the last major kernel version upgrade to 5.18 on Arch Linux I'm 
unable to get a usable ethernet connection on my desktop PC.

I can see a timeout in the logs

 > kernel: NETDEV WATCHDOG: enp37s0 (r8169): transmit queue 0 timed out

and regular very likely related errors after

 > kernel: r8169 0000:25:00.0 enp37s0: rtl_rxtx_empty_cond == 0 (loop: 
42, delay: 100).


The link does manage to go up at nominal full 1Gbps speed, but there is 
no usable connection to speak of and pings are very bursty and take 
multiple seconds.

I was able to pinpoint that the problems were introduced in commit 
4b5f82f6aaef3fa95cce52deb8510f55ddda6a71 with the enablement of ASPM 
L1/L1.1 for ">= RTL_GIGA_MAC_VER_45", which my chip falls under. Adding 
pcie_aspm=off the kernel command line or changing that check to ">= 
RTL_GIGA_MAC_VER_60" for testing purposes and recompiling the kernel 
fixes my problems.


I'm using a MSI B450I GAMING PLUS AC motherboard with a RTL8168h chip as 
per dmesg:

 > r8169 0000:25:00.0 eth0: RTL8168h/8111h, 30:9c:23:de:97:a9, XID 541, 
IRQ 101

lspci says:

 > 25:00.0 Ethernet controller [0200]: Realtek Semiconductor Co., Ltd. 
RTL8111/8168/8411 PCI Express Gigabit Ethernet Controller [10ec:8168] 
(rev 15)
         Subsystem: Micro-Star International Co., Ltd. [MSI] Device 
[1462:7a40]
         Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- 
ParErr- Stepping- SERR- FastB2B- DisINTx+
         Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
         Latency: 0, Cache Line Size: 64 bytes
         Interrupt: pin A routed to IRQ 30
         IOMMU group: 14
         Region 0: I/O ports at f000 [size=256]
         Region 2: Memory at fcb04000 (64-bit, non-prefetchable) [size=4K]
         Region 4: Memory at fcb00000 (64-bit, non-prefetchable) [size=16K]
         Capabilities: <access denied>
         Kernel driver in use: r8169
         Kernel modules: r8169


If you need more info I'll do my best to provide what I can, hope that 
helps already.

Regards,
Bernhard
