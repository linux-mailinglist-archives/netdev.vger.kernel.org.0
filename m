Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3AB473B031
	for <lists+netdev@lfdr.de>; Mon, 10 Jun 2019 10:05:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388300AbfFJIFs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Jun 2019 04:05:48 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:55207 "EHLO
        mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388235AbfFJIFr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Jun 2019 04:05:47 -0400
Received: from eucas1p1.samsung.com (unknown [182.198.249.206])
        by mailout2.w1.samsung.com (KnoxPortal) with ESMTP id 20190610080545euoutp022ebc182272c87f0cc85ede65a5f809ca~mx79Mr9zr3196231962euoutp02D
        for <netdev@vger.kernel.org>; Mon, 10 Jun 2019 08:05:45 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.w1.samsung.com 20190610080545euoutp022ebc182272c87f0cc85ede65a5f809ca~mx79Mr9zr3196231962euoutp02D
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1560153945;
        bh=Iydzu+34xMOqZUeL4a5kLloyjoWo0xPAO3gew+uxnu8=;
        h=Subject:To:Cc:From:Date:In-Reply-To:References:From;
        b=sH/4LAkHLx5LaovrpNwy12MpT8CJXv7/xkiwiDpXtHPdZ7fQDMTcWf7X+sL6btgr9
         rkPl7nPCboz85OMHt+8Kl8OUle3NIX7UCfzqEiCaKtdAeiJvXnHPeqLMd78IyHkgaR
         hEED+yxS8Ue2nSnWuUFHF64XBzqns9f4FunbBPjs=
Received: from eusmges3new.samsung.com (unknown [203.254.199.245]) by
        eucas1p2.samsung.com (KnoxPortal) with ESMTP id
        20190610080544eucas1p22efd8450d445146257a36b83adde084a~mx78aOjzV0238302383eucas1p2l;
        Mon, 10 Jun 2019 08:05:44 +0000 (GMT)
Received: from eucas1p2.samsung.com ( [182.198.249.207]) by
        eusmges3new.samsung.com (EUCPMTA) with SMTP id 12.DD.04325.85F0EFC5; Mon, 10
        Jun 2019 09:05:44 +0100 (BST)
Received: from eusmtrp1.samsung.com (unknown [182.198.249.138]) by
        eucas1p1.samsung.com (KnoxPortal) with ESMTPA id
        20190610080543eucas1p1925be58eed3fadb6df90b58541e87cbb~mx77lHQId2351823518eucas1p1A;
        Mon, 10 Jun 2019 08:05:43 +0000 (GMT)
Received: from eusmgms1.samsung.com (unknown [182.198.249.179]) by
        eusmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20190610080543eusmtrp1f50cfc06142c71af65eb2953a6d6aff2~mx77VWRmP3063330633eusmtrp1G;
        Mon, 10 Jun 2019 08:05:43 +0000 (GMT)
X-AuditID: cbfec7f5-b8fff700000010e5-b1-5cfe0f5899b8
Received: from eusmtip2.samsung.com ( [203.254.199.222]) by
        eusmgms1.samsung.com (EUCPMTA) with SMTP id 35.D7.04146.75F0EFC5; Mon, 10
        Jun 2019 09:05:43 +0100 (BST)
Received: from [106.109.129.180] (unknown [106.109.129.180]) by
        eusmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20190610080542eusmtip23f447e2d8dc20e3cf266844fb3998a84~mx76qbxxV0105901059eusmtip2V;
        Mon, 10 Jun 2019 08:05:42 +0000 (GMT)
