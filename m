Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D21E2D197C
	for <lists+netdev@lfdr.de>; Mon,  7 Dec 2020 20:32:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726292AbgLGT3P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Dec 2020 14:29:15 -0500
Received: from smtp-fw-9102.amazon.com ([207.171.184.29]:61893 "EHLO
        smtp-fw-9102.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725814AbgLGT3O (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Dec 2020 14:29:14 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1607369354; x=1638905354;
  h=references:from:to:cc:subject:in-reply-to:date:
   message-id:mime-version;
  bh=0Y1dm1HYkUvVJl3cJ/WHZ+bp4yLLS2dSUm6fd231PVk=;
  b=tzXd9L4FXGBjokF8WfOTjiZ3Vnhbty6sKArkMUHAJGQqSZInLKnIgQjB
   Hbriiqfvk+TC0RJwGrZxLel6EQiMdY8nXev44qd1bItQixfj6CovG/x9H
   72VptXjF0woVdoMsTWOeLeZKXbSAZ3XXWLlZnfGDPsMZl7OEWqaQgM4zU
   k=;
X-IronPort-AV: E=Sophos;i="5.78,400,1599523200"; 
   d="scan'208";a="102381052"
Received: from sea32-co-svc-lb4-vlan3.sea.corp.amazon.com (HELO email-inbound-relay-1e-303d0b0e.us-east-1.amazon.com) ([10.47.23.38])
  by smtp-border-fw-out-9102.sea19.amazon.com with ESMTP; 07 Dec 2020 19:28:27 +0000
Received: from EX13D28EUC001.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan3.iad.amazon.com [10.40.163.38])
        by email-inbound-relay-1e-303d0b0e.us-east-1.amazon.com (Postfix) with ESMTPS id 759D2A18C4;
        Mon,  7 Dec 2020 19:28:26 +0000 (UTC)
Received: from u68c7b5b1d2d758.ant.amazon.com.amazon.com (10.43.162.146) by
 EX13D28EUC001.ant.amazon.com (10.43.164.4) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Mon, 7 Dec 2020 19:28:17 +0000
References: <1607083875-32134-1-git-send-email-akiyano@amazon.com>
 <1607083875-32134-10-git-send-email-akiyano@amazon.com>
 <20201206202230.GD23696@ranger.igk.intel.com>
User-agent: mu4e 1.4.12; emacs 27.1
From:   Shay Agroskin <shayagr@amazon.com>
To:     Maciej Fijalkowski <maciej.fijalkowski@intel.com>
CC:     <akiyano@amazon.com>, <davem@davemloft.net>, <kuba@kernel.org>,
        <netdev@vger.kernel.org>, <dwmw@amazon.com>, <zorik@amazon.com>,
        <matua@amazon.com>, <saeedb@amazon.com>, <msw@amazon.com>,
        <aliguori@amazon.com>, <nafea@amazon.com>, <gtzalik@amazon.com>,
        <netanel@amazon.com>, <alisaidi@amazon.com>, <benh@amazon.com>,
        <ndagan@amazon.com>, <sameehj@amazon.com>
Subject: Re: [PATCH V4 net-next 9/9] net: ena: introduce ndo_xdp_xmit()
 function for XDP_REDIRECT
In-Reply-To: <20201206202230.GD23696@ranger.igk.intel.com>
Date:   Mon, 7 Dec 2020 21:28:04 +0200
Message-ID: <pj41zly2i9xvp7.fsf@u68c7b5b1d2d758.ant.amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; format=flowed
X-Originating-IP: [10.43.162.146]
X-ClientProxiedBy: EX13D02UWC001.ant.amazon.com (10.43.162.243) To
 EX13D28EUC001.ant.amazon.com (10.43.164.4)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Maciej Fijalkowski <maciej.fijalkowski@intel.com> writes:

> On Fri, Dec 04, 2020 at 02:11:15PM +0200, akiyano@amazon.com 
> wrote:
>> From: Arthur Kiyanovski <akiyano@amazon.com>
>> 
>> This patch implements the ndo_xdp_xmit() net_device function 
>> which is
>> called when a packet is redirected to this driver using an
>> XDP_REDIRECT directive.
>> 
>> The function receives an array of xdp frames that it needs to 
>> xmit.
>> The TX queues that are used to xmit these frames are the XDP
>> queues used by the XDP_TX flow. Therefore a lock is added to 
>> synchronize
>> both flows (XDP_TX and XDP_REDIRECT).
>> 
>> Signed-off-by: Shay Agroskin <shayagr@amazon.com>
>> Signed-off-by: Arthur Kiyanovski <akiyano@amazon.com>
>> ...
>> +	xdp_ring = &adapter->tx_ring[qid];
>> +
>> +	/* Other CPU ids might try to send thorugh this queue */
>> +	spin_lock(&xdp_ring->xdp_tx_lock);
>
> I have a feeling that we are not consistent with this locking 
> approach as
> some drivers do that and some don't.
>

Not sure what you mean here, ENA driver uses a lock for XDP xmit 
function because XDP_TX and XDP_REDIRECT flows share the same egress queues. This is a design choice that was 
taken. Some drivers (e.g. mlx5) seem to have separate queues for 
regular TX, XDP_TX, XDP_REDIRECT and RX flows, and saw are able to 
avoid locking.

>> +
>> +	for (i = 0; i < n; i++) {
>> +		err = ena_xdp_xmit_frame(xdp_ring, dev, frames[i], 
>> 0);
>> +		/* The descriptor is freed by ena_xdp_xmit_frame 
>> in case
>> +		 * of an error.
>> +		 */
>> +		if (err)
>> +			drops++;
>> +	}
>> +
>> +	/* Ring doorbell to make device aware of the packets */
>> +	if (flags & XDP_XMIT_FLUSH) {
>> + 
>> ena_com_write_sq_doorbell(xdp_ring->ena_com_io_sq);
>> +		ena_increase_stat(&xdp_ring->tx_stats.doorbells, 
>> 1,
>> +				  &xdp_ring->syncp);
>
> Have you thought of ringing the doorbell once per a batch of 
> xmitted
> frames?
>

For XDP_REDIRECT the packets are indeed batched before sending a 
doorbell. XDP_TX flow would be added the same improvement in 
future patchset.
Thanks for this idea (:

>> +	}
>> +
>> +	spin_unlock(&xdp_ring->xdp_tx_lock);
>> +
>> +	/* Return number of packets sent */
>> +	return n - drops;
>>  }
>> ...
>>  
>> -				   rx_ring->qid + 
>> rx_ring->adapter->num_io_queues);
>> +		/* Find xmit queue */
>> +		qid = rx_ring->qid + 
>> rx_ring->adapter->num_io_queues;
>> +		xdp_ring = &rx_ring->adapter->tx_ring[qid];
>> +
>> +		/* The XDP queues are shared between XDP_TX and 
>> XDP_REDIRECT */
>> +		spin_lock(&xdp_ring->xdp_tx_lock);
>> +
>> +		ena_xdp_xmit_frame(xdp_ring, rx_ring->netdev, 
>> xdpf, XDP_XMIT_FLUSH);
>
> Once again you don't check retval over here.
>

