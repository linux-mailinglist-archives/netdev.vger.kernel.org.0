Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3202E6C0D8D
	for <lists+netdev@lfdr.de>; Mon, 20 Mar 2023 10:42:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230316AbjCTJmW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Mar 2023 05:42:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230045AbjCTJmU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Mar 2023 05:42:20 -0400
Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A45EC149AA;
        Mon, 20 Mar 2023 02:42:18 -0700 (PDT)
Received: from dggpemm500005.china.huawei.com (unknown [172.30.72.57])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4Pg8s050zjz9tVH;
        Mon, 20 Mar 2023 17:41:56 +0800 (CST)
Received: from [10.69.30.204] (10.69.30.204) by dggpemm500005.china.huawei.com
 (7.185.36.74) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.21; Mon, 20 Mar
 2023 17:42:16 +0800
Subject: Re: [PATCH net-next] net: mana: Add support for jumbo frame
To:     Haiyang Zhang <haiyangz@microsoft.com>,
        <linux-hyperv@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     <decui@microsoft.com>, <kys@microsoft.com>,
        <paulros@microsoft.com>, <olaf@aepfle.de>, <vkuznets@redhat.com>,
        <davem@davemloft.net>, <wei.liu@kernel.org>, <edumazet@google.com>,
        <kuba@kernel.org>, <pabeni@redhat.com>, <leon@kernel.org>,
        <longli@microsoft.com>, <ssengar@linux.microsoft.com>,
        <linux-kernel@vger.kernel.org>
References: <1679261264-26375-1-git-send-email-haiyangz@microsoft.com>
From:   Yunsheng Lin <linyunsheng@huawei.com>
Message-ID: <fb5abef7-8f52-007b-f058-85f580aefc88@huawei.com>
Date:   Mon, 20 Mar 2023 17:42:15 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.0
MIME-Version: 1.0
In-Reply-To: <1679261264-26375-1-git-send-email-haiyangz@microsoft.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.69.30.204]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 dggpemm500005.china.huawei.com (7.185.36.74)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2023/3/20 5:27, Haiyang Zhang wrote:
> During probe, get the hardware allowed max MTU by querying the device
> configuration. Users can select MTU up to the device limit. Also,
> when XDP is in use, we currently limit the buffer size to one page.
> 
> Updated RX data path to allocate and use RX queue DMA buffers with
> proper size based on the MTU setting.

The change in this patch seems better to splitted into more reviewable
patchset. Perhaps refactor the RX queue DMA buffers allocation to handle
different size first, then add support for the jumbo frame.

