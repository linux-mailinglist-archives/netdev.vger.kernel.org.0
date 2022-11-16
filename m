Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ED0A662B3AB
	for <lists+netdev@lfdr.de>; Wed, 16 Nov 2022 08:04:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232111AbiKPHEf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Nov 2022 02:04:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232022AbiKPHEe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Nov 2022 02:04:34 -0500
Received: from out2.migadu.com (out2.migadu.com [188.165.223.204])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0219910A1;
        Tue, 15 Nov 2022 23:04:31 -0800 (PST)
Message-ID: <fd21dfd5-f458-dfba-594d-3aafd6a4648a@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1668582270;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=3p3BDjMaIeWiHiTfc5N33AZZ1i73cE2xBBhFOU13Cp4=;
        b=gd4nA+inqNhDcrizoNUlUXpu2lfLcvZnEHWA8U8on2HpS5dC5SAqJP23fAsB/ewv7C97BS
        yXJf8UCNJvYlcYZWsFel/y6L2eQmLGJKYCFetUxnpeTt+6URK2+GE5MhEpglvUHJZ0WPQX
        YNZaFYpZhE4q3qqHr2ga/MGycd8u6G8=
Date:   Tue, 15 Nov 2022 23:04:22 -0800
MIME-Version: 1.0
Subject: Re: [PATCH bpf-next 06/11] xdp: Carry over xdp metadata into skb
 context
Content-Language: en-US
To:     Stanislav Fomichev <sdf@google.com>
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
References: <20221115030210.3159213-1-sdf@google.com>
 <20221115030210.3159213-7-sdf@google.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Martin KaFai Lau <martin.lau@linux.dev>
In-Reply-To: <20221115030210.3159213-7-sdf@google.com>
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

On 11/14/22 7:02 PM, Stanislav Fomichev wrote:
> Implement new bpf_xdp_metadata_export_to_skb kfunc which
> prepares compatible xdp metadata for kernel consumption.
> This kfunc should be called prior to bpf_redirect
> or when XDP_PASS'ing the frame into the kernel (note, the drivers
> have to be updated to enable consuming XDP_PASS'ed metadata).
> 
> veth driver is amended to consume this metadata when converting to skb.
> 
> Internally, XDP_FLAGS_HAS_SKB_METADATA flag is used to indicate
> whether the frame has skb metadata. The metadata is currently
> stored prior to xdp->data_meta. bpf_xdp_adjust_meta refuses
> to work after a call to bpf_xdp_metadata_export_to_skb (can lift
> this requirement later on if needed, we'd have to memmove
> xdp_skb_metadata).

It is ok to refuse bpf_xdp_adjust_meta() after bpf_xdp_metadata_export_to_skb() 
for now.  However, it will also need to refuse bpf_xdp_adjust_head().

[ ... ]

> +/* For the packets directed to the kernel, this kfunc exports XDP metadata
> + * into skb context.
> + */
> +noinline int bpf_xdp_metadata_export_to_skb(const struct xdp_md *ctx)
> +{
> +	return 0;
> +}
> +

I think it is still better to return 'struct xdp_skb_metata *' instead of 
true/false.  Like:

noinline struct xdp_skb_metata *bpf_xdp_metadata_export_to_skb(const struct 
xdp_md *ctx)
{
	return 0;
}

The KF_RET_NULL has already been set in 
BTF_SET8_START_GLOBAL(xdp_metadata_kfunc_ids).  There is 
"xdp_btf_struct_access()" that can allow write access to 'struct xdp_skb_metata' 
What else is missing? We can try to solve it.

Then there is no need for this double check in patch 8 selftest which is not 
easy to use:

+               if (bpf_xdp_metadata_export_to_skb(ctx) < 0) {
+                       bpf_printk("bpf_xdp_metadata_export_to_skb failed");
+                       return XDP_DROP;
+               }

[ ... ]

+               skb_metadata = ctx->skb_metadata;
+               if (!skb_metadata) {
+                       bpf_printk("no ctx->skb_metadata");
+                       return XDP_DROP;
+               }

[ ... ]


> diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
> index b444b1118c4f..71e3bc7ad839 100644
> --- a/tools/include/uapi/linux/bpf.h
> +++ b/tools/include/uapi/linux/bpf.h
> @@ -6116,6 +6116,12 @@ enum xdp_action {
>   	XDP_REDIRECT,
>   };
>   
> +/* Subset of XDP metadata exported to skb context.
> + */
> +struct xdp_skb_metadata {
> +	__u64 rx_timestamp;
> +};
> +
>   /* user accessible metadata for XDP packet hook
>    * new fields must be added to the end of this structure
>    */
> @@ -6128,6 +6134,7 @@ struct xdp_md {
>   	__u32 rx_queue_index;  /* rxq->queue_index  */
>   
>   	__u32 egress_ifindex;  /* txq->dev->ifindex */
> +	__bpf_md_ptr(struct xdp_skb_metadata *, skb_metadata);

Once the above bpf_xdp_metadata_export_to_skb() returning a pointer works, then 
it can be another kfunc 'struct xdp_skb_metata * bpf_xdp_get_skb_metadata(const 
struct xdp_md *ctx)' to return the skb_metadata which was a similar point 
discussed in the previous RFC.

