Return-Path: <netdev+bounces-1766-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1D9696FF171
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 14:22:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E6CFD1C20EF8
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 12:21:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B2CC919E4C;
	Thu, 11 May 2023 12:21:59 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7E2CAD54
	for <netdev@vger.kernel.org>; Thu, 11 May 2023 12:21:59 +0000 (UTC)
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44EA83ABE
	for <netdev@vger.kernel.org>; Thu, 11 May 2023 05:21:57 -0700 (PDT)
Received: from dggpemm500005.china.huawei.com (unknown [172.30.72.55])
	by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4QH9vN5Ys3zsRX0;
	Thu, 11 May 2023 20:20:00 +0800 (CST)
Received: from [10.69.30.204] (10.69.30.204) by dggpemm500005.china.huawei.com
 (7.185.36.74) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.23; Thu, 11 May
 2023 20:21:54 +0800
Subject: Re: [PATCH net-next v4 3/7] net: wangxun: Implement vlan add and kill
 functions
To: Mengyuan Lou <mengyuanlou@net-swift.com>, <netdev@vger.kernel.org>
CC: <jiawenwu@trustnetic.com>
References: <20230510093845.47446-1-mengyuanlou@net-swift.com>
 <20230510093845.47446-4-mengyuanlou@net-swift.com>
From: Yunsheng Lin <linyunsheng@huawei.com>
Message-ID: <c7ec9d3d-c8da-0b9a-2420-fa9031074613@huawei.com>
Date: Thu, 11 May 2023 20:21:53 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.0
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20230510093845.47446-4-mengyuanlou@net-swift.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.69.30.204]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 dggpemm500005.china.huawei.com (7.185.36.74)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-6.3 required=5.0 tests=BAYES_00,NICE_REPLY_A,
	RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 2023/5/10 17:38, Mengyuan Lou wrote:
