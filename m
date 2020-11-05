Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC3102A7C99
	for <lists+netdev@lfdr.de>; Thu,  5 Nov 2020 12:08:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726762AbgKELI3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Nov 2020 06:08:29 -0500
Received: from m9785.mail.qiye.163.com ([220.181.97.85]:25675 "EHLO
        m9785.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726067AbgKELI3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Nov 2020 06:08:29 -0500
Received: from [192.168.188.14] (unknown [106.75.220.2])
        by m9785.mail.qiye.163.com (Hmail) with ESMTPA id 34F305C18FA;
        Thu,  5 Nov 2020 18:44:39 +0800 (CST)
Subject: Re: [PATCH v2 net-next 2/2] net/sched: act_frag: add implict packet
 fragment support.
To:     Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Cc:     kuba@kernel.org, netdev@vger.kernel.org
References: <1604562747-14802-1-git-send-email-wenxu@ucloud.cn>
 <1604562747-14802-2-git-send-email-wenxu@ucloud.cn>
 <20201105081445.GQ3837@localhost.localdomain>
From:   wenxu <wenxu@ucloud.cn>
Message-ID: <b4ef6031-7a8b-a834-790b-781f6c0fb97e@ucloud.cn>
Date:   Thu, 5 Nov 2020 18:44:36 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.1
MIME-Version: 1.0
In-Reply-To: <20201105081445.GQ3837@localhost.localdomain>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgYFAkeWUFZS1VLWVdZKFlBSUI3V1ktWUFJV1kPCR
        oVCBIfWUFZGktCSUhOGExMTENLVkpNS09OTEhLTEJITElVGRETFhoSFyQUDg9ZV1kWGg8SFR0UWU
        FZT0tIVUpKS0hNSlVLWQY+
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6MDI6Qyo5Hj0zCDoILiozMykZ
        DEtPChJVSlVKTUtPTkxIS0xCTkNJVTMWGhIXVQweFQMOOw4YFxQOH1UYFUVZV1kSC1lBWUpLTVVM
        TlVJSUtVSVlXWQgBWUFJTU9INwY+
X-HM-Tid: 0a759802272c2087kuqy34f305c18fa
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 11/5/2020 4:14 PM, Marcelo Ricardo Leitner wrote:
> On Thu, Nov 05, 2020 at 03:52:27PM +0800, wenxu@ucloud.cn wrote:
>
> We cross-posted :)
> I think my comments on the v1 still applies, btw.
>
> ...
>> This patch add support for a xmit hook to mirred, that gets executed before
>> xmiting the packet. Then, when act_ct gets loaded, it configs that hook.
>> The frag xmit hook maybe reused by other modules.
> ...
>> --- a/include/net/act_api.h
>> +++ b/include/net/act_api.h
>> @@ -239,6 +239,29 @@ int tcf_action_check_ctrlact(int action, struct tcf_proto *tp,
>>  			     struct netlink_ext_ack *newchain);
>>  struct tcf_chain *tcf_action_set_ctrlact(struct tc_action *a, int action,
>>  					 struct tcf_chain *newchain);
>> +
>> +#if IS_ENABLED(CONFIG_NET_ACT_FRAG)
>> +int tcf_exec_frag_xmit_hook(struct sk_buff *skb, int (*xmit)(struct sk_buff *skb));
>> +void tcf_set_frag_xmit_hook(void);
>> +void tcf_clear_frag_xmit_hook(void);
>> +bool tcf_frag_xmit_hook_enabled(void);
> Now it's naming the hook after frag action, but it's meant to be
> generic. It got confusing on what is local to act_frag or not due to
> that.

You are right. For more gneric the tcf_xx-xmit_hook should put back to common place and not only used for act_frag.

>
