Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C0BC4199542
	for <lists+netdev@lfdr.de>; Tue, 31 Mar 2020 13:21:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730534AbgCaLVy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Mar 2020 07:21:54 -0400
Received: from mail-il1-f193.google.com ([209.85.166.193]:45815 "EHLO
        mail-il1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729925AbgCaLVx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Mar 2020 07:21:53 -0400
Received: by mail-il1-f193.google.com with SMTP id x16so19018129ilp.12;
        Tue, 31 Mar 2020 04:21:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=qKDkpoJr7FT+xSnuAXXrL+5r38BtzQdjQKiZus21QDE=;
        b=De49afrrOSEAE6d16LJHXttNzo3rRRZMfRBePwOMyj6Zz8IeO3du2R+ksJfiwpNOgJ
         +FMHm16y/a02jaI0SjMRzbLs4Hk/ImJqEw1Fjp/7iWYUUIeySx1NRiCNoJ6I8QzcicqI
         H60p/wDBGYpXAaJbqmWxOOQBELIx4/B5vxEVKM906pmwdKz1VJ+GG4ho79Lc/wZ3LBaC
         JTFN7N8DQw6Uaku8DXQBvqoF1VEPVFyS77tGIVgO4uik3bG6kVAhEWVT3VHnzxUtFSjN
         MdGyJwksUJ+5kPD2YxdZcqodMgVnKQ98zGRCbwy0Iv3/M9usgBxoqmkdv6FFR6lox/4X
         +Fxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=qKDkpoJr7FT+xSnuAXXrL+5r38BtzQdjQKiZus21QDE=;
        b=QV8CehD8oh5qWr13qVhrOI/jeOq7K7OaomY38Mk20IAj59jQC9aZygLSkMsuVr2KEw
         3pRap9W0Em1gDtS4rmjXGf3o65IVhHQogx4nCAOPl+z8ftubx8the8q/gaxUbe3QHYD5
         vbAakQCzqBrmL8gysoGIooIR29ZtILSnaOwSU28BJ3o22QOhw/XAujmz/v3ikJTuY/h9
         morF7qsAOIqQ2xeWwS5IuxxrDR2a9i02Y6X/3DPc6BaoaPdyZsd2M7X/gjhtdpNPtCyi
         6dacQrdgowSXfn5CUJn6LraKZ0Dei6uCvc9slZUb6didjoRyaq0Tns1ARRajw98JbazH
         Tx+w==
X-Gm-Message-State: ANhLgQ2M8lhL/RkUIdZPduWhBPC0/CDoOCsgoiNIi32q+yun0dsyZ2jL
        STrsPFDK9uyzPie0gQdOhjV94OE32DNiTsD78q3o1GlLF0w=
X-Google-Smtp-Source: ADFU+vtGPEg8G50KWWMKJaz5WV8TmjAedD99biDTTwbWYJRszva9IlMSkgggoXwqdJIdIsnLOfH3Qr5QTA18gJEf7ok=
X-Received: by 2002:a92:77c2:: with SMTP id s185mr15455250ilc.297.1585653711555;
 Tue, 31 Mar 2020 04:21:51 -0700 (PDT)
MIME-Version: 1.0
References: <1585625296-31013-1-git-send-email-hqjagain@gmail.com> <87bloc23d1.fsf@kamboji.qca.qualcomm.com>
In-Reply-To: <87bloc23d1.fsf@kamboji.qca.qualcomm.com>
From:   Qiujun Huang <hqjagain@gmail.com>
Date:   Tue, 31 Mar 2020 19:21:33 +0800
Message-ID: <CAJRQjofn+kMqueK+CuoJgdV-_Y6ChM2cCaGKOBJ=uVBDPpYKxA@mail.gmail.com>
Subject: Re: [PATCH] ath9k: fix stack-out-of-bounds Write in ath9k_hif_usb_rx_cb
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     ath9k-devel@qca.qualcomm.com,
        "David S. Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, anenbupt@gmail.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 31, 2020 at 7:03 PM Kalle Valo <kvalo@codeaurora.org> wrote:
>
> Qiujun Huang <hqjagain@gmail.com> writes:
>
> > Add barrier to accessing the stack array skb_pool.
> >
> > Reported-by: syzbot+d403396d4df67ad0bd5f@syzkaller.appspotmail.com
> > Signed-off-by: Qiujun Huang <hqjagain@gmail.com>
> > ---
> >  drivers/net/wireless/ath/ath9k/hif_usb.c | 5 +++++
> >  1 file changed, 5 insertions(+)
> >
> > diff --git a/drivers/net/wireless/ath/ath9k/hif_usb.c b/drivers/net/wireless/ath/ath9k/hif_usb.c
> > index dd0c323..c4a2b72 100644
> > --- a/drivers/net/wireless/ath/ath9k/hif_usb.c
> > +++ b/drivers/net/wireless/ath/ath9k/hif_usb.c
> > @@ -612,6 +612,11 @@ static void ath9k_hif_usb_rx_stream(struct hif_device_usb *hif_dev,
> >                       hif_dev->remain_skb = nskb;
> >                       spin_unlock(&hif_dev->rx_lock);
> >               } else {
> > +                     if (pool_index == MAX_PKT_NUM_IN_TRANSFER) {
> > +                             dev_err(&hif_dev->udev->dev,
> > +                                     "ath9k_htc: over RX MAX_PKT_NUM\n");
> > +                             goto err;
> > +                     }
>
> What about 'pool_index >= MAX_PKT_NUM_IN_TRANSFER' just to be on the
> safe side? Ah, but then error handling won't work:

Get that.

>
> err:
>         for (i = 0; i < pool_index; i++) {
>                 RX_STAT_ADD(skb_completed_bytes, skb_pool[i]->len);
>                 ath9k_htc_rx_msg(hif_dev->htc_handle, skb_pool[i],
>                                  skb_pool[i]->len, USB_WLAN_RX_PIPE);
>                 RX_STAT_INC(skb_completed);
>         }
>
> Maybe that should use 'min(pool_index, MAX_PKT_NUM_IN_TRANSFER - 1)' or
> something? Or maybe it's just overengineerin, dunno.

I will take a deeper look, thanks.

>
> --
> https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
