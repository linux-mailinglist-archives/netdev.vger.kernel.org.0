Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 39DB92841BA
	for <lists+netdev@lfdr.de>; Mon,  5 Oct 2020 22:56:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726165AbgJEUzs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Oct 2020 16:55:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725845AbgJEUzr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Oct 2020 16:55:47 -0400
Received: from mail-ed1-x542.google.com (mail-ed1-x542.google.com [IPv6:2a00:1450:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85923C0613CE;
        Mon,  5 Oct 2020 13:55:47 -0700 (PDT)
Received: by mail-ed1-x542.google.com with SMTP id 33so10975967edq.13;
        Mon, 05 Oct 2020 13:55:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=0KXseeCMswEw3SWrnakm1K0mYIfL4kZcpHfxRqoIgMU=;
        b=mxo4Uqz/xXzKk4/Fkf0UViItLoD13jZ8008e89DxyPjzmRn2rRC97te/QxnnH6MYQs
         74CmOqNAXt5oIO7BEI0y0nFKWoVZzopqE4gBDzGIcOxs3MSRYQZHR/svrVf4FUt+kRFz
         kz+5kwBgUtT5Oa+YOvnqscet9UOU5QyVNLFT90JtfKVZQ5a8fDm6QtXwfhXtPEzbqNnD
         Z2uh7jiJp8AbuRu7//hZWB0RUoTvCRp/afCD43jqAeAO5pMvuKLfevwhNI8V9KOPopId
         aX1OZtJzrWzJcovthrKLWxuAHcnVXn73x2waj63hrb0i7RjnK0i8+v81c+/DY1c/747+
         50Fw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=0KXseeCMswEw3SWrnakm1K0mYIfL4kZcpHfxRqoIgMU=;
        b=b/FrBJh5Rj6un0hpSePoU+llZN71luBnOq2wW5ej61IwSS6ZsQ9NXc8rRYWlHFp35H
         orRF7x6oXP0K+3RnEAtL8RO1amkhsuCdtRVKApndXn5RwVNgZcUQKUeSl0cFcVAX+/aX
         2pS6ebgfKnJdAvjpVUKU5Zqa/qoxsfTZHyQvpVVg21bYmQek9IlJsB2aaMCT6g0pbDPj
         lyu5pqUjoTdD8FaWvTF+ay96579ImTe5sV/g2DrnwUHL73CErvnb3UUQyc6BAeHL4xY5
         VMrP+X97Y4LrdnRSVpIU4RUiiO3uDGfhPv7FT3omAqeICbfRNWQGvwhcYCiCGaz7JXd4
         NJ6w==
X-Gm-Message-State: AOAM532zfzy0KknJd1Df3f3zHefhRpWOehIaVDr3IOb/7vi9o8l/Yyn1
        MFXrGv/6IPnKqLF6e+rmmAs=
X-Google-Smtp-Source: ABdhPJxCjPWgWcxBrUDWsu/CF1riX44RkMXepHp2zPBD+VlQ07H+wBfAgVuRNsNhM6GZfkCAdGNKjA==
X-Received: by 2002:aa7:d7ce:: with SMTP id e14mr1737919eds.258.1601931346140;
        Mon, 05 Oct 2020 13:55:46 -0700 (PDT)
Received: from skbuf ([188.26.229.171])
        by smtp.gmail.com with ESMTPSA id w21sm554233ejo.70.2020.10.05.13.55.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Oct 2020 13:55:45 -0700 (PDT)
Date:   Mon, 5 Oct 2020 23:55:44 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Christian Eggers <ceggers@arri.de>
Cc:     Woojung Huh <woojung.huh@microchip.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] net: dsa: microchip: fix race condition
Message-ID: <20201005205544.7ddl4xzxhfas6nya@skbuf>
References: <20201005160829.5607-1-ceggers@arri.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201005160829.5607-1-ceggers@arri.de>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Christian,

On Mon, Oct 05, 2020 at 06:08:29PM +0200, Christian Eggers wrote:
> Between queuing the delayed work and finishing the setup of the dsa
> ports, the process may sleep in request_module() and the queued work may
> be executed prior the initialization of the DSA ports is finished. In
              ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
              "prior to the switch net devices being registered", maybe?
> ksz_mib_read_work(), a NULL dereference will happen within
> netof_carrier_ok(dp->slave).
> 
> Not queuing the delayed work in ksz_init_mib_timer() make things even
                                                       ~~~~
                                                       makes
> worse because the work will now be queued for immediate execution
> (instead of 2000 ms) in ksz_mac_link_down() via
> dsa_port_link_register_of().
> 
> Solution:
> 1. Do not queue (only initialize) delayed work in ksz_init_mib_timer().
> 2. Only queue delayed work in ksz_mac_link_down() if init is completed.
> 3. Queue work once in ksz_switch_register(), after dsa_register_switch()
> has completed.
> 
> Signed-off-by: Christian Eggers <ceggers@arri.de>
> Cc: stable@vger.kernel.org

For patches sent to the networking tree you should:
git format-patch --subject-prefix=
(a) "PATCH net-next" if it's a new feature (not applicable now)
(b) "PATCH net" if it's a bug fix (such is the case here)

Plus you should not Cc the stable mailing list, since David Miller deals
with sending patches to stable himself as long as you make sure to send
to his "net" tree as opposed to "net-next".

Read this for more details
https://www.kernel.org/doc/html/latest/networking/netdev-FAQ.html

> ---
> Call tree:

Please include the call path in the commit message, it is relevant that
request_module() is being called by phy_device_create(), and something
which you did not say in the verbal commit description.

FYI, you haven't even addressed the root cause of the problem, which is
ksz_mib_read_work sticking its nose where it's not supposed to:

		/* Only read MIB counters when the port is told to do.
		 * If not, read only dropped counters when link is not up.
		 */
		if (!p->read) {
			const struct dsa_port *dp = dsa_to_port(dev->ds, i);

			if (!netif_carrier_ok(dp->slave))
				mib->cnt_ptr = dev->reg_mib_cnt;
		}

This is simply Not Ok.
Not only the dp->slave is on purpose registered outside of the driver's
control (as you came to find out yourself), but not even all ports are
user ports. For example, the CPU port doesn't have a valid struct
net_device *slave pointer. You are just lucky that it's defined like
this:

struct dsa_port {
	/* A CPU port is physically connected to a master device.
	 * A user port exposed to userspace has a slave device.
	 */
	union {
		struct net_device *master;
		struct net_device *slave;
	};

so the code is in fact checking the status of the master interface's link.
But DSA doesn't assume that the *master and *slave pointers are under a
union. That can change any day, and when it changes, the KSZ driver will
break.

My personal feeling is that this driver hides a landmine beneath every
line of code, and it isn't getting better.
Sure, you should absolutely add the call stack to the commit message,
but how many people are going to git blame so they can see it. The code
needs to be obviously correct.

Things like needing to check dev->mib_read_interval as an indication
whether the race between ksz_mac_link_down and ksz_switch_register is
over are exactly the type of things that make it not fun to follow.

If reading MIB counters for ports that are down is such a "waste of time"
as per commit 7c6ff470aa867f53b8522a3a5c84c36ac7a20090, then how about
scheduling the delayed work from .phylink_mac_link_up, and canceling it
from .phylink_mac_link_down? Either that, or set a boolean variable to
struct ksz_port p->link_up, to true or false respectively from the
phylink callbacks, and using that as an indication whether to read the
MIB counters or not, instead of accessing the potentially invalid
dp->slave pointer? Would that work?

Sorry for rambling. I realize that there aren't probably a lot of things
you can do better to fix this problem for stable, but maybe you could
take some time and clean it up a little bit?

Thanks,
-Vladimir
