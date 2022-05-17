Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6FA8F52A4FE
	for <lists+netdev@lfdr.de>; Tue, 17 May 2022 16:35:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349068AbiEQOfQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 May 2022 10:35:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348989AbiEQOfP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 May 2022 10:35:15 -0400
Received: from mo4-p00-ob.smtp.rzone.de (mo4-p00-ob.smtp.rzone.de [81.169.146.160])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9020D4FC77;
        Tue, 17 May 2022 07:35:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1652798110;
    s=strato-dkim-0002; d=hartkopp.net;
    h=In-Reply-To:From:References:Cc:To:Subject:Date:Message-ID:Cc:Date:
    From:Subject:Sender;
    bh=J4Lj0h3j4UiNNQppf5MxuIa77BYo4dAXtQP4Rxpu7fw=;
    b=QZqk9E23590GTpmbxMTUuk5j4tRFRmOkyDwSOSmdsJ7dv1/lJ++cHBy1oG5QI+50zH
    HOP6jI27BwViVGeT4QJLCiEkdLR19qtY0bIUWaj2KE4c7Vh9hkC3Jw9YHUdALYLI8Jqi
    pXAjmVDTMYAnIzZr0mkS5Hjo8ZGGxD6yS/JH8+JXA7ptnAJV2TH38uPdrkF99Va2pIRY
    S2vxTvAswIvcHAPlZK5zrR1MCfGDIabQ96qj832DoAdTS6zXaP6tjSraN8banBk5ewcS
    zIxGFe5obSEBY2Afik6QUeYwqzHf5salqYWWhYprOslJWUhOlp3hvI9JZnaGR6oGRNTS
    lgZA==
Authentication-Results: strato.com;
    dkim=none
X-RZG-AUTH: ":P2MHfkW8eP4Mre39l357AZT/I7AY/7nT2yrDxb8mjG14FZxedJy6qgO1qCHSa1GLptZHusx3hdBqPeOuh2krLEWFUg=="
X-RZG-CLASS-ID: mo00
Received: from [IPV6:2a00:6020:1cff:5b00::b82]
    by smtp.strato.de (RZmta 47.45.0 AUTH)
    with ESMTPSA id R0691fy4HEZAEW5
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
    Tue, 17 May 2022 16:35:10 +0200 (CEST)
Message-ID: <22590a57-c7c6-39c6-06d5-11c6e4e1534b@hartkopp.net>
Date:   Tue, 17 May 2022 16:35:05 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: [PATCH v3 3/4] can: skb:: move can_dropped_invalid_skb and
 can_skb_headroom_valid to skb.c
Content-Language: en-US
To:     Max Staudt <max@enpas.org>
Cc:     Marc Kleine-Budde <mkl@pengutronix.de>,
        Vincent MAILHOL <mailhol.vincent@wanadoo.fr>,
        linux-can@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
References: <20220513142355.250389-1-mailhol.vincent@wanadoo.fr>
 <20220514141650.1109542-1-mailhol.vincent@wanadoo.fr>
 <20220514141650.1109542-4-mailhol.vincent@wanadoo.fr>
 <7b1644ad-c117-881e-a64f-35b8d8b40ef7@hartkopp.net>
 <CAMZ6RqKZMHXB7rQ70GrXcVE7x7kytAAGfE+MOpSgWgWgp0gD2g@mail.gmail.com>
 <20220517060821.akuqbqxro34tj7x6@pengutronix.de>
 <CAMZ6RqJ3sXYUOpw7hEfDzj14H-vXK_i+eYojBk2Lq=h=7cm7Jg@mail.gmail.com>
 <20220517104545.eslountqjppvcnz2@pengutronix.de>
 <e054f6d4-7ed1-98ac-8364-425f4ef0f760@hartkopp.net>
 <20220517141404.578d188a.max@enpas.org>
 <20220517122153.4r6n6kkbdslsa2hv@pengutronix.de>
 <20220517143921.08458f2c.max@enpas.org>
 <0b505b1f-1ee4-5a2c-3bbf-6e9822f78817@hartkopp.net>
 <20220517154301.5bf99ba9.max@enpas.org>
From:   Oliver Hartkopp <socketcan@hartkopp.net>
In-Reply-To: <20220517154301.5bf99ba9.max@enpas.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 17.05.22 15:43, Max Staudt wrote:
> On Tue, 17 May 2022 15:35:03 +0200
> Oliver Hartkopp <socketcan@hartkopp.net> wrote:
> 
>> Oh, I didn't want to introduce two new kernel modules but to have
>> can_dev in different 'feature levels'.
> 
> Which I agree is a nice idea, as long as heisenbugs can be avoided :)
> 
> (as for the separate modules vs. feature levels of can-dev - sorry, my
> two paragraphs were each referring to a different idea. I mixed them
> into one single email...)
> 
> 
> Maybe the can-skb and rx-offload parts could be a *visible* sub-option
> of can-dev in Kconfig, which is normally optional, but immediately
> force-selected once a CAN HW driver is selected?

I think it should be even more simple.

When you enter the current Kconfig page of "CAN Device Drivers" every 
selection of vcan/vxcan/slcan should directly select CAN_DEV_SW.

The rest could stay the same, e.g. selecting CAN_DEV "Platform CAN 
drivers with Netlink support" which then enables CAN_CALC_BITTIMING and 
CAN_LEDS to be selectable. Which also makes sure the old .config files 
still apply.

And finally the selection of flexcan, ti_hecc and
mcp251xfd automatically selects CAN_DEV_RX_OFFLOAD.

Then only some more Makefile magic has to be done to build can-dev.ko 
accordingly.

Best regards,
Oliver



> 
> 
>> But e.g. the people that are running Linux instances in a cloud only
>> using vcan and vxcan would not need to carry the entire
>> infrastructure of CAN hardware support and rx-offload.
> 
> Out of curiosity, do you have an example use case for this vcan cloud
> setup? I can't dream one up...
> 
> 
> 
> Max
