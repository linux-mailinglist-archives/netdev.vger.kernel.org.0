Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1F54D102F53
	for <lists+netdev@lfdr.de>; Tue, 19 Nov 2019 23:30:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727390AbfKSWar (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Nov 2019 17:30:47 -0500
Received: from mail-qt1-f193.google.com ([209.85.160.193]:34650 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727233AbfKSWar (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Nov 2019 17:30:47 -0500
Received: by mail-qt1-f193.google.com with SMTP id i17so26615094qtq.1;
        Tue, 19 Nov 2019 14:30:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Mcw1hfLTKip+h8+06L/FqGCE8BQLqmdXe65vzkzACqM=;
        b=SE/ZcGogN0uQimCRkJfCOCUfkzBX+BfR4gOlXRuKbPV1MI7mZaYgVUs9uLrHPU3pqI
         pt5D/RW51MGsTRtMT9vUphGDtiEBOMYWUOQLp9o7KCVYFwqkFILKGYfRSWxLFVAi0hPj
         5wWZju8clxzi0JBG4qtjqbO+eJ6biCX+G2FOHVqQlgAO2gpZZB495iecUReMLycsq4EJ
         5ZIPoAg81wKeMKbrrEa0V3Y9pty/sot9uan1YqOfRrJs4Vq5Ke2BVoc+6LgN2Yy/YT39
         UaIc3/UXn7eQ9BewM77ut1TNRox0rfLQ3wtPjRdtAbXx8usDCrtpOkjeMWz55d+U7XHU
         cbTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Mcw1hfLTKip+h8+06L/FqGCE8BQLqmdXe65vzkzACqM=;
        b=EoCcv878Dpd743BShfVioiCySzhgDaK1Vo0Dpz1J4mKqGPckkkjk9aWHkWX2vbirhL
         V8yi/9Cwjxhq9xTqg6NE5e4DUwKmrHZGhELT0rqGc7ZgcMkWnt6YawyfQfF7kbDYKniO
         6mCAQbsJHuuJVOHpNEpWx373HDWwa25LOWDb8snPocIHnSgBmxTQvVo0cUu66qAUj4I7
         ZMppYE4hwOVJ7a30Zo5f92SI0aqVk6NCQA0P2EHTiBUZeOUPbNe8qBGdXl8nbX+SCWut
         FFSGIWstqvX4qbRPloWVH4kCHvMQFAuZjaFMN3fMbK3OXL2/efsAAj/rJyTyRea4BBLL
         86hg==
X-Gm-Message-State: APjAAAV0yONCuhlK1C+UPt16e7opVxo/5AD1duBlD+uJbVq37wqVBzoN
        aIRI1sCd0t7Nzs0WltGruHVCLaGKLWBFXA82TrI=
X-Google-Smtp-Source: APXvYqyE0GRRnL4lPbNjCXByG39FTsvsW4WURCuRXrGX0JR9FqMszBzE+W4XHnhlIHY1zSDzahrE0VYiBif7XqtOT84=
X-Received: by 2002:ac8:7a83:: with SMTP id x3mr175592qtr.141.1574202645781;
 Tue, 19 Nov 2019 14:30:45 -0800 (PST)
MIME-Version: 1.0
References: <20191119062151.777260-1-andriin@fb.com> <20191119221639.wygkmhkqp42fpana@ast-mbp.dhcp.thefacebook.com>
In-Reply-To: <20191119221639.wygkmhkqp42fpana@ast-mbp.dhcp.thefacebook.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 19 Nov 2019 14:30:34 -0800
Message-ID: <CAEf4BzbYFWHOmM_Lo=Z3ce2rrae6bbR-56JPDVAfSzpCc2X2gQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next] libbpf: fix call relocation offset calculation bug
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 19, 2019 at 2:16 PM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> On Mon, Nov 18, 2019 at 10:21:51PM -0800, Andrii Nakryiko wrote:
> >
> > -static __attribute__ ((noinline))
> > -int test_pkt_access_subprog2(int val, volatile struct __sk_buff *skb)
> > +__attribute__ ((noinline))
> > +int test_pkt_access_subprog2(int val, struct __sk_buff *skb)
> >  {
> >       return skb->len * val;
> >  }
>
> Did you run test_progs -n 8?

I ran all of them, but missed that number of failing tests increased.

>
> Above breaks it with:
> 10: (61) r1 = *(u32 *)(r6 +40)
> func 'test_pkt_access_subprog2' doesn't have 6-th argument
> invalid bpf_context access off=40 size=4
>
> The point of the subprog2 is to test the scenario where BTF disagress with llvm
> optimizations.
>

Yeah, right. I should keep test_pkt_access_subprog2 as static then.
Will post v2 with that change.
