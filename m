Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3A57594FB5
	for <lists+netdev@lfdr.de>; Mon, 19 Aug 2019 23:17:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728602AbfHSVR1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Aug 2019 17:17:27 -0400
Received: from smtp5.emailarray.com ([65.39.216.39]:15011 "EHLO
        smtp5.emailarray.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728594AbfHSVR0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Aug 2019 17:17:26 -0400
Received: (qmail 35079 invoked by uid 89); 19 Aug 2019 21:17:25 -0000
Received: from unknown (HELO ?172.20.53.208?) (amxlbW9uQGZsdWdzdmFtcC5jb21AMTk5LjIwMS42NC4xMzk=) (POLARISLOCAL)  
  by smtp5.emailarray.com with (AES256-GCM-SHA384 encrypted) SMTP; 19 Aug 2019 21:17:25 -0000
From:   "Jonathan Lemon" <jlemon@flugsvamp.com>
To:     "Ivan Khoronzhuk" <ivan.khoronzhuk@linaro.org>
Cc:     magnus.karlsson@intel.com, bjorn.topel@intel.com,
        davem@davemloft.net, hawk@kernel.org, john.fastabend@gmail.com,
        jakub.kicinski@netronome.com, daniel@iogearbox.net,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        xdp-newbies@vger.kernel.org, linux-kernel@vger.kernel.org,
        yhs@fb.com, andrii.nakryiko@gmail.com
Subject: Re: [PATCH bpf-next v2 3/3] samples: bpf: syscal_nrs: use mmap2 if
 defined
Date:   Mon, 19 Aug 2019 14:17:19 -0700
X-Mailer: MailMate (1.12.5r5635)
Message-ID: <644F885D-101C-4244-BD10-E9B312AA4380@flugsvamp.com>
In-Reply-To: <20190815121356.8848-4-ivan.khoronzhuk@linaro.org>
References: <20190815121356.8848-1-ivan.khoronzhuk@linaro.org>
 <20190815121356.8848-4-ivan.khoronzhuk@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 15 Aug 2019, at 5:13, Ivan Khoronzhuk wrote:

> For arm32 xdp sockets mmap2 is preferred, so use it if it's defined.
> Declaration of __NR_mmap can be skipped and it breaks build.
>
> Signed-off-by: Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>

Acked-by: Jonathan Lemon <jonathan.lemon@gmail.com>


> ---
>  samples/bpf/syscall_nrs.c  |  6 ++++++
>  samples/bpf/tracex5_kern.c | 13 +++++++++++++
>  2 files changed, 19 insertions(+)
>
> diff --git a/samples/bpf/syscall_nrs.c b/samples/bpf/syscall_nrs.c
> index 516e255cbe8f..88f940052450 100644
> --- a/samples/bpf/syscall_nrs.c
> +++ b/samples/bpf/syscall_nrs.c
> @@ -9,5 +9,11 @@ void syscall_defines(void)
>  	COMMENT("Linux system call numbers.");
>  	SYSNR(__NR_write);
>  	SYSNR(__NR_read);
> +#ifdef __NR_mmap2
> +	SYSNR(__NR_mmap2);
> +#endif
> +#ifdef __NR_mmap
>  	SYSNR(__NR_mmap);
> +#endif
> +
>  }
> diff --git a/samples/bpf/tracex5_kern.c b/samples/bpf/tracex5_kern.c
> index f57f4e1ea1ec..35cb0eed3be5 100644
> --- a/samples/bpf/tracex5_kern.c
> +++ b/samples/bpf/tracex5_kern.c
> @@ -68,12 +68,25 @@ PROG(SYS__NR_read)(struct pt_regs *ctx)
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
> +#endif
> +
> +#ifdef __NR_mmap
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
