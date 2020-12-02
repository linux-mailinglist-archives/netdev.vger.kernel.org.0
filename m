Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B0692CB260
	for <lists+netdev@lfdr.de>; Wed,  2 Dec 2020 02:35:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727660AbgLBBfY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Dec 2020 20:35:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:44036 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726812AbgLBBfX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 1 Dec 2020 20:35:23 -0500
Date:   Tue, 1 Dec 2020 17:34:41 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1606872882;
        bh=npzelDe+uJksIT4FYnid/IQ2tvp/OjzhLx6X7WJwIhw=;
        h=From:To:Cc:Subject:In-Reply-To:References:From;
        b=lIJzV/M8U8V0txwg4WlTL8nlgNOpk4724lVSiHp20ekondzVpVUqUzdJZSXBnGG01
         vGw/7IUPKl8jNZuWXJvmNppOnpMgqaTsVQI4CN7F//eORtAO19gFMeaDlmjNFJWEWd
         FBUPx5yWBBsfqZ/gUEjZItKQafjeV3r1Oy0ohypc=
From:   Jakub Kicinski <kuba@kernel.org>
To:     Parav Pandit <parav@nvidia.com>
Cc:     <netdev@vger.kernel.org>, <davem@davemloft.net>,
        <jacob.e.keller@intel.com>, Jiri Pirko <jiri@nvidia.com>
Subject: Re: [PATCH net-next v2] devlink: Add devlink port documentation
Message-ID: <20201201173441.229a94c7@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
In-Reply-To: <20201130200025.573239-1-parav@nvidia.com>
References: <20201130164119.571362-1-parav@nvidia.com>
        <20201130200025.573239-1-parav@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 30 Nov 2020 22:00:25 +0200 Parav Pandit wrote:
> Added documentation for devlink port and port function related commands.
> 
> Signed-off-by: Parav Pandit <parav@nvidia.com>
> Reviewed-by: Jiri Pirko <jiri@nvidia.com>

> +============
> +Devlink Port
> +============
> +
> +``devlink-port`` provides capability for a driver to expose various
> +flavours of ports which exist on device. A devlink port can be of an
> +embedded switch (eswitch) present on the device.

The wording is a little awkward here.

The first paragraph should clarify what object represents.

This just says it exposes ports that exist.

A better phrasing would be to say that these are ports of an eswitch,
in trivial case the only ports will be the physical ports of the card.

> +A devlink port can be of 3 diffferent types.

"can be of" repeated from the previous line

> +.. list-table:: List of devlink port types
> +   :widths: 23 90
> +
> +   * - Type
> +     - Description
> +   * - ``DEVLINK_PORT_TYPE_ETH``
> +     - This type is set for a devlink port when a physical link layer of the port

Is "physical link layer" a thing? I the common names are physical layer
and a (data) link layer. I don't think I've seen physical link layer,
or would know what it is...

> +       is Ethernet.
> +   * - ``DEVLINK_PORT_TYPE_IB``
> +     - This type is set for a devlink port when a physical link layer of the port
> +       is InfiniBand.
> +   * - ``DEVLINK_PORT_TYPE_AUTO``
> +     - This type is indicated by the user when user prefers to set the port type
> +       to be automatically detected by the device driver.

IMO type should be after flavor. Flavor is a higher level attribute,
only physical ports have a type.

> +Devlink port can be of few different flavours described below.
> +
> +.. list-table:: List of devlink port flavours
> +   :widths: 33 90
> +
> +   * - Flavour
> +     - Description
> +   * - ``DEVLINK_PORT_FLAVOUR_PHYSICAL``
> +     - Any kind of port which is physically facing the user. This can be

Hm. Not a great phrasing :(

It faces a physical networking layer. To me PCIe faces the user.

> +       a eswitch physical port or any other physical port on the device.
> +   * - ``DEVLINK_PORT_FLAVOUR_CPU``
> +     - This indicates a CPU port.

You need to mention this is a DSA-only thing.

> +   * - ``DEVLINK_PORT_FLAVOUR_DSA``
> +     - This indicates a interconnect port in a distributed switch architecture.

(DSA)

> +   * - ``DEVLINK_PORT_FLAVOUR_PCI_PF``
> +     - This indicates an eswitch port representing PCI physical function(PF).
> +   * - ``DEVLINK_PORT_FLAVOUR_PCI_VF``
> +     - This indicates an eswitch port representing PCI virtual function(VF).
> +   * - ``DEVLINK_PORT_FLAVOUR_VIRTUAL``
> +     - This indicates a virtual port facing the user.

No idea what that means from the description. 

> +A devlink port may be for a controller consisting one or more PCI device(s).

Port can have multiple PCI devices?

> +A devlink instance holds ports of two types of controllers.
> +
> +(1) controller discovered on same system where eswitch resides
> +This is the case where PCI PF/VF of a controller and devlink eswitch
> +instance both are located on a single system.
> +
> +(2) controller located on external host system.
> +This is the case where a controller is located in one system and its
> +devlink eswitch ports are located in a different system.
> +
> +An example view of two controller systems::
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
> +                 |           --------- ---------         ------- ------- |
> +                 |           | vf(s) | | sf(s) |         |vf(s)| |sf(s)| |
> +                 | -------   ----/---- ---/----- ------- ---/--- ---/--- |
> +                 | | pf0 |______/________/       | pf1 |___/_______/     |
> +                 | -------                       -------                 |
> +                 |                                                       |
> +                 |  local controller_num=0 (eswitch)                     |
> +                 ---------------------------------------------------------
> +
> +Port function configuration
> +===========================
> +
> +When a port flavor is ``DEVLINK_PORT_FLAVOUR_PCI_PF`` or
> +``DEVLINK_PORT_FLAVOUR_PCI_VF``, it represents the port of a PCI function.
> +A user can configure the port function attributes before enumerating the
> +function. For example user may set the hardware address of the function
> +represented by the devlink port.
> diff --git a/Documentation/networking/devlink/index.rst b/Documentation/networking/devlink/index.rst
> index d82874760ae2..aab79667f97b 100644
> --- a/Documentation/networking/devlink/index.rst
> +++ b/Documentation/networking/devlink/index.rst
> @@ -18,6 +18,7 @@ general.
>     devlink-info
>     devlink-flash
>     devlink-params
> +   devlink-port
>     devlink-region
>     devlink-resource
>     devlink-reload

