Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 700B5396C0C
	for <lists+netdev@lfdr.de>; Tue,  1 Jun 2021 06:20:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230063AbhFAEWg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Jun 2021 00:22:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:43430 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229491AbhFAEWd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 1 Jun 2021 00:22:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EBE6C6135D;
        Tue,  1 Jun 2021 04:20:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622521253;
        bh=s1jFIDeqCQ9weYzltcR9NGUTexPyHMP93HqOhHVdb20=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=FiGF1+Ot+7/PnNvH10NggXPm4lp5ynJCuPVXavSbvBovFoUbCx6b0uu4IW7z9X75l
         uiRXEr+XMKB9jxdoRD9y1L5apOIuQfpIuZAyxl+A+w7udeyMO+KLIGk/4RjjtLHxYT
         AD/04CU0hY+PO8k6PdFp58MCGymHeIA/lYgK/U6zrSzEo0ewA9A803jl8d8YH4iWVR
         AOosb4z/hHNeNCmP4x13+u6F2/ZpGzIWP859BB+VSa/9Hb+ypC/+y2NjZ2shsXXMv+
         QLeoJ2Q6xTZJY9sJ8m5HxFHujb1oxdLbOzV3pjWMQnfD0GnCnO6LUuWGIn/V8grHnI
         Rm/HMd+8PKqsg==
Date:   Mon, 31 May 2021 21:20:52 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Justin Iurman <justin.iurman@uliege.be>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, tom@herbertland.com
Subject: Re: [PATCH net-next v4 2/5] ipv6: ioam: Data plane support for
 Pre-allocated Trace
Message-ID: <20210531212052.14aca857@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <1696168387.35309838.1622461844972.JavaMail.zimbra@uliege.be>
References: <20210527151652.16074-1-justin.iurman@uliege.be>
        <20210527151652.16074-3-justin.iurman@uliege.be>
        <20210529140555.3536909f@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
        <1678535209.34108899.1622370998279.JavaMail.zimbra@uliege.be>
        <1616887215.34203636.1622386231363.JavaMail.zimbra@uliege.be>
        <20210530130519.2fc95684@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
        <1696168387.35309838.1622461844972.JavaMail.zimbra@uliege.be>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 31 May 2021 13:50:44 +0200 (CEST) Justin Iurman wrote:
> >> Actually, it's more than for semantic reasons. Take the following topology:
> >> 
> >>  _____              _____              _____
> >> |     | eth0  eth0 |     | eth1  eth0 |     |
> >> |  A  |.----------.|  B  |.----------.|  C  |
> >> |_____|            |_____|            |_____|
> >> 
> >> If I only want IOAM to be deployed from A to C but not from C to A,
> >> then I would need the following on B (let's just focus on B):
> >> 
> >> B.eth0.ioam6_enabled = 1 // enable IOAM *on input* for B.eth0
> >> B.eth0.ioam6_id = B1
> >> B.eth1.ioam6_id = B2
> >> 
> >> Back to your suggestion, if I only had one field (i.e., ioam6_id != 0
> >> to enable IOAM), I would end up with:
> >> 
> >> B.eth0.ioam6_id = B1 // (!= 0)
> >> B.eth1.ioam6_id = B2 // (!= 0)
> >> 
> >> Which means in this case that IOAM would also be enabled on B for the
> >> reverse path. So we definitely need two fields to distinguish both
> >> the status (enabled/disabled) and the IOAM ID of an interface.  
> > 
> > Makes sense. Is it okay to assume 0 is equivalent to ~0, though:
> > 
> > +		raw32 = dev_net(skb->dev)->ipv6.sysctl.ioam6_id;
> > +		if (!raw32)
> > +			raw32 = IOAM6_EMPTY_u24;
> > 
> > etc. Quick grep through the RFC only reveals that ~0 is special (not
> > available). Should we init ids to ~0 instead of 0 explicitly?  
> 
> Yes, I think so. And it is indeed correct to assume that. So, if it's
> fine for you to init IDs to ~0, then it'd be definitely a big yes
> from me.

Yes, we can init the sysctl to ~0, I don't see why not.
