Return-Path: <netdev+bounces-4947-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A7F6B70F541
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 13:29:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A4739280F4A
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 11:29:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CF4771774F;
	Wed, 24 May 2023 11:29:45 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 778A68472;
	Wed, 24 May 2023 11:29:45 +0000 (UTC)
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A57212F;
	Wed, 24 May 2023 04:29:38 -0700 (PDT)
Received: from dggpemm500005.china.huawei.com (unknown [172.30.72.57])
	by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4QR85q6vXszLq5p;
	Wed, 24 May 2023 19:26:39 +0800 (CST)
Received: from [10.69.30.204] (10.69.30.204) by dggpemm500005.china.huawei.com
 (7.185.36.74) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.23; Wed, 24 May
 2023 19:29:35 +0800
Subject: Re: mlx5 XDP redirect leaking memory on kernel 6.3
From: Yunsheng Lin <linyunsheng@huawei.com>
To: Dragos Tatulea <dtatulea@nvidia.com>, Tariq Toukan <tariqt@nvidia.com>,
	"ttoukan.linux@gmail.com" <ttoukan.linux@gmail.com>, "jbrouer@redhat.com"
	<jbrouer@redhat.com>, Saeed Mahameed <saeedm@nvidia.com>, "saeed@kernel.org"
	<saeed@kernel.org>, "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC: "maxtram95@gmail.com" <maxtram95@gmail.com>, "lorenzo@kernel.org"
	<lorenzo@kernel.org>, "alexander.duyck@gmail.com"
	<alexander.duyck@gmail.com>, "kheib@redhat.com" <kheib@redhat.com>,
	"ilias.apalodimas@linaro.org" <ilias.apalodimas@linaro.org>,
	"mkabat@redhat.com" <mkabat@redhat.com>, "brouer@redhat.com"
	<brouer@redhat.com>, "atzin@redhat.com" <atzin@redhat.com>,
	"fmaurer@redhat.com" <fmaurer@redhat.com>, "bpf@vger.kernel.org"
	<bpf@vger.kernel.org>, "jbenc@redhat.com" <jbenc@redhat.com>
References: <d862a131-5e31-bd26-84f7-fd8764ca9d48@redhat.com>
 <00ca7beb7fe054a3ba1a36c61c1e3b1314369f11.camel@nvidia.com>
 <7a0bd108-ba00-add9-a244-02a6c3cb64df@huawei.com>
Message-ID: <da846559-4093-e8cf-9a99-218953f50b3c@huawei.com>
Date: Wed, 24 May 2023 19:29:35 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.0
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <7a0bd108-ba00-add9-a244-02a6c3cb64df@huawei.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.69.30.204]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 dggpemm500005.china.huawei.com (7.185.36.74)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,NICE_REPLY_A,
	RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 2023/5/24 19:26, Yunsheng Lin wrote:
>> On XDP redirect and tx, the page is set to skip the bias counter release with
>> the expectation that page_pool_put_defragged_page will be called from [1]. But,
> 
> page_pool_put_defragged_page() can only be called when there is only user using

only *one* user

> the page, I am not sure how it can ensure that yet.
> 

