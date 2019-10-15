Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B310ED8048
	for <lists+netdev@lfdr.de>; Tue, 15 Oct 2019 21:29:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732298AbfJOT31 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Oct 2019 15:29:27 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:46912 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729122AbfJOT31 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 15 Oct 2019 15:29:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=71G3s/rUI0pnqWNwJf5MVFguS+1OAMt2sjhIMJHNNNo=; b=a5gdHa7gNXpkZDMt0yWHXSNpmU
        4XPU9qFPcsbhstN8wugkMvdhlO3N8Qh/r+nSTPRdRbXHItoZe9c3pFqhSuVp+0nSoRE+wcrRTxcd/
        i8hIl2ZbCMNisDVEVXOVP/kIBKnxqDHgOFwlW75vypeZvCzsAB9JNItX9NiO7ktIs/xM=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.92.2)
        (envelope-from <andrew@lunn.ch>)
        id 1iKSVX-0003bL-W8; Tue, 15 Oct 2019 21:29:23 +0200
Date:   Tue, 15 Oct 2019 21:29:23 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Ioana Ciornei <ioana.ciornei@nxp.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        Ioana Radulescu <ruxandra.radulescu@nxp.com>
Subject: Re: [PATCH v2 net 2/2] dpaa2-eth: Fix TX FQID values
Message-ID: <20191015192923.GC7839@lunn.ch>
References: <1571045117-26329-1-git-send-email-ioana.ciornei@nxp.com>
 <1571045117-26329-3-git-send-email-ioana.ciornei@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1571045117-26329-3-git-send-email-ioana.ciornei@nxp.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 14, 2019 at 12:25:17PM +0300, Ioana Ciornei wrote:
> From: Ioana Radulescu <ruxandra.radulescu@nxp.com>
> 
> Depending on when MC connects the DPNI to a MAC, Tx FQIDs may
> not be available during probe time.
> 
> Read the FQIDs each time the link goes up to avoid using invalid
> values. In case an error occurs or an invalid value is retrieved,
> fall back to QDID-based enqueueing.
> 
> Fixes: 1fa0f68c9255 ("dpaa2-eth: Use FQ-based DPIO enqueue API")
> Signed-off-by: Ioana Radulescu <ruxandra.radulescu@nxp.com>
> Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
> ---
> Changes in v2:
>  - used reverse christmas tree ordering in update_tx_fqids
> 
>  drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c | 42 ++++++++++++++++++++++++
>  1 file changed, 42 insertions(+)
> 
> diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
> index 5acd734a216b..c3c2c06195ae 100644
> --- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
> +++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
> @@ -1235,6 +1235,8 @@ static void dpaa2_eth_set_rx_taildrop(struct dpaa2_eth_priv *priv, bool enable)
>  	priv->rx_td_enabled = enable;
>  }
>  
> +static void update_tx_fqids(struct dpaa2_eth_priv *priv);
> +

Hi Ioana and Ioana

Using forward declarations is generally not liked. Is there something
which is preventing you from having it earlier in the file?

Thanks
	Andrew
