Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 700BF2B77F8
	for <lists+netdev@lfdr.de>; Wed, 18 Nov 2020 09:07:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726296AbgKRIEu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Nov 2020 03:04:50 -0500
Received: from m9785.mail.qiye.163.com ([220.181.97.85]:19598 "EHLO
        m9785.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726158AbgKRIEt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Nov 2020 03:04:49 -0500
Received: from [192.168.1.8] (unknown [116.234.4.84])
        by m9785.mail.qiye.163.com (Hmail) with ESMTPA id 322CC5C1A31;
        Wed, 18 Nov 2020 16:04:46 +0800 (CST)
Subject: Re: [PATCH v2 net-next 3/3] net/sched: sch_frag: add generic packet
 fragment support.
To:     Cong Wang <xiyou.wangcong@gmail.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Vlad Buslov <vladbu@nvidia.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>
References: <1605663468-14275-1-git-send-email-wenxu@ucloud.cn>
 <CAM_iQpVoFrZ9gFNFUsqtt=12OS_Cs+vpokgNCB0eQiBf=hD4dA@mail.gmail.com>
From:   wenxu <wenxu@ucloud.cn>
Message-ID: <bf2b3221-2325-c913-be30-2db543e6e1e1@ucloud.cn>
Date:   Wed, 18 Nov 2020 16:04:45 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.1
MIME-Version: 1.0
In-Reply-To: <CAM_iQpVoFrZ9gFNFUsqtt=12OS_Cs+vpokgNCB0eQiBf=hD4dA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgYFAkeWUFZS1VLWVdZKFlBSUI3V1ktWUFJV1kPCR
        oVCBIfWUFZSRpMTx1JGh9NHRpOVkpNS05NQ01NQ01PTk5VGRETFhoSFyQUDg9ZV1kWGg8SFR0UWU
        FZT0tIVUpKS0hKTFVLWQY+
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6PRA6Hgw5PD06STxREzBOVjgp
        SUoaCg9VSlVKTUtOTUNNTUNNTUhKVTMWGhIXVQweFQMOOw4YFxQOH1UYFUVZV1kSC1lBWUpKTVVJ
        SE9VT1VDT1lXWQgBWUFJQk5DNwY+
X-HM-Tid: 0a75da6272c82087kuqy322cc5c1a31
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


在 2020/11/18 15:00, Cong Wang 写道:
> On Tue, Nov 17, 2020 at 5:37 PM <wenxu@ucloud.cn> wrote:
>> From: wenxu <wenxu@ucloud.cn>
>>
>> Currently kernel tc subsystem can do conntrack in cat_ct. But when several
>> fragment packets go through the act_ct, function tcf_ct_handle_fragments
>> will defrag the packets to a big one. But the last action will redirect
>> mirred to a device which maybe lead the reassembly big packet over the mtu
>> of target device.
>>
>> This patch add support for a xmit hook to mirred, that gets executed before
>> xmiting the packet. Then, when act_ct gets loaded, it configs that hook.
>> The frag xmit hook maybe reused by other modules.
>>
>> Signed-off-by: wenxu <wenxu@ucloud.cn>
>> ---
>> v2: make act_frag just buildin for tc core but not a module
>>     return an error code from tcf_fragment
>>     depends on INET for ip_do_fragment
> Much better now.
>
>
>> +#ifdef CONFIG_INET
>> +               ret = ip_do_fragment(net, skb->sk, skb, sch_frag_xmit);
>> +#endif
>
> Doesn't the whole sch_frag need to be put under CONFIG_INET?
> I don't think fragmentation could work without CONFIG_INET.

I have already test with this. Without CONFIG_INET it is work.

And only the ip_do_fragment depends on CONFIG_INET

>
> Thanks.
>
