Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7D21464BE0E
	for <lists+netdev@lfdr.de>; Tue, 13 Dec 2022 21:42:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237129AbiLMUmr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Dec 2022 15:42:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237130AbiLMUmp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Dec 2022 15:42:45 -0500
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E4E75F9A
        for <netdev@vger.kernel.org>; Tue, 13 Dec 2022 12:42:43 -0800 (PST)
Received: by mail-pf1-x42c.google.com with SMTP id x66so3049378pfx.3
        for <netdev@vger.kernel.org>; Tue, 13 Dec 2022 12:42:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=XkHwLgn63fMXtP3ZcfbwPRrSo06n2QTz2CP/VYPmCsc=;
        b=IJe8VaWxvgAbcCcXTkBgySJQyeS0PlsGQdltZooJoUdQLa9xq3GoZa58fC5e0itUok
         Tn0OXC3go+kw3w+TriONeu+Kznt9JWRSxIjtqMkEa8ZX1lzDctPpRMZU5mcDGCK/HnIj
         ww1BO5pVkav4S35W/oXfOp2PWnEEW9AxuWbxXZuyXfnhaxYHMBMav+fa2lMb9lsGP38W
         0Ms6Vs9zrVKNXb5pkdZgDViT8AxWT/AlI9IAHXYU9yONNOru6oBguhkLmE+oqWcEsztT
         RGiw0nBAJ0ewdxyRmqW6DrHUV2ymQ5h2uwJNGG4DgWIMK1OIpyJZptjy5AzpOv4qTpua
         xAFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=XkHwLgn63fMXtP3ZcfbwPRrSo06n2QTz2CP/VYPmCsc=;
        b=uelfPSl4T9jUasqQ+lwXBWuLJELyHS+mOYdxSbLg4TWKH5iOo9olMay5DCIhZaktk+
         V9m3aky5yqX9VMAb5gsuLdnn0Ye6lwUV8Qbm3Nfy1vxPxjVP9qjgEUZ58LIQcfxVC8DA
         NVcq+fhMNlckgN5kjf7HSqR3CrpqA+uqSuOMtkoKIxEs8HQNXgfVIbwar4HTnFWCHUAy
         YpJeOiejVyg77aS8gfEtGfhnpGp7IBpkk4wF2MpLLXSnM+VJcyZv1s/gZ/Ra2byV2X4A
         PuIC9vgYXwt7t+5BbRITLS/wNv9HkU7fS+z9bHClthVDHjNPUyTRxPViQW23FWE/drtT
         OHYA==
X-Gm-Message-State: ANoB5pnrAIYnWXLbVQZtXLCmPYc7biyv6/9ymqcF8DY+idrI6k0ZXiYL
        8JXnpv0InI/HPLfhQaWyBPrj5orB8cDNJ7qCv4Xfew==
X-Google-Smtp-Source: AA0mqf6liYnI7MTSb0aiFsiwgvOdfPtstAEaXSYZItP8hh5VurVuu/s0R6kzwBGWiYInX3cAhqmDmPBc+mZNumw4H7Q=
X-Received: by 2002:a63:2160:0:b0:46f:f26e:e8ba with SMTP id
 s32-20020a632160000000b0046ff26ee8bamr72565608pgm.250.1670964162580; Tue, 13
 Dec 2022 12:42:42 -0800 (PST)
MIME-Version: 1.0
References: <20221213023605.737383-1-sdf@google.com> <20221213023605.737383-6-sdf@google.com>
 <Y5ivuUezkNpHUtCP@maniforge.lan>
In-Reply-To: <Y5ivuUezkNpHUtCP@maniforge.lan>
From:   Stanislav Fomichev <sdf@google.com>
Date:   Tue, 13 Dec 2022 12:42:30 -0800
Message-ID: <CAKH8qBtU6_aeVrgfUVEyOW2JrGRWf4o=d=H3hnM+aD_UW-gcEA@mail.gmail.com>
Subject: Re: [PATCH bpf-next v4 05/15] bpf: XDP metadata RX kfuncs
To:     David Vernet <void@manifault.com>
Cc:     bpf@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org, martin.lau@linux.dev, song@kernel.org,
        yhs@fb.com, john.fastabend@gmail.com, kpsingh@kernel.org,
        haoluo@google.com, jolsa@kernel.org,
        David Ahern <dsahern@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Willem de Bruijn <willemb@google.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Anatoly Burakov <anatoly.burakov@intel.com>,
        Alexander Lobakin <alexandr.lobakin@intel.com>,
        Magnus Karlsson <magnus.karlsson@gmail.com>,
        Maryam Tahhan <mtahhan@redhat.com>, xdp-hints@xdp-project.net,
        netdev@vger.kernel.org
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

