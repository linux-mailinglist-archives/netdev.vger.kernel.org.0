Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CC43857E66E
	for <lists+netdev@lfdr.de>; Fri, 22 Jul 2022 20:23:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236100AbiGVSXx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Jul 2022 14:23:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235917AbiGVSXv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Jul 2022 14:23:51 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2224386C27
        for <netdev@vger.kernel.org>; Fri, 22 Jul 2022 11:23:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BA59F622FB
        for <netdev@vger.kernel.org>; Fri, 22 Jul 2022 18:23:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC1BEC341C6;
        Fri, 22 Jul 2022 18:23:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658514230;
        bh=0i0g6wlW4+C0PGDMzbus1rdPjLNF8ICh/+0IE44f1X8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=e06FwOi51Y6x542tePk837ruSYa9pEQCAZAiiAK/asADoANtJ3trDX9qdzS9/ibDv
         OHs2AKC447NTHOvsifRvefoZIar+R5qw754QAdnZdCcnAMSCerFMiAriTkpPGJKhAY
         XERVtm819i+umuzhQ0eGoLWu+xb7sjsnQlJ9S+PpqNUQcBJyx6TP6IMGIogu4ZaX5i
         45apezXUpWYHpGpt4MxhSHrr+Yp9VaL8LpKVh7NaqJK8YxkRfkWlqxYS6L1T75UKua
         EeeYXtVCJWnFE8OFlt92BQnGNYGZCRC0ic6jFaBJrhYde7dR8TPHbQOyd9tfTMI1Xf
         lCUXtv+Bsg8MA==
Date:   Fri, 22 Jul 2022 11:23:48 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, idosch@nvidia.com,
        petrm@nvidia.com, pabeni@redhat.com, edumazet@google.com,
        mlxsw@nvidia.com, saeedm@nvidia.com, snelson@pensando.io
Subject: Re: [patch net-next v3 01/11] net: devlink: make sure that
 devlink_try_get() works with valid pointer during xarray iteration
Message-ID: <20220722112348.75fb5ccc@kernel.org>
In-Reply-To: <YtrHOewPlQ0xOwM8@nanopsycho>
References: <20220720151234.3873008-1-jiri@resnulli.us>
        <20220720151234.3873008-2-jiri@resnulli.us>
        <20220720174953.707bcfa9@kernel.org>
        <YtrHOewPlQ0xOwM8@nanopsycho>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 22 Jul 2022 17:50:17 +0200 Jiri Pirko wrote:
> >Plus we need to be more careful about the unregistering order, I
> >believe the correct ordering is:
> >
> >	clear_unmark()
> >	put()
> >	wait()
> >	notify()
> >
> >but I believe we'll run afoul of Leon's notification suppression.
> >So I guess notify() has to go before clear_unmark(), but we should
> >unmark before we wait otherwise we could live lock (once the mutex 
> >is really gone, I mean).  
> 
> Kuba, could you elaborate a bit more about the live lock problem here?

Once the devlink_mutex lock is gone - (unprivileged) user space dumping
devlink objects could prevent any de-registration from happening
because it can keep the reference of the instance up. So we should mark
the instance as not REGISTERED first, then go to wait.

Pretty theoretical, I guess, but I wanted to mention it in case you can
figure out a solution along the way :S I don't think it's a blocker
right now since we still have the mutex.
