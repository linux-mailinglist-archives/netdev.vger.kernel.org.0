Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 400B511F835
	for <lists+netdev@lfdr.de>; Sun, 15 Dec 2019 15:55:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726130AbfLOOxz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 15 Dec 2019 09:53:55 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:53702 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726103AbfLOOxz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 15 Dec 2019 09:53:55 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=LlT6ikAggP/C6/7IxxJEB2Gd9SwegvIYZr5x9uHQBWw=; b=pFe41H2zNHB5YsBkI1Q4kOTeUh
        0OqSAAphloxnEVMXUuStQuSZitaN2GnHgZuFaNaR+3ir64/40BL4IwVWX0jmS78NaykWlf8QyB3VH
        LRQvZ5F2pKGOdxcxGewa4uNwM9Owrsn4siLxtV3CCQ3aGmFxwpk5Y3W1H697Caib60io=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.92.2)
        (envelope-from <andrew@lunn.ch>)
        id 1igVHJ-0004ZC-PF; Sun, 15 Dec 2019 15:53:49 +0100
Date:   Sun, 15 Dec 2019 15:53:49 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Baruch Siach <baruch@tkos.co.il>
Cc:     Marek Behun <marek.behun@nic.cz>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        netdev@vger.kernel.org,
        Denis Odintsov <d.odintsov@traviangames.com>,
        Hubert Feurstein <h.feurstein@gmail.com>
Subject: Re: [BUG] mv88e6xxx: tx regression in v5.3
Message-ID: <20191215145349.GB22725@lunn.ch>
References: <20191212131448.GA9959@lunn.ch>
 <20191212150810.zx6o26jnk5croh4r@sapphire.tkos.co.il>
 <20191212151355.GE30053@lunn.ch>
 <20191212152355.iiepmi4cjriddeon@sapphire.tkos.co.il>
 <20191212193611.63111051@nic.cz>
 <20191212190640.6vki2pjfacdnxihh@sapphire.tkos.co.il>
 <20191212193129.GF30053@lunn.ch>
 <20191212204141.16a406cd@nic.cz>
 <8736dlucai.fsf@tarshish>
 <871rt5u9no.fsf@tarshish>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <871rt5u9no.fsf@tarshish>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> This fixes cpu port configuration for me:
> 
> diff --git a/drivers/net/dsa/mv88e6xxx/port.c b/drivers/net/dsa/mv88e6xxx/port.c
> index 7fe256c5739d..a6c320978bcf 100644
> --- a/drivers/net/dsa/mv88e6xxx/port.c
> +++ b/drivers/net/dsa/mv88e6xxx/port.c
> @@ -427,10 +427,6 @@ static int mv88e6xxx_port_set_cmode(struct mv88e6xxx_chip *chip, int port,
>  		cmode = 0;
>  	}
>  
> -	/* cmode doesn't change, nothing to do for us */
> -	if (cmode == chip->ports[port].cmode)
> -		return 0;
> -
>  	lane = mv88e6xxx_serdes_get_lane(chip, port);
>  	if (lane) {
>  		if (chip->ports[port].serdes_irq) {
> 
> Does that make sense?

This needs testing on a 6390, with a port 9 or 10 using fixed link. We
have had issues in the past where mac_config() has been called once
per second, and each time it reconfigured the MAC, causing the link to
go down/up. So we try to avoid doing work which is not requires and
which could upset the link.

      Andrew
