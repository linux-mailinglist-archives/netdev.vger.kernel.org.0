Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BC32F4B316A
	for <lists+netdev@lfdr.de>; Sat, 12 Feb 2022 00:40:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354239AbiBKXkP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Feb 2022 18:40:15 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:41656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238960AbiBKXkO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Feb 2022 18:40:14 -0500
Received: from mail-il1-x135.google.com (mail-il1-x135.google.com [IPv6:2607:f8b0:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0D06CF9;
        Fri, 11 Feb 2022 15:40:12 -0800 (PST)
Received: by mail-il1-x135.google.com with SMTP id d7so2257735ilf.8;
        Fri, 11 Feb 2022 15:40:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=igxBsCr8vqLoUc1GDBD/4f34OJOLGaGVg98vU5KaylA=;
        b=OA+m4u91kxK7VKbYb4E2UfSDT+1NWBwe12ajj32cf1pm0z410HHDYzo+b5rQ29jHGC
         nrZ7fo2BO989FVwLHeYKF4tsH3vRzHbzn+skrfQNMjcnD56RzY4otjIEWzUs8blKYVN2
         MEEv6Pn74JEZVA6/23+mN5i/oqDyWQtSTD5VXS0miqOJZPlURXIRL/A9GODWsJb8cJsp
         nmLY/ahkRqV2sZirEsgXDfozcMfBRMq2iIqehJolEs79ZmCAFKpJFlhOlsi4d+OpWjOU
         dpj5jmKtBVxc7YvITyXn5dLtBTBuiLor1uN61YIMeV+Xd6fGledNC8dCboeRfHEM3Din
         W2DA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=igxBsCr8vqLoUc1GDBD/4f34OJOLGaGVg98vU5KaylA=;
        b=RQLrK55032Bxobr3nLfpbUwoELkg3YwuFFjp4Ng8I9kVC4NcoYaCRKyztS5dA8g+Kh
         EwDfH6SEjk02YNTo0tEQV9XZrN98ThgNmtAoE6oenhT2s5EHa2IR+SDGEI9uEHNj6hPO
         EO0hmEkwZ9EE1YtVx3fJ1Cdp7AOb2RKz6SUkoIKMtrNdeuSNeQYuxH7Sp7LL4qg4VN7Z
         ETAIGAZj4+84EAtrUWTVvUlh2Qn1IdoyCNjsHg7Vo+T0FUCrNMCfs7ImdrDKxFLNrs4y
         MsvM5vHGyZEKHpo8HQ0bWIMSCDzZNXUAZw5CqsbfHdiktgn4AAh2Uqn7D1WTm90nnH+e
         GUiw==
X-Gm-Message-State: AOAM530ot5Dtgneqzrn016RvnTtObYSzjOheG8Gb1VJEF8To1DOlh5K8
        6noqb21H1BbPXkUqO2gJeezYokWoZ2ps3fT343w=
X-Google-Smtp-Source: ABdhPJxxlElN2f1SvtJ1YH/zt9O15SV2pBiAktWpReFnhDyCzMF4i0up9jbdq5aYqonakP3QjJEsFl3k8oHuRGzm1k0=
X-Received: by 2002:a05:6e02:190e:: with SMTP id w14mr2092874ilu.71.1644622812147;
 Fri, 11 Feb 2022 15:40:12 -0800 (PST)
MIME-Version: 1.0
References: <20220211195101.591642-1-toke@redhat.com> <CAEf4BzY=spmQrPX06-hrNMSaH_Sst-WTZiHSpNaCid4+ZNjB3w@mail.gmail.com>
 <87y22h6klq.fsf@toke.dk>
In-Reply-To: <87y22h6klq.fsf@toke.dk>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 11 Feb 2022 15:40:01 -0800
Message-ID: <CAEf4Bzadvq0yhTNJ5NQOCE-+CYP8s+-gJo=su-OjPrHGDrur+A@mail.gmail.com>
Subject: Re: [PATCH bpf-next] libbpf: Use dynamically allocated buffer when
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

On Fri, Feb 11, 2022 at 3:37 PM Toke H=C3=B8iland-J=C3=B8rgensen <toke@redh=
at.com> wrote:
>
> Andrii Nakryiko <andrii.nakryiko@gmail.com> writes:
>
> > On Fri, Feb 11, 2022 at 11:51 AM Toke H=C3=B8iland-J=C3=B8rgensen <toke=
@redhat.com> wrote:
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
> >> Reported-by: Zhiqian Guan <zhguan@redhat.com>
> >> Fixes: 8bbb77b7c7a2 ("libbpf: Add various netlink helpers")
> >> Signed-off-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
> >> ---
> >>  tools/lib/bpf/netlink.c | 55 ++++++++++++++++++++++++++++++++++++++--=
-
> >>  1 file changed, 52 insertions(+), 3 deletions(-)
> >>
> >> diff --git a/tools/lib/bpf/netlink.c b/tools/lib/bpf/netlink.c
> >> index c39c37f99d5c..9a6e95206bf0 100644
> >> --- a/tools/lib/bpf/netlink.c
> >> +++ b/tools/lib/bpf/netlink.c
> >> @@ -87,22 +87,70 @@ enum {
> >>         NL_DONE,
> >>  };
> >>
> >> +static int __libbpf_netlink_recvmsg(int sock, struct msghdr *mhdr, in=
t flags)
> >
> > let's not use names starting with underscored. Just call it
> > "netlink_recvmsg" or something like that.
>
> Alright, will fix.
>
> >> +{
> >> +       int len;
> >> +
> >> +       do {
> >> +               len =3D recvmsg(sock, mhdr, flags);
> >
> > recvmsg returns ssize_t, is it ok to truncate to int?
>
> In practice, yeah; the kernel is not going to return a single message
> that overflows an int, even on 32bit. And with an int return type it's
> more natural to return -errno instead of having the caller deal with
> that. So unless you have strong objections I'd prefer to keep it this
> way...

yep, int is fine

>
> >> +       } while (len < 0 && (errno =3D=3D EINTR || errno =3D=3D EAGAIN=
));
> >> +
> >> +       if (len < 0)
> >> +               return -errno;
> >> +       return len;
> >> +}
> >> +
> >> +static int libbpf_netlink_recvmsg(int sock, struct msghdr *mhdr, char=
 **buf)
> >> +{
> >> +       struct iovec *iov =3D mhdr->msg_iov;
> >> +       void *nbuf;
> >> +       int len;
> >> +
> >> +       len =3D __libbpf_netlink_recvmsg(sock, mhdr, MSG_PEEK | MSG_TR=
UNC);
> >> +       if (len < 0)
> >> +               return len;
> >> +
> >> +       if (len < 4096)
> >> +               len =3D 4096;
> >> +
> >> +       if (len > iov->iov_len) {
> >> +               nbuf =3D realloc(iov->iov_base, len);
> >> +               if (!nbuf) {
> >> +                       free(iov->iov_base);
> >> +                       return -ENOMEM;
> >> +               }
> >> +               iov->iov_base =3D nbuf;
> >
> > this function both sets iov->iov_base *and* returns buf. It's quite a
> > convoluted contract. Seems like buf is not necessary (and also NULL
> > out iov->iov_base in case of error above?). But it might be cleaner to
> > do this MSG_PEEK  + realloc + recvmsg  in libbpf_netlink_recv()
> > explicitly. It's only one place.
>
> Hmm, yeah, if I wrap the realloc code in a small helper that works; will
> fix.
>
> -Toke
>
