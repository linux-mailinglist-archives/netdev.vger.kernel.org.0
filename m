Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AE8F633CFA
	for <lists+netdev@lfdr.de>; Tue,  4 Jun 2019 04:05:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726223AbfFDCFG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Jun 2019 22:05:06 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:52782 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725876AbfFDCFG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 3 Jun 2019 22:05:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=0C5/9hNsFJy85Op9+MDkg+R/CtXricvNhx0APekNuHg=; b=XJPZtOpUuVqzZ93m0HGJPaJ/j7
        c3kbSwLAcq9RJcettKu+EDe9kWp1lT9j6uQs4zklikZWKP6mObXQQlXe9xvRw8omVlFWm9LSBp17f
        o4KprfOg02hWGmjs0QiYQe9ZiW6MFWrMC81ht1jZ6Yfg8Cf/xkRgNxzZpWziGilJReMY=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hXyox-0001OS-EC; Tue, 04 Jun 2019 04:05:03 +0200
Date:   Tue, 4 Jun 2019 04:05:03 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Robert Hancock <hancock@sedsystems.ca>
Cc:     netdev@vger.kernel.org, anirudh@xilinx.com, John.Linn@xilinx.com
Subject: Re: [PATCH net-next 01/18] net: axienet: Fix casting of pointers to
 u32
Message-ID: <20190604020503.GH17267@lunn.ch>
References: <1559599037-8514-1-git-send-email-hancock@sedsystems.ca>
 <1559599037-8514-2-git-send-email-hancock@sedsystems.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1559599037-8514-2-git-send-email-hancock@sedsystems.ca>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 03, 2019 at 03:57:00PM -0600, Robert Hancock wrote:
> This driver was casting skb pointers to u32 and storing them as such in
> the DMA buffer descriptor, which is obviously broken on 64-bit. The area
> of the buffer descriptor being used is not accessed by the hardware and
> has sufficient room for a 32 or 64-bit pointer, so just store the skb
> pointer as such.
> 
> Signed-off-by: Robert Hancock <hancock@sedsystems.ca>
> ---
>  drivers/net/ethernet/xilinx/xilinx_axienet.h      | 11 +++-------
>  drivers/net/ethernet/xilinx/xilinx_axienet_main.c | 26 ++++++++++++-----------
>  2 files changed, 17 insertions(+), 20 deletions(-)
> 
> diff --git a/drivers/net/ethernet/xilinx/xilinx_axienet.h b/drivers/net/ethernet/xilinx/xilinx_axienet.h
> index 011adae..e09dc14 100644
> --- a/drivers/net/ethernet/xilinx/xilinx_axienet.h
> +++ b/drivers/net/ethernet/xilinx/xilinx_axienet.h
> @@ -356,9 +356,6 @@
>   * @app2:         MM2S/S2MM User Application Field 2.
>   * @app3:         MM2S/S2MM User Application Field 3.
>   * @app4:         MM2S/S2MM User Application Field 4.
> - * @sw_id_offset: MM2S/S2MM Sw ID
> - * @reserved5:    Reserved and not used
> - * @reserved6:    Reserved and not used
>   */
>  struct axidma_bd {
>  	u32 next;	/* Physical address of next buffer descriptor */
> @@ -373,11 +370,9 @@ struct axidma_bd {
>  	u32 app1;	/* TX start << 16 | insert */
>  	u32 app2;	/* TX csum seed */
>  	u32 app3;
> -	u32 app4;
> -	u32 sw_id_offset;
> -	u32 reserved5;
> -	u32 reserved6;
> -};
> +	u32 app4;   /* Last field used by HW */
> +	struct sk_buff *skb;
> +} __aligned(XAXIDMA_BD_MINIMUM_ALIGNMENT);

Hi Robert

Is the memory for the descriptor non-cachable? I expect so.  You may
get slightly better performance if you were to keep an shadow array in
normal RAM. But this is O.K. as well.

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
