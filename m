Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 33C9248E03A
	for <lists+netdev@lfdr.de>; Thu, 13 Jan 2022 23:23:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237457AbiAMWXT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Jan 2022 17:23:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233675AbiAMWXS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Jan 2022 17:23:18 -0500
Received: from mail-yb1-xb34.google.com (mail-yb1-xb34.google.com [IPv6:2607:f8b0:4864:20::b34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1E68C061574;
        Thu, 13 Jan 2022 14:23:17 -0800 (PST)
Received: by mail-yb1-xb34.google.com with SMTP id p5so19085908ybd.13;
        Thu, 13 Jan 2022 14:23:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=8gXuFwaq4pToS2RMt259xUIMPglN6MUnJ+lOYAVQmPU=;
        b=GiqOqGS+FyNJPQa8P0NDUmkJkJ2GcSKIEFWvlFXnGN/zJ5mQ/e90n7Qja0yFVkuuT3
         vdy4KYIsqGBLziZXEfWuGmezzK/23WqiQTAe6kqki5noeFddVc+O5NTkotfVq1178Rv9
         DnebxjscZMmJtRUY2UEceU2WQDKUGAUNqYmh9NKQ/I6A6S//HxbSTYXys/zXi9aIIwDv
         eXgYwi+MjA19PHzwtoUhtjMTY0S9YDHVGKUM4XWVwQaFOGu11UZZsoKsxk2ljfVQKv8a
         ZUPIpeVfh5JDgmgmMx0vd2MhLm6+pOsZvz4WxcN99tnehfUR5SIbbGL3ZS2Gicf6ebp/
         IvEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=8gXuFwaq4pToS2RMt259xUIMPglN6MUnJ+lOYAVQmPU=;
        b=D2oR4ss152TPUDwi3OwCV8wQIUALYBEMTBkwCHIwmwYdzTDZwwqp0J17IUwrKxZpcr
         6L7dnfu08RYDCJo+n1qqEAnhdKYqhBJQQo0TWf01GsTG2s30O/XGvo69DEKN+W6kKrAS
         AdW8FpPMPI1AcMhVsoCFD21rlI7RtQcEiRbvuvV1UGtWZeBs9GpF47fSa1SxnAEkDdIV
         C9StXb7r3yVbry0KA1L8jT8xsR+J0a8c84ZY/JFfKoeIbSfvNU4vrlFJ7Yv9ajIxGX7f
         ddTy/BKujH6BiR/pq9DRnZ64F/s52vp92V09LQV5vKc2zGwlfII7beVljYv57U4W9Jjw
         pIPg==
X-Gm-Message-State: AOAM533xsbQ6C1aU1TLBuOiNXm5TNcm9OXW5Xt5StCZEGbLyV/AzBRXq
        aTh79l9fw7hVFZD0YqufUuSMB8aq6IOS23RgwDk=
X-Google-Smtp-Source: ABdhPJxqdbBnxNHHACZohOfI8k1AWAA4bg31eq7hfEecf0Cn1/b9/r1C98aAc5rqq+47TmU1iieLHJUF78XjB8Chb7k=
X-Received: by 2002:a5b:14a:: with SMTP id c10mr8615602ybp.752.1642112597121;
 Thu, 13 Jan 2022 14:23:17 -0800 (PST)
MIME-Version: 1.0
References: <20220113150846.1570738-1-rad@semihalf.ocm> <CABBYNZJn1ej18ERtgnF_wvbvBEm0N=cBRHHtr8bu+nfAotjg2Q@mail.gmail.com>
 <CAOs-w0+W_BHTdZkOnu-EPme2dpoO_6bQi_2LRH7Xw0Ge=i9TOA@mail.gmail.com>
In-Reply-To: <CAOs-w0+W_BHTdZkOnu-EPme2dpoO_6bQi_2LRH7Xw0Ge=i9TOA@mail.gmail.com>
From:   Luiz Augusto von Dentz <luiz.dentz@gmail.com>
Date:   Thu, 13 Jan 2022 14:23:06 -0800
Message-ID: <CABBYNZLinzOxJWgHwVbeEWe2zkz_y4BrXVYX4e0op580YO1OeA@mail.gmail.com>
Subject: Re: [PATCH] Bluetooth: Fix skb allocation in mgmt_remote_name()
To:     =?UTF-8?Q?Rados=C5=82aw_Biernacki?= <rad@semihalf.com>
Cc:     linux-bluetooth <linux-bluetooth@vger.kernel.org>,
        Marcel Holtmann <marcel@holtmann.org>,
        CrosBT Upstreaming <chromeos-bluetooth-upstreaming@chromium.org>,
        Archie Pusaka <apusaka@chromium.org>,
        Miao-chen Chou <mcchou@chromium.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>,
        upstream@semihalf.com, Angela Czubak <acz@semihalf.com>,
        Marek Maslanka <mm@semihalf.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Rados=C5=82aw,

On Thu, Jan 13, 2022 at 2:07 PM Rados=C5=82aw Biernacki <rad@semihalf.com> =
wrote:
>
> Hi Luiz,
>
> czw., 13 sty 2022 o 17:17 Luiz Augusto von Dentz
> <luiz.dentz@gmail.com> napisa=C5=82(a):
> >
> > Hi Radoslaw,
> >
> > On Thu, Jan 13, 2022 at 7:09 AM Radoslaw Biernacki <rad@semihalf.com> w=
rote:
> > >
> > > From: Radoslaw Biernacki <rad@semihalf.com>
> > >
> > > This patch fixes skb allocation, as lack of space for ev might push s=
kb
> > > tail beyond its end.
> > > Also introduce eir_precalc_len() that can be used instead of magic
> > > numbers for similar eir operations on skb.
> > >
> > > Fixes: cf1bce1de7eeb ("Bluetooth: mgmt: Make use of mgmt_send_event_s=
kb in MGMT_EV_DEVICE_FOUND")
> > > Signed-off-by: Angela Czubak <acz@semihalf.com>
> > > Signed-off-by: Marek Maslanka <mm@semihalf.com>
> > > Signed-off-by: Radoslaw Biernacki <rad@semihalf.com>
> > > ---
> > >  net/bluetooth/eir.h  |  5 +++++
> > >  net/bluetooth/mgmt.c | 12 ++++--------
> > >  2 files changed, 9 insertions(+), 8 deletions(-)
> > >
> > > diff --git a/net/bluetooth/eir.h b/net/bluetooth/eir.h
> > > index 05e2e917fc25..e5876751f07e 100644
> > > --- a/net/bluetooth/eir.h
> > > +++ b/net/bluetooth/eir.h
> > > @@ -15,6 +15,11 @@ u8 eir_create_scan_rsp(struct hci_dev *hdev, u8 in=
stance, u8 *ptr);
> > >  u8 eir_append_local_name(struct hci_dev *hdev, u8 *eir, u8 ad_len);
> > >  u8 eir_append_appearance(struct hci_dev *hdev, u8 *ptr, u8 ad_len);
> > >
> > > +static inline u16 eir_precalc_len(u8 data_len)
> > > +{
> > > +       return sizeof(u8) * 2 + data_len;
> > > +}
> > > +
> > >  static inline u16 eir_append_data(u8 *eir, u16 eir_len, u8 type,
> > >                                   u8 *data, u8 data_len)
> > >  {
> > > diff --git a/net/bluetooth/mgmt.c b/net/bluetooth/mgmt.c
> > > index 37087cf7dc5a..d517fd847730 100644
> > > --- a/net/bluetooth/mgmt.c
> > > +++ b/net/bluetooth/mgmt.c
> > > @@ -9680,13 +9680,11 @@ void mgmt_remote_name(struct hci_dev *hdev, b=
daddr_t *bdaddr, u8 link_type,
> > >  {
> > >         struct sk_buff *skb;
> > >         struct mgmt_ev_device_found *ev;
> > > -       u16 eir_len;
> > > -       u32 flags;
> > > +       u16 eir_len =3D 0;
> > > +       u32 flags =3D 0;
> > >
> > > -       if (name_len)
> > > -               skb =3D mgmt_alloc_skb(hdev, MGMT_EV_DEVICE_FOUND, 2 =
+ name_len);
> > > -       else
> > > -               skb =3D mgmt_alloc_skb(hdev, MGMT_EV_DEVICE_FOUND, 0)=
;
> > > +       skb =3D mgmt_alloc_skb(hdev, MGMT_EV_DEVICE_FOUND,
> > > +                            sizeof(*ev) + (name ? eir_precalc_len(na=
me_len) : 0));
> >
> > Looks like mgmt_device_connected also has a similar problem.
>
> Yes, I was planning to send a patch to this one though it will not be as =
slick.
> It would be nice to have a helper which will call skb_put() and add
> eir data at once.
> Basically skb operation in pair to, what eir_append_data() does with
> help of eir_len but without awkwardness when passing return value to
> skb_put() (as it returns offset not size).

Hmm, that might be a good idea indeed something like eir_append_skb,
if only we could grow the skb with skb_put directly that would
eliminate the problem with having to reserve enough space for the
worse case.

> I will send V2 with two patches. I hope they will align with your
> original goal of eliminating the necessity of intermediary buffers at
> some point in future.
>
> >
> > >         ev =3D skb_put(skb, sizeof(*ev));
> > >         bacpy(&ev->addr.bdaddr, bdaddr);
> > > @@ -9696,10 +9694,8 @@ void mgmt_remote_name(struct hci_dev *hdev, bd=
addr_t *bdaddr, u8 link_type,
> > >         if (name) {
> > >                 eir_len =3D eir_append_data(ev->eir, 0, EIR_NAME_COMP=
LETE, name,
> > >                                           name_len);
> > > -               flags =3D 0;
> > >                 skb_put(skb, eir_len);
> > >         } else {
> > > -               eir_len =3D 0;
> > >                 flags =3D MGMT_DEV_FOUND_NAME_REQUEST_FAILED;
> > >         }
> >
> > These changes would leave flags and eir_len uninitialized.
>
> Both are initialized to 0 by this patch.

Sorry, I must be blind that I didn't see you had changed that to be
initialized in their declaration.

> >
> > > --
> > > 2.34.1.703.g22d0c6ccf7-goog
> > >
> >
> >
> > --
> > Luiz Augusto von Dentz



--=20
Luiz Augusto von Dentz
