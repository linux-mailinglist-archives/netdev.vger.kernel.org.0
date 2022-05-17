Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3D61D529A96
	for <lists+netdev@lfdr.de>; Tue, 17 May 2022 09:12:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236629AbiEQHMA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 May 2022 03:12:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241330AbiEQHLj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 May 2022 03:11:39 -0400
Received: from relay8-d.mail.gandi.net (relay8-d.mail.gandi.net [217.70.183.201])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09A57BC0B;
        Tue, 17 May 2022 00:11:37 -0700 (PDT)
Received: (Authenticated sender: maxime.chevallier@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 71B681BF203;
        Tue, 17 May 2022 07:11:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1652771496;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=U2jr41wtHG2GIGl4bAID1eKFo3qoAi+kociDDFSpOdQ=;
        b=FOR8Z/mYKhL0docIvxdYA2kIC8tFFvxoSzuxqNsLi+ItV9R7/w8BkzHuefuhWbnZ9QBaA5
        D/vJAAHMhmrOkZht8JDrlWEuaX1ZgErcwlDVw7fwjM021cDvcmLDpwvF9t/jIseU8U0c9h
        xe+1eme5jLpNpe42bACGN4yuU7EyuaS5JNZ7d6lNYdQ8omXPYb8bxOHZRbD3Almic1tsrR
        RuT6ITO81p2Fci3Vr7bXCAIgBx0pE4QieLX4N71bvT61nsVEK6raQVznANKT5ibmLjS+CN
        4H2pAsbmqfe8Fs7aLrN3bwhewsE7igs1yA9oJiJcjivkXDNuluJJaFII3lKEVA==
Date:   Tue, 17 May 2022 09:11:34 +0200
From:   Maxime Chevallier <maxime.chevallier@bootlin.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     "davem@davemloft.net" <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "thomas.petazzoni@bootlin.com" <thomas.petazzoni@bootlin.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        Luka Perkov <luka.perkov@sartura.hr>,
        Robert Marko <robert.marko@sartura.hr>
Subject: Re: [PATCH net-next v2 1/5] net: ipqess: introduce the Qualcomm
 IPQESS driver
Message-ID: <20220517091134.4b67b4a0@pc-20.home>
In-Reply-To: <20220514204438.urxot42jfazwnjlz@skbuf>
References: <20220514150656.122108-1-maxime.chevallier@bootlin.com>
        <20220514150656.122108-2-maxime.chevallier@bootlin.com>
        <20220514204438.urxot42jfazwnjlz@skbuf>
Organization: Bootlin
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Vlad,

On Sat, 14 May 2022 20:44:38 +0000
Vladimir Oltean <vladimir.oltean@nxp.com> wrote:

> On Sat, May 14, 2022 at 05:06:52PM +0200, Maxime Chevallier wrote:
> > +/* locking is handled by the caller */
> > +static int ipqess_rx_buf_alloc_napi(struct ipqess_rx_ring *rx_ring)
> > +{
> > +	struct ipqess_buf *buf = &rx_ring->buf[rx_ring->head];
> > +
> > +	buf->skb = napi_alloc_skb(&rx_ring->napi_rx,
> > IPQESS_RX_HEAD_BUFF_SIZE);
> > +	if (!buf->skb)
> > +		return -ENOMEM;
> > +
> > +	return ipqess_rx_buf_prepare(buf, rx_ring);
> > +}
> > +
> > +static int ipqess_rx_buf_alloc(struct ipqess_rx_ring *rx_ring)
> > +{
> > +	struct ipqess_buf *buf = &rx_ring->buf[rx_ring->head];
> > +
> > +	buf->skb = netdev_alloc_skb_ip_align(rx_ring->ess->netdev,
> > +
> > IPQESS_RX_HEAD_BUFF_SIZE); +
> > +	if (!buf->skb)
> > +		return -ENOMEM;
> > +
> > +	return ipqess_rx_buf_prepare(buf, rx_ring);
> > +}
> > +
> > +static void ipqess_refill_work(struct work_struct *work)
> > +{
> > +	struct ipqess_rx_ring_refill *rx_refill =
> > container_of(work,
> > +		struct ipqess_rx_ring_refill, refill_work);
> > +	struct ipqess_rx_ring *rx_ring = rx_refill->rx_ring;
> > +	int refill = 0;
> > +
> > +	/* don't let this loop by accident. */
> > +	while (atomic_dec_and_test(&rx_ring->refill_count)) {
> > +		napi_disable(&rx_ring->napi_rx);
> > +		if (ipqess_rx_buf_alloc(rx_ring)) {
> > +			refill++;
> > +			dev_dbg(rx_ring->ppdev,
> > +				"Not all buffers were
> > reallocated");
> > +		}
> > +		napi_enable(&rx_ring->napi_rx);
> > +	}
> > +
> > +	if (atomic_add_return(refill, &rx_ring->refill_count))
> > +		schedule_work(&rx_refill->refill_work);
> > +}
> > +
> > +static int ipqess_rx_poll(struct ipqess_rx_ring *rx_ring, int
> > budget) +{  
> 
> > +	while (done < budget) {  
> 
> > +		num_desc += atomic_xchg(&rx_ring->refill_count, 0);
> > +		while (num_desc) {
> > +			if (ipqess_rx_buf_alloc_napi(rx_ring)) {
> > +				num_desc =
> > atomic_add_return(num_desc,
> > +
> > &rx_ring->refill_count);
> > +				if (num_desc >= ((4 *
> > IPQESS_RX_RING_SIZE + 6) / 7))  
> 
> DIV_ROUND_UP(IPQESS_RX_RING_SIZE * 4, 7)
> Also, why this number?

Ah this was from the original out-of-tree driver... I'll try to figure
out what's going on an replace that by some #define that would make
more sense.

> > +
> > schedule_work(&rx_ring->ess->rx_refill[rx_ring->ring_id].refill_work);
> > +				break;
> > +			}
> > +			num_desc--;
> > +		}
> > +	}
> > +
> > +	ipqess_w32(rx_ring->ess,
> > IPQESS_REG_RX_SW_CONS_IDX_Q(rx_ring->idx),
> > +		   rx_ring_tail);
> > +	rx_ring->tail = rx_ring_tail;
> > +
> > +	return done;
> > +}  
> 
> > +static void ipqess_rx_ring_free(struct ipqess *ess)
> > +{
> > +	int i;
> > +
> > +	for (i = 0; i < IPQESS_NETDEV_QUEUES; i++) {
> > +		int j;
> > +
> > +		atomic_set(&ess->rx_ring[i].refill_count, 0);
> > +		cancel_work_sync(&ess->rx_refill[i].refill_work);  
> 
> When refill_work is currently scheduled and executing the while loop,
> will refill_count underflow due to the possibility of calling
> atomic_dec_and_test(0)?

Good question, I'll double-check, you might be correct. Nice catch

> > +
> > +		for (j = 0; j < IPQESS_RX_RING_SIZE; j++) {
> > +			dma_unmap_single(&ess->pdev->dev,
> > +
> > ess->rx_ring[i].buf[j].dma,
> > +
> > ess->rx_ring[i].buf[j].length,
> > +					 DMA_FROM_DEVICE);
> > +
> > dev_kfree_skb_any(ess->rx_ring[i].buf[j].skb);
> > +		}
> > +	}
> > +  

Thanks,

Maxime
