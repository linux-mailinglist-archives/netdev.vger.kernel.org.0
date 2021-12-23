Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0CBD747DC6C
	for <lists+netdev@lfdr.de>; Thu, 23 Dec 2021 01:57:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238387AbhLWA5J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Dec 2021 19:57:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235367AbhLWA5J (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Dec 2021 19:57:09 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BE8BC061574
        for <netdev@vger.kernel.org>; Wed, 22 Dec 2021 16:57:09 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8B0CA61D23
        for <netdev@vger.kernel.org>; Thu, 23 Dec 2021 00:57:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3B7AC36AE8;
        Thu, 23 Dec 2021 00:57:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1640221027;
        bh=vTG9ZnsGMRzH8oZvJPuLB0V+2YSVILxTecBO+MYsPrk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=spqDlssSJlKbsfyjyA0SwISVNYMAFxkgUMs3DtDK/l/rIExKGcDtqm3zTxaiZYEoR
         wFtYBb4cvswXiNsgpKoAm4s7A4EUZFS+Sqkc0wv9mrEZLG8yfrZj7Izje4Djc7yxZQ
         QM7WIX++tQ4tcFRY33abZWZX1DPTDg0jElwg/rirU2NkgvmRgHflMyR/YA8f7n4YHc
         TQGAAu2KoZfHSAkKLjgc3/ytms6d6sdXr9JH1mTS2uXrJw3xoXeyXSstjylGcalcbP
         t1RG0ATmOW0AOZik8Mf16QN1jAxks7lCOry9bE2WdxNsfoJnWR7f+0qtGnPb3ljbqn
         mTorozgPTnGjw==
Date:   Wed, 22 Dec 2021 16:57:06 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     conleylee@foxmail.com
Cc:     davem@davemloft.net, mripard@kernel.org, wens@csie.org,
        netdev@vger.kernel.org, linux-sunxi@lists.linux.dev
Subject: Re: [PATCH] sun4i-emac.c: add dma support
Message-ID: <20211222165706.28089162@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <tencent_004AE1B7729BE20B02D8003D40DE850A9609@qq.com>
References: <tencent_004AE1B7729BE20B02D8003D40DE850A9609@qq.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 22 Dec 2021 15:09:27 +0800 conleylee@foxmail.com wrote:
> -#define DRV_NAME		"sun4i-emac"
> +#define DRV_NAME "sun4i-emac"
>  
> -#define EMAC_MAX_FRAME_LEN	0x0600
> +#define EMAC_MAX_FRAME_LEN 0x600
>  
>  #define EMAC_DEFAULT_MSG_ENABLE 0x0000
> -static int debug = -1;     /* defaults above */;
> +static int debug = -1; /* defaults above */
> +;
>  module_param(debug, int, 0);
>  MODULE_PARM_DESC(debug, "debug message flags");
>  
> @@ -69,24 +71,25 @@ MODULE_PARM_DESC(watchdog, "transmit timeout in milliseconds");
>   */
>  
>  struct emac_board_info {
> -	struct clk		*clk;
> -	struct device		*dev;
> -	struct platform_device	*pdev;
> -	spinlock_t		lock;
> -	void __iomem		*membase;
> -	u32			msg_enable;
> -	struct net_device	*ndev;
> -	struct sk_buff		*skb_last;
> -	u16			tx_fifo_stat;
> -
> -	int			emacrx_completed_flag;
> -
> -	struct device_node	*phy_node;
> -	unsigned int		link;
> -	unsigned int		speed;
> -	unsigned int		duplex;
> -
> -	phy_interface_t		phy_interface;
> +	struct clk *clk;
> +	struct device *dev;
> +	struct platform_device *pdev;
> +	spinlock_t lock;
> +	void __iomem *membase;
> +	u32 msg_enable;
> +	struct net_device *ndev;
> +	u16 tx_fifo_stat;
> +
> +	int emacrx_completed_flag;
> +
> +	struct device_node *phy_node;
> +	unsigned int link;
> +	unsigned int speed;
> +	unsigned int duplex;
> +
> +	phy_interface_t phy_interface;
> +	struct dma_chan *rx_chan;
> +	phys_addr_t emac_rx_fifo;

Please remove all the code formatting changes from the patch and repost.
It makes it hard to review the patch when most of it is an unrelated
whitespace modification.
