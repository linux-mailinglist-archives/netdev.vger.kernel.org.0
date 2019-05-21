Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3475B253CB
	for <lists+netdev@lfdr.de>; Tue, 21 May 2019 17:22:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728695AbfEUPWa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 May 2019 11:22:30 -0400
Received: from www62.your-server.de ([213.133.104.62]:59412 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728127AbfEUPWa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 May 2019 11:22:30 -0400
Received: from [78.46.172.2] (helo=sslproxy05.your-server.de)
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1hT6ax-0005Vp-Jx; Tue, 21 May 2019 17:22:27 +0200
Received: from [178.197.249.20] (helo=linux.home)
        by sslproxy05.your-server.de with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89)
        (envelope-from <daniel@iogearbox.net>)
        id 1hT6ax-0008sl-E5; Tue, 21 May 2019 17:22:27 +0200
Subject: Re: [PATCH 4/5] samples/bpf: fix tracex5_user build error
To:     Matteo Croce <mcroce@redhat.com>, xdp-newbies@vger.kernel.org,
        bpf@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Alexei Starovoitov <ast@kernel.org>
References: <20190518004639.20648-1-mcroce@redhat.com>
 <20190518004639.20648-4-mcroce@redhat.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <3accecfb-4743-4ac0-1a35-053c25f00e7e@iogearbox.net>
Date:   Tue, 21 May 2019 17:22:26 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.3.0
MIME-Version: 1.0
In-Reply-To: <20190518004639.20648-4-mcroce@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.100.3/25456/Tue May 21 09:56:54 2019)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 05/18/2019 02:46 AM, Matteo Croce wrote:
> Add missing symbols to tools/include/linux/filter.h to fix a build failure:
> 
> make -C samples/bpf/../../tools/lib/bpf/ RM='rm -rf' LDFLAGS= srctree=samples/bpf/../../ O=
>   HOSTCC  samples/bpf/tracex5_user.o
> samples/bpf/tracex5_user.c: In function ‘install_accept_all_seccomp’:
> samples/bpf/tracex5_user.c:17:21: error: array type has incomplete element type ‘struct sock_filter’
>    17 |  struct sock_filter filter[] = {
>       |                     ^~~~~~
> samples/bpf/tracex5_user.c:18:3: warning: implicit declaration of function ‘BPF_STMT’; did you mean ‘BPF_STX’? [-Wimplicit-function-declaration]
>    18 |   BPF_STMT(BPF_RET+BPF_K, SECCOMP_RET_ALLOW),
>       |   ^~~~~~~~
>       |   BPF_STX
> samples/bpf/tracex5_user.c:20:9: error: variable ‘prog’ has initializer but incomplete type
>    20 |  struct sock_fprog prog = {
>       |         ^~~~~~~~~~
> samples/bpf/tracex5_user.c:21:4: error: ‘struct sock_fprog’ has no member named ‘len’
>    21 |   .len = (unsigned short)(sizeof(filter)/sizeof(filter[0])),
>       |    ^~~
> samples/bpf/tracex5_user.c:21:10: warning: excess elements in struct initializer
>    21 |   .len = (unsigned short)(sizeof(filter)/sizeof(filter[0])),
>       |          ^
> samples/bpf/tracex5_user.c:21:10: note: (near initialization for ‘prog’)
> samples/bpf/tracex5_user.c:22:4: error: ‘struct sock_fprog’ has no member named ‘filter’
>    22 |   .filter = filter,
>       |    ^~~~~~
> samples/bpf/tracex5_user.c:22:13: warning: excess elements in struct initializer
>    22 |   .filter = filter,
>       |             ^~~~~~
> samples/bpf/tracex5_user.c:22:13: note: (near initialization for ‘prog’)
> samples/bpf/tracex5_user.c:20:20: error: storage size of ‘prog’ isn’t known
>    20 |  struct sock_fprog prog = {
>       |                    ^~~~
> samples/bpf/tracex5_user.c:20:20: warning: unused variable ‘prog’ [-Wunused-variable]
> samples/bpf/tracex5_user.c:17:21: warning: unused variable ‘filter’ [-Wunused-variable]
>    17 |  struct sock_filter filter[] = {
>       |                     ^~~~~~
> make[2]: *** [scripts/Makefile.host:109: samples/bpf/tracex5_user.o] Error 1
> make[1]: *** [Makefile:1763: samples/bpf/] Error 2
> 
> Signed-off-by: Matteo Croce <mcroce@redhat.com>
> ---
>  tools/include/linux/filter.h | 27 +++++++++++++++++++++++++++
>  1 file changed, 27 insertions(+)
> 
> diff --git a/tools/include/linux/filter.h b/tools/include/linux/filter.h
> index ca28b6ab8db7..6b2ed7eccfa5 100644
> --- a/tools/include/linux/filter.h
> +++ b/tools/include/linux/filter.h
> @@ -7,6 +7,33 @@
>  
>  #include <linux/bpf.h>

This here is also mixing UAPI code below into non-UAPI headers in
tooling infrastructure ..

> +/*
> + *	Try and keep these values and structures similar to BSD, especially
> + *	the BPF code definitions which need to match so you can share filters
> + */
> +
> +struct sock_filter {	/* Filter block */
> +	__u16	code;   /* Actual filter code */
> +	__u8	jt;	/* Jump true */
> +	__u8	jf;	/* Jump false */
> +	__u32	k;      /* Generic multiuse field */
> +};
> +
> +struct sock_fprog {	/* Required for SO_ATTACH_FILTER. */
> +	unsigned short		len;	/* Number of filter blocks */
> +	struct sock_filter __user *filter;
> +};
> +
> +/*
> + * Macros for filter block array initializers.
> + */
> +#ifndef BPF_STMT
> +#define BPF_STMT(code, k) { (unsigned short)(code), 0, 0, k }
> +#endif
> +#ifndef BPF_JUMP
> +#define BPF_JUMP(code, k, jt, jf) { (unsigned short)(code), jt, jf, k }
> +#endif
> +
>  /* ArgX, context and stack frame pointer register positions. Note,
>   * Arg1, Arg2, Arg3, etc are used as argument mappings of function
>   * calls in BPF_CALL instruction.
> 

