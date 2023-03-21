Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 54BE06C2C4C
	for <lists+netdev@lfdr.de>; Tue, 21 Mar 2023 09:27:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230156AbjCUI1e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Mar 2023 04:27:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230273AbjCUI1K (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Mar 2023 04:27:10 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A240B3C793;
        Tue, 21 Mar 2023 01:27:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 40791B81252;
        Tue, 21 Mar 2023 08:27:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1B79C433EF;
        Tue, 21 Mar 2023 08:27:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679387225;
        bh=G8XymTXPHbxOnstyG63Kd2jgHhH5dsTlu9HPkRT19pw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=tefxz2aFJsJSJAT9m2sxqO7z2PEBl56vSqPhmfiqxPVQQPuSX3hM9bwVWsUfBUbUV
         SN6w+Tb/vnoTpcHujhSOStnaApNS4VpEmgCNZ3oR72owoz5kYDnnFe/tydRB0rUNEX
         qamTvhKJA+FpyKbFOSzTV6ffMagjaw4JjCbDRMqPpGaM80RGOoNsRaXqvad0fjGnel
         kqLiqpg3nmO8RwbGwSGC6gDf6HcIuMdJpLxFuxwImT/ePCfGrMf3iPXyHfdPJHEskq
         GwBn7US73vVmOCe+1hL+JHJhm61brMjUu4/7bhOrOYUq+gMYjRx2f7OEOe5pK0JEI4
         C+O56sU2uY5IA==
Date:   Tue, 21 Mar 2023 08:26:58 +0000
From:   Lee Jones <lee@kernel.org>
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc:     Vinod Koul <vkoul@kernel.org>,
        Colin Foster <colin.foster@in-advantage.com>,
        linux-phy@lists.infradead.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Kishon Vijay Abraham I <kishon@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>, UNGLinuxDriver@microchip.com,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: Re: [PATCH v2 net-next 1/9] phy: phy-ocelot-serdes: add ability to
 be used in a non-syscon configuration
Message-ID: <20230321082658.GD2673958@google.com>
References: <20230317185415.2000564-1-colin.foster@in-advantage.com>
 <20230317185415.2000564-2-colin.foster@in-advantage.com>
 <ZBgeKM50e1vt+ho1@matsya>
 <ZBgmXplfA/Q3/1dC@shell.armlinux.org.uk>
 <20230320133431.GB2673958@google.com>
 <ZBhtOw4Ftj3Sa3JU@shell.armlinux.org.uk>
 <20230320164136.GC2673958@google.com>
 <ZBiRFNAqd94tbEJ9@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ZBiRFNAqd94tbEJ9@shell.armlinux.org.uk>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 20 Mar 2023, Russell King (Oracle) wrote:

> On Mon, Mar 20, 2023 at 04:41:36PM +0000, Lee Jones wrote:
> > On Mon, 20 Mar 2023, Russell King (Oracle) wrote:
> >
> > > On Mon, Mar 20, 2023 at 01:34:31PM +0000, Lee Jones wrote:
> > > > Once again netdev seems to have applied patches from other subsystems
> > > > without review/ack.  What makes netdev different to any other kernel
> > > > subsystem?  What would happen if other random maintainers started
> > > > applying netdev patches without appropriate review?  I suspect someone
> > > > would become understandably grumpy.
> > >
> > > Why again are you addressing your whinge to me? I'm not one of the
> > > netdev maintainers, but I've pointed out what happens in netdev
> > > land. However, you seem to *not* want to discuss it directly with
> > > DaveM/Jakub/Paolo - as illustrated again with yet another response
> > > to *me* rather than addressing your concerns *to* the people who
> > > you have an issue with.
> > >
> > > This is not communication. Effectively, this is sniping, because
> > > rather than discussing it with the individuals concerned, you are
> > > instead preferring to discuss it with others.
> > >
> > > Please stop this.
> >
> > Read the above paragraph again.
>
> You sent your email _TO_ me, that means you addressed your comments
> primarily _to_ me. RFC2822:
>
>    The "To:" field contains the address(es) of the primary recipient(s)
>    of the message.
>
>    The "Cc:" field (where the "Cc" means "Carbon Copy" in the sense of
>    making a copy on a typewriter using carbon paper) contains the
>    addresses of others who are to receive the message, though the
>    content of the message may not be directed at them.

You're over-thinking it.  I replied to all.

--
Lee Jones [李琼斯]
