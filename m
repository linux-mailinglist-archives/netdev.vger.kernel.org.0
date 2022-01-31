Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 123914A4ED3
	for <lists+netdev@lfdr.de>; Mon, 31 Jan 2022 19:48:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357958AbiAaSr5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Jan 2022 13:47:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357946AbiAaSrx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Jan 2022 13:47:53 -0500
Received: from mail-yb1-xb36.google.com (mail-yb1-xb36.google.com [IPv6:2607:f8b0:4864:20::b36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1D2DC06173B;
        Mon, 31 Jan 2022 10:47:37 -0800 (PST)
Received: by mail-yb1-xb36.google.com with SMTP id j2so30170934ybu.0;
        Mon, 31 Jan 2022 10:47:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=317J+b5PpSz9x/w2XV3+0c4wYcSD3IlZCWiQWA5Ipxk=;
        b=eI8S6HU4hdhKI33oB2A77jQ5V2CxkG5J0sRSnPNQRR/LWUgBL44/AI5I8DKXpLtgAk
         U3PwrJjmLcA//CNKNXw6eUCi7hsWc7xfM6ZvWHSVzdZaO6AonSqjVCxah1otkOsB1fiV
         rc4oYNGl9hSbQmVH2LA72zjrYXbyTJmvzlodkB7nvGFsfK7ID1KN3R40xBYtv4Q30cVN
         8jW0eKe7PAMFCwnGKwCzLODuvWtJ8VSf4lEsfr20OOCS2aXyETlK5OnePtwIAx62UmO0
         MZzcycHt4kZ9O2mBjYD2cpDXOaARyCiN9A05TO0u8LqajMvO8LSm+nf4dhD7InRd7BwA
         x0aA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=317J+b5PpSz9x/w2XV3+0c4wYcSD3IlZCWiQWA5Ipxk=;
        b=Z1Q6BXvMOG6KBvKe8WtbimM6NI8cDxI17S0HQ2picZPOtLqa2UXh1RHaIrcH+RGv8a
         mC/JCU6rpxnzE9deUiOrA8do6kApvOIxKTy/GH3O5Nr/nJYGWZRLakrv3LfmvcnfLgEk
         Qr+H2pqXCfLGCi0bRmP08sowq7p/g7hI3glhtc41VC5Gd+M9tH0K/pplP485hmgpavj+
         GnP8BhBD4HMIAyHTAqbLawPtOiVaC2f89ABiM5MbGYSyll3P+fxhtGLasRH/RPSKu88t
         zFgBwd5icBliNuEeBORDpJsCj3eBeQqrCoLva95nzIwHn1IQ23Al6zeTx05TcLDSPetW
         UPcg==
X-Gm-Message-State: AOAM530NnspZBtJ+hKJylxPucL3/1LixGiLgkvq+CqdBntm/iTXytrPV
        /LeDLvdnohrk6LB8feJzQJkqtnEBVhbXj9yxbQY=
X-Google-Smtp-Source: ABdhPJwarLPQqvXwzoY39z9HgOmm8G1lObZ3heCf+jF3pngw5pMw8uAoV92YPAxkOQa+IkVbXlcm+32aAbpjxHzUAl4=
X-Received: by 2002:a25:50cf:: with SMTP id e198mr31706710ybb.398.1643654857132;
 Mon, 31 Jan 2022 10:47:37 -0800 (PST)
MIME-Version: 1.0
References: <20220113150846.1570738-1-rad@semihalf.ocm> <CABBYNZJn1ej18ERtgnF_wvbvBEm0N=cBRHHtr8bu+nfAotjg2Q@mail.gmail.com>
 <CAOs-w0+W_BHTdZkOnu-EPme2dpoO_6bQi_2LRH7Xw0Ge=i9TOA@mail.gmail.com> <CABBYNZLinzOxJWgHwVbeEWe2zkz_y4BrXVYX4e0op580YO1OeA@mail.gmail.com>
In-Reply-To: <CABBYNZLinzOxJWgHwVbeEWe2zkz_y4BrXVYX4e0op580YO1OeA@mail.gmail.com>
From:   Luiz Augusto von Dentz <luiz.dentz@gmail.com>
Date:   Mon, 31 Jan 2022 10:47:26 -0800
Message-ID: <CABBYNZL3ozczAK2mWXVd+x2NtZhaAbfnUFoA3ot1AQLNHSeL5w@mail.gmail.com>
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

On Thu, Jan 13, 2022 at 2:23 PM Luiz Augusto von Dentz
<luiz.dentz@gmail.com> wrote:
>
> Hi Rados=C5=82aw,
>
> On Thu, Jan 13, 2022 at 2:07 PM Rados=C5=82aw Biernacki <rad@semihalf.com=
> wrote:
> >
> > Hi Luiz,
> >
> > czw., 13 sty 2022 o 17:17 Luiz Augusto von Dentz
> > <luiz.dentz@gmail.com> napisa=C5=82(a):
> > >
> > > Hi Radoslaw,
> > >
> > > On Thu, Jan 13, 2022 at 7:09 AM Radoslaw Biernacki <rad@semihalf.com>=
 wrote:
> > > >
> > > > From: Radoslaw Biernacki <rad@semihalf.com>
> > > >
> > > > This patch fixes skb allocation, as lack of space for ev might push=
 skb
> > > > tail beyond its end.
> > > > Also introduce eir_precalc_len() that can be used instead of magic
> > > > numbers for similar eir operations on skb.
> > > >
> > > > Fixes: cf1bce1de7eeb ("Bluetooth: mgmt: Make use of mgmt_send_event=
_skb in MGMT_EV_DEVICE_FOUND")
> > > > Signed-off-by: Angela Czubak <acz@semihalf.com>
> > > > Signed-off-by: Marek Maslanka <mm@semihalf.com>
> > > > Signed-off-by: Radoslaw Biernacki <rad@semihalf.com>
> > > > ---
> > > >  net/bluetooth/eir.h  |  5 +++++
> > > >  net/bluetooth/mgmt.c | 12 ++++--------
> > > >  2 files changed, 9 insertions(+), 8 deletions(-)
> > > >
> > > > diff --git a/net/bluetooth/eir.h b/net/bluetooth/eir.h
> > > > index 05e2e917fc25..e5876751f07e 100644
> > > > --- a/net/bluetooth/eir.h
> > > > +++ b/net/bluetooth/eir.h
> > > > @@ -15,6 +15,11 @@ u8 eir_create_scan_rsp(struct hci_dev *hdev, u8 =
instance, u8 *ptr);
> > > >  u8 eir_append_local_name(struct hci_dev *hdev, u8 *eir, u8 ad_len)=
;
> > > >  u8 eir_append_appearance(struct hci_dev *hdev, u8 *ptr, u8 ad_len)=
;
> > > >
> > > > +static inline u16 eir_precalc_len(u8 data_len)
> > > > +{
> > > > +       return sizeof(u8) * 2 + data_len;
> > > > +}
> > > > +
> > > >  static inline u16 eir_append_data(u8 *eir, u16 eir_len, u8 type,
> > > >                                   u8 *data, u8 data_len)
> > > >  {
> > > > diff --git a/net/bluetooth/mgmt.c b/net/bluetooth/mgmt.c
> > > > index 37087cf7dc5a..d517fd847730 100644
> > > > --- a/net/bluetooth/mgmt.c
> > > > +++ b/net/bluetooth/mgmt.c
> > > > @@ -9680,13 +9680,11 @@ void mgmt_remote_name(struct hci_dev *hdev,=
 bdaddr_t *bdaddr, u8 link_type,
> > > >  {
> > > >         struct sk_buff *skb;
> > > >         struct mgmt_ev_device_found *ev;
> > > > -       u16 eir_len;
> > > > -       u32 flags;
> > > > +       u16 eir_len =3D 0;
> > > > +       u32 flags =3D 0;
> > > >
> > > > -       if (name_len)
> > > > -               skb =3D mgmt_alloc_skb(hdev, MGMT_EV_DEVICE_FOUND, =
2 + name_len);
> > > > -       else
> > > > -               skb =3D mgmt_alloc_skb(hdev, MGMT_EV_DEVICE_FOUND, =
0);
> > > > +       skb =3D mgmt_alloc_skb(hdev, MGMT_EV_DEVICE_FOUND,
> > > > +                            sizeof(*ev) + (name ? eir_precalc_len(=
name_len) : 0));
> > >
> > > Looks like mgmt_device_connected also has a similar problem.
> >
> > Yes, I was planning to send a patch to this one though it will not be a=
s slick.
> > It would be nice to have a helper which will call skb_put() and add
> > eir data at once.
> > Basically skb operation in pair to, what eir_append_data() does with
> > help of eir_len but without awkwardness when passing return value to
> > skb_put() (as it returns offset not size).
>
> Hmm, that might be a good idea indeed something like eir_append_skb,
> if only we could grow the skb with skb_put directly that would
> eliminate the problem with having to reserve enough space for the
> worse case.
>
> > I will send V2 with two patches. I hope they will align with your
> > original goal of eliminating the necessity of intermediary buffers at
> > some point in future.

Are you still planning to send the v2?

> > >
> > > >         ev =3D skb_put(skb, sizeof(*ev));
> > > >         bacpy(&ev->addr.bdaddr, bdaddr);
> > > > @@ -9696,10 +9694,8 @@ void mgmt_remote_name(struct hci_dev *hdev, =
bdaddr_t *bdaddr, u8 link_type,
> > > >         if (name) {
> > > >                 eir_len =3D eir_append_data(ev->eir, 0, EIR_NAME_CO=
MPLETE, name,
> > > >                                           name_len);
> > > > -               flags =3D 0;
> > > >                 skb_put(skb, eir_len);
> > > >         } else {
> > > > -               eir_len =3D 0;
> > > >                 flags =3D MGMT_DEV_FOUND_NAME_REQUEST_FAILED;
> > > >         }
> > >
> > > These changes would leave flags and eir_len uninitialized.
> >
> > Both are initialized to 0 by this patch.
>
> Sorry, I must be blind that I didn't see you had changed that to be
> initialized in their declaration.
>
> > >
> > > > --
> > > > 2.34.1.703.g22d0c6ccf7-goog
> > > >
> > >
> > >
> > > --
> > > Luiz Augusto von Dentz
>
>
>
> --
> Luiz Augusto von Dentz



--=20
Luiz Augusto von Dentz
