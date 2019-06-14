Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AF37746246
	for <lists+netdev@lfdr.de>; Fri, 14 Jun 2019 17:14:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726164AbfFNPOF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Jun 2019 11:14:05 -0400
Received: from mail-lj1-f193.google.com ([209.85.208.193]:34618 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725808AbfFNPOE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Jun 2019 11:14:04 -0400
Received: by mail-lj1-f193.google.com with SMTP id p17so2801655ljg.1;
        Fri, 14 Jun 2019 08:14:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=MqdMYxzkiSwMRv+VXImvJdkt4bTiY1sZ1dE3S1yUxjY=;
        b=EnmKRGmHCP0dd9YCT7Sa1sRiVYY3dIOFQN63iW/HID5nI196Ye+IIbFPDbLFAw2tjc
         DSCM/UG2Qp44pxaRoiJv5uVkv0U2En2pXA3kSJMe5G+SOINKkfCzLw3gy5wdHir0ulEz
         7hb+y/ZdIE+J/Rp3mHyG/+sSH11flJuqNNNHuhjJxENX2UBM0bi+wZ/Xdvyiel0Z3Aq4
         N9hH5SmGQW+J99Nl15imoQVS0XoYywA00dN32EIJb96Da+zWd2GrGlaUqbKQlJAWsWMz
         +IyzxPtaRk+uHg0jpSLfpk5T53sa9O0eY3eUCjqaSpsh7w31kx+tDIWJr946CNrgo4fg
         2A0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=MqdMYxzkiSwMRv+VXImvJdkt4bTiY1sZ1dE3S1yUxjY=;
        b=oUmgIXdwjrC/Hx1niRSDzxwVngdIUQIH9zoTJF0I/HMrWSqf4/1m0Hu+2r3faWzydU
         w+x+gjAwExDLDONUJG7wuqLk4SniCJwLL0FX7BiQqrv2YT2Xn4bRt/yDQRNp3DTcHcdF
         tLAkbCdHbTQ40ljxS3vllAbqXm6/p0fB7D2d4GX1TieGOmzo+m/4hx0s57SzTGROqXs+
         3LU1R6UZDef53cYPHLhsqzDGryxnq+UDlf1JO3TVw10tCg8TXW59zZeM0l+VX2nvO6ji
         ucOfLLPTTHH05z1gv+h5irngUdTvZ6DNUeX7obSxleHmB+OWFMzf0Y53MNPVGywY+Qxo
         dMRw==
X-Gm-Message-State: APjAAAVb/ICrvom7xvicaBCxneBNeYdPyIjscGMi9KYRWXooaACfrO4Y
        MbB/vMcyyambWGQZk6okxaD8p3tomfTHrLFXGcg=
X-Google-Smtp-Source: APXvYqyVZDAlfPGKBUEBYyP3HR/YFNAMJJLgIQ5RjXnLqmdeAazhXaYhTHPbLX8yCDXTPOB3FWMcjFkg8PSfPbwh4LQ=
X-Received: by 2002:a2e:9dca:: with SMTP id x10mr19768948ljj.17.1560525242066;
 Fri, 14 Jun 2019 08:14:02 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1560431531.git.jpoimboe@redhat.com> <99c22bbd79e72855f4bc9049981602d537a54e70.1560431531.git.jpoimboe@redhat.com>
 <20190613205710.et5fywop4gfalsa6@ast-mbp.dhcp.thefacebook.com>
 <20190614012030.b6eujm7b4psu62kj@treble> <20190614070852.GQ3436@hirez.programming.kicks-ass.net>
 <20190614073536.d3xkhwhq3fuivwt5@ast-mbp.dhcp.thefacebook.com> <20190614081116.GU3436@hirez.programming.kicks-ass.net>
In-Reply-To: <20190614081116.GU3436@hirez.programming.kicks-ass.net>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Fri, 14 Jun 2019 08:13:49 -0700
Message-ID: <CAADnVQJ_-mFCeWoq-Uz9VRFkb3eLgAK+yC5hG=N7t5riGhmLWg@mail.gmail.com>
Subject: Re: [PATCH 2/9] objtool: Fix ORC unwinding in non-JIT BPF generated code
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     Josh Poimboeuf <jpoimboe@redhat.com>, X86 ML <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, Song Liu <songliubraving@fb.com>,
        Kairui Song <kasong@redhat.com>,
        "David S. Miller" <davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 14, 2019 at 1:11 AM Peter Zijlstra <peterz@infradead.org> wrote:
>
> On Fri, Jun 14, 2019 at 12:35:38AM -0700, Alexei Starovoitov wrote:
> > On Fri, Jun 14, 2019 at 09:08:52AM +0200, Peter Zijlstra wrote:
> > > On Thu, Jun 13, 2019 at 08:20:30PM -0500, Josh Poimboeuf wrote:
> > > > On Thu, Jun 13, 2019 at 01:57:11PM -0700, Alexei Starovoitov wrote:
> > >
> > > > > and to patches 8 and 9.
> > > >
> > > > Well, it's your code, but ... can I ask why?  AT&T syntax is the
> > > > standard for Linux, which is in fact the OS we are developing for.
> > >
> > > I agree, all assembly in Linux is AT&T, adding Intel notation only
> > > serves to cause confusion.
> >
> > It's not assembly. It's C code that generates binary and here
> > we're talking about comments.
>
> And comments are useless if they don't clarify. Intel syntax confuses.
>
> > I'm sure you're not proposing to do:
> > /* mov src, dst */
> > #define EMIT_mov(DST, SRC)                                                               \
> > right?
>
> Which is why Josh reversed both of them. The current Intel order is just
> terribly confusing. And I don't see any of the other JITs having
> confusing comments like this.
>
> > bpf_jit_comp.c stays as-is. Enough of it.
>
> I think you're forgetting this is also arch/x86 code, and no, it needs
> changes because its broken wrt unwinding.

See MAINTAINERS file.
If you guys keep insisting on pointless churn like this
we'll move arch/x86/net/ into net/ where it probably belongs.
netdev has its own comment style too.
And it is also probably confusing to some folks.
