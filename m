Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EE83576BB8
	for <lists+netdev@lfdr.de>; Fri, 26 Jul 2019 16:36:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727805AbfGZOgk convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 26 Jul 2019 10:36:40 -0400
Received: from mail-lj1-f194.google.com ([209.85.208.194]:36790 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726731AbfGZOgi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Jul 2019 10:36:38 -0400
Received: by mail-lj1-f194.google.com with SMTP id i21so51730184ljj.3
        for <netdev@vger.kernel.org>; Fri, 26 Jul 2019 07:36:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=ESrjKMJPqUK9pinmPi7bcie4M3UhRDC8HVVE4OSwOk8=;
        b=MYUZ2Q2t5+HTSNRMk6rdhNvKmo4Ad4JGiTbfV25kBSk6owRio75TGMTgJTwPKgm/pK
         3Kh8CJr1CzKNgg1mP9zSD2UvaQpN3AYP0ftrb3lMSxyaUUoI9w0QuBUlEuTGGJYsNZ/X
         FNk7SVx/DvYiAeHwKz0hyH3jIzjWSpoqtivUcMamh/D+25xAdOrE63eJR4Uo/UY0Rdmq
         QrLS/+uCLbhiPyx7mXYB6iX5La0nwbP2/keFOi+Unm5ULjdxSj85qIsJ11F6rZIP84tm
         zEtkJmOc89qF1/uyYEPrbX/mpYDN8TLzD8bxk4OBItLY/3pNsIij0eB3Kpr1kDYD1ypN
         /MhQ==
X-Gm-Message-State: APjAAAVRyHgL15bdA95jo/EumPrtTs87gIL8W/rgysv5QwQBL+E2dkGW
        m7EUVsRGo43jaEFoqku9cmtBgblC3meMIKPob3QrQA==
X-Google-Smtp-Source: APXvYqxGabCoWIrfGSKoR5ai3Kt1u7OzRh9if17wFc8MUP8mbfI1gzaVQkmeiAhee7824imVd7L8ZqoB3bPUr44To2Q=
X-Received: by 2002:a2e:8756:: with SMTP id q22mr50549544ljj.108.1564151795781;
 Fri, 26 Jul 2019 07:36:35 -0700 (PDT)
MIME-Version: 1.0
References: <20190725231546.23878-1-mcroce@redhat.com> <20190726125715.GB5031@kwain>
In-Reply-To: <20190726125715.GB5031@kwain>
From:   Matteo Croce <mcroce@redhat.com>
Date:   Fri, 26 Jul 2019 16:35:59 +0200
Message-ID: <CAGnkfhy_h_UfoefRmBjQgUgiX+954fQjX2kqa2hPLbKpLHU4rg@mail.gmail.com>
Subject: Re: [PATCH net-next] mvpp2: document HW checksum behaviour
To:     Antoine Tenart <antoine.tenart@bootlin.com>
Cc:     netdev <netdev@vger.kernel.org>,
        Maxime Chevallier <maxime.chevallier@bootlin.com>,
        Marcin Wojtas <mw@semihalf.com>,
        Stefan Chulski <stefanc@marvell.com>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 26, 2019 at 2:57 PM Antoine Tenart
<antoine.tenart@bootlin.com> wrote:
>
> Hi Matteo,
>
> On Fri, Jul 26, 2019 at 01:15:46AM +0200, Matteo Croce wrote:
> > The hardware can only offload checksum calculation on first port due to
> > the Tx FIFO size limitation. Document this in a comment.
> >
> > Fixes: 576193f2d579 ("net: mvpp2: jumbo frames support")
> > Signed-off-by: Matteo Croce <mcroce@redhat.com>
>
> Looks good. Please note there's a similar code path in the probe. You
> could also add a comment there (or move this check/comment in a common
> place).
>
> Thanks!
> Antoine
>
> > ---
> >  drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c | 5 ++++-
> >  1 file changed, 4 insertions(+), 1 deletion(-)
> >
> > diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
> > index d8e5241097a9..2f7286bd203b 100644
> > --- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
> > +++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
> > @@ -843,7 +843,10 @@ static int mvpp2_bm_update_mtu(struct net_device *dev, int mtu)
> >               /* Add port to new short & long pool */
> >               mvpp2_swf_bm_pool_init(port);
> >
> > -             /* Update L4 checksum when jumbo enable/disable on port */
> > +             /* Update L4 checksum when jumbo enable/disable on port.
> > +              * Only port 0 supports hardware checksum offload due to
> > +              * the Tx FIFO size limitation.
> > +              */
> >               if (new_long_pool == MVPP2_BM_JUMBO && port->id != 0) {
> >                       dev->features &= ~(NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM);
> >                       dev->hw_features &= ~(NETIF_F_IP_CSUM |
> > --
> > 2.21.0
> >
>
> --
> Antoine Ténart, Bootlin
> Embedded Linux and Kernel engineering
> https://bootlin.com

I see, there is a similar statement in mvpp2_port_probe().
What about adding a static function which sets the flag, and add the
comment there instead of duplicating the comment?

-- 
Matteo Croce
per aspera ad upstream
