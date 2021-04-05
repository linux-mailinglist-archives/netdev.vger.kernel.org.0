Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D15B3544E7
	for <lists+netdev@lfdr.de>; Mon,  5 Apr 2021 18:11:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239633AbhDEQLT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Apr 2021 12:11:19 -0400
Received: from discovery.labus-online.de ([116.202.114.139]:43864 "EHLO
        discovery.labus-online.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229832AbhDEQLS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Apr 2021 12:11:18 -0400
X-Greylist: delayed 11864 seconds by postgrey-1.27 at vger.kernel.org; Mon, 05 Apr 2021 12:11:18 EDT
Received: from localhost (localhost [127.0.0.1])
        by discovery.labus-online.de (Postfix) with ESMTP id 65487112004F;
        Mon,  5 Apr 2021 18:11:11 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=freifunk-rtk.de;
        s=modoboa; t=1617639071;
        bh=n2uR7ySAArUW+kTjLVR8XcQQWEkZokBQLWdVj8wwPVw=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=ZA1LW4GHuBavitqbCI3Rs2YIctQWcq1ZW8wf+w4UiH2eE0/gFBYK5aHKUEEQtPj7L
         ZpHfogxPfmljL9NhioJqdjOO60lrd1PXqpiQQk7IJI4vj28ESI40lihw+HJTLIflme
         +YYydX1jdK0sFaStUWAUv6VMREeE12nA7RToZhZS0AkQID42uYl1y9VnYMfHhi/TM8
         FEWm16gawANHXWDqsE1VMKsEn+CGdD0oRMBsYvfKxAbBHM/kmF56XZTqmXQHVAAwln
         OkGZ73FPDoZid4qx3kOxK+5mbwVncZdUTA0S77rjLvNuHbxDpZ3wrEdeQVqMnqRj6q
         aGpcFFe+3ZeiQ==
X-Virus-Scanned: Debian amavisd-new at discovery.labus-online.de
Received: from discovery.labus-online.de ([127.0.0.1])
        by localhost (mail.labus-online.de [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id flrV72YhN09H; Mon,  5 Apr 2021 18:11:01 +0200 (CEST)
Received: from [IPv6:2a02:908:1966:3a60:b62e:99ff:fe91:d1a9] (unknown [IPv6:2a02:908:1966:3a60:b62e:99ff:fe91:d1a9])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature ECDSA (P-384) server-digest SHA384)
        (No client certificate requested)
        by discovery.labus-online.de (Postfix) with ESMTPSA;
        Mon,  5 Apr 2021 18:11:01 +0200 (CEST)
Subject: Re: stmmac: zero udp checksum
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     netdev@vger.kernel.org, mschiffer@universe-factory.net
References: <cfc1ede9-4a1c-1a62-bdeb-d1e54c27f2e7@freifunk-rtk.de>
 <YGsQQUHPpuEGIRoh@lunn.ch>
From:   Julian Labus <julian@freifunk-rtk.de>
Message-ID: <98fcc1a7-8ce2-ac15-92a1-8c53b0e12658@freifunk-rtk.de>
Date:   Mon, 5 Apr 2021 18:11:01 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.0
MIME-Version: 1.0
In-Reply-To: <YGsQQUHPpuEGIRoh@lunn.ch>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 05.04.21 15:27, Andrew Lunn wrote:
> On Mon, Apr 05, 2021 at 02:53:15PM +0200, Julian Labus wrote:
>> Hi all,
>>
>> in our community mesh network we recently discovered that a TP-Link Archer
>> C2600 device is unable to receive IPv6 UDP packets with a zero checksum when
>> RX checksum offloading is enabled. The device uses ipq806x-gmac-dwmac for
>> its ethernet ports.
>>
>> According to https://tools.ietf.org/html/rfc2460#section-8.1 this sounds
>> like correct behavior as it says a UDP checksum must not be zero for IPv6
>> packets. But this definition was relaxed in
>> https://tools.ietf.org/html/rfc6935#section-5 to allow zero checksums in
>> tunneling protocols like VXLAN where we discovered the problem.
>>
>> Can the behavior of the stmmac driver be changed to meet RFC6935 or would it
>> be possible to make the (RX) Checksum Offloading Engine configurable via a
>> device tree property to disable it in environments were it causes problems?
> 
> Hi Julian
> 
> I don't know the stmmac driver at all...
> 
> Have you played around with ethtool -k/-K? Can use this to turn off
> hardware checksums?
> 
> I doubt a DT property would be accepted. What you probably want to do
> is react on the NETDEV notifiers for when an upper interface is
> changed. If a VXLAN interface is added, turn off hardware checksums.
> 
> 	 Andrew

Hi Andrew,

yes, disabling the offloading via "ethtool -K <ifname> rx off" works and 
is used as a workaround in a startup script but the OpenWrt-based OS on 
the mentioned device does not provide a reliable way to trigger ethtool 
commands when network devices change.

Reacting to upper interface changes and disabling (rx) offloading per 
interface sounds right when looking at RFC6935 again.

"As an alternative, certain protocols that use UDP as a tunnel
encapsulation MAY enable zero-checksum mode for a specific port
(or set of ports) for sending and/or receiving."

But was is still a bit strange to me is that it seems like the stmmac 
driver behaves different than other ethernet drivers which do not drop 
UDP packets with zero checksums when rx checksumming is enabled.

Julian
