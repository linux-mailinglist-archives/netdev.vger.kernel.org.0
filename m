Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B74A5C0590
	for <lists+netdev@lfdr.de>; Fri, 27 Sep 2019 14:48:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727608AbfI0MsX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Sep 2019 08:48:23 -0400
Received: from www62.your-server.de ([213.133.104.62]:44366 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726295AbfI0MsW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Sep 2019 08:48:22 -0400
Received: from [2a02:120b:2c12:c120:71a0:62dd:894c:fd0e] (helo=localhost)
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1iDpfZ-0004tR-24; Fri, 27 Sep 2019 14:48:21 +0200
Date:   Fri, 27 Sep 2019 14:48:20 +0200
From:   Daniel Borkmann <daniel@iogearbox.net>
To:     Yonghong Song <yhs@fb.com>
Cc:     Andrii Nakryiko <andriin@fb.com>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, Alexei Starovoitov <ast@fb.com>,
        kernel-team@fb.com
Subject: Re: [PATCH bpf] libbpf: add macro __BUILD_STATIC_LIBBPF__ to guard
 .symver
Message-ID: <20190927124820.GB22184@pc-66.home>
References: <20190926230204.1911391-1-yhs@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190926230204.1911391-1-yhs@fb.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.101.4/25585/Fri Sep 27 10:25:33 2019)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 26, 2019 at 04:02:04PM -0700, Yonghong Song wrote:
> bcc uses libbpf repo as a submodule. It brings in libbpf source
> code and builds everything together to produce shared libraries.
> With latest libbpf, I got the following errors:
>   /bin/ld: libbcc_bpf.so.0.10.0: version node not found for symbol xsk_umem__create@LIBBPF_0.0.2
>   /bin/ld: failed to set dynamic section sizes: Bad value
>   collect2: error: ld returned 1 exit status
>   make[2]: *** [src/cc/libbcc_bpf.so.0.10.0] Error 1
> 
> In xsk.c, we have
>   asm(".symver xsk_umem__create_v0_0_2, xsk_umem__create@LIBBPF_0.0.2");
>   asm(".symver xsk_umem__create_v0_0_4, xsk_umem__create@@LIBBPF_0.0.4");
> The linker thinks the built is for LIBBPF but cannot find proper version
> LIBBPF_0.0.2/4, so emit errors.
> 
> I also confirmed that using libbpf.a to produce a shared library also
> has issues:
>   -bash-4.4$ cat t.c
>   extern void *xsk_umem__create;
>   void * test() { return xsk_umem__create; }
>   -bash-4.4$ gcc -c t.c
>   -bash-4.4$ gcc -shared t.o libbpf.a -o t.so
>   /bin/ld: t.so: version node not found for symbol xsk_umem__create@LIBBPF_0.0.2
>   /bin/ld: failed to set dynamic section sizes: Bad value
>   collect2: error: ld returned 1 exit status
>   -bash-4.4$
> 
> To fix the problem, I simply added a macro __BUILD_STATIC_LIBBPF__
> which will prevent issuing .symver assembly codes when enabled.
> The .symver assembly codes are still issued by default.
> This will at least give other libbpf users to build libbpf
> without these versioned symbols.
> 
> I did not touch Makefile to actually use this macro to build
> static library as I want to check whether this is desirable or not.

Isn't there any better way on how we can detect this? Asking users to
pass this macro to the build seems a suboptimal user experience. How
are other libraries solving this given this seems really not specific
to libbpf?

> Signed-off-by: Yonghong Song <yhs@fb.com>
> ---
>  tools/lib/bpf/xsk.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/tools/lib/bpf/xsk.c b/tools/lib/bpf/xsk.c
> index 24fa313524fb..76c12c4c5c70 100644
> --- a/tools/lib/bpf/xsk.c
> +++ b/tools/lib/bpf/xsk.c
> @@ -261,8 +261,11 @@ int xsk_umem__create_v0_0_2(struct xsk_umem **umem_ptr, void *umem_area,
>  	return xsk_umem__create_v0_0_4(umem_ptr, umem_area, size, fill, comp,
>  					&config);
>  }
> +
> +#ifndef __BUILD_STATIC_LIBBPF__
>  asm(".symver xsk_umem__create_v0_0_2, xsk_umem__create@LIBBPF_0.0.2");
>  asm(".symver xsk_umem__create_v0_0_4, xsk_umem__create@@LIBBPF_0.0.4");
> +#endif
>  
>  static int xsk_load_xdp_prog(struct xsk_socket *xsk)
>  {
> -- 
> 2.17.1
> 
