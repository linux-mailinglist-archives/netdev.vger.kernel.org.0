Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE4F0283FE0
	for <lists+netdev@lfdr.de>; Mon,  5 Oct 2020 21:51:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729481AbgJETvE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Oct 2020 15:51:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:51154 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729424AbgJETvD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 5 Oct 2020 15:51:03 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 24D5C208C3;
        Mon,  5 Oct 2020 19:51:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601927463;
        bh=1T+9kQ3pjH7MeGK2jXGXy3H/l8OUyrnaJiqS5Zg5sX0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=EzfPiglmn2b/vAR8ot+ESA7GLGEA+xlFbHIbRpJMCE9JcXpc/b5Jle/b2AbwEaG0q
         u7FYFH5BDXD3altpn4evsZN5k0jgd7H1L5b/DElERzEGx1T50QXys0soziYaADQRk0
         uUK2GmOXdn/n9qH8C0dgyGpPrkLbzv0aRSD5lWyE=
Date:   Mon, 5 Oct 2020 12:51:01 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kernel-team@fb.com,
        jiri@resnulli.us, andrew@lunn.ch, mkubecek@suse.cz
Subject: Re: [PATCH net-next 1/6] ethtool: wire up get policies to ops
Message-ID: <20201005125101.5681ce22@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <d896585af214e015963a9989375246242bc1bb65.camel@sipsolutions.net>
References: <20201005155753.2333882-1-kuba@kernel.org>
        <20201005155753.2333882-2-kuba@kernel.org>
        <631a2328a95d0dd06d901cdb411c3eb06f90bda7.camel@sipsolutions.net>
        <20201005121622.55607210@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <de5a03325d397fe559ce6c6182dfedc0cdad2c3b.camel@sipsolutions.net>
        <20201005123120.7e8caa84@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <3e793f3b5c99bb4a5584d621b1dd5b30e62d81f2.camel@sipsolutions.net>
        <20201005124147.1d4111e7@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <d896585af214e015963a9989375246242bc1bb65.camel@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 05 Oct 2020 21:46:02 +0200 Johannes Berg wrote:
> On Mon, 2020-10-05 at 12:41 -0700, Jakub Kicinski wrote:
> 
> > > Now you can freely add any attributes, and, due to strict validation,
> > > anything not specified in the policy will be rejected, whether by being
> > > out of range (> maxattr) or not specified (NLA_UNSPEC).  
> > 
> > 100%, but in ethtool policy is defined in a different compilation unit
> > than the op array.  
> 
> Ah. OK, then that won't work, of course, never mind.
> 
> I'd probably go with your preference then, but perhaps drop the actual
> size definition:
> 
> const struct nla_policy policy[] = {
> ...
> };
> 
> extern const struct nla_policy policy[OTHER_ATTR + 1];
> 
> op = {
>         .policy = policy,
>         .max_attr = ARRAY_SIZE(policy) - 1,
> }
> 
> 
> But that'd really just be to save typing copying it if it ever changes,
> since it's compiler checked for consistency.

Sounds good, will do (unless Michal speaks up and prefers otherwise :)).
