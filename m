Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E3C88D69B5
	for <lists+netdev@lfdr.de>; Mon, 14 Oct 2019 20:48:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732484AbfJNSsU convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 14 Oct 2019 14:48:20 -0400
Received: from mx1.redhat.com ([209.132.183.28]:38958 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731506AbfJNSsT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 14 Oct 2019 14:48:19 -0400
Received: from mail-lf1-f72.google.com (mail-lf1-f72.google.com [209.85.167.72])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id F304A10B78
        for <netdev@vger.kernel.org>; Mon, 14 Oct 2019 18:48:18 +0000 (UTC)
Received: by mail-lf1-f72.google.com with SMTP id z7so3011587lfj.19
        for <netdev@vger.kernel.org>; Mon, 14 Oct 2019 11:48:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=SRp89eOkih07vlksGf3v7HdYTJDHBKxtvHAyxS+uWvk=;
        b=acjk1nzWzgMS1DVjPX5fMK5fEFxGs2uywfWiniGGUyU6uf6+nVpJ9jeHAjaOP/wl87
         WVRNUNQNnOm3Rp0sO5ihwSYogxlMjyH2tgG9pNn+4zygxmziLKJxqLvPQJp/Tt5f+HNV
         oOoYX/yGvd0Kw7ZYtzFCQMpeUl9sgd0YlhJZJvS7DUQe19gJAOTxfbVlQDHP1FoGF7e9
         jTocgo229FLt+1MwZPYi0opYc27kcsWKZiYaubyDbE7z8DcFVUt7VZO72KocG5TTqHw7
         dgqC6iJBRry46sw+vRcseJQWlPQPouDFfY/tcmu+nIoeeb84ZW0CucV7Mp4qaELF8f+a
         tFZg==
X-Gm-Message-State: APjAAAXPLiMg4IGpZZviWz5DeoOkYQfFuQ1DdygPKBP93Jaa46DbK6OI
        RQTQbr4ttXfGMbpORfiMjd9Zyg6F2b3Zd7wYOx/I/RM05MuCvROx5eS5YYGht0K5fnxRCl/Dx5A
        p8e2by49Q7EZtaE/B
X-Received: by 2002:ac2:5595:: with SMTP id v21mr6072063lfg.168.1571078897499;
        Mon, 14 Oct 2019 11:48:17 -0700 (PDT)
X-Google-Smtp-Source: APXvYqzOOF4YrrolnbdkbUjAC120HAMxIzIpiWYEd9uyfcdN8vtAlgp3lZ8njSA3TC+LCPKqU6ClmQ==
X-Received: by 2002:ac2:5595:: with SMTP id v21mr6072048lfg.168.1571078897318;
        Mon, 14 Oct 2019 11:48:17 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([2a00:7660:6da:443::2])
        by smtp.gmail.com with ESMTPSA id l5sm4280420lfk.17.2019.10.14.11.48.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Oct 2019 11:48:16 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id A38F118063D; Mon, 14 Oct 2019 20:48:15 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     John Fastabend <john.fastabend@gmail.com>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Marek Majkowski <marek@cloudflare.com>,
        Lorenz Bauer <lmb@cloudflare.com>,
        Alan Maguire <alan.maguire@oracle.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: Re: [PATCH bpf-next v3 1/5] bpf: Support chain calling multiple BPF programs after each other
In-Reply-To: <5da4ab712043c_25f42addb7c085b83b@john-XPS-13-9370.notmuch>
References: <157046883502.2092443.146052429591277809.stgit@alrua-x1> <157046883614.2092443.9861796174814370924.stgit@alrua-x1> <20191007204234.p2bh6sul2uakpmnp@ast-mbp.dhcp.thefacebook.com> <87sgo3lkx9.fsf@toke.dk> <20191009015117.pldowv6n3k5p3ghr@ast-mbp.dhcp.thefacebook.com> <87o8yqjqg0.fsf@toke.dk> <20191010044156.2hno4sszysu3c35g@ast-mbp.dhcp.thefacebook.com> <87v9srijxa.fsf@toke.dk> <5da4ab712043c_25f42addb7c085b83b@john-XPS-13-9370.notmuch>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Mon, 14 Oct 2019 20:48:15 +0200
Message-ID: <87eezfi2og.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

John Fastabend <john.fastabend@gmail.com> writes:

> Toke Høiland-Jørgensen wrote:
>> Alexei Starovoitov <alexei.starovoitov@gmail.com> writes:
>> 
>> > On Wed, Oct 09, 2019 at 10:03:43AM +0200, Toke Høiland-Jørgensen wrote:
>> >> Alexei Starovoitov <alexei.starovoitov@gmail.com> writes:
>> >> 
>> >> > Please implement proper indirect calls and jumps.
>> >> 
>> >> I am still not convinced this will actually solve our problem; but OK, I
>> >> can give it a shot.
>> >
>> > If you're not convinced let's talk about it first.
>> >
>> > Indirect calls is a building block for debugpoints.
>> > Let's not call them tracepoints, because Linus banned any discusion
>> > that includes that name.
>> > The debugpoints is a way for BPF program to insert points in its
>> > code to let external facility to do tracing and debugging.
>> >
>> > void (*debugpoint1)(struct xdp_buff *, int code);
>> > void (*debugpoint2)(struct xdp_buff *);
>> > void (*debugpoint3)(int len);
>
> I was considering some basic static linking from libbpf side. Something
> like,
>
>   bpf_object__link_programs(struct bpf_object *obj1, struct bpf_object *obj2);
>
> This way you could just 'link' in debugpoint{1,2,3} from libbpf before
> loading? This would be useful on my side for adding/removing features
> and handling different kernel versions. So more generally useful IMO.

So that will end up with a single monolithic BPF program being loaded
(from the kernel PoV), right? That won't do; we want to be able to go
back to the component programs, and manipulate them as separate kernel
objects.

-Toke
