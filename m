Return-Path: <netdev+bounces-4592-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 72F2470D708
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 10:17:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3AFA11C208CC
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 08:17:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 15B071DDF6;
	Tue, 23 May 2023 08:17:03 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04CEC1D2BF
	for <netdev@vger.kernel.org>; Tue, 23 May 2023 08:17:02 +0000 (UTC)
Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E1A21701;
	Tue, 23 May 2023 01:17:00 -0700 (PDT)
Received: from dggpemm500005.china.huawei.com (unknown [172.30.72.57])
	by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4QQRrG6JSjz18LfT;
	Tue, 23 May 2023 16:12:30 +0800 (CST)
Received: from [10.69.30.204] (10.69.30.204) by dggpemm500005.china.huawei.com
 (7.185.36.74) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.23; Tue, 23 May
 2023 16:16:58 +0800
Subject: Re: [PATCH net] page_pool: fix inconsistency for
 page_pool_ring_[un]lock()
To: Jesper Dangaard Brouer <jbrouer@redhat.com>, Ilias Apalodimas
	<ilias.apalodimas@linaro.org>
CC: <brouer@redhat.com>, <davem@davemloft.net>, <kuba@kernel.org>,
	<pabeni@redhat.com>, <netdev@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, Jesper Dangaard Brouer <hawk@kernel.org>,
	Eric Dumazet <edumazet@google.com>, Lorenzo Bianconi <lorenzo@kernel.org>,
	Daniel Borkmann <daniel@iogearbox.net>, John Fastabend
	<john.fastabend@gmail.com>
References: <20230522031714.5089-1-linyunsheng@huawei.com>
 <1fc46094-a72a-f7e4-ef18-15edb0d56233@redhat.com>
 <CAC_iWjJaNuDFZuv1Rv4Yr5Kaj1Wq69txAoLGepvnJT=pY1gaRw@mail.gmail.com>
 <cc64a349-aaf4-9d80-3653-75eeb3032baf@huawei.com>
 <c6c44d10-d283-7a26-8597-6be6e29bc832@redhat.com>
From: Yunsheng Lin <linyunsheng@huawei.com>
Message-ID: <c475a980-50fb-e966-80a0-d9ccca9435d4@huawei.com>
Date: Tue, 23 May 2023 16:16:58 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.0
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <c6c44d10-d283-7a26-8597-6be6e29bc832@redhat.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.69.30.204]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 dggpemm500005.china.huawei.com (7.185.36.74)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,NICE_REPLY_A,
	RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 2023/5/23 15:08, Jesper Dangaard Brouer wrote:
 > On 23/05/2023 04.13, Yunsheng Lin wrote:
>> Do you still working on optimizing the page_pool destroy
>> process? If not, do you mind if I carry it on based on
>> that?
> 
> I'm still working on improving the page_pool destroy process.
> I prefer to do the implementation myself.

Sure, let me know if you want a hand for that.

> 
> I've not submitted another version, because I'm currently using the
> workqueue to detect/track a memory leak in mlx5.
> 
> The mlx5 driver combined with XDP redirect is leaking memory, and will
> eventually lead to OOM.  The workqueue warning doesn't point to the
> actual problem, but it makes is easier to notice that there is a problem.
> 
> --Jesper
> 
> .
> 

