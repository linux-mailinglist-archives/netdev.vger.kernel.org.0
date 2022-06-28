Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9240155EDAB
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 21:11:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233263AbiF1TLj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jun 2022 15:11:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235377AbiF1TLa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jun 2022 15:11:30 -0400
Received: from smtp2.emailarray.com (smtp.emailarray.com [69.28.212.198])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DEE4F25584
        for <netdev@vger.kernel.org>; Tue, 28 Jun 2022 12:11:28 -0700 (PDT)
Received: (qmail 85275 invoked by uid 89); 28 Jun 2022 19:11:26 -0000
Received: from unknown (HELO localhost) (amxlbW9uQGZsdWdzdmFtcC5jb21AMTYzLjExNC4xMzIuNQ==) (POLARISLOCAL)  
  by smtp2.emailarray.com with SMTP; 28 Jun 2022 19:11:26 -0000
Date:   Tue, 28 Jun 2022 12:11:24 -0700
From:   Jonathan Lemon <jonathan.lemon@gmail.com>
To:     Vadim Fedorenko <vfedorenko@novek.ru>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>,
        Vadim Fedorenko <vadfed@fb.com>, Aya Levin <ayal@nvidia.com>,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-clk@vger.kernel.org
Subject: Re: [RFC PATCH v2 3/3] ptp_ocp: implement DPLL ops
Message-ID: <20220628191124.qvto5tyfe63htxxr@bsd-mbp.dhcp.thefacebook.com>
References: <20220626192444.29321-1-vfedorenko@novek.ru>
 <20220626192444.29321-4-vfedorenko@novek.ru>
 <20220627193436.3wjunjqqtx7dtqm6@bsd-mbp.dhcp.thefacebook.com>
 <7c2fa2e9-6353-5472-75c8-b3ffe403f0f3@novek.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7c2fa2e9-6353-5472-75c8-b3ffe403f0f3@novek.ru>
X-Spam-Status: No, score=0.7 required=5.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
        FORGED_GMAIL_RCVD,FREEMAIL_FROM,KHOP_HELO_FCRDNS,NML_ADSP_CUSTOM_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_SOFTFAIL,T_SCC_BODY_TEXT_LINE,
        UNPARSEABLE_RELAY autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 27, 2022 at 11:13:22PM +0100, Vadim Fedorenko wrote:
