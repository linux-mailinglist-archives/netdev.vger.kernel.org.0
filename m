Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E8CA835E91F
	for <lists+netdev@lfdr.de>; Wed, 14 Apr 2021 00:40:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347524AbhDMWkq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Apr 2021 18:40:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:35146 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232745AbhDMWkq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 13 Apr 2021 18:40:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 78881611CE;
        Tue, 13 Apr 2021 22:40:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618353625;
        bh=OlD0GdQ8fYEYnqnPf3/vEO9T3vKOZDIYrRn3R/+DkRs=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=E+bj3mKJhrGwrA1ZQAeWPb0bo6nv6fd63b+2mNC0NCk10sp/Iqi3WW6/7jLU1ngme
         dbt6jAHuoqHS6+Y8lNBUNgxwM4Oim8WkGzc4JmC+826w5+8BEYHgnVQNWSoviW01El
         0vJctZGKo7Dnkw7U0X/P/+8OyExQULGZL6hj15wzvlzgZf4HeDS+R7TTEni7o9dRMR
         FfynLj/tvjwBV0MGB1tI5vyrwgAMQt2Vzl2zvjlikI1NjSZ9IO6uHoFcesdnH1romc
         mplMbKr9cKTHPpiU7WfmyAQ7UXqWX2ZeR7L6QLOMKWNXvkW8KE551woShTq2VKZez8
         n23wJDrWzwCuQ==
Message-ID: <8b3e437e15bfd7f063b41b17ea32311d084a92bc.camel@kernel.org>
Subject: Re: [net-next 01/16] net/mlx5: E-Switch, let user to enable disable
 metadata
From:   Saeed Mahameed <saeed@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Parav Pandit <parav@nvidia.com>, Roi Dayan <roid@nvidia.com>,
        Vu Pham <vuhuong@nvidia.com>
Date:   Tue, 13 Apr 2021 15:40:24 -0700
In-Reply-To: <20210413132142.0e2d1752@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <20210413193006.21650-1-saeed@kernel.org>
         <20210413193006.21650-2-saeed@kernel.org>
         <20210413132142.0e2d1752@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.38.4 (3.38.4-1.fc33) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 2021-04-13 at 13:21 -0700, Jakub Kicinski wrote:
> On Tue, 13 Apr 2021 12:29:51 -0700 Saeed Mahameed wrote:
> > Currently each packet inserted in eswitch is tagged with a internal
> > metadata to indicate source vport. Metadata tagging is not always
> > needed. Metadata insertion is needed for multi-port RoCE, failover
> > between representors and stacked devices. In many other cases,
> > metadata enablement is not needed.
> > 
> > Metadata insertion slows down the packet processing rate.
> 
> Can you share example numbers?

I remember it was substantial, i don't know the exact numbers. it might
depend on the use case: Parav, do you know ?

> 
> > Hence, allow user to disable metadata using driver specific devlink
> > parameter.
> > 
> > Example to show and disable metadata before changing eswitch mode:
> > $ devlink dev param show pci/0000:06:00.0 name esw_port_metadata
> > pci/0000:06:00.0:
> >   name esw_port_metadata type driver-specific
> >     values:
> >       cmode runtime value true
> > 
> > $ devlink dev param set pci/0000:06:00.0 \
> >           name esw_port_metadata value false cmode runtime
> > 
> > $ devlink dev eswitch set pci/0000:06:00.0 mode switchdev
> 
> Is this something that only gets enabled when device is put into
> switchdev mode? That needs to be clarified in the documentation IMO 
> to give peace of mind to all users who don't enable switchdev.

Currently this is always enabled when switchdev is turned on, it
affects the whole operation mode of the FDB and the offloaded flows so
it can't be dynamic, it must be decided before user enables switchdev,
it is needed only to allow LAG use cases, hence we add a disable knob
for those who don't want LAG and could use some more packet rate.

Some documentation was pushed as part of this patch:
please let me know if it needs improvement. (maybe we should add the
benefit of packet rate ?)


 .../device_drivers/ethernet/mellanox/mlx5.rst | 23 +++++++

+esw_port_metadata: Eswitch port metadata state
+----------------------------------------------
+Eswitch port metadata state controls whether to internally tag packet
with metadata or not.
+Metadata tagging must be enabled for multi-port RoCE, failover between
representors and stacked devices.
+By default metadata is enabled on the supported devices. When metadata
usage is not needed,
+user can disable metadata tagging before moving the eswitch to
switchdev mode.

