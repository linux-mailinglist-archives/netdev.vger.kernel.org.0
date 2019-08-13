Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AF8D88BFC9
	for <lists+netdev@lfdr.de>; Tue, 13 Aug 2019 19:42:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727851AbfHMRmB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Aug 2019 13:42:01 -0400
Received: from smtp8.emailarray.com ([65.39.216.67]:29123 "EHLO
        smtp8.emailarray.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727483AbfHMRmB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Aug 2019 13:42:01 -0400
Received: (qmail 31454 invoked by uid 89); 13 Aug 2019 17:42:00 -0000
Received: from unknown (HELO ?172.20.41.143?) (amxlbW9uQGZsdWdzdmFtcC5jb21AMTk5LjIwMS42NC4xMzc=) (POLARISLOCAL)  
  by smtp8.emailarray.com with (AES256-GCM-SHA384 encrypted) SMTP; 13 Aug 2019 17:42:00 -0000
From:   "Jonathan Lemon" <jlemon@flugsvamp.com>
To:     "Ivan Khoronzhuk" <ivan.khoronzhuk@linaro.org>
Cc:     magnus.karlsson@intel.com, bjorn.topel@intel.com,
        davem@davemloft.net, hawk@kernel.org, john.fastabend@gmail.com,
        jakub.kicinski@netronome.com, daniel@iogearbox.net,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        xdp-newbies@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH bpf-next 3/3] samples: bpf: syscal_nrs: use mmap2 if
 defined
Date:   Tue, 13 Aug 2019 10:41:54 -0700
X-Mailer: MailMate (1.12.5r5635)
Message-ID: <036BCF4A-53D6-4000-BBDE-07C04B8B23FA@flugsvamp.com>
In-Reply-To: <20190813102318.5521-4-ivan.khoronzhuk@linaro.org>
References: <20190813102318.5521-1-ivan.khoronzhuk@linaro.org>
 <20190813102318.5521-4-ivan.khoronzhuk@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 13 Aug 2019, at 3:23, Ivan Khoronzhuk wrote:

> For arm32 xdp sockets mmap2 is preferred, so use it if it's defined.
>
> Signed-off-by: Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>

Doesn't this change the application API?
-- 
Jonathan


> ---
>  samples/bpf/syscall_nrs.c  |  5 +++++
>  samples/bpf/tracex5_kern.c | 11 +++++++++++
>  2 files changed, 16 insertions(+)
>
> diff --git a/samples/bpf/syscall_nrs.c b/samples/bpf/syscall_nrs.c
> index 516e255cbe8f..2dec94238350 100644
> --- a/samples/bpf/syscall_nrs.c
> +++ b/samples/bpf/syscall_nrs.c
> @@ -9,5 +9,10 @@ void syscall_defines(void)
>  	COMMENT("Linux system call numbers.");
>  	SYSNR(__NR_write);
>  	SYSNR(__NR_read);
> +#ifdef __NR_mmap2
> +	SYSNR(__NR_mmap2);
> +#else
>  	SYSNR(__NR_mmap);
> +#endif
> +
>  }
> diff --git a/samples/bpf/tracex5_kern.c b/samples/bpf/tracex5_kern.c
> index f57f4e1ea1ec..300350ad299a 100644
> --- a/samples/bpf/tracex5_kern.c
> +++ b/samples/bpf/tracex5_kern.c
> @@ -68,12 +68,23 @@ PROG(SYS__NR_read)(struct pt_regs *ctx)
>  	return 0;
>  }
>
> +#ifdef __NR_mmap2
> +PROG(SYS__NR_mmap2)(struct pt_regs *ctx)
> +{
> +	char fmt[] = "mmap2\n";
> +
> +	bpf_trace_printk(fmt, sizeof(fmt));
> +	return 0;
> +}
> +#else
>  PROG(SYS__NR_mmap)(struct pt_regs *ctx)
>  {
>  	char fmt[] = "mmap\n";
> +
>  	bpf_trace_printk(fmt, sizeof(fmt));
>  	return 0;
>  }
> +#endif
>
>  char _license[] SEC("license") = "GPL";
>  u32 _version SEC("version") = LINUX_VERSION_CODE;
> -- 
> 2.17.1
