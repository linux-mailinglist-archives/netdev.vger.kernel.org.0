Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5FB94F69F2
	for <lists+netdev@lfdr.de>; Sun, 10 Nov 2019 16:57:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726964AbfKJP5t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 Nov 2019 10:57:49 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:59032 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726800AbfKJP5s (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 10 Nov 2019 10:57:48 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=3n+pLtElMjjizYjFq07GNTqHxv51NOmHxpiW2z+eMK4=; b=qsJs1PnIWO6isolDY2TUV/qr9v
        TDrLpX0CQVj+Fb0BwDizRYyOP72iwKyAwZcM6Vn/2qSD+quzURtA1/0NbPsbloJg92etSqcKKTJxI
        j2TZRSqXAtexH1KIgNyaHWiURbJ1QLA0et9UylkBP+9ezuFTux5s2Fm0/M2N82o+uORo=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.92.2)
        (envelope-from <andrew@lunn.ch>)
        id 1iTpaz-0006lj-Sm; Sun, 10 Nov 2019 16:57:45 +0100
Date:   Sun, 10 Nov 2019 16:57:45 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Iwan R Timmer <irtimmer@gmail.com>
Cc:     netdev@vger.kernel.org, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, davem@davemloft.net
Subject: Re: [PATCH net-next v3 2/2] net: dsa: mv88e6xxx: Add support for
 port mirroring
Message-ID: <20191110155745.GB25889@lunn.ch>
References: <20191107211114.106310-1-irtimmer@gmail.com>
 <20191107211114.106310-3-irtimmer@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191107211114.106310-3-irtimmer@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 07, 2019 at 10:11:14PM +0100, Iwan R Timmer wrote:
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
>  drivers/net/dsa/mv88e6xxx/chip.c    | 76 +++++++++++++++++++++++++++++
>  drivers/net/dsa/mv88e6xxx/chip.h    |  6 +++
>  drivers/net/dsa/mv88e6xxx/global1.c | 18 +++++--
>  drivers/net/dsa/mv88e6xxx/port.c    | 37 ++++++++++++++
>  drivers/net/dsa/mv88e6xxx/port.h    |  3 ++
>  5 files changed, 136 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
> index dfca0ec35145..ce4503b387a8 100644
> --- a/drivers/net/dsa/mv88e6xxx/chip.c
> +++ b/drivers/net/dsa/mv88e6xxx/chip.c
> @@ -5250,6 +5250,80 @@ static int mv88e6xxx_port_mdb_del(struct dsa_switch *ds, int port,
>  	return err;
>  }
>  
> +static int mv88e6xxx_port_mirror_add(struct dsa_switch *ds, int port,
> +				     struct dsa_mall_mirror_tc_entry *mirror,
> +				     bool ingress)
> +{
> +	struct mv88e6xxx_chip *chip = ds->priv;
> +	enum mv88e6xxx_egress_direction direction = ingress ?
> +						MV88E6XXX_EGRESS_DIR_INGRESS :
> +						MV88E6XXX_EGRESS_DIR_EGRESS;
> +	bool other_mirrors = false;
> +	int i;
> +	int err;

David will complain about reverse christmas tree here, and in other
functions.

Please add my:

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

when you repost.

    Andrew
