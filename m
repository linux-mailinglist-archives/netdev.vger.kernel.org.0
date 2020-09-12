Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 48502267911
	for <lists+netdev@lfdr.de>; Sat, 12 Sep 2020 11:12:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725817AbgILJMs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Sep 2020 05:12:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725805AbgILJMs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 12 Sep 2020 05:12:48 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FFBBC061573
        for <netdev@vger.kernel.org>; Sat, 12 Sep 2020 02:12:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=9VPRDIqwbo/uPBUvG78Pya89U71BxiPJFZByy8EBX/s=; b=JHnpYFyqOJ9N5in1IDPJfdEAL
        ttlRE02IXU7Dqq+csbh4/qOxTNIhaVR1Pp36wyBVOQzWUQ/RGMelBt8C+AO7zRk0yvLK9EkBrtK+h
        WLsqGnrdAVphlHAfZEp/eIfqlv+8hEmM7JZdPrA3LXjtJlWZqgK8M//LfODbvCLjj7m+AMHn/6Prb
        WhI5WR7J3z/yuoAf+FiD7XWS9/fWXcnmTuC3ruDtpTjie2JL9jAHBXRNTGwNtwR0fnHvdjsUjCsWb
        vpKqzwgkcCzfmDdhki4TFUD0OGrrydqyJ20b3x2agOttYmapY3bbwjyFwrIcBR/rO+CXHfnnzXGf/
        df7T2wOIA==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:33038)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1kH1aN-0008Fw-GD; Sat, 12 Sep 2020 10:12:43 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1kH1aM-0000aw-Ka; Sat, 12 Sep 2020 10:12:42 +0100
Date:   Sat, 12 Sep 2020 10:12:42 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Vadym Kochan <vadym.kochan@plvision.eu>
Cc:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>
Subject: Re: [DISCUSS] sfp: sfp controller concept
Message-ID: <20200912091242.GI1551@shell.armlinux.org.uk>
References: <20200911181914.GB20711@plvision.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200911181914.GB20711@plvision.eu>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Sep 11, 2020 at 09:19:14PM +0300, Vadym Kochan wrote:
> Hi,
> 
> I'd like to discuss a concept of introduction additional entity into SFP
> subsystem called SFP controller. But lets start with the issue.
> 
> Issue
> =====
> 
> There are boards with SFP ports whose GPIO pins are not connected directly to
> the SoC but to the I2C CPLD device which has ability to read/write statuses of
> each SFP via I2C read/write commands.
> 
> Of course there is already a solution - implement GPIO chip and convert GPIO
> numbers & states into internal representation (I2C registers). But it requires
> additional GPIO-related handling like:
> 
> 1) Describe GPIO pins and IN/OUT mapping in DTS
> 
> 2) Consider this mapping also in CPLD driver
> 
> 3) IRQ - for me this is not clear how to simulate
>    sending IRQ via GPIO chip.
> 
> I started to think that may be it would be good to introduce
> some generic sfp_controller which might be registered by such CPLD
> driver which may provide states of connected modules through the
> callback by mapping direct SFP states into it's CPLD registers and
> call some sfp_state_update() which will trigger the SFP state
> machine. So this driver will check/provide on direct SFP defined
> states without considering the GPIO things.

The driver already has the basis for splitting the control signals -
this is why there is sfp->get_state()/sfp->set_state(). However, until
there is hardware that requires something that isn't a GPIO, there was
no point taking it further.

> How it may look
> ===============
> 
> Device tree:
> 
> sfp0: sfp0 {
>         compatible = "sff,sfp";
>         i2c-bus = <&i2c0_sfp0>;
>         /* ref to controller device */
>         ctl = <&cpld>;
>         /* this index will be used by sfp controller */
>         idx = <0>;
> };
> 
> SFP controller interface:
> 
> There might be added generic sfp-ctl.c which implements the basic sfp controller infra:
> 
>     1) register/unregister sfp controller driver
> 
>     2) lookup sfp controller by fwnode on SFP node parsing/probing
> 
> The relation between modules might be:
> 
>     sfp.c <-> sfp-ctl.c <- driver <-> CPLD or some device
> 
> Flows:
> 1) CPLD driver prope:
>     driver -> sfp_controller_register()
> 
> 2) SFP instance probe:
>     sfp.c -> sfp-ctl.c:sfp_controller_add_socket()
>              creates assoctation between idx and sfp instance.
>                                       
> 3) SFP get state:
>     sfp.c -> sfp_ctl_get_state() -> sfp-ctl.c:sfp_controller_get_state() -> driver ops -> get_state
> 
> 4) SFP state updated:
>     driver -> sfp-ctl.c:sfp_controller_notify() -> sfp.c:sfp_state_update()
>               finds struct sfp* instance by idx

You are missing one of the most important things to consider - the SFP
and SFP controller become different drivers. How do they get associated,
and how does the probing between both work? What happens when one of
those drivers is unbound and the resources it provides are taken away?

> Currently I do not see how to properly define sfp_state_update(...) func
> which may be triggered by sfp controller to notify SFP state machine. May be additional
> interface is needed which may provide to controller the sfp* instance and it's idx:
> 
> int sfp_controller_add_socket(struct sfp_controller *ctl, struct sfp *sfp, int idx);
> 
> void sfp_controller_del_socket(struct sfp_controller *ctl, struct sfp *sfp);

I don't see how an index helps. What does the index define?

There's also the issue that the SFP cage driver needs to know which
hardware signals are implemented, so it knows whether to make use of the
soft signals that are available via the I2C bus on the module. I don't
see that having been addressed in your proposal.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
