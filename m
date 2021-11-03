Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D608443E04
	for <lists+netdev@lfdr.de>; Wed,  3 Nov 2021 09:08:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231267AbhKCIKr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Nov 2021 04:10:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230352AbhKCIKr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Nov 2021 04:10:47 -0400
Received: from mail-wm1-x32a.google.com (mail-wm1-x32a.google.com [IPv6:2a00:1450:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D203DC061205
        for <netdev@vger.kernel.org>; Wed,  3 Nov 2021 01:08:10 -0700 (PDT)
Received: by mail-wm1-x32a.google.com with SMTP id z11-20020a1c7e0b000000b0030db7b70b6bso3888895wmc.1
        for <netdev@vger.kernel.org>; Wed, 03 Nov 2021 01:08:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=y+h6ogY2iFX9VezgygiGlqtRgxxUVwR6ulA1k3hBo7w=;
        b=OHisHYZRhq5lsyMbcUfFslcsN7JkTBjw4xufAleoROAYHMtNzqjLMvnQgZpFwJuBy+
         ZbGNJJpbKU1mNkOpiOjfueRuzyPDY4XsXcmAyWqBYFZZHqicVjKJWfhJqmklA6Zi3Y8G
         DwJ81jU4WCHgAZyLi9BW5PokXg1fP/eGVhy/6CN2KCATQdOxRdZq9q9o6s/jB5h08Cex
         GV/nc0kJ83etEqs1p8B9Zbndo/Z6FCFOOcoKpEmtgQ8icDJdfqig2D1Ei8CjOXA6zyCa
         etJPosWh0QP44YzVFwyBfJDgjaPTpJIhNoMMazfIEFjBv93gpt84quog84P3/MJtgLlj
         cmIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=y+h6ogY2iFX9VezgygiGlqtRgxxUVwR6ulA1k3hBo7w=;
        b=TVM+RyaDq1VSi0CMSHs+09STICSosK405xrF1XsZm829RTLc2juopraQj8QL/bX4xw
         m5yAx0CX8duyxYQHGRLScA/XH0EVjEP3BO2drIvIqBJaW5A3vQ6f+nuSjHhWi2b7wTnR
         YXRAR4G2c8tpNhezRHNzR+kYmqyc/tIvA1HBijC84YqTRuEj0MvcwqP3tmxTU0PWDzk8
         VUe8wTOvHa2AXjTHVa8cEp/mofywbqU/HA/hDp+DvfeLzFZihGyeWdlyEpxaS6Yt+y54
         pTIlziPJTV0AFhJ0zhgoO3Zc474U/2ZFrmKs1gh+CUX6wyu6FX0ysj4veav3Gozmp7q/
         P5Rg==
X-Gm-Message-State: AOAM533lqlxSIBwo0XG6gwrR+uPvCW5aXvbsTOQYtYIGlKzsLVx9tRV+
        IUQcOupyRsTeN2qccjRNc9QEKXsjdbkqwVLIySur5A==
X-Google-Smtp-Source: ABdhPJydxpJleTtHMM1rdITnTQNqXOqaqV+zjrYGIl6eHPiP/Tk8I+O+dfPeGWvmpr+a1HX+rwsbSjdS7mF2pJbxVFc=
X-Received: by 2002:a05:600c:2308:: with SMTP id 8mr2934903wmo.179.1635926888930;
 Wed, 03 Nov 2021 01:08:08 -0700 (PDT)
MIME-Version: 1.0
References: <20211102192742.1.I3ba1a76d72da5a813cf6e6f219838c9ef28c5eaa@changeid>
 <4049F5B5-D5A7-4F60-A33D-F22B601E7064@holtmann.org>
In-Reply-To: <4049F5B5-D5A7-4F60-A33D-F22B601E7064@holtmann.org>
From:   Archie Pusaka <apusaka@google.com>
Date:   Wed, 3 Nov 2021 16:07:58 +0800
Message-ID: <CAJQfnxG=TF1G3yqiok1m6bcU7LT3p+PGCAhFQsi4W1hBpg2hnA@mail.gmail.com>
Subject: Re: [PATCH] Bluetooth: Fix receiving HCI_LE_Advertising_Set_Terminated
 event
To:     Marcel Holtmann <marcel@holtmann.org>
Cc:     linux-bluetooth <linux-bluetooth@vger.kernel.org>,
        CrosBT Upstreaming <chromeos-bluetooth-upstreaming@chromium.org>,
        Archie Pusaka <apusaka@chromium.org>,
        Alain Michaud <alainm@chromium.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Marcel,

Thanks for your reply.
I've sent a v2 patch to incorporate your suggestions.

Regards,
Archie

On Tue, 2 Nov 2021 at 22:00, Marcel Holtmann <marcel@holtmann.org> wrote:
>
> Hi Archie,
>
> > This event is received when the controller stops advertising,
> > specifically for these three reasons:
> > (a) Connection is successfully created (success).
> > (b) Timeout is reached (error).
> > (c) Number of advertising events is reached (error).
> > (*) This event is NOT generated when the host stops the advertisement.
> > Refer to the BT spec ver 5.3 vol 4 part E sec 7.7.65.18. Note that the
> > section was revised from BT spec ver 5.0 vol 2 part E sec 7.7.65.18
> > which was ambiguous about (*).
> >
> > Some chips (e.g. RTL8822CE) send this event when the host stops the
> > advertisement with status =3D HCI_ERROR_CANCELLED_BY_HOST (due to (*)
> > above). This is treated as an error and the advertisement will be
> > removed and userspace will be informed via MGMT event.
> >
> > On suspend, we are supposed to temporarily disable advertisements,
> > and continue advertising on resume. However, due to the behavior
> > above, the advertisements are removed instead.
> >
> > This patch returns early if HCI_ERROR_CANCELLED_BY_HOST is received.
>
> lets include a btmon snippet here to show the faulty behavior.
>
> >
> > Additionally, this patch also clear HCI_LE_ADV if there are no more
> > advertising instances after receiving other errors.
>
> Does this really belong in this patch? I think it warrants a separate pat=
ch with an appropriate Fixes: tag. Especially in the case we are working ar=
ound a firmware bug, this should be separate. It gives us a better chance t=
o bisect anything if we ever have to.
>
> >
> > Signed-off-by: Archie Pusaka <apusaka@chromium.org>
> > Reviewed-by: Alain Michaud <alainm@chromium.org>
> >
> > ---
> >
> > include/net/bluetooth/hci.h |  1 +
> > net/bluetooth/hci_event.c   | 12 ++++++++++++
> > 2 files changed, 13 insertions(+)
> >
> > diff --git a/include/net/bluetooth/hci.h b/include/net/bluetooth/hci.h
> > index 63065bc01b76..84db6b275231 100644
> > --- a/include/net/bluetooth/hci.h
> > +++ b/include/net/bluetooth/hci.h
> > @@ -566,6 +566,7 @@ enum {
> > #define HCI_ERROR_INVALID_LL_PARAMS   0x1e
> > #define HCI_ERROR_UNSPECIFIED         0x1f
> > #define HCI_ERROR_ADVERTISING_TIMEOUT 0x3c
> > +#define HCI_ERROR_CANCELLED_BY_HOST  0x44
> >
> > /* Flow control modes */
> > #define HCI_FLOW_CTL_MODE_PACKET_BASED        0x00
> > diff --git a/net/bluetooth/hci_event.c b/net/bluetooth/hci_event.c
> > index d4b75a6cfeee..150b50677790 100644
> > --- a/net/bluetooth/hci_event.c
> > +++ b/net/bluetooth/hci_event.c
> > @@ -5538,6 +5538,14 @@ static void hci_le_ext_adv_term_evt(struct hci_d=
ev *hdev, struct sk_buff *skb)
> >
> >       adv =3D hci_find_adv_instance(hdev, ev->handle);
> >
> > +     /* Some chips (e.g. RTL8822CE) emit HCI_ERROR_CANCELLED_BY_HOST. =
This
> > +      * event is being fired as a result of a hci_cp_le_set_ext_adv_en=
able
> > +      * disable request, which will have its own callback and cleanup =
via
> > +      * the hci_cc_le_set_ext_adv_enable path.
> > +      */
>
> I am not in favor of pointing fingers at bad hardware in the source code =
of core (that belongs in a commit message). Blaming hardware is really up t=
o the drivers. So I would rather phrase it like this:
>
>         /* The Bluetooth Core 5.3 specification clearly states that this =
event
>          * shall not be sent when the Host disables the advertising set. =
So in
>          * case of HCI_ERROR_CANCELLED_BY_HOST, just ignore the event.
>          *
>          * When the Host disables an advertising set, all cleanup is done=
 via
>          * its command callback and not needed to be duplicated here.
>          */
>
> > +     if (ev->status =3D=3D HCI_ERROR_CANCELLED_BY_HOST)
> > +             return;
> > +
>
> And since this is clearly an implementation issue, the manufactures can i=
ssue a firmware fix for this. So lets be verbose and complain about it.
>
>         if (ev->status =3D=3D HCI_ERRROR..) {
>                 bt_dev_warn_ratelimited(hdev, =E2=80=9CUnexpected adverti=
sing set terminated event=E2=80=9D);
>                 return;
>         }
>
> >       if (ev->status) {
> >               if (!adv)
> >                       return;
> > @@ -5546,6 +5554,10 @@ static void hci_le_ext_adv_term_evt(struct hci_d=
ev *hdev, struct sk_buff *skb)
> >               hci_remove_adv_instance(hdev, ev->handle);
> >               mgmt_advertising_removed(NULL, hdev, ev->handle);
> >
> > +             /* If we are no longer advertising, clear HCI_LE_ADV */
> > +             if (list_empty(&hdev->adv_instances))
> > +                     hci_dev_clear_flag(hdev, HCI_LE_ADV);
> > +
>
> See comment above why this might be better suited for a separate patch.
>
> Regards
>
> Marcel
>
