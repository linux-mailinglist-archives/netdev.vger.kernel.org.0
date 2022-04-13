Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 35E224FF1EA
	for <lists+netdev@lfdr.de>; Wed, 13 Apr 2022 10:29:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229618AbiDMIb6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Apr 2022 04:31:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233813AbiDMIb5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Apr 2022 04:31:57 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7ECB734BAC
        for <netdev@vger.kernel.org>; Wed, 13 Apr 2022 01:29:34 -0700 (PDT)
Received: from canpemm500006.china.huawei.com (unknown [172.30.72.57])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4KdbLk62cSzgYfw
        for <netdev@vger.kernel.org>; Wed, 13 Apr 2022 16:27:42 +0800 (CST)
Received: from [10.174.179.200] (10.174.179.200) by
 canpemm500006.china.huawei.com (7.192.105.130) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Wed, 13 Apr 2022 16:29:32 +0800
Subject: Re: [PATCH net-next 2/3] ixgbe: add improvement for MDD response
 functionality
To:     Tony Nguyen <anthony.l.nguyen@intel.com>,
        Slawomir Mrozowicz <slawomirx.mrozowicz@intel.com>
CC:     <netdev@vger.kernel.org>,
        Konrad Jankowski <konrad0.jankowski@intel.com>
References: <20220308171155.408896-1-anthony.l.nguyen@intel.com>
 <20220308171155.408896-3-anthony.l.nguyen@intel.com>
From:   "Ziyang Xuan (William)" <william.xuanziyang@huawei.com>
Message-ID: <2e53d80d-c28a-c35f-7331-5027b585048a@huawei.com>
Date:   Wed, 13 Apr 2022 16:29:31 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20220308171155.408896-3-anthony.l.nguyen@intel.com>
Content-Type: text/plain; charset="gbk"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.179.200]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 canpemm500006.china.huawei.com (7.192.105.130)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-5.5 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> From: Slawomir Mrozowicz <slawomirx.mrozowicz@intel.com>
> 
> The 82599 PF driver disable VF driver after a special MDD event occurs.
> Adds the option for administrators to control whether VFs are
> automatically disabled after several MDD events.
> The automatically disabling is now the default mode for 82599 PF driver,
> as it is more reliable.
> 
> This addresses CVE-2021-33061.

Hello Slawomir,

I am handling the CVE-2021-33061 for our versions. I have some questions
for the CVE because the description of the patch and CVE site is not clear.

1. Which function will be triggered DOS, PF or VF?
According to your solution, I guess it is PF, because VF will be disabled finally.

2. What is the principle of the DOS? Is it the 82599 hardware-specific defects?
According to your solution, it is only for ixgbe_mac_82599EB. But the pci error
PCI_STATUS_REC_MASTER_ABORT is for all pci devices. So I guess that.

3. Is it possible triggered DOS within IXGBE_PRIMARY_ABORT_LIMIT toleration?

Thank you!

