Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BD0814B417F
	for <lists+netdev@lfdr.de>; Mon, 14 Feb 2022 06:53:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240560AbiBNFxF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Feb 2022 00:53:05 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:44056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240557AbiBNFxE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Feb 2022 00:53:04 -0500
Received: from mail-io1-xd2b.google.com (mail-io1-xd2b.google.com [IPv6:2607:f8b0:4864:20::d2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 802075004F;
        Sun, 13 Feb 2022 21:52:57 -0800 (PST)
Received: by mail-io1-xd2b.google.com with SMTP id y84so18733903iof.0;
        Sun, 13 Feb 2022 21:52:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=FGezhFYDn+FIpD2g9NAEA9h9LALmUmeNx1mmcxyun78=;
        b=CaKWE/efZEQOf9QdTrU0JX8VjnDEFyrUuuuAj4YxnrKV98W3tibxNbXbaq73eAvsYM
         ihpxxVnHsTwOiKlJg7kOusMoyVVyXLtRretKO+Qv2kYkxELo2CYCSHs64b8DBvWJhh2U
         Ikjn0ItCCnvWCZjXPebXOCLK7bCYfPIOUs84fRsGnBcGgiB6NDUh3jCT6H5xnTJ4+oM4
         bIbhRoyb5sEZAa6d3bYOe4tMCH4Pbcudt+nmnspiFJTNrBTrsgDdgdflSJ3UmLmNs365
         yywkPnY5fREYF2NQI6wOqJ2y1lWHH7RkkAn9dlhBSo/ZHJCmZImCk1DDMPmJQ9M1xRzO
         7amA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=FGezhFYDn+FIpD2g9NAEA9h9LALmUmeNx1mmcxyun78=;
        b=pM10aaSZReqjPoaL/x4Gv/sP2gpCeDz0/3kZ2cM/W83qeapGJYzwPtXivqKZkET/jc
         oCADBLUTLmPjqz/yHLfM+Wi6uZujgMstk12naL8KyAhmGdhWV0Kht0jtONcMLuGwFmV3
         GpZQKDDOAeziCu48CvSU9s0iHUKMBwGvjUKCCIdjzybwRvzxlyQgAhR4j1b8YePKhOAn
         9Ee4HkstG1ZKn6roqid1V0uE5ZglwlejOMm5jxVU/ltyj4xcFhniSQrJyLc5EgQtalK9
         Qd8gVDmikNjrZ7lOLctsoSa/eoRxJbJ1OrWRrde8XrhhqX/U1uX7IbyBGFwqUz3t7+EZ
         d/jQ==
X-Gm-Message-State: AOAM532A3Y1zjAyMuq48zc1yQiQNEtMWT68/TpuZ9P6OdxCCqIZDpwvv
        5VAhFepEe7Cc5+u9JDi13GDQbfmyejr5/kicoSo=
X-Google-Smtp-Source: ABdhPJzyNfT3dCCyH23JrWaxnDgYYrTxiIDKzsOq71Fam71i0Yn3AY9c6XUUElOnQ23RvpD5lsairavIkZgjEOZDrBM=
X-Received: by 2002:a5e:a806:: with SMTP id c6mr6492459ioa.112.1644817976715;
 Sun, 13 Feb 2022 21:52:56 -0800 (PST)
MIME-Version: 1.0
References: <20220211234819.612288-1-toke@redhat.com> <CAEf4BzYURbRGL2D-WV=VUs6to=024wO2u=bGtwwxLEKc6pmfhQ@mail.gmail.com>
 <87h7927q3o.fsf@toke.dk>
In-Reply-To: <87h7927q3o.fsf@toke.dk>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Sun, 13 Feb 2022 21:52:45 -0800
Message-ID: <CAEf4BzZO=v8DJkPWibygAy6KAP5fWQZ_00XyKP_kVmpCxVH_Ag@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2] libbpf: Use dynamically allocated buffer when
 receiving netlink messages
To:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        Zhiqian Guan <zhguan@redhat.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Feb 13, 2022 at 7:17 AM Toke H=C3=B8iland-J=C3=B8rgensen <toke@redh=
at.com> wrote:
>
> Andrii Nakryiko <andrii.nakryiko@gmail.com> writes:
>
> > On Fri, Feb 11, 2022 at 3:49 PM Toke H=C3=B8iland-J=C3=B8rgensen <toke@=
redhat.com> wrote:
> >>
> >> When receiving netlink messages, libbpf was using a statically allocat=
ed
> >> stack buffer of 4k bytes. This happened to work fine on systems with a=
 4k
> >> page size, but on systems with larger page sizes it can lead to trunca=
ted
> >> messages. The user-visible impact of this was that libbpf would insist=
 no
> >> XDP program was attached to some interfaces because that bit of the ne=
tlink
> >> message got chopped off.
> >>
> >> Fix this by switching to a dynamically allocated buffer; we borrow the
> >> approach from iproute2 of using recvmsg() with MSG_PEEK|MSG_TRUNC to g=
et
> >> the actual size of the pending message before receiving it, adjusting =
the
> >> buffer as necessary. While we're at it, also add retries on interrupte=
d
> >> system calls around the recvmsg() call.
> >>
> >> v2:
> >>   - Move peek logic to libbpf_netlink_recv(), don't double free on ENO=
MEM.
> >>
> >> Reported-by: Zhiqian Guan <zhguan@redhat.com>
> >> Fixes: 8bbb77b7c7a2 ("libbpf: Add various netlink helpers")
> >> Acked-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
> >> Signed-off-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
> >> ---
> >
> > Applied to bpf-next.
>
> Awesome, thanks!
>
> > One improvement would be to avoid initial malloc of 4096, especially
> > if that size is enough for most cases. You could detect this through
> > iov.iov_base =3D=3D buf and not free(iov.iov_base) at the end. Seems
> > reliable and simple enough. I'll leave it up to you to follow up, if
> > you think it's a good idea.
>
> Hmm, seems distributions tend to default the stack size limit to 8k; so
> not sure if blowing half of that on a buffer just to avoid a call to
> malloc() in a non-performance-sensitive is ideal to begin with? I think
> I'd prefer to just keep the dynamic allocation...

8KB for user-space thread stack, really? Not 2MB by default? Are you
sure you are not confusing this with kernel threads?

>
> -Toke
>
