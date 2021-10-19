Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 984534336B3
	for <lists+netdev@lfdr.de>; Tue, 19 Oct 2021 15:10:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235707AbhJSNNH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Oct 2021 09:13:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230267AbhJSNNH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Oct 2021 09:13:07 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92D59C06161C;
        Tue, 19 Oct 2021 06:10:54 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1mcotF-0004uo-TJ; Tue, 19 Oct 2021 15:10:49 +0200
Date:   Tue, 19 Oct 2021 15:10:49 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Naresh Kamboju <naresh.kamboju@linaro.org>
Cc:     open list <linux-kernel@vger.kernel.org>, selinux@vger.kernel.org,
        Linux-Next Mailing List <linux-next@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>, lkft-triage@lists.linaro.org,
        Florian Westphal <fw@strlen.de>,
        Paul Moore <paul@paul-moore.com>,
        Eric Paris <eparis@parisplace.org>,
        Stephen Smalley <stephen.smalley.work@gmail.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: [next] BUG: kernel NULL pointer dereference, address::
 selinux_ip_postroute_compat
Message-ID: <20211019131049.GE28644@breakpoint.cc>
References: <CA+G9fYuY3BJ9osvhwg0-YG=L+etgCBfCq0koC9BEkvK8-GR3ew@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+G9fYuY3BJ9osvhwg0-YG=L+etgCBfCq0koC9BEkvK8-GR3ew@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Naresh Kamboju <naresh.kamboju@linaro.org> wrote:
> Following kernel crash noticed on linux next 20211019 tag.
> on x86, i386 and other architectures.

Paul, this might be caused by
1d1e1ded13568be81a0e19d228e310a48997bec8
("selinux: make better use of the nf_hook_state passed to the NF
 hooks"), in particular this hunk here:

-       if (sk == NULL)
+       if (state->sk == NULL)
                return NF_ACCEPT;
+       sk = skb_to_full_sk(skb);
        sksec = sk->sk_security;

state->sk might not be related to skb->sk.
I suspect that this should instead be:

+       sk = skb_to_full_sk(skb);
        if (sk == NULL)

See 7026b1ddb6b8d4e6ee33dc2bd06c0ca8746fa7ab for the origin of this
additional socket pointer.

