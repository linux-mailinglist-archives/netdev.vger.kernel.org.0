Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CDFC52FD6EA
	for <lists+netdev@lfdr.de>; Wed, 20 Jan 2021 18:33:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390120AbhATOHC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Jan 2021 09:07:02 -0500
Received: from mail-yb1-f179.google.com ([209.85.219.179]:35529 "EHLO
        mail-yb1-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388004AbhATNbQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Jan 2021 08:31:16 -0500
Received: by mail-yb1-f179.google.com with SMTP id k132so12320553ybf.2;
        Wed, 20 Jan 2021 05:31:00 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=TDkQlUwx2SnbfI3bo/dvPQ9TYvp5Pg19eP3Xh9x9QQA=;
        b=akR9tPgogBqDO1N0u69Dvan6xv8axu2t+ZJDkrnxmr5MppVTxF69kV1bTdEFl45tZN
         lgsmSMMFrIlPxGXcLHn4PeanH0Gf+OR+MmVytcax6kQLzyy7bzbxNwB4CRTNT1c3si6k
         9+zdQfVMn8zBjnCW/2fzmMz/YbxPMJAyBnZgVGkyybyiOOqMFk78aMd9pvRbLbBrpgsX
         l2IwLknmetULmhrxNchL8zbGEP6KLmH6qbcRe9b1zFyXWqXjdR7u4XbZRmRQtwjUg31v
         vQcACGexPMbvJr7dz9kr4NJ5Kc9Tk5ftyPnzbLiIM/Yr/GhRNIEYMkeJy8x1VurjIlWc
         KMKw==
X-Gm-Message-State: AOAM532ixOsN0M9ZZhp9AXIQhoVXfUCM2vnGHbLrEkyDObqlD1RxQ0Je
        78Lft7fAFN3V6kOlHd0ryGOoXSXm82njPboTUsY=
X-Google-Smtp-Source: ABdhPJyXniBHr/mjEIYxXgrcej64wZm2Dv4s6R/ANXLhIvvrZaLeby7h0bBliGh4tZh4wy6V/MqgDH3HRBfMB5BfZYI=
X-Received: by 2002:a25:5583:: with SMTP id j125mr12566111ybb.307.1611149434990;
 Wed, 20 Jan 2021 05:30:34 -0800 (PST)
MIME-Version: 1.0
References: <20210120114137.200019-1-mailhol.vincent@wanadoo.fr>
 <20210120114137.200019-2-mailhol.vincent@wanadoo.fr> <994ac0a3-afd9-eca7-9640-e001f5a43d65@pengutronix.de>
In-Reply-To: <994ac0a3-afd9-eca7-9640-e001f5a43d65@pengutronix.de>
From:   Vincent MAILHOL <mailhol.vincent@wanadoo.fr>
Date:   Wed, 20 Jan 2021 22:30:24 +0900
Message-ID: <CAMZ6RqL46r5FnD7WQqFa5Z715id7r3qrdh2nR=gVFesLDdrCQA@mail.gmail.com>
Subject: Re: [PATCH v4 1/3] can: dev: can_restart: fix use after free bug
To:     Marc Kleine-Budde <mkl@pengutronix.de>
Cc:     Oliver Hartkopp <socketcan@hartkopp.net>,
        linux-can <linux-can@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Stephane Grosjean <s.grosjean@peak-system.com>,
        Loris Fauster <loris.fauster@ttcontrol.com>,
        Alejandro Concepcion Rodriguez <alejandro@acoro.eu>,
        Dan Carpenter <dan.carpenter@oracle.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed. 20 janv. 2021 at 21:53, Marc Kleine-Budde <mkl@pengutronix.de> wrote:
> On 1/20/21 12:41 PM, Vincent Mailhol wrote:
> > After calling netif_rx_ni(skb), dereferencing skb is unsafe.
> > Especially, the can_frame cf which aliases skb memory is accessed
> > after the netif_rx_ni() in:
> >       stats->rx_bytes += cf->len;
> >
> > Reordering the lines solves the issue.
> >
> > Fixes: 39549eef3587 ("can: CAN Network device driver and Netlink interface")
> > Signed-off-by: Vincent Mailhol <mailhol.vincent@wanadoo.fr>
> > ---
> > *Remark for upstream*
> > drivers/net/can/dev.c has been moved to drivers/net/can/dev/dev.c in
> > below commit, please carry the patch forward.
> > Reference: 3e77f70e7345 ("can: dev: move driver related infrastructure
> > into separate subdir")
>
> I've send a pull request to Jakub and David. Let's see what happens :)

Thanks!

Yours sincerely,
Vincent

> Marc
>
> --
> Pengutronix e.K.                 | Marc Kleine-Budde           |
> Embedded Linux                   | https://www.pengutronix.de  |
> Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
> Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |
>
