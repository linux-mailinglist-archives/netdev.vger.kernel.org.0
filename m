Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0009B519FD3
	for <lists+netdev@lfdr.de>; Wed,  4 May 2022 14:45:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349760AbiEDMtd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 May 2022 08:49:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344100AbiEDMtc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 May 2022 08:49:32 -0400
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02B48220C4;
        Wed,  4 May 2022 05:45:57 -0700 (PDT)
Received: by mail-ej1-x636.google.com with SMTP id l18so2649290ejc.7;
        Wed, 04 May 2022 05:45:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=eqxzPAq/6txqhh70GyWZ9dMzqgIc/vxzo6fkTD3QZS8=;
        b=DQKFxktsEdeC24E9xD18PGOF3eb4E37NXK8Jk40earBxOWueb2vNWQZL9RWCu/dl4A
         VAIPX2JKdhn0yUAuBcTduh04EYcI6gtLOd0VYLoFQsteu598QISLBxyQ+wBrxTMXzQe6
         68mSIh3qIWwpn47l/Y6k//TfxdewM+TURRq33hwXH+FrJKbbLQQ1ESUfvBPV+mYkPjvB
         mxAArFxRLv4DmfH0MWTzRGIwp1ew6ifaDknkdlV4Lj28hDadaJfOaV/UcdRg7xzM+6h1
         LZVsGKWWtaRoSRRkAdOvRXeP5+0b/2zEz1Ow2172Lu7y9G+x3KXS69i9WVPh/+/m6ISw
         Sgsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=eqxzPAq/6txqhh70GyWZ9dMzqgIc/vxzo6fkTD3QZS8=;
        b=4bLLEsQeCezwakcEdDThakHAHJsthItH0pZ+V59C7JfUEqhFddagWC3QjdKWJwLCOn
         lu+vw8UCIm530M/0IssWgoJw7HD7yREUgHAC/yNqTPWUJeBQBOdHBpbXs3IdsXCfLpXK
         /XN+qAAevG3gl1261xmFtrfKJayVCn1KvSeGbCUDCXSAvhYonWFZ5c14Lg1fQjQuNuiJ
         4HbEIGxtinf/pPHs1ljAljGjWh3Gt4Y2MpUsVJriop6XTvvnKQ+g0UQwP4+l6odX6px8
         WfXWRHx8PhV3Z8PNVUEjpA5pbYyaRNIhfXC3wd0HOSQLe+Hzcxi5bORL8RBGn+iyJDGp
         1cZw==
X-Gm-Message-State: AOAM5329m59TlwC/cN0C6T/oSXV0NEH2++U+KxvqYiKd4y9DT4xKAP7/
        vFQQS7Fl0S7edRub9xw/iIbJVoiB4IrRivTUpW4=
X-Google-Smtp-Source: ABdhPJxc1REFxauNJu9kH27xWf33ByQbeGyFm74go/LzQFj69XyDS7xdiIS96nN/wo9BIryUNtNaizrM7doW8I9EfJI=
X-Received: by 2002:a17:907:9720:b0:6f4:31d4:925f with SMTP id
 jg32-20020a170907972000b006f431d4925fmr15789498ejc.658.1651668355447; Wed, 04
 May 2022 05:45:55 -0700 (PDT)
MIME-Version: 1.0
References: <20220504114703.1229615-1-festevam@gmail.com> <YnJvM4YaQBR0VZqF@lunn.ch>
In-Reply-To: <YnJvM4YaQBR0VZqF@lunn.ch>
From:   Fabio Estevam <festevam@gmail.com>
Date:   Wed, 4 May 2022 09:45:46 -0300
Message-ID: <CAOMZO5AMNamgei1YJ+QCV0cdNi58KYYboqc0R5DLBjq3DyhMAA@mail.gmail.com>
Subject: Re: [PATCH] net: phy: micrel: Do not use kszphy_suspend/resume for KSZ8061
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Claudiu Beznea <claudiu.beznea@microchip.com>,
        netdev <netdev@vger.kernel.org>,
        Oleksij Rempel <o.rempel@pengutronix.de>,
        Russell King - ARM Linux <linux@armlinux.org.uk>,
        Fabio Estevam <festevam@denx.de>,
        stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Andrew,

On Wed, May 4, 2022 at 9:19 AM Andrew Lunn <andrew@lunn.ch> wrote:

> Thanks for the fix. What you fail to mention is why not call
> kszphy_probe() to populate priv? What makes this PHY special that it
> does not need the probe call?

Looking at the driver history, it has been like this since the beginning.

Adding kszphy_probe() only causes another NULL pointer dereference.

I would need to add both kszphy_probe() and driver_data.

Both can be added, but I don't think this would be material for stable.

I would not like to add a wrong driver_data and cause other problems.

IMHO, I would prefer to restore the Ethernet functionality first, then
if someone
is certain on the proper driver data, this could be added to net-next.

> Looking at the ksphy_driver structure, this seems to affect
> PHY_ID_KS8737 and PHY_ID_KSZ8061

Good catch, thanks.

ksz8737 has a .driver_data field, so I can add .driver_probe there.

For v2 I plan:

- Send two patch as a series:

patch 1/2 would be same as this one
patch 2/2 would pass driver_probe to ksz8737

Do you agree?

Thanks
