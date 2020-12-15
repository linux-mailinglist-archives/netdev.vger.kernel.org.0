Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BDD342DB7A5
	for <lists+netdev@lfdr.de>; Wed, 16 Dec 2020 01:09:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726908AbgLPABQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Dec 2020 19:01:16 -0500
Received: from mail.kernel.org ([198.145.29.99]:34574 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730214AbgLOX2N (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 15 Dec 2020 18:28:13 -0500
Date:   Tue, 15 Dec 2020 15:27:40 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608074863;
        bh=hQ1fGiioYfGnyGLep8OOVh14e+XNVzPqHxl7J6G0csc=;
        h=From:To:Cc:Subject:In-Reply-To:References:From;
        b=GHV4WIWb6NDel4oBMXbvu5Mb69cEE8utqUV5Y6HXU09h5CNxFwayMD0CGJpVsnKNM
         ZY8gtntBoE95pnn+JM2prId02Dd1OQR+fokQnMQ1Z7bF7l9s9mhKjFXabrGZEkIYEP
         57fwg4hb2O0p6TckbdOrHNTe6tuUPYeRdGP/sR6KR1H7IaOrPHePUJ5cfODyYHzGHc
         DfnLGQFVlNnQO+lcVMdnek0JJm7FVkiCsIxXSQZH+7BhahNFtIEwb4bAAwuZlZ354m
         Jts8mjh82aqw1DSdYSmLcQgqyArR006NwkNLaq131YFxHvbpDUuj3++PidhSGqFaOw
         UC8eXaWM9r6mg==
From:   Jakub Kicinski <kuba@kernel.org>
To:     Saeed Mahameed <saeed@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Leon Romanovsky <leonro@nvidia.com>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, David Ahern <dsahern@kernel.org>,
        Jacob Keller <jacob.e.keller@intel.com>,
        Sridhar Samudrala <sridhar.samudrala@intel.com>,
        david.m.ertman@intel.com, dan.j.williams@intel.com,
        kiran.patil@intel.com, gregkh@linuxfoundation.org,
        Parav Pandit <parav@nvidia.com>, Jiri Pirko <jiri@nvidia.com>,
        Vu Pham <vuhuong@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: Re: [net-next v5 03/15] devlink: Introduce PCI SF port flavour and
 port attribute
Message-ID: <20201215152740.0b3ed376@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201215090358.240365-4-saeed@kernel.org>
References: <20201215090358.240365-1-saeed@kernel.org>
        <20201215090358.240365-4-saeed@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 15 Dec 2020 01:03:46 -0800 Saeed Mahameed wrote:
> + *	devlink_port_attrs_pci_sf_set - Set PCI SF port attributes
> + *
> + *	@devlink_port: devlink port
> + *	@controller: associated controller number for the devlink port instance
> + *	@pf: associated PF for the devlink port instance
> + *	@sf: associated SF of a PF for the devlink port instance
> + *	@external: indicates if the port is for an external controller
> + */
> +void devlink_port_attrs_pci_sf_set(struct devlink_port *devlink_port, u32 controller,
> +				   u16 pf, u32 sf, bool external)
> +{
> +	struct devlink_port_attrs *attrs = &devlink_port->attrs;
> +	int ret;
> +
> +	if (WARN_ON(devlink_port->registered))
> +		return;
> +	ret = __devlink_port_attrs_set(devlink_port, DEVLINK_PORT_FLAVOUR_PCI_SF);
> +	if (ret)
> +		return;
> +	attrs->pci_sf.controller = controller;
> +	attrs->pci_sf.pf = pf;
> +	attrs->pci_sf.sf = sf;
> +	attrs->pci_sf.external = external;
> +}
> +EXPORT_SYMBOL_GPL(devlink_port_attrs_pci_sf_set);

So subfunctions don't have a VF id but they may have a controller?

Can you tell us more about the use cases and deployment models you're
intending to support? Let's not add attributes and info which will go
unused.

How are SFs supposed to be used with SmartNICs? Are you assuming single
domain of control? It seems that the way the industry is moving the
major use case for SmartNICs is bare metal.

I always assumed nested eswitches when thinking about SmartNICs, what
are you intending to do?

What are your plans for enabling this feature in user space project?
