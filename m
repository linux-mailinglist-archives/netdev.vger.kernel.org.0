Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C54B82551A3
	for <lists+netdev@lfdr.de>; Fri, 28 Aug 2020 01:35:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728093AbgH0XfU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Aug 2020 19:35:20 -0400
Received: from mail-proxy25223.qiye.163.com ([103.129.252.23]:12360 "EHLO
        mail-proxy25223.qiye.163.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728083AbgH0XfU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Aug 2020 19:35:20 -0400
Received: from [192.168.1.7] (unknown [101.81.69.209])
        by m9785.mail.qiye.163.com (Hmail) with ESMTPA id 3AE005C0F66;
        Fri, 28 Aug 2020 07:33:12 +0800 (CST)
Subject: Re: [PATCH net-next 1/2] ipv6: add ipv6_fragment hook in ipv6_stub
To:     Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        David Miller <davem@davemloft.net>
Cc:     netdev@vger.kernel.org
References: <1598524792-30597-1-git-send-email-wenxu@ucloud.cn>
 <1598524792-30597-2-git-send-email-wenxu@ucloud.cn>
 <20200827.075147.1030378285544511842.davem@davemloft.net>
 <20200827223836.GB2443@localhost.localdomain>
From:   wenxu <wenxu@ucloud.cn>
Message-ID: <401c9afe-cc58-bf62-4588-b971b05cb024@ucloud.cn>
Date:   Fri, 28 Aug 2020 07:33:10 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200827223836.GB2443@localhost.localdomain>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgYFAkeWUFZS1VLWVdZKFlBSUI3V1ktWUFJV1kPCR
        oVCBIfWUFZSx8aHx5JSk0fS05PVkpOQkNOTEpKQklIQk9VGRETFhoSFyQUDg9ZV1kWGg8SFR0UWU
        FZT0tIVUpKS0hKTFVKS0tZBg++
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6PhQ6PRw5OD5PIxlPAhE*Nhgp
        GktPFB9VSlVKTkJDTkxKSkJJTkpOVTMWGhIXVQweFQMOOw4YFxQOH1UYFUVZV1kSC1lBWUpLSlVD
        SlVNQlVJS0JZV1kIAVlBSUNDSzcG
X-HM-Tid: 0a743244a0142087kuqy3ae005c0f66
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Yes， I check the ipv6_stub->ipv6_fragment. And in the case

if there is no ipv6_stub->ipv6_fragment it means no ipv6 fragment support

and it should free the skb.

Maybe sometimes  not all the calling remember to check with this? So

it should add a default one with following?

+static int eafnosupport_ipv6_fragment(struct net *net, struct sock *sk, struct sk_buff *skb,
+                                     int (*output)(struct net *, struct sock *, struct sk_buff *))
+{
+       kfree_skb(skb);
+       return -EAFNOSUPPORT;
+}
+

在 2020/8/28 6:38, Marcelo Ricardo Leitner 写道:
> On Thu, Aug 27, 2020 at 07:51:47AM -0700, David Miller wrote:
>> From: wenxu@ucloud.cn
>> Date: Thu, 27 Aug 2020 18:39:51 +0800
>>
>>> From: wenxu <wenxu@ucloud.cn>
>>>
>>> Add ipv6_fragment to ipv6_stub to avoid calling netfilter when
>>> access ip6_fragment.
>>>
>>> Signed-off-by: wenxu <wenxu@ucloud.cn>
>> Please test these changes with ipv6 disabled.
>>
>> It will crash, you have to update the default stub in
>> net/ipv6/addrconf_core.c as well.
> I didn't test it myself but I'm not seeing how the crash could happen.
> The next patch does check for it being NULL before using it:
>
> -               if (!v6ops)
> +               if (!ipv6_stub->ipv6_fragment)
>                         goto err;
>
> Wenxu?
>
>   Marcelo
>
