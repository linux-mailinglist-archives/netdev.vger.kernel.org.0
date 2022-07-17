Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D115A577729
	for <lists+netdev@lfdr.de>; Sun, 17 Jul 2022 17:50:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230182AbiGQPuV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 17 Jul 2022 11:50:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229508AbiGQPuU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 17 Jul 2022 11:50:20 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94BA6DF69
        for <netdev@vger.kernel.org>; Sun, 17 Jul 2022 08:50:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=sXVxmA8JyjLAmyVzGlM6JyvEoPNZ5zdlWKV8yMLc03w=; b=AiBmcTn2dh/L1qK1z1Lawc8Bf0
        0ft5Qd9hraFyyPP0C81qx8uQzqLpwT2ZdTATxyBa7geILK7vB/v+8mV7UG36ptd8DoGLLSMVAd/md
        azKSBRIauws2uO9r8WzrGHrUJn5+T9mLAWnyf/r8JmnfkcNLRmYLpHy+ZkbZ2au8U/DU=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1oD6XB-00Ad9h-UO; Sun, 17 Jul 2022 17:50:17 +0200
Date:   Sun, 17 Jul 2022 17:50:17 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>
Subject: Re: [PATCH net 14/15] docs: net: dsa: delete misinformation about
 -EOPNOTSUPP for FDB/MDB/VLAN
Message-ID: <YtQvuadngnYEhSOT@lunn.ch>
References: <20220716185344.1212091-1-vladimir.oltean@nxp.com>
 <20220716185344.1212091-15-vladimir.oltean@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220716185344.1212091-15-vladimir.oltean@nxp.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jul 16, 2022 at 09:53:43PM +0300, Vladimir Oltean wrote:
> Returning -EOPNOTSUPP does *NOT* mean anything special.
> 
> port_vlan_add() is actually called from 2 code paths, one is
> vlan_vid_add() from 8021q module and the other is
> br_switchdev_port_vlan_add() from switchdev.
> 
> The bridge has a wrapper __vlan_vid_add() which first tries via
> switchdev, then if that returns -EOPNOTSUPP, tries again via the VLAN RX
> filters in the 8021q module. But DSA doesn't distinguish between one
> call path and the other when calling the driver's port_vlan_add(), so if
> the driver returns -EOPNOTSUPP to switchdev, it also returns -EOPNOTSUPP
> to the 8021q module. And the latter is a hard error.
> 
> port_fdb_add() is called from the deferred dsa_owq only, so obviously
> its return code isn't propagated anywhere, and cannot be interpreted in
> any way.
> 
> The return code from port_mdb_add() is propagated to the bridge, but
> again, this doesn't do anything special when -EOPNOTSUPP is returned,
> but rather, br_switchdev_mdb_notify() returns void.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
