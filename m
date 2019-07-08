Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A0D5C61C9A
	for <lists+netdev@lfdr.de>; Mon,  8 Jul 2019 11:55:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729974AbfGHJzs convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 8 Jul 2019 05:55:48 -0400
Received: from mail-ed1-f68.google.com ([209.85.208.68]:41813 "EHLO
        mail-ed1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729185AbfGHJzs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Jul 2019 05:55:48 -0400
Received: by mail-ed1-f68.google.com with SMTP id p15so3518051eds.8
        for <netdev@vger.kernel.org>; Mon, 08 Jul 2019 02:55:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=UQYYOmoW+5Q0SC607V3r6+/7LzVUj0S7VkOnPDvXzuI=;
        b=dJ3afKSOFBloFDAqmLv30eiGgiRswY4L3q57xk/0fxFDbtQNUvncBqnasDSSnfWBCB
         HEfLfkxgeZbhwMf21DTyNzKO1ZwUKHfLTjASD38mND+ITRhIAKlnw+RGDtADRv/e73+d
         VH4K/GVp3LQYWzGWjVp2ksv7ztN5blfcoDtmCuobAbjUug67a+6Ozn75uLg0wepLnlKy
         iTXRuikHYf+gZoY/ga2YSJyRaS3ZKVO/I3Dtq+YATwnPmLjeG7B1vUz9DmaF5BBox/7p
         R36+7YTSYalx86wJO7vWKeqR6B+JYD7xj5mebWD+soP0CPWVON96mCXN84zwW7MXviMN
         oiUA==
X-Gm-Message-State: APjAAAW3R5Xn2SIUDGJV8PvQN9ZFPBCX/KXEjIDmvgDO+KPSVMvUD8d9
        FDOVXj5rDeAzpYerUp9SVrl5Ow==
X-Google-Smtp-Source: APXvYqy3EFcCeDCieuyOXLR4URJnYixbJ3JLdYdsBvDkF4AJIeXt5OXJoBCOIoAX74pE6QlrOxSr1Q==
X-Received: by 2002:a05:6402:145a:: with SMTP id d26mr12365823edx.10.1562579745410;
        Mon, 08 Jul 2019 02:55:45 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([2a00:7660:6da:443::2])
        by smtp.gmail.com with ESMTPSA id x11sm2548387eda.80.2019.07.08.02.55.44
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 08 Jul 2019 02:55:44 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 319F9181CE6; Mon,  8 Jul 2019 11:55:44 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Y Song <ys114321@gmail.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        =?utf-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>
Subject: Re: [PATCH bpf-next v2 4/6] xdp: Add devmap_hash map type for looking up devices by hashed index
In-Reply-To: <CAH3MdRU+FXDMdQr9Q-BP8eiMLwaV6Mn2oic3kXwK4wxvw+tJAQ@mail.gmail.com>
References: <156240283550.10171.1727292671613975908.stgit@alrua-x1> <156240283595.10171.8867063497268976931.stgit@alrua-x1> <CAH3MdRU+FXDMdQr9Q-BP8eiMLwaV6Mn2oic3kXwK4wxvw+tJAQ@mail.gmail.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Mon, 08 Jul 2019 11:55:44 +0200
Message-ID: <874l3w26lb.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Y Song <ys114321@gmail.com> writes:

> On Sat, Jul 6, 2019 at 1:48 AM Toke Høiland-Jørgensen <toke@redhat.com> wrote:
>>
>> From: Toke Høiland-Jørgensen <toke@redhat.com>
>>
>> A common pattern when using xdp_redirect_map() is to create a device map
>> where the lookup key is simply ifindex. Because device maps are arrays,
>> this leaves holes in the map, and the map has to be sized to fit the
>> largest ifindex, regardless of how many devices actually are actually
>> needed in the map.
>>
>> This patch adds a second type of device map where the key is looked up
>> using a hashmap, instead of being used as an array index. This allows maps
>> to be densely packed, so they can be smaller.
>>
>> Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
>> ---
>>  include/linux/bpf.h        |    7 ++
>>  include/linux/bpf_types.h  |    1
>>  include/trace/events/xdp.h |    3 -
>>  kernel/bpf/devmap.c        |  192 ++++++++++++++++++++++++++++++++++++++++++++
>>  kernel/bpf/verifier.c      |    2
>>  net/core/filter.c          |    9 ++
>>  6 files changed, 211 insertions(+), 3 deletions(-)
>>
>> diff --git a/include/linux/bpf.h b/include/linux/bpf.h
>> index bfdb54dd2ad1..f9a506147c8a 100644
>> --- a/include/linux/bpf.h
>> +++ b/include/linux/bpf.h
>> @@ -713,6 +713,7 @@ struct xdp_buff;
>>  struct sk_buff;
>>
>>  struct bpf_dtab_netdev *__dev_map_lookup_elem(struct bpf_map *map, u32 key);
>> +struct bpf_dtab_netdev *__dev_map_hash_lookup_elem(struct bpf_map *map, u32 key);
>>  void __dev_map_flush(struct bpf_map *map);
>>  int dev_map_enqueue(struct bpf_dtab_netdev *dst, struct xdp_buff *xdp,
>>                     struct net_device *dev_rx);
>> @@ -799,6 +800,12 @@ static inline struct net_device  *__dev_map_lookup_elem(struct bpf_map *map,
>>         return NULL;
>>  }
>>
>> +static inline struct net_device  *__dev_map_hash_lookup_elem(struct bpf_map *map,
>> +                                                            u32 key)
>> +{
>> +       return NULL;
>> +}
>> +
>>  static inline void __dev_map_flush(struct bpf_map *map)
>>  {
>>  }
>> diff --git a/include/linux/bpf_types.h b/include/linux/bpf_types.h
>> index eec5aeeeaf92..36a9c2325176 100644
>> --- a/include/linux/bpf_types.h
>> +++ b/include/linux/bpf_types.h
>> @@ -62,6 +62,7 @@ BPF_MAP_TYPE(BPF_MAP_TYPE_ARRAY_OF_MAPS, array_of_maps_map_ops)
>>  BPF_MAP_TYPE(BPF_MAP_TYPE_HASH_OF_MAPS, htab_of_maps_map_ops)
>>  #ifdef CONFIG_NET
>>  BPF_MAP_TYPE(BPF_MAP_TYPE_DEVMAP, dev_map_ops)
>> +BPF_MAP_TYPE(BPF_MAP_TYPE_DEVMAP_HASH, dev_map_hash_ops)
>>  BPF_MAP_TYPE(BPF_MAP_TYPE_SK_STORAGE, sk_storage_map_ops)
>>  #if defined(CONFIG_BPF_STREAM_PARSER)
>>  BPF_MAP_TYPE(BPF_MAP_TYPE_SOCKMAP, sock_map_ops)
>> diff --git a/include/trace/events/xdp.h b/include/trace/events/xdp.h
>> index 68899fdc985b..8c8420230a10 100644
>> --- a/include/trace/events/xdp.h
>> +++ b/include/trace/events/xdp.h
>> @@ -175,7 +175,8 @@ struct _bpf_dtab_netdev {
>>  #endif /* __DEVMAP_OBJ_TYPE */
>>
>>  #define devmap_ifindex(fwd, map)                               \
>> -       ((map->map_type == BPF_MAP_TYPE_DEVMAP) ?               \
>> +       ((map->map_type == BPF_MAP_TYPE_DEVMAP ||               \
>> +         map->map_type == BPF_MAP_TYPE_DEVMAP_HASH) ?          \
>>           ((struct _bpf_dtab_netdev *)fwd)->dev->ifindex : 0)
>>
>>  #define _trace_xdp_redirect_map(dev, xdp, fwd, map, idx)               \
>> diff --git a/kernel/bpf/devmap.c b/kernel/bpf/devmap.c
>> index a2fe16362129..341af02f049d 100644
>> --- a/kernel/bpf/devmap.c
>> +++ b/kernel/bpf/devmap.c
>> @@ -37,6 +37,12 @@
>>   * notifier hook walks the map we know that new dev references can not be
>>   * added by the user because core infrastructure ensures dev_get_by_index()
>>   * calls will fail at this point.
>> + *
>> + * The devmap_hash type is a map type which interprets keys as ifindexes and
>> + * indexes these using a hashmap. This allows maps that use ifindex as key to be
>> + * densely packed instead of having holes in the lookup array for unused
>> + * ifindexes. The setup and packet enqueue/send code is shared between the two
>> + * types of devmap; only the lookup and insertion is different.
>>   */
>>  #include <linux/bpf.h>
>>  #include <net/xdp.h>
>> @@ -59,6 +65,7 @@ struct xdp_bulk_queue {
>>
>>  struct bpf_dtab_netdev {
>>         struct net_device *dev; /* must be first member, due to tracepoint */
>> +       struct hlist_node index_hlist;
>>         struct bpf_dtab *dtab;
>>         unsigned int idx; /* keep track of map index for tracepoint */
>>         struct xdp_bulk_queue __percpu *bulkq;
>> @@ -70,11 +77,29 @@ struct bpf_dtab {
>>         struct bpf_dtab_netdev **netdev_map;
>>         struct list_head __percpu *flush_list;
>>         struct list_head list;
>> +
>> +       /* these are only used for DEVMAP_HASH type maps */
>> +       unsigned int items;
>> +       struct hlist_head *dev_index_head;
>> +       spinlock_t index_lock;
>>  };
>>
>>  static DEFINE_SPINLOCK(dev_map_lock);
>>  static LIST_HEAD(dev_map_list);
>>
>> +static struct hlist_head *dev_map_create_hash(void)
>> +{
>> +       int i;
>> +       struct hlist_head *hash;
>> +
>> +       hash = kmalloc_array(NETDEV_HASHENTRIES, sizeof(*hash), GFP_KERNEL);
>> +       if (hash != NULL)
>> +               for (i = 0; i < NETDEV_HASHENTRIES; i++)
>> +                       INIT_HLIST_HEAD(&hash[i]);
>> +
>> +       return hash;
>> +}
>> +
>>  static int dev_map_init_map(struct bpf_dtab *dtab, union bpf_attr *attr,
>>                             bool check_memlock)
>>  {
>> @@ -98,6 +123,9 @@ static int dev_map_init_map(struct bpf_dtab *dtab, union bpf_attr *attr,
>>         cost = (u64) dtab->map.max_entries * sizeof(struct bpf_dtab_netdev *);
>>         cost += sizeof(struct list_head) * num_possible_cpus();
>>
>> +       if (attr->map_type == BPF_MAP_TYPE_DEVMAP_HASH)
>> +               cost += sizeof(struct hlist_head) * NETDEV_HASHENTRIES;
>> +
>>         /* if map size is larger than memlock limit, reject it */
>>         err = bpf_map_charge_init(&dtab->map.memory, cost);
>>         if (err)
>> @@ -116,8 +144,18 @@ static int dev_map_init_map(struct bpf_dtab *dtab, union bpf_attr *attr,
>>         if (!dtab->netdev_map)
>>                 goto free_percpu;
>>
>> +       if (attr->map_type == BPF_MAP_TYPE_DEVMAP_HASH) {
>> +               dtab->dev_index_head = dev_map_create_hash();
>> +               if (!dtab->dev_index_head)
>> +                       goto free_map_area;
>> +
>> +               spin_lock_init(&dtab->index_lock);
>> +       }
>> +
>>         return 0;
>>
>> +free_map_area:
>> +       bpf_map_area_free(dtab->netdev_map);
>>  free_percpu:
>>         free_percpu(dtab->flush_list);
>>  free_charge:
>> @@ -199,6 +237,7 @@ static void dev_map_free(struct bpf_map *map)
>>
>>         free_percpu(dtab->flush_list);
>>         bpf_map_area_free(dtab->netdev_map);
>> +       kfree(dtab->dev_index_head);
>>         kfree(dtab);
>>  }
>>
>> @@ -219,6 +258,70 @@ static int dev_map_get_next_key(struct bpf_map *map, void *key, void *next_key)
>>         return 0;
>>  }
>>
>> +static inline struct hlist_head *dev_map_index_hash(struct bpf_dtab *dtab,
>> +                                                   int idx)
>> +{
>> +       return &dtab->dev_index_head[idx & (NETDEV_HASHENTRIES - 1)];
>> +}
>> +
>> +struct bpf_dtab_netdev *__dev_map_hash_lookup_elem(struct bpf_map *map, u32 key)
>> +{
>> +       struct bpf_dtab *dtab = container_of(map, struct bpf_dtab, map);
>> +       struct hlist_head *head = dev_map_index_hash(dtab, key);
>> +       struct bpf_dtab_netdev *dev;
>> +
>> +       hlist_for_each_entry_rcu(dev, head, index_hlist)
>> +               if (dev->idx == key)
>> +                       return dev;
>> +
>> +       return NULL;
>> +}
>> +
>> +static int dev_map_hash_get_next_key(struct bpf_map *map, void *key,
>> +                                   void *next_key)
>> +{
>> +       struct bpf_dtab *dtab = container_of(map, struct bpf_dtab, map);
>> +       u32 idx, *next = next_key;
>> +       struct bpf_dtab_netdev *dev, *next_dev;
>> +       struct hlist_head *head;
>> +       int i = 0;
>> +
>> +       if (!key)
>> +               goto find_first;
>> +
>> +       idx = *(u32 *)key;
>> +
>> +       dev = __dev_map_hash_lookup_elem(map, idx);
>> +       if (!dev)
>> +               goto find_first;
>> +
>> +       next_dev = hlist_entry_safe(rcu_dereference_raw(hlist_next_rcu(&dev->index_hlist)),
>> +                                   struct bpf_dtab_netdev, index_hlist);
>
> Just want to get a better understanding. Why do you want
> hlist_entry_safe instead of hlist_entry?

Erm, because the entry might not exist? The _safe variant just checks
the list pointer before casting to the containing struct.

> Also, maybe rcu_dereference instead of rcu_dereference_raw?

Well, the _raw() variant comes from the equivalent function in
hashtab.c, where I originally nicked most of this function, so think it
makes more sense to keep them the same.

> dev_map_hash_get_next_key() is called in syscall.c within rcu_read_lock region.
>
>> +
>> +       if (next_dev) {
>> +               *next = next_dev->idx;
>> +               return 0;
>> +       }
>> +
>> +       i = idx & (NETDEV_HASHENTRIES - 1);
>> +       i++;
>> +
>> + find_first:
>> +       for (; i < NETDEV_HASHENTRIES; i++) {
>> +               head = dev_map_index_hash(dtab, i);
>> +
>> +               next_dev = hlist_entry_safe(rcu_dereference_raw(hlist_first_rcu(head)),
>> +                                           struct bpf_dtab_netdev,
>> +                                           index_hlist);
>
> ditto. The same question as the above.
>
>> +               if (next_dev) {
>> +                       *next = next_dev->idx;
>> +                       return 0;
>> +               }
>> +       }
>> +
>> +       return -ENOENT;
>> +}
>> +
>>  static int bq_xmit_all(struct xdp_bulk_queue *bq, u32 flags,
>>                        bool in_napi_ctx)
>>  {
>> @@ -374,6 +477,15 @@ static void *dev_map_lookup_elem(struct bpf_map *map, void *key)
>>         return dev ? &dev->ifindex : NULL;
>>  }
>>
>> +static void *dev_map_hash_lookup_elem(struct bpf_map *map, void *key)
>> +{
>> +       struct bpf_dtab_netdev *obj = __dev_map_hash_lookup_elem(map,
>> +                                                               *(u32 *)key);
>> +       struct net_device *dev = obj ? obj->dev : NULL;
>
> When obj->dev could be NULL?

Never. This could just as well be written as

return obj ? obj->dev->ifindex : NULL;

but writing it this way keeps it consistent with the existing
dev_map_lookup_elem() function.

>> +
>> +       return dev ? &dev->ifindex : NULL;
>> +}
>> +
>>  static void dev_map_flush_old(struct bpf_dtab_netdev *dev)
>>  {
>>         if (dev->dev->netdev_ops->ndo_xdp_xmit) {
>> @@ -423,6 +535,27 @@ static int dev_map_delete_elem(struct bpf_map *map, void *key)
>>         return 0;
>>  }
>>
>> +static int dev_map_hash_delete_elem(struct bpf_map *map, void *key)
>> +{
>> +       struct bpf_dtab *dtab = container_of(map, struct bpf_dtab, map);
>> +       struct bpf_dtab_netdev *old_dev;
>> +       int k = *(u32 *)key;
>> +
>> +       old_dev = __dev_map_hash_lookup_elem(map, k);
>> +       if (!old_dev)
>> +               return 0;
>> +
>> +       spin_lock(&dtab->index_lock);
>> +       if (!hlist_unhashed(&old_dev->index_hlist)) {
>> +               dtab->items--;
>> +               hlist_del_init_rcu(&old_dev->index_hlist);
>> +       }
>> +       spin_unlock(&dtab->index_lock);
>> +
>> +       call_rcu(&old_dev->rcu, __dev_map_entry_free);
>> +       return 0;
>> +}
>> +
>>  static struct bpf_dtab_netdev *__dev_map_alloc_node(struct net *net,
>>                                                     struct bpf_dtab *dtab,
>>                                                     u32 ifindex,
>> @@ -503,6 +636,55 @@ static int dev_map_update_elem(struct bpf_map *map, void *key, void *value,
>>                                      map, key, value, map_flags);
>>  }
>>
>> +static int __dev_map_hash_update_elem(struct net *net, struct bpf_map *map,
>> +                                    void *key, void *value, u64 map_flags)
>> +{
>> +       struct bpf_dtab *dtab = container_of(map, struct bpf_dtab, map);
>> +       struct bpf_dtab_netdev *dev, *old_dev;
>> +       u32 ifindex = *(u32 *)value;
>> +       u32 idx = *(u32 *)key;
>> +
>> +       if (unlikely(map_flags > BPF_EXIST || !ifindex))
>> +               return -EINVAL;
>> +
>> +       old_dev = __dev_map_hash_lookup_elem(map, idx);
>> +       if (old_dev && (map_flags & BPF_NOEXIST))
>> +               return -EEXIST;
>> +
>> +       dev = __dev_map_alloc_node(net, dtab, ifindex, idx);
>> +       if (IS_ERR(dev))
>> +               return PTR_ERR(dev);
>> +
>> +       spin_lock(&dtab->index_lock);
>> +
>> +       if (old_dev) {
>> +               hlist_del_rcu(&old_dev->index_hlist);
>> +       } else {
>> +               if (dtab->items >= dtab->map.max_entries) {
>> +                       spin_unlock(&dtab->index_lock);
>> +                       call_rcu(&dev->rcu, __dev_map_entry_free);
>> +                       return -ENOSPC;
>> +               }
>> +               dtab->items++;
>> +       }
>> +
>> +       hlist_add_head_rcu(&dev->index_hlist,
>> +                          dev_map_index_hash(dtab, idx));
>> +       spin_unlock(&dtab->index_lock);
>> +
>> +       if (old_dev)
>> +               call_rcu(&old_dev->rcu, __dev_map_entry_free);
>> +
>> +       return 0;
>> +}
>> +
>> +static int dev_map_hash_update_elem(struct bpf_map *map, void *key, void *value,
>> +                                  u64 map_flags)
>> +{
>> +       return __dev_map_hash_update_elem(current->nsproxy->net_ns,
>> +                                        map, key, value, map_flags);
>> +}
>> +
>>  const struct bpf_map_ops dev_map_ops = {
>>         .map_alloc = dev_map_alloc,
>>         .map_free = dev_map_free,
>> @@ -513,6 +695,16 @@ const struct bpf_map_ops dev_map_ops = {
>>         .map_check_btf = map_check_no_btf,
>>  };
>>
>> +const struct bpf_map_ops dev_map_hash_ops = {
>> +       .map_alloc = dev_map_alloc,
>> +       .map_free = dev_map_free,
>> +       .map_get_next_key = dev_map_hash_get_next_key,
>> +       .map_lookup_elem = dev_map_hash_lookup_elem,
>> +       .map_update_elem = dev_map_hash_update_elem,
>> +       .map_delete_elem = dev_map_hash_delete_elem,
>> +       .map_check_btf = map_check_no_btf,
>> +};
>> +
>>  static int dev_map_notification(struct notifier_block *notifier,
>>                                 ulong event, void *ptr)
>>  {
>> diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
>> index a2e763703c30..231b9e22827c 100644
>> --- a/kernel/bpf/verifier.c
>> +++ b/kernel/bpf/verifier.c
>> @@ -3460,6 +3460,7 @@ static int check_map_func_compatibility(struct bpf_verifier_env *env,
>>                         goto error;
>>                 break;
>>         case BPF_MAP_TYPE_DEVMAP:
>> +       case BPF_MAP_TYPE_DEVMAP_HASH:
>>                 if (func_id != BPF_FUNC_redirect_map &&
>>                     func_id != BPF_FUNC_map_lookup_elem)
>>                         goto error;
>> @@ -3542,6 +3543,7 @@ static int check_map_func_compatibility(struct bpf_verifier_env *env,
>>                 break;
>>         case BPF_FUNC_redirect_map:
>>                 if (map->map_type != BPF_MAP_TYPE_DEVMAP &&
>> +                   map->map_type != BPF_MAP_TYPE_DEVMAP_HASH &&
>>                     map->map_type != BPF_MAP_TYPE_CPUMAP &&
>>                     map->map_type != BPF_MAP_TYPE_XSKMAP)
>>                         goto error;
>> diff --git a/net/core/filter.c b/net/core/filter.c
>> index 089aaea0ccc6..276961c4e0d4 100644
>> --- a/net/core/filter.c
>> +++ b/net/core/filter.c
>> @@ -3517,7 +3517,8 @@ static int __bpf_tx_xdp_map(struct net_device *dev_rx, void *fwd,
>>         int err;
>>
>>         switch (map->map_type) {
>> -       case BPF_MAP_TYPE_DEVMAP: {
>> +       case BPF_MAP_TYPE_DEVMAP:
>> +       case BPF_MAP_TYPE_DEVMAP_HASH: {
>>                 struct bpf_dtab_netdev *dst = fwd;
>>
>>                 err = dev_map_enqueue(dst, xdp, dev_rx);
>> @@ -3554,6 +3555,7 @@ void xdp_do_flush_map(void)
>>         if (map) {
>>                 switch (map->map_type) {
>>                 case BPF_MAP_TYPE_DEVMAP:
>> +               case BPF_MAP_TYPE_DEVMAP_HASH:
>>                         __dev_map_flush(map);
>>                         break;
>>                 case BPF_MAP_TYPE_CPUMAP:
>> @@ -3574,6 +3576,8 @@ static inline void *__xdp_map_lookup_elem(struct bpf_map *map, u32 index)
>>         switch (map->map_type) {
>>         case BPF_MAP_TYPE_DEVMAP:
>>                 return __dev_map_lookup_elem(map, index);
>> +       case BPF_MAP_TYPE_DEVMAP_HASH:
>> +               return __dev_map_hash_lookup_elem(map, index);
>>         case BPF_MAP_TYPE_CPUMAP:
>>                 return __cpu_map_lookup_elem(map, index);
>>         case BPF_MAP_TYPE_XSKMAP:
>> @@ -3655,7 +3659,8 @@ static int xdp_do_generic_redirect_map(struct net_device *dev,
>>         ri->tgt_value = NULL;
>>         WRITE_ONCE(ri->map, NULL);
>>
>> -       if (map->map_type == BPF_MAP_TYPE_DEVMAP) {
>> +       if (map->map_type == BPF_MAP_TYPE_DEVMAP ||
>> +           map->map_type == BPF_MAP_TYPE_DEVMAP_HASH) {
>>                 struct bpf_dtab_netdev *dst = fwd;
>>
>>                 err = dev_map_generic_redirect(dst, skb, xdp_prog);
>>
