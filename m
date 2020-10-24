Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 446D9297A4A
	for <lists+netdev@lfdr.de>; Sat, 24 Oct 2020 04:05:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1758892AbgJXCFF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Oct 2020 22:05:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:35076 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1756403AbgJXCFE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 23 Oct 2020 22:05:04 -0400
Received: from kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net (unknown [163.114.132.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 24EB12168B;
        Sat, 24 Oct 2020 02:05:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603505104;
        bh=1SznU4v/2hoICYwAFkiPUmm9/CLDAp4rTDK4KY25p/I=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=0Na83PYnKHUB6rFU2jAB1rG+/SPtBWbBCGWuZBmPLnbXYsAAZiKEBGQFYfp/zYo+W
         ARYXczbxaBA0He9XzuGek85Uts6Z45kgeYzHIk+1xhob3ByYpX09hFeAiFR/7fZyf9
         wBc9hw/eO/rh69MjzZf0JEwHxNy0GmkvCgThprUg=
Date:   Fri, 23 Oct 2020 19:05:03 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Rohit Maheshwari <rohitm@chelsio.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, secdev@chelsio.com,
        Julia Lawall <julia.lawall@inria.fr>
Subject: Re: [net v2 3/7] cxgb4/ch_ktls: creating skbs causes panic
Message-ID: <20201023190503.44f61271@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20201023053134.26021-4-rohitm@chelsio.com>
References: <20201023053134.26021-1-rohitm@chelsio.com>
        <20201023053134.26021-4-rohitm@chelsio.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 23 Oct 2020 11:01:30 +0530 Rohit Maheshwari wrote:
> Creating SKB per tls record and freeing the original one causes
> panic. There will be race if connection reset is requested. By
> freeing original skb, refcnt will be decremented and that means,
> there is no pending record to send, and so tls_dev_del will be
> requested in control path while SKB of related connection is in
> queue.

Can't you make your new skbs take a reference on the socket, then?

> @@ -1672,42 +1572,60 @@ static int chcr_end_part_handler(struct chcr_ktls_info *tx_info,
>  				 struct tls_record_info *record,
>  				 u32 tcp_seq, int mss, bool tcp_push_no_fin,
>  				 struct sge_eth_txq *q,
> -				 u32 tls_end_offset, bool last_wr)
> +				 u32 tls_end_offset, u32 skb_offset)
>  {
>  	struct sk_buff *nskb = NULL;
> +	bool is_last_wr = false;
> +	int ret;
> +
> +	if (skb_offset + tls_end_offset == skb->len)
> +		is_last_wr = true;
> +
>  	/* check if it is a complete record */
>  	if (tls_end_offset == record->len) {
>  		nskb = skb;
>  		atomic64_inc(&tx_info->adap->ch_ktls_stats.ktls_tx_complete_pkts);
>  	} else {
> -		dev_kfree_skb_any(skb);
> -
> +		/* TAG needs to be calculated so, need to send complete record,
> +		 * free the original skb and send a new one.
> +		 */
>  		nskb = alloc_skb(0, GFP_KERNEL);
> -		if (!nskb)

Please add a patch that fixes the misuses of GFP_KERNEL as pointed out
by Julia. Make it a separate patch in this series, before this one.

