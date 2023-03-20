Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2A8186C1221
	for <lists+netdev@lfdr.de>; Mon, 20 Mar 2023 13:44:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231481AbjCTMoL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Mar 2023 08:44:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231502AbjCTMoE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Mar 2023 08:44:04 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3B6028D00;
        Mon, 20 Mar 2023 05:43:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6F2AA614D0;
        Mon, 20 Mar 2023 12:43:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0DD09C433EF;
        Mon, 20 Mar 2023 12:43:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679316230;
        bh=3L9RSVyHVKcmoJzAucUoH9eNRK6jXEQQXLoDnI6KoZE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=U9HZSvj2T4jrnVdkZevOpl5TsEhVpNw5vvGGvE8p70PPY6Z1PdNDNoIR/vWwwmK+t
         1a32z68S/H45gRK/f/yB5EuHyrstF3Uee2QZ1/rxWF3QVPClhviTUDxXjONK6xWvJ7
         rz1J3UlgNQSZmNsPebL78BPfsyO7/svIEy/kqZWh8IbnyRKydPJEqBdZARljAFCV4m
         6SvV2xxXQE/DRdVEjJLkZDOyjOs9jGg6vZbE0vsESj1Ii2+ncsYEqAMX9Sy4LC6nWc
         M5WugU2WRItgpPM2JAOOW/yFkESzpVhpIKGj85navKXKNxFkszovhx86ZZ893aVyGa
         CaM2JusOo5PnQ==
Date:   Mon, 20 Mar 2023 18:13:46 +0530
From:   Vinod Koul <vkoul@kernel.org>
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc:     Colin Foster <colin.foster@in-advantage.com>,
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
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Lee Jones <lee@kernel.org>
Subject: Re: [PATCH v2 net-next 1/9] phy: phy-ocelot-serdes: add ability to
 be used in a non-syscon configuration
Message-ID: <ZBhVAg4hkLu56fsi@matsya>
References: <20230317185415.2000564-1-colin.foster@in-advantage.com>
 <20230317185415.2000564-2-colin.foster@in-advantage.com>
 <ZBgeKM50e1vt+ho1@matsya>
 <ZBgmXplfA/Q3/1dC@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZBgmXplfA/Q3/1dC@shell.armlinux.org.uk>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 20-03-23, 09:24, Russell King (Oracle) wrote:
> On Mon, Mar 20, 2023 at 02:19:44PM +0530, Vinod Koul wrote:
> > On 17-03-23, 11:54, Colin Foster wrote:
> > > The phy-ocelot-serdes module has exclusively been used in a syscon setup,
> > > from an internal CPU. The addition of external control of ocelot switches
> > > via an existing MFD implementation means that syscon is no longer the only
> > > interface that phy-ocelot-serdes will see.
> > > 
> > > In the MFD configuration, an IORESOURCE_REG resource will exist for the
> > > device. Utilize this resource to be able to function in both syscon and
> > > non-syscon configurations.
> > 
> > Applied to phy/next, thanks
> 
> Please read the netdev FAQ. Patches sent to netdev contain the tree that
> the submitter wishes the patches to be applied to.
> 
> As a result, I see davem has just picked up the *entire* series which
> means that all patches are in net-next now. net-next is immutable.
> 
> In any case, IMHO if this kind of fly-by cherry-picking from patch
> series is intended, it should be mentioned during review to give a
> chance for other maintainers to respond and give feedback. Not all
> submitters will know how individual maintainers work. Not all
> maintainers know how other maintainers work.

:-(

Just saw the email at similar time around mine! I can skip anything
which is tagged net-dev in future, saves me time from useless endeavours!

-- 
~Vinod
