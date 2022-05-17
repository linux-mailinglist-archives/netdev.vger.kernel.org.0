Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 63A2952A380
	for <lists+netdev@lfdr.de>; Tue, 17 May 2022 15:35:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347891AbiEQNfQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 May 2022 09:35:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243021AbiEQNfP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 May 2022 09:35:15 -0400
Received: from mo4-p00-ob.smtp.rzone.de (mo4-p00-ob.smtp.rzone.de [81.169.146.221])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC6F34C795;
        Tue, 17 May 2022 06:35:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1652794510;
    s=strato-dkim-0002; d=hartkopp.net;
    h=In-Reply-To:From:References:Cc:To:Subject:Date:Message-ID:Cc:Date:
    From:Subject:Sender;
    bh=Rp91Wk++k/5LeCAt8Q1r8LuSJbklfuV4ylHC92VYA90=;
    b=DW4ijKfudIAgDozIFv2qZffi5LDTuKJTgTGws3OZ74RJTi6xxFMNeQoTrBEfvH2hEM
    bBgOsv9Z9ck0JEmBCZAEvSKOlr78fs1bVrbREopwb6yQdcW2RQPPwWyg24t6cezEQyoU
    WABEvnuQpuefPFCLF3fXzUwMaHo9FNHz4U+fIAOwUKfkesxdecMaEgFt5ew+9fSrT3Rb
    KtwyBMGnMqnfJ/cvBTRvM9IVIe9IjKpOLRhEpx+4gg7J6YeN4udmrNl4UAxDO0cDUZ8/
    CTujr0kclnJ49+h5HBdTSyF8iBpJtUKlVAI7BaFZEQ2C6WlGMRDokcZV08lcOTYWZxOP
    wdjg==
Authentication-Results: strato.com;
    dkim=none
X-RZG-AUTH: ":P2MHfkW8eP4Mre39l357AZT/I7AY/7nT2yrDxb8mjG14FZxedJy6qgO1qCHSa1GLptZHusx3hdBqPeOuh2kie+Xl80LlDzEQtkFfeVo6PFYN7Q=="
X-RZG-CLASS-ID: mo00
Received: from [IPV6:2a00:6020:1cff:5b00:35f3:7c7f:af09:932d]
    by smtp.strato.de (RZmta 47.45.0 AUTH)
    with ESMTPSA id R0691fy4HDZ9EHF
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
    Tue, 17 May 2022 15:35:09 +0200 (CEST)
Message-ID: <0b505b1f-1ee4-5a2c-3bbf-6e9822f78817@hartkopp.net>
Date:   Tue, 17 May 2022 15:35:03 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
Subject: Re: [PATCH v3 3/4] can: skb:: move can_dropped_invalid_skb and
 can_skb_headroom_valid to skb.c
Content-Language: en-US
To:     Max Staudt <max@enpas.org>, Marc Kleine-Budde <mkl@pengutronix.de>
Cc:     Vincent MAILHOL <mailhol.vincent@wanadoo.fr>,
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
From:   Oliver Hartkopp <socketcan@hartkopp.net>
In-Reply-To: <20220517143921.08458f2c.max@enpas.org>
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



On 5/17/22 14:39, Max Staudt wrote:
> On Tue, 17 May 2022 14:21:53 +0200
> Marc Kleine-Budde <mkl@pengutronix.de> wrote:
> 
>> On 17.05.2022 14:14:04, Max Staudt wrote:
>>>> After looking through drivers/net/can/Kconfig I would probably
>>>> phrase it like this:
>>>>
>>>> Select CAN devices (hw/sw) -> we compile a can_dev module. E.g.
>>>> to handle the skb stuff for vcan's.
>>>>
>>>> Select hardware CAN devices -> we compile the netlink stuff into
>>>> can_dev and offer CAN_CALC_BITTIMING and CAN_LEDS to be compiled
>>>> into can_dev too.
>>>>
>>>> In the latter case: The selection of flexcan, ti_hecc and
>>>> mcp251xfd automatically selects CAN_RX_OFFLOAD which is then also
>>>> compiled into can_dev.
>>>>
>>>> Would that fit in terms of complexity?
>>>
>>> IMHO these should always be compiled into can-dev. Out of tree
>>> drivers are fairly common here, and having to determine which kind
>>> of can-dev (stripped or not) the user has on their system is a
>>> nightmare waiting to happen.
>>
>> I personally don't care about out-of-tree drivers.
> 
> I know that this is the official stance in the kernel.
> 
> But out-of-tree drivers do happen on a regular basis, even when
> developing with the aim of upstreaming. And if a developer builds a
> minimal kernel to host a CAN driver, without building in-tree hardware
> CAN drivers, then can-dev will be there but behave differently from
> can-dev in a full distro. Leading to heisenbugs and wasting time. The
> source of heisenbugs really are the suggested *hidden* Kconfigs.
> 
> 
> On another note, is the module accounting overhead in the kernel for
> two new modules with relatively little code in each, code that almost
> always is loaded when CAN is used, really worth it?

Oh, I didn't want to introduce two new kernel modules but to have 
can_dev in different 'feature levels'.

I would assume a distro kernel to have everything enabled with a full 
featured can_dev - which is likely the base for out-of-tree drivers too.

But e.g. the people that are running Linux instances in a cloud only 
using vcan and vxcan would not need to carry the entire infrastructure 
of CAN hardware support and rx-offload.

Best regards,
Oliver
