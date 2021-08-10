Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 960C43E5C6C
	for <lists+netdev@lfdr.de>; Tue, 10 Aug 2021 16:00:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240452AbhHJOAU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Aug 2021 10:00:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:37424 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240460AbhHJOAR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 10 Aug 2021 10:00:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5AD7B60FDA;
        Tue, 10 Aug 2021 13:59:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628603995;
        bh=cUGDZE9Xg2IJjNxEw677DX+pac9KgLJszxZNXbEccBU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=baOqIho5KNRYlT55FB7U+UzuN6FNpheHSOV2Z50xwJ3osSpTt6yS9/TW4Qfmikk57
         P9PKE3BU83UB8TAPJpQxzrT59o5cH9j2sAlfvyoijqoMsE1Q/dCyrawDoHMkSmDZjb
         SANQnsojd8PUpkD6klbNa8inCxV8tscX2hSaXqkQY/pnIQsP7Gey0SjYuT1kzbAgTb
         TqZufDc65VUw3Q2FGZgpS2S7rtiAkr5tvsApQlSmdkE3CqCLGk4q2OkN0MuMsTVtBk
         XODeGSbL1zSjd7kvGb3eeAejNYmsLbZni3NBHlt3118kO/YpK1kChtvHJ8pXR3PHLi
         JO3x7E4KS3bkw==
Date:   Tue, 10 Aug 2021 06:59:54 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Andrew Lunn <andrew@lunn.ch>,
        "Keller, Jacob E" <jacob.e.keller@intel.com>
Cc:     Ido Schimmel <idosch@idosch.org>, netdev@vger.kernel.org,
        davem@davemloft.net, mkubecek@suse.cz, pali@kernel.org,
        vadimp@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: Re: [RFC PATCH net-next 1/8] ethtool: Add ability to control
 transceiver modules' low power mode
Message-ID: <20210810065954.68036568@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <YRKElHYChti9EeHo@lunn.ch>
References: <20210809102152.719961-1-idosch@idosch.org>
        <20210809102152.719961-2-idosch@idosch.org>
        <YRE7kNndxlGQr+Hw@lunn.ch>
        <YRIqOZrrjS0HOppg@shredder>
        <YRKElHYChti9EeHo@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 10 Aug 2021 15:52:20 +0200 Andrew Lunn wrote:
> > The transition from low power to high power can take a few seconds with
> > QSFP/QSFP-DD and it's likely to only get longer with future / more
> > complex modules. Therefore, to reduce link-up time, the firmware
> > automatically transitions modules to high power mode.
> > 
> > There is obviously a trade-off here between power consumption and
> > link-up time. My understanding is that Mellanox is not the only vendor
> > favoring shorter link-up times as users have the ability to control the
> > low power mode of the modules in other implementations.
> > 
> > Regarding "why do we need user space involved?", by default, it does not
> > need to be involved (the system works without this API), but if it wants
> > to reduce the power consumption by setting unused modules to low power
> > mode, then it will need to use this API.  
> 
> O.K. Thanks for the better explanation. Some of this should go into
> the commit message.
> 
> I suggest it gets a different name and semantics, to avoid
> confusion. I think we should consider this the default power mode for
> when the link is administratively down, rather than direct control
> over the modules power mode. The driver should transition the module
> to this setting on link down, be it high power or low power. That
> saves a lot of complexity, since i assume you currently need a udev
> script or something which sets it to low power mode on link down,
> where as you can avoid this be configuring the default and let the
> driver do it.

Good point. And actually NICs have similar knobs, exposed via ethtool
priv flags today. Intel NICs for example. Maybe we should create a
"really power the port down policy" API?

Jake do you know what the use cases for Intel are? Are they SFP, MAC,
or NC-SI related?

> I also wonder if a hierarchy is needed? You can set the default for
> the switch, and then override is per module? I _guess_ most users will
> decide at a switch level they want to save power and pay the penalty
> over longer link up times. But then we have the question, is it an
> ethtool option, or a devlink parameter?
