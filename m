Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 24EC951BE2E
	for <lists+netdev@lfdr.de>; Thu,  5 May 2022 13:37:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358137AbiEELkX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 May 2022 07:40:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358081AbiEELkS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 May 2022 07:40:18 -0400
Received: from us-smtp-delivery-74.mimecast.com (us-smtp-delivery-74.mimecast.com [170.10.129.74])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 28D4631DC4
        for <netdev@vger.kernel.org>; Thu,  5 May 2022 04:36:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1651750590;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=s5VZsXvMOrsw/LdKgNsxCQT8TPaGA+hj6jEy3+MgG7Y=;
        b=ZwT8e3gaL4de+oQr/E564MRPvs5bPWHnrTq4jrYDrI9D2/ddkOj6ExJA/w0OS3uOv+qR3d
        JmiyQj2xZ8S4LokJO+yWr1UdA01rKRPMzXQliU5FGJ+X6nLNVSrva9K/YhflD1h3j41ogx
        YAaXZJMchjU09JJ1WYvZy1k9NslqGRM=
Received: from mail-qv1-f70.google.com (mail-qv1-f70.google.com
 [209.85.219.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-211-Uv_Nw-EbOb2TzvITVAPRGA-1; Thu, 05 May 2022 07:36:28 -0400
X-MC-Unique: Uv_Nw-EbOb2TzvITVAPRGA-1
Received: by mail-qv1-f70.google.com with SMTP id bu6-20020ad455e6000000b004563a74e3f9so2953825qvb.9
        for <netdev@vger.kernel.org>; Thu, 05 May 2022 04:36:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=s5VZsXvMOrsw/LdKgNsxCQT8TPaGA+hj6jEy3+MgG7Y=;
        b=KP1R/+RdTLZ4vLoVpoxS+eHVo1UEheofxWSLHud79C3XGAhmamoexWtJCd5iPbkm63
         91h0MgAn2eDyg0n3Gi0j+56WpCSMyfcPqBR3I3sZWi1OMZv+Q4OB3P/yj5iKqjweA4ud
         YULuTbbF7qoWTw2TQSKMXTEZmp3X9ybuIlAtwVZXd/27gokQIz2WJtvRrKClbFSvAzWi
         QdxZ04twYyLYNacR+hYNeSR8HsrKB425lNEkMbe5N/rZkb45pQvF7RjqhxombkDO42+5
         Xn7uoqpFsAWpcr3tYjAxYbJEGj5A7snuBs0w7+Lvjy5iHNxaHIgSJPakgDu0FuLmqkmv
         joaA==
X-Gm-Message-State: AOAM533xFb+bel35ojO4/DL3GCq8JoaC75/Jrg9YXjfi9NmaFxgj3490
        p6XkOTSUI/WW00uIg3DOUVDtIFhinTeAxJBj5AOE1kJb2pFQxLqKzzFocY1udlJ7V7SMjgmjKRw
        VKmakACjNHoWxw4pK
X-Received: by 2002:a05:622a:164a:b0:2f1:ffab:b3e0 with SMTP id y10-20020a05622a164a00b002f1ffabb3e0mr23080243qtj.553.1651750587664;
        Thu, 05 May 2022 04:36:27 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyOyCUe0cl2Kt15tOG3jHL52AgPOmxFzKiY8vZxKoiwiFksklAc56GGsUp411yPYYSwvpDVtw==
X-Received: by 2002:a05:622a:164a:b0:2f1:ffab:b3e0 with SMTP id y10-20020a05622a164a00b002f1ffabb3e0mr23080216qtj.553.1651750587070;
        Thu, 05 May 2022 04:36:27 -0700 (PDT)
Received: from gerbillo.redhat.com (146-241-115-66.dyn.eolo.it. [146.241.115.66])
        by smtp.gmail.com with ESMTPSA id t3-20020ac85303000000b002f39b99f6a9sm688008qtn.67.2022.05.05.04.36.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 May 2022 04:36:26 -0700 (PDT)
Message-ID: <03b67c37b68d80041ccadd8d010a48dbe3e7e96c.camel@redhat.com>
Subject: Re: [PATCH net-next v10 2/2] net: ethernet: Add driver for Sunplus
 SP7021
From:   Paolo Abeni <pabeni@redhat.com>
To:     Wells Lu <wellslutw@gmail.com>, davem@davemloft.net,
        kuba@kernel.org, robh+dt@kernel.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        p.zabel@pengutronix.de, krzk+dt@kernel.org, roopa@nvidia.com,
        andrew@lunn.ch, edumazet@google.com
Cc:     wells.lu@sunplus.com
Date:   Thu, 05 May 2022 13:36:22 +0200
In-Reply-To: <1651497818-25352-3-git-send-email-wellslutw@gmail.com>
References: <1651497818-25352-1-git-send-email-wellslutw@gmail.com>
         <1651497818-25352-3-git-send-email-wellslutw@gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-2.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

          On Mon, 2022-05-02 at 21:23 +0800, Wells Lu wrote:
> Add driver for Sunplus SP7021 SoC.
> 
> Reviewed-by: Andrew Lunn <andrew@lunn.ch>
> Signed-off-by: Wells Lu <wellslutw@gmail.com>
> ---
> Changes in v10
>   - Addressed comments of Mr. Stephen Hemminger.
>     - Use define NAPI_POLL_WEIGHT.
>     - Return amount of processed packets in spl2sw_tx_poll() and spl2sw_rx_poll().
>   - Addressed comments of Mr. Francois Romien.
>     - Added spin locks for "read-modify-write of int-mask register".
> 
>  MAINTAINERS                                   |   1 +
>  drivers/net/ethernet/Kconfig                  |   1 +
>  drivers/net/ethernet/Makefile                 |   1 +
>  drivers/net/ethernet/sunplus/Kconfig          |  35 ++
>  drivers/net/ethernet/sunplus/Makefile         |   6 +
>  drivers/net/ethernet/sunplus/spl2sw_define.h  | 270 ++++++++
>  drivers/net/ethernet/sunplus/spl2sw_desc.c    | 228 +++++++
>  drivers/net/ethernet/sunplus/spl2sw_desc.h    |  19 +
>  drivers/net/ethernet/sunplus/spl2sw_driver.c  | 578 ++++++++++++++++++
>  drivers/net/ethernet/sunplus/spl2sw_int.c     | 273 +++++++++
>  drivers/net/ethernet/sunplus/spl2sw_int.h     |  13 +
>  drivers/net/ethernet/sunplus/spl2sw_mac.c     | 274 +++++++++
>  drivers/net/ethernet/sunplus/spl2sw_mac.h     |  18 +
>  drivers/net/ethernet/sunplus/spl2sw_mdio.c    | 126 ++++
>  drivers/net/ethernet/sunplus/spl2sw_mdio.h    |  12 +
>  drivers/net/ethernet/sunplus/spl2sw_phy.c     |  92 +++
>  drivers/net/ethernet/sunplus/spl2sw_phy.h     |  12 +
>  .../net/ethernet/sunplus/spl2sw_register.h    |  86 +++
>  18 files changed, 2045 insertions(+)
>  create mode 100644 drivers/net/ethernet/sunplus/Kconfig
>  create mode 100644 drivers/net/ethernet/sunplus/Makefile
>  create mode 100644 drivers/net/ethernet/sunplus/spl2sw_define.h
>  create mode 100644 drivers/net/ethernet/sunplus/spl2sw_desc.c
>  create mode 100644 drivers/net/ethernet/sunplus/spl2sw_desc.h
>  create mode 100644 drivers/net/ethernet/sunplus/spl2sw_driver.c
>  create mode 100644 drivers/net/ethernet/sunplus/spl2sw_int.c
>  create mode 100644 drivers/net/ethernet/sunplus/spl2sw_int.h
>  create mode 100644 drivers/net/ethernet/sunplus/spl2sw_mac.c
>  create mode 100644 drivers/net/ethernet/sunplus/spl2sw_mac.h
>  create mode 100644 drivers/net/ethernet/sunplus/spl2sw_mdio.c
>  create mode 100644 drivers/net/ethernet/sunplus/spl2sw_mdio.h
>  create mode 100644 drivers/net/ethernet/sunplus/spl2sw_phy.c
>  create mode 100644 drivers/net/ethernet/sunplus/spl2sw_phy.h
>  create mode 100644 drivers/net/ethernet/sunplus/spl2sw_register.h
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 22a2f9699..11a062c42 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -18890,6 +18890,7 @@ L:	netdev@vger.kernel.org
>  S:	Maintained
>  W:	https://sunplus.atlassian.net/wiki/spaces/doc/overview
>  F:	Documentation/devicetree/bindings/net/sunplus,sp7021-emac.yaml
> +F:	drivers/net/ethernet/sunplus/
>  
>  SUNPLUS OCOTP DRIVER
>  M:	Vincent Shih <vincent.sunplus@gmail.com>
> diff --git a/drivers/net/ethernet/Kconfig b/drivers/net/ethernet/Kconfig
> index 827993022..955abbc54 100644
> --- a/drivers/net/ethernet/Kconfig
> +++ b/drivers/net/ethernet/Kconfig
> @@ -179,6 +179,7 @@ source "drivers/net/ethernet/smsc/Kconfig"
>  source "drivers/net/ethernet/socionext/Kconfig"
>  source "drivers/net/ethernet/stmicro/Kconfig"
>  source "drivers/net/ethernet/sun/Kconfig"
> +source "drivers/net/ethernet/sunplus/Kconfig"
>  source "drivers/net/ethernet/synopsys/Kconfig"
>  source "drivers/net/ethernet/tehuti/Kconfig"
>  source "drivers/net/ethernet/ti/Kconfig"
> diff --git a/drivers/net/ethernet/Makefile b/drivers/net/ethernet/Makefile
> index 8ef43e0c3..9eb011699 100644
> --- a/drivers/net/ethernet/Makefile
> +++ b/drivers/net/ethernet/Makefile
> @@ -90,6 +90,7 @@ obj-$(CONFIG_NET_VENDOR_SMSC) += smsc/
>  obj-$(CONFIG_NET_VENDOR_SOCIONEXT) += socionext/
>  obj-$(CONFIG_NET_VENDOR_STMICRO) += stmicro/
>  obj-$(CONFIG_NET_VENDOR_SUN) += sun/
> +obj-$(CONFIG_NET_VENDOR_SUNPLUS) += sunplus/
>  obj-$(CONFIG_NET_VENDOR_TEHUTI) += tehuti/
>  obj-$(CONFIG_NET_VENDOR_TI) += ti/
>  obj-$(CONFIG_NET_VENDOR_TOSHIBA) += toshiba/
> diff --git a/drivers/net/ethernet/sunplus/Kconfig b/drivers/net/ethernet/sunplus/Kconfig
> new file mode 100644
> index 000000000..d0144a2ab
> --- /dev/null
> +++ b/drivers/net/ethernet/sunplus/Kconfig
> @@ -0,0 +1,35 @@
> +# SPDX-License-Identifier: GPL-2.0
> +#
> +# Sunplus network device configuration
> +#
> +
> +config NET_VENDOR_SUNPLUS
> +	bool "Sunplus devices"
> +	default y
> +	depends on ARCH_SUNPLUS || COMPILE_TEST
> +	help
> +	  If you have a network (Ethernet) card belonging to this
> +	  class, say Y here.
> +
> +	  Note that the answer to this question doesn't directly
> +	  affect the kernel: saying N will just cause the configurator
> +	  to skip all the questions about Sunplus cards. If you say Y,
> +	  you will be asked for your specific card in the following
> +	  questions.
> +
> +if NET_VENDOR_SUNPLUS
> +
> +config SP7021_EMAC
> +	tristate "Sunplus Dual 10M/100M Ethernet devices"
> +	depends on SOC_SP7021 || COMPILE_TEST
> +	select PHYLIB
> +	select COMMON_CLK_SP7021
> +	select RESET_SUNPLUS
> +	select NVMEM_SUNPLUS_OCOTP
> +	help
> +	  If you have Sunplus dual 10M/100M Ethernet devices, say Y.
> +	  The network device creates two net-device interfaces.
> +	  To compile this driver as a module, choose M here. The
> +	  module will be called sp7021_emac.
> +
> +endif # NET_VENDOR_SUNPLUS
> diff --git a/drivers/net/ethernet/sunplus/Makefile b/drivers/net/ethernet/sunplus/Makefile
> new file mode 100644
> index 000000000..ef7d7d0a7
> --- /dev/null
> +++ b/drivers/net/ethernet/sunplus/Makefile
> @@ -0,0 +1,6 @@
> +# SPDX-License-Identifier: GPL-2.0
> +#
> +# Makefile for the Sunplus network device drivers.
> +#
> +obj-$(CONFIG_SP7021_EMAC) += sp7021_emac.o
> +sp7021_emac-objs := spl2sw_driver.o spl2sw_int.o spl2sw_desc.o spl2sw_mac.o spl2sw_mdio.o spl2sw_phy.o
> diff --git a/drivers/net/ethernet/sunplus/spl2sw_define.h b/drivers/net/ethernet/sunplus/spl2sw_define.h
> new file mode 100644
> index 000000000..acc6c1228
> --- /dev/null
> +++ b/drivers/net/ethernet/sunplus/spl2sw_define.h
> @@ -0,0 +1,270 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +/* Copyright Sunplus Technology Co., Ltd.
> + *       All rights reserved.
> + */
> +
> +#ifndef __SPL2SW_DEFINE_H__
> +#define __SPL2SW_DEFINE_H__
> +
> +#define MAX_NETDEV_NUM			2	/* Maximum # of net-device */
> +
> +/* Interrupt status */
> +#define MAC_INT_DAISY_MODE_CHG		BIT(31) /* Daisy Mode Change             */
> +#define MAC_INT_IP_CHKSUM_ERR		BIT(23) /* IP Checksum Append Error      */
> +#define MAC_INT_WDOG_TIMER1_EXP		BIT(22) /* Watchdog Timer1 Expired       */
> +#define MAC_INT_WDOG_TIMER0_EXP		BIT(21) /* Watchdog Timer0 Expired       */
> +#define MAC_INT_INTRUDER_ALERT		BIT(20) /* Atruder Alert                 */
> +#define MAC_INT_PORT_ST_CHG		BIT(19) /* Port Status Change            */
> +#define MAC_INT_BC_STORM		BIT(18) /* Broad Cast Storm              */
> +#define MAC_INT_MUST_DROP_LAN		BIT(17) /* Global Queue Exhausted        */
> +#define MAC_INT_GLOBAL_QUE_FULL		BIT(16) /* Global Queue Full             */
> +#define MAC_INT_TX_SOC_PAUSE_ON		BIT(15) /* Soc Port TX Pause On          */
> +#define MAC_INT_RX_SOC_QUE_FULL		BIT(14) /* Soc Port Out Queue Full       */
> +#define MAC_INT_TX_LAN1_QUE_FULL	BIT(9)  /* Port 1 Out Queue Full         */
> +#define MAC_INT_TX_LAN0_QUE_FULL	BIT(8)  /* Port 0 Out Queue Full         */
> +#define MAC_INT_RX_L_DESCF		BIT(7)  /* Low Priority Descriptor Full  */
> +#define MAC_INT_RX_H_DESCF		BIT(6)  /* High Priority Descriptor Full */
> +#define MAC_INT_RX_DONE_L		BIT(5)  /* RX Low Priority Done          */
> +#define MAC_INT_RX_DONE_H		BIT(4)  /* RX High Priority Done         */
> +#define MAC_INT_TX_DONE_L		BIT(3)  /* TX Low Priority Done          */
> +#define MAC_INT_TX_DONE_H		BIT(2)  /* TX High Priority Done         */
> +#define MAC_INT_TX_DES_ERR		BIT(1)  /* TX Descriptor Error           */
> +#define MAC_INT_RX_DES_ERR		BIT(0)  /* Rx Descriptor Error           */
> +
> +#define MAC_INT_RX			(MAC_INT_RX_DONE_H | MAC_INT_RX_DONE_L | \
> +					MAC_INT_RX_DES_ERR)
> +#define MAC_INT_TX			(MAC_INT_TX_DONE_L | MAC_INT_TX_DONE_H | \
> +					MAC_INT_TX_DES_ERR)
> +#define MAC_INT_MASK_DEF		(MAC_INT_DAISY_MODE_CHG | MAC_INT_IP_CHKSUM_ERR | \
> +					MAC_INT_WDOG_TIMER1_EXP | MAC_INT_WDOG_TIMER0_EXP | \
> +					MAC_INT_INTRUDER_ALERT | MAC_INT_PORT_ST_CHG | \
> +					MAC_INT_BC_STORM | MAC_INT_MUST_DROP_LAN | \
> +					MAC_INT_GLOBAL_QUE_FULL | MAC_INT_TX_SOC_PAUSE_ON | \
> +					MAC_INT_RX_SOC_QUE_FULL | MAC_INT_TX_LAN1_QUE_FULL | \
> +					MAC_INT_TX_LAN0_QUE_FULL | MAC_INT_RX_L_DESCF | \
> +					MAC_INT_RX_H_DESCF)
> +
> +/* Address table search */
> +#define MAC_ADDR_LOOKUP_IDLE		BIT(2)
> +#define MAC_SEARCH_NEXT_ADDR		BIT(1)
> +#define MAC_BEGIN_SEARCH_ADDR		BIT(0)
> +
> +/* Address table status */
> +#define MAC_HASH_LOOKUP_ADDR		GENMASK(31, 22)
> +#define MAC_R_PORT_MAP			GENMASK(13, 12)
> +#define MAC_R_CPU_PORT			GENMASK(11, 10)
> +#define MAC_R_VID			GENMASK(9, 7)
> +#define MAC_R_AGE			GENMASK(6, 4)
> +#define MAC_R_PROXY			BIT(3)
> +#define MAC_R_MC_INGRESS		BIT(2)
> +#define MAC_AT_TABLE_END		BIT(1)
> +#define MAC_AT_DATA_READY		BIT(0)
> +
> +/* Wt mac ad0 */
> +#define MAC_W_PORT_MAP			GENMASK(13, 12)
> +#define MAC_W_LAN_PORT_1		BIT(13)
> +#define MAC_W_LAN_PORT_0		BIT(12)
> +#define MAC_W_CPU_PORT			GENMASK(11, 10)
> +#define MAC_W_CPU_PORT_1		BIT(11)
> +#define MAC_W_CPU_PORT_0		BIT(10)
> +#define MAC_W_VID			GENMASK(9, 7)
> +#define MAC_W_AGE			GENMASK(6, 4)
> +#define MAC_W_PROXY			BIT(3)
> +#define MAC_W_MC_INGRESS		BIT(2)
> +#define MAC_W_MAC_DONE			BIT(1)
> +#define MAC_W_MAC_CMD			BIT(0)
> +
> +/* W mac 15_0 bus */
> +#define MAC_W_MAC_15_0			GENMASK(15, 0)
> +
> +/* W mac 47_16 bus */
> +#define MAC_W_MAC_47_16			GENMASK(31, 0)
> +
> +/* PVID config 0 */
> +#define MAC_P1_PVID			GENMASK(6, 4)
> +#define MAC_P0_PVID			GENMASK(2, 0)
> +
> +/* VLAN member config 0 */
> +#define MAC_VLAN_MEMSET_3		GENMASK(27, 24)
> +#define MAC_VLAN_MEMSET_2		GENMASK(19, 16)
> +#define MAC_VLAN_MEMSET_1		GENMASK(11, 8)
> +#define MAC_VLAN_MEMSET_0		GENMASK(3, 0)
> +
> +/* VLAN member config 1 */
> +#define MAC_VLAN_MEMSET_5		GENMASK(11, 8)
> +#define MAC_VLAN_MEMSET_4		GENMASK(3, 0)
> +
> +/* Port ability */
> +#define MAC_PORT_ABILITY_LINK_ST	GENMASK(25, 24)
> +
> +/* CPU control */
> +#define MAC_EN_SOC1_AGING		BIT(15)
> +#define MAC_EN_SOC0_AGING		BIT(14)
> +#define MAC_DIS_LRN_SOC1		BIT(13)
> +#define MAC_DIS_LRN_SOC0		BIT(12)
> +#define MAC_EN_CRC_SOC1			BIT(9)
> +#define MAC_EN_CRC_SOC0			BIT(8)
> +#define MAC_DIS_SOC1_CPU		BIT(7)
> +#define MAC_DIS_SOC0_CPU		BIT(6)
> +#define MAC_DIS_BC2CPU_P1		BIT(5)
> +#define MAC_DIS_BC2CPU_P0		BIT(4)
> +#define MAC_DIS_MC2CPU			GENMASK(3, 2)
> +#define MAC_DIS_MC2CPU_P1		BIT(3)
> +#define MAC_DIS_MC2CPU_P0		BIT(2)
> +#define MAC_DIS_UN2CPU			GENMASK(1, 0)
> +
> +/* Port control 0 */
> +#define MAC_DIS_PORT			GENMASK(25, 24)
> +#define MAC_DIS_PORT1			BIT(25)
> +#define MAC_DIS_PORT0			BIT(24)
> +#define MAC_DIS_RMC2CPU_P1		BIT(17)
> +#define MAC_DIS_RMC2CPU_P0		BIT(16)
> +#define MAC_EN_FLOW_CTL_P1		BIT(9)
> +#define MAC_EN_FLOW_CTL_P0		BIT(8)
> +#define MAC_EN_BACK_PRESS_P1		BIT(1)
> +#define MAC_EN_BACK_PRESS_P0		BIT(0)
> +
> +/* Port control 1 */
> +#define MAC_DIS_SA_LRN_P1		BIT(9)
> +#define MAC_DIS_SA_LRN_P0		BIT(8)
> +
> +/* Port control 2 */
> +#define MAC_EN_AGING_P1			BIT(9)
> +#define MAC_EN_AGING_P0			BIT(8)
> +
> +/* Switch Global control */
> +#define MAC_RMC_TB_FAULT_RULE		GENMASK(26, 25)
> +#define MAC_LED_FLASH_TIME		GENMASK(24, 23)
> +#define MAC_BC_STORM_PREV		GENMASK(5, 4)
> +
> +/* LED port 0 */
> +#define MAC_LED_ACT_HI			BIT(28)
> +
> +/* PHY control register 0  */
> +#define MAC_CPU_PHY_WT_DATA		GENMASK(31, 16)
> +#define MAC_CPU_PHY_CMD			GENMASK(14, 13)
> +#define MAC_CPU_PHY_REG_ADDR		GENMASK(12, 8)
> +#define MAC_CPU_PHY_ADDR		GENMASK(4, 0)
> +
> +/* PHY control register 1 */
> +#define MAC_CPU_PHY_RD_DATA		GENMASK(31, 16)
> +#define MAC_PHY_RD_RDY			BIT(1)
> +#define MAC_PHY_WT_DONE			BIT(0)
> +
> +/* MAC force mode */
> +#define MAC_EXT_PHY1_ADDR		GENMASK(28, 24)
> +#define MAC_EXT_PHY0_ADDR		GENMASK(20, 16)
> +#define MAC_FORCE_RMII_LINK		GENMASK(9, 8)
> +#define MAC_FORCE_RMII_EN_1		BIT(7)
> +#define MAC_FORCE_RMII_EN_0		BIT(6)
> +#define MAC_FORCE_RMII_FC		GENMASK(5, 4)
> +#define MAC_FORCE_RMII_DPX		GENMASK(3, 2)
> +#define MAC_FORCE_RMII_SPD		GENMASK(1, 0)
> +
> +/* CPU transmit trigger */
> +#define MAC_TRIG_L_SOC0			BIT(1)
> +#define MAC_TRIG_H_SOC0			BIT(0)
> +
> +/* Config descriptor queue */
> +#define TX_DESC_NUM			16	/* # of descriptors in TX queue   */
> +#define MAC_GUARD_DESC_NUM		2	/* # of descriptors of gap      0 */
> +#define RX_QUEUE0_DESC_NUM		16	/* # of descriptors in RX queue 0 */
> +#define RX_QUEUE1_DESC_NUM		16	/* # of descriptors in RX queue 1 */
> +#define TX_DESC_QUEUE_NUM		1	/* # of TX queue                  */
> +#define RX_DESC_QUEUE_NUM		2	/* # of RX queue                  */
> +
> +#define MAC_RX_LEN_MAX			2047	/* Size of RX buffer       */
> +
> +/* Tx descriptor */
> +/* cmd1 */
> +#define TXD_OWN				BIT(31)
> +#define TXD_ERR_CODE			GENMASK(29, 26)
> +#define TXD_SOP				BIT(25)		/* start of a packet */
> +#define TXD_EOP				BIT(24)		/* end of a packet */
> +#define TXD_VLAN			GENMASK(17, 12)
> +#define TXD_PKT_LEN			GENMASK(10, 0)	/* packet length */
> +/* cmd2 */
> +#define TXD_EOR				BIT(31)		/* end of ring */
> +#define TXD_BUF_LEN2			GENMASK(22, 12)
> +#define TXD_BUF_LEN1			GENMASK(10, 0)
> +
> +/* Rx descriptor */
> +/* cmd1 */
> +#define RXD_OWN				BIT(31)
> +#define RXD_ERR_CODE			GENMASK(29, 26)
> +#define RXD_TCP_UDP_CHKSUM		BIT(23)
> +#define RXD_PROXY			BIT(22)
> +#define RXD_PROTOCOL			GENMASK(21, 20)
> +#define RXD_VLAN_TAG			BIT(19)
> +#define RXD_IP_CHKSUM			BIT(18)
> +#define RXD_ROUTE_TYPE			GENMASK(17, 16)
> +#define RXD_PKT_SP			GENMASK(14, 12)	/* packet source port */
> +#define RXD_PKT_LEN			GENMASK(10, 0)	/* packet length */
> +/* cmd2 */
> +#define RXD_EOR				BIT(31)		/* end of ring */
> +#define RXD_BUF_LEN2			GENMASK(22, 12)
> +#define RXD_BUF_LEN1			GENMASK(10, 0)
> +
> +/* structure of descriptor */
> +struct spl2sw_mac_desc {
> +	u32 cmd1;
> +	u32 cmd2;
> +	u32 addr1;
> +	u32 addr2;
> +};
> +
> +struct spl2sw_skb_info {
> +	struct sk_buff *skb;
> +	u32 mapping;
> +	u32 len;
> +};
> +
> +struct spl2sw_common {
> +	void __iomem *l2sw_reg_base;
> +
> +	struct platform_device *pdev;
> +	struct reset_control *rstc;
> +	struct clk *clk;
> +
> +	void *desc_base;
> +	dma_addr_t desc_dma;
> +	s32 desc_size;
> +	struct spl2sw_mac_desc *rx_desc[RX_DESC_QUEUE_NUM];
> +	struct spl2sw_skb_info *rx_skb_info[RX_DESC_QUEUE_NUM];
> +	u32 rx_pos[RX_DESC_QUEUE_NUM];
> +	u32 rx_desc_num[RX_DESC_QUEUE_NUM];
> +	u32 rx_desc_buff_size;
> +
> +	struct spl2sw_mac_desc *tx_desc;
> +	struct spl2sw_skb_info tx_temp_skb_info[TX_DESC_NUM];
> +	u32 tx_done_pos;
> +	u32 tx_pos;
> +	u32 tx_desc_full;
> +
> +	struct net_device *ndev[MAX_NETDEV_NUM];
> +	struct mii_bus *mii_bus;
> +
> +	struct napi_struct rx_napi;
> +	struct napi_struct tx_napi;
> +
> +	spinlock_t tx_lock;		/* spinlock for accessing tx buffer */
> +	spinlock_t mdio_lock;		/* spinlock for mdio commands */
> +	spinlock_t int_mask_lock;	/* spinlock for accessing int mask reg. */
> +
> +	u8 enable;
> +};
> +
> +struct spl2sw_mac {
> +	struct net_device *ndev;
> +	struct spl2sw_common *comm;
> +
> +	u8 mac_addr[ETH_ALEN];
> +	phy_interface_t phy_mode;
> +	struct device_node *phy_node;
> +
> +	u8 lan_port;
> +	u8 to_vlan;
> +	u8 vlan_id;
> +};
> +
> +#endif
> diff --git a/drivers/net/ethernet/sunplus/spl2sw_desc.c b/drivers/net/ethernet/sunplus/spl2sw_desc.c
> new file mode 100644
> index 000000000..3f0d9f78b
> --- /dev/null
> +++ b/drivers/net/ethernet/sunplus/spl2sw_desc.c
> @@ -0,0 +1,228 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/* Copyright Sunplus Technology Co., Ltd.
> + *       All rights reserved.
> + */
> +
> +#include <linux/platform_device.h>
> +#include <linux/netdevice.h>
> +#include <linux/of_mdio.h>
> +
> +#include "spl2sw_define.h"
> +#include "spl2sw_desc.h"
> +
> +void spl2sw_rx_descs_flush(struct spl2sw_common *comm)
> +{
> +	struct spl2sw_skb_info *rx_skbinfo;
> +	struct spl2sw_mac_desc *rx_desc;
> +	u32 i, j;
> +
> +	for (i = 0; i < RX_DESC_QUEUE_NUM; i++) {
> +		rx_desc = comm->rx_desc[i];
> +		rx_skbinfo = comm->rx_skb_info[i];
> +		for (j = 0; j < comm->rx_desc_num[i]; j++) {
> +			rx_desc[j].addr1 = rx_skbinfo[j].mapping;
> +			rx_desc[j].cmd2 = (j == comm->rx_desc_num[i] - 1) ?
> +					  RXD_EOR | comm->rx_desc_buff_size :
> +					  comm->rx_desc_buff_size;
> +			wmb();	/* Set RXD_OWN after other fields are ready. */
> +			rx_desc[j].cmd1 = RXD_OWN;
> +		}
> +	}
> +}
> +
> +void spl2sw_tx_descs_clean(struct spl2sw_common *comm)
> +{
> +	u32 i;
> +
> +	if (!comm->tx_desc)
> +		return;
> +
> +	for (i = 0; i < TX_DESC_NUM; i++) {
> +		comm->tx_desc[i].cmd1 = 0;
> +		wmb();	/* Clear TXD_OWN and then set other fields. */
> +		comm->tx_desc[i].cmd2 = 0;
> +		comm->tx_desc[i].addr1 = 0;
> +		comm->tx_desc[i].addr2 = 0;
> +
> +		if (comm->tx_temp_skb_info[i].mapping) {
> +			dma_unmap_single(&comm->pdev->dev, comm->tx_temp_skb_info[i].mapping,
> +					 comm->tx_temp_skb_info[i].skb->len, DMA_TO_DEVICE);
> +			comm->tx_temp_skb_info[i].mapping = 0;
> +		}
> +
> +		if (comm->tx_temp_skb_info[i].skb) {
> +			dev_kfree_skb_any(comm->tx_temp_skb_info[i].skb);
> +			comm->tx_temp_skb_info[i].skb = NULL;
> +		}
> +	}
> +}
> +
> +void spl2sw_rx_descs_clean(struct spl2sw_common *comm)
> +{
> +	struct spl2sw_skb_info *rx_skbinfo;
> +	struct spl2sw_mac_desc *rx_desc;
> +	u32 i, j;
> +
> +	for (i = 0; i < RX_DESC_QUEUE_NUM; i++) {
> +		if (!comm->rx_skb_info[i])
> +			continue;
> +
> +		rx_desc = comm->rx_desc[i];
> +		rx_skbinfo = comm->rx_skb_info[i];
> +		for (j = 0; j < comm->rx_desc_num[i]; j++) {
> +			rx_desc[j].cmd1 = 0;
> +			wmb();	/* Clear RXD_OWN and then set other fields. */
> +			rx_desc[j].cmd2 = 0;
> +			rx_desc[j].addr1 = 0;
> +
> +			if (rx_skbinfo[j].skb) {
> +				dma_unmap_single(&comm->pdev->dev, rx_skbinfo[j].mapping,
> +						 comm->rx_desc_buff_size, DMA_FROM_DEVICE);
> +				dev_kfree_skb_any(rx_skbinfo[j].skb);
> +				rx_skbinfo[j].skb = NULL;
> +				rx_skbinfo[j].mapping = 0;
> +			}
> +		}
> +
> +		kfree(rx_skbinfo);
> +		comm->rx_skb_info[i] = NULL;
> +	}
> +}
> +
> +void spl2sw_descs_clean(struct spl2sw_common *comm)
> +{
> +	spl2sw_rx_descs_clean(comm);
> +	spl2sw_tx_descs_clean(comm);
> +}
> +
> +void spl2sw_descs_free(struct spl2sw_common *comm)
> +{
> +	u32 i;
> +
> +	spl2sw_descs_clean(comm);
> +	comm->tx_desc = NULL;
> +	for (i = 0; i < RX_DESC_QUEUE_NUM; i++)
> +		comm->rx_desc[i] = NULL;
> +
> +	/*  Free descriptor area  */
> +	if (comm->desc_base) {
> +		dma_free_coherent(&comm->pdev->dev, comm->desc_size, comm->desc_base,
> +				  comm->desc_dma);
> +		comm->desc_base = NULL;
> +		comm->desc_dma = 0;
> +		comm->desc_size = 0;
> +	}
> +}
> +
> +void spl2sw_tx_descs_init(struct spl2sw_common *comm)
> +{
> +	memset(comm->tx_desc, '\0', sizeof(struct spl2sw_mac_desc) *
> +	       (TX_DESC_NUM + MAC_GUARD_DESC_NUM));
> +}
> +
> +int spl2sw_rx_descs_init(struct spl2sw_common *comm)
> +{
> +	struct spl2sw_skb_info *rx_skbinfo;
> +	struct spl2sw_mac_desc *rx_desc;
> +	struct sk_buff *skb;
> +	u32 mapping;
> +	u32 i, j;
> +
> +	for (i = 0; i < RX_DESC_QUEUE_NUM; i++) {
> +		comm->rx_skb_info[i] = kcalloc(comm->rx_desc_num[i], sizeof(*rx_skbinfo),
> +					       GFP_KERNEL | GFP_DMA);
> +		if (!comm->rx_skb_info[i])
> +			goto mem_alloc_fail;
> +
> +		rx_skbinfo = comm->rx_skb_info[i];
> +		rx_desc = comm->rx_desc[i];
> +		for (j = 0; j < comm->rx_desc_num[i]; j++) {
> +			skb = netdev_alloc_skb(NULL, comm->rx_desc_buff_size);
> +			if (!skb)
> +				goto mem_alloc_fail;
> +
> +			rx_skbinfo[j].skb = skb;
> +			mapping = dma_map_single(&comm->pdev->dev, skb->data,
> +						 comm->rx_desc_buff_size,
> +						 DMA_FROM_DEVICE);
> +			if (dma_mapping_error(&comm->pdev->dev, mapping))
> +				goto mem_alloc_fail;
> +
> +			rx_skbinfo[j].mapping = mapping;
> +			rx_desc[j].addr1 = mapping;
> +			rx_desc[j].addr2 = 0;
> +			rx_desc[j].cmd2 = (j == comm->rx_desc_num[i] - 1) ?
> +					  RXD_EOR | comm->rx_desc_buff_size :
> +					  comm->rx_desc_buff_size;
> +			wmb();	/* Set RXD_OWN after other fields are effective. */
> +			rx_desc[j].cmd1 = RXD_OWN;
> +		}
> +	}
> +
> +	return 0;
> +
> +mem_alloc_fail:
> +	spl2sw_rx_descs_clean(comm);
> +	return -ENOMEM;
> +}
> +
> +int spl2sw_descs_alloc(struct spl2sw_common *comm)
> +{
> +	s32 desc_size;
> +	u32 i;
> +
> +	/* Alloc descriptor area  */
> +	desc_size = (TX_DESC_NUM + MAC_GUARD_DESC_NUM) * sizeof(struct spl2sw_mac_desc);
> +	for (i = 0; i < RX_DESC_QUEUE_NUM; i++)
> +		desc_size += comm->rx_desc_num[i] * sizeof(struct spl2sw_mac_desc);
> +
> +	comm->desc_base = dma_alloc_coherent(&comm->pdev->dev, desc_size, &comm->desc_dma,
> +					     GFP_KERNEL);
> +	if (!comm->desc_base)
> +		return -ENOMEM;
> +
> +	comm->desc_size = desc_size;
> +
> +	/* Setup Tx descriptor */
> +	comm->tx_desc = comm->desc_base;
> +
> +	/* Setup Rx descriptor */
> +	comm->rx_desc[0] = &comm->tx_desc[TX_DESC_NUM + MAC_GUARD_DESC_NUM];
> +	for (i = 1; i < RX_DESC_QUEUE_NUM; i++)
> +		comm->rx_desc[i] = comm->rx_desc[i - 1] + comm->rx_desc_num[i - 1];
> +
> +	return 0;
> +}
> +
> +int spl2sw_descs_init(struct spl2sw_common *comm)
> +{
> +	u32 i, ret;
> +
> +	/* Initialize rx descriptor's data */
> +	comm->rx_desc_num[0] = RX_QUEUE0_DESC_NUM;
> +	comm->rx_desc_num[1] = RX_QUEUE1_DESC_NUM;
> +
> +	for (i = 0; i < RX_DESC_QUEUE_NUM; i++) {
> +		comm->rx_desc[i] = NULL;
> +		comm->rx_skb_info[i] = NULL;
> +		comm->rx_pos[i] = 0;
> +	}
> +	comm->rx_desc_buff_size = MAC_RX_LEN_MAX;
> +
> +	/* Initialize tx descriptor's data */
> +	comm->tx_done_pos = 0;
> +	comm->tx_desc = NULL;
> +	comm->tx_pos = 0;
> +	comm->tx_desc_full = 0;
> +	for (i = 0; i < TX_DESC_NUM; i++)
> +		comm->tx_temp_skb_info[i].skb = NULL;
> +
> +	/* Allocate tx & rx descriptors. */
> +	ret = spl2sw_descs_alloc(comm);
> +	if (ret)
> +		return ret;
> +
> +	spl2sw_tx_descs_init(comm);
> +
> +	return spl2sw_rx_descs_init(comm);
> +}
> diff --git a/drivers/net/ethernet/sunplus/spl2sw_desc.h b/drivers/net/ethernet/sunplus/spl2sw_desc.h
> new file mode 100644
> index 000000000..f04e2d85c
> --- /dev/null
> +++ b/drivers/net/ethernet/sunplus/spl2sw_desc.h
> @@ -0,0 +1,19 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +/* Copyright Sunplus Technology Co., Ltd.
> + *       All rights reserved.
> + */
> +
> +#ifndef __SPL2SW_DESC_H__
> +#define __SPL2SW_DESC_H__
> +
> +void spl2sw_rx_descs_flush(struct spl2sw_common *comm);
> +void spl2sw_tx_descs_clean(struct spl2sw_common *comm);
> +void spl2sw_rx_descs_clean(struct spl2sw_common *comm);
> +void spl2sw_descs_clean(struct spl2sw_common *comm);
> +void spl2sw_descs_free(struct spl2sw_common *comm);
> +void spl2sw_tx_descs_init(struct spl2sw_common *comm);
> +int  spl2sw_rx_descs_init(struct spl2sw_common *comm);
> +int  spl2sw_descs_alloc(struct spl2sw_common *comm);
> +int  spl2sw_descs_init(struct spl2sw_common *comm);
> +
> +#endif
> diff --git a/drivers/net/ethernet/sunplus/spl2sw_driver.c b/drivers/net/ethernet/sunplus/spl2sw_driver.c
> new file mode 100644
> index 000000000..8320fa833
> --- /dev/null
> +++ b/drivers/net/ethernet/sunplus/spl2sw_driver.c
> @@ -0,0 +1,578 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/* Copyright Sunplus Technology Co., Ltd.
> + *       All rights reserved.
> + */
> +
> +#include <linux/platform_device.h>
> +#include <linux/nvmem-consumer.h>
> +#include <linux/etherdevice.h>
> +#include <linux/netdevice.h>
> +#include <linux/spinlock.h>
> +#include <linux/of_net.h>
> +#include <linux/reset.h>
> +#include <linux/clk.h>
> +#include <linux/of.h>
> +
> +#include "spl2sw_register.h"
> +#include "spl2sw_define.h"
> +#include "spl2sw_desc.h"
> +#include "spl2sw_mdio.h"
> +#include "spl2sw_phy.h"
> +#include "spl2sw_int.h"
> +#include "spl2sw_mac.h"
> +
> +/* net device operations */
> +static int spl2sw_ethernet_open(struct net_device *ndev)
> +{
> +	struct spl2sw_mac *mac = netdev_priv(ndev);
> +	struct spl2sw_common *comm = mac->comm;
> +	u32 mask;
> +
> +	netdev_dbg(ndev, "Open port = %x\n", mac->lan_port);
> +
> +	comm->enable |= mac->lan_port;
> +
> +	spl2sw_mac_hw_start(comm);
> +
> +	/* Enable TX and RX interrupts */
> +	mask = readl(comm->l2sw_reg_base + L2SW_SW_INT_MASK_0);
> +	mask &= ~(MAC_INT_TX | MAC_INT_RX);
> +	writel(mask, comm->l2sw_reg_base + L2SW_SW_INT_MASK_0);
> +
> +	phy_start(ndev->phydev);
> +
> +	netif_start_queue(ndev);
> +
> +	return 0;
> +}
> +
> +static int spl2sw_ethernet_stop(struct net_device *ndev)
> +{
> +	struct spl2sw_mac *mac = netdev_priv(ndev);
> +	struct spl2sw_common *comm = mac->comm;
> +
> +	netif_stop_queue(ndev);
> +
> +	comm->enable &= ~mac->lan_port;
> +
> +	phy_stop(ndev->phydev);
> +
> +	spl2sw_mac_hw_stop(comm);
> +
> +	return 0;
> +}
> +
> +static int spl2sw_ethernet_start_xmit(struct sk_buff *skb, struct net_device *ndev)
> +{
> +	struct spl2sw_mac *mac = netdev_priv(ndev);
> +	struct spl2sw_common *comm = mac->comm;
> +	struct spl2sw_skb_info *skbinfo;
> +	struct spl2sw_mac_desc *txdesc;
> +	unsigned long flags;
> +	u32 mapping;
> +	u32 tx_pos;
> +	u32 cmd1;
> +	u32 cmd2;
> +
> +	if (unlikely(comm->tx_desc_full == 1)) {
> +		/* No TX descriptors left. Wait for tx interrupt. */
> +		netdev_dbg(ndev, "TX descriptor queue full when xmit!\n");
> +		return NETDEV_TX_BUSY;
> +	}
> +
> +	/* If skb size is shorter than ETH_ZLEN (60), pad it with 0. */
> +	if (unlikely(skb->len < ETH_ZLEN)) {
> +		if (skb_padto(skb, ETH_ZLEN))
> +			return NETDEV_TX_OK;
> +
> +		skb_put(skb, ETH_ZLEN - skb->len);
> +	}
> +
> +	mapping = dma_map_single(&comm->pdev->dev, skb->data,
> +				 skb->len, DMA_TO_DEVICE);
> +	if (dma_mapping_error(&comm->pdev->dev, mapping)) {
> +		ndev->stats.tx_errors++;
> +		dev_kfree_skb(skb);
> +		return NETDEV_TX_OK;
> +	}
> +
> +	spin_lock_irqsave(&comm->tx_lock, flags);
> +
> +	tx_pos = comm->tx_pos;
> +	txdesc = &comm->tx_desc[tx_pos];
> +	skbinfo = &comm->tx_temp_skb_info[tx_pos];
> +	skbinfo->mapping = mapping;
> +	skbinfo->len = skb->len;
> +	skbinfo->skb = skb;
> +
> +	/* Set up a TX descriptor */
> +	cmd1 = TXD_OWN | TXD_SOP | TXD_EOP | (mac->to_vlan << 12) |
> +	       (skb->len & TXD_PKT_LEN);
> +	cmd2 = skb->len & TXD_BUF_LEN1;
> +
> +	if (tx_pos == (TX_DESC_NUM - 1))
> +		cmd2 |= TXD_EOR;
> +
> +	txdesc->addr1 = skbinfo->mapping;
> +	txdesc->cmd2 = cmd2;
> +	wmb();	/* Set TXD_OWN after other fields are effective. */
> +	txdesc->cmd1 = cmd1;
> +
> +	/* Move tx_pos to next position */
> +	tx_pos = ((tx_pos + 1) == TX_DESC_NUM) ? 0 : tx_pos + 1;
> +
> +	if (unlikely(tx_pos == comm->tx_done_pos)) {
> +		netif_stop_queue(ndev);
> +		comm->tx_desc_full = 1;
> +	}
> +	comm->tx_pos = tx_pos;
> +	wmb();		/* make sure settings are effective. */
> +
> +	/* Trigger mac to transmit */
> +	writel(MAC_TRIG_L_SOC0, comm->l2sw_reg_base + L2SW_CPU_TX_TRIG);
> +
> +	spin_unlock_irqrestore(&comm->tx_lock, flags);
> +	return NETDEV_TX_OK;
> +}
> +
> +static void spl2sw_ethernet_set_rx_mode(struct net_device *ndev)
> +{
> +	struct spl2sw_mac *mac = netdev_priv(ndev);
> +
> +	spl2sw_mac_rx_mode_set(mac);
> +}
> +
> +static int spl2sw_ethernet_set_mac_address(struct net_device *ndev, void *addr)
> +{
> +	struct spl2sw_mac *mac = netdev_priv(ndev);
> +	int err;
> +
> +	err = eth_mac_addr(ndev, addr);
> +	if (err)
> +		return err;
> +
> +	/* Delete the old MAC address */
> +	netdev_dbg(ndev, "Old Ethernet (MAC) address = %pM\n", mac->mac_addr);
> +	if (is_valid_ether_addr(mac->mac_addr)) {
> +		err = spl2sw_mac_addr_del(mac);
> +		if (err)
> +			return err;
> +	}
> +
> +	/* Set the MAC address */
> +	ether_addr_copy(mac->mac_addr, ndev->dev_addr);
> +	return spl2sw_mac_addr_add(mac);
> +}
> +
> +static void spl2sw_ethernet_tx_timeout(struct net_device *ndev, unsigned int txqueue)
> +{
> +	struct spl2sw_mac *mac = netdev_priv(ndev);
> +	struct spl2sw_common *comm = mac->comm;
> +	unsigned long flags;
> +	int i;
> +
> +	netdev_err(ndev, "TX timed out!\n");
> +	ndev->stats.tx_errors++;
> +
> +	spin_lock_irqsave(&comm->tx_lock, flags);
> +
> +	for (i = 0; i < MAX_NETDEV_NUM; i++)
> +		if (comm->ndev[i])
> +			netif_stop_queue(comm->ndev[i]);
> +
> +	spl2sw_mac_soft_reset(comm);
> +
> +	/* Accept TX packets again. */
> +	for (i = 0; i < MAX_NETDEV_NUM; i++)
> +		if (comm->ndev[i]) {
> +			netif_trans_update(comm->ndev[i]);
> +			netif_wake_queue(comm->ndev[i]);
> +		}
> +
> +	spin_unlock_irqrestore(&comm->tx_lock, flags);
> +}
> +
> +static const struct net_device_ops netdev_ops = {
> +	.ndo_open = spl2sw_ethernet_open,
> +	.ndo_stop = spl2sw_ethernet_stop,
> +	.ndo_start_xmit = spl2sw_ethernet_start_xmit,
> +	.ndo_set_rx_mode = spl2sw_ethernet_set_rx_mode,
> +	.ndo_set_mac_address = spl2sw_ethernet_set_mac_address,
> +	.ndo_do_ioctl = phy_do_ioctl,
> +	.ndo_tx_timeout = spl2sw_ethernet_tx_timeout,
> +};
> +
> +static void spl2sw_check_mac_vendor_id_and_convert(u8 *mac_addr)
> +{
> +	u8 tmp;
> +
> +	/* Byte order of MAC address of some samples are reversed.
> +	 * Check vendor id and convert byte order if it is wrong.
> +	 * OUI of Sunplus: fc:4b:bc
> +	 */
> +	if (mac_addr[5] == 0xfc && mac_addr[4] == 0x4b && mac_addr[3] == 0xbc &&
> +	    (mac_addr[0] != 0xfc || mac_addr[1] != 0x4b || mac_addr[2] != 0xbc)) {
> +		/* Swap mac_addr[0] and mac_addr[5] */
> +		tmp = mac_addr[0];
> +		mac_addr[0] = mac_addr[5];
> +		mac_addr[5] = tmp;
> +
> +		/* Swap mac_addr[1] and mac_addr[4] */
> +		tmp = mac_addr[1];
> +		mac_addr[1] = mac_addr[4];
> +		mac_addr[4] = tmp;
> +
> +		/* Swap mac_addr[2] and mac_addr[3] */
> +		tmp = mac_addr[2];
> +		mac_addr[2] = mac_addr[3];
> +		mac_addr[3] = tmp;
> +	}
> +}
> +
> +static int spl2sw_nvmem_get_mac_address(struct device *dev, struct device_node *np,
> +					void *addrbuf)
> +{
> +	struct nvmem_cell *cell;
> +	ssize_t len;
> +	u8 *mac;
> +
> +	/* Get nvmem cell of mac-address from dts. */
> +	cell = of_nvmem_cell_get(np, "mac-address");
> +	if (IS_ERR(cell))
> +		return PTR_ERR(cell);
> +
> +	/* Read mac address from nvmem cell. */
> +	mac = nvmem_cell_read(cell, &len);
> +	nvmem_cell_put(cell);
> +	if (IS_ERR(mac))
> +		return PTR_ERR(mac);
> +
> +	if (len != ETH_ALEN) {
> +		kfree(mac);
> +		dev_info(dev, "Invalid length of mac address in nvmem!\n");
> +		return -EINVAL;
> +	}
> +
> +	/* Byte order of some samples are reversed.
> +	 * Convert byte order here.
> +	 */
> +	spl2sw_check_mac_vendor_id_and_convert(mac);
> +
> +	/* Check if mac address is valid */
> +	if (!is_valid_ether_addr(mac)) {
> +		kfree(mac);
> +		dev_info(dev, "Invalid mac address in nvmem (%pM)!\n", mac);
> +		return -EINVAL;
> +	}
> +
> +	ether_addr_copy(addrbuf, mac);
> +	kfree(mac);
> +	return 0;
> +}
> +
> +static u32 spl2sw_init_netdev(struct platform_device *pdev, u8 *mac_addr,
> +			      struct net_device **r_ndev)
> +{
> +	struct net_device *ndev;
> +	struct spl2sw_mac *mac;
> +	int ret;
> +
> +	/* Allocate the devices, and also allocate spl2sw_mac,
> +	 * we can get it by netdev_priv().
> +	 */
> +	ndev = devm_alloc_etherdev(&pdev->dev, sizeof(*mac));
> +	if (!ndev) {
> +		*r_ndev = NULL;
> +		return -ENOMEM;
> +	}
> +	SET_NETDEV_DEV(ndev, &pdev->dev);
> +	ndev->netdev_ops = &netdev_ops;
> +	mac = netdev_priv(ndev);
> +	mac->ndev = ndev;
> +	ether_addr_copy(mac->mac_addr, mac_addr);
> +
> +	eth_hw_addr_set(ndev, mac_addr);
> +	dev_info(&pdev->dev, "Ethernet (MAC) address = %pM\n", mac_addr);
> +
> +	ret = register_netdev(ndev);
> +	if (ret) {
> +		dev_err(&pdev->dev, "Failed to register net device \"%s\"!\n",
> +			ndev->name);
> +		free_netdev(ndev);
> +		*r_ndev = NULL;
> +		return ret;
> +	}
> +	netdev_dbg(ndev, "Registered net device \"%s\" successfully.\n", ndev->name);
> +
> +	*r_ndev = ndev;
> +	return 0;
> +}
> +
> +static struct device_node *spl2sw_get_eth_child_node(struct device_node *ether_np, int id)
> +{
> +	struct device_node *port_np;
> +	int port_id;
> +
> +	for_each_child_of_node(ether_np, port_np) {
> +		/* It is not a 'port' node, continue. */
> +		if (strcmp(port_np->name, "port"))
> +			continue;
> +
> +		if (of_property_read_u32(port_np, "reg", &port_id) < 0)
> +			continue;
> +
> +		if (port_id == id)
> +			return port_np;
> +	}
> +
> +	/* Not found! */
> +	return NULL;
> +}
> +
> +static int spl2sw_probe(struct platform_device *pdev)
> +{
> +	struct device_node *eth_ports_np;
> +	struct device_node *port_np;
> +	struct spl2sw_common *comm;
> +	struct device_node *phy_np;
> +	phy_interface_t phy_mode;
> +	struct net_device *ndev;
> +	struct spl2sw_mac *mac;
> +	u8 mac_addr[ETH_ALEN];
> +	int irq, i, ret;
> +
> +	if (platform_get_drvdata(pdev))
> +		return -ENODEV;
> +
> +	/* Allocate memory for 'spl2sw_common' area. */
> +	comm = devm_kzalloc(&pdev->dev, sizeof(*comm), GFP_KERNEL);
> +	if (!comm)
> +		return -ENOMEM;
> +
> +	comm->pdev = pdev;
> +	platform_set_drvdata(pdev, comm);
> +
> +	spin_lock_init(&comm->tx_lock);
> +	spin_lock_init(&comm->mdio_lock);
> +	spin_lock_init(&comm->int_mask_lock);
> +
> +	/* Get memory resource 0 from dts. */
> +	comm->l2sw_reg_base = devm_platform_ioremap_resource(pdev, 0);
> +	if (IS_ERR(comm->l2sw_reg_base))
> +		return PTR_ERR(comm->l2sw_reg_base);
> +
> +	/* Get irq resource from dts. */
> +	ret = platform_get_irq(pdev, 0);
> +	if (ret < 0)
> +		return ret;
> +	irq = ret;
> +
> +	/* Get clock controller. */
> +	comm->clk = devm_clk_get(&pdev->dev, NULL);
> +	if (IS_ERR(comm->clk)) {
> +		dev_err_probe(&pdev->dev, PTR_ERR(comm->clk),
> +			      "Failed to retrieve clock controller!\n");
> +		return PTR_ERR(comm->clk);
> +	}
> +
> +	/* Get reset controller. */
> +	comm->rstc = devm_reset_control_get_exclusive(&pdev->dev, NULL);
> +	if (IS_ERR(comm->rstc)) {
> +		dev_err_probe(&pdev->dev, PTR_ERR(comm->rstc),
> +			      "Failed to retrieve reset controller!\n");
> +		return PTR_ERR(comm->rstc);
> +	}
> +
> +	/* Enable clock. */
> +	ret = clk_prepare_enable(comm->clk);
> +	if (ret)
> +		return ret;
> +	udelay(1);
> +
> +	/* Reset MAC */
> +	reset_control_assert(comm->rstc);
> +	udelay(1);
> +	reset_control_deassert(comm->rstc);
> +	usleep_range(1000, 2000);
> +
> +	/* Request irq. */
> +	ret = devm_request_irq(&pdev->dev, irq, spl2sw_ethernet_interrupt, 0,
> +			       dev_name(&pdev->dev), comm);
> +	if (ret) {
> +		dev_err(&pdev->dev, "Failed to request irq #%d!\n", irq);
> +		goto out_clk_disable;
> +	}
> +
> +	/* Initialize TX and RX descriptors. */
> +	ret = spl2sw_descs_init(comm);
> +	if (ret) {
> +		dev_err(&pdev->dev, "Fail to initialize mac descriptors!\n");
> +		spl2sw_descs_free(comm);
> +		goto out_clk_disable;
> +	}
> +
> +	/* Initialize MAC. */
> +	spl2sw_mac_init(comm);
> +
> +	/* Initialize mdio bus */
> +	ret = spl2sw_mdio_init(comm);
> +	if (ret) {
> +		dev_err(&pdev->dev, "Failed to initialize mdio bus!\n");
> +		goto out_clk_disable;
> +	}
> +
> +	/* Get child node ethernet-ports. */
> +	eth_ports_np = of_get_child_by_name(pdev->dev.of_node, "ethernet-ports");
> +	if (!eth_ports_np) {
> +		dev_err(&pdev->dev, "No ethernet-ports child node found!\n");
> +		ret = -ENODEV;
> +		goto out_free_mdio;
> +	}
> +
> +	for (i = 0; i < MAX_NETDEV_NUM; i++) {
> +		/* Get port@i of node ethernet-ports. */
> +		port_np = spl2sw_get_eth_child_node(eth_ports_np, i);
> +		if (!port_np)
> +			continue;
> +
> +		/* Get phy-mode. */
> +		if (of_get_phy_mode(port_np, &phy_mode)) {
> +			dev_err(&pdev->dev, "Failed to get phy-mode property of port@%d!\n",
> +				i);
> +			continue;
> +		}
> +
> +		/* Get phy-handle. */
> +		phy_np = of_parse_phandle(port_np, "phy-handle", 0);
> +		if (!phy_np) {
> +			dev_err(&pdev->dev, "Failed to get phy-handle property of port@%d!\n",
> +				i);
> +			continue;
> +		}
> +
> +		/* Get mac-address from nvmem. */
> +		ret = spl2sw_nvmem_get_mac_address(&pdev->dev, port_np, mac_addr);
> +		if (ret == -EPROBE_DEFER) {
> +			goto out_unregister_dev;
> +		} else if (ret) {
> +			dev_info(&pdev->dev, "Generate a random mac address!\n");
> +			eth_random_addr(mac_addr);
> +		}
> +
> +		/* Initialize the net device. */
> +		ret = spl2sw_init_netdev(pdev, mac_addr, &ndev);
> +		if (ret)
> +			goto out_unregister_dev;
> +
> +		ndev->irq = irq;
> +		comm->ndev[i] = ndev;
> +		mac = netdev_priv(ndev);
> +		mac->phy_node = phy_np;
> +		mac->phy_mode = phy_mode;
> +		mac->comm = comm;
> +
> +		mac->lan_port = 0x1 << i;	/* forward to port i */
> +		mac->to_vlan = 0x1 << i;	/* vlan group: i     */
> +		mac->vlan_id = i;		/* vlan group: i     */
> +
> +		/* Set MAC address */
> +		ret = spl2sw_mac_addr_add(mac);
> +		if (ret)
> +			goto out_unregister_dev;
> +
> +		spl2sw_mac_rx_mode_set(mac);
> +	}
> +
> +	/* Find first valid net device. */
> +	for (i = 0; i < MAX_NETDEV_NUM; i++) {
> +		if (comm->ndev[i])
> +			break;
> +	}
> +	if (i >= MAX_NETDEV_NUM) {
> +		dev_err(&pdev->dev, "No valid ethernet port!\n");
> +		ret = -ENODEV;
> +		goto out_free_mdio;
> +	}
> +
> +	/* Save first valid net device */
> +	ndev = comm->ndev[i];
> +
> +	ret = spl2sw_phy_connect(comm);
> +	if (ret) {
> +		netdev_err(ndev, "Failed to connect phy!\n");
> +		goto out_unregister_dev;
> +	}
> +
> +	/* Add and enable napi. */
> +	netif_napi_add(ndev, &comm->rx_napi, spl2sw_rx_poll, NAPI_POLL_WEIGHT);
> +	napi_enable(&comm->rx_napi);
> +	netif_napi_add(ndev, &comm->tx_napi, spl2sw_tx_poll, NAPI_POLL_WEIGHT);
> +	napi_enable(&comm->tx_napi);
> +	return 0;
> +
> +out_unregister_dev:
> +	for (i = 0; i < MAX_NETDEV_NUM; i++)
> +		if (comm->ndev[i])
> +			unregister_netdev(comm->ndev[i]);
> +
> +out_free_mdio:
> +	spl2sw_mdio_remove(comm);
> +
> +out_clk_disable:
> +	clk_disable_unprepare(comm->clk);
> +	return ret;
> +}
> +
> +static int spl2sw_remove(struct platform_device *pdev)
> +{
> +	struct spl2sw_common *comm;
> +	int i;
> +
> +	comm = platform_get_drvdata(pdev);
> +
> +	spl2sw_phy_remove(comm);
> +
> +	/* Unregister and free net device. */
> +	for (i = 0; i < MAX_NETDEV_NUM; i++)
> +		if (comm->ndev[i])
> +			unregister_netdev(comm->ndev[i]);
> +
> +	comm->enable = 0;
> +	spl2sw_mac_hw_stop(comm);
> +	spl2sw_descs_free(comm);
> +
> +	/* Disable and delete napi. */
> +	napi_disable(&comm->rx_napi);
> +	netif_napi_del(&comm->rx_napi);
> +	napi_disable(&comm->tx_napi);
> +	netif_napi_del(&comm->tx_napi);
> +
> +	spl2sw_mdio_remove(comm);
> +
> +	clk_disable_unprepare(comm->clk);
> +
> +	return 0;
> +}
> +
> +static const struct of_device_id spl2sw_of_match[] = {
> +	{.compatible = "sunplus,sp7021-emac"},
> +	{ /* sentinel */ }
> +};
> +
> +MODULE_DEVICE_TABLE(of, spl2sw_of_match);
> +
> +static struct platform_driver spl2sw_driver = {
> +	.probe = spl2sw_probe,
> +	.remove = spl2sw_remove,
> +	.driver = {
> +		.name = "sp7021_emac",
> +		.owner = THIS_MODULE,
> +		.of_match_table = spl2sw_of_match,
> +	},
> +};
> +
> +module_platform_driver(spl2sw_driver);
> +
> +MODULE_AUTHOR("Wells Lu <wellslutw@gmail.com>");
> +MODULE_DESCRIPTION("Sunplus Dual 10M/100M Ethernet driver");
> +MODULE_LICENSE("GPL");
> diff --git a/drivers/net/ethernet/sunplus/spl2sw_int.c b/drivers/net/ethernet/sunplus/spl2sw_int.c
> new file mode 100644
> index 000000000..e8eb30c44
> --- /dev/null
> +++ b/drivers/net/ethernet/sunplus/spl2sw_int.c
> @@ -0,0 +1,273 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/* Copyright Sunplus Technology Co., Ltd.
> + *       All rights reserved.
> + */
> +
> +#include <linux/platform_device.h>
> +#include <linux/etherdevice.h>
> +#include <linux/netdevice.h>
> +#include <linux/bitfield.h>
> +#include <linux/spinlock.h>
> +#include <linux/of_mdio.h>
> +
> +#include "spl2sw_register.h"
> +#include "spl2sw_define.h"
> +#include "spl2sw_int.h"
> +
> +int spl2sw_rx_poll(struct napi_struct *napi, int budget)
> +{
> +	struct spl2sw_common *comm = container_of(napi, struct spl2sw_common, rx_napi);
> +	struct spl2sw_mac_desc *desc, *h_desc;
> +	struct net_device_stats *stats;
> +	struct sk_buff *skb, *new_skb;
> +	struct spl2sw_skb_info *sinfo;
> +	int budget_left = budget;
> +	unsigned long flags;
> +	u32 rx_pos, pkg_len;
> +	u32 num, rx_count;
> +	s32 queue;
> +	u32 mask;
> +	int port;
> +	u32 cmd;
> +
> +	/* Process high-priority queue and then low-priority queue. */
> +	for (queue = 0; queue < RX_DESC_QUEUE_NUM; queue++) {
> +		rx_pos = comm->rx_pos[queue];
> +		rx_count = comm->rx_desc_num[queue];
> +
> +		for (num = 0; num < rx_count && budget_left; num++) {
> +			sinfo = comm->rx_skb_info[queue] + rx_pos;
> +			desc = comm->rx_desc[queue] + rx_pos;
> +			cmd = desc->cmd1;
> +
> +			if (cmd & RXD_OWN)
> +				break;
> +
> +			port = FIELD_GET(RXD_PKT_SP, cmd);
> +			if (port < MAX_NETDEV_NUM && comm->ndev[port])
> +				stats = &comm->ndev[port]->stats;
> +			else
> +				goto spl2sw_rx_poll_rec_err;
> +
> +			pkg_len = FIELD_GET(RXD_PKT_LEN, cmd);
> +			if (unlikely((cmd & RXD_ERR_CODE) || pkg_len < ETH_ZLEN + 4)) {
> +				stats->rx_length_errors++;
> +				stats->rx_dropped++;
> +				goto spl2sw_rx_poll_rec_err;
> +			}
> +
> +			dma_unmap_single(&comm->pdev->dev, sinfo->mapping,
> +					 comm->rx_desc_buff_size, DMA_FROM_DEVICE);
> +
> +			skb = sinfo->skb;
> +			skb_put(skb, pkg_len - 4); /* Minus FCS */
> +			skb->ip_summed = CHECKSUM_NONE;
> +			skb->protocol = eth_type_trans(skb, comm->ndev[port]);
> +			netif_receive_skb(skb);
> +
> +			stats->rx_packets++;
> +			stats->rx_bytes += skb->len;
> +
> +			/* Allocate a new skb for receiving. */
> +			new_skb = netdev_alloc_skb(NULL, comm->rx_desc_buff_size);
> +			if (unlikely(!new_skb)) {
> +				desc->cmd2 = (rx_pos == comm->rx_desc_num[queue] - 1) ?
> +					     RXD_EOR : 0;
> +				sinfo->skb = NULL;
> +				sinfo->mapping = 0;
> +				desc->addr1 = 0;
> +				goto spl2sw_rx_poll_alloc_err;
> +			}
> +
> +			sinfo->mapping = dma_map_single(&comm->pdev->dev, new_skb->data,
> +							comm->rx_desc_buff_size,
> +							DMA_FROM_DEVICE);
> +			if (dma_mapping_error(&comm->pdev->dev, sinfo->mapping)) {
> +				dev_kfree_skb_irq(new_skb);
> +				desc->cmd2 = (rx_pos == comm->rx_desc_num[queue] - 1) ?
> +					     RXD_EOR : 0;
> +				sinfo->skb = NULL;
> +				sinfo->mapping = 0;
> +				desc->addr1 = 0;
> +				goto spl2sw_rx_poll_alloc_err;
> +			}
> +
> +			sinfo->skb = new_skb;
> +			desc->addr1 = sinfo->mapping;
> +
> +spl2sw_rx_poll_rec_err:
> +			desc->cmd2 = (rx_pos == comm->rx_desc_num[queue] - 1) ?
> +				     RXD_EOR | comm->rx_desc_buff_size :
> +				     comm->rx_desc_buff_size;
> +
> +			wmb();	/* Set RXD_OWN after other fields are effective. */
> +			desc->cmd1 = RXD_OWN;
> +
> +spl2sw_rx_poll_alloc_err:
> +			/* Move rx_pos to next position */
> +			rx_pos = ((rx_pos + 1) == comm->rx_desc_num[queue]) ? 0 : rx_pos + 1;
> +
> +			budget_left--;
> +
> +			/* If there are packets in high-priority queue,
> +			 * stop processing low-priority queue.
> +			 */
> +			if (queue == 1 && !(h_desc->cmd1 & RXD_OWN))
> +				break;
> +		}
> +
> +		comm->rx_pos[queue] = rx_pos;
> +
> +		/* Save pointer to last rx descriptor of high-priority queue. */
> +		if (queue == 0)
> +			h_desc = comm->rx_desc[queue] + rx_pos;
> +	}
> +
> +	wmb();	/* make sure settings are effective. */

It's unclear to me why a memory barrier is needed here. Which writes
should be visibile before the following? Also the spin lock/unlock pair
below implies a full memory barrier.

> +	spin_lock_irqsave(&comm->int_mask_lock, flags);
> +	mask = readl(comm->l2sw_reg_base + L2SW_SW_INT_MASK_0);
> +	mask &= ~MAC_INT_RX;
> +	writel(mask, comm->l2sw_reg_base + L2SW_SW_INT_MASK_0);
> +	spin_unlock_irqrestore(&comm->int_mask_lock, flags);
> +
> +	napi_complete(napi);
> +	return budget - budget_left;
> +}
> +
> +int spl2sw_tx_poll(struct napi_struct *napi, int budget)
> +{
> +	struct spl2sw_common *comm = container_of(napi, struct spl2sw_common, tx_napi);
> +	struct spl2sw_skb_info *skbinfo;
> +	struct net_device_stats *stats;
> +	int budget_left = budget;
> +	unsigned long flags;
> +	u32 tx_done_pos;
> +	u32 mask;
> +	u32 cmd;
> +	int i;
> +
> +	spin_lock(&comm->tx_lock);
> +
> +	tx_done_pos = comm->tx_done_pos;
> +	while (((tx_done_pos != comm->tx_pos) || (comm->tx_desc_full == 1)) && budget_left) {
> +		cmd = comm->tx_desc[tx_done_pos].cmd1;
> +		if (cmd & TXD_OWN)
> +			break;
> +
> +		skbinfo = &comm->tx_temp_skb_info[tx_done_pos];
> +		if (unlikely(!skbinfo->skb))
> +			goto spl2sw_tx_poll_next;
> +
> +		i = ffs(FIELD_GET(TXD_VLAN, cmd)) - 1;
> +		if (i < MAX_NETDEV_NUM && comm->ndev[i])
> +			stats = &comm->ndev[i]->stats;
> +		else
> +			goto spl2sw_tx_poll_unmap;
> +
> +		if (unlikely(cmd & (TXD_ERR_CODE))) {
> +			stats->tx_errors++;
> +		} else {
> +			stats->tx_packets++;
> +			stats->tx_bytes += skbinfo->len;
> +		}
> +
> +spl2sw_tx_poll_unmap:
> +		dma_unmap_single(&comm->pdev->dev, skbinfo->mapping, skbinfo->len,
> +				 DMA_TO_DEVICE);
> +		skbinfo->mapping = 0;
> +		dev_kfree_skb_irq(skbinfo->skb);
> +		skbinfo->skb = NULL;
> +
> +spl2sw_tx_poll_next:
> +		/* Move tx_done_pos to next position */
> +		tx_done_pos = ((tx_done_pos + 1) == TX_DESC_NUM) ? 0 : tx_done_pos + 1;
> +
> +		if (comm->tx_desc_full == 1)
> +			comm->tx_desc_full = 0;
> +
> +		budget_left--;
> +	}
> +
> +	comm->tx_done_pos = tx_done_pos;
> +	if (!comm->tx_desc_full)
> +		for (i = 0; i < MAX_NETDEV_NUM; i++)
> +			if (comm->ndev[i])
> +				if (netif_queue_stopped(comm->ndev[i]))
> +					netif_wake_queue(comm->ndev[i]);
> +
> +	spin_unlock(&comm->tx_lock);
> +
> +	wmb();			/* make sure settings are effective. */

Same here.

Thanks,

Paolo

