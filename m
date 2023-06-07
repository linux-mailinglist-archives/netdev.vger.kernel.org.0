Return-Path: <netdev+bounces-8791-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id CC2E8725D0F
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 13:27:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 19AB52812B8
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 11:27:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 837021119B;
	Wed,  7 Jun 2023 11:27:52 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 765956AB7
	for <netdev@vger.kernel.org>; Wed,  7 Jun 2023 11:27:52 +0000 (UTC)
Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48FBF1BC2;
	Wed,  7 Jun 2023 04:27:48 -0700 (PDT)
Received: from dggpemm500005.china.huawei.com (unknown [172.30.72.55])
	by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4QblQg3kQQzlXFj;
	Wed,  7 Jun 2023 19:26:03 +0800 (CST)
Received: from [10.67.102.37] (10.67.102.37) by dggpemm500005.china.huawei.com
 (7.185.36.74) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.23; Wed, 7 Jun
 2023 19:27:46 +0800
Subject: Re: [PATCH net v2] net: renesas: rswitch: Fix timestamp feature after
 all descriptors are used
To: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>, <s.shtylyov@omp.ru>,
	<davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
	<pabeni@redhat.com>
References: <20230607070141.1795982-1-yoshihiro.shimoda.uh@renesas.com>
CC: <netdev@vger.kernel.org>, <linux-renesas-soc@vger.kernel.org>, Phong Hoang
	<phong.hoang.wz@renesas.com>
From: Hao Lan <lanhao@huawei.com>
Message-ID: <1df24847-6523-12df-2cba-f51412463347@huawei.com>
Date: Wed, 7 Jun 2023 19:27:46 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.7.1
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20230607070141.1795982-1-yoshihiro.shimoda.uh@renesas.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.67.102.37]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 dggpemm500005.china.huawei.com (7.185.36.74)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,NICE_REPLY_A,
	RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net



On 2023/6/7 15:01, Yoshihiro Shimoda wrote:
> diff --git a/drivers/net/ethernet/renesas/rswitch.c b/drivers/net/ethernet/renesas/rswitch.c
> index aace87139cea..049adbf5a642 100644
> --- a/drivers/net/ethernet/renesas/rswitch.c
> +++ b/drivers/net/ethernet/renesas/rswitch.c
> @@ -420,7 +420,7 @@ static int rswitch_gwca_queue_format(struct net_device *ndev,
>  }
>  
>  static void rswitch_gwca_ts_queue_fill(struct rswitch_private *priv,
> -				       int start_index, int num)
> +				       int start_index, int num, bool last)
>  {
>  	struct rswitch_gwca_queue *gq = &priv->gwca.ts_queue;
>  	struct rswitch_ts_desc *desc;
> @@ -431,6 +431,12 @@ static void rswitch_gwca_ts_queue_fill(struct rswitch_private *priv,
>  		desc = &gq->ts_ring[index];
>  		desc->desc.die_dt = DT_FEMPTY_ND | DIE;
>  	}
> +
> +	if (last) {
> +		desc = &gq->ts_ring[gq->ring_size];
> +		rswitch_desc_set_dptr(&desc->desc, gq->ring_dma);
> +		desc->desc.die_dt = DT_LINKFIX;
> +	}
>  }
>  
Hello Yoshihiro Shimoda，

Does your function set the last descriptor to hardware on initialization, but not at other times?
I think rswitch_gwca_ts_queue_fill should be implemented in a separate function,
not use the 'last' distinguish the last descriptor.
But if it should be setting every cycle, I think rswitch_gwca_queue_ext_ts_fill should
check if the descriptor is the last in the queue and set the LINKFIX flag.

>  static int rswitch_gwca_queue_ext_ts_fill(struct net_device *ndev,
> @@ -941,7 +947,7 @@ static void rswitch_ts(struct rswitch_private *priv)
>  	}
>  
>  	num = rswitch_get_num_cur_queues(gq);
> -	rswitch_gwca_ts_queue_fill(priv, gq->dirty, num);
> +	rswitch_gwca_ts_queue_fill(priv, gq->dirty, num, false);
>  	gq->dirty = rswitch_next_queue_index(gq, false, num);
>  }
>  
> @@ -1780,7 +1786,7 @@ static int rswitch_init(struct rswitch_private *priv)
>  	if (err < 0)
>  		goto err_ts_queue_alloc;
>  
> -	rswitch_gwca_ts_queue_fill(priv, 0, TS_RING_SIZE);
> +	rswitch_gwca_ts_queue_fill(priv, 0, TS_RING_SIZE, true);
>  	INIT_LIST_HEAD(&priv->gwca.ts_info_list);
>  
>  	for (i = 0; i < RSWITCH_NUM_PORTS; i++) {
> 

