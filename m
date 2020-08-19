Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 33D4724A185
	for <lists+netdev@lfdr.de>; Wed, 19 Aug 2020 16:17:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728570AbgHSOR3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Aug 2020 10:17:29 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:33566 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728595AbgHSORX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 19 Aug 2020 10:17:23 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1k8Otw-00A5rp-U9; Wed, 19 Aug 2020 16:17:16 +0200
Date:   Wed, 19 Aug 2020 16:17:16 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     sameehj@amazon.com
Cc:     davem@davemloft.net, netdev@vger.kernel.org, dwmw@amazon.com,
        zorik@amazon.com, matua@amazon.com, saeedb@amazon.com,
        msw@amazon.com, aliguori@amazon.com, nafea@amazon.com,
        gtzalik@amazon.com, netanel@amazon.com, alisaidi@amazon.com,
        benh@amazon.com, akiyano@amazon.com, ndagan@amazon.com
Subject: Re: [PATCH V2 net-next 1/4] net: ena: ethtool: use unsigned long for
 pointer arithmetics
Message-ID: <20200819141716.GE2403519@lunn.ch>
References: <20200819134349.22129-1-sameehj@amazon.com>
 <20200819134349.22129-2-sameehj@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200819134349.22129-2-sameehj@amazon.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 19, 2020 at 01:43:46PM +0000, sameehj@amazon.com wrote:
> From: Sameeh Jubran <sameehj@amazon.com>
> 
> unsigned long is the type for doing maths on pointers.

Maths on pointers is perfectly valid. The real issue here is you have
all your types mixed up.

> -			ptr = (u64 *)((uintptr_t)&ring->tx_stats +
> -				(uintptr_t)ena_stats->stat_offset);
> +			ptr = (u64 *)((unsigned long)&ring->tx_stats +
> +				ena_stats->stat_offset);

struct ena_ring {
...
        union {
		struct ena_stats_tx tx_stats;
		struct ena_stats_rx rx_stats;
	};

struct ena_stats_tx {
	u64 cnt;
	u64 bytes;
	u64 queue_stop;
	u64 prepare_ctx_err;
	u64 queue_wakeup;
	...
}

&ring->tx_stats will give you a struct *ena_stats_tx. Arithmetic on
that, adding 1 for example, takes you forward a full ena_stats_tx
structure. Not what you want.

&ring->tx_stats.cnt however, will give you a u64 *. Adding 1 to that
will give you bytes, etc.

     Andrew
