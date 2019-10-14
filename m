Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 33D6DD5BCD
	for <lists+netdev@lfdr.de>; Mon, 14 Oct 2019 09:02:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730102AbfJNHCh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Oct 2019 03:02:37 -0400
Received: from relay9-d.mail.gandi.net ([217.70.183.199]:40061 "EHLO
        relay9-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726646AbfJNHCh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Oct 2019 03:02:37 -0400
X-Originating-IP: 209.85.221.172
Received: from mail-vk1-f172.google.com (mail-vk1-f172.google.com [209.85.221.172])
        (Authenticated sender: pshelar@ovn.org)
        by relay9-d.mail.gandi.net (Postfix) with ESMTPSA id B1C55FF803
        for <netdev@vger.kernel.org>; Mon, 14 Oct 2019 07:02:34 +0000 (UTC)
Received: by mail-vk1-f172.google.com with SMTP id v78so3315156vke.4
        for <netdev@vger.kernel.org>; Mon, 14 Oct 2019 00:02:34 -0700 (PDT)
X-Gm-Message-State: APjAAAXgAs9eMTpAokuz+mtPryGzlC3jbUDAUUD7lkc3oYyrzghZjsab
        ic9k4f0vMlOpBHD6NHHbe8bkGLMYiIRZ0F3szFY=
X-Google-Smtp-Source: APXvYqxO3mdfmyYHfvWqIjaNltaYu5hdc0xqFapyhDDdr9EVc2mLwKFVQHNpcC0FBXMROfnGUOP20IsKCKgM0KpIl+0=
X-Received: by 2002:a1f:5e0e:: with SMTP id s14mr14760903vkb.27.1571036553007;
 Mon, 14 Oct 2019 00:02:33 -0700 (PDT)
MIME-Version: 1.0
References: <1570802447-8019-1-git-send-email-xiangxia.m.yue@gmail.com> <1570802447-8019-6-git-send-email-xiangxia.m.yue@gmail.com>
In-Reply-To: <1570802447-8019-6-git-send-email-xiangxia.m.yue@gmail.com>
From:   Pravin Shelar <pshelar@ovn.org>
Date:   Mon, 14 Oct 2019 00:02:22 -0700
X-Gmail-Original-Message-ID: <CAOrHB_CujxO4syd=OFcZE4pMSNfxi9NtEqQB=2xxjP_i4yXSnA@mail.gmail.com>
Message-ID: <CAOrHB_CujxO4syd=OFcZE4pMSNfxi9NtEqQB=2xxjP_i4yXSnA@mail.gmail.com>
Subject: Re: [PATCH net-next v3 05/10] net: openvswitch: optimize flow-mask
 looking up
To:     Tonghao Zhang <xiangxia.m.yue@gmail.com>
Cc:     Greg Rose <gvrose8192@gmail.com>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        ovs dev <dev@openvswitch.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 11, 2019 at 7:05 AM <xiangxia.m.yue@gmail.com> wrote:
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
>  net/openvswitch/flow_table.c | 114 ++++++++++++++++++++++---------------------
>  1 file changed, 58 insertions(+), 56 deletions(-)
>
> diff --git a/net/openvswitch/flow_table.c b/net/openvswitch/flow_table.c
> index 4c82960..1b99f8e 100644
> --- a/net/openvswitch/flow_table.c
> +++ b/net/openvswitch/flow_table.c
> @@ -198,10 +198,8 @@ static int tbl_mask_array_realloc(struct flow_table *tbl, int size)
>         if (old) {
>                 int i;
>
> -               for (i = 0; i < old->max; i++) {
> -                       if (ovsl_dereference(old->masks[i]))
> -                               new->masks[new->count++] = old->masks[i];
> -               }
> +               for (i = 0; i < old->count; i++)
> +                       new->masks[new->count++] = old->masks[i];
>         }
>
>         rcu_assign_pointer(tbl->mask_array, new);
> @@ -538,7 +536,7 @@ static struct sw_flow *flow_lookup(struct flow_table *tbl,
>
>                 mask = rcu_dereference_ovsl(ma->masks[i]);
>                 if (!mask)
> -                       continue;
> +                       break;
>
>                 flow = masked_flow_lookup(ti, key, mask, n_mask_hit);
>                 if (flow) { /* Found */
> @@ -632,15 +630,13 @@ struct sw_flow *ovs_flow_tbl_lookup_exact(struct flow_table *tbl,
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
> @@ -704,21 +700,34 @@ static struct table_instance *table_instance_expand(struct table_instance *ti,
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
> +       ma->count--;
> +       smp_wmb();
> +
You need corresponding barriers when you read this value. I think it
would be better if you use WRITE_ONCE() and READ_ONCE() APIs to manage
this variable access.



> +       rcu_assign_pointer(ma->masks[i], ma->masks[ma->count]);
> +       RCU_INIT_POINTER(ma->masks[ma->count], NULL);
> +
> +       kfree_rcu(mask, rcu);
> +
> +       /* Shrink the mask array if necessary. */
> +       if (ma->max >= (MASK_ARRAY_SIZE_MIN * 2) &&
> +           ma->count <= (ma->max / 3))
> +               tbl_mask_array_realloc(tbl, ma->max / 2);
>  }
>
>  /* Remove 'mask' from the mask list, if it is not needed any more. */
> @@ -732,17 +741,8 @@ static void flow_mask_remove(struct flow_table *tbl, struct sw_flow_mask *mask)
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
> @@ -795,17 +795,42 @@ static struct sw_flow_mask *flow_mask_find(const struct flow_table *tbl,
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
> +
> +               ma = ovsl_dereference(tbl->mask_array);
> +       }
> +
> +       BUG_ON(ovsl_dereference(ma->masks[ma->count]));
> +
> +       rcu_assign_pointer(ma->masks[ma->count], new);
> +
> +       smp_wmb();
> +       ma->count++;
> +
> +       return 0;
> +}
> +
>  /* Add 'mask' into the mask list, if it is not already there. */
>  static int flow_mask_insert(struct flow_table *tbl, struct sw_flow *flow,
>                             const struct sw_flow_mask *new)
> @@ -814,9 +839,6 @@ static int flow_mask_insert(struct flow_table *tbl, struct sw_flow *flow,
>
>         mask = flow_mask_find(tbl, new);
>         if (!mask) {
> -               struct mask_array *ma;
> -               int i;
> -
>                 /* Allocate a new mask if none exsits. */
>                 mask = mask_alloc();
>                 if (!mask)
> @@ -825,29 +847,9 @@ static int flow_mask_insert(struct flow_table *tbl, struct sw_flow *flow,
>                 mask->range = new->range;
>
>                 /* Add mask to mask-list. */
> -               ma = ovsl_dereference(tbl->mask_array);
> -               if (ma->count >= ma->max) {
> -                       int err;
> -
> -                       err = tbl_mask_array_realloc(tbl, ma->max +
> -                                                    MASK_ARRAY_SIZE_MIN);
> -                       if (err) {
> -                               kfree(mask);
> -                               return err;
> -                       }
> -
> -                       ma = ovsl_dereference(tbl->mask_array);
> -               }
> -
> -               for (i = 0; i < ma->max; i++) {
> -                       const struct sw_flow_mask *t;
> -
> -                       t = ovsl_dereference(ma->masks[i]);
> -                       if (!t) {
> -                               rcu_assign_pointer(ma->masks[i], mask);
> -                               ma->count++;
> -                               break;
> -                       }
> +               if (tbl_mask_array_add_mask(tbl, mask)) {
> +                       kfree(mask);
> +                       return -ENOMEM;
>                 }
>         } else {
>                 BUG_ON(!mask->ref_count);
> --
> 1.8.3.1
>
