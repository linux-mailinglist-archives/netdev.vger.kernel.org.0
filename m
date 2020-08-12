Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 19648242649
	for <lists+netdev@lfdr.de>; Wed, 12 Aug 2020 09:48:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726807AbgHLHsl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Aug 2020 03:48:41 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:20097 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726479AbgHLHsk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Aug 2020 03:48:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1597218519;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=eQf3+HvHKnlSe+Z7RG69UMsLhFqyCRv2tFgK/HQL7TE=;
        b=ir7LywsrfqKoACqHxEV3oJO3K1GX/xjhbsK5/1Q4rTZ19z5/X0i9DMNIQF5tipKp3V4Qel
        sbPWVWPAzVMkyhfxVgCGsHxbB0Tjr5meohIyXIrpPTvJts8HNN6cnvuiDDnQ5t2Fiu8ZM4
        YKbuIe04fM1UgrQ3Yc7F+NTV9JGAK/s=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-156-OPUD8D2_MLOMpShTcVxnuQ-1; Wed, 12 Aug 2020 03:48:32 -0400
X-MC-Unique: OPUD8D2_MLOMpShTcVxnuQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 121B6102C805;
        Wed, 12 Aug 2020 07:48:31 +0000 (UTC)
Received: from krava (unknown [10.40.194.46])
        by smtp.corp.redhat.com (Postfix) with SMTP id 0EE5188F29;
        Wed, 12 Aug 2020 07:48:27 +0000 (UTC)
Date:   Wed, 12 Aug 2020 09:48:26 +0200
From:   Jiri Olsa <jolsa@redhat.com>
To:     Yonghong Song <yhs@fb.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, Andrii Nakryiko <andriin@fb.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>
Subject: Re: [RFC] bpf: verifier check for dead branch
Message-ID: <20200812074826.GB754656@krava>
References: <20200807173045.GC561444@krava>
 <f13fde40-0c07-ff73-eeb3-3c59c5694f74@fb.com>
 <20200810135451.GA699846@krava>
 <e4abe45b-2c80-9448-677c-e352f0ecb24e@fb.com>
 <20200811071438.GC699846@krava>
 <f03e2ce3-8cf8-0590-1777-f9e8171cd3fa@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f03e2ce3-8cf8-0590-1777-f9e8171cd3fa@fb.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 11, 2020 at 09:08:13AM -0700, Yonghong Song wrote:
> 
> 
> On 8/11/20 12:14 AM, Jiri Olsa wrote:
> > On Mon, Aug 10, 2020 at 10:16:12AM -0700, Yonghong Song wrote:
> > 
> > SNIP
> > 
> > > 
> > > Thanks for the test case. I can reproduce the issue. The following
> > > is why this happens in llvm.
> > > the pseudo IR code looks like
> > >     data = skb->data
> > >     data_end = skb->data_end
> > >     comp = data + 42 > data_end
> > >     ip = select "comp" nullptr "data + some offset"
> > >           <=== select return one of nullptr or "data + some offset" based on
> > > "comp"
> > >     if comp   // original skb_shorter condition
> > >        ....
> > >     ...
> > >        = ip
> > > 
> > > In llvm, bpf backend "select" actually inlined "comp" to generate proper
> > > control flow. Therefore, comp is computed twice like below
> > >     data = skb->data
> > >     data_end = skb->data_end
> > >     if (data + 42 > data_end) {
> > >        ip = nullptr; goto block1;
> > >     } else {
> > >        ip = data + some_offset;
> > >        goto block2;
> > >     }
> > >     ...
> > >     if (data + 42 > data_end) // original skb_shorter condition
> > > 
> > > The issue can be workarounded the source. Just check data + 42 > data_end
> > > and if failure return. Then you will be able to assign
> > > a value to "ip" conditionally.
> 
> sorry for typo. The above should be "conditionally" -> "unconditionally".

aaah, ok ;-)

> 
> The following is what I mean:
> 
> diff --git a/t.c b/t.c
> index c6baf28..7bf90dc 100644
> --- a/t.c
> +++ b/t.c
> @@ -37,17 +37,10 @@
> 
>  static INLINE struct iphdr *get_iphdr (struct __sk_buff *skb)
>  {
> -       struct iphdr *ip = NULL;
>         struct ethhdr *eth;
> 
> -       if (skb_shorter(skb, ETH_IPV4_UDP_SIZE))
> -               goto out;
> -
>         eth = (void *)(long)skb->data;
> -       ip = (void *)(eth + 1);
> -
> -out:
> -       return ip;
> +       return (void *)(eth + 1);
>  }
> 
>  int my_prog(struct __sk_buff *skb)
> @@ -56,9 +49,10 @@ int my_prog(struct __sk_buff *skb)
>         struct udphdr *udp;
>         __u8 proto = 0;
> 
> -       if (!(ip = get_iphdr(skb)))
> +       if (skb_shorter(skb, ETH_IPV4_UDP_SIZE))
>                 goto out;
> 
> +       ip = get_iphdr(skb);
>         proto = ip->protocol;
> 
>         if (proto != IPPROTO_UDP)
> 
> > 
> > > 
> > > Will try to fix this issue in llvm12 as well.
> > > Thanks!
> > 
> > great, could you please CC me on the changes?
> 
> This will be a llvm change. Do you have llvm phabricator login name
> https://reviews.llvm.org/
> so I can add you as a subscriber?

Jiri (Olsa)
olsajiri@gmail.com

thank,
jirka

