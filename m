Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 49AED6475F9
	for <lists+netdev@lfdr.de>; Thu,  8 Dec 2022 20:07:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230048AbiLHTHp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Dec 2022 14:07:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230033AbiLHTHl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Dec 2022 14:07:41 -0500
Received: from mail-pg1-x52f.google.com (mail-pg1-x52f.google.com [IPv6:2607:f8b0:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D4458F0A4
        for <netdev@vger.kernel.org>; Thu,  8 Dec 2022 11:07:31 -0800 (PST)
Received: by mail-pg1-x52f.google.com with SMTP id 62so1905375pgb.13
        for <netdev@vger.kernel.org>; Thu, 08 Dec 2022 11:07:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=TNmZs7xdPt2yB6Pp3QzBpCh+NFgEVAZP45QZ6VnrGKk=;
        b=fdeav+O+fgceEM0gL1i28BDJqyCedZUmtJCLgupSzgx8memqy09DHjFis8sE+lOQit
         ZN5a4qs9u9f8cTJuS5jwsuQ/LbyBUxKJi+F7vr7th8mevH4wWMEgEvOpRdMzCcuHClg8
         1u03uLl3BC0BSh5YJPiPj1bfsiMPqZNlQr+Q6tcXoeXkX0U8nkOI6+LRX7mQsw9dm2uw
         DCSGcTK84Mh1XHMt81Xm1uRMN7AbDVVAY8Cm/EmKRaXKGuy+oCislH59/l5KjzIM/lpq
         Ul5b9dA11uRv0WXW4hbfdmyw5CJW4zT2oJzh2snI6/BECRscMpa5aBrdW9ORg8slzUBS
         GaUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=TNmZs7xdPt2yB6Pp3QzBpCh+NFgEVAZP45QZ6VnrGKk=;
        b=4MTzP/yDsTtjRhtpfy+uwAa/IekrVXxI+uGnRDQ6g0lEnRchEJr0g6JG3M+vNbTZR5
         hCoYnfjxwYnzv2AeYEb426XhQxX72sXTg4e0kQqOfC4mxz6/e1C+XFz34GwnqJGPuRaY
         lKYmxtH6pUFsB/GsIN7xi/3EaZzQGj9tZORjdeTMB3yMMl+jkpqgSJCwKqylo70fzsRR
         gI2y1tES6Jl5hemf7AGQpB04eB13BoxhcoIhrNbrLE9hA5MD0HzcarVPbwAGLjUU2YBs
         7iMqJmsV+W3guQ9n7dyyQK6XHdK88gXTjQarKgbNCRrFgBICa84TG1AswlCcbTULnQwZ
         d6fg==
X-Gm-Message-State: ANoB5plkKr3bOS3Fy3q8YGnpXKszGl31VpXW8amk05RgKnwQemJYKy1v
        AopPczn/jDUMkkj15IwNyFraClr4e5HfcJGNCqNs5g==
X-Google-Smtp-Source: AA0mqf5itnPfDBCS55IWprjW54xD/q90fOr4shbMYlG7KKpZ0bH/JY4+OMwAQnHeqtLOx7uqmn619LHGnVsZlbXdlZ4=
X-Received: by 2002:aa7:820a:0:b0:574:a642:ad40 with SMTP id
 k10-20020aa7820a000000b00574a642ad40mr63992049pfi.42.1670526450848; Thu, 08
 Dec 2022 11:07:30 -0800 (PST)
MIME-Version: 1.0
References: <20221206024554.3826186-1-sdf@google.com> <20221206024554.3826186-4-sdf@google.com>
 <391b9abf-c53a-623c-055f-60768c716baa@linux.dev>
In-Reply-To: <391b9abf-c53a-623c-055f-60768c716baa@linux.dev>
From:   Stanislav Fomichev <sdf@google.com>
Date:   Thu, 8 Dec 2022 11:07:19 -0800
Message-ID: <CAKH8qBvfNDo-+qB-CyvCjQAcTtftWoQJTPwVb4zdAMZs=TzG7w@mail.gmail.com>
Subject: Re: [PATCH bpf-next v3 03/12] bpf: XDP metadata RX kfuncs
To:     Martin KaFai Lau <martin.lau@linux.dev>
Cc:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        song@kernel.org, yhs@fb.com, john.fastabend@gmail.com,
        kpsingh@kernel.org, haoluo@google.com, jolsa@kernel.org,
        David Ahern <dsahern@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Willem de Bruijn <willemb@google.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Anatoly Burakov <anatoly.burakov@intel.com>,
        Alexander Lobakin <alexandr.lobakin@intel.com>,
        Magnus Karlsson <magnus.karlsson@gmail.com>,
        Maryam Tahhan <mtahhan@redhat.com>, xdp-hints@xdp-project.net,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 7, 2022 at 6:47 PM Martin KaFai Lau <martin.lau@linux.dev> wrote:
>
> On 12/5/22 6:45 PM, Stanislav Fomichev wrote:
> > diff --git a/include/net/xdp.h b/include/net/xdp.h
> > index 55dbc68bfffc..c24aba5c363b 100644
> > --- a/include/net/xdp.h
> > +++ b/include/net/xdp.h
> > @@ -409,4 +409,33 @@ void xdp_attachment_setup(struct xdp_attachment_info *info,
> >
> >   #define DEV_MAP_BULK_SIZE XDP_BULK_QUEUE_SIZE
> >
> > +#define XDP_METADATA_KFUNC_xxx       \
> > +     XDP_METADATA_KFUNC(XDP_METADATA_KFUNC_RX_TIMESTAMP_SUPPORTED, \
> > +                        bpf_xdp_metadata_rx_timestamp_supported) \
> > +     XDP_METADATA_KFUNC(XDP_METADATA_KFUNC_RX_TIMESTAMP, \
> > +                        bpf_xdp_metadata_rx_timestamp) \
> > +     XDP_METADATA_KFUNC(XDP_METADATA_KFUNC_RX_HASH_SUPPORTED, \
> > +                        bpf_xdp_metadata_rx_hash_supported) \
> > +     XDP_METADATA_KFUNC(XDP_METADATA_KFUNC_RX_HASH, \
> > +                        bpf_xdp_metadata_rx_hash) \
> > +
> > +enum {
> > +#define XDP_METADATA_KFUNC(name, str) name,
> > +XDP_METADATA_KFUNC_xxx
> > +#undef XDP_METADATA_KFUNC
> > +MAX_XDP_METADATA_KFUNC,
> > +};
> > +
> > +#ifdef CONFIG_NET
>
> I think this is no longer needed because xdp_metadata_kfunc_id() is only used in
> offload.c which should be CONFIG_NET only.

Seems to be the case. At least my build tests with weird configs work,
thank you!

> > +u32 xdp_metadata_kfunc_id(int id);
> > +#else
> > +static inline u32 xdp_metadata_kfunc_id(int id) { return 0; }
> > +#endif
> > +
> > +struct xdp_md;
> > +bool bpf_xdp_metadata_rx_timestamp_supported(const struct xdp_md *ctx);
> > +u64 bpf_xdp_metadata_rx_timestamp(const struct xdp_md *ctx);
> > +bool bpf_xdp_metadata_rx_hash_supported(const struct xdp_md *ctx);
> > +u32 bpf_xdp_metadata_rx_hash(const struct xdp_md *ctx);
> > +
> >   #endif /* __LINUX_NET_XDP_H__ */
> > diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
> > index f89de51a45db..790650a81f2b 100644
> > --- a/include/uapi/linux/bpf.h
> > +++ b/include/uapi/linux/bpf.h
> > @@ -1156,6 +1156,11 @@ enum bpf_link_type {
> >    */
> >   #define BPF_F_XDP_HAS_FRAGS (1U << 5)
> >
> > +/* If BPF_F_XDP_HAS_METADATA is used in BPF_PROG_LOAD command, the loaded
> > + * program becomes device-bound but can access it's XDP metadata.
> > + */
> > +#define BPF_F_XDP_HAS_METADATA       (1U << 6)
> > +
>
> [ ... ]
>
> > diff --git a/kernel/bpf/offload.c b/kernel/bpf/offload.c
> > index f5769a8ecbee..bad8bab916eb 100644
> > --- a/kernel/bpf/offload.c
> > +++ b/kernel/bpf/offload.c
> > @@ -41,7 +41,7 @@ struct bpf_offload_dev {
> >   struct bpf_offload_netdev {
> >       struct rhash_head l;
> >       struct net_device *netdev;
> > -     struct bpf_offload_dev *offdev;
> > +     struct bpf_offload_dev *offdev; /* NULL when bound-only */
> >       struct list_head progs;
> >       struct list_head maps;
> >       struct list_head offdev_netdevs;
> > @@ -58,6 +58,12 @@ static const struct rhashtable_params offdevs_params = {
> >   static struct rhashtable offdevs;
> >   static bool offdevs_inited;
> >
> > +static int __bpf_offload_init(void);
> > +static int __bpf_offload_dev_netdev_register(struct bpf_offload_dev *offdev,
> > +                                          struct net_device *netdev);
> > +static void __bpf_offload_dev_netdev_unregister(struct bpf_offload_dev *offdev,
> > +                                             struct net_device *netdev);
> > +
> >   static int bpf_dev_offload_check(struct net_device *netdev)
> >   {
> >       if (!netdev)
> > @@ -87,13 +93,17 @@ int bpf_prog_offload_init(struct bpf_prog *prog, union bpf_attr *attr)
> >           attr->prog_type != BPF_PROG_TYPE_XDP)
> >               return -EINVAL;
> >
> > -     if (attr->prog_flags)
> > +     if (attr->prog_flags & ~BPF_F_XDP_HAS_METADATA)
> >               return -EINVAL;
> >
> >       offload = kzalloc(sizeof(*offload), GFP_USER);
> >       if (!offload)
> >               return -ENOMEM;
> >
> > +     err = __bpf_offload_init();
> > +     if (err)
> > +             return err;
> > +
> >       offload->prog = prog;
> >
> >       offload->netdev = dev_get_by_index(current->nsproxy->net_ns,
> > @@ -102,11 +112,25 @@ int bpf_prog_offload_init(struct bpf_prog *prog, union bpf_attr *attr)
> >       if (err)
> >               goto err_maybe_put;
> >
> > +     prog->aux->offload_requested = !(attr->prog_flags & BPF_F_XDP_HAS_METADATA);
> > +
>
> If I read the set correctly, bpf prog can either use metadata kfunc or offload
> but not both. It is fine to start with only supporting metadata kfunc when there
> is no offload but will be useful to understand the reason. I assume an offloaded
> bpf prog should still be able to call the bpf helpers like adjust_head/tail and
> the same should go for any kfunc?

Yes, I'm assuming there should be some work on the offloaded device
drivers to support metadata kfuncs.
Offloaded kfuncs, in general, seem hard (how do we call kernel func
from the device-offloaded prog?); so refusing kfuncs early for the
offloaded case seems fair for now?

> Also, the BPF_F_XDP_HAS_METADATA feels like it is acting more like
> BPF_F_XDP_DEV_BOUND_ONLY.

SG. Seems like a better option in case in the future binding to
devices might give some other nice perks besides the metadata..

> >       down_write(&bpf_devs_lock);
> >       ondev = bpf_offload_find_netdev(offload->netdev);
> >       if (!ondev) {
> > -             err = -EINVAL;
> > -             goto err_unlock;
> > +             if (!prog->aux->offload_requested) {
>
> nit. bpf_prog_is_offloaded(prog->aux)

Thx!

> > +                     /* When only binding to the device, explicitly
> > +                      * create an entry in the hashtable. See related
> > +                      * maybe_remove_bound_netdev.
> > +                      */
> > +                     err = __bpf_offload_dev_netdev_register(NULL, offload->netdev);
> > +                     if (err)
> > +                             goto err_unlock;
> > +                     ondev = bpf_offload_find_netdev(offload->netdev);
> > +             }
> > +             if (!ondev) {
> > +                     err = -EINVAL;
> > +                     goto err_unlock;
> > +             }
> >       }
> >       offload->offdev = ondev->offdev;
> >       prog->aux->offload = offload;
> > @@ -209,6 +233,19 @@ bpf_prog_offload_remove_insns(struct bpf_verifier_env *env, u32 off, u32 cnt)
> >       up_read(&bpf_devs_lock);
> >   }
> >
> > +static void maybe_remove_bound_netdev(struct net_device *dev)
> > +{
> > +     struct bpf_offload_netdev *ondev;
> > +
> > +     rtnl_lock();
> > +     down_write(&bpf_devs_lock);
> > +     ondev = bpf_offload_find_netdev(dev);
> > +     if (ondev && !ondev->offdev && list_empty(&ondev->progs))
> > +             __bpf_offload_dev_netdev_unregister(NULL, dev);
> > +     up_write(&bpf_devs_lock);
> > +     rtnl_unlock();
> > +}
> > +
> >   static void __bpf_prog_offload_destroy(struct bpf_prog *prog)
> >   {
> >       struct bpf_prog_offload *offload = prog->aux->offload;
> > @@ -226,10 +263,17 @@ static void __bpf_prog_offload_destroy(struct bpf_prog *prog)
> >
> >   void bpf_prog_offload_destroy(struct bpf_prog *prog)
> >   {
> > +     struct net_device *netdev = NULL;
> > +
> >       down_write(&bpf_devs_lock);
> > -     if (prog->aux->offload)
> > +     if (prog->aux->offload) {
> > +             netdev = prog->aux->offload->netdev;
> >               __bpf_prog_offload_destroy(prog);
> > +     }
> >       up_write(&bpf_devs_lock);
> > +
> > +     if (netdev)
>
> May be I have missed a refcnt or lock somewhere.  Is it possible that netdev may
> have been freed?

Yeah, with the offload framework, there are no refcnts. We put an
"offloaded" device into a separate hashtable (protected by
rtnl/semaphore).
maybe_remove_bound_netdev will re-grab the locks (due to ordering:
rtnl->bpf_devs_lock) and remove the device from the hashtable if it's
still there.
At least this is how, I think, it should work; LMK if something is
still fishy here...

Or is the concern here that somebody might allocate new netdev reusing
the same address? I think I have enough checks in
maybe_remove_bound_netdev to guard against that. Or, at least, to make
it safe :-)

> > +             maybe_remove_bound_netdev(netdev);
> >   }
> >
>
> [ ... ]
>
> > +void *bpf_offload_resolve_kfunc(struct bpf_prog *prog, u32 func_id)
> > +{
> > +     const struct net_device_ops *netdev_ops;
> > +     void *p = NULL;
> > +
> > +     down_read(&bpf_devs_lock);
> > +     if (!prog->aux->offload || !prog->aux->offload->netdev)
> > +             goto out;
> > +
> > +     netdev_ops = prog->aux->offload->netdev->netdev_ops;
> > +
> > +     if (func_id == xdp_metadata_kfunc_id(XDP_METADATA_KFUNC_RX_TIMESTAMP_SUPPORTED))
> > +             p = netdev_ops->ndo_xdp_rx_timestamp_supported;
> > +     else if (func_id == xdp_metadata_kfunc_id(XDP_METADATA_KFUNC_RX_TIMESTAMP))
> > +             p = netdev_ops->ndo_xdp_rx_timestamp;
> > +     else if (func_id == xdp_metadata_kfunc_id(XDP_METADATA_KFUNC_RX_HASH_SUPPORTED))
> > +             p = netdev_ops->ndo_xdp_rx_hash_supported;
> > +     else if (func_id == xdp_metadata_kfunc_id(XDP_METADATA_KFUNC_RX_HASH))
> > +             p = netdev_ops->ndo_xdp_rx_hash;
> > +     /* fallback to default kfunc when not supported by netdev */
> > +out:
> > +     up_read(&bpf_devs_lock);
> > +
> > +     return p;
> > +}
> > diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
> > index 13bc96035116..b345a273f7d0 100644
> > --- a/kernel/bpf/syscall.c
> > +++ b/kernel/bpf/syscall.c
> > @@ -2491,7 +2491,8 @@ static int bpf_prog_load(union bpf_attr *attr, bpfptr_t uattr)
> >                                BPF_F_TEST_STATE_FREQ |
> >                                BPF_F_SLEEPABLE |
> >                                BPF_F_TEST_RND_HI32 |
> > -                              BPF_F_XDP_HAS_FRAGS))
> > +                              BPF_F_XDP_HAS_FRAGS |
> > +                              BPF_F_XDP_HAS_METADATA))
> >               return -EINVAL;
> >
> >       if (!IS_ENABLED(CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS) &&
> > @@ -2575,7 +2576,7 @@ static int bpf_prog_load(union bpf_attr *attr, bpfptr_t uattr)
> >       prog->aux->attach_btf = attach_btf;
> >       prog->aux->attach_btf_id = attr->attach_btf_id;
> >       prog->aux->dst_prog = dst_prog;
> > -     prog->aux->offload_requested = !!attr->prog_ifindex;
> > +     prog->aux->dev_bound = !!attr->prog_ifindex;
> >       prog->aux->sleepable = attr->prog_flags & BPF_F_SLEEPABLE;
> >       prog->aux->xdp_has_frags = attr->prog_flags & BPF_F_XDP_HAS_FRAGS;
> >
> > @@ -2598,7 +2599,7 @@ static int bpf_prog_load(union bpf_attr *attr, bpfptr_t uattr)
> >       atomic64_set(&prog->aux->refcnt, 1);
> >       prog->gpl_compatible = is_gpl ? 1 : 0;
> >
> > -     if (bpf_prog_is_offloaded(prog->aux)) {
> > +     if (bpf_prog_is_dev_bound(prog->aux)) {
> >               err = bpf_prog_offload_init(prog, attr);
> >               if (err)
> >                       goto free_prog_sec;
> > diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
> > index fc4e313a4d2e..00951a59ee26 100644
> > --- a/kernel/bpf/verifier.c
> > +++ b/kernel/bpf/verifier.c
> > @@ -15323,6 +15323,24 @@ static int fixup_kfunc_call(struct bpf_verifier_env *env, struct bpf_insn *insn,
> >               return -EINVAL;
> >       }
> >
> > +     *cnt = 0;
> > +
> > +     if (resolve_prog_type(env->prog) == BPF_PROG_TYPE_XDP) {
>
> hmmm...does it need BPF_PROG_TYPE_XDP check? Is the below
> bpf_prog_is_dev_bound() and the eariler
> 'register_btf_kfunc_id_set(BPF_PROG_TYPE_XDP, &xdp_metadata_kfunc_set)' good enough?

Should be enough, yeah, will drop. I was being a bit defensive here in
case we have non-xdp device-bound programs in the future.


> > +             if (bpf_prog_is_offloaded(env->prog->aux)) {
> > +                     verbose(env, "no metadata kfuncs offload\n");
> > +                     return -EINVAL;
> > +             }
> > +
> > +             if (bpf_prog_is_dev_bound(env->prog->aux)) {
> > +                     void *p = bpf_offload_resolve_kfunc(env->prog, insn->imm);
> > +
> > +                     if (p) {
> > +                             insn->imm = BPF_CALL_IMM(p);
> > +                             return 0;
> > +                     }
> > +             }
> > +     }
> > +
>
>
