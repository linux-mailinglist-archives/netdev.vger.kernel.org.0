Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 53D3E39F7C9
	for <lists+netdev@lfdr.de>; Tue,  8 Jun 2021 15:25:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233045AbhFHN1A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Jun 2021 09:27:00 -0400
Received: from out28-99.mail.aliyun.com ([115.124.28.99]:52602 "EHLO
        out28-99.mail.aliyun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233011AbhFHN05 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Jun 2021 09:26:57 -0400
X-Alimail-AntiSpam: AC=CONTINUE;BC=0.06712966|-1;CH=green;DM=|CONTINUE|false|;DS=CONTINUE|ham_regular_dialog|0.0523574-0.000283678-0.947359;FP=0|0|0|0|0|-1|-1|-1;HT=ay29a033018047190;MF=zhouyanjie@wanyeetech.com;NM=1;PH=DS;RN=21;RT=21;SR=0;TI=SMTPD_---.KPRhPnH_1623158698;
Received: from 192.168.0.103(mailfrom:zhouyanjie@wanyeetech.com fp:SMTPD_---.KPRhPnH_1623158698)
          by smtp.aliyun-inc.com(10.147.41.143);
          Tue, 08 Jun 2021 21:24:59 +0800
Subject: Re: [PATCH 2/2] net: stmmac: Add Ingenic SoCs MAC support.
To:     Paul Cercueil <paul@crapouillou.net>,
        =?UTF-8?B?5ZGo55Cw5p2w?= <zhouyanjie@wanyeetech.com>
Cc:     davem@davemloft.net, kuba@kernel.org, robh+dt@kernel.org,
        peppe.cavallaro@st.com, alexandre.torgue@foss.st.com,
        joabreu@synopsys.com, mcoquelin.stm32@gmail.com,
        linux-mips@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, dongsheng.qiu@ingenic.com,
        aric.pzqi@ingenic.com, rick.tyliu@ingenic.com,
        sihui.liu@ingenic.com, jun.jiang@ingenic.com,
        sernia.zhou@foxmail.com
References: <1623086867-119039-1-git-send-email-zhouyanjie@wanyeetech.com>
 <1623086867-119039-3-git-send-email-zhouyanjie@wanyeetech.com>
 <GDKDUQ.OOVD9KC4HV31@crapouillou.net>
From:   Zhou Yanjie <zhouyanjie@wanyeetech.com>
Message-ID: <55d2488a-d536-6541-6104-abfeb8a75c0b@wanyeetech.com>
Date:   Tue, 8 Jun 2021 21:24:58 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <GDKDUQ.OOVD9KC4HV31@crapouillou.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Paul,

On 2021/6/8 下午4:46, Paul Cercueil wrote:
> Hi Zhou,
>
> Le mar., juin 8 2021 at 01:27:47 +0800, 周琰杰 (Zhou Yanjie) 
> <zhouyanjie@wanyeetech.com> a écrit :
>> Add support for Ingenic SoC MAC glue layer support for the stmmac
>> device driver. This driver is used on for the MAC ethernet controller
>> found in the JZ4775 SoC, the X1000 SoC, the X1600 SoC, the X1830 SoC,
>> and the X2000 SoC.
>>
>> Signed-off-by: 周琰杰 (Zhou Yanjie) <zhouyanjie@wanyeetech.com>
>> ---
>>  drivers/net/ethernet/stmicro/stmmac/Kconfig        |  16 +-
>>  drivers/net/ethernet/stmicro/stmmac/Makefile       |   1 +
>>  .../net/ethernet/stmicro/stmmac/dwmac-ingenic.c    | 367 
>> +++++++++++++++++++++
>>  3 files changed, 382 insertions(+), 2 deletions(-)
>>  create mode 100644 drivers/net/ethernet/stmicro/stmmac/dwmac-ingenic.c
>>
>> diff --git a/drivers/net/ethernet/stmicro/stmmac/Kconfig 
>> b/drivers/net/ethernet/stmicro/stmmac/Kconfig
>> index 7737e4d0..fb58537 100644
>> --- a/drivers/net/ethernet/stmicro/stmmac/Kconfig
>> +++ b/drivers/net/ethernet/stmicro/stmmac/Kconfig
>> @@ -66,6 +66,18 @@ config DWMAC_ANARION
>>
>>        This selects the Anarion SoC glue layer support for the stmmac 
>> driver.
>>
>> +config DWMAC_INGENIC
>> +    tristate "Ingenic MAC support"
>> +    default MACH_INGENIC
>> +    depends on OF && HAS_IOMEM && (MACH_INGENIC || COMPILE_TEST)
>> +    select MFD_SYSCON
>> +    help
>> +      Support for ethernet controller on Ingenic SoCs.
>> +
>> +      This selects Ingenic SoCs glue layer support for the stmmac
>> +      device driver. This driver is used on for the Ingenic SoCs
>> +      MAC ethernet controller.
>> +
>>  config DWMAC_IPQ806X
>>      tristate "QCA IPQ806x DWMAC support"
>>      default ARCH_QCOM
>> @@ -129,7 +141,7 @@ config DWMAC_QCOM_ETHQOS
>>
>>  config DWMAC_ROCKCHIP
>>      tristate "Rockchip dwmac support"
>> -    default ARCH_ROCKCHIP
>> +    default MACH_ROCKCHIP
>>      depends on OF && (ARCH_ROCKCHIP || COMPILE_TEST)
>>      select MFD_SYSCON
>>      help
>> @@ -164,7 +176,7 @@ config DWMAC_STI
>>
>>  config DWMAC_STM32
>>      tristate "STM32 DWMAC support"
>> -    default ARCH_STM32
>> +    default MACH_STM32
>>      depends on OF && HAS_IOMEM && (ARCH_STM32 || COMPILE_TEST)
>>      select MFD_SYSCON
>>      help
>> diff --git a/drivers/net/ethernet/stmicro/stmmac/Makefile 
>> b/drivers/net/ethernet/stmicro/stmmac/Makefile
>> index f2e478b..6471f93 100644
>> --- a/drivers/net/ethernet/stmicro/stmmac/Makefile
>> +++ b/drivers/net/ethernet/stmicro/stmmac/Makefile
>> @@ -14,6 +14,7 @@ stmmac-$(CONFIG_STMMAC_SELFTESTS) += 
>> stmmac_selftests.o
>>  # Ordering matters. Generic driver must be last.
>>  obj-$(CONFIG_STMMAC_PLATFORM)    += stmmac-platform.o
>>  obj-$(CONFIG_DWMAC_ANARION)    += dwmac-anarion.o
>> +obj-$(CONFIG_DWMAC_INGENIC)    += dwmac-ingenic.o
>>  obj-$(CONFIG_DWMAC_IPQ806X)    += dwmac-ipq806x.o
>>  obj-$(CONFIG_DWMAC_LPC18XX)    += dwmac-lpc18xx.o
>>  obj-$(CONFIG_DWMAC_MEDIATEK)    += dwmac-mediatek.o
>> diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-ingenic.c 
>> b/drivers/net/ethernet/stmicro/stmmac/dwmac-ingenic.c
>> new file mode 100644
>> index 00000000..8be8caa
>> --- /dev/null
>> +++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-ingenic.c
>> @@ -0,0 +1,367 @@
>> +// SPDX-License-Identifier: GPL-2.0
>> +/*
>> + * dwmac-ingenic.c - Ingenic SoCs DWMAC specific glue layer
>> + *
>> + * Copyright (c) 2020 周琰杰 (Zhou Yanjie) <zhouyanjie@wanyeetech.com>
>
> 2021?


Sure, I will change it.


>
>> + */
>> +
>> +#include <linux/bitfield.h>
>> +#include <linux/clk.h>
>> +#include <linux/kernel.h>
>> +#include <linux/mfd/syscon.h>
>> +#include <linux/module.h>
>> +#include <linux/of.h>
>> +#include <linux/of_device.h>
>> +#include <linux/of_net.h>
>> +#include <linux/phy.h>
>> +#include <linux/platform_device.h>
>> +#include <linux/regmap.h>
>> +#include <linux/slab.h>
>> +#include <linux/stmmac.h>
>> +
>> +#include "stmmac_platform.h"
>> +
>> +#define MACPHYC_TXCLK_SEL_MASK        GENMASK(31, 31)
>> +#define MACPHYC_TXCLK_SEL_OUTPUT    0x1
>> +#define MACPHYC_TXCLK_SEL_INPUT        0x0
>> +#define MACPHYC_MODE_SEL_MASK        GENMASK(31, 31)
>> +#define MACPHYC_MODE_SEL_RMII        0x0
>> +#define MACPHYC_TX_SEL_MASK            GENMASK(19, 19)
>> +#define MACPHYC_TX_SEL_ORIGIN        0x0
>> +#define MACPHYC_TX_SEL_DELAY        0x1
>> +#define MACPHYC_TX_DELAY_MASK        GENMASK(18, 12)
>> +#define MACPHYC_TX_DELAY_63_UNIT    0x3e
>> +#define MACPHYC_RX_SEL_MASK            GENMASK(11, 11)
>> +#define MACPHYC_RX_SEL_ORIGIN        0x0
>> +#define MACPHYC_RX_SEL_DELAY        0x1
>> +#define MACPHYC_RX_DELAY_MASK        GENMASK(10, 4)
>> +#define MACPHYC_SOFT_RST_MASK        GENMASK(3, 3)
>> +#define MACPHYC_PHY_INFT_MASK        GENMASK(2, 0)
>> +#define MACPHYC_PHY_INFT_RMII        0x4
>> +#define MACPHYC_PHY_INFT_RGMII        0x1
>> +#define MACPHYC_PHY_INFT_GMII        0x0
>> +#define MACPHYC_PHY_INFT_MII        0x0
>> +
>> +enum ingenic_mac_version {
>> +    ID_JZ4775,
>> +    ID_X1000,
>> +    ID_X1600,
>> +    ID_X1830,
>> +    ID_X2000,
>
> You could test it on all these? I never heard about the X1600 before.
>

Yes, X1600 is a new model for industrial control applications that has

just been launched. It has two CAN interfaces and one CDBUS interface.


>> +};
>> +
>> +struct ingenic_mac {
>> +    const struct ingenic_soc_info *soc_info;
>> +    struct device *dev;
>> +    struct regmap *regmap;
>> +};
>> +
>> +struct ingenic_soc_info {
>> +    enum ingenic_mac_version version;
>> +    u32 mask;
>> +
>> +    int (*set_mode)(struct plat_stmmacenet_data *plat_dat);
>> +    int (*suspend)(struct ingenic_mac *mac);
>> +    void (*resume)(struct ingenic_mac *mac);
>
> These suspend/resume callbacks are not used anywhere - just drop them.
>

Sure.


>> +};
>> +
>> +static int ingenic_mac_init(struct plat_stmmacenet_data *plat_dat)
>> +{
>> +    struct ingenic_mac *mac = plat_dat->bsp_priv;
>> +    int ret;
>> +
>> +    if (mac->soc_info->set_mode) {
>> +        ret = mac->soc_info->set_mode(plat_dat);
>> +        if (ret)
>> +            return ret;
>> +    }
>> +
>> +    return ret;
>
> You are returning an uninitialized variable.
>

Sure, I'll change it in the next version.


>> +}
>> +
>> +static int jz4775_mac_set_mode(struct plat_stmmacenet_data *plat_dat)
>> +{
>> +    struct ingenic_mac *mac = plat_dat->bsp_priv;
>> +    int val;
>
> unsigned int val;
>

Sure.


>> +
>> +    switch (plat_dat->interface) {
>> +    case PHY_INTERFACE_MODE_MII:
>> +        val = FIELD_PREP(MACPHYC_TXCLK_SEL_MASK, 
>> MACPHYC_TXCLK_SEL_INPUT) |
>> +              FIELD_PREP(MACPHYC_PHY_INFT_MASK, MACPHYC_PHY_INFT_MII);
>> +        pr_debug("MAC PHY Control Register: PHY_INTERFACE_MODE_MII\n");
>
> Use dev_dbg() with mac->dev, instead of pr_debug().
>
> (Same for all pr_debug() calls below)
>

Sure.


>> +        break;
>> +
>> +    case PHY_INTERFACE_MODE_GMII:
>> +        val = FIELD_PREP(MACPHYC_TXCLK_SEL_MASK, 
>> MACPHYC_TXCLK_SEL_INPUT) |
>> +              FIELD_PREP(MACPHYC_PHY_INFT_MASK, MACPHYC_PHY_INFT_GMII);
>> +        pr_debug("MAC PHY Control Register: 
>> PHY_INTERFACE_MODE_GMII\n");
>> +        break;
>> +
>> +    case PHY_INTERFACE_MODE_RMII:
>> +        val = FIELD_PREP(MACPHYC_TXCLK_SEL_MASK, 
>> MACPHYC_TXCLK_SEL_INPUT) |
>> +              FIELD_PREP(MACPHYC_PHY_INFT_MASK, MACPHYC_PHY_INFT_RMII);
>> +        pr_debug("MAC PHY Control Register: 
>> PHY_INTERFACE_MODE_RMII\n");
>> +        break;
>> +
>> +    case PHY_INTERFACE_MODE_RGMII:
>> +        val = FIELD_PREP(MACPHYC_TXCLK_SEL_MASK, 
>> MACPHYC_TXCLK_SEL_INPUT) |
>> +              FIELD_PREP(MACPHYC_PHY_INFT_MASK, 
>> MACPHYC_PHY_INFT_RGMII);
>> +        pr_debug("MAC PHY Control Register: 
>> PHY_INTERFACE_MODE_RGMII\n");
>> +        break;
>> +
>> +    default:
>> +        dev_err(mac->dev, "unsupported interface %d", 
>> plat_dat->interface);
>> +        return -EINVAL;
>> +    }
>> +
>> +    /* Update MAC PHY control register */
>> +    return regmap_update_bits(mac->regmap, 0, mac->soc_info->mask, 
>> val);
>> +}
>> +
>> +static int x1000_mac_set_mode(struct plat_stmmacenet_data *plat_dat)
>> +{
>> +    struct ingenic_mac *mac = plat_dat->bsp_priv;
>> +    int val;
>> +
>> +    switch (plat_dat->interface) {
>> +    case PHY_INTERFACE_MODE_RMII:
>> +        pr_debug("MAC PHY Control Register: 
>> PHY_INTERFACE_MODE_RMII\n");
>> +        break;
>> +
>> +    default:
>> +        dev_err(mac->dev, "unsupported interface %d", 
>> plat_dat->interface);
>> +        return -EINVAL;
>> +    }
>> +
>> +    /* Update MAC PHY control register */
>> +    return regmap_update_bits(mac->regmap, 0, mac->soc_info->mask, 
>> val);
>
> You're passing 'val', which is an uninitialized variable.
>

I will fix this int the next version.


>> +}
>> +
>> +static int x1600_mac_set_mode(struct plat_stmmacenet_data *plat_dat)
>> +{
>> +    struct ingenic_mac *mac = plat_dat->bsp_priv;
>> +    int val;
>
> unsigned int val;
>

Sure.


>> +
>> +    switch (plat_dat->interface) {
>> +    case PHY_INTERFACE_MODE_RMII:
>> +        val = FIELD_PREP(MACPHYC_PHY_INFT_MASK, MACPHYC_PHY_INFT_RMII);
>> +        pr_debug("MAC PHY Control Register: 
>> PHY_INTERFACE_MODE_RMII\n");
>> +        break;
>> +
>> +    default:
>> +        dev_err(mac->dev, "unsupported interface %d", 
>> plat_dat->interface);
>> +        return -EINVAL;
>> +    }
>> +
>> +    /* Update MAC PHY control register */
>> +    return regmap_update_bits(mac->regmap, 0, mac->soc_info->mask, 
>> val);
>> +}
>> +
>> +static int x1830_mac_set_mode(struct plat_stmmacenet_data *plat_dat)
>> +{
>> +    struct ingenic_mac *mac = plat_dat->bsp_priv;
>> +    int val;
>
> Same here,
>

Sure.


>> +
>> +    switch (plat_dat->interface) {
>> +    case PHY_INTERFACE_MODE_RMII:
>> +        val = FIELD_PREP(MACPHYC_MODE_SEL_MASK, 
>> MACPHYC_MODE_SEL_RMII) |
>> +              FIELD_PREP(MACPHYC_PHY_INFT_MASK, MACPHYC_PHY_INFT_RMII);
>> +        pr_debug("MAC PHY Control Register: 
>> PHY_INTERFACE_MODE_RMII\n");
>> +        break;
>> +
>> +    default:
>> +        dev_err(mac->dev, "unsupported interface %d", 
>> plat_dat->interface);
>> +        return -EINVAL;
>> +    }
>> +
>> +    /* Update MAC PHY control register */
>> +    return regmap_update_bits(mac->regmap, 0, mac->soc_info->mask, 
>> val);
>> +}
>> +
>> +static int x2000_mac_set_mode(struct plat_stmmacenet_data *plat_dat)
>> +{
>> +    struct ingenic_mac *mac = plat_dat->bsp_priv;
>> +    int val;
>
> Same here.
>

Sure.


>> +
>> +    switch (plat_dat->interface) {
>> +    case PHY_INTERFACE_MODE_RMII:
>> +        val = FIELD_PREP(MACPHYC_TX_SEL_MASK, MACPHYC_TX_SEL_ORIGIN) |
>> +              FIELD_PREP(MACPHYC_RX_SEL_MASK, MACPHYC_RX_SEL_ORIGIN) |
>> +              FIELD_PREP(MACPHYC_PHY_INFT_MASK, MACPHYC_PHY_INFT_RMII);
>> +        pr_debug("MAC PHY Control Register: 
>> PHY_INTERFACE_MODE_RMII\n");
>> +        break;
>> +
>> +    case PHY_INTERFACE_MODE_RGMII:
>> +        val = FIELD_PREP(MACPHYC_TX_SEL_MASK, MACPHYC_TX_SEL_DELAY) |
>> +              FIELD_PREP(MACPHYC_TX_DELAY_MASK, 
>> MACPHYC_TX_DELAY_63_UNIT) |
>> +              FIELD_PREP(MACPHYC_RX_SEL_MASK, MACPHYC_RX_SEL_ORIGIN) |
>> +              FIELD_PREP(MACPHYC_PHY_INFT_MASK, 
>> MACPHYC_PHY_INFT_RGMII);
>> +        pr_debug("MAC PHY Control Register: 
>> PHY_INTERFACE_MODE_RGMII\n");
>> +        break;
>> +
>> +    default:
>> +        dev_err(mac->dev, "unsupported interface %d", 
>> plat_dat->interface);
>> +        return -EINVAL;
>> +    }
>> +
>> +    /* Update MAC PHY control register */
>> +    return regmap_update_bits(mac->regmap, 0, mac->soc_info->mask, 
>> val);
>> +}
>> +
>> +static int ingenic_mac_probe(struct platform_device *pdev)
>> +{
>> +    struct plat_stmmacenet_data *plat_dat;
>> +    struct stmmac_resources stmmac_res;
>> +    struct ingenic_mac *mac;
>> +    const struct ingenic_soc_info *data;
>> +    int ret;
>> +
>> +    ret = stmmac_get_platform_resources(pdev, &stmmac_res);
>> +    if (ret)
>> +        return ret;
>> +
>> +    plat_dat = stmmac_probe_config_dt(pdev, stmmac_res.mac);
>> +    if (IS_ERR(plat_dat))
>> +        return PTR_ERR(plat_dat);
>> +
>> +    mac = devm_kzalloc(&pdev->dev, sizeof(*mac), GFP_KERNEL);
>> +    if (!mac) {
>> +        ret = -ENOMEM;
>> +        goto err_remove_config_dt;
>> +    }
>> +
>> +    data = of_device_get_match_data(&pdev->dev);
>> +    if (!data) {
>> +        dev_err(&pdev->dev, "no of match data provided\n");
>> +        ret = -EINVAL;
>> +        goto err_remove_config_dt;
>> +    }
>> +
>> +    /* Get MAC PHY control register */
>> +    mac->regmap = syscon_regmap_lookup_by_phandle(pdev->dev.of_node, 
>> "mode-reg");
>> +    if (IS_ERR(mac->regmap)) {
>> +        pr_err("%s: failed to get syscon regmap\n", __func__);
>
> dev_err?
>

Sure, I will change this in v2.


>> +        goto err_remove_config_dt;
>> +    }
>> +
>> +    mac->soc_info = data;
>> +    mac->dev = &pdev->dev;
>> +
>> +    plat_dat->bsp_priv = mac;
>> +
>> +    ret = ingenic_mac_init(plat_dat);
>> +    if (ret)
>> +        goto err_remove_config_dt;
>> +
>> +    ret = stmmac_dvr_probe(&pdev->dev, plat_dat, &stmmac_res);
>> +    if (ret)
>> +        goto err_remove_config_dt;
>> +
>> +    return 0;
>> +
>> +err_remove_config_dt:
>> +    stmmac_remove_config_dt(pdev, plat_dat);
>> +
>> +    return ret;
>> +}
>> +
>> +#ifdef CONFIG_PM_SLEEP
>
> Remove this #ifdef.
>

Sure.


>> +static int ingenic_mac_suspend(struct device *dev)
>> +{
>> +    struct net_device *ndev = dev_get_drvdata(dev);
>> +    struct stmmac_priv *priv = netdev_priv(ndev);
>> +    struct ingenic_mac *mac = priv->plat->bsp_priv;
>> +
>> +    int ret;
>> +
>> +    ret = stmmac_suspend(dev);
>> +
>> +    if (mac->soc_info->suspend)
>> +        ret = mac->soc_info->suspend(mac);
>> +
>> +    return ret;
>> +}
>> +
>> +static int ingenic_mac_resume(struct device *dev)
>> +{
>> +    struct net_device *ndev = dev_get_drvdata(dev);
>> +    struct stmmac_priv *priv = netdev_priv(ndev);
>> +    struct ingenic_mac *mac = priv->plat->bsp_priv;
>> +    int ret;
>> +
>> +    if (mac->soc_info->resume)
>> +        mac->soc_info->resume(mac);
>> +
>> +    ret = ingenic_mac_init(priv->plat);
>> +    if (ret)
>> +        return ret;
>> +
>> +    ret = stmmac_resume(dev);
>> +
>> +    return ret;
>> +}
>> +#endif /* CONFIG_PM_SLEEP */
>> +
>> +static SIMPLE_DEV_PM_OPS(ingenic_mac_pm_ops,
>> +    ingenic_mac_suspend, ingenic_mac_resume);
>> +
>> +static struct ingenic_soc_info jz4775_soc_info = {
>> +    .version = ID_JZ4775,
>> +    .mask = MACPHYC_TXCLK_SEL_MASK | MACPHYC_SOFT_RST_MASK | 
>> MACPHYC_PHY_INFT_MASK,
>> +
>> +    .set_mode = jz4775_mac_set_mode,
>> +};
>> +
>> +static struct ingenic_soc_info x1000_soc_info = {
>> +    .version = ID_X1000,
>> +    .mask = MACPHYC_SOFT_RST_MASK,
>> +
>> +    .set_mode = x1000_mac_set_mode,
>> +};
>> +
>> +static struct ingenic_soc_info x1600_soc_info = {
>> +    .version = ID_X1600,
>> +    .mask = MACPHYC_SOFT_RST_MASK | MACPHYC_PHY_INFT_MASK,
>> +
>> +    .set_mode = x1600_mac_set_mode,
>> +};
>> +
>> +static struct ingenic_soc_info x1830_soc_info = {
>> +    .version = ID_X1830,
>> +    .mask = MACPHYC_MODE_SEL_MASK | MACPHYC_SOFT_RST_MASK | 
>> MACPHYC_PHY_INFT_MASK,
>> +
>> +    .set_mode = x1830_mac_set_mode,
>> +};
>> +
>> +static struct ingenic_soc_info x2000_soc_info = {
>> +    .version = ID_X2000,
>> +    .mask = MACPHYC_TX_SEL_MASK | MACPHYC_TX_DELAY_MASK | 
>> MACPHYC_RX_SEL_MASK |
>> +            MACPHYC_RX_DELAY_MASK | MACPHYC_SOFT_RST_MASK | 
>> MACPHYC_PHY_INFT_MASK,
>> +
>> +    .set_mode = x2000_mac_set_mode,
>> +};
>> +
>> +static const struct of_device_id ingenic_mac_of_matches[] = {
>> +    { .compatible = "ingenic,jz4775-mac", .data = &jz4775_soc_info },
>> +    { .compatible = "ingenic,x1000-mac", .data = &x1000_soc_info },
>> +    { .compatible = "ingenic,x1600-mac", .data = &x1600_soc_info },
>> +    { .compatible = "ingenic,x1830-mac", .data = &x1830_soc_info },
>> +    { .compatible = "ingenic,x2000-mac", .data = &x2000_soc_info },
>> +    { }
>> +};
>> +MODULE_DEVICE_TABLE(of, ingenic_mac_of_matches);
>> +
>> +static struct platform_driver ingenic_mac_driver = {
>> +    .probe        = ingenic_mac_probe,
>> +    .remove        = stmmac_pltfr_remove,
>> +    .driver        = {
>> +        .name    = "ingenic-mac",
>> +        .pm        = &ingenic_mac_pm_ops,
>
> .pm = pm_ptr(&ingenic_mac_pm_ops),
>

Sure.


Thanks and best regards!


>> +        .of_match_table = ingenic_mac_of_matches,
>> +    },
>> +};
>> +module_platform_driver(ingenic_mac_driver);
>> +
>> +MODULE_AUTHOR("周琰杰 (Zhou Yanjie) <zhouyanjie@wanyeetech.com>");
>> +MODULE_DESCRIPTION("Ingenic SoCs DWMAC specific glue layer");
>> +MODULE_LICENSE("GPL v2");
>> -- 
>> 2.7.4
>>
>
> Cheers,
> -Paul
>
