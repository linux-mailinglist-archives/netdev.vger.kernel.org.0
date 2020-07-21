Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 162B6227368
	for <lists+netdev@lfdr.de>; Tue, 21 Jul 2020 02:04:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728061AbgGUAEH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jul 2020 20:04:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:44306 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726535AbgGUAEB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 20 Jul 2020 20:04:01 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0535C208E4;
        Tue, 21 Jul 2020 00:03:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595289807;
        bh=h8sfiUIiKNHZ17ebLa3729aAJisaODzfc/a/4ztkjxo=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=HgVTkGwH2ZNkEDuR4oSj7yip742nDeVvDo+Q+ag6XaS394WLF20zaCsliBe+p0Ay4
         8D24Y0K0Mif8Kk9Afte5G+c+dU7JLp1Y9RQdODvLL2uIelkQmPYvLjGNSSjhrTsOUK
         5KrWZ/M38QcC9HvmGKmv5U6tl/csrqKHmCp7SB6M=
Date:   Mon, 20 Jul 2020 17:03:25 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Shannon Nelson <snelson@pensando.io>
Cc:     netdev@vger.kernel.org, davem@davemloft.net
Subject: Re: [PATCH net 2/5] ionic: fix up filter locks and debug msgs
Message-ID: <20200720170325.6c24303d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200720230017.20419-3-snelson@pensando.io>
References: <20200720230017.20419-1-snelson@pensando.io>
        <20200720230017.20419-3-snelson@pensando.io>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 20 Jul 2020 16:00:14 -0700 Shannon Nelson wrote:
> Add in a couple of forgotten spinlocks and fix up some of
> the debug messages around filter management.

Aren't these independent changes?

> Fixes: c1e329ebec8d ("ionic: Add management of rx filters")
> Signed-off-by: Shannon Nelson <snelson@pensando.io>

> diff --git a/drivers/net/ethernet/pensando/ionic/ionic_rx_filter.c b/drivers/net/ethernet/pensando/ionic/ionic_rx_filter.c
> index 80eeb7696e01..fb9d828812bd 100644
> --- a/drivers/net/ethernet/pensando/ionic/ionic_rx_filter.c
> +++ b/drivers/net/ethernet/pensando/ionic/ionic_rx_filter.c
> @@ -69,10 +69,12 @@ int ionic_rx_filters_init(struct ionic_lif *lif)
>  
>  	spin_lock_init(&lif->rx_filters.lock);
>  
> +	spin_lock_bh(&lif->rx_filters.lock);
>  	for (i = 0; i < IONIC_RX_FILTER_HLISTS; i++) {
>  		INIT_HLIST_HEAD(&lif->rx_filters.by_hash[i]);
>  		INIT_HLIST_HEAD(&lif->rx_filters.by_id[i]);
>  	}
> +	spin_unlock_bh(&lif->rx_filters.lock);
>  
>  	return 0;
>  }
> @@ -84,11 +86,13 @@ void ionic_rx_filters_deinit(struct ionic_lif *lif)
>  	struct hlist_node *tmp;
>  	unsigned int i;
>  
> +	spin_lock_bh(&lif->rx_filters.lock);
>  	for (i = 0; i < IONIC_RX_FILTER_HLISTS; i++) {
>  		head = &lif->rx_filters.by_id[i];
>  		hlist_for_each_entry_safe(f, tmp, head, by_id)
>  			ionic_rx_filter_free(lif, f);
>  	}
> +	spin_unlock_bh(&lif->rx_filters.lock);
>  }

Taking a lock around init/deinit is a little strange, is this fixing 
a possible issue or just for "completeness"? If the like head can be
modified before it's initialized or after its flushed - that's a more
serious problem to address..
