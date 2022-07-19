Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CBD6D5795C6
	for <lists+netdev@lfdr.de>; Tue, 19 Jul 2022 11:07:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234471AbiGSJH1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jul 2022 05:07:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233997AbiGSJH0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Jul 2022 05:07:26 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id CFD24205EE
        for <netdev@vger.kernel.org>; Tue, 19 Jul 2022 02:07:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1658221643;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=5xq3a91+TAH7Moxgf8B5LgoKm/+Ua2vqG4jjWG7x1VA=;
        b=SqRWN/PENUHLCZeaRS1rH0z1r6gfGOTnqZu9iIA2nfe7HjiCOpUtGQ6sYXRXiH60dBgzbu
        nLy8pYDG0f0K8VntP9nFaPIP0y/o+NputU6ZQRCyQBHbTqQ2L0HP3GwkxdyDzKroPKk9na
        cV6OOyGAu5WuTzkzC8SwnFVBeXSoQqU=
Received: from mail-qv1-f72.google.com (mail-qv1-f72.google.com
 [209.85.219.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-182-htDX1nGXMCGc8Dbcjp5TwQ-1; Tue, 19 Jul 2022 05:07:22 -0400
X-MC-Unique: htDX1nGXMCGc8Dbcjp5TwQ-1
Received: by mail-qv1-f72.google.com with SMTP id od5-20020a0562142f0500b00473838e0feeso6958665qvb.9
        for <netdev@vger.kernel.org>; Tue, 19 Jul 2022 02:07:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=5xq3a91+TAH7Moxgf8B5LgoKm/+Ua2vqG4jjWG7x1VA=;
        b=5jvfbGOn85MKlXkcenc/pswNW5ZU2HCSUJkkHxRV6JWJqeiJ+Z68IucHWT6PAY7Lc7
         9jjAV6tfwXaoPnEj2xEKgfZ6F4JRtZXqyPS4jbjJJPT7pt+oQv63LGZewaZ1VoFTJttU
         6OJJDvP/bLU00NNw3kGi5XpzVl8QIFZiMhtj7ylO0qLJO0XIx/xMSCjCJXbYDps6kwT4
         XO+17nETwVWQ6yjFjfWTWjid0m/WEo34+igepVr/zXVBqGhmlvosx9bFroGjkMFfH4g5
         0DkyCm1ZDpxNAlichIjjtfYD/GQrzvGlsFuhpvdFtSIaST0RYasOSVO71FT28EepExaI
         liQw==
X-Gm-Message-State: AJIora+fwAAMrmSRGbmK4tORiGw98avztAsTgTOIuMVnq1jG64vnmR6p
        WR9bHJTENkLvIUGQVlrZxIV3B0iqlsOyGB7fNsLD22Jp2ySyujsT/d3RiN1USnKEaOqeJ4Xv2Lv
        8Vjj2bnfbPgayvZ79
X-Received: by 2002:a05:622a:1794:b0:317:db58:f413 with SMTP id s20-20020a05622a179400b00317db58f413mr23730539qtk.505.1658221641984;
        Tue, 19 Jul 2022 02:07:21 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1uRKX09vnsNM2yGtz/6mob8/dB7WaX8W9gLTBKi64TLhFALZmpn6m1I/lQV/rd+tPtAJ0qMaw==
X-Received: by 2002:a05:622a:1794:b0:317:db58:f413 with SMTP id s20-20020a05622a179400b00317db58f413mr23730525qtk.505.1658221641721;
        Tue, 19 Jul 2022 02:07:21 -0700 (PDT)
Received: from gerbillo.redhat.com (146-241-104-164.dyn.eolo.it. [146.241.104.164])
        by smtp.gmail.com with ESMTPSA id dm53-20020a05620a1d7500b006b4880b08a9sm14138074qkb.88.2022.07.19.02.07.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Jul 2022 02:07:21 -0700 (PDT)
Message-ID: <00e2c14ffd5bb2214b4d5553c1ed1d331b4cc355.camel@redhat.com>
Subject: Re: [PATCH V4 net-next] net: marvell: prestera: add phylink support
From:   Paolo Abeni <pabeni@redhat.com>
To:     Oleksandr Mazur <oleksandr.mazur@plvision.eu>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Cc:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        Yevhen Orlov <yevhen.orlov@plvision.eu>,
        Taras Chornyi <taras.chornyi@plvision.eu>,
        "linux@armlinux.org.uk" <linux@armlinux.org.uk>,
        "andrew@lunn.ch" <andrew@lunn.ch>
Date:   Tue, 19 Jul 2022 11:07:17 +0200
In-Reply-To: <GV1P190MB2019F8813E2E3A169076EE9AE48F9@GV1P190MB2019.EURP190.PROD.OUTLOOK.COM>
References: <20220715193454.7627-1-oleksandr.mazur@plvision.eu>
         <660684000d6820524c61d733fb076225202dad8e.camel@redhat.com>
         <GV1P190MB2019F8813E2E3A169076EE9AE48F9@GV1P190MB2019.EURP190.PROD.OUTLOOK.COM>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-2.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 2022-07-19 at 08:56 +0000, Oleksandr Mazur wrote:
> > > +
> > > +static void prestera_pcs_an_restart(struct phylink_pcs *pcs)
> > > +{
> > > +     /*
> > > +      * TODO: add 100basex AN restart support
> 
> > Possibly typo above ? s/100basex/1000basex/
> 
> Hello Paolo, yes, you're right.
> So, should i wait some time before resubmitting patch again with
> changes - V5 - or it's okay to resubmit new version now?

My personal take: v4 has been out for several days, so it's ok to
submit a new revision now. Others may disagre, but you would be free to
point the finger against me for the suggestion :)

Please additionally have a look to my other comment, regarding
read_lock usage.

Thanks!

Paolo

