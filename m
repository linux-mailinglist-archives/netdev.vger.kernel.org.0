Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CA67D60DB16
	for <lists+netdev@lfdr.de>; Wed, 26 Oct 2022 08:29:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232844AbiJZG0u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Oct 2022 02:26:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231801AbiJZG0t (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Oct 2022 02:26:49 -0400
Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E3DA80E86;
        Tue, 25 Oct 2022 23:26:47 -0700 (PDT)
Received: from dggpeml500026.china.huawei.com (unknown [172.30.72.55])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4MxzH46N9Cz15M6D;
        Wed, 26 Oct 2022 14:21:52 +0800 (CST)
Received: from [10.174.178.66] (10.174.178.66) by
 dggpeml500026.china.huawei.com (7.185.36.106) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Wed, 26 Oct 2022 14:26:44 +0800
Message-ID: <8a7af8f9-23db-35f7-82a5-aaa578c91473@huawei.com>
Date:   Wed, 26 Oct 2022 14:26:44 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.0.2
Subject: Re: [PATCH net,v2] wifi: mac80211: fix general-protection-fault in
 ieee80211_subif_start_xmit()
To:     Ping-Ke Shih <pkshih@realtek.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "johannes@sipsolutions.net" <johannes@sipsolutions.net>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>
CC:     "toke@kernel.org" <toke@kernel.org>,
        "alexander@wetzel-home.de" <alexander@wetzel-home.de>,
        "nbd@nbd.name" <nbd@nbd.name>,
        "weiyongjun1@huawei.com" <weiyongjun1@huawei.com>,
        "yuehaibing@huawei.com" <yuehaibing@huawei.com>
References: <20221026024703.150668-1-shaozhengchao@huawei.com>
 <147c69bcc88f4cb28774bd60346325ff@realtek.com>
From:   shaozhengchao <shaozhengchao@huawei.com>
In-Reply-To: <147c69bcc88f4cb28774bd60346325ff@realtek.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.178.66]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 dggpeml500026.china.huawei.com (7.185.36.106)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2022/10/26 13:46, Ping-Ke Shih wrote:
> 
> 
>> -----Original Message-----
>> From: Zhengchao Shao <shaozhengchao@huawei.com>
>> Sent: Wednesday, October 26, 2022 10:47 AM
>> To: linux-wireless@vger.kernel.org; netdev@vger.kernel.org; johannes@sipsolutions.net;
>> davem@davemloft.net; edumazet@google.com; kuba@kernel.org; pabeni@redhat.com
>> Cc: toke@kernel.org; alexander@wetzel-home.de; nbd@nbd.name; weiyongjun1@huawei.com;
>> yuehaibing@huawei.com; shaozhengchao@huawei.com
>> Subject: [PATCH net,v2] wifi: mac80211: fix general-protection-fault in ieee80211_subif_start_xmit()
>>
>> When device is running and the interface status is changed, the gpf issue
>> is triggered. The problem triggering process is as follows:
>> Thread A:                           Thread B
>> ieee80211_runtime_change_iftype()   process_one_work()
>>      ...                                 ...
>>      ieee80211_do_stop()                 ...
>>      ...                                 ...
>>          sdata->bss = NULL               ...
>>          ...                             ieee80211_subif_start_xmit()
>>                                              ieee80211_multicast_to_unicast
>>                                      //!sdata->bss->multicast_to_unicast
>>                                        cause gpf issue
>>
>> When the interface status is changed, the sending queue continues to send
>> packets. After the bss is set to NULL, the bss is accessed. As a result,
>> this causes a general-protection-fault issue.
>>
>> The following is the stack information:
>> general protection fault, probably for non-canonical address
>> 0xdffffc000000002f: 0000 [#1] PREEMPT SMP KASAN
>> KASAN: null-ptr-deref in range [0x0000000000000178-0x000000000000017f]
>> Workqueue: mld mld_ifc_work
>> RIP: 0010:ieee80211_subif_start_xmit+0x25b/0x1310
>> Call Trace:
>> <TASK>
>> dev_hard_start_xmit+0x1be/0x990
>> __dev_queue_xmit+0x2c9a/0x3b60
>> ip6_finish_output2+0xf92/0x1520
>> ip6_finish_output+0x6af/0x11e0
>> ip6_output+0x1ed/0x540
>> mld_sendpack+0xa09/0xe70
>> mld_ifc_work+0x71c/0xdb0
>> process_one_work+0x9bf/0x1710
>> worker_thread+0x665/0x1080
>> kthread+0x2e4/0x3a0
>> ret_from_fork+0x1f/0x30
>> </TASK>
>>
>> Fixes: f856373e2f31 ("wifi: mac80211: do not wake queues on a vif that is being stopped")
>> Reported-by: syzbot+c6e8fca81c294fd5620a@syzkaller.appspotmail.com
>> Signed-off-by: Zhengchao Shao <shaozhengchao@huawei.com>
>> ---
>>   net/mac80211/tx.c | 5 +++++
>>   1 file changed, 5 insertions(+)
>>
>> diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
>> index a364148149f9..c38485f39d2b 100644
>> --- a/net/mac80211/tx.c
>> +++ b/net/mac80211/tx.c
>> @@ -4418,6 +4418,11 @@ netdev_tx_t ieee80211_subif_start_xmit(struct sk_buff *skb,
>>   	if (likely(!is_multicast_ether_addr(eth->h_dest)))
>>   		goto normal;
>>
>> +	if (unlikely(!ieee80211_sdata_running(sdata))) {
>> +                kfree_skb(skb);
>> +                return NETDEV_TX_OK;
>> +        }
>> +
> 
> The indent looks odd. It seems like you use spaces instead of tabs?
> 
Hi Shih:
	Thank you for your review. I will fix it in V3.

Zhengchao Shao
>>   	if (unlikely(ieee80211_multicast_to_unicast(skb, dev))) {
>>   		struct sk_buff_head queue;
>>
>> --
>> 2.17.1
>>
>>
>> ------Please consider the environment before printing this e-mail.
> 
