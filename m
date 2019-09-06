Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 57C90AB8B0
	for <lists+netdev@lfdr.de>; Fri,  6 Sep 2019 15:00:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392761AbfIFM7l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Sep 2019 08:59:41 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:59772 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391494AbfIFM7j (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Sep 2019 08:59:39 -0400
Received: from localhost (unknown [88.214.184.128])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id ADBB9152F2BB1;
        Fri,  6 Sep 2019 05:59:36 -0700 (PDT)
Date:   Fri, 06 Sep 2019 14:59:35 +0200 (CEST)
Message-Id: <20190906.145935.2234218592748770009.davem@davemloft.net>
To:     paulb@mellanox.com
Cc:     pshelar@ovn.org, netdev@vger.kernel.org, jpettit@nicira.com,
        simon.horman@netronome.com, marcelo.leitner@gmail.com,
        vladbu@mellanox.com, jiri@mellanox.com, roid@mellanox.com,
        yossiku@mellanox.com, ronye@mellanox.com, ozsh@mellanox.com
Subject: Re: [PATCH net-next v4 1/1] net: openvswitch: Set OvS recirc_id
 from tc chain index
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1567605397-14060-2-git-send-email-paulb@mellanox.com>
References: <1567605397-14060-1-git-send-email-paulb@mellanox.com>
        <1567605397-14060-2-git-send-email-paulb@mellanox.com>
X-Mailer: Mew version 6.8 on Emacs 26.2
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 06 Sep 2019 05:59:39 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Paul Blakey <paulb@mellanox.com>
Date: Wed,  4 Sep 2019 16:56:37 +0300

> Offloaded OvS datapath rules are translated one to one to tc rules,
> for example the following simplified OvS rule:
> 
> recirc_id(0),in_port(dev1),eth_type(0x0800),ct_state(-trk) actions:ct(),recirc(2)
> 
> Will be translated to the following tc rule:
> 
> $ tc filter add dev dev1 ingress \
> 	    prio 1 chain 0 proto ip \
> 		flower tcp ct_state -trk \
> 		action ct pipe \
> 		action goto chain 2
> 
> Received packets will first travel though tc, and if they aren't stolen
> by it, like in the above rule, they will continue to OvS datapath.
> Since we already did some actions (action ct in this case) which might
> modify the packets, and updated action stats, we would like to continue
> the proccessing with the correct recirc_id in OvS (here recirc_id(2))
> where we left off.
> 
> To support this, introduce a new skb extension for tc, which
> will be used for translating tc chain to ovs recirc_id to
> handle these miss cases. Last tc chain index will be set
> by tc goto chain action and read by OvS datapath.
> 
> Signed-off-by: Paul Blakey <paulb@mellanox.com>
> Signed-off-by: Vlad Buslov <vladbu@mellanox.com>
> Acked-by: Jiri Pirko <jiri@mellanox.com>
> ---
> Changelog:
> V3->V4:
> 	Removed changes to tcf_result, instead us action return value to get chain index

Applied to net-next.
