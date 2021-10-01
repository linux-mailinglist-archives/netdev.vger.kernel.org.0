Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 47B6E41F77D
	for <lists+netdev@lfdr.de>; Sat,  2 Oct 2021 00:39:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240759AbhJAWl1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Oct 2021 18:41:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:57724 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229934AbhJAWl0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 1 Oct 2021 18:41:26 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 49DC461AA4;
        Fri,  1 Oct 2021 22:39:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633127981;
        bh=/ZNVHBu+J2y22coskZNSiZzF8cLnz6K3RaXpYGYiJ3o=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=YVaFgnEY9SZbIq036x+hMolbzO81x5dRGapc2Ez6gp162tFdR140CTflnuAwmkBjk
         ZC78dZrvQ1T1aLUzEtUcZBJo1qjLfVZ5IJgsCrZQZv3O9ZqzXQ1xU66GLmYa72qqZg
         wE1SfAUF0tfsr0YmQfX93llCjIpQnlUBn1c1Zsiv579gzUr/qyNRBLKqMJImY+I8Qo
         3c81Mlu/uL+LYPxmVlweChNLMixWcv9AaDTJ8C0PKNdPSRvH1Jwn+/GVIqajsYGsBU
         F6+i8zV/Kd5VvR33SHOa2PQir/ffvbYId0I9yvfg0AKVudnaC7RmCRpBe9PIm184Xi
         hzxwqMcprScqg==
Date:   Fri, 1 Oct 2021 15:39:40 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     =?UTF-8?B?xYF1a2Fzeg==?= Stelmach <l.stelmach@samsung.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Andrew Lunn <andrew@lunn.ch>, jim.cromie@gmail.com,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Rob Herring <robh+dt@kernel.org>,
        Kukjin Kim <kgene@kernel.org>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org,
        =?UTF-8?B?QmFydMWCb21pZWogxbtvbG5pZXJr?= =?UTF-8?B?aWV3aWN6?= 
        <b.zolnierkie@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>
Subject: Re: [PATCH net-next v16 3/3] net: ax88796c: ASIX AX88796C SPI
 Ethernet Adapter Driver
Message-ID: <20211001153940.28c5d60d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210929140854.28535-4-l.stelmach@samsung.com>
References: <20210929140854.28535-1-l.stelmach@samsung.com>
        <CGME20210929140913eucas1p2e76ab9b78b12d456dc74ab7d54ea81ac@eucas1p2.samsung.com>
        <20210929140854.28535-4-l.stelmach@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 29 Sep 2021 16:08:54 +0200 =C5=81ukasz Stelmach wrote:
> +static char *no_regs_list =3D "80018001,e1918001,8001a001,fc0d0000";

static const char ...

> +static int
> +ax88796c_close(struct net_device *ndev)
> +{
> +	struct ax88796c_device *ax_local =3D to_ax88796c_device(ndev);
> +
> +	netif_stop_queue(ndev);

This can run concurrently with the work which restarts the queue.
You should take the mutex and purge the queue here, so that there=20
is no chance queue will get restarted by the work right after.

> +	phy_stop(ndev->phydev);
> +
> +	mutex_lock(&ax_local->spi_lock);

> +MODULE_AUTHOR("ASIX");

You can drop this, author should be human.
