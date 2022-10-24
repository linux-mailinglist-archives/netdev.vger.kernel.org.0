Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 285506097C2
	for <lists+netdev@lfdr.de>; Mon, 24 Oct 2022 03:20:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229887AbiJXBUg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 Oct 2022 21:20:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229634AbiJXBUd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 23 Oct 2022 21:20:33 -0400
Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F89B4DB25;
        Sun, 23 Oct 2022 18:20:31 -0700 (PDT)
Received: from dggpemm500022.china.huawei.com (unknown [172.30.72.53])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4Mwcd52bJhzJn8t;
        Mon, 24 Oct 2022 09:17:45 +0800 (CST)
Received: from dggpemm500005.china.huawei.com (7.185.36.74) by
 dggpemm500022.china.huawei.com (7.185.36.162) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Mon, 24 Oct 2022 09:20:29 +0800
Received: from [10.69.30.204] (10.69.30.204) by dggpemm500005.china.huawei.com
 (7.185.36.74) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Mon, 24 Oct
 2022 09:20:29 +0800
Subject: Re: [Patch v9 03/12] net: mana: Handle vport sharing between devices
To:     <longli@microsoft.com>, "K. Y. Srinivasan" <kys@microsoft.com>,
        "Haiyang Zhang" <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>, Dexuan Cui <decui@microsoft.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Leon Romanovsky <leon@kernel.org>, <edumazet@google.com>,
        <shiraz.saleem@intel.com>, "Ajay Sharma" <sharmaajay@microsoft.com>
CC:     <linux-hyperv@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-rdma@vger.kernel.org>
References: <1666396889-31288-1-git-send-email-longli@linuxonhyperv.com>
 <1666396889-31288-4-git-send-email-longli@linuxonhyperv.com>
From:   Yunsheng Lin <linyunsheng@huawei.com>
Message-ID: <05607c38-7c9f-49df-c6b2-17e35f2ecbbd@huawei.com>
Date:   Mon, 24 Oct 2022 09:20:28 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.0
MIME-Version: 1.0
In-Reply-To: <1666396889-31288-4-git-send-email-longli@linuxonhyperv.com>
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

