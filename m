Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 21F4C27378C
	for <lists+netdev@lfdr.de>; Tue, 22 Sep 2020 02:38:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728894AbgIVAif (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Sep 2020 20:38:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728497AbgIVAif (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Sep 2020 20:38:35 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B19BFC061755
        for <netdev@vger.kernel.org>; Mon, 21 Sep 2020 17:38:35 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 7D7ED128514DC;
        Mon, 21 Sep 2020 17:21:47 -0700 (PDT)
Date:   Mon, 21 Sep 2020 17:38:33 -0700 (PDT)
Message-Id: <20200921.173833.705760978025831604.davem@davemloft.net>
To:     vladimir.oltean@nxp.com
Cc:     netdev@vger.kernel.org, bridge@lists.linux-foundation.org,
        kuba@kernel.org, roopa@nvidia.com, nikolay@nvidia.com,
        pablo@netfilter.org, andrew@lunn.ch, f.fainelli@gmail.com,
        vivien.didelot@gmail.com
Subject: Re: [PATCH net] net: bridge: br_vlan_get_pvid_rcu() should
 dereference the VLAN group under RCU
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200921220709.96107-1-vladimir.oltean@nxp.com>
References: <20200921220709.96107-1-vladimir.oltean@nxp.com>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Mon, 21 Sep 2020 17:21:47 -0700 (PDT)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>
Date: Tue, 22 Sep 2020 01:07:09 +0300

> When calling the RCU brother of br_vlan_get_pvid(), lockdep warns:
> 
> =============================
> WARNING: suspicious RCU usage
> 5.9.0-rc3-01631-g13c17acb8e38-dirty #814 Not tainted
> -----------------------------
> net/bridge/br_private.h:1054 suspicious rcu_dereference_protected() usage!
> 
> Call trace:
>  lockdep_rcu_suspicious+0xd4/0xf8
>  __br_vlan_get_pvid+0xc0/0x100
>  br_vlan_get_pvid_rcu+0x78/0x108
> 
> The warning is because br_vlan_get_pvid_rcu() calls nbp_vlan_group()
> which calls rtnl_dereference() instead of rcu_dereference(). In turn,
> rtnl_dereference() calls rcu_dereference_protected() which assumes
> operation under an RCU write-side critical section, which obviously is
> not the case here. So, when the incorrect primitive is used to access
> the RCU-protected VLAN group pointer, READ_ONCE() is not used, which may
> cause various unexpected problems.
> 
> I'm sad to say that br_vlan_get_pvid() and br_vlan_get_pvid_rcu() cannot
> share the same implementation. So fix the bug by splitting the 2
> functions, and making br_vlan_get_pvid_rcu() retrieve the VLAN groups
> under proper locking annotations.
> 
> Fixes: 7582f5b70f9a ("bridge: add br_vlan_get_pvid_rcu()")
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Applied and queued up for -stable, thank you.
