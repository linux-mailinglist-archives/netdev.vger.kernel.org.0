Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4B3BD55CC3C
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 15:01:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238202AbiF0Tel (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jun 2022 15:34:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236184AbiF0Tek (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jun 2022 15:34:40 -0400
Received: from smtp3.emailarray.com (smtp3.emailarray.com [65.39.216.17])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41AE262D7
        for <netdev@vger.kernel.org>; Mon, 27 Jun 2022 12:34:39 -0700 (PDT)
Received: (qmail 29873 invoked by uid 89); 27 Jun 2022 19:34:37 -0000
Received: from unknown (HELO localhost) (amxlbW9uQGZsdWdzdmFtcC5jb21AMTYzLjExNC4xMzIuNQ==) (POLARISLOCAL)  
  by smtp3.emailarray.com with SMTP; 27 Jun 2022 19:34:37 -0000
Date:   Mon, 27 Jun 2022 12:34:36 -0700
From:   Jonathan Lemon <jonathan.lemon@gmail.com>
To:     Vadim Fedorenko <vfedorenko@novek.ru>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>,
        Vadim Fedorenko <vadfed@fb.com>, Aya Levin <ayal@nvidia.com>,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-clk@vger.kernel.org
Subject: Re: [RFC PATCH v2 3/3] ptp_ocp: implement DPLL ops
Message-ID: <20220627193436.3wjunjqqtx7dtqm6@bsd-mbp.dhcp.thefacebook.com>
References: <20220626192444.29321-1-vfedorenko@novek.ru>
 <20220626192444.29321-4-vfedorenko@novek.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220626192444.29321-4-vfedorenko@novek.ru>
X-Spam-Status: No, score=0.7 required=5.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
        FORGED_GMAIL_RCVD,FREEMAIL_FROM,NML_ADSP_CUSTOM_MED,SPF_HELO_NONE,
        SPF_SOFTFAIL,T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jun 26, 2022 at 10:24:44PM +0300, Vadim Fedorenko wrote:
> From: Vadim Fedorenko <vadfed@fb.com>
> 
> Implement DPLL operations in ptp_ocp driver.
> 
> Signed-off-by: Vadim Fedorenko <vadfed@fb.com>
> ---
>  drivers/ptp/Kconfig       |   1 +
>  drivers/ptp/ptp_ocp.c     | 169 ++++++++++++++++++++++++++++++--------
>  include/uapi/linux/dpll.h |   2 +
>  3 files changed, 136 insertions(+), 36 deletions(-)
> 
> diff --git a/drivers/ptp/Kconfig b/drivers/ptp/Kconfig
> index 458218f88c5e..f74846ebc177 100644
> --- a/drivers/ptp/Kconfig
> +++ b/drivers/ptp/Kconfig
> @@ -176,6 +176,7 @@ config PTP_1588_CLOCK_OCP
>  	depends on !S390
>  	depends on COMMON_CLK
>  	select NET_DEVLINK
> +	select DPLL
>  	help
>  	  This driver adds support for an OpenCompute time card.
>  
> diff --git a/drivers/ptp/ptp_ocp.c b/drivers/ptp/ptp_ocp.c
> index e59ea2173aac..f830625a63a3 100644
> --- a/drivers/ptp/ptp_ocp.c
> +++ b/drivers/ptp/ptp_ocp.c
> @@ -21,6 +21,7 @@
>  #include <linux/mtd/mtd.h>
>  #include <linux/nvmem-consumer.h>
>  #include <linux/crc16.h>
> +#include <uapi/linux/dpll.h>
>  
>  #define PCI_VENDOR_ID_FACEBOOK			0x1d9b
>  #define PCI_DEVICE_ID_FACEBOOK_TIMECARD		0x0400
> @@ -336,6 +337,7 @@ struct ptp_ocp {
>  	struct ptp_ocp_signal	signal[4];
>  	struct ptp_ocp_sma_connector sma[4];
>  	const struct ocp_sma_op *sma_op;
> +	struct dpll_device *dpll;
>  };
>  
>  #define OCP_REQ_TIMESTAMP	BIT(0)
> @@ -660,18 +662,19 @@ static DEFINE_IDR(ptp_ocp_idr);
>  struct ocp_selector {
>  	const char *name;
>  	int value;
> +	int dpll_type;
>  };
>  
>  static const struct ocp_selector ptp_ocp_clock[] = {
> -	{ .name = "NONE",	.value = 0 },
> -	{ .name = "TOD",	.value = 1 },
> -	{ .name = "IRIG",	.value = 2 },
> -	{ .name = "PPS",	.value = 3 },
> -	{ .name = "PTP",	.value = 4 },
> -	{ .name = "RTC",	.value = 5 },
> -	{ .name = "DCF",	.value = 6 },
> -	{ .name = "REGS",	.value = 0xfe },
> -	{ .name = "EXT",	.value = 0xff },
> +	{ .name = "NONE",	.value = 0,		.dpll_type = 0 },
> +	{ .name = "TOD",	.value = 1,		.dpll_type = 0 },
> +	{ .name = "IRIG",	.value = 2,		.dpll_type = 0 },
> +	{ .name = "PPS",	.value = 3,		.dpll_type = 0 },
> +	{ .name = "PTP",	.value = 4,		.dpll_type = 0 },
> +	{ .name = "RTC",	.value = 5,		.dpll_type = 0 },
> +	{ .name = "DCF",	.value = 6,		.dpll_type = 0 },
> +	{ .name = "REGS",	.value = 0xfe,		.dpll_type = 0 },
> +	{ .name = "EXT",	.value = 0xff,		.dpll_type = 0 },

No need for zeros, or are they just temp stubs?

> @@ -680,37 +683,37 @@ static const struct ocp_selector ptp_ocp_clock[] = {
>  #define SMA_SELECT_MASK		GENMASK(14, 0)
>  
>  static const struct ocp_selector ptp_ocp_sma_in[] = {
> -	{ .name = "10Mhz",	.value = 0x0000 },
> -	{ .name = "PPS1",	.value = 0x0001 },
> -	{ .name = "PPS2",	.value = 0x0002 },
> -	{ .name = "TS1",	.value = 0x0004 },
> -	{ .name = "TS2",	.value = 0x0008 },
> -	{ .name = "IRIG",	.value = 0x0010 },
> -	{ .name = "DCF",	.value = 0x0020 },
> -	{ .name = "TS3",	.value = 0x0040 },
> -	{ .name = "TS4",	.value = 0x0080 },
> -	{ .name = "FREQ1",	.value = 0x0100 },
> -	{ .name = "FREQ2",	.value = 0x0200 },
> -	{ .name = "FREQ3",	.value = 0x0400 },
> -	{ .name = "FREQ4",	.value = 0x0800 },
> -	{ .name = "None",	.value = SMA_DISABLE },
> +	{ .name = "10Mhz",	.value = 0x0000,	.dpll_type = DPLL_TYPE_EXT_10MHZ },
> +	{ .name = "PPS1",	.value = 0x0001,	.dpll_type = DPLL_TYPE_EXT_1PPS },
> +	{ .name = "PPS2",	.value = 0x0002,	.dpll_type = DPLL_TYPE_EXT_1PPS },
> +	{ .name = "TS1",	.value = 0x0004,	.dpll_type = DPLL_TYPE_CUSTOM },
> +	{ .name = "TS2",	.value = 0x0008,	.dpll_type = DPLL_TYPE_CUSTOM },
> +	{ .name = "IRIG",	.value = 0x0010,	.dpll_type = DPLL_TYPE_CUSTOM },
> +	{ .name = "DCF",	.value = 0x0020,	.dpll_type = DPLL_TYPE_CUSTOM },
> +	{ .name = "TS3",	.value = 0x0040,	.dpll_type = DPLL_TYPE_CUSTOM },
> +	{ .name = "TS4",	.value = 0x0080,	.dpll_type = DPLL_TYPE_CUSTOM },
> +	{ .name = "FREQ1",	.value = 0x0100,	.dpll_type = DPLL_TYPE_CUSTOM },
> +	{ .name = "FREQ2",	.value = 0x0200,	.dpll_type = DPLL_TYPE_CUSTOM },
> +	{ .name = "FREQ3",	.value = 0x0400,	.dpll_type = DPLL_TYPE_CUSTOM },
> +	{ .name = "FREQ4",	.value = 0x0800,	.dpll_type = DPLL_TYPE_CUSTOM },
> +	{ .name = "None",	.value = SMA_DISABLE,	.dpll_type = DPLL_TYPE_NONE },

80-column limit (here and throughout the file)


>  static const struct ocp_selector ptp_ocp_sma_out[] = {
> -	{ .name = "10Mhz",	.value = 0x0000 },
> -	{ .name = "PHC",	.value = 0x0001 },
> -	{ .name = "MAC",	.value = 0x0002 },
> -	{ .name = "GNSS1",	.value = 0x0004 },
> -	{ .name = "GNSS2",	.value = 0x0008 },
> -	{ .name = "IRIG",	.value = 0x0010 },
> -	{ .name = "DCF",	.value = 0x0020 },
> -	{ .name = "GEN1",	.value = 0x0040 },
> -	{ .name = "GEN2",	.value = 0x0080 },
> -	{ .name = "GEN3",	.value = 0x0100 },
> -	{ .name = "GEN4",	.value = 0x0200 },
> -	{ .name = "GND",	.value = 0x2000 },
> -	{ .name = "VCC",	.value = 0x4000 },
> +	{ .name = "10Mhz",	.value = 0x0000,	.dpll_type = DPLL_TYPE_EXT_10MHZ },
> +	{ .name = "PHC",	.value = 0x0001,	.dpll_type = DPLL_TYPE_INT_OSCILLATOR },
> +	{ .name = "MAC",	.value = 0x0002,	.dpll_type = DPLL_TYPE_INT_OSCILLATOR },

How does this work?  The DPLL types seem somewhat restrictive here.


> +	{ .name = "GNSS1",	.value = 0x0004,	.dpll_type = DPLL_TYPE_GNSS },
> +	{ .name = "GNSS2",	.value = 0x0008,	.dpll_type = DPLL_TYPE_GNSS },
> +	{ .name = "IRIG",	.value = 0x0010,	.dpll_type = DPLL_TYPE_CUSTOM },
> +	{ .name = "DCF",	.value = 0x0020,	.dpll_type = DPLL_TYPE_CUSTOM },
> +	{ .name = "GEN1",	.value = 0x0040,	.dpll_type = DPLL_TYPE_CUSTOM },
> +	{ .name = "GEN2",	.value = 0x0080,	.dpll_type = DPLL_TYPE_CUSTOM },
> +	{ .name = "GEN3",	.value = 0x0100,	.dpll_type = DPLL_TYPE_CUSTOM },
> +	{ .name = "GEN4",	.value = 0x0200,	.dpll_type = DPLL_TYPE_CUSTOM },
> +	{ .name = "GND",	.value = 0x2000,	.dpll_type = DPLL_TYPE_CUSTOM },
> +	{ .name = "VCC",	.value = 0x4000,	.dpll_type = DPLL_TYPE_CUSTOM },

80-columns


>  
> @@ -3713,6 +3716,90 @@ ptp_ocp_detach(struct ptp_ocp *bp)
>  	device_unregister(&bp->dev);
>  }
>  
> +static int ptp_ocp_dpll_get_status(struct dpll_device *dpll)
> +{
> +	struct ptp_ocp *bp = (struct ptp_ocp *)dpll_priv(dpll);
> +	int sync;
> +
> +	sync = ioread32(&bp->reg->status) & OCP_STATUS_IN_SYNC;
> +	return sync;
> +}
> +
> +static int ptp_ocp_dpll_get_lock_status(struct dpll_device *dpll)
> +{
> +	struct ptp_ocp *bp = (struct ptp_ocp *)dpll_priv(dpll);
> +	int sync;
> +
> +	sync = ioread32(&bp->reg->status) & OCP_STATUS_IN_SYNC;
> +	return sync;
> +}
> +
> +static int ptp_ocp_sma_get_dpll_type(struct ptp_ocp *bp, int sma_nr)
> +{
> +	struct ocp_selector *tbl;
> +	u32 val;
> +
> +	if (bp->sma[sma_nr].mode == SMA_MODE_IN)
> +		tbl = bp->sma_op->tbl[0];
> +	else
> +		tbl = bp->sma_op->tbl[1];
> +
> +	val = ptp_ocp_sma_get(bp, sma_nr);
> +	return tbl[val].dpll_type;
> +}
> +
> +static int ptp_ocp_dpll_type_supported(struct dpll_device *dpll, int sma, int type, int dir)
> +{
> +	struct ptp_ocp *bp = (struct ptp_ocp *)dpll_priv(dpll);
> +	struct ocp_selector *tbl = bp->sma_op->tbl[dir];
> +	int i;
> +
> +	for (i = 0; i < sizeof(*tbl); i++) {
> +		if (tbl[i].dpll_type == type)
> +			return 1;
> +	}
> +	return 0;
> +}
> +
> +static int ptp_ocp_dpll_get_source_type(struct dpll_device *dpll, int sma)
> +{
> +	struct ptp_ocp *bp = (struct ptp_ocp *)dpll_priv(dpll);
> +
> +	if (bp->sma[sma].mode != SMA_MODE_IN)
> +		return -1;
> +
> +	return ptp_ocp_sma_get_dpll_type(bp, sma);
> +}
> +
> +static int ptp_ocp_dpll_get_source_supported(struct dpll_device *dpll, int sma, int type)
> +{
> +	return ptp_ocp_dpll_type_supported(dpll, sma, type, 0);
> +}
> +
> +static int ptp_ocp_dpll_get_output_type(struct dpll_device *dpll, int sma)
> +{
> +	struct ptp_ocp *bp = (struct ptp_ocp *)dpll_priv(dpll);
> +
> +	if (bp->sma[sma].mode != SMA_MODE_OUT)
> +		return -1;
> +
> +	return ptp_ocp_sma_get_dpll_type(bp, sma);
> +}
> +
> +static int ptp_ocp_dpll_get_output_supported(struct dpll_device *dpll, int sma, int type)
> +{
> +	return ptp_ocp_dpll_type_supported(dpll, sma, type, 1);
> +}
> +
> +static struct dpll_device_ops dpll_ops = {
> +	.get_status		= ptp_ocp_dpll_get_status,
> +	.get_lock_status	= ptp_ocp_dpll_get_lock_status,
> +	.get_source_type	= ptp_ocp_dpll_get_source_type,
> +	.get_source_supported	= ptp_ocp_dpll_get_source_supported,
> +	.get_output_type	= ptp_ocp_dpll_get_output_type,
> +	.get_output_supported	= ptp_ocp_dpll_get_output_supported,
> +};
> +
>  static int
>  ptp_ocp_probe(struct pci_dev *pdev, const struct pci_device_id *id)
>  {
> @@ -3768,6 +3855,14 @@ ptp_ocp_probe(struct pci_dev *pdev, const struct pci_device_id *id)
>  
>  	ptp_ocp_info(bp);
>  	devlink_register(devlink);
> +
> +	bp->dpll = dpll_device_alloc(&dpll_ops, ARRAY_SIZE(bp->sma), ARRAY_SIZE(bp->sma), bp);
> +	if (!bp->dpll) {
> +		dev_err(&pdev->dev, "dpll_device_alloc failed\n");
> +		return 0;
> +	}
> +	dpll_device_register(bp->dpll);
> +
>  	return 0;

80 cols, and this should be done before ptp_ocp_complete()
Also, should 'goto out', not return 0 and leak resources.


>  
>  out:
> @@ -3785,6 +3880,8 @@ ptp_ocp_remove(struct pci_dev *pdev)
>  	struct ptp_ocp *bp = pci_get_drvdata(pdev);
>  	struct devlink *devlink = priv_to_devlink(bp);
>  
> +	dpll_device_unregister(bp->dpll);
> +	dpll_device_free(bp->dpll);
>  	devlink_unregister(devlink);
>  	ptp_ocp_detach(bp);
>  	pci_disable_device(pdev);

This should be in ptp_ocp_detach() to handle probe failures.


> diff --git a/include/uapi/linux/dpll.h b/include/uapi/linux/dpll.h
> index 7ce45c6b4fd4..5e8c46712d18 100644
> --- a/include/uapi/linux/dpll.h
> +++ b/include/uapi/linux/dpll.h
> @@ -41,11 +41,13 @@ enum dpll_genl_attr {
>  
>  /* DPLL signal types used as source or as output */
>  enum dpll_genl_signal_type {
> +	DPLL_TYPE_NONE,
>  	DPLL_TYPE_EXT_1PPS,
>  	DPLL_TYPE_EXT_10MHZ,
>  	DPLL_TYPE_SYNCE_ETH_PORT,
>  	DPLL_TYPE_INT_OSCILLATOR,
>  	DPLL_TYPE_GNSS,
> +	DPLL_TYPE_CUSTOM,
>  
>  	__DPLL_TYPE_MAX,
>  };
> -- 
> 2.27.0
> 
