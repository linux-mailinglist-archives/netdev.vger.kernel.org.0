Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2889D500634
	for <lists+netdev@lfdr.de>; Thu, 14 Apr 2022 08:36:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236260AbiDNGi7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Apr 2022 02:38:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229989AbiDNGi4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Apr 2022 02:38:56 -0400
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D93F31DFB
        for <netdev@vger.kernel.org>; Wed, 13 Apr 2022 23:36:31 -0700 (PDT)
Received: by mail-wr1-x436.google.com with SMTP id b19so5498548wrh.11
        for <netdev@vger.kernel.org>; Wed, 13 Apr 2022 23:36:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=W13RGoIXQweN+v6MZVwcX2S9w3C2c7+oR55UibETev4=;
        b=WQmWi7kZ5kk/7oG/tazI71tOaN0y+HbleNKYDusllFjhCTldmvNnXaaz0SSUehd5E3
         pDcrfIDbMtkKWb9D8haIQ0Ru4SrFkNnlXAsPeIAEvupX52fGt9xOijfofW97Z7GPy6SY
         V2F0135ueB0amGkKCrAAjm+N9UQNpgU/fS8Heiqld1CjqBYN8ubrkTCoN15VpYam858X
         sorGqm3Y58Q309vFeOhsFePqw0+HPDQBS46owA7Tnic2hH+TrLcgmSrUv5k8OZ4jpko5
         AVNaFTroEu9QK0Lx3PHijyihwFki298WhPfSgiHHmPx7fCemmdwGN8oH9cM6nGglSwUc
         c3vw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=W13RGoIXQweN+v6MZVwcX2S9w3C2c7+oR55UibETev4=;
        b=DmFpSJNUKE0pMzTsF5tN0eRnscB9RsOlVyExCGKi1AsL3gyX44jVZs9FNtJk17oT4J
         UeBuvWlAn7rFECNuGbmC3YZzhs+0N/KAzDlN2QjOJ3DKfe5l594HJnrXGRWLGvD/ZpmJ
         f9lBGgLZT5LVCbd2Bpo8GI5kAyeu37iLocKCZhpgp1ZQGiyMR/MtTKa+YoB1y0teOr6Y
         wNJ5SV1Y2BmmytYJfIgmbnpNdzrjTTw6YGuAAMHuzLXQR4WYWuZKJDaqfKU4CT04IDBY
         bIfoeDgV9Jex3J3X5u2u+E7oRKgjodns4a93IYekIpj7d8rk2adw3le90uVLvGNIvSUg
         ZewA==
X-Gm-Message-State: AOAM533oU7ZXJPGkJnXckGcvbqh7YAPN5Itpv0yqBNb0gLW7noQPV58s
        3t38AcEVy/s42z/iyaB/bFz2RIUX+eQ=
X-Google-Smtp-Source: ABdhPJysrmkTofBY7xlCZITbWx5+f3SqxhTLPj4cgo4gywTgrK8qZ2Dyp+9R/eh5Pv6pp6dB4l2W+g==
X-Received: by 2002:adf:816b:0:b0:203:7fae:a245 with SMTP id 98-20020adf816b000000b002037faea245mr867622wrm.619.1649918190081;
        Wed, 13 Apr 2022 23:36:30 -0700 (PDT)
Received: from hoboy.vegasvil.org (195-70-108-137.stat.salzburg-online.at. [195.70.108.137])
        by smtp.gmail.com with ESMTPSA id f13-20020a5d664d000000b00207ab79ed80sm955619wrw.12.2022.04.13.23.36.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Apr 2022 23:36:29 -0700 (PDT)
Date:   Wed, 13 Apr 2022 23:36:27 -0700
From:   Richard Cochran <richardcochran@gmail.com>
To:     Gerhard Engleder <gerhard@engleder-embedded.com>
Cc:     Vinicius Costa Gomes <vinicius.gomes@intel.com>, yangbo.lu@nxp.com,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, mlichvar@redhat.com,
        netdev <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next v2 4/5] ptp: Support late timestamp determination
Message-ID: <20220414063627.GA2311@hoboy.vegasvil.org>
References: <20220403175544.26556-1-gerhard@engleder-embedded.com>
 <20220403175544.26556-5-gerhard@engleder-embedded.com>
 <20220410072930.GC212299@hoboy.vegasvil.org>
 <CANr-f5xhH31yF8UOmM=ktWULyUugBGDoHzOiYZggiDPZeTbdrw@mail.gmail.com>
 <20220410134215.GA258320@hoboy.vegasvil.org>
 <CANr-f5xriLzQ+3xtM+iV8ahu=J1mA7ixbc49f0i2jxkySthTdQ@mail.gmail.com>
 <CANr-f5yn9LzMQ8yAP8Py-EP_NyifFyj1uXBNo+kuGY1p8t0CFw@mail.gmail.com>
 <20220412214655.GB579091@hoboy.vegasvil.org>
 <CANr-f5zLyphtbi49mvsH_rVzn7yrGejUGMVobwrFmX8U6f2YVA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANr-f5zLyphtbi49mvsH_rVzn7yrGejUGMVobwrFmX8U6f2YVA@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 13, 2022 at 10:51:54PM +0200, Gerhard Engleder wrote:
> For igc and tsnep the 16 bytes in front of the RX frame exist anyway.
> So this would be a minimal solution with best performance as a first
> step. A lookup for netdev/phc can be added in the future if there is
> a driver, which needs that.

It is a design mistake to base new kernel interfaces on hardware
quirks.

> Is it worth posting an implementation in that direction?

Sure, but please make thoughts about how this would work for the
non-igc world.

IIRC one of the nxp switches also has such counters?  You can start
with that.

Thanks,
Richard
