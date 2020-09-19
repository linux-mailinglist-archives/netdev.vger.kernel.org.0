Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 172FF270A03
	for <lists+netdev@lfdr.de>; Sat, 19 Sep 2020 04:23:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726159AbgISCXi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Sep 2020 22:23:38 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:13709 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726009AbgISCXi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 18 Sep 2020 22:23:38 -0400
Received: from DGGEMS403-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 3185D76BED2A56DBD76B;
        Sat, 19 Sep 2020 10:23:37 +0800 (CST)
Received: from [10.74.191.121] (10.74.191.121) by
 DGGEMS403-HUB.china.huawei.com (10.3.19.203) with Microsoft SMTP Server id
 14.3.487.0; Sat, 19 Sep 2020 10:23:27 +0800
Subject: Re: [PATCH net-next] net: hns3: remove unnecessary NULL checking in
 napi_consume_skb()
From:   Yunsheng Lin <linyunsheng@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <linmiaohe@huawei.com>,
        <martin.varghese@nokia.com>, <fw@strlen.de>, <edumazet@google.com>,
        <dcaratti@redhat.com>, <steffen.klassert@secunet.com>,
        <pabeni@redhat.com>, <kyk.segfault@gmail.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linuxarm@huawei.com>
References: <1600481766-46158-1-git-send-email-linyunsheng@huawei.com>
Message-ID: <11f34f14-8d23-b7a6-3ca6-2a147de36b64@huawei.com>
Date:   Sat, 19 Sep 2020 10:23:26 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.0
MIME-Version: 1.0
In-Reply-To: <1600481766-46158-1-git-send-email-linyunsheng@huawei.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.74.191.121]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Please ignore this patch, the title is not right, sorry for the noise.

On 2020/9/19 10:16, Yunsheng Lin wrote:
> When budget is non-zero, skb_unref() has already handled the
> NULL checking.
> 
> When budget is zero, the dev_consume_skb_any() has handled NULL
> checking in __dev_kfree_skb_irq(), or dev_kfree_skb() which also
> ultimately call skb_unref().
> 
> So remove the unnecessary checking in napi_consume_skb().
> 
> Signed-off-by: Yunsheng Lin <linyunsheng@huawei.com>
> ---
>  net/core/skbuff.c | 3 ---
>  1 file changed, 3 deletions(-)
> 
> diff --git a/net/core/skbuff.c b/net/core/skbuff.c
> index bfd7483..e077447 100644
> --- a/net/core/skbuff.c
> +++ b/net/core/skbuff.c
> @@ -895,9 +895,6 @@ void __kfree_skb_defer(struct sk_buff *skb)
>  
>  void napi_consume_skb(struct sk_buff *skb, int budget)
>  {
> -	if (unlikely(!skb))
> -		return;
> -
>  	/* Zero budget indicate non-NAPI context called us, like netpoll */
>  	if (unlikely(!budget)) {
>  		dev_consume_skb_any(skb);
> 
