Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A0993D4EB5
	for <lists+netdev@lfdr.de>; Sun, 25 Jul 2021 18:35:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230075AbhGYPpJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 25 Jul 2021 11:45:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229545AbhGYPpJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 25 Jul 2021 11:45:09 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 547FCC061757;
        Sun, 25 Jul 2021 09:25:39 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1m7gwS-0003O6-CZ; Sun, 25 Jul 2021 18:25:28 +0200
Date:   Sun, 25 Jul 2021 18:25:28 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Paul Moore <paul@paul-moore.com>
Cc:     Florian Westphal <fw@strlen.de>, Paolo Abeni <pabeni@redhat.com>,
        Casey Schaufler <casey@schaufler-ca.com>,
        netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        linux-security-module@vger.kernel.org, selinux@vger.kernel.org
Subject: Re: [PATCH RFC 0/9] sk_buff: optimize layout for GRO
Message-ID: <20210725162528.GK9904@breakpoint.cc>
References: <cover.1626879395.git.pabeni@redhat.com>
 <1252ad17-3460-5e6a-8f0d-05d91a1a7b96@schaufler-ca.com>
 <e6200ddd38510216f9f32051ce1acff21fc9c6d0.camel@redhat.com>
 <2e9e57f0-98f9-b64d-fd82-aecef84835c5@schaufler-ca.com>
 <d3fe6ae85b8fad9090288c553f8d248603758506.camel@redhat.com>
 <CAHC9VhT0uuBdmmT1HhMjjQswiJxWuy3cZdRQZ4Zzf-H8n5arLQ@mail.gmail.com>
 <20210724185141.GJ9904@breakpoint.cc>
 <CAHC9VhSsNWSus4xr7erxQs_4GyfJYb7_6a8juisWue6Xc4fVkQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHC9VhSsNWSus4xr7erxQs_4GyfJYb7_6a8juisWue6Xc4fVkQ@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Paul Moore <paul@paul-moore.com> wrote:
> > There is the skb extension infra, does that work for you?
> 
> I was hopeful that when the skb_ext capability was introduced we might
> be able to use it for the LSM(s), but when I asked netdev if they
> would be willing to accept patches to leverage the skb_ext
> infrastructure I was told "no".

I found

https://lore.kernel.org/netdev/CAHC9VhSz1_KA1tCJtNjwK26BOkGhKGbPT7v1O82mWPduvWwd4A@mail.gmail.com/#r

and from what I gather from your comments and that of Casey
I think skb extensions is the correct thing for this (i.e., needs
netlabel/secid config/enablement so typically won't be active on
a distro kernel by default).

It certainly makes more sense to me than doing lookups
in a hashtable based on a ID (I tried to do that to get rid of skb->nf_bridge
pointer years ago and it I could not figure out how to invalidate an entry
without adding a new skb destructor callback).
