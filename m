Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 92E2D561E0B
	for <lists+netdev@lfdr.de>; Thu, 30 Jun 2022 16:36:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236277AbiF3OfF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jun 2022 10:35:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232475AbiF3Oeo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Jun 2022 10:34:44 -0400
Received: from out30-133.freemail.mail.aliyun.com (out30-133.freemail.mail.aliyun.com [115.124.30.133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46D3D68A1A;
        Thu, 30 Jun 2022 07:20:45 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R191e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04400;MF=mqaio@linux.alibaba.com;NM=1;PH=DS;RN=10;SR=0;TI=SMTPD_---0VHtYxCo_1656598839;
Received: from 30.13.190.220(mailfrom:mqaio@linux.alibaba.com fp:SMTPD_---0VHtYxCo_1656598839)
          by smtp.aliyun-inc.com;
          Thu, 30 Jun 2022 22:20:41 +0800
Message-ID: <446b9cf0-8f98-b176-0f35-829004746c77@linux.alibaba.com>
Date:   Thu, 30 Jun 2022 22:20:39 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.9.1
Subject: Re: [PATCH] net: hinic: avoid kernel hung in hinic_get_stats64()
To:     Paolo Abeni <pabeni@redhat.com>, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, gustavoars@kernel.org,
        cai.huoqing@linux.dev, aviad.krawczyk@huawei.com,
        zhaochen6@huawei.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <07736c2b7019b6883076a06129e06e8f7c5f7154.1656487154.git.mqaio@linux.alibaba.com>
 <64e59afe33fff04861c800853a549f7979270f79.camel@redhat.com>
From:   maqiao <mqaio@linux.alibaba.com>
In-Reply-To: <64e59afe33fff04861c800853a549f7979270f79.camel@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



在 2022/6/30 下午5:56, Paolo Abeni 写道:
> On Wed, 2022-06-29 at 15:28 +0800, Qiao Ma wrote:
>> When using hinic device as a bond slave device, and reading device stats of
>> master bond device, the kernel may hung.
>>
>> The kernel panic calltrace as follows:
>> Kernel panic - not syncing: softlockup: hung tasks
>> Call trace:
>>    native_queued_spin_lock_slowpath+0x1ec/0x31c
>>    dev_get_stats+0x60/0xcc
>>    dev_seq_printf_stats+0x40/0x120
>>    dev_seq_show+0x1c/0x40
>>    seq_read_iter+0x3c8/0x4dc
>>    seq_read+0xe0/0x130
>>    proc_reg_read+0xa8/0xe0
>>    vfs_read+0xb0/0x1d4
>>    ksys_read+0x70/0xfc
>>    __arm64_sys_read+0x20/0x30
>>    el0_svc_common+0x88/0x234
>>    do_el0_svc+0x2c/0x90
>>    el0_svc+0x1c/0x30
>>    el0_sync_handler+0xa8/0xb0
>>    el0_sync+0x148/0x180
>>
>> And the calltrace of task that actually caused kernel hungs as follows:
>>    __switch_to+124
>>    __schedule+548
>>    schedule+72
>>    schedule_timeout+348
>>    __down_common+188
>>    __down+24
>>    down+104
>>    hinic_get_stats64+44 [hinic]
>>    dev_get_stats+92
>>    bond_get_stats+172 [bonding]
>>    dev_get_stats+92
>>    dev_seq_printf_stats+60
>>    dev_seq_show+24
>>    seq_read_iter+964
>>    seq_read+220
>>    proc_reg_read+164
>>    vfs_read+172
>>    ksys_read+108
>>    __arm64_sys_read+28
>>    el0_svc_common+132
>>    do_el0_svc+40
>>    el0_svc+24
>>    el0_sync_handler+164
>>    el0_sync+324
>>
>> When getting device stats from bond, kernel will call bond_get_stats().
>> It first holds the spinlock bond->stats_lock, and then call
>> hinic_get_stats64() to collect hinic device's stats.
>> However, hinic_get_stats64() calls `down(&nic_dev->mgmt_lock)` to
>> protect its critical section, which may schedule current task out.
>> And if system is under high pressure, the task cannot be woken up
>> immediately, which eventually triggers kernel hung panic.
>>
>> Fixes: edd384f682cc ("net-next/hinic: Add ethtool and stats")
>> Signed-off-by: Qiao Ma <mqaio@linux.alibaba.com>
> 
> Side note: it looks like that after this patch every section protected
> by the mgmt_lock is already under rtnl lock protection, so you could
> probably remove the hinic specific lock (in a separate, net-next,
> patch).
> 
> Please double check the above as I skimmed upon that quickly.
Thank you, I need to carefully check each section will only be called 
through netlink dev_get_stats().

And I forgot to add prefix "net-next" in patch's title, forgive me...
> 
> Thanks,
> 
> Paolo
