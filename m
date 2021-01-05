Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 086CA2EAA86
	for <lists+netdev@lfdr.de>; Tue,  5 Jan 2021 13:17:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727855AbhAEMQJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Jan 2021 07:16:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:47766 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726231AbhAEMQI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 5 Jan 2021 07:16:08 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7C0552229C;
        Tue,  5 Jan 2021 12:15:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1609848928;
        bh=0rbmmR3ReQPovsOtuTvxe8cg7v1K8KmXSbOOlTtcfns=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=JdH+68mQjXlgLypOMEbUt6T4g0JvpINZgwGt5Im1IC+J3FbpEVd3xMQs0o92AEaBz
         8ayThEF76lz768Jl+kr8OL+Po5G2LWNEemS0gXnp3xZeYvqxirGvC3SC0RRdzWYkl6
         kv6w0WfiGNO5rn3VzWMLyH+MVKECv/AuIQSnzg9x/M/uPiEqXmHXSaDwFA+UYMcpOU
         4vUdS502O1s1mIiyt3q1kAA2zfDYKc6F7CYKsY8JCTfIFgBC4gpTGcBVnOCWuX3iDi
         QjMLh408xD64RIGTs1RI4o8wGxka4gN6T7PWhdDURHm51LMAyTmsXESLDPAMCjYVkx
         BnBLiy3wRvJww==
Date:   Tue, 5 Jan 2021 13:15:00 +0100
From:   Marek =?UTF-8?B?QmVow7pu?= <kabel@kernel.org>
To:     Pavana Sharma <pavana.sharma@digi.com>
Cc:     kuba@kernel.org, andrew@lunn.ch, ashkan.boldaji@digi.com,
        clang-built-linux@googlegroups.com, davem@davemloft.net,
        devicetree@vger.kernel.org, f.fainelli@gmail.com,
        gregkh@linuxfoundation.org, kbuild-all@lists.01.org,
        linux-kernel@vger.kernel.org, lkp@intel.com,
        netdev@vger.kernel.org, robh+dt@kernel.org,
        vivien.didelot@gmail.com
Subject: Re: [net-next PATCH v12 4/4] net: dsa: mv88e6xxx: Add support for
 mv88e6393x  family of Marvell
Message-ID: <20210105131343.4d0fff05@nic.cz>
In-Reply-To: <2c2bb4b92484ce21c0cf43076d6c7921bae7456a.1607685097.git.pavana.sharma@digi.com>
References: <cover.1607685096.git.pavana.sharma@digi.com>
        <2c2bb4b92484ce21c0cf43076d6c7921bae7456a.1607685097.git.pavana.sharma@digi.com>
X-Mailer: Claws Mail 3.17.7 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 11 Dec 2020 22:51:01 +1000
Pavana Sharma <pavana.sharma@digi.com> wrote:

> +int mv88e6393x_serdes_irq_enable(struct mv88e6xxx_chip *chip, int port,
> +				int lane, bool enable)
> +{
> +	u8 cmode = chip->ports[port].cmode;
> +	int err = 0;
> +
> +	switch (cmode) {
> +	case MV88E6XXX_PORT_STS_CMODE_SGMII:
> +	case MV88E6XXX_PORT_STS_CMODE_1000BASEX:
> +	case MV88E6XXX_PORT_STS_CMODE_2500BASEX:
> +	case MV88E6XXX_PORT_STS_CMODE_5GBASER:
> +	case MV88E6XXX_PORT_STS_CMODE_10GBASER:
> +		err = mv88e6390_serdes_irq_enable_sgmii(chip, lane, enable);
> +	}

This is wrong. IRQ for 5gbase-r and 10gbase-r is enabled differently.
Please look at how I did it in my proposal
https://www.mail-archive.com/netdev@vger.kernel.org/msg347854.html
Please look at the following functions in that patch:

   mv88e6393x_serdes_irq_enable_10g()
   mv88e6393x_serdes_irq_enable()
   mv88e6393x_serdes_irq_status_10g()
   irqreturn_t mv88e6393x_serdes_irq_status()

and also at the constants added to serdes.h in that patch

#define MV88E6393X_10G_INT_ENABLE      0x9000
#define MV88E6393X_10G_INT_LINK_CHANGE BIT(2)
#define MV88E6393X_10G_INT_STATUS      0x9001
