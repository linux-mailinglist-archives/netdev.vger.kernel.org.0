Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2580CE90C8
	for <lists+netdev@lfdr.de>; Tue, 29 Oct 2019 21:27:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726861AbfJ2U1r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Oct 2019 16:27:47 -0400
Received: from relay5-d.mail.gandi.net ([217.70.183.197]:39049 "EHLO
        relay5-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725840AbfJ2U1r (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Oct 2019 16:27:47 -0400
X-Originating-IP: 209.85.217.44
Received: from mail-vs1-f44.google.com (mail-vs1-f44.google.com [209.85.217.44])
        (Authenticated sender: pshelar@ovn.org)
        by relay5-d.mail.gandi.net (Postfix) with ESMTPSA id 661C91C0003
        for <netdev@vger.kernel.org>; Tue, 29 Oct 2019 20:27:44 +0000 (UTC)
Received: by mail-vs1-f44.google.com with SMTP id l5so108375vsh.12
        for <netdev@vger.kernel.org>; Tue, 29 Oct 2019 13:27:44 -0700 (PDT)
X-Gm-Message-State: APjAAAXK5QiCUU1sZbmL1O/9UlNEUTpNKCtjWXKeweHBHHHhd/EEjv9k
        KdoioH98+69mq7hJ6+73PJjT/bees0tYNV6eBtQ=
X-Google-Smtp-Source: APXvYqwSWsJlwAE1sRK+CYN7cLgpZ6Z8Uf0Ld5pHHkF6t1eMsl4iablwcFfanr5fLMpxpSGUrOj5SO6dVE86h2I0xmU=
X-Received: by 2002:a67:2804:: with SMTP id o4mr2978192vso.47.1572380862914;
 Tue, 29 Oct 2019 13:27:42 -0700 (PDT)
MIME-Version: 1.0
References: <1571135440-24313-1-git-send-email-xiangxia.m.yue@gmail.com>
 <1571135440-24313-9-git-send-email-xiangxia.m.yue@gmail.com>
 <CAOrHB_B5dLuvoTxGpmaMiX9deEk9KjQHacqNKEpzHA2m5YS7jw@mail.gmail.com>
 <CAMDZJNWD=a+EBneEU-qs3pzXSBoOdzidn5cgOKs-y8G0UWvbnA@mail.gmail.com>
 <CAOrHB_BqGdFmmzTEPxejt0QXmyC_QtAXG=S8kzKi=3w-PacwUw@mail.gmail.com>
 <CAMDZJNXdu3R_GkHEBbwycEpe0wnwNmGzHx-8gUxtwiW1mEy7uw@mail.gmail.com>
 <CAOrHB_DdMX7sZkk79esdZkmb8RGaX_XiMAxhGz1LgWx50eFD9g@mail.gmail.com>
 <CAMDZJNVfyzmnd4qhp_esE-s3+-z8K=6tBP63X+SCEcjBon60eQ@mail.gmail.com>
 <CAOrHB_CnpcQoztqnfBkaDhTCK5nti8agtRmbbzZH+BfrPpiZ1g@mail.gmail.com>
 <CAMDZJNWeUoXD9SOBXfWes7Xk=BLRPs1iti+Kwz7YfC0NSE6oig@mail.gmail.com>
 <CAOrHB_BADQMdhFk4a8BJ0qaUeLf+2+H=cLf9q80U2g1AxewY2A@mail.gmail.com> <CAMDZJNWzsP+sb+pXbxEXFpYQLy6TJQ_eqaseC8v5YNbFDA844Q@mail.gmail.com>
In-Reply-To: <CAMDZJNWzsP+sb+pXbxEXFpYQLy6TJQ_eqaseC8v5YNbFDA844Q@mail.gmail.com>
From:   Pravin Shelar <pshelar@ovn.org>
Date:   Tue, 29 Oct 2019 13:27:31 -0700
X-Gmail-Original-Message-ID: <CAOrHB_CMX_heb+wfhiVWdc5Q1qLOTk8X0oz3TRPsci2yMb2=SA@mail.gmail.com>
Message-ID: <CAOrHB_CMX_heb+wfhiVWdc5Q1qLOTk8X0oz3TRPsci2yMb2=SA@mail.gmail.com>
Subject: Re: [PATCH net-next v4 08/10] net: openvswitch: fix possible memleak
 on destroy flow-table
To:     Tonghao Zhang <xiangxia.m.yue@gmail.com>
Cc:     Greg Rose <gvrose8192@gmail.com>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        ovs dev <dev@openvswitch.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 29, 2019 at 4:31 AM Tonghao Zhang <xiangxia.m.yue@gmail.com> wrote:
>
> On Tue, Oct 29, 2019 at 3:38 PM Pravin Shelar <pshelar@ovn.org> wrote:
> >
> > On Sun, Oct 27, 2019 at 11:49 PM Tonghao Zhang <xiangxia.m.yue@gmail.com> wrote:
> > >
> > > On Thu, Oct 24, 2019 at 3:14 PM Pravin Shelar <pshelar@ovn.org> wrote:
> > > >
> > > > On Tue, Oct 22, 2019 at 7:35 PM Tonghao Zhang <xiangxia.m.yue@gmail.com> wrote:
> > > > >
> > > > > On Tue, Oct 22, 2019 at 2:58 PM Pravin Shelar <pshelar@ovn.org> wrote:
> > > > > >
> > > > ...
> > > >
> > ...
> > > > >  struct sw_flow *ovs_flow_tbl_dump_next(struct table_instance *ti,
> > > > > @@ -400,10 +458,9 @@ static struct table_instance
> > > > > *table_instance_rehash(struct table_instance *ti,
> > > > >         return new_ti;
> > > > >  }
> > > > >
> > > > > -int ovs_flow_tbl_flush(struct flow_table *flow_table)
> > > > > +int ovs_flow_tbl_flush(struct flow_table *table)
> > > > >  {
> > > > > -       struct table_instance *old_ti, *new_ti;
> > > > > -       struct table_instance *old_ufid_ti, *new_ufid_ti;
> > > > > +       struct table_instance *new_ti, *new_ufid_ti;
> > > > >
> > > > >         new_ti = table_instance_alloc(TBL_MIN_BUCKETS);
> > > > >         if (!new_ti)
> > > > > @@ -412,16 +469,12 @@ int ovs_flow_tbl_flush(struct flow_table *flow_table)
> > > > >         if (!new_ufid_ti)
> > > > >                 goto err_free_ti;
> > > > >
> > > > > -       old_ti = ovsl_dereference(flow_table->ti);
> > > > > -       old_ufid_ti = ovsl_dereference(flow_table->ufid_ti);
> > > > > +       table_instance_destroy(table, true);
> > > > >
> > > > This would destroy running table causing unnecessary flow miss. Lets
> > > > keep current scheme of setting up new table before destroying current
> > > > one.
> > > >
> > > > > -       rcu_assign_pointer(flow_table->ti, new_ti);
> > ....
> > ...
> > >  /* Must be called with OVS mutex held. */
> > >  void ovs_flow_tbl_remove(struct flow_table *table, struct sw_flow *flow)
> > >  {
> > > @@ -752,17 +794,7 @@ void ovs_flow_tbl_remove(struct flow_table
> > > *table, struct sw_flow *flow)
> > >         struct table_instance *ufid_ti = ovsl_dereference(table->ufid_ti);
> > >
> > >         BUG_ON(table->count == 0);
> > > -       hlist_del_rcu(&flow->flow_table.node[ti->node_ver]);
> > > -       table->count--;
> > > -       if (ovs_identifier_is_ufid(&flow->id)) {
> > > -               hlist_del_rcu(&flow->ufid_table.node[ufid_ti->node_ver]);
> > > -               table->ufid_count--;
> > > -       }
> > > -
> > > -       /* RCU delete the mask. 'flow->mask' is not NULLed, as it should be
> > > -        * accessible as long as the RCU read lock is held.
> > > -        */
> > > -       flow_mask_remove(table, flow->mask);
> > > +       table_instance_remove(table, ti, ufid_ti, flow, true);
> > >  }
> > Lets rename table_instance_remove() to imply it is freeing a flow.
> hi Pravin, the function ovs_flow_free will free the flow actually. In
> -ovs_flow_cmd_del
> ovs_flow_tbl_remove
> ...
> ovs_flow_free
>
> In -table_instance_destroy
> table_instance_remove
> ovs_flow_free
>
> But if rename the table_instance_remove, table_instance_flow_free ?
table_instance_flow_free() looks good.
