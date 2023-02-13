Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 12361693CBF
	for <lists+netdev@lfdr.de>; Mon, 13 Feb 2023 04:02:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229786AbjBMDCa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 12 Feb 2023 22:02:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229675AbjBMDC3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 12 Feb 2023 22:02:29 -0500
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90EA43AAC;
        Sun, 12 Feb 2023 19:02:28 -0800 (PST)
Received: by mail-pj1-x1034.google.com with SMTP id on9-20020a17090b1d0900b002300a96b358so10846721pjb.1;
        Sun, 12 Feb 2023 19:02:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MEDbcOxolU0HbrfFxohAD9L+LzxXEe4zIJugK/4itx8=;
        b=apLe2YguA0Pc6sL6izJba1F3C4lKTe96SewT9pJU87Apnsrl6AEbe/WefFWdXsOpUg
         81FmmSE0GgYlpMVdhZvl6mDEbcBPkhRRO6N/Y2SnftetvAvtO3ia9+tMEZ1epBPPrNn9
         kRtyHLfEDleKvIE8jhrUJt6TpcPgBtUNWizgWR9Te59Wf6v2D2NsFf1IiZ5+ubMSDakJ
         xFmlE8bb5KbbH2gNbZZuP/f0uZDd210GCGBA8SqupNDc47EJ9PIBadV/VaZtM0rP0+SK
         5g2Jf08fhhGbwDYUWP2e7u9Y1S6AqhZTgb/aLC7tZuwBwL9GN+x1KQ526ON38yc+DCiz
         Iuzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=MEDbcOxolU0HbrfFxohAD9L+LzxXEe4zIJugK/4itx8=;
        b=5rfKGpmnsS+dec3UW2CpPVkKLOJsykR1B9R2qbGv52tQOQoG+lrOaFW+nFcwnsblHL
         p0LFncyA0db/r9skJjzc4dHAW7HvgEkbvHhpQTFQPSHZerK9rDnRfzrPRzlCPeoW7zmo
         0EmTf6i9k5c0f63n78rWNEe+vcRP6yDjeeXQWGFKKV/Fe5szwzsrAKIDz6Uk+9x6TVHu
         ge0IByDTW0JFpQeyIz3gRyqJ596EwJcUkmkXXEtfp0FYdUikh8Vv3apUM9fLu3FoD2qB
         58Wn+px6+/ooiSblbaObeiVX/HfkiosETfYOv11gtK98hnB4hbao4kBLA48Kh6h2/KI/
         P9Cg==
X-Gm-Message-State: AO0yUKVhap/Z7VgDgrh9db4rygtFHPtdAoWrOhQc5VS71+SUVRY5Ooo7
        B+/cpdWtEHVAFxQeXxtYDRB46tGlP8TDKEwblxY=
X-Google-Smtp-Source: AK7set/e+qARK/QtVij3sON012kQwYFF4eRiBpS/im1W7rNc454vIcpW5lF3mWQIO6atACkpJuwR+qHAmC6nL4i8EBM=
X-Received: by 2002:a17:90a:4ec6:b0:233:fa66:8c22 with SMTP id
 v6-20020a17090a4ec600b00233fa668c22mr335693pjl.115.1676257347849; Sun, 12 Feb
 2023 19:02:27 -0800 (PST)
MIME-Version: 1.0
References: <20230210041030.865478-1-zyytlz.wz@163.com> <CABBYNZL_gZ+kr_OEqjYgMmt+=91=jC88g310F-ScMC=kLh0xdw@mail.gmail.com>
In-Reply-To: <CABBYNZL_gZ+kr_OEqjYgMmt+=91=jC88g310F-ScMC=kLh0xdw@mail.gmail.com>
From:   Zheng Hacker <hackerzheng666@gmail.com>
Date:   Mon, 13 Feb 2023 11:02:14 +0800
Message-ID: <CAJedcCxXpNOk9bxMziaYAzKBWb1RCVJoJn_2y=8WMn6S3vAkCw@mail.gmail.com>
Subject: Re: [PATCH] Bluetooth: hci_core: Fix poential Use-after-Free bug in hci_remove_adv_monitor
To:     Luiz Augusto von Dentz <luiz.dentz@gmail.com>
Cc:     Zheng Wang <zyytlz.wz@163.com>, marcel@holtmann.org,
        alex000young@gmail.com, johan.hedberg@gmail.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, linux-bluetooth@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Luiz Augusto von Dentz <luiz.dentz@gmail.com> =E4=BA=8E2023=E5=B9=B42=E6=9C=
=8811=E6=97=A5=E5=91=A8=E5=85=AD 03:53=E5=86=99=E9=81=93=EF=BC=9A
>
> Hi Zheng,
>
> On Thu, Feb 9, 2023 at 8:11 PM Zheng Wang <zyytlz.wz@163.com> wrote:
> >
> > In hci_remove_adv_monitor, if it gets into HCI_ADV_MONITOR_EXT_MSFT cas=
e,
> > the function will free the monitor and print its handle after that.
> >
> > Fix it by switch the order.
> >
> > Fixes: 7cf5c2978f23 ("Bluetooth: hci_sync: Refactor remove Adv Monitor"=
)
> > Signed-off-by: Zheng Wang <zyytlz.wz@163.com>
> > ---
> >  net/bluetooth/hci_core.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/net/bluetooth/hci_core.c b/net/bluetooth/hci_core.c
> > index b65c3aabcd53..db3352c60de6 100644
> > --- a/net/bluetooth/hci_core.c
> > +++ b/net/bluetooth/hci_core.c
> > @@ -1980,9 +1980,9 @@ static int hci_remove_adv_monitor(struct hci_dev =
*hdev,
> >                 goto free_monitor;
> >
> >         case HCI_ADV_MONITOR_EXT_MSFT:
> > -               status =3D msft_remove_monitor(hdev, monitor);
> >                 bt_dev_dbg(hdev, "%s remove monitor %d msft status %d",
> >                            hdev->name, monitor->handle, status);
> > +               status =3D msft_remove_monitor(hdev, monitor);
>
> I wonder if it is not a good idea to move the logging inside
> msft_remove_monitor?
>
> >                 break;
> >         }
> >
Hello Luiz,

Thanks for your quick reply. I think moving it inside msft_remove_monitor
is a good idea. Because the variable status is returned by msft_remove_moni=
tor.
The call chain is
msft_remove_monitor
  ->msft_remove_monitor_sync
    ->msft_le_cancel_monitor_advertisement_cb
      ->hci_free_adv_monitor
        ->kfree(monitor);
We could mov the bt_dev_dbg to the location before
hci_free_adv_monitor calling and delete the releated code in
hci_remove_adv_monitor.

If you agree with that, I'll make another patch.

Best regards,
Zheng Wang
