Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AABD448BF01
	for <lists+netdev@lfdr.de>; Wed, 12 Jan 2022 08:32:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348807AbiALHcq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Jan 2022 02:32:46 -0500
Received: from a.mx.secunet.com ([62.96.220.36]:57788 "EHLO a.mx.secunet.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1348740AbiALHcp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 12 Jan 2022 02:32:45 -0500
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id 1E7752058E;
        Wed, 12 Jan 2022 08:32:44 +0100 (CET)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id W_5yKYO15ycv; Wed, 12 Jan 2022 08:32:43 +0100 (CET)
Received: from mailout2.secunet.com (mailout2.secunet.com [62.96.220.49])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id 5585320096;
        Wed, 12 Jan 2022 08:32:43 +0100 (CET)
Received: from cas-essen-01.secunet.de (unknown [10.53.40.201])
        by mailout2.secunet.com (Postfix) with ESMTP id 4F38980004A;
        Wed, 12 Jan 2022 08:32:43 +0100 (CET)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 cas-essen-01.secunet.de (10.53.40.201) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Wed, 12 Jan 2022 08:32:43 +0100
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.17; Wed, 12 Jan
 2022 08:32:42 +0100
Received: by gauss2.secunet.de (Postfix, from userid 1000)
        id 79F1B3180D7C; Wed, 12 Jan 2022 08:32:42 +0100 (CET)
Date:   Wed, 12 Jan 2022 08:32:42 +0100
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     Yan Yan <evitayan@google.com>
CC:     <netdev@vger.kernel.org>, Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, <lorenzo@google.com>,
        <maze@google.com>, <nharold@google.com>, <benedictwong@google.com>
Subject: Re: [PATCH v1 1/2] xfrm: Check if_id in xfrm_migrate
Message-ID: <20220112073242.GA1223722@gauss3.secunet.de>
References: <20220108013230.56294-1-evitayan@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20220108013230.56294-1-evitayan@google.com>
X-ClientProxiedBy: cas-essen-02.secunet.de (10.53.40.202) To
 mbx-essen-01.secunet.de (10.53.40.197)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 07, 2022 at 05:32:30PM -0800, Yan Yan wrote:
> This patch enables distinguishing SAs and SPs based on if_id during
> the xfrm_migrate flow. This ensures support for xfrm interfaces
> throughout the SA/SP lifecycle.
> 
> When there are multiple existing SPs with the same direction,
> the same xfrm_selector and different endpoint addresses,
> xfrm_migrate might fail with ENODATA.
> 
> Specifically, the code path for performing xfrm_migrate is:
>   Stage 1: find policy to migrate with
>     xfrm_migrate_policy_find(sel, dir, type, net)
>   Stage 2: find and update state(s) with
>     xfrm_migrate_state_find(mp, net)
>   Stage 3: update endpoint address(es) of template(s) with
>     xfrm_policy_migrate(pol, m, num_migrate)
> 
> Currently "Stage 1" always returns the first xfrm_policy that
> matches, and "Stage 3" looks for the xfrm_tmpl that matches the
> old endpoint address. Thus if there are multiple xfrm_policy
> with same selector, direction, type and net, "Stage 1" might
> rertun a wrong xfrm_policy and "Stage 3" will fail with ENODATA
> because it cannot find a xfrm_tmpl with the matching endpoint
> address.
> 
> The fix is to allow userspace to pass an if_id and add if_id
> to the matching rule in Stage 1 and Stage 2 since if_id is a
> unique ID for xfrm_policy and xfrm_state. For compatibility,
> if_id will only be checked if the attribute is set.
> 
> Tested with additions to Android's kernel unit test suite:
> https://android-review.googlesource.com/c/kernel/tests/+/1668886
> 
> Signed-off-by: Yan Yan <evitayan@google.com>

What is the difference between this patch and the one with
the same subject you sent on Jan 5th?
