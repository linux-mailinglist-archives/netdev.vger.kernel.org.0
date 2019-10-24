Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F133AE2AD9
	for <lists+netdev@lfdr.de>; Thu, 24 Oct 2019 09:14:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437890AbfJXHOW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Oct 2019 03:14:22 -0400
Received: from relay6-d.mail.gandi.net ([217.70.183.198]:38003 "EHLO
        relay6-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2437885AbfJXHOW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Oct 2019 03:14:22 -0400
X-Originating-IP: 209.85.217.41
Received: from mail-vs1-f41.google.com (mail-vs1-f41.google.com [209.85.217.41])
        (Authenticated sender: pshelar@ovn.org)
        by relay6-d.mail.gandi.net (Postfix) with ESMTPSA id 623B0C0008
        for <netdev@vger.kernel.org>; Thu, 24 Oct 2019 07:14:19 +0000 (UTC)
Received: by mail-vs1-f41.google.com with SMTP id p13so15568892vso.0
        for <netdev@vger.kernel.org>; Thu, 24 Oct 2019 00:14:19 -0700 (PDT)
X-Gm-Message-State: APjAAAU6DJ1cFMNrwu6v4t2kSwSmAct++eE9p7ecPRdOrs1LIxWfP6vE
        hRziYcplDRET3lUmp104JM97WrReyg9Nf2vUuFs=
X-Google-Smtp-Source: APXvYqw4uM2QcA998qBLdNKPghx//wuzVhGMBwesp7JxKNICgAUGHpM8i522qqfpZfCiLAKrUKQyr++xjXHs1A8H1qg=
X-Received: by 2002:a67:ec8f:: with SMTP id h15mr7943906vsp.66.1571901257917;
 Thu, 24 Oct 2019 00:14:17 -0700 (PDT)
MIME-Version: 1.0
References: <1571135440-24313-1-git-send-email-xiangxia.m.yue@gmail.com>
 <1571135440-24313-9-git-send-email-xiangxia.m.yue@gmail.com>
 <CAOrHB_B5dLuvoTxGpmaMiX9deEk9KjQHacqNKEpzHA2m5YS7jw@mail.gmail.com>
 <CAMDZJNWD=a+EBneEU-qs3pzXSBoOdzidn5cgOKs-y8G0UWvbnA@mail.gmail.com>
 <CAOrHB_BqGdFmmzTEPxejt0QXmyC_QtAXG=S8kzKi=3w-PacwUw@mail.gmail.com>
 <CAMDZJNXdu3R_GkHEBbwycEpe0wnwNmGzHx-8gUxtwiW1mEy7uw@mail.gmail.com>
 <CAOrHB_DdMX7sZkk79esdZkmb8RGaX_XiMAxhGz1LgWx50eFD9g@mail.gmail.com> <CAMDZJNVfyzmnd4qhp_esE-s3+-z8K=6tBP63X+SCEcjBon60eQ@mail.gmail.com>
In-Reply-To: <CAMDZJNVfyzmnd4qhp_esE-s3+-z8K=6tBP63X+SCEcjBon60eQ@mail.gmail.com>
From:   Pravin Shelar <pshelar@ovn.org>
Date:   Thu, 24 Oct 2019 00:14:07 -0700
X-Gmail-Original-Message-ID: <CAOrHB_CnpcQoztqnfBkaDhTCK5nti8agtRmbbzZH+BfrPpiZ1g@mail.gmail.com>
Message-ID: <CAOrHB_CnpcQoztqnfBkaDhTCK5nti8agtRmbbzZH+BfrPpiZ1g@mail.gmail.com>
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

On Tue, Oct 22, 2019 at 7:35 PM Tonghao Zhang <xiangxia.m.yue@gmail.com> wrote:
>
> On Tue, Oct 22, 2019 at 2:58 PM Pravin Shelar <pshelar@ovn.org> wrote:
> >
...

> > > >
> > Sure, I can review it, Can you send the patch inlined in mail?
> >
> > Thanks.
> diff --git a/net/openvswitch/flow_table.c b/net/openvswitch/flow_table.c
> index 5df5182..5b20793 100644
> --- a/net/openvswitch/flow_table.c
> +++ b/net/openvswitch/flow_table.c
> @@ -257,10 +257,75 @@ static void flow_tbl_destroy_rcu_cb(struct rcu_head *rcu)
>         __table_instance_destroy(ti);
>  }
>
> -static void table_instance_destroy(struct table_instance *ti,
> -                                  struct table_instance *ufid_ti,
> +static void tbl_mask_array_del_mask(struct flow_table *tbl,
> +                                   struct sw_flow_mask *mask)
> +{
> +       struct mask_array *ma = ovsl_dereference(tbl->mask_array);
> +       int i, ma_count = READ_ONCE(ma->count);
> +
> +       /* Remove the deleted mask pointers from the array */
> +       for (i = 0; i < ma_count; i++) {
> +               if (mask == ovsl_dereference(ma->masks[i]))
> +                       goto found;
> +       }
> +
> +       BUG();
> +       return;
> +
> +found:
> +       WRITE_ONCE(ma->count, ma_count -1);
> +
> +       rcu_assign_pointer(ma->masks[i], ma->masks[ma_count -1]);
> +       RCU_INIT_POINTER(ma->masks[ma_count -1], NULL);
> +
> +       kfree_rcu(mask, rcu);
> +
> +       /* Shrink the mask array if necessary. */
> +       if (ma->max >= (MASK_ARRAY_SIZE_MIN * 2) &&
> +           ma_count <= (ma->max / 3))
> +               tbl_mask_array_realloc(tbl, ma->max / 2);
> +}
> +
> +/* Remove 'mask' from the mask list, if it is not needed any more. */
> +static void flow_mask_remove(struct flow_table *tbl, struct sw_flow_mask *mask)
> +{
> +       if (mask) {
> +               /* ovs-lock is required to protect mask-refcount and
> +                * mask list.
> +                */
> +               ASSERT_OVSL();
> +               BUG_ON(!mask->ref_count);
> +               mask->ref_count--;
> +
> +               if (!mask->ref_count)
> +                       tbl_mask_array_del_mask(tbl, mask);
> +       }
> +}
> +
> +static void table_instance_remove(struct flow_table *table, struct
> sw_flow *flow)
> +{
> +       struct table_instance *ti = ovsl_dereference(table->ti);
> +       struct table_instance *ufid_ti = ovsl_dereference(table->ufid_ti);
> +
> +       BUG_ON(table->count == 0);
> +       hlist_del_rcu(&flow->flow_table.node[ti->node_ver]);
> +       table->count--;
> +       if (ovs_identifier_is_ufid(&flow->id)) {
> +               hlist_del_rcu(&flow->ufid_table.node[ufid_ti->node_ver]);
> +               table->ufid_count--;
> +       }
> +
> +       /* RCU delete the mask. 'flow->mask' is not NULLed, as it should be
> +        * accessible as long as the RCU read lock is held.
> +        */
> +       flow_mask_remove(table, flow->mask);
> +}
> +
> +static void table_instance_destroy(struct flow_table *table,
>                                    bool deferred)
>  {
> +       struct table_instance *ti = ovsl_dereference(table->ti);
> +       struct table_instance *ufid_ti = ovsl_dereference(table->ufid_ti);
>         int i;
>
>         if (!ti)
> @@ -274,13 +339,9 @@ static void table_instance_destroy(struct
> table_instance *ti,
>                 struct sw_flow *flow;
>                 struct hlist_head *head = &ti->buckets[i];
>                 struct hlist_node *n;
> -               int ver = ti->node_ver;
> -               int ufid_ver = ufid_ti->node_ver;
>
> -               hlist_for_each_entry_safe(flow, n, head, flow_table.node[ver]) {
> -                       hlist_del_rcu(&flow->flow_table.node[ver]);
> -                       if (ovs_identifier_is_ufid(&flow->id))
> -                               hlist_del_rcu(&flow->ufid_table.node[ufid_ver]);
> +               hlist_for_each_entry_safe(flow, n, head,
> flow_table.node[ti->node_ver]) {
> +                       table_instance_remove(table, flow);
>                         ovs_flow_free(flow, deferred);
>                 }
>         }
> @@ -300,12 +361,9 @@ static void table_instance_destroy(struct
> table_instance *ti,
>   */
>  void ovs_flow_tbl_destroy(struct flow_table *table)
>  {
> -       struct table_instance *ti = rcu_dereference_raw(table->ti);
> -       struct table_instance *ufid_ti = rcu_dereference_raw(table->ufid_ti);
> -
>         free_percpu(table->mask_cache);
>         kfree_rcu(rcu_dereference_raw(table->mask_array), rcu);
> -       table_instance_destroy(ti, ufid_ti, false);
> +       table_instance_destroy(table, false);
>  }
>
>  struct sw_flow *ovs_flow_tbl_dump_next(struct table_instance *ti,
> @@ -400,10 +458,9 @@ static struct table_instance
> *table_instance_rehash(struct table_instance *ti,
>         return new_ti;
>  }
>
> -int ovs_flow_tbl_flush(struct flow_table *flow_table)
> +int ovs_flow_tbl_flush(struct flow_table *table)
>  {
> -       struct table_instance *old_ti, *new_ti;
> -       struct table_instance *old_ufid_ti, *new_ufid_ti;
> +       struct table_instance *new_ti, *new_ufid_ti;
>
>         new_ti = table_instance_alloc(TBL_MIN_BUCKETS);
>         if (!new_ti)
> @@ -412,16 +469,12 @@ int ovs_flow_tbl_flush(struct flow_table *flow_table)
>         if (!new_ufid_ti)
>                 goto err_free_ti;
>
> -       old_ti = ovsl_dereference(flow_table->ti);
> -       old_ufid_ti = ovsl_dereference(flow_table->ufid_ti);
> +       table_instance_destroy(table, true);
>
This would destroy running table causing unnecessary flow miss. Lets
keep current scheme of setting up new table before destroying current
one.

> -       rcu_assign_pointer(flow_table->ti, new_ti);
> -       rcu_assign_pointer(flow_table->ufid_ti, new_ufid_ti);
> -       flow_table->last_rehash = jiffies;
> -       flow_table->count = 0;
> -       flow_table->ufid_count = 0;
> +       rcu_assign_pointer(table->ti, new_ti);
> +       rcu_assign_pointer(table->ufid_ti, new_ufid_ti);
> +       table->last_rehash = jiffies;
>
> -       table_instance_destroy(old_ti, old_ufid_ti, true);
>         return 0;
>
>  err_free_ti:
> @@ -700,69 +753,10 @@ static struct table_instance
> *table_instance_expand(struct table_instance *ti,
>         return table_instance_rehash(ti, ti->n_buckets * 2, ufid);
>  }
>
> -static void tbl_mask_array_del_mask(struct flow_table *tbl,
> -                                   struct sw_flow_mask *mask)
> -{
> -       struct mask_array *ma = ovsl_dereference(tbl->mask_array);
> -       int i, ma_count = READ_ONCE(ma->count);
> -
> -       /* Remove the deleted mask pointers from the array */
> -       for (i = 0; i < ma_count; i++) {
> -               if (mask == ovsl_dereference(ma->masks[i]))
> -                       goto found;
> -       }
> -
> -       BUG();
> -       return;
> -
> -found:
> -       WRITE_ONCE(ma->count, ma_count -1);
> -
> -       rcu_assign_pointer(ma->masks[i], ma->masks[ma_count -1]);
> -       RCU_INIT_POINTER(ma->masks[ma_count -1], NULL);
> -
> -       kfree_rcu(mask, rcu);
> -
> -       /* Shrink the mask array if necessary. */
> -       if (ma->max >= (MASK_ARRAY_SIZE_MIN * 2) &&
> -           ma_count <= (ma->max / 3))
> -               tbl_mask_array_realloc(tbl, ma->max / 2);
> -}
> -
> -/* Remove 'mask' from the mask list, if it is not needed any more. */
> -static void flow_mask_remove(struct flow_table *tbl, struct sw_flow_mask *mask)
> -{
> -       if (mask) {
> -               /* ovs-lock is required to protect mask-refcount and
> -                * mask list.
> -                */
> -               ASSERT_OVSL();
> -               BUG_ON(!mask->ref_count);
> -               mask->ref_count--;
> -
> -               if (!mask->ref_count)
> -                       tbl_mask_array_del_mask(tbl, mask);
> -       }
> -}
> -
>  /* Must be called with OVS mutex held. */
>  void ovs_flow_tbl_remove(struct flow_table *table, struct sw_flow *flow)
>  {
> -       struct table_instance *ti = ovsl_dereference(table->ti);
> -       struct table_instance *ufid_ti = ovsl_dereference(table->ufid_ti);
> -
> -       BUG_ON(table->count == 0);
> -       hlist_del_rcu(&flow->flow_table.node[ti->node_ver]);
> -       table->count--;
> -       if (ovs_identifier_is_ufid(&flow->id)) {
> -               hlist_del_rcu(&flow->ufid_table.node[ufid_ti->node_ver]);
> -               table->ufid_count--;
> -       }
> -
> -       /* RCU delete the mask. 'flow->mask' is not NULLed, as it should be
> -        * accessible as long as the RCU read lock is held.
> -        */
> -       flow_mask_remove(table, flow->mask);
> +       table_instance_remove(table, flow);
Can you just rename table_instance_remove() to ovs_flow_tbl_remove()?
