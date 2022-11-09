Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1DEA2623314
	for <lists+netdev@lfdr.de>; Wed,  9 Nov 2022 19:59:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231133AbiKIS7V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Nov 2022 13:59:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230337AbiKIS7S (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Nov 2022 13:59:18 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA08619C1B
        for <netdev@vger.kernel.org>; Wed,  9 Nov 2022 10:59:16 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6FCAFB80E38
        for <netdev@vger.kernel.org>; Wed,  9 Nov 2022 18:59:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51310C433C1;
        Wed,  9 Nov 2022 18:59:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668020354;
        bh=SmuCkD6VzH8yRausIroiBir8xQ42CpSNyu4wq8lVHxk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=EQQ3tgnP8t99fQksqkDjXAJ16wwsfn2x/nhIeBQcsuOQQoq7kZZ4Ul9U4DX2regPA
         CtKhZip7NalEqFFcX/Y+kyAVTTCwGc2gtRgoE6Snw0nRne9xBd0J9TRZQA6vWaD78t
         hGuPBP3maUNGEym0pddF+YceGnDIicdu3+87NaRuHv0PdGHvIv8Kb01Wtq1rhC8qZn
         TrKGDI6FBSGZNygHuhBh4hj1up849vCALeDARW3rztiXo84V9QfzOslaWoj48lSi2X
         i/GkwSrs3RelrSARKQq9v/VmzUhF/MS8A0i+hWs0tpl+nL9dUFkvx6XC8WLjMgLjgz
         qsWzAwQghkaYg==
Date:   Wed, 9 Nov 2022 20:59:09 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com,
        pabeni@redhat.com, Jonathan Lemon <bsd@meta.com>,
        jacob.e.keller@intel.com
Subject: Re: [PATCH net-next] genetlink: fix policy dump for dumps
Message-ID: <Y2v4fVbvUdZ80A9E@unreal>
References: <20221108204041.330172-1-kuba@kernel.org>
 <Y2vnesR4cNMVF4Jn@unreal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y2vnesR4cNMVF4Jn@unreal>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 09, 2022 at 07:46:34PM +0200, Leon Romanovsky wrote:
> On Tue, Nov 08, 2022 at 12:40:41PM -0800, Jakub Kicinski wrote:
> > Jonathan reports crashes when running net-next in Meta's fleet.
> 
> I experience these crashes too.
> 
> > Stats collection uses ethtool -I which does a per-op policy dump
> > to check if stats are supported. We don't initialize the dumpit
> > information if doit succeeds due to evaluation short-circuiting.
> > 
> > The crash may look like this:
> > 
> >    BUG: kernel NULL pointer dereference, address: 0000000000000cc0
> >    RIP: 0010:netlink_policy_dump_add_policy+0x174/0x2a0
> >      ctrl_dumppolicy_start+0x19f/0x2f0
> >      genl_start+0xe7/0x140
> > 
> > Or we may trigger a warning:
> > 
> >    WARNING: CPU: 1 PID: 785 at net/netlink/policy.c:87 netlink_policy_dump_get_policy_idx+0x79/0x80
> >    RIP: 0010:netlink_policy_dump_get_policy_idx+0x79/0x80
> >      ctrl_dumppolicy_put_op+0x214/0x360
> > 
> > depending on what garbage we pick up from the stack.
> > 
> > Reported-by: Jonathan Lemon <bsd@meta.com>
> > Fixes: 26588edbef60 ("genetlink: support split policies in ctrl_dumppolicy_put_op()")
> > Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> > ---
> > CC: jacob.e.keller@intel.com
> > ---
> >  net/netlink/genetlink.c | 12 ++++++------
> >  1 file changed, 6 insertions(+), 6 deletions(-)
> 
> I added your updated patch to my CI run. Unfortunately, the regression
> system is overloaded due to nightly regression so won't be able to get
> results in sensible time frame.
> 

Thanks,
Tested-by: Leon Romanovsky <leonro@nvidia.com>
