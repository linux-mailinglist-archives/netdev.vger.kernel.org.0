Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 51F7924A498
	for <lists+netdev@lfdr.de>; Wed, 19 Aug 2020 19:03:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726825AbgHSRD3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Aug 2020 13:03:29 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:44973 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726793AbgHSRDU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Aug 2020 13:03:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1597856598;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=9GJWCG839lOHyaKwmWp7My5quoa4YMXTRSk1ZL7SJ6w=;
        b=IGIfaKMyp7bLyhq2ouvEsYePL4fwFRJH/NJ4amJwao1rF8Fq/YrgW2He1ChTvB5xl+k+cy
        aTTBAEiYV4nIS8tiITSgyNDSjDsF7WSD/7rv3Kek9XkiKpS0hFXFWmZjjuZIkbOQRk7hAI
        CyC/UH90vZTNk0r/O7fPqtCpw2gbq+E=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-169-JBw8427CPnGYl4GuhJAUJw-1; Wed, 19 Aug 2020 13:03:07 -0400
X-MC-Unique: JBw8427CPnGYl4GuhJAUJw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D7E43801AAF;
        Wed, 19 Aug 2020 17:03:05 +0000 (UTC)
Received: from carbon (unknown [10.40.208.64])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4D28F7BE98;
        Wed, 19 Aug 2020 17:02:54 +0000 (UTC)
Date:   Wed, 19 Aug 2020 19:02:53 +0200
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Jiri Olsa <jolsa@kernel.org>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Mark Wielaard <mjw@redhat.com>,
        Nick Clifton <nickc@redhat.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>, brouer@redhat.com
Subject: Re: [PATCH bpf-next] tools/resolve_btfids: Fix sections with wrong
 alignment
Message-ID: <20200819190253.2c795745@carbon>
In-Reply-To: <20200819092342.259004-1-jolsa@kernel.org>
References: <20200819092342.259004-1-jolsa@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 19 Aug 2020 11:23:42 +0200 Jiri Olsa <jolsa@kernel.org> wrote:

> The data of compressed section should be aligned to 4
> (for 32bit) or 8 (for 64 bit) bytes.
> 
> The binutils ld sets sh_addralign to 1, which makes libelf
> fail with misaligned section error during the update as
> reported by Jesper:
> 
>    FAILED elf_update(WRITE): invalid section alignment
> 
> While waiting for ld fix, we can fix compressed sections
> sh_addralign value manually.
> 
> Adding warning in -vv mode when the fix is triggered:
> 
>   $ ./tools/bpf/resolve_btfids/resolve_btfids -vv vmlinux
>   ...
>   section(36) .comment, size 44, link 0, flags 30, type=1
>   section(37) .debug_aranges, size 45684, link 0, flags 800, type=1
>    - fixing wrong alignment sh_addralign 16, expected 8
>   section(38) .debug_info, size 129104957, link 0, flags 800, type=1
>    - fixing wrong alignment sh_addralign 1, expected 8
>   section(39) .debug_abbrev, size 1152583, link 0, flags 800, type=1
>    - fixing wrong alignment sh_addralign 1, expected 8
>   section(40) .debug_line, size 7374522, link 0, flags 800, type=1
>    - fixing wrong alignment sh_addralign 1, expected 8
>   section(41) .debug_frame, size 702463, link 0, flags 800, type=1
>   section(42) .debug_str, size 1017571, link 0, flags 830, type=1
>    - fixing wrong alignment sh_addralign 1, expected 8
>   section(43) .debug_loc, size 3019453, link 0, flags 800, type=1
>    - fixing wrong alignment sh_addralign 1, expected 8
>   section(44) .debug_ranges, size 1744583, link 0, flags 800, type=1
>    - fixing wrong alignment sh_addralign 16, expected 8
>   section(45) .symtab, size 2955888, link 46, flags 0, type=2
>   section(46) .strtab, size 2613072, link 0, flags 0, type=3
>   ...
>   update ok for vmlinux

I also works for me:

[...]
section(37) .debug_aranges, size 45684, link 0, flags 800, type=1
 - fixing wrong alignment sh_addralign 16, expected 8
section(38) .debug_info, size 129098181, link 0, flags 800, type=1
 - fixing wrong alignment sh_addralign 1, expected 8
section(39) .debug_abbrev, size 1152583, link 0, flags 800, type=1
 - fixing wrong alignment sh_addralign 1, expected 8
section(40) .debug_line, size 7374522, link 0, flags 800, type=1
 - fixing wrong alignment sh_addralign 1, expected 8
section(41) .debug_frame, size 702463, link 0, flags 800, type=1
section(42) .debug_str, size 1017606, link 0, flags 830, type=1
 - fixing wrong alignment sh_addralign 1, expected 8
section(43) .debug_loc, size 3019453, link 0, flags 800, type=1
 - fixing wrong alignment sh_addralign 1, expected 8
section(44) .debug_ranges, size 1744583, link 0, flags 800, type=1
 - fixing wrong alignment sh_addralign 16, expected 8
section(45) .symtab, size 2955888, link 46, flags 0, type=2
section(46) .strtab, size 2613072, link 0, flags 0, type=3
section(47) .shstrtab, size 525, link 0, flags 0, type=3
[...]
update ok for vmlinux.err.bak


> 
> Another workaround is to disable compressed debug info data
> CONFIG_DEBUG_INFO_COMPRESSED kernel option.
> 
> Fixes: fbbb68de80a4 ("bpf: Add resolve_btfids tool to resolve BTF IDs in ELF object")
> Cc: Mark Wielaard <mjw@redhat.com>
> Cc: Nick Clifton <nickc@redhat.com>
> Reported-by: Jesper Dangaard Brouer <brouer@redhat.com>
> Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> ---

Thanks for fixing this!

Acked-by: Jesper Dangaard Brouer <brouer@redhat.com>

-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

