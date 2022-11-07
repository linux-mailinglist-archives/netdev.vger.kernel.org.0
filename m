Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D207C61FBD0
	for <lists+netdev@lfdr.de>; Mon,  7 Nov 2022 18:48:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232634AbiKGRsC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Nov 2022 12:48:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232990AbiKGRro (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Nov 2022 12:47:44 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59FE617A97;
        Mon,  7 Nov 2022 09:47:43 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EA9CD611E9;
        Mon,  7 Nov 2022 17:47:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36564C433D6;
        Mon,  7 Nov 2022 17:47:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667843262;
        bh=7WUGMjbQAmJLzpGQPB3dMUjNgFPkqKZ4u1QV1AW//uM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=QKVrLSoKk6VveD4mEiq0tyP6ZWWZy6zJq0azmvsoVf3N/PJK21QvWCb3UWNXi11my
         p4byXoesl/ETA0NdclkejgJalCRfpF5uf1TqyKTyTkhjUcA8z0Nl5oYZEDA/bEgIlc
         P51p41dxF3U+y/WKbelikyBFyomeVrn2O1iMP7Ll8lVVkMpKfbftkw8EJ3/QnOgF35
         dwb71wuhLDecU+w/8qsRYRD/+6xZKvvIC5+a3jY1gEzwtgHqIg4YoVWbXW1lsEIeKM
         gq8mc8rLYHgBXZeMDA+guPFWi+UR1wzH6aUKyF+QUGG4jV/aND6eWJWIUCdqBNfbEq
         Sxu2L/rqSMAQg==
Date:   Mon, 7 Nov 2022 23:17:27 +0530
From:   Manivannan Sadhasivam <mani@kernel.org>
To:     Robert Marko <robimarko@gmail.com>
Cc:     mani@kernel.org, kvalo@kernel.org, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        gregkh@linuxfoundation.org, elder@linaro.org,
        hemantk@codeaurora.org, quic_jhugo@quicinc.com,
        quic_qianyu@quicinc.com, bbhatt@codeaurora.org,
        mhi@lists.linux.dev, linux-arm-msm@vger.kernel.org,
        ath11k@lists.infradead.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, ansuelsmth@gmail.com
Subject: Re: [PATCH 2/2] wifi: ath11k: use unique QRTR instance ID
Message-ID: <20221107174727.GA7535@thinkpad>
References: <20221105194943.826847-1-robimarko@gmail.com>
 <20221105194943.826847-2-robimarko@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20221105194943.826847-2-robimarko@gmail.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Nov 05, 2022 at 08:49:43PM +0100, Robert Marko wrote:
> Currently, trying to use AHB + PCI/MHI cards or multiple PCI/MHI cards
> will cause a clash in the QRTR instance node ID and prevent the driver
> from talking via QMI to the card and thus initializing it with:
> [    9.836329] ath11k c000000.wifi: host capability request failed: 1 90
> [    9.842047] ath11k c000000.wifi: failed to send qmi host cap: -22
> 

There is still an outstanding issue where you cannot connect two WLAN modules
with same node id.

> So, in order to allow for this combination of cards, especially AHB + PCI
> cards like IPQ8074 + QCN9074 (Used by me and tested on) set the desired
> QRTR instance ID offset by calculating a unique one based on PCI domain
> and bus ID-s and writing it to bits 7-0 of BHI_ERRDBG2 MHI register by
> using the SBL state callback that is added as part of the series.
> We also have to make sure that new QRTR offset is added on top of the
> default QRTR instance ID-s that are currently used in the driver.
> 

Register BHI_ERRDBG2 is listed as Read only from Host as per the BHI spec.
So I'm not sure if this solution is going to work on all ath11k supported
chipsets.

Kalle, can you confirm?

> This finally allows using AHB + PCI or multiple PCI cards on the same
> system.
> 
> Before:
> root@OpenWrt:/# qrtr-lookup
>   Service Version Instance Node  Port
>      1054       1        0    7     1 <unknown>
>        69       1        2    7     3 ATH10k WLAN firmware service
> 
> After:
> root@OpenWrt:/# qrtr-lookup
>   Service Version Instance Node  Port
>      1054       1        0    7     1 <unknown>
>        69       1        2    7     3 ATH10k WLAN firmware service
>        15       1        0    8     1 Test service
>        69       1        8    8     2 ATH10k WLAN firmware service
> 
> Tested-on: IPQ8074 hw2.0 AHB WLAN.HK.2.5.0.1-01208-QCAHKSWPL_SILICONZ-1
> Tested-on: QCN9074 hw1.0 PCI WLAN.HK.2.5.0.1-01208-QCAHKSWPL_SILICONZ-1
> 
> Signed-off-by: Robert Marko <robimarko@gmail.com>
> ---
>  drivers/net/wireless/ath/ath11k/mhi.c | 47 ++++++++++++++++++---------
>  drivers/net/wireless/ath/ath11k/mhi.h |  3 ++
>  drivers/net/wireless/ath/ath11k/pci.c |  5 ++-
>  3 files changed, 38 insertions(+), 17 deletions(-)
> 
> diff --git a/drivers/net/wireless/ath/ath11k/mhi.c b/drivers/net/wireless/ath/ath11k/mhi.c
> index 86995e8dc913..23e85ea902f5 100644
> --- a/drivers/net/wireless/ath/ath11k/mhi.c
> +++ b/drivers/net/wireless/ath/ath11k/mhi.c
> @@ -294,6 +294,32 @@ static void ath11k_mhi_op_runtime_put(struct mhi_controller *mhi_cntrl)
>  {
>  }
>  
> +static int ath11k_mhi_op_read_reg(struct mhi_controller *mhi_cntrl,
> +				  void __iomem *addr,
> +				  u32 *out)
> +{
> +	*out = readl(addr);
> +
> +	return 0;
> +}
> +
> +static void ath11k_mhi_op_write_reg(struct mhi_controller *mhi_cntrl,
> +				    void __iomem *addr,
> +				    u32 val)
> +{
> +	writel(val, addr);
> +}
> +
> +static void ath11k_mhi_qrtr_instance_set(struct mhi_controller *mhi_cntrl)
> +{
> +	struct ath11k_base *ab = dev_get_drvdata(mhi_cntrl->cntrl_dev);
> +
> +	ath11k_mhi_op_write_reg(mhi_cntrl,
> +				mhi_cntrl->bhi + BHI_ERRDBG2,
> +				FIELD_PREP(QRTR_INSTANCE_MASK,
> +				ab->qmi.service_ins_id - ab->hw_params.qmi_service_ins_id));
> +}
> +
>  static char *ath11k_mhi_op_callback_to_str(enum mhi_callback reason)
>  {
>  	switch (reason) {
> @@ -315,6 +341,8 @@ static char *ath11k_mhi_op_callback_to_str(enum mhi_callback reason)
>  		return "MHI_CB_FATAL_ERROR";
>  	case MHI_CB_BW_REQ:
>  		return "MHI_CB_BW_REQ";
> +	case MHI_CB_EE_SBL_MODE:
> +		return "MHI_CB_EE_SBL_MODE";
>  	default:
>  		return "UNKNOWN";
>  	}
> @@ -336,27 +364,14 @@ static void ath11k_mhi_op_status_cb(struct mhi_controller *mhi_cntrl,
>  		if (!(test_bit(ATH11K_FLAG_UNREGISTERING, &ab->dev_flags)))
>  			queue_work(ab->workqueue_aux, &ab->reset_work);
>  		break;
> +	case MHI_CB_EE_SBL_MODE:
> +		ath11k_mhi_qrtr_instance_set(mhi_cntrl);

I still don't understand how SBL could make use of this information during
boot without waiting for an update.

Thanks,
Mani

> +		break;
>  	default:
>  		break;
>  	}
>  }
>  
> -static int ath11k_mhi_op_read_reg(struct mhi_controller *mhi_cntrl,
> -				  void __iomem *addr,
> -				  u32 *out)
> -{
> -	*out = readl(addr);
> -
> -	return 0;
> -}
> -
> -static void ath11k_mhi_op_write_reg(struct mhi_controller *mhi_cntrl,
> -				    void __iomem *addr,
> -				    u32 val)
> -{
> -	writel(val, addr);
> -}
> -
>  static int ath11k_mhi_read_addr_from_dt(struct mhi_controller *mhi_ctrl)
>  {
>  	struct device_node *np;
> diff --git a/drivers/net/wireless/ath/ath11k/mhi.h b/drivers/net/wireless/ath/ath11k/mhi.h
> index 8d9f852da695..0db308bc3047 100644
> --- a/drivers/net/wireless/ath/ath11k/mhi.h
> +++ b/drivers/net/wireless/ath/ath11k/mhi.h
> @@ -16,6 +16,9 @@
>  #define MHICTRL					0x38
>  #define MHICTRL_RESET_MASK			0x2
>  
> +#define BHI_ERRDBG2				0x38
> +#define QRTR_INSTANCE_MASK			GENMASK(7, 0)
> +
>  int ath11k_mhi_start(struct ath11k_pci *ar_pci);
>  void ath11k_mhi_stop(struct ath11k_pci *ar_pci);
>  int ath11k_mhi_register(struct ath11k_pci *ar_pci);
> diff --git a/drivers/net/wireless/ath/ath11k/pci.c b/drivers/net/wireless/ath/ath11k/pci.c
> index 99cf3357c66e..cd26c1567415 100644
> --- a/drivers/net/wireless/ath/ath11k/pci.c
> +++ b/drivers/net/wireless/ath/ath11k/pci.c
> @@ -370,13 +370,16 @@ static void ath11k_pci_sw_reset(struct ath11k_base *ab, bool power_on)
>  static void ath11k_pci_init_qmi_ce_config(struct ath11k_base *ab)
>  {
>  	struct ath11k_qmi_ce_cfg *cfg = &ab->qmi.ce_cfg;
> +	struct ath11k_pci *ab_pci = ath11k_pci_priv(ab);
> +	struct pci_bus *bus = ab_pci->pdev->bus;
>  
>  	cfg->tgt_ce = ab->hw_params.target_ce_config;
>  	cfg->tgt_ce_len = ab->hw_params.target_ce_count;
>  
>  	cfg->svc_to_ce_map = ab->hw_params.svc_to_ce_map;
>  	cfg->svc_to_ce_map_len = ab->hw_params.svc_to_ce_map_len;
> -	ab->qmi.service_ins_id = ab->hw_params.qmi_service_ins_id;
> +	ab->qmi.service_ins_id = ab->hw_params.qmi_service_ins_id +
> +	(((pci_domain_nr(bus) & 0xF) << 4) | (bus->number & 0xF));
>  
>  	ath11k_ce_get_shadow_config(ab, &cfg->shadow_reg_v2,
>  				    &cfg->shadow_reg_v2_len);
> -- 
> 2.38.1
> 
> 

-- 
மணிவண்ணன் சதாசிவம்
