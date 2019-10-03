Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9C8FECA003
	for <lists+netdev@lfdr.de>; Thu,  3 Oct 2019 16:03:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730054AbfJCODX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Oct 2019 10:03:23 -0400
Received: from mail-lj1-f195.google.com ([209.85.208.195]:41099 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729378AbfJCODW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Oct 2019 10:03:22 -0400
Received: by mail-lj1-f195.google.com with SMTP id f5so2887544ljg.8;
        Thu, 03 Oct 2019 07:03:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=NTLL37XAD8pU3pBUhISEGbyMqcJiQVJfDIlaSv771n4=;
        b=pj4ZnRnYzaIgLsdqk6kSOcVzt7wrjfM6HI+sArYw22kUbm2qdm/vBQf2dtm6Wio7W1
         /EemaMtXI7V9g9sid8s7kawVPS8V1kSqTELird3LSFVh/zna8n3T/Ie28PKIZAl5x9Iv
         1juMukoUFP9HGP+cBNUQ0m11F/1x7VuoCshlfFkzRvtk4ZkfTinYzkyKVPKD1EwatBgI
         FDinJ5V7cRXnjWDnkEsYv+TXkeAN70HxsKVoOvZnmjfox/pvgd03oGlbYkYmO/kfCKD5
         HT0PZUDsjFxJqrQ3IovHHskoSG8bZG27D+Pvjst1qwdYESNRphbGzTW6m0tGDOXH9xwX
         3aig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=NTLL37XAD8pU3pBUhISEGbyMqcJiQVJfDIlaSv771n4=;
        b=dmqe4l7LH9JiaGNC5pX8jgYdbDjlKhouJJUqk4U27H25+/2Wy8SMKYTNxs5Bl35TCe
         bF5FuXOOkIEJXWHouwjHJ175HjY8YIuIu9JH31Q9Lmv6tA3mj8riz6B6RKsZTOBs1Gm1
         5kxJjDGu+ueCzSchVrHklEzwqe+IvCR0Uu5hqhxMthQTK4llBX4h+6eHoSUwJtdmnmyc
         zZ7ehRsnOLoKlNOlaGNDB+mtpwGLbR4WatB5pqUdg84RbqGIhfplay0fVF3KwfZCrpfh
         FrS+wJI+nylQecFDac9TO3jIiWjNf2WTe9cRE3BeM1XN7/MaQXf8en4zjmkj3yoOda7q
         WHuA==
X-Gm-Message-State: APjAAAW4PNDEZNJNGa15vPJykxBSBjYwOYyRapr7hvIdc8JvFgddyYIx
        0uiZJZqDZuwSloAsIc1dUJSJdfoxNQjiRQfkOmtilg==
X-Google-Smtp-Source: APXvYqwRNESSylVCmAN89FvYCTyF5U5xt45Q6AVEx8Y4yHwdgeQ7KfjWyASZtygk7dvSd4c07hNEzDoJ/JjiNW1rZy8=
X-Received: by 2002:a2e:9a83:: with SMTP id p3mr6400347lji.136.1570111400163;
 Thu, 03 Oct 2019 07:03:20 -0700 (PDT)
MIME-Version: 1.0
References: <157002302448.1302756.5727756706334050763.stgit@alrua-x1>
 <E7319D69-6450-4BC3-97B1-134B420298FF@fb.com> <A754440E-07BF-4CF4-8F15-C41179DCECEF@fb.com>
 <87r23vq79z.fsf@toke.dk> <20191003105335.3cc65226@carbon>
In-Reply-To: <20191003105335.3cc65226@carbon>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Thu, 3 Oct 2019 07:03:06 -0700
Message-ID: <CAADnVQKTbaxJhkukxXM7Ue7=kA9eWsGMpnkXc=Z8O3iWGSaO0A@mail.gmail.com>
Subject: Re: [PATCH bpf-next 0/9] xdp: Support multiple programs on a single
 interface through chain calls
To:     Jesper Dangaard Brouer <brouer@redhat.com>
Cc:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        Song Liu <songliubraving@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>, Martin Lau <kafai@fb.com>,
        Yonghong Song <yhs@fb.com>,
        Marek Majkowski <marek@cloudflare.com>,
        Lorenz Bauer <lmb@cloudflare.com>,
        David Miller <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 3, 2019 at 1:53 AM Jesper Dangaard Brouer <brouer@redhat.com> wrote:
>> The xdpcap use-case is to trap any XDP return action code (and tcpdump
> via perf event ring_buffer).  For system administrators the xdpcap
> use-case is something we hear about all the time, so one of the missing
> features for XDP.  As Toke also wrote, we want to extend this to ALSO
> be-able to see/dump the packet BEFORE a given XDP program.

It sounds to me that 'xdpdump/xdpcap' (tcpdump equivalent) is
the only use case both you and Toke are advocating for.
I think such case we can do already without new kernel code:
- retrieve prog_id of the program attached to given xdp ifindex
- convert to fd
- create prog_array of one element and store that prog_fd
- create xdpump bpf prog that prints to ring buffer
  and tail_calls into that prog_array
- replace xdp prog on that ifindex

Now it see all the traffic first and existing xdp progs keep working.
What am I missing?
