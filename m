Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D8FCE272149
	for <lists+netdev@lfdr.de>; Mon, 21 Sep 2020 12:37:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726558AbgIUKhb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Sep 2020 06:37:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726436AbgIUKhb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Sep 2020 06:37:31 -0400
Received: from mail-oi1-x22a.google.com (mail-oi1-x22a.google.com [IPv6:2607:f8b0:4864:20::22a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1F78C061755
        for <netdev@vger.kernel.org>; Mon, 21 Sep 2020 03:37:30 -0700 (PDT)
Received: by mail-oi1-x22a.google.com with SMTP id c13so16392581oiy.6
        for <netdev@vger.kernel.org>; Mon, 21 Sep 2020 03:37:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=iBfaAsgP2Wc9m9ukTSp0WO8VtZOp1OXSL6zmdWQTUqs=;
        b=crpc0nfVJbvYCNSWQXOHLOgtivRJkJBwhtZQJQd0LOq9z7JrIirEIdKKArFXNrEp65
         J7JrdkSevJkvTo9RgQQJ5soCztHibsj8PzcZke7k6WBxIKs5q/Vvr/VCAsyQkZPV8HDJ
         2SbO9eil48bZkIhN3NCANO4hrnnm0LN63u6vI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=iBfaAsgP2Wc9m9ukTSp0WO8VtZOp1OXSL6zmdWQTUqs=;
        b=NPF089RS/wHwmfdJzzpvPfTh/U7oTmCgGEpI5uEt1+vUBDWk819JwKeCjfRqtIGeyo
         joXsk+jgauyjV2seRcQ7HfvqPI0OuUzKscABTx4Zck00cT1yfyQh1pDnyN7ZknE9/KJu
         prhak4kXXA9+OZYx9CkFupr0BxYQPYcLrblUisO48oQViBNBFG7OrQ/midiZgjpUf6qj
         FpBT/6LNs/P2VhhStgGpYPUoYeDBSSrmaGLMBHqGRO4HfndDISna5fW7Vng5L1lpmqLk
         dFX0C9nE9b4e/Lt3y5sFImY044TGbkOxzvyTjxY6jlE6Z3EIL/Z651rKQtuTf3JTnGs7
         hPPQ==
X-Gm-Message-State: AOAM533ETSsVTunf0plYCL6FYGLWPgPDCKwSGc9efDC1aU72Rdha54GS
        tQu/5OFDOAob6vqv502bC9V8wfQtMT788c+ehafG3g==
X-Google-Smtp-Source: ABdhPJywbTIiUXIiz9lQFxuFUQCwQleYQ72E4bh5DGZlkZA8Jby0MTiFSuvmdWHYEFCXlnaWZJAeZzLPj+aEfR7c/kQ=
X-Received: by 2002:aca:f0a:: with SMTP id 10mr17598746oip.13.1600684649900;
 Mon, 21 Sep 2020 03:37:29 -0700 (PDT)
MIME-Version: 1.0
References: <20200917143846.37ce43a0@carbon> <CANP3RGcxM-Cno=Qw5Lut9DgmV=1suXqetnybA9RgxmW3KmwivQ@mail.gmail.com>
 <56ccfc21195b19d5b25559aca4cef5c450d0c402.camel@kernel.org>
 <20200918120016.7007f437@carbon> <CANP3RGfUj-KKHHQtbggiZ4V-Xrr_sk+TWyN5FgYUGZS6rOX1yw@mail.gmail.com>
In-Reply-To: <CANP3RGfUj-KKHHQtbggiZ4V-Xrr_sk+TWyN5FgYUGZS6rOX1yw@mail.gmail.com>
From:   Lorenz Bauer <lmb@cloudflare.com>
Date:   Mon, 21 Sep 2020 11:37:18 +0100
Message-ID: <CACAyw9-v_o+gPUpC-R9SXsfzMywrdGsWV13Nk=tx2aS-fEBFYg@mail.gmail.com>
Subject: Re: BPF redirect API design issue for BPF-prog MTU feedback?
To:     =?UTF-8?Q?Maciej_=C5=BBenczykowski?= <maze@google.com>
Cc:     Jesper Dangaard Brouer <brouer@redhat.com>,
        Saeed Mahameed <saeed@kernel.org>,
        Daniel Borkmann <borkmann@iogearbox.net>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        BPF-dev-list <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Shaun Crampton <shaun@tigera.io>,
        David Miller <davem@davemloft.net>,
        Marek Majkowski <marek@cloudflare.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 19 Sep 2020 at 00:06, Maciej =C5=BBenczykowski <maze@google.com> wr=
ote:
>
> > This is a good point.  As bpf_skb_adjust_room() can just be run after
> > bpf_redirect() call, then a MTU check in bpf_redirect() actually
> > doesn't make much sense.  As clever/bad BPF program can then avoid the
> > MTU check anyhow.  This basically means that we have to do the MTU
> > check (again) on kernel side anyhow to catch such clever/bad BPF
> > programs.  (And I don't like wasting cycles on doing the same check two
> > times).
>
> If you get rid of the check in bpf_redirect() you might as well get
> rid of *all* the checks for excessive mtu in all the helpers that
> adjust packet size one way or another way.  They *all* then become
> useless overhead.
>
> I don't like that.  There may be something the bpf program could do to
> react to the error condition (for example in my case, not modify
> things and just let the core stack deal with things - which will
> probably just generate packet too big icmp error).
>
> btw. right now our forwarding programs first adjust the packet size
> then call bpf_redirect() and almost immediately return what it
> returned.
>
> but this could I think easily be changed to reverse the ordering, so
> we wouldn't increase packet size before the core stack was informed we
> would be forwarding via a different interface.

We do the same, except that we also use XDP_TX when appropriate. This
complicates the matter, because there is no helper call we could
return an error from.

My preference would be to have three helpers: get MTU for a device,
redirect ctx to a device (with MTU check), resize ctx (without MTU
check) but that doesn't work with XDP_TX. Your idea of doing checks in
redirect and adjust_room is pragmatic and seems easier to implement.

--=20
Lorenz Bauer  |  Systems Engineer
6th Floor, County Hall/The Riverside Building, SE1 7PB, UK

www.cloudflare.com
