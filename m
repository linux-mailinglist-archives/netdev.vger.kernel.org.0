Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D4C42427565
	for <lists+netdev@lfdr.de>; Sat,  9 Oct 2021 03:29:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244063AbhJIBbh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Oct 2021 21:31:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:53088 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244066AbhJIBbf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 8 Oct 2021 21:31:35 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7A4E960F9C;
        Sat,  9 Oct 2021 01:29:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633742979;
        bh=m6xrguudo5KfbpN5p+3kyDIdgG+YtVQyVsUMNQrkcAo=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=WfyULsDf3Yx+UbsN0p+OIzDix8RO2ibAkehIHDnG2myhCDGW7sL80v3zaurBjBawB
         zwUwQLlmY8qmDX8lMUqhkKRb+ejNBEGck75uyUUZxGb/GlbMMvEC4eTvlvXT64YidL
         JHLaMJjEUNcHbmTM8hyje3UF53HpzX6fB8fkJkdM9XCSe/wWJ7ytn9dn/cO2i7JPrb
         T4/is3bGpohLtYaxsreGAQ9azgNUr5HrFKzTdGLAnqbXAbvh1b4gQfoAHBAfaJebgZ
         CTcfk3SjmYvmNrvpFq+FZ+Vj7tPkAO6jw5tGMptqMkxAaF5W/06FFXbDRr6ypRO21U
         ylxdmHjvP0xtg==
Date:   Fri, 8 Oct 2021 18:29:38 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     "Keller, Jacob E" <jacob.e.keller@intel.com>
Cc:     Jiri Pirko <jiri@resnulli.us>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [net-next 0/4] devlink: add dry run support for flash update
Message-ID: <20211008182938.0dea0600@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <CO1PR11MB50899080E3A33882F9630C98D6B39@CO1PR11MB5089.namprd11.prod.outlook.com>
References: <20211008104115.1327240-1-jacob.e.keller@intel.com>
        <YWA7keYHnhlHCkKT@nanopsycho>
        <20211008112159.4448a6c1@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <CO1PR11MB5089797DA5BA3D7EACE5DE8FD6B29@CO1PR11MB5089.namprd11.prod.outlook.com>
        <20211008153536.65b04fc9@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <CO1PR11MB5089A8DC692F9FCB87530639D6B29@CO1PR11MB5089.namprd11.prod.outlook.com>
        <20211008171757.471966c1@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <CO1PR11MB50899080E3A33882F9630C98D6B39@CO1PR11MB5089.namprd11.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 9 Oct 2021 00:32:49 +0000 Keller, Jacob E wrote:
> Ah.. I see how its done. It's passed as the argument so you  don't
> see a direct comparison which makes it look like there isn't one...
> Feels like there could probably be a better abstraction that was more
> readable here...
> 
> Anyways. I'll confirm what happens on the kernel that doesn't have
> the attribute defined at all.
> 
> I wonder if the thing I saw differently was because the attribute
> *was* known but wasn't in policy. I.e. because it was defined it was
> validated....
> 
> Yep, I confirm that on a kernel without the DRY_RUN flag that it
> would allow the run because we aren't being strict.
> 
> I am guessing that we can't convert devlink over to strict validation?

I think the current best practice is not to opt-in commands which
started out as non-strict into strict validation. That said opting 
it in for MAXTYPE validation seems reasonable to me.

Alternatively, as I said, you can just check the max attr for the
family in user space. CTRL_CMD_GETFAMILY returns it as part of family
info (CTRL_ATTR_MAXATTR). We can make user space do the rejecting.
