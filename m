Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C0DB23B99E
	for <lists+netdev@lfdr.de>; Mon, 10 Jun 2019 18:37:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387396AbfFJQhD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Jun 2019 12:37:03 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:42206 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728389AbfFJQhD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 10 Jun 2019 12:37:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=TK6DJF1OfnpqoJww6+tyoena5H9KJcrEGa/0kFZWbOg=; b=kTdE5YuMR3ogwBgZb+v9OmzXN1
        2b2P4CUk3vF+G97SPTzqE0i7Sw/GnMUS8kmO458SH5GWGzH+vH+OxPhHRNtMcSIjoP0vyZpN3PK7k
        1mV3sn+4yKsAi+Y7zyMyaadhPexul4C2xA3jmNOOGYe7Zmd9G4tGz4UIMrm20OkgTIdQ=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1haNI3-0000KB-S8; Mon, 10 Jun 2019 18:36:59 +0200
Date:   Mon, 10 Jun 2019 18:36:59 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     David Miller <davem@davemloft.net>
Cc:     sameehj@amazon.com, netdev@vger.kernel.org, dwmw@amazon.com,
        zorik@amazon.com, matua@amazon.com, saeedb@amazon.com,
        msw@amazon.com, aliguori@amazon.com, nafea@amazon.com,
        gtzalik@amazon.com, netanel@amazon.com, alisaidi@amazon.com,
        benh@amazon.com, akiyano@amazon.com
Subject: Re: [PATCH V2 net-next 4/6] net: ena: allow queue allocation backoff
 when low on memory
Message-ID: <20190610163659.GL28724@lunn.ch>
References: <20190610111918.21397-1-sameehj@amazon.com>
 <20190610111918.21397-5-sameehj@amazon.com>
 <20190610.091840.690511717716268814.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190610.091840.690511717716268814.davem@davemloft.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 10, 2019 at 09:18:40AM -0700, David Miller wrote:
> From: <sameehj@amazon.com>
> Date: Mon, 10 Jun 2019 14:19:16 +0300
> 
> > +static inline void set_io_rings_size(struct ena_adapter *adapter,
> > +				     int new_tx_size, int new_rx_size)
> 
> Please do not ever use inline in foo.c files, let the compiler decide.

Hi David

It looks like a few got passed review:

~/linux/drivers/net/ethernet/amazon/ena$ grep inline *.c
ena_com.c:static inline int ena_com_mem_addr_set(struct ena_com_dev *ena_dev,
ena_com.c:static inline void comp_ctxt_release(struct ena_com_admin_queue *queue,
ena_com.c:static inline int ena_com_init_comp_ctxt(struct ena_com_admin_queue *queue)
ena_eth_com.c:static inline struct ena_eth_io_rx_cdesc_base *ena_com_get_next_rx_cdesc(
ena_eth_com.c:static inline void *get_sq_desc_regular_queue(struct ena_com_io_sq *io_sq)
ena_eth_com.c:static inline int ena_com_write_bounce_buffer_to_dev(struct ena_com_io_sq *io_sq,
ena_eth_com.c:static inline int ena_com_write_header_to_bounce(struct ena_com_io_sq *io_sq,
ena_eth_com.c:static inline void *get_sq_desc_llq(struct ena_com_io_sq *io_sq)
ena_eth_com.c:static inline int ena_com_close_bounce_buffer(struct ena_com_io_sq *io_sq)
ena_eth_com.c:static inline void *get_sq_desc(struct ena_com_io_sq *io_sq)
ena_eth_com.c:static inline int ena_com_sq_update_llq_tail(struct ena_com_io_sq *io_sq)
ena_eth_com.c:static inline int ena_com_sq_update_tail(struct ena_com_io_sq *io_sq)
ena_eth_com.c:static inline struct ena_eth_io_rx_cdesc_base *
ena_eth_com.c:static inline u16 ena_com_cdesc_rx_pkt_get(struct ena_com_io_cq *io_cq,
ena_eth_com.c:static inline int ena_com_create_and_store_tx_meta_desc(struct ena_com_io_sq *io_sq,
ena_eth_com.c:static inline void ena_com_rx_set_flags(struct ena_com_rx_ctx *ena_rx_ctx,
ena_netdev.c:static inline int validate_rx_req_id(struct ena_ring *rx_ring, u16 req_id)
ena_netdev.c:static inline int ena_alloc_rx_page(struct ena_ring *rx_ring,
ena_netdev.c:static inline void ena_unmap_tx_skb(struct ena_ring *tx_ring,
ena_netdev.c:static inline void ena_rx_checksum(struct ena_ring *rx_ring,
ena_netdev.c:inline void ena_adjust_intr_moderation(struct ena_ring *rx_ring,
ena_netdev.c:static inline void ena_unmask_interrupt(struct ena_ring *tx_ring,
ena_netdev.c:static inline void ena_update_ring_numa_node(struct ena_ring *tx_ring,
ena_netdev.c:static inline void set_default_llq_configurations(struct ena_llq_configurations *llq_config)

	Andrew
