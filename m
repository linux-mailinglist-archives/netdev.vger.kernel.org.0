Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 045494C9048
	for <lists+netdev@lfdr.de>; Tue,  1 Mar 2022 17:28:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234303AbiCAQ3P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Mar 2022 11:29:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229809AbiCAQ3O (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Mar 2022 11:29:14 -0500
Received: from www62.your-server.de (www62.your-server.de [213.133.104.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D3FAFDA;
        Tue,  1 Mar 2022 08:28:32 -0800 (PST)
Received: from sslproxy01.your-server.de ([78.46.139.224])
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1nP5MK-000DX3-8e; Tue, 01 Mar 2022 17:28:20 +0100
Received: from [85.1.206.226] (helo=linux.home)
        by sslproxy01.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1nP5MJ-000JV6-UK; Tue, 01 Mar 2022 17:28:19 +0100
Subject: Re: [PATCH] bpf: cgroup: remove WARN_ON at bpf_cgroup_link_release
To:     Dongliang Mu <dzm91@hust.edu.cn>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>
Cc:     Dongliang Mu <mudongliangabcd@gmail.com>,
        syzkaller <syzkaller@googlegroups.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20220227134009.1298488-1-dzm91@hust.edu.cn>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <d4bed569-d448-8b59-0774-c036e4c9abe9@iogearbox.net>
Date:   Tue, 1 Mar 2022 17:28:19 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20220227134009.1298488-1-dzm91@hust.edu.cn>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.5/26468/Tue Mar  1 10:31:38 2022)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/27/22 2:40 PM, Dongliang Mu wrote:
> From: Dongliang Mu <mudongliangabcd@gmail.com>
> 
> When syzkaller injects fault into memory allocation at
> bpf_prog_array_alloc, the kernel encounters a memory failure and
> returns non-zero, thus leading to one WARN_ON at
> bpf_cgroup_link_release. The stack trace is as follows:
> 
>   __kmalloc+0x7e/0x3d0
>   bpf_prog_array_alloc+0x4f/0x60
>   compute_effective_progs+0x132/0x580
>   ? __sanitizer_cov_trace_pc+0x1a/0x40
>   update_effective_progs+0x5e/0x260
>   __cgroup_bpf_detach+0x293/0x760
>   bpf_cgroup_link_release+0xad/0x400
>   bpf_link_free+0xca/0x190
>   bpf_link_put+0x161/0x1b0
>   bpf_link_release+0x33/0x40
>   __fput+0x286/0x9f0
> 
> Fix this by removing the WARN_ON for __cgroup_bpf_detach.
> 
> Reported-by: syzkaller <syzkaller@googlegroups.com>
> Signed-off-by: Dongliang Mu <mudongliangabcd@gmail.com>
> ---
>   kernel/bpf/cgroup.c | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/kernel/bpf/cgroup.c b/kernel/bpf/cgroup.c
> index 514b4681a90a..fdbdcee6c9fa 100644
> --- a/kernel/bpf/cgroup.c
> +++ b/kernel/bpf/cgroup.c
> @@ -896,8 +896,8 @@ static void bpf_cgroup_link_release(struct bpf_link *link)
>   		return;
>   	}
>   
> -	WARN_ON(__cgroup_bpf_detach(cg_link->cgroup, NULL, cg_link,
> -				    cg_link->type));
> +	__cgroup_bpf_detach(cg_link->cgroup, NULL, cg_link,
> +				    cg_link->type);

"Fixing" by removing WARN_ON is just papering over the issue which in this case as
mentioned is allocation failure on detach/teardown when allocating and recomputing
effective prog arrays..

>   	cg = cg_link->cgroup;
>   	cg_link->cgroup = NULL;
> 

