Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E851062A492
	for <lists+netdev@lfdr.de>; Tue, 15 Nov 2022 22:57:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231499AbiKOV5n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Nov 2022 16:57:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229731AbiKOV5l (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Nov 2022 16:57:41 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6AFEE30563
        for <netdev@vger.kernel.org>; Tue, 15 Nov 2022 13:57:41 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 06FDA61A47
        for <netdev@vger.kernel.org>; Tue, 15 Nov 2022 21:57:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D8D6C433C1;
        Tue, 15 Nov 2022 21:57:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668549460;
        bh=PhHq9gYFOhnmkSE9sxpEYnragsYTRi53MDR0OZm6TKk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=iMGFViu3l/KZZRNn+4oO/dr8nadYoUwvd8fsRT3kFmMYwZuM93bxcM65IH70bNV2g
         eEAr0Sbe2a6uaIhzs3knhzZumP/VFVIyKfgM2/+xgsiXyX+YSIJ+LfdoOoQ7TttxPb
         EBW78etyonvw8MD/9ZknmuLRX1BsqjmZjaZE6+6K6CUe19smks/RadY8uKJS29IG8s
         yJC3Rr+NLzF4Yt25T/tvi7TLKr+QhczlOIYlqkVm2x4tFEkvFwZP4fbOah9i3lJ/hR
         Q0d6ONJ68uew5Gy+meKl/T3Ltcv/E7D/AjJW5pkzIQjEwRAnmQblMlbv+1dB/dIcvI
         gSQ3SP8HtmB+A==
Date:   Tue, 15 Nov 2022 13:57:33 -0800
From:   Saeed Mahameed <saeed@kernel.org>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Subject: Re: [PATCH net] net: dsa: don't leak tagger-owned storage on switch
 driver unbind
Message-ID: <Y3QLTSeHa8l+nCm9@x130.lan>
References: <20221114143551.1906361-1-vladimir.oltean@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20221114143551.1906361-1-vladimir.oltean@nxp.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 14 Nov 16:35, Vladimir Oltean wrote:
>In the initial commit dc452a471dba ("net: dsa: introduce tagger-owned
>storage for private and shared data"), we had a call to
>tag_ops->disconnect(dst) issued from dsa_tree_free(), which is called at
>tree teardown time.
>
>There were problems with connecting to a switch tree as a whole, so this
>got reworked to connecting to individual switches within the tree. In
>this process, tag_ops->disconnect(ds) was made to be called only from
>switch.c (cross-chip notifiers emitted as a result of dynamic tag proto
>changes), but the normal driver teardown code path wasn't replaced with
>anything.
>
>Solve this problem by adding a function that does the opposite of
>dsa_switch_setup_tag_protocol(), which is called from the equivalent
>spot in dsa_switch_teardown(). The positioning here also ensures that we
>won't have any use-after-free in tagging protocol (*rcv) ops, since the
>teardown sequence is as follows:
>
>dsa_tree_teardown
>-> dsa_tree_teardown_master
>   -> dsa_master_teardown
>      -> unsets master->dsa_ptr, making no further packets match the
>         ETH_P_XDSA packet type handler
>-> dsa_tree_teardown_ports
>   -> dsa_port_teardown
>      -> dsa_slave_destroy
>         -> unregisters DSA net devices, there is even a synchronize_net()
>            in unregister_netdevice_many()
>-> dsa_tree_teardown_switches
>   -> dsa_switch_teardown
>      -> dsa_switch_teardown_tag_protocol
>         -> finally frees the tagger-owned storage
>
>Fixes: 7f2973149c22 ("net: dsa: make tagging protocols connect to individual switches from a tree")
>Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Saeed Mahameed <saeed@kernel.org>

