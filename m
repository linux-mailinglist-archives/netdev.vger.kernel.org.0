Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 14C5D3FE6B9
	for <lists+netdev@lfdr.de>; Thu,  2 Sep 2021 02:50:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231880AbhIBAsx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Sep 2021 20:48:53 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:19001 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232731AbhIBAsw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Sep 2021 20:48:52 -0400
Received: from dggemv704-chm.china.huawei.com (unknown [172.30.72.57])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4H0McX2nhnzblQX;
        Thu,  2 Sep 2021 08:43:56 +0800 (CST)
Received: from dggpemm500005.china.huawei.com (7.185.36.74) by
 dggemv704-chm.china.huawei.com (10.3.19.47) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Thu, 2 Sep 2021 08:47:52 +0800
Received: from [10.69.30.204] (10.69.30.204) by dggpemm500005.china.huawei.com
 (7.185.36.74) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.2308.8; Thu, 2 Sep 2021
 08:47:51 +0800
Subject: Re: [PATCH net-next] tcp: add tcp_tx_skb_cache_key checking in
 sk_stream_alloc_skb()
From:   Yunsheng Lin <linyunsheng@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <edumazet@google.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linuxarm@openeuler.org>, <yoshfuji@linux-ipv6.org>,
        <dsahern@kernel.org>
References: <1630492744-60396-1-git-send-email-linyunsheng@huawei.com>
Message-ID: <ba7a0854-6841-2ebc-c329-4c13f1a997df@huawei.com>
Date:   Thu, 2 Sep 2021 08:47:51 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.0
MIME-Version: 1.0
In-Reply-To: <1630492744-60396-1-git-send-email-linyunsheng@huawei.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.69.30.204]
X-ClientProxiedBy: dggeme704-chm.china.huawei.com (10.1.199.100) To
 dggpemm500005.china.huawei.com (7.185.36.74)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021/9/1 18:39, Yunsheng Lin wrote:
> Since tcp_tx_skb_cache is disabled by default in:
> commit 0b7d7f6b2208 ("tcp: add tcp_tx_skb_cache sysctl")
> 
> Add tcp_tx_skb_cache_key checking in sk_stream_alloc_skb() to
> avoid possible branch-misses.
> 
> Signed-off-by: Yunsheng Lin <linyunsheng@huawei.com>
> ---
> Also, the sk->sk_tx_skb_cache may be both changed by allocation
> and freeing side, I assume there may be some implicit protection
> here too, such as the NAPI protection for rx?

Hi, Eric
   Is there any implicit protection for sk->sk_tx_skb_cache?
As my understanding, sk_stream_alloc_skb() seems to be protected
by lock_sock(), and the sk_wmem_free_skb() seems to be mostly
happening in NAPI polling for TCP(when ack packet is received)
without lock_sock(), so it seems there is no protection here?

> 
