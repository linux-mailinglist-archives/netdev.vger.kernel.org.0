Return-Path: <netdev+bounces-9584-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 332E5729E5E
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 17:26:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A55AF28185D
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 15:26:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A7DD218C3B;
	Fri,  9 Jun 2023 15:26:18 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9723418AF8
	for <netdev@vger.kernel.org>; Fri,  9 Jun 2023 15:26:18 +0000 (UTC)
Received: from mail-m11879.qiye.163.com (mail-m11879.qiye.163.com [115.236.118.79])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FC004496;
	Fri,  9 Jun 2023 08:25:53 -0700 (PDT)
Received: from [IPV6:240e:3b7:3279:1440:b958:def:cae6:50d2] (unknown [IPV6:240e:3b7:3279:1440:b958:def:cae6:50d2])
	by mail-m11879.qiye.163.com (Hmail) with ESMTPA id 947DE6802A8;
	Fri,  9 Jun 2023 23:25:42 +0800 (CST)
Message-ID: <9c1fecc1-7d17-c039-6bfa-c63be6fcf013@sangfor.com.cn>
Date: Fri, 9 Jun 2023 23:25:34 +0800
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.2
Subject: Re: [PATCH net-next] net: ethtool: Fix out-of-bounds copy to user
To: Alexander Duyck <alexander.duyck@gmail.com>
Cc: Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
 davem@davemloft.net, edumazet@google.com, pabeni@redhat.com,
 netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
 pengdonglin@sangfor.com.cn, huangcun@sangfor.com.cn
References: <20230601112839.13799-1-dinghui@sangfor.com.cn>
 <135a45b2c388fbaf9db4620cb01b95230709b9ac.camel@gmail.com>
 <eed0cbf7-ff12-057e-e133-0ddf5e98ef68@sangfor.com.cn>
 <6110cf9f-c10e-4b9b-934d-8d202b7f5794@lunn.ch>
 <f7e23fe6-4d30-ef1b-a431-3ef6ec6f77ba@sangfor.com.cn>
 <6e28cea9-d615-449d-9c68-aa155efc8444@lunn.ch>
 <CAKgT0UdyykQL-BidjaNpjX99FwJTxET51U29q4_CDqmABUuVbw@mail.gmail.com>
 <ece228a3-5c31-4390-b6ba-ec3f2b6c5dcb@lunn.ch>
 <CAKgT0Uf+XaKCFgBRTn-viVsKkNE7piAuDpht=efixsAV=3JdFQ@mail.gmail.com>
 <44905acd-3ac4-cfe5-5e91-d182c1959407@sangfor.com.cn>
 <20230602225519.66c2c987@kernel.org>
 <5f0f2bab-ae36-8b13-2c6d-c69c6ff4a43f@sangfor.com.cn>
 <20230604104718.4bf45faf@kernel.org>
 <f6ad6281-df30-93cf-d057-5841b8c1e2e6@sangfor.com.cn>
 <20230605113915.4258af7f@kernel.org>
 <034f5393-e519-1e8d-af76-ae29677a1bf5@sangfor.com.cn>
 <CAKgT0UdX7cc-LVFowFrY7mSZMvN0xc+w+oH16GNrduLY-AddSA@mail.gmail.com>
From: Ding Hui <dinghui@sangfor.com.cn>
In-Reply-To: <CAKgT0UdX7cc-LVFowFrY7mSZMvN0xc+w+oH16GNrduLY-AddSA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
	tZV1koWUFITzdXWS1ZQUlXWQ8JGhUIEh9ZQVkZQ0JLVk5OT0tIGUtOGR9PHlUTARMWGhIXJBQOD1
	lXWRgSC1lBWUlPSx5BSBlMQUhJTEJBSk9PS0EZQk5DQR8eHUEYGh5NQU5LH0lZV1kWGg8SFR0UWU
	FZT0tIVUpKS0hKTFVKS0tVS1kG
