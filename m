Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7BC853D25B2
	for <lists+netdev@lfdr.de>; Thu, 22 Jul 2021 16:27:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232290AbhGVNqw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Jul 2021 09:46:52 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:40506 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232231AbhGVNqv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 22 Jul 2021 09:46:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=k0+aH2yUU+cNWHexCbe+XbKTU7eC/gqAsvgBA43Tr1Q=; b=i36rq8pgsaZAyfqVGG08yTUneg
        y/1YtBBa4eyJfXco3i1ms5m07krdrNElUZPmCAHg1BE/qpt+4qhMl4G7mYWMiNpUSrU3N7aUCctC/
        iiPebCTJ7Rdx400FlZG1RgwRzHKSgUBZSET8MMHpgIBwYDROR+mCtSq4MrW3njtU9MMw=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1m6ZfW-00ELGo-Bg; Thu, 22 Jul 2021 16:27:22 +0200
Date:   Thu, 22 Jul 2021 16:27:22 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Ioana Ciornei <ciorneiioana@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        corbet@lwn.net, Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: Re: [PATCH net-next] docs: networking: dpaa2: add documentation for
 the switch driver
Message-ID: <YPmASiX46tOjUOe/@lunn.ch>
References: <20210722132735.685606-1-ciorneiioana@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210722132735.685606-1-ciorneiioana@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +At the moment, the dpaa2-switch driver imposes the following restrictions on
> +the DPSW object that it will probe:
> +
> + * The maximum number of FDBs should be at least equal to the number of switch
> +   interfaces.

Should maximum actually be minimum?

This is necessary so that separation of switch ports can be
> +   done, ie when not under a bridge, each switch port will have its own FDB.
> +
> + * Both the broadcast and flooding configuration should be per FDB. This
> +   enables the driver to restrict the broadcast and flooding domains of each
> +   FDB depending on the switch ports that are sharing it (aka are under the
> +   same bridge).
> +
> + * The control interface of the switch should not be disabled
> +   (DPSW_OPT_CTRL_IF_DIS not passed as a create time option). Without the
> +   control interface, the driver is not capable to provide proper Rx/Tx traffic
> +   support on the switch port netdevices.
> +
> +Besides the configuration of the actual DPSW object, the dpaa2-switch driver
> +will need the following DPAA2 objects:
> +
> + * 1 DPMCP - A Management Command Portal object is needed for any interraction
> +   with the MC firmware.
> +
> + * 1 DPBP - A Buffer Pool is used for seeding buffers intended for the Rx path
> +   on the control interface.
> +
> + * Access to at least one DPIO object (Software Portal) is needed for any
> +   enqueue/dequeue operation to be performed on the control interface queues.
> +   The DPIO object will be shared, no need for a private one.

Are these requirements tested? Will the driver fail probe if they are
not met?

> +Routing actions (redirect, trap, drop)
> +--------------------------------------
> +
> +The DPAA2 switch is able to offload flow-based redirection of packets making
> +use of ACL tables. Shared filter blocks are supported by sharing a single ACL
> +table between multiple ports.
> +
> +The following flow keys are supported:
> +
> + * Ethernet: dst_mac/src_mac
> + * IPv4: dst_ip/src_ip/ip_proto/tos
> + * VLAN: vlan_id/vlan_prio/vlan_tpid/vlan_dei
> + * L4: dst_port/src_port
> +
> +Also, the matchall filter can be used to redirect the entire traffic received
> +on a port.
> +
> +As per flow actions, the following are supported:
> +
> + * drop
> + * mirred egress redirect
> + * trap
> +
> +Each ACL entry (filter) can be setup with only one of the listed
> +actions.
> +
> +A sorted single linked list is used to keep the ACL entries by their
> +order of priority. When adding a new filter, this enables us to quickly
> +ascertain if the new entry has the highest priority of the entire block
> +or if we should make some space in the ACL table by increasing the
> +priority of the filters already in the table.

It would be nice to have an example which shows priority in action,
since i don't understand what you are saying here.

      Andrew
