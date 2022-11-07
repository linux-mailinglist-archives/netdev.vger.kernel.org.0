Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DE21C61F1D4
	for <lists+netdev@lfdr.de>; Mon,  7 Nov 2022 12:28:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231809AbiKGL2W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Nov 2022 06:28:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231808AbiKGL2Q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Nov 2022 06:28:16 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2CC91A3AE;
        Mon,  7 Nov 2022 03:28:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8C1EFB80F9F;
        Mon,  7 Nov 2022 11:28:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 586B4C433D6;
        Mon,  7 Nov 2022 11:28:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667820490;
        bh=gX0czMPTs+259vGom9QGdlIGR+c8u6kSHEipAFI8adA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=cvTLkC3VKRS9PtAELzxSU8KvwKLl0f7r4w9dHgMyB6a/OXsiruhEGzQN0QcVuBg+Z
         /PaoGMX43mD9PbvRm5DdocDSs3I7JFdPC8rDGJ1fP+UF3eC4G32sdRpgAml8IeiORp
         xvIrH8jnQofutAF5rio2BDGUbuH9pBOkiDGF1JiiaWVptKA9S/VmtXJq4b8a92Ln7F
         uEMnU8pZPFeXVtvSgBdCv2v3GwhppLvhl7t8aFHDKWPMKxszmZClEn2kKBIuGsCOVX
         lqU+DD6OEiC16RcBT5bmOuNtRUV6SL2ChUfq/xLPon/SrCMaEmbc+gOelhv3qbkA+Y
         G4JoRFRAf/i0g==
Date:   Mon, 7 Nov 2022 16:57:56 +0530
From:   Manivannan Sadhasivam <mani@kernel.org>
To:     Robert Marko <robimarko@gmail.com>
Cc:     kvalo@kernel.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, gregkh@linuxfoundation.org,
        elder@linaro.org, hemantk@codeaurora.org, quic_jhugo@quicinc.com,
        quic_qianyu@quicinc.com, bbhatt@codeaurora.org,
        mhi@lists.linux.dev, linux-arm-msm@vger.kernel.org,
        ath11k@lists.infradead.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, ansuelsmth@gmail.com
Subject: Re: [PATCH 1/2] bus: mhi: core: add SBL state callback
Message-ID: <20221107112756.GB2220@thinkpad>
References: <20221105194943.826847-1-robimarko@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20221105194943.826847-1-robimarko@gmail.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Nov 05, 2022 at 08:49:42PM +0100, Robert Marko wrote:
> Add support for SBL state callback in MHI core.
> 
> It is required for ath11k MHI devices in order to be able to set QRTR
> instance ID in the SBL state so that QRTR instance ID-s dont conflict in
> case of multiple PCI/MHI cards or AHB + PCI/MHI card.
> Setting QRTR instance ID is only possible in SBL state and there is
> currently no way to ensure that we are in that state, so provide a
> callback that the controller can trigger off.
> 

Where can I find the corresponding ath11k patch that makes use of this
callback?

Thanks,
Mani

> Signed-off-by: Robert Marko <robimarko@gmail.com>
> ---
>  drivers/bus/mhi/host/main.c | 1 +
>  include/linux/mhi.h         | 2 ++
>  2 files changed, 3 insertions(+)
> 
> diff --git a/drivers/bus/mhi/host/main.c b/drivers/bus/mhi/host/main.c
> index df0fbfee7b78..8b03dd1f0cb8 100644
> --- a/drivers/bus/mhi/host/main.c
> +++ b/drivers/bus/mhi/host/main.c
> @@ -900,6 +900,7 @@ int mhi_process_ctrl_ev_ring(struct mhi_controller *mhi_cntrl,
>  			switch (event) {
>  			case MHI_EE_SBL:
>  				st = DEV_ST_TRANSITION_SBL;
> +				mhi_cntrl->status_cb(mhi_cntrl, MHI_CB_EE_SBL_MODE);
>  				break;
>  			case MHI_EE_WFW:
>  			case MHI_EE_AMSS:
> diff --git a/include/linux/mhi.h b/include/linux/mhi.h
> index a5441ad33c74..beffe102dd19 100644
> --- a/include/linux/mhi.h
> +++ b/include/linux/mhi.h
> @@ -34,6 +34,7 @@ struct mhi_buf_info;
>   * @MHI_CB_SYS_ERROR: MHI device entered error state (may recover)
>   * @MHI_CB_FATAL_ERROR: MHI device entered fatal error state
>   * @MHI_CB_BW_REQ: Received a bandwidth switch request from device
> + * @MHI_CB_EE_SBL_MODE: MHI device entered SBL mode
>   */
>  enum mhi_callback {
>  	MHI_CB_IDLE,
> @@ -45,6 +46,7 @@ enum mhi_callback {
>  	MHI_CB_SYS_ERROR,
>  	MHI_CB_FATAL_ERROR,
>  	MHI_CB_BW_REQ,
> +	MHI_CB_EE_SBL_MODE,
>  };
>  
>  /**
> -- 
> 2.38.1
> 

-- 
மணிவண்ணன் சதாசிவம்
