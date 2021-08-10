Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9007D3E84F9
	for <lists+netdev@lfdr.de>; Tue, 10 Aug 2021 23:09:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234035AbhHJVJw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Aug 2021 17:09:52 -0400
Received: from mail3.marcant.net ([217.14.160.188]:41901 "EHLO
        mail3.marcant.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234026AbhHJVJs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Aug 2021 17:09:48 -0400
X-Greylist: delayed 13281 seconds by postgrey-1.27 at vger.kernel.org; Tue, 10 Aug 2021 17:09:47 EDT
Received: from [192.168.180.1] (port=47516 helo=admins.marcant.net)
        by mail3.marcant.net with esmtp (Exim 4.94.2)
        (envelope-from <avalentin@marcant.net>)
        id 1mDYzk-0004gh-25; Tue, 10 Aug 2021 23:09:08 +0200
Received: from vmh.kalnet.hooya.de (unknown [192.168.203.15])
        by admins.marcant.net (Postfix) with ESMTPA id 0B71B2809A2;
        Tue, 10 Aug 2021 23:09:08 +0200 (CEST)
Subject: Re: [RFC net-next 2/3] net: dsa: qca8k: enable assisted learning on
 CPU port
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     DENG Qingfang <dqfext@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        "open list:NETWORKING DRIVERS" <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        Ansuel Smith <ansuelsmth@gmail.com>,
        Jonathan McDowell <noodles@earth.li>,
        =?UTF-8?B?TWljaGFsIFZva8OhxI0=?= <vokac.m@gmail.com>,
        Christian Lamparter <chunkeey@gmail.com>,
        Nishka Dasgupta <nishkadg.linux@gmail.com>,
        John Crispin <john@phrozen.org>,
        Stefan Lippers-Hollmann <s.l-h@gmx.de>,
        Hannu Nyman <hannu.nyman@iki.fi>,
        Imran Khan <gururug@gmail.com>,
        Frank Wunderlich <frank-w@public-files.de>,
        Nick Lowe <nick.lowe@gmail.com>
References: <20210807120726.1063225-1-dqfext@gmail.com>
 <20210807120726.1063225-3-dqfext@gmail.com>
 <20210807222555.y6r7qxhdyy6d3esx@skbuf>
 <20210808160503.227880-1-dqfext@gmail.com>
 <0072b721-7520-365d-26ef-a2ad70117ac2@marcant.net>
 <20210810175324.ijodmycvxfnwu4yf@skbuf>
From:   Andre Valentin <avalentin@marcant.net>
Organization: MarcanT AG
Message-ID: <7af5c79e-fe18-a6fa-4282-1aa2bee187d6@marcant.net>
Date:   Tue, 10 Aug 2021 23:09:07 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <20210810175324.ijodmycvxfnwu4yf@skbuf>
Content-Type: text/plain; charset=utf-8
Content-Language: de-DE
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Am 10.08.21 um 19:53 schrieb Vladimir Oltean:
> On Tue, Aug 10, 2021 at 07:27:05PM +0200, Andre Valentin wrote:
>> On Sun, Aug 08, 2021 at 1805, DENG Qingfang wrote:
>>> On Sun, Aug 08, 2021 at 01:25:55AM +0300, Vladimir Oltean wrote:
>>>> On Sat, Aug 07, 2021 at 08:07:25PM +0800, DENG Qingfang wrote:
>>>>> Enable assisted learning on CPU port to fix roaming issues.
>>>>
>>>> 'roaming issues' implies to me it suffered from blindness to MAC
>>>> addresses learned on foreign interfaces, which appears to not be true
>>>> since your previous patch removes hardware learning on the CPU port
>>>> (=> hardware learning on the CPU port was supported, so there were no
>>>> roaming issues)
>>
>> The issue is with a wifi AP bridged into dsa and previously learned
>> addresses.
>>
>> Test setup:
>> We have to wifi APs a and b(with qca8k). Client is on AP a.
>>
>> The qca8k switch in AP b sees also the broadcast traffic from the client
>> and takes the address into its fdb.
>>
>> Now the client roams to AP b.
>> The client starts DHCP but does not get an IP. With tcpdump, I see the
>> packets going through the switch (ap->cpu port->ethernet port) and they
>> arrive at the DHCP server. It responds, the response packet reaches the
>> ethernet port of the qca8k, and is not forwarded.
>>
>> After about 3 minutes the fdb entry in the qca8k on AP b is
>> "cleaned up" and the client can immediately get its IP from the DHCP server.
>>
>> I hope this helps understanding the background.
> 
> How does this differ from what is described in commit d5f19486cee7
> ("net: dsa: listen for SWITCHDEV_{FDB,DEL}_ADD_TO_DEVICE on foreign
> bridge neighbors")?
> 
I lost a bit, It is a bit different.

I've been also working a bit on the ipq807x device with such a switch on
OpenWRT. There is a backport of that commit. To fix the problems described
by d5f19486cee7, I enabled assisted_learning on qca8k. And it solves the
problem.

But initially, the device was unreachable until I created traffic from the device
to a client (cpu port->ethernet). At first, I did not notice this because a wifi client
with it's traffic immediately solved the issue automatically.
Later I verified this in detail.

Hopefully DENG Qingfang patches help. But I cannot proove atm.
