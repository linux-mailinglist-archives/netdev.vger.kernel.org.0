Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BE90F63C77B
	for <lists+netdev@lfdr.de>; Tue, 29 Nov 2022 19:54:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236232AbiK2Syn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Nov 2022 13:54:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236240AbiK2Syk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Nov 2022 13:54:40 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CDC0F56543;
        Tue, 29 Nov 2022 10:54:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=edg6yT0rXDHR3AgqPgWtrGV1scb1jUJMvYpN3NYcYxc=; b=HKIx5XvFKKM7ppI2tPkpVmtQPC
        8wkBhJB6afDbL4Ca0JaMjC92N0OdfZUppHo3G+I1/SJ/ZG+1JGprsyi3+CW8YGswqWdO78pq1C3eG
        bq6lw+rBomzgbfCp9quEwkjDrVTvtIW755LfyiV0mIHT1cdZvFqvg+7jCOoM8GXPMNZ0=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1p05kW-003u7m-7Z; Tue, 29 Nov 2022 19:54:32 +0100
Date:   Tue, 29 Nov 2022 19:54:32 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, Ioana Ciornei <ioana.ciornei@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Russell King <linux@armlinux.org.uk>,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 07/12] net: dpaa2: publish MAC stringset to
 ethtool -S even if MAC is missing
Message-ID: <Y4ZVaA1pNEvqcNud@lunn.ch>
References: <20221129141221.872653-1-vladimir.oltean@nxp.com>
 <20221129141221.872653-8-vladimir.oltean@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221129141221.872653-8-vladimir.oltean@nxp.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 29, 2022 at 04:12:16PM +0200, Vladimir Oltean wrote:
> DPNIs and DPSW objects can connect and disconnect at runtime from DPMAC
> objects on the same fsl-mc bus. The DPMAC object also holds "ethtool -S"
> unstructured counters. Those counters are only shown for the entity
> owning the netdev (DPNI, DPSW) if it's connected to a DPMAC.
> 
> The ethtool stringset code path is split into multiple callbacks, but
> currently, connecting and disconnecting the DPMAC takes the rtnl_lock().
> This blocks the entire ethtool code path from running, see
> ethnl_default_doit() -> rtnl_lock() -> ops->prepare_data() ->
> strset_prepare_data().
> 
> This is going to be a problem if we are going to no longer require
> rtnl_lock() when connecting/disconnecting the DPMAC, because the DPMAC
> could appear between ops->get_sset_count() and ops->get_strings().
> If it appears out of the blue, we will provide a stringset into an array
> that was dimensioned thinking the DPMAC wouldn't be there => array
> accessed out of bounds.
> 
> There isn't really a good way to work around that, and I don't want to
> put too much pressure on the ethtool framework by playing locking games.
> Just make the DPMAC counters be always available. They'll be zeroes if
> the DPNI or DPSW isn't connected to a DPMAC.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
