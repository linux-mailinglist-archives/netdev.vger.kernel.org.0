Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 19A5F6C2C8
	for <lists+netdev@lfdr.de>; Wed, 17 Jul 2019 23:51:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727468AbfGQVvz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Jul 2019 17:51:55 -0400
Received: from pandora.armlinux.org.uk ([78.32.30.218]:52156 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727229AbfGQVvz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Jul 2019 17:51:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:
        Content-Transfer-Encoding:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Reply-To:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=2rq5t0/7y2qTHtXHIrLaZLAQqkNxyvKZKHdSfn15RNA=; b=xaGuHAb+WNB24TuCh+9cEj2Wn
        3VHgqs7Ks1CmmCR6utbS8P2NsJCziXHnWvJtNZqSMFPt41SGHwFD/C+MDjVeu1kSsay1GDCuovRXJ
        Elssx7q6lW/Lit5psIQ6QV6Z7/0le8gljVhalwwVxGDcl9uLt0p8yh/KjT/5jr5UfmR1KNSS09+7I
        uDgkYk7xpAioGtfcmPDnScLHw0kSIt9MUVq61YG61GYDKtNrV23/o0po4lSySFqilfG30L9Mej68q
        8V1ShQPqeLeS5UXved9tMrGaELSpsXYEylXXxByeR9q/I3ORRYWJjuXU9HMMCsf7HjrOfLbfX5m6J
        pDaSP7NWw==;
Received: from shell.armlinux.org.uk ([2002:4e20:1eda:1:5054:ff:fe00:4ec]:59544)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1hnrq3-0002qh-GC; Wed, 17 Jul 2019 22:51:51 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.89)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1hnrq2-0001zJ-O7; Wed, 17 Jul 2019 22:51:50 +0100
Date:   Wed, 17 Jul 2019 22:51:50 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     =?iso-8859-1?Q?Ren=E9?= van Dorst <opensource@vdorst.com>
Cc:     netdev@vger.kernel.org
Subject: Re: phylink: flow control on fixed-link not working.
Message-ID: <20190717215150.tk3gvq7lqc56scac@shell.armlinux.org.uk>
References: <20190717213111.Horde.nir2D5kAJww569fjh8BZgZm@www.vdorst.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20190717213111.Horde.nir2D5kAJww569fjh8BZgZm@www.vdorst.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 17, 2019 at 09:31:11PM +0000, René van Dorst wrote:
> Hi,
> 
> I am trying to enable flow control/pause on PHYLINK and fixed-link.
> 
> My setup SOC mac (mt7621) <-> RGMII <-> SWITCH mac (mt7530).
> 
> It seems that in fixed-link mode all the flow control/pause bits are cleared
> in
> phylink_parse_fixedlink(). If I read phylink_parse_fixedlink() [0] correctly,
> I see that pl->link_config.advertising is AND with pl->supprted which has only
> the PHY_SETTING() modes bits set. pl->link_config.advertising is losing Pause
> bits. pl->link_config.advertising is used in phylink_resolve_flow() to set the
> MLO_PAUSE_RX/TX BITS.
> 
> I think this is an error.
> Because in phylink_start() see this part [1].
> 
>  /* Apply the link configuration to the MAC when starting. This allows
>   * a fixed-link to start with the correct parameters, and also
>   * ensures that we set the appropriate advertisement for Serdes links.
>   */
>  phylink_resolve_flow(pl, &pl->link_config);
>  phylink_mac_config(pl, &pl->link_config);
> 
> 
> If I add a this hacky patch below, flow control is enabled on the fixed-link.
>         if (s) {
>                 __set_bit(s->bit, pl->supported);
> +               if (phylink_test(pl->link_config.advertising, Pause))
> +                       phylink_set(pl->supported, Pause);
>         } else {
> 
> So is phylink_parse_fixedlink() broken or should it handled in a other way?

Quite simply, if the MAC says it doesn't support pause modes (i.o.w.
the validate callback clears them) then pause modes aren't supported.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 12.1Mbps down 622kbps up
According to speedtest.net: 11.9Mbps down 500kbps up
