Return-Path: <netdev+bounces-4478-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id DF18370D14E
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 04:34:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 84254281093
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 02:34:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C8A7E1FA3;
	Tue, 23 May 2023 02:34:27 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA4851108
	for <netdev@vger.kernel.org>; Tue, 23 May 2023 02:34:27 +0000 (UTC)
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 222D4CA;
	Mon, 22 May 2023 19:34:26 -0700 (PDT)
Received: from dggpemm500005.china.huawei.com (unknown [172.30.72.56])
	by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4QQJDz4mTWzqTNG;
	Tue, 23 May 2023 10:29:55 +0800 (CST)
Received: from [10.69.30.204] (10.69.30.204) by dggpemm500005.china.huawei.com
 (7.185.36.74) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.23; Tue, 23 May
 2023 10:34:23 +0800
Subject: Re: [PATCH net] page_pool: fix inconsistency for
 page_pool_ring_[un]lock()
To: Jakub Kicinski <kuba@kernel.org>
CC: Ilias Apalodimas <ilias.apalodimas@linaro.org>, Jesper Dangaard Brouer
	<jbrouer@redhat.com>, <davem@davemloft.net>, <pabeni@redhat.com>,
	<brouer@redhat.com>, <netdev@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, Jesper Dangaard Brouer <hawk@kernel.org>,
	Eric Dumazet <edumazet@google.com>, Lorenzo Bianconi <lorenzo@kernel.org>,
	Daniel Borkmann <daniel@iogearbox.net>, John Fastabend
	<john.fastabend@gmail.com>
References: <20230522031714.5089-1-linyunsheng@huawei.com>
 <1fc46094-a72a-f7e4-ef18-15edb0d56233@redhat.com>
 <CAC_iWjJaNuDFZuv1Rv4Yr5Kaj1Wq69txAoLGepvnJT=pY1gaRw@mail.gmail.com>
 <cc64a349-aaf4-9d80-3653-75eeb3032baf@huawei.com>
 <20230522192238.28837d1d@kernel.org>
From: Yunsheng Lin <linyunsheng@huawei.com>
Message-ID: <e36a2091-82be-6071-245e-0cdd068ff857@huawei.com>
Date: Tue, 23 May 2023 10:34:23 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.0
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20230522192238.28837d1d@kernel.org>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.69.30.204]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 dggpemm500005.china.huawei.com (7.185.36.74)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,NICE_REPLY_A,
	RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 2023/5/23 10:22, Jakub Kicinski wrote:
> On Tue, 23 May 2023 10:13:14 +0800 Yunsheng Lin wrote:
>> On 2023/5/22 19:45, Ilias Apalodimas wrote:
>>>> Thanks for spotting and fixing this! :-)  
>>
>> It was spotted when implementing the below patch:)
>>
>> https://patchwork.kernel.org/project/netdevbpf/patch/168269857929.2191653.13267688321246766547.stgit@firesoul/#25325801
>>
>> Do you still working on optimizing the page_pool destroy
>> process? If not, do you mind if I carry it on based on
>> that?
> 
> Not sure what you mean, this patch is a fix and the destroy
> optimizations where targeted at net-next. Fix goes in first,
> and then after the tree merge on Thu the work in net-next can 
> progress.

Sure, it will be sent as RFC if this patch is not merged to
net-next yet:)

