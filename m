Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1F0FA6C9237
	for <lists+netdev@lfdr.de>; Sun, 26 Mar 2023 05:28:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230405AbjCZD2j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Mar 2023 23:28:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229643AbjCZD2h (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 25 Mar 2023 23:28:37 -0400
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7C33A5D9;
        Sat, 25 Mar 2023 20:28:35 -0700 (PDT)
Received: by mail-ed1-x52c.google.com with SMTP id eh3so22836309edb.11;
        Sat, 25 Mar 2023 20:28:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679801313;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0iQy+trIE+WT+RF3qXqqjnaSY3Kw/XgafnBh4NMXIEM=;
        b=YTzpxDOscYTU7FkI19hkBs/nxavSa8+hyorw4qGz0nPvIhTVChIeyOlLiJO4cTzDDB
         iyO+nO/ecQIbMJBzt5Zt7VDjmBJwIVQRI73jeRE9jPAaK/OwvFoAq4LmL6Ve1QN7oE5K
         VWeFG1XhVmq4L8CKV+Zi2fWyUIVFSAq68KIwyUk4PMp8vfQ5pCmJlSxlThLg1SsjaRaB
         wJy3dEx8B+y/S7JNLvo/H2XbrIWGDTa50b4Oa+FQy4hoHIhQlrrrrG8SWc/iOFJ+OJVx
         YNKlOYlMtjGcI66Ki+3L+O4CrE+2ze5UoC4iOv9pqW/5OdnDHxwGM1wUj4X/NLMA8rPs
         lmmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679801313;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0iQy+trIE+WT+RF3qXqqjnaSY3Kw/XgafnBh4NMXIEM=;
        b=XW9Qb3yTbl+e/zp8rbTmuu/FHgNheSKJQdaL6p2KyFCw7luok8azyCmAZGbcoW/EOf
         3/plPCmu+m0ydjPlWIiOhV+BTpbw0uCVJLQQv+y+xVAr2ZNS/efXdMiiqgy1gtRkTI6N
         1ydHvCuPtmMTEKWA2x2WI2XtQCR4oE8SvA9/aYKkwgLZ+BuSrlG5ve3LS905l8l2GC6U
         bIhkts2oz8RSB5qFVNOt2jKziz4OWmf8ysZLSNF/AEUFtweG36lbx029eJq0QuzzuY50
         3c2Et5qb3olukezkSkcpjINYcM7ceQPwu1gQihm+8srQaa0wuhKGk1nUfENfaWbB2BmV
         XPCA==
X-Gm-Message-State: AAQBX9cWvsquT4jAOWX27bTX6VlqrTaBiuHHt2tt6vVwvGUTPjhFGgUh
        JXYqD3eG3z8DcXl4MTjESpb6s+26IncMo1FW/4k=
X-Google-Smtp-Source: AKy350ZwRVyt9Hr/FsMRJ3pmjRYIhvMxCC/x6I5GEAqUWUjQ2DoUpd+KRWVBnHxqFGa2P9oA7IXezFF29qsaZ25EjvA=
X-Received: by 2002:a17:906:891:b0:8b1:7569:b526 with SMTP id
 n17-20020a170906089100b008b17569b526mr3315410eje.11.1679801312826; Sat, 25
 Mar 2023 20:28:32 -0700 (PDT)
MIME-Version: 1.0
References: <20230325152417.5403-1-kerneljasonxing@gmail.com> <CANn89iJaVrObJNDC9TrnSUC3XQeo-zfmUXLVrNVcsbRDPuSNtA@mail.gmail.com>
In-Reply-To: <CANn89iJaVrObJNDC9TrnSUC3XQeo-zfmUXLVrNVcsbRDPuSNtA@mail.gmail.com>
From:   Jason Xing <kerneljasonxing@gmail.com>
Date:   Sun, 26 Mar 2023 11:27:56 +0800
Message-ID: <CAL+tcoBPOBs0qvWmV_0EJ-s1qF=FKz=bhcH5Px51cgZJ9NDrcw@mail.gmail.com>
Subject: Re: [PATCH net] net: fix raising a softirq on the current cpu with
 rps enabled
To:     Eric Dumazet <edumazet@google.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jason Xing <kernelxing@tencent.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Mar 25, 2023 at 11:57=E2=80=AFPM Eric Dumazet <edumazet@google.com>=
 wrote:
>
> On Sat, Mar 25, 2023 at 8:26=E2=80=AFAM Jason Xing <kerneljasonxing@gmail=
.com> wrote:
> >
> > From: Jason Xing <kernelxing@tencent.com>
> >
> > Since we decide to put the skb into a backlog queue of another
> > cpu, we should not raise the softirq for the current cpu. When
> > to raise a softirq is based on whether we have more data left to
> > process later. As to the current cpu, there is no indication of
> > more data enqueued, so we do not need this action. After enqueuing
> > to another cpu, net_rx_action() function will call ipi and then
> > another cpu will raise the softirq as expected.
> >
> > Also, raising more softirqs which set the corresponding bit field
> > can make the IRQ mechanism think we probably need to start ksoftirqd
> > on the current cpu. Actually it shouldn't happen.
> >
> > Fixes: 0a9627f2649a ("rps: Receive Packet Steering")
> > Signed-off-by: Jason Xing <kernelxing@tencent.com>
> > ---
> >  net/core/dev.c | 2 --
> >  1 file changed, 2 deletions(-)
> >
> > diff --git a/net/core/dev.c b/net/core/dev.c
> > index 1518a366783b..bfaaa652f50c 100644
> > --- a/net/core/dev.c
> > +++ b/net/core/dev.c
> > @@ -4594,8 +4594,6 @@ static int napi_schedule_rps(struct softnet_data =
*sd)
> >         if (sd !=3D mysd) {
> >                 sd->rps_ipi_next =3D mysd->rps_ipi_list;
> >                 mysd->rps_ipi_list =3D sd;
> > -
> > -               __raise_softirq_irqoff(NET_RX_SOFTIRQ);
> >                 return 1;
> >         }
> >  #endif /* CONFIG_RPS */
> > --
> > 2.37.3
> >
>
> This is not going to work in some cases. Please take a deeper look.

I'll do it. I've already been struggling with this for a few days. I
still have no clue.

I found out in some cases that frequently starting ksoftirqd is not
that good because this thread may be blocked when waiting in the
runqueue.
So I tried to avoid raising softirqs to mitigate the issue and then I
noticed this one.

>
> I have to run, if you (or others) do not find the reason, I will give
> more details when I am done traveling.

Happy traveling :)

Thanks,
Jason
