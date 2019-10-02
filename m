Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E06ACC45CC
	for <lists+netdev@lfdr.de>; Wed,  2 Oct 2019 04:04:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729765AbfJBCDI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Oct 2019 22:03:08 -0400
Received: from relay1-d.mail.gandi.net ([217.70.183.193]:45043 "EHLO
        relay1-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726062AbfJBCDI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Oct 2019 22:03:08 -0400
X-Originating-IP: 209.85.217.43
Received: from mail-vs1-f43.google.com (mail-vs1-f43.google.com [209.85.217.43])
        (Authenticated sender: pshelar@ovn.org)
        by relay1-d.mail.gandi.net (Postfix) with ESMTPSA id E769E240004
        for <netdev@vger.kernel.org>; Wed,  2 Oct 2019 02:03:06 +0000 (UTC)
Received: by mail-vs1-f43.google.com with SMTP id b123so10854596vsb.5
        for <netdev@vger.kernel.org>; Tue, 01 Oct 2019 19:03:06 -0700 (PDT)
X-Gm-Message-State: APjAAAU3A14VbLDHN3oJTcu5BtG2s4MRM5H2xRC6jwARoFHldwF4ASSA
        BCmcoHMOqRBxBKHIuUx1B5rOoXvwgxiWFVofBX8=
X-Google-Smtp-Source: APXvYqwcb7GTBilw3phENAFskltdl/4NXmv69/A+ckDC1T6nOom3LTgt//k4TlxAKYfCjzC3QTYAGl4mo1sOmLaEgaQ=
X-Received: by 2002:a67:f314:: with SMTP id p20mr555741vsf.66.1569981785545;
 Tue, 01 Oct 2019 19:03:05 -0700 (PDT)
MIME-Version: 1.0
References: <1569777006-7435-1-git-send-email-xiangxia.m.yue@gmail.com> <1569777006-7435-6-git-send-email-xiangxia.m.yue@gmail.com>
In-Reply-To: <1569777006-7435-6-git-send-email-xiangxia.m.yue@gmail.com>
From:   Pravin Shelar <pshelar@ovn.org>
Date:   Tue, 1 Oct 2019 19:06:55 -0700
X-Gmail-Original-Message-ID: <CAOrHB_BHJGm8WNNdJ3C8nxyUDvRBri_0gq4DJQCoFjdrrvaLyw@mail.gmail.com>
Message-ID: <CAOrHB_BHJGm8WNNdJ3C8nxyUDvRBri_0gq4DJQCoFjdrrvaLyw@mail.gmail.com>
Subject: Re: [PATCH net-next 5/9] net: openvswitch: optimize flow-mask looking up
To:     Tonghao Zhang <xiangxia.m.yue@gmail.com>
Cc:     Greg Rose <gvrose8192@gmail.com>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Sep 29, 2019 at 7:09 PM <xiangxia.m.yue@gmail.com> wrote:
>
> From: Tonghao Zhang <xiangxia.m.yue@gmail.com>
>
> The full looking up on flow table traverses all mask array.
> If mask-array is too large, the number of invalid flow-mask
> increase, performance will be drop.
>
> This patch optimizes mask-array operation:
>
> * Inserting, insert it [ma->count- 1] directly.
> * Removing, only change last and current mask point, and free current mask.
> * Looking up, full looking up will break if mask is NULL.
>
> The function which changes or gets *count* of struct mask_array,
> is protected by ovs_lock, but flow_lookup (not protected) should use *max* of
> struct mask_array.
>
> Functions protected by ovs_lock:
> * tbl_mask_array_del_mask
> * tbl_mask_array_add_mask
> * flow_mask_find
> * ovs_flow_tbl_lookup_exact
> * ovs_flow_tbl_num_masks
>
> Signed-off-by: Tonghao Zhang <xiangxia.m.yue@gmail.com>
> ---
>  net/openvswitch/flow_table.c | 101 +++++++++++++++++++++----------------------
>  1 file changed, 49 insertions(+), 52 deletions(-)
>
> diff --git a/net/openvswitch/flow_table.c b/net/openvswitch/flow_table.c
> index e59fac5..5257e4a 100644
> --- a/net/openvswitch/flow_table.c
> +++ b/net/openvswitch/flow_table.c
> @@ -546,7 +546,7 @@ static struct sw_flow *flow_lookup(struct flow_table *tbl,
>
>                 mask = rcu_dereference_ovsl(ma->masks[i]);
>                 if (!mask)
> -                       continue;
> +                       break;
>
>                 flow = masked_flow_lookup(ti, key, mask, n_mask_hit);
>                 if (flow) { /* Found */
> @@ -640,15 +640,13 @@ struct sw_flow *ovs_flow_tbl_lookup_exact(struct flow_table *tbl,
>         int i;
>
>         /* Always called under ovs-mutex. */
> -       for (i = 0; i < ma->max; i++) {
> +       for (i = 0; i < ma->count; i++) {
>                 struct table_instance *ti = rcu_dereference_ovsl(tbl->ti);
>                 u32 __always_unused n_mask_hit;
>                 struct sw_flow_mask *mask;
>                 struct sw_flow *flow;
>
>                 mask = ovsl_dereference(ma->masks[i]);
> -               if (!mask)
> -                       continue;
>
>                 flow = masked_flow_lookup(ti, match->key, mask, &n_mask_hit);
>                 if (flow && ovs_identifier_is_key(&flow->id) &&
> @@ -712,21 +710,31 @@ static struct table_instance *table_instance_expand(struct table_instance *ti,
>         return table_instance_rehash(ti, ti->n_buckets * 2, ufid);
>  }
>
> -static void tbl_mask_array_delete_mask(struct mask_array *ma,
> -                                      struct sw_flow_mask *mask)
> +static void tbl_mask_array_del_mask(struct flow_table *tbl,
> +                                   struct sw_flow_mask *mask)
>  {
> +       struct mask_array *ma = ovsl_dereference(tbl->mask_array);
>         int i;
>
>         /* Remove the deleted mask pointers from the array */
> -       for (i = 0; i < ma->max; i++) {
> -               if (mask == ovsl_dereference(ma->masks[i])) {
> -                       RCU_INIT_POINTER(ma->masks[i], NULL);
> -                       ma->count--;
> -                       kfree_rcu(mask, rcu);
> -                       return;
> -               }
> +       for (i = 0; i < ma->count; i++) {
> +               if (mask == ovsl_dereference(ma->masks[i]))
> +                       goto found;
>         }
> +
>         BUG();
> +       return;
> +
> +found:
> +       rcu_assign_pointer(ma->masks[i], ma->masks[ma->count -1]);
> +       RCU_INIT_POINTER(ma->masks[ma->count -1], NULL);
> +       ma->count--;
> +       kfree_rcu(mask, rcu);
> +
> +       /* Shrink the mask array if necessary. */
> +       if (ma->max >= (MASK_ARRAY_SIZE_MIN * 2) &&
> +           ma->count <= (ma->max / 3))
> +               tbl_mask_array_realloc(tbl, ma->max / 2);
>  }
>
>  /* Remove 'mask' from the mask list, if it is not needed any more. */
> @@ -740,17 +748,8 @@ static void flow_mask_remove(struct flow_table *tbl, struct sw_flow_mask *mask)
>                 BUG_ON(!mask->ref_count);
>                 mask->ref_count--;
>
> -               if (!mask->ref_count) {
> -                       struct mask_array *ma;
> -
> -                       ma = ovsl_dereference(tbl->mask_array);
> -                       tbl_mask_array_delete_mask(ma, mask);
> -
> -                       /* Shrink the mask array if necessary. */
> -                       if (ma->max >= (MASK_ARRAY_SIZE_MIN * 2) &&
> -                           ma->count <= (ma->max / 3))
> -                               tbl_mask_array_realloc(tbl, ma->max / 2);
> -               }
> +               if (!mask->ref_count)
> +                       tbl_mask_array_del_mask(tbl, mask);
>         }
>  }
>
> @@ -803,17 +802,38 @@ static struct sw_flow_mask *flow_mask_find(const struct flow_table *tbl,
>         int i;
>
>         ma = ovsl_dereference(tbl->mask_array);
> -       for (i = 0; i < ma->max; i++) {
> +       for (i = 0; i < ma->count; i++) {
>                 struct sw_flow_mask *t;
>                 t = ovsl_dereference(ma->masks[i]);
>
> -               if (t && mask_equal(mask, t))
> +               if (mask_equal(mask, t))
>                         return t;
>         }
>
>         return NULL;
>  }
>
> +static int tbl_mask_array_add_mask(struct flow_table *tbl,
> +                                  struct sw_flow_mask *new)
> +{
> +       struct mask_array *ma = ovsl_dereference(tbl->mask_array);
> +       int err;
> +
> +       if (ma->count >= ma->max) {
> +               err = tbl_mask_array_realloc(tbl, ma->max +
> +                                             MASK_ARRAY_SIZE_MIN);
> +               if (err)
> +                       return err;
> +       }
> +
> +       BUG_ON(ovsl_dereference(ma->masks[ma->count]));
> +
> +       rcu_assign_pointer(ma->masks[ma->count], new);
> +       ma->count++;
There is no barrier for ma->count. Fastpath is accessing ma->count
without synchronization. Same issue with mask delete operation.
