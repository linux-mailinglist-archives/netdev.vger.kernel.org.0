Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E440400E7F
	for <lists+netdev@lfdr.de>; Sun,  5 Sep 2021 09:08:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233418AbhIEHIx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Sep 2021 03:08:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:40476 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230076AbhIEHIw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 5 Sep 2021 03:08:52 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0908E60F90;
        Sun,  5 Sep 2021 07:07:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1630825669;
        bh=2AN7jaUkId5p5Qt1yhW27a/sFRX0ygt9NOhtHuuhSLs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=cc4MZx1NyeFU/RvGqUJV56STTx1MR90SwnuDXeArGypJJIiJQC1BYLu+XHdhDaWc4
         R21aSxX20Dj9vhWhaWWjZ8730uaMtQRFr89sAzNdVHHsZ3fvklir1ur6nVmvmUHQAH
         HP+PaS4M32eu6B9eJonw9Ukui2lvCcQeHx54AiPvfK/t1w1mwEXZzC8TrA7LJt+zlV
         C6wgMOf/6H12Qt1U+YfOXhRLU5nZ29EyLun+uE/g9LZzY4nsSEz22VSlm7VNRJZQKo
         Q0koKriOUrVSa9puK27hiAmyAGby261dOYdNe3sac/psgnq0wDqSLHdjq3zNddGjgg
         GJM29RXBGgyYA==
Date:   Sun, 5 Sep 2021 10:07:45 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>
Subject: Re: [RFC PATCH net] net: dsa: tear down devlink port regions when
 tearing down the devlink port on error
Message-ID: <YTRswWukNB0zDRIc@unreal>
References: <20210902231738.1903476-1-vladimir.oltean@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210902231738.1903476-1-vladimir.oltean@nxp.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Sep 03, 2021 at 02:17:38AM +0300, Vladimir Oltean wrote:
> Commit 86f8b1c01a0a ("net: dsa: Do not make user port errors fatal")
> decided it was fine to ignore errors on certain ports that fail to
> probe, and go on with the ports that do probe fine.
> 
> Commit fb6ec87f7229 ("net: dsa: Fix type was not set for devlink port")
> noticed that devlink_port_type_eth_set(dlp, dp->slave); does not get
> called, and devlink notices after a timeout of 3700 seconds and prints a
> WARN_ON. So it went ahead to unregister the devlink port. And because
> there exists an UNUSED port flavour, we actually re-register the devlink
> port as UNUSED.
> 
> Commit 08156ba430b4 ("net: dsa: Add devlink port regions support to
> DSA") added devlink port regions, which are set up by the driver and not
> by DSA.
> 
> When we trigger the devlink port deregistration and reregistration as
> unused, devlink now prints another WARN_ON, from here:
> 
> devlink_port_unregister:
> 	WARN_ON(!list_empty(&devlink_port->region_list));
> 
> So the port still has regions, which makes sense, because they were set
> up by the driver, and the driver doesn't know we're unregistering the
> devlink port.
> 
> Somebody needs to tear them down, and optionally (actually it would be
> nice, to be consistent) set them up again for the new devlink port.
> 
> But DSA's layering stays in our way quite badly here.

I don't know anything about DSA and what led to the decision to ignore
devlink registration errors, but devlink core is relying on the simple
assumption that everything is initialized correctly.

So if DSA needs to have not-initialized port, it should do all the needed
hacks internally.

Thanks
