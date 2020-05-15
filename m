Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B1D81D5B21
	for <lists+netdev@lfdr.de>; Fri, 15 May 2020 23:02:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726261AbgEOVB6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 May 2020 17:01:58 -0400
Received: from mx2.suse.de ([195.135.220.15]:36114 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726179AbgEOVB6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 15 May 2020 17:01:58 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id D917FAC50;
        Fri, 15 May 2020 21:01:59 +0000 (UTC)
Received: by lion.mk-sys.cz (Postfix, from userid 1000)
        id CE1AC60347; Fri, 15 May 2020 23:01:56 +0200 (CEST)
Date:   Fri, 15 May 2020 23:01:56 +0200
From:   Michal Kubecek <mkubecek@suse.cz>
To:     netdev@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>, davem@davemloft.net,
        simon.horman@netronome.com, kernel-team@fb.com
Subject: Re: [PATCH net-next 3/3] ethtool: don't call set_channels in drivers
 if config didn't change
Message-ID: <20200515210156.GH21714@lion.mk-sys.cz>
References: <20200515194902.3103469-1-kuba@kernel.org>
 <20200515194902.3103469-4-kuba@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200515194902.3103469-4-kuba@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 15, 2020 at 12:49:02PM -0700, Jakub Kicinski wrote:
> Don't call drivers if nothing changed. Netlink code already
> contains this logic.
> 
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>

Reviewed-by: Michal Kubecek <mkubecek@suse.cz>

> ---
>  net/ethtool/ioctl.c | 6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/net/ethtool/ioctl.c b/net/ethtool/ioctl.c
> index a574d60111fa..eeb1137a3f23 100644
> --- a/net/ethtool/ioctl.c
> +++ b/net/ethtool/ioctl.c
> @@ -1669,6 +1669,12 @@ static noinline_for_stack int ethtool_set_channels(struct net_device *dev,
>  
>  	dev->ethtool_ops->get_channels(dev, &curr);
>  
> +	if (channels.rx_count == curr.rx_count &&
> +	    channels.tx_count == curr.tx_count &&
> +	    channels.combined_count == curr.combined_count &&
> +	    channels.other_count == curr.other_count)
> +		return 0;
> +
>  	/* ensure new counts are within the maximums */
>  	if (channels.rx_count > curr.max_rx ||
>  	    channels.tx_count > curr.max_tx ||
> -- 
> 2.25.4
> 
