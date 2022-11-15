Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EC000629EC2
	for <lists+netdev@lfdr.de>; Tue, 15 Nov 2022 17:17:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238612AbiKOQRz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Nov 2022 11:17:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238619AbiKOQR3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Nov 2022 11:17:29 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 828CA2AC64
        for <netdev@vger.kernel.org>; Tue, 15 Nov 2022 08:16:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1668528986;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=bOrA8zR/ryblbm93hbMhRd04HxxErdHBg2bgYXeyD5c=;
        b=ijYPDVjT0g9BGWvJZr80hEOSOOZxp+QQNwyQ6e825xKAmXg4+90ngxWMD728589xp3zEet
        G/Ck2sfk141x6jW/pzmLYCMUI3rmvRKxzcYyOK/5eLQyJ3P/vQhIDtHs2cjpKNgeEcKLtB
        jljqRvEUaub/INF7tCwgnuaCGs98zKs=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-364-tRMt535qNBK_YSnFdNkmiQ-1; Tue, 15 Nov 2022 11:16:24 -0500
X-MC-Unique: tRMt535qNBK_YSnFdNkmiQ-1
Received: by mail-ed1-f69.google.com with SMTP id z9-20020a05640235c900b0046358415c4fso10194386edc.9
        for <netdev@vger.kernel.org>; Tue, 15 Nov 2022 08:16:24 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:message-id:date:references:in-reply-to:subject:cc:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=bOrA8zR/ryblbm93hbMhRd04HxxErdHBg2bgYXeyD5c=;
        b=Smj/wlKfudsh2xl+d2dGsHXkb+XUwdpaAdhATrSUEwIOfIgwUY0R/CL4Kq6wGO3AGa
         nGStczKLqnxYk6m8/BLW02xcySfe8Sn8QsEGIqhN+Y+JpPN8wKEwAqNUhdxdQqhEiKUf
         b5n/LZCZr11u2XFMRvOlTi8ZNXeK1ZdeFPZ0/yY6lItPZTCv9D0aue+gSZrJGkyEHjI7
         cZ2ajeZuWXPVc6gsySQ2Kzt7pXKsUMhNj7w6AkRpKPy8CagdJVC8TE3d2rvrOIyz5xki
         Vo+9lnNkKfzIf7L9Y3gKagq8FCiRS4gK7u/0EX7RQwAbkGC0qFMxuuS+DwnC1Jjsd47d
         V23w==
X-Gm-Message-State: ANoB5pnPZo5mPc0YiIJ9wVSbN1Rv4ucT+tBviN+Af0DeOjQ7oDgP5cMq
        P0kDYaM7t/hMzm2spNohVQqraSVrGpIi9cDgVvo49tVHoQSAN0Q4pSvmqHdHvSYYLD/1a6LaQe3
        lviolsCkYxjB6xGLN
X-Received: by 2002:a17:906:b20f:b0:7a1:1c24:e564 with SMTP id p15-20020a170906b20f00b007a11c24e564mr14266193ejz.629.1668528982966;
        Tue, 15 Nov 2022 08:16:22 -0800 (PST)
X-Google-Smtp-Source: AA0mqf4f6V01MIBOQ6uOMTkIurg8f8K4nbxM7Se1zbLrqsNocfRCwDDnb9WLmpxWxmTlKpHTE8gfvQ==
X-Received: by 2002:a17:906:b20f:b0:7a1:1c24:e564 with SMTP id p15-20020a170906b20f00b007a11c24e564mr14266163ejz.629.1668528982588;
        Tue, 15 Nov 2022 08:16:22 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id d18-20020a056402401200b004580862ffdbsm6404586eda.59.2022.11.15.08.16.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Nov 2022 08:16:22 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 736C17A6CD4; Tue, 15 Nov 2022 17:16:21 +0100 (CET)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Stanislav Fomichev <sdf@google.com>, bpf@vger.kernel.org
Cc:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        martin.lau@linux.dev, song@kernel.org, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org, sdf@google.com,
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
Subject: Re: [xdp-hints] [PATCH bpf-next 03/11] bpf: Support
 inlined/unrolled kfuncs for xdp metadata
In-Reply-To: <20221115030210.3159213-4-sdf@google.com>
References: <20221115030210.3159213-1-sdf@google.com>
 <20221115030210.3159213-4-sdf@google.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Tue, 15 Nov 2022 17:16:21 +0100
Message-ID: <87k03wi46i.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Stanislav Fomichev <sdf@google.com> writes:

