Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 95F88215F0A
	for <lists+netdev@lfdr.de>; Mon,  6 Jul 2020 20:52:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729785AbgGFSwa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jul 2020 14:52:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:43156 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729733AbgGFSwa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 6 Jul 2020 14:52:30 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 24CD5206B6;
        Mon,  6 Jul 2020 18:52:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594061550;
        bh=K7jVrg8xCIjPeUCpE0HelQtfZnCl9ovnYQN7JoFH9O0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=GOptF7vF9OHDlfJznhdorkhr9ew3ooYA3XDh6PEhP3tawUufDPv7NeeM4qWmVJMR0
         nfMi+sKlg+bFE6R0QOUgixJ++a72z71oEYIBisZ0tFyrtKqeH5l5rbFATR6IuiSP+a
         9XXXFtgG6orjQq8TTOufUwC8jUWtvbQ/fPVqrJdM=
Date:   Mon, 6 Jul 2020 11:52:28 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Michael Chan <michael.chan@broadcom.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: Re: [PATCH net-next v3 6/8] bnxt_en: Implement ethtool -X to set
 indirection table.
Message-ID: <20200706115228.317e9915@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <1593987732-1336-7-git-send-email-michael.chan@broadcom.com>
References: <1593987732-1336-1-git-send-email-michael.chan@broadcom.com>
        <1593987732-1336-7-git-send-email-michael.chan@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun,  5 Jul 2020 18:22:10 -0400 Michael Chan wrote:
> +	/* Reset the RSS indir table if we cannot reserve all the RX rings */
> +	if (rx_rings != bp->rx_nr_rings) {
> +		netdev_warn(bp->dev, "Able to reserve only %d out of %d requested RX rings\n",
> +			    rx_rings, bp->rx_nr_rings);
> +		if (bp->dev->priv_flags & IFF_RXFH_CONFIGURED) {
> +			netdev_warn(bp->dev, "RSS table entries reverting to default\n");
> +			bp->dev->priv_flags &= ~IFF_RXFH_CONFIGURED;
> +		}
> +	}

Maybe let me just type out what I had in mind:

unsigned int bnxt_max_rss_ring(bp)
{
	int i, tbl_size, max_ring;

	if (!bp->rss_indir_tbl)
		return 0;

	max_ring = 0;
	tbl_size = bnxt_get_rxfh_indir_size(dev);
	for (i = 0; i < tbl_size; i++)
		max_ring = max(max_ring, bp->rss_indir_tbl[i]);

	return max_ring;
}

Then:

	if (rx_rings != bp->rx_nr_rings) {
		netdev_warn(bp->dev, "Able to reserve only %d out of %d requested RX rings\n",
			    rx_rings, bp->rx_nr_rings);

		if (netif_is_rxfh_configured(bp->dev) &&
		    rx_rings < bnxt_max_rss_ring(bp)) {
			netdev_err(bp->dev, "RSS table entries reverting to default\n");
			bp->dev->priv_flags &= ~IFF_RXFH_CONFIGURED;
		}
	}
