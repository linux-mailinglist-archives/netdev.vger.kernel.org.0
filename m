Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC1D8262553
	for <lists+netdev@lfdr.de>; Wed,  9 Sep 2020 04:43:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726657AbgIICnH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Sep 2020 22:43:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725997AbgIICnG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Sep 2020 22:43:06 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39CC3C061573
        for <netdev@vger.kernel.org>; Tue,  8 Sep 2020 19:43:06 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 79E6D11E3E4C2;
        Tue,  8 Sep 2020 19:26:18 -0700 (PDT)
Date:   Tue, 08 Sep 2020 19:43:04 -0700 (PDT)
Message-Id: <20200908.194304.373837754597025372.davem@davemloft.net>
To:     olteanv@gmail.com
Cc:     kuba@kernel.org, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        andrew@lunn.ch, xiyou.wangcong@gmail.com, ap420073@gmail.com,
        netdev@vger.kernel.org
Subject: Re: [PATCH v2 net] net: dsa: link interfaces with the DSA master
 to get rid of lockdep warnings
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200907234842.1684223-1-olteanv@gmail.com>
References: <20200907234842.1684223-1-olteanv@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Tue, 08 Sep 2020 19:26:18 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <olteanv@gmail.com>
Date: Tue,  8 Sep 2020 02:48:42 +0300

> Since commit 845e0ebb4408 ("net: change addr_list_lock back to static
> key"), cascaded DSA setups (DSA switch port as DSA master for another
> DSA switch port) are emitting this lockdep warning:
 ...
> Since DSA never made use of the netdev API for describing links between
> upper devices and lower devices, the dev->lower_level value of a DSA
> switch interface would be 1, which would warn when it is a DSA master.
> 
> We can use netdev_upper_dev_link() to describe the relationship between
> a DSA slave and a DSA master. To be precise, a DSA "slave" (switch port)
> is an "upper" to a DSA "master" (host port). The relationship is "many
> uppers to one lower", like in the case of VLAN. So, for that reason, we
> use the same function as VLAN uses.
> 
> There might be a chance that somebody will try to take hold of this
> interface and use it immediately after register_netdev() and before
> netdev_upper_dev_link(). To avoid that, we do the registration and
> linkage while holding the RTNL, and we use the RTNL-locked cousin of
> register_netdev(), which is register_netdevice().
> 
> Since this warning was not there when lockdep was using dynamic keys for
> addr_list_lock, we are blaming the lockdep patch itself. The network
> stack _has_ been using static lockdep keys before, and it _is_ likely
> that stacked DSA setups have been triggering these lockdep warnings
> since forever, however I can't test very old kernels on this particular
> stacked DSA setup, to ensure I'm not in fact introducing regressions.
> 
> Fixes: 845e0ebb4408 ("net: change addr_list_lock back to static key")
> Suggested-by: Cong Wang <xiyou.wangcong@gmail.com>
> Signed-off-by: Vladimir Oltean <olteanv@gmail.com>

Applied and queued up for v5.8 -stable, thanks.
