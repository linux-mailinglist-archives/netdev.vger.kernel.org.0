Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 49C75399C52
	for <lists+netdev@lfdr.de>; Thu,  3 Jun 2021 10:16:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229772AbhFCISa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Jun 2021 04:18:30 -0400
Received: from mailout1.secunet.com ([62.96.220.44]:60356 "EHLO
        mailout1.secunet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229667AbhFCISa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Jun 2021 04:18:30 -0400
Received: from cas-essen-02.secunet.de (unknown [10.53.40.202])
        by mailout1.secunet.com (Postfix) with ESMTP id E5D41800056;
        Thu,  3 Jun 2021 10:16:43 +0200 (CEST)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 cas-essen-02.secunet.de (10.53.40.202) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Thu, 3 Jun 2021 10:16:43 +0200
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2176.2; Thu, 3 Jun 2021
 10:16:43 +0200
Received: by gauss2.secunet.de (Postfix, from userid 1000)
        id 3219831801F6; Thu,  3 Jun 2021 10:16:43 +0200 (CEST)
Date:   Thu, 3 Jun 2021 10:16:43 +0200
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     "Ahmed S. Darwish" <a.darwish@linutronix.de>
CC:     Varad Gautam <varad.gautam@suse.com>,
        <linux-kernel@vger.kernel.org>,
        linux-rt-users <linux-rt-users@vger.kernel.org>,
        <netdev@vger.kernel.org>, <stable@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "Florian Westphal" <fw@strlen.de>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>
Subject: Re: [PATCH v2] xfrm: policy: Read seqcount outside of rcu-read side
 in xfrm_policy_lookup_bytype
Message-ID: <20210603081643.GW40979@gauss3.secunet.de>
References: <20210528120357.29542-1-varad.gautam@suse.com>
 <20210528160407.32127-1-varad.gautam@suse.com>
 <YLEd9RS8Cebjv2ho@lx-t490>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <YLEd9RS8Cebjv2ho@lx-t490>
X-ClientProxiedBy: cas-essen-01.secunet.de (10.53.40.201) To
 mbx-essen-01.secunet.de (10.53.40.197)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 28, 2021 at 06:44:37PM +0200, Ahmed S. Darwish wrote:
> On Fri, May 28, 2021, Varad Gautam wrote:
> >
> > Thead 1 (xfrm_hash_resize)	Thread 2 (xfrm_policy_lookup_bytype)
> >
> > 				rcu_read_lock();
> > mutex_lock(&hash_resize_mutex);
> > 				read_seqcount_begin(&xfrm_policy_hash_generation);
> > 				mutex_lock(&hash_resize_mutex); // block
> > xfrm_bydst_resize();
> > synchronize_rcu(); // block
> > 		<RCU stalls in xfrm_policy_lookup_bytype>
> >
> ...
> >
> > Fixes: 77cc278f7b20 ("xfrm: policy: Use sequence counters with associated lock")
> > Signed-off-by: Varad Gautam <varad.gautam@suse.com>
> 
> Acked-by: Ahmed S. Darwish <a.darwish@linutronix.de>

Applied, thanks a lot!
