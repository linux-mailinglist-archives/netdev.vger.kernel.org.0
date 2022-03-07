Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E44844D0A39
	for <lists+netdev@lfdr.de>; Mon,  7 Mar 2022 22:45:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232552AbiCGVpy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Mar 2022 16:45:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230517AbiCGVpy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Mar 2022 16:45:54 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45B18117
        for <netdev@vger.kernel.org>; Mon,  7 Mar 2022 13:44:59 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D686760BA5
        for <netdev@vger.kernel.org>; Mon,  7 Mar 2022 21:44:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECD23C340E9;
        Mon,  7 Mar 2022 21:44:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646689498;
        bh=1ov/le2xqTKCzwg/Lvo9YsLhktyWrDn7aKMhVR5W41Y=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=XnpCAuwiZGW1oGMF8t0VriXJsGpJxXjF82bk/84tKn9qaentzUTFnzsL0bCiOby1A
         d0+qN5ko2BdL9XmYBja9mWEFCh6m50RFXYyrjfE6WQwbOWvEyrWc5TaqLr6hj8GVCY
         Jp+2alZJVWkjePdr9tvtA/tR9kuHlhgRnQcGdEVNTHxsuHO+L0IksRqqLH8ZVFVbba
         Cz7agG0Z7FD48lCEjx/Z94mBefYZJ2U2OJEwDbX1i/Vxv45PAwFzjEwqjJ11c1ZArn
         V5vHLKzM3KsBvVjP95iFpsihDDhSa0Lkru3qovNAijx0WWWTJSe8mssZv5l7y2oM/D
         /OWXzX/2KlKHA==
Date:   Mon, 7 Mar 2022 13:44:56 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Vladimir Oltean <vladimir.oltean@nxp.com>, netdev@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>
Subject: Re: [PATCH v2 net-next] net: dsa: unlock the rtnl_mutex when
 dsa_master_setup() fails
Message-ID: <20220307134456.2bc1e9a1@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20220305123234.z7dotdedlqdsokj6@skbuf>
References: <20220303140840.1818952-1-vladimir.oltean@nxp.com>
        <20220304205659.5e0c6997@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <20220305123234.z7dotdedlqdsokj6@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 5 Mar 2022 14:32:34 +0200 Vladimir Oltean wrote:
> On Fri, Mar 04, 2022 at 08:56:59PM -0800, Jakub Kicinski wrote:
> > On Thu,  3 Mar 2022 16:08:40 +0200 Vladimir Oltean wrote:  
> > > Subject: [PATCH v2 net-next] net: dsa: unlock the rtnl_mutex when dsa_master_setup() fails  
> > 
> > Did you mean s/-next//?  
> 
> I really meant net-next, but now I see that I was wrong.
> What I did was:
> 
> git tag --contains c146f9bc195a
> v5.17-rc1
> v5.17-rc2
> v5.17-rc3
> v5.17-rc4
> v5.17-rc5
> v5.17-rc6
> 
> and from this I drew the incorrect conclusion that the patch was merged
> during the v5.17 rc's, for inclusion in v5.18.

Yeah, git tag --contains is finicky, I gave up on using it :(

The patch appears to now be commit afb3cc1a397d ("net: dsa: unlock the
rtnl_mutex when dsa_master_setup() fails") in net, thanks!
