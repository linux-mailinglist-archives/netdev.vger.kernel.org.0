Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A6536D9C58
	for <lists+netdev@lfdr.de>; Wed, 16 Oct 2019 23:17:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437478AbfJPVQ7 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 16 Oct 2019 17:16:59 -0400
Received: from lithops.sigma-star.at ([195.201.40.130]:46434 "EHLO
        lithops.sigma-star.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727542AbfJPVQ6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Oct 2019 17:16:58 -0400
Received: from localhost (localhost [127.0.0.1])
        by lithops.sigma-star.at (Postfix) with ESMTP id 6708060632EE;
        Wed, 16 Oct 2019 23:16:55 +0200 (CEST)
Received: from lithops.sigma-star.at ([127.0.0.1])
        by localhost (lithops.sigma-star.at [127.0.0.1]) (amavisd-new, port 10032)
        with ESMTP id XoiCMRDj9y1F; Wed, 16 Oct 2019 23:16:55 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
        by lithops.sigma-star.at (Postfix) with ESMTP id 17F5E60632C1;
        Wed, 16 Oct 2019 23:16:55 +0200 (CEST)
Received: from lithops.sigma-star.at ([127.0.0.1])
        by localhost (lithops.sigma-star.at [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id X13sxO1rFzJx; Wed, 16 Oct 2019 23:16:55 +0200 (CEST)
Received: from lithops.sigma-star.at (lithops.sigma-star.at [195.201.40.130])
        by lithops.sigma-star.at (Postfix) with ESMTP id D843F6083266;
        Wed, 16 Oct 2019 23:16:54 +0200 (CEST)
Date:   Wed, 16 Oct 2019 23:16:54 +0200 (CEST)
From:   Richard Weinberger <richard@nod.at>
To:     Roopa Prabhu <roopa@cumulusnetworks.com>
Cc:     Nikolay Aleksandrov <nikolay@cumulusnetworks.com>,
        Richard Weinberger <richard.weinberger@gmail.com>,
        netdev <netdev@vger.kernel.org>,
        bridge@lists.linux-foundation.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Message-ID: <910194713.25283.1571260614731.JavaMail.zimbra@nod.at>
In-Reply-To: <CAJieiUi-b5vcOTGqXcDpn9fxVwA9jyoMWEDM2F_ZgVfzdgFgeA@mail.gmail.com>
References: <CAFLxGvwnOi6dSq5yLM78XskweQOY6aPbRt==G9wv5qS+dfj8bw@mail.gmail.com> <3A7BDEE0-7C07-4F23-BA01-F32AD41451BB@cumulusnetworks.com> <5A4A5745-5ADC-4AAC-B060-1BC9907C153C@cumulusnetworks.com> <CAJieiUi-b5vcOTGqXcDpn9fxVwA9jyoMWEDM2F_ZgVfzdgFgeA@mail.gmail.com>
Subject: Re: Bridge port userspace events broken?
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-Originating-IP: [195.201.40.130]
X-Mailer: Zimbra 8.8.12_GA_3807 (ZimbraWebClient - FF60 (Linux)/8.8.12_GA_3809)
Thread-Topic: Bridge port userspace events broken?
Thread-Index: X0H1a+cAJkAg3/lVNpzTKtoYJLogig==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Roopa, Nikolay,

----- Ursprüngliche Mail -----
> +1,  this can be fixed....but in general all new bridge and link
> attributes have better support with netlink.
> In this case its IFLA_BRPORT_GROUP_FWD_MASK link attribute available
> via ip monitor or bridge monitor.
> you probably cannot use it with udev today.
> 
> For the future, I think having udev listen to netlink link and devlink
> events would make sense (Not sure if anybody is working on it).
> AFAIK the sysfs uevent mechanism for link attributes don't  receive
> the required attention and testing like the equivalent netlink events.

I understand that netlink works best for you but sysfs notifications are still
useful.
Please let me explain my use case a little bit more.

The application I work on operates on network interfaces, in this case the
interface happens to be a bridge.
systemd-networkd sets up the bridge as soon all slave interfaces emerge.

Therefore the systemd service file of the application depends on the bridge.
i.e.
Requires=sys-subsystem-net-devices-br0.device

In one specific setup the bridge needs to forward more than usual and 
group_fwd_mask needs to be altered. Sadly this is nothing systemd-networkd
can do right now, so I added the following line to the service file of
the application:
ExecStartPre=/bin/bash -c "echo 0xfffd > /sys/class/net/eth0/brport/group_fwd_mask"

Here comes the problem, the unit is activated as soon br0 is created but
at this time eth0 is sometimes not yet a slave or br0. It takes some time.

So I need a way to model this dependency in a systemd environment.
A common approach to do so is setting up an udev rule which set a systemd notify
as soon a specific sysfs file arrives.

Teaching the application to listen for bridge specific netlink messages is
another possible approach but seems overkill to me.
Or maybe there is some nice wrapper/helper?

It would be nice to have sysfs notifications for bridge devices too.
I can understand that not everyone likes this approach but this is the way
how *many* systems out there work these day. Actually almost any (embedded)
system with systemd.

Thanks,
//richard
