Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B97E25B0FDF
	for <lists+netdev@lfdr.de>; Thu,  8 Sep 2022 00:36:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229688AbiIGWga (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Sep 2022 18:36:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229535AbiIGWg3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Sep 2022 18:36:29 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C5AD8980D
        for <netdev@vger.kernel.org>; Wed,  7 Sep 2022 15:36:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=xffrmXpJPrhu+9xL7p3pMXRSj8cblTFtyWCSFz8oR6s=; b=hNOlrKe4BlUG9h8rLTuFg1aqFm
        26iY4YYC62opfUnFMW0WltvWbpJKx29uTovI/CZyhDj4ODqX9pd2ii0hx0bEdwkF6a/qlWarH2MDh
        NLal9dd+QHj5iYJia9agS4I9Y9b+/XRv4OZTIZ4yG1flKl5B1fqoluHrYLYNgwKYPQoY=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1oW3ej-00FuNK-3n; Thu, 08 Sep 2022 00:36:25 +0200
Date:   Thu, 8 Sep 2022 00:36:25 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Mattias Forsblad <mattias.forsblad@gmail.com>
Cc:     netdev@vger.kernel.org, Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Subject: Re: [PATCH net-next v5 5/6] net: dsa: mv88e6xxx: rmon: Use RMU for
 reading RMON data
Message-ID: <Yxkc6Zav7XoKRLBt@lunn.ch>
References: <20220907072950.2329571-1-mattias.forsblad@gmail.com>
 <20220907072950.2329571-6-mattias.forsblad@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220907072950.2329571-6-mattias.forsblad@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> @@ -430,6 +431,7 @@ struct mv88e6xxx_bus_ops {
>  	int (*read)(struct mv88e6xxx_chip *chip, int addr, int reg, u16 *val);
>  	int (*write)(struct mv88e6xxx_chip *chip, int addr, int reg, u16 val);
>  	int (*init)(struct mv88e6xxx_chip *chip);
> +	int (*get_rmon)(struct mv88e6xxx_chip *chip, int port, uint64_t *data);
>  };

I think you can make this a lot cleaner. You are adding this get_rmon
op here. Add it to mv88e6xxx_smi_indirect_ops,
mv88e6xxx_smi_direct_ops, and mv88e6xxx_smi_dual_direct_ops, calling
the MDIO version.

Then the top level mv88e6xxx_get_ethtool_stats() just calls the
get_rmon() method in mv88e6xxx_bus_ops.

Notice how mv88e6xxx_smi_init() sets chip->smi_ops depending on the
chip type. What you can do is when RMU is successfully enabled,
replace chip->smi_ops with a version which goes via RMU. You can keep
.read and .write pointing to the MDIO versions for the moment, until
they also use RMU.

Doing it like this removes all the checking is RMU setup or not.

      Andrew
