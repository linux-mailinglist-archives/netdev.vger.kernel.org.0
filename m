Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F23C122B93E
	for <lists+netdev@lfdr.de>; Fri, 24 Jul 2020 00:15:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726952AbgGWWPi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jul 2020 18:15:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726436AbgGWWPi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jul 2020 18:15:38 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7356C0619D3
        for <netdev@vger.kernel.org>; Thu, 23 Jul 2020 15:15:38 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id BB5FE11E48C62;
        Thu, 23 Jul 2020 14:58:52 -0700 (PDT)
Date:   Thu, 23 Jul 2020 15:15:36 -0700 (PDT)
Message-Id: <20200723.151536.1140890514201934018.davem@davemloft.net>
To:     olteanv@gmail.com
Cc:     kuba@kernel.org, netdev@vger.kernel.org, andrew@lunn.ch,
        f.fainelli@gmail.com, vivien.didelot@gmail.com, jiri@mellanox.com,
        edumazet@google.com, ap420073@gmail.com, xiyou.wangcong@gmail.com,
        maximmi@mellanox.com, mkubecek@suse.cz, richardcochran@gmail.com
Subject: Re: [PATCH net-next] net: dsa: stop overriding master's
 ndo_get_phys_port_name
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200722224312.2719813-1-olteanv@gmail.com>
References: <20200722224312.2719813-1-olteanv@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 23 Jul 2020 14:58:53 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <olteanv@gmail.com>
Date: Thu, 23 Jul 2020 01:43:12 +0300

> The purpose of this override is to give the user an indication of what
> the number of the CPU port is (in DSA, the CPU port is a hardware
> implementation detail and not a network interface capable of traffic).
> 
> However, it has always failed (by design) at providing this information
> to the user in a reliable fashion.
> 
> Prior to commit 3369afba1e46 ("net: Call into DSA netdevice_ops
> wrappers"), the behavior was to only override this callback if it was
> not provided by the DSA master.
> 
> That was its first failure: if the DSA master itself was a DSA port or a
> switchdev, then the user would not see the number of the CPU port in
> /sys/class/net/eth0/phys_port_name, but the number of the DSA master
> port within its respective physical switch.
> 
> But that was actually ok in a way. The commit mentioned above changed
> that behavior, and now overrides the master's ndo_get_phys_port_name
> unconditionally. That comes with problems of its own, which are worse in
> a way.
> 
> The idea is that it's typical for switchdev users to have udev rules for
> consistent interface naming. These are based, among other things, on
> the phys_port_name attribute. If we let the DSA switch at the bottom
> to start randomly overriding ndo_get_phys_port_name with its own CPU
> port, we basically lose any predictability in interface naming, or even
> uniqueness, for that matter.
> 
> So, there are reasons to let DSA override the master's callback (to
> provide a consistent interface, a number which has a clear meaning and
> must not be interpreted according to context), and there are reasons to
> not let DSA override it (it breaks udev matching for the DSA master).
> 
> But, there is an alternative method for users to retrieve the number of
> the CPU port of each DSA switch in the system:
> 
>   $ devlink port
>   pci/0000:00:00.5/0: type eth netdev swp0 flavour physical port 0
>   pci/0000:00:00.5/2: type eth netdev swp2 flavour physical port 2
>   pci/0000:00:00.5/4: type notset flavour cpu port 4
>   spi/spi2.0/0: type eth netdev sw0p0 flavour physical port 0
>   spi/spi2.0/1: type eth netdev sw0p1 flavour physical port 1
>   spi/spi2.0/2: type eth netdev sw0p2 flavour physical port 2
>   spi/spi2.0/4: type notset flavour cpu port 4
>   spi/spi2.1/0: type eth netdev sw1p0 flavour physical port 0
>   spi/spi2.1/1: type eth netdev sw1p1 flavour physical port 1
>   spi/spi2.1/2: type eth netdev sw1p2 flavour physical port 2
>   spi/spi2.1/3: type eth netdev sw1p3 flavour physical port 3
>   spi/spi2.1/4: type notset flavour cpu port 4
> 
> So remove this duplicated, unreliable and troublesome method. From this
> patch on, the phys_port_name attribute of the DSA master will only
> contain information about itself (if at all). If the users need reliable
> information about the CPU port they're probably using devlink anyway.
> 
> Signed-off-by: Vladimir Oltean <olteanv@gmail.com>

Applied and now there is only one dsa netdev op :-)
