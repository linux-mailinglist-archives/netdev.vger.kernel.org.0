Return-Path: <netdev+bounces-988-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 29FFB6FBC43
	for <lists+netdev@lfdr.de>; Tue,  9 May 2023 03:01:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DDC491C20A9F
	for <lists+netdev@lfdr.de>; Tue,  9 May 2023 01:01:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 761B0380;
	Tue,  9 May 2023 01:01:48 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AB8F7C;
	Tue,  9 May 2023 01:01:48 +0000 (UTC)
Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06D8B171F;
	Mon,  8 May 2023 18:01:46 -0700 (PDT)
Received: from dggpemm500005.china.huawei.com (unknown [172.30.72.55])
	by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4QFfwJ0ZsbzpVpN;
	Tue,  9 May 2023 09:00:32 +0800 (CST)
Received: from [10.69.30.204] (10.69.30.204) by dggpemm500005.china.huawei.com
 (7.185.36.74) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.23; Tue, 9 May
 2023 09:01:43 +0800
Subject: Re: [PATCH net-next] net: veth: rely on napi_build_skb in
 veth_convert_skb_to_xdp_buff
To: Lorenzo Bianconi <lorenzo@kernel.org>, <netdev@vger.kernel.org>
CC: <lorenzo.bianconi@redhat.com>, <bpf@vger.kernel.org>,
	<davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
	<pabeni@redhat.com>, <hawk@kernel.org>, <john.fastabend@gmail.com>,
	<ast@kernel.org>, <daniel@iogearbox.net>
References: <0f822c0b72f8b71555c11745cb8fb33399d02de9.1683578488.git.lorenzo@kernel.org>
From: Yunsheng Lin <linyunsheng@huawei.com>
Message-ID: <78a76439-9189-be9c-be2a-d757487f52c2@huawei.com>
Date: Tue, 9 May 2023 09:01:43 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.0
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <0f822c0b72f8b71555c11745cb8fb33399d02de9.1683578488.git.lorenzo@kernel.org>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.69.30.204]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 dggpemm500005.china.huawei.com (7.185.36.74)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-6.0 required=5.0 tests=BAYES_00,NICE_REPLY_A,
	RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 2023/5/9 4:45, Lorenzo Bianconi wrote:
> Since veth_convert_skb_to_xdp_buff routine runs in veth_poll() NAPI,
> rely on napi_build_skb() instead of build_skb() to reduce skb allocation
> cost.

LGTM.
Reviewed-by: Yunsheng Lin <linyunsheng@huawei.com>

> 
> Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> ---
>  drivers/net/veth.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/veth.c b/drivers/net/veth.c
> index dce9f9d63e04..3ae496011640 100644
> --- a/drivers/net/veth.c
> +++ b/drivers/net/veth.c
> @@ -747,7 +747,7 @@ static int veth_convert_skb_to_xdp_buff(struct veth_rq *rq,
>  		if (!page)
>  			goto drop;
>  
> -		nskb = build_skb(page_address(page), PAGE_SIZE);
> +		nskb = napi_build_skb(page_address(page), PAGE_SIZE);
>  		if (!nskb) {
>  			page_pool_put_full_page(rq->page_pool, page, true);
>  			goto drop;
> 

