Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0968652B00D
	for <lists+netdev@lfdr.de>; Wed, 18 May 2022 03:44:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233779AbiERBoj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 May 2022 21:44:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233725AbiERBoj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 May 2022 21:44:39 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39FB95469D;
        Tue, 17 May 2022 18:44:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F1581B81DEF;
        Wed, 18 May 2022 01:44:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70FC5C385B8;
        Wed, 18 May 2022 01:44:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652838275;
        bh=jw9WY5TGpI68KaNjv0zfL25huNIRIdW/P8Q6Phay5WY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=bwbAFNG6xWVALg36Hiu/dCS79vtJ58HL/feVRzcheNQxr0TEnRxrY4LTkxR7ZvgXy
         avQUnmmtrAYBOg0rHUWidg0oF8/GX4sZG0g5wXIV3ap15nG0W8JSgVKISuARYcoZ6x
         Yv9cCmoyJQ8XY9mnTqm31Bhvo7v618hXtIxeA2njxKGFLjS5E+VhsoPHjUd92+V6GE
         M6WClZNtNMxr6v3CBrVDRfZjAc271LL+vmLyzt3zvRUFpY9chkIg4tU8MwCoaAPq/B
         WzXv4RyyHz94Aa3FT8O0FCq708qOutTIuWeP0HcIZSbCp90KilK3kcJIA9+mGCU2Ns
         Xd5mWhI8Kp81Q==
Date:   Tue, 17 May 2022 18:44:33 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     netdev@vger.kernel.org, nbd@nbd.name, john@phrozen.org,
        sean.wang@mediatek.com, Mark-MC.Lee@mediatek.com,
        davem@davemloft.net, edumazet@google.com, pabeni@redhat.com,
        Sam.Shih@mediatek.com, linux-mediatek@lists.infradead.org,
        devicetree@vger.kernel.org, robh@kernel.org,
        lorenzo.bianconi@redhat.com
Subject: Re: [PATCH v2 net-next 12/15] net: ethernet: mtk_eth_soc: introduce
 MTK_NETSYS_V2 support
Message-ID: <20220517184433.3cb2fd5a@kernel.org>
In-Reply-To: <cc1bd411e3028e2d6b0365ed5d29f3cea66223f8.1652716741.git.lorenzo@kernel.org>
References: <cover.1652716741.git.lorenzo@kernel.org>
        <cc1bd411e3028e2d6b0365ed5d29f3cea66223f8.1652716741.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 16 May 2022 18:06:39 +0200 Lorenzo Bianconi wrote:
> +	struct mtk_mac *mac = netdev_priv(dev);
> +	struct mtk_tx_dma_v2 *desc = txd;
> +	struct mtk_eth *eth = mac->hw;
> +	u32 data;
> +
> +	WRITE_ONCE(desc->txd1, info->addr);
> +
> +	data = TX_DMA_PLEN0(info->size);
> +	if (info->last)
> +		data |= TX_DMA_LS0;
> +	WRITE_ONCE(desc->txd3, data);
> +
> +	if (!info->qid && mac->id)
> +		info->qid = MTK_QDMA_GMAC2_QID;
> +
> +	data = (mac->id + 1) << TX_DMA_FPORT_SHIFT_V2; /* forward port */
> +	data |= TX_DMA_SWC_V2 | QID_BITS_V2(info->qid);
> +	WRITE_ONCE(desc->txd4, data);
> +
> +	data = 0;
> +	if (info->first) {
> +		if (info->gso)
> +			data |= TX_DMA_TSO_V2;
> +		/* tx checksum offload */
> +		if (info->csum)
> +			data |= TX_DMA_CHKSUM_V2;
> +	}
> +	WRITE_ONCE(desc->txd5, data);
> +
> +	data = 0;
> +	if (info->first && info->vlan)
> +		data |= TX_DMA_INS_VLAN_V2 | info->vlan_tci;
> +	WRITE_ONCE(desc->txd6, data);
> +
> +	WRITE_ONCE(desc->txd7, 0);
> +	WRITE_ONCE(desc->txd8, 0);

Why all the WRITE_ONCE()? Don't you just need a barrier between writing
the descriptor and kicking the HW? 
