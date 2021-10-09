Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F9B042749A
	for <lists+netdev@lfdr.de>; Sat,  9 Oct 2021 02:18:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243995AbhJIATy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Oct 2021 20:19:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:38784 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243958AbhJIATy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 8 Oct 2021 20:19:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2B5BA60FC2;
        Sat,  9 Oct 2021 00:17:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633738678;
        bh=BU1Nl5chIErbEOxs41MmYcV86/XBmu41VIDvCZu3oTs=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=e5Kjmm/IxU4/PE2771j3JbYc0BnbTHb6oPapm4wdQlAs2PXUBzt/BBUjYDS1lgXk5
         SruD3Cw48s6WBpR3fyyWIAfZWTscQ8MbE0SDQ0Svkr72ri6eGDHyGMcUuXKP9CF2/V
         FujWuRdomOSMLqfAIbBnMgvQjfVCI3EbhBD75wWu29LKrH/LOhBPOs0jaG9SC8H9zH
         3PnC7GIx3Ept13O0WYU8vxpIdu4ewXsKbG6weKg4Qg0klzBE5y+acuNgsqYgMm9h4H
         vXFFCzN198D5VDXeth0MbYIC76endVuFdNptIwx0yvF8mokSAXHFiByS0B6VpL0uqW
         ZMv49AxMTK2Vg==
Date:   Fri, 8 Oct 2021 17:17:57 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     "Keller, Jacob E" <jacob.e.keller@intel.com>
Cc:     Jiri Pirko <jiri@resnulli.us>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [net-next 0/4] devlink: add dry run support for flash update
Message-ID: <20211008171757.471966c1@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <CO1PR11MB5089A8DC692F9FCB87530639D6B29@CO1PR11MB5089.namprd11.prod.outlook.com>
References: <20211008104115.1327240-1-jacob.e.keller@intel.com>
        <YWA7keYHnhlHCkKT@nanopsycho>
        <20211008112159.4448a6c1@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <CO1PR11MB5089797DA5BA3D7EACE5DE8FD6B29@CO1PR11MB5089.namprd11.prod.outlook.com>
        <20211008153536.65b04fc9@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <CO1PR11MB5089A8DC692F9FCB87530639D6B29@CO1PR11MB5089.namprd11.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 8 Oct 2021 23:58:45 +0000 Keller, Jacob E wrote:
> > > Doesn't the policy checks prevent any unknown attributes?
> > > Or are unknown attributes silently ignored?  
> > 
> > Did you test it?
> > 
> > DEVLINK_CMD_FLASH_UPDATE has GENL_DONT_VALIDATE_STRICT set.  
> 
> Hmm. I did run into an issue while initially testing where
> DEVLINK_ATTR_DRY_RUN wasn't in the devlink_nla_policy table and it
> rejected the command with an unknown attribute. I had to add the
> attribute to the policy table to fix this.
> 
> I'm double checking on a different kernel now with the new userspace
> to see if I get the same behavior.

Weird.
 
> I'm not super familiar with the validation code or what
> GENL_DONT_VALIDATE_STRICT means...
> 
> Indeed.. I just did a search for GENL_DONT_VALIDATE_STRICT and the
> only uses I can find are ones which *set* the flag. Nothing ever
> checks it!!
> 
> I suspect it got removed at some point.. still digging into exact
> history though...


 It's passed by genl_family_rcv_msg_doit() to
genl_family_rcv_msg_attrs_parse() where it chooses the netlink policy.
