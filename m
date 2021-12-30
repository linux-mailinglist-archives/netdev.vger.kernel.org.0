Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F1037481F2C
	for <lists+netdev@lfdr.de>; Thu, 30 Dec 2021 19:24:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237129AbhL3SYZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Dec 2021 13:24:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233228AbhL3SYZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Dec 2021 13:24:25 -0500
Received: from mail-lf1-x12b.google.com (mail-lf1-x12b.google.com [IPv6:2a00:1450:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7ADAC061574
        for <netdev@vger.kernel.org>; Thu, 30 Dec 2021 10:24:24 -0800 (PST)
Received: by mail-lf1-x12b.google.com with SMTP id i31so55996819lfv.10
        for <netdev@vger.kernel.org>; Thu, 30 Dec 2021 10:24:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fungible.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=1db2pLvrUlBX+EBsSswBEqIzkkJUEqfzs6ogW7D0rXY=;
        b=bvG+ydJxOeS8mf+Tg0fJJIHhetXZDkchWx/zhKv8fYg+ictaBt74qBKm1A2ohfeer5
         XS0k72y4Ln8HGu94mgwOy2N3ap8LO8CJNtEYy2mRcV8ysd6a4P+NltL4fShnCA77DCsi
         UhiyW360z9OilgBAmbwRBHLpH8P+BUfmXDXZM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=1db2pLvrUlBX+EBsSswBEqIzkkJUEqfzs6ogW7D0rXY=;
        b=BK/BC2kyL8nZGaNGLthqVM6WrvmZGgtsM/tFkLfbO//U/CO+Mx1eiX+nQzHdBz1H+s
         HguJ212GgMFTigGHvjfxMwh75kACumxakkQSCWzwcO9s8bzXudQYz+iBY/iWzZEkf/uB
         EYHCz8rYjC/n7QpZ+zdOjk9xmvb0nTw+0vPU3/eOgY0pWyRnV/4EQJMeaP0dUWuwMFyU
         2Hm6m/z+wHgq/EbzFkJ0UCBhh6CjXHBBn0g/sxbtMXL6eU5GGDAYVfUnoOe5hgOIS4Wo
         Pok4YJaVovK5hvEGBQRnUiaEZSW2r/4AFJEnv3U0X00ODBcwPhvs4VhDe0kZ3Cgi3yOu
         BfGg==
X-Gm-Message-State: AOAM530FficsSvcvmIXV5TxzGjJYTqv8nu+uQz4ouTW8RbL0d0DXJyBF
        cMlGkduX5kAUaMQl4v/rJm9him2NpdbcclkHTfGqIaOA2lODUA==
X-Google-Smtp-Source: ABdhPJztKxxn8NiH9+anjwmdpzwbPZtvMsOeV8NORUfvD2bv6EnoXC9Dhb6UavarOtN+j6DHxZi36JlnlY4oi6GTcSM=
X-Received: by 2002:a05:6512:3093:: with SMTP id z19mr20622990lfd.670.1640888662888;
 Thu, 30 Dec 2021 10:24:22 -0800 (PST)
MIME-Version: 1.0
References: <20211230163909.160269-1-dmichail@fungible.com>
 <20211230163909.160269-3-dmichail@fungible.com> <Yc3sLEjF6O1CaMZZ@lunn.ch>
In-Reply-To: <Yc3sLEjF6O1CaMZZ@lunn.ch>
From:   Dimitris Michailidis <d.michailidis@fungible.com>
Date:   Thu, 30 Dec 2021 10:24:10 -0800
Message-ID: <CAOkoqZnoOgGDGcnDeOQxjZ_eYh8eyFHK_E+w7E6QHWAvaembKw@mail.gmail.com>
Subject: Re: [PATCH net-next 2/8] net/fungible: Add service module for
 Fungible drivers
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 30, 2021 at 9:28 AM Andrew Lunn <andrew@lunn.ch> wrote:
>
> > +/* Wait for the CSTS.RDY bit to match @enabled. */
> > +static int fun_wait_ready(struct fun_dev *fdev, bool enabled)
> > +{
> > +     unsigned int cap_to = NVME_CAP_TIMEOUT(fdev->cap_reg);
> > +     unsigned long timeout = ((cap_to + 1) * HZ / 2) + jiffies;
> > +     u32 bit = enabled ? NVME_CSTS_RDY : 0;
>
> Reverse Christmas tree, since this is a network driver.

The longer line in the middle depends on the previous line, I'd need to
remove the initializers to sort these by length.

> Please also consider using include/linux/iopoll.h. The signal handling
> might make that not possible, but signal handling in driver code is in
> itself very unusual.

This initialization is based on NVMe, hence the use of NVMe registers,
and this function is based on nvme_wait_ready(). The check sequence
including signal handling comes from there.

iopoll is possible with the signal check removed, though I see I'd need a
shorter delay than the 100ms used here and it doesn't check for reads of
all 1s, which happen occasionally. My preference though would be to keep
this close to the NVMe version. Let me know.

> > +
> > +     do {
> > +             u32 csts = readl(fdev->bar + NVME_REG_CSTS);
> > +
> > +             if (csts == ~0) {
> > +                     dev_err(fdev->dev, "CSTS register read %#x\n", csts);
> > +                     return -EIO;
> > +             }
> > +
> > +             if ((csts & NVME_CSTS_RDY) == bit)
> > +                     return 0;
> > +
> > +             msleep(100);
> > +             if (fatal_signal_pending(current))
> > +                     return -EINTR;
> > +     } while (time_is_after_eq_jiffies(timeout));
> > +
> > +     dev_err(fdev->dev,
> > +             "Timed out waiting for device to indicate RDY %u; aborting %s\n",
> > +             enabled, enabled ? "initialization" : "reset");
> > +     return -ETIMEDOUT;
> > +}
>
>   Andrew
