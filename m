Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8323B633179
	for <lists+netdev@lfdr.de>; Tue, 22 Nov 2022 01:41:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231313AbiKVAlB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Nov 2022 19:41:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230242AbiKVAk7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Nov 2022 19:40:59 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F1481583F
        for <netdev@vger.kernel.org>; Mon, 21 Nov 2022 16:40:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=LH3FIjU4ugtDO+a5e5fvSmHur//3OvRXxjCVQjiWCt8=; b=1n564vQrAbj/E/1DTd6oak4qjJ
        eF9mmqnTn7Z7AQ1m1bjBgXAc+HkDzHzZKmya4QMUHlUO73WHkxzQG0WOw9H8ND7qTpcbHibQcJhb+
        Scx64pmqVphoBQn69PpHBWnRByXcAUPUGIN3yofwnCkxfeuCOimRL/1Ppv4e4kzHwgao=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1oxHLK-0034EE-4q; Tue, 22 Nov 2022 01:40:54 +0100
Date:   Tue, 22 Nov 2022 01:40:54 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Steve Williams <steve.williams@getcruise.com>
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH net-next] net/hanic: Add the hanic network interface for
 high availability links
Message-ID: <Y3wallEfG+ygdwvu@lunn.ch>
References: <20221118232639.13743-1-steve.williams@getcruise.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221118232639.13743-1-steve.williams@getcruise.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +Output R-TAG filter
> +===================
> +
> +In a realistic system, some destinations do not support 802.1cb,
> +or don't need it. The hanic driver has a means to call out these
> +destinations by vlan or by mac and vlan together. For example, if
> +all the destinations on vlan=11 (0x000b) should not receive r-TAG'ed
> +packets, then that can be arranged like so::
> +
> +  $ echo 000b: prime > /sys/class/net/\<nic\>/hanic/filters_vlan

Please use netlink for all configuration, not sysfs.

> +Creating interfaces
> +===================
> +
> +The way to create interfaces is with a command like this::
> +
> +  $ echo +hanic0 > /sys/class/net/hanic_interfaces

ip link add hanic0 type hanic

> +
> +It is also possible to destroy interfaces thusly::
> +
> +  $ echo -hanic0 > /sys/class/net/hanic_interfaces

ip link del handic0

> +The standard IP commands can be used to do the enlistment, like so::
> +
> +  $ ip link set sandlan0a master hanic0
> +  $ ip link set sandlan0b master hanic0

It is not clear if sandland is going to get merged, so you probably
should just use eth0 and eth1 in the examples.

> +* /sys/class/net/\<nic\>/hanic/test_drop_packet_in
> +
> +Inject faults by dropping input packets from some port. Write to this
> +file the port number and the number of packets to drop. For example,
> +to tell port 1 to drop the next 5 input packets::

The normal way to do this is TC. Please don't reinvent what the kernel
already has.

Probably nobody will look at the code in too much detail until your
get your uAPI accepted. uAPI is nearly impossible to change once it is
merged, so it is important to get correct. So please throw away all
your sysfs code and replace it with netlink.

     Andrew
