Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 56152640B0
	for <lists+netdev@lfdr.de>; Wed, 10 Jul 2019 07:27:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727087AbfGJF1w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Jul 2019 01:27:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:49908 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725932AbfGJF1v (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 10 Jul 2019 01:27:51 -0400
Received: from localhost (unknown [37.142.3.125])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3709A20665;
        Wed, 10 Jul 2019 05:27:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562736470;
        bh=7L1PogGoEpn5Kd8aneV8mLaxZSNCTpPPc2eMzKiOKO8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Fao99MZDLEPFpKcxGrLYlGStt4Rk2hTF5HhRtch8AOxm+g9/mUQ/wO5/Z3zZmnlEr
         2nNEaOsqg3pxr4Gn58O/0DyiAcnOnw6tThQ6oqSpJEmmdRH3R/v8zLiP0vXX9c+LKb
         bAriiEFNCFE2oNeIpB5PBb6sdD0EeZuV/ykrW8Xo=
Date:   Wed, 10 Jul 2019 08:27:46 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Saeed Mahameed <saeedm@mellanox.com>
Cc:     "saeedm@dev.mellanox.co.il" <saeedm@dev.mellanox.co.il>,
        Eran Ben Elisha <eranbe@mellanox.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        Tariq Toukan <tariqt@mellanox.com>
Subject: Re: [PATCH mlx5-next 4/5] net/mlx5: Introduce TLS TX offload
 hardware bits and structures
Message-ID: <20190710052746.GE7034@mtr-leonro.mtl.com>
References: <20190703073909.14965-1-saeedm@mellanox.com>
 <20190703073909.14965-5-saeedm@mellanox.com>
 <20190703092735.GZ4727@mtr-leonro.mtl.com>
 <CALzJLG-em1w+Lgf2UutbG2Lzq8bx3zUqoLGx26H2_EXOuuk+jg@mail.gmail.com>
 <20190704171519.GE7212@mtr-leonro.mtl.com>
 <CALzJLG--k3z2HuV09tivJuOtU-BFAyCEV1vJbPqYX+OyskggmQ@mail.gmail.com>
 <20190704182113.GG7212@mtr-leonro.mtl.com>
 <c5cc4604e5759e5b8a056a3baefb8a3d3caf4f74.camel@mellanox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c5cc4604e5759e5b8a056a3baefb8a3d3caf4f74.camel@mellanox.com>
User-Agent: Mutt/1.12.0 (2019-05-25)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 09, 2019 at 08:54:58PM +0000, Saeed Mahameed wrote:
> On Thu, 2019-07-04 at 21:21 +0300, Leon Romanovsky wrote:
> > On Thu, Jul 04, 2019 at 01:21:04PM -0400, Saeed Mahameed wrote:
> > > On Thu, Jul 4, 2019 at 1:15 PM Leon Romanovsky <leon@kernel.org>
> > > wrote:
> > > > On Thu, Jul 04, 2019 at 01:06:58PM -0400, Saeed Mahameed wrote:
> > > > > On Wed, Jul 3, 2019 at 5:27 AM <leon@kernel.org> wrote:
> > > > > > On Wed, Jul 03, 2019 at 07:39:32AM +0000, Saeed Mahameed
> > > > > > wrote:
> > > > > > > From: Eran Ben Elisha <eranbe@mellanox.com>
> > > > > > >
> > > > > > > Add TLS offload related IFC structs, layouts and
> > > > > > > enumerations.
> > > > > > >
> > > > > > > Signed-off-by: Eran Ben Elisha <eranbe@mellanox.com>
> > > > > > > Signed-off-by: Tariq Toukan <tariqt@mellanox.com>
> > > > > > > Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
> > > > > > > ---
> > > > > > >  include/linux/mlx5/device.h   |  14 +++++
> > > > > > >  include/linux/mlx5/mlx5_ifc.h | 104
> > > > > > > ++++++++++++++++++++++++++++++++--
> > > > > > >  2 files changed, 114 insertions(+), 4 deletions(-)
> > > > > >
> > > > > > <...>
> > > > > >
> > > > > > > @@ -2725,7 +2739,8 @@ struct mlx5_ifc_traffic_counter_bits
> > > > > > > {
> > > > > > >
> > > > > > >  struct mlx5_ifc_tisc_bits {
> > > > > > >       u8         strict_lag_tx_port_affinity[0x1];
> > > > > > > -     u8         reserved_at_1[0x3];
> > > > > > > +     u8         tls_en[0x1];
> > > > > > > +     u8         reserved_at_1[0x2];
> > > > > >
> > > > > > It should be reserved_at_2.
> > > > > >
> > > > >
> > > > > it should be at_1.
> > > >
> > > > Why? See mlx5_ifc_flow_table_prop_layout_bits,
> > > > mlx5_ifc_roce_cap_bits, e.t.c.
> > > >
> > >
> > > they are all at_1 .. so i don't really understand what you want
> > > from me,
> > > Leon the code is good, please double check you comments..
> >
> > Saeed,
> >
> > reserved_at_1 should be renamed to be reserved_at_2.
> >
> > strict_lag_tx_port_affinity[0x1] + tls_en[0x1] = 0x2
> >
>
> Ok now it is clear, i trusted the developer on this one :)
> anyway you have to admit that you mislead me with your examples:
> mx5_ifc_flow_table_prop_layout_bits and mlx5_ifc_roce_cap_bits, they
> both are fine so i though this was fine too.
>
> I will fix it up.

Thanks

>
> Thanks,
> Saeed.
>
> > > > Thanks
> > > >
> > > > > > Thanks
