Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 66D741C96CB
	for <lists+netdev@lfdr.de>; Thu,  7 May 2020 18:46:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727808AbgEGQqs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 May 2020 12:46:48 -0400
Received: from correo.us.es ([193.147.175.20]:40798 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726393AbgEGQqr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 7 May 2020 12:46:47 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id C98A411EB49
        for <netdev@vger.kernel.org>; Thu,  7 May 2020 18:46:45 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id B9B7211540C
        for <netdev@vger.kernel.org>; Thu,  7 May 2020 18:46:45 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id AE6FB11540E; Thu,  7 May 2020 18:46:45 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id A26C22066B;
        Thu,  7 May 2020 18:46:43 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Thu, 07 May 2020 18:46:43 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 86DDF42EF4E0;
        Thu,  7 May 2020 18:46:43 +0200 (CEST)
Date:   Thu, 7 May 2020 18:46:43 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Edward Cree <ecree@solarflare.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net,
        netfilter-devel@vger.kernel.org, jiri@resnulli.us, kuba@kernel.org
Subject: Re: [RFC PATCH net] net: flow_offload: simplify hw stats check
 handling
Message-ID: <20200507164643.GA10994@salvia>
References: <49176c41-3696-86d9-f0eb-c20207cd6d23@solarflare.com>
 <20200507153231.GA10250@salvia>
 <9000b990-9a25-936e-6063-0034429256f0@solarflare.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9000b990-9a25-936e-6063-0034429256f0@solarflare.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 07, 2020 at 04:49:15PM +0100, Edward Cree wrote:
> On 07/05/2020 16:32, Pablo Neira Ayuso wrote:
> > On Thu, May 07, 2020 at 03:59:09PM +0100, Edward Cree wrote:
> >> Make FLOW_ACTION_HW_STATS_DONT_CARE be all bits, rather than none, so that
> >>  drivers and __flow_action_hw_stats_check can use simple bitwise checks.
> > 
> > You have have to explain why this makes sense in terms of semantics.
> > 
> > _DISABLED and _ANY are contradicting each other.
> No, they aren't.  The DISABLED bit means "I will accept disabled", it doesn't
>  mean "I insist on disabled".  What _does_ mean "I insist on disabled" is if
>  the DISABLED bit is set and no other bits are.
> So DISABLED | ANY means "I accept disabled; I also accept immediate or
>  delayed".  A.k.a. "I don't care, do what you like".

Jiri said Disabled means: bail out if you cannot disable it.

If the driver cannot disable, then it will have to check if the
frontend is asking for Disabled (hence, report error to the frontend)
or if it is actually asking for Don't care.

What you propose is a context-based interpretation of the bits. So
semantics depend on how you accumulate/combine bits.

I really think bits semantics should be interpreted on the bit alone
itself.

There is one exception though, that is _ANY case, where you let the
driver pick between delayed or immediate. But if the driver does not
support for counters, it bails out in any case, so the outcome in both
request is basically the same.

You are asking for different outcome depending on how bits are
combined, which can be done, but it sounds innecessarily complicated
to me.
