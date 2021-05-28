Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 47C20394602
	for <lists+netdev@lfdr.de>; Fri, 28 May 2021 18:45:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236258AbhE1Qqi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 May 2021 12:46:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235710AbhE1Qqf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 May 2021 12:46:35 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A835C061574;
        Fri, 28 May 2021 09:44:41 -0700 (PDT)
Date:   Fri, 28 May 2021 18:44:37 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1622220279;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=MM/fYlgGh387J6P2lgkdYt7pFux0FECvUjgf+Lt7YEM=;
        b=H3aDHB9C1CRQ7mhy6uWO5eta+z8bvP7br4OWLOtZ5PZbpoLBW9jH/len3RLer3rypH4/EJ
        qyIZ3JgIUzETrn65te7SlpJkneIpOZeQzHt5Oz8KTAvPyMnJA21YZS//ngaYt+senX75ft
        iGra+Ea9s/w5+S4x7QHUIBfK6OxVi7/Lh9V9ZNC3WDL8Xvr2Kd8XuBlyXmI+WE3PIKKyx+
        b4IT/v5t6d7WWDOqNV13Cb0RqXRR5jHPbndGiH7lV06dzcOVZsXod1Qjbd4b4mDajK2hBp
        0IrSXdWbSNVtbaABBM19yDgBRZ/HOqcuHdREI1hIUAnmK8G9/FFY+OXI6ZrqoA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1622220279;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=MM/fYlgGh387J6P2lgkdYt7pFux0FECvUjgf+Lt7YEM=;
        b=hfb/qxn1syliAp0nMJggRr/rVQ29hRm6PaKz3PonsdTNrwKvwxFG4+vHIKNN+O2rGQDZE1
        efe5QY63d6VDorCA==
From:   "Ahmed S. Darwish" <a.darwish@linutronix.de>
To:     Varad Gautam <varad.gautam@suse.com>
Cc:     linux-kernel@vger.kernel.org,
        linux-rt-users <linux-rt-users@vger.kernel.org>,
        netdev@vger.kernel.org, stable@vger.kernel.org,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Florian Westphal <fw@strlen.de>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>
Subject: Re: [PATCH v2] xfrm: policy: Read seqcount outside of rcu-read side
 in xfrm_policy_lookup_bytype
Message-ID: <YLEd9RS8Cebjv2ho@lx-t490>
References: <20210528120357.29542-1-varad.gautam@suse.com>
 <20210528160407.32127-1-varad.gautam@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210528160407.32127-1-varad.gautam@suse.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 28, 2021, Varad Gautam wrote:
>
> Thead 1 (xfrm_hash_resize)	Thread 2 (xfrm_policy_lookup_bytype)
>
> 				rcu_read_lock();
> mutex_lock(&hash_resize_mutex);
> 				read_seqcount_begin(&xfrm_policy_hash_generation);
> 				mutex_lock(&hash_resize_mutex); // block
> xfrm_bydst_resize();
> synchronize_rcu(); // block
> 		<RCU stalls in xfrm_policy_lookup_bytype>
>
...
>
> Fixes: 77cc278f7b20 ("xfrm: policy: Use sequence counters with associated lock")
> Signed-off-by: Varad Gautam <varad.gautam@suse.com>

Acked-by: Ahmed S. Darwish <a.darwish@linutronix.de>
