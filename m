Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 93D0A41C205
	for <lists+netdev@lfdr.de>; Wed, 29 Sep 2021 11:51:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245196AbhI2Jw6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Sep 2021 05:52:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:38798 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S245079AbhI2Jw4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 29 Sep 2021 05:52:56 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B08BC613A5;
        Wed, 29 Sep 2021 09:51:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632909075;
        bh=TQQ+cjIN9++CtK9DgtuA6I+X1WnMjFRfMLxBOvN/9hI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=RDOtNOVfqPdKvpSr/OsPhNB0fjENTcC6due2YIfIDrAMsow0opiYt1QHJew4ql2n1
         fZH4NruBoG9wJO8wbT0XZJbvOC+xUiY29xWFOTMILMu96eFiy5sv/dZZ7M1arg9kJs
         7GltsB1HljAlqeovMRCxLsp8lK6AS/SlkTAt5UjPTSLE3nvQDh8DTRk4hRPx/qY3Wu
         Ljm7ukEFU/n7DLFsJw3WsBW0ZdKkSNdy4ty2WkKje0ftyfAwYt0JLv6bCNAmbKzOtE
         71e19ToUqhiQJknv1dNPYIjXnX1N8db1jYZmFGrSBIsCKGj8DAhwjqiVCn57wl0taE
         eBXytOfpUPuAw==
Date:   Wed, 29 Sep 2021 10:51:07 +0100
From:   Will Deacon <will@kernel.org>
To:     Arnd Bergmann <arnd@kernel.org>
Cc:     Bjorn Andersson <bjorn.andersson@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>, Rob Clark <robdclark@gmail.com>,
        Sean Paul <sean@poorly.run>, David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>,
        Joerg Roedel <joro@8bytes.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Alex Elder <elder@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        Andy Gross <agross@kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Maxime Ripard <mripard@kernel.org>,
        Chen-Yu Tsai <wens@csie.org>,
        Jernej Skrabec <jernej.skrabec@gmail.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Sudeep Holla <sudeep.holla@arm.com>,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        dri-devel@lists.freedesktop.org, freedreno@lists.freedesktop.org,
        iommu@lists.linux-foundation.org, linux-media@vger.kernel.org,
        linux-mmc@vger.kernel.org, netdev@vger.kernel.org,
        ath10k@lists.infradead.org, linux-wireless@vger.kernel.org,
        linux-gpio@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-sunxi@lists.linux.dev
