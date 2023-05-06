Return-Path: <netdev+bounces-672-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 235016F8E24
	for <lists+netdev@lfdr.de>; Sat,  6 May 2023 04:54:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 52A9B1C21AF0
	for <lists+netdev@lfdr.de>; Sat,  6 May 2023 02:54:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B187CED8;
	Sat,  6 May 2023 02:54:19 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D9A77E
	for <netdev@vger.kernel.org>; Sat,  6 May 2023 02:54:19 +0000 (UTC)
Received: from out30-130.freemail.mail.aliyun.com (out30-130.freemail.mail.aliyun.com [115.124.30.130])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A7547AAB;
	Fri,  5 May 2023 19:54:17 -0700 (PDT)
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R101e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018045192;MF=xuanzhuo@linux.alibaba.com;NM=1;PH=DS;RN=12;SR=0;TI=SMTPD_---0VhrbjLx_1683341652;
Received: from localhost(mailfrom:xuanzhuo@linux.alibaba.com fp:SMTPD_---0VhrbjLx_1683341652)
          by smtp.aliyun-inc.com;
          Sat, 06 May 2023 10:54:13 +0800
Message-ID: <1683341417.0965195-4-xuanzhuo@linux.alibaba.com>
Subject: Re: [PATCH] virtio_net: set default mtu to 1500 when 'Device maximum MTU' bigger than 1500
Date: Sat, 6 May 2023 10:50:17 +0800
From: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
To: Hao Chen <chenh@yusur.tech>
Cc: huangml@yusur.tech,
 zy@yusur.tech,
 "Michael S. Tsirkin" <mst@redhat.com>,
 Jason Wang <jasowang@redhat.com>,
 "David S. Miller" <davem@davemloft.net>,
 Eric Dumazet <edumazet@google.com>,
 Jakub Kicinski <kuba@kernel.org>,
 Paolo Abeni <pabeni@redhat.com>,
 virtualization@lists.linux-foundation.org (open list:VIRTIO CORE AND NET DRIVERS),
 netdev@vger.kernel.org (open list:NETWORKING DRIVERS),
 linux-kernel@vger.kernel.org (open list)
References: <20230506021529.396812-1-chenh@yusur.tech>
In-Reply-To: <20230506021529.396812-1-chenh@yusur.tech>
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
	ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY,
	USER_IN_DEF_SPF_WL autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>

On Sat,  6 May 2023 10:15:29 +0800, Hao Chen <chenh@yusur.tech> wrote:
> When VIRTIO_NET_F_MTU(3) Device maximum MTU reporting is supported.
> If offered by the device, device advises driver about the value of its
> maximum MTU. If negotiated, the driver uses mtu as the maximum
> MTU value. But there the driver also uses it as default mtu,
> some devices may have a maximum MTU greater than 1500, this may
> cause some large packages to be discarded,

You mean tx packet?

If yes, I do not think this is the problem of driver.

Maybe you should give more details about the discard.

> so I changed the MTU to a more
> general 1500 when 'Device maximum MTU' bigger than 1500.
>
> Signed-off-by: Hao Chen <chenh@yusur.tech>
> ---
>  drivers/net/virtio_net.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> index 8d8038538fc4..e71c7d1b5f29 100644
> --- a/drivers/net/virtio_net.c
> +++ b/drivers/net/virtio_net.c
> @@ -4040,7 +4040,10 @@ static int virtnet_probe(struct virtio_device *vdev)
>  			goto free;
>  		}
>
> -		dev->mtu = mtu;
> +		if (mtu > 1500)

s/1500/ETH_DATA_LEN/

Thanks.

> +			dev->mtu = 1500;
> +		else
> +			dev->mtu = mtu;
>  		dev->max_mtu = mtu;
>  	}
>
> --
> 2.27.0
>

