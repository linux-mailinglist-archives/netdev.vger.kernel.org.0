Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F07F110E59B
	for <lists+netdev@lfdr.de>; Mon,  2 Dec 2019 06:53:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726319AbfLBFxa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Dec 2019 00:53:30 -0500
Received: from ozlabs.org ([203.11.71.1]:56981 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725807AbfLBFxa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 2 Dec 2019 00:53:30 -0500
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 47RDn32QZ8z9sPL;
        Mon,  2 Dec 2019 16:53:26 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ellerman.id.au;
        s=201909; t=1575266008;
        bh=EH+luGXjEilyQ8e+4eAH4LRNqk79yUFe6oQvFYlUr4k=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=noH5xNFoZXpnOmGLtGuWcghVmhFwCLZEThi4IM+78KPiDy/A0K25QrTucZRFgHP4w
         p2UM2USUd7MJu6d/A3e/ccqQDysB0pqm//W3VLWOjSJkms+GcIcpkZBglp3shAkzHi
         RZjxs5MUi7Nr6wZG0CZoxOL4RIqdc2dVDsEY/IGWMv0fCVY89W6dj1rFiZxl2I2Ypr
         f1S3RlnKxSPmoNNdJ0AicXhAYf/uqa2zcQMFULONaZNMVJthAQMinzzwXbfXBu51PT
         Dlux5u8JToEHyTEfhuOlQpqbXMouCkWZi+nWI+na3hSy6B9D1f6/pFDHTJb5DjlUoB
         k0lXg7QDgxh0A==
From:   Michael Ellerman <mpe@ellerman.id.au>
To:     Aurelien Jarno <aurelien@aurel32.net>, linux-kernel@vger.kernel.org
Cc:     linuxppc-dev@lists.ozlabs.org, debian-kernel@lists.debian.org,
        Aurelien Jarno <aurelien@aurel32.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        "open list\:BPF \(Safe dynamic programs and tools\)" 
        <netdev@vger.kernel.org>,
        "open list\:BPF \(Safe dynamic programs and tools\)" 
        <bpf@vger.kernel.org>
Subject: Re: [PATCH] libbpf: fix readelf output parsing on powerpc with recent binutils
In-Reply-To: <20191201195728.4161537-1-aurelien@aurel32.net>
References: <20191201195728.4161537-1-aurelien@aurel32.net>
Date:   Mon, 02 Dec 2019 16:53:26 +1100
Message-ID: <87zhgbe0ix.fsf@mpe.ellerman.id.au>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Aurelien Jarno <aurelien@aurel32.net> writes:
> On powerpc with recent versions of binutils, readelf outputs an extra
> field when dumping the symbols of an object file. For example:
>
>     35: 0000000000000838    96 FUNC    LOCAL  DEFAULT [<localentry>: 8]     1 btf_is_struct
>
> The extra "[<localentry>: 8]" prevents the GLOBAL_SYM_COUNT variable to
> be computed correctly and causes the checkabi target to fail.
>
> Fix that by looking for the symbol name in the last field instead of the
> 8th one. This way it should also cope with future extra fields.
>
> Signed-off-by: Aurelien Jarno <aurelien@aurel32.net>
> ---
>  tools/lib/bpf/Makefile | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)

Thanks for fixing that, it's been on my very long list of test failures
for a while.

Tested-by: Michael Ellerman <mpe@ellerman.id.au>

cheers

> diff --git a/tools/lib/bpf/Makefile b/tools/lib/bpf/Makefile
> index 99425d0be6ff..333900cf3f4f 100644
> --- a/tools/lib/bpf/Makefile
> +++ b/tools/lib/bpf/Makefile
> @@ -147,7 +147,7 @@ TAGS_PROG := $(if $(shell which etags 2>/dev/null),etags,ctags)
>  
>  GLOBAL_SYM_COUNT = $(shell readelf -s --wide $(BPF_IN_SHARED) | \
>  			   cut -d "@" -f1 | sed 's/_v[0-9]_[0-9]_[0-9].*//' | \
> -			   awk '/GLOBAL/ && /DEFAULT/ && !/UND/ {print $$8}' | \
> +			   awk '/GLOBAL/ && /DEFAULT/ && !/UND/ {print $$NF}' | \
>  			   sort -u | wc -l)
>  VERSIONED_SYM_COUNT = $(shell readelf -s --wide $(OUTPUT)libbpf.so | \
>  			      grep -Eo '[^ ]+@LIBBPF_' | cut -d@ -f1 | sort -u | wc -l)
> @@ -216,7 +216,7 @@ check_abi: $(OUTPUT)libbpf.so
>  		     "versioned in $(VERSION_SCRIPT)." >&2;		 \
>  		readelf -s --wide $(OUTPUT)libbpf-in.o |		 \
>  		    cut -d "@" -f1 | sed 's/_v[0-9]_[0-9]_[0-9].*//' |	 \
> -		    awk '/GLOBAL/ && /DEFAULT/ && !/UND/ {print $$8}'|   \
> +		    awk '/GLOBAL/ && /DEFAULT/ && !/UND/ {print $$NF}'|  \
>  		    sort -u > $(OUTPUT)libbpf_global_syms.tmp;		 \
>  		readelf -s --wide $(OUTPUT)libbpf.so |			 \
>  		    grep -Eo '[^ ]+@LIBBPF_' | cut -d@ -f1 |		 \
> -- 
> 2.24.0
