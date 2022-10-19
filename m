Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 07103605429
	for <lists+netdev@lfdr.de>; Thu, 20 Oct 2022 01:43:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230081AbiJSXn4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Oct 2022 19:43:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229630AbiJSXnv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Oct 2022 19:43:51 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 245D3157F59;
        Wed, 19 Oct 2022 16:43:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 19346B82639;
        Wed, 19 Oct 2022 23:43:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60BFEC433C1;
        Wed, 19 Oct 2022 23:43:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666223025;
        bh=SkLLkcU5TOFI2QjJPz7/UivzW23oiY6PsaSXHNNVu3M=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=InHDNrPnMkFob4mpq5C6539OmORNNVC7wBXoXxKdnXLwi1LR4tzNBQEu4c8Z+EQ62
         o8Du9O3vRs8qfvKQ47F2/TSXqCNCGyjPA+ACsBiPgrS5ojxiya3HjvAUds3wkyAtnR
         1Lp30P3VN8keUlmBEL4+0yXwTUraS41QD6KC8tY7mL/xtjtLVziNk2x2AWSiKyd2dL
         G2UQSqb5owTumHZXrl3p0iJbbbkmJFCb1iyVeTETN5Z8d7O7/q8RtIpfs8RNSSoHov
         5ozpr0eF6vBJbxeJUqFi3j9hU5D8oHhdO7wt3U435w4mxJ2Zh66d2BlOpGayaRawJG
         JzRvSN0xpnKYA==
Date:   Wed, 19 Oct 2022 16:43:44 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Raju Lakkaraju <Raju.Lakkaraju@microchip.com>
Cc:     <netdev@vger.kernel.org>, <davem@davemloft.net>,
        <linux-kernel@vger.kernel.org>, <Bryan.Whitehead@microchip.com>,
        <edumazet@google.com>, <pabeni@redhat.com>,
        <UNGLinuxDriver@microchip.com>
Subject: Re: [PATCH net-next V4] net: lan743x: Add support to SGMII register
 dump for PCI11010/PCI11414 chips
Message-ID: <20221019164344.52cf16dd@kernel.org>
In-Reply-To: <20221018061425.3400-1-Raju.Lakkaraju@microchip.com>
References: <20221018061425.3400-1-Raju.Lakkaraju@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 18 Oct 2022 11:44:25 +0530 Raju Lakkaraju wrote:
> Add support to SGMII register dump

> +++ b/drivers/net/ethernet/microchip/lan743x_ethtool.c
> @@ -24,6 +24,9 @@
>  #define LOCK_TIMEOUT_MAX_CNT		    (100) // 1 sec (10 msce * 100)
>  
>  #define LAN743X_CSR_READ_OP(offset)	     lan743x_csr_read(adapter, offset)
> +#define VSPEC1			MDIO_MMD_VEND1
> +#define VSPEC2			MDIO_MMD_VEND2
> +#define SGMII_RD(adp, dev, adr) lan743x_sgmii_dump_read(adp, dev, adr)

These defines help limit the line length?
Please don't obfuscate code like that, see below.

> +static void lan743x_sgmii_regs(struct net_device *dev, void *p)
> +{
> +	struct lan743x_adapter *adp = netdev_priv(dev);
> +	u32 *rb = p;
> +
> +	rb[ETH_SR_VSMMD_DEV_ID1]                = SGMII_RD(adp, VSPEC1, 0x0002);
> +	rb[ETH_SR_VSMMD_DEV_ID2]                = SGMII_RD(adp, VSPEC1, 0x0003);
> +	rb[ETH_SR_VSMMD_PCS_ID1]                = SGMII_RD(adp, VSPEC1, 0x0004);
> +	rb[ETH_SR_VSMMD_PCS_ID2]                = SGMII_RD(adp, VSPEC1, 0x0005);
> +	rb[ETH_SR_VSMMD_STS]                    = SGMII_RD(adp, VSPEC1, 0x0008);
> +	rb[ETH_SR_VSMMD_CTRL]                   = SGMII_RD(adp, VSPEC1, 0x0009);
> +	rb[ETH_SR_MII_CTRL]                     = SGMII_RD(adp, VSPEC2, 0x0000);
> +	rb[ETH_SR_MII_STS]                      = SGMII_RD(adp, VSPEC2, 0x0001);
> +	rb[ETH_SR_MII_DEV_ID1]                  = SGMII_RD(adp, VSPEC2, 0x0002);
> +	rb[ETH_SR_MII_DEV_ID2]                  = SGMII_RD(adp, VSPEC2, 0x0003);
> +	rb[ETH_SR_MII_AN_ADV]                   = SGMII_RD(adp, VSPEC2, 0x0004);
> +	rb[ETH_SR_MII_LP_BABL]                  = SGMII_RD(adp, VSPEC2, 0x0005);
> +	rb[ETH_SR_MII_EXPN]                     = SGMII_RD(adp, VSPEC2, 0x0006);
> +	rb[ETH_SR_MII_EXT_STS]                  = SGMII_RD(adp, VSPEC2, 0x000F);
> +	rb[ETH_SR_MII_TIME_SYNC_ABL]            = SGMII_RD(adp, VSPEC2, 0x0708);
> +	rb[ETH_SR_MII_TIME_SYNC_TX_MAX_DLY_LWR] = SGMII_RD(adp, VSPEC2, 0x0709);

You can declare a structure holding the params and save the info there:

	struct {
		u8 id;
		u8 dev;
		u16 addr;
	} regs[] = {
		{ ETH_SR_MII_TIME_SYNC_TX_MAX_DLY_LWR,	MDIO_MMD_VEND2,	0x0709 },
	};

that should fit on the line.

You can then read the values in a loop. And inside that loop you can
handle errors (perhaps avoiding the need for lan743x_sgmii_dump_read()
which seems rather unnecessary as lan743x_sgmii_read() already prints 
errors).

FWIW I like Andrew's suggestion from v3 to use version as a bitfield, too.
