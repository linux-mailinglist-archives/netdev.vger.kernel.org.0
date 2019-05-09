Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1AE79183B3
	for <lists+netdev@lfdr.de>; Thu,  9 May 2019 04:23:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726460AbfEICXh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 May 2019 22:23:37 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:58977 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725842AbfEICXg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 8 May 2019 22:23:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=BLdUxRrkwpbfMypNuHs1fW3qzt5NUxqZanuMvnX1EIM=; b=vu0NFRT9a7FhbMaiTIdR8jrxM+
        UljmNAEVWm4ywYA69TC01Y2ntK1Ozzi49VjWGqq8Axff70XUsDWUtgZGBAhX/eNj9rU9dUsxz0tUo
        wkUnRlsy/iv+FRmoEPkwZ5nlnd/nqV3tP+b0BKUMa+s8KsgoPN0SCPFj2tEkY+HZ6qyM=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hOYiY-0006iY-9w; Thu, 09 May 2019 04:23:30 +0200
Date:   Thu, 9 May 2019 04:23:30 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Jose Abreu <Jose.Abreu@synopsys.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Joao Pinto <Joao.Pinto@synopsys.com>,
        "David S . Miller" <davem@davemloft.net>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>
Subject: Re: [PATCH net-next 10/11] net: stmmac: Introduce selftests support
Message-ID: <20190509022330.GA23758@lunn.ch>
References: <cover.1557300602.git.joabreu@synopsys.com>
 <be9099bbf8783b210dc9034a8b82219984f03250.1557300602.git.joabreu@synopsys.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <be9099bbf8783b210dc9034a8b82219984f03250.1557300602.git.joabreu@synopsys.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +static int stmmac_test_eee(struct stmmac_priv *priv)
> +{
> +	struct stmmac_extra_stats *initial, *final;
> +	int timeout = 100;
> +	int ret;
> +
> +	ret = stmmac_test_loopback(priv);
> +	if (ret)
> +		goto out_free_final;
> +
> +	/* We have no traffic in the line so, sooner or later it will go LPI */
> +	while (--timeout) {
> +		memcpy(final, &priv->xstats, sizeof(*final));
> +
> +		if (final->irq_tx_path_in_lpi_mode_n >
> +		    initial->irq_tx_path_in_lpi_mode_n)
> +			break;
> +		msleep(100);
> +	}
> +
> +	if (!timeout) {
> +		ret = -ETIMEDOUT;
> +		goto out_free_final;
> +	}

Retries would be a better name than timeout.

Also, 100 * 100 ms seems like a long time.

> +static int stmmac_filter_check(struct stmmac_priv *priv)
> +{
> +	if (!(priv->dev->flags & IFF_PROMISC))
> +		return 0;
> +
> +	netdev_warn(priv->dev, "Test can't be run in promiscuous mode!\n");
> +	return 1;

Maybe return EOPNOTSUPP here,

> +}
> +
> +static int stmmac_test_hfilt(struct stmmac_priv *priv)
> +{
> +	unsigned char gd_addr[ETH_ALEN] = {0x01, 0x0c, 0xcd, 0x04, 0x00, 0x00};
> +	unsigned char bd_addr[ETH_ALEN] = {0x06, 0x07, 0x08, 0x09, 0x0a, 0x0b};

What does gd and bd mean?

> +	struct stmmac_packet_attrs attr = { };
> +	int ret;
> +
> +	if (stmmac_filter_check(priv))
> +		return -EOPNOTSUPP;

and just return the error code from the call.

> +
> +	ret = dev_mc_add(priv->dev, gd_addr);
> +	if (ret)
> +		return ret;
> +
> +	attr.dst = gd_addr;
> +
> +	/* Shall receive packet */
> +	ret = __stmmac_test_loopback(priv, &attr);
> +	if (ret)
> +		goto cleanup;
> +
> +	attr.dst = bd_addr;
> +
> +	/* Shall NOT receive packet */
> +	ret = __stmmac_test_loopback(priv, &attr);
> +	ret = !ret;

What is this test testing? gd is a multicast, where as bd is not.  I
expect the hardware treats multicast different to unicast. So it would
make more sense to test two different multicast addresses, one which
has been added via dev_mc_addr, and one that has not?

> +
> +cleanup:
> +	dev_mc_del(priv->dev, gd_addr);
> +	return ret;
> +}
> +
> +static int stmmac_test_pfilt(struct stmmac_priv *priv)
> +{
> +	unsigned char gd_addr[ETH_ALEN] = {0x01, 0x02, 0x03, 0x04, 0x05, 0x06};
> +	unsigned char bd_addr[ETH_ALEN] = {0x06, 0x07, 0x08, 0x09, 0x0a, 0x0b};
> +	struct stmmac_packet_attrs attr = { };
> +	int ret;
> +
> +	if (stmmac_filter_check(priv))
> +		return -EOPNOTSUPP;
> +
> +	ret = dev_uc_add(priv->dev, gd_addr);
> +	if (ret)
> +		return ret;
> +
> +	attr.dst = gd_addr;
> +
> +	/* Shall receive packet */
> +	ret = __stmmac_test_loopback(priv, &attr);
> +	if (ret)
> +		goto cleanup;

gb is a multicast address. Does dev_uc_add() return an error? If it
does not we should not expect it to actually work, since a multicast
address should not match a unicast address?

You also seem to be missing a test for adding a unicast address via
dev_uc_add() and receiving packets for that address, but not receiving
multicast packets.

> +static const struct stmmac_test {
> +	char name[ETH_GSTRING_LEN];
> +	int lb;
> +	int (*fn)(struct stmmac_priv *priv);
> +} stmmac_selftests[] = {
> +	{
> +		.name = "MAC Loopback         ",
> +		.lb = STMMAC_LOOPBACK_MAC,
> +		.fn = stmmac_test_loopback,

stmmac_test_mac_loopback might be a better name.

> +	}, {
> +		.name = "PHY Loopback         ",
> +		.lb = STMMAC_LOOPBACK_PHY,
> +		.fn = stmmac_test_phy_loopback,
> +	}, {

  Andrew
