Return-Path: <netdev+bounces-1295-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 59AD56FD353
	for <lists+netdev@lfdr.de>; Wed, 10 May 2023 02:39:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1E77428131E
	for <lists+netdev@lfdr.de>; Wed, 10 May 2023 00:39:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4FFA5374;
	Wed, 10 May 2023 00:39:39 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E03B362
	for <netdev@vger.kernel.org>; Wed, 10 May 2023 00:39:39 +0000 (UTC)
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B799840D9
	for <netdev@vger.kernel.org>; Tue,  9 May 2023 17:39:35 -0700 (PDT)
Received: from dggpemm500005.china.huawei.com (unknown [172.30.72.57])
	by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4QGGLL3b1yzLpjD;
	Wed, 10 May 2023 08:36:42 +0800 (CST)
Received: from [10.69.30.204] (10.69.30.204) by dggpemm500005.china.huawei.com
 (7.185.36.74) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.23; Wed, 10 May
 2023 08:39:32 +0800
Subject: Re: [PATCH net-next v1 1/2] net: introduce and use
 skb_frag_fill_page_desc()
To: Paolo Abeni <pabeni@redhat.com>, Igor Russkikh <irusskikh@marvell.com>,
	"David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Michael Chan <michael.chan@broadcom.com>,
	Raju Rangoju <rajur@chelsio.com>, Ajit Khaparde <ajit.khaparde@broadcom.com>,
	Sriharsha Basavapatna <sriharsha.basavapatna@broadcom.com>, Somnath Kotur
	<somnath.kotur@broadcom.com>, Claudiu Manoil <claudiu.manoil@nxp.com>,
	Dimitris Michailidis <dmichail@fungible.com>, Thomas Petazzoni
	<thomas.petazzoni@bootlin.com>, Saeed Mahameed <saeedm@nvidia.com>, Leon
 Romanovsky <leon@kernel.org>, "Michael S. Tsirkin" <mst@redhat.com>, Jason
 Wang <jasowang@redhat.com>, Ronak Doshi <doshir@vmware.com>, VMware
 PV-Drivers Reviewers <pv-drivers@vmware.com>, Wei Liu <wei.liu@kernel.org>,
	Paul Durrant <paul@xen.org>, Alexei Starovoitov <ast@kernel.org>, Daniel
 Borkmann <daniel@iogearbox.net>, Andrii Nakryiko <andrii@kernel.org>, Martin
 KaFai Lau <martin.lau@linux.dev>, Song Liu <song@kernel.org>, Yonghong Song
	<yhs@fb.com>, John Fastabend <john.fastabend@gmail.com>, KP Singh
	<kpsingh@kernel.org>, Stanislav Fomichev <sdf@google.com>, Hao Luo
	<haoluo@google.com>, Jiri Olsa <jolsa@kernel.org>, Boris Pismenny
	<borisp@nvidia.com>, Steffen Klassert <steffen.klassert@secunet.com>, Herbert
 Xu <herbert@gondor.apana.org.au>
CC: <simon.horman@corigine.com>, "netdev@vger.kernel.org"
	<netdev@vger.kernel.org>
References: <20230509092656.20308-1-linyunsheng@huawei.com>
 <20230509092656.20308-2-linyunsheng@huawei.com>
 <d0fdd0bb9a1855910217e6b658506cd21ac6edfa.camel@redhat.com>
From: Yunsheng Lin <linyunsheng@huawei.com>
Message-ID: <198376b3-e515-28db-97a1-20e8905ac935@huawei.com>
Date: Wed, 10 May 2023 08:39:31 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.0
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <d0fdd0bb9a1855910217e6b658506cd21ac6edfa.camel@redhat.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.69.30.204]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 dggpemm500005.china.huawei.com (7.185.36.74)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,NICE_REPLY_A,
	RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 2023/5/9 18:07, Paolo Abeni wrote:
> On Tue, 2023-05-09 at 17:26 +0800, Yunsheng Lin wrote:
>> Most users use __skb_frag_set_page()/skb_frag_off_set()/
>> skb_frag_size_set() to fill the page desc for a skb frag.
>>
>> Introduce skb_frag_fill_page_desc() to do that.
>>
>> net/bpf/test_run.c does not call skb_frag_off_set() to
>> set the offset, "copy_from_user(page_address(page), ...)"
>> suggest that it is assuming offset to be initialized as
>> zero, so call skb_frag_fill_page_desc() with offset being
>> zero for this case.
>>
>> Also, skb_frag_set_page() is not used anymore, so remove
>> it.
>>
>> Signed-off-by: Yunsheng Lin <linyunsheng@huawei.com>
> 
> The recipients list is very long, but you forgot to include the most
> relevant one: the netdev ML.

Thanks for the remainding.

> 
> Probably it's worth splitting this patch in a series with individual
> patches touching the net core and the specific device drivers, to that
> you could CC only the relevant recipients on each patch.

I was debugging the send_mail stript to see why the netdev ML was not
included, and ended up sending a few copy of this patchset forgeting
to use '--dry-run' option.

As there is a few Reviewed-by tags from community now, splitting this patch
might need to drop some Reviewed-by tags, which means some patch might
need re-reviewing, I am not sure it is worth splitting considering the
confusion caused by the above mistake.

Please let me know what do you think.
Thanks.

