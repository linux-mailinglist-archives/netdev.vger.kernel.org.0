Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4866E31C3E7
	for <lists+netdev@lfdr.de>; Mon, 15 Feb 2021 23:04:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229710AbhBOWEN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Feb 2021 17:04:13 -0500
Received: from www62.your-server.de ([213.133.104.62]:59464 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229520AbhBOWEJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Feb 2021 17:04:09 -0500
Received: from sslproxy06.your-server.de ([78.46.172.3])
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1lBlxi-0008vO-Tx; Mon, 15 Feb 2021 23:03:22 +0100
Received: from [85.7.101.30] (helo=pc-9.home)
        by sslproxy06.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1lBlxi-000GCA-KS; Mon, 15 Feb 2021 23:03:22 +0100
Subject: Re: [PATCHv19 bpf-next 2/6] bpf: add a new bpf argument type
 ARG_CONST_MAP_PTR_OR_NULL
To:     Hangbin Liu <liuhangbin@gmail.com>, bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org,
        =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>,
        Jiri Benc <jbenc@redhat.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Eelco Chaudron <echaudro@redhat.com>, ast@kernel.org,
        Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>
References: <20210208104747.573461-1-liuhangbin@gmail.com>
 <20210208104747.573461-3-liuhangbin@gmail.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <737a6e4f-1551-e686-f180-e5d08347dbea@iogearbox.net>
Date:   Mon, 15 Feb 2021 23:03:21 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20210208104747.573461-3-liuhangbin@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.4/26081/Mon Feb 15 13:19:24 2021)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/8/21 11:47 AM, Hangbin Liu wrote:
> Add a new bpf argument type ARG_CONST_MAP_PTR_OR_NULL which could be
> used when we want to allow NULL pointer for map parameter. The bpf helper
> need to take care and check if the map is NULL when use this type.
> 
> Acked-by: Toke Høiland-Jørgensen <toke@redhat.com>
> Acked-by: John Fastabend <john.fastabend@gmail.com>
> Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
[...]
> @@ -4259,9 +4261,9 @@ static int check_func_arg(struct bpf_verifier_env *env, u32 arg,
>   		meta->ref_obj_id = reg->ref_obj_id;
>   	}
>   
> -	if (arg_type == ARG_CONST_MAP_PTR) {
> -		/* bpf_map_xxx(map_ptr) call: remember that map_ptr */
> -		meta->map_ptr = reg->map_ptr;
> +	if (arg_type == ARG_CONST_MAP_PTR ||
> +	    arg_type == ARG_CONST_MAP_PTR_OR_NULL) {
> +		meta->map_ptr = register_is_null(reg) ? NULL : reg->map_ptr;

Sorry, but after re-reading this is unfortunately still broken :( Looking at your
helper func proto:

+static const struct bpf_func_proto bpf_xdp_redirect_map_multi_proto = {
+	.func           = bpf_xdp_redirect_map_multi,
+	.gpl_only       = false,
+	.ret_type       = RET_INTEGER,
+	.arg1_type      = ARG_CONST_MAP_PTR,
+	.arg2_type      = ARG_CONST_MAP_PTR_OR_NULL,
+	.arg3_type      = ARG_ANYTHING,
+};

So in check_helper_call() first meta->map_ptr is set to arg1 map, then when
checking arg2 map it can either be const NULL or a valid map ptr, but then
later on in check_map_func_compatibility() we only end up checking compatibility
of the /2nd/ map (e.g. on !meta->map_ptr we just return 0). This means, we
can pass whatever map type as arg1 map and it will pass the verifier just fine.
