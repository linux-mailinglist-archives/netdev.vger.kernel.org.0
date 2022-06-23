Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A8DA9558899
	for <lists+netdev@lfdr.de>; Thu, 23 Jun 2022 21:22:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229902AbiFWTWo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jun 2022 15:22:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230280AbiFWTWV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jun 2022 15:22:21 -0400
Received: from smtp4.emailarray.com (smtp4.emailarray.com [65.39.216.22])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA10E3E5F7
        for <netdev@vger.kernel.org>; Thu, 23 Jun 2022 11:28:17 -0700 (PDT)
Received: (qmail 96020 invoked by uid 89); 23 Jun 2022 18:28:15 -0000
Received: from unknown (HELO localhost) (amxlbW9uQGZsdWdzdmFtcC5jb21AMTYzLjExNC4xMzIuNQ==) (POLARISLOCAL)  
  by smtp4.emailarray.com with SMTP; 23 Jun 2022 18:28:15 -0000
Date:   Thu, 23 Jun 2022 11:28:13 -0700
From:   Jonathan Lemon <jonathan.lemon@gmail.com>
To:     Vadim Fedorenko <vfedorenko@novek.ru>
Cc:     Jakub Kicinski <kuba@kernel.org>, Vadim Fedorenko <vadfed@fb.com>,
        Aya Levin <ayal@nvidia.com>,
        Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [RFC PATCH v1 3/3] ptp_ocp: implement DPLL ops
Message-ID: <20220623182813.safjhwvu67i4vu3b@bsd-mbp.dhcp.thefacebook.com>
References: <20220623005717.31040-1-vfedorenko@novek.ru>
 <20220623005717.31040-4-vfedorenko@novek.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220623005717.31040-4-vfedorenko@novek.ru>
X-Spam-Status: No, score=0.7 required=5.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
        FORGED_GMAIL_RCVD,FREEMAIL_FROM,NML_ADSP_CUSTOM_MED,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_SOFTFAIL,T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 23, 2022 at 03:57:17AM +0300, Vadim Fedorenko wrote:
> From: Vadim Fedorenko <vadfed@fb.com>
> 
> Implement DPLL operations in ptp_ocp driver.

Please CC: me as well.


> +static int ptp_ocp_dpll_get_status(struct dpll_device *dpll)
> +{
> +	struct ptp_ocp *bp = (struct ptp_ocp *)dpll_priv(dpll);
> +	int sync;
> +
> +	sync = ioread32(&bp->reg->status) & OCP_STATUS_IN_SYNC;
> +	return sync;
> +}

Please match existing code style.


> +static int ptp_ocp_dpll_get_source_type(struct dpll_device *dpll, int sma)
> +{
> +	struct ptp_ocp *bp = (struct ptp_ocp *)dpll_priv(dpll);
> +	int ret;
> +
> +	if (bp->sma[sma].mode != SMA_MODE_IN)
> +		return -1;
> +
> +	switch (ptp_ocp_sma_get(bp, sma)) {
> +	case 0:
> +		ret = DPLL_TYPE_EXT_10MHZ;
> +		break;
> +	case 1:
> +	case 2:
> +		ret = DPLL_TYPE_EXT_1PPS;
> +		break;
> +	default:
> +		ret = DPLL_TYPE_INT_OSCILLATOR;
> +	}
> +
> +	return ret;
> +}

These case statements switch on private bits.  This needs to match
on the selector name instead.


> +static int ptp_ocp_dpll_get_output_type(struct dpll_device *dpll, int sma)
> +{
> +	struct ptp_ocp *bp = (struct ptp_ocp *)dpll_priv(dpll);
> +	int ret;
> +
> +	if (bp->sma[sma].mode != SMA_MODE_OUT)
> +		return -1;
> +
> +	switch (ptp_ocp_sma_get(bp, sma)) {
> +	case 0:
> +		ret = DPLL_TYPE_EXT_10MHZ;
> +		break;
> +	case 1:
> +	case 2:
> +		ret = DPLL_TYPE_INT_OSCILLATOR;
> +		break;
> +	case 4:
> +	case 8:
> +		ret = DPLL_TYPE_GNSS;
> +		break;
> +	default:
> +		ret = DPLL_TYPE_INT_OSCILLATOR;

Missing break;


> +	}
> +
> +	return ret;
> +}
> +
> +static struct dpll_device_ops dpll_ops = {
> +	.get_status		= ptp_ocp_dpll_get_status,
> +	.get_lock_status	= ptp_ocp_dpll_get_lock_status,
> +	.get_source_type	= ptp_ocp_dpll_get_source_type,
> +	.get_output_type	= ptp_ocp_dpll_get_output_type,
> +};

No 'set' statements here?  Also, what happens if there is more than
one GNSS receiver, how is this differentiated?
>  static int
>  ptp_ocp_probe(struct pci_dev *pdev, const struct pci_device_id *id)
>  {
> @@ -3768,6 +3846,14 @@ ptp_ocp_probe(struct pci_dev *pdev, const struct pci_device_id *id)
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

How is the release/unregister path called when the module is unloaded?
-- 
Jonathan
