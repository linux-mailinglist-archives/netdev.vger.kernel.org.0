Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BBD7552A968
	for <lists+netdev@lfdr.de>; Tue, 17 May 2022 19:38:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351510AbiEQRiF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 May 2022 13:38:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351501AbiEQRiD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 May 2022 13:38:03 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6EC2D3A18E;
        Tue, 17 May 2022 10:38:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 343A6B81B18;
        Tue, 17 May 2022 17:38:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82BF6C385B8;
        Tue, 17 May 2022 17:37:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652809080;
        bh=eHifGayDG02quoV3KcJSM+PxEDMZbY8lAV/ptLfgFvM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=I5kAF3I/AUbaMnhhKAimpquiSrx5qPouEKWy+HiK6ll1MuFC+ZQ/CRNvNLRMxWWiv
         OrdhZaLWneMrYP8oaN1bqO29C0RQCkLY2a7BsSB+/lAn9UcZpJ+8ExeBuA45n0Y2Ui
         LlEFcrQ1rI34YVg7s100GRSK9jDE7hNzV/X1rUBUHpZmLBADNzm6w4hVP9/cl0KZwP
         8XNxUeLUfyuUO9mb5zFChF3PvCVunKudgTXZltGi3atXRWlqYLRLzFrttc4JNZuRma
         F/pxcMYztZPQOHcwCvnX4d/HKYKGnEkVRax6QUemNClmKfA95fQP+fZfa/VEV7dFZr
         sv8ohsqoDSuPw==
Date:   Tue, 17 May 2022 10:37:58 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     Florian Fainelli <f.fainelli@gmail.com>, davem@davemloft.net,
        netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        alex.aring@gmail.com, stefan@datenfreihafen.org,
        mareklindner@neomailbox.ch, sw@simonwunderlich.de, a@unstable.cc,
        sven@narfation.org, linux-wireless@vger.kernel.org,
        linux-wpan@vger.kernel.org
Subject: Re: [PATCH net-next] net: ifdefy the wireless pointers in struct
 net_device
Message-ID: <20220517103758.353c2476@kernel.org>
In-Reply-To: <74bdbec0580ed05d0f18533eae9af50bc0a4a0ef.camel@sipsolutions.net>
References: <20220516215638.1787257-1-kuba@kernel.org>
        <8e9f1b04-d17b-2812-22bb-e62b5560aa6e@gmail.com>
        <74bdbec0580ed05d0f18533eae9af50bc0a4a0ef.camel@sipsolutions.net>
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

On Tue, 17 May 2022 09:48:24 +0200 Johannes Berg wrote:
> On Mon, 2022-05-16 at 19:12 -0700, Florian Fainelli wrote:
> > 
> > On 5/16/2022 2:56 PM, Jakub Kicinski wrote:  
> > > Most protocol-specific pointers in struct net_device are under
> > > a respective ifdef. Wireless is the notable exception. Since
> > > there's a sizable number of custom-built kernels for datacenter
> > > workloads which don't build wireless it seems reasonable to
> > > ifdefy those pointers as well.
> > > 
> > > While at it move IPv4 and IPv6 pointers up, those are special
> > > for obvious reasons.
> > > 
> > > Signed-off-by: Jakub Kicinski <kuba@kernel.org>  
> > 
> > Could not we move to an union of pointers in the future since in many 
> > cases a network device can only have one of those pointers at any given 
> > time?  
> 
> Then at the very least we'd need some kind of type that we can assign to
> disambiguate, because today e.g. we have a netdev notifier (and other
> code) that could get a non-wireless netdev and check like this:
> 
> static int cfg80211_netdev_notifier_call(struct notifier_block *nb,
>                                          unsigned long state, void *ptr)
> {
>         struct net_device *dev = netdev_notifier_info_to_dev(ptr);
>         struct wireless_dev *wdev = dev->ieee80211_ptr;
> [...]
>         if (!wdev)
>                 return NOTIFY_DONE;

Can we use enum netdev_ml_priv_type netdev::ml_priv and
netdev::ml_priv_type for this?
