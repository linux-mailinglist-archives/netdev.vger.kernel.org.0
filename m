Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F11BF3380CF
	for <lists+netdev@lfdr.de>; Thu, 11 Mar 2021 23:48:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229470AbhCKWsI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Mar 2021 17:48:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:35692 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229441AbhCKWrh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 11 Mar 2021 17:47:37 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A765364F26;
        Thu, 11 Mar 2021 22:47:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615502857;
        bh=znxGQDEfaNjJ9FvCpPXHmW8UlMkQWmL7z0g6+7T7k0Q=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=Sr6l3pH2hMyxOHx1cuZeCD+iY++93Z2HfNEn8118gKUNSv1cGFQ3CV5i/GwXVa1hy
         WwEnLYSyrcvN/0v3DwAP62SI8XTwXBjS+VlGwlE9sfHJqPeM1/gFe+f3nC/5afIy+F
         T02T5c6nTCrwu6I8oAwcxnbqHwO1DxyNX2wCh/HwnlEYLgc2uGUUP1RuWa6BARb+Sx
         75ZRniw66AtVGm/FTkub8x42E7T7tDHIP+0WagDpfM+GKapm0No1q9FjWf+3zZ7/SI
         8fkeZQjsYErsizqYrdZduJR7uZD2G9zpj5KT6eiAujig3cei1bi5Or693rqyb8zC36
         AfXODcSuXHtqw==
Message-ID: <5e0ba8e23231eb15e6f1dbfa9759b3aa94267193.camel@kernel.org>
Subject: Re: [PATCH] net: mellanox: mlx5: fix error return code of
 mlx5e_stats_flower()
From:   Saeed Mahameed <saeed@kernel.org>
To:     Roi Dayan <roid@nvidia.com>, Jia-Ju Bai <baijiaju1990@gmail.com>,
        leon@kernel.org, davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date:   Thu, 11 Mar 2021 14:47:35 -0800
In-Reply-To: <78a83112-2978-42e9-a90e-c8bee0389fd8@nvidia.com>
References: <20210306134718.17566-1-baijiaju1990@gmail.com>
         <99807217-c2a3-928f-4c8c-2195f3500594@nvidia.com>
         <1fdf71d7-7a54-0b69-3339-e792dd03b2c8@nvidia.com>
         <3a1a2089-a7fa-2a7c-7040-c0aa62b08960@gmail.com>
         <78a83112-2978-42e9-a90e-c8bee0389fd8@nvidia.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.38.4 (3.38.4-1.fc33) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 2021-03-09 at 11:44 +0200, Roi Dayan wrote:
> 
> 
> On 2021-03-09 10:32 AM, Jia-Ju Bai wrote:
> > 
> > 
> > On 2021/3/9 16:24, Roi Dayan wrote:
> > > 
> > > 
> > > On 2021-03-09 10:20 AM, Roi Dayan wrote:
> > > > 
> > > > 
> > > > On 2021-03-06 3:47 PM, Jia-Ju Bai wrote:
> > > > > When mlx5e_tc_get_counter() returns NULL to counter or
> > > > > mlx5_devcom_get_peer_data() returns NULL to peer_esw, no
> > > > > error return
> > > > > code of mlx5e_stats_flower() is assigned.
> > > > > To fix this bug, err is assigned with -EINVAL in these cases.
> > > > > 
> > > > > Reported-by: TOTE Robot <oslab@tsinghua.edu.cn>

Hey Jia-Ju, What are the conditions for this robot to raise a flag?
sometimes it is totally normal to abort a function and return 0.. i am
just curious to know ? 


> > > > > Signed-off-by: Jia-Ju Bai <baijiaju1990@gmail.com>
> > > > > ---
> > > > >   drivers/net/ethernet/mellanox/mlx5/core/en_tc.c | 12
> > > > > +++++++++---
> > > > >   1 file changed, 9 insertions(+), 3 deletions(-)
> > > > > 
> > > > > diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c 
> > > > > b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
> > > > > index 0da69b98f38f..1f2c9da7bd35 100644
> > > > > --- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
> > > > > +++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
> > > > > @@ -4380,8 +4380,10 @@ int mlx5e_stats_flower(struct
> > > > > net_device 
> > > > > *dev, struct mlx5e_priv *priv,
> > > > >       if (mlx5e_is_offloaded_flow(flow) ||
> > > > > flow_flag_test(flow, CT)) {
> > > > >           counter = mlx5e_tc_get_counter(flow);
> > > > > -        if (!counter)
> > > > > +        if (!counter) {
> > > > > +            err = -EINVAL;
> > > > >               goto errout;
> > > > > +        }
> > > > >           mlx5_fc_query_cached(counter, &bytes, &packets,
> > > > > &lastuse);
> > > > >       }
> > > > > @@ -4390,8 +4392,10 @@ int mlx5e_stats_flower(struct
> > > > > net_device 
> > > > > *dev, struct mlx5e_priv *priv,
> > > > >        * un-offloaded while the other rule is offloaded.
> > > > >        */
> > > > >       peer_esw = mlx5_devcom_get_peer_data(devcom, 
> > > > > MLX5_DEVCOM_ESW_OFFLOADS);
> > > > > -    if (!peer_esw)
> > > > > +    if (!peer_esw) {
> > > > > +        err = -EINVAL;
> > > > 

This is not an error flow, i am curious what are the thresholds of this
robot ?

> > > > note here it's not an error. it could be there is no peer esw
> > > > so just continue with the stats update.
> > > > 
> > > > >           goto out;
> > > > > +    }
> > > > >       if (flow_flag_test(flow, DUP) &&
> > > > >           flow_flag_test(flow->peer_flow, OFFLOADED)) {
> > > > > @@ -4400,8 +4404,10 @@ int mlx5e_stats_flower(struct
> > > > > net_device 
> > > > > *dev, struct mlx5e_priv *priv,
> > > > >           u64 lastuse2;
> > > > >           counter = mlx5e_tc_get_counter(flow->peer_flow);
> > > > > -        if (!counter)
> > > > > +        if (!counter) {
> > > > > +            err = -EINVAL;
> > > 
> > > this change is problematic. the current goto is to do stats
> > > update with
> > > the first counter stats we got but if you now want to return an
> > > error
> > > then you probably should not do any update at all.
> > 
> > Thanks for your reply :)
> > I am not sure whether an error code should be returned here?
> > If so, flow_stats_update(...) should not be called here?
> > 
> > 
> > Best wishes,
> > Jia-Ju Bai
> > 
> 
> basically flow and peer_flow should be valid and protected from
> changes,
> and counter should be valid.
> it looks like the check here is more of a sanity check if something
> goes
> wrong but shouldn't. you can just let it be, update the stats from
> the
> first queried counter.
> 

Roi, let's consider returning an error code here, we shouldn't be
silently returning if we are not expecting these errors, 

why would mlx5e_stats_flower() be called if stats are not offloaded ?

Thanks,
Saeed.


