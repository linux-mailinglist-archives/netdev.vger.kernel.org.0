Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4000F221A4C
	for <lists+netdev@lfdr.de>; Thu, 16 Jul 2020 04:47:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727975AbgGPCqv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jul 2020 22:46:51 -0400
Received: from m9784.mail.qiye.163.com ([220.181.97.84]:39909 "EHLO
        m9784.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727105AbgGPCqv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jul 2020 22:46:51 -0400
Received: from [192.168.188.14] (unknown [106.75.220.2])
        by m9784.mail.qiye.163.com (Hmail) with ESMTPA id 819E941E5C;
        Thu, 16 Jul 2020 10:42:15 +0800 (CST)
Subject: Re: [PATCH net-next v2 0/3] make nf_ct_frag/6_gather elide the skb CB
 clear
To:     Florian Westphal <fw@strlen.de>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org,
        Cong Wang <xiyou.wangcong@gmail.com>
References: <1594097711-9365-1-git-send-email-wenxu@ucloud.cn>
 <20200715132659.34fa0e14@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20200715211714.GR32005@breakpoint.cc>
From:   wenxu <wenxu@ucloud.cn>
Message-ID: <70a49463-03aa-4fa3-c7a0-0391fb84c6c5@ucloud.cn>
Date:   Thu, 16 Jul 2020 10:42:11 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200715211714.GR32005@breakpoint.cc>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgYFAkeWUFZS1VLWVdZKFlBSUI3V1ktWUFJV1kPCR
        oVCBIfWUFZShlDGh9NTRhCHxpOVkpOQk9DTUxISE5DS0pVGRETFhoSFyQUDg9ZV1kWGg8SFR0UWU
        FZT0tIVUpKS0hKTFVKS0tZBg++
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6MDo6EQw*AT4CNzgSPw8TNCIN
        LA8aFAhVSlVKTkJPQ01MSEhOQk5KVTMWGhIXVQweFQMOOw4YFxQOH1UYFUVZV1kSC1lBWUpLTVVM
        TlVJSUtVSVlXWQgBWUFITE5CNwY+
X-HM-Tid: 0a735580421a2086kuqy819e941e5c
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 7/16/2020 5:17 AM, Florian Westphal wrote:
> Jakub Kicinski <kuba@kernel.org> wrote:
>> On Tue,  7 Jul 2020 12:55:08 +0800 wenxu@ucloud.cn wrote:
>>> From: wenxu <wenxu@ucloud.cn>
>>>
>>> Add nf_ct_frag_gather and Make nf_ct_frag6_gather elide the CB clear 
>>> when packets are defragmented by connection tracking. This can make
>>> each subsystem such as br_netfilter, openvswitch, act_ct do defrag
>>> without restore the CB. 
>>> This also avoid serious crashes and problems in  ct subsystem.
>>> Because Some packet schedulers store pointers in the qdisc CB private
>>> area and parallel accesses to the SKB.
>>>
>>> This series following up
>>> http://patchwork.ozlabs.org/project/netdev/patch/1593422178-26949-1-git-send-email-wenxu@ucloud.cn/
>>>
>>> patch1: add nf_ct_frag_gather elide the CB clear
>>> patch2: make nf_ct_frag6_gather elide the CB clear
>>> patch3: fix clobber qdisc_skb_cb in act_ct with defrag
>>>
>>> v2: resue some ip_defrag function in patch1
>> Florian, Cong - are you willing to venture an ack on these? Anyone?
> Nope, sorry.  Reason is that I can't figure out the need for this series.
> Taking a huge step back:
>
> http://patchwork.ozlabs.org/project/netdev/patch/1593422178-26949-1-git-send-email-wenxu@ucloud.cn/
>
> That patch looks ok to me:
> I understand the problem statement/commit message and I can see how its addressed.
>
> I don't understand why the CB clearing must be avoided.
>
> defrag assumes skb ownership -- e.g. it may realloc skb->data
> (calls pskb_may_pull), it calls skb_orphan(), etc.
>
> AFAICS, tcf_classify makes same assumption -- exclusive ownership
> and no parallel skb accesses.
>
> So, if in fact the "only" problem is the loss of
> qdisc_skb_cb(skb)->pkt_len, then the other patch looks ok to me.
>
> If we indeed have parallel access, then I do not understand how
> avoiding the memsets in the defrag path makes things any better
> (see above wrt. skb pull and the like).

Hi David,


What case for the parallel access the skb in tcf_classify?

If there indeed have this. Maybe it can't do defrag which also

access and modify the skb?


BR

wenxu


