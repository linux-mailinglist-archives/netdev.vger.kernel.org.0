Return-Path: <netdev+bounces-987-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id EBCCB6FBC24
	for <lists+netdev@lfdr.de>; Tue,  9 May 2023 02:51:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BAB69281154
	for <lists+netdev@lfdr.de>; Tue,  9 May 2023 00:51:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D863B37D;
	Tue,  9 May 2023 00:51:11 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD4477C;
	Tue,  9 May 2023 00:51:11 +0000 (UTC)
Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07BE24C02;
	Mon,  8 May 2023 17:51:09 -0700 (PDT)
Received: from dggpemm500005.china.huawei.com (unknown [172.30.72.53])
	by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4QFfh404RszpWF8;
	Tue,  9 May 2023 08:49:56 +0800 (CST)
Received: from [10.69.30.204] (10.69.30.204) by dggpemm500005.china.huawei.com
 (7.185.36.74) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.23; Tue, 9 May
 2023 08:51:07 +0800
Subject: Re: [PATCH RFC 2/2] net: remove __skb_frag_set_page()
To: Simon Horman <simon.horman@corigine.com>
CC: <netdev@vger.kernel.org>, <linux-rdma@vger.kernel.org>,
	<virtualization@lists.linux-foundation.org>,
	<xen-devel@lists.xenproject.org>, <bpf@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <edumazet@google.com>, <davem@davemloft.net>,
	<kuba@kernel.org>, <pabeni@redhat.com>, <alexanderduyck@fb.com>,
	<jbrouer@redhat.com>, <ilias.apalodimas@linaro.org>
References: <20230508123922.39284-1-linyunsheng@huawei.com>
 <20230508123922.39284-3-linyunsheng@huawei.com>
 <ZFkHulUs7d1xWKSa@corigine.com>
From: Yunsheng Lin <linyunsheng@huawei.com>
Message-ID: <ca5dabb4-d875-7845-553f-915b3ce85be1@huawei.com>
Date: Tue, 9 May 2023 08:51:07 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.0
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <ZFkHulUs7d1xWKSa@corigine.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.69.30.204]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 dggpemm500005.china.huawei.com (7.185.36.74)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-6.0 required=5.0 tests=BAYES_00,NICE_REPLY_A,
	RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 2023/5/8 22:31, Simon Horman wrote:
> On Mon, May 08, 2023 at 08:39:22PM +0800, Yunsheng Lin wrote:
>> The remaining users calling __skb_frag_set_page() with
>> page being NULL seems to doing defensive programming, as
>> shinfo->nr_frags is already decremented, so remove them.
>>
>> Signed-off-by: Yunsheng Lin <linyunsheng@huawei.com>
> 
> ...
> 
>> diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
>> index efaff5018af8..f3f08660ec30 100644
>> --- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
>> +++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
>> @@ -1105,7 +1105,6 @@ static u32 __bnxt_rx_agg_pages(struct bnxt *bp,
>>  			unsigned int nr_frags;
>>  
>>  			nr_frags = --shinfo->nr_frags;
> 
> Hi Yunsheng,
> 
> nr_frags is now  unused, other than being set on the line above.
> Probably this local variable can be removed.

Yes, will remove that.
Thanks.

