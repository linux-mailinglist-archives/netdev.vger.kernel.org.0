Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4798737A9F
	for <lists+netdev@lfdr.de>; Thu,  6 Jun 2019 19:11:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729950AbfFFRLR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jun 2019 13:11:17 -0400
Received: from mx2.suse.de ([195.135.220.15]:58868 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727512AbfFFRLR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 6 Jun 2019 13:11:17 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 24A37AD17;
        Thu,  6 Jun 2019 17:11:16 +0000 (UTC)
Received: by unicorn.suse.cz (Postfix, from userid 1000)
        id 597D3E00E3; Thu,  6 Jun 2019 19:11:15 +0200 (CEST)
Date:   Thu, 6 Jun 2019 19:11:15 +0200
From:   Michal Kubecek <mkubecek@suse.cz>
To:     netdev@vger.kernel.org
Cc:     sameehj@amazon.com, davem@davemloft.net, dwmw@amazon.com,
        zorik@amazon.com, matua@amazon.com, saeedb@amazon.com,
        msw@amazon.com, aliguori@amazon.com, nafea@amazon.com,
        gtzalik@amazon.com, netanel@amazon.com, alisaidi@amazon.com,
        benh@amazon.com, akiyano@amazon.com
Subject: Re: [PATCH V1 net-next 5/6] net: ena: add ethtool function for
 changing io queue sizes
Message-ID: <20190606171115.GC21536@unicorn.suse.cz>
References: <20190606115520.20394-1-sameehj@amazon.com>
 <20190606115520.20394-6-sameehj@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190606115520.20394-6-sameehj@amazon.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 06, 2019 at 02:55:19PM +0300, sameehj@amazon.com wrote:
> diff --git a/drivers/net/ethernet/amazon/ena/ena_netdev.c b/drivers/net/ethernet/amazon/ena/ena_netdev.c
> index 938aca254..7d3837c13 100644
> --- a/drivers/net/ethernet/amazon/ena/ena_netdev.c
> +++ b/drivers/net/ethernet/amazon/ena/ena_netdev.c
> @@ -2031,6 +2031,20 @@ static int ena_close(struct net_device *netdev)
>  	return 0;
>  }
>  
> +int ena_update_queue_sizes(struct ena_adapter *adapter,
> +			   int new_tx_size,
> +			   int new_rx_size)
> +{
> +	bool dev_up;
> +
> +	dev_up = test_bit(ENA_FLAG_DEV_UP, &adapter->flags);
> +	ena_close(adapter->netdev);
> +	adapter->requested_tx_ring_size = new_tx_size;
> +	adapter->requested_rx_ring_size = new_rx_size;
> +	ena_init_io_rings(adapter);
> +	return dev_up ? ena_up(adapter) : 0;
> +}

This function is called with u32 values as arguments by its only caller
and copies them into u32 members of struct ena_adapter. Why are its
arguments new_tx_size and new_rx_size declared as int?

Michal Kubecek
