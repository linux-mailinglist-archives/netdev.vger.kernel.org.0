Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA59A297A41
	for <lists+netdev@lfdr.de>; Sat, 24 Oct 2020 03:59:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1755274AbgJXB6q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Oct 2020 21:58:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:55704 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755242AbgJXB6q (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 23 Oct 2020 21:58:46 -0400
Received: from kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net (unknown [163.114.132.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2F59020735;
        Sat, 24 Oct 2020 01:58:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603504725;
        bh=YglXHnfN9jr4/5LSr7ZogleEudtq+0uHYIcbL8YUZnc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=LtXA1sG/YqAFHOvDQPbZgCAeFzvOZ2p2lYwwjbPN8YplAnPSRCwMfqjJVI1rioneO
         d3iIAVQVrpupoz7pZUv0F/Go1NOzdJCEbsxS+zKUBPdl7cCYalgARJcq69enbWmIRm
         KmKe3w857BW3YsAWFlnNMHDnH0BZUoqIjlhy1Flg=
Date:   Fri, 23 Oct 2020 18:58:44 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Rohit Maheshwari <rohitm@chelsio.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, secdev@chelsio.com
Subject: Re: [net v2 2/7] ch_ktls: Correction in finding correct length
Message-ID: <20201023185844.1f586d84@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20201023053134.26021-3-rohitm@chelsio.com>
References: <20201023053134.26021-1-rohitm@chelsio.com>
        <20201023053134.26021-3-rohitm@chelsio.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 23 Oct 2020 11:01:29 +0530 Rohit Maheshwari wrote:
> There is a possibility of linear skbs coming in. Correcting
> the length extraction logic.
> 
> Fixes: 5a4b9fe7fece ("cxgb4/chcr: complete record tx handling")
> Signed-off-by: Rohit Maheshwari <rohitm@chelsio.com>

> @@ -980,6 +979,10 @@ chcr_ktls_write_tcp_options(struct chcr_ktls_info *tx_info, struct sk_buff *skb,
>  		return NETDEV_TX_BUSY;
>  	}
>  
> +	if (unlikely(credits < ETHTXQ_STOP_THRES)) {
> +		chcr_eth_txq_stop(q);
> +		wr_mid |= FW_WR_EQUEQ_F | FW_WR_EQUIQ_F;
> +	}
>  	pos = &q->q.desc[q->q.pidx];
>  	wr = pos;
>  
> @@ -987,42 +990,51 @@ chcr_ktls_write_tcp_options(struct chcr_ktls_info *tx_info, struct sk_buff *skb,
>  	wr->op_immdlen = htonl(FW_WR_OP_V(FW_ETH_TX_PKT_WR) |
>  			       FW_WR_IMMDLEN_V(ctrl));
>  
> -	wr->equiq_to_len16 = htonl(FW_WR_LEN16_V(len16));
> +	wr->equiq_to_len16 = htonl(wr_mid | FW_WR_LEN16_V(len16));
>  	wr->r3 = 0;
>  
>  	cpl = (void *)(wr + 1);
>  
>  	/* CPL header */
> -	cpl->ctrl0 = htonl(TXPKT_OPCODE_V(CPL_TX_PKT) | TXPKT_INTF_V(tx_chan) |
> +	cpl->ctrl0 = htonl(TXPKT_OPCODE_V(CPL_TX_PKT) |
> +			   TXPKT_INTF_V(tx_info->tx_chan) |
>  			   TXPKT_PF_V(tx_info->adap->pf));
>  	cpl->pack = 0;
>  	cpl->len = htons(pktlen);
> -	/* checksum offload */
> -	cpl->ctrl1 = 0;
> -
> -	pos = cpl + 1;
>  
>  	memcpy(buf, skb->data, pktlen);
>  	if (tx_info->ip_family == AF_INET) {
>  		/* we need to correct ip header len */
>  		ip = (struct iphdr *)(buf + maclen);
>  		ip->tot_len = htons(pktlen - maclen);
> +		cntrl1 = TXPKT_CSUM_TYPE_V(TX_CSUM_TCPIP);
>  #if IS_ENABLED(CONFIG_IPV6)
>  	} else {
>  		ip6 = (struct ipv6hdr *)(buf + maclen);
>  		ip6->payload_len = htons(pktlen - maclen - iplen);
> +		cntrl1 = TXPKT_CSUM_TYPE_V(TX_CSUM_TCPIP6);
>  #endif
>  	}
> +
> +	cntrl1 |= T6_TXPKT_ETHHDR_LEN_V(maclen - ETH_HLEN) |
> +		  TXPKT_IPHDR_LEN_V(iplen);
> +	/* checksum offload */
> +	cpl->ctrl1 = cpu_to_be64(cntrl1);
> +
> +	pos = cpl + 1;
> +
>  	/* now take care of the tcp header, if fin is not set then clear push
>  	 * bit as well, and if fin is set, it will be sent at the last so we
>  	 * need to update the tcp sequence number as per the last packet.
>  	 */
>  	tcp = (struct tcphdr *)(buf + maclen + iplen);
>  
> -	if (!tcp->fin)
> +	if (!fin) {
>  		tcp->psh = 0;
> -	else
> +		tcp->fin = 0;
> +	} else {
>  		tcp->seq = htonl(tx_info->prev_seq);
> +	}
>  
>  	chcr_copy_to_txd(buf, &q->q, pos, pktlen);
>  

> @@ -1905,8 +1920,7 @@ static int chcr_ktls_xmit(struct sk_buff *skb, struct net_device *dev)
>  	cxgb4_reclaim_completed_tx(adap, &q->q, true);
>  	/* if tcp options are set but finish is not send the options first */
>  	if (!th->fin && chcr_ktls_check_tcp_options(th)) {
> -		ret = chcr_ktls_write_tcp_options(tx_info, skb, q,
> -						  tx_info->tx_chan);
> +		ret = chcr_ktls_write_tcp_options(tx_info, skb, q, false);
>  		if (ret)
>  			return NETDEV_TX_BUSY;
>  	}

>  	/* tcp finish is set, send a separate tcp msg including all the options
>  	 * as well.
>  	 */
>  	if (th->fin)
> -		chcr_ktls_write_tcp_options(tx_info, skb, q, tx_info->tx_chan);
> +		chcr_ktls_write_tcp_options(tx_info, skb, q, true);
>  
>  out:
>  	dev_kfree_skb_any(skb);

I don't see how these changes related to a linear skb.
