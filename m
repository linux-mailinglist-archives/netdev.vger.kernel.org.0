Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 52EE611B99C
	for <lists+netdev@lfdr.de>; Wed, 11 Dec 2019 18:07:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730724AbfLKRHd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Dec 2019 12:07:33 -0500
Received: from guitar.tcltek.co.il ([192.115.133.116]:36189 "EHLO
        mx.tkos.co.il" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729512AbfLKRHd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 11 Dec 2019 12:07:33 -0500
Received: from tarshish (unknown [10.0.8.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx.tkos.co.il (Postfix) with ESMTPS id 819BE4400C6;
        Wed, 11 Dec 2019 19:07:30 +0200 (IST)
References: <87tv67tcom.fsf@tarshish> <20191211131111.GK16369@lunn.ch>
User-agent: mu4e 1.2.0; emacs 26.1
From:   Baruch Siach <baruch@tkos.co.il>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Vivien Didelot <vivien.didelot@gmail.com>, netdev@vger.kernel.org,
        Denis Odintsov <d.odintsov@traviangames.com>,
        Hubert Feurstein <h.feurstein@gmail.com>
Subject: Re: [BUG] mv88e6xxx: tx regression in v5.3
In-reply-to: <20191211131111.GK16369@lunn.ch>
Date:   Wed, 11 Dec 2019 19:07:29 +0200
Message-ID: <87fthqu6y6.fsf@tarshish>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Andrew,

On Wed, Dec 11 2019, Andrew Lunn wrote:

> On Wed, Dec 11, 2019 at 11:48:57AM +0200, Baruch Siach wrote:
>> Hi Andrew, Vivien,
>> 
>> Since kernel v5.3 (tested v5.3.15), the 88E6141 switch on SolidRun
>> Clearfog GT-8K stopped transmitting packets on switch connected
>> ports. Kernel v5.2 works fine (tested v5.2.21).
>> 
>> Here are the relevant kernel v5.3 log lines:
>> 
>> [    2.867424] mv88e6085 f412a200.mdio-mii:04: switch 0x3400 detected: Marvell 88E6141, revision 0
>> [    2.927445] libphy: mdio: probed
>> [    3.578496] mv88e6085 f412a200.mdio-mii:04 lan2 (uninitialized): PHY [!cp1!config-space@f4000000!mdio@12a200!switch0@4!mdio:11] driver [Marvell 88E6390]
>> [    3.595674] mv88e6085 f412a200.mdio-mii:04 lan1 (uninitialized): PHY [!cp1!config-space@f4000000!mdio@12a200!switch0@4!mdio:12] driver [Marvell 88E6390]
>> [    3.612797] mv88e6085 f412a200.mdio-mii:04 lan4 (uninitialized): PHY [!cp1!config-space@f4000000!mdio@12a200!switch0@4!mdio:13] driver [Marvell 88E6390]
>> [    3.629910] mv88e6085 f412a200.mdio-mii:04 lan3 (uninitialized): PHY [!cp1!config-space@f4000000!mdio@12a200!switch0@4!mdio:14] driver [Marvell 88E6390]
>> [    3.646049] mv88e6085 f412a200.mdio-mii:04: configuring for phy/ link mode
>> [    3.654451] DSA: tree 0 setup
>> ...
>> [   10.784521] mvpp2 f4000000.ethernet eth2: configuring for fixed/2500base-x link mode
>> [   10.792401] mvpp2 f4000000.ethernet eth2: Link is Up - 2.5Gbps/Full - flow control off
>> [   19.817981] mv88e6085 f412a200.mdio-mii:04 lan1: configuring for phy/ link mode
>> [   19.827083] 8021q: adding VLAN 0 to HW filter on device lan1
>> [   21.577276] mv88e6085 f412a200.mdio-mii:04 lan1: Link is Up - 100Mbps/Full - flow control rx/tx
>> [   21.586030] IPv6: ADDRCONF(NETDEV_CHANGE): lan1: link becomes ready
>> 
>> The Tx count on the lan1 interface increments, but the ARP packets don't 
>> show on the network.
>
> Hi Baruch
>
> I don't know of an issues.
>
> If the MAC TX counter increases, it sounds like it is a PHY issue?
> Does 100Mbps/Full make sense for this link?

100Mbps switch is what I have at the other side of the link. Works
perfectly with v5.2.

> Probably your best bet is to do a git bisect to find which commit
> broke it.

Bisect points at 7fb5a711545d ("net: dsa: mv88e6xxx: drop adjust_link to
enabled phylink"). Reverting this commit on top of v5.3.15 fixes the
issue (and brings the warning back). As I understand, this basically
reverts the driver migration to phylink. What might be the issue with
phylink?

Thanks,
baruch

-- 
     http://baruch.siach.name/blog/                  ~. .~   Tk Open Systems
=}------------------------------------------------ooO--U--Ooo------------{=
   - baruch@tkos.co.il - tel: +972.52.368.4656, http://www.tkos.co.il -