Subject: Re: [PATCH bpf v2] xdp: fix hang while unregistering device bound
 to xdp socket
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        bpf@vger.kernel.org, xdp-newbies@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>
From:   Ilya Maximets <i.maximets@samsung.com>
Message-ID: <d8b2bc92-3b7e-dfe7-35ee-61a68d46ff02@samsung.com>
Date:   Mon, 10 Jun 2019 11:05:41 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
        Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <20190607163156.12cd3418@cakuba.netronome.com>
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrHKsWRmVeSWpSXmKPExsWy7djP87oR/P9iDM618ln8advAaPH5yHE2
        iznnW1gsrrT/ZLc49qKFzWLXupnMFpd3zWGzWHHoBFBsgZjF9v59jA5cHltW3mTy2DnrLrvH
        4j0vmTymdz9k9ujbsorR4/MmuQC2KC6blNSczLLUIn27BK6MWfdeMha846648voZSwPjJs4u
        Rg4OCQETiS+Tg7oYuTiEBFYwSnz9vZIZwvnCKHGvsYsVwvnMKHGy9z9QhhOs4+W/FjaIxHJG
        iQ8t36BaPjJKfJv/DqxKWCBK4tu/p0wgtoiAocSvG1PARjELrGWSuPRnIgtIgk1AR+LU6iOM
        IDavgJ1E/+6F7CA2i4CqxJwZJ8AGiQpESHzZuQmqRlDi5MwnYL2cAtYS7cvvsILYzALiEk1f
        VkLZ8hLb384Bu0hC4By7RFvndyaIu10k5t+YxAJhC0u8Or6FHcKWkTg9uQcqXi9xv+UlI0Rz
        B6PE9EP/oJrtJba8PscOCjJmAU2J9bv0IcKOEt8vtbNDQpJP4sZbQYgb+CQmbZvODBHmleho
        E4KoVpH4fXA5NBSlJG6++8w+gVFpFpLPZiH5ZhaSb2Yh7F3AyLKKUTy1tDg3PbXYOC+1XK84
        Mbe4NC9dLzk/dxMjMFWd/nf86w7GfX+SDjEKcDAq8fAesP8bI8SaWFZcmXuIUYKDWUmE9+3R
        PzFCvCmJlVWpRfnxRaU5qcWHGKU5WJTEeasZHkQLCaQnlqRmp6YWpBbBZJk4OKUaGJUVXn2w
        V0//Nfeqks7Br83XPzv03w5hCKmSKthteEOc2fSu1Tex7NZp/7KNPsd+DdY+dOGXl6Dn+TUq
        H66J3etXPcZZvLLANGlOZeJ26TVLJXOVU07uejl5h1Rr59y/eb8Sr/6+/iRlchrj7LeTNxpU
        ZXP2R26WP1r8/um9/4HvEpYq8dxXFFNiKc5INNRiLipOBADigeVQUQMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrEIsWRmVeSWpSXmKPExsVy+t/xe7rh/P9iDGad5Lf407aB0eLzkeNs
        FnPOt7BYXGn/yW5x7EULm8WudTOZLS7vmsNmseLQCaDYAjGL7f37GB24PLasvMnksXPWXXaP
        xXteMnlM737I7NG3ZRWjx+dNcgFsUXo2RfmlJakKGfnFJbZK0YYWRnqGlhZ6RiaWeobG5rFW
        RqZK+nY2Kak5mWWpRfp2CXoZs+69ZCx4x11x5fUzlgbGTZxdjJwcEgImEi//tbB1MXJxCAks
        ZZT4ef4XI0RCSuLHrwusELawxJ9rXVBF7xklHv06xASSEBaIkrj0+DgziC0iYCjx68YUVpAi
        ZoG1TBK7VjczQXTsZ5TYeuopWAebgI7EqdVHwFbwCthJ9O9eyA5iswioSsyZcQJskqhAhMTs
        XQ0sEDWCEidnPgGzOQWsJdqX3wE7iVlAXeLPvEvMELa4RNOXlVBxeYntb+cwT2AUmoWkfRaS
        lllIWmYhaVnAyLKKUSS1tDg3PbfYUK84Mbe4NC9dLzk/dxMjMD63Hfu5eQfjpY3BhxgFOBiV
        eHgP2P+NEWJNLCuuzD3EKMHBrCTC+/bonxgh3pTEyqrUovz4otKc1OJDjKZAz01klhJNzgem
        jrySeENTQ3MLS0NzY3NjMwslcd4OgYMxQgLpiSWp2ampBalFMH1MHJxSDYy6Equ6i9YVXTOJ
        7+mo3zd5xWnLz3cvX4t+IDRDvNdugv2hM91zfy9o+3ijq/Vcv5OSTt85lorF1yuWcCtM7N8Q
        l3/1kvelhVazLL2FszlfrgnbuiWJzf6/c1fWyu+1Pm1f2V4Ue89a219xM7DsgPJtq+d/7i/M
        WC9mua1PesVqm+rfS9ZlMy5VYinOSDTUYi4qTgQAAmzqW+UCAAA=
X-CMS-MailID: 20190610080543eucas1p1925be58eed3fadb6df90b58541e87cbb
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-RootMTR: 20190607173149eucas1p1d2ebedcab469ebd66acfe7c7dcd18d7e
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20190607173149eucas1p1d2ebedcab469ebd66acfe7c7dcd18d7e
References: <CGME20190607173149eucas1p1d2ebedcab469ebd66acfe7c7dcd18d7e@eucas1p1.samsung.com>
        <20190607173143.4919-1-i.maximets@samsung.com>
        <20190607163156.12cd3418@cakuba.netronome.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 08.06.2019 2:31, Jakub Kicinski wrote:
> On Fri,  7 Jun 2019 20:31:43 +0300, Ilya Maximets wrote:
>> +static int xsk_notifier(struct notifier_block *this,
>> +			unsigned long msg, void *ptr)
>> +{
>> +	struct sock *sk;
>> +	struct net_device *dev = netdev_notifier_info_to_dev(ptr);
>> +	struct net *net = dev_net(dev);
>> +	int i, unregister_count = 0;
> 
> Please order the var declaration lines longest to shortest.
> (reverse christmas tree)

Hi.
I'm not a fan of mixing 'struct's with bare types in the declarations.
Moving the 'sk' to the third place will make a hole like this:

	struct net_device *dev = netdev_notifier_info_to_dev(ptr);
	struct net *net = dev_net(dev);
	struct sock *sk;
	int i, unregister_count = 0;

Which is not looking good.
Moving to the 4th place:

	struct net_device *dev = netdev_notifier_info_to_dev(ptr);
	struct net *net = dev_net(dev);
	int i, unregister_count = 0;
	struct sock *sk;

This variant doesn't look good for me because of mixing 'struct's with
bare integers.

Do you think I need to use one of above variants?

> 
>> +	mutex_lock(&net->xdp.lock);
>> +	sk_for_each(sk, &net->xdp.list) {
>> +		struct xdp_sock *xs = xdp_sk(sk);
>> +
>> +		mutex_lock(&xs->mutex);
>> +		switch (msg) {
>> +		case NETDEV_UNREGISTER:
> 
> You should probably check the msg type earlier and not take all the
> locks and iterate for other types..

Yeah. I thought about it too. Will fix in the next version.

Best regards, Ilya Maximets.
