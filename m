Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1E03D109644
	for <lists+netdev@lfdr.de>; Tue, 26 Nov 2019 00:11:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727825AbfKYXLw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Nov 2019 18:11:52 -0500
Received: from www62.your-server.de ([213.133.104.62]:40018 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727664AbfKYXLv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Nov 2019 18:11:51 -0500
Received: from sslproxy01.your-server.de ([88.198.220.130])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1iZNWG-0007Xc-Ul; Tue, 26 Nov 2019 00:11:48 +0100
Received: from [178.197.248.11] (helo=pc-9.home)
        by sslproxy01.your-server.de with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89)
        (envelope-from <daniel@iogearbox.net>)
        id 1iZNWG-00010E-Fd; Tue, 26 Nov 2019 00:11:48 +0100
Subject: Re: [PATCH,bpf-next 2/2] samples: bpf: fix syscall_tp due to unused
 syscall
To:     "Daniel T. Lee" <danieltimlee@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org
References: <20191123055151.9990-1-danieltimlee@gmail.com>
 <20191123055151.9990-3-danieltimlee@gmail.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <c9d5d930-f6d8-1f83-4d5d-3b175b86cc8a@iogearbox.net>
Date:   Tue, 26 Nov 2019 00:11:47 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20191123055151.9990-3-danieltimlee@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.101.4/25644/Mon Nov 25 10:54:22 2019)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/23/19 6:51 AM, Daniel T. Lee wrote:
> Currently, open() is called from the user program and it calls the syscall
> 'sys_openat', not the 'sys_open'. This leads to an error of the program
> of user side, due to the fact that the counter maps are zero since no
> function such 'sys_open' is called.
> 
> This commit adds the kernel bpf program which are attached to the
> tracepoint 'sys_enter_openat' and 'sys_enter_openat'.
> 
> Signed-off-by: Daniel T. Lee <danieltimlee@gmail.com>
> ---
>   samples/bpf/syscall_tp_kern.c | 14 ++++++++++++++
>   1 file changed, 14 insertions(+)
> 
> diff --git a/samples/bpf/syscall_tp_kern.c b/samples/bpf/syscall_tp_kern.c
> index 1d78819ffef1..4ea91b1d3e03 100644
> --- a/samples/bpf/syscall_tp_kern.c
> +++ b/samples/bpf/syscall_tp_kern.c
> @@ -51,9 +51,23 @@ int trace_enter_open(struct syscalls_enter_open_args *ctx)
>   	return 0;
>   }
>   
> +SEC("tracepoint/syscalls/sys_enter_openat")
> +int trace_enter_open_at(struct syscalls_enter_open_args *ctx)
> +{
> +	count((void *)&enter_open_map);

Nit: cast to void * not needed, same in below 3 locations.

> +	return 0;
> +}
> +
>   SEC("tracepoint/syscalls/sys_exit_open")
>   int trace_enter_exit(struct syscalls_exit_open_args *ctx)
>   {
>   	count((void *)&exit_open_map);
>   	return 0;
>   }
> +
> +SEC("tracepoint/syscalls/sys_exit_openat")
> +int trace_enter_exit_at(struct syscalls_exit_open_args *ctx)
> +{
> +	count((void *)&exit_open_map);
> +	return 0;
> +}
> 

