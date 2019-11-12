Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EF37FF94BC
	for <lists+netdev@lfdr.de>; Tue, 12 Nov 2019 16:51:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727116AbfKLPvl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Nov 2019 10:51:41 -0500
Received: from mail-qt1-f193.google.com ([209.85.160.193]:44174 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726008AbfKLPvl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Nov 2019 10:51:41 -0500
Received: by mail-qt1-f193.google.com with SMTP id o11so20195010qtr.11;
        Tue, 12 Nov 2019 07:51:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=LQBXaQZ8sYLX3FvyToEo9vTTZBjJQsr8E1LEgLzRPXs=;
        b=RsE9lrNVKHVIjj4mLDlw3H/mypAihdMOWqmZd+CTUbTTAjq0/uplgxGeoxMwaJtIU8
         JSxXfXBrRZtwLtJQBpO/wtp+ER6o35mC+oW16bJleR6ygLAc0ps7Z7PYt0zU14i3wtF2
         CUhXzZkHnbnUtfjy+gfeX2iL5kE1bErsZS0DSx5nck/gJ7OlhzV8zgP/IoNJGTxz+kd3
         ib98Gio8uq13GOr1ylMTj0i6YxTDDaPpqUtMCpVqbW2KuwgT677J8zkoCZW/qieBgJNs
         K9xNmiY9uibdCWd+69izfCe4yNKpWjml7LQ7zUw4TNljpcqQOrsL2dNGI0Zq87SOlgsG
         /TCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=LQBXaQZ8sYLX3FvyToEo9vTTZBjJQsr8E1LEgLzRPXs=;
        b=JZ0BbjV5+Wzi3o69GSQ2DCZKefoYNlskilEegjYI5MaqOjWIGIaJVJdRVOhlSHDYbj
         UrJzT3Im9tMHPkMlg+3eBSM2ZFNhTsFbGSeYOIwd4L1tZqt6BL4chvg0mQFeoKOlSIES
         uGEiBpGSonAujh8pYlZ1yEVU6tIhQ/ZmyinWWzhP418wMvc7FpxN3nIyllgdIvp3OcK4
         dN0wKYxQzSMx7+zr6dnrbjVe6rVgIVpbMf5TJub7mpzsm1gRAWHbPyfTmuZ1FXnN6rmE
         q6Uc1ecloC4YreHH4XLPn1Ddq2V8A2Uf6EEVHmy88EtomPHLFzYckD0o3ZxZSU5igy4q
         BxqQ==
X-Gm-Message-State: APjAAAV02XtIebtXpkrU2hn9en/gVpHW8ZFxrHz4WXOCFgiORdPFAkmY
        /43AfXUTOVQULSMJ8Q3WhEQKCnC7VcIJ+lvdJrMkyg==
X-Google-Smtp-Source: APXvYqw2USUknyNH12Zul6mHL6lqDlsWSFY9lTdDbwPKg2Pz6XlR6gnfvP35zB3LnBBhMSCqM3nWOFtORufpMc4G9HU=
X-Received: by 2002:ac8:293a:: with SMTP id y55mr32569355qty.118.1573573899944;
 Tue, 12 Nov 2019 07:51:39 -0800 (PST)
MIME-Version: 1.0
References: <20191106231650.1580-1-jeffrey.l.hugo@gmail.com> <20191112084225.casuncbo7z54vu4g@netronome.com>
In-Reply-To: <20191112084225.casuncbo7z54vu4g@netronome.com>
From:   Jeffrey Hugo <jeffrey.l.hugo@gmail.com>
Date:   Tue, 12 Nov 2019 08:51:28 -0700
Message-ID: <CAOCk7NpNgtTSus2KtBMe=jGLFyBumVfRVxKxtHoEDUEt2-6tqQ@mail.gmail.com>
Subject: Re: [PATCH] ath10k: Fix qmi init error handling
To:     Simon Horman <simon.horman@netronome.com>
Cc:     kvalo@codeaurora.org, davem@davemloft.net,
        ath10k@lists.infradead.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, MSM <linux-arm-msm@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 12, 2019 at 1:42 AM Simon Horman <simon.horman@netronome.com> wrote:
>
> On Wed, Nov 06, 2019 at 03:16:50PM -0800, Jeffrey Hugo wrote:
> > When ath10k_qmi_init() fails, the error handling does not free the irq
> > resources, which causes an issue if we EPROBE_DEFER as we'll attempt to
> > (re-)register irqs which are already registered.
> >
> > Fixes: ba94c753ccb4 ("ath10k: add QMI message handshake for wcn3990 client")
> > Signed-off-by: Jeffrey Hugo <jeffrey.l.hugo@gmail.com>
> > ---
> >  drivers/net/wireless/ath/ath10k/snoc.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/drivers/net/wireless/ath/ath10k/snoc.c b/drivers/net/wireless/ath/ath10k/snoc.c
> > index fc15a0037f0e..f2a0b7aaad3b 100644
> > --- a/drivers/net/wireless/ath/ath10k/snoc.c
> > +++ b/drivers/net/wireless/ath/ath10k/snoc.c
> > @@ -1729,7 +1729,7 @@ static int ath10k_snoc_probe(struct platform_device *pdev)
> >       ret = ath10k_qmi_init(ar, msa_size);
> >       if (ret) {
> >               ath10k_warn(ar, "failed to register wlfw qmi client: %d\n", ret);
> > -             goto err_core_destroy;
> > +             goto err_free_irq;
> >       }
>
> From a casual examination of the code this seems like a step in the right
> direction. But does this error path also need to call ath10k_hw_power_off() ?

It probably should.  I don't see any fatal errors from the step being
skipped, although it might silence some regulator warnings about being
left on.  Unlikely to be observed by most folks as I was initing the
driver pretty early to debug some things.  Looks like Kalle already
picked up this patch though, so I guess your suggestion would need to
be a follow up.
