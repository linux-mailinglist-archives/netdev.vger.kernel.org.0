Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D097463B788
	for <lists+netdev@lfdr.de>; Tue, 29 Nov 2022 02:58:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235152AbiK2B6j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Nov 2022 20:58:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234663AbiK2B6h (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Nov 2022 20:58:37 -0500
Received: from out2.migadu.com (out2.migadu.com [IPv6:2001:41d0:2:aacc::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 587B9419AE;
        Mon, 28 Nov 2022 17:58:34 -0800 (PST)
Message-ID: <c8a2d940-ff85-c952-74d0-25ad2c33c1af@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1669687112;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=wnDUg7hTxIXAET/T19mjG0DRQx0yYHWdq/wH+w9xkpw=;
        b=b9oFc2uNv9j/GNo0OOTLfrigXSlMYHiJ+scZb9qRFRliQKt0OlhrYMWnwLSIU4GumS4WpI
        ZHaTK6/fNdAQ286xhoMNZ1/DSrd5y3u7h4zb8ejZtRLyTdtnjQdEKW/t2tGqd+m8pXj5Fw
        hm3JLF/ZtUM27B+q0FjAt8/aT+4lDQ4=
Date:   Mon, 28 Nov 2022 17:58:23 -0800
MIME-Version: 1.0
Subject: Re: [PATCH ipsec-next 2/3] xfrm: interface: Add unstable helpers for
 setting/getting XFRM metadata from TC-BPF
Content-Language: en-US
To:     Eyal Birger <eyal.birger@gmail.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kselftest@vger.kernel.org, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        steffen.klassert@secunet.com, herbert@gondor.apana.org.au,
        andrii@kernel.org, daniel@iogearbox.net, nicolas.dichtel@6wind.com,
        razor@blackwall.org, mykolal@fb.com, ast@kernel.org,
        song@kernel.org, yhs@fb.com, john.fastabend@gmail.com,
        kpsingh@kernel.org, sdf@google.com, haoluo@google.com,
        jolsa@kernel.org, shuah@kernel.org
References: <20221128160501.769892-1-eyal.birger@gmail.com>
 <20221128160501.769892-3-eyal.birger@gmail.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Martin KaFai Lau <martin.lau@linux.dev>
In-Reply-To: <20221128160501.769892-3-eyal.birger@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/28/22 8:05 AM, Eyal Birger wrote:
> This change adds xfrm metadata helpers using the unstable kfunc call
> interface for the TC-BPF hooks. This allows steering traffic towards
> different IPsec connections based on logic implemented in bpf programs.
> 
> This object is built based on the availabilty of BTF debug info.
> 
> The metadata percpu dsts used on TX take ownership of the original skb
> dsts so that they may be used as part of the xfrm transmittion logic -
> e.g.  for MTU calculations.

A few quick comments and questions:

> 
> Signed-off-by: Eyal Birger <eyal.birger@gmail.com>
> ---
>   include/net/dst_metadata.h     |  1 +
>   include/net/xfrm.h             | 20 ++++++++
>   net/core/dst.c                 |  4 ++
>   net/xfrm/Makefile              |  6 +++
>   net/xfrm/xfrm_interface_bpf.c  | 92 ++++++++++++++++++++++++++++++++++

Please tag for bpf-next

>   net/xfrm/xfrm_interface_core.c | 15 ++++++
>   6 files changed, 138 insertions(+)
>   create mode 100644 net/xfrm/xfrm_interface_bpf.c
> 
> diff --git a/include/net/dst_metadata.h b/include/net/dst_metadata.h
> index a454cf4327fe..1b7fae4c6b24 100644
> --- a/include/net/dst_metadata.h
> +++ b/include/net/dst_metadata.h
> @@ -26,6 +26,7 @@ struct macsec_info {
>   struct xfrm_md_info {
>   	u32 if_id;
>   	int link;
> +	struct dst_entry *dst_orig;
>   };
>   
>   struct metadata_dst {

[ ... ]

> diff --git a/net/core/dst.c b/net/core/dst.c
> index bc9c9be4e080..4c2eb7e56dab 100644
> --- a/net/core/dst.c
> +++ b/net/core/dst.c
> @@ -315,6 +315,8 @@ void metadata_dst_free(struct metadata_dst *md_dst)
>   #ifdef CONFIG_DST_CACHE
>   	if (md_dst->type == METADATA_IP_TUNNEL)
>   		dst_cache_destroy(&md_dst->u.tun_info.dst_cache);
> +	else if (md_dst->type == METADATA_XFRM)
> +		dst_release(md_dst->u.xfrm_info.dst_orig);

Why only release dst_orig under CONFIG_DST_CACHE?

>   #endif
>   	kfree(md_dst);
>   }
> @@ -348,6 +350,8 @@ void metadata_dst_free_percpu(struct metadata_dst __percpu *md_dst)
>   
>   		if (one_md_dst->type == METADATA_IP_TUNNEL)
>   			dst_cache_destroy(&one_md_dst->u.tun_info.dst_cache);
> +		else if (one_md_dst->type == METADATA_XFRM)
> +			dst_release(one_md_dst->u.xfrm_info.dst_orig);

Same here.

[ ... ]

> diff --git a/net/xfrm/xfrm_interface_bpf.c b/net/xfrm/xfrm_interface_bpf.c
> new file mode 100644
> index 000000000000..d3997ab7cc28
> --- /dev/null
> +++ b/net/xfrm/xfrm_interface_bpf.c
> @@ -0,0 +1,92 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +/* Unstable XFRM Helpers for TC-BPF hook
> + *
> + * These are called from SCHED_CLS BPF programs. Note that it is
> + * allowed to break compatibility for these functions since the interface they
> + * are exposed through to BPF programs is explicitly unstable.
> + */
> +
> +#include <linux/bpf.h>
> +#include <linux/btf_ids.h>
> +
> +#include <net/dst_metadata.h>
> +#include <net/xfrm.h>
> +
> +struct bpf_xfrm_info {
> +	u32 if_id;
> +	int link;
> +};
> +
> +static struct metadata_dst __percpu *xfrm_md_dst;
> +__diag_push();
> +__diag_ignore_all("-Wmissing-prototypes",
> +		  "Global functions as their definitions will be in xfrm_interface BTF");
> +
> +__used noinline
> +int bpf_skb_get_xfrm_info(struct __sk_buff *skb_ctx, struct bpf_xfrm_info *to)
> +{
> +	struct sk_buff *skb = (struct sk_buff *)skb_ctx;
> +	struct xfrm_md_info *info;
> +
> +	memset(to, 0, sizeof(*to));
> +
> +	info = skb_xfrm_md_info(skb);
> +	if (!info)
> +		return -EINVAL;
> +
> +	to->if_id = info->if_id;
> +	to->link = info->link;
> +	return 0;
> +}
> +
> +__used noinline
> +int bpf_skb_set_xfrm_info(struct __sk_buff *skb_ctx,
> +			  const struct bpf_xfrm_info *from)
> +{
> +	struct sk_buff *skb = (struct sk_buff *)skb_ctx;
> +	struct metadata_dst *md_dst;
> +	struct xfrm_md_info *info;
> +
> +	if (unlikely(skb_metadata_dst(skb)))
> +		return -EINVAL;
> +
> +	md_dst = this_cpu_ptr(xfrm_md_dst);
> +
> +	info = &md_dst->u.xfrm_info;
> +	memset(info, 0, sizeof(*info));
> +
> +	info->if_id = from->if_id;
> +	info->link = from->link;
> +	info->dst_orig = skb_dst(skb);
However, the dst_orig init is not done under CONFIG_DST_CACHE though...

Also, is it possible that skb->_skb_refdst has SKB_DST_NOREF set and later below 
... (contd)

> +
> +	dst_hold((struct dst_entry *)md_dst);
> +	skb_dst_set(skb, (struct dst_entry *)md_dst);
> +	return 0;
> +}
> +
> +__diag_pop()
> +
> +BTF_SET8_START(xfrm_ifc_kfunc_set)
> +BTF_ID_FLAGS(func, bpf_skb_get_xfrm_info)
> +BTF_ID_FLAGS(func, bpf_skb_set_xfrm_info)
> +BTF_SET8_END(xfrm_ifc_kfunc_set)
> +
> +static const struct btf_kfunc_id_set xfrm_interface_kfunc_set = {
> +	.owner = THIS_MODULE,
> +	.set   = &xfrm_ifc_kfunc_set,
> +};
> +
> +int __init register_xfrm_interface_bpf(void)
> +{
> +	xfrm_md_dst = metadata_dst_alloc_percpu(0, METADATA_XFRM,
> +						GFP_KERNEL);
> +	if (!xfrm_md_dst)
> +		return -ENOMEM;
> +	return register_btf_kfunc_id_set(BPF_PROG_TYPE_SCHED_CLS,
> +					 &xfrm_interface_kfunc_set);

Will cleanup_xfrm_interface_bpf() be called during error ?

> +}
> +
> +void __exit cleanup_xfrm_interface_bpf(void)
> +{
> +	metadata_dst_free_percpu(xfrm_md_dst);
> +}
> diff --git a/net/xfrm/xfrm_interface_core.c b/net/xfrm/xfrm_interface_core.c
> index 5a67b120c4db..1e1e8e965939 100644
> --- a/net/xfrm/xfrm_interface_core.c
> +++ b/net/xfrm/xfrm_interface_core.c
> @@ -396,6 +396,14 @@ xfrmi_xmit2(struct sk_buff *skb, struct net_device *dev, struct flowi *fl)
>   
>   		if_id = md_info->if_id;
>   		fl->flowi_oif = md_info->link;
> +		if (md_info->dst_orig) {
> +			struct dst_entry *tmp_dst = dst;
> +
> +			dst = md_info->dst_orig;
> +			skb_dst_set(skb, dst);

(contd) ... skb_dst_set() is always called here.  (considering there is 
skb_dst_set_noref()).


> +			md_info->dst_orig = NULL;
> +			dst_release(tmp_dst);
> +		}
>   	} else {
>   		if_id = xi->p.if_id;
>   	}
> @@ -1162,12 +1170,18 @@ static int __init xfrmi_init(void)
>   	if (err < 0)
>   		goto rtnl_link_failed;
>   
> +	err = register_xfrm_interface_bpf();
> +	if (err < 0)
> +		goto kfunc_failed;
> +
>   	lwtunnel_encap_add_ops(&xfrmi_encap_ops, LWTUNNEL_ENCAP_XFRM);
>   
>   	xfrm_if_register_cb(&xfrm_if_cb);
>   
>   	return err;
>   
> +kfunc_failed:
> +	rtnl_link_unregister(&xfrmi_link_ops);
>   rtnl_link_failed:
>   	xfrmi6_fini();
>   xfrmi6_failed:
> @@ -1183,6 +1197,7 @@ static void __exit xfrmi_fini(void)
>   {
>   	xfrm_if_unregister_cb();
>   	lwtunnel_encap_del_ops(&xfrmi_encap_ops, LWTUNNEL_ENCAP_XFRM);
> +	cleanup_xfrm_interface_bpf();
>   	rtnl_link_unregister(&xfrmi_link_ops);
>   	xfrmi4_fini();
>   	xfrmi6_fini();

