Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5DCB846CD6D
	for <lists+netdev@lfdr.de>; Wed,  8 Dec 2021 06:59:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232405AbhLHGCa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Dec 2021 01:02:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230426AbhLHGCa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Dec 2021 01:02:30 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9DF0FC061574
        for <netdev@vger.kernel.org>; Tue,  7 Dec 2021 21:58:58 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id D30B0CE1FCC
        for <netdev@vger.kernel.org>; Wed,  8 Dec 2021 05:58:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC99BC00446;
        Wed,  8 Dec 2021 05:58:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638943135;
        bh=s8X0se/NrtJ3lclSE7n0R19PYBQljtHEhErflTiRSXo=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=QstsAAp39a8XZ9TUQViMIgofN/rf3awYAzWuUK+lQvAcgjHeAMbUVUszG0caTfAQm
         vKXZIDZ7UmCQRugg7pVFImn3S0o7Lq6H649azgk8gMnQS6e93fa5qV6/Lw9lS/UiGt
         AHolw/buLPik9l50e0NEIoLIh4o3mKIfLt25o9TL5sMsa7ZbCfOvlZOe2qL5nUx7vo
         ztc83zvXErFg+6lt0FUcPGzmMHRygd4fILZueoGmm/eK5nYV/Z3xBg5/Hv1YAmLPfY
         +61iM5mfhOuQbdtIUwE2B2yB2q6T1cGF6hFwl4Rtb9DHSpIT4+YKetv9J/AtN55ftq
         lqfE5sQkwEyhA==
Date:   Tue, 7 Dec 2021 21:58:53 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     davem@davemloft.net, Jesse Brandeburg <jesse.brandeburg@intel.com>,
        netdev@vger.kernel.org, stephen@networkplumber.org,
        Gurucharan G <gurucharanx.g@intel.com>
Subject: Re: [PATCH net 7/7] ice: safer stats processing
Message-ID: <20211207215853.692bbff4@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20211207222544.977843-8-anthony.l.nguyen@intel.com>
References: <20211207222544.977843-1-anthony.l.nguyen@intel.com>
        <20211207222544.977843-8-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue,  7 Dec 2021 14:25:44 -0800 Tony Nguyen wrote:
> @@ -5949,6 +5950,7 @@ ice_update_vsi_tx_ring_stats(struct ice_vsi *vsi, s=
truct ice_tx_ring **rings,
>  			ice_fetch_u64_stats_per_ring(&ring->syncp, ring->stats, &pkts, &bytes=
);
>  		vsi_stats->tx_packets +=3D pkts;
>  		vsi_stats->tx_bytes +=3D bytes;
> +
>  		vsi->tx_restart +=3D ring->tx_stats.restart_q;
>  		vsi->tx_busy +=3D ring->tx_stats.tx_busy;
>  		vsi->tx_linearize +=3D ring->tx_stats.tx_linearize;

> @@ -6219,6 +6227,7 @@ void ice_get_stats64(struct net_device *netdev, str=
uct rtnl_link_stats64 *stats)
>  	 */
>  	if (!test_bit(ICE_VSI_DOWN, vsi->state))
>  		ice_update_vsi_ring_stats(vsi);
> +
>  	stats->tx_packets =3D vsi_stats->tx_packets;
>  	stats->tx_bytes =3D vsi_stats->tx_bytes;
>  	stats->rx_packets =3D vsi_stats->rx_packets;

=F0=9F=99=84 in a fix that has to go back to 4.16?
