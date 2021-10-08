Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5DE10426174
	for <lists+netdev@lfdr.de>; Fri,  8 Oct 2021 02:44:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234360AbhJHAqs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Oct 2021 20:46:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:53052 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229487AbhJHAqr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 7 Oct 2021 20:46:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 12D3A61056;
        Fri,  8 Oct 2021 00:44:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633653892;
        bh=3Nq6CakiX02/jiCPVuoYRZGiZcNauO7mQNhGl4vQgNA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=tDeRF1qEnthEbVTxHG0t/sK+HKOtE0Fi7Nm6p0lRSVE4URBRZO/E32Y9+qtAslNo5
         sUbsLuZWp5y87qDQ6jTRbZTeroVkHMeXoRDWVIYI4spC48JoE7sfg6SvvX27QxfAXO
         oBeGJ60rRYEOf9QFeO48rFW/0qVNmZ6mK3apXgPZ2AenwJTg18648sq/YDcbdvTNCV
         SPRX/g2SAjFGQqbOy/CsS+bpul7u/ACoTMx3TtDvp3W+so74SsEOOclnhJlzi061RQ
         Pu5Gq0FT5fkVBKH7wWHhBuzC0gu7b+njVP4aox7k5SZG9nj/xhsH382A5jFnruCoE6
         WjWouylgRMj+Q==
Date:   Fri, 8 Oct 2021 03:44:48 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Ido Schimmel <idosch@nvidia.com>,
        Ingo Molnar <mingo@redhat.com>, Jiri Pirko <jiri@nvidia.com>,
        linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org,
        mlxsw@nvidia.com, Moshe Shemesh <moshe@nvidia.com>,
        netdev@vger.kernel.org, Saeed Mahameed <saeedm@nvidia.com>,
        Salil Mehta <salil.mehta@huawei.com>,
        Shay Drory <shayd@nvidia.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        Yisen Zhuang <yisen.zhuang@huawei.com>
Subject: Re: [PATCH net-next v3 1/5] devlink: Reduce struct devlink exposure
Message-ID: <YV+UgAEYz2GH8LIW@unreal>
References: <cover.1633589385.git.leonro@nvidia.com>
 <39692583a2aace1b9e435399344f097c72073522.1633589385.git.leonro@nvidia.com>
 <20211007155800.1ff26948@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211007155800.1ff26948@gandalf.local.home>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 07, 2021 at 03:58:00PM -0400, Steven Rostedt wrote:
> On Thu,  7 Oct 2021 09:55:15 +0300
> Leon Romanovsky <leon@kernel.org> wrote:
> 
> > +void *devlink_priv(struct devlink *devlink)
> > +{
> > +	BUG_ON(!devlink);
> 
> Do we really want to bring down the kernel in this case?

It was before.

> 
> Can't we just have:
> 
> 	if (WARN_ON(!devlink))
> 		return NULL;
> ?

Callers of devlink_priv() are not prepared to have NULL here, they don't
check return value at all,and this BUG_ON() can't happen at all.

> 
> Same for the below as well.

I can send followup patch.

Thanks

> 
> -- Steve
> 
> > +	return &devlink->priv;
> > +}
> > +EXPORT_SYMBOL_GPL(devlink_priv);
> > +
> > +struct devlink *priv_to_devlink(void *priv)
> > +{
> > +	BUG_ON(!priv);
> > +	return container_of(priv, struct devlink, priv);
> > +}
> > +EXPORT_SYMBOL_GPL(priv_to_devlink);
> > +
> > +struct device *devlink_to_dev(const struct devlink *devlink)
> > +{
> > +	return devlink->dev;
> > +}
> > +EXPORT_SYMBOL_GPL(devlink_to_dev);
> > +
