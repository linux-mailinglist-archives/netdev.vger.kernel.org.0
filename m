Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 24D371E189E
	for <lists+netdev@lfdr.de>; Tue, 26 May 2020 02:58:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388211AbgEZA6K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 May 2020 20:58:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387794AbgEZA6K (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 May 2020 20:58:10 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 125FDC061A0E
        for <netdev@vger.kernel.org>; Mon, 25 May 2020 17:58:10 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 79D071279E51A;
        Mon, 25 May 2020 17:58:09 -0700 (PDT)
Date:   Mon, 25 May 2020 17:58:08 -0700 (PDT)
Message-Id: <20200525.175808.465482238114904305.davem@davemloft.net>
To:     olteanv@gmail.com
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        madalin.bucur@oss.nxp.com, netdev@vger.kernel.org
Subject: Re: [PATCH] dpaa_eth: fix usage as DSA master, try 3
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200524212251.3311546-1-olteanv@gmail.com>
References: <20200524212251.3311546-1-olteanv@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 25 May 2020 17:58:09 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <olteanv@gmail.com>
Date: Mon, 25 May 2020 00:22:51 +0300

> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> The dpaa-eth driver probes on compatible string for the MAC node, and
> the fman/mac.c driver allocates a dpaa-ethernet platform device that
> triggers the probing of the dpaa-eth net device driver.
> 
> All of this is fine, but the problem is that the struct device of the
> dpaa_eth net_device is 2 parents away from the MAC which can be
> referenced via of_node. So of_find_net_device_by_node can't find it, and
> DSA switches won't be able to probe on top of FMan ports.
> 
> It would be a bit silly to modify a core function
> (of_find_net_device_by_node) to look for dev->parent->parent->of_node
> just for one driver. We're just 1 step away from implementing full
> recursion.
> 
> Actually there have already been at least 2 previous attempts to make
> this work:
> - Commit a1a50c8e4c24 ("fsl/man: Inherit parent device and of_node")
> - One or more of the patches in "[v3,0/6] adapt DPAA drivers for DSA":
>   https://patchwork.ozlabs.org/project/netdev/cover/1508178970-28945-1-git-send-email-madalin.bucur@nxp.com/
>   (I couldn't really figure out which one was supposed to solve the
>   problem and how).
> 
> Point being, it looks like this is still pretty much a problem today.
> On T1040, the /sys/class/net/eth0 symlink currently points to
> 
> ../../devices/platform/ffe000000.soc/ffe400000.fman/ffe4e6000.ethernet/dpaa-ethernet.0/net/eth0
> 
> which pretty much illustrates the problem. The closest of_node we've got
> is the "fsl,fman-memac" at /soc@ffe000000/fman@400000/ethernet@e6000,
> which is what we'd like to be able to reference from DSA as host port.
> 
> For of_find_net_device_by_node to find the eth0 port, we would need the
> parent of the eth0 net_device to not be the "dpaa-ethernet" platform
> device, but to point 1 level higher, aka the "fsl,fman-memac" node
> directly. The new sysfs path would look like this:
> 
> ../../devices/platform/ffe000000.soc/ffe400000.fman/ffe4e6000.ethernet/net/eth0
> 
> And this is exactly what SET_NETDEV_DEV does. It sets the parent of the
> net_device. The new parent has an of_node associated with it, and
> of_dev_node_match already checks for the of_node of the device or of its
> parent.
> 
> Fixes: a1a50c8e4c24 ("fsl/man: Inherit parent device and of_node")
> Fixes: c6e26ea8c893 ("dpaa_eth: change device used")
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Applied and queued up for -stable, thanks.
