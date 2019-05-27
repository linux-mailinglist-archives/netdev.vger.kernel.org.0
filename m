Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CA3A42ACC8
	for <lists+netdev@lfdr.de>; Mon, 27 May 2019 03:27:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725973AbfE0B1A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 May 2019 21:27:00 -0400
Received: from icp-osb-irony-out3.external.iinet.net.au ([203.59.1.153]:8909
        "EHLO icp-osb-irony-out3.external.iinet.net.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725864AbfE0B07 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 May 2019 21:26:59 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: =?us-ascii?q?A2AkAAAVPOtc/zXSMGcNVxkBAQEBAQE?=
 =?us-ascii?q?BAQEBAQEHAQEBAQEBgWWBZ4ZSk14GgRAlg1+FcIRyjBMJAQEBAQEBAQEBNwE?=
 =?us-ascii?q?BAYQ/AoJiOBMBAwEBAQQBAQEBAwGGXwEBAQECASMVQQULCw0LAgImAgJXBg0?=
 =?us-ascii?q?IAQGDHoF3BaZEcYEvGoUtgxyBRoEMKIFhigl4gQeBOAyCXz6HToJYBJNdhzO?=
 =?us-ascii?q?NQwmCD5MPBhuMcgOJVKR0gXgzGggoCIMogkVuAQiNJ49UAQE?=
X-IPAS-Result: =?us-ascii?q?A2AkAAAVPOtc/zXSMGcNVxkBAQEBAQEBAQEBAQEHAQEBA?=
 =?us-ascii?q?QEBgWWBZ4ZSk14GgRAlg1+FcIRyjBMJAQEBAQEBAQEBNwEBAYQ/AoJiOBMBA?=
 =?us-ascii?q?wEBAQQBAQEBAwGGXwEBAQECASMVQQULCw0LAgImAgJXBg0IAQGDHoF3BaZEc?=
 =?us-ascii?q?YEvGoUtgxyBRoEMKIFhigl4gQeBOAyCXz6HToJYBJNdhzONQwmCD5MPBhuMc?=
 =?us-ascii?q?gOJVKR0gXgzGggoCIMogkVuAQiNJ49UAQE?=
X-IronPort-AV: E=Sophos;i="5.60,517,1549900800"; 
   d="scan'208";a="185842111"
Received: from unknown (HELO [10.44.0.22]) ([103.48.210.53])
  by icp-osb-irony-out3.iinet.net.au with ESMTP; 27 May 2019 09:26:55 +0800
Subject: Re: [PATCH net] net: dsa: mv88e6xxx: Set correct interface mode for
 CPU/DSA ports
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <e27eeebb-44fb-ae42-d43d-b42b47510f76@kernel.org>
 <20190524134412.GE2979@lunn.ch>
From:   Greg Ungerer <gerg@kernel.org>
Message-ID: <f83b9083-4f2e-5520-b452-e11667c5c1cd@kernel.org>
Date:   Mon, 27 May 2019 11:26:55 +1000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190524134412.GE2979@lunn.ch>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Andrew,

Thanks for the quick response.


On 24/5/19 11:44 pm, Andrew Lunn wrote:
> On Fri, May 24, 2019 at 11:25:03AM +1000, Greg Ungerer wrote:
>> Hi Andrew,
>>
>> I have a problem with a Marvell 6390 switch that I have bisected
>> back to commit 7cbbee050c95, "[PATCH] net: dsa: mv88e6xxx: Set correct
>> interface mode for CPU/DSA ports".
>>
>> I have a Marvell 380 SoC based platform with a Marvell 6390 10 port
>> switch, everything works with kernel 5.0 and older. As of 5.1 the
>> switch ports no longer work - no packets are ever received and
>> none get sent out.
>>
>> The ports are probed and all discovered ok, they just don't work.
>>
>>    mv88e6085 f1072004.mdio-mii:10: switch 0x3900 detected: Marvell 88E6390, revision 1
>>    libphy: mv88e6xxx SMI: probed
>>    mv88e6085 f1072004.mdio-mii:10 lan1 (uninitialized): PHY [mv88e6xxx-1:01] driver [Marvell 88E6390]
>>    mv88e6085 f1072004.mdio-mii:10 lan2 (uninitialized): PHY [mv88e6xxx-1:02] driver [Marvell 88E6390]
>>    mv88e6085 f1072004.mdio-mii:10 lan3 (uninitialized): PHY [mv88e6xxx-1:03] driver [Marvell 88E6390]
>>    mv88e6085 f1072004.mdio-mii:10 lan4 (uninitialized): PHY [mv88e6xxx-1:04] driver [Marvell 88E6390]
>>    mv88e6085 f1072004.mdio-mii:10 lan5 (uninitialized): PHY [mv88e6xxx-1:05] driver [Marvell 88E6390]
>>    mv88e6085 f1072004.mdio-mii:10 lan6 (uninitialized): PHY [mv88e6xxx-1:06] driver [Marvell 88E6390]
>>    mv88e6085 f1072004.mdio-mii:10 lan7 (uninitialized): PHY [mv88e6xxx-1:07] driver [Marvell 88E6390]
>>    mv88e6085 f1072004.mdio-mii:10 lan8 (uninitialized): PHY [mv88e6xxx-1:08] driver [Marvell 88E6390]
>>    DSA: tree 0 setup
>>
>> Things like ethtool on the ports seem to work ok, reports link correctly.
>> Configuring ports as part of a bridge or individually gets the same result.
> 
> Hi Greg
> 
> DSA by default should configure the CPU port and DSA ports to there
> maximum speed. For port 10, that is 10Gbps. Your 380 cannot do that
> speed. So you need to tell the switch driver to slow down. Add a fixed
> link node to port ten, with speed 1000. You might also need to set the
> phy-mode to rgmii.

My hardware has the CPU port on 9, and it is SGMII. The existing working
devicetree setup I used is:

                        port@9 {
                                 reg = <9>;
                                 label = "cpu";
                                 ethernet = <&eth0>;
                                 fixed-link {
                                         speed = <1000>;
                                         full-duplex;
                                 };
                         };


> Can the 380 do 2500BaseX? There is work in progress to support this
> speed, so maybe next cycle you can change to that.

That would be nice.

Regards
Greg

