Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E24D1FED76
	for <lists+netdev@lfdr.de>; Thu, 18 Jun 2020 10:20:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728601AbgFRIUP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Jun 2020 04:20:15 -0400
Received: from mail.intenta.de ([178.249.25.132]:25093 "EHLO mail.intenta.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727039AbgFRIUE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 18 Jun 2020 04:20:04 -0400
X-Greylist: delayed 324 seconds by postgrey-1.27 at vger.kernel.org; Thu, 18 Jun 2020 04:20:03 EDT
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=intenta.de; s=dkim1;
        h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:Subject:CC:To:From:Date; bh=H6dwnRKnSAwZ1mPEq8hnbpLALPJs7LiunanmFW679cw=;
        b=XXvIJ/7Qw/ZRDRlJ3jea70RIpw+YvTdtr+uPlEFsRbubufdMxcugVt+SQI72jGEfLrKNpVG1q+7Ew9NIGIds8HgxHtxFzoOT28wCnB2IfDs+IGRdbzHaeEa3VRlQ288YBwWANM2/mRHWUity48JSANkWc03+eohD74J5fu79+IC8dmnjzDXeOdU/wiGfJfD7Nmjns0tqSUpsX2P7B5FNHJC5J6HQXI12ta6v5+s48RK2Z+n6/FBkVllRr5bpgORdztNVJTi9We3EXAc4UeOlsFLQmYLkenalUxwZG4/kadvjRbWWnzkJTM87RJhQYKQBH2Ii6FOQkecpbeCGUbCR6Q==;
Date:   Thu, 18 Jun 2020 10:14:33 +0200
From:   Helmut Grohne <helmut.grohne@intenta.de>
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
CC:     Nicolas Ferre <nicolas.ferre@microchip.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>
Subject: Re: [PATCH] net: macb: reject unsupported rgmii delays
Message-ID: <20200618081433.GA22636@laureti-dev>
References: <20200616074955.GA9092@laureti-dev>
 <20200617105518.GO1551@shell.armlinux.org.uk>
 <20200617112153.GB28783@laureti-dev>
 <20200617114025.GQ1551@shell.armlinux.org.uk>
 <20200617115201.GA30172@laureti-dev>
 <20200617120809.GS1551@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20200617120809.GS1551@shell.armlinux.org.uk>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-ClientProxiedBy: ICSMA002.intenta.de (10.10.16.48) To ICSMA002.intenta.de
 (10.10.16.48)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 17, 2020 at 02:08:09PM +0200, Russell King - ARM Linux admin wrote:
> With a fixed link, we could be in either a MAC-to-PHY or MAC-to-MAC
> setup; we just don't know.  However, we don't have is access to the
> PHY (if it exists) in the fixed link case to configure it for the
> delay.

Let me twist that a little: We may have access to the PHY, but we don't
always have access. When we do have access, we have a separate device
tree node with another fixed-link and another phy-mode. For fixed-links,
we specify the phy-mode for each end.

> In the MAC-to-MAC RGMII setup, where neither MAC can insert the
> necessary delay, the only way to have a RGMII conformant link is to
> have the PCB traces induce the necessary delay. That errs towards
> PHY_INTERFACE_MODE_RGMII for this case.

Yes.

> However, considering the MAC-to-PHY RGMII fixed link case, where the
> PHY may not be accessible, and may be configured with the necessary
> delay, should that case also use PHY_INTERFACE_MODE_RGMII - clearly
> that would be as wrong as using PHY_INTERFACE_MODE_RGMII_ID would
> be for the MAC-to-MAC RGMII with PCB-delays case.

If you take into account that the PHY has a separate node with phy-mode
being rgmii-id, it makes a lot more sense to use rgmii for the phy-mode
of the MAC. So I don't think it is that clear that doing so is wrong.

In an earlier discussion Florian Fainelli said:
https://patchwork.ozlabs.org/project/netdev/patch/20190410005700.31582-19-olteanv@gmail.com/#2149183
| fixed-link really should denote a MAC to MAC connection so if you have
| "rgmii-id" on one side, you would expect "rgmii" on the other side
| (unless PCB traces account for delays, grrr).

For these reasons, I still think that rgmii would be a useful
description for the fixed-link to PHY connection where the PHY adds the
delay.

> So, I think a MAC driver should not care about the specific RGMII
> mode being asked for in any case, and just accept them all.

I would like to agree to this. However, the implication is that when you
get your delays wrong, your driver silently ignores you and you never
notice your mistake until you see no traffic passing and wonder why.

In this case, I was faced with a PHY that would do rgmii-txid and I
configured that on the MAC. Unfortunately, macb_main.c didn't tell me
that it did rgmii-id instead.

> I also think that some of this ought to be put in the documentation
> as guidance for new implementations.

That seems to be the part where everyone agrees.

Given the state of the discussion, I'm wondering whether this could be
fixed at a more fundamental level in the device tree bindings.

A number of people (including you) pointed out that retroactively fixing
the meaning of phy modes does not work and causes pain instead. That
hints that the only way to fix this is adding new properties. How about
this?

rgmii-delay-type:
  description:
    Responsibility for adding the rgmii delay
  enum:
    # The remote PHY or MAC to this MAC is responsible for adding the
    # delay.
    - remote
    # The delay is added by neither MAC nor MAC, but using PCB traces
    # instead.
    - pcb
    # The MAC must add the delay.
    - local
rgmii-rx-delay:
  # Responsibility for RX delay. Delay specification in the phy-mode is
  # ignored when this is present.
  $ref: "#/properties/rgmii-delay-type"
rgmii-tx-delay:
  # Responsibility for TX delay. Delay specification in the phy-mode is
  # ignored when this is present.
  $ref: "#/properties/rgmii-delay-type"

The naming is up to discussion, but I think you get the idea. The core
properties of this proposal are:
 * It does not break existing device trees.
 * It completely resolves the present ambiguity.
The major downside is that you never know whether your driver supports
such delay specifications already.

Helmut
