Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D51C91270FD
	for <lists+netdev@lfdr.de>; Thu, 19 Dec 2019 23:56:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727167AbfLSW4Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Dec 2019 17:56:16 -0500
Received: from mail-qk1-f194.google.com ([209.85.222.194]:42145 "EHLO
        mail-qk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727128AbfLSW4Q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Dec 2019 17:56:16 -0500
Received: by mail-qk1-f194.google.com with SMTP id z14so4816762qkg.9;
        Thu, 19 Dec 2019 14:56:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=iXkUlTxofge+68S2qKmExLsxr3C16B8BqGTQ8GuFZgI=;
        b=edzARg7FRmRjK8jc/6g1M52nIVC9TD768eyTajC07EAzIgkfV1q/iUQ8fa7GtXGlZL
         P24zYCZn34G9CmNdk8speQm70yeD3IuwhBn0JNCSjzYC7wA5jM+z5WaozMdR5Ua9MTbf
         ZZogQyJrGzWIrdx640+uVIr7nLQTXZsK1fzfYxi0hR5T97BNCdkjlgCnfRaMsPxX2D6n
         IcbERZ/deM7Cmul5gC9PZo/jAu771Cs63rTdDA8e69K+pKtCcMdI36khweGnsBdYMh3D
         zO5zDfm22MVQpPAxFfbyV6p8PbPG/S3VCpL21zUwxuYCLh+ZFiQoBn8PLn0/YL49Bxmx
         898Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=iXkUlTxofge+68S2qKmExLsxr3C16B8BqGTQ8GuFZgI=;
        b=cCt37rWtKeIuVWkSxp9fWnO/pMo7byUYzZ0ScbvR1QFcsh6xAXv2JtPmK59OW3tAiD
         DGoWxyJxRZPFJgiHN+Q9j2HGQZ9DXrfWgKPDE83SlVnXiP67br8UH7AujR2HfvGjA4dN
         7Mi7Ee0MX7H7rXGyh+gAOE4XOHfN6fFx17PsvOYrNR8NtadiZlJ9FdZOTnDCJQh6t6yw
         uenrdIkYLPo4+96U+fg+iyWqfWB3oQiRIbAnJoI8IkVqI0HpUoChiD0CKr5vAPF9AZrW
         Uhuxc7GctQ2ZZsZQ0KG3u0E8eSMfaMp459afNiapB91Km1L28P9ZKLxIkHWmo3uDMxeQ
         JCuw==
X-Gm-Message-State: APjAAAWy/qqytUhPj6/OGpCVRYP55GOO44CWSI7t48ayMyO3xU/0i1KL
        9U8QO0YzeVvjJ5kZlq/CbEEvi9gNvTKB3omYStk=
X-Google-Smtp-Source: APXvYqxrPUSTJd6lMN61zhFOPOHy5CHGsb5RT8jePCy4kBXJfSO+CQBnlh8pigD+DrdQ7s9O+HBlGhywyqV3eNVhldk=
X-Received: by 2002:ae9:e809:: with SMTP id a9mr10703636qkg.92.1576796175099;
 Thu, 19 Dec 2019 14:56:15 -0800 (PST)
MIME-Version: 1.0
References: <20191218105400.2895-1-bjorn.topel@gmail.com> <20191218121132.4023f4f1@carbon>
 <CAJ+HfNgKsPN7V9r=N=hDoVb23-nk3q=y+Nv4jB3koPw0+4Zw9A@mail.gmail.com>
 <20191218130346.1a346606@carbon> <CAEf4BzZab=FvCuvKOKsj0M5RRoGuuXW2ME5EoDuqT8sJOd2Xtg@mail.gmail.com>
 <20191219203329.75d4bead@carbon> <4e5cb0b0-14b9-5de9-4346-e4c2955e99a0@iogearbox.net>
In-Reply-To: <4e5cb0b0-14b9-5de9-4346-e4c2955e99a0@iogearbox.net>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 19 Dec 2019 14:56:04 -0800
Message-ID: <CAEf4Bzb0=Uwf0V1u2k4cvucAnEFxG-g_TYcy6YZHUCACgiNFyg@mail.gmail.com>
Subject: Re: [PATCH bpf-next 0/8] Simplify xdp_do_redirect_map()/xdp_do_flush_map()
 and XDP maps
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     Jesper Dangaard Brouer <brouer@redhat.com>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>,
        Netdev <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>, bpf <bpf@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        John Fastabend <john.fastabend@gmail.com>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Maciej Fijalkowski <maciejromanfijalkowski@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 19, 2019 at 12:08 PM Daniel Borkmann <daniel@iogearbox.net> wro=
te:
>
> On 12/19/19 8:33 PM, Jesper Dangaard Brouer wrote:
> > On Wed, 18 Dec 2019 16:39:08 -0800
> > Andrii Nakryiko <andrii.nakryiko@gmail.com> wrote:
> >
> >> On Wed, Dec 18, 2019 at 4:04 AM Jesper Dangaard Brouer
> >> <brouer@redhat.com> wrote:
> >>>
> >>> On Wed, 18 Dec 2019 12:39:53 +0100
> >>> Bj=C3=B6rn T=C3=B6pel <bjorn.topel@gmail.com> wrote:
> >>>
> >>>> On Wed, 18 Dec 2019 at 12:11, Jesper Dangaard Brouer <brouer@redhat.=
com> wrote:
> >>>>>
> >>>>> On Wed, 18 Dec 2019 11:53:52 +0100
> >>>>> Bj=C3=B6rn T=C3=B6pel <bjorn.topel@gmail.com> wrote:
> >>>>>
> >>>>>>    $ sudo ./xdp_redirect_cpu --dev enp134s0f0 --cpu 22 xdp_cpu_map=
0
> >>>>>>
> >>>>>>    Running XDP/eBPF prog_name:xdp_cpu_map5_lb_hash_ip_pairs
> >>>>>>    XDP-cpumap      CPU:to  pps            drop-pps    extra-info
> >>>>>>    XDP-RX          20      7723038        0           0
> >>>>>>    XDP-RX          total   7723038        0
> >>>>>>    cpumap_kthread  total   0              0           0
> >>>>>>    redirect_err    total   0              0
> >>>>>>    xdp_exception   total   0              0
> >>>>>
> >>>>> Hmm... I'm missing some counters on the kthread side.
> >>>>>
> >>>>
> >>>> Oh? Any ideas why? I just ran the upstream sample straight off.
> >>>
> >>> Looks like it happened in commit: bbaf6029c49c ("samples/bpf: Convert
> >>> XDP samples to libbpf usage") (Cc Maciej).
> >>>
> >>> The old bpf_load.c will auto attach the tracepoints... for and libbpf
> >>> you have to be explicit about it.
> >>
> >> ... or you can use skeleton, which will auto-attach them as well,
> >> provided BPF program's section names follow expected naming
> >> convention. So it might be a good idea to try it out.
> >
> > To Andrii, can you provide some more info on how to use this new
> > skeleton system of yours?  (Pointers to code examples?)
>
> There's a man page ;-)
>
> https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next.git/tree/too=
ls/bpf/bpftool/Documentation/bpftool-gen.rst

Also see runqslower patch set for end-to-end set up. There are a bunch
of selftests already using skeletons (test_attach_probe,
test_core_extern, test_skeleton).
