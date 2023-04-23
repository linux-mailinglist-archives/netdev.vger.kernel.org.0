Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D0F626EBE18
	for <lists+netdev@lfdr.de>; Sun, 23 Apr 2023 10:50:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229631AbjDWIuY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 Apr 2023 04:50:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229441AbjDWIuX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 23 Apr 2023 04:50:23 -0400
Received: from mailout-taastrup.gigahost.dk (mailout-taastrup.gigahost.dk [46.183.139.199])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CDEB01733;
        Sun, 23 Apr 2023 01:50:19 -0700 (PDT)
Received: from mailout.gigahost.dk (mailout.gigahost.dk [89.186.169.112])
        by mailout-taastrup.gigahost.dk (Postfix) with ESMTP id 245ED1883692;
        Sun, 23 Apr 2023 08:50:16 +0000 (UTC)
Received: from smtp.gigahost.dk (smtp.gigahost.dk [89.186.169.109])
        by mailout.gigahost.dk (Postfix) with ESMTP id 2043E25003AB;
        Sun, 23 Apr 2023 08:50:16 +0000 (UTC)
Received: by smtp.gigahost.dk (Postfix, from userid 1000)
        id 1060F9B403E2; Sun, 23 Apr 2023 08:50:16 +0000 (UTC)
X-Screener-Id: e32ae469fa6e394734d05373d3a705875723cf1e
Received: from fujitsu (2-104-116-184-cable.dk.customer.tdc.net [2.104.116.184])
        by smtp.gigahost.dk (Postfix) with ESMTPSA id 94AB891201E3;
        Sun, 23 Apr 2023 08:50:15 +0000 (UTC)
From:   Hans Schultz <netdev@kapio-technology.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>, netdev@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Ido Schimmel <idosch@nvidia.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Ivan Vecera <ivecera@redhat.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        bridge@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 net] net: bridge: switchdev: don't notify FDB entries
 with "master dynamic"
In-Reply-To: <20230418155902.898627-1-vladimir.oltean@nxp.com>
References: <20230418155902.898627-1-vladimir.oltean@nxp.com>
Date:   Sun, 23 Apr 2023 10:47:15 +0200
Message-ID: <875y9nt27g.fsf@kapio-technology.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 18, 2023 at 18:59, Vladimir Oltean <vladimir.oltean@nxp.com> wrote:
> diff --git a/net/bridge/br_switchdev.c b/net/bridge/br_switchdev.c
> index de18e9c1d7a7..ba95c4d74a60 100644
> --- a/net/bridge/br_switchdev.c
> +++ b/net/bridge/br_switchdev.c
> @@ -148,6 +148,17 @@ br_switchdev_fdb_notify(struct net_bridge *br,
>  	if (test_bit(BR_FDB_LOCKED, &fdb->flags))
>  		return;
>  
> +	/* Entries with these flags were created using ndm_state == NUD_REACHABLE,
> +	 * ndm_flags == NTF_MASTER( | NTF_STICKY), ext_flags == 0 by something
> +	 * equivalent to 'bridge fdb add ... master dynamic (sticky)'.
> +	 * Drivers don't know how to deal with these, so don't notify them to
> +	 * avoid confusing them.
> +	 */
> +	if (test_bit(BR_FDB_ADDED_BY_USER, &fdb->flags) &&
> +	    !test_bit(BR_FDB_STATIC, &fdb->flags) &&
> +	    !test_bit(BR_FDB_ADDED_BY_EXT_LEARN, &fdb->flags))
> +		return;
> +

I do not understand this patch. It seems to me that it basically blocks
any future use of dynamic fdb entries from userspace towards drivers.

I would have expected that something would be done in the DSA layer,
where (switchcore) drivers would be able to set some flags to indicate
which features are supported by the driver, including non-static
fdb entries. But as the placement here is earlier in the datapath from
userspace towards drivers it's not possible to do any such thing in the
DSA layer wrt non-static fdb entries.
