Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BDE312327BB
	for <lists+netdev@lfdr.de>; Thu, 30 Jul 2020 00:52:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727975AbgG2Wwh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jul 2020 18:52:37 -0400
Received: from www62.your-server.de ([213.133.104.62]:51128 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726709AbgG2Wwh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Jul 2020 18:52:37 -0400
Received: from sslproxy05.your-server.de ([78.46.172.2])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1k0uvu-0005PO-AA; Thu, 30 Jul 2020 00:52:22 +0200
Received: from [178.196.57.75] (helo=pc-9.home)
        by sslproxy05.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1k0uvu-000BDt-4V; Thu, 30 Jul 2020 00:52:22 +0200
Subject: Re: [PATCH bpf-next 1/2] bpf: expose socket storage to
 BPF_PROG_TYPE_CGROUP_SOCK
To:     Stanislav Fomichev <sdf@google.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Cc:     davem@davemloft.net, ast@kernel.org,
        Martin KaFai Lau <kafai@fb.com>
References: <20200729003104.1280813-1-sdf@google.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <92a04281-8bfb-78ec-25b0-fa7adf8dd9c5@iogearbox.net>
Date:   Thu, 30 Jul 2020 00:52:21 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20200729003104.1280813-1-sdf@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.3/25888/Wed Jul 29 16:57:45 2020)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/29/20 2:31 AM, Stanislav Fomichev wrote:
> This lets us use socket storage from the following hooks:
> * BPF_CGROUP_INET_SOCK_CREATE
> * BPF_CGROUP_INET_SOCK_RELEASE
> * BPF_CGROUP_INET4_POST_BIND
> * BPF_CGROUP_INET6_POST_BIND
> 
> Using existing 'bpf_sk_storage_get_proto' doesn't work because
> second argument is ARG_PTR_TO_SOCKET. Even though
> BPF_PROG_TYPE_CGROUP_SOCK hooks operate on 'struct bpf_sock',
> the verifier still considers it as a PTR_TO_CTX.
> That's why I'm adding another 'bpf_sk_storage_get_cg_sock_proto'
> definition strictly for BPF_PROG_TYPE_CGROUP_SOCK which accepts
> ARG_PTR_TO_CTX which is really 'struct sock' for this program type.
> 
> Cc: Martin KaFai Lau <kafai@fb.com>
> Signed-off-by: Stanislav Fomichev <sdf@google.com>

Makes sense, both applied, thanks!

[...]
> diff --git a/net/core/filter.c b/net/core/filter.c
> index 29e3455122f7..7124f0fe6974 100644
> --- a/net/core/filter.c
> +++ b/net/core/filter.c
> @@ -6187,6 +6187,7 @@ bool bpf_helper_changes_pkt_data(void *func)
>   }
>   
>   const struct bpf_func_proto bpf_event_output_data_proto __weak;
> +const struct bpf_func_proto bpf_sk_storage_get_cg_sock_proto __weak;
>   
>   static const struct bpf_func_proto *
>   sock_filter_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
> @@ -6219,6 +6220,8 @@ sock_filter_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
>   	case BPF_FUNC_get_cgroup_classid:
>   		return &bpf_get_cgroup_classid_curr_proto;
>   #endif
> +	case BPF_FUNC_sk_storage_get:
> +		return &bpf_sk_storage_get_cg_sock_proto;

Been wondering whether we need these for connect/sendmsg/etc hooks that operate
on sock_addr, but for those we have them already covered in sock_addr_func_proto()
therefore all good.

sock_addr_func_proto() also lists the BPF_FUNC_sk_storage_delete. Should we add
that one as well for sock_filter_func_proto()? Presumably create/release doesn't
make sense, but any use case for bind hook?

>   	default:
>   		return bpf_base_func_proto(func_id);
>   	}
> 

