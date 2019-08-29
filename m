Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BAF5DA2A76
	for <lists+netdev@lfdr.de>; Fri, 30 Aug 2019 01:01:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728230AbfH2XBh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Aug 2019 19:01:37 -0400
Received: from mail-lj1-f196.google.com ([209.85.208.196]:43988 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728186AbfH2XBg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Aug 2019 19:01:36 -0400
Received: by mail-lj1-f196.google.com with SMTP id h15so4613572ljg.10
        for <netdev@vger.kernel.org>; Thu, 29 Aug 2019 16:01:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=dWpG0YUJK4oh97pmATFFGm5Bx2chV77bCMHwj+U/rzs=;
        b=VuTBOHveQY4ECCWJawPUkFir2Mkr3Pc5QEum8ohGsf0SMDR/muT3SPS6HpUQrmWNch
         U7KuqDSjK/bIGZlmNfFtVfmRft1uSbjb58oL+f5sctrrLpWrNUMxLgqVnESt/GrMoK4g
         N9xITWbTi0J83XcJXiptBg3vk5k3BwkNbE18x72x3w+BYnWWUXug1DtY03RxDTmrMR6h
         KO6kfofFjTVtH5u1ksCcIu3CPpVaXHuRfMEppd89yswXqPjXtdGV/eaO06plv7/5G21s
         V8yU7WbPa7/evucSbiXbCj9qT0HIvPgyU1ceOg4W4qXm6oET9fg5xoEz6207A0u+wbj6
         d8SA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=dWpG0YUJK4oh97pmATFFGm5Bx2chV77bCMHwj+U/rzs=;
        b=itgeu0xiOFoOUSvQCYwbuWpgoGaVBMnijsniyrIwCmN63W9tKmPUlGqOhbykyYYfa6
         qYqh6GJ9vmAVWPtehpoSQkyI2j0DI69eo2hPM4f2hqxQai1mjJ7G8UPp+Vlvj3KIAiYE
         V2p5uQiwu+MO+e4iyVR6B9XkpabUFuKYT/Umyxa2hl3ha+AIaREw82qZD/CPj4DxTSz5
         XKwT4vn8joNFEIIxqt4V4FcO9foUYuXO/Ze8/5qxBFvEcgwagvck7ySt/togjsmlUaaz
         bnpsqAJhoNMKNxIjoU8DyRchVYmG6lYP9IxgU9alG6L9RzJf5ghjWC3dtWgDZhYrvVpH
         LZYg==
X-Gm-Message-State: APjAAAXbMReCvDxGFfZHv/cOngtw3iN+nNLInzWvEEnEcnKh47XPEtsJ
        XvyKr9pLmzRYnVBxMH3KaU1JAfNsVAEK7vfXeHTYjQ==
X-Google-Smtp-Source: APXvYqxNpzicsUuQwo1oQCc+GPzNucP83JZz9Ef59f8nvkHELkz0gFCaDSokDUztXkMvX6PkYbWDLzZOxJnfQsdhHMg=
X-Received: by 2002:a2e:8794:: with SMTP id n20mr5597064lji.116.1567119693426;
 Thu, 29 Aug 2019 16:01:33 -0700 (PDT)
MIME-Version: 1.0
References: <20190829064502.2750303-1-yhs@fb.com> <20190829064507.2750795-1-yhs@fb.com>
In-Reply-To: <20190829064507.2750795-1-yhs@fb.com>
From:   Brian Vazquez <brianvv@google.com>
Date:   Thu, 29 Aug 2019 16:01:22 -0700
Message-ID: <CAMzD94RuPs8_BHNRDjk6NDkyi=hJ+pCKeLb3ihACLYaOWz8sAA@mail.gmail.com>
Subject: Re: [PATCH bpf-next 05/13] bpf: adding map batch processing support
To:     Yonghong Song <yhs@fb.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>, kernel-team@fb.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Yonghong!

Thanks for sending this series of patches and starting the discussion.

On Wed, Aug 28, 2019 at 11:45 PM Yonghong Song <yhs@fb.com> wrote:
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
> covers other potential use cases. Four bpf syscall subcommands are introduced:
>         BPF_MAP_LOOKUP_BATCH
>         BPF_MAP_LOOKUP_AND_DELETE_BATCH
>         BPF_MAP_UPDATE_BATCH
>         BPF_MAP_DELETE_BATCH
>
> The UAPI attribute structure looks like:
>         struct { /* struct used by BPF_MAP_*_BATCH commands */
>                 __aligned_u64   start_key;      /* input: storing start key,
>                                                  * if NULL, starting from the beginning.
>                                                  */
>                 __aligned_u64   next_start_key; /* output: storing next batch start_key,
>                                                  * if NULL, no next key.
>                                                  */
>                 __aligned_u64   keys;           /* input/output: key buffer */
>                 __aligned_u64   values;         /* input/output: value buffer */
>                 __u32           count;          /* input: # of keys/values in
>                                                  *   or fits in keys[]/values[].
>                                                  * output: how many successful
>                                                  *   lookup/lookup_and_delete
>                                                  *   /delete/update operations.
>                                                  */
>                 __u32           map_fd;
>                 __u64           elem_flags;     /* BPF_MAP_{UPDATE,LOOKUP}_ELEM flags */
>                 __u64           flags;          /* flags for batch operation */
>         } batch;
>
> The 'start_key' and 'next_start_key' are used to BPF_MAP_LOOKUP_BATCH,
> BPF_MAP_LOOKUP_AND_DELETE_BATCH and BPF_MAP_DELETE_BATCH
> to start the operation on 'start_key' and also set the
> next batch start key in 'next_start_key'.
>
> If 'count' is greater than 0 and the return code is 0,
>   . the 'count' may be updated to be smaller if there is less
>     elements than 'count' for the operation. In such cases,
>     'next_start_key' will be set to NULL.
>   . the 'count' remains the same. 'next_start_key' could be NULL
>     or could point to next start_key for batch processing.
>
> If 'count' is greater than 0 and the return code is an error
> other than -EFAULT, the kernel will try to overwrite 'count'
> to contain the number of successful element-level (lookup,
> lookup_and_delete, update and delete) operations. The following
> attributes can be checked:
>   . if 'count' value is modified, the new value will be
>     the number of successful element-level operations.
>   . if 'count' value is modified, the keys[]/values[] will
>     contain correct results for new 'count' number of
>     operations for lookup[_and_delete] and update.
>
> The implementation in this patch mimics what user space
> did, e.g., for lookup_and_delete,
>     while(bpf_get_next_key(map, keyp, next_keyp) == 0) {
>        bpf_map_delete_elem(map, keyp);
>        bpf_map_lookup_elem(map, next_keyp, &value, flags);
>        keyp, next_keyp = next_keyp, keyp;
>     }
> The similar loop is implemented in the kernel, and
> each operation, bpf_get_next_key(), bpf_map_delete_elem()
> and bpf_map_lookup_elem(), uses existing kernel functions
> each of which has its own rcu_read_lock region, bpf_prog_active
> protection, etc.
> Therefore, it is totally possible that after bpf_get_next_key(),
> the bpf_map_delete_elem() or bpf_map_lookup_elem() may fail
> as the key may be deleted concurrently by kernel or
> other user space processes/threads.
> By default, the current implementation permits the loop
> to continue, just like typical user space handling. But
> a flag, BPF_F_ENFORCE_ENOENT, can be specified, so kernel
> will return an error if bpf_map_delete_elem() or
> bpf_map_lookup_elem() failed.
>
> The high-level algorithm for BPF_MAP_LOOKUP_BATCH and
> BPF_MAP_LOOKUP_AND_DELETE_BATCH:
>         if (start_key == NULL and next_start_key == NULL) {
>                 lookup up to 'count' keys in keys[] and fill
>                 corresponding values[], and delete those
>                 keys if BPF_MAP_LOOKUP_AND_DELETE_BATCH.
>         } else if (start_key == NULL && next_start_key != NULL) {
>                 lookup up to 'count' keys from the beginning
>                 of the map and fill keys[]/values[], delete
>                 those keys if BPF_MAP_LOOKUP_AND_DELETE_BATCH.
>                 Set 'next_start_key' for next batch operation.
>         } else if (start_key != NULL && next_start_key != NULL) {
>                 lookup to 'count' keys from 'start_key', inclusive,
>                 and fill keys[]/values[], delete those keys if
>                 BPF_MAP_LOOKUP_AND_DELETE_BATCH.
>                 Set 'next_start_key' for next batch operation.
>         }
>
> The high-level algorithm for BPF_MAP_UPDATE_BATCH:
>         if (count != 0) {
>                 do 'count' number of updates on keys[]/values[].
>         }
>
> The high-level algorithm for BPF_MAP_DELETE_BATCH:
>         if (count == 0) {
>                 if (start_key == NULL) {
>                         delete all elements from map.
>                 } else {
>                         delete all elements from start_key to the end of map.
>                 }
>         } else {
>                 if (start_key == NULL and next_start_key == NULL) {
>                         delete 'count' number of keys in keys[].
>                 } else if (start_key == NULL and next_start_key != NULL) {
>                         delete 'count' number of keys from the
>                         beginning of the map and set 'next_start_key'
>                         properly.
>                 } else if (start_key != NULL and next_start_keeey != NULL) {
>                         delete 'count' number of keys from 'start_key',
>                         and set 'next_start_key' properly.
>                 }
>         }
>
> Signed-off-by: Yonghong Song <yhs@fb.com>
> ---
>  include/uapi/linux/bpf.h |  27 +++
>  kernel/bpf/syscall.c     | 448 +++++++++++++++++++++++++++++++++++++++
>  2 files changed, 475 insertions(+)
>
> diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
> index 5d2fb183ee2d..576688f13e8c 100644
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
> @@ -347,6 +351,9 @@ enum bpf_attach_type {
>  /* flags for BPF_PROG_QUERY */
>  #define BPF_F_QUERY_EFFECTIVE  (1U << 0)
>
> +/* flags for BPF_MAP_*_BATCH */
> +#define BPF_F_ENFORCE_ENOENT   (1U << 0)
> +
>  enum bpf_stack_build_id_status {
>         /* user space need an empty entry to identify end of a trace */
>         BPF_STACK_BUILD_ID_EMPTY = 0,
> @@ -396,6 +403,26 @@ union bpf_attr {
>                 __u64           flags;
>         };
>
> +       struct { /* struct used by BPF_MAP_*_BATCH commands */
> +               __aligned_u64   start_key;      /* input: storing start key,
> +                                                * if NULL, starting from the beginning.
> +                                                */
> +               __aligned_u64   next_start_key; /* output: storing next batch start_key,
> +                                                * if NULL, no next key.
> +                                                */
> +               __aligned_u64   keys;           /* input/output: key buffer */
> +               __aligned_u64   values;         /* input/output: value buffer */
> +               __u32           count;          /* input: # of keys/values in
> +                                                *   or fits in keys[]/values[].
> +                                                * output: how many successful
> +                                                *   lookup/lookup_and_delete
> +                                                *   update/delete operations.
> +                                                */
> +               __u32           map_fd;
> +               __u64           elem_flags;     /* BPF_MAP_*_ELEM flags */
> +               __u64           flags;          /* flags for batch operation */
> +       } batch;
> +
>         struct { /* anonymous struct used by BPF_PROG_LOAD command */
>                 __u32           prog_type;      /* one of enum bpf_prog_type */
>                 __u32           insn_cnt;
> diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
> index 06308f0206e5..8746b55405f9 100644
> --- a/kernel/bpf/syscall.c
> +++ b/kernel/bpf/syscall.c
> @@ -33,6 +33,17 @@
>
>  #define BPF_OBJ_FLAG_MASK   (BPF_F_RDONLY | BPF_F_WRONLY)
>
> +#define BPF_MAP_BATCH_SWAP_KEYS(key1, key2, buf1, buf2)        \
> +       do {                                            \
> +               if (key1 == (buf1)) {                   \
> +                       key1 = buf2;                    \
> +                       key2 = buf1;                    \
> +               } else {                                \
> +                       key1 = buf1;                    \
> +                       key2 = buf2;                    \
> +               }                                       \
> +       } while (0)                                     \
> +
>  DEFINE_PER_CPU(int, bpf_prog_active);
>  static DEFINE_IDR(prog_idr);
>  static DEFINE_SPINLOCK(prog_idr_lock);
> @@ -1183,6 +1194,431 @@ static int map_lookup_and_delete_elem(union bpf_attr *attr)
>         return err;
>  }
>
> +static void __map_batch_get_attrs(const union bpf_attr *attr,
> +                                 void __user **skey, void __user **nskey,
> +                                 void __user **keys, void __user **values,
> +                                 u32 *max_count, u64 *elem_flags, u64 *flags)
> +{
> +       *skey = u64_to_user_ptr(attr->batch.start_key);
> +       *nskey = u64_to_user_ptr(attr->batch.next_start_key);
> +       *keys = u64_to_user_ptr(attr->batch.keys);
> +       *values = u64_to_user_ptr(attr->batch.values);
> +       *max_count = attr->batch.count;
> +       *elem_flags = attr->batch.elem_flags;
> +       *flags = attr->batch.flags;
> +}
> +
> +static int
> +__map_lookup_delete_batch_key_in_keys(struct bpf_map *map, void *key, void *value,
> +                                     u32 max_count, u32 key_size, u32 value_size,
> +                                     u64 elem_flags, void __user *keys,
> +                                     void __user *values,
> +                                     union bpf_attr __user *uattr,
> +                                     bool ignore_enoent)
> +{
> +       u32 count, missed = 0;
> +       int ret = 0, err;
> +
> +       for (count = 0; count < max_count; count++) {
> +               if (copy_from_user(key, keys + count * key_size, key_size)) {
> +                       ret = -EFAULT;
> +                       break;
> +               }
> +
> +               ret = bpf_map_copy_value(map, key, value, elem_flags);
> +               if (ret) {
> +                       if (ret != -ENOENT || !ignore_enoent)
> +                               break;
> +
> +                       missed++;
> +                       continue;
> +               }
> +
> +
> +               if (copy_to_user(values + count * value_size, value, value_size)) {
> +                       ret = -EFAULT;
> +                       break;
> +               }
> +
> +               ret = bpf_map_delete_elem(map, key);
> +               if (ret) {
> +                       if (ret != -ENOENT || !ignore_enoent)
> +                               break;
> +
> +                       missed++;
> +               }
> +       }
> +
> +       count -= missed;
> +       if ((!ret && missed) || (ret && ret != -EFAULT)) {
> +               err = put_user(count, &uattr->batch.count);
> +               ret = err ? : ret;
> +       }
> +
> +       return ret;
> +}
> +
> +static int map_lookup_and_delete_batch(struct bpf_map *map,
> +                                      const union bpf_attr *attr,
> +                                      union bpf_attr __user *uattr,
> +                                      bool do_delete)
> +{
> +       u32 max_count, count = 0, key_size, roundup_key_size, value_size;
> +       bool ignore_enoent, nextkey_is_null, copied;
> +       void *buf = NULL, *key, *value, *next_key;
> +       void __user *skey, *nskey, *keys, *values;
> +       u64 elem_flags, flags, zero = 0;
> +       int err, ret = 0;
> +
> +       if (map->map_type == BPF_MAP_TYPE_QUEUE ||
> +           map->map_type == BPF_MAP_TYPE_STACK)
> +               return -ENOTSUPP;
> +
> +       __map_batch_get_attrs(attr, &skey, &nskey, &keys, &values, &max_count,
> +                             &elem_flags, &flags);
> +
> +       if (elem_flags & ~BPF_F_LOCK || flags & ~BPF_F_ENFORCE_ENOENT)
> +               return -EINVAL;
> +
> +       if (!max_count)
> +               return 0;
> +
> +       /* The following max_count/skey/nskey combinations are supported:
> +        * max_count != 0 && !skey && !nskey: loop/delete max_count elements in keys[]/values[].
> +        * max_count != 0 && !skey && nskey: loop/delete max_count elements starting from map start.
> +        * max_count != 0 && skey && nskey: loop/delete max_count elements starting from skey.
> +        */
> +       if (skey && !nskey)
> +               return -EINVAL;
> +
> +       /* allocate space for two keys and one value. */
> +       key_size = map->key_size;
> +       roundup_key_size = round_up(map->key_size, 8);
> +       value_size = bpf_map_value_size(map);
> +       buf = kmalloc(roundup_key_size * 2 + value_size, GFP_USER | __GFP_NOWARN);
> +       if (!buf)
> +               return -ENOMEM;
> +
> +       key = buf;
> +       next_key = buf + roundup_key_size;
> +       value = buf + roundup_key_size * 2;
> +       ignore_enoent = !(flags & BPF_F_ENFORCE_ENOENT);
> +
> +       if (!skey && !nskey) {
> +               /* handle cases where keys in keys[] */
> +               ret = __map_lookup_delete_batch_key_in_keys(map, key, value, max_count,
> +                                                           key_size, value_size,
> +                                                           elem_flags, keys, values,
> +                                                           uattr, ignore_enoent);
> +               goto out;
> +       }
> +
> +       /* Get the first key. */
> +       if (!skey) {
> +               ret = bpf_map_get_next_key(map, NULL, key);
> +               if (ret) {
> +                       nextkey_is_null = true;
> +                       goto after_loop;
> +               }
> +       } else if (copy_from_user(key, skey, key_size)) {
> +               ret = -EFAULT;
> +               goto out;
> +       }
> +
> +       /* Copy the first key/value pair */
> +       ret = bpf_map_copy_value(map, key, value, elem_flags);
> +       if (ret) {
> +               if (skey)
> +                       goto out;
> +
> +               nextkey_is_null = true;
> +               goto after_loop;
> +       }
> +
> +       if (copy_to_user(keys, key, key_size) ||
> +           copy_to_user(values, value, value_size)) {
> +               ret = -EFAULT;
> +               goto out;
> +       }
> +
> +       /* We will always try to get next_key first
> +        * and then delete the current key.
> +        */
> +       ret = bpf_map_get_next_key(map, key, next_key);

One of the issues I see in this implementation is that is still
relying on the existing functions and has the same consistency
problems that my attempt had.

The problem happens when you are trying to do batch lookup on a
hashmap and when executing bpf_map_get_next_key(map, key, next_key)
the key is removed, then that call will return the first key and you'd
start iterating the map from the beginning again and retrieve
duplicate information.

Note that sometimes you can also start from the same bucket when the
key is updated while dumping it because it can be inserted on the head
of the bucket so you could potentially revisit elements that you had
already visited.

From previous discussion my understanding was that what we wanted was
to pursue 'atomic' compounded operations first and after that, try to
batch them. Although I don't think there's an easy way of batching and
being consistent at the same time.
