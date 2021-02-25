Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8AE98324885
	for <lists+netdev@lfdr.de>; Thu, 25 Feb 2021 02:28:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234613AbhBYB1n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Feb 2021 20:27:43 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:56846 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233814AbhBYB1n (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 24 Feb 2021 20:27:43 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1lF5Qj-008KZ1-0O; Thu, 25 Feb 2021 02:27:01 +0100
Date:   Thu, 25 Feb 2021 02:27:00 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     netdev@vger.kernel.org, Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ido Schimmel <idosch@idosch.org>,
        DENG Qingfang <dqfext@gmail.com>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        George McCollister <george.mccollister@gmail.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        Kurt Kanzenbach <kurt@linutronix.de>
Subject: Re: [RFC PATCH net-next 08/12] Documentation: networking: dsa: add
 paragraph for the LAG offload
Message-ID: <YDb85NfrHh62RqgG@lunn.ch>
References: <20210221213355.1241450-1-olteanv@gmail.com>
 <20210221213355.1241450-9-olteanv@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210221213355.1241450-9-olteanv@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Feb 21, 2021 at 11:33:51PM +0200, Vladimir Oltean wrote:
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> Add a short summary of the methods that a driver writer must implement
> for offloading a link aggregation group, and what is still missing.
> 
> Cc: Tobias Waldekranz <tobias@waldekranz.com>
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> ---
>  Documentation/networking/dsa/dsa.rst | 32 ++++++++++++++++++++++++++++
>  1 file changed, 32 insertions(+)
> 
> diff --git a/Documentation/networking/dsa/dsa.rst b/Documentation/networking/dsa/dsa.rst
> index 463b48714fe9..0a5b06cf4d45 100644
> --- a/Documentation/networking/dsa/dsa.rst
> +++ b/Documentation/networking/dsa/dsa.rst
> @@ -698,6 +698,38 @@ Bridge VLAN filtering
>    function that the driver has to call for each MAC address known to be behind
>    the given port. A switchdev object is used to carry the VID and MDB info.
>  
> +Link aggregation
> +----------------
> +
> +Link aggregation is implemented in the Linux networking stack by the bonding
> +and team drivers, which are modeled as virtual, stackable network interfaces.
> +DSA is capable of offloading a link aggregation group (LAG) to hardware that
> +supports the feature, and supports bridging between physical ports and LAGs,
> +as well as between LAGs. A bonding/team interface which holds multiple physical
> +ports constitutes a logical port, although DSA has no explicit concept of a
> +physical port at the moment.

Hi Vladimir

I don't understand what you mean by a physical port in this context.

Due to this, events where a LAG joins/leaves a
> +bridge are treated as if all individual physical ports that are members of that
> +LAG join/leave the bridge. Switchdev port attributes (VLAN filtering, STP
> +state, etc) on a LAG are treated similarly: DSA offloads the same switchdev
> +port attribute on all members of the LAG. Switchdev objects on a LAG (FDB, MDB)
> +are not yet supported, since the DSA driver API does not have the concept of a
> +logical port ID.
> +
> +- ``port_lag_join``: function invoked when a given switch port is added to a
> +  LAG. The driver may return ``-EOPNOTSUPP``, and in this case, DSA will fall
> +  back to a software implementation where all traffic from this port is sent to
> +  the CPU.
> +- ``port_lag_leave``: function invoked when a given switch port leaves a LAG
> +  and returns to operation as a standalone port.
> +- ``port_lag_change``: function invoked when the link state of any member of
> +  the LAG changes, and the hashing function needs rebalancing only towards the
> +  subset of physical LAG member ports that are up.

"and the hashing function needs rebalancing to only make use of the
subset of physical LAG member ports that are up."

       Andrew
