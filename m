Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3D4E4BBEEA
	for <lists+netdev@lfdr.de>; Tue, 24 Sep 2019 01:20:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2503548AbfIWXUp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Sep 2019 19:20:45 -0400
Received: from mail-lj1-f196.google.com ([209.85.208.196]:41658 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2503543AbfIWXUp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Sep 2019 19:20:45 -0400
Received: by mail-lj1-f196.google.com with SMTP id f5so15389360ljg.8;
        Mon, 23 Sep 2019 16:20:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=4FDiAN3LPU3esIOl+hYj05qzFl+klW6hpWuBukpMcw0=;
        b=Mg8e/iVECsZ3FNXHYjKrtaqIwHfS1nCIxMR6YorIiSg5I2Uxfxb9iTxLcyHlUi8fGA
         BeNpdsfumB8FXQRRfBGtODJ4cdB0OWaiv2DWQC512tr8484u/bDMrNu9EU6+ahjfEOU6
         Vc92Kags4VRTYUxaIge58QqcFiNzvvjbu78Q5UvbIdstXdekVyele2y/N/+lfVO1pbRI
         NoN4Fc49NtdjPnkSTyn0h3i9Rl2OboBLpnV47aHz4NdKUHHcf/gsVxeU6+39GvBWaMd0
         kSDMXG1o5VjQ1E4fx97ZaksFuy/elbHVSZ9E5ykwXXHkQ/3iqeuFHwV+w3sHeBJnBwyI
         QpAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=4FDiAN3LPU3esIOl+hYj05qzFl+klW6hpWuBukpMcw0=;
        b=lF+PKqZGpggv4Fy5sUlMjTRBEHQwTRRpx6ZPYiYD7v9+z0p6WNfR4r1UtQWQJoeWKb
         npwn7R/hLQNsn/qYAk5lX2hbsXrB2SLH8g1h+8hCVEB+vhUw6I417wdLI72nHQokeu5Z
         VMHPD9KRF8yxAX3SJr2q4CyFidLsmzm0Gp+SOzfhvMqmEuproC6us8T2uBb50Ahw/yng
         hrCDjT5+smZh/xUxRAPe63h2AIgckf5EaBY79O34RX/fxOMJNIHaCT2gLS1hSgO1kOU5
         753fP9geQvW8HGTTA8qydU/Yo18UpOBHjZeEKa3/DWWK/PPkR7S/ZHlJKRp6/rXjRkYT
         i2lw==
X-Gm-Message-State: APjAAAUt335oCaSULVbt3gXpiJWyjqcwn81oQi1+4Bdp3P/nEyp4fauZ
        Stq4UsTEdfc0X3pPtmZR0EoyjMMu1YBHjkSMbSU=
X-Google-Smtp-Source: APXvYqxBJj530OsjPizCEZD8SIKglCT8hMI5S56K4HQPuFIXALhFRngeokYHLFzfEyvYhTtBdnCzFc91Iltn/uMgxl0=
X-Received: by 2002:a2e:89c9:: with SMTP id c9mr1034992ljk.64.1569280839415;
 Mon, 23 Sep 2019 16:20:39 -0700 (PDT)
MIME-Version: 1.0
References: <20190906225434.3635421-1-yhs@fb.com> <20190906225434.3635421-2-yhs@fb.com>
In-Reply-To: <20190906225434.3635421-2-yhs@fb.com>
From:   Brian Vazquez <brianvv.kernel@gmail.com>
Date:   Mon, 23 Sep 2019 16:20:28 -0700
Message-ID: <CABCgpaULua4BQAwr8F4+azGBV5A1JLyEtth_+M-NLLjowC8owA@mail.gmail.com>
Subject: Re: [RFC PATCH bpf-next v2 1/2] bpf: adding map batch processing support
To:     Yonghong Song <yhs@fb.com>
Cc:     ast@fb.com, Daniel Borkmann <daniel@iogearbox.net>,
        netdev <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        kernel-team@fb.com, Jakub Kicinski <jakub.kicinski@netronome.com>,
        Brian Vazquez <brianvv@google.com>,
        Stanislav Fomichev <sdf@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Yonghong, thanks for working on this!

I have some concerns about this implementation but overall I think
this might work for our use case too!

On Sun, Sep 8, 2019 at 1:11 AM Yonghong Song <yhs@fb.com> wrote:
>
> Brian Vazquez has proposed BPF_MAP_DUMP command to look up more than one
> map entries per syscall.
>   https://lore.kernel.org/bpf/CABCgpaU3xxX6CMMxD+1knApivtc2jLBHysDXw-0E9bQEL0qC3A@mail.gmail.com/T/#t
>
> During discussion, we found more use cases can be supported in a similar
> map operation batching framework. For example, batched map lookup and delete,
> which can be really helpful for bcc.
>   https://github.com/iovisor/bcc/blob/master/tools/tcptop.py#L233-L243
>   https://github.com/iovisor/bcc/blob/master/tools/slabratetop.py#L129-L138
>
> Also, in bcc, we have API to delete all entries in a map.
>   https://github.com/iovisor/bcc/blob/master/src/cc/api/BPFTable.h#L257-L264
>
> For map update, batched operations also useful as sometimes applications need
> to populate initial maps with more than one entry. For example, the below
> example is from kernel/samples/bpf/xdp_redirect_cpu_user.c:
>   https://github.com/torvalds/linux/blob/master/samples/bpf/xdp_redirect_cpu_user.c#L543-L550
>
> This patch addresses all the above use cases. To make uapi stable, it also
> covers other potential use cases. For bpf syscall subcommands are introduced:
>         BPF_MAP_LOOKUP_BATCH
>         BPF_MAP_LOOKUP_AND_DELETE_BATCH
>         BPF_MAP_UPDATE_BATCH
>         BPF_MAP_DELETE_BATCH
>
> The UAPI attribute structure looks like:
>
>     struct { /* struct used by BPF_MAP_*_BATCH commands */
>             __u64           batch;  /* input/output:
>                                      * input: start batch,
>                                      *        0 to start from beginning.
>                                      * output: next start batch,
>                                      *         0 to end batching.
>                                      */
>             __aligned_u64   keys;
>             __aligned_u64   values;
>             __u32           count;  /* input/output:
>                                      * input: # of elements keys/values.
>                                      * output: # of filled elements.
>                                      */
>             __u32           map_fd;
>             __u64           elem_flags;
>             __u64           flags;
>     } batch;
>
> An opaque value 'batch' is used for user/kernel space communication
> for where in the map to start the operation for lookup/lookup_and_delete/delete.
>   input 'batch' = 0: to start the operation from the beginning of the map.
>   output 'batch': if not 0, the next input for batch operation.
>
> For lookup/lookup_and_delete:
>   operation: lookup/lookup_and_delete starting from a particular 'batch'.
>   return:
>      'batch'       'count'     return code     meaning
>       0            0           0               Done. Nothing left
>       0            0           -ENOSPC         no space to handle batch 0
>       > 0          0           -ENOSPC         no space to handle 'batch'
>       > 0          > 0         0               stopped right before 'batch'
> Note that:
>   (1). Even if return code is 0 and return 'count' > 0, the return 'count' may
>        not be equal to input 'count'. This happens when there is no enough space
>        to handle a batch.
>   (2). If the return code is an error and not -EFAULT,
>        'batch' indicates the batch has issues and 'count' indicates the number
>        of elements successfully processed.
>
> For delete:
>   operation: deletion starting from a particular 'batch'.
>   return: 0 means everything is deleted from 'batch'.
>           error code means something deletion not happening.
>
> For update:
>   operation: update 'count' number of elements in 'keys'/'values'.
>   return: 0 means successful updates for all elements.
>           error code, if not -EFAULT, 'count' is the number of successful updates.
>
> Signed-off-by: Yonghong Song <yhs@fb.com>
> ---
>  include/linux/bpf.h      |   9 ++
>  include/uapi/linux/bpf.h |  22 +++
>  kernel/bpf/hashtab.c     | 324 +++++++++++++++++++++++++++++++++++++++
>  kernel/bpf/syscall.c     |  68 ++++++++
>  4 files changed, 423 insertions(+)
>
> diff --git a/include/linux/bpf.h b/include/linux/bpf.h
> index 5b9d22338606..3c1302e8e2d4 100644
> --- a/include/linux/bpf.h
> +++ b/include/linux/bpf.h
> @@ -37,6 +37,15 @@ struct bpf_map_ops {
>         int (*map_get_next_key)(struct bpf_map *map, void *key, void *next_key);
>         void (*map_release_uref)(struct bpf_map *map);
>         void *(*map_lookup_elem_sys_only)(struct bpf_map *map, void *key);
> +       int (*map_lookup_batch)(struct bpf_map *map, const union bpf_attr *attr,
> +                               union bpf_attr __user *uattr);
> +       int (*map_lookup_and_delete_batch)(struct bpf_map *map,
> +                                          const union bpf_attr *attr,
> +                                          union bpf_attr __user *uattr);
> +       int (*map_update_batch)(struct bpf_map *map, const union bpf_attr *attr,
> +                               union bpf_attr __user *uattr);
> +       int (*map_delete_batch)(struct bpf_map *map, const union bpf_attr *attr,
> +                               union bpf_attr __user *uattr);
>
>         /* funcs callable from userspace and from eBPF programs */
>         void *(*map_lookup_elem)(struct bpf_map *map, void *key);
> diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
> index 5d2fb183ee2d..9d4f76073dd9 100644
> --- a/include/uapi/linux/bpf.h
> +++ b/include/uapi/linux/bpf.h
> @@ -107,6 +107,10 @@ enum bpf_cmd {
>         BPF_MAP_LOOKUP_AND_DELETE_ELEM,
>         BPF_MAP_FREEZE,
>         BPF_BTF_GET_NEXT_ID,
> +       BPF_MAP_LOOKUP_BATCH,
> +       BPF_MAP_LOOKUP_AND_DELETE_BATCH,
> +       BPF_MAP_UPDATE_BATCH,
> +       BPF_MAP_DELETE_BATCH,
>  };
>
>  enum bpf_map_type {
> @@ -396,6 +400,24 @@ union bpf_attr {
>                 __u64           flags;
>         };
>
> +       struct { /* struct used by BPF_MAP_*_BATCH commands */
> +               __u64           batch;  /* input/output:
> +                                        * input: start batch,
> +                                        *        0 to start from beginning.
> +                                        * output: next start batch,
> +                                        *         0 to end batching.
> +                                        */
> +               __aligned_u64   keys;
> +               __aligned_u64   values;
> +               __u32           count;  /* input/output:
> +                                        * input: # of elements keys/values.
> +                                        * output: # of filled elements.
> +                                        */
> +               __u32           map_fd;
> +               __u64           elem_flags;
> +               __u64           flags;
> +       } batch;
> +
>         struct { /* anonymous struct used by BPF_PROG_LOAD command */
>                 __u32           prog_type;      /* one of enum bpf_prog_type */
>                 __u32           insn_cnt;
> diff --git a/kernel/bpf/hashtab.c b/kernel/bpf/hashtab.c
> index 22066a62c8c9..ee7b90200f4d 100644
> --- a/kernel/bpf/hashtab.c
> +++ b/kernel/bpf/hashtab.c
> @@ -1232,6 +1232,322 @@ static void htab_map_seq_show_elem(struct bpf_map *map, void *key,
>         rcu_read_unlock();
>  }
>
> +static int
> +__htab_map_lookup_and_delete_batch(struct bpf_map *map,
> +                                  const union bpf_attr *attr,
> +                                  union bpf_attr __user *uattr,
> +                                  bool do_delete, bool is_lru_map)
> +{
> +       struct bpf_htab *htab = container_of(map, struct bpf_htab, map);
> +       u32 bucket_cnt, total, key_size, value_size, roundup_key_size;
> +       void *keys = NULL, *values = NULL, *value, *dst_key, *dst_val;
> +       u64 elem_map_flags, map_flags;
> +       struct hlist_nulls_head *head;
> +       void __user *ukeys, *uvalues;
> +       struct hlist_nulls_node *n;
> +       u32 batch, max_count;
> +       unsigned long flags;
> +       struct htab_elem *l;
> +       struct bucket *b;
> +       int ret = 0;
> +
> +       max_count = attr->batch.count;
> +       if (!max_count)
> +               return 0;
> +
> +       elem_map_flags = attr->batch.elem_flags;
> +       if ((elem_map_flags & ~BPF_F_LOCK) ||
> +           ((elem_map_flags & BPF_F_LOCK) && !map_value_has_spin_lock(map)))
> +               return -EINVAL;
> +
> +       map_flags = attr->batch.flags;
> +       if (map_flags)
> +               return -EINVAL;
> +
> +       batch = (u32)attr->batch.batch;
> +       if (batch >= htab->n_buckets)
> +               return -EINVAL;
> +
> +       /* We cannot do copy_from_user or copy_to_user inside
> +        * the rcu_read_lock. Allocate enough space here.
> +        */
> +       key_size = htab->map.key_size;
> +       roundup_key_size = round_up(htab->map.key_size, 8);
> +       value_size = htab->map.value_size;
> +       keys = kvmalloc(key_size * max_count, GFP_USER | __GFP_NOWARN);
> +       values = kvmalloc(value_size * max_count, GFP_USER | __GFP_NOWARN);
> +       if (!keys || !values) {
> +               ret = -ENOMEM;
> +               goto out;
> +       }
> +
> +       dst_key = keys;
> +       dst_val = values;
> +       total = 0;
> +
> +       preempt_disable();
> +       this_cpu_inc(bpf_prog_active);
> +       rcu_read_lock();
> +
> +again:
> +       b = &htab->buckets[batch];
> +       head = &b->head;
> +       raw_spin_lock_irqsave(&b->lock, flags);
> +

Would it be possible to avoid that lock when we're not deleting (just
batching lookup)? To be honest I don't how much impact would have to
grab that lock when concurrent additions are happening in a bpf
program.

> +       bucket_cnt = 0;
> +       hlist_nulls_for_each_entry_rcu(l, n, head, hash_node)
> +               bucket_cnt++;
> +
> +       if (bucket_cnt > (max_count - total)) {
> +               if (total == 0)
> +                       ret = -ENOSPC;
> +               goto after_loop;
> +       }
> +
> +       hlist_nulls_for_each_entry_rcu(l, n, head, hash_node) {
> +               memcpy(dst_key, l->key, key_size);
> +
> +               value = l->key + roundup_key_size;
> +               if (elem_map_flags & BPF_F_LOCK)
> +                       copy_map_value_locked(map, dst_val, value, true);
> +               else
> +                       copy_map_value(map, dst_val, value);
> +               check_and_init_map_lock(map, dst_val);
> +
> +               dst_key += key_size;
> +               dst_val += value_size;
> +               total++;
> +       }
> +
> +       if (do_delete) {
> +               hlist_nulls_for_each_entry_rcu(l, n, head, hash_node) {
> +                       hlist_nulls_del_rcu(&l->hash_node);
> +                       if (is_lru_map)
> +                               bpf_lru_push_free(&htab->lru, &l->lru_node);
> +                       else
> +                               free_htab_elem(htab, l);
> +               }
> +       }
> +
> +       batch++;
> +       if (batch >= htab->n_buckets) {
> +               batch = 0;
> +               goto after_loop;
> +       }
> +
> +       raw_spin_unlock_irqrestore(&b->lock, flags);
> +       goto again;
> +
> +after_loop:
> +       raw_spin_unlock_irqrestore(&b->lock, flags);
> +
> +       rcu_read_unlock();
> +       this_cpu_dec(bpf_prog_active);
> +       preempt_enable();
> +
> +       /* copy data back to user */
> +       ukeys = u64_to_user_ptr(attr->batch.keys);
> +       uvalues = u64_to_user_ptr(attr->batch.values);
> +       if (put_user(batch, &uattr->batch.batch) ||
> +           copy_to_user(ukeys, keys, total * key_size) ||
> +           copy_to_user(uvalues, values, total * value_size) ||
> +           put_user(total, &uattr->batch.count))
> +               ret = -EFAULT;
> +
> +out:
> +       kvfree(keys);
> +       kvfree(values);
> +       return ret;
> +}
> +
> +static int
> +__htab_map_update_batch(struct bpf_map *map, const union bpf_attr *attr,
> +                       union bpf_attr __user *uattr, bool is_lru_map)
> +{
> +       struct bpf_htab *htab = container_of(map, struct bpf_htab, map);
> +       u32 count, max_count, key_size, roundup_key_size, value_size;
> +       u64 elem_map_flags, map_flags;
> +       void __user *ukey, *uvalue;
> +       void *key, *value;
> +       int ret = 0;
> +
> +       max_count = attr->batch.count;
> +       if (!max_count)
> +               return 0;
> +
> +       elem_map_flags = attr->batch.elem_flags;
> +       if ((elem_map_flags & BPF_F_LOCK) && !map_value_has_spin_lock(map))
> +               return -EINVAL;
> +
> +       map_flags = attr->batch.flags;
> +       if (map_flags)
> +               return -EINVAL;
> +
> +       key_size = htab->map.key_size;
> +       roundup_key_size = round_up(htab->map.key_size, 8);
> +       value_size = htab->map.value_size;
> +       key = kmalloc(key_size, GFP_USER | __GFP_NOWARN);
> +       value = kmalloc(value_size, GFP_USER | __GFP_NOWARN);
> +       if (!key || !value) {
> +               ret = -ENOMEM;
> +               goto out;
> +       }
> +
> +       ukey = u64_to_user_ptr(attr->batch.keys);
> +       uvalue = u64_to_user_ptr(attr->batch.values);
> +       for (count = 0; count < max_count; count++) {
> +               if (copy_from_user(key, ukey + count * key_size, key_size) ||
> +                   copy_from_user(value, uvalue + count * value_size, value_size)) {
> +                       ret = -EFAULT;
> +                       break;
> +               }
> +
> +               preempt_disable();
> +               __this_cpu_inc(bpf_prog_active);
> +               rcu_read_lock();
> +               if (is_lru_map)
> +                       ret = htab_lru_map_update_elem(map, key, value, elem_map_flags);
> +               else
> +                       ret = htab_map_update_elem(map, key, value, elem_map_flags);
> +               rcu_read_unlock();
> +               __this_cpu_dec(bpf_prog_active);
> +               preempt_enable();
> +
> +               if (ret) {
> +                       if (put_user(count, &uattr->batch.count))
> +                               ret = -EFAULT;
> +                       break;
> +               }
> +       }
> +
> +out:
> +       kfree(key);
> +       kfree(value);
> +       return ret;
> +}
> +
> +static int
> +__htab_map_delete_batch(struct bpf_map *map,
> +                       const union bpf_attr *attr,
> +                       union bpf_attr __user *uattr,
> +                       bool is_lru_map)
> +{
> +       struct bpf_htab *htab = container_of(map, struct bpf_htab, map);
> +       u64 elem_map_flags, map_flags;
> +       struct hlist_nulls_head *head;
> +       struct hlist_nulls_node *n;
> +       u32 batch, max_count;
> +       unsigned long flags;
> +       struct htab_elem *l;
> +       struct bucket *b;
> +
> +       elem_map_flags = attr->batch.elem_flags;
> +       map_flags = attr->batch.flags;
> +       if (elem_map_flags || map_flags)
> +               return -EINVAL;
> +
> +       max_count = attr->batch.count;
> +       batch = (u32)attr->batch.batch;
> +       if (max_count || batch >= htab->n_buckets)
> +               return -EINVAL;
> +
> +       preempt_disable();
> +       __this_cpu_inc(bpf_prog_active);
> +       rcu_read_lock();
> +
> +again:
> +       b = &htab->buckets[batch];
> +       head = &b->head;
> +       raw_spin_lock_irqsave(&b->lock, flags);
> +
> +       hlist_nulls_for_each_entry_rcu(l, n, head, hash_node) {
> +               hlist_nulls_del_rcu(&l->hash_node);
> +               if (is_lru_map)
> +                       bpf_lru_push_free(&htab->lru, &l->lru_node);
> +               else
> +                       free_htab_elem(htab, l);
> +       }
> +
> +       batch++;
> +       if (batch >= htab->n_buckets)
> +               goto out;
> +
> +       raw_spin_unlock_irqrestore(&b->lock, flags);
> +       goto again;
> +
> +out:
> +       raw_spin_unlock_irqrestore(&b->lock, flags);
> +       rcu_read_unlock();
> +       __this_cpu_dec(bpf_prog_active);
> +       preempt_enable();
> +
> +       return 0;
> +}
> +
> +static int
> +htab_map_lookup_batch(struct bpf_map *map, const union bpf_attr *attr,
> +                     union bpf_attr __user *uattr)
> +{
> +       return __htab_map_lookup_and_delete_batch(map, attr, uattr, false,
> +                                                 false);
> +}
> +
> +static int
> +htab_map_lookup_and_delete_batch(struct bpf_map *map,
> +                                const union bpf_attr *attr,
> +                                union bpf_attr __user *uattr)
> +{
> +       return __htab_map_lookup_and_delete_batch(map, attr, uattr, true,
> +                                                 false);
> +}
> +
> +static int
> +htab_map_update_batch(struct bpf_map *map, const union bpf_attr *attr,
> +                     union bpf_attr __user *uattr)
> +{
> +       return __htab_map_update_batch(map, attr, uattr, false);
> +}
> +
> +static int
> +htab_map_delete_batch(struct bpf_map *map,
> +                     const union bpf_attr *attr,
> +                     union bpf_attr __user *uattr)
> +{
> +       return __htab_map_delete_batch(map, attr, uattr, false);
> +}
> +
> +static int
> +htab_lru_map_lookup_batch(struct bpf_map *map, const union bpf_attr *attr,
> +                         union bpf_attr __user *uattr)
> +{
> +       return __htab_map_lookup_and_delete_batch(map, attr, uattr, false,
> +                                                 true);
> +}
> +
> +static int
> +htab_lru_map_lookup_and_delete_batch(struct bpf_map *map,
> +                                    const union bpf_attr *attr,
> +                                    union bpf_attr __user *uattr)
> +{
> +       return __htab_map_lookup_and_delete_batch(map, attr, uattr, true,
> +                                                 true);
> +}
> +
> +static int
> +htab_lru_map_update_batch(struct bpf_map *map, const union bpf_attr *attr,
> +                         union bpf_attr __user *uattr)
> +{
> +       return __htab_map_update_batch(map, attr, uattr, true);
> +}
> +
> +static int
> +htab_lru_map_delete_batch(struct bpf_map *map,
> +                         const union bpf_attr *attr,
> +                         union bpf_attr __user *uattr)
> +{
> +       return __htab_map_delete_batch(map, attr, uattr, true);
> +}
> +
>  const struct bpf_map_ops htab_map_ops = {
>         .map_alloc_check = htab_map_alloc_check,
>         .map_alloc = htab_map_alloc,
> @@ -1242,6 +1558,10 @@ const struct bpf_map_ops htab_map_ops = {
>         .map_delete_elem = htab_map_delete_elem,
>         .map_gen_lookup = htab_map_gen_lookup,
>         .map_seq_show_elem = htab_map_seq_show_elem,
> +       .map_lookup_batch = htab_map_lookup_batch,
> +       .map_lookup_and_delete_batch = htab_map_lookup_and_delete_batch,
> +       .map_update_batch = htab_map_update_batch,
> +       .map_delete_batch = htab_map_delete_batch,
>  };
>
>  const struct bpf_map_ops htab_lru_map_ops = {
> @@ -1255,6 +1575,10 @@ const struct bpf_map_ops htab_lru_map_ops = {
>         .map_delete_elem = htab_lru_map_delete_elem,
>         .map_gen_lookup = htab_lru_map_gen_lookup,
>         .map_seq_show_elem = htab_map_seq_show_elem,
> +       .map_lookup_batch = htab_lru_map_lookup_batch,
> +       .map_lookup_and_delete_batch = htab_lru_map_lookup_and_delete_batch,
> +       .map_update_batch = htab_lru_map_update_batch,
> +       .map_delete_batch = htab_lru_map_delete_batch,
>  };
>
>  /* Called from eBPF program */
> diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
> index ca60eafa6922..e83bdf7efbd8 100644
> --- a/kernel/bpf/syscall.c
> +++ b/kernel/bpf/syscall.c
> @@ -2816,6 +2816,62 @@ static int bpf_task_fd_query(const union bpf_attr *attr,
>         return err;
>  }
>
> +#define BPF_MAP_BATCH_LAST_FIELD batch.flags
> +
> +#define BPF_DO_BATCH(fn)                       \
> +       do {                                    \
> +               if (!fn) {                      \
> +                       err = -ENOTSUPP;        \
> +                       goto err_put;           \
> +               }                               \
> +               err = fn(map, attr, uattr);     \
> +       } while(0)
> +
> +static int bpf_map_do_batch(const union bpf_attr *attr,
> +                           union bpf_attr __user *uattr,
> +                           int cmd)
> +{
> +       struct bpf_map *map;
> +       int err, ufd;
> +       struct fd f;
> +
> +       if (CHECK_ATTR(BPF_MAP_BATCH))
> +               return -EINVAL;
> +
> +       ufd = attr->batch.map_fd;
> +       f = fdget(ufd);
> +       map = __bpf_map_get(f);
> +       if (IS_ERR(map))
> +               return PTR_ERR(map);
> +
> +       if ((cmd == BPF_MAP_LOOKUP_BATCH ||
> +            cmd == BPF_MAP_LOOKUP_AND_DELETE_BATCH) &&
> +           !(map_get_sys_perms(map, f) & FMODE_CAN_READ)) {
> +               err = -EPERM;
> +               goto err_put;
> +       }
> +
> +       if (cmd != BPF_MAP_LOOKUP_BATCH &&
> +           !(map_get_sys_perms(map, f) & FMODE_CAN_WRITE)) {
> +               err = -EPERM;
> +               goto err_put;
> +       }
> +
> +       if (cmd == BPF_MAP_LOOKUP_BATCH) {
> +               BPF_DO_BATCH(map->ops->map_lookup_batch);
> +       } else if (cmd == BPF_MAP_LOOKUP_AND_DELETE_BATCH) {
> +               BPF_DO_BATCH(map->ops->map_lookup_and_delete_batch);
> +       } else if (cmd == BPF_MAP_UPDATE_BATCH) {
> +               BPF_DO_BATCH(map->ops->map_update_batch);
> +       } else {
> +               BPF_DO_BATCH(map->ops->map_delete_batch);
> +       }
> +
> +err_put:
> +       fdput(f);
> +       return err;
> +}
> +
>  SYSCALL_DEFINE3(bpf, int, cmd, union bpf_attr __user *, uattr, unsigned int, size)
>  {
>         union bpf_attr attr = {};
> @@ -2913,6 +2969,18 @@ SYSCALL_DEFINE3(bpf, int, cmd, union bpf_attr __user *, uattr, unsigned int, siz
>         case BPF_MAP_LOOKUP_AND_DELETE_ELEM:
>                 err = map_lookup_and_delete_elem(&attr);
>                 break;
> +       case BPF_MAP_LOOKUP_BATCH:
> +               err = bpf_map_do_batch(&attr, uattr, BPF_MAP_LOOKUP_BATCH);
> +               break;
> +       case BPF_MAP_LOOKUP_AND_DELETE_BATCH:
> +               err = bpf_map_do_batch(&attr, uattr, BPF_MAP_LOOKUP_AND_DELETE_BATCH);
> +               break;
> +       case BPF_MAP_UPDATE_BATCH:
> +               err = bpf_map_do_batch(&attr, uattr, BPF_MAP_UPDATE_BATCH);
> +               break;
> +       case BPF_MAP_DELETE_BATCH:
> +               err = bpf_map_do_batch(&attr, uattr, BPF_MAP_DELETE_BATCH);
> +               break;
>         default:
>                 err = -EINVAL;
>                 break;
> --
> 2.17.1
>

In general it'd be great if we could express the old functions
(get_next_key, lookup, delete) in terms of this new ones so we  avoid
having twice the code.

Also to be honest I don't see how batching updates would be useful,
maybe just try to do batching lookup and lookup_and_delete?
