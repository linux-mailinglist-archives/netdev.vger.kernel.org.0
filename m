Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EF7875B2D30
	for <lists+netdev@lfdr.de>; Fri,  9 Sep 2022 05:59:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229576AbiIID67 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Sep 2022 23:58:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229546AbiIID66 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Sep 2022 23:58:58 -0400
Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ECB5F3122D;
        Thu,  8 Sep 2022 20:58:55 -0700 (PDT)
Received: from canpemm500006.china.huawei.com (unknown [172.30.72.54])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4MP2FM4mtRz14QWk;
        Fri,  9 Sep 2022 11:55:03 +0800 (CST)
Received: from [10.174.179.200] (10.174.179.200) by
 canpemm500006.china.huawei.com (7.192.105.130) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Fri, 9 Sep 2022 11:58:53 +0800
Subject: Re: [PATCH 1/2] can: bcm: registration process optimization in
 bcm_module_init()
To:     Oliver Hartkopp <socketcan@hartkopp.net>, <mkl@pengutronix.de>,
        <edumazet@google.com>, <kuba@kernel.org>,
        <linux-can@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     <linux-kernel@vger.kernel.org>
References: <cover.1662606045.git.william.xuanziyang@huawei.com>
 <823cff0ebec33fa9389eeaf8b8ded3217c32cb38.1662606045.git.william.xuanziyang@huawei.com>
 <381dd961-f786-2400-0977-9639c3f7006e@hartkopp.net>
 <c480bdd7-e35e-fbf9-6767-801e04703780@hartkopp.net>
 <7b063d38-311c-76d6-4e31-02f9cccc9bcb@huawei.com>
 <053c7de3-c76c-82fd-2d44-2e7c1673ae98@hartkopp.net>
