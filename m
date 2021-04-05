Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F3E80354235
	for <lists+netdev@lfdr.de>; Mon,  5 Apr 2021 14:59:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235573AbhDEM7R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Apr 2021 08:59:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229681AbhDEM7R (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Apr 2021 08:59:17 -0400
X-Greylist: delayed 338 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 05 Apr 2021 05:59:11 PDT
Received: from discovery.labus-online.de (discovery.labus-online.de [IPv6:2a01:4f8:231:4262::1001])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51B63C061756
        for <netdev@vger.kernel.org>; Mon,  5 Apr 2021 05:59:11 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by discovery.labus-online.de (Postfix) with ESMTP id 7B102112004F;
        Mon,  5 Apr 2021 14:53:27 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=freifunk-rtk.de;
        s=modoboa; t=1617627207;
        bh=gMzwMjWkc89hSxNbYCUuvLWhYXrz4tejpkshy0LJDlY=;
        h=From:Subject:To:Cc:Date:From;
        b=tpwinEIZ1End4JaQC5ySn6/dt3XMo9suqDnpu48uE2kBbXBTBmK4OusGYd8kJ3V2C
         L1eBxvA8dICfGWPZ1lQeorNgyE86jWmOOFszfjJHvXB0lm2vXlNhxCHT6PJMes5Sja
         FlmzOp/XSkh0cP8PcqIzpglSpT8Is13oMgr1ecsqqnZktZCAUqjc8Nt+7QRMzVGeDY
         6MvgsLTo6QxMLVaP06FzoDeAYa0Iwwy2etZj5FB40x+jcQfLVBlAAN5HMdcnR8/8GI
         2cv8wFnqBx7cpTSnRTeh6dvik1iq6Svo1i+qgglVgAxgyoD0KfClEppdlSozo3tWRb
         Y5A0uDvtvmnUA==
X-Virus-Scanned: Debian amavisd-new at discovery.labus-online.de
Received: from discovery.labus-online.de ([127.0.0.1])
        by localhost (mail.labus-online.de [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id mJr4bQZcF4Xo; Mon,  5 Apr 2021 14:53:15 +0200 (CEST)
Received: from [IPv6:2a02:908:1966:3a60:b62e:99ff:fe91:d1a9] (unknown [IPv6:2a02:908:1966:3a60:b62e:99ff:fe91:d1a9])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature ECDSA (P-384))
        (No client certificate requested)
        by discovery.labus-online.de (Postfix) with ESMTPSA;
        Mon,  5 Apr 2021 14:53:15 +0200 (CEST)
From:   Julian Labus <julian@freifunk-rtk.de>
Subject: stmmac: zero udp checksum
To:     netdev@vger.kernel.org
Cc:     mschiffer@universe-factory.net
Message-ID: <cfc1ede9-4a1c-1a62-bdeb-d1e54c27f2e7@freifunk-rtk.de>
Date:   Mon, 5 Apr 2021 14:53:15 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi all,

in our community mesh network we recently discovered that a TP-Link 
Archer C2600 device is unable to receive IPv6 UDP packets with a zero 
checksum when RX checksum offloading is enabled. The device uses 
ipq806x-gmac-dwmac for its ethernet ports.

According to https://tools.ietf.org/html/rfc2460#section-8.1 this sounds 
like correct behavior as it says a UDP checksum must not be zero for 
IPv6 packets. But this definition was relaxed in 
https://tools.ietf.org/html/rfc6935#section-5 to allow zero checksums in 
tunneling protocols like VXLAN where we discovered the problem.

Can the behavior of the stmmac driver be changed to meet RFC6935 or 
would it be possible to make the (RX) Checksum Offloading Engine 
configurable via a device tree property to disable it in environments 
were it causes problems?

Best regards,
Julian Labus
