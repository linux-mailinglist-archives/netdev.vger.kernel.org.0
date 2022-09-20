Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C9B4B5BF113
	for <lists+netdev@lfdr.de>; Wed, 21 Sep 2022 01:30:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230233AbiITXaG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Sep 2022 19:30:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230060AbiITXaC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Sep 2022 19:30:02 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9CE073DF0A;
        Tue, 20 Sep 2022 16:29:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 129B6B82D83;
        Tue, 20 Sep 2022 23:29:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FB2CC433B5;
        Tue, 20 Sep 2022 23:29:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663716595;
        bh=nD4QLliR2Fg9W839ij/O4HSyRbpGyiFLDJtkdeZ/HeY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=BfwBkfqbihYRed6NuVk9N/7VrgAlWrxMTTnaQQMPx7cebYpFkqsE/ktZQWEHBiYaX
         cwb7Y3AEkerp3zVtNY/ziEbnaENtxPrhGS2KNFOpI3iXxcnGhMvgX70B+w7J7FZ7Qa
         gyI9tRxfZgHOF677hYUGAYQ6JwTXL76IREzWK8r+S2mxTeINADcF+H3zunuUqAWrR0
         aX9eX8dtdd4RMautD7Rb4Nl0d45XaSRDRwrxVHc0ijebPXXz9ay9zNlH78gp7F9lj9
         F37xn7mSvuyaRC4CLmwhHztTmpzkWd8eXwN79QyBkJSDeLNm5wQE7HPnfkuPhJlNC4
         vsHKvmKaq4Txg==
Date:   Tue, 20 Sep 2022 16:29:54 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Nikolay Aleksandrov <razor@blackwall.org>
Cc:     Sevinj Aghayeva <sevinj.aghayeva@gmail.com>,
        netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        aroulin@nvidia.com, sbrivio@redhat.com, roopa@nvidia.com,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org,
        bridge@lists.linux-foundation.org
Subject: Re: [PATCH RFC net-next 0/5] net: vlan: fix bridge binding behavior
 and add selftests
Message-ID: <20220920162954.1f4aaf7b@kernel.org>
In-Reply-To: <78bd0e54-4ee3-bd3c-2154-9eb8b9a70497@blackwall.org>
References: <cover.1663445339.git.sevinj.aghayeva@gmail.com>
        <78bd0e54-4ee3-bd3c-2154-9eb8b9a70497@blackwall.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 20 Sep 2022 12:16:26 +0300 Nikolay Aleksandrov wrote:
> The set looks good to me, the bridge and vlan direct dependency is gone and
> the new notification type is used for passing link type specific info.

IDK, vlan knows it's calling the bridge:

+	if ((vlan->flags ^ old_flags) & VLAN_FLAG_BRIDGE_BINDING &&
+	    netif_is_bridge_master(vlan->real_dev)) {

bridge knows it's vlan calling:

+	if (is_vlan_dev(dev)) {
+		br_vlan_device_event(dev, event, ptr);

going thru the generic NETDEV notifier seems odd.

If this is just to avoid the dependency we can perhaps add a stub 
like net/ipv4/udp_tunnel_stub.c ?

> If the others are ok with it I think you can send it as non-RFC, but I'd give it
> a few more days at least. :)
