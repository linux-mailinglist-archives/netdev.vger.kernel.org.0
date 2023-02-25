Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 88A306A2608
	for <lists+netdev@lfdr.de>; Sat, 25 Feb 2023 01:56:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229547AbjBYA4W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Feb 2023 19:56:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229445AbjBYA4V (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Feb 2023 19:56:21 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99F2B32E61
        for <netdev@vger.kernel.org>; Fri, 24 Feb 2023 16:56:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2E7A360FBB
        for <netdev@vger.kernel.org>; Sat, 25 Feb 2023 00:56:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F7FEC433D2;
        Sat, 25 Feb 2023 00:56:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677286579;
        bh=uATBzMEuY6H29iYbHb8zzVA85/DRLX03NhjiPp1wyAU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=k1NkXji4Q1dslDslbX1I7vfAsXVMAbERyGJSq3zvt7IT1+bEklNetNZD+feU2TitY
         t14vjlRh5xuRT86kqx3XqowUlkCqQzUZu1QDDMAgR4Gc8dlI5a2yxyAJBDDzOGNMu0
         Hv6NDjo4jbRGVuhKGmupOOEKEIn1R6vtwE35aSHMsMXD/U0bv6eufn2RtNgFubgRQK
         5pg/kgmP0QateOJbofU/hw3rHVtEd7sClzM393GAZKB320wmh6EqYKiRASBrrxDJsC
         x3CkurRlhPonQ5nguXzPFndl90rojCJxmsYkG8QdqeG9z4VROfPlU86/KAqt/3jQ7M
         d+z9/pLoMVDKw==
Date:   Fri, 24 Feb 2023 16:56:18 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Stephen Hemminger <stephen@networkplumber.org>
Cc:     Jamal Hadi Salim <jhs@mojatatu.com>, dsahern@gmail.com,
        netdev@vger.kernel.org
Subject: Re: [PATCH iproute2] genl: print caps for all families
Message-ID: <20230224165618.5e4cbbf4@kernel.org>
In-Reply-To: <20230224143327.4221f8a5@hermes.local>
References: <20230224015234.1626025-1-kuba@kernel.org>
        <20230223192742.36fd977a@hermes.local>
        <20230224091146.39eae414@kernel.org>
        <CAM0EoM=Ugqtg_jg_kgWjA+eojcV7k+nZuyov8Qn2C7L7aPwSRQ@mail.gmail.com>
        <20230224102935.591dbb43@kernel.org>
        <20230224143327.4221f8a5@hermes.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 24 Feb 2023 14:33:27 -0800 Stephen Hemminger wrote:
> > I'm biased but at this point the time is probably better spent trying
> > to filling the gaps in ynl than add JSON to a CLI tool nobody knows
> > about... too harsh? :  
> 
> So I can drop it (insert sarcasm here)

It may be useful to experts as a for-human-consumption CLI.

JSON to me implies use in scripts or higher level code, I can't
think of a reason why scripts would poke into genl internals.
E.g. if a script wants something from devlink it will call devlink,
and the devlink tool internally may interrogate genl internals.

IOW we're tapping into a layer in the middle of the tech stack, 
while user wants JSON out of the end of the stack.

[We can replace ynl with a iproute2 internal lib or libml to avoid bias]
Now, what I'm saying is - for devlink - we don't have a easy to use
library which a programmer can interact with to query the family info.
Parsing thru the policy dumps is _hard_. So building a C library for
this seems more fruitful than adding JSON to the CLI tool.

IDK if I'm making sense.  I could well be wrong.
