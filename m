Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F1B7A52A759
	for <lists+netdev@lfdr.de>; Tue, 17 May 2022 17:50:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350485AbiEQPuP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 May 2022 11:50:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350320AbiEQPuO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 May 2022 11:50:14 -0400
Received: from mo4-p01-ob.smtp.rzone.de (mo4-p01-ob.smtp.rzone.de [85.215.255.50])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 668A841625;
        Tue, 17 May 2022 08:50:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1652802608;
    s=strato-dkim-0002; d=hartkopp.net;
    h=In-Reply-To:From:References:Cc:To:Subject:Date:Message-ID:Cc:Date:
    From:Subject:Sender;
    bh=umUNayokkaTSmspLVRIo0mZYj7Hd4ZnNmdSOcnNn1eU=;
    b=C/ZOv2NbtShmR/v76wbTsLX7/tQlb8/ByXpAW0i8b3iXQS3zZutvj9rmKNrmzZAuN3
    PO3LmLyE/xzplheDK1zx1sq1wV/MKXZ2EqdFG/4iKsybTWA/649hKeUHDdVq+fufJnj9
    ihg6VKs8yCU7Y9n/wYb9ZQO8mPKep/T8NRiXWaqc5c7e7ODO9vNRwMi8vIHYwj5s/xUq
    BOEClyEopf3regpz4zN/aZx8iIMqq69Q1OQeVfZfBzzMim0oyss55NLwR7yU1cDJWJI7
    PN5g2vet0XzDQuQ1WMGhsRVVO8GCZzvosyiHJe6pETOqjrXyu7OOTG68BKAwB1zrjA9+
    rc6w==
Authentication-Results: strato.com;
    dkim=none
X-RZG-AUTH: ":P2MHfkW8eP4Mre39l357AZT/I7AY/7nT2yrDxb8mjG14FZxedJy6qgO1qCHSa1GLptZHusx3hdBqPeOuh2krLEWFUg=="
X-RZG-CLASS-ID: mo00
Received: from [IPV6:2a00:6020:1cff:5b00::b82]
    by smtp.strato.de (RZmta 47.45.0 AUTH)
    with ESMTPSA id R0691fy4HFo8Ejx
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
    Tue, 17 May 2022 17:50:08 +0200 (CEST)
Message-ID: <e51a64cd-1130-9c65-2bde-483c63f6aa10@hartkopp.net>
Date:   Tue, 17 May 2022 17:50:03 +0200
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
 <22590a57-c7c6-39c6-06d5-11c6e4e1534b@hartkopp.net>
 <20220517173821.445c5e90.max@enpas.org>
From:   Oliver Hartkopp <socketcan@hartkopp.net>
In-Reply-To: <20220517173821.445c5e90.max@enpas.org>
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



On 17.05.22 17:38, Max Staudt wrote:
> On Tue, 17 May 2022 16:35:05 +0200
> Oliver Hartkopp <socketcan@hartkopp.net> wrote:
> 
>> I think it should be even more simple.
>>
>> When you enter the current Kconfig page of "CAN Device Drivers" every
>> selection of vcan/vxcan/slcan should directly select CAN_DEV_SW.
> 
> I'm a bit lost - what would CAN_DEV_SW do?

It should be just *one* enabler of building can-dev-ko

> If it enables can_dropped_invalid_skb(), then the HW drivers would also
> need to depend on CAN_DEV_SW directly or indirectly, or am I missing
> something?

And CAN_DEV is another enabler that would build the skb stuff from 
CAN_DEV_SW too (but also the netlink stuff).

That's what I meant with "some Makefile magic" which is then building 
the can-dev.ko with the required features depending on CAN_DEV_SW, 
CAN_DEV, CAN_DEV_RX_OFFLOAD, CAN_CALC_BITTIMING, etc

Best,
Oliver

