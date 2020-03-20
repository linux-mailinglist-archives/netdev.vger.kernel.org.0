Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BF79A18D2CC
	for <lists+netdev@lfdr.de>; Fri, 20 Mar 2020 16:24:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727553AbgCTPYh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Mar 2020 11:24:37 -0400
Received: from www62.your-server.de ([213.133.104.62]:54730 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726847AbgCTPYh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Mar 2020 11:24:37 -0400
Received: from sslproxy06.your-server.de ([78.46.172.3])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1jFJVh-00077o-EM; Fri, 20 Mar 2020 16:24:33 +0100
Received: from [85.7.42.192] (helo=pc-9.home)
        by sslproxy06.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1jFJVh-000RXn-0E; Fri, 20 Mar 2020 16:24:33 +0100
Subject: Re: [PATCH] bpf: explicitly memset the bpf_attr structure
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alexei Starovoitov <ast@kernel.org>
Cc:     Martin KaFai Lau <kafai@fb.com>, Song Liu <songliubraving@fb.com>,
        Yonghong Song <yhs@fb.com>, Andrii Nakryiko <andriin@fb.com>,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        =?UTF-8?Q?Maciej_=c5=bbenczykowski?= <maze@google.com>,
        John Stultz <john.stultz@linaro.org>,
        Alexander Potapenko <glider@google.com>,
        Alistair Delva <adelva@google.com>
References: <20200320094813.GA421650@kroah.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <3bcf52da-0930-a27f-60f9-28a40e639949@iogearbox.net>
Date:   Fri, 20 Mar 2020 16:24:32 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20200320094813.GA421650@kroah.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.2/25757/Fri Mar 20 14:13:59 2020)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/20/20 10:48 AM, Greg Kroah-Hartman wrote:
> For the bpf syscall, we are relying on the compiler to properly zero out
> the bpf_attr union that we copy userspace data into.  Unfortunately that
> doesn't always work properly, padding and other oddities might not be
> correctly zeroed, and in some tests odd things have been found when the
> stack is pre-initialized to other values.
> 
> Fix this by explicitly memsetting the structure to 0 before using it.
> 
> Reported-by: Maciej Żenczykowski <maze@google.com>
> Reported-by: John Stultz <john.stultz@linaro.org>
> Reported-by: Alexander Potapenko <glider@google.com>
> Reported-by: Alistair Delva <adelva@google.com>
> Cc: stable <stable@vger.kernel.org>
> Link: https://android-review.googlesource.com/c/kernel/common/+/1235490
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> ---
>   kernel/bpf/syscall.c | 3 ++-
>   1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
> index a91ad518c050..a4b1de8ea409 100644
> --- a/kernel/bpf/syscall.c
> +++ b/kernel/bpf/syscall.c
> @@ -3354,7 +3354,7 @@ static int bpf_map_do_batch(const union bpf_attr *attr,
>   
>   SYSCALL_DEFINE3(bpf, int, cmd, union bpf_attr __user *, uattr, unsigned int, size)
>   {
> -	union bpf_attr attr = {};
> +	union bpf_attr attr;
>   	int err;
>   
>   	if (sysctl_unprivileged_bpf_disabled && !capable(CAP_SYS_ADMIN))
> @@ -3366,6 +3366,7 @@ SYSCALL_DEFINE3(bpf, int, cmd, union bpf_attr __user *, uattr, unsigned int, siz
>   	size = min_t(u32, size, sizeof(attr));
>   
>   	/* copy attributes from user space, may be less than sizeof(bpf_attr) */
> +	memset(&attr, 0, sizeof(attr));

Thanks for the fix, there are a few more of these places. We would also need
to cover:

- bpf_prog_get_info_by_fd()
- bpf_map_get_info_by_fd()
- btf_get_info_by_fd()

Please add these as well to your fix.

>   	if (copy_from_user(&attr, uattr, size) != 0)
>   		return -EFAULT;
>   
> 
> base-commit: 6c90b86a745a446717fdf408c4a8a4631a5e8ee3
> 

