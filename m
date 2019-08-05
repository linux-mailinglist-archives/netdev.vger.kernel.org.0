Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3812682618
	for <lists+netdev@lfdr.de>; Mon,  5 Aug 2019 22:33:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730099AbfHEUdh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Aug 2019 16:33:37 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:33836 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727802AbfHEUdh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Aug 2019 16:33:37 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id D570E15432775;
        Mon,  5 Aug 2019 13:33:36 -0700 (PDT)
Date:   Mon, 05 Aug 2019 13:33:36 -0700 (PDT)
Message-Id: <20190805.133336.916443336565287148.davem@davemloft.net>
To:     nikolay@cumulusnetworks.com
Cc:     netdev@vger.kernel.org, roopa@cumulusnetworks.com,
        bridge@lists.linux-foundation.org, michael-dev@fami-braun.de
Subject: Re: [PATCH net v4] net: bridge: move default pvid init/deinit to
 NETDEV_REGISTER/UNREGISTER
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190802105736.26767-1-nikolay@cumulusnetworks.com>
References: <0a015a21-c1ae-e275-e675-431f08bece86@cumulusnetworks.com>
        <20190802105736.26767-1-nikolay@cumulusnetworks.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 05 Aug 2019 13:33:37 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
Date: Fri,  2 Aug 2019 13:57:36 +0300

> Most of the bridge device's vlan init bugs come from the fact that its
> default pvid is created at the wrong time, way too early in ndo_init()
> before the device is even assigned an ifindex. It introduces a bug when the
> bridge's dev_addr is added as fdb during the initial default pvid creation
> the notification has ifindex/NDA_MASTER both equal to 0 (see example below)
> which really makes no sense for user-space[0] and is wrong.
> Usually user-space software would ignore such entries, but they are
> actually valid and will eventually have all necessary attributes.
> It makes much more sense to send a notification *after* the device has
> registered and has a proper ifindex allocated rather than before when
> there's a chance that the registration might still fail or to receive
> it with ifindex/NDA_MASTER == 0. Note that we can remove the fdb flush
> from br_vlan_flush() since that case can no longer happen. At
> NETDEV_REGISTER br->default_pvid is always == 1 as it's initialized by
> br_vlan_init() before that and at NETDEV_UNREGISTER it can be anything
> depending why it was called (if called due to NETDEV_REGISTER error
> it'll still be == 1, otherwise it could be any value changed during the
> device life time).
> 
> For the demonstration below a small change to iproute2 for printing all fdb
> notifications is added, because it contained a workaround not to show
> entries with ifindex == 0.
> Command executed while monitoring: $ ip l add br0 type bridge
> Before (both ifindex and master == 0):
> $ bridge monitor fdb
> 36:7e:8a:b3:56:ba dev * vlan 1 master * permanent
> 
> After (proper br0 ifindex):
> $ bridge monitor fdb
> e6:2a:ae:7a:b7:48 dev br0 vlan 1 master br0 permanent
> 
> v4: move only the default pvid init/deinit to NETDEV_REGISTER/UNREGISTER
> v3: send the correct v2 patch with all changes (stub should return 0)
> v2: on error in br_vlan_init set br->vlgrp to NULL and return 0 in
>     the br_vlan_bridge_event stub when bridge vlans are disabled
> 
> [0] https://bugzilla.kernel.org/show_bug.cgi?id=204389
> 
> Reported-by: michael-dev <michael-dev@fami-braun.de>
> Fixes: 5be5a2df40f0 ("bridge: Add filtering support for default_pvid")
> Signed-off-by: Nikolay Aleksandrov <nikolay@cumulusnetworks.com>

Applied and queued up for -stable, thanks.
