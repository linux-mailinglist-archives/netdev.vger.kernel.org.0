Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CBD1A523625
	for <lists+netdev@lfdr.de>; Wed, 11 May 2022 16:50:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245068AbiEKOuW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 May 2022 10:50:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245089AbiEKOuR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 May 2022 10:50:17 -0400
Received: from mo4-p01-ob.smtp.rzone.de (mo4-p01-ob.smtp.rzone.de [85.215.255.54])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF9A819FF7E;
        Wed, 11 May 2022 07:50:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1652280607;
    s=strato-dkim-0002; d=hartkopp.net;
    h=In-Reply-To:From:References:Cc:To:Subject:Date:Message-ID:Cc:Date:
    From:Subject:Sender;
    bh=8O2cVCTEJiG9Saz5teTiN4WXvdQwaPKShwXqV7miEQ0=;
    b=YSLKyPN6Sd0+VEfc2S2yHINv1+Ju8pKU/iEVr3u90zFzO0Doo5quDHDg7pg0zbS/Nu
    /XoO1exFah7ICoJgRWLicD9cmpbo4+eqDRK0Xl3iQc7xG69mpjR12SZZK5zF3jOiVFGT
    cxqsQt9zMkde8V049NT3mah45mkMjkhuS82wTIWbvVzdh5uMnTJkfwX281h5ZS2EvioR
    QDbWal9ysPSdaGdQuPCZGwh7E184uLto9rn2YymEe+4pDwd48XLqqtSkc1Y6TI8SDtEW
    oSXtEy7YjvSRMt2HxCJ5rrvLz4HbZBtTx2qKfj7hxmA111cj7UW7oD27MSqmgIfamjlY
    OakQ==
Authentication-Results: strato.com;
    dkim=none
X-RZG-AUTH: ":P2MHfkW8eP4Mre39l357AZT/I7AY/7nT2yrDxb8mjG14FZxedJy6qgO1qCHSa1GLptZHusx3hdBqPeOuh2koeKQvJnLjhchY2TXGXhEF98MlNg=="
X-RZG-CLASS-ID: mo00
Received: from [IPV6:2a00:6020:1cff:5b00:9642:f755:5daa:777e]
    by smtp.strato.de (RZmta 47.42.2 AUTH)
    with ESMTPSA id 4544c9y4BEo7yaU
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
    Wed, 11 May 2022 16:50:07 +0200 (CEST)
Message-ID: <002d234f-a7d6-7b1a-72f4-157d7a283446@hartkopp.net>
Date:   Wed, 11 May 2022 16:50:06 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
Subject: Re: [PATCH 1/1] can: skb: add and set local_origin flag
Content-Language: en-US
To:     Marc Kleine-Budde <mkl@pengutronix.de>
Cc:     Oleksij Rempel <o.rempel@pengutronix.de>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Devid Antonio Filoni <devid.filoni@egluetechnologies.com>,
        kernel@pengutronix.de, linux-can@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        David Jander <david@protonic.nl>
References: <20220511121913.2696181-1-o.rempel@pengutronix.de>
 <b631b022-72d5-9160-fd13-f33c80dbbe59@hartkopp.net>
 <20220511132421.7o5a3po32l3w2wcr@pengutronix.de>
 <20220511143620.kphwgp2vhjyoecs5@pengutronix.de>
From:   Oliver Hartkopp <socketcan@hartkopp.net>
In-Reply-To: <20220511143620.kphwgp2vhjyoecs5@pengutronix.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 5/11/22 16:36, Marc Kleine-Budde wrote:
> On 11.05.2022 15:24:21, Marc Kleine-Budde wrote:
>> On 11.05.2022 14:38:32, Oliver Hartkopp wrote:
>>> IMO this patch does not work as intended.
>>>
>>> You probably need to revisit every place where can_skb_reserve() is used,
>>> e.g. in raw_sendmsg().
>>
>> And the loopback for devices that don't support IFF_ECHO:
>>
>> | https://elixir.bootlin.com/linux/latest/source/net/can/af_can.c#L257
> 
> BTW: There is a bug with interfaces that don't support IFF_ECHO.
> 
> Assume an invalid CAN frame is passed to can_send() on an interface that
> doesn't support IFF_ECHO. The above mentioned code does happily generate
> an echo frame and it's send, even if the driver drops it, due to
> can_dropped_invalid_skb(dev, skb).
> 
> The echoed back CAN frame is treated in raw_rcv() as if the headroom is valid:
> 
> | https://elixir.bootlin.com/linux/v5.17.6/source/net/can/raw.c#L138
> 
> But as far as I can see the can_skb_headroom_valid() check never has
> been done. What about this patch?
> 
> index 1fb49d51b25d..fda4807ad165 100644
> --- a/net/can/af_can.c
> +++ b/net/can/af_can.c
> @@ -255,6 +255,9 @@ int can_send(struct sk_buff *skb, int loop)
>                   */
>   
>                  if (!(skb->dev->flags & IFF_ECHO)) {
> +                       if (can_dropped_invalid_skb(dev, skb))
> +                               return -EINVAL;
> +

Good point!

But please check the rest of the code.
You need 'goto inval_skb;' instead of the return ;-)

Best,
Oliver

>                          /* If the interface is not capable to do loopback
>                           * itself, we do it here.
>                           */
> 
> Marc
> 
