Return-Path: <netdev+bounces-8252-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 443A37234DE
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 03:51:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 64B5D1C20DCB
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 01:51:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2A926388;
	Tue,  6 Jun 2023 01:51:17 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DB757F
	for <netdev@vger.kernel.org>; Tue,  6 Jun 2023 01:51:16 +0000 (UTC)
Received: from out30-113.freemail.mail.aliyun.com (out30-113.freemail.mail.aliyun.com [115.124.30.113])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 226A610C1;
	Mon,  5 Jun 2023 18:50:49 -0700 (PDT)
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R151e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018046059;MF=xuanzhuo@linux.alibaba.com;NM=1;PH=DS;RN=14;SR=0;TI=SMTPD_---0VkU73yf_1686016221;
Received: from localhost(mailfrom:xuanzhuo@linux.alibaba.com fp:SMTPD_---0VkU73yf_1686016221)
          by smtp.aliyun-inc.com;
          Tue, 06 Jun 2023 09:50:22 +0800
Message-ID: <1686016211.426338-1-xuanzhuo@linux.alibaba.com>
Subject: Re: [PATCH net] virtio_net: use control_buf for coalesce params
Date: Tue, 6 Jun 2023 09:50:11 +0800
From: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
To: Brett Creeley <brett.creeley@amd.com>
Cc: <brett.creeley@amd.com>,
 <shannon.nelson@amd.com>,
 <allen.hubbe@amd.com>,
 <linux-kernel@vger.kernel.org>,
 <netdev@vger.kernel.org>,
 <virtualization@lists.linux-foundation.org>,
 <alvaro.karsz@solid-run.com>,
 <pabeni@redhat.com>,
 <kuba@kernel.org>,
 <edumazet@google.com>,
 <davem@davemloft.net>,
 <xuanzhuo@linux.alibaba.com>,
 <jasowang@redhat.com>,
 <mst@redhat.com>
References: <20230605195925.51625-1-brett.creeley@amd.com>
In-Reply-To: <20230605195925.51625-1-brett.creeley@amd.com>
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
	ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>

On Mon, 5 Jun 2023 12:59:25 -0700, Brett Creeley <brett.creeley@amd.com> wrote:
> Commit 699b045a8e43 ("net: virtio_net: notifications coalescing
> support") added coalescing command support for virtio_net. However,
> the coalesce commands are using buffers on the stack, which is causing
> the device to see DMA errors. There should also be a complaint from
> check_for_stack() in debug_dma_map_xyz(). Fix this by adding and using
> coalesce params from the control_buf struct, which aligns with other
> commands.
>
> Fixes: 699b045a8e43 ("net: virtio_net: notifications coalescing support")
> Reviewed-by: Shannon Nelson <shannon.nelson@amd.com>
> Signed-off-by: Allen Hubbe <allen.hubbe@amd.com>
> Signed-off-by: Brett Creeley <brett.creeley@amd.com>

Reviewed-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>

Thanks.

> ---
>  drivers/net/virtio_net.c | 16 ++++++++--------
>  1 file changed, 8 insertions(+), 8 deletions(-)
>
> diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> index 56ca1d270304..486b5849033d 100644
> --- a/drivers/net/virtio_net.c
> +++ b/drivers/net/virtio_net.c
> @@ -205,6 +205,8 @@ struct control_buf {
>  	__virtio16 vid;
>  	__virtio64 offloads;
>  	struct virtio_net_ctrl_rss rss;
> +	struct virtio_net_ctrl_coal_tx coal_tx;
> +	struct virtio_net_ctrl_coal_rx coal_rx;
>  };
>
>  struct virtnet_info {
> @@ -2934,12 +2936,10 @@ static int virtnet_send_notf_coal_cmds(struct virtnet_info *vi,
>  				       struct ethtool_coalesce *ec)
>  {
>  	struct scatterlist sgs_tx, sgs_rx;
> -	struct virtio_net_ctrl_coal_tx coal_tx;
> -	struct virtio_net_ctrl_coal_rx coal_rx;
>
> -	coal_tx.tx_usecs = cpu_to_le32(ec->tx_coalesce_usecs);
> -	coal_tx.tx_max_packets = cpu_to_le32(ec->tx_max_coalesced_frames);
> -	sg_init_one(&sgs_tx, &coal_tx, sizeof(coal_tx));
> +	vi->ctrl->coal_tx.tx_usecs = cpu_to_le32(ec->tx_coalesce_usecs);
> +	vi->ctrl->coal_tx.tx_max_packets = cpu_to_le32(ec->tx_max_coalesced_frames);
> +	sg_init_one(&sgs_tx, &vi->ctrl->coal_tx, sizeof(vi->ctrl->coal_tx));
>
>  	if (!virtnet_send_command(vi, VIRTIO_NET_CTRL_NOTF_COAL,
>  				  VIRTIO_NET_CTRL_NOTF_COAL_TX_SET,
> @@ -2950,9 +2950,9 @@ static int virtnet_send_notf_coal_cmds(struct virtnet_info *vi,
>  	vi->tx_usecs = ec->tx_coalesce_usecs;
>  	vi->tx_max_packets = ec->tx_max_coalesced_frames;
>
> -	coal_rx.rx_usecs = cpu_to_le32(ec->rx_coalesce_usecs);
> -	coal_rx.rx_max_packets = cpu_to_le32(ec->rx_max_coalesced_frames);
> -	sg_init_one(&sgs_rx, &coal_rx, sizeof(coal_rx));
> +	vi->ctrl->coal_rx.rx_usecs = cpu_to_le32(ec->rx_coalesce_usecs);
> +	vi->ctrl->coal_rx.rx_max_packets = cpu_to_le32(ec->rx_max_coalesced_frames);
> +	sg_init_one(&sgs_rx, &vi->ctrl->coal_rx, sizeof(vi->ctrl->coal_rx));
>
>  	if (!virtnet_send_command(vi, VIRTIO_NET_CTRL_NOTF_COAL,
>  				  VIRTIO_NET_CTRL_NOTF_COAL_RX_SET,
> --
> 2.17.1
>

