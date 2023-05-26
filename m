Return-Path: <netdev+bounces-5501-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C5E3A711E90
	for <lists+netdev@lfdr.de>; Fri, 26 May 2023 05:55:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8A11E28165C
	for <lists+netdev@lfdr.de>; Fri, 26 May 2023 03:54:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B743F1C26;
	Fri, 26 May 2023 03:54:57 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 955671C05
	for <netdev@vger.kernel.org>; Fri, 26 May 2023 03:54:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F786C433EF;
	Fri, 26 May 2023 03:54:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1685073296;
	bh=BHY/pfIw2hUuaTnVESEiRxkn2QmMt7VyZTxiw2ST2/4=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=jo9QPA6rqq5KvmK2DyY2+wTV9OlRByScL9JF5u8QW4rzmCAD4VQJcrWWfwJUvaWdm
	 bYKtT0u9TYP1uKYIOB1ujIiE/a3eYHYMmFOB9WALy4cqxNsbERAzE28Flrsfv16jjO
	 /zAE2nBsXCa/QvVQEp+Zo4S5cAGiHzZE1B38Tl2os8CMZpYUBxH4ITmFk9iIE6188W
	 dJ2YXTGIwV5kzov+ja1FldTeR6eG4aAVXdqdiGPmlPfUBjniwEO//sHB9xUqdSkY2y
	 6s2sK1klCz3dbbXJOpSXvFvpAqByGjsp8L1yTqb/hzkAu6OOXDNyGtCcS9igSBWH7M
	 p2/yarnzgRwGg==
Date: Thu, 25 May 2023 20:54:54 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Justin Chen <justin.chen@broadcom.com>
Cc: netdev@vger.kernel.org, devicetree@vger.kernel.org,
 linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
 bcm-kernel-feedback-list@broadcom.com, florian.fainelli@broadcom.com,
 davem@davemloft.net, edumazet@google.com, pabeni@redhat.com,
 robh+dt@kernel.org, krzysztof.kozlowski+dt@linaro.org, conor+dt@kernel.org,
 opendmb@gmail.com, andrew@lunn.ch, hkallweit1@gmail.com,
 linux@armlinux.org.uk, richardcochran@gmail.com, sumit.semwal@linaro.org,
 christian.koenig@amd.com, simon.horman@corigine.com
Subject: Re: [PATCH net-next v5 3/6] net: bcmasp: Add support for ASP2.0
 Ethernet controller
Message-ID: <20230525205454.1c766852@kernel.org>
In-Reply-To: <1684969313-35503-4-git-send-email-justin.chen@broadcom.com>
References: <1684969313-35503-1-git-send-email-justin.chen@broadcom.com>
	<1684969313-35503-4-git-send-email-justin.chen@broadcom.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed, 24 May 2023 16:01:50 -0700 Justin Chen wrote:
> Add support for the Broadcom ASP 2.0 Ethernet controller which is first
> introduced with 72165. This controller features two distinct Ethernet
> ports that can be independently operated.
> 
> This patch supports:
> 
> - Wake-on-LAN using magic packets
> - basic ethtool operations (link, counters, message level)
> - MAC destination address filtering (promiscuous, ALL_MULTI, etc.)

> +static netdev_tx_t bcmasp_xmit(struct sk_buff *skb, struct net_device *dev)
> +{
> +	struct bcmasp_intf *intf = netdev_priv(dev);
> +	int spb_index, nr_frags, ret, i, j;
> +	unsigned int total_bytes, size;
> +	struct bcmasp_tx_cb *txcb;
> +	dma_addr_t mapping, valid;
> +	struct bcmasp_desc *desc;
> +	bool csum_hw = false;
> +	struct device *kdev;
> +	skb_frag_t *frag;
> +
> +	kdev = &intf->parent->pdev->dev;
> +
> +	spin_lock(&intf->tx_lock);

What is the tx_lock for? netdevs already have a tx lock, unless you
declare the device as lockless.

> +static void bcmasp_tx_timeout(struct net_device *dev, unsigned int txqueue)
> +{
> +	struct bcmasp_intf *intf = netdev_priv(dev);
> +
> +	netif_dbg(intf, tx_err, dev, "transmit timeout!\n");
> +
> +	netif_trans_update(dev);
> +	dev->stats.tx_errors++;
> +
> +	netif_wake_queue(dev);

If the queue is full xmit will just put it back to sleep.
You want to try to reap completions if anything, no?

> +static struct net_device_stats *bcmasp_get_stats(struct net_device *dev)
> +{
> +	return &dev->stats;
> +}

you don't have to do this, core will use device stats if there's no ndo

> +	ndev = alloc_etherdev(sizeof(struct bcmasp_intf));
> +	if (!dev) {

*blink* condition is typo'ed

> +		dev_warn(dev, "%s: unable to alloc ndev\n", ndev_dn->name);
> +		goto err;
> +	}

-- 
pw-bot: cr

