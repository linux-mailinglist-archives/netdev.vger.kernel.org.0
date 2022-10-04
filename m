Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3903D5F40D7
	for <lists+netdev@lfdr.de>; Tue,  4 Oct 2022 12:30:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229815AbiJDKaQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Oct 2022 06:30:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229755AbiJDKaN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Oct 2022 06:30:13 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B6EB40E35
        for <netdev@vger.kernel.org>; Tue,  4 Oct 2022 03:30:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1664879411;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=8Gu6wQbEujqIoRE5ZXJV+VaDyIac1+RR2QAIq/Gjc6A=;
        b=Pnsz/IReNfxujhWbOKgSntFRxI0SkyNZw7xHGj9rr4fy4LxMO2ZcTLGB/8oBiW2znAER+k
        sX/kZiClC/tE28f6iCXXV25v//tvAPOMBpjGDwDWoYuPT6egm8JVbgOWu8xCzReZ7rjoA7
        UNbf7ZuUjf398vJxL/svVC6j4vOeHWk=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-665-VxfQpBB6PeGx6VrzIxkeTQ-1; Tue, 04 Oct 2022 06:30:10 -0400
X-MC-Unique: VxfQpBB6PeGx6VrzIxkeTQ-1
Received: by mail-wm1-f70.google.com with SMTP id y20-20020a05600c365400b003b4d4ae666fso3453227wmq.4
        for <netdev@vger.kernel.org>; Tue, 04 Oct 2022 03:30:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:to:from:subject:message-id:x-gm-message-state:from
         :to:cc:subject:date;
        bh=8Gu6wQbEujqIoRE5ZXJV+VaDyIac1+RR2QAIq/Gjc6A=;
        b=AFDEhdjoAED3UWlDkKtIFgAhtZzeWZ5+dPFFOC1I6sPBPCvugZVJIdXsHhUbKTgNxb
         +SkyvPqjQ4VcGiStIOV+ESEilseVuR+XTyr/TRJdBxyhcQ619ZghahVwQNKD4x0nXb5U
         fNi+69CaDFgS0B/ge2EkE3yOtizstLQUm2mveO2pD3APoWsEA231mRUjVVD2LC1+gc4+
         zUmmeafbdTUUTQIi7bVhkoOlz/2LCUyeyT9CshnIAPLmWMKF50kWk0+lj7a+faWtQ5eQ
         TWIyaQqdK53mKDZ2aghnNVkx0NUgiXNZzDs1C1sCiFSRcxR9EKOemSqfV5/mpbZ/lBDY
         RdcA==
X-Gm-Message-State: ACrzQf2WcYfLaLEfjHkAZqZclEdSfVBKG+B4HtSlFX943NNVuEU6+igD
        IsZ8G0wW5l+ipG9lAKY2HXAvnKtEfHpltksKAv7MFl6VFFc6t3U/b/bUIOBDgZfpFiWKt6b11I4
        F59Q38LXqXmWvKoyI
X-Received: by 2002:a7b:c7d8:0:b0:3b4:5c41:6a6c with SMTP id z24-20020a7bc7d8000000b003b45c416a6cmr9409907wmk.139.1664879408831;
        Tue, 04 Oct 2022 03:30:08 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM6j5K3VsnjhT+M3kCXnWsc9JNCbQ3kkZoXNNwyk58lzbxcU7C7QTm03zt0B+XOBqRTPmdINxw==
X-Received: by 2002:a7b:c7d8:0:b0:3b4:5c41:6a6c with SMTP id z24-20020a7bc7d8000000b003b45c416a6cmr9409879wmk.139.1664879408568;
        Tue, 04 Oct 2022 03:30:08 -0700 (PDT)
Received: from gerbillo.redhat.com (146-241-97-71.dyn.eolo.it. [146.241.97.71])
        by smtp.gmail.com with ESMTPSA id bx10-20020a5d5b0a000000b00228fa832b7asm12557473wrb.52.2022.10.04.03.30.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Oct 2022 03:30:08 -0700 (PDT)
Message-ID: <6645ba3ba389dc6da8d16f063210441337db9249.camel@redhat.com>
Subject: Re: [PATCH net-next] docs: networking: phy: add missing space
From:   Paolo Abeni <pabeni@redhat.com>
To:     Casper Andersson <casper.casan@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>, netdev@vger.kernel.org,
        linux-doc@vger.kernel.org
Date:   Tue, 04 Oct 2022 12:30:06 +0200
In-Reply-To: <20221004073242.304425-1-casper.casan@gmail.com>
References: <20221004073242.304425-1-casper.casan@gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-2.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 2022-10-04 at 09:32 +0200, Casper Andersson wrote:
> Missing space between "pins'" and "strength"
> 
> Signed-off-by: Casper Andersson <casper.casan@gmail.com>
> ---

The merge window has now started (after Linus tagged 6.0)
and will last until he tags 6.1-rc1 (two weeks from now). During this
time we'll not be taking any patches for net-next so
please repost in around 2 weeks.

Thanks,

Paolo

