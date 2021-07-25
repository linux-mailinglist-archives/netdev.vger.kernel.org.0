Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E47B33D5078
	for <lists+netdev@lfdr.de>; Mon, 26 Jul 2021 00:52:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229829AbhGYWLt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 25 Jul 2021 18:11:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229531AbhGYWLs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 25 Jul 2021 18:11:48 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB856C061757;
        Sun, 25 Jul 2021 15:52:17 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1m7myW-0004UM-SO; Mon, 26 Jul 2021 00:52:01 +0200
Date:   Mon, 26 Jul 2021 00:52:00 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Casey Schaufler <casey@schaufler-ca.com>
Cc:     Florian Westphal <fw@strlen.de>, Paul Moore <paul@paul-moore.com>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        linux-security-module@vger.kernel.org, selinux@vger.kernel.org
Subject: Re: [PATCH RFC 0/9] sk_buff: optimize layout for GRO
Message-ID: <20210725225200.GL9904@breakpoint.cc>
References: <cover.1626879395.git.pabeni@redhat.com>
 <1252ad17-3460-5e6a-8f0d-05d91a1a7b96@schaufler-ca.com>
 <e6200ddd38510216f9f32051ce1acff21fc9c6d0.camel@redhat.com>
 <2e9e57f0-98f9-b64d-fd82-aecef84835c5@schaufler-ca.com>
 <d3fe6ae85b8fad9090288c553f8d248603758506.camel@redhat.com>
 <CAHC9VhT0uuBdmmT1HhMjjQswiJxWuy3cZdRQZ4Zzf-H8n5arLQ@mail.gmail.com>
 <20210724185141.GJ9904@breakpoint.cc>
 <CAHC9VhSsNWSus4xr7erxQs_4GyfJYb7_6a8juisWue6Xc4fVkQ@mail.gmail.com>
 <20210725162528.GK9904@breakpoint.cc>
 <75982e4e-f6b1-ade2-311f-1532254e2764@schaufler-ca.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <75982e4e-f6b1-ade2-311f-1532254e2764@schaufler-ca.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Casey Schaufler <casey@schaufler-ca.com> wrote:
> RedHat and android use SELinux and will want this. Ubuntu doesn't
> yet, but netfilter in in the AppArmor task list. Tizen definitely
> uses it with Smack. The notion that security modules are only used
> in fringe cases is antiquated. 

I was not talking about LSM in general, I was referring to the
extended info that Paul mentioned.

If thats indeed going to be used on every distro then skb extensions
are not suitable for this, it would result in extr akmalloc for every
skb.

> > It certainly makes more sense to me than doing lookups
> > in a hashtable based on a ID
> 
> Agreed. The data burden required to support a hash scheme
> for the security module stacking case is staggering.

It depends on the type of data (and its lifetime).

I suspect you have something that is more like skb->dev/dst,
i.e. reference to object that persists after the skb is free'd.