X-HM-Tid: 0a88a0c370a22eb5kusn947de6802a8
X-HM-MType: 1
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6MBA6Txw4TD0COiMrDE0JDU4U
	FDVPCiFVSlVKTUNNSElPSE9ITkpLVTMWGhIXVR8SFRwTDhI7CBoVHB0UCVUYFBZVGBVFWVdZEgtZ
	QVlJT0seQUgZTEFISUxCQUpPT0tBGUJOQ0EfHh1BGBoeTUFOSx9JWVdZCAFZQUlKTUtCNwY+
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,NICE_REPLY_A,
	RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
	SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 2023/6/8 22:17, Alexander Duyck wrote:
> 
> Well as I said before. The issue points to a driver problem more than
> anything else.
> 
> Normally the solution is to make it so that the counts don't
> fluctuate. That mostly consists of providing strings equal to the
> maximum count, and then 0 populating the data for any fields that
> don't exist in the case of ethtool -S.
> 
> So for example in the case of igb which you had pointed out you could
> take a look at ixgbe for inspiration on how to fix it since the two
> drivers should be similar and one has the issue and one does not.
> 

Thanks.

FYI, I just did some rough research about which drivers return constant count
and which not.

Variable (61/188):

drivers/net/dsa/bcm_sf2.c:    .get_sset_count         = bcm_sf2_sw_get_sset_count,
drivers/net/ethernet/amazon/ena/ena_ethtool.c:        .get_sset_count         = ena_get_sset_count,
drivers/net/ethernet/amd/xgbe/xgbe-ethtool.c: .get_sset_count = xgbe_get_sset_count,
drivers/net/ethernet/aquantia/atlantic/aq_ethtool.c:  .get_sset_count      = aq_ethtool_get_sset_count,
drivers/net/ethernet/broadcom/bcmsysport.c:   .get_sset_count         = bcm_sysport_get_sset_count,
drivers/net/ethernet/broadcom/bnx2x/bnx2x_ethtool.c:  .get_sset_count         = bnx2x_get_sset_count,
drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c:    .get_sset_count         = bnxt_get_sset_count,
drivers/net/ethernet/brocade/bna/bnad_ethtool.c:      .get_sset_count = bnad_get_sset_count,
drivers/net/ethernet/cadence/macb_main.c:     .get_sset_count         = gem_get_sset_count,
drivers/net/ethernet/cavium/liquidio/lio_ethtool.c:   .get_sset_count         = lio_get_sset_count,
drivers/net/ethernet/cavium/liquidio/lio_ethtool.c:   .get_sset_count         = lio_vf_get_sset_count,
drivers/net/ethernet/cavium/thunder/nicvf_ethtool.c:  .get_sset_count         = nicvf_get_sset_count,
drivers/net/ethernet/emulex/benet/be_ethtool.c:       .get_sset_count = be_get_sset_count,
drivers/net/ethernet/freescale/dpaa/dpaa_ethtool.c:   .get_sset_count = dpaa_get_sset_count,
drivers/net/ethernet/freescale/enetc/enetc_ethtool.c: .get_sset_count = enetc_get_sset_count,
drivers/net/ethernet/fungible/funeth/funeth_ethtool.c:        .get_sset_count      = fun_get_sset_count,
drivers/net/ethernet/google/gve/gve_ethtool.c:        .get_sset_count = gve_get_sset_count,
drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c:   .get_sset_count = hns3_get_sset_count,
drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c:      .get_sset_count = hclge_get_sset_count,
drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c:    .get_sset_count = hclgevf_get_sset_count,
drivers/net/ethernet/hisilicon/hns/hns_ae_adapt.c:    .get_sset_count = hns_ae_get_sset_count,
drivers/net/ethernet/hisilicon/hns/hns_ethtool.c:     .get_sset_count = hns_get_sset_count,
drivers/net/ethernet/huawei/hinic/hinic_ethtool.c:    .get_sset_count = hinic_get_sset_count,
drivers/net/ethernet/ibm/ibmvnic.c:   .get_sset_count         = ibmvnic_get_sset_count,
drivers/net/ethernet/intel/i40e/i40e_ethtool.c:       .get_sset_count         = i40e_get_sset_count,
drivers/net/ethernet/intel/iavf/iavf_ethtool.c:       .get_sset_count         = iavf_get_sset_count,
drivers/net/ethernet/intel/ice/ice_ethtool.c: .get_sset_count         = ice_get_sset_count,
drivers/net/ethernet/intel/igb/igb_ethtool.c: .get_sset_count         = igb_get_sset_count,
drivers/net/ethernet/intel/igc/igc_ethtool.c: .get_sset_count         = igc_ethtool_get_sset_count,
drivers/net/ethernet/intel/ixgbe/ixgbe_ethtool.c:     .get_sset_count         = ixgbe_get_sset_count,
drivers/net/ethernet/intel/ixgbevf/ethtool.c: .get_sset_count         = ixgbevf_get_sset_count,
drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c:      .get_sset_count         = mvpp2_ethtool_get_sset_count,
drivers/net/ethernet/marvell/octeon_ep/octep_ethtool.c:       .get_sset_count = octep_get_sset_count,
drivers/net/ethernet/marvell/octeontx2/nic/otx2_ethtool.c:    .get_sset_count         = otx2_get_sset_count,
drivers/net/ethernet/marvell/octeontx2/nic/otx2_ethtool.c:    .get_sset_count         = otx2vf_get_sset_count,
drivers/net/ethernet/mellanox/mlx4/en_ethtool.c:      .get_sset_count = mlx4_en_get_sset_count,
drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c: .get_sset_count    = mlx5e_get_sset_count,
drivers/net/ethernet/mellanox/mlx5/core/en_rep.c:     .get_sset_count    = mlx5e_rep_get_sset_count,
drivers/net/ethernet/mellanox/mlx5/core/ipoib/ethtool.c:      .get_sset_count     = mlx5i_get_sset_count,
drivers/net/ethernet/microsoft/mana/mana_ethtool.c:   .get_sset_count         = mana_get_sset_count,
drivers/net/ethernet/netronome/nfp/nfp_net_ethtool.c: .get_sset_count         = nfp_net_get_sset_count,
drivers/net/ethernet/netronome/nfp/nfp_net_ethtool.c: .get_sset_count         = nfp_port_get_sset_count,
drivers/net/ethernet/pensando/ionic/ionic_ethtool.c:  .get_sset_count         = ionic_get_sset_count,
drivers/net/ethernet/qlogic/qede/qede_ethtool.c:      .get_sset_count                 = qede_get_sset_count,
drivers/net/ethernet/qlogic/qlcnic/qlcnic_ethtool.c:  .get_sset_count = qlcnic_get_sset_count,
drivers/net/ethernet/qlogic/qlcnic/qlcnic_ethtool.c:  .get_sset_count         = qlcnic_get_sset_count,
drivers/net/ethernet/sfc/ef100_ethtool.c:     .get_sset_count         = efx_ethtool_get_sset_count,
drivers/net/ethernet/sfc/ethtool.c:   .get_sset_count         = efx_ethtool_get_sset_count,
drivers/net/ethernet/sfc/falcon/ethtool.c:    .get_sset_count         = ef4_ethtool_get_sset_count,
drivers/net/ethernet/sfc/siena/ethtool.c:     .get_sset_count         = efx_siena_ethtool_get_sset_count,
drivers/net/ethernet/stmicro/stmmac/stmmac_ethtool.c: .get_sset_count = stmmac_get_sset_count,
drivers/net/ethernet/sun/niu.c:       .get_sset_count         = niu_get_sset_count,
drivers/net/ethernet/sun/sunvnet.c:   .get_sset_count         = vnet_get_sset_count,
drivers/net/ethernet/ti/cpsw.c:       .get_sset_count         = cpsw_get_sset_count,
drivers/net/ethernet/ti/cpsw_new.c:   .get_sset_count         = cpsw_get_sset_count,
drivers/net/hyperv/netvsc_drv.c:      .get_sset_count = netvsc_get_sset_count,
drivers/net/ifb.c:    .get_sset_count         = ifb_get_sset_count,
drivers/net/veth.c:   .get_sset_count         = veth_get_sset_count,
drivers/net/virtio_net.c:     .get_sset_count = virtnet_get_sset_count,
drivers/net/vmxnet3/vmxnet3_ethtool.c:        .get_sset_count    = vmxnet3_get_sset_count,
drivers/s390/net/qeth_ethtool.c:      .get_sset_count = qeth_get_sset_count,


