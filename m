Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E312A4FE5C2
	for <lists+netdev@lfdr.de>; Tue, 12 Apr 2022 18:24:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350069AbiDLQ1C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Apr 2022 12:27:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235689AbiDLQ1A (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Apr 2022 12:27:00 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8EBB538192;
        Tue, 12 Apr 2022 09:24:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1649780682; x=1681316682;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=UeSHKiFD9MWQD9/lwoZzgM1WMiX/Uf+MCYGmOWbS/MQ=;
  b=IgeMVV1TefkVsW0SmgHxJRH+NyZFscL9F9bdji2rv8JrIej68zf9DmYm
   otsDeyHUHO6CZ/UM8wAIDTtj1UKHkMM1cnUuA4R7qFZ0TLpkZy0nCEwkk
   lNsLeeGKZqtAgFKQbmoPyQ6KUVnj9ef2+ZA9hCbHVgiNiYRVFJONnnDQd
   YUW1GTva3e9lYnYw3suUOi5MKihzrm47Yw3TfrDd1aGt9nEGYHW25hXYv
   55qi6Gxr8fnhIXI9n3Dr9nbKObcGrTnf+3mBVN5fv5W8pCdqgwr3q1+E/
   ii1VOss+KOFZG8X3rYiaRF3+B/2I2BIvhQbpMTx7o7VEl5GJW6UQLrtl9
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10315"; a="242362658"
X-IronPort-AV: E=Sophos;i="5.90,254,1643702400"; 
   d="scan'208";a="242362658"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Apr 2022 09:11:23 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,254,1643702400"; 
   d="scan'208";a="655174943"
Received: from irvmail001.ir.intel.com ([10.43.11.63])
  by fmsmga002.fm.intel.com with ESMTP; 12 Apr 2022 09:11:21 -0700
Received: from newjersey.igk.intel.com (newjersey.igk.intel.com [10.102.20.203])
        by irvmail001.ir.intel.com (8.14.3/8.13.6/MailSET/Hub) with ESMTP id 23CGBKdH010632;
        Tue, 12 Apr 2022 17:11:20 +0100
From:   Alexander Lobakin <alexandr.lobakin@intel.com>
To:     Petr Oros <poros@redhat.com>
Cc:     Alexander Lobakin <alexandr.lobakin@intel.com>,
        netdev@vger.kernel.org, ivecera@redhat.com,
        intel-wired-lan@lists.osuosl.org, linux-kernel@vger.kernel.org,
        kuba@kernel.org, pabeni@redhat.com, davem@davemloft.net
Subject: Re: [Intel-wired-lan] [PATCH] ice: wait for EMP reset after firmware flash
Date:   Tue, 12 Apr 2022 18:08:56 +0200
Message-Id: <20220412160856.1027597-1-alexandr.lobakin@intel.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220412102753.670867-1-poros@redhat.com>
References: <20220412102753.670867-1-poros@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Petr Oros <poros@redhat.com>
Date: Tue, 12 Apr 2022 12:27:53 +0200

> We need to wait for EMP reset after firmware flash.
> Code was extracted from OOT driver and without this wait fw_activate let
> card in inconsistent state recoverable only by second flash/activate
> 
> Reproducer:
> [root@host ~]# devlink dev flash pci/0000:ca:00.0 file E810_XXVDA4_FH_O_SEC_FW_1p6p1p9_NVM_3p10_PLDMoMCTP_0.11_8000AD7B.bin
> Preparing to flash
> [fw.mgmt] Erasing
> [fw.mgmt] Erasing done
> [fw.mgmt] Flashing 100%
> [fw.mgmt] Flashing done 100%
> [fw.undi] Erasing
> [fw.undi] Erasing done
> [fw.undi] Flashing 100%
> [fw.undi] Flashing done 100%
> [fw.netlist] Erasing
> [fw.netlist] Erasing done
> [fw.netlist] Flashing 100%
> [fw.netlist] Flashing done 100%
> Activate new firmware by devlink reload
> [root@host ~]# devlink dev reload pci/0000:ca:00.0 action fw_activate
> reload_actions_performed:
>     fw_activate
> [root@host ~]# ip link show ens7f0
> 71: ens7f0: <NO-CARRIER,BROADCAST,MULTICAST,UP> mtu 1500 qdisc mq state DOWN mode DEFAULT group default qlen 1000
>     link/ether b4:96:91:dc:72:e0 brd ff:ff:ff:ff:ff:ff
>     altname enp202s0f0
> 
> dmesg after flash:
> [   55.120788] ice: Copyright (c) 2018, Intel Corporation.
> [   55.274734] ice 0000:ca:00.0: Get PHY capabilities failed status = -5, continuing anyway
> [   55.569797] ice 0000:ca:00.0: The DDP package was successfully loaded: ICE OS Default Package version 1.3.28.0
> [   55.603629] ice 0000:ca:00.0: Get PHY capability failed.
> [   55.608951] ice 0000:ca:00.0: ice_init_nvm_phy_type failed: -5
> [   55.647348] ice 0000:ca:00.0: PTP init successful
> [   55.675536] ice 0000:ca:00.0: DCB is enabled in the hardware, max number of TCs supported on this port are 8
> [   55.685365] ice 0000:ca:00.0: FW LLDP is disabled, DCBx/LLDP in SW mode.
> [   55.692179] ice 0000:ca:00.0: Commit DCB Configuration to the hardware
> [   55.701382] ice 0000:ca:00.0: 126.024 Gb/s available PCIe bandwidth, limited by 16.0 GT/s PCIe x8 link at 0000:c9:02.0 (capable of 252.048 Gb/s with 16.0 GT/s PCIe x16 link)
> Reboot don't help, only second flash/activate with OOT or patched driver put card back in consistent state
> 
> After patch:
> [root@host ~]# devlink dev flash pci/0000:ca:00.0 file E810_XXVDA4_FH_O_SEC_FW_1p6p1p9_NVM_3p10_PLDMoMCTP_0.11_8000AD7B.bin
> Preparing to flash
> [fw.mgmt] Erasing
> [fw.mgmt] Erasing done
> [fw.mgmt] Flashing 100%
> [fw.mgmt] Flashing done 100%
> [fw.undi] Erasing
> [fw.undi] Erasing done
> [fw.undi] Flashing 100%
> [fw.undi] Flashing done 100%
> [fw.netlist] Erasing
> [fw.netlist] Erasing done
> [fw.netlist] Flashing 100%
> [fw.netlist] Flashing done 100%
> Activate new firmware by devlink reload
> [root@host ~]# devlink dev reload pci/0000:ca:00.0 action fw_activate
> reload_actions_performed:
>     fw_activate
> [root@host ~]# ip link show ens7f0
> 19: ens7f0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc mq state UP mode DEFAULT group default qlen 1000
>     link/ether b4:96:91:dc:72:e0 brd ff:ff:ff:ff:ff:ff
>     altname enp202s0f0
> 
> Fixes: 399e27dbbd9e94 ("ice: support immediate firmware activation via devlink reload")
> Signed-off-by: Petr Oros <poros@redhat.com>
> ---
>  drivers/net/ethernet/intel/ice/ice_main.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
> index d768925785ca79..90ea2203cdc763 100644
> --- a/drivers/net/ethernet/intel/ice/ice_main.c
> +++ b/drivers/net/ethernet/intel/ice/ice_main.c
> @@ -6931,12 +6931,15 @@ static void ice_rebuild(struct ice_pf *pf, enum ice_reset_req reset_type)
>  
>  	dev_dbg(dev, "rebuilding PF after reset_type=%d\n", reset_type);
>  
> +#define ICE_EMP_RESET_SLEEP 5000

Ooof, 5 sec is a lot! Is there any way to poll the device readiness?
Does it really need the whole 5 sec?

>  	if (reset_type == ICE_RESET_EMPR) {
>  		/* If an EMP reset has occurred, any previously pending flash
>  		 * update will have completed. We no longer know whether or
>  		 * not the NVM update EMP reset is restricted.
>  		 */
>  		pf->fw_emp_reset_disabled = false;
> +
> +		msleep(ICE_EMP_RESET_SLEEP);
>  	}
>  
>  	err = ice_init_all_ctrlq(hw);
> -- 
> 2.35.1

Thanks,
Al
