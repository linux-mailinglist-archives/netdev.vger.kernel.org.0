Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 40C70E0F9B
	for <lists+netdev@lfdr.de>; Wed, 23 Oct 2019 03:18:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732669AbfJWBSG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Oct 2019 21:18:06 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:58808 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727140AbfJWBSF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 22 Oct 2019 21:18:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=lB/pNNhTJ43diKpGyF18VM60D7pY2ZFZjbUpQVstNfs=; b=Fu56ism/fOk1V72ugAel3KsbC3
        Pv0HD0a9Aoojt8oJ4xeC8ck47HxTYsYj1eeJRYaAAhls/2xBJjO9gLqLd/RkMIUqzXfzD845yC6qW
        xpwq6CuGc3YPiBRaPJznEiE+nWSh7r3GF6JiK7eR9dWlTrRtVhXfjOIB1r8nZC0a2d+Y=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.92.2)
        (envelope-from <andrew@lunn.ch>)
        id 1iN5Hm-0004TY-WF; Wed, 23 Oct 2019 03:18:03 +0200
Date:   Wed, 23 Oct 2019 03:18:02 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Iwan R Timmer <irtimmer@gmail.com>
Cc:     netdev@vger.kernel.org, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, davem@davemloft.net
Subject: Re: [PATCH net-next v2 2/2] net: dsa: mv88e6xxx: Add support for
 port mirroring
Message-ID: <20191023011802.GI5707@lunn.ch>
References: <20191021210143.119426-1-irtimmer@gmail.com>
 <20191021210143.119426-3-irtimmer@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191021210143.119426-3-irtimmer@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 21, 2019 at 11:01:43PM +0200, Iwan R Timmer wrote:
> Add support for configuring port mirroring through the cls_matchall
> classifier. We do a full ingress and/or egress capture towards a
> capture port. It allows setting a different capture port for ingress
> and egress traffic.
> 
> It keeps track of the mirrored ports and the destination ports to
> prevent changes to the capture port while other ports are being
> mirrored.
> 
> Signed-off-by: Iwan R Timmer <irtimmer@gmail.com>
> ---
>  drivers/net/dsa/mv88e6xxx/chip.c    | 70 +++++++++++++++++++++++++++++
>  drivers/net/dsa/mv88e6xxx/chip.h    |  6 +++
>  drivers/net/dsa/mv88e6xxx/global1.c | 11 ++++-
>  drivers/net/dsa/mv88e6xxx/port.c    | 29 ++++++++++++
>  drivers/net/dsa/mv88e6xxx/port.h    |  2 +
>  5 files changed, 117 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
> index e9735346838d..14e71bc98513 100644
> --- a/drivers/net/dsa/mv88e6xxx/chip.c
> +++ b/drivers/net/dsa/mv88e6xxx/chip.c
> @@ -4921,6 +4921,74 @@ static int mv88e6xxx_port_mdb_del(struct dsa_switch *ds, int port,
>  	return err;
>  }
>  
> +static int mv88e6xxx_port_mirror_add(struct dsa_switch *ds, int port,
> +				     struct dsa_mall_mirror_tc_entry *mirror,
> +				     bool ingress)

This bool is defined by the API to the DSA core, so we cannot do much
to make it easier to understand.

> +	err = mv88e6xxx_port_set_mirror(chip, port, ingress, true);

but here we could use enums for both ingress and this second true.
Maybe the enum i suggested for the previous patch could be more
generic and just represent ingress/egress?

> @@ -228,6 +228,8 @@ struct mv88e6xxx_port {
>  	u64 vtu_miss_violation;
>  	u8 cmode;
>  	unsigned int serdes_irq;
> +	bool mirror_ingress;
> +	bool mirror_egress;
>  };

In terms of structure packing, it might be better to put these two
bools after cmode.

      Andrew
