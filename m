Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 090DB62CF3F
	for <lists+netdev@lfdr.de>; Thu, 17 Nov 2022 00:59:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232804AbiKPX7E (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Nov 2022 18:59:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231300AbiKPX7D (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Nov 2022 18:59:03 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABB6A17057;
        Wed, 16 Nov 2022 15:59:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=THRVaYizhgSM/LrXu2xoRek9BSvZhHKUNBtqQFkqPUY=; b=UZ44W5ZJPQr4YHN4fXXhJuzJ5L
        v2xD3zuWI71vGnriO31FhHfCfwcEjqm8T2rlBrHfziE7z2FPdCkKSVY3mxBuEn7mQrMFoyAN60LZ4
        m0xWULPZiAAYnx44w3gToRnWOCkcigkDE5zg+PzJpa7UWVrKjbj8yglra1m6U+YfQNzQ=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1ovSHy-002cuv-Tp; Thu, 17 Nov 2022 00:57:54 +0100
Date:   Thu, 17 Nov 2022 00:57:54 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     Xiaolei Wang <xiaolei.wang@windriver.com>, hkallweit1@gmail.com,
        linux@armlinux.org.uk, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] net: fec: Create device link between phy dev and mac
 dev
Message-ID: <Y3V5AgBMBOx/ptwx@lunn.ch>
References: <20221116144305.2317573-1-xiaolei.wang@windriver.com>
 <20221116144305.2317573-3-xiaolei.wang@windriver.com>
 <Y3T8wliAKdl/paS6@lunn.ch>
 <355a8611-b60e-1166-0f7b-87a194debd07@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <355a8611-b60e-1166-0f7b-87a194debd07@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 16, 2022 at 03:27:39PM -0800, Florian Fainelli wrote:
> On 11/16/22 07:07, Andrew Lunn wrote:
> > On Wed, Nov 16, 2022 at 10:43:05PM +0800, Xiaolei Wang wrote:
> > > On imx6sx, there are two fec interfaces, but the external
> > > phys can only be configured by fec0 mii_bus. That means
> > > the fec1 can't work independently, it only work when the
> > > fec0 is active. It is alright in the normal boot since the
> > > fec0 will be probed first. But then the fec0 maybe moved
> > > behind of fec1 in the dpm_list due to various device link.
> 
> Humm, but if FEC1 depends upon its PHY to be available by the FEC0 MDIO bus
> provider, then surely we will need to make sure that FEC0's MDIO bus is
> always functional, and that includes surviving re-ordering as well as any
> sort of run-time power management that can occur.

Runtime PM is solved for the FECs MDIO bus, because there are switches
hanging off it, which have their own life cycle independent of the
MAC. This is something i had to fix many moons ago, when the FEC would
power off the MDIO bus when the interface is admin down, stopping
access to the switch. The mdio read and write functions now do run
time pm get and put as needed.

I've never done suspend/resume with a switch, it is not something
needed in the use cases i've covered.

> > > So in system suspend and resume, we would get the following
> > > warning when configuring the external phy of fec1 via the
> > > fec0 mii_bus due to the inactive of fec0. In order to fix
> > > this issue, we create a device link between phy dev and fec0.
> > > This will make sure that fec0 is always active when fec1
> > > is in active mode.
> 
> Still not clear to me how the proposed fix works, let alone how it does not
> leak device links since there is no device_link_del(), also you are going to
> be creating guaranteed regressions by putting that change in the PHY
> library.

The reference leak is bad, but i think phylib is the correct place to
fix this general issue. It is not specific to the FEC. There are other
boards with dual MAC SoCs and they save a couple of pins by putting
both PHYs on one MDIO bus. Having the link should help better
represent the device tree so that suspend/resume can do stuff in the
right order.

      Andrew
