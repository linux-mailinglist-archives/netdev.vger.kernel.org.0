Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD1B8283FCD
	for <lists+netdev@lfdr.de>; Mon,  5 Oct 2020 21:42:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729462AbgJETlu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Oct 2020 15:41:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:48018 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729302AbgJETlu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 5 Oct 2020 15:41:50 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2A97E20774;
        Mon,  5 Oct 2020 19:41:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601926909;
        bh=jSsAklYOf8IQB+0s6ZbzUR7PCdmtSyzIP/CXie6dVrg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=OoesGSpMqT4L1q5rob/g17xsW6B9UwbKyto13uv5kwWWSNzHzasgkCxZJAfIsJEaL
         3G8rHLw9zdKNiCehz4116wh7de5/6jjRkUBgEZA+4MCUHbC13PfdQLT8hbseT1Vh21
         mfxwYTFkel1CsGhCaCNNShx/y9HyvZq1nV7zRU60=
Date:   Mon, 5 Oct 2020 12:41:47 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kernel-team@fb.com,
        jiri@resnulli.us, andrew@lunn.ch, mkubecek@suse.cz
Subject: Re: [PATCH net-next 1/6] ethtool: wire up get policies to ops
Message-ID: <20201005124147.1d4111e7@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <3e793f3b5c99bb4a5584d621b1dd5b30e62d81f2.camel@sipsolutions.net>
References: <20201005155753.2333882-1-kuba@kernel.org>
        <20201005155753.2333882-2-kuba@kernel.org>
        <631a2328a95d0dd06d901cdb411c3eb06f90bda7.camel@sipsolutions.net>
        <20201005121622.55607210@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <de5a03325d397fe559ce6c6182dfedc0cdad2c3b.camel@sipsolutions.net>
        <20201005123120.7e8caa84@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <3e793f3b5c99bb4a5584d621b1dd5b30e62d81f2.camel@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 05 Oct 2020 21:33:55 +0200 Johannes Berg wrote:
> > What I'm saying is that my preference would be:
> > 
> > const struct nla_policy policy[OTHER_ATTR + 1] = {
> > 	[HEADER]	= NLA_POLICY(...)
> > 	[OTHER_ATTR]	= NLA_POLICY(...)
> > };
> > 
> > extern const struct nla_policy policy[OTHER_ATTR + 1];
> > 
> > op = {
> > 	.policy = policy,
> > 	.max_attr = ARRAY_SIZE(policy) - 1,
> > }
> > 
> > Since it's harder to forget to update the op (you don't have to update
> > op, and compiler will complain about the extern out of sync).  
> 
> Yeah.
> 
> I was thinking the third way ;-)
> 
> const struct nla_policy policy[] = {
> 	[HEADER]	= NLA_POLICY(...)
> 	[OTHER_ATTR]	= NLA_POLICY(...)
> };
> 
> op = {
> 	.policy = policy,
> 	.maxattr = ARRAY_SIZE(policy) - 1,
> };
> 
> 
> Now you can freely add any attributes, and, due to strict validation,
> anything not specified in the policy will be rejected, whether by being
> out of range (> maxattr) or not specified (NLA_UNSPEC).

100%, but in ethtool policy is defined in a different compilation unit
than the op array.
