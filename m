Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 46A7C5B8ADB
	for <lists+netdev@lfdr.de>; Wed, 14 Sep 2022 16:42:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229676AbiINOmm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Sep 2022 10:42:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229585AbiINOml (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Sep 2022 10:42:41 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C46458B76
        for <netdev@vger.kernel.org>; Wed, 14 Sep 2022 07:42:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=8JSaA+d7W4IpaH/iul2bJLk/aaKw4rPtw1r1jLwrOfg=; b=e4aysstR7SW+b4degALgwQbHZp
        hd+CcDrKADYEuyUW7T5fVuqbTaONEXQnm3fRZB7SvPzonCBk7zGdAsYUyj0o8JQFjqTacJVo4WcoH
        wbxUUIArz5+aUld6uj+WJvY0Rr0Rt+P1CrHNHv1Ssqww8S7cUBjbRTXohMwtuWWiGg8o=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1oYTb3-00Gi66-6O; Wed, 14 Sep 2022 16:42:37 +0200
Date:   Wed, 14 Sep 2022 16:42:37 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Mattias Forsblad <mattias.forsblad@gmail.com>
Cc:     netdev@vger.kernel.org, Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, linux@armlinux.org.uk
Subject: Re: [PATCH net-next v11 5/6] net: dsa: mv88e6xxx: rmon: Use RMU for
 reading RMON data
Message-ID: <YyHoXUyBIMyFGZTX@lunn.ch>
References: <20220914053041.1615876-1-mattias.forsblad@gmail.com>
 <20220914053041.1615876-6-mattias.forsblad@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220914053041.1615876-6-mattias.forsblad@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> @@ -1234,16 +1234,30 @@ static int mv88e6xxx_stats_get_stats(struct mv88e6xxx_chip *chip, int port,
>  				     u16 bank1_select, u16 histogram)
>  {
>  	struct mv88e6xxx_hw_stat *stat;
> +	int offset = 0;
> +	u64 high;
>  	int i, j;
>  
>  	for (i = 0, j = 0; i < ARRAY_SIZE(mv88e6xxx_hw_stats); i++) {
>  		stat = &mv88e6xxx_hw_stats[i];
>  		if (stat->type & types) {
> -			mv88e6xxx_reg_lock(chip);
> -			data[j] = _mv88e6xxx_get_ethtool_stat(chip, stat, port,
> -							      bank1_select,
> -							      histogram);
> -			mv88e6xxx_reg_unlock(chip);
> +			if (mv88e6xxx_rmu_available(chip) &&
> +			    !(stat->type & STATS_TYPE_PORT)) {

If i understand you comment to a previous version, the problem here is
STATS_TYPE_PORT. You are falling back to MDIO for those three
statistics. The data sheet for the 6352 shows these statistics are
available at offset 129 and above in the RMU reply.

I looked through the datasheets i have. I don't have a full set, but
all that i have which include the RMU have these statistics at offset
129.

So i think you can remove the fallback to MDIO. That should then allow
you to have a fully independent implementation, making it much
cleaner.

Or do you see other problems i currently don't?

    Andrew

