Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7F8365B2C1C
	for <lists+netdev@lfdr.de>; Fri,  9 Sep 2022 04:25:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229667AbiIICZi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Sep 2022 22:25:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229507AbiIICZg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Sep 2022 22:25:36 -0400
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46569F651D;
        Thu,  8 Sep 2022 19:25:33 -0700 (PDT)
Received: by mail-pf1-x442.google.com with SMTP id l65so313993pfl.8;
        Thu, 08 Sep 2022 19:25:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date;
        bh=5QDb9H3n9Vmh44IvMFrk6MQuatVVN6ACTnX3iqoQ/H4=;
        b=PaDtRQONcEyFONgdg0vE1UJJ1OdfXuO2ibxy5aFSgaUu2AY+YOzoMLWdt2yCXEJEjZ
         FZ+a/YnCVoKrUawv2IijGh8X6ZZUfx2TuzfaBtX3lxs8C5/pgapktzoSZ9lNDvMKRXL6
         z1Mf24KFv5WqcLbof/P7OEnRj607XFjrE1K/B0Kf837K19FAHpuFD+G+U3Xts8XhQOIg
         MsWEvarRrEZfSuUzDe7o5xT5FD6/dytFSpBn/aHStuYgJ6qIf6SpvSn/sKyJXtvNyQaa
         Plr8cahtkgWb1TgpT5BBU0OW//1hjCKfJLKRPy6q+K7xZ7kSkaZNEldpnlfGUZleLHsa
         o7JA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date;
        bh=5QDb9H3n9Vmh44IvMFrk6MQuatVVN6ACTnX3iqoQ/H4=;
        b=iUY4mgQXm4RVVyjzSF1rW9VuTQg/PufvFaSlyjdZ9vxxJqSTQlg+UzTGHFlKyQ16rl
         Drs5z4dfW1aKmKD2+0ITRfEt9AE/atC01418V/225wsO198ipdYhgBso32CJryVigurp
         VbRglecd6rJ+2FS4SMYy2QTSNRI4Ntb/PLBasIf1jvAsI9a99oM4cdH1XlE2EcBd53cC
         g3U5eQKPVrTURq/ImKrXL7fuTSq6lbeJV1k1i4VJedC43RdqWmLFoe5acg8mZDh5k+gG
         oPhcKusGQhICbUOkufJFR3sJBd41uOtBmVxGe+7fyy1avuyoUy1jrOf9IgiMk9NSlxR2
         9Wpg==
X-Gm-Message-State: ACgBeo3ZcgRbgI/hs8DTald/04WdqPLV72uesLLlT8H8TYPB16736VMp
        ZkZXm7PCOV2fzRiW6HEp0AhuPax/5EeVwmDVqBg=
X-Google-Smtp-Source: AA6agR7kREh8kCv44vlwqIpD+PEn/ppeqsLEvtiCz77+C2piwSDf51k+qErsywoCJpkbRkidihCFilp6H9a6WccNcjo=
X-Received: by 2002:a05:6a00:a05:b0:534:b1ad:cfac with SMTP id
 p5-20020a056a000a0500b00534b1adcfacmr11688058pfh.35.1662690332750; Thu, 08
 Sep 2022 19:25:32 -0700 (PDT)
MIME-Version: 1.0
References: <20220907111132.31722-1-imagedong@tencent.com> <e4b7eddc-3a73-0994-467e-6d65d6ad80c0@tessares.net>
 <52fcd27efafb415baa0bc52440296306110c56d7.camel@redhat.com>
In-Reply-To: <52fcd27efafb415baa0bc52440296306110c56d7.camel@redhat.com>
From:   Menglong Dong <menglong8.dong@gmail.com>
Date:   Fri, 9 Sep 2022 10:25:20 +0800
Message-ID: <CADxym3ZDow6UM6K3Nt_PDFq-4gfn8Hs0hCS62Dqsj4=tM_+hFQ@mail.gmail.com>
Subject: Re: [PATCH net v3] net: mptcp: fix unreleased socket in accept queue
To:     Paolo Abeni <pabeni@redhat.com>
Cc:     Matthieu Baerts <matthieu.baerts@tessares.net>,
        mathew.j.martineau@linux.intel.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, fw@strlen.de,
        peter.krystad@linux.intel.com, netdev@vger.kernel.org,
        mptcp@lists.linux.dev, linux-kernel@vger.kernel.org,
        Menglong Dong <imagedong@tencent.com>,
        Jiang Biao <benbjiang@tencent.com>,
        Mengen Sun <mengensun@tencent.com>
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

On Thu, Sep 8, 2022 at 10:45 PM Paolo Abeni <pabeni@redhat.com> wrote:
>
> On Thu, 2022-09-08 at 15:56 +0200, Matthieu Baerts wrote:
> > Hi Menglong,
> >
> > On 07/09/2022 13:11, menglong8.dong@gmail.com wrote:
> > > From: Menglong Dong <imagedong@tencent.com>
> > >
> > > The mptcp socket and its subflow sockets in accept queue can't be
> > > released after the process exit.
> > >
> > > While the release of a mptcp socket in listening state, the
> > > corresponding tcp socket will be released too. Meanwhile, the tcp
> > > socket in the unaccept queue will be released too. However, only init
> > > subflow is in the unaccept queue, and the joined subflow is not in th=
e
> > > unaccept queue, which makes the joined subflow won't be released, and
> > > therefore the corresponding unaccepted mptcp socket will not be relea=
sed
> > > to.
> >
> > Thank you for the v3.
> >
> > Unfortunately, our CI found a possible recursive locking:
> >
> > > - KVM Validation: debug:
> > >   - Unstable: 1 failed test(s): selftest_mptcp_join - Critical: 1 Cal=
l Trace(s) =E2=9D=8C:
> > >   - Task: https://cirrus-ci.com/task/5418283233968128
> > >   - Summary: https://api.cirrus-ci.com/v1/artifact/task/5418283233968=
128/summary/summary.txt
> >
> > https://lore.kernel.org/mptcp/4e6d3d9e-1f1a-23ae-cb56-2d4f043f17ae@gmai=
l.com/T/#u
> >
> > Do you mind looking at it please?
>
> Ah, that is actually a false positive, but we must silence it. The main
> point is that the lock_sock() in mptcp_close() rightfully lacks the
> _nested annotation.
>
> Instead of adding such annotation only for this call site, which would
> be both ugly and dangerous, I suggest to factor_out from mptcp_close()
> all the code the run under the socket lock, say in:
>
> bool __mptcp_close(struct sock *sk, long timeout)
>         // return true if the caller need to cancel the mptcp worker
>         // (outside the socket lock)
>
> and then in mptcp_subflow_queue_clean():
>
>         sock_hold(sk);
>
>         slow =3D lock_sock_fast_nested(sk);
>         next =3D msk->dl_next;
>         msk->first =3D NULL;
>         msk->dl_next =3D NULL;
>         do_cancel_work =3D __mptcp_close(sk, 0);
>         unlock_sock_fast(sk, slow);
>
>         if (do_cancel_work)
>                 mptcp_cancel_work(sk);
>         sock_put(sk);
>
> All the above could require 2 different patches, 1 to factor-out the
> helper, and 1 to actually implement the fix.
>

Thanks for your explanation! As Matthieu said, I'll send the next
version to the MPTCP mailing list only.

Thanks!
Menglong Dong

> Cheers,
>
> Paolo
>