ena_xdp_xmit_frame() function handles failure internally (reducing 
the ref-count of the RX page, increasing error stat etc.) 
therefore there is no need for special handling of its failure.
For XDP Redirect flow ena_xdp_xmit() function returns the kernel 
the number of packets that were successfully sent, and so it needs 
to monitor the return value of this function.
This is not the case here though.

>> +
>> +		spin_unlock(&xdp_ring->xdp_tx_lock);
>>  		xdp_stat = &rx_ring->rx_stats.xdp_tx;
>>  		break;
>>  	case XDP_REDIRECT:
>> @@ -644,6 +701,7 @@ static void ena_init_io_rings(struct 
>> ena_adapter *adapter,
>>  		txr->smoothed_interval =
>>  			ena_com_get_nonadaptive_moderation_interval_tx(ena_dev);
>>  		txr->disable_meta_caching = 
>>  adapter->disable_meta_caching;
>> +		spin_lock_init(&txr->xdp_tx_lock);
>>  
>>  		/* Don't init RX queues for xdp queues */
>>  		if (!ENA_IS_XDP_INDEX(adapter, i)) {
>> @@ -3236,6 +3294,7 @@ static const struct net_device_ops 
>> ena_netdev_ops = {
>>  	.ndo_set_mac_address	= NULL,
>>  	.ndo_validate_addr	= eth_validate_addr,
>>  	.ndo_bpf		= ena_xdp,
>> +	.ndo_xdp_xmit		= ena_xdp_xmit,
>>  };
>> ...
>> +	spinlock_t xdp_tx_lock;	/* synchronize XDP TX/Redirect 
>> traffic */
>>  
>>  	u16 next_to_use;
>>  	u16 next_to_clean;
>> -- 
>> 2.23.3
>> 

