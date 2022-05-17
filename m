Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CAB3052A986
	for <lists+netdev@lfdr.de>; Tue, 17 May 2022 19:44:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351577AbiEQRos (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 May 2022 13:44:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237818AbiEQRoq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 May 2022 13:44:46 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD84C4EDD0;
        Tue, 17 May 2022 10:44:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 77C5B6146C;
        Tue, 17 May 2022 17:44:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72A92C385B8;
        Tue, 17 May 2022 17:44:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652809484;
        bh=a6ecI+YK6t5cM5g7o9lfYB2kOKuzTjQtsmRTgpCAMUk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=vPoGzwlwklp8BToV5DpNv2Q8z6R4acgEa0G/iiyIE32cKrbYlsWJsQReWD3nnqrUB
         tS5mVetCpQDsk/oi+zFixfG7wCgo64IRlI2s1LnK4RkGt9SZBcl8A5xE7Yley13X1l
         zp91STWC1iC4pgBXQ9cTFVvw9bBIhtpg5hWYicUv9bkSVAeIoKZXjCySLpfvSG9Oi8
         Nb2lEH7hsAPxYQf81Se0ZLqft7pF7CmCrQ4DXX7K8c1FnwSa/B0OEZWPU+NLAuMw3X
         gJslbqT/wZtyxAttNCqvqU/ixmGWgg7ZXEjnxKtEFNrgmYhByweGFRYVOTnjC9kzzP
         P/KdrwnKFMKfQ==
Date:   Tue, 17 May 2022 10:44:43 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com,
        pabeni@redhat.com, alex.aring@gmail.com, stefan@datenfreihafen.org,
        mareklindner@neomailbox.ch, sw@simonwunderlich.de, a@unstable.cc,
        sven@narfation.org, linux-wireless@vger.kernel.org,
        linux-wpan@vger.kernel.org
Subject: Re: [PATCH net-next] net: ifdefy the wireless pointers in struct
 net_device
Message-ID: <20220517104443.68756db3@kernel.org>
In-Reply-To: <8b9d18e351cc58aed65c4a4c7f12f167984ee088.camel@sipsolutions.net>
References: <20220516215638.1787257-1-kuba@kernel.org>
        <8b9d18e351cc58aed65c4a4c7f12f167984ee088.camel@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 17 May 2022 09:51:31 +0200 Johannes Berg wrote:
> On Mon, 2022-05-16 at 14:56 -0700, Jakub Kicinski wrote:
> > 
> > +#if IS_ENABLED(CONFIG_WIRELESS)
> >  	struct wireless_dev	*ieee80211_ptr;
> > +#endif  
> 
> Technically, you should be able to use CONFIG_CFG80211 here, but in
> practice I'd really hope nobody enables WIRELESS without CFG80211 :)

ack

> > +++ b/include/net/cfg80211.h
> > @@ -8004,10 +8004,7 @@ int cfg80211_register_netdevice(struct net_device *dev);
> >   *
> >   * Requires the RTNL and wiphy mutex to be held.
> >   */
> > -static inline void cfg80211_unregister_netdevice(struct net_device *dev)
> > -{
> > -	cfg80211_unregister_wdev(dev->ieee80211_ptr);
> > -}
> > +void cfg80211_unregister_netdevice(struct net_device *dev);  
> 
> Exported functions aren't free either - I think in this case I'd
> (slightly) prefer the extra ifdef.

fine

> Anyway, we can do this, but I also like Florian's suggestion about the
> union, and sent an attempt at a disambiguation patch there.

Would you be willing to do that as a follow up? Are you talking about
wifi only or all the proto pointers?

As a netdev maintainer I'd like to reduce the divergence in whether 
the proto pointers are ifdef'd or not.