On Tue, Dec 13, 2022 at 9:00 AM David Vernet <void@manifault.com> wrote:
>
> On Mon, Dec 12, 2022 at 06:35:55PM -0800, Stanislav Fomichev wrote:
> > Define a new kfunc set (xdp_metadata_kfunc_ids) which implements all possible
> > XDP metatada kfuncs. Not all devices have to implement them. If kfunc is not
> > supported by the target device, the default implementation is called instead.
> > The verifier, at load time, replaces a call to the generic kfunc with a call
> > to the per-device one. Per-device kfunc pointers are stored in separate
> > struct xdp_metadata_ops.
> >
> > Cc: John Fastabend <john.fastabend@gmail.com>
> > Cc: David Ahern <dsahern@gmail.com>
> > Cc: Martin KaFai Lau <martin.lau@linux.dev>
> > Cc: Jakub Kicinski <kuba@kernel.org>
> > Cc: Willem de Bruijn <willemb@google.com>
> > Cc: Jesper Dangaard Brouer <brouer@redhat.com>
> > Cc: Anatoly Burakov <anatoly.burakov@intel.com>
> > Cc: Alexander Lobakin <alexandr.lobakin@intel.com>
> > Cc: Magnus Karlsson <magnus.karlsson@gmail.com>
> > Cc: Maryam Tahhan <mtahhan@redhat.com>
> > Cc: xdp-hints@xdp-project.net
> > Cc: netdev@vger.kernel.org
> > Signed-off-by: Stanislav Fomichev <sdf@google.com>
> > ---
> >  include/linux/bpf.h       |  2 ++
> >  include/linux/netdevice.h |  7 +++++++
> >  include/net/xdp.h         | 25 ++++++++++++++++++++++
> >  kernel/bpf/core.c         |  7 +++++++
> >  kernel/bpf/offload.c      | 23 ++++++++++++++++++++
> >  kernel/bpf/verifier.c     | 29 +++++++++++++++++++++++++-
> >  net/core/xdp.c            | 44 +++++++++++++++++++++++++++++++++++++++
> >  7 files changed, 136 insertions(+), 1 deletion(-)
> >
> > diff --git a/include/linux/bpf.h b/include/linux/bpf.h
> > index ca22e8b8bd82..de6279725f41 100644
> > --- a/include/linux/bpf.h
> > +++ b/include/linux/bpf.h
> > @@ -2477,6 +2477,8 @@ void bpf_offload_dev_netdev_unregister(struct bpf_offload_dev *offdev,
> >                                      struct net_device *netdev);
> >  bool bpf_offload_dev_match(struct bpf_prog *prog, struct net_device *netdev);
> >
> > +void *bpf_dev_bound_resolve_kfunc(struct bpf_prog *prog, u32 func_id);
> > +
> >  void unpriv_ebpf_notify(int new_state);
> >
> >  #if defined(CONFIG_NET) && defined(CONFIG_BPF_SYSCALL)
> > diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
> > index 5aa35c58c342..63786091c60d 100644
> > --- a/include/linux/netdevice.h
> > +++ b/include/linux/netdevice.h
> > @@ -74,6 +74,7 @@ struct udp_tunnel_nic_info;
> >  struct udp_tunnel_nic;
> >  struct bpf_prog;
> >  struct xdp_buff;
> > +struct xdp_md;
> >
> >  void synchronize_net(void);
> >  void netdev_set_default_ethtool_ops(struct net_device *dev,
> > @@ -1613,6 +1614,11 @@ struct net_device_ops {
> >                                                 bool cycles);
> >  };
> >
> > +struct xdp_metadata_ops {
> > +     int     (*xmo_rx_timestamp)(const struct xdp_md *ctx, u64 *timestamp);
> > +     int     (*xmo_rx_hash)(const struct xdp_md *ctx, u32 *hash);
> > +};
> > +
> >  /**
> >   * enum netdev_priv_flags - &struct net_device priv_flags
> >   *
> > @@ -2044,6 +2050,7 @@ struct net_device {
> >       unsigned int            flags;
> >       unsigned long long      priv_flags;
> >       const struct net_device_ops *netdev_ops;
> > +     const struct xdp_metadata_ops *xdp_metadata_ops;
> >       int                     ifindex;
> >       unsigned short          gflags;
> >       unsigned short          hard_header_len;
> > diff --git a/include/net/xdp.h b/include/net/xdp.h
> > index 55dbc68bfffc..152c3a9c1127 100644
> > --- a/include/net/xdp.h
> > +++ b/include/net/xdp.h
> > @@ -409,4 +409,29 @@ void xdp_attachment_setup(struct xdp_attachment_info *info,
> >
> >  #define DEV_MAP_BULK_SIZE XDP_BULK_QUEUE_SIZE
> >
> > +#define XDP_METADATA_KFUNC_xxx       \
> > +     XDP_METADATA_KFUNC(XDP_METADATA_KFUNC_RX_TIMESTAMP, \
> > +                        bpf_xdp_metadata_rx_timestamp) \
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
> > +struct xdp_md;
> > +int bpf_xdp_metadata_rx_timestamp(const struct xdp_md *ctx, u64 *timestamp);
> > +int bpf_xdp_metadata_rx_hash(const struct xdp_md *ctx, u32 *hash);
>
> We don't usually export function signatures like this for kfuncs as
> nobody in the main kernel should be linking against it. See [0].
>
> [0]: https://docs.kernel.org/bpf/kfuncs.html#creating-a-wrapper-kfunc

Oh, thanks, that's very helpful. As you might have guessed, I've added
those signatures to make the compiler happy :-(

> > +
> > +#ifdef CONFIG_NET
> > +u32 xdp_metadata_kfunc_id(int id);
> > +bool xdp_is_metadata_kfunc_id(u32 btf_id);
> > +#else
> > +static inline u32 xdp_metadata_kfunc_id(int id) { return 0; }
> > +static inline bool xdp_is_metadata_kfunc_id(u32 btf_id) { return false; }
> > +#endif
> > +
> >  #endif /* __LINUX_NET_XDP_H__ */
> > diff --git a/kernel/bpf/core.c b/kernel/bpf/core.c
> > index d434a994ee04..c3e501e3e39c 100644
> > --- a/kernel/bpf/core.c
> > +++ b/kernel/bpf/core.c
> > @@ -2097,6 +2097,13 @@ bool bpf_prog_map_compatible(struct bpf_map *map,
> >       if (fp->kprobe_override)
> >               return false;
> >
> > +     /* When tail-calling from a non-dev-bound program to a dev-bound one,
> > +      * XDP metadata helpers should be disabled. Until it's implemented,
> > +      * prohibit adding dev-bound programs to tail-call maps.
> > +      */
> > +     if (bpf_prog_is_dev_bound(fp->aux))
> > +             return false;
> > +
> >       spin_lock(&map->owner.lock);
> >       if (!map->owner.type) {
> >               /* There's no owner yet where we could check for
> > diff --git a/kernel/bpf/offload.c b/kernel/bpf/offload.c
> > index f714c941f8ea..3b6c9023f24d 100644
> > --- a/kernel/bpf/offload.c
> > +++ b/kernel/bpf/offload.c
> > @@ -757,6 +757,29 @@ void bpf_dev_bound_netdev_unregister(struct net_device *dev)
> >       up_write(&bpf_devs_lock);
> >  }
> >
> > +void *bpf_dev_bound_resolve_kfunc(struct bpf_prog *prog, u32 func_id)
> > +{
> > +     const struct xdp_metadata_ops *ops;
> > +     void *p = NULL;
> > +
> > +     down_read(&bpf_devs_lock);
> > +     if (!prog->aux->offload || !prog->aux->offload->netdev)
> > +             goto out;
> > +
> > +     ops = prog->aux->offload->netdev->xdp_metadata_ops;
> > +     if (!ops)
> > +             goto out;
> > +
> > +     if (func_id == xdp_metadata_kfunc_id(XDP_METADATA_KFUNC_RX_TIMESTAMP))
> > +             p = ops->xmo_rx_timestamp;
> > +     else if (func_id == xdp_metadata_kfunc_id(XDP_METADATA_KFUNC_RX_HASH))
> > +             p = ops->xmo_rx_hash;
> > +out:
> > +     up_read(&bpf_devs_lock);
> > +
> > +     return p;
> > +}
> > +
> >  static int __init bpf_offload_init(void)
> >  {
> >       int err;
> > diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
> > index 203d8cfeda70..e61fe0472b9b 100644
> > --- a/kernel/bpf/verifier.c
> > +++ b/kernel/bpf/verifier.c
> > @@ -15479,12 +15479,35 @@ static int fixup_kfunc_call(struct bpf_verifier_env *env, struct bpf_insn *insn,
> >                           struct bpf_insn *insn_buf, int insn_idx, int *cnt)
> >  {
> >       const struct bpf_kfunc_desc *desc;
> > +     void *xdp_kfunc;
> >
> >       if (!insn->imm) {
> >               verbose(env, "invalid kernel function call not eliminated in verifier pass\n");
> >               return -EINVAL;
> >       }
> >
> > +     *cnt = 0;
> > +
> > +     if (xdp_is_metadata_kfunc_id(insn->imm)) {
> > +             if (!bpf_prog_is_dev_bound(env->prog->aux)) {
> > +                     verbose(env, "metadata kfuncs require device-bound program\n");
> > +                     return -EINVAL;
> > +             }
> > +
> > +             if (bpf_prog_is_offloaded(env->prog->aux)) {
> > +                     verbose(env, "metadata kfuncs can't be offloaded\n");
> > +                     return -EINVAL;
> > +             }
> > +
> > +             xdp_kfunc = bpf_dev_bound_resolve_kfunc(env->prog, insn->imm);
> > +             if (xdp_kfunc) {
> > +                     insn->imm = BPF_CALL_IMM(xdp_kfunc);
> > +                     return 0;
> > +             }
>
> Per another comment, should these xdp kfuncs use special_kfunc_list, or
> some other variant that lives in verifier.c? I'll admit that I'm not
> quite following why you wouldn't need to do the find_kfunc_desc() call
> below, so apologies if I'm just totally off here.

Here I'm trying to short-circuit that generic verifier handling and do
kfunc resolving myself, so not sure. Will comment about
special_kfunc_list below.

> > +
> > +             /* fallback to default kfunc when not supported by netdev */
> > +     }
> > +
> >       /* insn->imm has the btf func_id. Replace it with
> >        * an address (relative to __bpf_call_base).
> >        */
> > @@ -15495,7 +15518,6 @@ static int fixup_kfunc_call(struct bpf_verifier_env *env, struct bpf_insn *insn,
> >               return -EFAULT;
> >       }
> >
> > -     *cnt = 0;
> >       insn->imm = desc->imm;
> >       if (insn->off)
> >               return 0;
> > @@ -16502,6 +16524,11 @@ int bpf_check_attach_target(struct bpf_verifier_log *log,
> >       if (tgt_prog) {
> >               struct bpf_prog_aux *aux = tgt_prog->aux;
> >
> > +             if (bpf_prog_is_dev_bound(tgt_prog->aux)) {
> > +                     bpf_log(log, "Replacing device-bound programs not supported\n");
> > +                     return -EINVAL;
> > +             }
> > +
> >               for (i = 0; i < aux->func_info_cnt; i++)
> >                       if (aux->func_info[i].type_id == btf_id) {
> >                               subprog = i;
> > diff --git a/net/core/xdp.c b/net/core/xdp.c
> > index 844c9d99dc0e..b0d4080249d7 100644
> > --- a/net/core/xdp.c
> > +++ b/net/core/xdp.c
> > @@ -4,6 +4,7 @@
> >   * Copyright (c) 2017 Jesper Dangaard Brouer, Red Hat Inc.
> >   */
> >  #include <linux/bpf.h>
> > +#include <linux/btf_ids.h>
> >  #include <linux/filter.h>
> >  #include <linux/types.h>
> >  #include <linux/mm.h>
> > @@ -709,3 +710,46 @@ struct xdp_frame *xdpf_clone(struct xdp_frame *xdpf)
> >
> >       return nxdpf;
> >  }
> > +
> > +noinline int bpf_xdp_metadata_rx_timestamp(const struct xdp_md *ctx, u64 *timestamp)
> > +{
> > +     return -EOPNOTSUPP;
> > +}
> > +
> > +noinline int bpf_xdp_metadata_rx_hash(const struct xdp_md *ctx, u32 *hash)
> > +{
> > +     return -EOPNOTSUPP;
> > +}
>
> I don't _think_ noinline should be necessary here given that the
> function is global, though tbh I'm not sure if leaving it off will break
> LTO. We currently don't use any attributes like this on other kfuncs
> (e.g. [1]), but maybe we should?
>
> [1]: https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next.git/tree/kernel/bpf/helpers.c#n2034

Hm, I guess since I'm not really directly calling these anywhere,
there is no chance they are going to be inlined? Will try to drop and
see what happens..

> > +
> > +BTF_SET8_START(xdp_metadata_kfunc_ids)
> > +#define XDP_METADATA_KFUNC(name, str) BTF_ID_FLAGS(func, str, 0)
>
> IMO 'str' isn't the right parameter name here given that it's the actual
> symbol and is not a string. What about _func or _symbol instead? Also
> IMO 'name' is a bit misleading -- I'd go with something like '_enum'. I
> wish there were a way for the preprocessor to auto-uppercase so you
> could just define a single field that was used both for defining the
> enum and for defining the symbol name.

How about I do the following:

enum {
#define XDP_METADATA_KFUNC(name, _) name,
XDP_METADATA_KFUNC_xxx
#undef XDP_METADATA_KFUNC
MAX_XDP_METADATA_KFUNC,
};

And then this in the .c file:

BTF_SET8_START(xdp_metadata_kfunc_ids)
#define XDP_METADATA_KFUNC(_, name) BTF_ID_FLAGS(func, name, 0)
XDP_METADATA_KFUNC_xxx
#undef XDP_METADATA_KFUNC
BTF_SET8_END(xdp_metadata_kfunc_ids)

Should be a bit more clear what and where I use? Otherwise, using
_func might seem a bit confusing in:
#define XDP_METADATA_KFUNC(_enum, _func) BTF_ID_FLAGS(func, _func, 0)

The "func, _func" part. Or maybe that's fine.. WDYT?

> > +XDP_METADATA_KFUNC_xxx
> > +#undef XDP_METADATA_KFUNC
> > +BTF_SET8_END(xdp_metadata_kfunc_ids)
> > +
> > +static const struct btf_kfunc_id_set xdp_metadata_kfunc_set = {
> > +     .owner = THIS_MODULE,
> > +     .set   = &xdp_metadata_kfunc_ids,
> > +};
> > +
> > +BTF_ID_LIST(xdp_metadata_kfunc_ids_unsorted)
> > +#define XDP_METADATA_KFUNC(name, str) BTF_ID(func, str)
> > +XDP_METADATA_KFUNC_xxx
> > +#undef XDP_METADATA_KFUNC
> > +
> > +u32 xdp_metadata_kfunc_id(int id)
> > +{
> > +     /* xdp_metadata_kfunc_ids is sorted and can't be used */
> > +     return xdp_metadata_kfunc_ids_unsorted[id];
> > +}
> > +
> > +bool xdp_is_metadata_kfunc_id(u32 btf_id)
> > +{
> > +     return btf_id_set8_contains(&xdp_metadata_kfunc_ids, btf_id);
> > +}
>
> The verifier already has a notion of "special kfuncs" via a
> special_kfunc_list that exists in verifier.c. Maybe we should be using
> that given that is only used in the verifier anyways? OTOH, it's nice
> that all of the complexity of e.g. accounting for #ifdef CONFIG_NET is
> contained here, so I also like your approach. It just seems like a
> divergence from how things are being done for other kfuncs so I figured
> it was worth discussing.

Yeah, idk, I've tried not to add more to the already huge verifier.c file :-(
If we were to put everything into verifier.c, I'd still need some
extra special_xdp_kfunc_list for those xdp kfuncs to be able to
distinguish them from the rest...
So yeah, not sure, I'd prefer to keep everything in xdp.c and not
pollute the more generic verifier.c, but I'm fine either way. LMK if
you feel strongly about it, can move.


> > +
> > +static int __init xdp_metadata_init(void)
> > +{
> > +     return register_btf_kfunc_id_set(BPF_PROG_TYPE_XDP, &xdp_metadata_kfunc_set);
> > +}
> > +late_initcall(xdp_metadata_init);
> > --
> > 2.39.0.rc1.256.g54fd8350bd-goog
> >
