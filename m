Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DCC91580488
	for <lists+netdev@lfdr.de>; Mon, 25 Jul 2022 21:39:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233461AbiGYTjV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Jul 2022 15:39:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230280AbiGYTjU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Jul 2022 15:39:20 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE65A205CC
        for <netdev@vger.kernel.org>; Mon, 25 Jul 2022 12:39:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 865F26104F
        for <netdev@vger.kernel.org>; Mon, 25 Jul 2022 19:39:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C466CC341C8;
        Mon, 25 Jul 2022 19:39:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658777958;
        bh=SdfrlchuYJLFvUpMCvr8KA1gHTG0obECyHg17u/1bvE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Az3f8Ns5tZBDxstiMHWxrs7gPIHACyAAu49739riY7vAQUSxG4risl79JHD+hLWQe
         fSEJAfpNxXGwErUq7QjBuJIbTwvZmW52ijOAk8YQhlndAu0vfMBb8UHS8CGvTYMx6c
         gCykN6WzrN2bwAhNLXdJMi5Dew1ZreiiwBVAKGU6qlJjYqoH0QNoDZ6g+8WYv+exSj
         pvpeYdX2OFf9sfwV9lqNyQydhxDrx9anTaBUP3Qe4Cs9mMU0zWmYozMmCxQpwspx4/
         6dLEwFq6dl+pO0SK64fjuVmxA/GjZIkvNUEb7lWnUwjl7Gabi/DwqcnR5ZyFw2otdH
         +keSj5hGBejtg==
Date:   Mon, 25 Jul 2022 12:39:17 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     "Keller, Jacob E" <jacob.e.keller@intel.com>
Cc:     Jiri Pirko <jiri@resnulli.us>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [net-next PATCH 1/2] devlink: add dry run attribute to flash
 update
Message-ID: <20220725123917.78863f79@kernel.org>
In-Reply-To: <SA2PR11MB5100E125B66263046B322DC1D6959@SA2PR11MB5100.namprd11.prod.outlook.com>
References: <20220720183433.2070122-1-jacob.e.keller@intel.com>
        <20220720183433.2070122-2-jacob.e.keller@intel.com>
        <YtjqJjIceW+fProb@nanopsycho>
        <SA2PR11MB51001777DC391C7E2626E84AD6919@SA2PR11MB5100.namprd11.prod.outlook.com>
        <YtpBR2ZnR2ieOg5E@nanopsycho>
        <CO1PR11MB508957F06BB96DD765A7580FD6909@CO1PR11MB5089.namprd11.prod.outlook.com>
        <YtwW4aMU96JSXIPw@nanopsycho>
        <SA2PR11MB5100E125B66263046B322DC1D6959@SA2PR11MB5100.namprd11.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 25 Jul 2022 19:15:10 +0000 Keller, Jacob E wrote:
> I'm not sure exactly what the process would be here. Maybe something
> like:
> 
> 1. identify all of the commands which aren't yet strict
> 2. introduce new command IDs for these commands with something like
> _STRICT as a suffix? (or something shorter like _2?) 3. make all of
> those commands strict validation..
> 
> but now that I think about that, i am not sure it would work. We use
> the same attribute list for all devlink commands. This means that
> strict validation would only check that its passed existing/known
> attributes? But that doesn't necessarily mean the kernel will process
> that particular attribute for a given command does it?
> 
> Like, once we introduce DEVLINK_ATTR_DRY_RUN support for flash, if we
> then want to introduce it later to something like port splitting.. it
> would be a valid attribute to send from kernels which support flash
> but would still be ignored on kernels that don't yet support it for
> port splitting?
> 
> Wouldn't we want each individual command to have its own validation
> of what attributes are valid?
> 
> I do think its probably a good idea to migrate to strict mode, but I
> am not sure it solves the problem of dry run. Thoughts? Am I missing
> something obvious?
> 
> Would we instead have to convert from genl_small_ops to genl_ops and
> introduce a policy for each command? I think that sounds like the
> proper approach here....

...or repost without the comment and move on. IDK if Jiri would like 
to see the general problem of attr rejection solved right now but IMHO
it's perfectly fine to just make the user space DTRT.
