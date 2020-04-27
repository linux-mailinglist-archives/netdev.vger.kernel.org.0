Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0AACA1BB0A1
	for <lists+netdev@lfdr.de>; Mon, 27 Apr 2020 23:37:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726338AbgD0VhP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Apr 2020 17:37:15 -0400
Received: from www62.your-server.de ([213.133.104.62]:50032 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726194AbgD0VhP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Apr 2020 17:37:15 -0400
Received: from sslproxy05.your-server.de ([78.46.172.2])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1jTBR3-00037V-8y; Mon, 27 Apr 2020 23:37:05 +0200
Received: from [178.195.186.98] (helo=pc-9.home)
        by sslproxy05.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1jTBR2-000H1P-R1; Mon, 27 Apr 2020 23:37:04 +0200
Subject: Re: [PATCH bpf-next v3 1/2] bpf: Change error code when ops is NULL
To:     Mao Wenan <maowenan@huawei.com>, ast@kernel.org, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com, andriin@fb.com,
        john.fastabend@gmail.com, kpsingh@chromium.org,
        andrii.nakryiko@gmail.com, dan.carpenter@oracle.com
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        kernel-janitors@vger.kernel.org
References: <20200426063635.130680-1-maowenan@huawei.com>
 <20200426063635.130680-2-maowenan@huawei.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <6f975e8c-34f5-4bcb-d99d-d1977866bedf@iogearbox.net>
Date:   Mon, 27 Apr 2020 23:37:03 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20200426063635.130680-2-maowenan@huawei.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.2/25795/Mon Apr 27 14:00:10 2020)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/26/20 8:36 AM, Mao Wenan wrote:
> There is one error printed when use BPF_MAP_TYPE_SOCKMAP to create map:
> libbpf: failed to create map (name: 'sock_map'): Invalid argument(-22)
> 
> This is because CONFIG_BPF_STREAM_PARSER is not set, and
> bpf_map_types[type] return invalid ops. It is not clear to show the
> cause of config missing with return code -EINVAL.
> 
> Signed-off-by: Mao Wenan <maowenan@huawei.com>
> ---
>   kernel/bpf/syscall.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
> index d85f37239540..8ae78c98d91e 100644
> --- a/kernel/bpf/syscall.c
> +++ b/kernel/bpf/syscall.c
> @@ -113,7 +113,7 @@ static struct bpf_map *find_and_alloc_map(union bpf_attr *attr)
>   	type = array_index_nospec(type, ARRAY_SIZE(bpf_map_types));
>   	ops = bpf_map_types[type];
>   	if (!ops)
> -		return ERR_PTR(-EINVAL);
> +		return ERR_PTR(-EOPNOTSUPP);
>   
>   	if (ops->map_alloc_check) {
>   		err = ops->map_alloc_check(attr);
> 

Unless I'm missing the use-case, why not using bpftool's feature probe to check for
availability (alternatively via 'feature probe kernel macros' if you need this into
inside the BPF prog for ifdef etc)?

   bpftool feature probe kernel | grep sockmap
   eBPF map_type sockmap is NOT available

Thanks,
Daniel
