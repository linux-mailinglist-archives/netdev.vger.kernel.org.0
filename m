Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8024D52A0BC
	for <lists+netdev@lfdr.de>; Tue, 17 May 2022 13:52:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344669AbiEQLwK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 May 2022 07:52:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230254AbiEQLwJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 May 2022 07:52:09 -0400
Received: from mo4-p00-ob.smtp.rzone.de (mo4-p00-ob.smtp.rzone.de [85.215.255.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3B08CE0E;
        Tue, 17 May 2022 04:52:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1652788322;
    s=strato-dkim-0002; d=hartkopp.net;
    h=In-Reply-To:From:References:Cc:To:Subject:Date:Message-ID:Cc:Date:
    From:Subject:Sender;
    bh=v4GkYgTTABh4HPSdojrqVvE6+lNCX1q0yeD6U3RA25Q=;
    b=Hxe9PyozAcYw2b678Pt2M8Dqa4rBFAZ2vIug+BOA/nO2j+W8XHdnvY+DyFSRv8mTu6
    BpqPOWQ5YXDHavWBs9bJpHAI9J8iTHhmt0YCkP2QH+WGZFsLDGLP7bquZEpm1JdR38Qt
    uqBuJx1DxKWGZDb9eQhUVcZfHwiZUw7aUOc+3mA7gHOxCLDhK5y9y+GPUM8p2Id4lThf
    TO2grjmERUqGu5H8Mwn7u+vmUGe0umbf4ac0NSHMpeKSVTNsMNolcRaazpfVb31863xS
    3xgg1bwGLTR3jyTLnWxdcHP8kgvmItaQzbaQZl/U4ng+N05clGNKihw0rcPEuhPYmh16
    9XHw==
Authentication-Results: strato.com;
    dkim=none
X-RZG-AUTH: ":P2MHfkW8eP4Mre39l357AZT/I7AY/7nT2yrDxb8mjG14FZxedJy6qgO1qCHSa1GLptZHusx3hdBqPeOuh2krLEWFUg=="
X-RZG-CLASS-ID: mo00
Received: from [IPV6:2a00:6020:1cff:5b00::b82]
    by smtp.strato.de (RZmta 47.45.0 AUTH)
    with ESMTPSA id R0691fy4HBq1Dq4
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
    Tue, 17 May 2022 13:52:01 +0200 (CEST)
Message-ID: <e054f6d4-7ed1-98ac-8364-425f4ef0f760@hartkopp.net>
Date:   Tue, 17 May 2022 13:51:57 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: [PATCH v3 3/4] can: skb:: move can_dropped_invalid_skb and
 can_skb_headroom_valid to skb.c
Content-Language: en-US
To:     Marc Kleine-Budde <mkl@pengutronix.de>,
        Vincent MAILHOL <mailhol.vincent@wanadoo.fr>
Cc:     linux-can@vger.kernel.org, linux-kernel@vger.kernel.org,
        Max Staudt <max@enpas.org>, netdev@vger.kernel.org
References: <20220513142355.250389-1-mailhol.vincent@wanadoo.fr>
 <20220514141650.1109542-1-mailhol.vincent@wanadoo.fr>
 <20220514141650.1109542-4-mailhol.vincent@wanadoo.fr>
 <7b1644ad-c117-881e-a64f-35b8d8b40ef7@hartkopp.net>
 <CAMZ6RqKZMHXB7rQ70GrXcVE7x7kytAAGfE+MOpSgWgWgp0gD2g@mail.gmail.com>
 <20220517060821.akuqbqxro34tj7x6@pengutronix.de>
 <CAMZ6RqJ3sXYUOpw7hEfDzj14H-vXK_i+eYojBk2Lq=h=7cm7Jg@mail.gmail.com>
 <20220517104545.eslountqjppvcnz2@pengutronix.de>
From:   Oliver Hartkopp <socketcan@hartkopp.net>
In-Reply-To: <20220517104545.eslountqjppvcnz2@pengutronix.de>
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



On 17.05.22 12:45, Marc Kleine-Budde wrote:
> On 17.05.2022 16:04:53, Vincent MAILHOL wrote:
>> So slcan, v(x)can and can-dev will select can-skb, and some of the
>> hardware drivers (still have to figure out the list) will select
>> can-rx-offload (other dependencies will stay as it is today).
> 
> For rx-offload that's flexcan, ti_hecc and mcp251xfd
> 
>> I think that splitting the current can-dev into can-skb + can-dev +
>> can-rx-offload is enough. Please let me know if you see a need for
>> more.

After looking through drivers/net/can/Kconfig I would probably phrase it 
like this:

Select CAN devices (hw/sw) -> we compile a can_dev module. E.g. to 
handle the skb stuff for vcan's.

Select hardware CAN devices -> we compile the netlink stuff into can_dev 
and offer CAN_CALC_BITTIMING and CAN_LEDS to be compiled into can_dev too.

In the latter case: The selection of flexcan, ti_hecc and mcp251xfd 
automatically selects CAN_RX_OFFLOAD which is then also compiled into 
can_dev.

Would that fit in terms of complexity?

Best,
Oliver
