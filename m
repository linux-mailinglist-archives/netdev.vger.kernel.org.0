Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 160BF4D0B07
	for <lists+netdev@lfdr.de>; Mon,  7 Mar 2022 23:25:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243108AbiCGWZw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Mar 2022 17:25:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236293AbiCGWZv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Mar 2022 17:25:51 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4FF66FA08
        for <netdev@vger.kernel.org>; Mon,  7 Mar 2022 14:24:56 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4B194B81729
        for <netdev@vger.kernel.org>; Mon,  7 Mar 2022 22:24:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9EC22C340EF;
        Mon,  7 Mar 2022 22:24:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646691893;
        bh=vPX6USZNqLBlmnunZMRpfSqRkAK6a0n9gXL5jc0Mmm4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=CHmydv1FUeri9qmBqc3O0CZG0Eraft7sQkkFvUfr2mjoDAXrukboCjpFOTdyVHC9c
         k6ztASPM9Vmo1Tmzx4HdHQS8bJiTzJsa5gykMVtPGXa2j8nqlsf57rqNYWvuLYuW3f
         rugPcTQEojdYPRGFPN1sj1i4fkQfyy4eK5QW5w/oOj6AXwxOo3hoXa4B7mSnQGRdTl
         anAyRJFU2JRy0n/9K8tMJz3BhMG63y2UqbFulP7OItie2HZirbxbf4pgP2JhrQL1Ip
         WCHHKk9HlXY0TK1dt+2Ft0OB7ETVWiIXAsJo9ksLuBmaGEZb4Bn5TxcSEqrFwsnBpT
         iNtRiLYK6V/mA==
Date:   Mon, 7 Mar 2022 14:24:52 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Michael Chan <michael.chan@broadcom.com>,
        Jiri Pirko <jiri@resnulli.us>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, gospo@broadcom.com,
        eranbe@nvidia.com
Subject: Re: [PATCH net-next 9/9] bnxt_en: add an nvm test for hw diagnose
Message-ID: <20220307142452.70c95fd1@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <1646470482-13763-10-git-send-email-michael.chan@broadcom.com>
References: <1646470482-13763-1-git-send-email-michael.chan@broadcom.com>
        <1646470482-13763-10-git-send-email-michael.chan@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat,  5 Mar 2022 03:54:42 -0500 Michael Chan wrote:
> From: Vikas Gupta <vikas.gupta@broadcom.com>
> 
> Add an NVM test function for devlink hw reporter.
> In this function an NVM VPD area is read followed by
> a write. Test result is cached and if it is successful then
> the next test can be conducted only after HW_RETEST_MIN_TIME to
> avoid frequent writes to the NVM.

You seem to execute a self-test from the .diganose callback.
That really seems like an abuse of the API. It's not hard to
add a separate self-test callback.

Jiri, WDYT?

> diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.h b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
> index fa0df43ddc1a..9dd878def3c2 100644
> --- a/drivers/net/ethernet/broadcom/bnxt/bnxt.h
> +++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
> @@ -1544,17 +1544,29 @@ struct bnxt_ctx_mem_info {
>  };
>  
>  enum bnxt_hw_err {
> -	BNXT_HW_STATUS_HEALTHY		= 0x0,
> -	BNXT_HW_STATUS_NVM_WRITE_ERR	= 0x1,
> -	BNXT_HW_STATUS_NVM_ERASE_ERR	= 0x2,
> -	BNXT_HW_STATUS_NVM_UNKNOWN_ERR	= 0x3,
> +	BNXT_HW_STATUS_HEALTHY			= 0x0,
> +	BNXT_HW_STATUS_NVM_WRITE_ERR		= 0x1,
> +	BNXT_HW_STATUS_NVM_ERASE_ERR		= 0x2,
> +	BNXT_HW_STATUS_NVM_UNKNOWN_ERR		= 0x3,
> +	BNXT_HW_STATUS_NVM_TEST_VPD_ENT_ERR	= 0x4,
> +	BNXT_HW_STATUS_NVM_TEST_VPD_READ_ERR	= 0x5,
> +	BNXT_HW_STATUS_NVM_TEST_VPD_WRITE_ERR	= 0x6,
> +	BNXT_HW_STATUS_NVM_TEST_INCMPL_ERR	= 0x7,
>  };
>  
>  struct bnxt_hw_health {
>  	u32 nvm_err_address;
>  	u32 nvm_write_errors;
>  	u32 nvm_erase_errors;
> +	u32 nvm_test_vpd_ent_errors;
> +	u32 nvm_test_vpd_read_errors;
> +	u32 nvm_test_vpd_write_errors;
> +	u32 nvm_test_incmpl_errors;
>  	u8 synd;
> +	/* max a test in a day if previous test was successful */
> +#define HW_RETEST_MIN_TIME	(1000 * 3600 * 24)
> +	u8 nvm_test_result;
> +	unsigned long nvm_test_timestamp;
>  	struct devlink_health_reporter *hw_reporter;
>  };
>  
> diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c
> index a802bbda1c27..77e55105d645 100644
> --- a/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c
> +++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c
> @@ -20,6 +20,7 @@
>  #include "bnxt_ulp.h"
>  #include "bnxt_ptp.h"
>  #include "bnxt_coredump.h"
> +#include "bnxt_nvm_defs.h"	/* NVRAM content constant and structure defs */
>  
>  static void __bnxt_fw_recover(struct bnxt *bp)
>  {
> @@ -263,20 +264,82 @@ static const char *hw_err_str(u8 synd)
>  		return "nvm erase error";
>  	case BNXT_HW_STATUS_NVM_UNKNOWN_ERR:
>  		return "unrecognized nvm error";
> +	case BNXT_HW_STATUS_NVM_TEST_VPD_ENT_ERR:
> +		return "nvm test vpd entry error";
> +	case BNXT_HW_STATUS_NVM_TEST_VPD_READ_ERR:
> +		return "nvm test vpd read error";
> +	case BNXT_HW_STATUS_NVM_TEST_VPD_WRITE_ERR:
> +		return "nvm test vpd write error";
> +	case BNXT_HW_STATUS_NVM_TEST_INCMPL_ERR:
> +		return "nvm test incomplete error";
>  	default:
>  		return "unknown hw error";
>  	}
>  }
>  
> +static void bnxt_nvm_test(struct bnxt *bp)
> +{
> +	struct bnxt_hw_health *h = &bp->hw_health;
> +	u32 datalen;
> +	u16 index;
> +	u8 *buf;
> +
> +	if (!h->nvm_test_result) {
> +		if (!h->nvm_test_timestamp ||
> +		    time_after(jiffies, h->nvm_test_timestamp +
> +					msecs_to_jiffies(HW_RETEST_MIN_TIME)))
> +			h->nvm_test_timestamp = jiffies;
> +		else
> +			return;
> +	}
> +
> +	if (bnxt_find_nvram_item(bp->dev, BNX_DIR_TYPE_VPD,
> +				 BNX_DIR_ORDINAL_FIRST, BNX_DIR_EXT_NONE,
> +				 &index, NULL, &datalen) || !datalen) {
> +		h->nvm_test_result = BNXT_HW_STATUS_NVM_TEST_VPD_ENT_ERR;
> +		h->nvm_test_vpd_ent_errors++;
> +		return;
> +	}
> +
> +	buf = kzalloc(datalen, GFP_KERNEL);
> +	if (!buf) {
> +		h->nvm_test_result = BNXT_HW_STATUS_NVM_TEST_INCMPL_ERR;
> +		h->nvm_test_incmpl_errors++;
> +		return;
> +	}
> +
> +	if (bnxt_get_nvram_item(bp->dev, index, 0, datalen, buf)) {
> +		h->nvm_test_result = BNXT_HW_STATUS_NVM_TEST_VPD_READ_ERR;
> +		h->nvm_test_vpd_read_errors++;
> +		goto err;
> +	}
> +
> +	if (bnxt_flash_nvram(bp->dev, BNX_DIR_TYPE_VPD, BNX_DIR_ORDINAL_FIRST,
> +			     BNX_DIR_EXT_NONE, 0, 0, buf, datalen)) {
> +		h->nvm_test_result = BNXT_HW_STATUS_NVM_TEST_VPD_WRITE_ERR;
> +		h->nvm_test_vpd_write_errors++;
> +	}
> +
> +err:
> +	kfree(buf);
> +}
> +
>  static int bnxt_hw_diagnose(struct devlink_health_reporter *reporter,
>  			    struct devlink_fmsg *fmsg,
>  			    struct netlink_ext_ack *extack)
>  {
>  	struct bnxt *bp = devlink_health_reporter_priv(reporter);
>  	struct bnxt_hw_health *h = &bp->hw_health;
> +	u8 synd = h->synd;
>  	int rc;
>  
> -	rc = devlink_fmsg_string_pair_put(fmsg, "Status", hw_err_str(h->synd));
> +	bnxt_nvm_test(bp);
> +	if (h->nvm_test_result) {
> +		synd = h->nvm_test_result;
> +		devlink_health_report(h->hw_reporter, hw_err_str(synd), NULL);
> +	}
> +
> +	rc = devlink_fmsg_string_pair_put(fmsg, "Status", hw_err_str(synd));
>  	if (rc)
>  		return rc;
>  	rc = devlink_fmsg_u32_pair_put(fmsg, "nvm_write_errors", h->nvm_write_errors);
> @@ -285,6 +348,23 @@ static int bnxt_hw_diagnose(struct devlink_health_reporter *reporter,
>  	rc = devlink_fmsg_u32_pair_put(fmsg, "nvm_erase_errors", h->nvm_erase_errors);
>  	if (rc)
>  		return rc;
> +	rc = devlink_fmsg_u32_pair_put(fmsg, "nvm_test_vpd_ent_errors",
> +				       h->nvm_test_vpd_ent_errors);
> +	if (rc)
> +		return rc;
> +	rc = devlink_fmsg_u32_pair_put(fmsg, "nvm_test_vpd_read_errors",
> +				       h->nvm_test_vpd_read_errors);
> +	if (rc)
> +		return rc;
> +	rc = devlink_fmsg_u32_pair_put(fmsg, "nvm_test_vpd_write_errors",
> +				       h->nvm_test_vpd_write_errors);
> +	if (rc)
> +		return rc;
> +	rc = devlink_fmsg_u32_pair_put(fmsg, "nvm_test_incomplete_errors",
> +				       h->nvm_test_incmpl_errors);
> +	if (rc)
> +		return rc;
> +
>  	return 0;
>  }
>  
> diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
> index eadaca42ed96..178074795b27 100644
> --- a/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
> +++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
> @@ -2168,14 +2168,10 @@ static void bnxt_print_admin_err(struct bnxt *bp)
>  	netdev_info(bp->dev, "PF does not have admin privileges to flash or reset the device\n");
>  }
>  
> -static int bnxt_find_nvram_item(struct net_device *dev, u16 type, u16 ordinal,
> -				u16 ext, u16 *index, u32 *item_length,
> -				u32 *data_length);
> -
> -static int bnxt_flash_nvram(struct net_device *dev, u16 dir_type,
> -			    u16 dir_ordinal, u16 dir_ext, u16 dir_attr,
> -			    u32 dir_item_len, const u8 *data,
> -			    size_t data_len)
> +int bnxt_flash_nvram(struct net_device *dev, u16 dir_type,
> +		     u16 dir_ordinal, u16 dir_ext, u16 dir_attr,
> +		     u32 dir_item_len, const u8 *data,
> +		     size_t data_len)
>  {
>  	struct bnxt *bp = netdev_priv(dev);
>  	struct hwrm_nvm_write_input *req;
> @@ -2819,8 +2815,8 @@ static int bnxt_get_nvram_directory(struct net_device *dev, u32 len, u8 *data)
>  	return rc;
>  }
>  
> -static int bnxt_get_nvram_item(struct net_device *dev, u32 index, u32 offset,
> -			       u32 length, u8 *data)
> +int bnxt_get_nvram_item(struct net_device *dev, u32 index, u32 offset,
> +			u32 length, u8 *data)
>  {
>  	struct bnxt *bp = netdev_priv(dev);
>  	int rc;
> @@ -2854,9 +2850,9 @@ static int bnxt_get_nvram_item(struct net_device *dev, u32 index, u32 offset,
>  	return rc;
>  }
>  
> -static int bnxt_find_nvram_item(struct net_device *dev, u16 type, u16 ordinal,
> -				u16 ext, u16 *index, u32 *item_length,
> -				u32 *data_length)
> +int bnxt_find_nvram_item(struct net_device *dev, u16 type, u16 ordinal,
> +			 u16 ext, u16 *index, u32 *item_length,
> +			 u32 *data_length)
>  {
>  	struct hwrm_nvm_find_dir_entry_output *output;
>  	struct hwrm_nvm_find_dir_entry_input *req;
> diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.h b/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.h
> index 6aa44840f13a..2593e0049582 100644
> --- a/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.h
> +++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.h
> @@ -56,6 +56,13 @@ int bnxt_hwrm_firmware_reset(struct net_device *dev, u8 proc_type,
>  int bnxt_flash_package_from_fw_obj(struct net_device *dev, const struct firmware *fw,
>  				   u32 install_type);
>  int bnxt_get_pkginfo(struct net_device *dev, char *ver, int size);
> +int bnxt_find_nvram_item(struct net_device *dev, u16 type, u16 ordinal, u16 ext,
> +			 u16 *index, u32 *item_length, u32 *data_length);
> +int bnxt_get_nvram_item(struct net_device *dev, u32 index, u32 offset,
> +			u32 length, u8 *data);
> +int bnxt_flash_nvram(struct net_device *dev, u16 dir_type, u16 dir_ordinal,
> +		     u16 dir_ext, u16 dir_attr, u32 dir_item_len,
> +		     const u8 *data, size_t data_len);
>  void bnxt_ethtool_init(struct bnxt *bp);
>  void bnxt_ethtool_free(struct bnxt *bp);
>  

