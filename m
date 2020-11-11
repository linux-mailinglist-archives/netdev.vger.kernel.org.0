Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C87392AF3FB
	for <lists+netdev@lfdr.de>; Wed, 11 Nov 2020 15:43:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727321AbgKKOns (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Nov 2020 09:43:48 -0500
Received: from mx2.suse.de ([195.135.220.15]:43206 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727266AbgKKOns (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 11 Nov 2020 09:43:48 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id DBBE8ABD6;
        Wed, 11 Nov 2020 14:43:45 +0000 (UTC)
Subject: Re: [PATCH v3 bpf] tools: bpftool: Add missing close before bpftool
 net attach exit
To:     Wang Hai <wanghai38@huawei.com>, john.fastabend@gmail.com,
        quentin@isovalent.com
Cc:     ast@kernel.org, daniel@iogearbox.net, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com, andrii@kernel.org,
        kpsingh@chromium.org, toke@redhat.com, danieltimlee@gmail.com,
        bpf@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20201111135425.56533-1-wanghai38@huawei.com>
From:   Michal Rostecki <mrostecki@opensuse.org>
Message-ID: <60498580-ad5f-da24-5792-897be2290b9d@opensuse.org>
Date:   Wed, 11 Nov 2020 15:43:44 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <20201111135425.56533-1-wanghai38@huawei.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
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
> +
> +cleanup:
> +	close(progfd);
> +	return err;
>   }
>   
>   static int do_detach(int argc, char **argv)
> 

LGTM, thanks!

Reviewed-By: Michal Rostecki <mrostecki@opensuse.org>
