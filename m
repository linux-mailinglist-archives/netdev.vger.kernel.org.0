Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB422479CA1
	for <lists+netdev@lfdr.de>; Sat, 18 Dec 2021 21:48:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234179AbhLRUsj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Dec 2021 15:48:39 -0500
Received: from yo2urs.ro ([86.126.81.149]:59804 "EHLO mail.yo2urs.ro"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234175AbhLRUsj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 18 Dec 2021 15:48:39 -0500
Received: by mail.yo2urs.ro (Postfix, from userid 124)
        id 8147934A6; Sat, 18 Dec 2021 22:33:24 +0200 (EET)
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on server.local.net
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=5.0 tests=ALL_TRUSTED,BAYES_00
        autolearn=unavailable autolearn_force=no version=3.4.6
Received: from www.yo2urs.ro (localhost [127.0.0.1])
        by mail.yo2urs.ro (Postfix) with ESMTP id D7CE530B;
        Sat, 18 Dec 2021 22:33:21 +0200 (EET)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Sat, 18 Dec 2021 22:33:21 +0200
From:   Gabriel Hojda <ghojda@yo2urs.ro>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Martyn Welch <martyn.welch@collabora.com>, netdev@vger.kernel.org,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Markus Reichl <m.reichl@fivetechno.de>,
        Steve Glendinning <steve.glendinning@shawell.net>,
        UNGLinuxDriver@microchip.com,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, stable@kernel.org
Subject: Re: Issues with smsc95xx driver since a049a30fc27c
In-Reply-To: <Yb4pTu3FtkGPPpzb@lunn.ch>
References: <199eebbd6b97f52b9119c9fa4fd8504f8a34de18.camel@collabora.com>
 <Yb4QFDQ0rFfFsT+Y@lunn.ch> <36f765d8450ba08cb3f8aecab0cadd89@yo2urs.ro>
 <Yb4m3xms1zMf5C3T@lunn.ch> <Yb4pTu3FtkGPPpzb@lunn.ch>
User-Agent: Roundcube Webmail/1.4.11
Message-ID: <459afb513515361c13816f753f493075@yo2urs.ro>
X-Sender: ghojda@yo2urs.ro
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021-12-18 20:32, Andrew Lunn wrote:
>> O.K, stab in the dark. Does the hardware need to be programmed with
>> the MAC address? When does this happen? If this is going wrong, it
>> could explain the promisc mode. If the MAC address has not been
>> programmed, it has no idea what packets are for itself. Put it into
>> promisc mode, and it will receive everything, including what it is
>> supposed to receive. But looking at the offending patch, it is not
>> obvious how it has anything to do with MAC addresses. The only
>> unbalanced change in that patch is that smsc95xx_reset(dev) has
>> disappeared, not moved to somewhere else.
> 
> Ah!
> 
> smsc95xx_reset() calls smsc95xx_set_mac_address(). So that fits.
> smsc95xx_reset() is also called in smsc95xx_bind(), but maybe that is
> not enough?
> 
> 	Andrew
hi Andrew,

the odroid-u3 has no preconfigured mac address. the kernel from the 
vendor is patched to read a file in /etc and set the mac address read 
from it. with the mainline kernel the interface gets a random mac 
address that can later be changed by NetworkManager & Co. (as far as i 
know there's no "smsc95xx.macaddr=xx:xx:xx:xx:xx:xx" kernel boot 
parameter).

u-boot should be able to set the mac addreess, but it doesn't even 
detect the network interface and i get a message like "No NET interface" 
(even though i've tried the steps at 
https://github.com/ARM-software/u-boot/blob/master/doc/README.odroid).

Gabriel
