Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E6F332DB809
	for <lists+netdev@lfdr.de>; Wed, 16 Dec 2020 01:58:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726190AbgLPA6m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Dec 2020 19:58:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:49782 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725869AbgLPA6k (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 15 Dec 2020 19:58:40 -0500
Date:   Tue, 15 Dec 2020 16:57:58 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608080279;
        bh=yx832H/XjCKHlXnPlAl5Tx/CbmPBGdiZ3w0hWU2l/DM=;
        h=From:To:Cc:Subject:In-Reply-To:References:From;
        b=QFsk+aIzc1xibj1EMATSReJT9x26YzzxPhWL+vRSD76bJoobbL6PKhWX+/FLuTknT
         ow7SYsxuXQ89FzQfAOI+d7cJhYvaerF4O29+/0RNfoMFpDYpZL39V6Is2XqJQDoWel
         jfw8/pDSdxw/w3n7WicI5+81vnMKUjtcJfN6tporfXkSxieMPtEoYX9V2rtvv38jt7
         f+zMYzY+l7jw0yEZyLyZ3rT92LasK5YQ7zi/yvlMWepLkKhoHMdGQ6ImfiWMxqf0cv
         O4Vr0ODcg2y9YIUp1akRyB/YyoRqULmQNZBMi+gqe+W5+//Icw2mzzgu9GG8DkiQnr
         QBgXNDhrBFfwA==
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
        Saeed Mahameed <saeedm@nvidia.com>
Subject: Re: [net-next v5 13/15] devlink: Add devlink port documentation
Message-ID: <20201215165758.4ff58f85@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201215090358.240365-14-saeed@kernel.org>
References: <20201215090358.240365-1-saeed@kernel.org>
        <20201215090358.240365-14-saeed@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 15 Dec 2020 01:03:56 -0800 Saeed Mahameed wrote:
> +PCI controllers
> +---------------
> +In most cases a PCI device has only one controller. A controller consists of
> +potentially multiple physical and virtual functions. Such PCI function consists
> +of one or more ports.

s/Such//

you say consists in two consecutive sentences.

> This port of the function is represented by the devlink eswitch port.

"This port of the function"? Why not just "Each port"?

> +A PCI Device connected to multiple CPUs or multiple PCI root complexes or

Why is device capitalized all of the sudden?

> +SmartNIC, however, may have multiple controllers. For a device with multiple

a SmartNIC or SmartNICs

> +controllers, each controller is distinguished by a unique controller number.
> +An eswitch on the PCI device support ports of multiple controllers.

eswitch is on a PCI device?

> +An example view of a system with two controllers::
> +
> +                 ---------------------------------------------------------
> +                 |                                                       |
> +                 |           --------- ---------         ------- ------- |
> +    -----------  |           | vf(s) | | sf(s) |         |vf(s)| |sf(s)| |
> +    | server  |  | -------   ----/---- ---/----- ------- ---/--- ---/--- |
> +    | pci rc  |=== | pf0 |______/________/       | pf1 |___/_______/     |
> +    | connect |  | -------                       -------                 |
> +    -----------  |     | controller_num=1 (no eswitch)                   |
> +                 ------|--------------------------------------------------
> +                 (internal wire)
> +                       |
> +                 ---------------------------------------------------------
> +                 | devlink eswitch ports and reps                        |
> +                 | ----------------------------------------------------- |
> +                 | |ctrl-0 | ctrl-0 | ctrl-0 | ctrl-0 | ctrl-0 |ctrl-0 | |
> +                 | |pf0    | pf0vfN | pf0sfN | pf1    | pf1vfN |pf1sfN | |
> +                 | ----------------------------------------------------- |
> +                 | |ctrl-1 | ctrl-1 | ctrl-1 | ctrl-1 | ctrl-1 |ctrl-1 | |
> +                 | |pf0    | pf0vfN | pf0sfN | pf1    | pf1vfN |pf1sfN | |
> +                 | ----------------------------------------------------- |
> +                 |                                                       |
> +                 |                                                       |
> +    -----------  |           --------- ---------         ------- ------- |
> +    | smartNIC|  |           | vf(s) | | sf(s) |         |vf(s)| |sf(s)| |
> +    | pci rc  |==| -------   ----/---- ---/----- ------- ---/--- ---/--- |
> +    | connect |  | | pf0 |______/________/       | pf1 |___/_______/     |
> +    -----------  | -------                       -------                 |
> +                 |                                                       |
> +                 |  local controller_num=0 (eswitch)                     |
> +                 ---------------------------------------------------------
> +
> +In above example, external controller (identified by controller number = 1)
> +doesn't have eswitch. Local controller (identified by controller number = 0)
> +has the eswitch. Devlink instance on local controller has eswitch devlink
> +ports representing ports for both the controllers.
> +
> +Port function configuration
> +===========================
> +
> +A user can configure the port function attribute before enumerating the

s/A user/User/

/port function attribute/$something_meaningful/

> +PCI function. Usually it means, user should configure port function attribute

attributes, plural

> +before a bus specific device for the function is created. However, when
> +SRIOV is enabled, virtual function devices are created on the PCI bus.
> +Hence, function attribute should be configured before binding virtual
> +function device to the driver.
> +
> +User may set the hardware address of the function represented by the devlink
> +port function. For Ethernet port function this means a MAC address.

