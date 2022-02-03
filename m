Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C38C54A8C59
	for <lists+netdev@lfdr.de>; Thu,  3 Feb 2022 20:18:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353737AbiBCTSF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Feb 2022 14:18:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353734AbiBCTSE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Feb 2022 14:18:04 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9C3FC061714
        for <netdev@vger.kernel.org>; Thu,  3 Feb 2022 11:18:04 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 570C060F3D
        for <netdev@vger.kernel.org>; Thu,  3 Feb 2022 19:18:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78DA9C340E8;
        Thu,  3 Feb 2022 19:18:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643915883;
        bh=nrs+W5bJvYSXfylJxV6mzYw2sbS29Lw3HPlnONw3IaI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=JmPhFcHMvqNGEXFEIOV/XEHEPYSxR8ESrfklIvOQ5Gp8TS7qN+9FNFu0rO+DlX+jG
         nRU/z4vIHEK9upPN0I6GsNa88Wz6+mXh183+ki77cnyE8Mo7JZu3ktiLv996NYzeUd
         Yx6/BT8wf9Pr4Xay2ewa+QJBvPsmAGr+NdKun+UCmx0V8uYJV+8re20+NRbjOcie2M
         FWHLw1hjCx1i3/q1TuLqeg3AeS2bb36/bz5aEatEp/K5fQTg0VD+tMmjD5QPdqi3X0
         EF44UQBHF91Gy7ycW0XZ/di/xPp86Ty2iW4UVbCm8HwzjKKiPBq7zbwZEF3VdHpRWk
         DC5Mk+i08gfpg==
Date:   Thu, 3 Feb 2022 11:18:02 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Alexander Duyck <alexander.duyck@gmail.com>
Cc:     Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>, Coco Li <lixiaoyan@google.com>
Subject: Re: [PATCH net-next 09/15] net: increase MAX_SKB_FRAGS
Message-ID: <20220203111802.1575416e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <CAKgT0UeTvj_6DWUskxxaRiQQxcwg6j0u+UHDaougJSMdkogKWA@mail.gmail.com>
References: <20220203015140.3022854-1-eric.dumazet@gmail.com>
        <20220203015140.3022854-10-eric.dumazet@gmail.com>
        <ee1fedeb33cd989379b72faac0fd6a366966f032.camel@gmail.com>
        <CANn89iKxGvbXQqoRZZ5j22-5YkpiCLS13EGoQ1OYe3EHjEss6A@mail.gmail.com>
        <CAKgT0UeTvj_6DWUskxxaRiQQxcwg6j0u+UHDaougJSMdkogKWA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 3 Feb 2022 09:56:42 -0800 Alexander Duyck wrote:
> > I could make  MAX_SKB_FRAGS a config option, and default to 17, until
> > all drivers have been fixed.
> >
> > Alternative is that I remove this patch from the series and we apply
> > it to Google production kernels,
> > as we did before.  
> 
> A config option would probably be preferred. The big issue as I see it
> is that changing MAX_SKB_FRAGS is going to have ripples throughout the
> ecosystem as the shared info size will be increasing and the queueing
> behavior for most drivers will be modified as a result.

I'd vote for making the change and dealing with the fall out. Unlikely
many people would turn this knob otherwise and it's a major difference.
Better not to fork the characteristics of the stack, IMHO.
