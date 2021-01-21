Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E70DA2FDF70
	for <lists+netdev@lfdr.de>; Thu, 21 Jan 2021 03:36:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732209AbhAUCVS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Jan 2021 21:21:18 -0500
Received: from mail-out.m-online.net ([212.18.0.9]:33789 "EHLO
        mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2392901AbhAUBwb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Jan 2021 20:52:31 -0500
Received: from frontend01.mail.m-online.net (unknown [192.168.8.182])
        by mail-out.m-online.net (Postfix) with ESMTP id 4DLljl1LYYz1qs04;
        Thu, 21 Jan 2021 02:51:23 +0100 (CET)
Received: from localhost (dynscan1.mnet-online.de [192.168.6.70])
        by mail.m-online.net (Postfix) with ESMTP id 4DLljl0mVMz1r2y8;
        Thu, 21 Jan 2021 02:51:23 +0100 (CET)
X-Virus-Scanned: amavisd-new at mnet-online.de
Received: from mail.mnet-online.de ([192.168.8.182])
        by localhost (dynscan1.mail.m-online.net [192.168.6.70]) (amavisd-new, port 10024)
        with ESMTP id J3r4SyxYuVTD; Thu, 21 Jan 2021 02:51:21 +0100 (CET)
X-Auth-Info: RhaUe+hEc+Br+v91hFTUEVLeLsUKumDEhVAIhWBJRng=
Received: from [IPv6:::1] (p578adb1c.dip0.t-ipconnect.de [87.138.219.28])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.mnet-online.de (Postfix) with ESMTPSA;
        Thu, 21 Jan 2021 02:51:21 +0100 (CET)
Subject: Re: [PATCH net-next V2] net: dsa: microchip: Adjust reset release
 timing to match reference reset circuit
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Michael Grzeschik <m.grzeschik@pengutronix.de>,
        Paul Barker <pbarker@konsulko.com>
References: <20210120030502.617185-1-marex@denx.de>
 <20210120173127.58445e6c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Marek Vasut <marex@denx.de>
Message-ID: <9dd12956-4ddc-b641-185e-a36c7d4d81a9@denx.de>
Date:   Thu, 21 Jan 2021 02:51:21 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20210120173127.58445e6c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/21/21 2:31 AM, Jakub Kicinski wrote:
> On Wed, 20 Jan 2021 04:05:02 +0100 Marek Vasut wrote:
>> KSZ8794CNX datasheet section 8.0 RESET CIRCUIT describes recommended
>> circuit for interfacing with CPU/FPGA reset consisting of 10k pullup
>> resistor and 10uF capacitor to ground. This circuit takes ~100 ms to
>> rise enough to release the reset.
>>
>> For maximum supply voltage VDDIO=3.3V VIH=2.0V R=10kR C=10uF that is
>>                      VDDIO - VIH
>>    t = R * C * -ln( ------------- ) = 10000*0.00001*-(-0.93)=0.093 s
>>                         VDDIO
>> so we need ~95 ms for the reset to really de-assert, and then the
>> original 100us for the switch itself to come out of reset. Simply
>> msleep() for 100 ms which fits the constraint with a bit of extra
>> space.
>>
>> Fixes: 5b797980908a ("net: dsa: microchip: Implement recommended reset timing")
>> Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
>> Signed-off-by: Marek Vasut <marex@denx.de>
> 
> I'm slightly confused whether this is just future proofing or you
> actually have a board where this matters. The tree is tagged as
> net-next but there is a Fixes tag which normally indicates net+stable.

I have a board where I trigger this problem, that's how I found it. It 
should be passed to stable too. So the correct tree / tag is "net" ?
