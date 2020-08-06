Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D8BBB23E4BD
	for <lists+netdev@lfdr.de>; Fri,  7 Aug 2020 01:48:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726205AbgHFXsT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Aug 2020 19:48:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725272AbgHFXsS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Aug 2020 19:48:18 -0400
Received: from mail-lj1-x241.google.com (mail-lj1-x241.google.com [IPv6:2a00:1450:4864:20::241])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00575C061574;
        Thu,  6 Aug 2020 16:48:17 -0700 (PDT)
Received: by mail-lj1-x241.google.com with SMTP id v4so262709ljd.0;
        Thu, 06 Aug 2020 16:48:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ROLgdGiet2JRzTM+E/daiaLAaAuchSq9OXMl0UQnk+k=;
        b=nYZUv7wV1jHMIjk9VuCGu7ew5bqyDt35IE4l8ct1rix0+WGq/kGKzZJoaXPStNCdqI
         tL/6+VXaASZkkX8QxJsYXaTF2NtCCpgTx6f3NkXGpghbcRae1c3l5yaz011ZIMCQJclP
         g7I0JHInvNZDBy1SNVE2TNHV5AISL9ZlPl9L/mOJwFlHmFWITJ8JmktEY5TfAW1X/Fjk
         ZN97e/1Lno4HL3nmLUW6Rgy0gM/9E6zJNJ2QIVVggo/LF0/FkFzhVEcjNdfR5fGusVfM
         /Xwly7dEF6hqBz6HsNKo5ipR0AAQFud7nny4W7pq/j1CYKYLZgp9RXzW1Nsqw2GBcMjd
         0fqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ROLgdGiet2JRzTM+E/daiaLAaAuchSq9OXMl0UQnk+k=;
        b=pPl9pWeeLpYeI0jGr07eB4wesykkl+yJASetM2L+y1vcLFAkW6W2BoY8qDA/UKYY0X
         kePHAipQBIRnm5r2wofJaENT5zc8POYvw5j/ediHoMjJDkX8LTvKXLHsrsEtTParYFaM
         UifVXULrczWBWiGAxG7yWX68paYGvY3tuG2s/1UzOCt88Jb3/+lDsexoJlGKPE6FO4ze
         mdjBAlAbr4qDpJZ+Y7yc1ZOjlJtODpnxnD4CvdX4aevwrSEH53pp37NYCcO4nq9gXgN7
         419YL4SGwiBUELzans54Z3IqsFNvQwtaglPSJvlvdYyqne9ObhMimLQR5vBsdmxlFCIo
         CqNA==
X-Gm-Message-State: AOAM5321+OyYGubg99OpUxRaJwz8WuaSOB7dcnvKC36FubyQptnPBstC
        4OjGdh2/b4OFQBJ6a41Vq3m07vQgYi8MVMk/KBxxGw==
X-Google-Smtp-Source: ABdhPJzxfnZbmoTJ2q3CZPv8Uh5nB+ooivEaDzn1xvAuI/Hf875586Oj7BAmugCvS4iEHAnPPIHJ3aDgO4dxFGn4etk=
X-Received: by 2002:a2e:8e28:: with SMTP id r8mr4526466ljk.290.1596757695646;
 Thu, 06 Aug 2020 16:48:15 -0700 (PDT)
MIME-Version: 1.0
References: <20200805223359.32109-1-danieltimlee@gmail.com> <5f2ba174c65a7_291f2b27e574e5b81@john-XPS-13-9370.notmuch>
In-Reply-To: <5f2ba174c65a7_291f2b27e574e5b81@john-XPS-13-9370.notmuch>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Thu, 6 Aug 2020 16:48:04 -0700
Message-ID: <CAADnVQLohzfYs7RLFt09aG6QqC8HVO2CgzJ08jyoUybJt10bDg@mail.gmail.com>
Subject: Re: [PATCH bpf-next] libbf: fix uninitialized pointer at btf__parse_raw()
To:     John Fastabend <john.fastabend@gmail.com>
Cc:     "Daniel T. Lee" <danieltimlee@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andriin@fb.com>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 5, 2020 at 11:22 PM John Fastabend <john.fastabend@gmail.com> wrote:
>
> Daniel T. Lee wrote:
> > Recently, from commit 94a1fedd63ed ("libbpf: Add btf__parse_raw() and
> > generic btf__parse() APIs"), new API has been added to libbpf that
> > allows to parse BTF from raw data file (btf__parse_raw()).
> >
> > The commit derives build failure of samples/bpf due to improper access
> > of uninitialized pointer at btf_parse_raw().
> >
> >     btf.c: In function btf__parse_raw:
> >     btf.c:625:28: error: btf may be used uninitialized in this function
> >       625 |  return err ? ERR_PTR(err) : btf;
> >           |         ~~~~~~~~~~~~~~~~~~~^~~~~
> >
> > This commit fixes the build failure of samples/bpf by adding code of
> > initializing btf pointer as NULL.
> >
> > Fixes: 94a1fedd63ed ("libbpf: Add btf__parse_raw() and generic btf__parse() APIs")
> > Signed-off-by: Daniel T. Lee <danieltimlee@gmail.com>
> > ---
>
> Unless errno is zero this should be ok in practice, but I guess compiler
> wont know that.
>
> Acked-by: John Fastabend <john.fastabend@gmail.com>

Applied. Thanks
