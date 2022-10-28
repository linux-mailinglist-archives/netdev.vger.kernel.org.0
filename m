Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DC6F5610A47
	for <lists+netdev@lfdr.de>; Fri, 28 Oct 2022 08:23:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229519AbiJ1GXB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Oct 2022 02:23:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229522AbiJ1GXA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Oct 2022 02:23:00 -0400
Received: from out0.migadu.com (out0.migadu.com [IPv6:2001:41d0:2:267::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F38141B8658;
        Thu, 27 Oct 2022 23:22:58 -0700 (PDT)
Message-ID: <31f3aa18-d368-9738-8bb5-857cd5f2c5bf@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1666938177;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=PjdyWQHBxlFEAVHsy8KHBXasKBH77ZloY2jBob0cGSo=;
        b=fIzOSJYKqfCNmFAW/5mh3gmrzWOW0oqCM0LOy7QJynO+iAi/by4YiDk60k6tps9S9BET+x
        YFr5HJYVFCz4QM+52y79KWf8k4FRAY5wD4PzdoNlm49GykrxhtvczSLjAoQHOcR7qQrNH3
        G6zCM/qR5I9tnG3gJ7y3A2UOIFCZW/g=
Date:   Thu, 27 Oct 2022 23:22:51 -0700
MIME-Version: 1.0
Subject: Re: [RFC bpf-next 5/5] selftests/bpf: Test rx_timestamp metadata in
 xskxceiver
Content-Language: en-US
To:     Stanislav Fomichev <sdf@google.com>
Cc:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        song@kernel.org, yhs@fb.com, john.fastabend@gmail.com,
        kpsingh@kernel.org, haoluo@google.com, jolsa@kernel.org,
        Jakub Kicinski <kuba@kernel.org>,
        Willem de Bruijn <willemb@google.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Anatoly Burakov <anatoly.burakov@intel.com>,
        Alexander Lobakin <alexandr.lobakin@intel.com>,
        Magnus Karlsson <magnus.karlsson@gmail.com>,
        Maryam Tahhan <mtahhan@redhat.com>, xdp-hints@xdp-project.net,
        netdev@vger.kernel.org, bpf@vger.kernel.org
References: <20221027200019.4106375-1-sdf@google.com>
 <20221027200019.4106375-6-sdf@google.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Martin KaFai Lau <martin.lau@linux.dev>
In-Reply-To: <20221027200019.4106375-6-sdf@google.com>
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

On 10/27/22 1:00 PM, Stanislav Fomichev wrote:
> Example on how the metadata is prepared from the BPF context
> and consumed by AF_XDP:
> 
> - bpf_xdp_metadata_have_rx_timestamp to test whether it's supported;
>    if not, I'm assuming verifier will remove this "if (0)" branch
> - bpf_xdp_metadata_rx_timestamp returns a _copy_ of metadata;
>    the program has to bpf_xdp_adjust_meta+memcpy it;
>    maybe returning a pointer is better?
> - af_xdp consumer grabs it from data-<expected_metadata_offset> and
>    makes sure timestamp is not empty
> - when loading the program, we pass BPF_F_XDP_HAS_METADATA+prog_ifindex
> 
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
>   .../testing/selftests/bpf/progs/xskxceiver.c  | 22 ++++++++++++++++++
>   tools/testing/selftests/bpf/xskxceiver.c      | 23 ++++++++++++++++++-
>   2 files changed, 44 insertions(+), 1 deletion(-)
> 
> diff --git a/tools/testing/selftests/bpf/progs/xskxceiver.c b/tools/testing/selftests/bpf/progs/xskxceiver.c
> index b135daddad3a..83c879aa3581 100644
> --- a/tools/testing/selftests/bpf/progs/xskxceiver.c
> +++ b/tools/testing/selftests/bpf/progs/xskxceiver.c
> @@ -12,9 +12,31 @@ struct {
>   	__type(value, __u32);
>   } xsk SEC(".maps");
>   
> +extern int bpf_xdp_metadata_have_rx_timestamp(struct xdp_md *ctx) __ksym;
> +extern __u32 bpf_xdp_metadata_rx_timestamp(struct xdp_md *ctx) __ksym;
> +
>   SEC("xdp")
>   int rx(struct xdp_md *ctx)
>   {
> +	void *data, *data_meta;
> +	__u32 rx_timestamp;
> +	int ret;
> +
> +	if (bpf_xdp_metadata_have_rx_timestamp(ctx)) {
> +		ret = bpf_xdp_adjust_meta(ctx, -(int)sizeof(__u32));
> +		if (ret != 0)
> +			return XDP_DROP;
> +
> +		data = (void *)(long)ctx->data;
> +		data_meta = (void *)(long)ctx->data_meta;
> +
> +		if (data_meta + sizeof(__u32) > data)
> +			return XDP_DROP;
> +
> +		rx_timestamp = bpf_xdp_metadata_rx_timestamp(ctx);
> +		__builtin_memcpy(data_meta, &rx_timestamp, sizeof(__u32));
> +	}

Thanks for the patches.  I took a quick look at patch 1 and 2 but haven't had a 
chance to look at the implementation details (eg. KF_UNROLL...etc), yet.

Overall (with the example here) looks promising.  There is a lot of flexibility 
on whether the xdp prog needs any hint at all, which hint it needs, and how to 
store it.

> +
>   	return bpf_redirect_map(&xsk, ctx->rx_queue_index, XDP_PASS);
>   }
>   
> diff --git a/tools/testing/selftests/bpf/xskxceiver.c b/tools/testing/selftests/bpf/xskxceiver.c
> index 066bd691db13..ce82c89a432e 100644
> --- a/tools/testing/selftests/bpf/xskxceiver.c
> +++ b/tools/testing/selftests/bpf/xskxceiver.c
> @@ -871,7 +871,9 @@ static bool is_offset_correct(struct xsk_umem_info *umem, struct pkt_stream *pkt
>   static bool is_pkt_valid(struct pkt *pkt, void *buffer, u64 addr, u32 len)
>   {
>   	void *data = xsk_umem__get_data(buffer, addr);
> +	void *data_meta = data - sizeof(__u32);
>   	struct iphdr *iphdr = (struct iphdr *)(data + sizeof(struct ethhdr));
> +	__u32 rx_timestamp = 0;
>   
>   	if (!pkt) {
>   		ksft_print_msg("[%s] too many packets received\n", __func__);
> @@ -907,6 +909,13 @@ static bool is_pkt_valid(struct pkt *pkt, void *buffer, u64 addr, u32 len)
>   		return false;
>   	}
>   
> +	memcpy(&rx_timestamp, data_meta, sizeof(rx_timestamp));
> +	if (rx_timestamp == 0) {
> +		ksft_print_msg("Invalid metadata received: ");
> +		ksft_print_msg("got %08x, expected != 0\n", rx_timestamp);
> +		return false;
> +	}
> +
>   	return true;
>   }

>   

