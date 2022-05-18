Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 922B452BE53
	for <lists+netdev@lfdr.de>; Wed, 18 May 2022 17:26:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238964AbiERO4P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 May 2022 10:56:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238955AbiEROz7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 May 2022 10:55:59 -0400
Received: from mo4-p01-ob.smtp.rzone.de (mo4-p01-ob.smtp.rzone.de [85.215.255.50])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81118A0D2C;
        Wed, 18 May 2022 07:55:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1652885748;
    s=strato-dkim-0002; d=hartkopp.net;
    h=In-Reply-To:References:Cc:To:From:Subject:Date:Message-ID:Cc:Date:
    From:Subject:Sender;
    bh=hYcXcVlFfZvhuv9lwG+hye9EfZ3gHatNRoDkftDUeBA=;
    b=Cuf9zkMbPoAgn8g3F1Ud6Dt6PDDOpeyuar18uYcRNT+y/2t4smyXEb8tqmYaw0RTeu
    P4S15iqyyCLY9ovfvOUmWK1Tud1CXVoola59TWCzwY9F7bJ9eIxW9CGx1VUvzfGy8ooa
    GYD+YKKT25qY4bycjMm3+SbnAbv6JCDf7nNtOT9IoP3pLKEZxA+qTzUqYbHnrMtysnKd
    Rv08soLyo6TNB5ixmLKpL9RPDk38SjEVfyLGd+rUn9UsAs7Z9dyccOF/V1WZ9Nr6Z34l
    mMaM7+sQVvMQaPeWwLj8G54q2pMF+112eggoTyR9BqKUa+ieYRV0bgCE0a7aongd3thB
    5TYw==
Authentication-Results: strato.com;
    dkim=none
X-RZG-AUTH: ":P2MHfkW8eP4Mre39l357AZT/I7AY/7nT2yrDxb8mjG14FZxedJy6qgO1qCHSa1GLptZHusx3hdBqPeOuh2krLEWFUg=="
X-RZG-CLASS-ID: mo00
Received: from [IPV6:2a00:6020:1cff:5b00::b82]
    by smtp.strato.de (RZmta 47.45.0 AUTH)
    with ESMTPSA id R0691fy4IEtmHtG
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
    Wed, 18 May 2022 16:55:48 +0200 (CEST)
Message-ID: <899706c6-0aac-b039-4b67-4e509ff0930d@hartkopp.net>
Date:   Wed, 18 May 2022 16:55:48 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: [PATCH v3 3/4] can: skb:: move can_dropped_invalid_skb and
 can_skb_headroom_valid to skb.c
Content-Language: en-US
From:   Oliver Hartkopp <socketcan@hartkopp.net>
To:     Marc Kleine-Budde <mkl@pengutronix.de>
Cc:     Vincent MAILHOL <mailhol.vincent@wanadoo.fr>,
        Max Staudt <max@enpas.org>, linux-can@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
References: <e054f6d4-7ed1-98ac-8364-425f4ef0f760@hartkopp.net>
 <20220517141404.578d188a.max@enpas.org>
 <20220517122153.4r6n6kkbdslsa2hv@pengutronix.de>
 <20220517143921.08458f2c.max@enpas.org>
 <0b505b1f-1ee4-5a2c-3bbf-6e9822f78817@hartkopp.net>
 <CAMZ6RqJ0iCsHT-D5VuYQ9fk42ZEjHStU1yW0RfX1zuJpk5rVtQ@mail.gmail.com>
 <43768ff7-71f8-a6c3-18f8-28609e49eedd@hartkopp.net>
 <20220518132811.xfmwms2cu3bfxgrp@pengutronix.de>
 <CAMZ6RqJqeNjAtoDWADHsWocgbSXqQixcebJBhiBFS8BVeKCb3g@mail.gmail.com>
 <3dbe135e-d13c-5c5d-e7e4-b9c13b820fb8@hartkopp.net>
 <20220518143613.2a7alnw6vtkw7ct2@pengutronix.de>
 <482fd87a-df5a-08f7-522b-898d68c3b04a@hartkopp.net>
In-Reply-To: <482fd87a-df5a-08f7-522b-898d68c3b04a@hartkopp.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 18.05.22 16:38, Oliver Hartkopp wrote:
> 
> 
> On 18.05.22 16:36, Marc Kleine-Budde wrote:
>> On 18.05.2022 16:33:58, Oliver Hartkopp wrote:
> 
>>> I would suggest to remove the Kconfig entry but not all the code 
>>> inside the
>>> drivers, so that a volunteer can convert the LED support based on the
>>> existing trigger points in the drivers code later.
>>
>> The generic netdev LED trigger code doesn't need any support in the
>> netdev driver.
> 
> Oh! Yes, then it could be removed. Sorry for not looking that deep into it.

I can send a patch for this removal too. That's an easy step which might 
get into 5.19 then.

Best regards,
Oliver

