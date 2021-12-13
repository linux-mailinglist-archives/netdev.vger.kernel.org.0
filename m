Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 938584731BB
	for <lists+netdev@lfdr.de>; Mon, 13 Dec 2021 17:27:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240755AbhLMQ1B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Dec 2021 11:27:01 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:43394 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S240827AbhLMQ05 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Dec 2021 11:26:57 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1639412816;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=xStP3+7Ro9V0luE32DgT7Hp9RicdgEwCYJfQCO89zJk=;
        b=DNtY4cL5v8qeyyAKtpkbEk6RXepIXZaRgREMO81gMTbZsMM7nQtxS04fcTXBP/6ua1THWn
        XjSwonZbaxUGJo+LGAKFqXPG6QMInrOjG8PCsq8OQ/DS+60HLiEnnDt5BCQrbX82/6Ie/e
        U7fvkibnhR5p3bUYuHEx41n2xd3mg0k=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-569-7Q9iqZSlPtK8dQTzW73gPQ-1; Mon, 13 Dec 2021 11:26:53 -0500
X-MC-Unique: 7Q9iqZSlPtK8dQTzW73gPQ-1
Received: by mail-ed1-f70.google.com with SMTP id q17-20020aa7da91000000b003e7c0641b9cso14393971eds.12
        for <netdev@vger.kernel.org>; Mon, 13 Dec 2021 08:26:53 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=xStP3+7Ro9V0luE32DgT7Hp9RicdgEwCYJfQCO89zJk=;
        b=PGKSNLMVJEi+WJuZJVwUIBh4PYYdoBOcF/f80Bd1FG1FdAJZAh/RDNCC8G7BHw1qKo
         V8NfC2AbKrSwc4P0oYpWFaWkiLO84BXxOnbkSLNzB+OzjB/voQSMFtW+RCKHX1ih408a
         eLN/Jt+bQ3rH92bsJ0VaCA8jhrGFIcLDRCunRmzkA26B88ne2uPPUK/lq6x0ZGVZ23lJ
         whOvSMNQV88cnu0YQStvilKBOdTttrg5NM9i5dCrRX4hxuVqy5ekzRYE817s3ZRocvl0
         k4xNHOwibhs4bnXlLQmluL0n7olKW1h1+t/WQ5zAZB/dvnvrgg86KT2aDQ4m6Csi76L+
         hGUQ==
X-Gm-Message-State: AOAM531CumSQqF/sImFt+5skMKgeOZ47QGmCzXmfnx/470guM6a67fCS
        /3asXQRReUa8SABvdlOO9tEIHN0cdMtdB1IjACR8cNrLcH+7m4+bzWDT7+2tLYleHDdFr8Mt7Fe
        cA6e+yJVUVQrN1KX3
X-Received: by 2002:a17:907:160c:: with SMTP id hb12mr44802248ejc.460.1639412811994;
        Mon, 13 Dec 2021 08:26:51 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwqepGzhbcfvTvErYJ74zZ/4uLaabIGMemsbkGr36u0LTcJroOlW5D/IdsKyygsqQTSDTYOTw==
X-Received: by 2002:a17:907:160c:: with SMTP id hb12mr44802199ejc.460.1639412811649;
        Mon, 13 Dec 2021 08:26:51 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id t5sm6662646edd.68.2021.12.13.08.26.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Dec 2021 08:26:51 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 716CF183553; Mon, 13 Dec 2021 17:26:50 +0100 (CET)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>
Subject: Re: [PATCH bpf-next v3 6/8] bpf: Add XDP_REDIRECT support to XDP
 for bpf_prog_run()
In-Reply-To: <CAADnVQJYfyHs41H1x-1wR5WVSX+3ju69XMUQ4id5+1DLkTVDkg@mail.gmail.com>
References: <20211211184143.142003-1-toke@redhat.com>
 <20211211184143.142003-7-toke@redhat.com>
 <CAADnVQJYfyHs41H1x-1wR5WVSX+3ju69XMUQ4id5+1DLkTVDkg@mail.gmail.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Mon, 13 Dec 2021 17:26:50 +0100
Message-ID: <87tufceaid.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Alexei Starovoitov <alexei.starovoitov@gmail.com> writes:

> On Sat, Dec 11, 2021 at 10:43 AM Toke H=C3=B8iland-J=C3=B8rgensen <toke@r=
edhat.com> wrote:
>> +
>> +static void bpf_test_run_xdp_teardown(struct bpf_test_timer *t)
>> +{
>> +       struct xdp_mem_info mem =3D {
>> +               .id =3D t->xdp.pp->xdp_mem_id,
>> +               .type =3D MEM_TYPE_PAGE_POOL,
>> +       };
>
> pls add a new line.
>
>> +       xdp_unreg_mem_model(&mem);
>> +}
>> +
>> +static bool ctx_was_changed(struct xdp_page_head *head)
>> +{
>> +       return (head->orig_ctx.data !=3D head->ctx.data ||
>> +               head->orig_ctx.data_meta !=3D head->ctx.data_meta ||
>> +               head->orig_ctx.data_end !=3D head->ctx.data_end);
>
> redundant ()
>
>>         bpf_test_timer_enter(&t);
>>         old_ctx =3D bpf_set_run_ctx(&run_ctx.run_ctx);
>>         do {
>>                 run_ctx.prog_item =3D &item;
>> -               if (xdp)
>> +               if (xdp && xdp_redirect) {
>> +                       ret =3D bpf_test_run_xdp_redirect(&t, prog, ctx);
>> +                       if (unlikely(ret < 0))
>> +                               break;
>> +                       *retval =3D ret;
>> +               } else if (xdp) {
>>                         *retval =3D bpf_prog_run_xdp(prog, ctx);
>
> Can we do this unconditionally without introducing a new uapi flag?
> I mean "return bpf_redirect()" was a nop under test_run.
> What kind of tests might break if it stops being a nop?

Well, I view the existing mode of bpf_prog_test_run() with XDP as a way
to write XDP unit tests: it allows you to submit a packet, run your XDP
program on it, and check that it returned the right value and did the
right modifications. This means if you XDP program does 'return
bpf_redirect()', userspace will still get the XDP_REDIRECT value and so
it can check correctness of your XDP program.

With this flag the behaviour changes quite drastically, in that it will
actually put packets on the wire instead of getting back the program
return. So I think it makes more sense to make it a separate opt-in
mode; the old behaviour can still be useful for checking XDP program
behaviour.

-Toke

