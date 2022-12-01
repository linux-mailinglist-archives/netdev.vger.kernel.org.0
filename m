Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 40F5E63ED2B
	for <lists+netdev@lfdr.de>; Thu,  1 Dec 2022 11:05:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229800AbiLAKFx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Dec 2022 05:05:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229831AbiLAKFv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Dec 2022 05:05:51 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D590D2E6A1
        for <netdev@vger.kernel.org>; Thu,  1 Dec 2022 02:05:46 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7F2B1B81DCF
        for <netdev@vger.kernel.org>; Thu,  1 Dec 2022 10:05:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F365C433D6;
        Thu,  1 Dec 2022 10:05:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669889144;
        bh=x7WoCfGuLDfSvHeZShnQaKAhDFEx5vSlAiw2pKNjs70=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=M8Ukub9PDkWeIHzltKlU8RCz2uCpro/hY0MQswTgi4aRntPKhnPlxtTBGqThfq2E2
         wx77D2HWDjVSZ7qroP54z4SjaYBZoAK1UjDJ+3MKsN0kRcSh+knH3UVZeGmKF2fOFe
         sHIG5JXgzTBPVBWirWovO2XyyIZi6lRSwzCueAlfYsC2JGaogsHB3zjHwRYIX0jDZY
         5DWtWiR/xiqtHOclWm/dDyVsLrWwWOy8SsypknJn6w0wTxVnMC35cIPsibMQER7oCI
         URC4wtHQvijyDwSXLnec7vSZKmGVYIw7dp+3rkShzTJiSxI28+fhNDhUKK5CStwq1q
         1yanQzeVqBK1Q==
Date:   Thu, 1 Dec 2022 12:05:38 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     Jakub Kicinski <kuba@kernel.org>, Ido Schimmel <idosch@idosch.org>,
        Yang Yingliang <yangyingliang@huawei.com>,
        netdev@vger.kernel.org, jiri@nvidia.com, davem@davemloft.net,
        edumazet@google.com, pabeni@redhat.com
Subject: Re: [PATCH net] net: devlink: fix UAF in
 devlink_compat_running_version()
Message-ID: <Y4h8cvsa+6LT/Yq+@unreal>
References: <Y4SGYr6VBkIMTEpj@nanopsycho>
 <20221128102043.35c1b9c1@kernel.org>
 <Y4XDbEWmLRE3D1Bx@nanopsycho>
 <20221129181826.79cef64c@kernel.org>
 <Y4dBrx3GTl2TLIrJ@nanopsycho>
 <20221130084659.618a8d60@kernel.org>
 <Y4eMFUBWKuLLavGB@nanopsycho>
 <20221130092042.0c223a8c@kernel.org>
 <Y4etAg+vcnRCMWx9@unreal>
 <Y4hoYI/eidosRvHt@nanopsycho>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y4hoYI/eidosRvHt@nanopsycho>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 01, 2022 at 09:40:00AM +0100, Jiri Pirko wrote:
> Wed, Nov 30, 2022 at 08:20:34PM CET, leon@kernel.org wrote:
> >On Wed, Nov 30, 2022 at 09:20:42AM -0800, Jakub Kicinski wrote:
> >> On Wed, 30 Nov 2022 18:00:05 +0100 Jiri Pirko wrote:
> >> > Wed, Nov 30, 2022 at 05:46:59PM CET, kuba@kernel.org wrote:
> >> > >On Wed, 30 Nov 2022 12:42:39 +0100 Jiri Pirko wrote:  
> >> > >> **)
> >> > >> I see. With the change I suggest, meaning doing
> >> > >> devlink_port_register/unregister() and netdev_register/unregister only
> >> > >> for registered devlink instance, you don't need this at all. When you
> >> > >> hit this compat callback, the netdevice is there and therefore devlink
> >> > >> instance is registered for sure.  
> >> > >
> >> > >If you move devlink registration up it has to be under the instance
> >> > >lock, otherwise we're back to reload problems. That implies unregister
> >> > >should be under the lock too. But then we can't wait for refs in
> >> > >unregister. Perhaps I don't understand the suggestion.  
> >> > 
> >> > I unlock for register and for the rest of the init I lock again.
> >> 
> >> The moment you register that instance callbacks can start coming.
> >> Leon move the register call last for a good reason - all drivers
> >> we looked at had bugs in handling init.
> >
> >Plus we had very cozy lock->unlock->lock sequences during devlink
> >command execution, which caused to races between devlink calls
> >and driver initialization.
> 
> So? Why do you think it is a problem?

We need to see the actual implementation. In general, once you unlock
you can get other threads to change the state of your device.

> 
> >
> >So I'm also interested to see what Jiri meant by saying "I unlock for
> >register and for the rest of the init I lock again".
> >
> >Thanks
