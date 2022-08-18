Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A58C2598797
	for <lists+netdev@lfdr.de>; Thu, 18 Aug 2022 17:37:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343769AbiHRPgT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Aug 2022 11:36:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343569AbiHRPgQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Aug 2022 11:36:16 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65E53C00C7
        for <netdev@vger.kernel.org>; Thu, 18 Aug 2022 08:36:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=Xn8X8SospVugTd8QNjQDoRAh6YrP5q7TVyjrKFm7znY=; b=TeXnLWhW6mPDdUHPEx6hix1cJe
        AChTpv1jvYjZBxmrB34lMCf8ja1NThoK8Fy2l+cqA23niY8MFmN/hnfEjz6hIarIHLoEBerEppklU
        MeyhhkgVGg4rcOY2wppEUAeg9JnQuLSPunAxHH2f/vVGeM4hMV2o+yarNaOufrO7/RIc=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1oOhZ6-00DlYH-Rl; Thu, 18 Aug 2022 17:36:12 +0200
Date:   Thu, 18 Aug 2022 17:36:12 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Mattias Forsblad <mattias.forsblad@gmail.com>
Cc:     netdev@vger.kernel.org, Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Subject: Re: [RFC net-next PATCH 3/3] mv88e6xxx: rmon: Use RMU to collect
 rmon data.
Message-ID: <Yv5cbL7xUFRo02Bu@lunn.ch>
References: <20220818102924.287719-1-mattias.forsblad@gmail.com>
 <20220818102924.287719-4-mattias.forsblad@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220818102924.287719-4-mattias.forsblad@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> @@ -1310,16 +1323,22 @@ static void mv88e6xxx_get_ethtool_stats(struct dsa_switch *ds, int port,
>  	struct mv88e6xxx_chip *chip = ds->priv;
>  	int ret;
>  
> -	mv88e6xxx_reg_lock(chip);
> +	if (chip->rmu.ops && chip->rmu.ops->get_rmon) {
> +		ret = chip->rmu.ops->get_rmon(chip, port, data);
> +		if (ret == -ETIMEDOUT)
> +			return;
> +	} else {
>  
> -	ret = mv88e6xxx_stats_snapshot(chip, port);
> -	mv88e6xxx_reg_unlock(chip);
> +		mv88e6xxx_reg_lock(chip);
>  
> -	if (ret < 0)
> -		return;
> +		ret = mv88e6xxx_stats_snapshot(chip, port);
> +		mv88e6xxx_reg_unlock(chip);
>  
> -	mv88e6xxx_get_stats(chip, port, data);
> +		if (ret < 0)
> +			return;
>  
> +		mv88e6xxx_get_stats(chip, port, data);
> +	}
>  }

I don't particularly like the way this is all mixed together.

Could you try to split it, so there is an MDIO set of functions and an
RMU set of functions. Maybe you have some helpers which are used by
both.

I would also suggest you try to think about ATU dump and VTU dump. You
ideally want a code structure which is very similar for all these dump
operations. Take a look at how qca8k-8xxx.c does things.

Is it documented in the datasheet that when RMU is used a snapshot is
not required?

    Andrew
