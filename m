Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 86C2C23E101
	for <lists+netdev@lfdr.de>; Thu,  6 Aug 2020 20:42:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729592AbgHFSjt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Aug 2020 14:39:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:53992 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728212AbgHFS34 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 6 Aug 2020 14:29:56 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A68B1221E2;
        Thu,  6 Aug 2020 18:25:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596738333;
        bh=44fEtW2caAEFXbE7fawJjZxMVIwDcVHgxMSMWD9dt9I=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=pGb2mHgQfkiIS0YL5xHX/68+l4GHFu4EJCbRNO3qHj0hAlJLmlRvBiVSWp1v2pdZR
         s5dCjtvXrxDYZ2889wT/B88/eE9EVkBWx+mX692WZH7x29D/Ti8kEE7SCRIhEsVa1Z
         BY2BtiaRGKiNprz+j2KZ/gP7yVosJq1OrmKft654=
Date:   Thu, 6 Aug 2020 11:25:30 -0700
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
Message-ID: <20200806112530.0588b3ac@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200805110258.GA2169@nanopsycho>
References: <20200728130653.7ce2f013@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <04f00024-758c-bc19-c187-49847c24a5a4@mellanox.com>
        <20200729140708.5f914c15@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <3352bd96-d10e-6961-079d-5c913a967513@mellanox.com>
        <20200730161101.48f42c5b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <0f2467fd-ee2e-1a51-f9c1-02f8a579d542@mellanox.com>
        <20200803141442.GB2290@nanopsycho>
        <20200803135703.16967635@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <20200804100418.GA2210@nanopsycho>
        <20200804133946.7246514e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <20200805110258.GA2169@nanopsycho>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 5 Aug 2020 13:02:58 +0200 Jiri Pirko wrote:
> Tue, Aug 04, 2020 at 10:39:46PM CEST, kuba@kernel.org wrote:
> >AFAIU the per-driver default is needed because we went too low 
> >level with what the action constitutes. We need maintain the higher
> >level actions.
> >
> >The user clearly did not care if FW was reset during devlink reload
> >before this set, so what has changed? The objective user has is to  
> 
> Well for mlxsw, the user is used to this flow:
> devlink dev flash - flash new fw
> devlink dev reload - new fw is activated and reset and driver instances
> are re-created.

Ugh, if the current behavior already implies fw-activation for some
drivers then the default has to probably be "do all the things" :S

> >activate their config / FW / move to different net ns. 
> >
> >Reloading the driver or resetting FW is a low level detail which
> >achieves different things for different implementations. So it's 
> >not a suitable abstraction -> IOW we need the driver default.  
> 
> I'm confused. So you think we need the driver default?

No, I'm talking about the state of this patch set. _In this patchset_ 
we need a driver default because of the unsuitable abstraction.

Better design would not require it.

> >The work flow for the user is:
> >
> >0. download fw to /lib/firmware
> >1. devlink flash $dev $fw
> >2. if live activation is enabled
> >   yes - devlink reload $dev $live-activate
> >   no - report machine has to be drained for reboot
> >
> >fw-reset can't be $live-activate, because as Jake said fw-reset does
> >not activate the new image for Intel. So will we end up per-driver
> >defaults in the kernel space, and user space maintaining a mapping from  
> 
> Well, that is what what is Moshe's proposal. Per-driver kernel default..
> I'm not sure what we are arguing about then :/

The fact that if I do a pure "driver reload" it will active new
firmware for mlxsw but not for mlx5. In this patchset for mlx5 I need
driver reload fw-reset. And for Intel there is no suitable option.

> >a driver to what a "level" of reset implies.
> >
> >I hope this makes things crystal clear. Please explain what problems
> >you're seeing and extensions you're expecting. A list of user scenarios
> >you foresee would be v. useful.  
