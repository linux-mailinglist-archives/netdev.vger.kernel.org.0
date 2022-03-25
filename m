Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5BEAA4E7948
	for <lists+netdev@lfdr.de>; Fri, 25 Mar 2022 17:50:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359438AbiCYQvd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Mar 2022 12:51:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353627AbiCYQvc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Mar 2022 12:51:32 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 165D8C12C7;
        Fri, 25 Mar 2022 09:49:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3932FB82929;
        Fri, 25 Mar 2022 16:49:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83337C2BBE4;
        Fri, 25 Mar 2022 16:49:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648226994;
        bh=4G/HlMObuPl5HB4vAXSAnNPwS1bpgtplquTJ8M34Ijg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=bhcqvKEZ6xBPEXWenC6BBEvEnIXURJxeibqMBU4N6HqnJ2FaKTIRuM7dmxg3WhH3A
         SD0RZhHr2hCZp/DETVXeJOnBr6sKYRgeFkbGOFnp5bq1DP7cS16CDBaTpB1x/b+fEs
         7sNKBAgziCnHLlxP0tBEExafTg14+AB54OslSiFFbiNRc6iCoKy5la9S+eytEvJ1e4
         2F6AMGRR4FTFQyhyxv8newa39UhccCaNrwbStwj6vHULRnuHGsOnTUIYOni0fGe/kc
         thmOYw29+wTDaPs1FRZrTcX9Iv3IPV6ppFWDyLZt/NML3O+661RITvJkIQ91HQ9vLD
         caz3y5QHcE8EA==
Date:   Fri, 25 Mar 2022 09:49:52 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     William McVicker <willmcvicker@google.com>,
        linux-wireless@vger.kernel.org,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Amitkumar Karwar <amitkarwar@gmail.com>,
        Ganapathi Bhat <ganapathi.bhat@nxp.com>,
        Xinming Hu <huxinming820@gmail.com>, kernel-team@android.com,
        Paolo Abeni <pabeni@redhat.com>
Subject: Re: [BUG] deadlock in nl80211_vendor_cmd
Message-ID: <20220325094952.10c46350@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <19e12e6b5f04ba9e5b192001fbe31a3fc47d380a.camel@sipsolutions.net>
References: <0000000000009e9b7105da6d1779@google.com>
        <99eda6d1dad3ff49435b74e539488091642b10a8.camel@sipsolutions.net>
        <5d5cf050-7de0-7bad-2407-276970222635@quicinc.com>
        <YjpGlRvcg72zNo8s@google.com>
        <dc556455-51a2-06e8-8ec5-b807c2901b7e@quicinc.com>
        <Yjzpo3TfZxtKPMAG@google.com>
        <19e12e6b5f04ba9e5b192001fbe31a3fc47d380a.camel@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 25 Mar 2022 13:04:23 +0100 Johannes Berg wrote:
> So we can avoid the potential deadlock in cfg80211 in a few ways:
> 
>  1) export rtnl_lock_unregistering_all() or maybe a variant after
>     refactoring the two versions, to allow cfg80211 to use it, that way
>     netdev_run_todo() can never have a non-empty todo list
> 
>  2) export __rtnl_unlock() so cfg80211 can avoid running
>     netdev_run_todo() in the unlock, personally I like this less because
>     it might encourage random drivers to use it
> 
>  3) completely rework cfg80211's locking, adding a separate mutex for
>     the wiphy list so we don't need to acquire the RTNL at all here
>     (unless the ops need it, but there's no issue if we don't drop it),
>     something like https://p.sipsolutions.net/27d08e1f5881a793.txt
> 
> 
> I think I'm happy with 3) now (even if it took a couple of hours), so I
> think we can go with it, just need to go through all the possibilities.

I like 3) as well. FWIW a few places (e.g. mlx5, devlink, I think I've
seen more) had been converting to xarray for managing the "registered"
objects. It may be worth looking into if you're re-doing things, anyway.
