Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 375AD42BB6F
	for <lists+netdev@lfdr.de>; Wed, 13 Oct 2021 11:22:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239031AbhJMJYm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Oct 2021 05:24:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230150AbhJMJYl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Oct 2021 05:24:41 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5BF7EC061570;
        Wed, 13 Oct 2021 02:22:38 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1maaT5-00043q-Sh; Wed, 13 Oct 2021 11:22:35 +0200
Date:   Wed, 13 Oct 2021 11:22:35 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Eugene Crosser <crosser@average.org>
Cc:     netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
        Lahav Schlesinger <lschlesinger@drivenets.com>,
        David Ahern <dsahern@kernel.org>
Subject: Re: Commit 09e856d54bda5f288ef8437a90ab2b9b3eab83d1r "vrf: Reset skb
 conntrack connection on VRF rcv" breaks expected netfilter behaviour
Message-ID: <20211013092235.GA32450@breakpoint.cc>
References: <bca5dcab-ef6b-8711-7f99-8d86e79d76eb@average.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bca5dcab-ef6b-8711-7f99-8d86e79d76eb@average.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Eugene Crosser <crosser@average.org> wrote:
> Maybe a better solution for stray conntrack entries would be to
> introduce finer control in netfilter? One possible idea would be to
> implement both "track" and "notrack" targets; then a working
> configuration would look like this:

'track' is hard to implement correctly because of RELATED traffic.

E.g. 'tcp dport 22 track' won't work correctly because icmp pmtu
won't be handled.

I'd suggest to try a conditional nf_ct_reset that keeps the conntrack
entry if its in another zone.

I can't think of another solution at the moment, the existing behaviour
of resetting conntrack entry for postrouting/output is too old,
otherwise the better solution IMO would be to keep that entry around on
egress if a NAT rewrite has been done. This would avoid the 'double snat'
problem that the 'reset on ingress' tries to solve.
