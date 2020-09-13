Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4427E267D2C
	for <lists+netdev@lfdr.de>; Sun, 13 Sep 2020 03:34:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725920AbgIMBel (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Sep 2020 21:34:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725890AbgIMBek (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 12 Sep 2020 21:34:40 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34A43C061573;
        Sat, 12 Sep 2020 18:34:40 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id D4FB412919DED;
        Sat, 12 Sep 2020 18:17:51 -0700 (PDT)
Date:   Sat, 12 Sep 2020 18:34:37 -0700 (PDT)
Message-Id: <20200912.183437.1205152743307947529.davem@davemloft.net>
To:     geert@linux-m68k.org
Cc:     hkallweit1@gmail.com, f.fainelli@gmail.com, andrew@lunn.ch,
        kuba@kernel.org, gaku.inami.xh@renesas.com,
        yoshihiro.shimoda.uh@renesas.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Revert "net: linkwatch: add check for netdevice being
 present to linkwatch_do_dev"
From:   David Miller <davem@davemloft.net>
In-Reply-To: <CAMuHMdW0agywTHr4bDO9f_xbQibCxDykdkcAmuRJQO90=E6-Zw@mail.gmail.com>
References: <CAMuHMdUd4VtpOGr26KAmF22N32obNqQzq3tbcPxLJ7mxUtSyrg@mail.gmail.com>
        <20200911.174400.306709791543819081.davem@davemloft.net>
        <CAMuHMdW0agywTHr4bDO9f_xbQibCxDykdkcAmuRJQO90=E6-Zw@mail.gmail.com>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Sat, 12 Sep 2020 18:17:52 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Geert Uytterhoeven <geert@linux-m68k.org>
Date: Sat, 12 Sep 2020 14:33:59 +0200

> "dev" is not the bridge device, but the physical Ethernet interface, which
> may already be suspended during s2ram.

Hmmm, ok.

Looking more deeply NETDEV_CHANGE causes br_port_carrier_check() to run which
exits early if netif_running() is false, which is going to be true if
netif_device_present() is false:

	*notified = false;
	if (!netif_running(br->dev))
		return;

The only other work the bridge notifier does is:

	if (event != NETDEV_UNREGISTER)
		br_vlan_port_event(p, event);

and:

	/* Events that may cause spanning tree to refresh */
	if (!notified && (event == NETDEV_CHANGEADDR || event == NETDEV_UP ||
			  event == NETDEV_CHANGE || event == NETDEV_DOWN))
		br_ifinfo_notify(RTM_NEWLINK, NULL, p);

So some vlan stuff, and emitting a netlink message to any available
listeners.

Should we really do all of this for a device which is not even
present?

This whole situation seems completely illogical.  The device is
useless, it logically has no link or other state that can be managed
or used, while it is not present.

So all of these bridge operations should only happen when the device
transitions back to present again.
