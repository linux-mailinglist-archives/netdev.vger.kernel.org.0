Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 796FF63DCEF
	for <lists+netdev@lfdr.de>; Wed, 30 Nov 2022 19:18:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229786AbiK3SR7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Nov 2022 13:17:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230288AbiK3SRa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Nov 2022 13:17:30 -0500
Received: from out2.migadu.com (out2.migadu.com [188.165.223.204])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 008BF88B56;
        Wed, 30 Nov 2022 10:15:18 -0800 (PST)
Message-ID: <b3306950-bea9-e914-0491-54048d6d55e4@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1669832107;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=cLk4yabJzvkIcVmaArcXfeMK0WT9teH2A3xR5+0JBmQ=;
        b=BN0Tx1JDsXTuP0AEdr7CMBTRwApD3BJ8bru3zwgbLz1lEyhZLGZlLe87vrP2IQZva9PdpL
        S8VglkwhjobLUazPcH01M1jYa2efXKdrTLlCgbl8GOosVgu0wWuaCRcIjLBw4THCji3iiL
        pSExCBdcOZwL58B5K5nKHeeCHyMcLmU=
Date:   Wed, 30 Nov 2022 10:14:56 -0800
MIME-Version: 1.0
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Martin KaFai Lau <martin.lau@linux.dev>
Subject: Re: [PATCH ipsec-next,v2 2/3] xfrm: interface: Add unstable helpers
 for setting/getting XFRM metadata from TC-BPF
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
References: <20221129132018.985887-1-eyal.birger@gmail.com>
 <20221129132018.985887-3-eyal.birger@gmail.com>
Content-Language: en-US
In-Reply-To: <20221129132018.985887-3-eyal.birger@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/29/22 5:20 AM, Eyal Birger wrote:
> diff --git a/net/xfrm/xfrm_interface_bpf.c b/net/xfrm/xfrm_interface_bpf.c
> new file mode 100644
> index 000000000000..757e15857dbf
> --- /dev/null
> +++ b/net/xfrm/xfrm_interface_bpf.c
> @@ -0,0 +1,100 @@
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
No need to introduce a bpf variant of the "struct xfrm_md_info" (more on this 
later).

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

This kfunc is not needed.  It only reads the skb->_skb_refdst.  The new kfunc 
bpf_rdonly_cast() can be used.  Take a look at the bpf_rdonly_cast() usages in 
the selftests/bpf/progs/type_cast.c.  It was in bpf-next only but should also be 
in net-next now.

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

Directly use "const struct xfrm_md_info *from" instead.  This kfunc can check 
from->dst_orig != NULL and return -EINVAL.  It will then have a consistent API 
with the bpf_rdonly_cast() mentioned above.

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

Unnecessary memset here.  Everything should have been initialized below. 
bpf_skb_set_tunnel_key() needs memset but not here.

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

May be DEFINE_PER_CPU() instead?

> +	if (!xfrm_md_dst)
> +		return -ENOMEM;
> +	err = register_btf_kfunc_id_set(BPF_PROG_TYPE_SCHED_CLS,
> +					&xfrm_interface_kfunc_set);
> +	if (err < 0) {
> +		cleanup_xfrm_interface_bpf();
> +		return err;
> +	}
> +	return 0;
> +}
> +
> +void __exit cleanup_xfrm_interface_bpf(void)
> +{
> +	metadata_dst_free_percpu(xfrm_md_dst);
> +}

