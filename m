Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4B9AC54C15A
	for <lists+netdev@lfdr.de>; Wed, 15 Jun 2022 07:55:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242000AbiFOFq7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jun 2022 01:46:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238751AbiFOFq6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jun 2022 01:46:58 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 634D149F83
        for <netdev@vger.kernel.org>; Tue, 14 Jun 2022 22:46:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id B984FCE1CB3
        for <netdev@vger.kernel.org>; Wed, 15 Jun 2022 05:46:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71E93C34115;
        Wed, 15 Jun 2022 05:46:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1655272014;
        bh=aeu4oCaySMh8kK/4nX6TjFwRUUqACCE4H42Q9juPll4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=krt9p2goMD2muqVT6sOCYsSuUR6qH2gXRU+Q8+YAx1fi70oEIYlOt2U3aHBv3e/Vn
         L+M9OkYhxq0T5AgOKnL1RoxQH1ItWcJFHY2zsFdZinv+VZKes2fVl6p3ii+k+9EiLB
         M6W5spZmFyu/UochZ+Wd8LryMByUaBVAjuPc2BGdOLpiYGk2nL7WpnG7W2fDwYSSPn
         EjO5RszmH0qsHXCzjgHKQzA277bnZPrhsJFyrNj479JAR4AyIwtg3Ccyo/o+JlBKgI
         nwrElRYukfEHy7Bmge9GfTrH/RaXHFLQt2entaYqTgkvxzTw6bVpsZ/xMxjAn2wwq7
         hoC4DxIPIDang==
Date:   Tue, 14 Jun 2022 22:46:52 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Marek =?UTF-8?B?QmVow7pu?= <kabel@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>, netdev@vger.kernel.org,
        Paolo Abeni <pabeni@redhat.com>,
        Robert Hancock <robert.hancock@calian.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>
Subject: Re: [PATCH net-next 02/15] net: phylink: add phylink_pcs_inband()
Message-ID: <20220614224652.09d4c287@kernel.org>
In-Reply-To: <E1o0jgF-000JYC-49@rmk-PC.armlinux.org.uk>
References: <Yqc0lxn3ngWSuvdS@shell.armlinux.org.uk>
        <E1o0jgF-000JYC-49@rmk-PC.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 13 Jun 2022 14:00:31 +0100 Russell King (Oracle) wrote:
> +	if (phylink_autoneg_inband(mode) &&
> +	    (interface == PHY_INTERFACE_MODE_SGMII ||
> +	     interface == PHY_INTERFACE_MODE_QSGMII ||
> +	     linkmode_test_bit(ETHTOOL_LINK_MODE_Autoneg_BIT, advertising)))
> +		return true;
> +	else
> +		return false;

Okay, let me be a little annoying...

Could you run thru checkpatch --strict and fix the few whitespace
issues it points out? There's a handful of spaces instead of tabs,
unaligned continuation lines and an unnecessary bracket.

Patch 1 does not need to be backported so I presume it can lose the
fixes tag?

The quoted code can be converted into a direct return of the condition,
I don't really care but I think there are bots out there which will
send a "fix" soon if we commit this.

And patch 10 generates a transient "function should be static" warning.
I think you need a __maybe_unused on mv88e6xxx_pcs_select() as well.