Constant (127/188):

arch/um/drivers/vector_kern.c:        .get_sset_count = vector_get_sset_count,
drivers/infiniband/ulp/ipoib/ipoib_ethtool.c: .get_sset_count         = ipoib_get_sset_count,
drivers/infiniband/ulp/opa_vnic/opa_vnic_ethtool.c:   .get_sset_count = vnic_get_sset_count,
drivers/net/can/flexcan/flexcan-ethtool.c:    .get_sset_count = flexcan_get_sset_count,
drivers/net/can/slcan/slcan-ethtool.c:        .get_sset_count = slcan_get_sset_count,
drivers/net/dsa/b53/b53_common.c:     .get_sset_count         = b53_get_sset_count,
drivers/net/dsa/dsa_loop.c:   .get_sset_count         = dsa_loop_get_sset_count,
drivers/net/dsa/hirschmann/hellcreek.c:       .get_sset_count        = hellcreek_get_sset_count,
drivers/net/dsa/lan9303-core.c:       .get_sset_count         = lan9303_get_sset_count,
drivers/net/dsa/lantiq_gswip.c:       .get_sset_count         = gswip_get_sset_count,
drivers/net/dsa/microchip/ksz_common.c:       .get_sset_count         = ksz_sset_count,
drivers/net/dsa/mt7530.c:     .get_sset_count         = mt7530_get_sset_count,
drivers/net/dsa/mv88e6xxx/chip.c:     .get_sset_count         = mv88e6xxx_get_sset_count,
drivers/net/dsa/ocelot/felix.c:       .get_sset_count                 = felix_get_sset_count,
drivers/net/dsa/qca/qca8k-8xxx.c:     .get_sset_count         = qca8k_get_sset_count,
drivers/net/dsa/realtek/rtl8365mb.c:  .get_sset_count = rtl8365mb_get_sset_count,
drivers/net/dsa/realtek/rtl8366rb.c:  .get_sset_count = rtl8366_get_sset_count,
drivers/net/dsa/rzn1_a5psw.c: .get_sset_count = a5psw_get_sset_count,
drivers/net/dsa/sja1105/sja1105_main.c:       .get_sset_count         = sja1105_get_sset_count,
drivers/net/dsa/vitesse-vsc73xx-core.c:       .get_sset_count = vsc73xx_get_sset_count,
drivers/net/dsa/xrs700x/xrs700x.c:    .get_sset_count         = xrs700x_get_sset_count,
drivers/net/ethernet/3com/3c59x.c:    .get_sset_count         = vortex_get_sset_count,
drivers/net/ethernet/alacritech/slicoss.c:    .get_sset_count         = slic_get_sset_count,
drivers/net/ethernet/altera/altera_tse_ethtool.c:     .get_sset_count = tse_sset_count,
drivers/net/ethernet/amd/pcnet32.c:   .get_sset_count         = pcnet32_get_sset_count,
drivers/net/ethernet/apm/xgene-v2/ethtool.c:  .get_sset_count = xge_get_sset_count,
drivers/net/ethernet/apm/xgene/xgene_enet_ethtool.c:  .get_sset_count = xgene_get_sset_count,
drivers/net/ethernet/asix/ax88796c_ioctl.c:   .get_sset_count         = ax88796c_get_sset_count,
drivers/net/ethernet/atheros/ag71xx.c:        .get_sset_count                 = ag71xx_ethtool_get_sset_count,
drivers/net/ethernet/atheros/alx/ethtool.c:   .get_sset_count = alx_get_sset_count,
drivers/net/ethernet/atheros/atlx/atl1.c:     .get_sset_count         = atl1_get_sset_count,
drivers/net/ethernet/broadcom/b44.c:  .get_sset_count         = b44_get_sset_count,
drivers/net/ethernet/broadcom/bcm63xx_enet.c: .get_sset_count         = bcm_enet_get_sset_count,
drivers/net/ethernet/broadcom/bcm63xx_enet.c: .get_sset_count         = bcm_enetsw_get_sset_count,
drivers/net/ethernet/broadcom/bgmac.c:        .get_sset_count         = bgmac_get_sset_count,
drivers/net/ethernet/broadcom/bnx2.c: .get_sset_count         = bnx2_get_sset_count,
drivers/net/ethernet/broadcom/genet/bcmgenet.c:       .get_sset_count         = bcmgenet_get_sset_count,
drivers/net/ethernet/broadcom/tg3.c:  .get_sset_count         = tg3_get_sset_count,
drivers/net/ethernet/calxeda/xgmac.c: .get_sset_count = xgmac_get_sset_count,
drivers/net/ethernet/chelsio/cxgb3/cxgb3_main.c:      .get_sset_count = get_sset_count,
drivers/net/ethernet/chelsio/cxgb4/cxgb4_ethtool.c:   .get_sset_count    = get_sset_count,
drivers/net/ethernet/chelsio/cxgb4vf/cxgb4vf_main.c:  .get_sset_count         = cxgb4vf_get_sset_count,
drivers/net/ethernet/chelsio/cxgb/cxgb2.c:    .get_sset_count    = get_sset_count,
drivers/net/ethernet/cisco/enic/enic_ethtool.c:       .get_sset_count = enic_get_sset_count,
drivers/net/ethernet/cortina/gemini.c:        .get_sset_count = gmac_get_sset_count,
drivers/net/ethernet/dlink/sundance.c:        .get_sset_count = get_sset_count,
drivers/net/ethernet/engleder/tsnep_ethtool.c:        .get_sset_count = tsnep_ethtool_get_sset_count,
drivers/net/ethernet/freescale/dpaa2/dpaa2-ethtool.c: .get_sset_count = dpaa2_eth_get_sset_count,
drivers/net/ethernet/freescale/dpaa2/dpaa2-switch-ethtool.c:  .get_sset_count         = dpaa2_switch_ethtool_get_sset_count,
drivers/net/ethernet/freescale/fec_main.c:    .get_sset_count         = fec_enet_get_sset_count,
drivers/net/ethernet/freescale/gianfar_ethtool.c:     .get_sset_count = gfar_sset_count,
drivers/net/ethernet/freescale/ucc_geth_ethtool.c:    .get_sset_count         = uec_get_sset_count,
drivers/net/ethernet/ibm/ehea/ehea_ethtool.c: .get_sset_count = ehea_get_sset_count,
drivers/net/ethernet/ibm/emac/core.c: .get_sset_count = emac_ethtool_get_sset_count,
drivers/net/ethernet/ibm/ibmveth.c:   .get_sset_count                  = ibmveth_get_sset_count,
drivers/net/ethernet/intel/e1000/e1000_ethtool.c:     .get_sset_count         = e1000_get_sset_count,
drivers/net/ethernet/intel/e1000e/ethtool.c:  .get_sset_count         = e1000e_get_sset_count,
drivers/net/ethernet/intel/e100.c:    .get_sset_count         = e100_get_sset_count,
drivers/net/ethernet/intel/fm10k/fm10k_ethtool.c:     .get_sset_count         = fm10k_get_sset_count,
drivers/net/ethernet/intel/ice/ice_ethtool.c: .get_sset_count         = ice_repr_get_sset_count,
drivers/net/ethernet/intel/igbvf/ethtool.c:   .get_sset_count         = igbvf_get_sset_count,
drivers/net/ethernet/marvell/mv643xx_eth.c:   .get_sset_count         = mv643xx_eth_get_sset_count,
drivers/net/ethernet/marvell/mvneta.c:        .get_sset_count = mvneta_ethtool_get_sset_count,
drivers/net/ethernet/marvell/prestera/prestera_ethtool.c:     .get_sset_count = prestera_ethtool_get_sset_count,
drivers/net/ethernet/marvell/skge.c:  .get_sset_count = skge_get_sset_count,
drivers/net/ethernet/marvell/sky2.c:  .get_sset_count = sky2_get_sset_count,
drivers/net/ethernet/mediatek/mtk_eth_soc.c:  .get_sset_count         = mtk_get_sset_count,
drivers/net/ethernet/mellanox/mlxbf_gige/mlxbf_gige_ethtool.c:        .get_sset_count         = mlxbf_gige_get_sset_count,
drivers/net/ethernet/mellanox/mlxsw/spectrum_ethtool.c:       .get_sset_count                 = mlxsw_sp_port_get_sset_count,
drivers/net/ethernet/micrel/ksz884x.c:        .get_sset_count         = netdev_get_sset_count,
drivers/net/ethernet/microchip/lan743x_ethtool.c:     .get_sset_count = lan743x_ethtool_get_sset_count,
drivers/net/ethernet/microchip/lan966x/lan966x_ethtool.c:     .get_sset_count         = lan966x_get_sset_count,
drivers/net/ethernet/microchip/sparx5/sparx5_ethtool.c:       .get_sset_count         = sparx5_get_sset_count,
drivers/net/ethernet/mscc/ocelot_net.c:       .get_sset_count         = ocelot_port_get_sset_count,
drivers/net/ethernet/myricom/myri10ge/myri10ge.c:     .get_sset_count = myri10ge_get_sset_count,
drivers/net/ethernet/neterion/s2io.c: .get_sset_count = s2io_get_sset_count,
drivers/net/ethernet/nvidia/forcedeth.c:      .get_sset_count = nv_get_sset_count,
drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe_ethtool.c:      .get_sset_count = pch_gbe_get_sset_count,
drivers/net/ethernet/pasemi/pasemi_mac_ethtool.c:     .get_sset_count         = pasemi_mac_get_sset_count,
drivers/net/ethernet/qlogic/netxen/netxen_nic_ethtool.c:      .get_sset_count = netxen_get_sset_count,
drivers/net/ethernet/qualcomm/emac/emac-ethtool.c:    .get_sset_count  = emac_get_sset_count,
drivers/net/ethernet/qualcomm/qca_debug.c:    .get_sset_count = qcaspi_get_sset_count,
drivers/net/ethernet/qualcomm/rmnet/rmnet_vnd.c:      .get_sset_count = rmnet_get_sset_count,
drivers/net/ethernet/realtek/8139cp.c:        .get_sset_count         = cp_get_sset_count,
drivers/net/ethernet/realtek/8139too.c:       .get_sset_count         = rtl8139_get_sset_count,
drivers/net/ethernet/realtek/r8169_main.c:    .get_sset_count         = rtl8169_get_sset_count,
drivers/net/ethernet/renesas/ravb_main.c:     .get_sset_count         = ravb_get_sset_count,
drivers/net/ethernet/renesas/sh_eth.c:        .get_sset_count     = sh_eth_get_sset_count,
drivers/net/ethernet/rocker/rocker_main.c:    .get_sset_count         = rocker_port_get_sset_count,
drivers/net/ethernet/samsung/sxgbe/sxgbe_ethtool.c:   .get_sset_count = sxgbe_get_sset_count,
drivers/net/ethernet/silan/sc92031.c: .get_sset_count         = sc92031_ethtool_get_sset_count,
drivers/net/ethernet/sun/cassini.c:   .get_sset_count         = cas_get_sset_count,
drivers/net/ethernet/synopsys/dwc-xlgmac-ethtool.c:   .get_sset_count = xlgmac_ethtool_get_sset_count,
drivers/net/ethernet/tehuti/tehuti.c:         .get_sset_count = bdx_get_sset_count,
drivers/net/ethernet/ti/am65-cpsw-ethtool.c:  .get_sset_count         = am65_cpsw_get_sset_count,
drivers/net/ethernet/ti/netcp_ethss.c:        .get_sset_count         = keystone_get_sset_count,
drivers/net/ethernet/toshiba/spider_net_ethtool.c:    .get_sset_count         = spider_net_get_sset_count,
drivers/net/ethernet/toshiba/tc35815.c:       .get_sset_count         = tc35815_get_sset_count,
drivers/net/ethernet/vertexcom/mse102x.c:     .get_sset_count         = mse102x_get_sset_count,
drivers/net/ethernet/via/via-velocity.c:      .get_sset_count         = velocity_get_sset_count,
drivers/net/fjes/fjes_ethtool.c:              .get_sset_count   = fjes_get_sset_count,
drivers/net/phy/adin.c:               .get_sset_count = adin_get_sset_count,
drivers/net/phy/aquantia_main.c:      .get_sset_count = aqr107_get_sset_count,
drivers/net/phy/at803x.c:     .get_sset_count         = at803x_get_sset_count,
drivers/net/phy/bcm7xxx.c:    .get_sset_count = bcm_phy_get_sset_count,                       \
drivers/net/phy/bcm-cygnus.c: .get_sset_count = bcm_phy_get_sset_count,
drivers/net/phy/broadcom.c:   .get_sset_count = bcm_phy_get_sset_count,
drivers/net/phy/icplus.c:     .get_sset_count = ip101g_get_sset_count,
drivers/net/phy/marvell.c:            .get_sset_count = marvell_get_sset_count,
drivers/net/phy/micrel.c:     .get_sset_count = kszphy_get_sset_count,
drivers/net/phy/mscc/mscc_main.c:     .get_sset_count = &vsc85xx_get_sset_count,
drivers/net/phy/nxp-c45-tja11xx.c:            .get_sset_count         = nxp_c45_get_sset_count,
drivers/net/phy/nxp-cbtx.c:           .get_sset_count         = cbtx_get_sset_count,
drivers/net/phy/nxp-tja11xx.c:                .get_sset_count = tja11xx_get_sset_count,
drivers/net/phy/smsc.c:       .get_sset_count = smsc_get_sset_count,
drivers/net/usb/asix_devices.c:       .get_sset_count         = ax88772_ethtool_get_sset_count,
drivers/net/usb/cdc_ncm.c:    .get_sset_count         = cdc_ncm_get_sset_count,
drivers/net/usb/lan78xx.c:    .get_sset_count = lan78xx_get_sset_count,
drivers/net/usb/r8152.c:      .get_sset_count = rtl8152_get_sset_count,
drivers/net/usb/smsc95xx.c:   .get_sset_count = smsc95xx_ethtool_get_sset_count,
drivers/net/wireless/ath/ath6kl/cfg80211.c:   .get_sset_count = ath6kl_get_sset_count,
drivers/net/wireless/marvell/libertas/ethtool.c:      .get_sset_count = lbs_mesh_ethtool_get_sset_count,
drivers/net/xen-netback/interface.c:  .get_sset_count = xenvif_get_sset_count,
drivers/net/xen-netfront.c:   .get_sset_count = xennet_get_sset_count,
drivers/staging/qlge/qlge_ethtool.c:  .get_sset_count = qlge_get_sset_count,
net/batman-adv/soft-interface.c:      .get_sset_count = batadv_get_sset_count,
net/mac80211/ethtool.c:       .get_sset_count = ieee80211_get_sset_count,


-- 
Thanks,
-dinghui


