Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D5178576D70
	for <lists+netdev@lfdr.de>; Sat, 16 Jul 2022 13:16:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230114AbiGPLP7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 Jul 2022 07:15:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229521AbiGPLP6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 16 Jul 2022 07:15:58 -0400
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3139175AF;
        Sat, 16 Jul 2022 04:15:56 -0700 (PDT)
Received: by mail-ej1-x630.google.com with SMTP id oy13so13055448ejb.1;
        Sat, 16 Jul 2022 04:15:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=GSuKOTkU3shP0EBSGkZH4bPjOmCNN0weweRSI39rxR4=;
        b=LmTfJY0C2KyehmNxK1ghGj/zlJEMylOOKJbogqEpNjvqB6ZH0PxovI/7v+v1fOSdBC
         M6iw1J/y0vD6r7uFeq3sB9GKHprjqIq5Ct6xVM81/IQgLMAMwDzAUlwWt7Wi3lPo3/Y4
         tLfI8OhFHzxN6JSMmA//PC68Do/mdkZKDiTpB1cUYgH3fw9dTMlSqhWy+FEh5GxM2PkQ
         ZS2ctOw7eNQFgnRDTINyhdA4ZroolRfCl8MMF5IQ/oJQUl2nlJV2FHgIGCO/77oLldmp
         o31Nm7kIK0HoIH24IY9VAOR+r6keNDGQZ9n5NNFvpkPQSkKJoI0HxALT5rPnX9zqcYGN
         8jhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=GSuKOTkU3shP0EBSGkZH4bPjOmCNN0weweRSI39rxR4=;
        b=qrcz9/YqlkLQ2QREL+jDscwOMAlt8qNJdUrNXV/PWYB9igD9tPFJnf2Nmyc3nsQ1IT
         rlptB1DsDDvyenhvmItCv4B7B+5ZoLKhiBSum/VrqatLKoaR1eIhYsC8728/GZrJ16ss
         woiOq+Q1c9RRlzO/aN/HxBtJbKuvDRKX5bs/gzb+SYW+MSCtQRnnxAPBIVW3ya7GVAHG
         4ZM7JuPNnLsMaSaaLHjcPEenHTVentoTHucFOZI6U8HN4BY8a5WMg42hhCCX1ljR7UrZ
         Rt7uW+tpzFnosTX19reyVga5k8Dic3vMapdrEDFEp+3yRt2GpwXPtg8smVnqcDcWol8M
         fT8A==
X-Gm-Message-State: AJIora9lD/+xq9WKV2/JklxXoBGNFqwmVHQuRUamuaDIce6j72amBzQ+
        ao+bEBUGJ/tEi6iG7/rci2M=
X-Google-Smtp-Source: AGRyM1sLb4uqrhY6SDkuMORlJ7TVbmlpoUkrp8ICgwzrq8QuVsTAX0TDXJWnC5I3SzDQW8/0IZykNQ==
X-Received: by 2002:a17:906:8461:b0:72e:e3f5:373b with SMTP id hx1-20020a170906846100b0072ee3f5373bmr10571972ejc.199.1657970155263;
        Sat, 16 Jul 2022 04:15:55 -0700 (PDT)
Received: from skbuf ([188.25.231.115])
        by smtp.gmail.com with ESMTPSA id 2-20020a170906218200b006fefd1d5c2bsm3128699eju.148.2022.07.16.04.15.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 16 Jul 2022 04:15:54 -0700 (PDT)
Date:   Sat, 16 Jul 2022 14:15:51 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     "Russell King (Oracle)" <linux@armlinux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Alvin =?utf-8?Q?=C5=A0ipraga?= <alsi@bang-olufsen.dk>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Daniel Scally <djrscally@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        DENG Qingfang <dqfext@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        George McCollister <george.mccollister@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        linux-acpi@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org,
        Marek =?utf-8?B?QmVow7pu?= <kabel@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        netdev@vger.kernel.org, Paolo Abeni <pabeni@redhat.com>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Sean Wang <sean.wang@mediatek.com>,
        UNGLinuxDriver@microchip.com,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Woojung Huh <woojung.huh@microchip.com>
Subject: Re: [PATCH net-next 0/6] net: dsa: always use phylink
Message-ID: <20220716111551.64rjruz4q4g5uzee@skbuf>
References: <YtGPO5SkMZfN8b/s@shell.armlinux.org.uk>
 <20220715171719.niqcrklpk4ittfvl@skbuf>
 <YtHVLGR0RQ6dWuBS@shell.armlinux.org.uk>
 <20220715160359.2e9dabfe@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220715160359.2e9dabfe@kernel.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 15, 2022 at 04:03:59PM -0700, Jakub Kicinski wrote:
> On Fri, 15 Jul 2022 21:59:24 +0100 Russell King (Oracle) wrote:
> > The only thing that delayed them was your eventual comments about
> > re-working how it was being done. Yet again, posting the RFC series
> > created very little in the way of feedback. I'm getting to the point
> > of thinking its a waste of time posting RFC patches - it's counter
> > productive. RFC means "request for comments" but it seems that many
> > interpret it as "I can ignore it".
> 
> I'm afraid you are correct. Dave used to occasionally apply RFC patches
> which kept reviewers on their toes a little bit (it kept me for sure).
> These days patchwork automatically marks patches as RFC based on
> the subject, tossing them out of "Action required" queue. So they are
> extremely easy to ignore.
> 
> Perhaps an alternative way of posting would be to write "RFC only,
> please don't apply" at the end of the cover letter. Maybe folks will 
> at least get thru reading the cover letter then :S

Again, expressing complaints to me for responding late is misdirected
frustration. The fact that I chose to leave my comments only when
Russell gave up on waiting for feedback from Andrew doesn't mean I
ignored his RFC patches, it just means I didn't want to add noise and
ask for minor changes when it wasn't clear that this is the overall
final direction that the series would follow. I still have preferences
about the way in which this patch set gets accepted, and now seems like
the proper moment to express them.
