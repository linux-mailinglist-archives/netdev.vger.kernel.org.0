Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6CF1262EA5
	for <lists+netdev@lfdr.de>; Tue,  9 Jul 2019 05:20:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726658AbfGIDQO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Jul 2019 23:16:14 -0400
Received: from mail-io1-f65.google.com ([209.85.166.65]:42840 "EHLO
        mail-io1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726371AbfGIDQO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Jul 2019 23:16:14 -0400
Received: by mail-io1-f65.google.com with SMTP id u19so39994229ior.9
        for <netdev@vger.kernel.org>; Mon, 08 Jul 2019 20:16:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=nGOmh29TGZafyfyVJOcn2nosHFNl3QrLZzpaQS9XMrM=;
        b=XaniDyCjntbObOD8X/yiWenq7ANSZO/SZT8l1d93R9wjjRQVhuhRiA5WmC7lUfH+MS
         WHQJv3VlX2NOhg75TY0qfVtPob9g0ibhdZwgdEnwIvpTIYRei2zWS60TyntBeLsL4IwQ
         8JoUCpkFDaOpz1UK2vunL3Gpa7c8yDATvdMgU9BdNowWgDh6gXBnfUVKT4CV4vhQlyat
         B8lyXEyk8Lc2/Fg6l7PZ259Xlr2JnNcideN+N0z7uYx1z5QG/hn6QGbI6gT+zIhjvhmM
         fIBy5dJYc3j4LwiR64ILvu1HtLJsWUnc7BksArtngZX6MDkka+OreAO7+Y2m4v9PZTYL
         pA4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=nGOmh29TGZafyfyVJOcn2nosHFNl3QrLZzpaQS9XMrM=;
        b=tWuX09pIXF9fIPj84AA2TmxNfyDpfTLbMoCLDnFBtpbY0awlEMlo2GEvuPkCsR4inb
         jpzN2JLOKada8WUnbEDdb7WSZOOZylrfcvH+exAMks7QeEqbsBIVsBj9YVJz9kFB1ikg
         P1YOUoQ5UH7Nb9agUdQTviBHM5lgpLWGkESzpaAmM5c4jDZJ2iCdhzEHqXnB9ovT/zS4
         zRq7YMKlnp6exVg9oyKHS6pE6EaTOr44CpLU0UervKQZc3AGwLHpRRYxvfxeVw/bweL0
         2Z4zK5hbywkOisBUHznb0JtixjEb52CouZO9l2BG9zTZxwyLEJEnlayAAQYqSsj9crC4
         Zo3w==
X-Gm-Message-State: APjAAAX3su8DNuYgQK1hcqG5hZWji6LwRs3hXVUuR5ZSummIum7mgOv4
        /gwt00myMM07UgoIiztDm1e7q/bJ5C9Shjlf+wqBgA==
X-Google-Smtp-Source: APXvYqxQrt1oV8q8p1cSTfywmnz1kJhSMyp7d6/N40Kg3eS/vfmmXAbqvkPdf05FtQyW0okYWKIfuYu6vACede7+Iak=
X-Received: by 2002:a5d:9291:: with SMTP id s17mr19848417iom.10.1562642173287;
 Mon, 08 Jul 2019 20:16:13 -0700 (PDT)
MIME-Version: 1.0
References: <1562538732-20700-1-git-send-email-kwangdo.yi@gmail.com> <539888f4-e5be-7ad5-53ce-63dd182708b1@gmail.com>
In-Reply-To: <539888f4-e5be-7ad5-53ce-63dd182708b1@gmail.com>
From:   kwangdo yi <kwangdo.yi@gmail.com>
Date:   Mon, 8 Jul 2019 23:16:02 -0400
Message-ID: <CAFHy5LAQyL2JW1Lox67OSz2WuRnzhVgSk6-0hfHf=gG2fXYmRQ@mail.gmail.com>
Subject: Re: [PATCH] phy: added a PHY_BUSY state into phy_state_machine
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I simply fixed this issue by increasing the polling time from 20 msec to
60 msec in Xilinx EMAC driver. But the state machine would be in a
better shape if it is capable of handling sub system driver's fake failure.
PHY device driver could advertising the min/max timeouts for its subsystem,
but still some vendor's EMAC driver fails to meet the deadline if this value
is not set properly in PHY driver.

On Sun, Jul 7, 2019 at 11:07 PM Florian Fainelli <f.fainelli@gmail.com> wrote:
>
> +Andrew, Heiner (please CC PHY library maintainers).
>
> On 7/7/2019 3:32 PM, kwangdo.yi wrote:
> > When mdio driver polling the phy state in the phy_state_machine,
> > sometimes it results in -ETIMEDOUT and link is down. But the phy
> > is still alive and just didn't meet the polling deadline.
> > Closing the phy link in this case seems too radical. Failing to
> > meet the deadline happens very rarely. When stress test runs for
> > tens of hours with multiple target boards (Xilinx Zynq7000 with
> > marvell 88E1512 PHY, Xilinx custom emac IP), it happens. This
> > patch gives another chance to the phy_state_machine when polling
> > timeout happens. Only two consecutive failing the deadline is
> > treated as the real phy halt and close the connection.
>
> How about simply increasing the MDIO polling timeout in the Xilinx EMAC
> driver instead? Or if the PHY is where the timeout needs to be
> increased, allow the PHY device drivers to advertise min/max timeouts
> such that the MDIO bus layer can use that information?
>
> >
> >
> > Signed-off-by: kwangdo.yi <kwangdo.yi@gmail.com>
> > ---
> >  drivers/net/phy/phy.c | 6 ++++++
> >  include/linux/phy.h   | 1 +
> >  2 files changed, 7 insertions(+)
> >
> > diff --git a/drivers/net/phy/phy.c b/drivers/net/phy/phy.c
> > index e888542..9e8138b 100644
> > --- a/drivers/net/phy/phy.c
> > +++ b/drivers/net/phy/phy.c
> > @@ -919,7 +919,13 @@ void phy_state_machine(struct work_struct *work)
> >               break;
> >       case PHY_NOLINK:
> >       case PHY_RUNNING:
> > +     case PHY_BUSY:
> >               err = phy_check_link_status(phydev);
> > +             if (err == -ETIMEDOUT && old_state == PHY_RUNNING) {
> > +                     phy->state = PHY_BUSY;
> > +                     err = 0;
> > +
> > +             }
> >               break;
> >       case PHY_FORCING:
> >               err = genphy_update_link(phydev);
> > diff --git a/include/linux/phy.h b/include/linux/phy.h
> > index 6424586..4a49401 100644
> > --- a/include/linux/phy.h
> > +++ b/include/linux/phy.h
> > @@ -313,6 +313,7 @@ enum phy_state {
> >       PHY_RUNNING,
> >       PHY_NOLINK,
> >       PHY_FORCING,
> > +     PHY_BUSY,
> >  };
> >
> >  /**
> >
>
> --
> Florian
