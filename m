Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 796F35AD432
	for <lists+netdev@lfdr.de>; Mon,  5 Sep 2022 15:44:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237754AbiIENnT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Sep 2022 09:43:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237401AbiIENnS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Sep 2022 09:43:18 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A70DC4DB03
        for <netdev@vger.kernel.org>; Mon,  5 Sep 2022 06:43:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=5S2C1qIffrjQm8JT9DUtSSIny+24wVz4QiujzfLR+Lk=; b=rKOMCFXXDHFTuy1qFvyQJihSoR
        sn2s+Z/l37H3NsngO6YIU+eiPPFJSyXFMGuLgKQccMSE5nBdgV22YREgz6M+qRnYXG7AcKnROSxcL
        ngI20T7oOhTo1vlzGWWzpjIPMdbL7n4XiS4NZTRTqqnVrBAgJ3jbS6PUAZF7rpR2DKq0=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1oVCNf-00FeWZ-AF; Mon, 05 Sep 2022 15:43:15 +0200
Date:   Mon, 5 Sep 2022 15:43:15 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Mattias Forsblad <mattias.forsblad@gmail.com>
Cc:     netdev@vger.kernel.org, Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Subject: Re: [PATCH net-next v3 1/2] net: dsa: mv88e6xxx: Add functionality
 for handling RMU frames.
Message-ID: <YxX888IJMul5DOuH@lunn.ch>
References: <20220905131917.3643193-1-mattias.forsblad@gmail.com>
 <20220905131917.3643193-2-mattias.forsblad@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220905131917.3643193-2-mattias.forsblad@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 05, 2022 at 03:19:16PM +0200, Mattias Forsblad wrote:
> The Marvell SOHO family has a secondary channel for sending
> control data other than the ordinary MDIO channel. The
> switch can process specially crafted ethernet frames
> as control frames. Add functionality for creating, sending,
> receiving and processing those frames. This channel is
> best suited for accessing larger data structures in the
> switch.
> Use this control channel for getting RMON counters.
> 
> Signed-off-by: Mattias Forsblad <mattias.forsblad@gmail.com>
> ---
>  drivers/net/dsa/mv88e6xxx/Makefile  |   1 +
>  drivers/net/dsa/mv88e6xxx/chip.c    |  73 +++++--
>  drivers/net/dsa/mv88e6xxx/chip.h    |  21 ++
>  drivers/net/dsa/mv88e6xxx/global1.c |  76 +++++++
>  drivers/net/dsa/mv88e6xxx/global1.h |   3 +
>  drivers/net/dsa/mv88e6xxx/rmu.c     | 310 ++++++++++++++++++++++++++++
>  drivers/net/dsa/mv88e6xxx/rmu.h     |  28 +++
>  include/net/dsa.h                   |  20 +-
>  net/dsa/dsa.c                       |  28 +++
>  net/dsa/dsa2.c                      |   2 +
>  net/dsa/tag_dsa.c                   |  32 ++-

Please try to break this up into lots of small patches, each patch
doing one thing. It is O.K, to add a helper in one patch, and then a
user of that helper in a later patch, for example. You can add the
common code in dsa.c and then in a later patch make use of it. You can
add the rmu_enable code in one patch, and then use it later, etc.

Ideally, you want lots of small patches, each with a good commit
message, all of which are obviously correct.

I've not looked at the details yet of this patch. I will try to do so
later. My main aim at the moment is to get your changes into the right
sort of structure and the right sort of shape.

     Andrew
