Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A93A110A5EB
	for <lists+netdev@lfdr.de>; Tue, 26 Nov 2019 22:23:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726437AbfKZVXA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Nov 2019 16:23:00 -0500
Received: from mail-pg1-f196.google.com ([209.85.215.196]:34529 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726033AbfKZVXA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Nov 2019 16:23:00 -0500
Received: by mail-pg1-f196.google.com with SMTP id z188so9639429pgb.1
        for <netdev@vger.kernel.org>; Tue, 26 Nov 2019 13:22:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=6/C6I0i87/WZnXIrmrosa90/eAl9LYlEh8C0iWOtu10=;
        b=dQKartIzq9lcDOeMZSrCdPu+Yi2YLj6S1/i5r+r3Z3CmlM3Um0R+5E9S+TUfrXu+IQ
         Njvy16TFycCN2Bh5R1dcR4Hu93XeMjXF0VyoxFEt5gEpQ7HXeZrUO+h4iKEDsIvcGugV
         Afm6BC1zXhozTaIh+c5Eb2Gn/YAgy55BSz5tG3LrqgTB+3W3cxsbssoW73Zh7sV9hqsV
         65ueX0gbdQbTJhBab7QyqVvHii+DDpSbz1VJ7qzSkgBN1/DJnTdiCAI95mVbKqwkFwrx
         khfrKjsTzH8jCPIiqYbZn1TkrfArjIhixC5u4eHN/vi40i1cqd3Gvsr5yA/3npLif6y+
         9e3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=6/C6I0i87/WZnXIrmrosa90/eAl9LYlEh8C0iWOtu10=;
        b=Nf/JIt8oDbV5TP2kBv46EP/2k/Y0UY8pL123g9DpOIYJkIP33wiC1Lq4ye+t/11Dnp
         4lmjLAZibbSp7VloGKxgYmjpmbZ5wDVRCVxBdSa2hsKGFIte8E4sN8YeDqw2B53C1Ny3
         P63JQOYz8+RXEHKCF8oj2bX/z9MZA6eJARubHxkV3dfMvt01cnKrd7s26uDe6G6ZKioM
         NrD02v2z14yxLdmAPVdr8Mst5XfvLeJgynoRrv6FOklxgSCCz3LoudY6Ez+JOPb2Y6Js
         XGo5HW8HiydvQvLJO521oiRGcJMjBkGiwQE1jC6ssrKvUrP4H2+78Ji+XnRVilIJ0JEN
         hMPg==
X-Gm-Message-State: APjAAAVvTN75hE7DaJlWwUrntuKrR0muCP7WfCR8LaKnofiyzqth5eJG
        vg8L3kxDbxJWO706OTJxaQQDTYMLyzUlSmujosKAoQ==
X-Google-Smtp-Source: APXvYqyM2tWhpkF/12V6DFQdzF+HZF4mPyfBy3JXMF5Ph+w11uqrKP+IoH06RmM6rIuMg+X8ziQzgixJ3GwZuwbSUf0=
X-Received: by 2002:a65:590f:: with SMTP id f15mr560009pgu.381.1574803378796;
 Tue, 26 Nov 2019 13:22:58 -0800 (PST)
MIME-Version: 1.0
References: <20191126201226.51857-1-natechancellor@gmail.com>
In-Reply-To: <20191126201226.51857-1-natechancellor@gmail.com>
From:   Nick Desaulniers <ndesaulniers@google.com>
Date:   Tue, 26 Nov 2019 13:22:47 -0800
Message-ID: <CAKwvOdk5wZF6BHR0_xSL=H=tmSFT42qmn23etO3uV6w-PPgaqA@mail.gmail.com>
Subject: Re: [PATCH] netfilter: nf_flow_table_offload: Don't use offset
 uninitialized in flow_offload_port_{d,s}nat
To:     Nathan Chancellor <natechancellor@gmail.com>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        Network Development <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        clang-built-linux <clang-built-linux@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 26, 2019 at 12:13 PM Nathan Chancellor
<natechancellor@gmail.com> wrote:
>
> Clang warns (trimmed the second warning for brevity):
>
> ../net/netfilter/nf_flow_table_offload.c:342:2: warning: variable
> 'offset' is used uninitialized whenever switch default is taken
> [-Wsometimes-uninitialized]
>         default:
>         ^~~~~~~
> ../net/netfilter/nf_flow_table_offload.c:346:57: note: uninitialized use
> occurs here
>         flow_offload_mangle(entry, flow_offload_l4proto(flow), offset,
>                                                                ^~~~~~
> ../net/netfilter/nf_flow_table_offload.c:331:12: note: initialize the
> variable 'offset' to silence this warning
>         u32 offset;
>                   ^
>                    = 0
>
> Match what was done in the flow_offload_ipv{4,6}_{d,s}nat functions and
> just return in the default case, since port would also be uninitialized.

Thanks for the patch. I have a report of this from kernelci bot, would
you mind crediting it:
Reported-by: kernelci.org bot <bot@kernelci.org>
Looks like `port` is uninitialized (prior to your patch), too.
Reviewed-by: Nick Desaulniers <ndesaulniers@google.com>
These two functions look identical except for the mask. The
maintainers should consider reusing more code between them and passing
in the mask.

>
> Fixes: c29f74e0df7a ("netfilter: nf_flow_table: hardware offload support")
> Link: https://github.com/ClangBuiltLinux/linux/issues/780
> Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>
> ---
>  net/netfilter/nf_flow_table_offload.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/net/netfilter/nf_flow_table_offload.c b/net/netfilter/nf_flow_table_offload.c
> index c54c9a6cc981..a77a6e1cfd64 100644
> --- a/net/netfilter/nf_flow_table_offload.c
> +++ b/net/netfilter/nf_flow_table_offload.c
> @@ -340,7 +340,7 @@ static void flow_offload_port_snat(struct net *net,
>                 offset = 0; /* offsetof(struct tcphdr, dest); */
>                 break;
>         default:
> -               break;
> +               return;
>         }
>
>         flow_offload_mangle(entry, flow_offload_l4proto(flow), offset,
> @@ -367,7 +367,7 @@ static void flow_offload_port_dnat(struct net *net,
>                 offset = 0; /* offsetof(struct tcphdr, dest); */
>                 break;
>         default:
> -               break;
> +               return;
>         }
>
>         flow_offload_mangle(entry, flow_offload_l4proto(flow), offset,
> --
> 2.24.0
>
> --
> You received this message because you are subscribed to the Google Groups "Clang Built Linux" group.
> To unsubscribe from this group and stop receiving emails from it, send an email to clang-built-linux+unsubscribe@googlegroups.com.
> To view this discussion on the web visit https://groups.google.com/d/msgid/clang-built-linux/20191126201226.51857-1-natechancellor%40gmail.com.



-- 
Thanks,
~Nick Desaulniers
