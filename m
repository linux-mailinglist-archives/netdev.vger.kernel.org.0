Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BAF9DA5C74
	for <lists+netdev@lfdr.de>; Mon,  2 Sep 2019 21:00:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726958AbfIBTAG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Sep 2019 15:00:06 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:35760 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726911AbfIBTAG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Sep 2019 15:00:06 -0400
Received: from localhost (unknown [63.64.162.234])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 092AE15405A1C;
        Mon,  2 Sep 2019 12:00:06 -0700 (PDT)
Date:   Mon, 02 Sep 2019 12:00:05 -0700 (PDT)
Message-Id: <20190902.120005.1239670234954992261.davem@davemloft.net>
To:     olteanv@gmail.com
Cc:     f.fainelli@gmail.com, vivien.didelot@gmail.com, andrew@lunn.ch,
        netdev@vger.kernel.org
Subject: Re: [PATCH] net: dsa: Fix off-by-one number of calls to
 devlink_port_unregister
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190831124619.460-1-olteanv@gmail.com>
References: <20190831124619.460-1-olteanv@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.2
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 02 Sep 2019 12:00:06 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <olteanv@gmail.com>
Date: Sat, 31 Aug 2019 15:46:19 +0300

> When a function such as dsa_slave_create fails, currently the following
> stack trace can be seen:
 ...
> devlink_free is complaining right here:
> 
> 	WARN_ON(!list_empty(&devlink->port_list));
> 
> This happens because devlink_port_unregister is no longer done right
> away in dsa_port_setup when a DSA_PORT_TYPE_USER has failed.
> Vivien said about this change that:
> 
>     Also no need to call devlink_port_unregister from within dsa_port_setup
>     as this step is inconditionally handled by dsa_port_teardown on error.
> 
> which is not really true. The devlink_port_unregister function _is_
> being called unconditionally from within dsa_port_setup, but not for
> this port that just failed, just for the previous ones which were set
> up.
> 
> ports_teardown:
> 	for (i = 0; i < port; i++)
> 		dsa_port_teardown(&ds->ports[i]);
> 
> Initially I was tempted to fix this by extending the "for" loop to also
> cover the port that failed during setup. But this could have potentially
> unforeseen consequences unrelated to devlink_port or even other types of
> ports than user ports, which I can't really test for. For example, if
> for some reason devlink_port_register itself would fail, then
> unconditionally unregistering it in dsa_port_teardown would not be a
> smart idea. The list might go on.
> 
> So just make dsa_port_setup undo the setup it had done upon failure, and
> let the for loop undo the work of setting up the previous ports, which
> are guaranteed to be brought up to a consistent state.
> 
> Fixes: 955222ca5281 ("net: dsa: use a single switch statement for port setup")
> Signed-off-by: Vladimir Oltean <olteanv@gmail.com>

Applied to net-next, thanks.
