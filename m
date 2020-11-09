Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 15AB52AB56A
	for <lists+netdev@lfdr.de>; Mon,  9 Nov 2020 11:51:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729174AbgKIKvu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Nov 2020 05:51:50 -0500
Received: from mx2.suse.de ([195.135.220.15]:44468 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726423AbgKIKvt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 9 Nov 2020 05:51:49 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 4595EABF4;
        Mon,  9 Nov 2020 10:51:48 +0000 (UTC)
Subject: Re: [PATCH bpf] tools: bpftool: Add missing close before bpftool net
 attach exit
To:     Wang Hai <wanghai38@huawei.com>, ast@kernel.org,
        daniel@iogearbox.net, kafai@fb.com, songliubraving@fb.com,
        yhs@fb.com, andrii@kernel.org, john.fastabend@gmail.com,
        kpsingh@chromium.org, toke@redhat.com, quentin@isovalent.com,
        danieltimlee@gmail.com
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20201109070410.65833-1-wanghai38@huawei.com>
From:   Michal Rostecki <mrostecki@opensuse.org>
Message-ID: <3b07c1a3-d5cf-dfb4-9184-00fca6c7d3b1@opensuse.org>
Date:   Mon, 9 Nov 2020 11:51:47 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <20201109070410.65833-1-wanghai38@huawei.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/9/20 8:04 AM, Wang Hai wrote:
> progfd is created by prog_parse_fd(), before 'bpftool net attach' exit,
> it should be closed.
> 
> Fixes: 04949ccc273e ("tools: bpftool: add net attach command to attach XDP on interface")
> Signed-off-by: Wang Hai <wanghai38@huawei.com>
> ---
>   tools/bpf/bpftool/net.c | 2 ++
>   1 file changed, 2 insertions(+)
> 
> diff --git a/tools/bpf/bpftool/net.c b/tools/bpf/bpftool/net.c
> index 910e7bac6e9e..3e9b40e64fb0 100644
> --- a/tools/bpf/bpftool/net.c
> +++ b/tools/bpf/bpftool/net.c
> @@ -600,12 +600,14 @@ static int do_attach(int argc, char **argv)
>   	if (err < 0) {
>   		p_err("interface %s attach failed: %s",
>   		      attach_type_strings[attach_type], strerror(-err));
> +		close(progfd);
>   		return err;
>   	}
>   
>   	if (json_output)
>   		jsonw_null(json_wtr);
>   
> +	close(progfd);
>   	return 0;
>   }
>   

Nit - wouldn't it be better to create a `cleanup`/`out` section before 
return and use goto, to avoid copying the `close` call?
