Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A04A4A6B14
	for <lists+netdev@lfdr.de>; Wed,  2 Feb 2022 05:51:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244628AbiBBEv2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Feb 2022 23:51:28 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:42098 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231474AbiBBEv1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Feb 2022 23:51:27 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6B3AE6170A;
        Wed,  2 Feb 2022 04:51:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 603D8C004E1;
        Wed,  2 Feb 2022 04:51:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643777486;
        bh=jAsmf+yg+yTEjfozNxKTPJAkY11OeZStMsb+udKaqnM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=qkm/nWUO6J9yVevumHHkYMrdh/l/btpaE1dGYxWOqAUHmlhoJcNPsQ5znOEC80PWS
         FEAHHyBFTD2uIpsTj/b5qgkmp1h+h8VoII7oyMXQQ+qoLwhEE5lRv6t8UQdtBYRDEk
         AyS6nh8FIhwkaAmFX7S5CGEPR3ChGscERPZZ2WtB143oympV9iOnhqXtH0jTsoG1U/
         vNcoZfYlctdF2sjUgW7b+aYlx8t4lSoeKkKDdZk7yepCtTqg9lrJmttZ9oKPQyORwX
         5Z+fmwlVJzeIAUkRD+7pw3bFDmCiJEWyaoyyACqMQyOO8K/0ADts0VbyMpsrtdDlFv
         kH2+5ANxQE4Qg==
Date:   Tue, 1 Feb 2022 20:51:25 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Joseph CHAMG <josright123@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>, joseph_chang@davicom.com.tw,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, andy.shevchenko@gmail.com,
        andrew@lunn.ch, leon@kernel.org
Subject: Re: [PATCH v16, 2/2] net: Add dm9051 driver
Message-ID: <20220201205125.54a28bca@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20220129164346.5535-3-josright123@gmail.com>
References: <20220129164346.5535-1-josright123@gmail.com>
        <20220129164346.5535-3-josright123@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 30 Jan 2022 00:43:46 +0800 Joseph CHAMG wrote:
> +		rdptr = skb_put(skb, rxlen - 4);
> +		ret = regmap_noinc_read(db->regmap_dm, DM_SPI_MRCMD, rdptr, rxlen);
> +		if (ret) {

should be counted as rx_error

> +			dev_kfree_skb(skb);
> +			return ret;
> +		}
> +
> +		ret = regmap_write(db->regmap_dm, DM9051_ISR, 0xff); /* to stop mrcmd */
> +		if (ret)
> +			return ret;

leaks skb, also should be counted as rx_error

> +		skb->protocol = eth_type_trans(skb, db->ndev);
> +		if (db->ndev->features & NETIF_F_RXCSUM)
> +			skb_checksum_none_assert(skb);
> +		netif_rx_ni(skb);
> +		db->ndev->stats.rx_bytes += rxlen;
> +		db->ndev->stats.rx_packets++;
> +		scanrr++;
> +	} while (!ret);
> +
> +	return scanrr;
> +}
> +
> +/* transmit a packet,
> + * return value,
> + *   0 - succeed
> + *  -ETIMEDOUT - timeout error
> + */
> +static int dm9051_single_tx(struct board_info *db, u8 *buff, unsigned int len)
> +{
> +	int ret;
> +
> +	ret = dm9051_map_xmitpoll(db);
> +	if (ret)
> +		return ret;
> +
> +	ret = regmap_noinc_write(db->regmap_dm, DM_SPI_MWCMD, buff, len);
> +	if (ret)
> +		return ret;
> +
> +	ret = regmap_bulk_write(db->regmap_dmbulk, DM9051_TXPLL, &len, 2);
> +	if (ret < 0)
> +		return ret;
> +
> +	return regmap_write(db->regmap_dm, DM9051_TCR, TCR_TXREQ);
> +}
> +
> +static int dm9051_loop_tx(struct board_info *db)
> +{
> +	struct net_device *ndev = db->ndev;
> +	int ntx = 0;
> +	int ret;
> +
> +	while (!skb_queue_empty(&db->txq)) {
> +		struct sk_buff *skb;
> +
> +		skb = skb_dequeue(&db->txq);
> +		if (skb) {
> +			ntx++;
> +			ret = dm9051_single_tx(db, skb->data, skb->len);
> +			dev_kfree_skb(skb);
> +			if (ret < 0)
> +				return 0;

Should be counted as tx error?

> +			ndev->stats.tx_bytes += skb->len;
> +			ndev->stats.tx_packets++;
> +		}
> +
> +		if (netif_queue_stopped(ndev) &&
> +		    (skb_queue_len(&db->txq) < DM9051_TX_QUE_LO_WATER))
> +			netif_wake_queue(ndev);
> +	}
> +
> +	return ntx;

