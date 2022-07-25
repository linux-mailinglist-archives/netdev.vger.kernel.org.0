Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E18DB5805B0
	for <lists+netdev@lfdr.de>; Mon, 25 Jul 2022 22:32:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236580AbiGYUcu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Jul 2022 16:32:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235986AbiGYUct (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Jul 2022 16:32:49 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6DCD9FF9
        for <netdev@vger.kernel.org>; Mon, 25 Jul 2022 13:32:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 858AE6118A
        for <netdev@vger.kernel.org>; Mon, 25 Jul 2022 20:32:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C29A9C341C6;
        Mon, 25 Jul 2022 20:32:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658781167;
        bh=auGxJDW6F7iP0J5E9adePL0FsRIorElCGgXemKMSxVs=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=dTD2C10u3mViN08aJ01NCuXpBfPZYRWiqXcVuxAv3nXPuUqT3Gmqiu7ZDegnzUsE2
         PLPA0v3n/lbykT3Pjc9Hap5Ns3FBiPzNn/vrWMuZ0bmpgSv+RuI8dNku5TG2iltFlQ
         fLHYGdxhe+IqAbaH4TQ1hc63/ahOLLQgYfbIbq80KWxYpNu47FkACPJVkqA1w0LNFs
         Hg5BKwbXPOgaPKPQt2QHVukxIBaKGlvTpY5BO1OvMTgfaJw5t7Zx/Tw4XV1UY2/5Tc
         eVnwsYS0xZz9BnFRbhu4IdDzbZAke12ykFohd4AJep/zWZPHOGzQNE5uoFdE14M2Hw
         BK3cJTolE2u4g==
Date:   Mon, 25 Jul 2022 13:32:46 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     "Keller, Jacob E" <jacob.e.keller@intel.com>
Cc:     Jiri Pirko <jiri@resnulli.us>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [net-next PATCH 1/2] devlink: add dry run attribute to flash
 update
Message-ID: <20220725133246.251e51b9@kernel.org>
In-Reply-To: <SA2PR11MB5100005E9FEB757A6364C2CFD6959@SA2PR11MB5100.namprd11.prod.outlook.com>
References: <20220720183433.2070122-1-jacob.e.keller@intel.com>
        <20220720183433.2070122-2-jacob.e.keller@intel.com>
        <YtjqJjIceW+fProb@nanopsycho>
        <SA2PR11MB51001777DC391C7E2626E84AD6919@SA2PR11MB5100.namprd11.prod.outlook.com>
        <YtpBR2ZnR2ieOg5E@nanopsycho>
        <CO1PR11MB508957F06BB96DD765A7580FD6909@CO1PR11MB5089.namprd11.prod.outlook.com>
        <YtwW4aMU96JSXIPw@nanopsycho>
        <SA2PR11MB5100E125B66263046B322DC1D6959@SA2PR11MB5100.namprd11.prod.outlook.com>
        <20220725123917.78863f79@kernel.org>
        <SA2PR11MB5100005E9FEB757A6364C2CFD6959@SA2PR11MB5100.namprd11.prod.outlook.com>
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

On Mon, 25 Jul 2022 20:27:02 +0000 Keller, Jacob E wrote:
> > ...or repost without the comment and move on. IDK if Jiri would like
> > to see the general problem of attr rejection solved right now but IMHO
> > it's perfectly fine to just make the user space DTRT.  
> 
> Its probably worth fixing policy, but would like to come up with a
> proper path that doesn't break compatibility and that will require
> discussion to figure out what approach works.

The problem does not exist for new commands, right? Because we don't
set GENL_DONT_VALIDATE_STRICT for new additions. For that reason I
don't think we are in the "sooner we fix the better" situation.
