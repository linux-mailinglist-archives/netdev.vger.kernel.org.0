Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 10CCE482651
	for <lists+netdev@lfdr.de>; Sat,  1 Jan 2022 03:22:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231951AbiAACW2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Dec 2021 21:22:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231938AbiAACW2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Dec 2021 21:22:28 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 214CCC061574;
        Fri, 31 Dec 2021 18:22:28 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C3E3BB81D57;
        Sat,  1 Jan 2022 02:22:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9ED2DC36AEC;
        Sat,  1 Jan 2022 02:22:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641003745;
        bh=APz4Jtsyu1sUD/EnSPVj4YAQO/qc9RwHaadctv1OyBw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=oSzK52le/t8R9DqJxqmxoYsdRPxFhvrvZcoPqPCrFPHqM4ziCkYcKuX6oH4IkLONp
         C3DVB/joGYpK7j/d2DG8Za5o8fjHc8QoTWIWktvw8UDdPAxkC+loKcbpuX+4AuYa7U
         2qzbZSIk5Ad/oZapumsR6y8ng7yI382Hupn9Kdf/nPJCgA8MOM2H+u3ZampoYe9tdN
         H49SeWt8zvEBqAaSlurJdM3oSjOX0AId0QH/JnAT60ISQ5BbYPjSn2CauwcNUTCq5j
         L+YAuaejs9PngWhJ2J6sPGv95bbpoXtRbuEs83el6Ac4kDQl/710kdVjkTCKHE3RrF
         tzNC93/19AY2w==
Date:   Fri, 31 Dec 2021 18:22:23 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Menglong Dong <menglong8.dong@gmail.com>
Cc:     Steven Rostedt <rostedt@goodmis.org>,
        David Ahern <dsahern@kernel.org>, mingo@redhat.com,
        David Miller <davem@davemloft.net>,
        Neil Horman <nhorman@tuxdriver.com>,
        Eric Dumazet <edumazet@google.com>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        jonathan.lemon@gmail.com, alobakin@pm.me,
        Kees Cook <keescook@chromium.org>,
        Paolo Abeni <pabeni@redhat.com>, talalahmad@google.com,
        haokexin@gmail.com, Menglong Dong <imagedong@tencent.com>,
        atenart@kernel.org, bigeasy@linutronix.de,
        Wei Wang <weiwan@google.com>, arnd@arndb.de, vvs@virtuozzo.com,
        Cong Wang <cong.wang@bytedance.com>,
        LKML <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Mengen Sun <mengensun@tencent.com>, mungerjiang@tencent.com
Subject: Re: [PATCH v2 net-next 1/3] net: skb: introduce
 kfree_skb_with_reason()
Message-ID: <20211231182223.43afa349@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <CADxym3aonWQoR=XkoLqn_taEhjBYeMf7f2Tgjgnq7fCNT2kHNw@mail.gmail.com>
References: <20211230093240.1125937-1-imagedong@tencent.com>
        <20211230093240.1125937-2-imagedong@tencent.com>
        <20211230172619.40603ff3@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
        <CADxym3aonWQoR=XkoLqn_taEhjBYeMf7f2Tgjgnq7fCNT2kHNw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 31 Dec 2021 14:35:31 +0800 Menglong Dong wrote:
> > >  void skb_release_head_state(struct sk_buff *skb);
> > >  void kfree_skb(struct sk_buff *skb);  
> >
> > Should this be turned into a static inline calling
> > kfree_skb_with_reason() now? BTW you should drop the
> > '_with'.
> >  
> 
> I thought about it before, but I'm a little afraid that some users may trace
> kfree_skb() with kprobe, making it inline may not be friendly to them?

Hm, there is a bpf sample which does that, but that's probably 
not commonly used given there is a tracepoint. If someone is 
using a kprobe they can switch to kprobing kfree_skb*reason().
