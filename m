Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 248FD640101
	for <lists+netdev@lfdr.de>; Fri,  2 Dec 2022 08:25:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232467AbiLBHZf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Dec 2022 02:25:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232383AbiLBHZe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Dec 2022 02:25:34 -0500
X-Greylist: delayed 39995 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 01 Dec 2022 23:25:32 PST
Received: from out-142.mta0.migadu.com (out-142.mta0.migadu.com [91.218.175.142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB260AC6F1
        for <netdev@vger.kernel.org>; Thu,  1 Dec 2022 23:25:32 -0800 (PST)
Message-ID: <55c5d250-f3c4-84e0-c56f-cd554ee05482@linux.dev>
Date:   Thu, 1 Dec 2022 23:25:22 -0800
MIME-Version: 1.0
Subject: Re: [PATCH bpf-next,v3 2/4] xfrm: interface: Add unstable helpers for
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
        jolsa@kernel.org, shuah@kernel.org, liuhangbin@gmail.com,
        lixiaoyan@google.com
References: <20221201211425.1528197-1-eyal.birger@gmail.com>
 <20221201211425.1528197-3-eyal.birger@gmail.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Martin KaFai Lau <martin.lau@linux.dev>
In-Reply-To: <20221201211425.1528197-3-eyal.birger@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/1/22 1:14 PM, Eyal Birger wrote:
> This change adds xfrm metadata helpers using the unstable kfunc call
> interface for the TC-BPF hooks. This allows steering traffic towards
> different IPsec connections based on logic implemented in bpf programs.
> 
> This object is built based on the availabilty of BTF debug info.

s/availabilty/availability/

> 
> The metadata percpu dsts used on TX take ownership of the original skb
> dsts so that they may be used as part of the xfrm transmittion logic -

s/transmittion/transmission/

[ ... ]

> diff --git a/net/xfrm/Makefile b/net/xfrm/Makefile
> index 08a2870fdd36..cd47f88921f5 100644
> --- a/net/xfrm/Makefile
> +++ b/net/xfrm/Makefile
> @@ -5,6 +5,12 @@
>   
>   xfrm_interface-$(CONFIG_XFRM_INTERFACE) += xfrm_interface_core.o
>   
> +ifeq ($(CONFIG_XFRM_INTERFACE),m)
> +xfrm_interface-$(CONFIG_DEBUG_INFO_BTF_MODULES) += xfrm_interface_bpf.o
> +else ifeq ($(CONFIG_XFRM_INTERFACE),y)
> +xfrm_interface-$(CONFIG_DEBUG_INFO_BTF) += xfrm_interface_bpf.o
> +endif
> +
>   obj-$(CONFIG_XFRM) := xfrm_policy.o xfrm_state.o xfrm_hash.o \
>   		      xfrm_input.o xfrm_output.o \
>   		      xfrm_sysctl.o xfrm_replay.o xfrm_device.o
> diff --git a/net/xfrm/xfrm_interface_bpf.c b/net/xfrm/xfrm_interface_bpf.c
> new file mode 100644
> index 000000000000..7938bf6cbb32
> --- /dev/null
> +++ b/net/xfrm/xfrm_interface_bpf.c
> @@ -0,0 +1,99 @@
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

Documentation is needed here and...

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

... also this get and the following set kfunc.

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
> +
> +	info->if_id = from->if_id;
> +	info->link = from->link;
> +	skb_dst_force(skb);
> +	info->dst_orig = skb_dst(skb);
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
> +	int err;
> +
> +	xfrm_md_dst = metadata_dst_alloc_percpu(0, METADATA_XFRM,
> +						GFP_KERNEL);
> +	if (!xfrm_md_dst)
> +		return -ENOMEM;
> +	err = register_btf_kfunc_id_set(BPF_PROG_TYPE_SCHED_CLS,
> +					&xfrm_interface_kfunc_set);
> +	if (err < 0) {
> +		cleanup_xfrm_interface_bpf();


nit. Directly call metadata_dst_free_percpu(xfrm_md_dst), easier to read.
> +		return err;
> +	}
> +	return 0;
> +}
> +
> +void cleanup_xfrm_interface_bpf(void)
> +{
> +	metadata_dst_free_percpu(xfrm_md_dst);
> +}

