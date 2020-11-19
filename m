Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D9CC2B8902
	for <lists+netdev@lfdr.de>; Thu, 19 Nov 2020 01:22:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726500AbgKSAVj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Nov 2020 19:21:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:54226 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726162AbgKSAVi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 18 Nov 2020 19:21:38 -0500
Received: from kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id ED076246BB;
        Thu, 19 Nov 2020 00:21:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605745298;
        bh=xmkOk+SqlBf6qRWj2rvbZ9ZAL1tQsZ7zvM53t2QMDFs=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=yfgQ2818rAsTga7DjWcVX+gA5Yjm6xPQu1WXPCBXYuCyExBFguqTkg+mi/X7byU4b
         Lu9msEZWLKdX0Mi1Gq3N5xutLu+mYA4fRH1LC3uYDgqkIElHY3g+/deaqJeSNvgCkc
         E4/zOZjSmpR8OjJ2YXIVL06nMi4BZRukT/4gjZeM=
Date:   Wed, 18 Nov 2020 16:21:37 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Camelia Groza <camelia.groza@nxp.com>
Cc:     brouer@redhat.com, saeed@kernel.org, davem@davemloft.net,
        madalin.bucur@oss.nxp.com, ioana.ciornei@nxp.com,
        netdev@vger.kernel.org
Subject: Re: [PATCH net-next v2 2/7] dpaa_eth: add basic XDP support
Message-ID: <20201118162137.149625e3@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <e8f6ede91ab1c3fa50953076e7983979de04d2b5.1605535745.git.camelia.groza@nxp.com>
References: <cover.1605535745.git.camelia.groza@nxp.com>
        <e8f6ede91ab1c3fa50953076e7983979de04d2b5.1605535745.git.camelia.groza@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 16 Nov 2020 16:42:28 +0200 Camelia Groza wrote:
> +	if (likely(fd_format == qm_fd_contig)) {
> +		xdp_act = dpaa_run_xdp(priv, (struct qm_fd *)fd, vaddr,
> +				       &xdp_meta_len);
> +		if (xdp_act != XDP_PASS) {
> +			percpu_stats->rx_packets++;
> +			percpu_stats->rx_bytes += qm_fd_get_length(fd);
> +			return qman_cb_dqrr_consume;
> +		}
>  		skb = contig_fd_to_skb(priv, fd);
> -	else
> +	} else {
> +		WARN_ONCE(priv->xdp_prog, "S/G frames not supported under XDP\n");
>  		skb = sg_fd_to_skb(priv, fd);

It'd be safer to drop the packet if the format does not allow XDP 
to run. Otherwise someone can bypass whatever policy XDP is trying 
to enforce.

