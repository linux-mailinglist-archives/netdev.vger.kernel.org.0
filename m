Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9FAF72B6FC0
	for <lists+netdev@lfdr.de>; Tue, 17 Nov 2020 21:11:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731440AbgKQULB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Nov 2020 15:11:01 -0500
Received: from mga11.intel.com ([192.55.52.93]:11821 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725771AbgKQUK5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 17 Nov 2020 15:10:57 -0500
IronPort-SDR: hTqiamgoSkylM3DbGuOHkJNnelG/NHy5E+nPzf8Kgisd3HFhQOBMz/u+Hfr7ZnKMNOiXnKFBNg
 NdKDtwraqbgQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9808"; a="167491476"
X-IronPort-AV: E=Sophos;i="5.77,486,1596524400"; 
   d="scan'208";a="167491476"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Nov 2020 12:10:53 -0800
IronPort-SDR: US9ONkcqp45RmdTnLDWuOpkjAT64yLIX0ipZv+Gj+DO63mqBUi3RWQ1coFfeDHnyMUS9YniSVJ
 K/arkH9++9EQ==
X-IronPort-AV: E=Sophos;i="5.77,486,1596524400"; 
   d="scan'208";a="330197590"
Received: from jekeller-mobl1.amr.corp.intel.com (HELO [10.255.231.91]) ([10.255.231.91])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Nov 2020 12:10:52 -0800
Subject: Re: [net-next v3 1/2] devlink: move request_firmware out of driver
To:     netdev@vger.kernel.org
Cc:     Jiri Pirko <jiri@nvidia.com>,
        Michael Chan <michael.chan@broadcom.com>,
        Shannon Nelson <snelson@pensando.io>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Boris Pismenny <borisp@nvidia.com>,
        Bin Luo <luobin9@huawei.com>, Jakub Kicinksi <kuba@kernel.org>
References: <20201117200820.854115-1-jacob.e.keller@intel.com>
 <20201117200820.854115-2-jacob.e.keller@intel.com>
From:   Jacob Keller <jacob.e.keller@intel.com>
Organization: Intel Corporation
Message-ID: <505ed03a-6e71-5abc-dd18-c3c737c6ade8@intel.com>
Date:   Tue, 17 Nov 2020 12:10:49 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.1
MIME-Version: 1.0
In-Reply-To: <20201117200820.854115-2-jacob.e.keller@intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 11/17/2020 12:08 PM, Jacob Keller wrote:
> All drivers which implement the devlink flash update support, with the
> exception of netdevsim, use either request_firmware or
> request_firmware_direct to locate the firmware file. Rather than having
> each driver do this separately as part of its .flash_update
> implementation, perform the request_firmware within net/core/devlink.c
> 
> Replace the file_name parameter in the struct devlink_flash_update_params
> with a pointer to the fw object.
> 
> Use request_firmware rather than request_firmware_direct. Although most
> Linux distributions today do not have the fallback mechanism
> implemented, only about half the drivers used the _direct request, as
> compared to the generic request_firmware. In the event that
> a distribution does support the fallback mechanism, the devlink flash
> update ought to be able to use it to provide the firmware contents. For
> distributions which do not support the fallback userspace mechanism,
> there should be essentially no difference between request_firmware and
> request_firmware_direct.
> 
> Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
> Cc: Jiri Pirko <jiri@nvidia.com>
> Cc: Michael Chan <michael.chan@broadcom.com>
> Cc: Shannon Nelson <snelson@pensando.io>
> Cc: Saeed Mahameed <saeedm@nvidia.com>
> Cc: Boris Pismenny <borisp@nvidia.com>
> Cc: Bin Luo <luobin9@huawei.com>
> Cc: Jakub Kicinksi <kuba@kernel.org>
> ---

Oof, forgot to metion that the only change since v2 is to fix the typo
in the commit message pointed out by Shannon. Otherwise, this patch is
identical and just comes in series with the other change.

>  .../net/ethernet/broadcom/bnxt/bnxt_devlink.c |  2 +-
>  .../net/ethernet/broadcom/bnxt/bnxt_ethtool.c | 33 ++++++++++++-------
>  .../net/ethernet/broadcom/bnxt/bnxt_ethtool.h |  4 +--
>  .../net/ethernet/huawei/hinic/hinic_devlink.c | 12 +------
>  drivers/net/ethernet/intel/ice/ice_devlink.c  | 14 +-------
>  .../net/ethernet/mellanox/mlx5/core/devlink.c | 11 +------
>  drivers/net/ethernet/mellanox/mlxsw/core.c    | 11 +------
>  .../net/ethernet/netronome/nfp/nfp_devlink.c  |  2 +-
>  drivers/net/ethernet/netronome/nfp/nfp_main.c | 17 ++--------
>  drivers/net/ethernet/netronome/nfp/nfp_main.h |  2 +-
>  .../ethernet/pensando/ionic/ionic_devlink.c   |  2 +-
>  .../ethernet/pensando/ionic/ionic_devlink.h   |  2 +-
>  .../net/ethernet/pensando/ionic/ionic_fw.c    | 12 +------
>  include/net/devlink.h                         |  7 ++--
>  net/core/devlink.c                            | 26 ++++++++++++---
>  15 files changed, 61 insertions(+), 96 deletions(-)
> 
> diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c
> index 184b6d0513b2..4ebae8a236fd 100644
> --- a/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c
> +++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c
> @@ -32,7 +32,7 @@ bnxt_dl_flash_update(struct devlink *dl,
>  
>  	devlink_flash_update_begin_notify(dl);
>  	devlink_flash_update_status_notify(dl, "Preparing to flash", NULL, 0, 0);
> -	rc = bnxt_flash_package_from_file(bp->dev, params->file_name, 0);
> +	rc = bnxt_flash_package_from_fw_obj(bp->dev, params->fw, 0);
>  	if (!rc)
>  		devlink_flash_update_status_notify(dl, "Flashing done", NULL, 0, 0);
>  	else
> diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
> index 53687bc7fcf5..91e73aedcdff 100644
> --- a/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
> +++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
> @@ -2416,13 +2416,12 @@ static int bnxt_flash_firmware_from_file(struct net_device *dev,
>  	return rc;
>  }
>  
> -int bnxt_flash_package_from_file(struct net_device *dev, const char *filename,
> -				 u32 install_type)
> +int bnxt_flash_package_from_fw_obj(struct net_device *dev, const struct firmware *fw,
> +				   u32 install_type)
>  {
>  	struct bnxt *bp = netdev_priv(dev);
>  	struct hwrm_nvm_install_update_output *resp = bp->hwrm_cmd_resp_addr;
>  	struct hwrm_nvm_install_update_input install = {0};
> -	const struct firmware *fw;
>  	u32 item_len;
>  	int rc = 0;
>  	u16 index;
> @@ -2437,13 +2436,6 @@ int bnxt_flash_package_from_file(struct net_device *dev, const char *filename,
>  		return rc;
>  	}
>  
> -	rc = request_firmware(&fw, filename, &dev->dev);
> -	if (rc != 0) {
> -		netdev_err(dev, "PKG error %d requesting file: %s\n",
> -			   rc, filename);
> -		return rc;
> -	}
> -
>  	if (fw->size > item_len) {
>  		netdev_err(dev, "PKG insufficient update area in nvram: %lu\n",
>  			   (unsigned long)fw->size);
> @@ -2475,7 +2467,6 @@ int bnxt_flash_package_from_file(struct net_device *dev, const char *filename,
>  					  dma_handle);
>  		}
>  	}
> -	release_firmware(fw);
>  	if (rc)
>  		goto err_exit;
>  
> @@ -2514,6 +2505,26 @@ int bnxt_flash_package_from_file(struct net_device *dev, const char *filename,
>  	return rc;
>  }
>  
> +static int bnxt_flash_package_from_file(struct net_device *dev, const char *filename,
> +					u32 install_type)
> +{
> +	const struct firmware *fw;
> +	int rc;
> +
> +	rc = request_firmware(&fw, filename, &dev->dev);
> +	if (rc != 0) {
> +		netdev_err(dev, "PKG error %d requesting file: %s\n",
> +			   rc, filename);
> +		return rc;
> +	}
> +
> +	rc = bnxt_flash_package_from_fw_obj(dev, fw, install_type);
> +
> +	release_firmware(fw);
> +
> +	return rc;
> +}
> +
>  static int bnxt_flash_device(struct net_device *dev,
>  			     struct ethtool_flash *flash)
>  {
> diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.h b/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.h
> index fa6fbde52bea..0a57cb6a4a4b 100644
> --- a/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.h
> +++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.h
> @@ -94,8 +94,8 @@ u32 bnxt_fw_to_ethtool_speed(u16);
>  u16 bnxt_get_fw_auto_link_speeds(u32);
>  int bnxt_hwrm_nvm_get_dev_info(struct bnxt *bp,
>  			       struct hwrm_nvm_get_dev_info_output *nvm_dev_info);
> -int bnxt_flash_package_from_file(struct net_device *dev, const char *filename,
> -				 u32 install_type);
> +int bnxt_flash_package_from_fw_obj(struct net_device *dev, const struct firmware *fw,
> +				   u32 install_type);
>  void bnxt_ethtool_init(struct bnxt *bp);
>  void bnxt_ethtool_free(struct bnxt *bp);
>  
> diff --git a/drivers/net/ethernet/huawei/hinic/hinic_devlink.c b/drivers/net/ethernet/huawei/hinic/hinic_devlink.c
> index 2630d667f393..58d5646444b0 100644
> --- a/drivers/net/ethernet/huawei/hinic/hinic_devlink.c
> +++ b/drivers/net/ethernet/huawei/hinic/hinic_devlink.c
> @@ -285,18 +285,8 @@ static int hinic_devlink_flash_update(struct devlink *devlink,
>  				      struct netlink_ext_ack *extack)
>  {
>  	struct hinic_devlink_priv *priv = devlink_priv(devlink);
> -	const struct firmware *fw;
> -	int err;
>  
> -	err = request_firmware_direct(&fw, params->file_name,
> -				      &priv->hwdev->hwif->pdev->dev);
> -	if (err)
> -		return err;
> -
> -	err = hinic_firmware_update(priv, fw, extack);
> -	release_firmware(fw);
> -
> -	return err;
> +	return hinic_firmware_update(priv, params->fw, extack);
>  }
>  
>  static const struct devlink_ops hinic_devlink_ops = {
> diff --git a/drivers/net/ethernet/intel/ice/ice_devlink.c b/drivers/net/ethernet/intel/ice/ice_devlink.c
> index 511da59bd6f2..0036d3e7df0b 100644
> --- a/drivers/net/ethernet/intel/ice/ice_devlink.c
> +++ b/drivers/net/ethernet/intel/ice/ice_devlink.c
> @@ -247,9 +247,7 @@ ice_devlink_flash_update(struct devlink *devlink,
>  			 struct netlink_ext_ack *extack)
>  {
>  	struct ice_pf *pf = devlink_priv(devlink);
> -	struct device *dev = &pf->pdev->dev;
>  	struct ice_hw *hw = &pf->hw;
> -	const struct firmware *fw;
>  	u8 preservation;
>  	int err;
>  
> @@ -277,21 +275,11 @@ ice_devlink_flash_update(struct devlink *devlink,
>  	if (err)
>  		return err;
>  
> -	err = request_firmware(&fw, params->file_name, dev);
> -	if (err) {
> -		NL_SET_ERR_MSG_MOD(extack, "Unable to read file from disk");
> -		return err;
> -	}
> -
> -	dev_dbg(dev, "Beginning flash update with file '%s'\n", params->file_name);
> -
>  	devlink_flash_update_begin_notify(devlink);
>  	devlink_flash_update_status_notify(devlink, "Preparing to flash", NULL, 0, 0);
> -	err = ice_flash_pldm_image(pf, fw, preservation, extack);
> +	err = ice_flash_pldm_image(pf, params->fw, preservation, extack);
>  	devlink_flash_update_end_notify(devlink);
>  
> -	release_firmware(fw);
> -
>  	return err;
>  }
>  
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/devlink.c b/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
> index a28f95df2901..e2ed341648e4 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
> @@ -13,17 +13,8 @@ static int mlx5_devlink_flash_update(struct devlink *devlink,
>  				     struct netlink_ext_ack *extack)
>  {
>  	struct mlx5_core_dev *dev = devlink_priv(devlink);
> -	const struct firmware *fw;
> -	int err;
>  
> -	err = request_firmware_direct(&fw, params->file_name, &dev->pdev->dev);
> -	if (err)
> -		return err;
> -
> -	err = mlx5_firmware_flash(dev, fw, extack);
> -	release_firmware(fw);
> -
> -	return err;
> +	return mlx5_firmware_flash(dev, params->fw, extack);
>  }
>  
>  static u8 mlx5_fw_ver_major(u32 version)
> diff --git a/drivers/net/ethernet/mellanox/mlxsw/core.c b/drivers/net/ethernet/mellanox/mlxsw/core.c
> index 937b8e46f8c7..88b751470c58 100644
> --- a/drivers/net/ethernet/mellanox/mlxsw/core.c
> +++ b/drivers/net/ethernet/mellanox/mlxsw/core.c
> @@ -1116,16 +1116,7 @@ static int mlxsw_core_fw_flash_update(struct mlxsw_core *mlxsw_core,
>  				      struct devlink_flash_update_params *params,
>  				      struct netlink_ext_ack *extack)
>  {
> -	const struct firmware *firmware;
> -	int err;
> -
> -	err = request_firmware_direct(&firmware, params->file_name, mlxsw_core->bus_info->dev);
> -	if (err)
> -		return err;
> -	err = mlxsw_core_fw_flash(mlxsw_core, firmware, extack);
> -	release_firmware(firmware);
> -
> -	return err;
> +	return mlxsw_core_fw_flash(mlxsw_core, params->fw, extack);
>  }
>  
>  static int mlxsw_core_devlink_param_fw_load_policy_validate(struct devlink *devlink, u32 id,
> diff --git a/drivers/net/ethernet/netronome/nfp/nfp_devlink.c b/drivers/net/ethernet/netronome/nfp/nfp_devlink.c
> index 97d2b03208de..713ee3041d49 100644
> --- a/drivers/net/ethernet/netronome/nfp/nfp_devlink.c
> +++ b/drivers/net/ethernet/netronome/nfp/nfp_devlink.c
> @@ -333,7 +333,7 @@ nfp_devlink_flash_update(struct devlink *devlink,
>  			 struct devlink_flash_update_params *params,
>  			 struct netlink_ext_ack *extack)
>  {
> -	return nfp_flash_update_common(devlink_priv(devlink), params->file_name, extack);
> +	return nfp_flash_update_common(devlink_priv(devlink), params->fw, extack);
>  }
>  
>  const struct devlink_ops nfp_devlink_ops = {
> diff --git a/drivers/net/ethernet/netronome/nfp/nfp_main.c b/drivers/net/ethernet/netronome/nfp/nfp_main.c
> index e672614d2906..742a420152b3 100644
> --- a/drivers/net/ethernet/netronome/nfp/nfp_main.c
> +++ b/drivers/net/ethernet/netronome/nfp/nfp_main.c
> @@ -301,11 +301,10 @@ static int nfp_pcie_sriov_configure(struct pci_dev *pdev, int num_vfs)
>  		return nfp_pcie_sriov_enable(pdev, num_vfs);
>  }
>  
> -int nfp_flash_update_common(struct nfp_pf *pf, const char *path,
> +int nfp_flash_update_common(struct nfp_pf *pf, const struct firmware *fw,
>  			    struct netlink_ext_ack *extack)
>  {
>  	struct device *dev = &pf->pdev->dev;
> -	const struct firmware *fw;
>  	struct nfp_nsp *nsp;
>  	int err;
>  
> @@ -319,24 +318,12 @@ int nfp_flash_update_common(struct nfp_pf *pf, const char *path,
>  		return err;
>  	}
>  
> -	err = request_firmware_direct(&fw, path, dev);
> -	if (err) {
> -		NL_SET_ERR_MSG_MOD(extack,
> -				   "unable to read flash file from disk");
> -		goto exit_close_nsp;
> -	}
> -
> -	dev_info(dev, "Please be patient while writing flash image: %s\n",
> -		 path);
> -
>  	err = nfp_nsp_write_flash(nsp, fw);
>  	if (err < 0)
> -		goto exit_release_fw;
> +		goto exit_close_nsp;
>  	dev_info(dev, "Finished writing flash image\n");
>  	err = 0;
>  
> -exit_release_fw:
> -	release_firmware(fw);
>  exit_close_nsp:
>  	nfp_nsp_close(nsp);
>  	return err;
> diff --git a/drivers/net/ethernet/netronome/nfp/nfp_main.h b/drivers/net/ethernet/netronome/nfp/nfp_main.h
> index fa6b13a05941..a7dede946a33 100644
> --- a/drivers/net/ethernet/netronome/nfp/nfp_main.h
> +++ b/drivers/net/ethernet/netronome/nfp/nfp_main.h
> @@ -166,7 +166,7 @@ nfp_pf_map_rtsym(struct nfp_pf *pf, const char *name, const char *sym_fmt,
>  		 unsigned int min_size, struct nfp_cpp_area **area);
>  int nfp_mbox_cmd(struct nfp_pf *pf, u32 cmd, void *in_data, u64 in_length,
>  		 void *out_data, u64 out_length);
> -int nfp_flash_update_common(struct nfp_pf *pf, const char *path,
> +int nfp_flash_update_common(struct nfp_pf *pf, const struct firmware *fw,
>  			    struct netlink_ext_ack *extack);
>  
>  enum nfp_dump_diag {
> diff --git a/drivers/net/ethernet/pensando/ionic/ionic_devlink.c b/drivers/net/ethernet/pensando/ionic/ionic_devlink.c
> index 51d64718ed9f..b41301a5b0df 100644
> --- a/drivers/net/ethernet/pensando/ionic/ionic_devlink.c
> +++ b/drivers/net/ethernet/pensando/ionic/ionic_devlink.c
> @@ -15,7 +15,7 @@ static int ionic_dl_flash_update(struct devlink *dl,
>  {
>  	struct ionic *ionic = devlink_priv(dl);
>  
> -	return ionic_firmware_update(ionic->lif, params->file_name, extack);
> +	return ionic_firmware_update(ionic->lif, params->fw, extack);
>  }
>  
>  static int ionic_dl_info_get(struct devlink *dl, struct devlink_info_req *req,
> diff --git a/drivers/net/ethernet/pensando/ionic/ionic_devlink.h b/drivers/net/ethernet/pensando/ionic/ionic_devlink.h
> index 5c01a9e306d8..0a77e8e810c5 100644
> --- a/drivers/net/ethernet/pensando/ionic/ionic_devlink.h
> +++ b/drivers/net/ethernet/pensando/ionic/ionic_devlink.h
> @@ -6,7 +6,7 @@
>  
>  #include <net/devlink.h>
>  
> -int ionic_firmware_update(struct ionic_lif *lif, const char *fw_name,
> +int ionic_firmware_update(struct ionic_lif *lif, const struct firmware *fw,
>  			  struct netlink_ext_ack *extack);
>  
>  struct ionic *ionic_devlink_alloc(struct device *dev);
> diff --git a/drivers/net/ethernet/pensando/ionic/ionic_fw.c b/drivers/net/ethernet/pensando/ionic/ionic_fw.c
> index d7bbf336c6f6..fd2ce134f66c 100644
> --- a/drivers/net/ethernet/pensando/ionic/ionic_fw.c
> +++ b/drivers/net/ethernet/pensando/ionic/ionic_fw.c
> @@ -91,7 +91,7 @@ static int ionic_fw_status_long_wait(struct ionic *ionic,
>  	return err;
>  }
>  
> -int ionic_firmware_update(struct ionic_lif *lif, const char *fw_name,
> +int ionic_firmware_update(struct ionic_lif *lif, const struct firmware *fw,
>  			  struct netlink_ext_ack *extack)
>  {
>  	struct ionic_dev *idev = &lif->ionic->idev;
> @@ -99,24 +99,15 @@ int ionic_firmware_update(struct ionic_lif *lif, const char *fw_name,
>  	struct ionic *ionic = lif->ionic;
>  	union ionic_dev_cmd_comp comp;
>  	u32 buf_sz, copy_sz, offset;
> -	const struct firmware *fw;
>  	struct devlink *dl;
>  	int next_interval;
>  	int err = 0;
>  	u8 fw_slot;
>  
> -	netdev_info(netdev, "Installing firmware %s\n", fw_name);
> -
>  	dl = priv_to_devlink(ionic);
>  	devlink_flash_update_begin_notify(dl);
>  	devlink_flash_update_status_notify(dl, "Preparing to flash", NULL, 0, 0);
>  
> -	err = request_firmware(&fw, fw_name, ionic->dev);
> -	if (err) {
> -		NL_SET_ERR_MSG_MOD(extack, "Unable to find firmware file");
> -		goto err_out;
> -	}
> -
>  	buf_sz = sizeof(idev->dev_cmd_regs->data);
>  
>  	netdev_dbg(netdev,
> @@ -200,7 +191,6 @@ int ionic_firmware_update(struct ionic_lif *lif, const char *fw_name,
>  		devlink_flash_update_status_notify(dl, "Flash failed", NULL, 0, 0);
>  	else
>  		devlink_flash_update_status_notify(dl, "Flash done", NULL, 0, 0);
> -	release_firmware(fw);
>  	devlink_flash_update_end_notify(dl);
>  	return err;
>  }
> diff --git a/include/net/devlink.h b/include/net/devlink.h
> index b01bb9bca5a2..d1d125a33322 100644
> --- a/include/net/devlink.h
> +++ b/include/net/devlink.h
> @@ -19,6 +19,7 @@
>  #include <net/flow_offload.h>
>  #include <uapi/linux/devlink.h>
>  #include <linux/xarray.h>
> +#include <linux/firmware.h>
>  
>  #define DEVLINK_RELOAD_STATS_ARRAY_SIZE \
>  	(__DEVLINK_RELOAD_LIMIT_MAX * __DEVLINK_RELOAD_ACTION_MAX)
> @@ -566,15 +567,15 @@ enum devlink_param_generic_id {
>  
>  /**
>   * struct devlink_flash_update_params - Flash Update parameters
> - * @file_name: the name of the flash firmware file to update from
> + * @fw: pointer to the firmware data to update from
>   * @component: the flash component to update
>   *
> - * With the exception of file_name, drivers must opt-in to parameters by
> + * With the exception of fw, drivers must opt-in to parameters by
>   * setting the appropriate bit in the supported_flash_update_params field in
>   * their devlink_ops structure.
>   */
>  struct devlink_flash_update_params {
> -	const char *file_name;
> +	const struct firmware *fw;
>  	const char *component;
>  	u32 overwrite_mask;
>  };
> diff --git a/net/core/devlink.c b/net/core/devlink.c
> index ab4b1368904f..b0121d79ac75 100644
> --- a/net/core/devlink.c
> +++ b/net/core/devlink.c
> @@ -3429,10 +3429,12 @@ EXPORT_SYMBOL_GPL(devlink_flash_update_timeout_notify);
>  static int devlink_nl_cmd_flash_update(struct sk_buff *skb,
>  				       struct genl_info *info)
>  {
> -	struct nlattr *nla_component, *nla_overwrite_mask;
> +	struct nlattr *nla_component, *nla_overwrite_mask, *nla_file_name;
>  	struct devlink_flash_update_params params = {};
>  	struct devlink *devlink = info->user_ptr[0];
> +	const char *file_name;
>  	u32 supported_params;
> +	int ret;
>  
>  	if (!devlink->ops->flash_update)
>  		return -EOPNOTSUPP;
> @@ -3442,8 +3444,6 @@ static int devlink_nl_cmd_flash_update(struct sk_buff *skb,
>  
>  	supported_params = devlink->ops->supported_flash_update_params;
>  
> -	params.file_name = nla_data(info->attrs[DEVLINK_ATTR_FLASH_UPDATE_FILE_NAME]);
> -
>  	nla_component = info->attrs[DEVLINK_ATTR_FLASH_UPDATE_COMPONENT];
>  	if (nla_component) {
>  		if (!(supported_params & DEVLINK_SUPPORT_FLASH_UPDATE_COMPONENT)) {
> @@ -3467,7 +3467,19 @@ static int devlink_nl_cmd_flash_update(struct sk_buff *skb,
>  		params.overwrite_mask = sections.value & sections.selector;
>  	}
>  
> -	return devlink->ops->flash_update(devlink, &params, info->extack);
> +	nla_file_name = info->attrs[DEVLINK_ATTR_FLASH_UPDATE_FILE_NAME];
> +	file_name = nla_data(nla_file_name);
> +	ret = request_firmware(&params.fw, file_name, devlink->dev);
> +	if (ret) {
> +		NL_SET_ERR_MSG_ATTR(info->extack, nla_file_name, "failed to locate the requested firmware file");
> +		return ret;
> +	}
> +
> +	ret = devlink->ops->flash_update(devlink, &params, info->extack);
> +
> +	release_firmware(params.fw);
> +
> +	return ret;
>  }
>  
>  static const struct devlink_param devlink_param_generic[] = {
> @@ -10225,12 +10237,16 @@ int devlink_compat_flash_update(struct net_device *dev, const char *file_name)
>  		goto out;
>  	}
>  
> -	params.file_name = file_name;
> +	ret = request_firmware(&params.fw, file_name, devlink->dev);
> +	if (ret)
> +		goto out;
>  
>  	mutex_lock(&devlink->lock);
>  	ret = devlink->ops->flash_update(devlink, &params, NULL);
>  	mutex_unlock(&devlink->lock);
>  
> +	release_firmware(params.fw);
> +
>  out:
>  	rtnl_lock();
>  	dev_put(dev);
> 
