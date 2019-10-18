Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 30C0DDCDA5
	for <lists+netdev@lfdr.de>; Fri, 18 Oct 2019 20:12:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2409403AbfJRSMb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Oct 2019 14:12:31 -0400
Received: from relay8-d.mail.gandi.net ([217.70.183.201]:45581 "EHLO
        relay8-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726534AbfJRSMa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Oct 2019 14:12:30 -0400
X-Originating-IP: 209.85.222.46
Received: from mail-ua1-f46.google.com (mail-ua1-f46.google.com [209.85.222.46])
        (Authenticated sender: pshelar@ovn.org)
        by relay8-d.mail.gandi.net (Postfix) with ESMTPSA id 400BE1BF20A
        for <netdev@vger.kernel.org>; Fri, 18 Oct 2019 18:12:28 +0000 (UTC)
Received: by mail-ua1-f46.google.com with SMTP id 107so1993433uau.5
        for <netdev@vger.kernel.org>; Fri, 18 Oct 2019 11:12:28 -0700 (PDT)
X-Gm-Message-State: APjAAAUYq/HG1EqWg0K+WSt2L+fd5A6XhhwcKKy6pNozwALWl15FQzvS
        xv4OWfyrkgoaICdzd2dpAheWDpEa8FMGl17GBDY=
X-Google-Smtp-Source: APXvYqzdgt1sQA+0nn+6AsOf089L2c5hVEWWToSUREKlwirJdTJBKmSaxTLbBP1hnjQFr1G5IDHVv9dXVRjl1SxVqUk=
X-Received: by 2002:ab0:3112:: with SMTP id e18mr5928255ual.22.1571422346683;
 Fri, 18 Oct 2019 11:12:26 -0700 (PDT)
MIME-Version: 1.0
References: <1571135440-24313-1-git-send-email-xiangxia.m.yue@gmail.com>
 <1571135440-24313-9-git-send-email-xiangxia.m.yue@gmail.com>
 <CAOrHB_B5dLuvoTxGpmaMiX9deEk9KjQHacqNKEpzHA2m5YS7jw@mail.gmail.com> <CAMDZJNWD=a+EBneEU-qs3pzXSBoOdzidn5cgOKs-y8G0UWvbnA@mail.gmail.com>
In-Reply-To: <CAMDZJNWD=a+EBneEU-qs3pzXSBoOdzidn5cgOKs-y8G0UWvbnA@mail.gmail.com>
From:   Pravin Shelar <pshelar@ovn.org>
Date:   Fri, 18 Oct 2019 11:12:16 -0700
X-Gmail-Original-Message-ID: <CAOrHB_BqGdFmmzTEPxejt0QXmyC_QtAXG=S8kzKi=3w-PacwUw@mail.gmail.com>
Message-ID: <CAOrHB_BqGdFmmzTEPxejt0QXmyC_QtAXG=S8kzKi=3w-PacwUw@mail.gmail.com>
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

On Thu, Oct 17, 2019 at 8:16 PM Tonghao Zhang <xiangxia.m.yue@gmail.com> wrote:
>
> On Fri, Oct 18, 2019 at 6:38 AM Pravin Shelar <pshelar@ovn.org> wrote:
> >
> > On Wed, Oct 16, 2019 at 5:50 AM <xiangxia.m.yue@gmail.com> wrote:
> > >
> > > From: Tonghao Zhang <xiangxia.m.yue@gmail.com>
> > >
> > > When we destroy the flow tables which may contain the flow_mask,
> > > so release the flow mask struct.
> > >
> > > Signed-off-by: Tonghao Zhang <xiangxia.m.yue@gmail.com>
> > > Tested-by: Greg Rose <gvrose8192@gmail.com>
> > > ---
> > >  net/openvswitch/flow_table.c | 14 +++++++++++++-
> > >  1 file changed, 13 insertions(+), 1 deletion(-)
> > >
> > > diff --git a/net/openvswitch/flow_table.c b/net/openvswitch/flow_table.c
> > > index 5df5182..d5d768e 100644
> > > --- a/net/openvswitch/flow_table.c
> > > +++ b/net/openvswitch/flow_table.c
> > > @@ -295,6 +295,18 @@ static void table_instance_destroy(struct table_instance *ti,
> > >         }
> > >  }
> > >
> > > +static void tbl_mask_array_destroy(struct flow_table *tbl)
> > > +{
> > > +       struct mask_array *ma = ovsl_dereference(tbl->mask_array);
> > > +       int i;
> > > +
> > > +       /* Free the flow-mask and kfree_rcu the NULL is allowed. */
> > > +       for (i = 0; i < ma->max; i++)
> > > +               kfree_rcu(rcu_dereference_raw(ma->masks[i]), rcu);
> > > +
> > > +       kfree_rcu(rcu_dereference_raw(tbl->mask_array), rcu);
> > > +}
> > > +
> > >  /* No need for locking this function is called from RCU callback or
> > >   * error path.
> > >   */
> > > @@ -304,7 +316,7 @@ void ovs_flow_tbl_destroy(struct flow_table *table)
> > >         struct table_instance *ufid_ti = rcu_dereference_raw(table->ufid_ti);
> > >
> > >         free_percpu(table->mask_cache);
> > > -       kfree_rcu(rcu_dereference_raw(table->mask_array), rcu);
> > > +       tbl_mask_array_destroy(table);
> > >         table_instance_destroy(ti, ufid_ti, false);
> > >  }
> >
> > This should not be required. mask is linked to a flow and gets
> > released when flow is removed.
> > Does the memory leak occur when OVS module is abruptly unloaded and
> > userspace does not cleanup flow table?
> When we destroy the ovs datapath or net namespace is destroyed , the
> mask memory will be happened. The call tree:
> ovs_exit_net/ovs_dp_cmd_del
> -->__dp_destroy
> -->destroy_dp_rcu
> -->ovs_flow_tbl_destroy
> -->table_instance_destroy (which don't release the mask memory because
> don't call the ovs_flow_tbl_remove /flow_mask_remove directly or
> indirectly).
>
Thats what I suggested earlier, we need to call function similar to
ovs_flow_tbl_remove(), we could refactor code to use the code.
This is better since by introducing tbl_mask_array_destroy() is
creating a dangling pointer to mask in sw-flow object. OVS is anyway
iterating entire flow table to release sw-flow in
table_instance_destroy(), it is natural to release mask at that point
after releasing corresponding sw-flow.



> but one thing, when we flush the flow, we don't flush the mask flow.(
> If necessary, one patch should be sent)
>
> > In that case better fix could be calling ovs_flow_tbl_remove()
> > equivalent from table_instance_destroy when it is iterating flow
> > table.
> I think operation of  the flow mask and flow table should use
> different API, for example:
> for flow mask, we use the:
> -tbl_mask_array_add_mask
> -tbl_mask_array_del_mask
> -tbl_mask_array_alloc
> -tbl_mask_array_realloc
> -tbl_mask_array_destroy(this patch introduce.)
>
> table instance:
> -table_instance_alloc
> -table_instance_destroy
> ....
