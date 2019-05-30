Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A108A30537
	for <lists+netdev@lfdr.de>; Fri, 31 May 2019 01:09:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726728AbfE3XJI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 May 2019 19:09:08 -0400
Received: from mail-qt1-f195.google.com ([209.85.160.195]:34638 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726131AbfE3XJI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 May 2019 19:09:08 -0400
Received: by mail-qt1-f195.google.com with SMTP id h1so9196860qtp.1;
        Thu, 30 May 2019 16:09:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=VsGWlAAgXK7ARM0UyCo1z+ObHcix8UI0v15itzMgAgs=;
        b=OP3KBdTFagUgJH07lGdWtzWlXEIRmW2U56cmovOgXBoCWumZLktpU5y6IEwJep4noD
         U1mNS/rrQL4V3ZKKtG3lKLP18iojhV9hc5EXXBXVmMXrpiVgohcdh1m2sS3KuWGrdKsV
         ly3u3pY95ODCqNObNVYBVbEjtufjCyzyt1e1VCXxNxEqa8OhbJ+YdjLaBIHlz9BhmbdR
         l7HgU4DMoqN4O4UWKvOnp61cWufcexJfYr2BPov0jGL+siqpM4UeYNYTneMQ1GHkQr2v
         hD5QzYHheW5Z4QloEuiic/TzpFXpKBPqCrd8i4cfkZdTeXAn9rFl9GvQSv0cBBtKg7dh
         kYZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=VsGWlAAgXK7ARM0UyCo1z+ObHcix8UI0v15itzMgAgs=;
        b=kUF3WFZgZ1ZdIVhzKIJw35kGE9bBJs7fA+aUHqRa8b2zba4ne/yiFz/krG6EGe9R5u
         GunkhgPdSSJ3BQ6RFGbH5CUokzil+Mt7Fixrbzb29WH8V0QHSeF5SOkHD5jT/MQMu9vV
         IvfgylYBPf+GXgXKOxPKWdUkXp34BPWH3kWZ1NRth2iKltA07UYRX5uHX1QSzRNQ7D4J
         3g4m6nujxWdwjPRSsljJ40wiZ/6Jyj3VcdJ/uOvUknwnuhrPbgaK3NumUSs6NOrtMs3x
         fW6UhGjzL2cVcV1WGi2nd4LHaSmBw1iUA0axI2YKqqzoUMXE9TtWby222rZPKWsSeJDz
         Wemw==
X-Gm-Message-State: APjAAAVwm3QEiuxQoZCIi8mYVIHqbFUaued4l+UItbCbWmlb1pGjWCGy
        jWumXmepcss+3/1lCcQrzPQ+ZKfyf7ymbq8rQDQ=
X-Google-Smtp-Source: APXvYqzbxFTeCMTO5x7GXFdrK925AyO/6B7goB3FrwXjSEPa+C7nAEKycPdEZA43M+BGTqaQKk8e4+HWr2f/NQVzA0w=
X-Received: by 2002:a0c:986e:: with SMTP id e43mr5917589qvd.78.1559257747089;
 Thu, 30 May 2019 16:09:07 -0700 (PDT)
MIME-Version: 1.0
References: <20190530190800.7633-1-luke.r.nels@gmail.com> <CAPhsuW4kMBSjpATqHrEhTmuqje=XZNGOrMyNur8f6K0RNQP=yw@mail.gmail.com>
 <CAB-e3NSidgz8gLRTL796A0DyRVePPjVDpSC6=gSA4hH8q6VqvQ@mail.gmail.com>
In-Reply-To: <CAB-e3NSidgz8gLRTL796A0DyRVePPjVDpSC6=gSA4hH8q6VqvQ@mail.gmail.com>
From:   Song Liu <liu.song.a23@gmail.com>
Date:   Thu, 30 May 2019 16:08:55 -0700
Message-ID: <CAPhsuW7rOzyJTac7d9PPHeWW39Hu5pV6Mk0xJr8jyr0HH=-W2A@mail.gmail.com>
Subject: Re: [PATCH 1/2] bpf, riscv: fix bugs in JIT for 32-bit ALU operations
To:     Luke Nelson <luke.r.nels@gmail.com>
Cc:     Xi Wang <xi.wang@gmail.com>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>,
        Palmer Dabbelt <palmer@sifive.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Networking <netdev@vger.kernel.org>,
        linux-riscv@lists.infradead.org, bpf <bpf@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 30, 2019 at 3:34 PM Luke Nelson <luke.r.nels@gmail.com> wrote:
>
> On Thu, May 30, 2019 at 1:53 PM Song Liu <liu.song.a23@gmail.com> wrote:
> >
> > This is a little messy. How about we introduce some helper function
> > like:
> >
> > /* please find a better name... */
> > emit_32_or_64(bool is64, const u32 insn_32, const u32 inst_64, struct
> > rv_jit_context *ctx)
> > {
> >        if (is64)
> >             emit(insn_64, ctx);
> >        else {
> >             emit(insn_32, ctx);
> >            rd = xxxx;
> >            emit_zext_32(rd, ctx);
> >        }
> > }
>
> This same check is used throughout the file, maybe clean it up in a
> separate patch?

Yes, let's do follow up patch.

Thanks,
Song
