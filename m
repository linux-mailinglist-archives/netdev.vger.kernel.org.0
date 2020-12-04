Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 216832CE5B7
	for <lists+netdev@lfdr.de>; Fri,  4 Dec 2020 03:32:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726898AbgLDC3v (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Dec 2020 21:29:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:34532 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726080AbgLDC3u (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 3 Dec 2020 21:29:50 -0500
Date:   Thu, 3 Dec 2020 18:29:08 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1607048950;
        bh=WcKeB64+Rq8+BRmoS2PnKlzbv/2X8OrvskOM2RQqNnQ=;
        h=From:To:Cc:Subject:In-Reply-To:References:From;
        b=Kw6j1lyQ2jP30JHzkrkY4nXVKTEsxIo1S0sEMVD+L2z+3Cm+JoB1zi8axEGF24zDv
         A3vVIB28F24tpnp5aUBqjVHJx06Pz/YiMzAJQTE3dL7eohT749qxfsmhN3PWfT6waV
         DDHIAX467Uftj7HerbC9vCNMLPFYXbHGA5rDcU0B3CAPGNNH+W9TRs/wRVdrvaBYCM
         co3Zq7Pr2zA4bHS0ndy838JR/GNLd3A/6gWBKzBH2ehV/HTLU5XlXD/s/BmQ58hDcZ
         iMgfhmKUSjBQojnigFzJ8vpKDus5sDZNoGESvlY8DuFzT2Q8JO8OIaZxUh1oo2Gr3f
         PdHbH9pDjLW9g==
From:   Jakub Kicinski <kuba@kernel.org>
To:     Saeed Mahameed <saeedm@nvidia.com>
Cc:     "David S. Miller" <davem@davemloft.net>, <netdev@vger.kernel.org>,
        "Eran Ben Elisha" <eranbe@nvidia.com>,
        Tariq Toukan <tariqt@nvidia.com>
Subject: Re: [net-next V2 08/15] net/mlx5e: Add TX PTP port object support
Message-ID: <20201203182908.1d25ea3f@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
In-Reply-To: <20201203042108.232706-9-saeedm@nvidia.com>
References: <20201203042108.232706-1-saeedm@nvidia.com>
        <20201203042108.232706-9-saeedm@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2 Dec 2020 20:21:01 -0800 Saeed Mahameed wrote:
> Add TX PTP port object support for better TX timestamping accuracy.
> Currently, driver supports CQE based TX port timestamp. Device
> also offers TX port timestamp, which has less jitter and better
> reflects the actual time of a packet's transmit.

How much better is it?

Is the new implementation is standard compliant or just a "better
guess"?

> Define new driver layout called ptpsq, on which driver will create
> SQs that will support TX port timestamp for their transmitted packets.
> Driver to identify PTP TX skbs and steer them to these dedicated SQs
> as part of the select queue ndo.
> 
> Driver to hold ptpsq per TC and report them at
> netif_set_real_num_tx_queues().
> 
> Add support for all needed functionality in order to xmit and poll
> completions received via ptpsq.
> 
> Add ptpsq to the TX reporter recover, diagnose and dump methods.
> 
> Creation of ptpsqs is disabled by default, and can be enabled via
> tx_port_ts private flag.

This flag is pretty bad user experience.

> This patch steer all timestamp related packets to a ptpsq, but it
> does not open the port timestamp support for it. The support will
> be added in the following patch.

Overall I'm a little shocked by this, let me sleep on it :)

More info on the trade offs and considerations which led to the
implementation would be useful.
