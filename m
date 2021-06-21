Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E1863AE4CE
	for <lists+netdev@lfdr.de>; Mon, 21 Jun 2021 10:29:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230206AbhFUIcH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Jun 2021 04:32:07 -0400
Received: from mailout1.secunet.com ([62.96.220.44]:57788 "EHLO
        mailout1.secunet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230137AbhFUIcG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Jun 2021 04:32:06 -0400
Received: from cas-essen-01.secunet.de (unknown [10.53.40.201])
        by mailout1.secunet.com (Postfix) with ESMTP id 2005D80004E;
        Mon, 21 Jun 2021 10:29:50 +0200 (CEST)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 cas-essen-01.secunet.de (10.53.40.201) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Mon, 21 Jun 2021 10:29:49 +0200
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2176.2; Mon, 21 Jun
 2021 10:29:49 +0200
Received: by gauss2.secunet.de (Postfix, from userid 1000)
        id 899D131803E8; Mon, 21 Jun 2021 10:29:49 +0200 (CEST)
Date:   Mon, 21 Jun 2021 10:29:49 +0200
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     Varad Gautam <varad.gautam@suse.com>
CC:     <linux-kernel@vger.kernel.org>,
        linux-rt-users <linux-rt-users@vger.kernel.org>,
        <netdev@vger.kernel.org>, Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        "Jakub Kicinski" <kuba@kernel.org>,
        Florian Westphal <fw@strlen.de>,
        "Ahmed S. Darwish" <a.darwish@linutronix.de>,
        Frederic Weisbecker <frederic@kernel.org>,
        <stable@vger.kernel.org>
Subject: Re: [PATCH] xfrm: policy: Restructure RCU-read locking in
 xfrm_sk_policy_lookup
Message-ID: <20210621082949.GX40979@gauss3.secunet.de>
References: <20210618141101.18168-1-varad.gautam@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20210618141101.18168-1-varad.gautam@suse.com>
X-ClientProxiedBy: cas-essen-02.secunet.de (10.53.40.202) To
 mbx-essen-01.secunet.de (10.53.40.197)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 18, 2021 at 04:11:01PM +0200, Varad Gautam wrote:
> Commit "xfrm: policy: Read seqcount outside of rcu-read side in
> xfrm_policy_lookup_bytype" [Linked] resolved a locking bug in
> xfrm_policy_lookup_bytype that causes an RCU reader-writer deadlock on
> the mutex wrapped by xfrm_policy_hash_generation on PREEMPT_RT since
> 77cc278f7b20 ("xfrm: policy: Use sequence counters with associated
> lock").
> 
> However, xfrm_sk_policy_lookup can still reach xfrm_policy_lookup_bytype
> while holding rcu_read_lock(), as:
> xfrm_sk_policy_lookup()
>   rcu_read_lock()
>   security_xfrm_policy_lookup()
>     xfrm_policy_lookup()

Hm, I don't see that call chain. security_xfrm_policy_lookup() calls
a hook with the name xfrm_policy_lookup. The only LSM that has
registered a function to that hook is selinux. It registers
selinux_xfrm_policy_lookup() and I don't see how we can call
xfrm_policy_lookup() from there.

Did you actually trigger that bug?

