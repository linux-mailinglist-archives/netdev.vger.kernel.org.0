Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DE0315B818E
	for <lists+netdev@lfdr.de>; Wed, 14 Sep 2022 08:42:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229991AbiINGmo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Sep 2022 02:42:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229528AbiINGmn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Sep 2022 02:42:43 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE9C425EB8;
        Tue, 13 Sep 2022 23:42:41 -0700 (PDT)
Received: from canpemm500006.china.huawei.com (unknown [172.30.72.53])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4MS9f70n03zmV94;
        Wed, 14 Sep 2022 14:38:55 +0800 (CST)
Received: from [10.174.179.200] (10.174.179.200) by
 canpemm500006.china.huawei.com (7.192.105.130) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Wed, 14 Sep 2022 14:42:39 +0800
Subject: Re: [PATCH 1/2] can: bcm: registration process optimization in
 bcm_module_init()
To:     Oliver Hartkopp <socketcan@hartkopp.net>,
        Marc Kleine-Budde <mkl@pengutronix.de>
CC:     <edumazet@google.com>, <kuba@kernel.org>,
        <linux-can@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
References: <cover.1662606045.git.william.xuanziyang@huawei.com>
 <823cff0ebec33fa9389eeaf8b8ded3217c32cb38.1662606045.git.william.xuanziyang@huawei.com>
 <381dd961-f786-2400-0977-9639c3f7006e@hartkopp.net>
 <c480bdd7-e35e-fbf9-6767-801e04703780@hartkopp.net>
 <7b063d38-311c-76d6-4e31-02f9cccc9bcb@huawei.com>
 <053c7de3-c76c-82fd-2d44-2e7c1673ae98@hartkopp.net>
 <9228b20a-3baa-32ad-6059-5cf0ffdb97a3@huawei.com>
 <d392c1f4-7ad3-59a4-1358-2c216c498402@hartkopp.net>
 <20220912120020.dlxuryltw4sii635@pengutronix.de>
 <4791cc31-db17-7720-4a86-f83e7bf0918d@hartkopp.net>
From:   "Ziyang Xuan (William)" <william.xuanziyang@huawei.com>
Message-ID: <dbf68897-c719-db79-b856-792bf8fbf533@huawei.com>
Date:   Wed, 14 Sep 2022 14:42:39 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <4791cc31-db17-7720-4a86-f83e7bf0918d@hartkopp.net>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.179.200]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 canpemm500006.china.huawei.com (7.192.105.130)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> 
> 
> On 12.09.22 14:00, Marc Kleine-Budde wrote:
>> On 09.09.2022 17:04:06, Oliver Hartkopp wrote:
>>>
>>>
>>> On 09.09.22 05:58, Ziyang Xuan (William) wrote:
>>>>>
>>>>>
>>>>> On 9/8/22 13:14, Ziyang Xuan (William) wrote:
>>>>>>> Just another reference which make it clear that the reordering of function calls in your patch is likely not correct:
>>>>>>>
>>>>>>> https://elixir.bootlin.com/linux/v5.19.7/source/net/packet/af_packet.c#L4734
>>>>>>>
>>>>>>> static int __init packet_init(void)
>>>>>>> {
>>>>>>>            int rc;
>>>>>>>
>>>>>>>            rc = proto_register(&packet_proto, 0);
>>>>>>>            if (rc)
>>>>>>>                    goto out;
>>>>>>>            rc = sock_register(&packet_family_ops);
>>>>>>>            if (rc)
>>>>>>>                    goto out_proto;
>>>>>>>            rc = register_pernet_subsys(&packet_net_ops);
>>>>>>>            if (rc)
>>>>>>>                    goto out_sock;
>>>>>>>            rc = register_netdevice_notifier(&packet_netdev_notifier);
>>>>>>>            if (rc)
>>>>>>>                    goto out_pernet;
>>>>>>>
>>>>>>>            return 0;
>>>>>>>
>>>>>>> out_pernet:
>>>>>>>            unregister_pernet_subsys(&packet_net_ops);
>>>>>>> out_sock:
>>>>>>>            sock_unregister(PF_PACKET);
>>>>>>> out_proto:
>>>>>>>            proto_unregister(&packet_proto);
>>>>>>> out:
>>>>>>>            return rc;
>>>>>>> }
>>>>>>>
>>>
>>>> Yes，all these socket operations need time, most likely, register_netdevice_notifier() and register_pernet_subsys() had been done.
>>>> But it maybe not for some reasons, for example, cpu# that runs {raw,bcm}_module_init() is stuck temporary,
>>>> or pernet_ops_rwsem lock competition in register_netdevice_notifier() and register_pernet_subsys().
>>>>
>>>> If the condition which I pointed happens, I think my solution can solve.
>>>>
>>>
>>> No, I don't think so.
>>>
>>> We need to maintain the exact order which is depicted in the af_packet.c
>>> code from above as the notifier call references the sock pointer.
>>
>> The notifier calls bcm_notifier() first, which will loop over the
>> bcm_notifier_list. The list is empty if there are no sockets open, yet.
>> So from my point of view this change looks fine.
>>
>> IMHO it's better to make a series where all these notifiers are moved in
>> front of the respective socket proto_register().
> 
> Notifiers and/or pernet_subsys ?
> 
> But yes, that would be better to have a clean consistent sequence in all these cases.
> 
> Would this affect af_packet.c then too?
Yes.

When we create a sock by packet_create() after proto_register() and sock_register().
It will use net->packet.sklist_lock and net->packet.sklist directly in packet_create().
net->packet.sklist_lock and net->packet.sklist are initialized in packet_net_init().

The code snippet is as follows:

static int packet_create(struct net *net, struct socket *sock, int protocol,
			 int kern)
{
	...
	mutex_lock(&net->packet.sklist_lock);
	sk_add_node_tail_rcu(sk, &net->packet.sklist);
	mutex_unlock(&net->packet.sklist_lock);
	...
}


static int __net_init packet_net_init(struct net *net)
{
	mutex_init(&net->packet.sklist_lock);
	INIT_HLIST_HEAD(&net->packet.sklist);
	...
}

So, if the sock is created firstly, we will get illegal access bug.

> 
> Regards,
> Oliver
> 
> .
