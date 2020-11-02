Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7882C2A2491
	for <lists+netdev@lfdr.de>; Mon,  2 Nov 2020 07:08:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726819AbgKBGIM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Nov 2020 01:08:12 -0500
Received: from m9785.mail.qiye.163.com ([220.181.97.85]:41672 "EHLO
        m9785.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725955AbgKBGIM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Nov 2020 01:08:12 -0500
Received: from [192.168.188.14] (unknown [106.75.220.2])
        by m9785.mail.qiye.163.com (Hmail) with ESMTPA id 697CB5C1ABE;
        Mon,  2 Nov 2020 14:08:05 +0800 (CST)
Subject: Re: [resend] Solution for the problem conntrack in tc subsystem
To:     Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Paul Blakey <paulb@mellanox.com>,
        Oz Shlomo <ozsh@mellanox.com>,
        Davide Caratti <dcaratti@redhat.com>
References: <7821f3ae-0e71-0d8b-5ef9-81da69ac29dc@ucloud.cn>
 <435e4756-f36a-f0f5-0ac5-45bd5cacaff2@ucloud.cn>
 <20201029225936.GM3837@localhost.localdomain>
From:   wenxu <wenxu@ucloud.cn>
Message-ID: <aafb3b96-dc50-8e9d-fdfe-4abb0e5a27f6@ucloud.cn>
Date:   Mon, 2 Nov 2020 14:08:03 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.1
MIME-Version: 1.0
In-Reply-To: <20201029225936.GM3837@localhost.localdomain>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgYFAkeWUFZS1VLWVdZKFlBSUI3V1ktWUFJV1kPCR
        oVCBIfWUFZGkoeSU1JSBhLSB9CVkpNS09JQkxJQ05DQkpVGRETFhoSFyQUDg9ZV1kWGg8SFR0UWU
        FZT0tIVUpKS0hKQ1VLWQY+
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6NBw6SRw4Mz5DQkw3CFE1UREa
        TwwaCxdVSlVKTUtPSUJMSUNNS01NVTMWGhIXVQweFQMOOw4YFxQOH1UYFUVZV1kSC1lBWUpLTVVM
        TlVJSUtVSVlXWQgBWUFJQ0lPNwY+
X-HM-Tid: 0a758791e0db2087kuqy697cb5c1abe
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 10/30/2020 6:59 AM, Marcelo Ricardo Leitner wrote:
> Cc'ing Cong, Paul, Oz and Davide.
>
> On Thu, Oct 29, 2020 at 10:22:04AM +0800, wenxu wrote:
>> Only do gso for the reassembly big packet is also can't fix all the
>> case such for icmp packet.
> Good point. And as we can't know that a fragment was for an icmp
> packet before defraging it, this is quite impactful.
>
>> So there are some proper solution for this problem. In the Internet
>> we can't avoid the fragment packets.
> I agree. One other idea is to add support for some hook to mirred,
> that gets executed before xmiting the packet. Then, when act_ct (or
> another specific act module, say act_frag, as act_ct might not be the
> only one interested in defragging in the future) gets loaded, it
> configs that hook.
>
> So that mirred would something like:
> if (xmit_hook)
> 	xmit_hook(skb, dev_queue_xmit);
> else
> 	dev_queue_xmit(skb);
> Even protect it with a static branch key.
>
Good idea, The act _mirror almost untouched.

The fragment function can be put in a common place for shared

by other modules.

>
>   Marcelo
>
