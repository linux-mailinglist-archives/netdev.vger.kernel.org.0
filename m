Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 728A968F9CE
	for <lists+netdev@lfdr.de>; Wed,  8 Feb 2023 22:38:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231871AbjBHViF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Feb 2023 16:38:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229478AbjBHViD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Feb 2023 16:38:03 -0500
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF5401F486;
        Wed,  8 Feb 2023 13:38:01 -0800 (PST)
Received: by mail-ed1-x52b.google.com with SMTP id m8so319965edd.10;
        Wed, 08 Feb 2023 13:38:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=+kHAo7pUsz47M7REuOPPx86y3RMC7ScF41yXDPOXJyw=;
        b=QzXDjfY4hGJw3Wyp4iK+5XolO97mys7vOd6mv6qg79LkgVrTEsqhZJgK/xJ4Fgp4W1
         j22TSQ2dCb8ufSb/TSxBWCqY4x9I/VUjgp6gl/htLS5TZRUTHhpg8vFm8hYKxvnD7Ex0
         iS0fE/DXWsxPAnhn3qjMdVWSd0UbPVRCCFjxLqcizykPGTVU1cGTXLjJWDgmAkP1cQ+O
         HEkd1niW9zHTZGPETt149R2RrFLq7xN/mmnUf/xh+1GZ/sDmE8dZrNuEzubVjhqXJ9wt
         mTrjEtJ6EIFNOqG9omvD6btiOVxgVaxRHHcKNZTDCWVAYpvxk92Yw2pfkIEcLkA13F/w
         cZYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=+kHAo7pUsz47M7REuOPPx86y3RMC7ScF41yXDPOXJyw=;
        b=V412VK2sXFcahqkzCq6Jvbzsk7J4ajUsgbcX/epXBffqVxs8oknh5fC1MBUtWVf/3N
         PWSAozQ6zJ4Za+vdUdWU4XtSwvYUi6oS1y5PimQJiVubyvvmX22DaHE9auOdnNBvJnYK
         2JFWuCwBGihb5khjCyxZYbBNakemlddXRoEMhGwl0t2vnywayBf4xcaFBioJjRMGAh88
         rWs6/4JTyPIVZykilGA/0yz7tPQpncMSazd37eVSstzwixwxEeBLHQc/ME+MUtqOLoHa
         x8yJDwslRjzKd/Ml4LO1t4Fc857RlldDE0idOpJHF5yBFSWHLMXUJ9GmoR4CkFajk7lJ
         lXKQ==
X-Gm-Message-State: AO0yUKXvEXqsVMtcfIW3q/Yv0HLafMqo8RbIuYH/nwsZD62nYr1pvJJ5
        nE+wItZkY00W8cVfcNR/mOo=
X-Google-Smtp-Source: AK7set+PoQ0F3NPOI2Ma1IMmy+eJeF9VpB4ejpFa7UU68AhrBZmYRq7hP40ewGLknm5mU+FvmM8zsA==
X-Received: by 2002:a50:998b:0:b0:4aa:b2d9:9b86 with SMTP id m11-20020a50998b000000b004aab2d99b86mr9644124edb.26.1675892280173;
        Wed, 08 Feb 2023 13:38:00 -0800 (PST)
Received: from skbuf ([188.26.185.183])
        by smtp.gmail.com with ESMTPSA id e16-20020a50a690000000b004aad0a9144fsm2593501edc.51.2023.02.08.13.37.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Feb 2023 13:37:59 -0800 (PST)
Date:   Wed, 8 Feb 2023 23:37:57 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     =?utf-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <clement.leger@bootlin.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Herve Codina <herve.codina@bootlin.com>,
        =?utf-8?Q?Miqu=C3=A8l?= Raynal <miquel.raynal@bootlin.com>,
        Milan Stevanovic <milan.stevanovic@se.com>,
        Jimmy Lalande <jimmy.lalande@se.com>,
        Pascal Eberhard <pascal.eberhard@se.com>,
        Arun Ramadoss <Arun.Ramadoss@microchip.com>,
        linux-renesas-soc@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v3 1/3] net: dsa: rzn1-a5psw: use
 a5psw_reg_rmw() to modify flooding resolution
Message-ID: <20230208213757.iyofbkmvww6r4luy@skbuf>
References: <20230208161749.331965-1-clement.leger@bootlin.com>
 <20230208161749.331965-2-clement.leger@bootlin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230208161749.331965-2-clement.leger@bootlin.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 08, 2023 at 05:17:47PM +0100, Clément Léger wrote:
> .port_bridge_flags will be added and allows to modify the flood mask
> independently for each port. Keeping the existing bridged_ports write
> in a5psw_flooding_set_resolution() would potentially messed up this.
> Use a read-modify-write to set that value and move bridged_ports
> handling in bridge_port_join/leave.
> 
> Signed-off-by: Clément Léger <clement.leger@bootlin.com>
> ---
>  drivers/net/dsa/rzn1_a5psw.c | 12 ++++++------
>  1 file changed, 6 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/net/dsa/rzn1_a5psw.c b/drivers/net/dsa/rzn1_a5psw.c
> index 919027cf2012..8b7d4a371f8b 100644
> --- a/drivers/net/dsa/rzn1_a5psw.c
> +++ b/drivers/net/dsa/rzn1_a5psw.c
> @@ -299,13 +299,9 @@ static void a5psw_flooding_set_resolution(struct a5psw *a5psw, int port,
>  			A5PSW_MCAST_DEF_MASK};
>  	int i;
>  
> -	if (set)
> -		a5psw->bridged_ports |= BIT(port);
> -	else
> -		a5psw->bridged_ports &= ~BIT(port);
> -
>  	for (i = 0; i < ARRAY_SIZE(offsets); i++)
> -		a5psw_reg_writel(a5psw, offsets[i], a5psw->bridged_ports);
> +		a5psw_reg_rmw(a5psw, offsets[i], BIT(port),
> +			      set ? BIT(port) : 0);
>  }
>  
>  static int a5psw_port_bridge_join(struct dsa_switch *ds, int port,
> @@ -326,6 +322,8 @@ static int a5psw_port_bridge_join(struct dsa_switch *ds, int port,
>  	a5psw_flooding_set_resolution(a5psw, port, true);
>  	a5psw_port_mgmtfwd_set(a5psw, port, false);
>  
> +	a5psw->bridged_ports |= BIT(port);
> +
>  	return 0;
>  }
>  
> @@ -334,6 +332,8 @@ static void a5psw_port_bridge_leave(struct dsa_switch *ds, int port,
>  {
>  	struct a5psw *a5psw = ds->priv;
>  
> +	a5psw->bridged_ports &= ~BIT(port);
> +
>  	a5psw_flooding_set_resolution(a5psw, port, false);
>  	a5psw_port_mgmtfwd_set(a5psw, port, true);
>  
> -- 
> 2.39.0
> 

What about the a5psw_flooding_set_resolution() call for the CPU port, from a5psw_setup()?
Isn't this an undocumented change? Does this logic in a5psw_port_bridge_leave() still work,
now that bridged_ports will no longer contain BIT(A5PSW_CPU_PORT)?

	/* No more ports bridged */
	if (a5psw->bridged_ports == BIT(A5PSW_CPU_PORT))
		a5psw->br_dev = NULL;
