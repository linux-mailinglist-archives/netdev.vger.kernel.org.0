Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2767F575272
	for <lists+netdev@lfdr.de>; Thu, 14 Jul 2022 18:07:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237665AbiGNQHR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Jul 2022 12:07:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232483AbiGNQHQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Jul 2022 12:07:16 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4015501A8
        for <netdev@vger.kernel.org>; Thu, 14 Jul 2022 09:07:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7FF4161FD7
        for <netdev@vger.kernel.org>; Thu, 14 Jul 2022 16:07:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D1BFC34114;
        Thu, 14 Jul 2022 16:07:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657814834;
        bh=EdbRl13BQ02NSiff8+/cyoPQirfa0uAsDedFhODnlpQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=lNnI/U/HNSrl56AWKYVO96OcVmT3WH+hyRNHD4QtRGnuOv9pusHc6c1Pwyf6XZw9x
         fmMmBsM/WLJFxXLABF+D1h4a90mAbjkdniITGtQnZpEXnchxIR6YlKFB69/LP1ncaD
         dE8x+/FFw6ULDGNaSGDF9G+IERDbYfLCIA2smDAppVshFp/V0xcotujT1FlRaFoYkg
         QZhrbmKiigtB2qxg8a5XA/b/xM9WynxEAL/Oi9kNzXhKJHa9QFCMZC5WLckhGJF22P
         XtXMh35u3vLe6txAOocOjcBoLUKAiv34elGq0i43vwcX0xxsmQA/ZdtRPnT6uCkLhw
         kx0C/0Rn96FmA==
Date:   Thu, 14 Jul 2022 09:07:13 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jiri Pirko <jiri@nvidia.com>
Cc:     Jiri Pirko <jiri@resnulli.us>, Dima Chumak <dchumak@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        Simon Horman <horms@verge.net.au>,
        Michal Wilczynski <michal.wilczynski@intel.com>
Subject: Re: [PATCH net-next 0/5] devlink rate police limiter
Message-ID: <20220714090713.3f2353f4@kernel.org>
In-Reply-To: <Ys+hqVopaCODxihw@nanopsycho>
References: <YsbBbBt+DNvBIU2E@nanopsycho>
        <20220707131649.7302a997@kernel.org>
        <YsfcUlF9KjFEGGVW@nanopsycho>
        <20220708110535.63a2b8e9@kernel.org>
        <YskOt0sbTI5DpFUu@nanopsycho>
        <20220711102957.0b278c12@kernel.org>
        <Ys0OvOtwVz7Aden9@nanopsycho>
        <20220712171341.29e2e91c@kernel.org>
        <Ys5SRCNwD8prZ0pL@nanopsycho>
        <20220713105255.4654c4ad@kernel.org>
        <Ys+hqVopaCODxihw@nanopsycho>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 14 Jul 2022 06:55:05 +0200 Jiri Pirko wrote:
> Wed, Jul 13, 2022 at 07:52:55PM CEST, kuba@kernel.org wrote:
> >On Wed, 13 Jul 2022 07:04:04 +0200 Jiri Pirko wrote:  
> >> Even if there is no netdevice to hook it to, because it does not exist?
> >> I have to be missing something, sorry :/  
> >
> >What I'm saying is that we can treat the devlink rate API as a "lower
> >layer interface". A layer under the netdevs. That seems sensible and
> >removes the API duplication which otherwise annoys me.
> >
> >We want drivers to only have to implement one API.
> >
> >So when user calls the legacy NDO API it should check if the device has
> >devlink rate support, first, and try to translate the legacy request
> >into devlink rate.
> >
> >Same for TC police as installed by the OvS offload feature that Simon
> >knows far more about than I do. IIRC we use a combination of matchall
> >and police to do shaping.
> >
> >That way drivers don't have to implement all three APIs, only devlink
> >rate (four APIs if we count TC qdisc but I think only NFP uses that
> >one and it has RED etc so that's too much).
> >
> >Does this help or am I still not making sense?  
> 
> I think I got it now. But in our case, there is no change for the user,
> as the netdev does not exist. So user still uses devlink rate uapi as
> proposed by this patchset. Only internal kernel changes requested.
> Correct?

Right. If the user wants to use devlink-rate directly they can.
For legacy users the kernel will translate to devlink-rate.
The point is for drivers to only have to implement devlink-rate.
