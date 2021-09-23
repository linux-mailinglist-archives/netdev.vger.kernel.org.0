Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E3F16415C03
	for <lists+netdev@lfdr.de>; Thu, 23 Sep 2021 12:33:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240432AbhIWKfR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Sep 2021 06:35:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231392AbhIWKfQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Sep 2021 06:35:16 -0400
Received: from mail-lf1-x12a.google.com (mail-lf1-x12a.google.com [IPv6:2a00:1450:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2AC9C061756
        for <netdev@vger.kernel.org>; Thu, 23 Sep 2021 03:33:44 -0700 (PDT)
Received: by mail-lf1-x12a.google.com with SMTP id m3so24892192lfu.2
        for <netdev@vger.kernel.org>; Thu, 23 Sep 2021 03:33:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=5ot6PH+gktYEISzCciV76Q6e/fmUSTf+WP29K4ilp2Q=;
        b=SUPsR6hhiJ072d+8E6Yzl6i5Ym+/AhcFu5yoBoSFix8pOFBlaOBKX1XqI445qNWH6F
         53hR4k3ABfxwfTYeK7LNwPz+XruldNXOWy4U64WSQroTx/hvqIQm66EQXtaKqm54dYHy
         JvPqW9/pCy3Z63YzhUCG0ClWaKTYsigfAESzo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=5ot6PH+gktYEISzCciV76Q6e/fmUSTf+WP29K4ilp2Q=;
        b=hb05JmY74iVdo2EuAmmAHLYaXbVqWj/jqEscBMz1HWWkUNFB656fra9pi3yUZqa7pD
         YZZ6sWEDi3nrxiba2wFEjLOb6hipHgFtERdQPBoDsg89QEP8UKU+T3ZFeZrbKAJq86L/
         2qiSPLHc8PWi/m3NYuqE/DPGxIwAloj5attQu5aAWTAKLzzb4LGFFt2vCZad9yLJ92/R
         XlO+xBEV2OD/LBspD3rUbdScNqd7wIvnrWwkKHHrqzeCuYbuQAhxsiYq0Mry09plg+Fe
         yzoZnu8XF4IW2w6hUMXvOUfaWp6potR/jDlHmBmVTbky4PKAEedW5ARFnbMltvQlgnXz
         FH4Q==
X-Gm-Message-State: AOAM533uUgbJsDrgCUV/lTVRwuhsyhexDDOcuo3p/gxn2xVT98QHVjJL
        vlqstmTVywdB7rpocjwT4M+Q7Kj9duD4xA1QKpjIuw==
X-Google-Smtp-Source: ABdhPJxnppm8F+8QGu58fQbjkPrXIDtcj5GlfwdtYGyad57i8DELRCX5sYZnmg/WU/Okl1vISllFrZU+uo7ZkluteN8=
X-Received: by 2002:a2e:85cb:: with SMTP id h11mr4528997ljj.111.1632393223115;
 Thu, 23 Sep 2021 03:33:43 -0700 (PDT)
MIME-Version: 1.0
References: <87o88l3oc4.fsf@toke.dk>
In-Reply-To: <87o88l3oc4.fsf@toke.dk>
From:   Lorenz Bauer <lmb@cloudflare.com>
Date:   Thu, 23 Sep 2021 11:33:31 +0100
Message-ID: <CACAyw99+KvsJGeqNE09VWHrZk9wKbQTg3h1h2LRmJADD5En2nQ@mail.gmail.com>
Subject: Re: Redux: Backwards compatibility for XDP multi-buff
To:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>
Cc:     Lorenzo Bianconi <lbianconi@redhat.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        John Fastabend <john.fastabend@gmail.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 21 Sept 2021 at 17:06, Toke H=C3=B8iland-J=C3=B8rgensen <toke@redha=
t.com> wrote:
>
> Hi Lorenz (Cc. the other people who participated in today's discussion)
>
> Following our discussion at the LPC session today, I dug up my previous
> summary of the issue and some possible solutions[0]. Seems no on
> actually replied last time, which is why we went with the "do nothing"
> approach, I suppose. I'm including the full text of the original email
> below; please take a look, and let's see if we can converge on a
> consensus here.

Hi Toke,

Thanks for looping me in again. A bit of context what XDP at
Cloudflare looks like:

* We have a chain of XDP programs attached to a real network device.
This implements DDoS protection and L4 load balancing. This is
maintained by the team I am on.
* We have hundreds of network namespaces with veth that have XDP
attached to them. Traffic is routed from the root namespace into
these. This is maintained by the Magic Transit team, see this talk
from last year's LPC [1]
I'll try to summarise what I've picked up from the thread and add my
own 2c. Options being considered:

1. Make sure mb-aware and mb-unaware programs don't mix.

This could either be in the form of a sysctl or a dynamic property
similar to a refcount. We'd need to discern mb-aware from mb-unaware
somehow, most easily via a new program type. This means recompiling
existing programs (but then we expect that to be necessary anyways).
We'd also have to be able to indicate "mb-awareness" for freplace
programs.

The implementation complexity seems OK, but operator UX is not good:
it's not possible to slowly migrate a system to mb-awareness, it has
to happen in one fell swoop. This would be really problematic for us,
since we already have multiple teams writing and deploying XDP
independently of each other. This number is only going to grow. It
seems there will also be trickiness around redirecting into different
devices? Not something we do today, but it's kind of an obvious
optimization to start redirecting into network namespaces from XDP
instead of relying on routing.

2. Add a compatibility shim for mb-unaware programs receiving an mb frame.

We'd still need a way to indicate "MB-OK", but it could be a piece of
metadata on a bpf_prog. Whatever code dispatches to an XDP program
would have to include a prologue that linearises the xdp_buff if
necessary which implies allocating memory. I don't know how hard it is
to implement this. There is also the question of freplace: do we
extend linearising to them, or do they have to support MB?

You raised an interesting point: couldn't we hit programs that can't
handle data_end - data being above a certain length? I think we (=3D
Cloudflare) actually have one of those, since we in some cases need to
traverse the entire buffer to calculate a checksum (we encapsulate
UDPv4 in IPv6, don't ask). Turns out it's actually really hard to
calculate the checksum on a variable length packet in BPF so we've had
to introduce limits. However, this case isn't too important: we made
this choice consciously, knowing that MTU changes would break it.

Other than that I like this option a lot: mb-aware and mb-unaware
programs can co-exist, at the cost of performance. This allows
gradually migrating to our stack so that it can handle jumbo frames.

3. Make non-linearity invisible to the BPF program

Something I've wished for often is that I didn't have to deal with
nonlinearity at all, based on my experience with cls_redirect [2].
It's really hard to write a BPF program that handles non-linear skb,
especially when you have to call adjust_head, etc. which invalidates
packet buffers. This is probably impossible, but maybe someone has a
crazy idea? :)

Lorenz

1: https://youtu.be/UkvxPyIJAko?t=3D10057
2: https://elixir.bootlin.com/linux/latest/source/tools/testing/selftests/b=
pf/progs/test_cls_redirect.c

--=20
Lorenz Bauer  |  Systems Engineer
6th Floor, County Hall/The Riverside Building, SE1 7PB, UK

www.cloudflare.com