From:   "Ziyang Xuan (William)" <william.xuanziyang@huawei.com>
Message-ID: <9228b20a-3baa-32ad-6059-5cf0ffdb97a3@huawei.com>
Date:   Fri, 9 Sep 2022 11:58:53 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <053c7de3-c76c-82fd-2d44-2e7c1673ae98@hartkopp.net>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.179.200]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 canpemm500006.china.huawei.com (7.192.105.130)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> 
> 
> On 9/8/22 13:14, Ziyang Xuan (William) wrote:
>>> Just another reference which make it clear that the reordering of function calls in your patch is likely not correct:
>>>
>>> https://elixir.bootlin.com/linux/v5.19.7/source/net/packet/af_packet.c#L4734
>>>
>>> static int __init packet_init(void)
>>> {
>>>          int rc;
>>>
>>>          rc = proto_register(&packet_proto, 0);
>>>          if (rc)
>>>                  goto out;
>>>          rc = sock_register(&packet_family_ops);
>>>          if (rc)
>>>                  goto out_proto;
>>>          rc = register_pernet_subsys(&packet_net_ops);
>>>          if (rc)
>>>                  goto out_sock;
>>>          rc = register_netdevice_notifier(&packet_netdev_notifier);
>>>          if (rc)
>>>                  goto out_pernet;
>>>
>>>          return 0;
>>>
>>> out_pernet:
>>>          unregister_pernet_subsys(&packet_net_ops);
>>> out_sock:
>>>          sock_unregister(PF_PACKET);
>>> out_proto:
>>>          proto_unregister(&packet_proto);
>>> out:
>>>          return rc;
>>> }
>>>
>>
>> I had a simple test with can_raw. kernel modification as following:
>>
>> --- a/net/can/af_can.c
>> +++ b/net/can/af_can.c
>> @@ -118,6 +118,8 @@ static int can_create(struct net *net, struct socket *sock, int protocol,
>>          const struct can_proto *cp;
>>          int err = 0;
>>
>> +       printk("%s: protocol: %d\n", __func__, protocol);
>> +
>>          sock->state = SS_UNCONNECTED;
>>
>>          if (protocol < 0 || protocol >= CAN_NPROTO)
>> diff --git a/net/can/raw.c b/net/can/raw.c
>> index 5dca1e9e44cf..6052fd0cc7b2 100644
>> --- a/net/can/raw.c
>> +++ b/net/can/raw.c
>> @@ -943,6 +943,9 @@ static __init int raw_module_init(void)
>>          pr_info("can: raw protocol\n");
>>
>>          err = can_proto_register(&raw_can_proto);
>> +       printk("%s: can_proto_register done\n", __func__);
>> +       msleep(5000); // 5s
>> +       printk("%s: to register_netdevice_notifier\n", __func__);
>>          if (err < 0)
>>                  pr_err("can: registration of raw protocol failed\n");
>>          else
>>
>> I added 5 seconds delay after can_proto_register() and some debugs.
>> Testcase codes just try to create a CAN_RAW socket in user space as following:
>>
>> int main(int argc, char **argv)
>> {
>>          int s;
>>
>>          s = socket(PF_CAN, SOCK_RAW, CAN_RAW);
>>          if (s < 0) {
>>                  perror("socket");
>>                  return 0;
>>          }
>>          close(s);
>>          return 0;
>> }
>>
>> Execute 'modprobe can_raw' and the testcase we can get message as following:
>>
>> [  109.312767] can: raw protocol
>> [  109.312772] raw_module_init: can_proto_register done
>> [  111.296178] can_create: protocol: 1
>> [  114.809141] raw_module_init: to register_netdevice_notifier
>>
>> It proved that it can create CAN_RAW socket and process socket once can_proto_register() successfully.
>> CAN_BCM is the same.
> 
> Well, opening a CAN_RAW socket is not a proof that you can delay register_netdevice_notifier() that much.
> 
> After creating the socket you need to set the netdevice and can add some CAN filters and execute bind() on that socket.

Yes，all these socket operations need time, most likely, register_netdevice_notifier() and register_pernet_subsys() had been done.
But it maybe not for some reasons, for example, cpu# that runs {raw,bcm}_module_init() is stuck temporary,
or pernet_ops_rwsem lock competition in register_netdevice_notifier() and register_pernet_subsys().

If the condition which I pointed happens, I think my solution can solve.

> 
> And these filters need to be removed be the netdev notifier when someone plugs out the USB CAN adapter.
> 
>> In the vast majority of cases, creating protocol socket and operating it are after protocol module initialization.
>> The scenario that I pointed in my patch is a low probability.
>>
>> af_packet.c and af_key.c do like that doesn't mean it's very correct. I think so.
> 
> I'm not sure either and this is why I'm asking.
> 
> Maybe having the notifier enabled first does not have a negative effect when removing the USB CAN interface when there is CAN_RAW protocol has been registered.
> 
> But if so, the PF_PACKET code should be revisited too
It is a low probability scenario. Maybe not everyone agrees that it is worth it. But I will try to speak my voice.

Thank you.

> 
> Best regards,
> Oliver
> 
>>
>> Thank you for your prompt reply.
>>
>>>
>>>
>>> On 08.09.22 09:10, Oliver Hartkopp wrote:
>>>>
>>>>
>>>> On 08.09.22 05:04, Ziyang Xuan wrote:
>>>>> Now, register_netdevice_notifier() and register_pernet_subsys() are both
>>>>> after can_proto_register(). It can create CAN_BCM socket and process socket
>>>>> once can_proto_register() successfully, so it is possible missing notifier
>>>>> event or proc node creation because notifier or bcm proc directory is not
>>>>> registered or created yet. Although this is a low probability scenario, it
>>>>> is not impossible.
>>>>>
>>>>> Move register_pernet_subsys() and register_netdevice_notifier() to the
>>>>> front of can_proto_register(). In addition, register_pernet_subsys() and
>>>>> register_netdevice_notifier() may fail, check their results are necessary.
>>>>>
>>>>> Signed-off-by: Ziyang Xuan <william.xuanziyang@huawei.com>
>>>>> ---
>>>>>    net/can/bcm.c | 18 +++++++++++++++---
>>>>>    1 file changed, 15 insertions(+), 3 deletions(-)
>>>>>
>>>>> diff --git a/net/can/bcm.c b/net/can/bcm.c
>>>>> index e60161bec850..e2783156bfd1 100644
>>>>> --- a/net/can/bcm.c
>>>>> +++ b/net/can/bcm.c
>>>>> @@ -1744,15 +1744,27 @@ static int __init bcm_module_init(void)
>>>>>        pr_info("can: broadcast manager protocol\n");
>>>>> +    err = register_pernet_subsys(&canbcm_pernet_ops);
>>>>> +    if (err)
>>>>> +        return err;
>>>>
>>>> Analogue to your patch for the CAN_RAW socket here (which has been applied to can-next right now) ...
>>>>
>>>> https://lore.kernel.org/linux-can/7af9401f0d2d9fed36c1667b5ac9b8df8f8b87ee.1661584485.git.william.xuanziyang@huawei.com/T/#u
>>>>
>>>> ... I'm not sure whether this is the right sequence to acquire the different resources here.
>>>>
>>>> E.g. in ipsec_pfkey_init() in af_key.c
>>>>
>>>> https://elixir.bootlin.com/linux/v5.19.7/source/net/key/af_key.c#L3887
>>>>
>>>> proto_register() is executed before register_pernet_subsys()
>>>>
>>>> Which seems to be more natural to me.
>>>>
>>>> Best regards,
>>>> Oliver
>>>>
>>>>> +
>>>>> +    err = register_netdevice_notifier(&canbcm_notifier);
>>>>> +    if (err)
>>>>> +        goto register_notifier_failed;
>>>>> +
>>>>>        err = can_proto_register(&bcm_can_proto);
>>>>>        if (err < 0) {
>>>>>            printk(KERN_ERR "can: registration of bcm protocol failed\n");
>>>>> -        return err;
>>>>> +        goto register_proto_failed;
>>>>>        }
>>>>> -    register_pernet_subsys(&canbcm_pernet_ops);
>>>>> -    register_netdevice_notifier(&canbcm_notifier);
>>>>>        return 0;
>>>>> +
>>>>> +register_proto_failed:
>>>>> +    unregister_netdevice_notifier(&canbcm_notifier);
>>>>> +register_notifier_failed:
>>>>> +    unregister_pernet_subsys(&canbcm_pernet_ops);
>>>>> +    return err;
>>>>>    }
>>>>>    static void __exit bcm_module_exit(void)
>>> .
> .