> 
> Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
> ---
>  .../net/ethernet/microsoft/mana/mana_bpf.c    |  22 +-
>  drivers/net/ethernet/microsoft/mana/mana_en.c | 229 ++++++++++++------
>  include/net/mana/gdma.h                       |   4 +
>  include/net/mana/mana.h                       |  18 +-
>  4 files changed, 183 insertions(+), 90 deletions(-)
> 
> diff --git a/drivers/net/ethernet/microsoft/mana/mana_bpf.c b/drivers/net/ethernet/microsoft/mana/mana_bpf.c
> index 3caea631229c..23b1521c0df9 100644
> --- a/drivers/net/ethernet/microsoft/mana/mana_bpf.c
> +++ b/drivers/net/ethernet/microsoft/mana/mana_bpf.c
> @@ -133,12 +133,6 @@ u32 mana_run_xdp(struct net_device *ndev, struct mana_rxq *rxq,
>  	return act;
>  }
>  
> -static unsigned int mana_xdp_fraglen(unsigned int len)
> -{
> -	return SKB_DATA_ALIGN(len) +
> -	       SKB_DATA_ALIGN(sizeof(struct skb_shared_info));
> -}
> -
>  struct bpf_prog *mana_xdp_get(struct mana_port_context *apc)
>  {
>  	ASSERT_RTNL();
> @@ -179,17 +173,18 @@ static int mana_xdp_set(struct net_device *ndev, struct bpf_prog *prog,
>  {
>  	struct mana_port_context *apc = netdev_priv(ndev);
>  	struct bpf_prog *old_prog;
> -	int buf_max;
> +	struct gdma_context *gc;
> +
> +	gc = apc->ac->gdma_dev->gdma_context;
>  
>  	old_prog = mana_xdp_get(apc);
>  
>  	if (!old_prog && !prog)
>  		return 0;
>  
> -	buf_max = XDP_PACKET_HEADROOM + mana_xdp_fraglen(ndev->mtu + ETH_HLEN);
> -	if (prog && buf_max > PAGE_SIZE) {
> -		netdev_err(ndev, "XDP: mtu:%u too large, buf_max:%u\n",
> -			   ndev->mtu, buf_max);
> +	if (prog && ndev->mtu > MANA_XDP_MTU_MAX) {
> +		netdev_err(ndev, "XDP: mtu:%u too large, mtu_max:%lu\n",
> +			   ndev->mtu, MANA_XDP_MTU_MAX);
>  		NL_SET_ERR_MSG_MOD(extack, "XDP: mtu too large");
>  
>  		return -EOPNOTSUPP;
> @@ -206,6 +201,11 @@ static int mana_xdp_set(struct net_device *ndev, struct bpf_prog *prog,
>  	if (apc->port_is_up)
>  		mana_chn_setxdp(apc, prog);
>  
> +	if (prog)
> +		ndev->max_mtu = MANA_XDP_MTU_MAX;
> +	else
> +		ndev->max_mtu = gc->adapter_mtu - ETH_HLEN;
> +
>  	return 0;
>  }
>  
> diff --git a/drivers/net/ethernet/microsoft/mana/mana_en.c b/drivers/net/ethernet/microsoft/mana/mana_en.c
> index 492474b4d8aa..07738b7e85f2 100644
> --- a/drivers/net/ethernet/microsoft/mana/mana_en.c
> +++ b/drivers/net/ethernet/microsoft/mana/mana_en.c
> @@ -427,6 +427,34 @@ static u16 mana_select_queue(struct net_device *ndev, struct sk_buff *skb,
>  	return txq;
>  }
>  
> +static int mana_change_mtu(struct net_device *ndev, int new_mtu)
> +{
> +	unsigned int old_mtu = ndev->mtu;
> +	int err, err2;
> +
> +	err = mana_detach(ndev, false);
> +	if (err) {
> +		netdev_err(ndev, "mana_detach failed: %d\n", err);
> +		return err;
> +	}
> +
> +	ndev->mtu = new_mtu;
> +
> +	err = mana_attach(ndev);
> +	if (!err)
> +		return 0;
> +
> +	netdev_err(ndev, "mana_attach failed: %d\n", err);
> +
> +	/* Try to roll it back to the old configuration. */
> +	ndev->mtu = old_mtu;
> +	err2 = mana_attach(ndev);
> +	if (err2)
> +		netdev_err(ndev, "mana re-attach failed: %d\n", err2);
> +
> +	return err;
> +}
> +
>  static const struct net_device_ops mana_devops = {
>  	.ndo_open		= mana_open,
>  	.ndo_stop		= mana_close,
> @@ -436,6 +464,7 @@ static const struct net_device_ops mana_devops = {
>  	.ndo_get_stats64	= mana_get_stats64,
>  	.ndo_bpf		= mana_bpf,
>  	.ndo_xdp_xmit		= mana_xdp_xmit,
> +	.ndo_change_mtu		= mana_change_mtu,
>  };
>  
>  static void mana_cleanup_port_context(struct mana_port_context *apc)
> @@ -625,6 +654,9 @@ static int mana_query_device_cfg(struct mana_context *ac, u32 proto_major_ver,
>  
>  	mana_gd_init_req_hdr(&req.hdr, MANA_QUERY_DEV_CONFIG,
>  			     sizeof(req), sizeof(resp));
> +
> +	req.hdr.resp.msg_version = GDMA_MESSAGE_V2;

hdr->req.msg_version and hdr->resp.msg_version are both set to
GDMA_MESSAGE_V1 in mana_gd_init_req_hdr(), is there any reason
why hdr->req.msg_version is not set to GDMA_MESSAGE_V2?
Does initializing req.hdr.resp.msg_version to GDMA_MESSAGE_V2
in mana_gd_init_req_hdr() without reset it to GDMA_MESSAGE_V2
in mana_query_device_cfg() affect other user?


> +
>  	req.proto_major_ver = proto_major_ver;
>  	req.proto_minor_ver = proto_minor_ver;
>  	req.proto_micro_ver = proto_micro_ver;
> @@ -647,6 +679,11 @@ static int mana_query_device_cfg(struct mana_context *ac, u32 proto_major_ver,
>  
>  	*max_num_vports = resp.max_num_vports;
>  
> +	if (resp.hdr.response.msg_version == GDMA_MESSAGE_V2)

It seems the driver is setting resp.hdr.response.msg_version to
GDMA_MESSAGE_V2 above, and do the checking here. Does older
firmware reset the resp.hdr.response.msg_version to GDMA_MESSAGE_V1
in order to enable compatibility between firmware and driver?

> +		gc->adapter_mtu = resp.adapter_mtu;
> +	else
> +		gc->adapter_mtu = ETH_FRAME_LEN;
> +
>  	return 0;
>  }
>  
> @@ -1185,10 +1222,10 @@ static void mana_post_pkt_rxq(struct mana_rxq *rxq)
>  	WARN_ON_ONCE(recv_buf_oob->wqe_inf.wqe_size_in_bu != 1);
>  }
>  
> -static struct sk_buff *mana_build_skb(void *buf_va, uint pkt_len,
> -				      struct xdp_buff *xdp)
> +static struct sk_buff *mana_build_skb(struct mana_rxq *rxq, void *buf_va,
> +				      uint pkt_len, struct xdp_buff *xdp)
>  {
> -	struct sk_buff *skb = build_skb(buf_va, PAGE_SIZE);
> +	struct sk_buff *skb = napi_build_skb(buf_va, rxq->alloc_size);

Changing build_skb() to napi_build_skb() seems like an optimization
unrelated to jumbo frame support, seems like another patch to do that?

>  
>  	if (!skb)
>  		return NULL;
> @@ -1196,11 +1233,12 @@ static struct sk_buff *mana_build_skb(void *buf_va, uint pkt_len,
>  	if (xdp->data_hard_start) {
>  		skb_reserve(skb, xdp->data - xdp->data_hard_start);
>  		skb_put(skb, xdp->data_end - xdp->data);
> -	} else {
> -		skb_reserve(skb, XDP_PACKET_HEADROOM);
> -		skb_put(skb, pkt_len);
> +		return skb;
>  	}
>  
> +	skb_reserve(skb, rxq->headroom);
> +	skb_put(skb, pkt_len);
> +
>  	return skb;
>  }
>  
> @@ -1233,7 +1271,7 @@ static void mana_rx_skb(void *buf_va, struct mana_rxcomp_oob *cqe,
>  	if (act != XDP_PASS && act != XDP_TX)
>  		goto drop_xdp;
>  
> -	skb = mana_build_skb(buf_va, pkt_len, &xdp);
> +	skb = mana_build_skb(rxq, buf_va, pkt_len, &xdp);
>  
>  	if (!skb)
>  		goto drop;
> @@ -1282,14 +1320,72 @@ static void mana_rx_skb(void *buf_va, struct mana_rxcomp_oob *cqe,
>  	u64_stats_update_end(&rx_stats->syncp);
>  
>  drop:
> -	WARN_ON_ONCE(rxq->xdp_save_page);
> -	rxq->xdp_save_page = virt_to_page(buf_va);
> +	WARN_ON_ONCE(rxq->xdp_save_va);
> +	/* Save for reuse */
> +	rxq->xdp_save_va = buf_va;
>  
>  	++ndev->stats.rx_dropped;
>  
>  	return;
>  }
>  
