Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 64D53DF1FE
	for <lists+netdev@lfdr.de>; Mon, 21 Oct 2019 17:49:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729501AbfJUPtN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Oct 2019 11:49:13 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:55826 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726289AbfJUPtN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 21 Oct 2019 11:49:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=qjtRzUmj40y3nRvlWQT2fySB0y5KtXhxgRAm3CLI7DQ=; b=soV5FhyJ6VMheL7DGTim/5xwZX
        +0CyOUIfy5k8qVWFjlQi7QrxoP+92YSOYqYeL62QqPjBG7oJbuQYwRssfJrQZjCtJhmpFYPjg4zMe
        MSnI3/iXmTcGiQ0wErnWNX4JGQlTtnBiLjymEUiYvoiClJJ+XNqDALkMhFOp9zZu1fBU=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.92.2)
        (envelope-from <andrew@lunn.ch>)
        id 1iMZvY-0005Fc-Mh; Mon, 21 Oct 2019 17:49:00 +0200
Date:   Mon, 21 Oct 2019 17:49:00 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     Chris Snook <chris.snook@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        James Hogan <jhogan@kernel.org>,
        Jay Cliburn <jcliburn@gmail.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Paul Burton <paul.burton@mips.com>,
        Ralf Baechle <ralf@linux-mips.org>,
        Rob Herring <robh+dt@kernel.org>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        linux-mips@vger.kernel.org, Russell King <linux@armlinux.org.uk>
Subject: Re: [PATCH v3 4/5] net: dsa: add support for Atheros AR9331 TAG
 format
Message-ID: <20191021154900.GF17002@lunn.ch>
References: <20191021053811.19818-1-o.rempel@pengutronix.de>
 <20191021053811.19818-5-o.rempel@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191021053811.19818-5-o.rempel@pengutronix.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +static struct sk_buff *ar9331_tag_rcv(struct sk_buff *skb,
> +				      struct net_device *ndev,
> +				      struct packet_type *pt)
> +{
> +	u8 ver, port;
> +	u16 hdr;
> +
> +	if (unlikely(!pskb_may_pull(skb, AR9331_HDR_LEN)))
> +		return NULL;
> +
> +	hdr = le16_to_cpu(*(__le16 *)skb_mac_header(skb));
> +
> +	ver = FIELD_GET(AR9331_HDR_VERSION_MASK, hdr);
> +	if (unlikely(ver != AR9331_HDR_VERSION)) {
> +		netdev_warn_once(ndev, "%s:%i wrong header version 0x%2x\n",
> +				 __func__, __LINE__, hdr);
> +		return NULL;
> +	}
> +
> +	if (unlikely(hdr & AR9331_HDR_FROM_CPU)) {
> +		netdev_warn_once(ndev, "%s:%i packet should not be from cpu 0x%2x\n",
> +				 __func__, __LINE__, hdr);
> +		return NULL;
> +	}
> +
> +	skb_pull(skb, AR9331_HDR_LEN);
> +	skb_set_mac_header(skb, -ETH_HLEN);

No other tag driver calls skb_set_mac_header().  Also, the -ETH_HLEN
looks odd, give you have just pulled off AR9331_HDR_LEN?

What other tag drivers use is skb_pull_rcsum().

     Andrew
