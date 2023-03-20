Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E82CA6C1CB8
	for <lists+netdev@lfdr.de>; Mon, 20 Mar 2023 17:50:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232650AbjCTQum (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Mar 2023 12:50:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232865AbjCTQtv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Mar 2023 12:49:51 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4FD3173F;
        Mon, 20 Mar 2023 09:42:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4748EB80F9C;
        Mon, 20 Mar 2023 16:41:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A25C3C433EF;
        Mon, 20 Mar 2023 16:41:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679330502;
        bh=j6QNvV6H6eDt02wjxkiTvHZcQhOub+6iicJVNt8AiKc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ABDM8gSrZx5kc8OL/cA9piN5bghBYggzRStcFDbwGlZqI1jRBM+7elOaAMCnSkqlo
         f0QGSia0zpPEELZeH+fR2d7BdDayswnu+zKSXHAKy0bZiZz+cuTjfDyZ7MbVSvSghB
         vxtZAWN9I53zhXjXvTQT56TNpsO1xcxp9YZakJM7Q15bzF2Hv75FhefWKU1Pi5721m
         bJCBSQ9Re1gg2gjW01D4wFXIgEEdKuHzZ4CTkCatJxMf8KjX+KJWLpzlUE3vvnhjkK
         AQbk4krJEBDjgjC9ZWjaWLNGhBXD9XAH1O6KrKXhaNbHuV6atuYRflGNbeYQCbzvCa
         Vdkg5y+ND7Hfw==
Date:   Mon, 20 Mar 2023 16:41:36 +0000
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
Message-ID: <20230320164136.GC2673958@google.com>
References: <20230317185415.2000564-1-colin.foster@in-advantage.com>
 <20230317185415.2000564-2-colin.foster@in-advantage.com>
 <ZBgeKM50e1vt+ho1@matsya>
 <ZBgmXplfA/Q3/1dC@shell.armlinux.org.uk>
 <20230320133431.GB2673958@google.com>
 <ZBhtOw4Ftj3Sa3JU@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ZBhtOw4Ftj3Sa3JU@shell.armlinux.org.uk>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 20 Mar 2023, Russell King (Oracle) wrote:

> On Mon, Mar 20, 2023 at 01:34:31PM +0000, Lee Jones wrote:
> > On Mon, 20 Mar 2023, Russell King (Oracle) wrote:
> >
> > > On Mon, Mar 20, 2023 at 02:19:44PM +0530, Vinod Koul wrote:
> > > > On 17-03-23, 11:54, Colin Foster wrote:
> > > > > The phy-ocelot-serdes module has exclusively been used in a syscon setup,
> > > > > from an internal CPU. The addition of external control of ocelot switches
> > > > > via an existing MFD implementation means that syscon is no longer the only
> > > > > interface that phy-ocelot-serdes will see.
> > > > >
> > > > > In the MFD configuration, an IORESOURCE_REG resource will exist for the
> > > > > device. Utilize this resource to be able to function in both syscon and
> > > > > non-syscon configurations.
> > > >
> > > > Applied to phy/next, thanks
> > >
> > > Please read the netdev FAQ. Patches sent to netdev contain the tree that
> > > the submitter wishes the patches to be applied to.
> > >
> > > As a result, I see davem has just picked up the *entire* series which
> > > means that all patches are in net-next now. net-next is immutable.
> > >
> > > In any case, IMHO if this kind of fly-by cherry-picking from patch
> > > series is intended, it should be mentioned during review to give a
> > > chance for other maintainers to respond and give feedback. Not all
> > > submitters will know how individual maintainers work. Not all
> > > maintainers know how other maintainers work.
> >
> > Once again netdev seems to have applied patches from other subsystems
> > without review/ack.  What makes netdev different to any other kernel
> > subsystem?  What would happen if other random maintainers started
> > applying netdev patches without appropriate review?  I suspect someone
> > would become understandably grumpy.
>
> Why again are you addressing your whinge to me? I'm not one of the
> netdev maintainers, but I've pointed out what happens in netdev
> land. However, you seem to *not* want to discuss it directly with
> DaveM/Jakub/Paolo - as illustrated again with yet another response
> to *me* rather than addressing your concerns *to* the people who
> you have an issue with.
>
> This is not communication. Effectively, this is sniping, because
> rather than discussing it with the individuals concerned, you are
> instead preferring to discuss it with others.
>
> Please stop this.

Read the above paragraph again.

It was an open question, *intentionally* not directed *at* anyone.

You just happen to be the one describing yet another unfortunate
situation.  Consider yourself a victim of circumstance and try not to
take any of it personally.

It's the workflow and the assumptions that I'm unhappy about and that I
think should be improved upon.  The gripe is not against any one
individual or individuals.

--
Lee Jones [李琼斯]
