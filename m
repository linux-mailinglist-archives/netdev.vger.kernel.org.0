Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F90E1B5544
	for <lists+netdev@lfdr.de>; Thu, 23 Apr 2020 09:16:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726861AbgDWHOZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Apr 2020 03:14:25 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:2839 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725562AbgDWHOY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 23 Apr 2020 03:14:24 -0400
Received: from DGGEMS412-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 37D6DEE7B8B846F81F60;
        Thu, 23 Apr 2020 15:14:22 +0800 (CST)
Received: from [127.0.0.1] (10.166.215.154) by DGGEMS412-HUB.china.huawei.com
 (10.3.19.212) with Microsoft SMTP Server id 14.3.487.0; Thu, 23 Apr 2020
 15:14:19 +0800
Subject: Re: [PATCH] net/x25: Fix x25_neigh refcnt leak when reveiving frame
To:     Xiyu Yang <xiyuyang19@fudan.edu.cn>,
        Andrew Hendry <andrew.hendry@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        "Jakub Kicinski" <kuba@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Eric Dumazet <edumazet@google.com>,
        Allison Randal <allison@lohutok.net>,
        Thomas Gleixner <tglx@linutronix.de>,
        <linux-x25@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
References: <1587618786-13481-1-git-send-email-xiyuyang19@fudan.edu.cn>
CC:     <yuanxzhang@fudan.edu.cn>, <kjlu@umn.edu>,
        Xin Tan <tanxin.ctf@gmail.com>
From:   Yuehaibing <yuehaibing@huawei.com>
Message-ID: <a5cfb5ee-cd8b-b694-3d83-cd4fe08429c7@huawei.com>
Date:   Thu, 23 Apr 2020 15:14:18 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.2.0
MIME-Version: 1.0
In-Reply-To: <1587618786-13481-1-git-send-email-xiyuyang19@fudan.edu.cn>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.166.215.154]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020/4/23 13:13, Xiyu Yang wrote:
> x25_lapb_receive_frame() invokes x25_get_neigh(), which returns a
> reference of the specified x25_neigh object to "nb" with increased
> refcnt.
> 
> When x25_lapb_receive_frame() returns, local variable "nb" becomes
> invalid, so the refcount should be decreased to keep refcount balanced.
> 
> The reference counting issue happens in one path of
> x25_lapb_receive_frame(). When pskb_may_pull() returns false, the
> function forgets to decrease the refcnt increased by x25_get_neigh(),
> causing a refcnt leak.
> 
> Fix this issue by calling x25_neigh_put() when pskb_may_pull() returns
> false.
> 

Fixes: cb101ed2c3c7 ("x25: Handle undersized/fragmented skbs")

> Signed-off-by: Xiyu Yang <xiyuyang19@fudan.edu.cn>
> Signed-off-by: Xin Tan <tanxin.ctf@gmail.com>
> ---
>  net/x25/x25_dev.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/net/x25/x25_dev.c b/net/x25/x25_dev.c
> index 00e782335cb0..25bf72ee6cad 100644
> --- a/net/x25/x25_dev.c
> +++ b/net/x25/x25_dev.c
> @@ -115,8 +115,10 @@ int x25_lapb_receive_frame(struct sk_buff *skb, struct net_device *dev,
>  		goto drop;
>  	}
>  
> -	if (!pskb_may_pull(skb, 1))
> +	if (!pskb_may_pull(skb, 1)) {
> +		x25_neigh_put(nb);
>  		return 0;
> +	}
>  
>  	switch (skb->data[0]) {
>  
> 

