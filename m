Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A34E65B1510
	for <lists+netdev@lfdr.de>; Thu,  8 Sep 2022 08:49:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231250AbiIHGtG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Sep 2022 02:49:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231132AbiIHGsr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Sep 2022 02:48:47 -0400
Received: from mo4-p01-ob.smtp.rzone.de (mo4-p01-ob.smtp.rzone.de [81.169.146.167])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08DE3D2B0D;
        Wed,  7 Sep 2022 23:48:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1662619683;
    s=strato-dkim-0002; d=hartkopp.net;
    h=In-Reply-To:From:References:Cc:To:Subject:Date:Message-ID:Cc:Date:
    From:Subject:Sender;
    bh=O1xo/jjb+NdYDRz2qFvm3F+/OFhapvqfEg6EDCRFB44=;
    b=qq2fYL4pMNxmi56Dy/4bW3/tUO9k27iILB5jy82RXy9tclbWVfP9uRnUJVrRqnQGY2
    5RNy7PT6CBq0Hw30j+233F4+KVQp1bUB5YRKqaNZP+33eL7cDMD9EeZh5ZDhFt/vTGLN
    KxRxmEngDJPQbSO1svem5rUIxz2eZ61X3gMce1gSxtJ7izcGs58u6yO2G+5jtRbmfW+m
    IMPhqHx6YHSvu/Q3a9YH1mON16n6ZpZ7mqW13Vim2H9h3ctlvA9jwh1cKxoeK/m3Fqgg
    YNeoXnAu/tTTaUc4IBYZoSZOSWIH3CbAbzWIlNdgZBqtccOKvnchAN5Ihp/NB2yNV1qX
    mK5A==
Authentication-Results: strato.com;
    dkim=none
X-RZG-AUTH: ":P2MHfkW8eP4Mre39l357AZT/I7AY/7nT2yrDxb8mjG14FZxedJy6qgO1qCHSa1GLptZHusx3hdIrpKytJSr63tDxrw=="
X-RZG-CLASS-ID: mo00
Received: from [IPV6:2a00:6020:1cfd:d100::b82]
    by smtp.strato.de (RZmta 48.0.2 AUTH)
    with ESMTPSA id wfa541y886m3685
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
    Thu, 8 Sep 2022 08:48:03 +0200 (CEST)
Message-ID: <1caf3e52-c862-e702-c833-153f130b790a@hartkopp.net>
Date:   Thu, 8 Sep 2022 08:47:57 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.0
Subject: Re: [PATCH 2/2] can: bcm: check the result of can_send() in
 bcm_can_tx()
Content-Language: en-US
To:     Ziyang Xuan <william.xuanziyang@huawei.com>, mkl@pengutronix.de,
        edumazet@google.com, kuba@kernel.org, linux-can@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org
References: <cover.1662606045.git.william.xuanziyang@huawei.com>
 <5c0f2f1bd1dc7bbb9500afd4273e36378e00a35d.1662606045.git.william.xuanziyang@huawei.com>
From:   Oliver Hartkopp <socketcan@hartkopp.net>
In-Reply-To: <5c0f2f1bd1dc7bbb9500afd4273e36378e00a35d.1662606045.git.william.xuanziyang@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sorry, but NACK.

The curr_frame counter handles the sequence counter of multiplex messages.

Even when this single send attempt failed the curr_frame counter has to 
continue.

For that reason the comment about statistics *before* the curr_frame++ 
might be misleading.

A potential improvement could be:

	if (!(can_send(skb, 1)))
		op->frames_abs++;

	op->currframe++;

But as op->frames_abs is a functional unused(!) value for tx ops and 
only displayed via procfs I would NOT tag such improvement as a 'fix' 
which might then be queued up for stable.

This could be something for the can-next tree ...

Best regards,
Oliver


On 08.09.22 05:04, Ziyang Xuan wrote:
> If can_send() fail, it should not update statistics in bcm_can_tx().
> Add the result check for can_send() in bcm_can_tx().
> 
> Fixes: ffd980f976e7 ("[CAN]: Add broadcast manager (bcm) protocol")
> Signed-off-by: Ziyang Xuan <william.xuanziyang@huawei.com>
> ---
>   net/can/bcm.c | 3 ++-
>   1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/net/can/bcm.c b/net/can/bcm.c
> index e2783156bfd1..8f5d704a409f 100644
> --- a/net/can/bcm.c
> +++ b/net/can/bcm.c
> @@ -298,7 +298,8 @@ static void bcm_can_tx(struct bcm_op *op)
>   	/* send with loopback */
>   	skb->dev = dev;
>   	can_skb_set_owner(skb, op->sk);
> -	can_send(skb, 1);
> +	if (can_send(skb, 1))
> +		goto out;
>   
>   	/* update statistics */
>   	op->currframe++;
