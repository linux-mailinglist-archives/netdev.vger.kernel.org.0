Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AB8A5196E89
	for <lists+netdev@lfdr.de>; Sun, 29 Mar 2020 18:46:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728391AbgC2Qqb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 29 Mar 2020 12:46:31 -0400
Received: from relay8-d.mail.gandi.net ([217.70.183.201]:57103 "EHLO
        relay8-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727903AbgC2Qqb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 29 Mar 2020 12:46:31 -0400
X-Originating-IP: 209.85.221.173
Received: from mail-vk1-f173.google.com (mail-vk1-f173.google.com [209.85.221.173])
        (Authenticated sender: pshelar@ovn.org)
        by relay8-d.mail.gandi.net (Postfix) with ESMTPSA id 5CFF31BF207
        for <netdev@vger.kernel.org>; Sun, 29 Mar 2020 16:46:29 +0000 (UTC)
Received: by mail-vk1-f173.google.com with SMTP id p123so4045230vkg.1
        for <netdev@vger.kernel.org>; Sun, 29 Mar 2020 09:46:29 -0700 (PDT)
X-Gm-Message-State: AGi0PuZL58mw/8PGWiujQR89Q7+mmIjfzf/zowfqJwwDgKOe/ZsoZ3A8
        lrSMZSg7alR6eMrzSiJVGPUlwBFzOnz6rSEdcas=
X-Google-Smtp-Source: APiQypK9gMYpLxOWYu03By1TENUcC0eEKByDhBUTnlfJ/Fbz+xLZUHTCl9PwVzwfEiEpZI/B3CjR/4u6cd+4kLKV1ww=
X-Received: by 2002:a1f:c944:: with SMTP id z65mr4865790vkf.82.1585500387683;
 Sun, 29 Mar 2020 09:46:27 -0700 (PDT)
MIME-Version: 1.0
References: <1584969039-74113-1-git-send-email-xiangxia.m.yue@gmail.com>
In-Reply-To: <1584969039-74113-1-git-send-email-xiangxia.m.yue@gmail.com>
From:   Pravin Shelar <pshelar@ovn.org>
Date:   Sun, 29 Mar 2020 09:46:16 -0700
X-Gmail-Original-Message-ID: <CAOrHB_BZ2Sqjooc9u1osbrEsbL5w003CL54v_bd3YPcqkjOzjg@mail.gmail.com>
Message-ID: <CAOrHB_BZ2Sqjooc9u1osbrEsbL5w003CL54v_bd3YPcqkjOzjg@mail.gmail.com>
Subject: Re: [PATCH net-next v1 1/3] net: openvswitch: expand the meters
 number supported
To:     Tonghao Zhang <xiangxia.m.yue@gmail.com>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        ovs dev <dev@openvswitch.org>, Andy Zhou <azhou@ovn.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Mar 28, 2020 at 8:46 AM <xiangxia.m.yue@gmail.com> wrote:
>
> From: Tonghao Zhang <xiangxia.m.yue@gmail.com>
>
> In kernel datapath of Open vSwitch, there are only 1024
> buckets of meter in one dp. If installing more than 1024
> (e.g. 8192) meters, it may lead to the performance drop.
> But in some case, for example, Open vSwitch used as edge
> gateway, there should be 200,000+ at least, meters used for
> IP address bandwidth limitation.
>
> [Open vSwitch userspace datapath has this issue too.]
>
> For more scalable meter, this patch expands the buckets
> when necessary, so we can install more meters in the datapath.
>
> * Introducing the struct *dp_meter_instance*, it's easy to
>   expand meter though change the *ti* point in the struct
>   *dp_meter_table*.
> * Using kvmalloc_array instead of kmalloc_array.
>
Thanks for working on this, I have couple of comments.

> Cc: Pravin B Shelar <pshelar@ovn.org>
> Cc: Andy Zhou <azhou@ovn.org>
> Signed-off-by: Tonghao Zhang <xiangxia.m.yue@gmail.com>
> ---
>  net/openvswitch/datapath.h |   2 +-
>  net/openvswitch/meter.c    | 168 ++++++++++++++++++++++++++++++-------
>  net/openvswitch/meter.h    |  17 +++-
>  3 files changed, 153 insertions(+), 34 deletions(-)
>
> diff --git a/net/openvswitch/datapath.h b/net/openvswitch/datapath.h
> index e239a46c2f94..785105578448 100644
> --- a/net/openvswitch/datapath.h
> +++ b/net/openvswitch/datapath.h
> @@ -82,7 +82,7 @@ struct datapath {
>         u32 max_headroom;
>
>         /* Switch meters. */
> -       struct hlist_head *meters;
> +       struct dp_meter_table *meters;
>  };
>
>  /**
> diff --git a/net/openvswitch/meter.c b/net/openvswitch/meter.c
> index 5010d1ddd4bd..98003b201b45 100644
> --- a/net/openvswitch/meter.c
> +++ b/net/openvswitch/meter.c
> @@ -47,40 +47,136 @@ static void ovs_meter_free(struct dp_meter *meter)
>         kfree_rcu(meter, rcu);
>  }
>
> -static struct hlist_head *meter_hash_bucket(const struct datapath *dp,
> +static struct hlist_head *meter_hash_bucket(struct dp_meter_instance *ti,
>                                             u32 meter_id)
>  {
> -       return &dp->meters[meter_id & (METER_HASH_BUCKETS - 1)];
> +       u32 hash = jhash_1word(meter_id, ti->hash_seed);
> +
I do not see any need to hash meter-id, can you explain it.


> +       return &ti->buckets[hash & (ti->n_buckets - 1)];
>  }
>
>  /* Call with ovs_mutex or RCU read lock. */
> -static struct dp_meter *lookup_meter(const struct datapath *dp,
> +static struct dp_meter *lookup_meter(const struct dp_meter_table *tbl,
>                                      u32 meter_id)
>  {
> +       struct dp_meter_instance *ti = rcu_dereference_ovsl(tbl->ti);
>         struct dp_meter *meter;
>         struct hlist_head *head;
>
> -       head = meter_hash_bucket(dp, meter_id);
> -       hlist_for_each_entry_rcu(meter, head, dp_hash_node,
> -                               lockdep_ovsl_is_held()) {
> +       head = meter_hash_bucket(ti, meter_id);
> +       hlist_for_each_entry_rcu(meter, head, hash_node[ti->node_ver],
> +                                lockdep_ovsl_is_held()) {
>                 if (meter->id == meter_id)
>                         return meter;
>         }
> +
This patch is expanding meter table linearly with number meters added
to datapath. so I do not see need to have hash table. it can be a
simple array. This would also improve lookup efficiency.
For hash collision we could find next free slot in array. let me know
what do you think about this approach.


>         return NULL;
>  }
>
> -static void attach_meter(struct datapath *dp, struct dp_meter *meter)
> +static struct dp_meter_instance *dp_meter_instance_alloc(const int size)
> +{
> +       struct dp_meter_instance *ti;
> +       int i;
> +
> +       ti = kmalloc(sizeof(*ti), GFP_KERNEL);
> +       if (!ti)
> +               return NULL;
> +
> +       ti->buckets = kvmalloc_array(size, sizeof(struct hlist_head),
> +                                    GFP_KERNEL);
> +       if (!ti->buckets) {
> +               kfree(ti);
> +               return NULL;
> +       }
> +
> +       for (i = 0; i < size; i++)
> +               INIT_HLIST_HEAD(&ti->buckets[i]);
> +
> +       ti->n_buckets = size;
> +       ti->node_ver = 0;
> +       get_random_bytes(&ti->hash_seed, sizeof(u32));
> +
> +       return ti;
> +}
> +
> +static void dp_meter_instance_free_rcu(struct rcu_head *rcu)
>  {
> -       struct hlist_head *head = meter_hash_bucket(dp, meter->id);
> +       struct dp_meter_instance *ti;
>
> -       hlist_add_head_rcu(&meter->dp_hash_node, head);
> +       ti = container_of(rcu, struct dp_meter_instance, rcu);
> +       kvfree(ti->buckets);
> +       kfree(ti);
>  }
>
> -static void detach_meter(struct dp_meter *meter)
> +static void dp_meter_instance_insert(struct dp_meter_instance *ti,
> +                                    struct dp_meter *meter)
> +{
> +       struct hlist_head *head = meter_hash_bucket(ti, meter->id);
> +
> +       hlist_add_head_rcu(&meter->hash_node[ti->node_ver], head);
> +}
> +
> +static void dp_meter_instance_remove(struct dp_meter_instance *ti,
> +                                    struct dp_meter *meter)
>  {
> +       hlist_del_rcu(&meter->hash_node[ti->node_ver]);
> +}
> +
> +static struct dp_meter_instance *
> +dp_meter_instance_expand(struct dp_meter_instance *ti)
> +{
> +       struct dp_meter_instance *new_ti;
> +       int i;
> +
> +       new_ti = dp_meter_instance_alloc(ti->n_buckets * 2);
> +       if (!new_ti)
> +               return NULL;
> +
> +       new_ti->node_ver = !ti->node_ver;
> +
> +       for (i = 0; i < ti->n_buckets; i++) {
> +               struct hlist_head *head = &ti->buckets[i];
> +               struct dp_meter *meter;
> +
> +               hlist_for_each_entry_rcu(meter, head, hash_node[ti->node_ver],
> +                                        lockdep_ovsl_is_held())
> +                       dp_meter_instance_insert(new_ti, meter);
> +       }
> +
> +       return new_ti;
> +}
> +
> +static void attach_meter(struct dp_meter_table *tbl, struct dp_meter *meter)
> +{
> +       struct dp_meter_instance *new_ti;
> +       struct dp_meter_instance *ti;
> +
> +       ti = rcu_dereference_ovsl(tbl->ti);
> +       dp_meter_instance_insert(ti, meter);
> +
> +       /* operate the counter safely, because called with ovs_lock. */
> +       tbl->count++;
> +
> +       if (tbl->count > ti->n_buckets) {
> +               new_ti = dp_meter_instance_expand(ti);
> +


> +               if (new_ti) {
> +                       rcu_assign_pointer(tbl->ti, new_ti);
> +                       call_rcu(&ti->rcu, dp_meter_instance_free_rcu);
> +               }
> +       }
> +}
> +
> +static void detach_meter(struct dp_meter_table *tbl, struct dp_meter *meter)
> +{
> +       struct dp_meter_instance *ti = rcu_dereference_ovsl(tbl->ti);
> +
>         ASSERT_OVSL();
> -       if (meter)
> -               hlist_del_rcu(&meter->dp_hash_node);
> +       if (meter) {
> +               /* operate the counter safely, because called with ovs_lock. */
> +               tbl->count--;
> +               dp_meter_instance_remove(ti, meter);
> +       }
>  }
>
>  static struct sk_buff *
> @@ -303,9 +399,9 @@ static int ovs_meter_cmd_set(struct sk_buff *skb, struct genl_info *info)
>         meter_id = nla_get_u32(a[OVS_METER_ATTR_ID]);
>
>         /* Cannot fail after this. */
> -       old_meter = lookup_meter(dp, meter_id);
> -       detach_meter(old_meter);
> -       attach_meter(dp, meter);
> +       old_meter = lookup_meter(dp->meters, meter_id);
> +       detach_meter(dp->meters, old_meter);
> +       attach_meter(dp->meters, meter);
>         ovs_unlock();
>
>         /* Build response with the meter_id and stats from
> @@ -365,7 +461,7 @@ static int ovs_meter_cmd_get(struct sk_buff *skb, struct genl_info *info)
>         }
>
>         /* Locate meter, copy stats. */
> -       meter = lookup_meter(dp, meter_id);
> +       meter = lookup_meter(dp->meters, meter_id);
>         if (!meter) {
>                 err = -ENOENT;
>                 goto exit_unlock;
> @@ -416,13 +512,13 @@ static int ovs_meter_cmd_del(struct sk_buff *skb, struct genl_info *info)
>                 goto exit_unlock;
>         }
>
> -       old_meter = lookup_meter(dp, meter_id);
> +       old_meter = lookup_meter(dp->meters, meter_id);
>         if (old_meter) {
>                 spin_lock_bh(&old_meter->lock);
>                 err = ovs_meter_cmd_reply_stats(reply, meter_id, old_meter);
>                 WARN_ON(err);
>                 spin_unlock_bh(&old_meter->lock);
> -               detach_meter(old_meter);
> +               detach_meter(dp->meters, old_meter);
>         }
>         ovs_unlock();
>         ovs_meter_free(old_meter);
> @@ -452,7 +548,7 @@ bool ovs_meter_execute(struct datapath *dp, struct sk_buff *skb,
>         int i, band_exceeded_max = -1;
>         u32 band_exceeded_rate = 0;
>
> -       meter = lookup_meter(dp, meter_id);
> +       meter = lookup_meter(dp->meters, meter_id);
>         /* Do not drop the packet when there is no meter. */
>         if (!meter)
>                 return false;
> @@ -570,32 +666,44 @@ struct genl_family dp_meter_genl_family __ro_after_init = {
>
>  int ovs_meters_init(struct datapath *dp)
>  {
> -       int i;
> +       struct dp_meter_instance *ti;
> +       struct dp_meter_table *tbl;
>
> -       dp->meters = kmalloc_array(METER_HASH_BUCKETS,
> -                                  sizeof(struct hlist_head), GFP_KERNEL);
> +       tbl = kmalloc(sizeof(*tbl), GFP_KERNEL);
> +       if (!tbl)
> +               return -ENOMEM;
>
> -       if (!dp->meters)
> +       tbl->count = 0;
> +
> +       ti = dp_meter_instance_alloc(METER_HASH_BUCKETS);
> +       if (!ti) {
> +               kfree(tbl);
>                 return -ENOMEM;
> +       }
>
> -       for (i = 0; i < METER_HASH_BUCKETS; i++)
> -               INIT_HLIST_HEAD(&dp->meters[i]);
> +       rcu_assign_pointer(tbl->ti, ti);
> +       dp->meters = tbl;
>
>         return 0;
>  }
>
>  void ovs_meters_exit(struct datapath *dp)
>  {
> +       struct dp_meter_table *tbl = dp->meters;
> +       struct dp_meter_instance *ti = rcu_dereference_ovsl(tbl->ti);
>         int i;
>
> -       for (i = 0; i < METER_HASH_BUCKETS; i++) {
> -               struct hlist_head *head = &dp->meters[i];
> +       for (i = 0; i < ti->n_buckets; i++) {
> +               struct hlist_head *head = &ti->buckets[i];
>                 struct dp_meter *meter;
>                 struct hlist_node *n;
>
> -               hlist_for_each_entry_safe(meter, n, head, dp_hash_node)
> -                       kfree(meter);
> +               hlist_for_each_entry_safe(meter, n, head,
> +                                         hash_node[ti->node_ver])
> +                       ovs_meter_free(meter);
>         }
>
> -       kfree(dp->meters);
> +       kvfree(ti->buckets);
> +       kfree(ti);
> +       kfree(tbl);
>  }
> diff --git a/net/openvswitch/meter.h b/net/openvswitch/meter.h
> index f645913870bd..bc84796d7d4d 100644
> --- a/net/openvswitch/meter.h
> +++ b/net/openvswitch/meter.h
> @@ -30,9 +30,7 @@ struct dp_meter_band {
>  struct dp_meter {
>         spinlock_t lock;    /* Per meter lock */
>         struct rcu_head rcu;
> -       struct hlist_node dp_hash_node; /*Element in datapath->meters
> -                                        * hash table.
> -                                        */
> +       struct hlist_node hash_node[2];
>         u32 id;
>         u16 kbps:1, keep_stats:1;
>         u16 n_bands;
> @@ -42,6 +40,19 @@ struct dp_meter {
>         struct dp_meter_band bands[];
>  };
>
> +struct dp_meter_instance {
> +       struct hlist_head *buckets;
> +       struct rcu_head rcu;
> +       u32 n_buckets;
> +       u32 hash_seed;
> +       u8 node_ver;
> +};
> +
> +struct dp_meter_table {
> +       struct dp_meter_instance __rcu *ti;
> +       u32 count;
> +};
> +
>  extern struct genl_family dp_meter_genl_family;
>  int ovs_meters_init(struct datapath *dp);
>  void ovs_meters_exit(struct datapath *dp);
> --
> 2.23.0
>
