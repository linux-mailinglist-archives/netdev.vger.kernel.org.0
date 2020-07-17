Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 710C9224443
	for <lists+netdev@lfdr.de>; Fri, 17 Jul 2020 21:32:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728481AbgGQTcl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jul 2020 15:32:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:44246 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727999AbgGQTcl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 17 Jul 2020 15:32:41 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A58452064C;
        Fri, 17 Jul 2020 19:32:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595014360;
        bh=4KwsvjwJQaBSNiAwKYt7rAz3HnYUx1PEov4meHZYOKk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=02zkt6ic6qEaP/c01WJ+nmYR63PGKobK8xMBSDYHxmyjINmtcvuV7z4n06r+Xfkyp
         rOIBogk+1pg09LXoF0wtt84/+WKnZ6c2Uz2GNMWOQReQk9rsN3Ey5xXnb7VA2KsAB2
         IK9Ayd8Yd3r+xIKV5VXIToyCF/nyTn72/06VwRmU=
Date:   Fri, 17 Jul 2020 12:32:39 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Claudiu Manoil <claudiu.manoil@nxp.com>
Cc:     "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: Re: [PATCH net-next v2 5/6] enetc: Add interrupt coalescing support
Message-ID: <20200717123239.1ffb5966@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <1595000224-6883-6-git-send-email-claudiu.manoil@nxp.com>
References: <1595000224-6883-1-git-send-email-claudiu.manoil@nxp.com>
        <1595000224-6883-6-git-send-email-claudiu.manoil@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 17 Jul 2020 18:37:03 +0300 Claudiu Manoil wrote:
> +	if (ic->rx_max_coalesced_frames != ENETC_RXIC_PKTTHR)
> +		netif_warn(priv, hw, ndev, "rx-frames fixed to %d\n",
> +			   ENETC_RXIC_PKTTHR);
> +
> +	if (ic->tx_max_coalesced_frames != ENETC_TXIC_PKTTHR)
> +		netif_warn(priv, hw, ndev, "tx-frames fixed to %d\n",
> +			   ENETC_TXIC_PKTTHR);

On second thought - why not return an error here? Since only one value
is supported seems like the right way to communicate to the users that
they can't change this.

> +	if (netif_running(ndev) && changed) {
> +		/* reconfigure the operation mode of h/w interrupts,
> +		 * traffic needs to be paused in the process
> +		 */
> +		enetc_stop(ndev);
> +		enetc_start(ndev);

Is start going to print an error when it fails? Kinda scary if this
could turn into a silent failure.
