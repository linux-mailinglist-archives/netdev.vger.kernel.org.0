Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6ED8F3B936
	for <lists+netdev@lfdr.de>; Mon, 10 Jun 2019 18:18:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404116AbfFJQRm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Jun 2019 12:17:42 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:40176 "EHLO
        mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390990AbfFJQRl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Jun 2019 12:17:41 -0400
Received: from eucas1p1.samsung.com (unknown [182.198.249.206])
        by mailout1.w1.samsung.com (KnoxPortal) with ESMTP id 20190610161740euoutp010fdaa26e07a196faa65fc5029be981bb~m4pdX136k2528825288euoutp01M
        for <netdev@vger.kernel.org>; Mon, 10 Jun 2019 16:17:40 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w1.samsung.com 20190610161740euoutp010fdaa26e07a196faa65fc5029be981bb~m4pdX136k2528825288euoutp01M
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1560183460;
        bh=sAFK7z11VVTb7FnfO2m2bg3sqAxX7frwXuQTxjAelag=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=bKVhvvtQaX5z3yG5D3noiVf8R9JGqcQzsgM4ySLGGbT0PomeYQBC83qR9mTw9Jyua
         3pIcMsHBxaAqZBjhD1EsUUfHxAaZhn+A06VLXpezFDFwaZvziwulPTd0A4AHAPGkS3
         0ad0WjSl04p41ZhcwN5Bg5uxwlfgd6rr9JcPH+go=
Received: from eusmges1new.samsung.com (unknown [203.254.199.242]) by
        eucas1p1.samsung.com (KnoxPortal) with ESMTP id
        20190610161739eucas1p17c0338184126cab4edaa1e201e70e2dc~m4pcjC3Pk1445614456eucas1p10;
        Mon, 10 Jun 2019 16:17:39 +0000 (GMT)
Received: from eucas1p2.samsung.com ( [182.198.249.207]) by
        eusmges1new.samsung.com (EUCPMTA) with SMTP id E8.D4.04298.3A28EFC5; Mon, 10
        Jun 2019 17:17:39 +0100 (BST)
Received: from eusmtrp2.samsung.com (unknown [182.198.249.139]) by
        eucas1p1.samsung.com (KnoxPortal) with ESMTPA id
        20190610161738eucas1p18e8ea92ad360435f32979380caed7f0b~m4pbzh9tt1445614456eucas1p1z;
        Mon, 10 Jun 2019 16:17:38 +0000 (GMT)
Received: from eusmgms2.samsung.com (unknown [182.198.249.180]) by
        eusmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20190610161738eusmtrp2a2a495b577bf1fbfabfc5ce074264323~m4pbj2g5A1476914769eusmtrp2g;
        Mon, 10 Jun 2019 16:17:38 +0000 (GMT)
X-AuditID: cbfec7f2-f2dff700000010ca-7f-5cfe82a3680a
Received: from eusmtip1.samsung.com ( [203.254.199.221]) by
        eusmgms2.samsung.com (EUCPMTA) with SMTP id 0E.D3.04140.2A28EFC5; Mon, 10
        Jun 2019 17:17:38 +0100 (BST)
Received: from [106.109.129.180] (unknown [106.109.129.180]) by
        eusmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20190610161737eusmtip1dd37683d70038d9f90fe32a0dfdf9043~m4parH2bQ2310323103eusmtip1d;
        Mon, 10 Jun 2019 16:17:37 +0000 (GMT)
Subject: Re: [PATCH bpf v2] xdp: fix hang while unregistering device bound
 to xdp socket