On 2022/10/22 8:01, longli@linuxonhyperv.com wrote:
> From: Long Li <longli@microsoft.com>
> 
> For outgoing packets, the PF requires the VF to configure the vport with
> corresponding protection domain and doorbell ID for the kernel or user
> context. The vport can't be shared between different contexts.
> 
> Implement the logic to exclusively take over the vport by either the
> Ethernet device or RDMA device.
> 
> Reviewed-by: Dexuan Cui <decui@microsoft.com>
> Signed-off-by: Long Li <longli@microsoft.com>
> Acked-by: Haiyang Zhang <haiyangz@microsoft.com>
> ---
> Change log:
> v2: use refcount instead of directly using atomic variables
> v4: change to mutex to avoid possible race with refcount
> v5: add detailed comments explaining vport sharing, use EXPORT_SYMBOL_NS
> v6: rebased to rdma-next
> 
>  drivers/net/ethernet/microsoft/mana/mana.h    |  7 +++
>  drivers/net/ethernet/microsoft/mana/mana_en.c | 53 ++++++++++++++++++-
>  2 files changed, 58 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/ethernet/microsoft/mana/mana.h b/drivers/net/ethernet/microsoft/mana/mana.h
> index d58be64374c8..2883a08dbfb5 100644
> --- a/drivers/net/ethernet/microsoft/mana/mana.h
> +++ b/drivers/net/ethernet/microsoft/mana/mana.h
> @@ -380,6 +380,10 @@ struct mana_port_context {
>  	mana_handle_t port_handle;
>  	mana_handle_t pf_filter_handle;
>  
> +	/* Mutex for sharing access to vport_use_count */
> +	struct mutex vport_mutex;
> +	int vport_use_count;
> +
>  	u16 port_idx;
>  
>  	bool port_is_up;
> @@ -631,4 +635,7 @@ struct mana_tx_package {
>  	struct gdma_posted_wqe_info wqe_info;
>  };
>  
> +int mana_cfg_vport(struct mana_port_context *apc, u32 protection_dom_id,
> +		   u32 doorbell_pg_id);
> +void mana_uncfg_vport(struct mana_port_context *apc);
>  #endif /* _MANA_H */
> diff --git a/drivers/net/ethernet/microsoft/mana/mana_en.c b/drivers/net/ethernet/microsoft/mana/mana_en.c
> index 8751e475d1ba..efe14a343fd1 100644
> --- a/drivers/net/ethernet/microsoft/mana/mana_en.c
> +++ b/drivers/net/ethernet/microsoft/mana/mana_en.c
> @@ -646,13 +646,48 @@ static int mana_query_vport_cfg(struct mana_port_context *apc, u32 vport_index,
>  	return 0;
>  }
>  
> -static int mana_cfg_vport(struct mana_port_context *apc, u32 protection_dom_id,
> -			  u32 doorbell_pg_id)
> +void mana_uncfg_vport(struct mana_port_context *apc)
> +{
> +	mutex_lock(&apc->vport_mutex);
> +	apc->vport_use_count--;
> +	WARN_ON(apc->vport_use_count < 0);
> +	mutex_unlock(&apc->vport_mutex);
> +}
> +EXPORT_SYMBOL_NS(mana_uncfg_vport, NET_MANA);
> +
> +int mana_cfg_vport(struct mana_port_context *apc, u32 protection_dom_id,
> +		   u32 doorbell_pg_id)
>  {
>  	struct mana_config_vport_resp resp = {};
>  	struct mana_config_vport_req req = {};
>  	int err;
>  
> +	/* This function is used to program the Ethernet port in the hardware
> +	 * table. It can be called from the Ethernet driver or the RDMA driver.
> +	 *
> +	 * For Ethernet usage, the hardware supports only one active user on a
> +	 * physical port. The driver checks on the port usage before programming
> +	 * the hardware when creating the RAW QP (RDMA driver) or exposing the
> +	 * device to kernel NET layer (Ethernet driver).
> +	 *
> +	 * Because the RDMA driver doesn't know in advance which QP type the
> +	 * user will create, it exposes the device with all its ports. The user
> +	 * may not be able to create RAW QP on a port if this port is already
> +	 * in used by the Ethernet driver from the kernel.
> +	 *
> +	 * This physical port limitation only applies to the RAW QP. For RC QP,
> +	 * the hardware doesn't have this limitation. The user can create RC
> +	 * QPs on a physical port up to the hardware limits independent of the
> +	 * Ethernet usage on the same port.
> +	 */
> +	mutex_lock(&apc->vport_mutex);
> +	if (apc->vport_use_count > 0) {
> +		mutex_unlock(&apc->vport_mutex);
> +		return -EBUSY;
> +	}
> +	apc->vport_use_count++;
> +	mutex_unlock(&apc->vport_mutex);
> +
>  	mana_gd_init_req_hdr(&req.hdr, MANA_CONFIG_VPORT_TX,
>  			     sizeof(req), sizeof(resp));
>  	req.vport = apc->port_handle;
> @@ -679,9 +714,16 @@ static int mana_cfg_vport(struct mana_port_context *apc, u32 protection_dom_id,
>  
>  	apc->tx_shortform_allowed = resp.short_form_allowed;
>  	apc->tx_vp_offset = resp.tx_vport_offset;
> +
> +	netdev_info(apc->ndev, "Configured vPort %llu PD %u DB %u\n",
> +		    apc->port_handle, protection_dom_id, doorbell_pg_id);
>  out:
> +	if (err)
> +		mana_uncfg_vport(apc);

There seems to be a similar race between error handling here and the
"apc->vport_use_count > 0" checking above as pointed out in v7.

> +
>  	return err;
>  }
> +EXPORT_SYMBOL_NS(mana_cfg_vport, NET_MANA);
>  
>  static int mana_cfg_vport_steering(struct mana_port_context *apc,
>  				   enum TRI_STATE rx,
> @@ -742,6 +784,9 @@ static int mana_cfg_vport_steering(struct mana_port_context *apc,
>  			   resp.hdr.status);
>  		err = -EPROTO;
>  	}
> +
> +	netdev_info(ndev, "Configured steering vPort %llu entries %u\n",
> +		    apc->port_handle, num_entries);
>  out:
>  	kfree(req);
>  	return err;
> @@ -1804,6 +1849,7 @@ static void mana_destroy_vport(struct mana_port_context *apc)
>  	}
>  
>  	mana_destroy_txq(apc);
> +	mana_uncfg_vport(apc);
>  
>  	if (gd->gdma_context->is_pf)
>  		mana_pf_deregister_hw_vport(apc);
> @@ -2076,6 +2122,9 @@ static int mana_probe_port(struct mana_context *ac, int port_idx,
>  	apc->pf_filter_handle = INVALID_MANA_HANDLE;
>  	apc->port_idx = port_idx;
>  
> +	mutex_init(&apc->vport_mutex);
> +	apc->vport_use_count = 0;
> +
>  	ndev->netdev_ops = &mana_devops;
>  	ndev->ethtool_ops = &mana_ethtool_ops;
>  	ndev->mtu = ETH_DATA_LEN;
> 
