Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 67027D62A4
	for <lists+netdev@lfdr.de>; Mon, 14 Oct 2019 14:35:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730732AbfJNMfv convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 14 Oct 2019 08:35:51 -0400
Received: from mx1.redhat.com ([209.132.183.28]:39912 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730717AbfJNMfv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 14 Oct 2019 08:35:51 -0400
Received: from mail-lf1-f71.google.com (mail-lf1-f71.google.com [209.85.167.71])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 4A3EEC0568FD
        for <netdev@vger.kernel.org>; Mon, 14 Oct 2019 12:35:50 +0000 (UTC)
Received: by mail-lf1-f71.google.com with SMTP id m24so2870123lfh.22
        for <netdev@vger.kernel.org>; Mon, 14 Oct 2019 05:35:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=PvVm8u9ObL3aYBOygBx9VWFhpRttK7ssE/n72+9xa/0=;
        b=MrVlMo68FdIfTccFfBrJ22zZpYm346N7YcTpXygyMgeRZZXkeAiJa9XX5JlvLlgfoX
         RDdyKX+5nmLkQsdKJYr4k3Qz6m0bbzkr4/sviGc3jNB/WtIkNnF1eBSfDcSgAZ1FbPSk
         pS6Lvpq9oLKJXl+k9OMwZGouwlTNHvFjOSLC6+IQYqy+8/7Nlt+Ro2/kowrULM7vrQjd
         FSNXgFt1QJdMAj9NXYxMRgmmc2qiiHex869BFFf/kRLjKTC4T5l4iPEsSnlAcoDquCG+
         /RVgkQh545DAR3RXCyOXm6CnbMQRa9k6yNnz6GS6osAhCUB51V8d5dLtrgEYLCuyazeO
         ZlxA==
X-Gm-Message-State: APjAAAURRkmn47fxFWzjVQXuDnQmRx54SekOkKHmvpolXTRCTtVGhKxe
        VCiUVqBQ12FXnoCVzx5dikSPM0EtYVrAdGGmoBv+OybEthj3U0Id/QKWHMEDFfaulsHJE7+nJWa
        BGvtDZP3Y7l9ShuSf
X-Received: by 2002:a2e:97ca:: with SMTP id m10mr16948672ljj.168.1571056548722;
        Mon, 14 Oct 2019 05:35:48 -0700 (PDT)
X-Google-Smtp-Source: APXvYqxuPCWjO7iKsWtjLdhGHxGgh+y+o7yVh8iwinIdgS/da0MWM6yCi6ZPx6BIVIe5jtwmZvf8FA==
X-Received: by 2002:a2e:97ca:: with SMTP id m10mr16948656ljj.168.1571056548487;
        Mon, 14 Oct 2019 05:35:48 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk (borgediget.toke.dk. [85.204.121.218])
        by smtp.gmail.com with ESMTPSA id n5sm4971168ljh.54.2019.10.14.05.35.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Oct 2019 05:35:47 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id ADBD818063D; Mon, 14 Oct 2019 14:35:45 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
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
In-Reply-To: <20191010044156.2hno4sszysu3c35g@ast-mbp.dhcp.thefacebook.com>
References: <157046883502.2092443.146052429591277809.stgit@alrua-x1> <157046883614.2092443.9861796174814370924.stgit@alrua-x1> <20191007204234.p2bh6sul2uakpmnp@ast-mbp.dhcp.thefacebook.com> <87sgo3lkx9.fsf@toke.dk> <20191009015117.pldowv6n3k5p3ghr@ast-mbp.dhcp.thefacebook.com> <87o8yqjqg0.fsf@toke.dk> <20191010044156.2hno4sszysu3c35g@ast-mbp.dhcp.thefacebook.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Mon, 14 Oct 2019 14:35:45 +0200
Message-ID: <87v9srijxa.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Alexei Starovoitov <alexei.starovoitov@gmail.com> writes:

> On Wed, Oct 09, 2019 at 10:03:43AM +0200, Toke Høiland-Jørgensen wrote:
>> Alexei Starovoitov <alexei.starovoitov@gmail.com> writes:
>> 
>> > Please implement proper indirect calls and jumps.
>> 
>> I am still not convinced this will actually solve our problem; but OK, I
>> can give it a shot.
>
> If you're not convinced let's talk about it first.
>
> Indirect calls is a building block for debugpoints.
> Let's not call them tracepoints, because Linus banned any discusion
> that includes that name.
> The debugpoints is a way for BPF program to insert points in its
> code to let external facility to do tracing and debugging.
>
> void (*debugpoint1)(struct xdp_buff *, int code);
> void (*debugpoint2)(struct xdp_buff *);
> void (*debugpoint3)(int len);

So how would these work? Similar to global variables (i.e., the loader
creates a single-entry PROG_ARRAY map for each one)? Presumably with
some BTF to validate the argument types?

So what would it take to actually support this? It doesn't quite sound
trivial to add?

> Essentially it's live debugging (tracing) of cooperative bpf programs
> that added debugpoints to their code.

Yup, certainly not disputing that this would be useful for debugging;
although it'll probably be a while before its use becomes widespread
enough that it'll be a reliable tool for people deploying XDP programs...

> Obviously indirect calls can be used for a ton of other things
> including proper chaing of progs, but I'm convinced that
> you don't need chaining to solve your problem.
> You need debugging.

Debugging is certainly also an area that I want to improve. However, I
think that focusing on debugging as the driver for chaining programs was
a mistake on my part; rudimentary debugging (using a tool such as
xdpdump) is something that falls out of program chaining, but it's not
the main driver for it.

> If you disagree please explain _your_ problem again.
> Saying that fb katran is a use case for chaining is, hrm, not correct.

I never said Katran was the driver for this. I just used Katran as one
of the "prior art" examples for my "how are people solving running
multiple programs on the same interface" survey.

What I want to achieve is simply the ability to run multiple independent
XDP programs on the same interface, without having to put any
constraints on the programs themselves. I'm not disputing that this is
*possible* to do completely in userspace, I just don't believe the
resulting solution will be very good. Proper kernel support for indirect
calls (or just "tail calls that return") may change that; but in any
case I think I need to go write some userspace code to have some more
concrete examples to discuss from. So we can come back to the
particulars once I've done that :)

-Toke
