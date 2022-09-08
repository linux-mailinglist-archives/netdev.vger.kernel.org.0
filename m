Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 089315B1587
	for <lists+netdev@lfdr.de>; Thu,  8 Sep 2022 09:20:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231277AbiIHHUu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Sep 2022 03:20:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230236AbiIHHUt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Sep 2022 03:20:49 -0400
X-Greylist: delayed 180 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 08 Sep 2022 00:20:47 PDT
Received: from mo4-p02-ob.smtp.rzone.de (mo4-p02-ob.smtp.rzone.de [85.215.255.84])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C547CA570D;
        Thu,  8 Sep 2022 00:20:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1662621464;
    s=strato-dkim-0002; d=hartkopp.net;
    h=In-Reply-To:References:Cc:To:From:Subject:Date:Message-ID:Cc:Date:
    From:Subject:Sender;
    bh=R8zeBI33JQE161cSzuZ1/ZAK1yvWGkUNXkMuzy1AVZQ=;
    b=oET3Fu1nJulbWnwUxXLWrdG0OdMl5Si0JnBWlQQlc/g2XThlRQ7Ur+nqF+1l1SPImL
    kDn2DFeZ65IBrhwucaWA5ANVUbUfO+Um9rTgfly+cBL5vPmQsqWUl+YDGZGTP0GVJuxA
    ysb+9i4cZOrrMMVmBpVm+/g86J/B2DX+hc5wWdMerU5DtxiepjNlE7QiqsN2rHh2iwmA
    ogX4/FLnwBp4zdyJHiO+UAxjMRIEBRIasVE5cGFY0BOmppyyCMYywi488HSotaPp65n9
    1tgaEzDSLGMdjrq2qv0Ty85ikHRCyxGXjSTo2WvFVl/cXfmJcs3PLu48+LEebAvJ7ldr
    Idjg==
Authentication-Results: strato.com;
    dkim=none
X-RZG-AUTH: ":P2MHfkW8eP4Mre39l357AZT/I7AY/7nT2yrDxb8mjG14FZxedJy6qgO1qCHSa1GLptZHusx3hdIrpKytJSr63tDxrw=="
X-RZG-CLASS-ID: mo00
Received: from [IPV6:2a00:6020:1cfd:d100::b82]
    by smtp.strato.de (RZmta 48.0.2 AUTH)
    with ESMTPSA id wfa541y887Hi6Fq
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
    Thu, 8 Sep 2022 09:17:44 +0200 (CEST)
Message-ID: <c480bdd7-e35e-fbf9-6767-801e04703780@hartkopp.net>
Date:   Thu, 8 Sep 2022 09:17:43 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.0
Subject: Re: [PATCH 1/2] can: bcm: registration process optimization in
 bcm_module_init()
Content-Language: en-US
From:   Oliver Hartkopp <socketcan@hartkopp.net>
To:     Ziyang Xuan <william.xuanziyang@huawei.com>, mkl@pengutronix.de,
        edumazet@google.com, kuba@kernel.org, linux-can@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org
References: <cover.1662606045.git.william.xuanziyang@huawei.com>
 <823cff0ebec33fa9389eeaf8b8ded3217c32cb38.1662606045.git.william.xuanziyang@huawei.com>
 <381dd961-f786-2400-0977-9639c3f7006e@hartkopp.net>
In-Reply-To: <381dd961-f786-2400-0977-9639c3f7006e@hartkopp.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-6.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Just another reference which make it clear that the reordering of 
function calls in your patch is likely not correct:

https://elixir.bootlin.com/linux/v5.19.7/source/net/packet/af_packet.c#L4734

static int __init packet_init(void)
{
         int rc;

         rc = proto_register(&packet_proto, 0);
         if (rc)
                 goto out;
         rc = sock_register(&packet_family_ops);
         if (rc)
                 goto out_proto;
         rc = register_pernet_subsys(&packet_net_ops);
         if (rc)
                 goto out_sock;
         rc = register_netdevice_notifier(&packet_netdev_notifier);
         if (rc)
                 goto out_pernet;

         return 0;

out_pernet:
         unregister_pernet_subsys(&packet_net_ops);
out_sock:
         sock_unregister(PF_PACKET);
out_proto:
         proto_unregister(&packet_proto);
out:
         return rc;
}



On 08.09.22 09:10, Oliver Hartkopp wrote:
> 
> 
> On 08.09.22 05:04, Ziyang Xuan wrote:
>> Now, register_netdevice_notifier() and register_pernet_subsys() are both
>> after can_proto_register(). It can create CAN_BCM socket and process 
>> socket
>> once can_proto_register() successfully, so it is possible missing 
>> notifier
>> event or proc node creation because notifier or bcm proc directory is not
>> registered or created yet. Although this is a low probability 
>> scenario, it
>> is not impossible.
>>
>> Move register_pernet_subsys() and register_netdevice_notifier() to the
>> front of can_proto_register(). In addition, register_pernet_subsys() and
>> register_netdevice_notifier() may fail, check their results are 
>> necessary.
>>
>> Signed-off-by: Ziyang Xuan <william.xuanziyang@huawei.com>
>> ---
>>   net/can/bcm.c | 18 +++++++++++++++---
>>   1 file changed, 15 insertions(+), 3 deletions(-)
>>
>> diff --git a/net/can/bcm.c b/net/can/bcm.c
>> index e60161bec850..e2783156bfd1 100644
>> --- a/net/can/bcm.c
>> +++ b/net/can/bcm.c
>> @@ -1744,15 +1744,27 @@ static int __init bcm_module_init(void)
>>       pr_info("can: broadcast manager protocol\n");
>> +    err = register_pernet_subsys(&canbcm_pernet_ops);
>> +    if (err)
>> +        return err;
> 
> Analogue to your patch for the CAN_RAW socket here (which has been 
> applied to can-next right now) ...
> 
> https://lore.kernel.org/linux-can/7af9401f0d2d9fed36c1667b5ac9b8df8f8b87ee.1661584485.git.william.xuanziyang@huawei.com/T/#u 
> 
> 
> ... I'm not sure whether this is the right sequence to acquire the 
> different resources here.
> 
> E.g. in ipsec_pfkey_init() in af_key.c
> 
> https://elixir.bootlin.com/linux/v5.19.7/source/net/key/af_key.c#L3887
> 
> proto_register() is executed before register_pernet_subsys()
> 
> Which seems to be more natural to me.
> 
> Best regards,
> Oliver
> 
>> +
>> +    err = register_netdevice_notifier(&canbcm_notifier);
>> +    if (err)
>> +        goto register_notifier_failed;
>> +
>>       err = can_proto_register(&bcm_can_proto);
>>       if (err < 0) {
>>           printk(KERN_ERR "can: registration of bcm protocol failed\n");
>> -        return err;
>> +        goto register_proto_failed;
>>       }
>> -    register_pernet_subsys(&canbcm_pernet_ops);
>> -    register_netdevice_notifier(&canbcm_notifier);
>>       return 0;
>> +
>> +register_proto_failed:
>> +    unregister_netdevice_notifier(&canbcm_notifier);
>> +register_notifier_failed:
>> +    unregister_pernet_subsys(&canbcm_pernet_ops);
>> +    return err;
>>   }
>>   static void __exit bcm_module_exit(void)
