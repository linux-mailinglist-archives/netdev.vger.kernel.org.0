Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF5B120E9DA
	for <lists+netdev@lfdr.de>; Tue, 30 Jun 2020 02:03:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726748AbgF2X6O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jun 2020 19:58:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:55228 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726199AbgF2X6O (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 29 Jun 2020 19:58:14 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6F5522072A;
        Mon, 29 Jun 2020 23:58:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593475093;
        bh=UyPXpoZT2Rr6SjXVHNpWy8COAM7otg0a4YsB/5XTWAU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=J2nhnjiXvEt+fnSbPQSwV/eCLkA4tl3ooLuDhLyxFINpyxfg7va9kVi9vXpIT4q1S
         9KmTuJzarIs7AZYVM9ote4zTCbu1qvX+kg9sUX01YZ7asyAxHX2MzkDG8zkik2dpF+
         asQBbEMfmMbGs5VmWDGDTRmbDAlLqLAYCG++BQKE=
Date:   Mon, 29 Jun 2020 16:58:11 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Michael Chan <michael.chan@broadcom.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: Re: [PATCH net-next 4/8] bnxt_en: Fill HW RSS table from the RSS
 logical indirection table.
Message-ID: <20200629165811.4ae9e0f3@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <1593412464-503-5-git-send-email-michael.chan@broadcom.com>
References: <1593412464-503-1-git-send-email-michael.chan@broadcom.com>
        <1593412464-503-5-git-send-email-michael.chan@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 29 Jun 2020 02:34:20 -0400 Michael Chan wrote:
> Now that we have the logical table, we can fill the HW RSS table
> using the logical table's entries and converting them to the HW
> specific format.  Re-initialize the logical table to standard
> distribution if the number of RX rings changes during ring reservation.
> 
> Signed-off-by: Michael Chan <michael.chan@broadcom.com>
> ---
>  drivers/net/ethernet/broadcom/bnxt/bnxt.c | 89 ++++++++++++++++++-------------
>  1 file changed, 53 insertions(+), 36 deletions(-)
> 
> diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
> index 7bf843d..87d37dc 100644
> --- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
> +++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
> @@ -4882,9 +4882,52 @@ int bnxt_get_nr_rss_ctxs(struct bnxt *bp, int rx_rings)
>  	return 1;
>  }
>  
> +static void __bnxt_fill_hw_rss_tbl(struct bnxt *bp, struct bnxt_vnic_info *vnic)
> +{
> +	bool no_rss = !(vnic->flags & BNXT_VNIC_RSS_FLAG);
> +	u16 i, j;
> +
> +	/* Fill the RSS indirection table with ring group ids */
> +	for (i = 0, j = 0; i < HW_HASH_INDEX_SIZE; i++) {
> +		if (!no_rss)
> +			j = bp->rss_indir_tbl[i];
> +		vnic->rss_table[i] = cpu_to_le16(vnic->fw_grp_ids[j]);
> +	}
> +}
> +
> +static void __bnxt_fill_hw_rss_tbl_p5(struct bnxt *bp,
> +				      struct bnxt_vnic_info *vnic)
> +{
> +	__le16 *ring_tbl = vnic->rss_table;
> +	struct bnxt_rx_ring_info *rxr;
> +	u16 tbl_size, i;
> +
> +	tbl_size = (bp->rx_nr_rings + BNXT_RSS_TABLE_ENTRIES_P5 - 1) &
> +		   ~(BNXT_RSS_TABLE_ENTRIES_P5 - 1);

nit: DIV_ROUND_UP() ?

> +	for (i = 0; i < tbl_size; i++) {
> +		u16 ring_id, j;
> +
> +		j = bp->rss_indir_tbl[i];
> +		rxr = &bp->rx_ring[j];
> +
> +		ring_id = rxr->rx_ring_struct.fw_ring_id;
> +		*ring_tbl++ = cpu_to_le16(ring_id);
> +		ring_id = bnxt_cp_ring_for_rx(bp, rxr);
> +		*ring_tbl++ = cpu_to_le16(ring_id);
> +	}
> +}
> +

> @@ -8252,6 +8267,8 @@ int bnxt_reserve_rings(struct bnxt *bp, bool irq_re_init)
>  			rc = bnxt_init_int_mode(bp);
>  		bnxt_ulp_irq_restart(bp, rc);
>  	}

if (!netif_is_rxfh_configured(nn->dp.netdev))

> +	bnxt_set_dflt_rss_indir_tbl(bp);
> +
>  	if (rc) {
>  		netdev_err(bp->dev, "ring reservation/IRQ init failure rc: %d\n", rc);
>  		return rc;

