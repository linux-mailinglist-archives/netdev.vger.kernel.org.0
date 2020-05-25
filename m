Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C679A1E1767
	for <lists+netdev@lfdr.de>; Mon, 25 May 2020 23:52:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731577AbgEYVvs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 May 2020 17:51:48 -0400
Received: from www62.your-server.de ([213.133.104.62]:47828 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727047AbgEYVvs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 May 2020 17:51:48 -0400
Received: from sslproxy01.your-server.de ([78.46.139.224])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1jdL0Z-0007By-Hz; Mon, 25 May 2020 23:51:43 +0200
Received: from [178.196.57.75] (helo=pc-9.home)
        by sslproxy01.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1jdL0Z-000BAv-9t; Mon, 25 May 2020 23:51:43 +0200
Subject: Re: [bpf-next PATCH v5 1/5] bpf, sk_msg: add some generic helpers
 that may be useful from sk_msg
To:     John Fastabend <john.fastabend@gmail.com>, yhs@fb.com,
        andrii.nakryiko@gmail.com, ast@kernel.org
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org
References: <159033879471.12355.1236562159278890735.stgit@john-Precision-5820-Tower>
 <159033903373.12355.15489763099696629346.stgit@john-Precision-5820-Tower>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <48c47712-bba1-3f53-bbeb-8a7403dab6db@iogearbox.net>
Date:   Mon, 25 May 2020 23:51:42 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <159033903373.12355.15489763099696629346.stgit@john-Precision-5820-Tower>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.2/25823/Mon May 25 14:23:53 2020)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/24/20 6:50 PM, John Fastabend wrote:
> Add these generic helpers that may be useful to use from sk_msg programs.
> The helpers do not depend on ctx so we can simply add them here,
> 
>   BPF_FUNC_perf_event_output
>   BPF_FUNC_get_current_uid_gid
>   BPF_FUNC_get_current_pid_tgid
>   BPF_FUNC_get_current_comm

Hmm, added helpers below are what you list here except get_current_comm.
Was this forgotten to be added here?

>   BPF_FUNC_get_current_cgroup_id
>   BPF_FUNC_get_current_ancestor_cgroup_id
>   BPF_FUNC_get_cgroup_classid
> 
> Acked-by: Yonghong Song <yhs@fb.com>
> Signed-off-by: John Fastabend <john.fastabend@gmail.com>
> ---
>   net/core/filter.c |   16 ++++++++++++++++
>   1 file changed, 16 insertions(+)
> 
> diff --git a/net/core/filter.c b/net/core/filter.c
> index 822d662..a56046a 100644
> --- a/net/core/filter.c
> +++ b/net/core/filter.c
> @@ -6443,6 +6443,22 @@ sk_msg_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
>   		return &bpf_msg_push_data_proto;
>   	case BPF_FUNC_msg_pop_data:
>   		return &bpf_msg_pop_data_proto;
> +	case BPF_FUNC_perf_event_output:
> +		return &bpf_event_output_data_proto;
> +	case BPF_FUNC_get_current_uid_gid:
> +		return &bpf_get_current_uid_gid_proto;
> +	case BPF_FUNC_get_current_pid_tgid:
> +		return &bpf_get_current_pid_tgid_proto;
> +#ifdef CONFIG_CGROUPS
> +	case BPF_FUNC_get_current_cgroup_id:
> +		return &bpf_get_current_cgroup_id_proto;
> +	case BPF_FUNC_get_current_ancestor_cgroup_id:
> +		return &bpf_get_current_ancestor_cgroup_id_proto;
> +#endif
> +#ifdef CONFIG_CGROUP_NET_CLASSID
> +	case BPF_FUNC_get_cgroup_classid:
> +		return &bpf_get_cgroup_classid_curr_proto;
> +#endif
>   	default:
>   		return bpf_base_func_proto(func_id);
>   	}
> 

