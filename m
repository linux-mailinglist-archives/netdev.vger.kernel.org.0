Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6DD9D1C62B0
	for <lists+netdev@lfdr.de>; Tue,  5 May 2020 23:12:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728853AbgEEVL7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 May 2020 17:11:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726350AbgEEVL7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 May 2020 17:11:59 -0400
Received: from mail-qt1-x841.google.com (mail-qt1-x841.google.com [IPv6:2607:f8b0:4864:20::841])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10AFCC061A0F;
        Tue,  5 May 2020 14:11:59 -0700 (PDT)
Received: by mail-qt1-x841.google.com with SMTP id o10so3332180qtr.6;
        Tue, 05 May 2020 14:11:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=pRITrxLwd+iqZS/lP4GYupH2XmYqIA8+NeaA7b9Uc3s=;
        b=QSzkymkaIXuFsPHV0wuPSS9QpU5PfeZ4q2Xm4ELLJHnIhIjuf9Fv3D+lQXtvbqJ4ZY
         y9XszdiuCvm4FrV8glVmg+cNaII9SM5SegD4YoMysvNYQ9GWtkCUl5+O+MY0Ho0XHa+d
         kF+fs/al7Xi6SH7X8U37BtjK15UdKvKXHuGM/Y0LOZ+5UjORFlUZQiuIhdSIweydTDNl
         8naOYSxOXIC/jnzYjo4RVua0hVJiC3lghqHosxfey0IO4sBkuI0fIBYbdCnGDhYDnUne
         StkyUtxURnJXL/LPqbXGS2wYiLTjjO4cevW1tYJ+69CMpcvuUh1bwvB5acKt4MrUvqAW
         1GQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=pRITrxLwd+iqZS/lP4GYupH2XmYqIA8+NeaA7b9Uc3s=;
        b=FFyW40KDDz9pOpPipL3NEIiY8klkNeBWq+JjViEOf8H96L74BKPcR35eE69a29I185
         rXkrUmrO8M7Y/IydF4B48nbnAKSF+mLnxlp6G+lIaEKfl/uQn0KkK4N9Zf6Y5YOH7Hsj
         rOzhT5XQU/NXQnRJqOBdyIAq8I4u8YDQgX5/4DSKTdLxuApVl/Y4NRTVJJDtbV0l93Ji
         +CqwsC8yJHMms+J0vQ65RUpfTM8RIXUFro6+/WPCcCcnLx/QVqvG3oSZAosuuMwI9T9c
         78etdyiNNs3Nmb/CdA6AlE3FYvccODE565xGYBcS40Bv1ZBXRRi22mYK8usPT4vnzozV
         Y5xw==
X-Gm-Message-State: AGi0PuZ90U3/LqesdqbfibOh0v3F8odTrV5k+gNRb+46q4dkpNXWbxwW
        DDqeEwT0kIf5vIYXvj4deZzkzNjwR76X7lzwISo=
X-Google-Smtp-Source: APiQypLEG5sW607s2DhnamkwUe9yqU8pWMN5khVOFpTpGRrvzCi2oCnsKTbs5t3Ag+LCPO7r1P3wLNI67wwlBARI5SU=
X-Received: by 2002:ac8:468d:: with SMTP id g13mr4682038qto.59.1588713118249;
 Tue, 05 May 2020 14:11:58 -0700 (PDT)
MIME-Version: 1.0
References: <158858309381.5053.12391080967642755711.stgit@ebuild>
 <CAEf4BzYHBisx0dLWn-Udp6saPqAA6ew_6W1BJ=zpcQOqWxPSPQ@mail.gmail.com> <87k11qoftf.fsf@toke.dk>
In-Reply-To: <87k11qoftf.fsf@toke.dk>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 5 May 2020 14:11:47 -0700
Message-ID: <CAEf4BzakfU4TAC-eaq0Qh4mF--VM+q5H8_D8RGUOf14kZ+w+Pg@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2] libbpf: fix probe code to return EPERM if encountered
To:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>
Cc:     Eelco Chaudron <echaudro@redhat.com>, bpf <bpf@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin Lau <kafai@fb.com>, Song Liu <songliubraving@fb.com>,
        Yonghong Song <yhs@fb.com>, Andrii Nakryiko <andriin@fb.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 5, 2020 at 3:07 AM Toke H=C3=B8iland-J=C3=B8rgensen <toke@redha=
t.com> wrote:
>
> Andrii Nakryiko <andrii.nakryiko@gmail.com> writes:
>
> > On Mon, May 4, 2020 at 2:13 AM Eelco Chaudron <echaudro@redhat.com> wro=
te:
> >>
> >> When the probe code was failing for any reason ENOTSUP was returned, e=
ven
> >> if this was due to no having enough lock space. This patch fixes this =
by
> >> returning EPERM to the user application, so it can respond and increas=
e
> >> the RLIMIT_MEMLOCK size.
> >>
> >> Signed-off-by: Eelco Chaudron <echaudro@redhat.com>
> >> ---
> >> v2: Split bpf_object__probe_name() in two functions as suggested by An=
drii
> >
> > Yeah, looks good, and this is good enough, so consider you have my
> > ack. But I think we can further improve the experience by:
> >
> > 1. Changing existing "Couldn't load basic 'r0 =3D 0' BPF program."
> > message to be something more meaningful and actionable for user. E.g.,
> >
> > "Couldn't load trivial BPF program. Make sure your kernel supports BPF
> > (CONFIG_BPF_SYSCALL=3Dy) and/or that RLIMIT_MEMLOCK is set to big enoug=
h
> > value."
> >
> > Then even complete kernel newbies can search for CONFIG_BPF_SYSCALL or
> > RLIMIT_MEMLOCK and hopefully find useful discussions. We can/should
> > add RLIMIT_MEMLOCK examples to some FAQ, probably as well (if it's not
> > there already).
>
> Always on board with improving documentation; and yeah I agree that
> "Couldn't load basic 'r0 =3D 0' BPF program." could be a bit friendlier ;=
)
>
> > 2. I'd do bpf_object__probe_loading() before obj->loaded is set, so
> > that user can have a loop of bpf_object__load() that bump
> > RLIMIT_MEMLOCK in steps. After setting obj->loaded =3D true, user won't
> > be able to attemp loading again and will get "object should not be
> > loaded twice\n".
>
> In practice this is not going to be enough, though. The memlock error
> only triggers on initial load if the limit is already exceeded (by other
> BPF programs); but often what will happen is that the program being
> loaded will have a map definition that's big enough to exhaust the
> memlimit by itself. In which case the memlock error will trigger while
> creating maps, not on initial probe.
>
> Since you can't predict where the error will happen, you need to be
> prepared to close the bpf object and start over anyway, so I'm not sure
> it adds much value to move bpf_object__probe_loading() earlier?
>

True that. Ok, sounds fine to me (error message would be still nice to
improve, though).

> -Toke
>