> On 27.06.2022 20:34, Jonathan Lemon wrote:
> > On Sun, Jun 26, 2022 at 10:24:44PM +0300, Vadim Fedorenko wrote:
> > > From: Vadim Fedorenko <vadfed@fb.com>
> > > 
> > > Implement DPLL operations in ptp_ocp driver.
> > > 
> > > Signed-off-by: Vadim Fedorenko <vadfed@fb.com>
> > > ---
> > >   drivers/ptp/Kconfig       |   1 +
> > >   drivers/ptp/ptp_ocp.c     | 169 ++++++++++++++++++++++++++++++--------
> > >   include/uapi/linux/dpll.h |   2 +
> > >   3 files changed, 136 insertions(+), 36 deletions(-)
> > > 
> > > diff --git a/drivers/ptp/Kconfig b/drivers/ptp/Kconfig
> > > index 458218f88c5e..f74846ebc177 100644
> > > --- a/drivers/ptp/Kconfig
> > > +++ b/drivers/ptp/Kconfig
> > > @@ -176,6 +176,7 @@ config PTP_1588_CLOCK_OCP
> > >   	depends on !S390
> > >   	depends on COMMON_CLK
> > >   	select NET_DEVLINK
> > > +	select DPLL
> > >   	help
> > >   	  This driver adds support for an OpenCompute time card.
> > > diff --git a/drivers/ptp/ptp_ocp.c b/drivers/ptp/ptp_ocp.c
> > > index e59ea2173aac..f830625a63a3 100644
> > > --- a/drivers/ptp/ptp_ocp.c
> > > +++ b/drivers/ptp/ptp_ocp.c
> > > @@ -21,6 +21,7 @@
> > >   #include <linux/mtd/mtd.h>
> > >   #include <linux/nvmem-consumer.h>
> > >   #include <linux/crc16.h>
> > > +#include <uapi/linux/dpll.h>
> > >   #define PCI_VENDOR_ID_FACEBOOK			0x1d9b
> > >   #define PCI_DEVICE_ID_FACEBOOK_TIMECARD		0x0400
> > > @@ -336,6 +337,7 @@ struct ptp_ocp {
> > >   	struct ptp_ocp_signal	signal[4];
> > >   	struct ptp_ocp_sma_connector sma[4];
> > >   	const struct ocp_sma_op *sma_op;
> > > +	struct dpll_device *dpll;
> > >   };
> > >   #define OCP_REQ_TIMESTAMP	BIT(0)
> > > @@ -660,18 +662,19 @@ static DEFINE_IDR(ptp_ocp_idr);
> > >   struct ocp_selector {
> > >   	const char *name;
> > >   	int value;
> > > +	int dpll_type;
> > >   };
> > >   static const struct ocp_selector ptp_ocp_clock[] = {
> > > -	{ .name = "NONE",	.value = 0 },
> > > -	{ .name = "TOD",	.value = 1 },
> > > -	{ .name = "IRIG",	.value = 2 },
> > > -	{ .name = "PPS",	.value = 3 },
> > > -	{ .name = "PTP",	.value = 4 },
> > > -	{ .name = "RTC",	.value = 5 },
> > > -	{ .name = "DCF",	.value = 6 },
> > > -	{ .name = "REGS",	.value = 0xfe },
> > > -	{ .name = "EXT",	.value = 0xff },
> > > +	{ .name = "NONE",	.value = 0,		.dpll_type = 0 },
> > > +	{ .name = "TOD",	.value = 1,		.dpll_type = 0 },
> > > +	{ .name = "IRIG",	.value = 2,		.dpll_type = 0 },
> > > +	{ .name = "PPS",	.value = 3,		.dpll_type = 0 },
> > > +	{ .name = "PTP",	.value = 4,		.dpll_type = 0 },
> > > +	{ .name = "RTC",	.value = 5,		.dpll_type = 0 },
> > > +	{ .name = "DCF",	.value = 6,		.dpll_type = 0 },
> > > +	{ .name = "REGS",	.value = 0xfe,		.dpll_type = 0 },
> > > +	{ .name = "EXT",	.value = 0xff,		.dpll_type = 0 },
> > 
> > No need for zeros, or are they just temp stubs?
> 
> These are just temp stubs for now.
> 
> > 
> > > @@ -680,37 +683,37 @@ static const struct ocp_selector ptp_ocp_clock[] = {
> > >   #define SMA_SELECT_MASK		GENMASK(14, 0)
> > >   static const struct ocp_selector ptp_ocp_sma_in[] = {
> > > -	{ .name = "10Mhz",	.value = 0x0000 },
> > > -	{ .name = "PPS1",	.value = 0x0001 },
> > > -	{ .name = "PPS2",	.value = 0x0002 },
> > > -	{ .name = "TS1",	.value = 0x0004 },
> > > -	{ .name = "TS2",	.value = 0x0008 },
> > > -	{ .name = "IRIG",	.value = 0x0010 },
> > > -	{ .name = "DCF",	.value = 0x0020 },
> > > -	{ .name = "TS3",	.value = 0x0040 },
> > > -	{ .name = "TS4",	.value = 0x0080 },
> > > -	{ .name = "FREQ1",	.value = 0x0100 },
> > > -	{ .name = "FREQ2",	.value = 0x0200 },
> > > -	{ .name = "FREQ3",	.value = 0x0400 },
> > > -	{ .name = "FREQ4",	.value = 0x0800 },
> > > -	{ .name = "None",	.value = SMA_DISABLE },
> > > +	{ .name = "10Mhz",	.value = 0x0000,	.dpll_type = DPLL_TYPE_EXT_10MHZ },
> > > +	{ .name = "PPS1",	.value = 0x0001,	.dpll_type = DPLL_TYPE_EXT_1PPS },
> > > +	{ .name = "PPS2",	.value = 0x0002,	.dpll_type = DPLL_TYPE_EXT_1PPS },
> > > +	{ .name = "TS1",	.value = 0x0004,	.dpll_type = DPLL_TYPE_CUSTOM },
> > > +	{ .name = "TS2",	.value = 0x0008,	.dpll_type = DPLL_TYPE_CUSTOM },
> > > +	{ .name = "IRIG",	.value = 0x0010,	.dpll_type = DPLL_TYPE_CUSTOM },
> > > +	{ .name = "DCF",	.value = 0x0020,	.dpll_type = DPLL_TYPE_CUSTOM },
> > > +	{ .name = "TS3",	.value = 0x0040,	.dpll_type = DPLL_TYPE_CUSTOM },
> > > +	{ .name = "TS4",	.value = 0x0080,	.dpll_type = DPLL_TYPE_CUSTOM },
> > > +	{ .name = "FREQ1",	.value = 0x0100,	.dpll_type = DPLL_TYPE_CUSTOM },
> > > +	{ .name = "FREQ2",	.value = 0x0200,	.dpll_type = DPLL_TYPE_CUSTOM },
> > > +	{ .name = "FREQ3",	.value = 0x0400,	.dpll_type = DPLL_TYPE_CUSTOM },
> > > +	{ .name = "FREQ4",	.value = 0x0800,	.dpll_type = DPLL_TYPE_CUSTOM },
> > > +	{ .name = "None",	.value = SMA_DISABLE,	.dpll_type = DPLL_TYPE_NONE },
> > 
> > 80-column limit (here and throughout the file)
> 
> I thought this rule was relaxed up to 100-columns?

Only in exceptional cases, IIRC.  checkpatch complains too.


> > >   static int
> > >   ptp_ocp_probe(struct pci_dev *pdev, const struct pci_device_id *id)
> > >   {
> > > @@ -3768,6 +3855,14 @@ ptp_ocp_probe(struct pci_dev *pdev, const struct pci_device_id *id)
> > >   	ptp_ocp_info(bp);
> > >   	devlink_register(devlink);
> > > +
> > > +	bp->dpll = dpll_device_alloc(&dpll_ops, ARRAY_SIZE(bp->sma), ARRAY_SIZE(bp->sma), bp);
> > > +	if (!bp->dpll) {
> > > +		dev_err(&pdev->dev, "dpll_device_alloc failed\n");
> > > +		return 0;
> > > +	}
> > > +	dpll_device_register(bp->dpll);
> > > +
> > >   	return 0;
> > 
> > 80 cols, and this should be done before ptp_ocp_complete()
> > Also, should 'goto out', not return 0 and leak resources.
> 
> I don't think we have to go with error path. Driver itself can work without
> DPLL device registered, there is no hard dependency. The DPLL device will
> not be registered and HW could not be configured/monitored via netlink, but
> could still be usable.

Not sure I agree with that - the DPLL device is selected in Kconfig, so
users would expect to have it present.  I think it makes more sense to
fail if it cannot be allocated.
-- 
Jonathan