> Implement vlan add/kill functions which add and remove
> vlan id in hardware.
> 
> Signed-off-by: Mengyuan Lou <mengyuanlou@net-swift.com>
> ---
>  drivers/net/ethernet/wangxun/libwx/wx_hw.c   | 275 ++++++++++++++++++-
>  drivers/net/ethernet/wangxun/libwx/wx_hw.h   |   3 +
>  drivers/net/ethernet/wangxun/libwx/wx_lib.c  |  18 ++
>  drivers/net/ethernet/wangxun/libwx/wx_type.h |  31 +++
>  4 files changed, 326 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/wangxun/libwx/wx_hw.c b/drivers/net/ethernet/wangxun/libwx/wx_hw.c
> index ca409b4054d0..4b7baeb6c568 100644
> --- a/drivers/net/ethernet/wangxun/libwx/wx_hw.c
> +++ b/drivers/net/ethernet/wangxun/libwx/wx_hw.c
> @@ -1182,12 +1182,30 @@ static void wx_enable_sec_rx_path(struct wx *wx)
>  	WX_WRITE_FLUSH(wx);
>  }
>  
> +static void wx_vlan_strip_control(struct wx *wx, bool enable)
> +{
> +	int i, j;
> +
> +	for (i = 0; i < wx->num_rx_queues; i++) {
> +		struct wx_ring *ring = wx->rx_ring[i];
> +
> +		if (ring->accel)
> +			continue;

Nit: add a blane line here?

> +		j = ring->reg_idx;
> +		wr32m(wx, WX_PX_RR_CFG(j), WX_PX_RR_CFG_VLAN,
> +		      enable ? WX_PX_RR_CFG_VLAN : 0);
> +	}
> +}
> +
>  void wx_set_rx_mode(struct net_device *netdev)
>  {
>  	struct wx *wx = netdev_priv(netdev);
> +	netdev_features_t features;
>  	u32 fctrl, vmolr, vlnctrl;
>  	int count;
>  
> +	features = netdev->features;
> +
>  	/* Check for Promiscuous and All Multicast modes */
>  	fctrl = rd32(wx, WX_PSR_CTL);
>  	fctrl &= ~(WX_PSR_CTL_UPE | WX_PSR_CTL_MPE);
> @@ -1254,6 +1272,13 @@ void wx_set_rx_mode(struct net_device *netdev)
>  	wr32(wx, WX_PSR_VLAN_CTL, vlnctrl);
>  	wr32(wx, WX_PSR_CTL, fctrl);
>  	wr32(wx, WX_PSR_VM_L2CTL(0), vmolr);
> +
> +	if ((features & NETIF_F_HW_VLAN_CTAG_RX) &&
> +	    (features & NETIF_F_HW_VLAN_STAG_RX))
> +		wx_vlan_strip_control(wx, true);
> +	else
> +		wx_vlan_strip_control(wx, false);

Is there any reason not check features bits in the
ndev->ndo_set_features?

> +
>  }
>  EXPORT_SYMBOL(wx_set_rx_mode);
>  
> @@ -1462,6 +1487,16 @@ static void wx_configure_tx(struct wx *wx)
>  	      WX_MAC_TX_CFG_TE, WX_MAC_TX_CFG_TE);
>  }
>  
> +static void wx_restore_vlan(struct wx *wx)
> +{
> +	u16 vid = 1;
> +
> +	wx_vlan_rx_add_vid(wx->netdev, htons(ETH_P_8021Q), 0);
> +
> +	for_each_set_bit_from(vid, wx->active_vlans, VLAN_N_VID)
> +		wx_vlan_rx_add_vid(wx->netdev, htons(ETH_P_8021Q), vid);
> +}
> +
>  /**
>   * wx_configure_rx - Configure Receive Unit after Reset
>   * @wx: pointer to private structure
> @@ -1527,7 +1562,7 @@ void wx_configure(struct wx *wx)
>  	wx_configure_port(wx);
>  
>  	wx_set_rx_mode(wx->netdev);
> -
> +	wx_restore_vlan(wx);
>  	wx_enable_sec_rx_path(wx);
>  
>  	wx_configure_tx(wx);
> @@ -1727,4 +1762,242 @@ int wx_sw_init(struct wx *wx)
>  }
>  EXPORT_SYMBOL(wx_sw_init);
>  
> +/**
> + *  wx_find_vlvf_slot - find the vlanid or the first empty slot
> + *  @wx: pointer to hardware structure
> + *  @vlan: VLAN id to write to VLAN filter
> + *
> + *  return the VLVF index where this VLAN id should be placed
> + *
> + **/
> +static int wx_find_vlvf_slot(struct wx *wx, u32 vlan)
> +{
> +	u32 bits = 0, first_empty_slot = 0;
> +	int regindex;
> +
> +	/* short cut the special case */
> +	if (vlan == 0)
> +		return 0;
> +
> +	/* Search for the vlan id in the VLVF entries. Save off the first empty
> +	 * slot found along the way
> +	 */
> +	for (regindex = 1; regindex < WX_PSR_VLAN_SWC_ENTRIES; regindex++) {
> +		wr32(wx, WX_PSR_VLAN_SWC_IDX, regindex);
> +		bits = rd32(wx, WX_PSR_VLAN_SWC);
> +		if (!bits && !(first_empty_slot))
> +			first_empty_slot = regindex;
> +		else if ((bits & 0x0FFF) == vlan)
> +			break;
> +	}
> +
> +	if (regindex >= WX_PSR_VLAN_SWC_ENTRIES) {
> +		if (first_empty_slot)
> +			regindex = first_empty_slot;
> +		else
> +			regindex = -ENOMEM;
> +	}
> +
> +	return regindex;
> +}
> +
> +/**
> + *  wx_set_vlvf - Set VLAN Pool Filter
> + *  @wx: pointer to hardware structure
> + *  @vlan: VLAN id to write to VLAN filter
> + *  @vind: VMDq output index that maps queue to VLAN id in VFVFB
> + *  @vlan_on: boolean flag to turn on/off VLAN in VFVF
> + *  @vfta_changed: pointer to boolean flag which indicates whether VFTA
> + *                 should be changed
> + *
> + *  Turn on/off specified bit in VLVF table.
> + **/
> +static int wx_set_vlvf(struct wx *wx, u32 vlan, u32 vind, bool vlan_on,
> +		       bool *vfta_changed)
> +{
> +	u32 vt;
> +
> +	/* If VT Mode is set
> +	 *   Either vlan_on
> +	 *     make sure the vlan is in VLVF
> +	 *     set the vind bit in the matching VLVFB
> +	 *   Or !vlan_on
> +	 *     clear the pool bit and possibly the vind
> +	 */
> +	vt = rd32(wx, WX_CFG_PORT_CTL);
> +	if (vt & WX_CFG_PORT_CTL_NUM_VT_MASK) {

Maybe reduce one indentation by:

	if(!vt & WX_CFG_PORT_CTL_NUM_VT_MASK)
		return;

> +		s32 vlvf_index;
> +		u32 bits;
> +
> +		vlvf_index = wx_find_vlvf_slot(wx, vlan);
> +		if (vlvf_index < 0)
> +			return vlvf_index;
> +
> +		wr32(wx, WX_PSR_VLAN_SWC_IDX, vlvf_index);
> +		if (vlan_on) {
> +			/* set the pool bit */
> +			if (vind < 32) {
> +				bits = rd32(wx, WX_PSR_VLAN_SWC_VM_L);
> +				bits |= (1 << vind);
> +				wr32(wx, WX_PSR_VLAN_SWC_VM_L, bits);
> +			} else {
> +				bits = rd32(wx, WX_PSR_VLAN_SWC_VM_H);
> +				bits |= (1 << (vind - 32));
> +				wr32(wx, WX_PSR_VLAN_SWC_VM_H, bits);
> +			}
> +		} else {
> +			/* clear the pool bit */
> +			if (vind < 32) {
> +				bits = rd32(wx, WX_PSR_VLAN_SWC_VM_L);
> +				bits &= ~(1 << vind);
> +				wr32(wx, WX_PSR_VLAN_SWC_VM_L, bits);
> +				bits |= rd32(wx, WX_PSR_VLAN_SWC_VM_H);
> +			} else {
> +				bits = rd32(wx, WX_PSR_VLAN_SWC_VM_H);
> +				bits &= ~(1 << (vind - 32));
> +				wr32(wx, WX_PSR_VLAN_SWC_VM_H, bits);
> +				bits |= rd32(wx, WX_PSR_VLAN_SWC_VM_L);
> +			}
> +		}
> +
> +		if (bits) {
> +			wr32(wx, WX_PSR_VLAN_SWC, (WX_PSR_VLAN_SWC_VIEN | vlan));
> +			if (!vlan_on && vfta_changed)
> +				*vfta_changed = false;
> +		} else {
> +			wr32(wx, WX_PSR_VLAN_SWC, 0);
> +		}
> +	}
> +
> +	return 0;
> +}
> +

...

> +
>  struct wx_ring {
>  	struct wx_ring *next;           /* pointer to next ring in q_vector */
>  	struct wx_q_vector *q_vector;   /* backpointer to host q_vector */
>  	struct net_device *netdev;      /* netdev ring belongs to */
>  	struct device *dev;             /* device for DMA mapping */
> +	struct wx_fwd_adapter *accel;

It seems accel is not really necessary for this patch, as
it is only checked wx_vlan_strip_control().



