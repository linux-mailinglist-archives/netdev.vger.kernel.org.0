Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 34FF43A2424
	for <lists+netdev@lfdr.de>; Thu, 10 Jun 2021 07:55:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229808AbhFJF5J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Jun 2021 01:57:09 -0400
Received: from mail-lj1-f180.google.com ([209.85.208.180]:41629 "EHLO
        mail-lj1-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229634AbhFJF5H (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Jun 2021 01:57:07 -0400
Received: by mail-lj1-f180.google.com with SMTP id z22so3092831ljh.8;
        Wed, 09 Jun 2021 22:54:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=u0FtwB+OlBrh5S/mTC2ETvvyD0FyxJjtP3SC5BMuDhs=;
        b=IYzf8/9bnHi+pEs8IVLQneuQRJQVj3fRf5NgnUbC+qu4bAmkmJiBmUVkm+XxkHxu1S
         /LPRqirtMPx+IqgVnv0gs79k3DXf7HbvRDgkl3VEacUOKR47WEN4VGjRBuosK6Kpeo8n
         ZdecatW55OWl8KLaUlJhl/21en09CqRG39vt4TeozKgQLxG63ij4NhLElwn8sUf5wTb+
         jDui/X5vx09RVpkr1DjQ0w+sF6a6eMLMAW6rnZN7k0MNMo5qHpA0+ttrFpIdmyd4jo+L
         wLHxGsehPYBbo3IqTUUm2mwoocMF5ZA4saEQ50+kiuozr3PGgmKYvMSUEPR2m8ew2QNV
         5YTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=u0FtwB+OlBrh5S/mTC2ETvvyD0FyxJjtP3SC5BMuDhs=;
        b=DJcvKmMFHaPNE1Qg072pXpvevP5ikGDF++3QGS0qYWMoWY4CjJumtzCm21b9z84xNY
         wGRnalCoq2qvH/2RByvXqKpCtUzd113gRMd9CKHULEuDAjZAExbmYJcHRp9CuQnuvGGi
         zSfX778131NXezw/b0ey/DHewaqFx61a3XgQuj0RhY4f1B253Fa+P8aWs0HaU5cB84dQ
         2udkEP9N1mQpgvlGk4eN1qhu8yspJIb9YV7xmI2lO67So8Xpk1J5MEyTtx2QjgdmUyhq
         fkEve7gx8pWxhwMxLz6EtMZ3hDfguWaQkY2sQ1REK24tPhA0QRHdXrylqjSZscJrM9FA
         bbRQ==
X-Gm-Message-State: AOAM530PksGiskKFE92dOVN9Zu+3U1phXd1lvl67chLoUnLvdgRSDMtb
        jLzksyPNgXvou2p/L3svd+dXcx7u+YrqSUGG/A==
X-Google-Smtp-Source: ABdhPJxuIUVF4ItXdV13staBsOh2jQ/iWmsgIa+giv1PAOwLym9wD0SxAp+Lg8Ad6hLnod0PXZWAOKbUbTM+6qN4I6g=
X-Received: by 2002:a2e:b614:: with SMTP id r20mr905597ljn.382.1623304437088;
 Wed, 09 Jun 2021 22:53:57 -0700 (PDT)
MIME-Version: 1.0
References: <3494dcf6-14ca-be2b-dbf8-dda2e208b70b@ti.com> <20210610004342.4493-1-praneeth@ti.com>
 <YMGP/aim6CD270Yo@lunn.ch>
In-Reply-To: <YMGP/aim6CD270Yo@lunn.ch>
From:   Johannes Pointner <h4nn35.work@gmail.com>
Date:   Thu, 10 Jun 2021 07:53:46 +0200
Message-ID: <CAHvQdo0YAmAo_1m7LgLS200a7fNz-vYJkwR74AxckQm-iu0tuA@mail.gmail.com>
Subject: Re: [PATCH v2] net: phy: dp83867: perform soft reset and retain
 established link
To:     praneeth@ti.com, Geet Modi <geet.modi@ti.com>,
        Andrew Lunn <andrew@lunn.ch>
Cc:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

On Thu, Jun 10, 2021 at 6:10 AM Andrew Lunn <andrew@lunn.ch> wrote:
>
> On Wed, Jun 09, 2021 at 07:43:42PM -0500, praneeth@ti.com wrote:
> > From: Praneeth Bajjuri <praneeth@ti.com>
> >
> > Current logic is performing hard reset and causing the programmed
> > registers to be wiped out.
> >
> > as per datasheet: https://www.ti.com/lit/ds/symlink/dp83867cr.pdf
> > 8.6.26 Control Register (CTRL)
> >
> > do SW_RESTART to perform a reset not including the registers,
> > If performed when link is already present,
> > it will drop the link and trigger re-auto negotiation.
> >
> > Signed-off-by: Praneeth Bajjuri <praneeth@ti.com>
> > Signed-off-by: Geet Modi <geet.modi@ti.com>
>
> Reviewed-by: Andrew Lunn <andrew@lunn.ch>
>
>     Andrew

I reported a few days ago an issue with the DP83822 which I think is
caused by a similar change.
https://lore.kernel.org/netdev/CAHvQdo2yzJC89K74c_CZFjPydDQ5i22w36XPR5tKVv_W8a2vcg@mail.gmail.com/
In my case I can't get an link after this change, reverting it fixes
the problem for me.

Hannes