Subject: Re: [PATCH] [RFC] qcom_scm: hide Kconfig symbol
Message-ID: <20210929095107.GA21057@willie-the-truck>
References: <20210927152412.2900928-1-arnd@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210927152412.2900928-1-arnd@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 27, 2021 at 05:22:13PM +0200, Arnd Bergmann wrote:
> From: Arnd Bergmann <arnd@arndb.de>
> 
> Now that SCM can be a loadable module, we have to add another
> dependency to avoid link failures when ipa or adreno-gpu are
> built-in:
> 
> aarch64-linux-ld: drivers/net/ipa/ipa_main.o: in function `ipa_probe':
> ipa_main.c:(.text+0xfc4): undefined reference to `qcom_scm_is_available'
> 
> ld.lld: error: undefined symbol: qcom_scm_is_available
> >>> referenced by adreno_gpu.c
> >>>               gpu/drm/msm/adreno/adreno_gpu.o:(adreno_zap_shader_load) in archive drivers/built-in.a
> 
> This can happen when CONFIG_ARCH_QCOM is disabled and we don't select
> QCOM_MDT_LOADER, but some other module selects QCOM_SCM. Ideally we'd
> use a similar dependency here to what we have for QCOM_RPROC_COMMON,
> but that causes dependency loops from other things selecting QCOM_SCM.
> 
> This appears to be an endless problem, so try something different this
> time:
> 
>  - CONFIG_QCOM_SCM becomes a hidden symbol that nothing 'depends on'
>    but that is simply selected by all of its users
> 
>  - All the stubs in include/linux/qcom_scm.h can go away
> 
>  - arm-smccc.h needs to provide a stub for __arm_smccc_smc() to
>    allow compile-testing QCOM_SCM on all architectures.
> 
>  - To avoid a circular dependency chain involving RESET_CONTROLLER
>    and PINCTRL_SUNXI, change the 'depends on RESET_CONTROLLER' in
>    the latter one to 'select'.
> 
> The last bit is rather annoying, as drivers should generally never
> 'select' another subsystem, and about half the users of the reset
> controller interface do this anyway.
> 
> Nevertheless, this version seems to pass all my randconfig tests
> and is more robust than any of the prior versions.
> 
> Comments?
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
>  drivers/firmware/Kconfig                |  4 +-
>  drivers/gpu/drm/msm/Kconfig             |  4 +-
>  drivers/iommu/Kconfig                   |  2 +-
>  drivers/media/platform/Kconfig          |  2 +-
>  drivers/mmc/host/Kconfig                |  2 +-
>  drivers/net/ipa/Kconfig                 |  1 +
>  drivers/net/wireless/ath/ath10k/Kconfig |  2 +-
>  drivers/pinctrl/qcom/Kconfig            |  3 +-
>  drivers/pinctrl/sunxi/Kconfig           |  6 +--
>  include/linux/arm-smccc.h               | 10 ++++
>  include/linux/qcom_scm.h                | 71 -------------------------
>  11 files changed, 23 insertions(+), 84 deletions(-)
> 
> diff --git a/drivers/firmware/Kconfig b/drivers/firmware/Kconfig
> index 220a58cf0a44..f7dd82ef0b9c 100644
> --- a/drivers/firmware/Kconfig
> +++ b/drivers/firmware/Kconfig
> @@ -203,9 +203,7 @@ config INTEL_STRATIX10_RSU
>  	  Say Y here if you want Intel RSU support.
>  
>  config QCOM_SCM
> -	tristate "Qcom SCM driver"
> -	depends on ARM || ARM64
> -	depends on HAVE_ARM_SMCCC
> +	tristate
>  	select RESET_CONTROLLER
>  
>  config QCOM_SCM_DOWNLOAD_MODE_DEFAULT
> diff --git a/drivers/gpu/drm/msm/Kconfig b/drivers/gpu/drm/msm/Kconfig
> index e9c6af78b1d7..3ddf739a6f9b 100644
> --- a/drivers/gpu/drm/msm/Kconfig
> +++ b/drivers/gpu/drm/msm/Kconfig
> @@ -17,7 +17,7 @@ config DRM_MSM
>  	select DRM_SCHED
>  	select SHMEM
>  	select TMPFS
> -	select QCOM_SCM if ARCH_QCOM
> +	select QCOM_SCM
>  	select WANT_DEV_COREDUMP
>  	select SND_SOC_HDMI_CODEC if SND_SOC
>  	select SYNC_FILE
> @@ -55,7 +55,7 @@ config DRM_MSM_GPU_SUDO
>  
>  config DRM_MSM_HDMI_HDCP
>  	bool "Enable HDMI HDCP support in MSM DRM driver"
> -	depends on DRM_MSM && QCOM_SCM
> +	depends on DRM_MSM
>  	default y
>  	help
>  	  Choose this option to enable HDCP state machine
> diff --git a/drivers/iommu/Kconfig b/drivers/iommu/Kconfig
> index 124c41adeca1..989c83acbfee 100644
> --- a/drivers/iommu/Kconfig
> +++ b/drivers/iommu/Kconfig
> @@ -308,7 +308,7 @@ config APPLE_DART
>  config ARM_SMMU
>  	tristate "ARM Ltd. System MMU (SMMU) Support"
>  	depends on ARM64 || ARM || (COMPILE_TEST && !GENERIC_ATOMIC64)
> -	depends on QCOM_SCM || !QCOM_SCM #if QCOM_SCM=m this can't be =y
> +	select QCOM_SCM
>  	select IOMMU_API
>  	select IOMMU_IO_PGTABLE_LPAE
>  	select ARM_DMA_USE_IOMMU if ARM

I don't want to get in the way of this patch because I'm also tired of the
randconfig failures caused by QCOM_SCM. However, ARM_SMMU is applicable to
a wide variety of (non-qcom) SoCs and so it seems a shame to require the
QCOM_SCM code to be included for all of those when it's not strictly needed
at all.

Will
