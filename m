Return-Path: <netdev+bounces-3791-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 0BF62708DDA
	for <lists+netdev@lfdr.de>; Fri, 19 May 2023 04:37:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A70981C21206
	for <lists+netdev@lfdr.de>; Fri, 19 May 2023 02:37:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9A563190;
	Fri, 19 May 2023 02:37:05 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87EFF36E
	for <netdev@vger.kernel.org>; Fri, 19 May 2023 02:37:05 +0000 (UTC)
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7BB73E4D;
	Thu, 18 May 2023 19:37:03 -0700 (PDT)
Received: from dggpemm500005.china.huawei.com (unknown [172.30.72.55])
	by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4QMrTx5Pd3zqSLG;
	Fri, 19 May 2023 10:32:37 +0800 (CST)
Received: from [10.69.30.204] (10.69.30.204) by dggpemm500005.china.huawei.com
 (7.185.36.74) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.23; Fri, 19 May
 2023 10:37:00 +0800
Subject: Re: [PATCH net-next v2] octeontx2-pf: Add support for page pool
To: Ratheesh Kannoth <rkannoth@marvell.com>, "netdev@vger.kernel.org"
	<netdev@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>
CC: Sunil Kovvuri Goutham <sgoutham@marvell.com>, "davem@davemloft.net"
	<davem@davemloft.net>, "edumazet@google.com" <edumazet@google.com>,
	"kuba@kernel.org" <kuba@kernel.org>, "pabeni@redhat.com" <pabeni@redhat.com>,
	Subbaraya Sundeep Bhatta <sbhatta@marvell.com>, Geethasowjanya Akula
	<gakula@marvell.com>, Srujana Challa <schalla@marvell.com>, Hariprasad Kelam
	<hkelam@marvell.com>
References: <20230518055129.3129897-1-rkannoth@marvell.com>
 <9b576dd4-6083-9fab-5859-875287831d0a@huawei.com>
 <MWHPR1801MB191809E0C74271333E96C343D37C9@MWHPR1801MB1918.namprd18.prod.outlook.com>
From: Yunsheng Lin <linyunsheng@huawei.com>
Message-ID: <0136fe46-eeb7-782d-0616-2a444e2f2da4@huawei.com>
Date: Fri, 19 May 2023 10:37:00 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.0
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <MWHPR1801MB191809E0C74271333E96C343D37C9@MWHPR1801MB1918.namprd18.prod.outlook.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.69.30.204]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 dggpemm500005.china.huawei.com (7.185.36.74)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-6.8 required=5.0 tests=BAYES_00,NICE_REPLY_A,
	RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 2023/5/19 9:52, Ratheesh Kannoth wrote:
>> ----------------------------------------------------------------------
>> On 2023/5/18 13:51, Ratheesh Kannoth wrote:
>>> Page pool for each rx queue enhance rx side performance by reclaiming
>>> buffers back to each queue specific pool. DMA mapping is done only for
>>> first allocation of buffers.
>>> As subsequent buffers allocation avoid DMA mapping, it results in
>>> performance improvement.
>>>
>>> Image        |  Performance with Linux kernel Packet Generator
>>
>> Is there any more detailed info for the performance data?
>> 'kernel Packet Generator' means using pktgen module in the
>> net/core/pktgen.c? it seems pktgen is more for tx, is there any abvious
>> reason why the page pool optimization for rx have brought about ten times
>> improvement?
> We used packet generator for TX machine.  Performance data is for RX DUT.  I will remove 
> Packet generator text from the commit message as it gives ambiguous information
> DUT  Rx     <-------------------------     TX  (Linux machine with packet generator)
>  (page pool support) 

Thanks for clarifying.
DUT is for 'Device Under Test'?
what does DUT do after it receive a packet? XDP DROP?

> 
>>
>>> ------------ | -----------------------------------------------
>>> Vannila      |   3Mpps
>>>              |
>>> with this    |   42Mpps
>>> change	     |
>>> -------------------------------------------------------------
>>>
>>
>> ...
>>
>>>  static int __otx2_alloc_rbuf(struct otx2_nic *pfvf, struct otx2_pool *pool,
>>>  			     dma_addr_t *dma)
>>>  {
>>>  	u8 *buf;
>>>
>>> +	if (pool->page_pool)
>>> +		return otx2_alloc_pool_buf(pfvf, pool, dma);
>>> +
>>>  	buf = napi_alloc_frag_align(pool->rbsize, OTX2_ALIGN);
>>>  	if (unlikely(!buf))
>>>  		return -ENOMEM;
>>
>> It seems the above is dead code when using 'select PAGE_POOL', as
>> PAGE_POOL config is always selected by the driver?
> _otx2_alloc_rbuf() is common code for RX and TX.  For RX,  pool->page_pool != NULL, so allocation is from page pool.
> 

Am I missing something here? 'buf' is dma-mapped with
DMA_FROM_DEVICE, can it be used for TX?

Also, what does 'r' in _otx2_alloc_rbuf() mean?



