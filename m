Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5CBDB253C2B
	for <lists+netdev@lfdr.de>; Thu, 27 Aug 2020 05:39:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726834AbgH0Diz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Aug 2020 23:38:55 -0400
Received: from m9785.mail.qiye.163.com ([220.181.97.85]:23477 "EHLO
        m9785.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726790AbgH0Diz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Aug 2020 23:38:55 -0400
X-Greylist: delayed 459 seconds by postgrey-1.27 at vger.kernel.org; Wed, 26 Aug 2020 23:38:51 EDT
Received: from [192.168.188.14] (unknown [106.75.220.2])
        by m9785.mail.qiye.163.com (Hmail) with ESMTPA id 0DB105C18B3;
        Thu, 27 Aug 2020 11:31:04 +0800 (CST)
Subject: Re: [PATCH net-next] net/sched: add act_ct_output support
To:     Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, Cong Wang <xiyou.wangcong@gmail.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Paul Blakey <paulb@mellanox.com>, Oz Shlomo <ozsh@mellanox.com>
References: <1598335663-26503-1-git-send-email-wenxu@ucloud.cn>
 <20200825153318.GA2444@localhost.localdomain>
From:   wenxu <wenxu@ucloud.cn>
Message-ID: <347b446d-ec80-9b8a-6678-86a6c3eddf6a@ucloud.cn>
Date:   Thu, 27 Aug 2020 11:30:54 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <20200825153318.GA2444@localhost.localdomain>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgYFAkeWUFZS1VLWVdZKFlBSUI3V1ktWUFJV1kPCR
        oVCBIfWUFZGBgfSBhLH0tDSx1NVkpOQkNPQkJLTU9PQkhVGRETFhoSFyQUDg9ZV1kWGg8SFR0UWU
        FZT0tIVUpKS0hKQ1VKS0tZBg++
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6Phg6NDo4Ij5IARocNTY8TzEV
        EQ8KCTxVSlVKTkJDT0JCS01PTU5DVTMWGhIXVQweFQMOOw4YFxQOH1UYFUVZV1kSC1lBWUpLTVVM
        TlVJSUtVSVlXWQgBWUFIQ0tJNwY+
X-HM-Tid: 0a742df80a582087kuqy0db105c18b3
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 8/25/2020 11:33 PM, Marcelo Ricardo Leitner wrote:
> On Tue, Aug 25, 2020 at 02:07:43PM +0800, wenxu@ucloud.cn wrote:
> ...
>> +static LIST_HEAD(ct_output_list);
>> +static DEFINE_SPINLOCK(ct_output_list_lock);
>> +
>> +#define CT_OUTPUT_RECURSION_LIMIT    4
>> +static DEFINE_PER_CPU(unsigned int, ct_output_rec_level);
> Wenxu, first of all, thanks for doing this.
>
> Hopefully this helps to show how much duplicated code this means.
> Later on, any bug that we find on mirrer, we also need to fix in
> act_ct_output, which is not good.
>
> Currently act_ct is the only one doing defrag and leading to this
> need, but that may change in the future. The action here, AFAICT, has
> nothing in specific to conntrack.  It is "just" re-fragmenting
> packets. The only specific reference to nf/ct I could notice is for
> the v6ops, to have access to ip6_fragment(), which can also be done
> via struct ipv6_stub (once added there). That said, it shouldn't be
> named after conntrack, to avoid future confusions.

Yes, there is no direct relation with conntrack.
The re-fragmenting based on the qdisc_skb_cb(skb)->mru which only setting
in the act_ct. So I named this to ct_xx.

>
> I still don't understand Cong's argument for not having this on
> act_mirred because TC is L2. That's actually not right. TC hooks at L2
> but deals with L3 and L4 (after all, it does static NAT, mungles L4
> headers and classifies based on virtually anything) since beginning,
> and this is just another case.
>
> What I can understand, is that this feature shouldn't be enabled by
> default on mirred. So that we are sure that users opting-in know what
> they are doing. It can have a "l3" flag, to enable L3 semantics, and
> that's it. Code re-used, no performance drawback for pure L2 users (it
> can even be protected by a static_key. Once a l3-enabled mirred is
> loaded, enable it), user knows what to expect and no confusion on
> which action to use.

I think it is better put this feature to act_mirred. And it also not enable by default.

Only packet with qdisc_skb_cb(skb)->mru which means this packet just do reassemble

before conntrack.

So only othersolution for solving this problem?


BR

wenxu

>
>   Marcelo
>
