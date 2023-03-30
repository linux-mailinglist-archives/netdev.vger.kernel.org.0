Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7077E6CF9FA
	for <lists+netdev@lfdr.de>; Thu, 30 Mar 2023 06:06:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229705AbjC3EGi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Mar 2023 00:06:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229481AbjC3EGh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Mar 2023 00:06:37 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A92F25272;
        Wed, 29 Mar 2023 21:06:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 64202B82338;
        Thu, 30 Mar 2023 04:06:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B891C433EF;
        Thu, 30 Mar 2023 04:06:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680149194;
        bh=cWovLLY/QzBK8HVyLhNR1l5TL9fvrIqFqju9NMQW51k=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ZDFPyj0kZOcN70YJukiaht+4R96ciHWp36kuDhyTZvQCNg6OkBfHzzFA9NTUHpmG0
         CE2qnk8K3dTtVHJ5UYF2C/NjxT3CiHTjv3ssN9KemoD+gZVlRJYU9CW2HC4tB09Rzt
         bSqgh6nNpI4IvofBMPJ7x0Mn7my04GU6UhQaOusi7lfs/yuRPTwLxZJkMbGhsjudfB
         84c088nj4doJ0i5QyNHAmMXa06sNStK2VB5m2MArER2xOIZcUtMWt9+XXrgS3Dxl+2
         wiDAgKKCMFIgMPROz+5hwBdDi/1/Ru+rlX7C+7JuPuMiq7nfWtfKDC6vI8BOvzapQr
         ahSZ46B9Sjevw==
Date:   Wed, 29 Mar 2023 21:06:33 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [RFC PATCH 2/2] mac80211: use the new drop reasons
 infrastructure
Message-ID: <20230329210633.39cca656@kernel.org>
In-Reply-To: <34e43da3694e2d627555af0149ebe438e1ed2938.camel@sipsolutions.net>
References: <20230329214620.131636-1-johannes@sipsolutions.net>
        <20230329234613.5bcb4d8dcade.Iea29d70af97ce2ed590a00dbebee2ab4d013dfd5@changeid>
        <34e43da3694e2d627555af0149ebe438e1ed2938.camel@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 29 Mar 2023 23:56:31 +0200 Johannes Berg wrote:
> > +	drop_reasons_unregister_subsys(SKB_DROP_REASON_SUBSYS_MAC80211_MONITOR);
> > +	drop_reasons_unregister_subsys(SKB_DROP_REASON_SUBSYS_MAC80211_UNUSABLE);
> > +
> >  	rcu_barrier();  
> 
> This is making me think that perhaps we don't want synchronize_rcu()
> inside drop_reasons_unregister_subsys(), since I have two now and also
> already have an rcu_barrier() ... so maybe just document that it's
> needed?

premature optimization? some workload is reloading mac80211 in a loop?
