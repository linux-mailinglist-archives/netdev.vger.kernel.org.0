Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C08004D9287
	for <lists+netdev@lfdr.de>; Tue, 15 Mar 2022 03:22:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344375AbiCOCXK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Mar 2022 22:23:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236325AbiCOCXK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Mar 2022 22:23:10 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0CAEC38D86;
        Mon, 14 Mar 2022 19:21:59 -0700 (PDT)
Received: from canpemm500006.china.huawei.com (unknown [172.30.72.56])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4KHcYm71txz920r;
        Tue, 15 Mar 2022 10:19:56 +0800 (CST)
Received: from [10.174.179.200] (10.174.179.200) by
 canpemm500006.china.huawei.com (7.192.105.130) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Tue, 15 Mar 2022 10:21:56 +0800
Subject: Re: [PATCH net-next 1/3] net: ipvlan: fix potential UAF problem for
 phy_dev
To:     Eric Dumazet <edumazet@google.com>
CC:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>, <sakiwit@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>
References: <cover.1647255926.git.william.xuanziyang@huawei.com>
 <751f88c0846df798a403643cefcaab53922ffe2f.1647255926.git.william.xuanziyang@huawei.com>
 <CANn89iLK9theyFtU+++UQNHc-cn5cTz-Q_CP3BY44WBbfQfS8g@mail.gmail.com>
From:   "Ziyang Xuan (William)" <william.xuanziyang@huawei.com>
Message-ID: <6d02adae-f904-4830-f508-9aa52293c55e@huawei.com>
Date:   Tue, 15 Mar 2022 10:21:56 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <CANn89iLK9theyFtU+++UQNHc-cn5cTz-Q_CP3BY44WBbfQfS8g@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.179.200]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 canpemm500006.china.huawei.com (7.192.105.130)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> On Mon, Mar 14, 2022 at 3:54 AM Ziyang Xuan
> <william.xuanziyang@huawei.com> wrote:
>>
>> Add the reference operation to phy_dev of ipvlan to avoid
>> the potential UAF problem under the following known scenario:
>>
>> Someone module puts the NETDEV_UNREGISTER event handler to a
>> work, and phy_dev is accessed in the work handler. But when
>> the work is excuted, phy_dev has been destroyed because upper
>> ipvlan did not get reference to phy_dev correctly.
> 
> Can you name the module deferring NETDEV_UNREGISTER to a work queue ?

The one I know is nb_netdevice netdevice notifier of roce_gid_mgmt.
It will trigger vlan's real_dev UAF. It is a syzbot problem.
See details:
https://syzkaller.appspot.com/bug?extid=e4df4e1389e28972e955

> 
> This sounds like a bug to me.
> 
>>
>> That likes as the scenario occurred by
>> commit 563bcbae3ba2 ("net: vlan: fix a UAF in vlan_dev_real_dev()").
> 
> Mentioning a commit that added a bug and many other commits trying to
> fix it is a bit unfortunate.

Yes, I am sorry for that. I will keep improving the quality of my code.

The related problems have solved by the series patches of
commit faab39f63c1f ("net: allow out-of-order netdev unregistration").
So I think it is the right time to fix other modules' potential problem.

> 
> Can you instead add a Fixes: tag ?

The potential problem exists since macvlan and ipvlan were added.

> 
> Do you have a repro to trigger the bug ?

For macvlan and ipvlan, there are not repros now. I think it is necessary
to give a right logic to cope with the constant evolution of the kernel.

> 
>>
>> Signed-off-by: Ziyang Xuan <william.xuanziyang@huawei.com>
>> ---
>>  drivers/net/ipvlan/ipvlan_main.c | 13 +++++++++++++
>>  1 file changed, 13 insertions(+)
>>
>> diff --git a/drivers/net/ipvlan/ipvlan_main.c b/drivers/net/ipvlan/ipvlan_main.c
>> index 696e245f6d00..dcdc01403f22 100644
>> --- a/drivers/net/ipvlan/ipvlan_main.c
>> +++ b/drivers/net/ipvlan/ipvlan_main.c
>> @@ -158,6 +158,10 @@ static int ipvlan_init(struct net_device *dev)
>>         }
>>         port = ipvlan_port_get_rtnl(phy_dev);
>>         port->count += 1;
>> +
>> +       /* Get ipvlan's reference to phy_dev */
>> +       dev_hold(phy_dev);
>> +
>>         return 0;
>>  }
>>
>> @@ -665,6 +669,14 @@ void ipvlan_link_delete(struct net_device *dev, struct list_head *head)
>>  }
>>  EXPORT_SYMBOL_GPL(ipvlan_link_delete);
>>
>> +static void ipvlan_dev_free(struct net_device *dev)
>> +{
>> +       struct ipvl_dev *ipvlan = netdev_priv(dev);
>> +
>> +       /* Get rid of the ipvlan's reference to phy_dev */
>> +       dev_put(ipvlan->phy_dev);
>> +}
>> +
>>  void ipvlan_link_setup(struct net_device *dev)
>>  {
>>         ether_setup(dev);
>> @@ -674,6 +686,7 @@ void ipvlan_link_setup(struct net_device *dev)
>>         dev->priv_flags |= IFF_UNICAST_FLT | IFF_NO_QUEUE;
>>         dev->netdev_ops = &ipvlan_netdev_ops;
>>         dev->needs_free_netdev = true;
>> +       dev->priv_destructor = ipvlan_dev_free;
>>         dev->header_ops = &ipvlan_header_ops;
>>         dev->ethtool_ops = &ipvlan_ethtool_ops;
>>  }
>> --
>> 2.25.1
>>
> .
> 
