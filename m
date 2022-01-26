Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E3AC749D655
	for <lists+netdev@lfdr.de>; Thu, 27 Jan 2022 00:45:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230175AbiAZXpY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jan 2022 18:45:24 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:56538 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229451AbiAZXpT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 26 Jan 2022 18:45:19 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=KtETfU1+wqNMppMn4Ma2jeShcVH64evaxx2kWzZVGG8=; b=GUCG7xO1z7VQ6MisHEWzT+utQp
        +DXEPSm1F4TbRCBm2yeQVrAIxBghnENx689AWvbxjbF1eMG6OcFzPZd298SnTDAdWavU4iLSQgZ1v
        V7DHmd8R+cpZAs7mEIOO7ZC5JuPH2Q5lmby54uPTLzMMUDXXn5BzSxYHqDgps4V9LTRI=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1nCryS-002sOg-8K; Thu, 27 Jan 2022 00:45:12 +0100
Date:   Thu, 27 Jan 2022 00:45:12 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Tobias Waldekranz <tobias@waldekranz.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 1/2] net: dsa: mv88e6xxx: Improve performance of
 busy bit polling
Message-ID: <YfHdCDIUvpaYpDSF@lunn.ch>
References: <20220126231239.1443128-1-tobias@waldekranz.com>
 <20220126231239.1443128-2-tobias@waldekranz.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220126231239.1443128-2-tobias@waldekranz.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> @@ -86,12 +86,12 @@ int mv88e6xxx_write(struct mv88e6xxx_chip *chip, int addr, int reg, u16 val)
>  int mv88e6xxx_wait_mask(struct mv88e6xxx_chip *chip, int addr, int reg,
>  			u16 mask, u16 val)
>  {
> +	const unsigned long timeout = jiffies + msecs_to_jiffies(50);
>  	u16 data;
>  	int err;
> -	int i;
>  
>  	/* There's no bus specific operation to wait for a mask */
> -	for (i = 0; i < 16; i++) {
> +	do {
>  		err = mv88e6xxx_read(chip, addr, reg, &data);
>  		if (err)
>  			return err;
> @@ -99,8 +99,8 @@ int mv88e6xxx_wait_mask(struct mv88e6xxx_chip *chip, int addr, int reg,
>  		if ((data & mask) == val)
>  			return 0;
>  
> -		usleep_range(1000, 2000);
> -	}
> +		cpu_relax();
> +	} while (time_before(jiffies, timeout));

I don't know if this is an issue or not...

There are a few bit-banging systems out there. For those, i wonder if
50ms is too short? With the old code, they had 16 chances, no matter
how slow they were. With the new code, if they take 50ms for one
transaction, they don't get a second chance.

But if they have taken 50ms, around 37ms has been spent with the
preamble, start, op, phy address, and register address. I assume at
that point the switch actually looks at the register, and given your
timings, it really should be ready, so a second loop is probably not
required?

O.K, so this seems safe.

     Andrew
