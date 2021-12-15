Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E47447669C
	for <lists+netdev@lfdr.de>; Thu, 16 Dec 2021 00:38:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232141AbhLOXiH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Dec 2021 18:38:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232096AbhLOXiH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Dec 2021 18:38:07 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BE27C061574;
        Wed, 15 Dec 2021 15:38:07 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C8133B8220D;
        Wed, 15 Dec 2021 23:38:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1698DC36AE1;
        Wed, 15 Dec 2021 23:38:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1639611484;
        bh=vzJgSPIy3+FHuUEYJTupv6VKwZpeq9MrPhdrbiF18RA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ANz/ETbml50S824SkAB5kzDn+n29RP5TbLUtlWMXovvekvB+x5Lgy9pynHYKEiu0C
         1fiQdo0teCmi4XMCTcOGqu6vKgliy6OfKwgUMS9EMd3LGbi6ogYCdxJaLlE6NKf9AE
         rEhKW/hENf7QO9OVA9Ct21XrIR7L3o3HZm8fGcQ9EAo09ckYaNU/j93JY7uNc7TgdK
         EF6+tLpu29AbmWoQ5ORhDs9wxQD+qYNI6do86w1ud+pN9Fiql8+arh2K+OuXIfz4LZ
         f6vtHHyJzDnlTy1Xnc0mMcnh4IfjeSIJadeDhSSfkt2Lr/iDhOkGYzjRWOeNdCK7z1
         LngdwpD6EaZAQ==
Date:   Wed, 15 Dec 2021 15:38:03 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Uladzislau Rezki <urezki@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>, RCU <rcu@vger.kernel.org>,
        "Paul E . McKenney" <paulmck@kernel.org>,
        Michal Hocko <mhocko@suse.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Daniel Axtens <dja@axtens.net>,
        Frederic Weisbecker <frederic@kernel.org>,
        Neeraj Upadhyay <neeraju@codeaurora.org>,
        Joel Fernandes <joel@joelfernandes.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Theodore Y . Ts'o" <tytso@mit.edu>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Oleksiy Avramchenko <oleksiy.avramchenko@sonymobile.com>
Subject: Re: [PATCH] mlxsw: core: Switch to kvfree_rcu() API
Message-ID: <20211215153803.7f14b0d6@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <YbpGGiTtBvJnYvmZ@pc638.lan>
References: <20211215111845.2514-1-urezki@gmail.com>
        <20211215111845.2514-7-urezki@gmail.com>
        <YbpGGiTtBvJnYvmZ@pc638.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 15 Dec 2021 20:46:34 +0100 Uladzislau Rezki wrote:
> On Wed, Dec 15, 2021 at 12:18:43PM +0100, Uladzislau Rezki (Sony) wrote:
> > Instead of invoking a synchronize_rcu() to free a pointer
> > after a grace period we can directly make use of new API
> > that does the same but in more efficient way.
> > 
> > TO: David S. Miller <davem@davemloft.net>
> > TO: Jakub Kicinski <kuba@kernel.org>
> > TO: netdev@vger.kernel.org
> > Signed-off-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
> > ---
> >  drivers/net/ethernet/mellanox/mlxsw/core.c | 3 +--
> >  1 file changed, 1 insertion(+), 2 deletions(-)
> > 
> > diff --git a/drivers/net/ethernet/mellanox/mlxsw/core.c b/drivers/net/ethernet/mellanox/mlxsw/core.c
> > index 3fd3812b8f31..47c29769759b 100644
> > --- a/drivers/net/ethernet/mellanox/mlxsw/core.c
> > +++ b/drivers/net/ethernet/mellanox/mlxsw/core.c
> > @@ -2190,8 +2190,7 @@ void mlxsw_core_rx_listener_unregister(struct mlxsw_core *mlxsw_core,
> >  	if (!rxl_item)
> >  		return;
> >  	list_del_rcu(&rxl_item->list);
> > -	synchronize_rcu();
> > -	kfree(rxl_item);
> > +	kvfree_rcu(rxl_item);
> >  }
> >  EXPORT_SYMBOL(mlxsw_core_rx_listener_unregister);
> 
> + David S. Miller <davem@davemloft.net>
> + Jakub Kicinski <kuba@kernel.org>
> + netdev@vger.kernel.org

Impressive CC list. Please make a fresh posting to netdev@
and use ./scripts/get_maintainer.pl.
