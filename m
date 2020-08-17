Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC2062465D3
	for <lists+netdev@lfdr.de>; Mon, 17 Aug 2020 13:58:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728173AbgHQL6J convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 17 Aug 2020 07:58:09 -0400
Received: from szxga08-in.huawei.com ([45.249.212.255]:43778 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726980AbgHQL6I (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 17 Aug 2020 07:58:08 -0400
Received: from dggeme752-chm.china.huawei.com (unknown [172.30.72.57])
        by Forcepoint Email with ESMTP id C7D07439247B691B2075;
        Mon, 17 Aug 2020 19:58:05 +0800 (CST)
Received: from dggeme753-chm.china.huawei.com (10.3.19.99) by
 dggeme752-chm.china.huawei.com (10.3.19.98) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.1913.5; Mon, 17 Aug 2020 19:58:05 +0800
Received: from dggeme753-chm.china.huawei.com ([10.7.64.70]) by
 dggeme753-chm.china.huawei.com ([10.7.64.70]) with mapi id 15.01.1913.007;
 Mon, 17 Aug 2020 19:58:05 +0800
From:   linmiaohe <linmiaohe@huawei.com>
To:     David Miller <davem@davemloft.net>
CC:     "kuba@kernel.org" <kuba@kernel.org>,
        "martin.varghese@nokia.com" <martin.varghese@nokia.com>,
        "fw@strlen.de" <fw@strlen.de>, "pshelar@ovn.org" <pshelar@ovn.org>,
        "dcaratti@redhat.com" <dcaratti@redhat.com>,
        "edumazet@google.com" <edumazet@google.com>,
        "steffen.klassert@secunet.com" <steffen.klassert@secunet.com>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "shmulik@metanetworks.com" <shmulik@metanetworks.com>,
        "kyk.segfault@gmail.com" <kyk.segfault@gmail.com>,
        "sowmini.varadhan@oracle.com" <sowmini.varadhan@oracle.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] net: handle the return value of pskb_carve_frag_list()
 correctly
Thread-Topic: [PATCH] net: handle the return value of pskb_carve_frag_list()
 correctly
Thread-Index: AdZ0Yo20uYefvGXNRNyT7FI7JGGSHQ==
Date:   Mon, 17 Aug 2020 11:58:05 +0000
Message-ID: <02b2c26de261418f91106a29cd702692@huawei.com>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.174.176.142]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

David Miller <davem@davemloft.net> wrote:
>> David Miller <davem@davemloft.net> wrote:
>>>> +	/* split line is in frag list */
>>>> +	if (k == 0 && pskb_carve_frag_list(skb, shinfo, off - pos, gfp_mask)) {
>>>> +		/* skb_frag_unref() is not needed here as shinfo->nr_frags = 0. */
>>>> +		if (skb_has_frag_list(skb))
>>>> +			kfree_skb_list(skb_shinfo(skb)->frag_list);
>>>> +		kfree(data);
>>>> +		return -ENOMEM;
>>>
>>>On error, the caller is going to kfree_skb(skb) which will take care of the frag list.
>>>
>> 
>> I'am sorry for my careless. The caller will take care of the frag list and kfree(data) is enough here.
>> Many thanks for review, will send v2 soon.
>
>Actually, reading this again, what about the skb_clone_fraglist() done a few lines up?  Who will release that reference to the fraglist items?
>
>Maybe the kfree_skb_list() is necessary after all?

Yep, it looks really confusing here. On error, the caller calls kfree_skb(skb) but only atomic_sub the skb_shared_info->dataref indeed because skb is cloned
here and it shares the fraglist with origin skbuff. But the skb_clone_fraglist() done a few lines up hold the extra reference to the fraglist for coming new skb->data.
As there is no new skb->data anymore, that reference to the fraglist items won't be release unless we take care of it here.

It seems this patch exactly do the right things already. :)

