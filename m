Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 825EA2C3461
	for <lists+netdev@lfdr.de>; Wed, 25 Nov 2020 00:12:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732214AbgKXXKq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Nov 2020 18:10:46 -0500
Received: from m9785.mail.qiye.163.com ([220.181.97.85]:54142 "EHLO
        m9785.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729256AbgKXXKq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Nov 2020 18:10:46 -0500
Received: from [192.168.1.8] (unknown [101.86.131.64])
        by m9785.mail.qiye.163.com (Hmail) with ESMTPA id 6C31F5C1172;
        Wed, 25 Nov 2020 07:10:43 +0800 (CST)
Subject: Re: [PATCH v3 net-next 3/3] net/sched: sch_frag: add generic packet
 fragment support.
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     marcelo.leitner@gmail.com, vladbu@nvidia.com, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, netdev@vger.kernel.org
References: <1605829116-10056-1-git-send-email-wenxu@ucloud.cn>
 <1605829116-10056-4-git-send-email-wenxu@ucloud.cn>
 <20201124112430.64143482@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   wenxu <wenxu@ucloud.cn>
Message-ID: <e25b0a93-0fb1-60cf-9451-c82920c45076@ucloud.cn>
Date:   Wed, 25 Nov 2020 07:10:43 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.3
MIME-Version: 1.0
In-Reply-To: <20201124112430.64143482@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgYFAkeWUFZS1VLWVdZKFlBSUI3V1ktWUFJV1kPCR
        oVCBIfWUFZSU1OGk1NSkwaS04eVkpNS01JTkJPT0hCT0NVGRETFhoSFyQUDg9ZV1kWGg8SFR0UWU
        FZT0tIVUpKS0hKTFVLWQY+
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6Oj46Vgw6Az00FDEWMxMsES0R
        ExQKCg5VSlVKTUtNSU5CT09PSkpIVTMWGhIXVQweFQMOOw4YFxQOH1UYFUVZV1kSC1lBWUpLSlVD
        TVVKSEpVTU9ZV1kIAVlBSUxCTDcG
X-HM-Tid: 0a75fc8607f72087kuqy6c31f5c1172
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


在 2020/11/25 3:24, Jakub Kicinski 写道:
> On Fri, 20 Nov 2020 07:38:36 +0800 wenxu@ucloud.cn wrote:
>> +int tcf_dev_queue_xmit(struct sk_buff *skb, int (*xmit)(struct sk_buff *skb))
>> +{
>> +	xmit_hook_func *xmit_hook;
>> +
>> +	xmit_hook = rcu_dereference(tcf_xmit_hook);
>> +	if (xmit_hook)
>> +		return xmit_hook(skb, xmit);
>> +	else
>> +		return xmit(skb);
>> +}
>> +EXPORT_SYMBOL_GPL(tcf_dev_queue_xmit);
> I'm concerned about the performance impact of these indirect calls.
>
> Did you check what code compiler will generate? What the impact with
> retpolines enabled is going to be?
>
> Now that sch_frag is no longer a module this could be simplified.
>
> First of all - xmit_hook can only be sch_frag_xmit_hook, so please use
> that directly. 
>
> 	if (READ_ONCE(tcf_xmit_hook_count)) 
> 		sch_frag_xmit_hook(...
> 	else
> 		dev_queue_xmit(...
>
> The abstraction is costly and not necessary right now IMO.
>
> Then probably the counter should be:
>
> 	u32 __read_mostly tcf_xmit_hook_count;
>
> To avoid byte loads and having it be places in an unlucky cache line.
Maybe a static key replace  tcf_xmit_hook_count is more simplified？

DEFINE_STATIC_KEY_FALSE(tcf_xmit_hook_in_use);

