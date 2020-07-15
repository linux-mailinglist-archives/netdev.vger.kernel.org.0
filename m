Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 87C01221507
	for <lists+netdev@lfdr.de>; Wed, 15 Jul 2020 21:23:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726873AbgGOTXm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jul 2020 15:23:42 -0400
Received: from www62.your-server.de ([213.133.104.62]:36888 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726479AbgGOTXm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jul 2020 15:23:42 -0400
Received: from sslproxy05.your-server.de ([78.46.172.2])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1jvn0A-0001qF-0g; Wed, 15 Jul 2020 21:23:34 +0200
Received: from [178.196.57.75] (helo=pc-9.home)
        by sslproxy05.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1jvn09-000LxG-P9; Wed, 15 Jul 2020 21:23:33 +0200
Subject: Re: [PATCH] tools/bpftool: Fix error return code in do_skeleton()
To:     YueHaibing <yuehaibing@huawei.com>, ast@kernel.org, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com, andriin@fb.com,
        john.fastabend@gmail.com, kpsingh@chromium.org
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20200715031353.14692-1-yuehaibing@huawei.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <6cb1dfd7-6456-ef1c-d708-042ab53b3d2c@iogearbox.net>
Date:   Wed, 15 Jul 2020 21:23:33 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20200715031353.14692-1-yuehaibing@huawei.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.3/25874/Wed Jul 15 16:18:08 2020)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/15/20 5:13 AM, YueHaibing wrote:
> The error return code should be PTR_ERR(obj) other than
> PTR_ERR(NULL).
> 
> Fixes: 5dc7a8b21144 ("bpftool, selftests/bpf: Embed object file inside skeleton")
> Signed-off-by: YueHaibing <yuehaibing@huawei.com>
> ---
>   tools/bpf/bpftool/gen.c | 3 ++-
>   1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/tools/bpf/bpftool/gen.c b/tools/bpf/bpftool/gen.c
> index 10de76b296ba..35f62273cdbd 100644
> --- a/tools/bpf/bpftool/gen.c
> +++ b/tools/bpf/bpftool/gen.c
> @@ -305,8 +305,9 @@ static int do_skeleton(int argc, char **argv)
>   	opts.object_name = obj_name;
>   	obj = bpf_object__open_mem(obj_data, file_sz, &opts);
>   	if (IS_ERR(obj)) {
> +		err = PTR_ERR(obj);
> +		p_err("failed to open BPF object file: %ld", err);
>   		obj = NULL;
> -		p_err("failed to open BPF object file: %ld", PTR_ERR(obj));
>   		goto out;

Instead of just the error number, could we dump something useful to the user here
via libbpf_strerror() given you touch this line? Also, I think the convention in
do_skeleton() is to just return {0,-1} given this is propagated as return code
for bpftool.

>   	}
>   
> 

