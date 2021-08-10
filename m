Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A04FC3E7E3D
	for <lists+netdev@lfdr.de>; Tue, 10 Aug 2021 19:31:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229577AbhHJRbZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Aug 2021 13:31:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229456AbhHJRbY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Aug 2021 13:31:24 -0400
X-Greylist: delayed 180 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 10 Aug 2021 10:31:02 PDT
Received: from mail3.marcant.net (mail3.marcant.net [IPv6:2a00:f88:0:3011:217:14:160:188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D9FBC0613C1
        for <netdev@vger.kernel.org>; Tue, 10 Aug 2021 10:31:02 -0700 (PDT)
Received: from [192.168.180.1] (port=45942 helo=admins.marcant.net)
        by mail3.marcant.net with esmtp (Exim 4.94.2)
        (envelope-from <avalentin@marcant.net>)
        id 1mDVWt-0002jU-0R; Tue, 10 Aug 2021 19:27:07 +0200
Received: from vmh.kalnet.hooya.de (unknown [192.168.203.15])
        by admins.marcant.net (Postfix) with ESMTPA id 5195E2808A2;
        Tue, 10 Aug 2021 19:27:06 +0200 (CEST)
Subject: Re: [RFC net-next 2/3] net: dsa: qca8k: enable assisted learning on
 CPU port
To:     DENG Qingfang <dqfext@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
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
From:   Andre Valentin <avalentin@marcant.net>
Organization: MarcanT AG
Message-ID: <0072b721-7520-365d-26ef-a2ad70117ac2@marcant.net>
Date:   Tue, 10 Aug 2021 19:27:05 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <20210808160503.227880-1-dqfext@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: de-DE
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Aug 08, 2021 at 1805, DENG Qingfang wrote:
> On Sun, Aug 08, 2021 at 01:25:55AM +0300, Vladimir Oltean wrote:
>> On Sat, Aug 07, 2021 at 08:07:25PM +0800, DENG Qingfang wrote:
>>> Enable assisted learning on CPU port to fix roaming issues.
>>
>> 'roaming issues' implies to me it suffered from blindness to MAC
>> addresses learned on foreign interfaces, which appears to not be true
>> since your previous patch removes hardware learning on the CPU port
>> (=> hardware learning on the CPU port was supported, so there were no
>> roaming issues)

The issue is with a wifi AP bridged into dsa and previously learned
addresses.

Test setup:
We have to wifi APs a and b(with qca8k). Client is on AP a.

The qca8k switch in AP b sees also the broadcast traffic from the client
and takes the address into its fdb.

Now the client roams to AP b.
The client starts DHCP but does not get an IP. With tcpdump, I see the
packets going through the switch (ap->cpu port->ethernet port) and they
arrive at the DHCP server. It responds, the response packet reaches the
ethernet port of the qca8k, and is not forwarded.

After about 3 minutes the fdb entry in the qca8k on AP b is
"cleaned up" and the client can immediately get its IP from the DHCP server.

I hope this helps understanding the background.

