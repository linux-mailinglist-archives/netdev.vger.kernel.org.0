Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B53B69C03F
	for <lists+netdev@lfdr.de>; Sat, 24 Aug 2019 23:01:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727823AbfHXVBZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 24 Aug 2019 17:01:25 -0400
Received: from mail.nic.cz ([217.31.204.67]:42418 "EHLO mail.nic.cz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726842AbfHXVBZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 24 Aug 2019 17:01:25 -0400
Received: from localhost (unknown [172.20.6.135])
        by mail.nic.cz (Postfix) with ESMTPSA id EEDD2140B27;
        Sat, 24 Aug 2019 23:01:21 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=nic.cz; s=default;
        t=1566680482; bh=9XjHBzs2MDBlVIPBZeb/7WzSF3ld4HmHUe1S3iJxXeI=;
        h=Date:From:To;
        b=aaHiVBpCcTWVRZ+TwNXhFUJky3eZRnEQRs2d6+CnJb7jmGdw/82T9C88PNKvS2fUC
         7Oz19DA8ubulM8AJg6GTC4CWkUkx3ndUVMyP3LKGJfCskysgzRSPkca5yPOtS6AufM
         4xuo70IALmzk8KRFaCX2WbG7Rzvi9BdtLZaJ16H8=
Date:   Sat, 24 Aug 2019 23:01:21 +0200
From:   Marek Behun <marek.behun@nic.cz>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        David Ahern <dsahern@gmail.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Chris Healy <cphealy@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>
Subject: Re: [PATCH RFC net-next 0/3] Multi-CPU DSA support
Message-ID: <20190824230121.35a3d59b@nic.cz>
In-Reply-To: <a7fed8ab-60f3-a30c-5634-fd89e4daf44d@gmail.com>
References: <20190824024251.4542-1-marek.behun@nic.cz>
        <a7fed8ab-60f3-a30c-5634-fd89e4daf44d@gmail.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Virus-Scanned: clamav-milter 0.100.3 at mail.nic.cz
X-Virus-Status: Clean
X-Spam-Status: No, score=-1.0 required=5.0 tests=ALL_TRUSTED,SHORTCIRCUIT
        shortcircuit=ham autolearn=disabled version=3.4.2
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on mail.nic.cz
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 24 Aug 2019 13:04:04 -0700
Florian Fainelli <f.fainelli@gmail.com> wrote:

> 1) Your approach is kind of interesting here, not sure if it is the best
> but it is not outright wrong. In the past, we had been talking about
> different approaches, some of which seemed too simplistic or too narrow
> on the use case, and some of which that are up in the air and were not
> worked on.
> 
> - John Crispin submitted a patch series for the MTK switch driver a
> while back that was picked up by Frank Wunderlich more recently. This
> approach uses a Device Tree based configuration in order to statically
> assign ports, or groups of ports to a specific DSA master device. This
> is IMHO wrong because a) DT is not to impose a policy but strictly
> describe HW, and b) there was no way to change that static assignment at
> runtime.
> 
> - Based on that patch series, Andrew, Vivien, Frank and myself discussed
> two possible options:
> 	- allowing the enslaving of DSA master devices in the bridge, so as to
> provide a hint that specific DSA slave network devices should be
> "bound"/"linked" to a specific DSA master device. This requires
> modifications in the bridge layer to avoid undoing what commit
> 8db0a2ee2c6302a1dcbcdb93cb731dfc6c0cdb5e ("net: bridge: reject
> DSA-enabled master netdevices as bridge members"). This would also
> require a bridge to be set-up
> 
> 	- enhancing the iproute2 command and backing kernel code in order to
> allow defining that a DSA slave device may be enslaved into a specific
> DSA master, similarly to how you currently enslave a device into a
> bridge, you could "enslave" a DSA slave to a DSA master with something
> that could look like this:
> 
> 	ip link set dev sw0p0 master eth0	# Associate port 0 with eth0
> 	ip link set dev sw0p1 master eth1	# Associate port 1 with eth1
> 
> To date, this may be the best way to do what we want here, rather than
> use the iflink which is a bit re-purposing something that is not exactly
> meant for that.

We cannot use "set master" to set CPU port, since that is used for
enslaving interfaces to bridges. There are usecases where these would
conflict with each other. The semantics would become complicated and
the documentation would became weird to users.

We are *already* using the iflink property to report which CPU device
is used as CPU destination port for a given switch slave interface. So
why to use that for changing this, also?

If you think that iflink should not be used for this, and other agree,
then we should create a new property, something like dsa-upstream, (eg.
ip link set dev sw0p0 dsa-upstream eth0). Using the "master" property
is not right, IMO.

Marek
