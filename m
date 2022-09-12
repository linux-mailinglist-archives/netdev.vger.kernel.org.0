Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1E2395B5CC2
	for <lists+netdev@lfdr.de>; Mon, 12 Sep 2022 16:55:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230267AbiILOzF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Sep 2022 10:55:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230301AbiILOzB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Sep 2022 10:55:01 -0400
Received: from mo4-p01-ob.smtp.rzone.de (mo4-p01-ob.smtp.rzone.de [85.215.255.50])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 310946277;
        Mon, 12 Sep 2022 07:54:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1662994494;
    s=strato-dkim-0002; d=hartkopp.net;
    h=In-Reply-To:From:References:Cc:To:Subject:Date:Message-ID:Cc:Date:
    From:Subject:Sender;
    bh=zI8dQLr+hgubSc2Md+BLeXBqKRPJrR0RfZFn/VtvoiY=;
    b=pug4P711jbukSxRjD5Fs3Nqpp2V3i+itICXRJvCm73SfX5ct9w2UnzwLz5QdmE77WW
    b3k3oriaOxVhdNX5Wr44HBZLm8CdocOwAOJ+9Djle2Qqq45UgZlzUHC/9UamwNZhpR6A
    hSg7z5vFU5IqjtvKl770MFli+caHVE26JPHCYfsm7WvTop+RLQN/a/bIUsnQathlBDP7
    5gUv2toCpAg5sj+7dEaKy+HVFYn8FICwKkYND/hxrcRSUoIGKynPNuWF+Tx1gCz47Jn0
    V+RvoDGZjKrdNRZEKm/I1+SaqWo1pIvKYFF+EfG4loVaFa5KopyiOeYEjbe6yPM3ah+B
    4Fug==
Authentication-Results: strato.com;
    dkim=none
X-RZG-AUTH: ":P2MHfkW8eP4Mre39l357AZT/I7AY/7nT2yrDxb8mjG14FZxedJy6qgO1qCHSa1GLptZHusx3hdIrpKytJSr6hfz3Vg=="
X-RZG-CLASS-ID: mo00
Received: from [IPV6:2a00:6020:1cfd:d100::923]
    by smtp.strato.de (RZmta 48.1.0 AUTH)
    with ESMTPSA id d25a93y8CEsr18D
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
    Mon, 12 Sep 2022 16:54:53 +0200 (CEST)
Message-ID: <4791cc31-db17-7720-4a86-f83e7bf0918d@hartkopp.net>
Date:   Mon, 12 Sep 2022 16:54:48 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.0
Subject: Re: [PATCH 1/2] can: bcm: registration process optimization in
 bcm_module_init()
Content-Language: en-US
To:     Marc Kleine-Budde <mkl@pengutronix.de>
Cc:     "Ziyang Xuan (William)" <william.xuanziyang@huawei.com>,
        edumazet@google.com, kuba@kernel.org, linux-can@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <cover.1662606045.git.william.xuanziyang@huawei.com>
 <823cff0ebec33fa9389eeaf8b8ded3217c32cb38.1662606045.git.william.xuanziyang@huawei.com>
 <381dd961-f786-2400-0977-9639c3f7006e@hartkopp.net>
 <c480bdd7-e35e-fbf9-6767-801e04703780@hartkopp.net>
 <7b063d38-311c-76d6-4e31-02f9cccc9bcb@huawei.com>
 <053c7de3-c76c-82fd-2d44-2e7c1673ae98@hartkopp.net>
 <9228b20a-3baa-32ad-6059-5cf0ffdb97a3@huawei.com>
 <d392c1f4-7ad3-59a4-1358-2c216c498402@hartkopp.net>
 <20220912120020.dlxuryltw4sii635@pengutronix.de>
From:   Oliver Hartkopp <socketcan@hartkopp.net>
In-Reply-To: <20220912120020.dlxuryltw4sii635@pengutronix.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 12.09.22 14:00, Marc Kleine-Budde wrote:
> On 09.09.2022 17:04:06, Oliver Hartkopp wrote:
>>
>>
>> On 09.09.22 05:58, Ziyang Xuan (William) wrote:
>>>>
>>>>
>>>> On 9/8/22 13:14, Ziyang Xuan (William) wrote:
>>>>>> Just another reference which make it clear that the reordering of function calls in your patch is likely not correct:
>>>>>>
>>>>>> https://elixir.bootlin.com/linux/v5.19.7/source/net/packet/af_packet.c#L4734
>>>>>>
>>>>>> static int __init packet_init(void)
>>>>>> {
>>>>>>            int rc;
>>>>>>
>>>>>>            rc = proto_register(&packet_proto, 0);
>>>>>>            if (rc)
>>>>>>                    goto out;
>>>>>>            rc = sock_register(&packet_family_ops);
>>>>>>            if (rc)
>>>>>>                    goto out_proto;
>>>>>>            rc = register_pernet_subsys(&packet_net_ops);
>>>>>>            if (rc)
>>>>>>                    goto out_sock;
>>>>>>            rc = register_netdevice_notifier(&packet_netdev_notifier);
>>>>>>            if (rc)
>>>>>>                    goto out_pernet;
>>>>>>
>>>>>>            return 0;
>>>>>>
>>>>>> out_pernet:
>>>>>>            unregister_pernet_subsys(&packet_net_ops);
>>>>>> out_sock:
>>>>>>            sock_unregister(PF_PACKET);
>>>>>> out_proto:
>>>>>>            proto_unregister(&packet_proto);
>>>>>> out:
>>>>>>            return rc;
>>>>>> }
>>>>>>
>>
>>> Yes，all these socket operations need time, most likely, register_netdevice_notifier() and register_pernet_subsys() had been done.
>>> But it maybe not for some reasons, for example, cpu# that runs {raw,bcm}_module_init() is stuck temporary,
>>> or pernet_ops_rwsem lock competition in register_netdevice_notifier() and register_pernet_subsys().
>>>
>>> If the condition which I pointed happens, I think my solution can solve.
>>>
>>
>> No, I don't think so.
>>
>> We need to maintain the exact order which is depicted in the af_packet.c
>> code from above as the notifier call references the sock pointer.
> 
> The notifier calls bcm_notifier() first, which will loop over the
> bcm_notifier_list. The list is empty if there are no sockets open, yet.
> So from my point of view this change looks fine.
> 
> IMHO it's better to make a series where all these notifiers are moved in
> front of the respective socket proto_register().

Notifiers and/or pernet_subsys ?

But yes, that would be better to have a clean consistent sequence in all 
these cases.

Would this affect af_packet.c then too?

Regards,
Oliver

