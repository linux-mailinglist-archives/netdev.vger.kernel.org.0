Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A404128030B
	for <lists+netdev@lfdr.de>; Thu,  1 Oct 2020 17:41:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732279AbgJAPly (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Oct 2020 11:41:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:54210 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731885AbgJAPly (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 1 Oct 2020 11:41:54 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AC86A206C1;
        Thu,  1 Oct 2020 15:41:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601566914;
        bh=BhwFqApviRpZw8db5ELZXyorHG5BVTMPnHkw1dEjWyc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=m9YGBkArLPoYswD8nksalXPwBt+6ut9wH2fZQ+zCaHqJBfhLm5UfYPICELEWV3j1p
         Z2qxo1FqrJOFi90HCOA3QUpWVKRxjVPb9tBR8EU6RvQmivBYswU1hmUH9YX6liK3mv
         HsAxXikCW2palX34Mqrz/9wBMUZPrHrbw07JREOM=
Date:   Thu, 1 Oct 2020 08:41:52 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     netdev@vger.kernel.org, andrew@lunn.ch, jiri@resnulli.us,
        mkubecek@suse.cz, dsahern@kernel.org, pablo@netfilter.org
Subject: Re: [RFC net-next 9/9] genetlink: allow dumping command-specific
 policy
Message-ID: <20201001084152.33cc5bf2@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <591d18f08b82a84c5dc19b110962dabc598c479d.camel@sipsolutions.net>
References: <20201001000518.685243-1-kuba@kernel.org>
        <20201001000518.685243-10-kuba@kernel.org>
        <591d18f08b82a84c5dc19b110962dabc598c479d.camel@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 01 Oct 2020 09:59:47 +0200 Johannes Berg wrote:
> On Wed, 2020-09-30 at 17:05 -0700, Jakub Kicinski wrote:
> > Right now CTRL_CMD_GETPOLICY can only dump the family-wide
> > policy. Support dumping policy of a specific op.  
> 
> So, hmm.
> 
> Yeah, I guess this is fine, but you could end up having to do a lot of
> dumps, and with e.g. ethtool you'd end up with a lot of duplicate data
> too, since it's structured as
> 
> 
> common_policy = { ... }
> 
> cmd1_policy = {
> 	[CMD1_COMMON] = NLA_NESTED_POLICY(common_policy),
> 	...
> };
> 
> cmd2_policy = {
> 	[CMD2_COMMON] = NLA_NESTED_POLICY(common_policy),
> 	...
> };
> 
> etc.
> 
> 
> So you end up dumping per command (and in practice, since they can be
> different, you now *have to* unless you know out-of-band that there are
> no per-command policies).
> 
> 
> Even if I don't have a good idea now on how to avoid the duplication, it
> might be nicer to have a (flag) attribute here for "CTRL_ATTR_ALL_OPS"?

Hm. How would you see the dump structured? We need to annotate the root
policies with the command. Right now I have:

 [ATTR_FAMILY_ID]
 [ATTR_OP]
 [ATTR_POLICY]
   [policy idx]
     [attr idx]
       [bla]
       [bla]
       [bla]

But if we're dumping _all_ the policy to op mapping is actually 1:n,
so we'd need to restructure the dump a lil' bit and have OP only
reported on root of the policy and make it a nested array.

Alternatively we could report OP -> policy mapping in a separate
message?

WDYT?