> Kfuncs have to be defined with KF_UNROLL for an attempted unroll.
> For now, only XDP programs can have their kfuncs unrolled, but
> we can extend this later on if more programs would like to use it.
>
> For XDP, we define a new kfunc set (xdp_metadata_kfunc_ids) which
> implements all possible metatada kfuncs. Not all devices have to
> implement them. If unrolling is not supported by the target device,
> the default implementation is called instead. The default
> implementation is unconditionally unrolled to 'return false/0/NULL'
> for now.
>
> Upon loading, if BPF_F_XDP_HAS_METADATA is passed via prog_flags,
> we treat prog_index as target device for kfunc unrolling.
> net_device_ops gains new ndo_unroll_kfunc which does the actual
> dirty work per device.
>
> The kfunc unrolling itself largely follows the existing map_gen_lookup
> unrolling example, so there is nothing new here.
>
> Cc: John Fastabend <john.fastabend@gmail.com>
> Cc: David Ahern <dsahern@gmail.com>
> Cc: Martin KaFai Lau <martin.lau@linux.dev>
> Cc: Jakub Kicinski <kuba@kernel.org>
> Cc: Willem de Bruijn <willemb@google.com>
> Cc: Jesper Dangaard Brouer <brouer@redhat.com>
> Cc: Anatoly Burakov <anatoly.burakov@intel.com>
> Cc: Alexander Lobakin <alexandr.lobakin@intel.com>
> Cc: Magnus Karlsson <magnus.karlsson@gmail.com>
> Cc: Maryam Tahhan <mtahhan@redhat.com>
> Cc: xdp-hints@xdp-project.net
> Cc: netdev@vger.kernel.org
> Signed-off-by: Stanislav Fomichev <sdf@google.com>
> ---
>  Documentation/bpf/kfuncs.rst   |  8 +++++
>  include/linux/bpf.h            |  1 +
>  include/linux/btf.h            |  1 +
>  include/linux/btf_ids.h        |  4 +++
>  include/linux/netdevice.h      |  5 +++
>  include/net/xdp.h              | 24 +++++++++++++
>  include/uapi/linux/bpf.h       |  5 +++
>  kernel/bpf/syscall.c           | 28 ++++++++++++++-
>  kernel/bpf/verifier.c          | 65 ++++++++++++++++++++++++++++++++++
>  net/core/dev.c                 |  7 ++++
>  net/core/xdp.c                 | 39 ++++++++++++++++++++
>  tools/include/uapi/linux/bpf.h |  5 +++
>  12 files changed, 191 insertions(+), 1 deletion(-)
>
> diff --git a/Documentation/bpf/kfuncs.rst b/Documentation/bpf/kfuncs.rst
> index 0f858156371d..1723de2720bb 100644
> --- a/Documentation/bpf/kfuncs.rst
> +++ b/Documentation/bpf/kfuncs.rst
> @@ -169,6 +169,14 @@ rebooting or panicking. Due to this additional restrictions apply to these
>  calls. At the moment they only require CAP_SYS_BOOT capability, but more can be
>  added later.
>  
> +2.4.8 KF_UNROLL flag
> +-----------------------
> +
> +The KF_UNROLL flag is used for kfuncs that the verifier can attempt to unroll.
> +Unrolling is currently implemented only for XDP programs' metadata kfuncs.
> +The main motivation behind unrolling is to remove function call overhead
> +and allow efficient inlined kfuncs to be generated.
> +
>  2.5 Registering the kfuncs
>  --------------------------
>  
> diff --git a/include/linux/bpf.h b/include/linux/bpf.h
> index 798aec816970..bf8936522dd9 100644
> --- a/include/linux/bpf.h
> +++ b/include/linux/bpf.h
> @@ -1240,6 +1240,7 @@ struct bpf_prog_aux {
>  		struct work_struct work;
>  		struct rcu_head	rcu;
>  	};
> +	const struct net_device_ops *xdp_kfunc_ndo;
>  };
>  
>  struct bpf_prog {
> diff --git a/include/linux/btf.h b/include/linux/btf.h
> index d80345fa566b..950cca997a5a 100644
> --- a/include/linux/btf.h
> +++ b/include/linux/btf.h
> @@ -51,6 +51,7 @@
>  #define KF_TRUSTED_ARGS (1 << 4) /* kfunc only takes trusted pointer arguments */
>  #define KF_SLEEPABLE    (1 << 5) /* kfunc may sleep */
>  #define KF_DESTRUCTIVE  (1 << 6) /* kfunc performs destructive actions */
> +#define KF_UNROLL       (1 << 7) /* kfunc unrolling can be attempted */
>  
>  /*
>   * Return the name of the passed struct, if exists, or halt the build if for
> diff --git a/include/linux/btf_ids.h b/include/linux/btf_ids.h
> index c9744efd202f..eb448e9c79bb 100644
> --- a/include/linux/btf_ids.h
> +++ b/include/linux/btf_ids.h
> @@ -195,6 +195,10 @@ asm(							\
>  __BTF_ID_LIST(name, local)				\
>  __BTF_SET8_START(name, local)
>  
> +#define BTF_SET8_START_GLOBAL(name)			\
> +__BTF_ID_LIST(name, global)				\
> +__BTF_SET8_START(name, global)
> +
>  #define BTF_SET8_END(name)				\
>  asm(							\
>  ".pushsection " BTF_IDS_SECTION ",\"a\";      \n"	\
> diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
> index 02a2318da7c7..2096b4f00e4b 100644
> --- a/include/linux/netdevice.h
> +++ b/include/linux/netdevice.h
> @@ -73,6 +73,8 @@ struct udp_tunnel_info;
>  struct udp_tunnel_nic_info;
>  struct udp_tunnel_nic;
>  struct bpf_prog;
> +struct bpf_insn;
> +struct bpf_patch;
>  struct xdp_buff;
>  
>  void synchronize_net(void);
> @@ -1604,6 +1606,9 @@ struct net_device_ops {
>  	ktime_t			(*ndo_get_tstamp)(struct net_device *dev,
>  						  const struct skb_shared_hwtstamps *hwtstamps,
>  						  bool cycles);
> +	void			(*ndo_unroll_kfunc)(const struct bpf_prog *prog,
> +						    u32 func_id,
> +						    struct bpf_patch *patch);
>  };
>  
>  /**
> diff --git a/include/net/xdp.h b/include/net/xdp.h
> index 55dbc68bfffc..2a82a98f2f9f 100644
> --- a/include/net/xdp.h
> +++ b/include/net/xdp.h
> @@ -7,6 +7,7 @@
>  #define __LINUX_NET_XDP_H__
>  
>  #include <linux/skbuff.h> /* skb_shared_info */
> +#include <linux/btf_ids.h> /* btf_id_set8 */
>  
>  /**
>   * DOC: XDP RX-queue information
> @@ -409,4 +410,27 @@ void xdp_attachment_setup(struct xdp_attachment_info *info,
>  
>  #define DEV_MAP_BULK_SIZE XDP_BULK_QUEUE_SIZE
>  
> +#define XDP_METADATA_KFUNC_xxx	\
> +	XDP_METADATA_KFUNC(XDP_METADATA_KFUNC_RX_TIMESTAMP_SUPPORTED, \
> +			   bpf_xdp_metadata_rx_timestamp_supported) \
> +	XDP_METADATA_KFUNC(XDP_METADATA_KFUNC_RX_TIMESTAMP, \
> +			   bpf_xdp_metadata_rx_timestamp) \
> +
> +enum {
> +#define XDP_METADATA_KFUNC(name, str) name,
> +XDP_METADATA_KFUNC_xxx
> +#undef XDP_METADATA_KFUNC
> +MAX_XDP_METADATA_KFUNC,
> +};
> +
> +#ifdef CONFIG_DEBUG_INFO_BTF
> +extern struct btf_id_set8 xdp_metadata_kfunc_ids;
> +static inline u32 xdp_metadata_kfunc_id(int id)
> +{
> +	return xdp_metadata_kfunc_ids.pairs[id].id;
> +}
> +#else
> +static inline u32 xdp_metadata_kfunc_id(int id) { return 0; }
> +#endif
> +
>  #endif /* __LINUX_NET_XDP_H__ */
> diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
> index fb4c911d2a03..b444b1118c4f 100644
> --- a/include/uapi/linux/bpf.h
> +++ b/include/uapi/linux/bpf.h
> @@ -1156,6 +1156,11 @@ enum bpf_link_type {
>   */
>  #define BPF_F_XDP_HAS_FRAGS	(1U << 5)
>  
> +/* If BPF_F_XDP_HAS_METADATA is used in BPF_PROG_LOAD command, the loaded
> + * program becomes device-bound but can access it's XDP metadata.
> + */
> +#define BPF_F_XDP_HAS_METADATA	(1U << 6)
> +
>  /* link_create.kprobe_multi.flags used in LINK_CREATE command for
>   * BPF_TRACE_KPROBE_MULTI attach type to create return probe.
>   */
> diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
> index 85532d301124..597c41949910 100644
> --- a/kernel/bpf/syscall.c
> +++ b/kernel/bpf/syscall.c
> @@ -2426,6 +2426,20 @@ static bool is_perfmon_prog_type(enum bpf_prog_type prog_type)
>  /* last field in 'union bpf_attr' used by this command */
>  #define	BPF_PROG_LOAD_LAST_FIELD core_relo_rec_size
>  
> +static int xdp_resolve_netdev(struct bpf_prog *prog, int ifindex)
> +{
> +	struct net *net = current->nsproxy->net_ns;
> +	struct net_device *dev;
> +
> +	for_each_netdev(net, dev) {
> +		if (dev->ifindex == ifindex) {

So this is basically dev_get_by_index(), except you're not doing
dev_hold()? Which also means there's no protection against the netdev
going away?

> +			prog->aux->xdp_kfunc_ndo = dev->netdev_ops;
> +			return 0;
> +		}
> +	}

> +	return -EINVAL;
> +}
> +
>  static int bpf_prog_load(union bpf_attr *attr, bpfptr_t uattr)
>  {
>  	enum bpf_prog_type type = attr->prog_type;
> @@ -2443,7 +2457,8 @@ static int bpf_prog_load(union bpf_attr *attr, bpfptr_t uattr)
>  				 BPF_F_TEST_STATE_FREQ |
>  				 BPF_F_SLEEPABLE |
>  				 BPF_F_TEST_RND_HI32 |
> -				 BPF_F_XDP_HAS_FRAGS))
> +				 BPF_F_XDP_HAS_FRAGS |
> +				 BPF_F_XDP_HAS_METADATA))
>  		return -EINVAL;
>  
>  	if (!IS_ENABLED(CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS) &&
> @@ -2531,6 +2546,17 @@ static int bpf_prog_load(union bpf_attr *attr, bpfptr_t uattr)
>  	prog->aux->sleepable = attr->prog_flags & BPF_F_SLEEPABLE;
>  	prog->aux->xdp_has_frags = attr->prog_flags & BPF_F_XDP_HAS_FRAGS;
>  
> +	if (attr->prog_flags & BPF_F_XDP_HAS_METADATA) {
> +		/* Reuse prog_ifindex to carry request to unroll
> +		 * metadata kfuncs.
> +		 */
> +		prog->aux->offload_requested = false;
> +
> +		err = xdp_resolve_netdev(prog, attr->prog_ifindex);
> +		if (err < 0)
> +			goto free_prog;
> +	}
> +
>  	err = security_bpf_prog_alloc(prog->aux);
>  	if (err)
>  		goto free_prog;
> diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
> index 07c0259dfc1a..b657ed6eb277 100644
> --- a/kernel/bpf/verifier.c
> +++ b/kernel/bpf/verifier.c
> @@ -9,6 +9,7 @@
>  #include <linux/types.h>
>  #include <linux/slab.h>
>  #include <linux/bpf.h>
> +#include <linux/bpf_patch.h>
>  #include <linux/btf.h>
>  #include <linux/bpf_verifier.h>
>  #include <linux/filter.h>
> @@ -14015,6 +14016,43 @@ static int fixup_call_args(struct bpf_verifier_env *env)
>  	return err;
>  }
>  
> +static int unroll_kfunc_call(struct bpf_verifier_env *env,
> +			     struct bpf_insn *insn,
> +			     struct bpf_patch *patch)
> +{
> +	enum bpf_prog_type prog_type;
> +	struct bpf_prog_aux *aux;
> +	struct btf *desc_btf;
> +	u32 *kfunc_flags;
> +	u32 func_id;
> +
> +	desc_btf = find_kfunc_desc_btf(env, insn->off);
> +	if (IS_ERR(desc_btf))
> +		return PTR_ERR(desc_btf);
> +
> +	prog_type = resolve_prog_type(env->prog);
> +	func_id = insn->imm;
> +
> +	kfunc_flags = btf_kfunc_id_set_contains(desc_btf, prog_type, func_id);
> +	if (!kfunc_flags)
> +		return 0;
> +	if (!(*kfunc_flags & KF_UNROLL))
> +		return 0;
> +	if (prog_type != BPF_PROG_TYPE_XDP)
> +		return 0;

Should this just handle XDP_METADATA_KFUNC_EXPORT_TO_SKB instead of
passing that into the driver (to avoid every driver having to
reimplement the same call to xdp_metadata_export_to_skb())?

-Toke

