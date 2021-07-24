Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 105FD3D4948
	for <lists+netdev@lfdr.de>; Sat, 24 Jul 2021 20:51:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230205AbhGXSLX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 24 Jul 2021 14:11:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229865AbhGXSLX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 24 Jul 2021 14:11:23 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B019FC061575;
        Sat, 24 Jul 2021 11:51:54 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1m7MkP-0007qR-Tl; Sat, 24 Jul 2021 20:51:41 +0200
Date:   Sat, 24 Jul 2021 20:51:41 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Paul Moore <paul@paul-moore.com>
Cc:     Paolo Abeni <pabeni@redhat.com>,
        Casey Schaufler <casey@schaufler-ca.com>,
        netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Florian Westphal <fw@strlen.de>,
        Eric Dumazet <edumazet@google.com>,
        linux-security-module@vger.kernel.org, selinux@vger.kernel.org
Subject: Re: [PATCH RFC 0/9] sk_buff: optimize layout for GRO
Message-ID: <20210724185141.GJ9904@breakpoint.cc>
References: <cover.1626879395.git.pabeni@redhat.com>
 <1252ad17-3460-5e6a-8f0d-05d91a1a7b96@schaufler-ca.com>
 <e6200ddd38510216f9f32051ce1acff21fc9c6d0.camel@redhat.com>
 <2e9e57f0-98f9-b64d-fd82-aecef84835c5@schaufler-ca.com>
 <d3fe6ae85b8fad9090288c553f8d248603758506.camel@redhat.com>
 <CAHC9VhT0uuBdmmT1HhMjjQswiJxWuy3cZdRQZ4Zzf-H8n5arLQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHC9VhT0uuBdmmT1HhMjjQswiJxWuy3cZdRQZ4Zzf-H8n5arLQ@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Paul Moore <paul@paul-moore.com> wrote:
 > Tow main drivers on my side:
> > - there are use cases/deployments that do not use them.
> > - moving them around was doable in term of required changes.
> >
> > There are no "slow-path" implications on my side. For example, vlan_*
> > fields are very critical performance wise, if the traffic is tagged.
> > But surely there are busy servers not using tagget traffic which will
> > enjoy the reduced cachelines footprint, and this changeset will not
> > impact negatively the first case.
> >
> > WRT to the vlan example, secmark and nfct require an extra conditional
> > to fetch the data. My understanding is that such additional conditional
> > is not measurable performance-wise when benchmarking the security
> > modules (or conntrack) because they have to do much more intersting
> > things after fetching a few bytes from an already hot cacheline.
> >
> > Not sure if the above somehow clarify my statements.
> >
> > As for expanding secmark to 64 bits, I guess that could be an
> > interesting follow-up discussion :)
> 
> The intersection between netdev and the LSM has a long and somewhat
> tortured past with each party making sacrifices along the way to get
> where we are at today.  It is far from perfect, at least from a LSM
> perspective, but it is what we've got and since performance is usually
> used as a club to beat back any changes proposed by the LSM side, I
> would like to object to these changes that negatively impact the LSM
> performance without some concession in return.  It has been a while
> since Casey and I have spoken about this, but I think the prefered
> option would be to exchange the current __u32 "sk_buff.secmark" field
> with a void* "sk_buff.security" field, like so many other kernel level
> objects.  Previous objections have eventually boiled down to the
> additional space in the sk_buff for the extra bits (there is some
> additional editorializing that could be done here, but I'll refrain),
> but based on the comments thus far in this thread it sounds like
> perhaps we can now make a deal here: move the LSM field down to a
> "colder" cacheline in exchange for converting the LSM field to a
> proper pointer.
> 
> Thoughts?

Is there a summary disucssion somewhere wrt. what exactly LSMs need?

There is the skb extension infra, does that work for you?
