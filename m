Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EEB6E42A83D
	for <lists+netdev@lfdr.de>; Tue, 12 Oct 2021 17:27:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237418AbhJLP3H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Oct 2021 11:29:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:54076 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229633AbhJLP3H (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 12 Oct 2021 11:29:07 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E92EE601FF;
        Tue, 12 Oct 2021 15:27:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634052425;
        bh=JHsNRkImaZso/PdEhq7lyB1jAuHIPy/YNePO+70974o=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=tfz5lBCZzH0JKgOGsRgMim4fgUflHSc+NzJKbYotcGljbTf7PO2CDwWHuLqWloEnD
         +osAhLbdsiFpEh1r/Ee5+G23epykAedEb9oZuKEzTgjDzoghoVjHwXJaGA6qe+39CA
         VTpVY+qq6hXn1Xh1On+VUZVHkSEVCdVvR869EEhNbjCe+Vrl9VyIalPm17mWpCeE8i
         LMFUAV/LGi2azLF3wmzkS73ciOLK8H4QY9vCvh81OLjBJZY+CWsUS3X+u8/Ux0blXz
         Pv++7boIgmVd1DCPKQUz8qDrke+Hp4zsV0pD9WNp/0emfjx42PgS92v0RZMJ3EBgH4
         w4EkG51zemCbg==
Date:   Tue, 12 Oct 2021 08:27:03 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Alvin =?UTF-8?B?xaBpcHJhZ2E=?= <alvin@pqrs.dk>
Cc:     Linus Walleij <linus.walleij@linaro.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Alvin =?UTF-8?B?xaBpcHJhZ2E=?= <alsi@bang-olufsen.dk>,
        Michael Rasmussen <mir@bang-olufsen.dk>,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 5/6] net: dsa: realtek-smi: add rtl8365mb
 subdriver for RTL8365MB-VC
Message-ID: <20211012082703.7b31e73b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20211012123557.3547280-6-alvin@pqrs.dk>
References: <20211012123557.3547280-1-alvin@pqrs.dk>
        <20211012123557.3547280-6-alvin@pqrs.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 12 Oct 2021 14:35:54 +0200 Alvin =C5=A0ipraga wrote:
> +	{ 0, 4, 2, "dot3StatsFCSErrors" },
> +	{ 0, 6, 2, "dot3StatsSymbolErrors" },
> +	{ 0, 8, 2, "dot3InPauseFrames" },
> +	{ 0, 10, 2, "dot3ControlInUnknownOpcodes" },
...

You must expose counters via existing standard APIs.

You should implement these ethtool ops:

	void	(*get_eth_phy_stats)(struct net_device *dev,
				     struct ethtool_eth_phy_stats *phy_stats);
	void	(*get_eth_mac_stats)(struct net_device *dev,
				     struct ethtool_eth_mac_stats *mac_stats);
	void	(*get_eth_ctrl_stats)(struct net_device *dev,
				      struct ethtool_eth_ctrl_stats *ctrl_stats);
	void	(*get_rmon_stats)(struct net_device *dev,
				  struct ethtool_rmon_stats *rmon_stats,
				  const struct ethtool_rmon_hist_range **ranges);

> +static int rtl8365mb_setup(struct dsa_switch *ds)
> +{
> +	struct realtek_smi *smi =3D ds->priv;
> +	struct rtl8365mb *mb;
> +	int ret;
> +	int i;
> +
> +	mb =3D smi->chip_data;

drivers/net/dsa/rtl8365mb.c:1428:20: warning: variable =E2=80=98mb=E2=80=99=
 set but not used [-Wunused-but-set-variable]
 1428 |  struct rtl8365mb *mb;
      |                    ^~
