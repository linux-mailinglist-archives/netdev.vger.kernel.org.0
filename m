Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 164AA67D67E
	for <lists+netdev@lfdr.de>; Thu, 26 Jan 2023 21:36:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232575AbjAZUf7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Jan 2023 15:35:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231655AbjAZUf6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Jan 2023 15:35:58 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E19EE728E6
        for <netdev@vger.kernel.org>; Thu, 26 Jan 2023 12:35:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1674765304;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=/3acAYFg343aBaQOikQ0aKIqJXF8w0Nm3+a/l/JWer0=;
        b=Y4ZoOlJwtG5aQ1RWRzjDoOvqiZdMx3nxH3mx7DgdgzoLzocyqg6e070DBDd+SUIpl2Npjj
        A9wHl0p98iEg2Es0Mg73Z9tGlAcWgaTvD+Ee5CIWyREF/PHVsTUrrFe0HDpty9sA0O0kEf
        7pLQQ9xWFc4xOyqTGeaQpDkwK9w/oaA=
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com
 [209.85.222.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-526-Y5NgWxjYME6QMaL_r-ijJQ-1; Thu, 26 Jan 2023 15:35:02 -0500
X-MC-Unique: Y5NgWxjYME6QMaL_r-ijJQ-1
Received: by mail-qk1-f199.google.com with SMTP id u11-20020a05620a430b00b007052a66d201so1761343qko.23
        for <netdev@vger.kernel.org>; Thu, 26 Jan 2023 12:35:02 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/3acAYFg343aBaQOikQ0aKIqJXF8w0Nm3+a/l/JWer0=;
        b=Cqhgg0/cF+YDfBt580FSAbLTgx/gbtvmL6lQaknCAqVsnJ1JXzZn1Dlze5m97PVdzM
         5AMMgZtcxPdIRhtWQnjnsxkWzXPnaECJvXetHyRn4dDjQfrfOp/0qB9imgqlkc1HCkYE
         DSMoSIEjX6ZNbr39rIwiX2dI2ISsoL59Ydvt/e8WiloOKtbN9nFbpHL1xM+Tkv4DmPAc
         sdxGEGqwcbcx6JwX0dfYU4XkqeJul2ArTOBciRu2S1/k02Z03w+Pf13D1hxcptH6l/My
         gCSz9dton+e9+eGcJCrjr+ymRdOw50jF9Wii8K2MgEIoOX9H8EsVJ224FRwuta7Jdc/M
         D0xg==
X-Gm-Message-State: AFqh2ko8gth1NZr1atO1RnHFRjeXQzEcpzIAcuGVuSsO/+vOzLYDFM/i
        IaAHbR0Lp/LFVfmUbOKisq4GvtvNJzkBJols52sAEvBNU48WK8C4HEtikbcpWayqxYRLdeX9pl8
        0W39Hpp84HwiZd3Z7
X-Received: by 2002:ac8:72ce:0:b0:3a5:ff6e:d43e with SMTP id o14-20020ac872ce000000b003a5ff6ed43emr51026149qtp.2.1674765301950;
        Thu, 26 Jan 2023 12:35:01 -0800 (PST)
X-Google-Smtp-Source: AMrXdXvawXxSE85cH7VlDOSx0KLjjmAX5cXCfTYY79GCeiB/r8zBVFxtdXe+Lsgpp8zV4eN6b8v2EA==
X-Received: by 2002:ac8:72ce:0:b0:3a5:ff6e:d43e with SMTP id o14-20020ac872ce000000b003a5ff6ed43emr51026089qtp.2.1674765301492;
        Thu, 26 Jan 2023 12:35:01 -0800 (PST)
Received: from localhost (nat-pool-bos-t.redhat.com. [66.187.233.206])
        by smtp.gmail.com with ESMTPSA id e11-20020ac8414b000000b003b63c08a888sm1431243qtm.4.2023.01.26.12.35.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Jan 2023 12:35:00 -0800 (PST)
Date:   Thu, 26 Jan 2023 15:35:00 -0500
From:   Eric Chanudet <echanude@redhat.com>
To:     Bartosz Golaszewski <brgl@bgdev.pl>
Cc:     Andy Gross <agross@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konrad.dybcio@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Michael Turquette <mturquette@baylibre.com>,
        Stephen Boyd <sboyd@kernel.org>,
        Georgi Djakov <djakov@kernel.org>,
        Will Deacon <will@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>,
        Joerg Roedel <joro@8bytes.org>,
        Manivannan Sadhasivam <mani@kernel.org>,
        Jassi Brar <jassisinghbrar@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Vinod Koul <vkoul@kernel.org>, Alex Elder <elder@kernel.org>,
        linux-arm-msm@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-clk@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        iommu@lists.linux.dev, linux-gpio@vger.kernel.org,
        netdev@vger.kernel.org,
        Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Subject: Re: [PATCH 18/18] arm64: dts: qcom: add initial support for qcom
 sa8775p-ride
Message-ID: <20230126203500.wd3mhihk4zjsop2w@echanude>
References: <20230109174511.1740856-1-brgl@bgdev.pl>
 <20230109174511.1740856-19-brgl@bgdev.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230109174511.1740856-19-brgl@bgdev.pl>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 09, 2023 at 06:45:11PM +0100, Bartosz Golaszewski wrote:
> From: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
> 
> This adds basic support for the Qualcomm sa8775p platform and the
> reference board: sa8775p-ride. The dt files describe the basics of the
> SoC and enable booting to shell.
> 
> Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
> ---
>  arch/arm64/boot/dts/qcom/Makefile         |   1 +
>  arch/arm64/boot/dts/qcom/sa8775p-ride.dts |  39 +
>  arch/arm64/boot/dts/qcom/sa8775p.dtsi     | 841 ++++++++++++++++++++++
>  3 files changed, 881 insertions(+)
>  create mode 100644 arch/arm64/boot/dts/qcom/sa8775p-ride.dts
>  create mode 100644 arch/arm64/boot/dts/qcom/sa8775p.dtsi
> 
> diff --git a/arch/arm64/boot/dts/qcom/Makefile b/arch/arm64/boot/dts/qcom/Makefile
> index 3e79496292e7..39b8206f7131 100644
> --- a/arch/arm64/boot/dts/qcom/Makefile
> +++ b/arch/arm64/boot/dts/qcom/Makefile
> @@ -61,6 +61,7 @@ dtb-$(CONFIG_ARCH_QCOM)	+= qrb5165-rb5-vision-mezzanine.dtb
>  dtb-$(CONFIG_ARCH_QCOM)	+= sa8155p-adp.dtb
>  dtb-$(CONFIG_ARCH_QCOM)	+= sa8295p-adp.dtb
>  dtb-$(CONFIG_ARCH_QCOM)	+= sa8540p-ride.dtb
> +dtb-$(CONFIG_ARCH_QCOM) += sa8775p-ride.dtb
>  dtb-$(CONFIG_ARCH_QCOM)	+= sc7180-idp.dtb
>  dtb-$(CONFIG_ARCH_QCOM)	+= sc7180-trogdor-coachz-r1.dtb
>  dtb-$(CONFIG_ARCH_QCOM)	+= sc7180-trogdor-coachz-r1-lte.dtb
> diff --git a/arch/arm64/boot/dts/qcom/sa8775p-ride.dts b/arch/arm64/boot/dts/qcom/sa8775p-ride.dts
> new file mode 100644
> index 000000000000..d4dae32a84cc
> --- /dev/null
> +++ b/arch/arm64/boot/dts/qcom/sa8775p-ride.dts
> @@ -0,0 +1,39 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +/*
> + * Copyright (c) 2023, Linaro Limited
> + */
> +
> +/dts-v1/;
> +
> +#include "sa8775p.dtsi"
> +
> +/ {
> +	model = "Qualcomm SA8875P Ride";

s/SA8875P/SA8775P/

> +	compatible = "qcom,sa8775p-ride", "qcom,sa8775p";
> +
> +	aliases {
> +		serial0 = &uart10;
> +	};
> +
> +	chosen {
> +		stdout-path = "serial0:115200n8";
> +	};

Tested-by: Eric Chanudet <echanude@redhat.com>

I could not get past ABL on sa8775p-ride initially. It seems it requires
__symbols__ to be in the DTB and looks for at least qcom_tzlog:
        qcom_tzlog: tz-log@146aa720 {
                compatible = "qcom,tz-log";
                reg = <0x146aa720 0x3000>;
                qcom,hyplog-enabled;
                hyplog-address-offset = <0x410>;
                hyplog-size-offset = <0x414>;
        };

In addition, an early hang happened without the following work-around:
--- a/drivers/firmware/smccc/smccc.c
+++ b/drivers/firmware/smccc/smccc.c
@@ -23,7 +23,7 @@ void __init arm_smccc_version_init(u32 version, enum arm_smccc_conduit conduit)
        smccc_version = version;
        smccc_conduit = conduit;
 
-       smccc_trng_available = smccc_probe_trng();
+       smccc_trng_available = false /* smccc_probe_trng() */;
        if (IS_ENABLED(CONFIG_ARM64_SVE) &&
            smccc_version >= ARM_SMCCC_VERSION_1_3)
                smccc_has_sve_hint = true;

This is not related to this patch set directly, I am merely mentioning
it in case someone else encounters the issue.

> +};
> +
> +&qupv3_id_1 {
> +	status = "okay";
> +};
> +
> +&uart10 {
> +	compatible = "qcom,geni-debug-uart";
> +	status = "okay";
> +	pinctrl-names = "default";
> +	pinctrl-0 = <&qup_uart10_state>;
> +};
> +
> +&tlmm {
> +	qup_uart10_state: qup_uart10_state {
> +		pins = "gpio46", "gpio47";
> +		function = "qup1_se3";
> +	};
> +};
> diff --git a/arch/arm64/boot/dts/qcom/sa8775p.dtsi b/arch/arm64/boot/dts/qcom/sa8775p.dtsi
> new file mode 100644
> index 000000000000..1a3b11628e38
> --- /dev/null
> +++ b/arch/arm64/boot/dts/qcom/sa8775p.dtsi
> @@ -0,0 +1,841 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +/*
> + * Copyright (c) 2023, Linaro Limited
> + */
> +
> +#include <dt-bindings/interrupt-controller/arm-gic.h>
> +#include <dt-bindings/clock/qcom,gcc-sa8775p.h>
> +#include <dt-bindings/clock/qcom,rpmh.h>
> +#include <dt-bindings/interconnect/qcom,sa8775p.h>
> +#include <dt-bindings/power/qcom-rpmpd.h>
> +#include <dt-bindings/soc/qcom,rpmh-rsc.h>
> +
> +/ {
> +	interrupt-parent = <&intc>;
> +
> +	#address-cells = <2>;
> +	#size-cells = <2>;
> +
> +	clocks {
> +		xo_board_clk: xo-board-clk {
> +			compatible = "fixed-clock";
> +			#clock-cells = <0>;
> +		};
> +
> +		sleep_clk: sleep-clk {
> +			compatible = "fixed-clock";
> +			#clock-cells = <0>;
> +			clock-frequency = <32764>;
> +		};
> +	};
> +
> +	cpus {
> +		#address-cells = <2>;
> +		#size-cells = <0>;
> +
> +		CPU0: cpu@0 {
> +			device_type = "cpu";
> +			compatible = "qcom,kryo";
> +			reg = <0x0 0x0>;
> +			enable-method = "psci";
> +			next-level-cache = <&L2_0>;
> +			L2_0: l2-cache {
> +			      compatible = "cache";
> +			      next-level-cache = <&L3_0>;
> +				L3_0: l3-cache {
> +				      compatible = "cache";
> +				};
> +			};
> +		};
> +
> +		CPU1: cpu@100 {
> +			device_type = "cpu";
> +			compatible = "qcom,kryo";
> +			reg = <0x0 0x100>;
> +			enable-method = "psci";
> +			cpu-release-addr = <0x0 0x90000000>;
> +			next-level-cache = <&L2_1>;
> +			L2_1: l2-cache {
> +			      compatible = "cache";
> +			      next-level-cache = <&L3_0>;
> +			};
> +		};
> +
> +		CPU2: cpu@200 {
> +			device_type = "cpu";
> +			compatible = "qcom,kryo";
> +			reg = <0x0 0x200>;
> +			enable-method = "psci";
> +			next-level-cache = <&L2_2>;
> +			L2_2: l2-cache {
> +			      compatible = "cache";
> +			      next-level-cache = <&L3_0>;
> +			};
> +		};
> +
> +		CPU3: cpu@300 {
> +			device_type = "cpu";
> +			compatible = "qcom,kryo";
> +			reg = <0x0 0x300>;
> +			enable-method = "psci";
> +			next-level-cache = <&L2_3>;
> +			L2_3: l2-cache {
> +			      compatible = "cache";
> +			      next-level-cache = <&L3_0>;
> +			};
> +		};
> +
> +		CPU4: cpu@10000 {
> +			device_type = "cpu";
> +			compatible = "qcom,kryo";
> +			reg = <0x0 0x10000>;
> +			enable-method = "psci";
> +			next-level-cache = <&L2_4>;
> +			L2_4: l2-cache {
> +			      compatible = "cache";
> +			      next-level-cache = <&L3_1>;
> +				L3_1: l3-cache {
> +				      compatible = "cache";
> +				};
> +
> +			};
> +		};
> +
> +		CPU5: cpu@10100 {
> +			device_type = "cpu";
> +			compatible = "qcom,kryo";
> +			reg = <0x0 0x10100>;
> +			enable-method = "psci";
> +			next-level-cache = <&L2_5>;
> +			L2_5: l2-cache {
> +			      compatible = "cache";
> +			      next-level-cache = <&L3_1>;
> +			};
> +		};
> +
> +		CPU6: cpu@10200 {
> +			device_type = "cpu";
> +			compatible = "qcom,kryo";
> +			reg = <0x0 0x10200>;
> +			enable-method = "psci";
> +			next-level-cache = <&L2_6>;
> +			L2_6: l2-cache {
> +			      compatible = "cache";
> +			      next-level-cache = <&L3_1>;
> +			};
> +		};
> +
> +		CPU7: cpu@10300 {
> +			device_type = "cpu";
> +			compatible = "qcom,kryo";
> +			reg = <0x0 0x10300>;
> +			enable-method = "psci";
> +			next-level-cache = <&L2_7>;
> +			L2_7: l2-cache {
> +			      compatible = "cache";
> +			      next-level-cache = <&L3_1>;
> +			};
> +		};
> +
> +		cpu-map {
> +			cluster0 {
> +				core0 {
> +					cpu = <&CPU0>;
> +				};
> +
> +				core1 {
> +					cpu = <&CPU1>;
> +				};
> +
> +				core2 {
> +					cpu = <&CPU2>;
> +				};
> +
> +				core3 {
> +					cpu = <&CPU3>;
> +				};
> +			};
> +
> +			cluster1 {
> +				core0 {
> +					cpu = <&CPU4>;
> +				};
> +
> +				core1 {
> +					cpu = <&CPU5>;
> +				};
> +
> +				core2 {
> +					cpu = <&CPU6>;
> +				};
> +
> +				core3 {
> +					cpu = <&CPU7>;
> +				};
> +			};
> +		};
> +	};
> +
> +	/* Will be updated by the bootloader. */
> +	memory {
> +		device_type = "memory";
> +		reg = <0 0 0 0>;
> +	};
> +
> +	reserved-memory {
> +		#address-cells = <2>;
> +		#size-cells = <2>;
> +		ranges;
> +
> +		sail_ss_mem: sail_ss_region@80000000 {
> +			no-map;
> +			reg = <0x0 0x80000000 0x0 0x10000000>;
> +		};
> +
> +		hyp_mem: hyp_region@90000000 {
> +			no-map;
> +			reg = <0x0 0x90000000 0x0 0x600000>;
> +		};
> +
> +		xbl_boot_mem: xbl_boot_region@90600000 {
> +			no-map;
> +			reg = <0x0 0x90600000 0x0 0x200000>;
> +		};
> +
> +		aop_image_mem: aop_image_region@90800000 {
> +			no-map;
> +			reg = <0x0 0x90800000 0x0 0x60000>;
> +		};
> +
> +		aop_cmd_db_mem: aop_cmd_db_region@90860000 {
> +			compatible = "qcom,cmd-db";
> +			no-map;
> +			reg = <0x0 0x90860000 0x0 0x20000>;
> +		};
> +
> +		uefi_log: uefi_log_region@908b0000 {
> +			no-map;
> +			reg = <0x0 0x908b0000 0x0 0x10000>;
> +		};
> +
> +		reserved_mem: reserved_region@908f0000 {
> +			no-map;
> +			reg = <0x0 0x908f0000 0x0 0xf000>;
> +		};
> +
> +		secdata_apss_mem: secdata_apss_region@908ff000 {
> +			no-map;
> +			reg = <0x0 0x908ff000 0x0 0x1000>;
> +		};
> +
> +		smem_mem: smem_region@90900000 {
> +			compatible = "qcom,smem";
> +			reg = <0x0 0x90900000 0x0 0x200000>;
> +			no-map;
> +			hwlocks = <&tcsr_mutex 3>;
> +		};
> +
> +		cpucp_fw_mem: cpucp_fw_region@90b00000 {
> +			no-map;
> +			reg = <0x0 0x90b00000 0x0 0x100000>;
> +		};
> +
> +		lpass_machine_learning_mem: lpass_machine_learning_region@93b00000 {
> +			no-map;
> +			reg = <0x0 0x93b00000 0x0 0xf00000>;
> +		};
> +
> +		adsp_rpc_remote_heap_mem: adsp_rpc_remote_heap_region@94a00000 {
> +			no-map;
> +			reg = <0x0 0x94a00000 0x0 0x800000>;
> +		};
> +
> +		pil_camera_mem: pil_camera_region@95200000 {
> +			no-map;
> +			reg = <0x0 0x95200000 0x0 0x500000>;
> +		};
> +
> +		pil_adsp_mem: pil_adsp_region@95c00000 {
> +			no-map;
> +			reg = <0x0 0x95c00000 0x0 0x1e00000>;
> +		};
> +
> +		pil_gdsp0_mem: pil_gdsp0_region@97b00000 {
> +			no-map;
> +			reg = <0x0 0x97b00000 0x0 0x1e00000>;
> +		};
> +
> +		pil_gdsp1_mem: pil_gdsp1_region@99900000 {
> +			no-map;
> +			reg = <0x0 0x99900000 0x0 0x1e00000>;
> +		};
> +
> +		pil_cdsp0_mem: pil_cdsp0_region@9b800000 {
> +			no-map;
> +			reg = <0x0 0x9b800000 0x0 0x1e00000>;
> +		};
> +
> +		pil_gpu_mem: pil_gpu_region@9d600000 {
> +			no-map;
> +			reg = <0x0 0x9d600000 0x0 0x2000>;
> +		};
> +
> +		pil_cdsp1_mem: pil_cdsp1_region@9d700000 {
> +			no-map;
> +			reg = <0x0 0x9d700000 0x0 0x1e00000>;
> +		};
> +
> +		pil_cvp_mem: pil_cvp_region@9f500000 {
> +			no-map;
> +			reg = <0x0 0x9f500000 0x0 0x700000>;
> +		};
> +
> +		pil_video_mem: pil_video_region@9fc00000 {
> +			no-map;
> +			reg = <0x0 0x9fc00000 0x0 0x700000>;
> +		};
> +
> +		hyptz_reserved_mem: hyptz_reserved_region@beb00000 {
> +			no-map;
> +			reg = <0x0 0xbeb00000 0x0 0x11500000>;
> +		};
> +
> +		tz_stat_mem: tz_stat_region@d0000000 {
> +			no-map;
> +			reg = <0x0 0xd0000000 0x0 0x100000>;
> +		};
> +
> +		tags_mem: tags_region@d0100000 {
> +			no-map;
> +			reg = <0x0 0xd0100000 0x0 0x1200000>;
> +		};
> +
> +		qtee_mem: qtee_region@d1300000 {
> +			no-map;
> +			reg = <0x0 0xd1300000 0x0 0x500000>;
> +		};
> +
> +		trusted_apps_mem: trusted_apps_region@d1800000 {
> +			no-map;
> +			reg = <0x0 0xd1800000 0x0 0x3900000>;
> +		};
> +
> +		dump_mem: mem_dump_region {
> +			compatible = "shared-dma-pool";
> +			alloc-ranges = <0x0 0x00000000 0x0 0xffffffff>;
> +			reusable;
> +			size = <0 0x3000000>;
> +		};
> +
> +		/* global autoconfigured region for contiguous allocations */
> +		linux,cma {
> +			compatible = "shared-dma-pool";
> +			alloc-ranges = <0x0 0x00000000 0x0 0xdfffffff>;
> +			reusable;
> +			alignment = <0x0 0x400000>;
> +			size = <0x0 0x2000000>;
> +			linux,cma-default;
> +		};
> +	};
> +
> +	psci {
> +		compatible = "arm,psci-1.0";
> +		method = "smc";
> +	};
> +
> +	firmware {
> +		scm {
> +			compatible = "qcom,scm";
> +		};
> +	};
> +
> +	qup_opp_table_100mhz: qup-100mhz-opp-table {
> +		compatible = "operating-points-v2";
> +
> +		opp-100000000 {
> +			opp-hz = /bits/ 64 <100000000>;
> +			required-opps = <&rpmhpd_opp_svs_l1>;
> +		};
> +	};
> +
> +	soc: soc@0 {
> +		compatible = "simple-bus";
> +		#address-cells = <1>;
> +		#size-cells = <1>;
> +		ranges = <0 0 0 0xffffffff>;
> +
> +		gcc: clock-controller@100000 {
> +			compatible = "qcom,gcc-sa8775p";
> +			reg = <0x100000 0xc7018>;
> +			#clock-cells = <1>;
> +			#reset-cells = <1>;
> +			#power-domain-cells = <1>;
> +			clocks = <&rpmhcc RPMH_CXO_CLK>,
> +				 <&sleep_clk>,
> +				 <0>,
> +				 <0>,
> +				 <0>,
> +				 <0>,
> +				 <0>,
> +				 <0>,
> +				 <0>,
> +				 <0>,
> +				 <0>, /* TODO: usb_0_ssphy */
> +				 <0>,
> +				 <0>,
> +				 <0>,
> +				 <0>;
> +			power-domains = <&rpmhpd SA8775P_CX>;
> +		};
> +
> +		ipcc: mailbox@408000 {
> +			compatible = "qcom,sa8775p-ipcc", "qcom,ipcc";
> +			reg = <0x408000 0x1000>;
> +			interrupts = <GIC_SPI 229 IRQ_TYPE_LEVEL_HIGH>;
> +			interrupt-controller;
> +			#interrupt-cells = <3>;
> +			#mbox-cells = <2>;
> +		};
> +
> +		aggre1_noc:interconnect-aggre1-noc {
> +			compatible = "qcom,sa8775p-aggre1-noc";
> +			#interconnect-cells = <2>;
> +			qcom,bcm-voters = <&apps_bcm_voter>;
> +		};
> +
> +		aggre2_noc: interconnect-aggre2-noc {
> +			compatible = "qcom,sa8775p-aggre2-noc";
> +			#interconnect-cells = <2>;
> +			qcom,bcm-voters = <&apps_bcm_voter>;
> +		};
> +
> +		clk_virt: interconnect-clk-virt {
> +			compatible = "qcom,sa8775p-clk-virt";
> +			#interconnect-cells = <2>;
> +			qcom,bcm-voters = <&apps_bcm_voter>;
> +		};
> +
> +		config_noc: interconnect-config-noc {
> +			compatible = "qcom,sa8775p-config-noc";
> +			#interconnect-cells = <2>;
> +			qcom,bcm-voters = <&apps_bcm_voter>;
> +		};
> +
> +		dc_noc: interconnect-dc-noc {
> +			compatible = "qcom,sa8775p-dc-noc";
> +			#interconnect-cells = <2>;
> +			qcom,bcm-voters = <&apps_bcm_voter>;
> +		};
> +
> +		gem_noc: interconnect-gem-noc {
> +			compatible = "qcom,sa8775p-gem-noc";
> +			#interconnect-cells = <2>;
> +			qcom,bcm-voters = <&apps_bcm_voter>;
> +		};
> +
> +		gpdsp_anoc: interconnect-gpdsp-anoc {
> +			compatible = "qcom,sa8775p-gpdsp-anoc";
> +			#interconnect-cells = <2>;
> +			qcom,bcm-voters = <&apps_bcm_voter>;
> +		};
> +
> +		lpass_ag_noc: interconnect-lpass-ag-noc {
> +			compatible = "qcom,sa8775p-lpass-ag-noc";
> +			#interconnect-cells = <2>;
> +			qcom,bcm-voters = <&apps_bcm_voter>;
> +		};
> +
> +		mc_virt: interconnect-mc-virt {
> +			compatible = "qcom,sa8775p-mc-virt";
> +			#interconnect-cells = <2>;
> +			qcom,bcm-voters = <&apps_bcm_voter>;
> +		};
> +
> +		mmss_noc: interconnect-mmss-noc {
> +			compatible = "qcom,sa8775p-mmss-noc";
> +			#interconnect-cells = <2>;
> +			qcom,bcm-voters = <&apps_bcm_voter>;
> +		};
> +
> +		nspa_noc: interconnect-nspa-noc {
> +			compatible = "qcom,sa8775p-nspa-noc";
> +			#interconnect-cells = <2>;
> +			qcom,bcm-voters = <&apps_bcm_voter>;
> +		};
> +
> +		nspb_noc: interconnect-nspb-noc {
> +			compatible = "qcom,sa8775p-nspb-noc";
> +			#interconnect-cells = <2>;
> +			qcom,bcm-voters = <&apps_bcm_voter>;
> +		};
> +
> +		pcie_anoc: interconnect-pcie-anoc {
> +			compatible = "qcom,sa8775p-pcie-anoc";
> +			#interconnect-cells = <2>;
> +			qcom,bcm-voters = <&apps_bcm_voter>;
> +		};
> +
> +		system_noc: interconnect-system-noc {
> +			compatible = "qcom,sa8775p-system-noc";
> +			#interconnect-cells = <2>;
> +			qcom,bcm-voters = <&apps_bcm_voter>;
> +		};
> +
> +		intc: interrupt-controller@17a00000 {
> +			compatible = "arm,gic-v3";
> +			#interrupt-cells = <3>;
> +			interrupt-controller;
> +			#address-cells = <1>;
> +			#size-cells = <1>;
> +			ranges;
> +			#redistributor-regions = <1>;
> +			redistributor-stride = <0x0 0x20000>;
> +			reg = <0x17a00000 0x10000>,     /* GICD */
> +			      <0x17a60000 0x100000>;    /* GICR * 8 */
> +			interrupts = <GIC_PPI 9 IRQ_TYPE_LEVEL_HIGH>;
> +		};
> +
> +		apps_rsc: rsc@18200000 {
> +			compatible = "qcom,rpmh-rsc";
> +			reg = <0x18200000 0x10000>,
> +			      <0x18210000 0x10000>,
> +			      <0x18220000 0x10000>;
> +			reg-names = "drv-0", "drv-1", "drv-2";
> +			interrupts = <GIC_SPI 3 IRQ_TYPE_LEVEL_HIGH>,
> +			      <GIC_SPI 4 IRQ_TYPE_LEVEL_HIGH>,
> +			      <GIC_SPI 5 IRQ_TYPE_LEVEL_HIGH>;
> +			qcom,tcs-offset = <0xd00>;
> +			qcom,drv-id = <2>;
> +			qcom,tcs-config = <ACTIVE_TCS 2>,
> +					  <SLEEP_TCS 3>,
> +					  <WAKE_TCS 3>,
> +					  <CONTROL_TCS 0>;
> +			label = "apps_rsc";
> +
> +			apps_bcm_voter: bcm_voter {
> +				compatible = "qcom,bcm-voter";
> +			};
> +
> +			rpmhcc: clock-controller {
> +				compatible = "qcom,sa8775p-rpmh-clk";
> +				#clock-cells = <1>;
> +				clock-names = "xo";
> +				clocks = <&xo_board_clk>;
> +			};
> +
> +			rpmhpd: power-controller {
> +				compatible = "qcom,sa8775p-rpmhpd";
> +				#power-domain-cells = <1>;
> +				operating-points-v2 = <&rpmhpd_opp_table>;
> +
> +				rpmhpd_opp_table: opp-table {
> +					compatible = "operating-points-v2";
> +
> +					rpmhpd_opp_ret: opp1 {
> +						opp-level = <RPMH_REGULATOR_LEVEL_RETENTION>;
> +					};
> +
> +					rpmhpd_opp_min_svs: opp2 {
> +						opp-level = <RPMH_REGULATOR_LEVEL_MIN_SVS>;
> +					};
> +
> +					rpmhpd_opp_low_svs: opp3 {
> +						opp-level = <RPMH_REGULATOR_LEVEL_LOW_SVS>;
> +					};
> +
> +					rpmhpd_opp_svs: opp4 {
> +						opp-level = <RPMH_REGULATOR_LEVEL_SVS>;
> +					};
> +
> +					rpmhpd_opp_svs_l1: opp5 {
> +						opp-level = <RPMH_REGULATOR_LEVEL_SVS_L1>;
> +					};
> +
> +					rpmhpd_opp_nom: opp6 {
> +						opp-level = <RPMH_REGULATOR_LEVEL_NOM>;
> +					};
> +
> +					rpmhpd_opp_nom_l1: opp7 {
> +						opp-level = <RPMH_REGULATOR_LEVEL_NOM_L1>;
> +					};
> +
> +					rpmhpd_opp_nom_l2: opp8 {
> +						opp-level = <RPMH_REGULATOR_LEVEL_NOM_L2>;
> +					};
> +
> +					rpmhpd_opp_turbo: opp9 {
> +						opp-level = <RPMH_REGULATOR_LEVEL_TURBO>;
> +					};
> +
> +					rpmhpd_opp_turbo_l1: opp10 {
> +						opp-level = <RPMH_REGULATOR_LEVEL_TURBO_L1>;
> +					};
> +				};
> +			};
> +		};
> +
> +		arch_timer: timer {
> +			compatible = "arm,armv8-timer";
> +			interrupts = <GIC_PPI 13 (GIC_CPU_MASK_SIMPLE(8) | IRQ_TYPE_LEVEL_LOW)>,
> +				     <GIC_PPI 14 (GIC_CPU_MASK_SIMPLE(8) | IRQ_TYPE_LEVEL_LOW)>,
> +				     <GIC_PPI 11 (GIC_CPU_MASK_SIMPLE(8) | IRQ_TYPE_LEVEL_LOW)>,
> +				     <GIC_PPI 12 (GIC_CPU_MASK_SIMPLE(8) | IRQ_TYPE_LEVEL_LOW)>;
> +			clock-frequency = <19200000>;
> +		};
> +
> +		memtimer: timer@17c20000 {
> +			#address-cells = <1>;
> +			#size-cells = <1>;
> +			ranges;
> +			compatible = "arm,armv7-timer-mem";
> +			reg = <0x17c20000 0x1000>;
> +			clock-frequency = <19200000>;
> +
> +			frame@17c21000 {
> +				frame-number = <0>;
> +				interrupts = <GIC_SPI 8 IRQ_TYPE_LEVEL_HIGH>,
> +					     <GIC_SPI 6 IRQ_TYPE_LEVEL_HIGH>;
> +				reg = <0x17c21000 0x1000>,
> +				      <0x17c22000 0x1000>;
> +			};
> +
> +			frame@17c23000 {
> +				frame-number = <1>;
> +				interrupts = <GIC_SPI 9 IRQ_TYPE_LEVEL_HIGH>;
> +				reg = <0x17c23000 0x1000>;
> +				status = "disabled";
> +			};
> +
> +			frame@17c25000 {
> +				frame-number = <2>;
> +				interrupts = <GIC_SPI 10 IRQ_TYPE_LEVEL_HIGH>;
> +				reg = <0x17c25000 0x1000>;
> +				status = "disabled";
> +			};
> +
> +			frame@17c27000 {
> +				frame-number = <3>;
> +				interrupts = <GIC_SPI 11 IRQ_TYPE_LEVEL_HIGH>;
> +				reg = <0x17c27000 0x1000>;
> +				status = "disabled";
> +			};
> +
> +			frame@17c29000 {
> +				frame-number = <4>;
> +				interrupts = <GIC_SPI 12 IRQ_TYPE_LEVEL_HIGH>;
> +				reg = <0x17c29000 0x1000>;
> +				status = "disabled";
> +			};
> +
> +			frame@17c2b000 {
> +				frame-number = <5>;
> +				interrupts = <GIC_SPI 13 IRQ_TYPE_LEVEL_HIGH>;
> +				reg = <0x17c2b000 0x1000>;
> +				status = "disabled";
> +			};
> +
> +			frame@17c2d000 {
> +				frame-number = <6>;
> +				interrupts = <GIC_SPI 14 IRQ_TYPE_LEVEL_HIGH>;
> +				reg = <0x17c2d000 0x1000>;
> +				status = "disabled";
> +			};
> +		};
> +
> +		tcsr_mutex: hwlock@1f40000 {
> +			compatible = "qcom,tcsr-mutex";
> +			reg = <0x1f40000 0x20000>;
> +			#hwlock-cells = <1>;
> +		};
> +
> +		tlmm: pinctrl@f000000 {
> +			compatible = "qcom,sa8775p-pinctrl";
> +			reg = <0xf000000 0x1000000>;
> +			interrupts = <GIC_SPI 208 IRQ_TYPE_LEVEL_HIGH>;
> +			gpio-controller;
> +			#gpio-cells = <2>;
> +			interrupt-controller;
> +			#interrupt-cells = <2>;
> +			gpio-ranges = <&tlmm 0 0 149>;
> +		};
> +
> +		qcom-wdt@17c10000 {
> +			compatible = "qcom,kpss-wdt";
> +			reg = <0x17c10000 0x1000>;
> +			clocks = <&sleep_clk>;
> +			interrupts = <GIC_SPI 0 IRQ_TYPE_LEVEL_HIGH>;
> +		};
> +
> +		qupv3_id_1: geniqup@ac0000 {
> +			compatible = "qcom,geni-se-qup";
> +			reg = <0xac0000 0x6000>;
> +			#address-cells = <1>;
> +			#size-cells = <1>;
> +			ranges;
> +			clock-names = "m-ahb", "s-ahb";
> +			clocks = <&gcc GCC_QUPV3_WRAP_1_M_AHB_CLK>,
> +				 <&gcc GCC_QUPV3_WRAP_1_S_AHB_CLK>;
> +			iommus = <&apps_smmu 0x443 0x0>;
> +			status = "disabled";
> +
> +			uart10: serial@a8c000 {
> +				compatible = "qcom,geni-uart";
> +				reg = <0xa8c000 0x4000>;
> +				interrupts = <GIC_SPI 356 IRQ_TYPE_LEVEL_HIGH>;
> +				clock-names = "se";
> +				clocks = <&gcc GCC_QUPV3_WRAP1_S3_CLK>;
> +				interconnect-names = "qup-core", "qup-config", "qup-memory";
> +				interconnects = <&clk_virt MASTER_QUP_CORE_1 0 &clk_virt SLAVE_QUP_CORE_1 0>,
> +						<&gem_noc MASTER_APPSS_PROC 0 &config_noc SLAVE_QUP_1 0>,
> +						<&aggre2_noc MASTER_QUP_1 0 &mc_virt SLAVE_EBI1 0>;
> +				power-domains = <&rpmhpd SA8775P_CX>;
> +				operating-points-v2 = <&qup_opp_table_100mhz>;
> +				status = "disabled";
> +			};
> +		};
> +
> +		apps_smmu: apps-smmu@15000000 {
> +			compatible = "qcom,sa8775p-smmu-500", "arm,mmu-500";
> +			reg = <0x15000000 0x100000>, <0x15182000 0x28>;
> +			reg-names = "base", "tcu-base";
> +			#iommu-cells = <2>;
> +			qcom,skip-init;
> +			qcom,use-3-lvl-tables;
> +			#global-interrupts = <2>;
> +			#size-cells = <1>;
> +			#address-cells = <1>;
> +			ranges;
> +
> +			interrupts = <GIC_SPI 119 IRQ_TYPE_LEVEL_HIGH>,
> +				      <GIC_SPI 120 IRQ_TYPE_LEVEL_HIGH>,
> +				      <GIC_SPI 102 IRQ_TYPE_LEVEL_HIGH>,
> +				      <GIC_SPI 103 IRQ_TYPE_LEVEL_HIGH>,
> +				      <GIC_SPI 104 IRQ_TYPE_LEVEL_HIGH>,
> +				      <GIC_SPI 105 IRQ_TYPE_LEVEL_HIGH>,
> +				      <GIC_SPI 106 IRQ_TYPE_LEVEL_HIGH>,
> +				      <GIC_SPI 107 IRQ_TYPE_LEVEL_HIGH>,
> +				      <GIC_SPI 108 IRQ_TYPE_LEVEL_HIGH>,
> +				      <GIC_SPI 109 IRQ_TYPE_LEVEL_HIGH>,
> +				      <GIC_SPI 110 IRQ_TYPE_LEVEL_HIGH>,
> +				      <GIC_SPI 111 IRQ_TYPE_LEVEL_HIGH>,
> +				      <GIC_SPI 112 IRQ_TYPE_LEVEL_HIGH>,
> +				      <GIC_SPI 113 IRQ_TYPE_LEVEL_HIGH>,
> +				      <GIC_SPI 114 IRQ_TYPE_LEVEL_HIGH>,
> +				      <GIC_SPI 115 IRQ_TYPE_LEVEL_HIGH>,
> +				      <GIC_SPI 116 IRQ_TYPE_LEVEL_HIGH>,
> +				      <GIC_SPI 117 IRQ_TYPE_LEVEL_HIGH>,
> +				      <GIC_SPI 118 IRQ_TYPE_LEVEL_HIGH>,
> +				      <GIC_SPI 181 IRQ_TYPE_LEVEL_HIGH>,
> +				      <GIC_SPI 182 IRQ_TYPE_LEVEL_HIGH>,
> +				      <GIC_SPI 183 IRQ_TYPE_LEVEL_HIGH>,
> +				      <GIC_SPI 184 IRQ_TYPE_LEVEL_HIGH>,
> +				      <GIC_SPI 185 IRQ_TYPE_LEVEL_HIGH>,
> +				      <GIC_SPI 186 IRQ_TYPE_LEVEL_HIGH>,
> +				      <GIC_SPI 187 IRQ_TYPE_LEVEL_HIGH>,
> +				      <GIC_SPI 188 IRQ_TYPE_LEVEL_HIGH>,
> +				      <GIC_SPI 189 IRQ_TYPE_LEVEL_HIGH>,
> +				      <GIC_SPI 190 IRQ_TYPE_LEVEL_HIGH>,
> +				      <GIC_SPI 191 IRQ_TYPE_LEVEL_HIGH>,
> +				      <GIC_SPI 192 IRQ_TYPE_LEVEL_HIGH>,
> +				      <GIC_SPI 315 IRQ_TYPE_LEVEL_HIGH>,
> +				      <GIC_SPI 316 IRQ_TYPE_LEVEL_HIGH>,
> +				      <GIC_SPI 317 IRQ_TYPE_LEVEL_HIGH>,
> +				      <GIC_SPI 318 IRQ_TYPE_LEVEL_HIGH>,
> +				      <GIC_SPI 319 IRQ_TYPE_LEVEL_HIGH>,
> +				      <GIC_SPI 320 IRQ_TYPE_LEVEL_HIGH>,
> +				      <GIC_SPI 321 IRQ_TYPE_LEVEL_HIGH>,
> +				      <GIC_SPI 322 IRQ_TYPE_LEVEL_HIGH>,
> +				      <GIC_SPI 323 IRQ_TYPE_LEVEL_HIGH>,
> +				      <GIC_SPI 324 IRQ_TYPE_LEVEL_HIGH>,
> +				      <GIC_SPI 325 IRQ_TYPE_LEVEL_HIGH>,
> +				      <GIC_SPI 326 IRQ_TYPE_LEVEL_HIGH>,
> +				      <GIC_SPI 327 IRQ_TYPE_LEVEL_HIGH>,
> +				      <GIC_SPI 328 IRQ_TYPE_LEVEL_HIGH>,
> +				      <GIC_SPI 329 IRQ_TYPE_LEVEL_HIGH>,
> +				      <GIC_SPI 330 IRQ_TYPE_LEVEL_HIGH>,
> +				      <GIC_SPI 331 IRQ_TYPE_LEVEL_HIGH>,
> +				      <GIC_SPI 332 IRQ_TYPE_LEVEL_HIGH>,
> +				      <GIC_SPI 333 IRQ_TYPE_LEVEL_HIGH>,
> +				      <GIC_SPI 334 IRQ_TYPE_LEVEL_HIGH>,
> +				      <GIC_SPI 335 IRQ_TYPE_LEVEL_HIGH>,
> +				      <GIC_SPI 336 IRQ_TYPE_LEVEL_HIGH>,
> +				      <GIC_SPI 337 IRQ_TYPE_LEVEL_HIGH>,
> +				      <GIC_SPI 338 IRQ_TYPE_LEVEL_HIGH>,
> +				      <GIC_SPI 339 IRQ_TYPE_LEVEL_HIGH>,
> +				      <GIC_SPI 340 IRQ_TYPE_LEVEL_HIGH>,
> +				      <GIC_SPI 341 IRQ_TYPE_LEVEL_HIGH>,
> +				      <GIC_SPI 342 IRQ_TYPE_LEVEL_HIGH>,
> +				      <GIC_SPI 343 IRQ_TYPE_LEVEL_HIGH>,
> +				      <GIC_SPI 344 IRQ_TYPE_LEVEL_HIGH>,
> +				      <GIC_SPI 345 IRQ_TYPE_LEVEL_HIGH>,
> +				      <GIC_SPI 395 IRQ_TYPE_LEVEL_HIGH>,
> +				      <GIC_SPI 396 IRQ_TYPE_LEVEL_HIGH>,
> +				      <GIC_SPI 397 IRQ_TYPE_LEVEL_HIGH>,
> +				      <GIC_SPI 398 IRQ_TYPE_LEVEL_HIGH>,
> +				      <GIC_SPI 399 IRQ_TYPE_LEVEL_HIGH>,
> +				      <GIC_SPI 400 IRQ_TYPE_LEVEL_HIGH>,
> +				      <GIC_SPI 401 IRQ_TYPE_LEVEL_HIGH>,
> +				      <GIC_SPI 402 IRQ_TYPE_LEVEL_HIGH>,
> +				      <GIC_SPI 403 IRQ_TYPE_LEVEL_HIGH>,
> +				      <GIC_SPI 404 IRQ_TYPE_LEVEL_HIGH>,
> +				      <GIC_SPI 405 IRQ_TYPE_LEVEL_HIGH>,
> +				      <GIC_SPI 406 IRQ_TYPE_LEVEL_HIGH>,
> +				      <GIC_SPI 407 IRQ_TYPE_LEVEL_HIGH>,
> +				      <GIC_SPI 408 IRQ_TYPE_LEVEL_HIGH>,
> +				      <GIC_SPI 409 IRQ_TYPE_LEVEL_HIGH>,
> +				      <GIC_SPI 418 IRQ_TYPE_LEVEL_HIGH>,
> +				      <GIC_SPI 419 IRQ_TYPE_LEVEL_HIGH>,
> +				      <GIC_SPI 412 IRQ_TYPE_LEVEL_HIGH>,
> +				      <GIC_SPI 421 IRQ_TYPE_LEVEL_HIGH>,
> +				      <GIC_SPI 706 IRQ_TYPE_LEVEL_HIGH>,
> +				      <GIC_SPI 423 IRQ_TYPE_LEVEL_HIGH>,
> +				      <GIC_SPI 424 IRQ_TYPE_LEVEL_HIGH>,
> +				      <GIC_SPI 425 IRQ_TYPE_LEVEL_HIGH>,
> +				      <GIC_SPI 689 IRQ_TYPE_LEVEL_HIGH>,
> +				      <GIC_SPI 690 IRQ_TYPE_LEVEL_HIGH>,
> +				      <GIC_SPI 691 IRQ_TYPE_LEVEL_HIGH>,
> +				      <GIC_SPI 692 IRQ_TYPE_LEVEL_HIGH>,
> +				      <GIC_SPI 693 IRQ_TYPE_LEVEL_HIGH>,
> +				      <GIC_SPI 694 IRQ_TYPE_LEVEL_HIGH>,
> +				      <GIC_SPI 695 IRQ_TYPE_LEVEL_HIGH>,
> +				      <GIC_SPI 696 IRQ_TYPE_LEVEL_HIGH>,
> +				      <GIC_SPI 410 IRQ_TYPE_LEVEL_HIGH>,
> +				      <GIC_SPI 411 IRQ_TYPE_LEVEL_HIGH>,
> +				      <GIC_SPI 420 IRQ_TYPE_LEVEL_HIGH>,
> +				      <GIC_SPI 413 IRQ_TYPE_LEVEL_HIGH>,
> +				      <GIC_SPI 422 IRQ_TYPE_LEVEL_HIGH>,
> +				      <GIC_SPI 707 IRQ_TYPE_LEVEL_HIGH>,
> +				      <GIC_SPI 708 IRQ_TYPE_LEVEL_HIGH>,
> +				      <GIC_SPI 709 IRQ_TYPE_LEVEL_HIGH>,
> +				      <GIC_SPI 710 IRQ_TYPE_LEVEL_HIGH>,
> +				      <GIC_SPI 711 IRQ_TYPE_LEVEL_HIGH>,
> +				      <GIC_SPI 414 IRQ_TYPE_LEVEL_HIGH>,
> +				      <GIC_SPI 712 IRQ_TYPE_LEVEL_HIGH>,
> +				      <GIC_SPI 713 IRQ_TYPE_LEVEL_HIGH>,
> +				      <GIC_SPI 714 IRQ_TYPE_LEVEL_HIGH>,
> +				      <GIC_SPI 715 IRQ_TYPE_LEVEL_HIGH>,
> +				      <GIC_SPI 912 IRQ_TYPE_LEVEL_HIGH>,
> +				      <GIC_SPI 911 IRQ_TYPE_LEVEL_HIGH>,
> +				      <GIC_SPI 910 IRQ_TYPE_LEVEL_HIGH>,
> +				      <GIC_SPI 909 IRQ_TYPE_LEVEL_HIGH>,
> +				      <GIC_SPI 908 IRQ_TYPE_LEVEL_HIGH>,
> +				      <GIC_SPI 907 IRQ_TYPE_LEVEL_HIGH>,
> +				      <GIC_SPI 906 IRQ_TYPE_LEVEL_HIGH>,
> +				      <GIC_SPI 905 IRQ_TYPE_LEVEL_HIGH>,
> +				      <GIC_SPI 904 IRQ_TYPE_LEVEL_HIGH>,
> +				      <GIC_SPI 903 IRQ_TYPE_LEVEL_HIGH>,
> +				      <GIC_SPI 902 IRQ_TYPE_LEVEL_HIGH>,
> +				      <GIC_SPI 901 IRQ_TYPE_LEVEL_HIGH>,
> +				      <GIC_SPI 900 IRQ_TYPE_LEVEL_HIGH>,
> +				      <GIC_SPI 899 IRQ_TYPE_LEVEL_HIGH>,
> +				      <GIC_SPI 898 IRQ_TYPE_LEVEL_HIGH>,
> +				      <GIC_SPI 897 IRQ_TYPE_LEVEL_HIGH>,
> +				      <GIC_SPI 896 IRQ_TYPE_LEVEL_HIGH>,
> +				      <GIC_SPI 895 IRQ_TYPE_LEVEL_HIGH>,
> +				      <GIC_SPI 894 IRQ_TYPE_LEVEL_HIGH>,
> +				      <GIC_SPI 893 IRQ_TYPE_LEVEL_HIGH>,
> +				      <GIC_SPI 892 IRQ_TYPE_LEVEL_HIGH>,
> +				      <GIC_SPI 891 IRQ_TYPE_LEVEL_HIGH>;
> +		};
> +	};
> +};

-- 
Eric Chanudet

