Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F0F724A73F
	for <lists+netdev@lfdr.de>; Wed, 19 Aug 2020 21:52:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726989AbgHSTwb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Aug 2020 15:52:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726585AbgHSTwa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Aug 2020 15:52:30 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0E38C061384
        for <netdev@vger.kernel.org>; Wed, 19 Aug 2020 12:52:29 -0700 (PDT)
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.94)
        (envelope-from <johannes@sipsolutions.net>)
        id 1k8U8H-00717h-7d; Wed, 19 Aug 2020 21:52:25 +0200
Message-ID: <b9ffb2eedde8e6e3c4c2d6ef44c262e06373d8b1.camel@sipsolutions.net>
Subject: Re: [PATCH] netlink: fix state reallocation in policy export
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org
Date:   Wed, 19 Aug 2020 21:52:15 +0200
In-Reply-To: <20200819121006.7f6615e4@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <20200819122255.6b32aa54d205.I316de8a67c79a393ae1826a1b2dcc08f31b1856e@changeid>
         <20200819121006.7f6615e4@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2020-08-19 at 12:10 -0700, Jakub Kicinski wrote:
 
> > +	memset(&state->policies[state->n_alloc], 0,
> > +	       sizeof(state->policies[0]) * (n_alloc - state->n_alloc));
> 
> [flex_]array_size() ? To avoid the inevitable follow up from a bot..

Yeah, hmm.

I suppose you know this but we can't really overflow anything here since
all of the factors are kernel controlled; you can't really have enough
policies in memory to overflow this, I'd think. We walk the constant
policies and their nested policies - nl80211 is a *heavy* user and only
recently went >10 policies linked together (triggering the bug)...

Really what we need is kzrealloc() ;-)

I'll send a v2 using flex_array_size(), it doesn't look any worse and I
don't care about the overflow check either since it's not at all a fast-
path.

johannes

