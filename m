Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 19645613311
	for <lists+netdev@lfdr.de>; Mon, 31 Oct 2022 10:52:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230229AbiJaJwS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Oct 2022 05:52:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229927AbiJaJwQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Oct 2022 05:52:16 -0400
Received: from mo4-p01-ob.smtp.rzone.de (mo4-p01-ob.smtp.rzone.de [85.215.255.54])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F587D2C2;
        Mon, 31 Oct 2022 02:52:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1667209912;
    s=strato-dkim-0002; d=hartkopp.net;
    h=In-Reply-To:From:References:Cc:To:Subject:Date:Message-ID:Cc:Date:
    From:Subject:Sender;
    bh=1q9fEUOKuWy2MmpzvJRJt2YAOqO+9Lu7ei8YZTtRDnw=;
    b=OKf136eLS80IjVjyiiVmEC2iCWzIYr8JCbN97wCerT39e6vXtlnwqkgTBUQ1C7f6g6
    CnqcLJumhQWlXgo3g1UqtluwG797VBqdHcY5Zz56hPQtyiQvuCBgZU/0jcfxAkLn1r3b
    udMh+XiEBJ+kheYR/NUBUnTqetnBvG9nNy9P9gV2MqzC7uEcWfNXotqdlNMHVb1owGG3
    Q6XkPf5vau90VF+kIF/oF833mcRsIusEfaJbDmfhy4EJd4hEu2NCNU6QRVs6k2M1nbGZ
    cNjS3vWhkAWaZ2PVQ+VUnGj3QB/mZwhNjFWyGyqQCVDJgoOJ35iQv2UCVA+IS4KoErVX
    ykTw==
Authentication-Results: strato.com;
    dkim=none
X-RZG-AUTH: ":P2MHfkW8eP4Mre39l357AZT/I7AY/7nT2yrDxb8mjG14FZxedJy6qgO1qCHSa1GLptZHusx3hdIrpKytISr6hZqJAw=="
X-RZG-CLASS-ID: mo00
Received: from [IPV6:2a00:6020:1cfd:d104::923]
    by smtp.strato.de (RZmta 48.2.1 AUTH)
    with ESMTPSA id Dde783y9V9pqDjr
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
    Mon, 31 Oct 2022 10:51:52 +0100 (CET)
Message-ID: <ef85bc4b-fbd0-f21c-1fe6-345659934bd9@hartkopp.net>
Date:   Mon, 31 Oct 2022 10:51:26 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.0
Subject: Re: [PATCH] can: canxl: Fix unremoved canxl_packet in can_exit()
To:     Chen Zhongjin <chenzhongjin@huawei.com>,
        linux-kernel@vger.kernel.org, linux-can@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     mkl@pengutronix.de, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, mailhol.vincent@wanadoo.fr
References: <20221031033053.37849-1-chenzhongjin@huawei.com>
Content-Language: en-US
From:   Oliver Hartkopp <socketcan@hartkopp.net>
In-Reply-To: <20221031033053.37849-1-chenzhongjin@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 31.10.22 04:30, Chen Zhongjin wrote:
> In can_init(), dev_add_pack(&canxl_packet) is added but not removed in
> can_exit(). It break the packet handler list and can make kernel panic
> when can_init() for the second time.
> 
>> modprobe can && rmmod can
>> rmmod xxx && modprobe can
> 
> BUG: unable to handle page fault for address: fffffbfff807d7f4
> RIP: 0010:dev_add_pack+0x133/0x1f0
> Call Trace:
>   <TASK>
>   can_init+0xaa/0x1000 [can]
>   do_one_initcall+0xd3/0x4e0
>   ...
> 
> Fixes: fb08cba12b52 ("can: canxl: update CAN infrastructure for CAN XL frames")
> Signed-off-by: Chen Zhongjin <chenzhongjin@huawei.com>

Acked-by: Oliver Hartkopp <socketcan@hartkopp.net>

Thanks for the finding!

Best regards,
Oliver

> ---
>   net/can/af_can.c | 1 +
>   1 file changed, 1 insertion(+)
> 
> diff --git a/net/can/af_can.c b/net/can/af_can.c
> index 9503ab10f9b8..5e9e3e1e9825 100644
> --- a/net/can/af_can.c
> +++ b/net/can/af_can.c
> @@ -902,6 +902,7 @@ static __init int can_init(void)
>   static __exit void can_exit(void)
>   {
>   	/* protocol unregister */
> +	dev_remove_pack(&canxl_packet);
>   	dev_remove_pack(&canfd_packet);
>   	dev_remove_pack(&can_packet);
>   	sock_unregister(PF_CAN);
