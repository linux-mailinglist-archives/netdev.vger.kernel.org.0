Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8BA191E689A
	for <lists+netdev@lfdr.de>; Thu, 28 May 2020 19:24:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405506AbgE1RYB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 May 2020 13:24:01 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:24588 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2405353AbgE1RYA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 May 2020 13:24:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1590686639;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=b10WE7v1A18G0MJHCfCrgYKCxbH7drfKcQ1AZUdmnb0=;
        b=WlEAixXTAXHbCVwmo/P/KsBiLKLkRXE3DTTERJmvGjzNSvV169o1jw9L0U0sKSTI/MMHeo
        eMTy916bkhrjpQ332omzlELc61FS0OspHBIXR5vVSdL0kynaWYGPE43FSF5awn086Q4U0x
        B4uvyIgyzV8br7xQmE3nu37fOCfWy5U=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-376-lWRK6raQPligR1tcSuyMoQ-1; Thu, 28 May 2020 13:23:57 -0400
X-MC-Unique: lWRK6raQPligR1tcSuyMoQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5D86E8015D2;
        Thu, 28 May 2020 17:23:54 +0000 (UTC)
Received: from krava (unknown [10.40.195.83])
        by smtp.corp.redhat.com (Postfix) with SMTP id 310947A8A5;
        Thu, 28 May 2020 17:23:49 +0000 (UTC)
Date:   Thu, 28 May 2020 19:23:49 +0200
From:   Jiri Olsa <jolsa@redhat.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Jiri Olsa <jolsa@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Yonghong Song <yhs@fb.com>, Martin KaFai Lau <kafai@fb.com>,
        David Miller <davem@redhat.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Wenbo Zhang <ethercflow@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Andrii Nakryiko <andriin@fb.com>,
        Brendan Gregg <bgregg@netflix.com>,
        Florent Revest <revest@chromium.org>,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH 7/9] bpf: Compile the BTF id whitelist data in vmlinux
Message-ID: <20200528172349.GA506785@krava>
References: <20200506132946.2164578-1-jolsa@kernel.org>
 <20200506132946.2164578-8-jolsa@kernel.org>
 <20200513182940.gil7v5vkthhwck3t@ast-mbp.dhcp.thefacebook.com>
 <20200514080515.GH3343750@krava>
 <CAEf4BzbZ6TYxVTJx3ij1WXy5AvVQio9Ht=tePO+xQf=JLigoog@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEf4BzbZ6TYxVTJx3ij1WXy5AvVQio9Ht=tePO+xQf=JLigoog@mail.gmail.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 14, 2020 at 03:46:26PM -0700, Andrii Nakryiko wrote:

SNIP

> > I was thinking of putting the names in __init section and generate the BTF
> > ids on kernel start, but the build time generation seemed more convenient..
> > let's see the linking times with 'real size' whitelist and we can reconsider
> >
> 
> Being able to record such places where to put BTF ID in code would be
> really nice, as Alexei mentioned. There are many potential use cases
> where it would be good to have BTF IDs just put into arbitrary
> variables/arrays. This would trigger compilation error, if someone
> screws up the name, or function is renamed, or if function can be
> compiled out under some configuration. E.g., assuming some reasonable
> implementation of the macro

hi,
I'm struggling with this part.. to get some reasonable reference
to function/name into 32 bits? any idea? ;-)

jirka

> 
> static const u32 d_path_whitelist[] = {
>     BTF_ID_FUNC(vfs_fallocate),
> #ifdef CONFIG_WHATEVER
>     BTF_ID_FUNC(do_truncate),
> #endif
> };
> 
> Would be nice and very explicit. Given this is not going to be sorted,
> you won't be able to use binary search, but if whitelists are
> generally small, it should be fine as is. If not, hashmap could be
> built in runtime and would be, probably, faster than binary search for
> longer sets of BTF IDs.
> 
> I wonder if we can do some assembly magic with generating extra
> symbols and/or relocations to achieve this? What do you think? Is it
> doable/desirable/better?
> 
> 
> > thanks,
> > jirka
> >
> 

