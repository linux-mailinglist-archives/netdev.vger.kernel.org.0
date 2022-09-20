Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 99EBD5BDDCD
	for <lists+netdev@lfdr.de>; Tue, 20 Sep 2022 09:07:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230070AbiITHHe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Sep 2022 03:07:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229777AbiITHHc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Sep 2022 03:07:32 -0400
Received: from mail-qv1-f42.google.com (mail-qv1-f42.google.com [209.85.219.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4CF452E5A;
        Tue, 20 Sep 2022 00:07:31 -0700 (PDT)
Received: by mail-qv1-f42.google.com with SMTP id ml1so1438945qvb.1;
        Tue, 20 Sep 2022 00:07:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=AgNMwleUSoGMfhROZxFkeUVJmew80ewFy3sNwaTGKlY=;
        b=4BFuocp76KzlxVLvhShx+0gv4iiED7xRs4waAfJJiGH4Fo8BOTdCr4iwfWujz6BVp+
         2w/oKtyuozhoGl7lYC326JizmQ9cGlSVBhqjtxmybF0YQJ+lm2YJeUeRzE+DoCQ9sAHb
         PNqCzfD6yPZsMdunw9PQFGvEPB8RVMVs+SYfXSC+xJGH5h9CzQpu4X1O+8DldGVWrSPC
         7hBanFr9I0YuGB2TOHOTvycuu/VpWWQSi+ersZT3ftSPzMkg2j8RfZyOtjRhRGb+kaxR
         5saYOxQA3LlvGm+9e4jTJf6bXyIarzYTZnszIOJBebY4avfZD+v5zmvd/BWSjYbZLA6R
         dQEQ==
X-Gm-Message-State: ACrzQf0wS6mo7o+XjFwc224V5L821XCv1ZbjYdruRo9MptazU/NsfgeK
        dTzwpu3GgP4nTrnmFY2BGoa1KAYtFp29PA==
X-Google-Smtp-Source: AMsMyM40aTRSZQRkhQW0ck3jQOrNZxQFKvhp+Xql9jKKArNzeb3wgtlLqYwk50yH3CJ4Dv0uRvhqyg==
X-Received: by 2002:a05:6214:27ca:b0:4a9:d3f8:9cfb with SMTP id ge10-20020a05621427ca00b004a9d3f89cfbmr17469328qvb.56.1663657650758;
        Tue, 20 Sep 2022 00:07:30 -0700 (PDT)
Received: from mail-yw1-f181.google.com (mail-yw1-f181.google.com. [209.85.128.181])
        by smtp.gmail.com with ESMTPSA id bj38-20020a05620a192600b006cebda00630sm544401qkb.60.2022.09.20.00.07.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 20 Sep 2022 00:07:30 -0700 (PDT)
Received: by mail-yw1-f181.google.com with SMTP id 00721157ae682-3487d84e477so16484637b3.6;
        Tue, 20 Sep 2022 00:07:30 -0700 (PDT)
X-Received: by 2002:a81:1691:0:b0:345:17df:4fc6 with SMTP id
 139-20020a811691000000b0034517df4fc6mr17471834yww.502.1663657650127; Tue, 20
 Sep 2022 00:07:30 -0700 (PDT)
MIME-Version: 1.0
References: <8ec796f47620980fdd0403e21bd8b7200b4fa1d4.1663598796.git.geert+renesas@glider.be>
 <00e5b86b-fe51-98c9-92b7-349b6a03fc1b@omp.ru>
In-Reply-To: <00e5b86b-fe51-98c9-92b7-349b6a03fc1b@omp.ru>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Tue, 20 Sep 2022 09:07:19 +0200
X-Gmail-Original-Message-ID: <CAMuHMdX7tn4EgG5YCN8FZTmY3+42zLGAxoUnCt5GNk24Hs+c5w@mail.gmail.com>
Message-ID: <CAMuHMdX7tn4EgG5YCN8FZTmY3+42zLGAxoUnCt5GNk24Hs+c5w@mail.gmail.com>
Subject: Re: [PATCH] net: ravb: Fix PHY state warning splat during system resume
To:     Sergey Shtylyov <s.shtylyov@omp.ru>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        netdev@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Sergey,

On Mon, Sep 19, 2022 at 8:40 PM Sergey Shtylyov <s.shtylyov@omp.ru> wrote:
> On 9/19/22 5:48 PM, Geert Uytterhoeven wrote:
> > Since commit 744d23c71af39c7d ("net: phy: Warn about incorrect
> > mdio_bus_phy_resume() state"), a warning splat is printed during system
> > resume with Wake-on-LAN disabled:
> >
> >         WARNING: CPU: 0 PID: 1197 at drivers/net/phy/phy_device.c:323 mdio_bus_phy_resume+0xbc/0xc8
> >
> > As the Renesas Ethernet AVB driver already calls phy_{stop,start}() in
> > its suspend/resume callbacks, it is sufficient to just mark the MAC
> > responsible for managing the power state of the PHY.
> >
> > Fixes: fba863b816049b03 ("net: phy: make PHY PM ops a no-op if MAC driver manages PHY PM")
> > Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
>
> Reviewed-by: Sergey Shtylyov <s.shtylyov@omp.ru>

Thanks for your review!

> > --- a/drivers/net/ethernet/renesas/ravb_main.c
> > +++ b/drivers/net/ethernet/renesas/ravb_main.c
> > @@ -1449,6 +1449,8 @@ static int ravb_phy_init(struct net_device *ndev)
> >               phy_remove_link_mode(phydev, ETHTOOL_LINK_MODE_100baseT_Half_BIT);
> >       }
> >
> > +     /* Indicate that the MAC is responsible for managing PHY PM */
> > +     phydev->mac_managed_pm = true;
>
>    Hm, this field is declared as *unsigned*...

True, I copied this from drivers/net/ethernet/broadcom/genet/bcmmii.c.
But true/false are fully compatible with single-bit values.

The linuxdoc suggests to use true, like for all other single-bit fields used
as booleans:

include/linux/phy.h: * @mac_managed_pm: Set true if MAC driver takes
of suspending/resuming PHY

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
