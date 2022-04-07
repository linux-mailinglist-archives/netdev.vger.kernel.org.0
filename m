Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 377A34F6F29
	for <lists+netdev@lfdr.de>; Thu,  7 Apr 2022 02:26:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232357AbiDGA1w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Apr 2022 20:27:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231775AbiDGA1v (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Apr 2022 20:27:51 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53DE04E398
        for <netdev@vger.kernel.org>; Wed,  6 Apr 2022 17:25:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E082661D7E
        for <netdev@vger.kernel.org>; Thu,  7 Apr 2022 00:25:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1C2CC385A3;
        Thu,  7 Apr 2022 00:25:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649291152;
        bh=u+6TV5IEMFW/3pbpMHVQbKwtXLnbQ8losSM6qCSuTLA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=PPUEY7FWZEWk6JDV2lp76dYnwUgWVC3lc4Pd845/UxphOn2rqTrf86ebgVZxvrifY
         qjHht75+35UAPrbbQGCMAvh3fZSNIG++0e70xEWQzr2n1EVjiT2Lyq9RchcWpjATer
         JpIEU5DG44sGeP7H2z22L+ttn010cfZtzrl5tVp+BOnZIC1/dGHophePAyMvs0ie3n
         suN/u062yOVy6wfWciT9QyjIJPHHRpnVXIgyp7tgRCrXQHfmBEl0u/TuN6AnLiGbAq
         W+LTBr96fO3TKWEKxNwKJul3lrVJE5PkJ/vZhI8fI62G9AoLyqKGOkQo5F5sHdMr3A
         xaERPub4gDJBw==
Date:   Wed, 6 Apr 2022 17:25:50 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Robin Murphy <robin.murphy@arm.com>
Subject: Re: [PATCH net] net: mdio: don't defer probe forever if PHY IRQ
 provider is missing
Message-ID: <20220406172550.6408c990@kernel.org>
In-Reply-To: <20220406231956.nwe6kb6vgli2chln@skbuf>
References: <20220406202323.3390405-1-vladimir.oltean@nxp.com>
        <20220406153443.51ad52f8@kernel.org>
        <20220406231956.nwe6kb6vgli2chln@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 6 Apr 2022 23:19:57 +0000 Vladimir Oltean wrote:
> On Wed, Apr 06, 2022 at 03:34:43PM -0700, Jakub Kicinski wrote:
> > > +	if (rc == -EPROBE_DEFER)
> > > +		rc = driver_deferred_probe_check_state(&phy->mdio.dev);
> > This one's not exported, allmodconfig build fails.  
> 
> Oops, I didn't realize that all its callers except for FWNODE_MDIO are built-in.
> 
> Do you prefer me exporting the symbol as part of the same patch or a different one?

I presume single patch is fine, but driver_deferred_probe_check_state()
lives in Greg's realm, so let's add Greg in case he prefers a separate
patch or more.
