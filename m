Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 567A221BBFA
	for <lists+netdev@lfdr.de>; Fri, 10 Jul 2020 19:13:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728089AbgGJRNf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jul 2020 13:13:35 -0400
Received: from correo.us.es ([193.147.175.20]:35036 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728068AbgGJRNe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 10 Jul 2020 13:13:34 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id D72B6E7808
        for <netdev@vger.kernel.org>; Fri, 10 Jul 2020 19:13:30 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id BA76DDA855
        for <netdev@vger.kernel.org>; Fri, 10 Jul 2020 19:13:30 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id A5A3DDA844; Fri, 10 Jul 2020 19:13:30 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,URIBL_BLOCKED,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 3D5A0DA722;
        Fri, 10 Jul 2020 19:13:28 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Fri, 10 Jul 2020 19:13:28 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 0210242EE38F;
        Fri, 10 Jul 2020 19:13:27 +0200 (CEST)
Date:   Fri, 10 Jul 2020 19:13:27 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Petr Machata <petrm@mellanox.com>
Cc:     Ido Schimmel <idosch@idosch.org>, netdev@vger.kernel.org,
        davem@davemloft.net, kuba@kernel.org, jiri@mellanox.com,
        mlxsw@mellanox.com, michael.chan@broadcom.com, saeedm@mellanox.com,
        leon@kernel.org, kadlec@netfilter.org, fw@strlen.de,
        jhs@mojatatu.com, xiyou.wangcong@gmail.com,
        simon.horman@netronome.com, Ido Schimmel <idosch@mellanox.com>
Subject: Re: [PATCH net-next 01/13] net: sched: Pass qdisc reference in
 struct flow_block_offload
Message-ID: <20200710171327.GA15481@salvia>
References: <20200710135706.601409-1-idosch@idosch.org>
 <20200710135706.601409-2-idosch@idosch.org>
 <20200710141500.GA12659@salvia>
 <87sgdzflk4.fsf@mellanox.com>
 <20200710152648.GA14902@salvia>
 <87r1tjfihg.fsf@mellanox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87r1tjfihg.fsf@mellanox.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 10, 2020 at 06:22:03PM +0200, Petr Machata wrote:
> 
> Pablo Neira Ayuso <pablo@netfilter.org> writes:
> 
> >> >> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/rep/tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en/rep/tc.c
> >> >> index eefeb1cdc2ee..4fc42c1955ff 100644
> >> >> --- a/drivers/net/ethernet/mellanox/mlx5/core/en/rep/tc.c
> >> >> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en/rep/tc.c
> >> >> @@ -404,7 +404,7 @@ static void mlx5e_rep_indr_block_unbind(void *cb_priv)
> >> >>  static LIST_HEAD(mlx5e_block_cb_list);
> >> >>
> >> >>  static int
> >> >> -mlx5e_rep_indr_setup_block(struct net_device *netdev,
> >> >> +mlx5e_rep_indr_setup_block(struct Qdisc *sch,
> >> >>  			   struct mlx5e_rep_priv *rpriv,
> >> >>  			   struct flow_block_offload *f,
> >> >>  			   flow_setup_cb_t *setup_cb,
> >> >> @@ -412,6 +412,7 @@ mlx5e_rep_indr_setup_block(struct net_device *netdev,
> >> >>  			   void (*cleanup)(struct flow_block_cb *block_cb))
> >> >>  {
> >> >>  	struct mlx5e_priv *priv = netdev_priv(rpriv->netdev);
> >> >> +	struct net_device *netdev = sch->dev_queue->dev;
> >> >
> >> > This break indirect block support for netfilter since the driver
> >> > is assuming a Qdisc object.
> >>
> >> Sorry, I don't follow. You mean mlx5 driver? What does it mean to
> >> "assume a qdisc object"?
> >>
> >> Is it incorrect to rely on the fact that the netdevice can be deduced
> >> from a qdisc, or that there is always a qdisc associated with a block
> >> binding point?
> >
> > The drivers assume that the xyz_indr_setup_block() always gets a sch
> > object, which is not always true. Are you really sure this will work
> > for the TC CT offload?
> 
> I tested indirect blocks in general, but not CT offload.
> 
> > --- a/net/netfilter/nf_flow_table_offload.c
> > +++ b/net/netfilter/nf_flow_table_offload.c
> > @@ -928,26 +928,27 @@ static int nf_flow_table_block_setup(struct nf_flowtable *flowtable,
> >  }
> >
> >  static void nf_flow_table_block_offload_init(struct flow_block_offload *bo,
> > -                                            struct net *net,
> > +                                            struct net_device *dev,
> >                                              enum flow_block_command cmd,
> >                                              struct nf_flowtable *flowtable,
> >                                              struct netlink_ext_ack *extack)
> >  {
> >         memset(bo, 0, sizeof(*bo));
> > -       bo->net         = net;
> > +       bo->net         = dev_net(dev);
> >         bo->block       = &flowtable->flow_block;
> >         bo->command     = cmd;
> >         bo->binder_type = FLOW_BLOCK_BINDER_TYPE_CLSACT_INGRESS;
> >         bo->extack      = extack;
> > +       bo->sch         = dev_ingress_queue(dev)->qdisc_sleeping;
> >         INIT_LIST_HEAD(&bo->cb_list);
> >  }
> >
> >  static void nf_flow_table_indr_cleanup(struct flow_block_cb *block_cb)
> >  {
> >         struct nf_flowtable *flowtable = block_cb->indr.data;
> > -       struct net_device *dev = block_cb->indr.dev;
> > +       struct Qdisc *sch = block_cb->indr.sch;
> >
> > -       nf_flow_table_gc_cleanup(flowtable, dev);
> > +       nf_flow_table_gc_cleanup(flowtable, sch->dev_queue->dev);
> >         down_write(&flowtable->flow_block_lock);
> >         list_del(&block_cb->list);
> >         list_del(&block_cb->driver_list);
> >
> > Moreover, the flow_offload infrastructure should also remain
> > independent from the front-end, either tc/netfilter/ethtool, this is
> > pulling in tc specific stuff into it, eg.
> 
> Hmm, OK, so I should not have assumed there is always a qdisc associated
> with a blocks.
> 
> I'm not sure how strong your objection to pulling in TC is. Would it be
> OK, instead of replacing the device with a qdisc in flow_block_indr, to
> put in both? The qdisc can be NULL for the "normal" binder types,
> because there the block is uniquely identified just by the type. For the
> "non-normal" ones it would be obvious how to initialize it.

Adding an extra field to flow_block_indr instead of replacing struct
net_device should be ok for your new qevent use-case, right? This new
Qdisc field will be NULL for the existing use-cases, that is what you
mean, correct?

I still did not have a look at this new qevent infrastructure, so I
don't have a better proposal right now.

Thanks.