From:   Ilya Maximets <i.maximets@samsung.com>
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        bpf@vger.kernel.org, xdp-newbies@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>
Message-ID: <06eee1e3-283a-d665-904b-f0bc89b73232@samsung.com>
Date:   Mon, 10 Jun 2019 19:17:37 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
        Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <d8b2bc92-3b7e-dfe7-35ee-61a68d46ff02@samsung.com>
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrJKsWRmVeSWpSXmKPExsWy7djP87qLm/7FGDT+ErH407aB0eLzkeNs
        FnPOt7BYXGn/yW5x7EULm8WudTOZLS7vmsNmseLQCaDYAjGL7f37GB24PLasvMnksXPWXXaP
        xXteMnlM737I7NG3ZRWjx+dNcgFsUVw2Kak5mWWpRfp2CVwZKy7rFGznrVh17S1bA+MRri5G
        Tg4JAROJqZOOsXQxcnAICaxglHguDBIWEvjCKPF5WVYXIxeQ/ZlRYsHF7aww9Y9evWaESCwH
        Knq6lw3C+cgoMeP1YiaQKmGBKIlv/56C2WwCOhKnVh9hBLFFBAwlft2YwgrSwCywlkni0p+J
        YKt5BewkJnRmg5gsAqoSl6+Kg5SLCkRIfNm5CayVV0BQ4uTMJywgNqeAvcSJo2/AbGYBcYmm
        LytZIWx5ie1v5zCDjJcQOMcu0X3kKyPE1S4St1t3MEPYwhKvjm9hh7BlJP7vnM8EYddL3G95
        yQjR3MEoMf3QP6iEvcSW1+fYQY5jFtCUWL9LHyLsKPH9UjtYWEKAT+LGW0GIG/gkJm2bzgwR
        5pXoaBOCqFaR+H1wOdQFUhI3331mn8CoNAvJZ7OQfDMLyTezEPYuYGRZxSieWlqcm55abJiX
        Wq5XnJhbXJqXrpecn7uJEZigTv87/mkH49dLSYcYBTgYlXh4I6L/xQixJpYVV+YeYpTgYFYS
        4V0hBRTiTUmsrEotyo8vKs1JLT7EKM3BoiTOW83wIFpIID2xJDU7NbUgtQgmy8TBKdXAOG3/
        P64U/lNqfAUyDN///lXpcmYW9fmxQnJ5rNYdnquKWRxi6n8Znm7+4f1Ims/OxPPixTzNWbLr
        F273XHvBoe4f94n7Xv8vcfiqvdgWuftibNZaN5XvPGtVOTqs+v35nBu/K4SqzBCdzjG/rMd/
        mvzc21E5PWYrO1dsnLLVc23PyfJefqN3SizFGYmGWsxFxYkAYheG7kwDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrHIsWRmVeSWpSXmKPExsVy+t/xu7qLmv7FGEyeJGjxp20Do8XnI8fZ
        LOacb2GxuNL+k93i2IsWNotd62YyW1zeNYfNYsWhE0CxBWIW2/v3MTpweWxZeZPJY+esu+we
        i/e8ZPKY3v2Q2aNvyypGj8+b5ALYovRsivJLS1IVMvKLS2yVog0tjPQMLS30jEws9QyNzWOt
        jEyV9O1sUlJzMstSi/TtEvQyVlzWKdjOW7Hq2lu2BsYjXF2MnBwSAiYSj169Zuxi5OIQEljK
        KPFx5URWiISUxI9fF6BsYYk/17rYIIreM0osvfSHGSQhLBAlcenxcTCbTUBH4tTqI4wgtoiA
        ocSvG1NYQRqYBdYySexa3cwEkhAS+MIo8WmxeRcjBwevgJ3EhM5sEJNFQFXi8lVxkApRgQiJ
        2bsaWEBsXgFBiZMzn4DZnAL2EieOvgGzmQXUJf7Mu8QMYYtLNH1ZyQphy0tsfzuHeQKj0Cwk
        7bOQtMxC0jILScsCRpZVjCKppcW56bnFRnrFibnFpXnpesn5uZsYgXG57djPLTsYu94FH2IU
        4GBU4uGNiP4XI8SaWFZcmXuIUYKDWUmEd4UUUIg3JbGyKrUoP76oNCe1+BCjKdBvE5mlRJPz
        gSkjryTe0NTQ3MLS0NzY3NjMQkmct0PgYIyQQHpiSWp2ampBahFMHxMHp1QDY013I0vBsWkv
        o9t26bKZSC1yOG7au+/nevabLk0iQpOUdA4Ylhd4rKm/bblMYM0HkTv1Tis8SjelXXggp11i
        V/jXdv3zKxzfjs/cnGrCuPDq7qDe//PXeaf722dWh9xMTGidWL11wvQl9S7H67JSmTxe3Nx7
        SrN43rFX5lJsnRUvyxh2r7/7QomlOCPRUIu5qDgRAGsFRj/hAgAA
X-CMS-MailID: 20190610161738eucas1p18e8ea92ad360435f32979380caed7f0b
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-RootMTR: 20190607173149eucas1p1d2ebedcab469ebd66acfe7c7dcd18d7e
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20190607173149eucas1p1d2ebedcab469ebd66acfe7c7dcd18d7e
References: <CGME20190607173149eucas1p1d2ebedcab469ebd66acfe7c7dcd18d7e@eucas1p1.samsung.com>
        <20190607173143.4919-1-i.maximets@samsung.com>
        <20190607163156.12cd3418@cakuba.netronome.com>
        <d8b2bc92-3b7e-dfe7-35ee-61a68d46ff02@samsung.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10.06.2019 11:05, Ilya Maximets wrote:
> On 08.06.2019 2:31, Jakub Kicinski wrote:
>> On Fri,  7 Jun 2019 20:31:43 +0300, Ilya Maximets wrote:
>>> +static int xsk_notifier(struct notifier_block *this,
>>> +			unsigned long msg, void *ptr)
>>> +{
>>> +	struct sock *sk;
>>> +	struct net_device *dev = netdev_notifier_info_to_dev(ptr);
>>> +	struct net *net = dev_net(dev);
>>> +	int i, unregister_count = 0;
>>
>> Please order the var declaration lines longest to shortest.
>> (reverse christmas tree)
> 
> Hi.
> I'm not a fan of mixing 'struct's with bare types in the declarations.
> Moving the 'sk' to the third place will make a hole like this:
> 
> 	struct net_device *dev = netdev_notifier_info_to_dev(ptr);
> 	struct net *net = dev_net(dev);
> 	struct sock *sk;
> 	int i, unregister_count = 0;
> 
> Which is not looking good.
> Moving to the 4th place:
> 
> 	struct net_device *dev = netdev_notifier_info_to_dev(ptr);
> 	struct net *net = dev_net(dev);
> 	int i, unregister_count = 0;
> 	struct sock *sk;

I've sent v3 with this variant and with moved msg check to the top level.

> 
> This variant doesn't look good for me because of mixing 'struct's with
> bare integers.
> 
> Do you think I need to use one of above variants?
> 
>>
>>> +	mutex_lock(&net->xdp.lock);
>>> +	sk_for_each(sk, &net->xdp.list) {
>>> +		struct xdp_sock *xs = xdp_sk(sk);
>>> +
>>> +		mutex_lock(&xs->mutex);
>>> +		switch (msg) {
>>> +		case NETDEV_UNREGISTER:
>>
>> You should probably check the msg type earlier and not take all the
>> locks and iterate for other types..
> 
> Yeah. I thought about it too. Will fix in the next version.
> 
> Best regards, Ilya Maximets.
> 
