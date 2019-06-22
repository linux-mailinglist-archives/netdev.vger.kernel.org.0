Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D8CBB4F918
	for <lists+netdev@lfdr.de>; Sun, 23 Jun 2019 01:54:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726511AbfFVXyQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 22 Jun 2019 19:54:16 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:32904 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726296AbfFVXyQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 22 Jun 2019 19:54:16 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 5E1D81540C178;
        Sat, 22 Jun 2019 16:54:15 -0700 (PDT)
Date:   Sat, 22 Jun 2019 16:54:14 -0700 (PDT)
Message-Id: <20190622.165414.71029280359569399.davem@davemloft.net>
To:     lucien.xin@gmail.com
Cc:     netdev@vger.kernel.org, jon.maloy@ericsson.com,
        ying.xue@windriver.com, tipc-discussion@lists.sourceforge.net
Subject: Re: [PATCH net] tipc: change to use register_pernet_device
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1a8f3ada3e0a65b6e9250c4580a7c420b4ddddac.1561027168.git.lucien.xin@gmail.com>
References: <1a8f3ada3e0a65b6e9250c4580a7c420b4ddddac.1561027168.git.lucien.xin@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sat, 22 Jun 2019 16:54:15 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Xin Long <lucien.xin@gmail.com>
Date: Thu, 20 Jun 2019 18:39:28 +0800

> This patch is to fix a dst defcnt leak, which can be reproduced by doing:
> 
>   # ip net a c; ip net a s; modprobe tipc
>   # ip net e s ip l a n eth1 type veth peer n eth1 netns c
>   # ip net e c ip l s lo up; ip net e c ip l s eth1 up
>   # ip net e s ip l s lo up; ip net e s ip l s eth1 up
>   # ip net e c ip a a 1.1.1.2/8 dev eth1
>   # ip net e s ip a a 1.1.1.1/8 dev eth1
>   # ip net e c tipc b e m udp n u1 localip 1.1.1.2
>   # ip net e s tipc b e m udp n u1 localip 1.1.1.1
>   # ip net d c; ip net d s; rmmod tipc
> 
> and it will get stuck and keep logging the error:
> 
>   unregister_netdevice: waiting for lo to become free. Usage count = 1
> 
> The cause is that a dst is held by the udp sock's sk_rx_dst set on udp rx
> path with udp_early_demux == 1, and this dst (eventually holding lo dev)
> can't be released as bearer's removal in tipc pernet .exit happens after
> lo dev's removal, default_device pernet .exit.
> 
>  "There are two distinct types of pernet_operations recognized: subsys and
>   device.  At creation all subsys init functions are called before device
>   init functions, and at destruction all device exit functions are called
>   before subsys exit function."
> 
> So by calling register_pernet_device instead to register tipc_net_ops, the
> pernet .exit() will be invoked earlier than loopback dev's removal when a
> netns is being destroyed, as fou/gue does.
> 
> Note that vxlan and geneve udp tunnels don't have this issue, as the udp
> sock is released in their device ndo_stop().
> 
> This fix is also necessary for tipc dst_cache, which will hold dsts on tx
> path and I will introduce in my next patch.
> 
> Reported-by: Li Shuang <shuali@redhat.com>
> Signed-off-by: Xin Long <lucien.xin@gmail.com>

Applied.
