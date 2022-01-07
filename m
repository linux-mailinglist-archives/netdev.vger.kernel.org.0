Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 31C054871DC
	for <lists+netdev@lfdr.de>; Fri,  7 Jan 2022 05:44:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232412AbiAGEod (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jan 2022 23:44:33 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:49180 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230171AbiAGEoc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Jan 2022 23:44:32 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4868E61D32
        for <netdev@vger.kernel.org>; Fri,  7 Jan 2022 04:44:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 825F5C36AE9;
        Fri,  7 Jan 2022 04:44:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641530671;
        bh=1uZnirBGuDTMjC9QK7cpj2yvw85DCmYYSuOR2jOz20M=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=rule/T32lOGCmKKm/GaEKfxiJibNa61BQXduVm/FOLkx+5e3GYIh7XDs78FW0T21a
         8SrEkUO4JZ0vF3QP9tc74URQrr8E0Ci4XxXv4o0UBxfYosFab/dIGJi2Wx01dPa4fa
         VpVLMIHqnorvjQFjFsGRlxwrC9J1L91CfLmKTzQV46bGRYruXm7FCdUqPp4YpVurdP
         NroGAbnvHYcdBIdEnBRuTaczo4VNIYB0/yRM/rnvdb/6dh2aJ5n5szPYwwwOzasaMv
         4FGPz0B91nslKk3Ico0PAR+uHNWxjbbEbLDSDxOjGTXTR1/LuxWRdISmhUj2Nt3OhI
         GRL+5vuWajbwQ==
Date:   Thu, 6 Jan 2022 20:44:30 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Dimitris Michailidis <d.michailidis@fungible.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, andrew@lunn.ch
Subject: Re: [PATCH net-next v5 4/8] net/funeth: ethtool operations
Message-ID: <20220106204430.3bf21da3@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20220107043612.21342-5-dmichail@fungible.com>
References: <20220107043612.21342-1-dmichail@fungible.com>
        <20220107043612.21342-5-dmichail@fungible.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu,  6 Jan 2022 20:36:08 -0800 Dimitris Michailidis wrote:
> +	if (netif_running(netdev))
> +		netdev->netdev_ops->ndo_stop(netdev);
> +
> +	old_tx = netdev->real_num_tx_queues;
> +	old_rx = netdev->real_num_rx_queues;
> +	set_ring_count(netdev, chan->tx_count, chan->rx_count);
> +
> +	if (netif_running(netdev)) {
> +		rc = netdev->netdev_ops->ndo_open(netdev);
> +		if (rc) {
> +			set_ring_count(netdev, old_tx, old_rx);
> +			netdev->netdev_ops->ndo_open(netdev);

Sorry, I wasn't clear - same story as with XDP - configuration changes
should not run at risk of having the machine drop off the network due
to temporary memory pressure.
