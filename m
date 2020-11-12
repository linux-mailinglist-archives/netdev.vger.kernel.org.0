Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B05382AFCF2
	for <lists+netdev@lfdr.de>; Thu, 12 Nov 2020 02:49:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728537AbgKLBdD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Nov 2020 20:33:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:52668 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728230AbgKLBUx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 11 Nov 2020 20:20:53 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AC8EF2067D;
        Thu, 12 Nov 2020 01:20:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605144053;
        bh=v4j9p/0k0IFTaSBpoIf/jFq9p4FIJh/mKbogTIAb/dE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=VLq8ZgQME1kDJnBnWvRGS6iGzENq0/m7szV8AvmxQdRtRlfcU79OZGl514FLsgThW
         ejgdz2foPnBKkHWvCYh9s/0kRG9di040BI2odlK0vNn+Oo89HgtjTPVdHlyEUQppi1
         T1qdPj0JHCXxdCMkXN9Ip4m60a9T1GF+LD6Xz7Js=
Date:   Wed, 11 Nov 2020 17:20:51 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Joel Stanley <joel@jms.id.au>
Cc:     Samuel Mendoza-Jonas <sam@mendozajonas.com>,
        "David S . Miller" <davem@davemloft.net>,
        Andrew Jeffery <andrew@aj.id.au>,
        Networking <netdev@vger.kernel.org>
Subject: Re: [PATCH] net/ncsi: Fix re-registering ncsi device
Message-ID: <20201111172051.28e70e7b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <CACPK8Xd3MfTbp2184e6Hp7D4U40ku0vqw=pb5E7mamddMGnj3A@mail.gmail.com>
References: <20201112004021.834673-1-joel@jms.id.au>
        <20201111165716.760829aa@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <CACPK8Xd3MfTbp2184e6Hp7D4U40ku0vqw=pb5E7mamddMGnj3A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 12 Nov 2020 01:11:04 +0000 Joel Stanley wrote:
> On Thu, 12 Nov 2020 at 00:57, Jakub Kicinski <kuba@kernel.org> wrote:
> >
> > On Thu, 12 Nov 2020 11:10:21 +1030 Joel Stanley wrote:  
> > > If a user unbinds and re-binds a ncsi aware driver, the kernel will
> > > attempt to register the netlink interface at runtime. The structure is
> > > marked __ro_after_init so this fails at this point.  
> >
> > netlink family should be registered at module init and unregistered at
> > unload. That's a better fix IMO.  
> 
> I don't follow, isn't that what is implemented already?
> 
> Perhaps I'm getting confused because the systems that use this code
> build the drivers in. The bug I'm seeing is when we unbind and re-bind
> the driver without any module loading or unloading.

It's registered from ncsi_register_dev(), which is obviously broken,
because there is only one family so it would never work if there was
more than one ncsi netdev.

Looks like NCSI can only be built in, so instead of module init it
should be a subsys_initcall().

Basically remove ncsi_unregister_netlink(), remove the dev parameter
from ncsi_init_netlink() and add:

subsys_initcall(ncsi_init_netlink);

at the end of ncsi-netlink.c
