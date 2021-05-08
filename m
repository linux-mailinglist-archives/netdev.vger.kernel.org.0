Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D628377370
	for <lists+netdev@lfdr.de>; Sat,  8 May 2021 19:46:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229591AbhEHRrK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 8 May 2021 13:47:10 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:59486 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229523AbhEHRrJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 8 May 2021 13:47:09 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1lfR1f-003Hxv-42; Sat, 08 May 2021 19:46:03 +0200
Date:   Sat, 8 May 2021 19:46:03 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Ansuel Smith <ansuelsmth@gmail.com>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH net-next v4 08/28] net: dsa: qca8k: handle error with
 qca8k_read operation
Message-ID: <YJbOWw3q6rYG/wcV@lunn.ch>
References: <20210508002920.19945-1-ansuelsmth@gmail.com>
 <20210508002920.19945-8-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210508002920.19945-8-ansuelsmth@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

>  static int
>  qca8k_fdb_next(struct qca8k_priv *priv, struct qca8k_fdb *fdb, int port)
>  {
> -	int ret;
> +	int ret, ret_read;
>  
>  	qca8k_fdb_write(priv, fdb->vid, fdb->port_mask, fdb->mac, fdb->aging);
>  	ret = qca8k_fdb_access(priv, QCA8K_FDB_NEXT, port);
> -	if (ret >= 0)
> -		qca8k_fdb_read(priv, fdb);
> +	if (ret >= 0) {
> +		ret_read = qca8k_fdb_read(priv, fdb);
> +		if (ret_read < 0)
> +			return ret_read;
> +	}

This is O.K, but it is a bit of an odd structure. How about

  	qca8k_fdb_write(priv, fdb->vid, fdb->port_mask, fdb->mac, fdb->aging);
	ret = qca8k_fdb_access(priv, QCA8K_FDB_NEXT, port);
	if (ret < 0)
		return ret;

	return qca8k_fdb_read(priv, fdb);
}

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
