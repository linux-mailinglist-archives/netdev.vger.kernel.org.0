Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B704547A876
	for <lists+netdev@lfdr.de>; Mon, 20 Dec 2021 12:17:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231617AbhLTLRf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Dec 2021 06:17:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231171AbhLTLRe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Dec 2021 06:17:34 -0500
X-Greylist: delayed 2374 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 20 Dec 2021 03:17:34 PST
Received: from wp126.webpack.hosteurope.de (wp126.webpack.hosteurope.de [IPv6:2a01:488:42:1000:50ed:8485::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CEE9C061574
        for <netdev@vger.kernel.org>; Mon, 20 Dec 2021 03:17:34 -0800 (PST)
Received: from [2003:a:659:3f00:1e6f:65ff:fe31:d1d5] (helo=hermes.fivetechno.de); authenticated
        by wp126.webpack.hosteurope.de running ExIM with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        id 1mzG3I-00012t-RW; Mon, 20 Dec 2021 11:37:56 +0100
X-Virus-Scanned: by amavisd-new 2.12.1 using newest ClamAV at
        linuxbbg.five-lan.de
Received: from [192.168.34.101] (p5098d998.dip0.t-ipconnect.de [80.152.217.152])
        (authenticated bits=0)
        by hermes.fivetechno.de (8.16.1/8.16.1/SUSE Linux 0.8) with ESMTPSA id 1BKAbsBK015347
        (version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NO);
        Mon, 20 Dec 2021 11:37:54 +0100
Subject: Re: Issues with smsc95xx driver since a049a30fc27c
To:     Gabriel Hojda <ghojda@yo2urs.ro>, Andrew Lunn <andrew@lunn.ch>
Cc:     Martyn Welch <martyn.welch@collabora.com>, netdev@vger.kernel.org,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Steve Glendinning <steve.glendinning@shawell.net>,
        UNGLinuxDriver@microchip.com,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, stable@kernel.org
References: <199eebbd6b97f52b9119c9fa4fd8504f8a34de18.camel@collabora.com>
 <Yb4QFDQ0rFfFsT+Y@lunn.ch> <36f765d8450ba08cb3f8aecab0cadd89@yo2urs.ro>
 <Yb4m3xms1zMf5C3T@lunn.ch> <Yb4pTu3FtkGPPpzb@lunn.ch>
 <459afb513515361c13816f753f493075@yo2urs.ro>
From:   Markus Reichl <m.reichl@fivetechno.de>
Organization: five technologies GmbH
Message-ID: <63a32b0c-926c-9f8b-fd15-2d96fa258fcb@fivetechno.de>
Date:   Mon, 20 Dec 2021 11:37:54 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <459afb513515361c13816f753f493075@yo2urs.ro>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: de-DE
Content-Transfer-Encoding: 8bit
X-bounce-key: webpack.hosteurope.de;m.reichl@fivetechno.de;1639999054;73d4a612;
X-HE-SMSGID: 1mzG3I-00012t-RW
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



Am 18.12.21 um 21:33 schrieb Gabriel Hojda:
> On 2021-12-18 20:32, Andrew Lunn wrote:
>>> O.K, stab in the dark. Does the hardware need to be programmed with
>>> the MAC address? When does this happen? If this is going wrong, it
>>> could explain the promisc mode. If the MAC address has not been
>>> programmed, it has no idea what packets are for itself. Put it into
>>> promisc mode, and it will receive everything, including what it is
>>> supposed to receive. But looking at the offending patch, it is not
>>> obvious how it has anything to do with MAC addresses. The only
>>> unbalanced change in that patch is that smsc95xx_reset(dev) has
>>> disappeared, not moved to somewhere else.
>>
>> Ah!
>>
>> smsc95xx_reset() calls smsc95xx_set_mac_address(). So that fits.
>> smsc95xx_reset() is also called in smsc95xx_bind(), but maybe that is
>> not enough?
>>
>>     Andrew
> hi Andrew,
> 
> the odroid-u3 has no preconfigured mac address. the kernel from the vendor is 
> patched to read a file in /etc and set the mac address read from it. with the 
> mainline kernel the interface gets a random mac address that can later be changed 
> by NetworkManager & Co. (as far as i know there's no 
> "smsc95xx.macaddr=xx:xx:xx:xx:xx:xx" kernel boot parameter).
> 
> u-boot should be able to set the mac addreess, but it doesn't even detect the 
> network interface and i get a message like "No NET interface" (even though i've 
> tried the steps at 
> https://github.com/ARM-software/u-boot/blob/master/doc/README.odroid).
> 
> Gabriel

Hi,

same issue on odroid-x2 which has no preconfigured mac address either.

I use plain Debian buster and bullseye with traditional
/etc/network/interfaces

auto eth0
     allow-hotplug eth0
     iface eth0 inet dhcp
         hwaddress ether c2:c5:aa:9e:aa:55
     iface eth0 inet6 dhcp


Gruß,
-- 
Markus Reichl
