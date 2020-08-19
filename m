Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1FADA24A503
	for <lists+netdev@lfdr.de>; Wed, 19 Aug 2020 19:36:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726640AbgHSRgi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Aug 2020 13:36:38 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:42791 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725939AbgHSRgf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Aug 2020 13:36:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1597858593;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=oVwS6fO0eqv/szYL1XRxdlPLXVP1y/v8xeaVC13ns4g=;
        b=jH9YZKUn6UOF6YJkBEMI8/w0GF82nvGkGno4gQoIIpu6beF/uiSl6MaFV7WozAPmD0oTpZ
        EKqrJeku/it7nDQpqFcrnscMdmO1+hyHkc6wTX5t/Phr2uhEVZj83kFe4KT7Id0kHCA4bn
        pIQBG917HvqyDtfJjxwt1PsOEz81QAs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-437-tbPqt1txMXGcm8ad9xpa_Q-1; Wed, 19 Aug 2020 13:36:29 -0400
X-MC-Unique: tbPqt1txMXGcm8ad9xpa_Q-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0A4F351B2;
        Wed, 19 Aug 2020 17:36:28 +0000 (UTC)
Received: from krava (unknown [10.40.192.44])
        by smtp.corp.redhat.com (Postfix) with SMTP id 6B4BD7DFDD;
        Wed, 19 Aug 2020 17:36:19 +0000 (UTC)
Date:   Wed, 19 Aug 2020 19:36:18 +0200
From:   Jiri Olsa <jolsa@redhat.com>
To:     Yonghong Song <yhs@fb.com>
Cc:     Jiri Olsa <jolsa@kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Mark Wielaard <mjw@redhat.com>,
        Nick Clifton <nickc@redhat.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Nick Desaulniers <ndesaulniers@google.com>
Subject: Re: [PATCH bpf-next] tools/resolve_btfids: Fix sections with wrong
 alignment
Message-ID: <20200819173618.GH177896@krava>
References: <20200819092342.259004-1-jolsa@kernel.org>
 <254246ed-1b76-c435-a7bd-0783a29094d9@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <254246ed-1b76-c435-a7bd-0783a29094d9@fb.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 19, 2020 at 08:31:51AM -0700, Yonghong Song wrote:
> 
> 
> On 8/19/20 2:23 AM, Jiri Olsa wrote:
> > The data of compressed section should be aligned to 4
> > (for 32bit) or 8 (for 64 bit) bytes.
> > 
> > The binutils ld sets sh_addralign to 1, which makes libelf
> > fail with misaligned section error during the update as
> > reported by Jesper:
> > 
> >     FAILED elf_update(WRITE): invalid section alignment
> > 
> > While waiting for ld fix, we can fix compressed sections
> > sh_addralign value manually.
> > 
> > Adding warning in -vv mode when the fix is triggered:
> > 
> >    $ ./tools/bpf/resolve_btfids/resolve_btfids -vv vmlinux
> >    ...
> >    section(36) .comment, size 44, link 0, flags 30, type=1
> >    section(37) .debug_aranges, size 45684, link 0, flags 800, type=1
> >     - fixing wrong alignment sh_addralign 16, expected 8
> >    section(38) .debug_info, size 129104957, link 0, flags 800, type=1
> >     - fixing wrong alignment sh_addralign 1, expected 8
> >    section(39) .debug_abbrev, size 1152583, link 0, flags 800, type=1
> >     - fixing wrong alignment sh_addralign 1, expected 8
> >    section(40) .debug_line, size 7374522, link 0, flags 800, type=1
> >     - fixing wrong alignment sh_addralign 1, expected 8
> >    section(41) .debug_frame, size 702463, link 0, flags 800, type=1
> >    section(42) .debug_str, size 1017571, link 0, flags 830, type=1
> >     - fixing wrong alignment sh_addralign 1, expected 8
> >    section(43) .debug_loc, size 3019453, link 0, flags 800, type=1
> >     - fixing wrong alignment sh_addralign 1, expected 8
> >    section(44) .debug_ranges, size 1744583, link 0, flags 800, type=1
> >     - fixing wrong alignment sh_addralign 16, expected 8
> >    section(45) .symtab, size 2955888, link 46, flags 0, type=2
> >    section(46) .strtab, size 2613072, link 0, flags 0, type=3
> >    ...
> >    update ok for vmlinux
> > 
> > Another workaround is to disable compressed debug info data
> > CONFIG_DEBUG_INFO_COMPRESSED kernel option.
> 
> So CONFIG_DEBUG_INFO_COMPRESSED is required to reproduce the bug, right?

correct

> 
> I turned on CONFIG_DEBUG_INFO_COMPRESSED in my config and got a bunch of
> build failures.
> 
> ld: drivers/crypto/virtio/virtio_crypto_algs.o: unable to initialize
> decompress status for section .debug_info
> ld: drivers/crypto/virtio/virtio_crypto_algs.o: unable to initialize
> decompress status for section .debug_info
> ld: drivers/crypto/virtio/virtio_crypto_algs.o: unable to initialize
> decompress status for section .debug_info
> ld: drivers/crypto/virtio/virtio_crypto_algs.o: unable to initialize
> decompress status for section .debug_info
> drivers/crypto/virtio/virtio_crypto_algs.o: file not recognized: File format
> not recognized
> 
> ld: net/llc/llc_core.o: unable to initialize decompress status for section
> .debug_info
> ld: net/llc/llc_core.o: unable to initialize decompress status for section
> .debug_info
> ld: net/llc/llc_core.o: unable to initialize decompress status for section
> .debug_info
> ld: net/llc/llc_core.o: unable to initialize decompress status for section
> .debug_info
> net/llc/llc_core.o: file not recognized: File format not recognized
> 
> ...
> 
> The 'ld' in my system:
> 
> $ ld -V
> GNU ld version 2.30-74.el8
>   Supported emulations:
>    elf_x86_64
>    elf32_x86_64
>    elf_i386
>    elf_iamcu
>    i386linux
>    elf_l1om
>    elf_k1om
>    i386pep
>    i386pe
> $
> 
> Do you know what is the issue here?

mine's: GNU ld version 2.32-31.fc31

there's version info in commit:
  10e68b02c861 Makefile: support compressed debug info

  Compress the debug information using zlib.  Requires GCC 5.0+ or Clang
  5.0+, binutils 2.26+, and zlib.

cc-ing Nick Desaulniers, author of that patch.. any idea about the error above?

thanks,
jirka

