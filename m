Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 97EB064AA71
	for <lists+netdev@lfdr.de>; Mon, 12 Dec 2022 23:41:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233865AbiLLWl3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Dec 2022 17:41:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233517AbiLLWl2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Dec 2022 17:41:28 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83FABA1AF;
        Mon, 12 Dec 2022 14:41:25 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AA24AB80E9B;
        Mon, 12 Dec 2022 22:41:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DDDB2C433EF;
        Mon, 12 Dec 2022 22:41:19 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="kJ9Impaj"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1670884877;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=0RlIYFMtptV14Ll/IQC4NgcykON3vMQcNKFWJ1LIFHI=;
        b=kJ9ImpajbUAEiUFcN6L+GPxuHJM4NteyFTK34DyZkQCw0N7mOFT3Yp+VOC1QL8J512rkLS
        viMbxoqSjW+OrMkmJObeYiAawkMaAwiZO+u0iTyReL8ReVYGQpd6GQrgq4hEX6BIB3nPW4
        Rpw3UA91kuOpy52I8noTMdpXSWSuk9g=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 757bcc63 (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO);
        Mon, 12 Dec 2022 22:41:17 +0000 (UTC)
Date:   Mon, 12 Dec 2022 15:41:15 -0700
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     Amit Klein <aksecurity@gmail.com>
Cc:     Yonghong Song <yhs@meta.com>, david.keisarschm@mail.huji.ac.il,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        John Fastabend <john.fastabend@gmail.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <martin.lau@linux.dev>,
        Song Liu <song@kernel.org>, Yonghong Song <yhs@fb.com>,
        KP Singh <kpsingh@kernel.org>,
        Stanislav Fomichev <sdf@google.com>,
        Hao Luo <haoluo@google.com>, Jiri Olsa <jolsa@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, ilay.bahat1@gmail.com,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH 2/5] Replace invocation of weak PRNG in kernel/bpf/core.c
Message-ID: <Y5euC6+f5604XT1y@zx2c4.com>
References: <cover.1670778651.git.david.keisarschm@mail.huji.ac.il>
 <7c16cafe96c47ff5234fbb980df9d3e3d48a0296.1670778652.git.david.keisarschm@mail.huji.ac.il>
 <01ade45b-8ca6-d584-199b-a06778038356@meta.com>
 <CANEQ_+KDR+kC=hYhTtNeQuSTp+-Dg0tRx-9MzJKQ2zH++fBGyQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CANEQ_+KDR+kC=hYhTtNeQuSTp+-Dg0tRx-9MzJKQ2zH++fBGyQ@mail.gmail.com>
X-Spam-Status: No, score=-6.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 13, 2022 at 12:35:24AM +0200, Amit Klein wrote:
> On Mon, Dec 12, 2022 at 8:03 PM Yonghong Song <yhs@meta.com> wrote:
> >
> >
> >
> > On 12/11/22 2:16 PM, david.keisarschm@mail.huji.ac.il wrote:
> > > From: David <david.keisarschm@mail.huji.ac.il>
> > >
> > > We changed the invocation of
> > >   prandom_u32_state to get_random_u32.
> > >   We deleted the maintained state,
> > >   which was a CPU-variable,
> > >   since get_random_u32 maintains its own CPU-variable.
> > >   We also deleted the state initializer,
> > >   since it is not needed anymore.
> > >
> > > Signed-off-by: David <david.keisarschm@mail.huji.ac.il>
> > > ---
> > >   include/linux/bpf.h   |  1 -
> > >   kernel/bpf/core.c     | 13 +------------
> > >   kernel/bpf/verifier.c |  2 --
> > >   net/core/filter.c     |  1 -
> > >   4 files changed, 1 insertion(+), 16 deletions(-)
> > >
> > > diff --git a/include/linux/bpf.h b/include/linux/bpf.h
> [...]
> > Please see the discussion here.
> > https://lore.kernel.org/bpf/87edtctz8t.fsf@toke.dk/
> > There is a performance concern with the above change.
> >
> 
> I see. How about using (in this instance only!) the SipHash-based
> solution which was the basis for prandom_u32() starting with commit
> c51f8f88d705 (v5.10-rc1) up until commit d4150779e60f (v5.19-rc1)?

Stop with this pseudo cryptographic garbage. Stop pushing this
everywhere. It was a hassle to undo this crap the first time around. The
last thing we need is to add it back.

Plus, there's no need for it either. I'll revisit the bpf patch if/when
it makes sense to do performance-wise.

Jason
