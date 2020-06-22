Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 75083203F5F
	for <lists+netdev@lfdr.de>; Mon, 22 Jun 2020 20:43:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730030AbgFVSnR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Jun 2020 14:43:17 -0400
Received: from mail.bugwerft.de ([46.23.86.59]:58018 "EHLO mail.bugwerft.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729605AbgFVSnR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 22 Jun 2020 14:43:17 -0400
Received: from [192.168.178.106] (p57bc9787.dip0.t-ipconnect.de [87.188.151.135])
        by mail.bugwerft.de (Postfix) with ESMTPSA id 95D3E42B84D;
        Mon, 22 Jun 2020 18:43:15 +0000 (UTC)
Subject: Re: [PATCH] net: dsa: mv88e6xxx: don't force settings on CPU port
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     vivien.didelot@gmail.com, f.fainelli@gmail.com,
        davem@davemloft.net, netdev@vger.kernel.org
References: <20200327195156.1728163-1-daniel@zonque.org>
 <20200327200153.GR3819@lunn.ch>
 <d101df30-5a9e-eac1-94b0-f171dbcd5b88@zonque.org>
 <20200327211821.GT3819@lunn.ch>
 <1bff1da3-8c9d-55c6-3408-3ae1c3943041@zonque.org>
 <20200327235220.GV3819@lunn.ch>
 <64462bcf-6c0c-af4f-19f4-d203daeabec3@zonque.org>
 <20200330134010.GA23477@lunn.ch>
From:   Daniel Mack <daniel@zonque.org>
Message-ID: <9f0bb7db-f80c-759a-ada8-952f4f05aeba@zonque.org>
Date:   Mon, 22 Jun 2020 20:43:15 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200330134010.GA23477@lunn.ch>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Andrew,

Picking up this ancient thread, sorry for the delay.

On 3/30/20 3:40 PM, Andrew Lunn wrote:
> On Mon, Mar 30, 2020 at 11:29:27AM +0200, Daniel Mack wrote:
>> On 3/28/20 12:52 AM, Andrew Lunn wrote:
>>> Did you turn off auto-neg on the external PHY and use fixed 100Full?
>>> Ethtool on the SoC interface should show you if the switch PHY is
>>> advertising anything. I'm guessing it is not, and hence you need to
>>> turn off auto neg on the external PHY.
>>>
>>> Another option would be something like
>>>
>>>                                         port@6 {
>>>                                                 reg = <6>;
>>>                                                 label = "cpu";
>>>                                                 ethernet = <&fec1>;
>>>
>>>                                                 phy-handle = <phy6>;
>>>                                         };
>>>                                 };
>>>
>>>                                 mdio {
>>>                                         #address-cells = <1>;
>>>                                         #size-cells = <0>;
>>>                                         phy6: ethernet-phy@6 {
>>>                                                 reg = <6>;
>>>                                                 interrupt-parent = <&switch0>;
>>>                                                 interrupts = <0 IRQ_TYPE_LEVEL_HIGH>;
>>>                                         };
>>>                                 };
>>>
>>> By explicitly saying there is a PHY for the CPU node, phylink might
>>> drive it.
> 
> You want to debug this. Although what you have is unusual, yours is
> not the only board. It is something we want to work. And ideally,
> there should be something controlling the PHY.

I spent some more time on this today, and the reason for why this fails
is simple. The PHY on port 4 is internal, and mv88e6xxx_mac_config()
hence decides to not touch the config of this port, unless it's a
fixed-linked config. And the latter is not an option the port has a
phy-handle.

This means that non-fixed ports with internal PHYs are only programmed
once at probe time, and userspace can't modify the settings later on.

I've sent a patch to relax that check, but tbh I'm not sure whether I
miss a relevant piece of detail about the current code.


Thanks,
Daniel
