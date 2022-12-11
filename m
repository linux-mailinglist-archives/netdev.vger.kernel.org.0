Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A6EA26493E3
	for <lists+netdev@lfdr.de>; Sun, 11 Dec 2022 12:24:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230204AbiLKLYq convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Sun, 11 Dec 2022 06:24:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229960AbiLKLYp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 11 Dec 2022 06:24:45 -0500
Received: from mail-pj1-f54.google.com (mail-pj1-f54.google.com [209.85.216.54])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9AAD711440;
        Sun, 11 Dec 2022 03:24:41 -0800 (PST)
Received: by mail-pj1-f54.google.com with SMTP id v13-20020a17090a6b0d00b00219c3be9830so9370360pjj.4;
        Sun, 11 Dec 2022 03:24:41 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=9Xx+VWxVfF6d2N/d4R2hoVV6iriRHfZEzJeKkWHHuls=;
        b=j8LO1ajlYhPsMrZDgDq6NS51jOxg3v6HmV0XVXRAhYaUhoSC3CfzsjJxV+LIq7mjvs
         pIMTgObYyIIw8Bcd38cJ6HvEAE3Bz8A1Coc1ASqAxyb3kzU/20gpe4v4Y3cl1tvS9+/8
         XPstrZokH84bL80zf+ShgyLJR70K0l65L1nVpAzb1FTrnBVoO6xs7ckZII24L17du90q
         nNF5ysOfpunm2LNNcWW5T8lOl6aercakaEcfrgYWqxbc/3yG/Aj1aV18rfsSKglvR6bq
         NnE4Ns3cyYxiZfHFC7LPKZXI7wefz5euwebEXC+YNKmTMbr+y2dFaQ9pA7KQN5PJdnZd
         dbtA==
X-Gm-Message-State: ANoB5pmcV+P3Zfxesi/QakW3W8GqYkmhd5/ktgoSSyDgA85tWDrdfa4T
        LcP1YCPqv9BC9eVDwoouy+HoBQojOi708lew4Cc=
X-Google-Smtp-Source: AA0mqf7917HIQYWFeNnOyEafaz/S972MlQdTp3NpmD0V6S1fYYRsBhjT6lTYnLAGxwP5yz/efHKAu9kgdkXf12fWnos=
X-Received: by 2002:a17:90b:3c4d:b0:221:4b1c:3b29 with SMTP id
 pm13-20020a17090b3c4d00b002214b1c3b29mr126610pjb.92.1670757880938; Sun, 11
 Dec 2022 03:24:40 -0800 (PST)
MIME-Version: 1.0
References: <20221203133159.94414-1-mailhol.vincent@wanadoo.fr>
 <20221210090157.793547-1-mailhol.vincent@wanadoo.fr> <20221210090157.793547-2-mailhol.vincent@wanadoo.fr>
 <Y5Rmp66zvlwykRLq@hovoldconsulting.com>
In-Reply-To: <Y5Rmp66zvlwykRLq@hovoldconsulting.com>
From:   Vincent MAILHOL <mailhol.vincent@wanadoo.fr>
Date:   Sun, 11 Dec 2022 20:24:29 +0900
Message-ID: <CAMZ6RqJoCEW9+Z+LD1W9CORE=RUvH9tLn163mkY5Dsct5juYUA@mail.gmail.com>
Subject: Re: [PATCH v2 1/9] can: ems_usb: ems_usb_disconnect(): fix NULL
 pointer dereference
To:     Johan Hovold <johan@kernel.org>
Cc:     Marc Kleine-Budde <mkl@pengutronix.de>, linux-can@vger.kernel.org,
        Oliver Neukum <oneukum@suse.com>,
        Wolfgang Grandegger <wg@grandegger.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Frank Jungclaus <frank.jungclaus@esd.eu>, socketcan@esd.eu,
        Yasushi SHOJI <yashi@spacecubics.com>,
        =?UTF-8?Q?Stefan_M=C3=A4tje?= <stefan.maetje@esd.eu>,
        Hangyu Hua <hbh25y@gmail.com>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        Peter Fink <pfink@christ-es.de>,
        Jeroen Hofstee <jhofstee@victronenergy.com>,
        =?UTF-8?Q?Christoph_M=C3=B6hring?= <cmoehring@christ-es.de>,
        John Whittington <git@jbrengineering.co.uk>,
        Vasanth Sadhasivan <vasanth.sadhasivan@samsara.com>,
        Jimmy Assarsson <extja@kvaser.com>,
        Anssi Hannula <anssi.hannula@bitwise.fi>,
        Pavel Skripkin <paskripkin@gmail.com>,
        Stephane Grosjean <s.grosjean@peak-system.com>,
        Wolfram Sang <wsa+renesas@sang-engineering.com>,
        "Gustavo A . R . Silva" <gustavoars@kernel.org>,
        Julia Lawall <Julia.Lawall@inria.fr>,
        Dongliang Mu <dzm91@hust.edu.cn>,
        Sebastian Haas <haas@ems-wuensche.com>,
        Maximilian Schneider <max@schneidersoft.net>,
        Daniel Berglund <db@kvaser.com>,
        Olivier Sobrie <olivier@sobrie.be>,
        =?UTF-8?B?UmVtaWdpdXN6IEtvxYLFgsSFdGFq?= 
        <remigiusz.kollataj@mobica.com>,
        Jakob Unterwurzacher <jakob.unterwurzacher@theobroma-systems.com>,
        Martin Elshuber <martin.elshuber@theobroma-systems.com>,
        Bernd Krumboeck <b.krumboeck@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alan Stern <stern@rowland.harvard.edu>,
        linux-usb@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue. 10 déc. 2022 à 20:02, Johan Hovold <johan@kernel.org> wrote:
> On Sat, Dec 10, 2022 at 06:01:49PM +0900, Vincent Mailhol wrote:
> > ems_usb sets the driver's priv data to NULL before waiting for the
> > completion of outsdanding urbs. This can results in NULL pointer
> > dereference, c.f. [1] and [2].
>
> Please stop making hand-wavy claims like this. There is no risk for a
> NULL-pointer deference here, and if you think otherwise you need to
> explain how that can happen in detail for each driver.

Understood.

*My* mistake comes from this message from Alan [1]:

| But if a driver does make the call, it should be careful to
| ensure that the call happens _after_ the driver is finished
| using the interface-data pointer.  For example, after all
| outstanding URBs have completed, if the completion handlers
| will need to call usb_get_intfdata().

I did not pay enough attention to the "if the completion handlers will
need to call usb_get_intfdata()" part and jumped into the incorrect
conclusion that any use of usb_set_intfdata(intf, NULL) before URB
completion was erroneous.

My deep apologies for all the noise. Please forget this series and one
more time, thank you for your patience.

[1] https://lore.kernel.org/linux-usb/Y4OD70GD4KnoRk0k@rowland.harvard.edu/
