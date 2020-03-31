Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C5C4919956F
	for <lists+netdev@lfdr.de>; Tue, 31 Mar 2020 13:40:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730543AbgCaLkK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Mar 2020 07:40:10 -0400
Received: from mail-io1-f66.google.com ([209.85.166.66]:34490 "EHLO
        mail-io1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730343AbgCaLkK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Mar 2020 07:40:10 -0400
Received: by mail-io1-f66.google.com with SMTP id h131so21322731iof.1;
        Tue, 31 Mar 2020 04:40:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=GvfMZgwwya4ZSH2OS8e5IKouh92EbNGvwaXpIPfmMZU=;
        b=HS3MXxUze51pqFaHc52OMaPkf+JHkR9fOcDmckzaIhHmhnG6RnivzmAx7X/1bSOW7W
         TXGjPqGU+CeKwCa9KP9JhXaNOngahNLeHUdjTKYEU+t+gQ8IdNiGf5ode1Wy7nMe5uF+
         41LboL1lOLWLZqPTsVX6AxSFLxYY8AtfPQla33L1MOLcI9Yv5U+riazFwhaoZvE45dCY
         ICXrPXX0mpGK+r4dPIh9Y2i4onsrVUIY9vTsvhTpaWbI6ciOnL1jF6Wrme2dCsW2THEp
         a4cf57cgiJpybFo/ihMtVg7qOU2gMZZT696Dm5dBxbpX7tz+BBsLUkJpcdjI0d1Hjog9
         qpiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=GvfMZgwwya4ZSH2OS8e5IKouh92EbNGvwaXpIPfmMZU=;
        b=QiUYWDgq/me77eGel8HsZRzStH2GROMyprkFl8brXHIwWmwmJAuscFzaMzXU2LqbyN
         MyDpLP2bEK+scIAK9h9C+OxPXB/m+XSlgHLCsNYcEqjRgBEymoKs3+SrMkssKs/Qw2zA
         +4ETx9cx2us1hBR741WYBGVxpmF5sJP/dSTm3LpEcb/PzzFOHwxHiuAtxV3FZZMhMTt9
         9mzIyBYw6oi7lffCzUMBNFeiwS7ZPkjKsGr3pMvJ4xblb2aUlrOAgXQ0Tr7HEGvIVhLt
         ze8PWy1ndkdb95U8QCFtX/NuvjWn3NlfqkpVS8GGgybDEsbvQcc34DyCbbUiqsmsgYoY
         S8bA==
X-Gm-Message-State: ANhLgQ2fX+z5yGsWml7LbAQSq5NXTw7TxZfiU82KX05BdtBuEt3tE+AL
        9+W8/KClkCi7JicdCK2MXsuMPT2IWVgEO2dvFuw=
X-Google-Smtp-Source: ADFU+vsF87hpVW35ufXfPeeeySR9ePWlx1H9GQn0Al/KxFVH01m9lLLgTtl4tDNU9Fb00y4+Wa1QAd+Wi9lSCqiwRDo=
X-Received: by 2002:a5d:984b:: with SMTP id p11mr1163615ios.175.1585654808716;
 Tue, 31 Mar 2020 04:40:08 -0700 (PDT)
MIME-Version: 1.0
References: <1585625296-31013-1-git-send-email-hqjagain@gmail.com> <87bloc23d1.fsf@kamboji.qca.qualcomm.com>
In-Reply-To: <87bloc23d1.fsf@kamboji.qca.qualcomm.com>
From:   Qiujun Huang <hqjagain@gmail.com>
Date:   Tue, 31 Mar 2020 19:39:51 +0800
Message-ID: <CAJRQjodOEoP-H7x_XjB5MxCFfgLeb1Bt=XfDT_rhLcBdyt=mQg@mail.gmail.com>
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
the  barrier ensure pool_index <= MAX_PKT_NUM_IN_TRANSFER
> > +                     }
>
> What about 'pool_index >= MAX_PKT_NUM_IN_TRANSFER' just to be on the
> safe side? Ah, but then error handling won't work:
It looks ok?
it can handle the case: pool_index == MAX_PKT_NUM_IN_TRANSFER
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
>
> --
> https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
