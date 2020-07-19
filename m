Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F2068224E85
	for <lists+netdev@lfdr.de>; Sun, 19 Jul 2020 03:31:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726359AbgGSBbl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Jul 2020 21:31:41 -0400
Received: from m9785.mail.qiye.163.com ([220.181.97.85]:19942 "EHLO
        m9785.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726248AbgGSBbk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 18 Jul 2020 21:31:40 -0400
Received: from [192.168.1.8] (unknown [180.157.172.142])
        by m9785.mail.qiye.163.com (Hmail) with ESMTPA id A09AB5C0F3F;
        Sun, 19 Jul 2020 09:31:37 +0800 (CST)
Subject: Re: [PATCH net] net/sched: act_ct: fix restore the qdisc_skb_cb after
 defrag
To:     Florian Westphal <fw@strlen.de>
Cc:     xiyou.wangcong@gmail.com, netdev@vger.kernel.org
References: <1595072073-6268-1-git-send-email-wenxu@ucloud.cn>
 <20200718123006.GW32005@breakpoint.cc>
From:   wenxu <wenxu@ucloud.cn>
Message-ID: <d9649e4c-9e6a-6847-b849-8ca062936441@ucloud.cn>
Date:   Sun, 19 Jul 2020 09:31:36 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200718123006.GW32005@breakpoint.cc>
Content-Type: text/plain; charset=gbk
Content-Transfer-Encoding: 8bit
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgYFAkeWUFZS1VLWVdZKFlBSUI3V1ktWUFJV1kPCR
        oVCBIfWUFZT0tITUpDGBpIGR5NVkpOQk5KSUlJQkxMQkNVGRETFhoSFyQUDg9ZV1kWGg8SFR0UWU
        FZT0tIVUpKS0hKTFVKS0tZBg++
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6OAw6Hyo*Gj5WNz5RODMjVhca
        LREaCwhVSlVKTkJOSklJSUJMQk1PVTMWGhIXVQweFQMOOw4YFxQOH1UYFUVZV1kSC1lBWUpDS1VK
        TkxVSkxJVUpPSVlXWQgBWUFJT0JJNwY+
X-HM-Tid: 0a7364b2ab962087kuqya09ab5c0f3f
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


ÔÚ 2020/7/18 20:30, Florian Westphal Ð´µÀ:
> wenxu@ucloud.cn <wenxu@ucloud.cn> wrote:
>> From: wenxu <wenxu@ucloud.cn>
>>
>> The fragment packets do defrag in tcf_ct_handle_fragments
>> will clear the skb->cb which make the qdisc_skb_cb clear
>> too. So the qdsic_skb_cb should be store before defrag and
>> restore after that.
>> It also update the pkt_len after all the
>> fragments finish the defrag to one packet and make the
>> following actions counter correct.
>>
>> Fixes: b57dc7c13ea9 ("net/sched: Introduce action ct")
>> Signed-off-by: wenxu <wenxu@ucloud.cn>
> Looks ok to me.  One question:
>
>> @@ -1014,6 +1017,7 @@ static int tcf_ct_act(struct sk_buff *skb, const struct tc_action *a,
>>  
>>  out:
>>  	tcf_action_update_bstats(&c->common, skb);
>> +	qdisc_skb_cb(skb)->pkt_len = skb->len;
>>  	return retval;
> This appears to be unconditional, I would have expected that
> this only done for reassembled skbs?
Yes.
>
> Otherwise we will lose the value calculated by core via
> qdisc_calculate_pkt_len().

qdisc_calculate_pkt_len only be cablled in dev_xmit_skb and qdisc_enqueue. If all the fragment will

pass those before defrag, it will caculate correctly. If the reassembled packets pass those, it also caculate correctly after we recaculate the pkt_len of qdisc_skb_cb

