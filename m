Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C90E84AA69B
	for <lists+netdev@lfdr.de>; Sat,  5 Feb 2022 05:34:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379451AbiBEEel (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Feb 2022 23:34:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379420AbiBEEej (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Feb 2022 23:34:39 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99A98C061346
        for <netdev@vger.kernel.org>; Fri,  4 Feb 2022 20:34:38 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 608E1B839AC
        for <netdev@vger.kernel.org>; Sat,  5 Feb 2022 04:34:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DEBBEC340E8;
        Sat,  5 Feb 2022 04:34:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644035676;
        bh=/zQ8Jjke6ZjXrG5uM56xKpDcN3T2apYRAseKmEAdtos=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=FymmMSnKqXu7c873jniS7YWjnptxq4+qqpCZWY5AKghqJhM4xDBrLgBfJ3We0vB4h
         VFrvTd0O1B+TAqdz6xtvkMTy2QyFeKNa9DP7SUhi8i2zpcaUY5Qv2+RdDXd2HZ0v0B
         xhJPLb0rpkS9qT9vzMNCIWozmR/pkSz9BIDe8MCNG9IfBOPH2uT76nQ5Iogc0bc5dc
         hexXkbhMhtb8A3fVwYzWckJU4Ey2+Jc9XxnobpHeNOMy9kjZIfE+J8gvSzZusYsoqI
         Qq+igmLtV6fNAgYEmcdJY1dmma/Nk4KEnDVIQQOHRee0liK48fFQhIZOVHbaC4+Sae
         hjVQ4CQ7WYNYQ==
Date:   Fri, 4 Feb 2022 20:34:34 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Eric Dumazet <edumazet@google.com>
Cc:     Eric Dumazet <eric.dumazet@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next 1/2] net: typhoon: implement ndo_features_check
 method
Message-ID: <20220204203434.17f56b23@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <CANn89iKF0sf1APAaVKHdWRZEVZ5X1LoBRGHBgS4TfucD=SsOJw@mail.gmail.com>
References: <20220203180227.3751784-1-eric.dumazet@gmail.com>
        <20220203180227.3751784-2-eric.dumazet@gmail.com>
        <20220204195229.2e210fde@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <CANn89iKF0sf1APAaVKHdWRZEVZ5X1LoBRGHBgS4TfucD=SsOJw@mail.gmail.com>
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

On Fri, 4 Feb 2022 20:26:58 -0800 Eric Dumazet wrote:
> > Should we always clear SG? If we want to make the assumption that
> > non-gso skbs are never this long (like the driver did before) then
> > we should never clear SG. If we do we risk one of the gso-generated
> > segs will also be longer than 32 frags.  
> 
> If I read the comment (deleted in this patch), it seems the 32 limits
> is about TSO only ?
> 
> #warning Typhoon only supports 32 entries in its SG list for TSO, disabling TSO
> 
> This is why I chose this implementation.

Right, sort of my point - to stay true to old code we don't need to
worry about SG ? The old code didn't..

> > Thought I should ask.
> >  
> > > +     }
> > > +     return features;  
> >
> > return vlan_features_check(skb, features) ?  
> 
> Hmm... not sure why we duplicate vlan_features_check() &
> vxlan_features_check() in all ndo_features_check() handlers :/

I was wondering as well. I can only speculate.. :S
