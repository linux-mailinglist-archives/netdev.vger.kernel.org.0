Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 04B75C45CB
	for <lists+netdev@lfdr.de>; Wed,  2 Oct 2019 04:04:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729759AbfJBCC6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Oct 2019 22:02:58 -0400
Received: from relay7-d.mail.gandi.net ([217.70.183.200]:46011 "EHLO
        relay7-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726062AbfJBCC5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Oct 2019 22:02:57 -0400
X-Originating-IP: 209.85.221.178
Received: from mail-vk1-f178.google.com (mail-vk1-f178.google.com [209.85.221.178])
        (Authenticated sender: pshelar@ovn.org)
        by relay7-d.mail.gandi.net (Postfix) with ESMTPSA id AB50F20007
        for <netdev@vger.kernel.org>; Wed,  2 Oct 2019 02:02:53 +0000 (UTC)
Received: by mail-vk1-f178.google.com with SMTP id 70so3977888vkz.8
        for <netdev@vger.kernel.org>; Tue, 01 Oct 2019 19:02:53 -0700 (PDT)
X-Gm-Message-State: APjAAAXJljU/4CvYa4goE+x4kP2eHbXgds+03N6hb9Sr7ZoQDMu53Pvx
        GGn6j9v9bLgY4Lsf0Fn/AoRjADb7ou0QKK8WL3g=
X-Google-Smtp-Source: APXvYqztv+cv/d1LnplPJ/tUn/CPaSuOuA6mJqxPCZ79d+fvJobVU0icfjilpVM+KjfieZAgSUvOBsrS15pp+13waV0=
X-Received: by 2002:a1f:a6cd:: with SMTP id p196mr831066vke.25.1569981772185;
 Tue, 01 Oct 2019 19:02:52 -0700 (PDT)
MIME-Version: 1.0
References: <1569777006-7435-1-git-send-email-xiangxia.m.yue@gmail.com> <1569777006-7435-3-git-send-email-xiangxia.m.yue@gmail.com>
In-Reply-To: <1569777006-7435-3-git-send-email-xiangxia.m.yue@gmail.com>
From:   Pravin Shelar <pshelar@ovn.org>
Date:   Tue, 1 Oct 2019 19:06:42 -0700
X-Gmail-Original-Message-ID: <CAOrHB_CiXrxO+dq6JRXUDeB+tDADUMetR7LpnqYDzFqoV=Qp_Q@mail.gmail.com>
Message-ID: <CAOrHB_CiXrxO+dq6JRXUDeB+tDADUMetR7LpnqYDzFqoV=Qp_Q@mail.gmail.com>
Subject: Re: [PATCH net-next 2/9] net: openvswitch: convert mask list in mask array
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
> Port the codes to linux upstream and with little changes.
>
> Pravin B Shelar, says:
> | mask caches index of mask in mask_list. On packet recv OVS
> | need to traverse mask-list to get cached mask. Therefore array
> | is better for retrieving cached mask. This also allows better
> | cache replacement algorithm by directly checking mask's existence.
>
> Link: https://github.com/openvswitch/ovs/commit/d49fc3ff53c65e4eca9cabd52ac63396746a7ef5
> Signed-off-by: Tonghao Zhang <xiangxia.m.yue@gmail.com>
> ---
>  net/openvswitch/flow.h       |   1 -
>  net/openvswitch/flow_table.c | 218 +++++++++++++++++++++++++++++++++----------
>  net/openvswitch/flow_table.h |   8 +-
>  3 files changed, 175 insertions(+), 52 deletions(-)
>
> diff --git a/net/openvswitch/flow.h b/net/openvswitch/flow.h
> index b830d5f..8080518 100644
> --- a/net/openvswitch/flow.h
> +++ b/net/openvswitch/flow.h
> @@ -166,7 +166,6 @@ struct sw_flow_key_range {
>  struct sw_flow_mask {
>         int ref_count;
>         struct rcu_head rcu;
> -       struct list_head list;
>         struct sw_flow_key_range range;
>         struct sw_flow_key key;
>  };
> diff --git a/net/openvswitch/flow_table.c b/net/openvswitch/flow_table.c
> index 3d515c0..99954fa 100644
> --- a/net/openvswitch/flow_table.c
> +++ b/net/openvswitch/flow_table.c
> @@ -34,6 +34,7 @@
>  #include <net/ndisc.h>
>
>  #define TBL_MIN_BUCKETS                1024
> +#define MASK_ARRAY_SIZE_MIN    16
>  #define REHASH_INTERVAL                (10 * 60 * HZ)
>
>  #define MC_HASH_SHIFT          8
> @@ -168,9 +169,59 @@ static struct table_instance *table_instance_alloc(int new_size)
>         return ti;
>  }
>
> +static void mask_array_rcu_cb(struct rcu_head *rcu)
> +{
> +       struct mask_array *ma = container_of(rcu, struct mask_array, rcu);
> +
> +       kfree(ma);
> +}
> +
> +static struct mask_array *tbl_mask_array_alloc(int size)
> +{
> +       struct mask_array *new;
> +
> +       size = max(MASK_ARRAY_SIZE_MIN, size);
> +       new = kzalloc(sizeof(struct mask_array) +
> +                     sizeof(struct sw_flow_mask *) * size, GFP_KERNEL);
> +       if (!new)
> +               return NULL;
> +
> +       new->count = 0;
> +       new->max = size;
> +
> +       return new;
> +}
> +
> +static int tbl_mask_array_realloc(struct flow_table *tbl, int size)
> +{
> +       struct mask_array *old;
> +       struct mask_array *new;
> +
> +       new = tbl_mask_array_alloc(size);
> +       if (!new)
> +               return -ENOMEM;
> +
> +       old = ovsl_dereference(tbl->mask_array);
> +       if (old) {
> +               int i;
> +
> +               for (i = 0; i < old->max; i++) {
> +                       if (ovsl_dereference(old->masks[i]))
> +                               new->masks[new->count++] = old->masks[i];
> +               }
> +       }
> +       rcu_assign_pointer(tbl->mask_array, new);
> +
> +       if (old)
> +              call_rcu(&old->rcu, mask_array_rcu_cb);
> +
kfree_rcu can be used instead of call_rcu.


> +       return 0;
> +}
> +
>  int ovs_flow_tbl_init(struct flow_table *table)
>  {
>         struct table_instance *ti, *ufid_ti;
> +       struct mask_array *ma;
>
>         table->mask_cache = __alloc_percpu(sizeof(struct mask_cache_entry) *
>                                            MC_HASH_ENTRIES,
> @@ -178,9 +229,13 @@ int ovs_flow_tbl_init(struct flow_table *table)
>         if (!table->mask_cache)
>                 return -ENOMEM;
>
> +       ma = tbl_mask_array_alloc(MASK_ARRAY_SIZE_MIN);
> +       if (!ma)
> +               goto free_mask_cache;
> +
>         ti = table_instance_alloc(TBL_MIN_BUCKETS);
>         if (!ti)
> -               goto free_mask_cache;
> +               goto free_mask_array;
>
>         ufid_ti = table_instance_alloc(TBL_MIN_BUCKETS);
>         if (!ufid_ti)
> @@ -188,7 +243,7 @@ int ovs_flow_tbl_init(struct flow_table *table)
>
>         rcu_assign_pointer(table->ti, ti);
>         rcu_assign_pointer(table->ufid_ti, ufid_ti);
> -       INIT_LIST_HEAD(&table->mask_list);
> +       rcu_assign_pointer(table->mask_array, ma);
>         table->last_rehash = jiffies;
>         table->count = 0;
>         table->ufid_count = 0;
> @@ -196,6 +251,8 @@ int ovs_flow_tbl_init(struct flow_table *table)
>
>  free_ti:
>         __table_instance_destroy(ti);
> +free_mask_array:
> +       kfree(ma);
>  free_mask_cache:
>         free_percpu(table->mask_cache);
>         return -ENOMEM;
> @@ -255,6 +312,7 @@ void ovs_flow_tbl_destroy(struct flow_table *table)
>         struct table_instance *ufid_ti = rcu_dereference_raw(table->ufid_ti);
>
>         free_percpu(table->mask_cache);
> +       kfree(rcu_dereference_raw(table->mask_array));
>         table_instance_destroy(ti, ufid_ti, false);
>  }
>
> @@ -460,17 +518,27 @@ static struct sw_flow *masked_flow_lookup(struct table_instance *ti,
>
>  static struct sw_flow *flow_lookup(struct flow_table *tbl,
>                                    struct table_instance *ti,
> +                                  struct mask_array *ma,
>                                    const struct sw_flow_key *key,
> -                                  u32 *n_mask_hit)
> +                                  u32 *n_mask_hit,
> +                                  u32 *index)
>  {
> -       struct sw_flow_mask *mask;
>         struct sw_flow *flow;
> +       int i;
>
> -       list_for_each_entry_rcu(mask, &tbl->mask_list, list) {
> -               flow = masked_flow_lookup(ti, key, mask, n_mask_hit);
> -               if (flow)  /* Found */
> -                       return flow;
> +       for (i = 0; i < ma->max; i++)  {
> +               struct sw_flow_mask *mask;
> +
> +               mask = rcu_dereference_ovsl(ma->masks[i]);
> +               if (mask) {
> +                       flow = masked_flow_lookup(ti, key, mask, n_mask_hit);
> +                       if (flow) { /* Found */
> +                               *index = i;
> +                               return flow;
> +                       }
> +               }
>         }
> +
>         return NULL;
>  }
>
> @@ -486,6 +554,7 @@ struct sw_flow *ovs_flow_tbl_lookup_stats(struct flow_table *tbl,
>                                           u32 skb_hash,
>                                           u32 *n_mask_hit)
>  {
> +       struct mask_array *ma = rcu_dereference_ovsl(tbl->mask_array);
>         struct table_instance *ti = rcu_dereference_ovsl(tbl->ti);
>         struct mask_cache_entry  *entries, *ce, *del;
>         struct sw_flow *flow;
> @@ -493,8 +562,11 @@ struct sw_flow *ovs_flow_tbl_lookup_stats(struct flow_table *tbl,
>         int seg;
>
>         *n_mask_hit = 0;
> -       if (unlikely(!skb_hash))
> -               return flow_lookup(tbl, ti, key, n_mask_hit);
> +       if (unlikely(!skb_hash)) {
> +               u32 __always_unused mask_index;
> +
> +               return flow_lookup(tbl, ti, ma, key, n_mask_hit, &mask_index);
> +       }
>
>         del = NULL;
>         entries = this_cpu_ptr(tbl->mask_cache);
> @@ -507,37 +579,33 @@ struct sw_flow *ovs_flow_tbl_lookup_stats(struct flow_table *tbl,
>
>                 if (ce->skb_hash == skb_hash) {
>                         struct sw_flow_mask *mask;
> -                       int i;
> -
> -                       i = 0;
> -                       list_for_each_entry_rcu(mask, &tbl->mask_list, list) {
> -                               if (ce->mask_index == i++) {
> -                                       flow = masked_flow_lookup(ti, key, mask,
> -                                                                 n_mask_hit);
> -                                       if (flow)  /* Found */
> -                                               return flow;
> -
> -                                       break;
> -                               }
> +                       struct sw_flow *flow;
> +
> +                       mask = rcu_dereference_ovsl(ma->masks[ce->mask_index]);
> +                       if (mask) {
> +                               flow = masked_flow_lookup(ti, key, mask,
> +                                                         n_mask_hit);
> +                               if (flow)  /* Found */
> +                                       return flow;
>                         }
>
>                         del = ce;
>                         break;
>                 }
>
> -               if (!del || (del->skb_hash && !ce->skb_hash)) {
> +               if (!del || (del->skb_hash && !ce->skb_hash) ||
> +                   (rcu_dereference_ovsl(ma->masks[del->mask_index]) &&
> +                    !rcu_dereference_ovsl(ma->masks[ce->mask_index]))) {
>                         del = ce;
>                 }
>
>                 hash >>= MC_HASH_SHIFT;
>         }
>
> -       flow = flow_lookup(tbl, ti, key, n_mask_hit);
> +       flow = flow_lookup(tbl, ti, ma, key, n_mask_hit, &del->mask_index);
>
> -       if (flow) {
> +       if (flow)
>                 del->skb_hash = skb_hash;
> -               del->mask_index = (*n_mask_hit - 1);
> -       }
>
>         return flow;
>  }
> @@ -546,26 +614,38 @@ struct sw_flow *ovs_flow_tbl_lookup(struct flow_table *tbl,
>                                     const struct sw_flow_key *key)
>  {
>         struct table_instance *ti = rcu_dereference_ovsl(tbl->ti);
> +       struct mask_array *ma = rcu_dereference_ovsl(tbl->mask_array);
> +
>         u32 __always_unused n_mask_hit;
> +       u32 __always_unused index;
>
> -       return flow_lookup(tbl, ti, key, &n_mask_hit);
> +       return flow_lookup(tbl, ti, ma, key, &n_mask_hit, &index);
>  }
>
>  struct sw_flow *ovs_flow_tbl_lookup_exact(struct flow_table *tbl,
>                                           const struct sw_flow_match *match)
>  {
> -       struct table_instance *ti = rcu_dereference_ovsl(tbl->ti);
> -       struct sw_flow_mask *mask;
> -       struct sw_flow *flow;
> -       u32 __always_unused n_mask_hit;
> +       struct mask_array *ma = ovsl_dereference(tbl->mask_array);
> +       int i;
>
>         /* Always called under ovs-mutex. */
> -       list_for_each_entry(mask, &tbl->mask_list, list) {
> +       for (i = 0; i < ma->max; i++) {
> +               struct table_instance *ti = rcu_dereference_ovsl(tbl->ti);
> +               u32 __always_unused n_mask_hit;
> +               struct sw_flow_mask *mask;
> +               struct sw_flow *flow;
> +
> +               mask = ovsl_dereference(ma->masks[i]);
> +               if (!mask)
> +                       continue;
> +
>                 flow = masked_flow_lookup(ti, match->key, mask, &n_mask_hit);
>                 if (flow && ovs_identifier_is_key(&flow->id) &&
> -                   ovs_flow_cmp_unmasked_key(flow, match))
> +                   ovs_flow_cmp_unmasked_key(flow, match)) {
>                         return flow;
> +               }
>         }
> +
>         return NULL;
>  }
>
> @@ -611,13 +691,8 @@ struct sw_flow *ovs_flow_tbl_lookup_ufid(struct flow_table *tbl,
>
>  int ovs_flow_tbl_num_masks(const struct flow_table *table)
>  {
> -       struct sw_flow_mask *mask;
> -       int num = 0;
> -
> -       list_for_each_entry(mask, &table->mask_list, list)
> -               num++;
> -
> -       return num;
> +       struct mask_array *ma = rcu_dereference_ovsl(table->mask_array);
> +       return ma->count;
>  }
>
>  static struct table_instance *table_instance_expand(struct table_instance *ti,
> @@ -638,8 +713,19 @@ static void flow_mask_remove(struct flow_table *tbl, struct sw_flow_mask *mask)
>                 mask->ref_count--;
>
>                 if (!mask->ref_count) {
> -                       list_del_rcu(&mask->list);
> -                       kfree_rcu(mask, rcu);
> +                       struct mask_array *ma;
> +                       int i;
> +
> +                       ma = ovsl_dereference(tbl->mask_array);
> +                       for (i = 0; i < ma->max; i++) {
> +                               if (mask == ovsl_dereference(ma->masks[i])) {
> +                                       RCU_INIT_POINTER(ma->masks[i], NULL);
> +                                       ma->count--;
> +                                       kfree_rcu(mask, rcu);
> +                                       return;
> +                               }
> +                       }
> +                       BUG();
>                 }
>         }
>  }
> @@ -689,13 +775,16 @@ static bool mask_equal(const struct sw_flow_mask *a,
>  static struct sw_flow_mask *flow_mask_find(const struct flow_table *tbl,
>                                            const struct sw_flow_mask *mask)
>  {
> -       struct list_head *ml;
> +       struct mask_array *ma;
> +       int i;
>
> -       list_for_each(ml, &tbl->mask_list) {
> -               struct sw_flow_mask *m;
> -               m = container_of(ml, struct sw_flow_mask, list);
> -               if (mask_equal(mask, m))
> -                       return m;
> +       ma = ovsl_dereference(tbl->mask_array);
> +       for (i = 0; i < ma->max; i++) {
> +               struct sw_flow_mask *t;
> +               t = ovsl_dereference(ma->masks[i]);
> +
> +               if (t && mask_equal(mask, t))
> +                       return t;
>         }
>
>         return NULL;
> @@ -706,15 +795,44 @@ static int flow_mask_insert(struct flow_table *tbl, struct sw_flow *flow,
>                             const struct sw_flow_mask *new)
>  {
>         struct sw_flow_mask *mask;
> +
>         mask = flow_mask_find(tbl, new);
>         if (!mask) {
> +               struct mask_array *ma;
> +               int i;
> +
>                 /* Allocate a new mask if none exsits. */
>                 mask = mask_alloc();
>                 if (!mask)
>                         return -ENOMEM;
>                 mask->key = new->key;
>                 mask->range = new->range;
> -               list_add_tail_rcu(&mask->list, &tbl->mask_list);
> +
> +               /* Add mask to mask-list. */
> +               ma = ovsl_dereference(tbl->mask_array);
> +               if (ma->count >= ma->max) {
> +                       int err;
> +
> +                       err = tbl_mask_array_realloc(tbl, ma->max +
> +                                                    MASK_ARRAY_SIZE_MIN);
> +                       if (err) {
> +                               kfree(mask);
> +                               return err;
> +                       }
> +
> +                       ma = ovsl_dereference(tbl->mask_array);
> +               }
> +
> +               for (i = 0; i < ma->max; i++) {
> +                       const struct sw_flow_mask *t;
> +
> +                       t = ovsl_dereference(ma->masks[i]);
> +                       if (!t) {
> +                               rcu_assign_pointer(ma->masks[i], mask);
> +                               ma->count++;
> +                               break;
> +                       }
> +               }
>         } else {
>                 BUG_ON(!mask->ref_count);
>                 mask->ref_count++;
> diff --git a/net/openvswitch/flow_table.h b/net/openvswitch/flow_table.h
> index 04b6b1c..8a5cea6 100644
> --- a/net/openvswitch/flow_table.h
> +++ b/net/openvswitch/flow_table.h
> @@ -27,6 +27,12 @@ struct mask_cache_entry {
>         u32 mask_index;
>  };
>
> +struct mask_array {
> +       struct rcu_head rcu;
> +       int count, max;
> +       struct sw_flow_mask __rcu *masks[];
> +};
> +
>  struct table_instance {
>         struct hlist_head *buckets;
>         unsigned int n_buckets;
> @@ -40,7 +46,7 @@ struct flow_table {
>         struct table_instance __rcu *ti;
>         struct table_instance __rcu *ufid_ti;
>         struct mask_cache_entry __percpu *mask_cache;
> -       struct list_head mask_list;
> +       struct mask_array __rcu *mask_array;
>         unsigned long last_rehash;
>         unsigned int count;
>         unsigned int ufid_count;
> --
> 1.8.3.1
>
