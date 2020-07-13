Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9AB6021E2EC
	for <lists+netdev@lfdr.de>; Tue, 14 Jul 2020 00:20:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726752AbgGMWT7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jul 2020 18:19:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:40054 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726629AbgGMWTA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 13 Jul 2020 18:19:00 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8CA2920C56;
        Mon, 13 Jul 2020 22:18:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594678737;
        bh=fAyScNLeL/KbGMRN+5K0N78YdwzeluYb+79QRes0B7I=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=OJthho3i8CBfgx7pxjudq2bDJC2PnqIDJM5Xcg4xaXD5DrRRP0DsxdBYBbEbEFJC0
         rEXygI+H3/ceQli1FyLkkY5SrzZK9XgCNaZu560ugl0/dMUtk84eCmM5wNfBv9eYta
         /qIchUtj8s+rB6XMe+uIYisJASvI33p3qEVDDhc8=
Date:   Mon, 13 Jul 2020 15:18:55 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Claudiu Manoil <claudiu.manoil@nxp.com>
Cc:     "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: Re: [PATCH net-next 4/6] enetc: Add interrupt coalescing support
Message-ID: <20200713151855.7b0b09b4@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <1594644970-13531-5-git-send-email-claudiu.manoil@nxp.com>
References: <1594644970-13531-1-git-send-email-claudiu.manoil@nxp.com>
        <1594644970-13531-5-git-send-email-claudiu.manoil@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 13 Jul 2020 15:56:08 +0300 Claudiu Manoil wrote:
> +static int enetc_get_coalesce(struct net_device *ndev,
> +			      struct ethtool_coalesce *ic)
> +{
> +	struct enetc_ndev_priv *priv = netdev_priv(ndev);
> +	struct enetc_int_vector *v = priv->int_vector[0];
> +
> +	memset(ic, 0, sizeof(*ic));

nit: no need to zero this out

> +	ic->tx_coalesce_usecs = enetc_cycles_to_usecs(v->tx_ictt);
> +	ic->rx_coalesce_usecs = enetc_cycles_to_usecs(v->rx_ictt);
> +
> +	ic->tx_max_coalesced_frames = ENETC_TXIC_PKTTHR;
> +	ic->rx_max_coalesced_frames = ENETC_RXIC_PKTTHR;
> +
> +	return 0;
> +}
> +
> +static int enetc_set_coalesce(struct net_device *ndev,
> +			      struct ethtool_coalesce *ic)
> +{
> +	struct enetc_ndev_priv *priv = netdev_priv(ndev);
> +	u32 rx_ictt, tx_ictt;
> +	int i, ic_mode;
> +
> +	tx_ictt = enetc_usecs_to_cycles(ic->tx_coalesce_usecs);
> +	rx_ictt = enetc_usecs_to_cycles(ic->rx_coalesce_usecs);
> +
> +	if (!ic->rx_max_coalesced_frames)

Isn't it better to check != ENETC_RXIC_PKTTHR, rather than != 0?

> +		netif_warn(priv, hw, ndev, "rx-frames fixed to %d\n",
> +			   ENETC_RXIC_PKTTHR);
> +
> +	if (!ic->tx_max_coalesced_frames)
> +		netif_warn(priv, hw, ndev, "tx-frames fixed to %d\n",
> +			   ENETC_TXIC_PKTTHR);