> 
> Signed-off-by: Slawomir Mrozowicz <slawomirx.mrozowicz@intel.com>
> Tested-by: Konrad Jankowski <konrad0.jankowski@intel.com>
> Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
> ---
>  drivers/net/ethernet/intel/ixgbe/ixgbe.h      |  4 +++
>  .../net/ethernet/intel/ixgbe/ixgbe_ethtool.c  | 21 ++++++++++++++
>  drivers/net/ethernet/intel/ixgbe/ixgbe_main.c | 28 ++++++++++++++++++-
>  3 files changed, 52 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe.h b/drivers/net/ethernet/intel/ixgbe/ixgbe.h
> index c9bf18086d9c..921a4d977d65 100644
> --- a/drivers/net/ethernet/intel/ixgbe/ixgbe.h
> +++ b/drivers/net/ethernet/intel/ixgbe/ixgbe.h
> @@ -184,6 +184,7 @@ struct vf_data_storage {
>  	u8 trusted;
>  	int xcast_mode;
>  	unsigned int vf_api;
> +	u8 primary_abort_count;
>  };
>  
>  enum ixgbevf_xcast_modes {
> @@ -558,6 +559,8 @@ struct ixgbe_mac_addr {
>  #define IXGBE_TRY_LINK_TIMEOUT (4 * HZ)
>  #define IXGBE_SFP_POLL_JIFFIES (2 * HZ)	/* SFP poll every 2 seconds */
>  
> +#define IXGBE_PRIMARY_ABORT_LIMIT	5
> +
>  /* board specific private data structure */
>  struct ixgbe_adapter {
>  	unsigned long active_vlans[BITS_TO_LONGS(VLAN_N_VID)];
> @@ -616,6 +619,7 @@ struct ixgbe_adapter {
>  #define IXGBE_FLAG2_RX_LEGACY			BIT(16)
>  #define IXGBE_FLAG2_IPSEC_ENABLED		BIT(17)
>  #define IXGBE_FLAG2_VF_IPSEC_ENABLED		BIT(18)
> +#define IXGBE_FLAG2_AUTO_DISABLE_VF		BIT(19)
>  
>  	/* Tx fast path data */
>  	int num_tx_queues;
> diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_ethtool.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_ethtool.c
> index f70967c32116..628d0eb0599f 100644
> --- a/drivers/net/ethernet/intel/ixgbe/ixgbe_ethtool.c
> +++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_ethtool.c
> @@ -138,6 +138,8 @@ static const char ixgbe_priv_flags_strings[][ETH_GSTRING_LEN] = {
>  	"legacy-rx",
>  #define IXGBE_PRIV_FLAGS_VF_IPSEC_EN	BIT(1)
>  	"vf-ipsec",
> +#define IXGBE_PRIV_FLAGS_AUTO_DISABLE_VF	BIT(2)
> +	"mdd-disable-vf",
>  };
>  
>  #define IXGBE_PRIV_FLAGS_STR_LEN ARRAY_SIZE(ixgbe_priv_flags_strings)
> @@ -3510,6 +3512,9 @@ static u32 ixgbe_get_priv_flags(struct net_device *netdev)
>  	if (adapter->flags2 & IXGBE_FLAG2_VF_IPSEC_ENABLED)
>  		priv_flags |= IXGBE_PRIV_FLAGS_VF_IPSEC_EN;
>  
> +	if (adapter->flags2 & IXGBE_FLAG2_AUTO_DISABLE_VF)
> +		priv_flags |= IXGBE_PRIV_FLAGS_AUTO_DISABLE_VF;
> +
>  	return priv_flags;
>  }
>  
> @@ -3517,6 +3522,7 @@ static int ixgbe_set_priv_flags(struct net_device *netdev, u32 priv_flags)
>  {
>  	struct ixgbe_adapter *adapter = netdev_priv(netdev);
>  	unsigned int flags2 = adapter->flags2;
> +	unsigned int i;
>  
>  	flags2 &= ~IXGBE_FLAG2_RX_LEGACY;
>  	if (priv_flags & IXGBE_PRIV_FLAGS_LEGACY_RX)
> @@ -3526,6 +3532,21 @@ static int ixgbe_set_priv_flags(struct net_device *netdev, u32 priv_flags)
>  	if (priv_flags & IXGBE_PRIV_FLAGS_VF_IPSEC_EN)
>  		flags2 |= IXGBE_FLAG2_VF_IPSEC_ENABLED;
>  
> +	flags2 &= ~IXGBE_FLAG2_AUTO_DISABLE_VF;
> +	if (priv_flags & IXGBE_PRIV_FLAGS_AUTO_DISABLE_VF) {
> +		if (adapter->hw.mac.type == ixgbe_mac_82599EB) {
> +			/* Reset primary abort counter */
> +			for (i = 0; i < adapter->num_vfs; i++)
> +				adapter->vfinfo[i].primary_abort_count = 0;
> +
> +			flags2 |= IXGBE_FLAG2_AUTO_DISABLE_VF;
> +		} else {
> +			e_info(probe,
> +			       "Cannot set private flags: Operation not supported\n");
> +			return -EOPNOTSUPP;
> +		}
> +	}
> +
>  	if (flags2 != adapter->flags2) {
>  		adapter->flags2 = flags2;
>  
> diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
> index 13df4e0f3796..c4a4954aa317 100644
> --- a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
> +++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
> @@ -7613,6 +7613,27 @@ static void ixgbe_watchdog_flush_tx(struct ixgbe_adapter *adapter)
>  }
>  
>  #ifdef CONFIG_PCI_IOV
> +static void ixgbe_bad_vf_abort(struct ixgbe_adapter *adapter, u32 vf)
> +{
> +	struct ixgbe_hw *hw = &adapter->hw;
> +
> +	if (adapter->hw.mac.type == ixgbe_mac_82599EB &&
> +	    adapter->flags2 & IXGBE_FLAG2_AUTO_DISABLE_VF) {
> +		adapter->vfinfo[vf].primary_abort_count++;
> +		if (adapter->vfinfo[vf].primary_abort_count ==
> +		    IXGBE_PRIMARY_ABORT_LIMIT) {
> +			ixgbe_set_vf_link_state(adapter, vf,
> +						IFLA_VF_LINK_STATE_DISABLE);
> +			adapter->vfinfo[vf].primary_abort_count = 0;
> +
> +			e_info(drv,
> +			       "Malicious Driver Detection event detected on PF %d VF %d MAC: %pM mdd-disable-vf=on",
> +			       hw->bus.func, vf,
> +			       adapter->vfinfo[vf].vf_mac_addresses);
> +		}
> +	}
> +}
> +
>  static void ixgbe_check_for_bad_vf(struct ixgbe_adapter *adapter)
>  {
>  	struct ixgbe_hw *hw = &adapter->hw;
> @@ -7644,8 +7665,10 @@ static void ixgbe_check_for_bad_vf(struct ixgbe_adapter *adapter)
>  			continue;
>  		pci_read_config_word(vfdev, PCI_STATUS, &status_reg);
>  		if (status_reg != IXGBE_FAILED_READ_CFG_WORD &&
> -		    status_reg & PCI_STATUS_REC_MASTER_ABORT)
> +		    status_reg & PCI_STATUS_REC_MASTER_ABORT) {
> +			ixgbe_bad_vf_abort(adapter, vf);
>  			pcie_flr(vfdev);
> +		}
>  	}
>  }
>  
> @@ -10746,6 +10769,9 @@ static int ixgbe_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
>  	if (err)
>  		goto err_sw_init;
>  
> +	if (adapter->hw.mac.type == ixgbe_mac_82599EB)
> +		adapter->flags2 |= IXGBE_FLAG2_AUTO_DISABLE_VF;
> +
>  	switch (adapter->hw.mac.type) {
>  	case ixgbe_mac_X550:
>  	case ixgbe_mac_X550EM_x:
> 
