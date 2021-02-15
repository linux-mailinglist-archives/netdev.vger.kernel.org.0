Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F45131C11D
	for <lists+netdev@lfdr.de>; Mon, 15 Feb 2021 19:06:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230253AbhBOSFL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Feb 2021 13:05:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230120AbhBOSFJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Feb 2021 13:05:09 -0500
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56199C061574
        for <netdev@vger.kernel.org>; Mon, 15 Feb 2021 10:04:29 -0800 (PST)
Received: by mail-pj1-x1029.google.com with SMTP id gb24so4155312pjb.4
        for <netdev@vger.kernel.org>; Mon, 15 Feb 2021 10:04:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=xgzI9OV1yo9zlK+OqGdfKnk4MokKZN2dOYCfgtZuOgg=;
        b=dR1f/O9hB0vcnlS1T6pgiK3D3mD2vRToTVgSS7iHfxRC7srgavW14+YDF9Mmq50Mam
         ZFT6HUIeipEA4F6JU2AvGQX08FWv89LWAyQEt9wcxMISZT8qrjiFJC/OziSMnNSU36pc
         Wn8zrEIUurAqo/5JyqHSXTJkrGkB1dsuZ7dwNYzf7FDdvzNvHDJckqFYt9p+aDb1lmV1
         Kmrq+syvkuponj2RqG9MuR1NoRm3DVWHQW6r3pFgVB8ecAfNoc+tj0UWFhZ+YEofhqQg
         tecgC8O0y4O5KskS27X5lGzrzFrnLqrCpK1MxTbaUAiZm4B/kRy+htlvtW1waCbgPAXD
         UISw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=xgzI9OV1yo9zlK+OqGdfKnk4MokKZN2dOYCfgtZuOgg=;
        b=mmA93u+GCkoceoMvFrM2KL4cdwB0Lrj79DnY9WXeT3E2O+Uf1JPDBA8iN7By/IA00Q
         NZcc+624K68P3wxo6zNQ+atAeeqQdtvLnqOnkVzm2egxQn9E9y2WtZQdV6GsZkmj0bfs
         GKZ38/QRfN6YQu7jq2RZc4O1j1cSvOgCHcu0NZ4+Y2fPsJ6Rd+R/lyuUhgIrElp0wCJ1
         SLFSOIuTbqQmrvK0SS3Ed8LW0r9upPXr+cYWnxvmIU3xWzryVBTYj0K36xEBFAi1pCCM
         F8+Y4iwG7JJPWwZkZgoMMAOQzAZfkrdQASEOotW/RJStWp0Va/3MspeHL9NjNaGwBf6X
         lvZw==
X-Gm-Message-State: AOAM533+PEFCSUIcXyb4k/6CKEcaIQfQi0G8xvlkmolo2HUnX2c3fPWx
        Iok3Xv9rTrvVD/mrK6A0ijdNwUa/Qbn/iQHs/i0=
X-Google-Smtp-Source: ABdhPJzZ2E6d2xy6WfLuf1ZXMi20AMMCnUlrxplxJlsYqabh4NGMLUHqv3xy9OCHtdzra6Q8jN/m2HOPGks8Q7V86wo=
X-Received: by 2002:a17:902:c282:b029:e3:45a0:a8a6 with SMTP id
 i2-20020a170902c282b02900e345a0a8a6mr9520192pld.10.1613412268433; Mon, 15 Feb
 2021 10:04:28 -0800 (PST)
MIME-Version: 1.0
References: <20210213175102.28227-1-ap420073@gmail.com> <CAM_iQpXLMk+4VuHr8WyLE1fxNV5hsN7JvA2PoDOmnZ4beJOH7Q@mail.gmail.com>
 <3cbe0945-4f98-961c-29cc-5b863c99e2df@gmail.com>
In-Reply-To: <3cbe0945-4f98-961c-29cc-5b863c99e2df@gmail.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Mon, 15 Feb 2021 10:04:18 -0800
Message-ID: <CAM_iQpUVG5+EbMbMXWJ=tb6Br+s+e2-tHChNvGgxFH7XSwEXHA@mail.gmail.com>
Subject: Re: [PATCH net-next v2 1/7] mld: convert from timer to delayed work
To:     Taehee Yoo <ap420073@gmail.com>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        jwi@linux.ibm.com, kgraul@linux.ibm.com, hca@linux.ibm.com,
        gor@linux.ibm.com, borntraeger@de.ibm.com,
        Marek Lindner <mareklindner@neomailbox.ch>,
        sw@simonwunderlich.de, a@unstable.cc, sven@narfation.org,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>, dsahern@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Feb 14, 2021 at 2:56 AM Taehee Yoo <ap420073@gmail.com> wrote:
>
>
>
> On 21. 2. 14. =EC=98=A4=EC=A0=84 4:07, Cong Wang wrote:
>  > On Sat, Feb 13, 2021 at 9:51 AM Taehee Yoo <ap420073@gmail.com> wrote:
>  >> -static void mld_dad_start_timer(struct inet6_dev *idev, unsigned
> long delay)
>  >> +static void mld_dad_start_work(struct inet6_dev *idev, unsigned
> long delay)
>  >>   {
>  >>          unsigned long tv =3D prandom_u32() % delay;
>  >>
>  >> -       if (!mod_timer(&idev->mc_dad_timer, jiffies+tv+2))
>  >> +       if (!mod_delayed_work(mld_wq, &idev->mc_dad_work,
> msecs_to_jiffies(tv + 2)))
>  >
>  > IIUC, before this patch 'delay' is in jiffies, after this patch it is
> in msecs?
>  >
>
> Ah, I understand, It's my mistake.
> I didn't change the behavior of 'delay' in this patchset.
> So, 'delay' is still in jiffies, not msecs.
> Therefore, msecs_to_jiffies() should not be used in this patchset.
> I will send a v3 patch, which doesn't use msecs_to_jiffies().
> Thanks!
>
> By the way, I think the 'delay' is from the
> unsolicited_report_interval() and it just return value of
> idev->cnf.mldv{1 | 2}_unsolicited_report_interval.
> I think this value is msecs, not jiffies.
> So, It should be converted to use msecs_to_jiffies(), I think.
> How do you think about it?

Hmm? I think it is in jiffies:

        .mldv1_unsolicited_report_interval =3D 10 * HZ,
        .mldv2_unsolicited_report_interval =3D HZ,


>
>  > [...]
>  >
>  >> -static void mld_dad_timer_expire(struct timer_list *t)
>  >> +static void mld_dad_work(struct work_struct *work)
>  >>   {
>  >> -       struct inet6_dev *idev =3D from_timer(idev, t, mc_dad_timer);
>  >> +       struct inet6_dev *idev =3D container_of(to_delayed_work(work)=
,
>  >> +                                             struct inet6_dev,
>  >> +                                             mc_dad_work);
>  >>
>  >> +       rtnl_lock();
>  >
>  > Any reason why we need RTNL after converting the timer to
>  > delayed work?
>  >
>
> For the moment, RTNL is not needed.
> But the Resources, which are used by delayed_work will be protected by
> RTNL instead of other locks.
> So, It just pre-adds RTNL and the following patches will delete other loc=
ks.

Sounds like this change does not belong to this patch. ;) If so,
please move it to where ever more appropriate.

Thanks.
