Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D702048DDA6
	for <lists+netdev@lfdr.de>; Thu, 13 Jan 2022 19:27:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237522AbiAMS1Z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Jan 2022 13:27:25 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:40952 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230289AbiAMS1Z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Jan 2022 13:27:25 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DAB55B82325;
        Thu, 13 Jan 2022 18:27:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52EBFC36AEB;
        Thu, 13 Jan 2022 18:27:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642098442;
        bh=lDz34ZVMgLLYfOQXsCEzJ1y3tKvlqRylg8PQrj64Y3M=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=legVsKhNla0DjVT16LpymMWEOD/el6BUbR1lkXh6vnRmx5LwOpSgvhh1PEjxXYIXP
         jZoi4wQJp1Mt10znUjq75E1oRP545XzJfqGBNtvlJLP97dn+6sMnPSRpq1PM+NnD1l
         m7R4zxo0oB5RLOLSnauJLC5OJEnfGXsi6ufJQ4vTNSBmxd67TfrHNaeI3KtRys8jem
         +YI3foEEbOyaHbl0iQMM/AMTwa/2mw2gLJlfyTdTnzfMuznbnKJkZfln7eVu03klHT
         AnDp6kZMWR+3Suo632zjz0chEB4qP3KTlsyZ9w/JcQuUOXE4T2Sly7TYlXbk4pAjMV
         eLQ8+nQ2QP5ug==
Received: by pali.im (Postfix)
        id BE629778; Thu, 13 Jan 2022 19:27:19 +0100 (CET)
Date:   Thu, 13 Jan 2022 19:27:19 +0100
From:   Pali =?utf-8?B?Um9ow6Fy?= <pali@kernel.org>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     "Russell King (Oracle)" <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Marek =?utf-8?B?QmVow7pu?= <kabel@kernel.org>,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] of: net: Add helper function of_get_ethdev_label()
Message-ID: <20220113182719.ixgysemitp5cuidn@pali>
References: <20220107161222.14043-1-pali@kernel.org>
 <Ydhqa+9ya6nHsvLq@shell.armlinux.org.uk>
 <Ydhwfa/ECqTE3rLx@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <Ydhwfa/ECqTE3rLx@lunn.ch>
User-Agent: NeoMutt/20180716
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Friday 07 January 2022 17:55:25 Andrew Lunn wrote:
> On Fri, Jan 07, 2022 at 04:29:31PM +0000, Russell King (Oracle) wrote:
> > On Fri, Jan 07, 2022 at 05:12:21PM +0100, Pali Rohár wrote:
> > > Adds a new helper function of_get_ethdev_label() which sets initial name of
> > > specified netdev interface based on DT "label" property. It is same what is
> > > doing DSA function dsa_port_parse_of() for DSA ports.
> > > 
> > > This helper function can be useful for drivers to make consistency between
> > > DSA and netdev interface names.
> > > 
> > > Signed-off-by: Pali Rohár <pali@kernel.org>
> > 
> > Doesn't this also need a patch to update the DT binding document
> > Documentation/devicetree/bindings/net/ethernet-controller.yaml ?
> > 
> > Also it needs a covering message for the series, and a well thought
> > out argument why this is required. Consistency with DSA probably
> > isn't a good enough reason.
> > 
> > >From what I remember, there have been a number of network interface
> > naming proposals over the years, and as you can see, none of them have
> > been successful... but who knows what will happen this time.
> 
> I agree with Russell here. I doubt this is going to be accepted.
> 
> DSA is special because DSA is very old, much older than DT, and maybe
> older than udev. The old DSA platform drivers had a mechanism to
> supply the interface name to the DSA core. When we added a DT binding
> to DSA we kept that mechanism, since that mechanism had been used for
> a long time.
> 
> Even if you could show there was a generic old mechanism, from before
> the days of DT, that allowed interface names to be set from platform
> drivers, i doubt it would be accepted because there is no continuity,
> which DSA has.

Well, DT should universally describe HW board wiring. From HW point of
view, it is really does not matter if RJ45 port is connected to embedded
PHY on SoC itself or to the external PHY chip, or to the switch chip
with embedded PHY. And if board has mix of these options, also labels
(as printed on product box) should be in DTS described in the same way,
independently of which software solution / driver is used for particular
chip. It really should not matter for DTS if kernel is using for
particular HW part DSA driver or ethernet driver.

So there really should be some common way. And if the one which DSA is
using is the old mechanism, what is the new mechanism then?
