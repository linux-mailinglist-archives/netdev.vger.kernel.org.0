Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4983A3C19AB
	for <lists+netdev@lfdr.de>; Thu,  8 Jul 2021 21:14:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229795AbhGHTRS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Jul 2021 15:17:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:42818 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229497AbhGHTRR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 8 Jul 2021 15:17:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8FE046143F;
        Thu,  8 Jul 2021 19:14:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625771675;
        bh=bz8Nw2UsTARfBh4O5eANMEUJxwSoES20lehw6GKPMDI=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=EGX/N2DyVR/lWsY4Asj9I3IMSKHr7pQrJzkS2UqOvFjnlbRxYMBa9qh9pdHyykydZ
         4YB/M0pUCPqlCOTW7ocMg1ZwYDURhIiUuZH4dGCnbh6UFUSoiWtrG7/bG44o1rfiOP
         ZPnjt+WHhLm8zCseRTNDVfrJcMjDfN3mOgwSGOgI3qL9M8WAdHv0KIJHJSSFjoxfcE
         7sJq/MeT0j0Le0URFPUJ3KY+wkhLGcL1blK6hDOuUS/y1gl6FvQG4iRh/w0iy1s/NM
         9o363VnvJFero6Z4sTzq6Mdad3cahkAbVLbSczGH/h0wZRwVely6eDUbxFzJmbZD47
         TyvCkCdY+bfjQ==
Received: by mail-lf1-f41.google.com with SMTP id f30so18345899lfj.1;
        Thu, 08 Jul 2021 12:14:35 -0700 (PDT)
X-Gm-Message-State: AOAM530gbM0hB5tVGi9XiqFzai/pfGXQit3o0zHC3tHXaj+Hv1q1IiWg
        0fNkKSPNkn+2zOQVTXXu1NePev9PfHQvV2Y9tdE=
X-Google-Smtp-Source: ABdhPJzLrjcE/kx4lv2a2xRFhxdgPyTqAZL9YJddyxzHJ43s2Nt5GjOqS+S7xLgDQHl3reyKdbF8OZ7bMhhGu85etbc=
X-Received: by 2002:ac2:5c0d:: with SMTP id r13mr24449296lfp.438.1625771673910;
 Thu, 08 Jul 2021 12:14:33 -0700 (PDT)
MIME-Version: 1.0
References: <20210708080409.73525-1-xuanzhuo@linux.alibaba.com>
 <c314bdcc-06fc-c869-5ad8-a74173a1e6f1@redhat.com> <f52ae16f-ee2b-c691-311a-51824c2d87e9@gmail.com>
In-Reply-To: <f52ae16f-ee2b-c691-311a-51824c2d87e9@gmail.com>
From:   Song Liu <song@kernel.org>
Date:   Thu, 8 Jul 2021 12:14:22 -0700
X-Gmail-Original-Message-ID: <CAPhsuW5fR71O7FoeGaXpboAiJhQaYT+GAxgZ-h4Ue_CHGE0OgA@mail.gmail.com>
Message-ID: <CAPhsuW5fR71O7FoeGaXpboAiJhQaYT+GAxgZ-h4Ue_CHGE0OgA@mail.gmail.com>
Subject: Re: [PATCH bpf] bpf: fix for BUG: kernel NULL pointer dereference,
 address: 0000000000000000
To:     David Ahern <dsahern@gmail.com>
Cc:     Jesper Dangaard Brouer <jbrouer@redhat.com>,
        Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
        bpf <bpf@vger.kernel.org>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Abaci <abaci@linux.alibaba.com>,
        Dust Li <dust.li@linux.alibaba.com>,
        David Ahern <dsahern@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 8, 2021 at 7:45 AM David Ahern <dsahern@gmail.com> wrote:
>
> On 7/8/21 4:26 AM, Jesper Dangaard Brouer wrote:
> >
> > Thanks for catching this.
> >
> > Cc: Ahern, are you okay with disabling this for the
> > bpf_prog_test_run_xdp() infra?
>
> yes.
>
> >
> > I don't think the selftests/bpf (e.g. prog_tests/xdp_devmap_attach.c)
> > use the bpf_prog_test_run, right?
> >
> > Acked-by: Jesper Dangaard Brouer <brouer@redhat.com>
>
>
> Acked-by: David Ahern <dsahern@kernel.org>

Acked-by: Song Liu <songliubraving@fb.com>
