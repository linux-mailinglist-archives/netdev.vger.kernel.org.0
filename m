Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 16619305F93
	for <lists+netdev@lfdr.de>; Wed, 27 Jan 2021 16:28:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343828AbhA0P1y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jan 2021 10:27:54 -0500
Received: from mail-yb1-f176.google.com ([209.85.219.176]:46330 "EHLO
        mail-yb1-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236004AbhA0P0c (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Jan 2021 10:26:32 -0500
Received: by mail-yb1-f176.google.com with SMTP id e206so2330496ybh.13;
        Wed, 27 Jan 2021 07:26:16 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=g7J7YInXRf+vZfRSfEQpz6oEhJ+wLQcyQNNaVNH5HFY=;
        b=E3ObrQSskLNveWMs/JrnXSzo06UziGDWOK+BX4AdfhdtZeIMisOoTxuf1X0dJOUqTC
         8qhlh7HYWhjrgXucSJHTBGUxm26lnNkiwN6y4LC5EabqXZ55Q1grVlndZrH0xygjQ88Y
         5CD0OQGTqCePr7XMOZJPfOE/i0+4vxwZYzLcqzB9+SGJ+ujYayHSMrW5kX+P7+eo4pSu
         2bJt/7P1PlZbTVUnQKG0igje1I4cA+apkEmd2EYyiLu+D0zQSiL1dFyuNt8OityvVxmD
         4mjllzy9hFAerYHSiewmtZnACXYZWQGvdFnbw7JokXS+Zq/TzHPcgTSX9m96hGQRypJY
         9dWQ==
X-Gm-Message-State: AOAM531f3HJ0RJxIoRIzM+6Eg8RfmPOMJv5AdXP29xtn9x8Vu4xH+/00
        Sklj4eNgTuPpNpBCx3wXCH9JmUYmzrIHf8DMW+8=
X-Google-Smtp-Source: ABdhPJw6b+4YqfCUHQFu0EDKCVnaEN+FjT3gMkXkCXnIn9i2v+z8+N9sdwJai/5WPFR0tFKKv2lh3rEwu5EGUIuebyM=
X-Received: by 2002:a25:7783:: with SMTP id s125mr5616478ybc.111.1611761151447;
 Wed, 27 Jan 2021 07:25:51 -0800 (PST)
MIME-Version: 1.0
References: <20210126171550.3066-1-kernel@esmil.dk> <CAF=yD-LGoVkf5ARHPsGAMbsruDq7iQ=X8c3cZRp5XaZC936EMw@mail.gmail.com>
 <87pn1q8l0t.fsf@codeaurora.org>
In-Reply-To: <87pn1q8l0t.fsf@codeaurora.org>
From:   Emil Renner Berthing <kernel@esmil.dk>
Date:   Wed, 27 Jan 2021 16:25:39 +0100
Message-ID: <CANBLGcwmTt2bmpwST1qHzOFhVoYYPC_gEz3nARzR9mOOg6nOHA@mail.gmail.com>
Subject: Re: [PATCH] rtlwifi: use tasklet_setup to initialize rx_work_tasklet
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Ping-Ke Shih <pkshih@realtek.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Allen Pais <allen.lkml@gmail.com>,
        Romain Perier <romain.perier@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 27 Jan 2021 at 16:20, Kalle Valo <kvalo@codeaurora.org> wrote:
>
> Willem de Bruijn <willemdebruijn.kernel@gmail.com> writes:
>
> > On Wed, Jan 27, 2021 at 5:23 AM Emil Renner Berthing <kernel@esmil.dk> wrote:
> >>
> >> In commit d3ccc14dfe95 most of the tasklets in this driver was
> >> updated to the new API. However for the rx_work_tasklet only the
> >> type of the callback was changed from
> >>   void _rtl_rx_work(unsigned long data)
> >> to
> >>   void _rtl_rx_work(struct tasklet_struct *t).
> >>
> >> The initialization of rx_work_tasklet was still open-coded and the
> >> function pointer just cast into the old type, and hence nothing sets
> >> rx_work_tasklet.use_callback = true and the callback was still called as
> >>
> >>   t->func(t->data);
> >>
> >> with uninitialized/zero t->data.
> >>
> >> Commit 6b8c7574a5f8 changed the casting of _rtl_rx_work a bit and
> >> initialized t->data to a pointer to the tasklet cast to an unsigned
> >> long.
> >>
> >> This way calling t->func(t->data) might actually work through all the
> >> casting, but it still doesn't update the code to use the new tasklet
> >> API.
> >>
> >> Let's use the new tasklet_setup to initialize rx_work_tasklet properly
> >> and set rx_work_tasklet.use_callback = true so that the callback is
> >> called as
> >>
> >>   t->callback(t);
> >>
> >> without all the casting.
> >>
> >> Fixes: 6b8c7574a5f8 ("rtlwifi: fix build warning")
> >> Fixes: d3ccc14dfe95 ("rtlwifi/rtw88: convert tasklets to use new
> >> tasklet_setup() API")
> >> Signed-off-by: Emil Renner Berthing <kernel@esmil.dk>
> >
> > Since the current code works, this could target net-next
>
> This should go to wireless-drivers-next, not net-next.
>
> > without Fixes tags.
>
> Correct, no need for Fixes tag as there's no bug to fix. This is only
> cleanup AFAICS.

I can definitely see how you can reasonably disagree, but I would not
be comfortable having code that only works because the calling
conventions of all relevant architectures happen to put the first
unsigned long argument and the first pointer argument in the same
register.
If you want to be conservative I'd much rather revert all the changes
around rx_work_tasklet including the new type of the _rtl_rx_work
callback, so we don't have to rely on calling conventions matching up.

In any case: as long as this fix eventually ends up upstream I'm fine.

/Emil
