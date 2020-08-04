Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 30A3923C0D6
	for <lists+netdev@lfdr.de>; Tue,  4 Aug 2020 22:40:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727124AbgHDUju (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Aug 2020 16:39:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:35710 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726859AbgHDUjt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 4 Aug 2020 16:39:49 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4E5C220842;
        Tue,  4 Aug 2020 20:39:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596573588;
        bh=fwBmY9dgQYH4vZnWhrqR3ofWDj2807uG5uWKustVE04=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=vuQDUdyDj9mot5TWZAsK48WWfz+H4Hm/SYYEA4/+vJLbCkhgOXd38EemwWJ3F3Jyg
         0/JoTq0Pn1Yr0+DLLtruFovmSbvzl7o8EdTerHIgf2EevMcKp4s9fBNo0JMYf4nxq5
         5NMbKCQJpk3Yp/tiNehfe2Qqfut0juyswLlfRmqQ=
Date:   Tue, 4 Aug 2020 13:39:46 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     Moshe Shemesh <moshe@mellanox.com>,
        Jacob Keller <jacob.e.keller@intel.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Jiri Pirko <jiri@mellanox.com>,
        Vasundhara Volam <vasundhara-v.volam@broadcom.com>
Subject: Re: [PATCH net-next RFC 01/13] devlink: Add reload level option to
 devlink reload command
Message-ID: <20200804133946.7246514e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200804100418.GA2210@nanopsycho>
References: <20200728114458.762b5396@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <d6fbfedd-9022-ff67-23ed-418607beecc2@intel.com>
        <20200728130653.7ce2f013@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <04f00024-758c-bc19-c187-49847c24a5a4@mellanox.com>
        <20200729140708.5f914c15@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <3352bd96-d10e-6961-079d-5c913a967513@mellanox.com>
        <20200730161101.48f42c5b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <0f2467fd-ee2e-1a51-f9c1-02f8a579d542@mellanox.com>
        <20200803141442.GB2290@nanopsycho>
        <20200803135703.16967635@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <20200804100418.GA2210@nanopsycho>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 4 Aug 2020 12:04:18 +0200 Jiri Pirko wrote:
> Mon, Aug 03, 2020 at 10:57:03PM CEST, kuba@kernel.org wrote:
> >I was trying to avoid having to provide a Cartesian product of
> >operation and system disruption level, if any other action can
> >be done "live" at some point.
> >
> >But no strong feelings about that one.
> >
> >Really, as long as there is no driver-specific defaults (or as 
> >little driver-specific anything as possible) and user actions 
> >are clearly expressed (fw-reset does not necessarily imply
> >fw-activation) - the API will be fine IMO.  
> 
> Clear actions, that is what I'm fine with.
> 
> But not sure how you think we can achieve no driver-specific defaults.
> We have them already :/ I don't think we can easily remove them and not
> break user expectations.

AFAIU the per-driver default is needed because we went too low 
level with what the action constitutes. We need maintain the higher
level actions.

The user clearly did not care if FW was reset during devlink reload
before this set, so what has changed? The objective user has is to
activate their config / FW / move to different net ns. 

Reloading the driver or resetting FW is a low level detail which
achieves different things for different implementations. So it's 
not a suitable abstraction -> IOW we need the driver default.


The work flow for the user is:

0. download fw to /lib/firmware
1. devlink flash $dev $fw
2. if live activation is enabled
   yes - devlink reload $dev $live-activate
   no - report machine has to be drained for reboot

fw-reset can't be $live-activate, because as Jake said fw-reset does
not activate the new image for Intel. So will we end up per-driver
defaults in the kernel space, and user space maintaining a mapping from
a driver to what a "level" of reset implies.

I hope this makes things crystal clear. Please explain what problems
you're seeing and extensions you're expecting. A list of user scenarios
you foresee would be v. useful.
