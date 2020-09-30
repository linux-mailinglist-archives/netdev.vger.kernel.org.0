Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BFEC427EE61
	for <lists+netdev@lfdr.de>; Wed, 30 Sep 2020 18:06:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731261AbgI3QGy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Sep 2020 12:06:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728081AbgI3QGv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Sep 2020 12:06:51 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8DA81C061755
        for <netdev@vger.kernel.org>; Wed, 30 Sep 2020 09:06:51 -0700 (PDT)
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.94)
        (envelope-from <johannes@sipsolutions.net>)
        id 1kNecv-00DqdA-BV; Wed, 30 Sep 2020 18:06:45 +0200
Message-ID: <fce613c2b4c797de4be413afddf872fd6dae9ef8.camel@sipsolutions.net>
Subject: Re: Genetlink per cmd policies
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Jakub Kicinski <kuba@kernel.org>, Jiri Pirko <jiri@resnulli.us>,
        Michal Kubecek <mkubecek@suse.cz>, dsahern@kernel.org,
        pablo@netfilter.org
Cc:     netdev@vger.kernel.org
Date:   Wed, 30 Sep 2020 18:06:28 +0200
In-Reply-To: <20200930084955.71a8c0ba@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <20200930084955.71a8c0ba@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jakub,

> I'd like to be able to dump ethtool nl policies, but right now policy
> dumping is only supported for "global" family policies.

Did ethtool add per-command policies?

> Is there any reason not to put the policy in struct genl_ops, 
> or just nobody got to it, yet?
> 
> I get the feeling that this must have been discussed before...

Sort of, yeah.

We actually *had* per-command policies, and I removed it in commit
3b0f31f2b8c9 ("genetlink: make policy common to family"), mostly because
the maxattr is actually in the family not the op, so having a policy in
each op was never really a good idea and well-supported.

Additionally, having the pointer in each op (and if you want to do it
right you also need maxattr in each op) significantly increases the
binary size there, as well as boilerplate code to type it out, though
the latter could be avoided by "falling back" to the family policy.

So at the time, that reduced nl80211 size by 824 bytes, which I guess
means we had 103 ops at the time. Doing it right with maxattr would cost
twice as much as just the policy pointer, and we probably have a few
more ops now, so we're looking at a cost of ~1.6k for it.

Personally, I'm not really convinced that there really is a need for it,
but then I haven't really looked that much at ethtool. In most cases,
you want some "common" attributes for the family, even if it's only the
interface index or such, because also on the userspace side that's
awkward if you have to really build *everything* including such
identifying information per command. The one or two families that
actually had different policies per command (at the time I removed it)
actually solved this by "aliasing" the same attribute number between the
different policies, but again that feels rather awkward ...

That's the historic info I guess - I'll take a look at ethtool later and
see what it's doing there.

johannes

