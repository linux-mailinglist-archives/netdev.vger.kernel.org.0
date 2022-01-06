Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C6B8C486DD1
	for <lists+netdev@lfdr.de>; Fri,  7 Jan 2022 00:34:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245535AbiAFXeq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jan 2022 18:34:46 -0500
Received: from www62.your-server.de ([213.133.104.62]:52640 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245495AbiAFXep (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Jan 2022 18:34:45 -0500
Received: from [78.46.152.42] (helo=sslproxy04.your-server.de)
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1n5cHI-00070o-1a; Fri, 07 Jan 2022 00:34:40 +0100
Received: from [85.1.206.226] (helo=linux.home)
        by sslproxy04.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1n5cHH-000W5q-PD; Fri, 07 Jan 2022 00:34:39 +0100
Subject: Re: [PATCH bpf-next v3] Add skb_store_bytes() for
 BPF_PROG_TYPE_CGROUP_SKB
To:     Tyler Wear <quic_twear@quicinc.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Cc:     maze@google.com, yhs@fb.com, kafai@fb.com, toke@redhat.com,
        Tyler Wear <quic_twear@quicinc.org>
References: <20220106004340.2317542-1-quic_twear@quicinc.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <a827c4a8-44bd-54d0-2a39-f2552ae9d30f@iogearbox.net>
Date:   Fri, 7 Jan 2022 00:34:39 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20220106004340.2317542-1-quic_twear@quicinc.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.3/26414/Thu Jan  6 10:26:00 2022)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/6/22 1:43 AM, Tyler Wear wrote:
> From: Tyler Wear <quic_twear@quicinc.org>
> 
> Need to modify the ds field to support upcoming Wifi QoS Alliance spec.
> Instead of adding generic function for just modifying the ds field,
> add skb_store_bytes for BPF_PROG_TYPE_CGROUP_SKB.
> This allows other fields in the network and transport header to be
> modified in the future.
> 
> Checksum API's also need to be added for completeness.
> 
> It is not possible to use CGROUP_(SET|GET)SOCKOPT since
> the policy may change during runtime and would result
> in a large number of entries with wildcards.
> 
> Signed-off-by: Tyler Wear <quic_twear@quicinc.com>
> ---
>   net/core/filter.c                             | 10 ++
>   .../bpf/prog_tests/cgroup_store_bytes.c       | 97 +++++++++++++++++++
>   .../selftests/bpf/progs/cgroup_store_bytes.c  | 64 ++++++++++++
>   3 files changed, 171 insertions(+)
>   create mode 100644 tools/testing/selftests/bpf/prog_tests/cgroup_store_bytes.c
>   create mode 100644 tools/testing/selftests/bpf/progs/cgroup_store_bytes.c
> 
> diff --git a/net/core/filter.c b/net/core/filter.c
> index 6102f093d59a..ce01a8036361 100644
> --- a/net/core/filter.c
> +++ b/net/core/filter.c
> @@ -7299,6 +7299,16 @@ cg_skb_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
>   		return &bpf_sk_storage_delete_proto;
>   	case BPF_FUNC_perf_event_output:
>   		return &bpf_skb_event_output_proto;
> +	case BPF_FUNC_skb_store_bytes:
> +		return &bpf_skb_store_bytes_proto;
> +	case BPF_FUNC_csum_update:
> +		return &bpf_csum_update_proto;
> +	case BPF_FUNC_csum_level:
> +		return &bpf_csum_level_proto;
> +	case BPF_FUNC_l3_csum_replace:
> +		return &bpf_l3_csum_replace_proto;
> +	case BPF_FUNC_l4_csum_replace:
> +		return &bpf_l4_csum_replace_proto;
>   #ifdef CONFIG_SOCK_CGROUP_DATA
>   	case BPF_FUNC_skb_cgroup_id:
>   		return &bpf_skb_cgroup_id_proto;

Do we need skb_share_check in the write helpers at these hook points when this
goes beyond just reading?

Thanks,
Daniel
