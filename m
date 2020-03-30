Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EECF81977E0
	for <lists+netdev@lfdr.de>; Mon, 30 Mar 2020 11:29:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728546AbgC3J33 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Mar 2020 05:29:29 -0400
Received: from mail.bugwerft.de ([46.23.86.59]:50184 "EHLO mail.bugwerft.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728383AbgC3J33 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 30 Mar 2020 05:29:29 -0400
Received: from [192.168.178.106] (pD95EFBD9.dip0.t-ipconnect.de [217.94.251.217])
        by mail.bugwerft.de (Postfix) with ESMTPSA id 0FA9129CABF;
        Mon, 30 Mar 2020 09:27:31 +0000 (UTC)
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
From:   Daniel Mack <daniel@zonque.org>
Message-ID: <64462bcf-6c0c-af4f-19f4-d203daeabec3@zonque.org>
Date:   Mon, 30 Mar 2020 11:29:27 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200327235220.GV3819@lunn.ch>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/28/20 12:52 AM, Andrew Lunn wrote:
>> I tried this as well with v5.5, but that leads to the external phy not
>> seeing a link at all. Will check again though.
> 
> Did you turn off auto-neg on the external PHY and use fixed 100Full?
> Ethtool on the SoC interface should show you if the switch PHY is
> advertising anything. I'm guessing it is not, and hence you need to
> turn off auto neg on the external PHY.
> 
> Another option would be something like
> 
>                                         port@6 {
>                                                 reg = <6>;
>                                                 label = "cpu";
>                                                 ethernet = <&fec1>;
> 
>                                                 phy-handle = <phy6>;
>                                         };
>                                 };
> 
>                                 mdio {
>                                         #address-cells = <1>;
>                                         #size-cells = <0>;
>                                         phy6: ethernet-phy@6 {
>                                                 reg = <6>;
>                                                 interrupt-parent = <&switch0>;
>                                                 interrupts = <0 IRQ_TYPE_LEVEL_HIGH>;
>                                         };
>                                 };
> 
> By explicitly saying there is a PHY for the CPU node, phylink might
> drive it.

Hmm, no. No luck with this either.

Given that the code forces the MAC for cases in which there is no PHY,
could we maybe omit this if there _is_ a PHY? Or make it conditional via
a DT property?


Thanks,
Daniel
