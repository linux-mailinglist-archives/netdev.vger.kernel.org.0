Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 90EEA5ADED
	for <lists+netdev@lfdr.de>; Sun, 30 Jun 2019 03:36:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726505AbfF3BgI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 29 Jun 2019 21:36:08 -0400
Received: from conssluserg-06.nifty.com ([210.131.2.91]:64763 "EHLO
        conssluserg-06.nifty.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726056AbfF3BgH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 29 Jun 2019 21:36:07 -0400
Received: from mail-vs1-f54.google.com (mail-vs1-f54.google.com [209.85.217.54]) (authenticated)
        by conssluserg-06.nifty.com with ESMTP id x5U1a1F4000658;
        Sun, 30 Jun 2019 10:36:02 +0900
DKIM-Filter: OpenDKIM Filter v2.10.3 conssluserg-06.nifty.com x5U1a1F4000658
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nifty.com;
        s=dec2015msa; t=1561858562;
        bh=GsxC4tEwPTMvxmjodyniSfKM8XvTWF4ZQPqzrB+b+MI=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=yvemeWLvba4Q8g2UVjnLIv15lSYwXP0TgSL9KEbz+SFcM8iUwyGgz6gG7JjR97M+6
         tpk7uLnaampMdiIpqfZ2lxTSVX020UTdbzmnVLNK4vxNUYFo8d/7Tw4WuKPZDidlIC
         BCUVUBBXShv4vZ+BL695j/CgsIYneCDDxUi1KyroulEfQOGtZx9pozt8eZT6ee9yHU
         VIP8tW0QZimtukFY2zDdO/4vd6SOyle4azblBK7rGJtJ2YrkWQ+XCFBIcIt8O/pHzh
         lXFAY5/5hPAoF8w4XYQg7z/W8WXDNDa4W0ziBOWK7e/HdpHcz5ZK0gJq7ke5uuA+Xo
         k2YvKzjzAof5g==
X-Nifty-SrcIP: [209.85.217.54]
Received: by mail-vs1-f54.google.com with SMTP id h28so6552015vsl.12;
        Sat, 29 Jun 2019 18:36:02 -0700 (PDT)
X-Gm-Message-State: APjAAAUeGivDeUZ3amVSnYOQJ+xiEmQvDwqVfVfEcfgvgMOukBcMZHos
        Gi+5GdZyAvRmLUYSpy3mW2kieOOy1LJ9ecu3N9Y=
X-Google-Smtp-Source: APXvYqxTVfy5EI181YpdOobkJbUfPJJwcnBGg16qjvPUW9JsxOT1+iFiAuvukVbwRgwDCIlcEtkvBLkcCf0+BEALY6g=
X-Received: by 2002:a67:8e0a:: with SMTP id q10mr10752837vsd.215.1561858560929;
 Sat, 29 Jun 2019 18:36:00 -0700 (PDT)
MIME-Version: 1.0
References: <20190627163903.28398-1-yamada.masahiro@socionext.com> <20190627163903.28398-2-yamada.masahiro@socionext.com>
In-Reply-To: <20190627163903.28398-2-yamada.masahiro@socionext.com>
From:   Masahiro Yamada <yamada.masahiro@socionext.com>
Date:   Sun, 30 Jun 2019 10:35:24 +0900
X-Gmail-Original-Message-ID: <CAK7LNAQ4Z0BxqFrNdQDWJqbJBW9bSvnzVkvJTZZ-1mMKD7Y6SQ@mail.gmail.com>
Message-ID: <CAK7LNAQ4Z0BxqFrNdQDWJqbJBW9bSvnzVkvJTZZ-1mMKD7Y6SQ@mail.gmail.com>
Subject: Re: [PATCH v3 1/4] kbuild: compile-test UAPI headers to ensure they
 are self-contained
To:     Linux Kbuild mailing list <linux-kbuild@vger.kernel.org>
Cc:     Song Liu <songliubraving@fb.com>,
        Michal Marek <michal.lkml@markovi.net>, bpf@vger.kernel.org,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jani Nikula <jani.nikula@intel.com>,
        Networking <netdev@vger.kernel.org>,
        Palmer Dabbelt <palmer@sifive.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Albert Ou <aou@eecs.berkeley.edu>, Yonghong Song <yhs@fb.com>,
        linux-riscv@lists.infradead.org, Sam Ravnborg <sam@ravnborg.org>,
        Martin KaFai Lau <kafai@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 28, 2019 at 1:40 AM Masahiro Yamada
<yamada.masahiro@socionext.com> wrote:
>
> Multiple people have suggested compile-testing UAPI headers to ensure
> they can be really included from user-space. "make headers_check" is
> obviously not enough to catch bugs, and we often leak references to
> kernel-space definition to user-space.
>
> Use the new header-test-y syntax to implement it. Please note exported
> headers are compile-tested with a completely different set of compiler
> flags. The header search path is set to $(objtree)/usr/include since
> exported headers should not include unexported ones.
>
> We use -std=gnu89 for the kernel space since the kernel code highly
> depends on GNU extensions. On the other hand, UAPI headers should be
> written in more standardized C, so they are compiled with -std=c90.
> This will emit errors if C++ style comments, the keyword 'inline', etc.
> are used. Please use C style comments (/* ... */), '__inline__', etc.
> in UAPI headers.
>
> There is additional compiler requirement to enable this test because
> many of UAPI headers include <stdlib.h>, <sys/ioctl.h>, <sys/time.h>,
> etc. directly or indirectly. You cannot use kernel.org pre-built
> toolchains [1] since they lack <stdlib.h>.
>
> I added scripts/cc-system-headers.sh to check the system header
> availability, which CONFIG_UAPI_HEADER_TEST depends on.


Perhaps, we could use scripts/cc-can-link.sh for this purpose.

The intention is slightly different, but a compiler to link
user-space programs must provide necessary standard headers.


-- 
Best Regards
Masahiro Yamada
