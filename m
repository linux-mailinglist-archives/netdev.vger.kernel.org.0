Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F044E10ECF2
	for <lists+netdev@lfdr.de>; Mon,  2 Dec 2019 17:20:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727594AbfLBQUA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Dec 2019 11:20:00 -0500
Received: from mail-lj1-f195.google.com ([209.85.208.195]:38494 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727484AbfLBQUA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Dec 2019 11:20:00 -0500
Received: by mail-lj1-f195.google.com with SMTP id k8so100180ljh.5;
        Mon, 02 Dec 2019 08:19:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=HGcdF9VVAZCUdbTM3FRA/f2Jg2OzxmwCb3WDeSg01uA=;
        b=J4Q6ICfCXHjGa1mbOshuV0kuoj5iUFSJKHL9Q8Mi7UJC3Hfrr7dJ6AgrT/C7NgwgeI
         1+7Dy3n73NyqgwgJgig6OH3dLZp/alupHshr0VbpkyNhC1xP+OOxSTQgo6kc6nP2vUBP
         nw1Nxvp+ZEpjekEc96NkXxJHokxE9ISYyoEQxn/ib+TGXmeSNrS6hRwkP2myDUlfcBwD
         bm9NirAqgfJzk/nIJ152Z7LhIsrPguVZOHkh1h+6YkGXed+4YbQVHbV2LEupmhNLpixY
         iJVL7d2zCpSNUJAAoJ4N0OIm/tdqzY2MsqtkNAJyMiuE9Yr5Ksf+x2KrEGoEznEGw2id
         wVtw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=HGcdF9VVAZCUdbTM3FRA/f2Jg2OzxmwCb3WDeSg01uA=;
        b=IwwsQ0lfJP8uttyT38SkR0wMh2jsR0puKqqZX70ZXPAai40dPW73/U7XDwrvF5Kh60
         bagSFI7DKLwC1XqmjqIEK1QNFTtx/zNHUtcwpWIzZGcIS8fU3b8s3CRy2QmM8RKwlSpy
         soJIKi3yFGkNx1dbsA3TQNqKoJXW5mG3KMxRx//9hqcNkSXSSPmdYyUAPmNsPFA8GXCG
         EmyChv7JXfVKKwRP1OfHtMuudGPkFtDflt7RXwYZuZfIztJuvs/8A2Ykh1hlVnFfaCHe
         8HVmcuW284quy7pj8WMscKMMrnHgW0H5w7cAd0syD08zPIIwlpPPiP2xHKYUdNEDAbfO
         Pt4A==
X-Gm-Message-State: APjAAAWQryVU7tcUZVcwqTjzXMvn4Y4Kkgh6My7TcwMvkicwxj0phHr1
        N8ez9nAtl1azloZiyzomd5zgzwZoh67bJuj8PIBXqg==
X-Google-Smtp-Source: APXvYqxsifR7qs0VyP/hfXwyl8i1EH5mCES+VRxeCmY6i6+MPx5smYQkoH0ZJMSp/dUO3l5B/1Mb9Pox43Xd3ChjKKA=
X-Received: by 2002:a2e:8508:: with SMTP id j8mr46640457lji.136.1575303597040;
 Mon, 02 Dec 2019 08:19:57 -0800 (PST)
MIME-Version: 1.0
References: <20191129222911.3710-1-daniel@iogearbox.net> <ec8264ad-8806-208a-1375-51e7cad1866e@gmail.com>
 <10d4c87c-3d53-2dbf-d8c0-8b36863fec60@iogearbox.net> <adc89dbf-361a-838f-a0a5-8ef7ea619848@gmail.com>
 <20191202083006.GJ2844@hirez.programming.kicks-ass.net> <20191202091716.GA30232@localhost.localdomain>
In-Reply-To: <20191202091716.GA30232@localhost.localdomain>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Mon, 2 Dec 2019 08:19:45 -0800
Message-ID: <CAADnVQJEqVmwAJ2V9NB+0Udwg5H9KJfCSjuSpARAGHLPuhnA=w@mail.gmail.com>
Subject: Re: [PATCH bpf] bpf: avoid setting bpf insns pages read-only when
 prog is jited
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, "H. Peter Anvin" <hpa@zytor.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 2, 2019 at 1:17 AM Daniel Borkmann <daniel@iogearbox.net> wrote:
>
> On Mon, Dec 02, 2019 at 09:30:06AM +0100, Peter Zijlstra wrote:
> > On Sun, Dec 01, 2019 at 06:49:32PM -0800, Eric Dumazet wrote:
> >
> > > Thanks for the link !
> > >
> > > Having RO protection as a debug feature would be useful.
> > >
> > > I believe we have CONFIG_STRICT_MODULE_RWX (and CONFIG_STRICT_KERNEL_RWX) for that already.
> > >
> > > Or are we saying we also want to get rid of them ?
> >
> > No, in fact I'm working on making that stronger. We currently still have
> > a few cases that violate the W^X rule.
> >
> > The thing is, when the BPF stuff is JIT'ed, the actual BPF instruction
> > page is not actually executed at all, so making it RO serves no purpose,
> > other than to fragment the direct map.
>
> Yes exactly, in that case it is only used for dumping the BPF insns back
> to user space and therefore no need at all to set it RO. (The JITed image
> however *is* set as RO. - Perhaps there was some confusion given your
> earlier question.)

May be we should also flip the default to net.core.bpf_jit_enable=1
for x86-64 ? and may be arm64 ? These two JITs are well tested
and maintained.
