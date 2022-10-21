Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C6C46607A0B
	for <lists+netdev@lfdr.de>; Fri, 21 Oct 2022 17:01:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229478AbiJUPBS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Oct 2022 11:01:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229958AbiJUPBQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Oct 2022 11:01:16 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DD7C165CA6
        for <netdev@vger.kernel.org>; Fri, 21 Oct 2022 08:01:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 99A5D61EE5
        for <netdev@vger.kernel.org>; Fri, 21 Oct 2022 15:01:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A8E0C433D6;
        Fri, 21 Oct 2022 15:01:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666364475;
        bh=doHC0D7wW67LMJdd2J1ouVmmvTFM00QK6Lq1RljaD40=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=lwDLlACeJwIIE57igups36nM2VQRRlRDRm1JMxqTc8DMVtlGB4DR7XwGJWYhWTTtY
         c2vC0zUvrLKJsU0Uu+08D9kRcwotuKcjW7Y6BPANcg5G4x+wwDuksid4Yux1ZWtXv2
         t9iRmhRS0QKONYyqM2YKTGDd4z4mFjCoOAh+YEqsCBDi0+ZpJ5oXPQwbEMBTbavPbZ
         5HrERCFI+mDHLOW1KVaVwBihcgUrvDYGCVtH/lejw+xgtS/g2KWilHY9Unk5fR9ECz
         +78gpHHSlBJ9mdHV+0UxTUh+wo22NRZ9rW/A3mXBrKFxtE5ylm3GGO9MQTeFlRaQRd
         r2NEl+RrAIOZw==
Date:   Fri, 21 Oct 2022 08:01:13 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com,
        pabeni@redhat.com, jiri@resnulli.us, razor@blackwall.org,
        nicolas.dichtel@6wind.com, gnault@redhat.com,
        jacob.e.keller@intel.com, fw@strlen.de
Subject: Re: [PATCH net-next 12/13] genetlink: allow families to use split
 ops directly
Message-ID: <20221021080113.6cee1270@kernel.org>
In-Reply-To: <8380d344eb5bc084f457920b0133e58ae05f6f2b.camel@sipsolutions.net>
References: <20221018230728.1039524-1-kuba@kernel.org>
        <20221018230728.1039524-13-kuba@kernel.org>
        <a23c47631957c3ba3aaa87bc325553da04f99a0c.camel@sipsolutions.net>
        <20221019122504.0cb9d326@kernel.org>
        <dfac0b6e09e9739c7f613cb8ed77c81f9db0bb44.camel@sipsolutions.net>
        <20221019125745.3f2e7659@kernel.org>
        <683f4c655dd09a2af718956e8c8d56e6451e11ac.camel@sipsolutions.net>
        <20221020110950.6e91f9bb@kernel.org>
        <8380d344eb5bc084f457920b0133e58ae05f6f2b.camel@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 21 Oct 2022 13:02:31 +0200 Johannes Berg wrote:
> > Perhaps we could hang it of the .resv_start_op as well?  
> 
> Yes, hopefully? Maybe?
> 
> > Any op past that would treat policy == NULL as reject all?  
> 
> Right. The only danger is that someone already added new stuff somewhere
> and bad/broken userspace already used it with garbage attrs.
> 
> But the chances of that are probably low.
> 
> So I'd say go for it, and worst case we bump up the resv_start_op for
> anything that breaks? Wouldn't be a huge loss either.

resv_start_op are only present in -rc kernels, so I think we can break
things risking only common anger not uAPI wrath :)

> > We'd need to add GENL_DONT_VALIDATE_DO for families which 
> > want to parse inside the callbacks. I wonder if people would
> > get annoyed.  
> 
> Why would anyone really want to _parse_ in the callbacks?

Until recently that was the only way to do per-op policies, I don't
know if anyone actually used per-op policies outside of ethtool tho.
