Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A902652F113
	for <lists+netdev@lfdr.de>; Fri, 20 May 2022 18:50:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347235AbiETQuP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 May 2022 12:50:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239565AbiETQuN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 May 2022 12:50:13 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 440AD36313
        for <netdev@vger.kernel.org>; Fri, 20 May 2022 09:50:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C42E261E76
        for <netdev@vger.kernel.org>; Fri, 20 May 2022 16:50:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D66F5C385A9;
        Fri, 20 May 2022 16:50:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653065412;
        bh=qWLxXVYRQ/qtEpXVWNFXSRg534yfFjTKs7wBQsMpy3A=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ACC3/88Hp0JJ5Pj08fFGNyw/Y13U7J5fxDyccN72gg3ZoI3QJ8d9JGbaCWGShxANY
         I1syGlCRfUW6nW2IykGtyEzB92S5s7dh7n02vD2yMCk/a/0ALbF+78lXQ9XjVY673d
         Z2mTogUDD09oN/Z2Xs7E2QtbTSg6I7DS5N8NUywuHuspGKjZllDPkKLIjYA7FhnlTN
         Rh415EBZoA7ze99wE7MryVj3671OEqjZIIb5qaxfvTnCKFPb8avqHtevdOxuZsPIBn
         FmcDVNT+atmmPFPxyvB9hRIjCFYr0vzg5iJwGSah9uvKmLUhzWXbmm1n2oP/V1B61n
         wvp9s9owW19eg==
Date:   Fri, 20 May 2022 09:50:10 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     David Laight <David.Laight@ACULAB.COM>
Cc:     "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "edumazet@google.com" <edumazet@google.com>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "jesse.brandeburg@intel.com" <jesse.brandeburg@intel.com>,
        "anthony.l.nguyen@intel.com" <anthony.l.nguyen@intel.com>
Subject: Re: [PATCH net-next] eth: ice: silence the GCC 12 array-bounds
 warning
Message-ID: <20220520095010.0f85db7f@kernel.org>
In-Reply-To: <fbde22661c6b4d5f82ca47d5703ab7a8@AcuMS.aculab.com>
References: <20220520060906.2311308-1-kuba@kernel.org>
        <fbde22661c6b4d5f82ca47d5703ab7a8@AcuMS.aculab.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 20 May 2022 12:58:35 +0000 David Laight wrote:
> > +# FIXME: temporarily silence -Warray-bounds on non W=1 builds
> > +ifndef KBUILD_EXTRA_WARN
> > +CFLAGS_ice_switch.o += $(call cc-disable-warning, array-bounds)
> > +endif
> > --
> > 2.34.3  
> 
> Is it possible to just add:
> 
> CFLAGS_ice_switch.o += $(disable-Warray-bounds)
> 
> and then ensure that disable-Warray-bounds is defined
> (and expanded) by the time it is actually expanded?
> This might be before or after the makefile is expanded.
> But it would mean that the work is only done once.
> I've an idea that 'call cc-disable-warning' is non-trivial.

Happy to do whatever's recommended but the $(disable-Warray-bounds)
does not work, I still see the warning.
