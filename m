Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 90AC6306084
	for <lists+netdev@lfdr.de>; Wed, 27 Jan 2021 17:05:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236927AbhA0QFH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jan 2021 11:05:07 -0500
Received: from mail-yb1-f171.google.com ([209.85.219.171]:33599 "EHLO
        mail-yb1-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236374AbhA0QCB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Jan 2021 11:02:01 -0500
Received: by mail-yb1-f171.google.com with SMTP id i141so2510023yba.0;
        Wed, 27 Jan 2021 08:01:46 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=yepEAjXY6R6spMmhtoWe8WjXNXVezUuhMTMgdZv+bxY=;
        b=Ab+6BerXgphwVaPZZKiT7IeYqSXYvDe4NV40EkUShsZoZo3hadfZ+1eng2WzscJiCS
         eqbNkg8si0rCA6BdLCTHVfj4Ziy0Nf32vsDFAyvLeD8HETrpT+i8V4ghBW/1lPE0NRhf
         IQXF9CvQ1SSJrovZF5XTb5D3VsZyWJKCCyOg+/ML/HZOI8x8jWKXBxWFmncQAUHdVf8h
         ATQPWHIqIgUEiX/qnBIM9QBTtY570Uign1q2YtItDUWH88nHOCJO2zBcBVQzJ4BQHdPz
         lZvt4nwCinKfzDUdAMksR+ww7en89UbGkt3KrIRMu0RyJ2LP7Ul0Vog5+pH2B15xKFiZ
         7nwQ==
X-Gm-Message-State: AOAM533CQveumLuNRsnh8We3D2XDDgF1OqTpbNyEqKfovPBwrUOTsaH1
        tuoTh55vHSc97WHtIIIbTdXbrVzFicpptn8vHyU=
X-Google-Smtp-Source: ABdhPJzg/HGDPUImAxYpyvDw+CFmq8I77SNxfyByZ6JGDcF7jwdlWSZG9M7iYncmpN6BcAFWQbVigJ0zAGn6Nuvt1Tg=
X-Received: by 2002:a25:324b:: with SMTP id y72mr17025245yby.23.1611763280688;
 Wed, 27 Jan 2021 08:01:20 -0800 (PST)
MIME-Version: 1.0
References: <20210126171550.3066-1-kernel@esmil.dk> <CAF=yD-LGoVkf5ARHPsGAMbsruDq7iQ=X8c3cZRp5XaZC936EMw@mail.gmail.com>
 <87pn1q8l0t.fsf@codeaurora.org> <CANBLGcwmTt2bmpwST1qHzOFhVoYYPC_gEz3nARzR9mOOg6nOHA@mail.gmail.com>
 <87lfce8keh.fsf@codeaurora.org>
In-Reply-To: <87lfce8keh.fsf@codeaurora.org>
From:   Emil Renner Berthing <kernel@esmil.dk>
Date:   Wed, 27 Jan 2021 17:01:08 +0100
Message-ID: <CANBLGcwfK41+E9JzrU_Hym8VK5S4rGdsyKCHMRiABQvt2zL4kg@mail.gmail.com>
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

On Wed, 27 Jan 2021 at 16:33, Kalle Valo <kvalo@codeaurora.org> wrote:
> ...
> Forgot to mention that I can remove the Fixes tags during commit, so no
> need to resend just because of those.

Cool, thanks.

> > I can definitely see how you can reasonably disagree, but I would not
> > be comfortable having code that only works because the calling
> > conventions of all relevant architectures happen to put the first
> > unsigned long argument and the first pointer argument in the same
> > register.
>
> If there's a bug this patch fixes please explain it clearly in the
> commit log. But as I read it (though I admit very quickly) I understood
> this is just cleanup.

Sorry, I'll try again.

So the tasklet_struct looks like this:
struct tasklet_struct {
  ..
  bool use_callback;
  union {
    void (*func)(unsigned long);
    void (*callback)(struct tasklet_struct *);
  };
  unsigned long data;
};

..and the use_callback flag is used like this:
if (t->use_callback)
  t->callback(t);
else
  t->func(t->data);

Now commit d3ccc14dfe95 changed the _rtl_rx_work to be of the new
callback, not func, type. But it didn't actually set the use_callback
flag, and just typecast the _rtl_rx_work function pointer and assigned
it to the func member. So _rtl_rx_work is still called as
t->func(t->data) even though it was rewritten to be called as
t->callback(t).
Now 6b8c7574a5f8 set t->data = (unsigned long)t, so calling
t->func(t->data) will probably work on most architectures because:

a) "unsigned long" and "struct tasklet_struct *" has the same width on
all Linux-capable architectures and
b) calling t->func(t->data) will put the value from t->data into the
same register as the function
    void _rtl_rx_work(struct tasklet_struct *t)
  expects to find the pointer t in the C calling conventions used by
all relevant architectures.

I guess it's debatable weather this is a bug or just ugly code.

/Emil
