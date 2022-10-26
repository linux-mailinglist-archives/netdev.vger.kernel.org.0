Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 938E760D8A6
	for <lists+netdev@lfdr.de>; Wed, 26 Oct 2022 02:58:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232038AbiJZA6N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Oct 2022 20:58:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231861AbiJZA6K (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Oct 2022 20:58:10 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41BEAB8C25;
        Tue, 25 Oct 2022 17:58:09 -0700 (PDT)
Received: from dggpeml500026.china.huawei.com (unknown [172.30.72.56])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4Mxr003hHZzVjBQ;
        Wed, 26 Oct 2022 08:53:20 +0800 (CST)
Received: from [10.174.178.66] (10.174.178.66) by
 dggpeml500026.china.huawei.com (7.185.36.106) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Wed, 26 Oct 2022 08:58:06 +0800
Message-ID: <91f72e36-794e-016f-32c4-2df6653e00bc@huawei.com>
Date:   Wed, 26 Oct 2022 08:58:06 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.0.2
Subject: Re: [PATCH] wifi: mac80211: fix general-protection-fault in
 ieee80211_subif_start_xmit()
To:     Alexander Wetzel <alexander@wetzel-home.de>,
        <linux-wireless@vger.kernel.org>, <netdev@vger.kernel.org>,
        <johannes@sipsolutions.net>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>
CC:     <weiyongjun1@huawei.com>, <yuehaibing@huawei.com>
References: <20221025123250.143952-1-shaozhengchao@huawei.com>
 <a54581e8-792a-0f54-e886-bca3d1d1063e@wetzel-home.de>
From:   shaozhengchao <shaozhengchao@huawei.com>
In-Reply-To: <a54581e8-792a-0f54-e886-bca3d1d1063e@wetzel-home.de>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.178.66]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
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



On 2022/10/25 22:42, Alexander Wetzel wrote:
> On 25.10.22 14:32, Zhengchao Shao wrote:
>> When device is running and the interface status is changed, the gpf issue
>> is triggered. The problem triggering process is as follows:
>> Thread A:                           Thread B
>> ieee80211_runtime_change_iftype()   process_one_work()
>>      ...                                 ...
>>      ieee80211_do_stop()                 ...
>>      ...                                 ...
>>          sdata->bss = NULL               ...
>>          ...                             ieee80211_subif_start_xmit()
>>                                              
>> ieee80211_multicast_to_unicast
>>                                      //!sdata->bss->multicast_to_unicast
>>                                        cause gpf issue
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
>> Fixes: 107395f9cf44 ("wifi: mac80211: Drop support for TX push path")
> 
> Don't think this patch fixes an issue introduced with the patch you 
> refer to. This patch changed nothing from a flow perspective and is just 
> cleaning up unused code.
> It still may still make sense to refer to the series: It next to be sure 
> triggered the issue for at least one driver (I assume it was hwsim here.)
> 
> That said this seems to be more related to whatever caused this bug:
> f856373e2f31 ("wifi: mac80211: do not wake queues on a vif that is being 
> stopped")
> 
> 
>> Reported-by: syzbot+c6e8fca81c294fd5620a@syzkaller.appspotmail.com
>> Signed-off-by: Zhengchao Shao <shaozhengchao@huawei.com>
>> ---
>>   net/mac80211/iface.c | 6 ++++++
>>   1 file changed, 6 insertions(+)
>>
>> diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
>> index dd9ac1f7d2ea..5a924459bfd1 100644
>> --- a/net/mac80211/iface.c
>> +++ b/net/mac80211/iface.c
>> @@ -1900,6 +1900,9 @@ static int 
>> ieee80211_runtime_change_iftype(struct ieee80211_sub_if_data *sdata,
>>                     IEEE80211_QUEUE_STOP_REASON_IFTYPE_CHANGE);
>>       synchronize_net();
>> +    if (sdata->dev)
>> +        netif_tx_stop_all_queues(sdata->dev);
> 
> All mac80211 interfaces are now non-queuing interfaces.
> When you stop the netif queues for a non-queuing interface netdev will 
> warn about that.
> 
> To avoid that you have to replace the netif call with
>      clear_bit(SDATA_STATE_RUNNING, &sdata->state);
> 
> Should just work the same for you here.
>> +
>>       ieee80211_do_stop(sdata, false);
>>       ieee80211_teardown_sdata(sdata);
>> @@ -1922,6 +1925,9 @@ static int 
>> ieee80211_runtime_change_iftype(struct ieee80211_sub_if_data *sdata,
>>       err = ieee80211_do_open(&sdata->wdev, false);
>>       WARN(err, "type change: do_open returned %d", err);
>> +    if (sdata->dev)
>> +        netif_tx_start_all_queues(sdata->dev);
> 
> That must then be of course
>      set_bit(SDATA_STATE_RUNNING, &sdata->state);
> 
> 
>> +
>>       ieee80211_wake_vif_queues(local, sdata,
>>                     IEEE80211_QUEUE_STOP_REASON_IFTYPE_CHANGE);
>>       return ret;
> 
> Alexander
Hi Alexander:
	Thank you for your review. I will fix them in V2.

Zhengchao Shao
