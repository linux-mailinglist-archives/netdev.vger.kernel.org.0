Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D2DF2AFA4C
	for <lists+netdev@lfdr.de>; Wed, 11 Nov 2020 22:24:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726466AbgKKVY0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Nov 2020 16:24:26 -0500
Received: from www62.your-server.de ([213.133.104.62]:39124 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725933AbgKKVYY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Nov 2020 16:24:24 -0500
Received: from sslproxy05.your-server.de ([78.46.172.2])
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1kcxbB-0006uo-5g; Wed, 11 Nov 2020 22:24:13 +0100
Received: from [85.7.101.30] (helo=pc-9.home)
        by sslproxy05.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1kcxbA-000Xzz-S4; Wed, 11 Nov 2020 22:24:12 +0100
Subject: Re: [PATCH v3 bpf] tools: bpftool: Add missing close before bpftool
 net attach exit
To:     Wang Hai <wanghai38@huawei.com>, john.fastabend@gmail.com,
        quentin@isovalent.com, mrostecki@opensuse.org
Cc:     ast@kernel.org, kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        andrii@kernel.org, kpsingh@chromium.org, toke@redhat.com,
        danieltimlee@gmail.com, bpf@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20201111135425.56533-1-wanghai38@huawei.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <6a589c0b-e2fb-5766-542b-62f40b16253a@iogearbox.net>
Date:   Wed, 11 Nov 2020 22:24:12 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20201111135425.56533-1-wanghai38@huawei.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.4/25985/Wed Nov 11 14:18:01 2020)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/11/20 2:54 PM, Wang Hai wrote:
> progfd is created by prog_parse_fd(), before 'bpftool net attach' exit,
> it should be closed.
> 
> Fixes: 04949ccc273e ("tools: bpftool: add net attach command to attach XDP on interface")
> Signed-off-by: Wang Hai <wanghai38@huawei.com>
> ---
> v2->v3: add 'err = 0' before successful return
> v1->v2: use cleanup tag instead of repeated closes
>   tools/bpf/bpftool/net.c | 18 +++++++++++-------
>   1 file changed, 11 insertions(+), 7 deletions(-)
> 
> diff --git a/tools/bpf/bpftool/net.c b/tools/bpf/bpftool/net.c
> index 910e7bac6e9e..f927392271cc 100644
> --- a/tools/bpf/bpftool/net.c
> +++ b/tools/bpf/bpftool/net.c
> @@ -578,8 +578,8 @@ static int do_attach(int argc, char **argv)
>   
>   	ifindex = net_parse_dev(&argc, &argv);
>   	if (ifindex < 1) {
> -		close(progfd);
> -		return -EINVAL;
> +		err = -EINVAL;
> +		goto cleanup;
>   	}
>   
>   	if (argc) {
> @@ -587,8 +587,8 @@ static int do_attach(int argc, char **argv)
>   			overwrite = true;
>   		} else {
>   			p_err("expected 'overwrite', got: '%s'?", *argv);
> -			close(progfd);
> -			return -EINVAL;
> +			err = -EINVAL;
> +			goto cleanup;
>   		}
>   	}
>   
> @@ -597,16 +597,20 @@ static int do_attach(int argc, char **argv)
>   		err = do_attach_detach_xdp(progfd, attach_type, ifindex,
>   					   overwrite);
>   
> -	if (err < 0) {
> +	if (err) {
>   		p_err("interface %s attach failed: %s",
>   		      attach_type_strings[attach_type], strerror(-err));
> -		return err;
> +		goto cleanup;
>   	}
>   
>   	if (json_output)
>   		jsonw_null(json_wtr);
>   
> -	return 0;
> +	err = 0;

Why is the 'err = 0' still needed here given we test for err != 0 earlier?
Would just remove it, otherwise looks good.

> +cleanup:
> +	close(progfd);
> +	return err;
>   }
>   
>   static int do_detach(int argc, char **argv)
> 

