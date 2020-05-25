Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 17E9C1E0B49
	for <lists+netdev@lfdr.de>; Mon, 25 May 2020 12:03:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389433AbgEYKD0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 May 2020 06:03:26 -0400
Received: from mx2.suse.de ([195.135.220.15]:38038 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389302AbgEYKD0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 25 May 2020 06:03:26 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id AC81CB1FE;
        Mon, 25 May 2020 10:03:26 +0000 (UTC)
Received: by lion.mk-sys.cz (Postfix, from userid 1000)
        id 024BF6032A; Mon, 25 May 2020 12:03:22 +0200 (CEST)
Date:   Mon, 25 May 2020 12:03:22 +0200
From:   Michal Kubecek <mkubecek@suse.cz>
To:     netdev@vger.kernel.org
Cc:     Horatiu Vultur <horatiu.vultur@microchip.com>,
        nikolay@cumulusnetworks.com, roopa@cumulusnetworks.com,
        davem@davemloft.net, kuba@kernel.org, andrew@lunn.ch,
        UNGLinuxDriver@microchip.com, bridge@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org
Subject: Re: MRP netlink interface
Message-ID: <20200525100322.sjlfxhz2ztrfjia7@lion.mk-sys.cz>
References: <20200525112827.t4nf4lamz6g4g2c5@soft-dev3.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200525112827.t4nf4lamz6g4g2c5@soft-dev3.localdomain>
User-Agent: NeoMutt/20180716
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 25, 2020 at 11:28:27AM +0000, Horatiu Vultur wrote:
[...]
> My first approach was to extend the 'struct br_mrp_instance' with a field that
> contains the priority of the node. But this breaks the backwards compatibility,
> and then every time when I need to change something, I will break the backwards
> compatibility. Is this a way to go forward?

No, I would rather say it's an example showing why passing data
structures as binary data via netlink is a bad idea. I definitely
wouldn't advice this approach for any new interface. One of the
strengths of netlink is the ability to use structured and extensible
messages.

> Another approach is to restructure MRP netlink interface. What I was thinking to
> keep the current attributes (IFLA_BRIDGE_MRP_INSTANCE,
> IFLA_BRIDGE_MRP_PORT_STATE,...) but they will be nested attributes and each of
> this attribute to contain the fields of the structures they represents.
> For example:
> [IFLA_AF_SPEC] = {
>     [IFLA_BRIDGE_FLAGS]
>     [IFLA_BRIDGE_MRP]
>         [IFLA_BRIDGE_MRP_INSTANCE]
>             [IFLA_BRIDGE_MRP_INSTANCE_RING_ID]
>             [IFLA_BRIDGE_MRP_INSTANCE_P_IFINDEX]
>             [IFLA_BRIDGE_MRP_INSTANCE_S_IFINDEX]
>         [IFLA_BRIDGE_MRP_RING_ROLE]
>             [IFLA_BRIDGE_MRP_RING_ROLE_RING_ID]
>             [IFLA_BRIDGE_MRP_RING_ROLE_ROLE]
>         ...
> }
> And then I can parse each field separately and then fill up the structure
> (br_mrp_instance, br_mrp_port_role, ...) which will be used forward.
> Then when this needs to be extended with the priority it would have the
> following format:
> [IFLA_AF_SPEC] = {
>     [IFLA_BRIDGE_FLAGS]
>     [IFLA_BRIDGE_MRP]
>         [IFLA_BRIDGE_MRP_INSTANCE]
>             [IFLA_BRIDGE_MRP_INSTANCE_RING_ID]
>             [IFLA_BRIDGE_MRP_INSTANCE_P_IFINDEX]
>             [IFLA_BRIDGE_MRP_INSTANCE_S_IFINDEX]
>             [IFLA_BRIDGE_MRP_INSTANCE_PRIO]
>         [IFLA_BRIDGE_MRP_RING_ROLE]
>             [IFLA_BRIDGE_MRP_RING_ROLE_RING_ID]
>             [IFLA_BRIDGE_MRP_RING_ROLE_ROLE]
>         ...
> }
> And also the br_mrp_instance will have a field called prio.
> So now, if the userspace is not updated to have support for setting the prio
> then the kernel will use a default value. Then if the userspace contains a field
> that the kernel doesn't know about, then it would just ignore it.
> So in this way every time when the netlink interface will be extended it would
> be backwards compatible.

Silently ignoring unrecognized attributes in userspace requests is what
most kernel netlink based interfaces have been doing traditionally but
it's not really a good idea. Essentially it ties your hands so that you
can only add new attributes which can be silently ignored without doing
any harm, otherwise you risk that kernel will do something different
than userspace asked and userspace does not even have a way to find out
if the feature is supported or not. (IIRC there are even some places
where ignoring an attribute changes the nature of the request but it is
still ignored by older kernels.)

That's why there have been an effort, mostly by Johannes Berg, to
introduce and promote strict checking for new netlink interfaces and new
attributes in existing netlink attributes. If you don't have strict
checking for unknown attributes enabled yet, there isn't much that can
be done for already released kernels but I would suggest to enable it as
soon as possible.

Michal
