Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 884FD4BE1FB
	for <lists+netdev@lfdr.de>; Mon, 21 Feb 2022 18:53:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358190AbiBUMmM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Feb 2022 07:42:12 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:34442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358199AbiBUMmG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Feb 2022 07:42:06 -0500
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E639010BF
        for <netdev@vger.kernel.org>; Mon, 21 Feb 2022 04:41:38 -0800 (PST)
Received: from canpemm500006.china.huawei.com (unknown [172.30.72.57])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4K2MMG1nJVz9ssP;
        Mon, 21 Feb 2022 20:39:54 +0800 (CST)
Received: from [10.174.179.200] (10.174.179.200) by
 canpemm500006.china.huawei.com (7.192.105.130) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Mon, 21 Feb 2022 20:41:35 +0800
Subject: Re: Why vlan_dev can not follow real_dev mtu change from smaller to
 bigger
To:     David Ahern <dsahern@kernel.org>, <netdev@vger.kernel.org>
CC:     <davem@davemloft.net>, Jakub Kicinski <kuba@kernel.org>,
        <pablo@netfilter.org>, <keescook@chromium.org>, <alobakin@pm.me>,
        <nbd@nbd.name>, <herbert@gondor.apana.org.au>
References: <6ffd8030-28ff-396b-5f94-a2e9fd8ef9fd@huawei.com>
 <47003762-f5bc-6677-9fa1-8a3d6bc51ab3@huawei.com>
 <9095c706-01f1-5b81-658a-a4288a864a0a@kernel.org>
From:   "Ziyang Xuan (William)" <william.xuanziyang@huawei.com>
Message-ID: <b5a52e45-62fe-abc9-f7ec-428d5364b3c3@huawei.com>
Date:   Mon, 21 Feb 2022 20:41:34 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <9095c706-01f1-5b81-658a-a4288a864a0a@kernel.org>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.179.200]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
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

> On 2/16/22 11:44 PM, Ziyang Xuan (William) wrote:
>>> Hello,
>>>
>>> Recently, I did some tests about mtu change for vlan device
>>> and real_dev. I found that vlan_dev's mtu could not follow its
>>> real_dev's mtu change from smaller to bigger.
>>>
>>> For example:
>>> Firstly, change real_dev's mtu from 1500 to 256, vlan_dev's mtu
>>> follow change from 1500 to 256.
>>> Secondly, change real_dev's mtu from 256 to 1500, but vlan_dev's
>>> mtu is still 256.
>>>
>>> I fond the code as following. But I could not understand the
>>> limitations. Is there anyone can help me?
>>>
>>> static int vlan_device_event(struct notifier_block *unused, unsigned long event,
>>> 			     void *ptr)
>>> {
>>> 	...
>>>
>>> 	case NETDEV_CHANGEMTU:
>>> 		vlan_group_for_each_dev(grp, i, vlandev) {
>>> 			if (vlandev->mtu <= dev->mtu)
>>> 				continue;
>>>
>>> 			dev_set_mtu(vlandev, dev->mtu);
>>> 		}
>>> 		break;
>>> 	...
>>> }
>>>
>>> Thank you for your reply.
>>>
>> commit: 2e477c9bd2bb ("vlan: Propagate physical MTU changes") wanted
>> to ensure that all existing VLAN device MTUs do not exceed the new
>> underlying MTU. Make VLAN device MTUs equal to the new underlying MTU
>> follow this rule. So I think the following modification is reasonable
>> and can solve the above problem.
>>
>> @@ -418,12 +418,8 @@ static int vlan_device_event(struct notifier_block *unused, unsigned long event,
>>                 break;
>>
>>         case NETDEV_CHANGEMTU:
>> -               vlan_group_for_each_dev(grp, i, vlandev) {
>> -                       if (vlandev->mtu <= dev->mtu)
>> -                               continue;
>> -
>> +               vlan_group_for_each_dev(grp, i, vlandev)
>>                         dev_set_mtu(vlandev, dev->mtu);
>> -               }
>>                 break;
>>
> 
> vlans must work within the mtu of the underlying device, so shrinking
> the mtu of the vlan device when the real device changes is appropriate.
> 
> vlan devices do not necessarily have to operate at the same mtu as the
> real device, so when the real device mtu is increased it might not be
> appropriate to raise the mtu of the vlan devices. Admin needs to manage
> that.
> .

I have submitted a patch for the problem.

https://patchwork.kernel.org/project/netdevbpf/patch/20220221124644.1146105-1-william.xuanziyang@huawei.com/

Allow vlan device follow real device MTU change from smaller to bigger
when user has not configured vlan device MTU. That also ensure user
configuration has higher priority.

Welcome to review.
