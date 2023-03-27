Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D0F6D6C9AC4
	for <lists+netdev@lfdr.de>; Mon, 27 Mar 2023 07:07:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232066AbjC0FHh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Mar 2023 01:07:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232071AbjC0FG6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Mar 2023 01:06:58 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8E295255
        for <netdev@vger.kernel.org>; Sun, 26 Mar 2023 22:06:50 -0700 (PDT)
Received: from ptx.hi.pengutronix.de ([2001:67c:670:100:1d::c0])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1pgf3y-0007sN-6O; Mon, 27 Mar 2023 07:06:34 +0200
Received: from ore by ptx.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1pgf3v-0004DS-2n; Mon, 27 Mar 2023 07:06:31 +0200
Date:   Mon, 27 Mar 2023 07:06:31 +0200
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Eric Dumazet <edumazet@google.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Woojung Huh <woojung.huh@microchip.com>, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        UNGLinuxDriver@microchip.com,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Roopa Prabhu <roopa@nvidia.com>,
        Ido Schimmel <idosch@nvidia.com>
Subject: Re: What is the best way to provide FDB related metrics to user
 space?
Message-ID: <20230327050631.GC28424@pengutronix.de>
References: <20230324140622.GB28424@pengutronix.de>
 <20230324144351.54kyejvgqvkozuvp@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20230324144351.54kyejvgqvkozuvp@skbuf>
X-Sent-From: Pengutronix Hildesheim
X-URL:  http://www.pengutronix.de/
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
User-Agent: Mutt/1.10.1 (2018-07-13)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c0
X-SA-Exim-Mail-From: ore@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-2.3 required=5.0 tests=RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Vladimir,

On Fri, Mar 24, 2023 at 04:43:51PM +0200, Vladimir Oltean wrote:
> Hi Oleksij,
> 
> On Fri, Mar 24, 2023 at 03:06:22PM +0100, Oleksij Rempel wrote:
> > Hello all,
> > 
> > I am currently working on implementing an interface to provide
> > FDB-related metrics to user space, such as the size of the FDB, the
> > count of objects, and so on. The IEEE 802.1Q-2018 standard offers some
> > guidance on this topic. For instance, section "17.2.4 Structure of the
> > IEEE8021-Q-BRIDGE-MIB" defines the ieee8021QBridgeFdbDynamicCount
> > object, and section "12.7.1.1.3 Outputs" provides additional outputs
> > that can be utilized for proper bridge management.
> > 
> > I've noticed that some DSA drivers implement devlink raw access to the
> > FDB. I am wondering if it would be acceptable to provide a generic
> > interface for all DSA switches for these kinds of metrics. What would be
> > the best interface to use for this purpose - devlink, sysfs, or
> > something else?
> 
> It's not an easy question. It probably depends on what exactly you need
> it for.
> 
> At a first glance, I'd say that the bridge's netlink interface should
> probably report these, based on information collected and aggregated
> from its bridge ports. But it becomes quite complicated to aggregate
> info from switchdev and non-switchdev (Wi-Fi, plain Ethernet) ports into
> a single meaningful number. Also, the software bridge does not have a
> hard limit per se when it comes to the number of FDB entries (although
> maybe it wouldn't be such a bad idea).
> 
> ieee8021QBridgeFdbDynamicCount seems defined as "The current number of
> dynamic entries in this Filtering Database." So we're already outside
> the territory of statically defined "maximums" and we're now talking
> about the degree of occupancy of certain tables. That will be a lot
> harder for the software bridge to aggregate coherently, and it can't
> just count its own dynamic FDB entries. Things like dynamic address
> learning of FDB entries learned on foreign interfaces would make that
> utilization figure quite imprecise. Also, some DSA switches have a
> VLAN-unaware FDB, and if the bridge is VLAN-aware, it will have one FDB
> entry per each VLAN, whereas the hardware table will have a single FDB
> entry. Also, DSA in general does not attempt to sync the software FDB
> with the hardware FDB.
> 
> So, while we could in theory make the bridge forward this information
> from drivers to user space in a unified form, it seems that the device
> specific information is hard to convert in a lossless form to generic
> information.
> 
> Which is exactly the reason why we have what we have now, I guess.
> 
> What do you mean by "devlink raw access"? In Documentation/networking/dsa/dsa.rst
> we say:

ack, this is what I described as raw access.

> | - Resources: a monitoring feature which enables users to see the degree of
> |   utilization of certain hardware tables in the device, such as FDB, VLAN, etc.
> 
> If you search for dsa_devlink_resource_register(), you'll see the
> current state of things. What is reported there as device-specific
> resources seems to be the kind of thing you would be interested in.

I would like to provide some additional context for my investigation and
question. The starting point was the following kernel log warnings:

ksz9477-switch spi1.0 dut: failed (err=-28) to add object (id=2)
ksz9477-switch spi1.0 uplink: failed (err=-28) to add object (id=2)

These warnings are related to the static FDB but share some general
issues - it is neither a kernel nor a hardware bug. The resources
provided by this hardware are insufficient for the related network
segment or configuration. At least we can see issues related to the
static FDB. However, a dynamic FDB will silently become full and start
flooding the network, causing other segments to slow down.

Since the kernel log does not provide easily understandable information
for network or system administrators, I started investigating more
unified ways to bring the issue to their attention. The
dsa_devlink_resource_register() method would help answer the question
"what exactly is wrong," but this is only the second step after
notifying the administrator that there is a problem.

Additionally, I have found that some devices provide an SNMP interface
to monitor FDBs. One example can be found in this article:
https://extremeportal.force.com/ExtrArticleDetail?an=000078206

Considering the background and context, do you have any suggestions on a
suitable approach for notifying administrators of such issues in a more
user-friendly and understandable manner?

Best regards,
Oleksij
-- 
Pengutronix e.K.                           |                             |
Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
