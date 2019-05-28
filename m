Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 410962C80B
	for <lists+netdev@lfdr.de>; Tue, 28 May 2019 15:45:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727554AbfE1NpE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 May 2019 09:45:04 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:35436 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727090AbfE1NpD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 28 May 2019 09:45:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=v8rsP2R8PtTOiYNMg+AH6ULR38KzTJtcVg1hTMGe/FQ=; b=W2MfJnxvxkqjI8/Elz3gKtqHV4
        zbUlNH5nPGoJz2AbDZa0fl1wH+qgsXTXZcpcMGeH0TcOv0ZvHjPDj7aPfBqUXfRB+sqwgbg2tmHBL
        GMA5Bv0CR8EdJZge67WN6jJmtROq3wBOpbC7n60qddNILHuox/2ufS9FAam8EY16OtLM=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hVcPS-0006hs-Ep; Tue, 28 May 2019 15:44:58 +0200
Date:   Tue, 28 May 2019 15:44:58 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Rasmus Villemoes <rasmus.villemoes@prevas.dk>
Cc:     Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Rasmus Villemoes <Rasmus.Villemoes@prevas.se>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] net: dsa: mv88e6xxx: fix handling of upper half of
 STATS_TYPE_PORT
Message-ID: <20190528134458.GE18059@lunn.ch>
References: <20190528131701.23912-1-rasmus.villemoes@prevas.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190528131701.23912-1-rasmus.villemoes@prevas.dk>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 28, 2019 at 01:17:10PM +0000, Rasmus Villemoes wrote:
> Currently, the upper half of a 4-byte STATS_TYPE_PORT statistic ends
> up in bits 47:32 of the return value, instead of bits 31:16 as they
> should.
> 
> Signed-off-by: Rasmus Villemoes <rasmus.villemoes@prevas.dk>

Hi Rasmus

Please include a Fixes tag, to indicate where the problem was
introduced. In this case, i think it was:

Fixes: 6e46e2d821bb ("net: dsa: mv88e6xxx: Fix u64 statistics")

And set the Subject to [PATCH net] to indicate this should be applied
to the net tree.

> ---
> I also noticed that it's a bit inconsistent that we return U64_MAX if
> there's a read error in STATS_TYPE_PORT, while
> mv88e6xxx_g1_stats_read() returns 0 in case of a read error. In
> practice, register reads probably never fail so it doesn't matter.
> 
>  drivers/net/dsa/mv88e6xxx/chip.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
> index 370434bdbdab..317553d2cb21 100644
> --- a/drivers/net/dsa/mv88e6xxx/chip.c
> +++ b/drivers/net/dsa/mv88e6xxx/chip.c
> @@ -785,7 +785,7 @@ static uint64_t _mv88e6xxx_get_ethtool_stat(struct mv88e6xxx_chip *chip,
>  			err = mv88e6xxx_port_read(chip, port, s->reg + 1, &reg);
>  			if (err)
>  				return U64_MAX;
> -			high = reg;
> +			low |= ((u32)reg) << 16;
>  		}
>  		break;
>  	case STATS_TYPE_BANK1:

What i don't like about this is how the function finishes:

       	}
        value = (((u64)high) << 32) | low;
        return value;
}

A better fix might be

-		break
+		value = (((u64)high) << 16 | low;
+		return value;

	Andrew	
