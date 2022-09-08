Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BF63F5B1573
	for <lists+netdev@lfdr.de>; Thu,  8 Sep 2022 09:13:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230126AbiIHHN2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Sep 2022 03:13:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229508AbiIHHNZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Sep 2022 03:13:25 -0400
Received: from mo4-p01-ob.smtp.rzone.de (mo4-p01-ob.smtp.rzone.de [85.215.255.51])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A33F7D4778;
        Thu,  8 Sep 2022 00:13:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1662621015;
    s=strato-dkim-0002; d=hartkopp.net;
    h=In-Reply-To:From:References:Cc:To:Subject:Date:Message-ID:Cc:Date:
    From:Subject:Sender;
    bh=PfeGL0sg6M1qDITuSaR33ABiwlNh0JNNpQKasyQHY9w=;
    b=F4Gqllbp0TDCEP0rVJILYj2fwQKzRHcFjhF2a3FQ/9PIVX1TCqqjkzfl7Xds5aYyJR
    CBWd0hFjQPC6SrQ4GmN8Ty6/bkpq/OF2jT6QNXgx1fibybvqPLgX/grEhuNCqraOO0To
    16gH9XfiDh/2sF6GgUrcVvf/T9UYfNGyVwFdAkPBpjuUxm9pQ9kiCy/AvR4cEMafu6eP
    XCcMgy5yovnDYyTHmeT0I6zX4NXmub0ITZJPgg6bG5/O+0suu0Rn1EKFe87R5HYbws9F
    zS5CJMF6H5MAzIsE9mW7lp1kEZQjim/0XSY5iC7yVrmqz+8/TrNKlZSwXo2eYQg/oPNG
    Gk4w==
Authentication-Results: strato.com;
    dkim=none
X-RZG-AUTH: ":P2MHfkW8eP4Mre39l357AZT/I7AY/7nT2yrDxb8mjG14FZxedJy6qgO1qCHSa1GLptZHusx3hdIrpKytJSr63tDxrw=="
X-RZG-CLASS-ID: mo00
Received: from [IPV6:2a00:6020:1cfd:d100::b82]
    by smtp.strato.de (RZmta 48.0.2 AUTH)
    with ESMTPSA id wfa541y887AF6Dj
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
    Thu, 8 Sep 2022 09:10:15 +0200 (CEST)
Message-ID: <381dd961-f786-2400-0977-9639c3f7006e@hartkopp.net>
Date:   Thu, 8 Sep 2022 09:10:15 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.0
Subject: Re: [PATCH 1/2] can: bcm: registration process optimization in
 bcm_module_init()
Content-Language: en-US
To:     Ziyang Xuan <william.xuanziyang@huawei.com>, mkl@pengutronix.de,
        edumazet@google.com, kuba@kernel.org, linux-can@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org
References: <cover.1662606045.git.william.xuanziyang@huawei.com>
 <823cff0ebec33fa9389eeaf8b8ded3217c32cb38.1662606045.git.william.xuanziyang@huawei.com>
From:   Oliver Hartkopp <socketcan@hartkopp.net>
In-Reply-To: <823cff0ebec33fa9389eeaf8b8ded3217c32cb38.1662606045.git.william.xuanziyang@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-6.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 08.09.22 05:04, Ziyang Xuan wrote:
> Now, register_netdevice_notifier() and register_pernet_subsys() are both
> after can_proto_register(). It can create CAN_BCM socket and process socket
> once can_proto_register() successfully, so it is possible missing notifier
> event or proc node creation because notifier or bcm proc directory is not
> registered or created yet. Although this is a low probability scenario, it
> is not impossible.
> 
> Move register_pernet_subsys() and register_netdevice_notifier() to the
> front of can_proto_register(). In addition, register_pernet_subsys() and
> register_netdevice_notifier() may fail, check their results are necessary.
> 
> Signed-off-by: Ziyang Xuan <william.xuanziyang@huawei.com>
> ---
>   net/can/bcm.c | 18 +++++++++++++++---
>   1 file changed, 15 insertions(+), 3 deletions(-)
> 
> diff --git a/net/can/bcm.c b/net/can/bcm.c
> index e60161bec850..e2783156bfd1 100644
> --- a/net/can/bcm.c
> +++ b/net/can/bcm.c
> @@ -1744,15 +1744,27 @@ static int __init bcm_module_init(void)
>   
>   	pr_info("can: broadcast manager protocol\n");
>   
> +	err = register_pernet_subsys(&canbcm_pernet_ops);
> +	if (err)
> +		return err;

Analogue to your patch for the CAN_RAW socket here (which has been 
applied to can-next right now) ...

https://lore.kernel.org/linux-can/7af9401f0d2d9fed36c1667b5ac9b8df8f8b87ee.1661584485.git.william.xuanziyang@huawei.com/T/#u

... I'm not sure whether this is the right sequence to acquire the 
different resources here.

E.g. in ipsec_pfkey_init() in af_key.c

https://elixir.bootlin.com/linux/v5.19.7/source/net/key/af_key.c#L3887

proto_register() is executed before register_pernet_subsys()

Which seems to be more natural to me.

Best regards,
Oliver

> +
> +	err = register_netdevice_notifier(&canbcm_notifier);
> +	if (err)
> +		goto register_notifier_failed;
> +
>   	err = can_proto_register(&bcm_can_proto);
>   	if (err < 0) {
>   		printk(KERN_ERR "can: registration of bcm protocol failed\n");
> -		return err;
> +		goto register_proto_failed;
>   	}
>   
> -	register_pernet_subsys(&canbcm_pernet_ops);
> -	register_netdevice_notifier(&canbcm_notifier);
>   	return 0;
> +
> +register_proto_failed:
> +	unregister_netdevice_notifier(&canbcm_notifier);
> +register_notifier_failed:
> +	unregister_pernet_subsys(&canbcm_pernet_ops);
> +	return err;
>   }
>   
>   static void __exit bcm_module_exit(void)
