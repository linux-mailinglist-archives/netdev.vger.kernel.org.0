Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C6EFC46E564
	for <lists+netdev@lfdr.de>; Thu,  9 Dec 2021 10:20:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234522AbhLIJYb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Dec 2021 04:24:31 -0500
Received: from a.mx.secunet.com ([62.96.220.36]:48840 "EHLO a.mx.secunet.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232940AbhLIJYa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 9 Dec 2021 04:24:30 -0500
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id 210B3204FD;
        Thu,  9 Dec 2021 10:20:56 +0100 (CET)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id fcZGp3W5uWt8; Thu,  9 Dec 2021 10:20:55 +0100 (CET)
Received: from mailout1.secunet.com (mailout1.secunet.com [62.96.220.44])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id 477912049A;
        Thu,  9 Dec 2021 10:20:53 +0100 (CET)
Received: from cas-essen-02.secunet.de (unknown [10.53.40.202])
        by mailout1.secunet.com (Postfix) with ESMTP id 37F6380004A;
        Thu,  9 Dec 2021 10:20:53 +0100 (CET)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 cas-essen-02.secunet.de (10.53.40.202) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.14; Thu, 9 Dec 2021 10:20:38 +0100
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2176.14; Thu, 9 Dec
 2021 10:20:37 +0100
Received: by gauss2.secunet.de (Postfix, from userid 1000)
        id 570CC3182EEE; Thu,  9 Dec 2021 10:20:36 +0100 (CET)
Date:   Thu, 9 Dec 2021 10:20:36 +0100
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>
CC:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Cong Wang <amwang@redhat.com>
Subject: Re: [PATCH net-next] xfrm: use net device refcount tracker helpers
Message-ID: <20211209092036.GK427717@gauss3.secunet.de>
References: <20211207193203.2706158-1-eric.dumazet@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20211207193203.2706158-1-eric.dumazet@gmail.com>
X-ClientProxiedBy: cas-essen-01.secunet.de (10.53.40.201) To
 mbx-essen-01.secunet.de (10.53.40.197)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 07, 2021 at 11:32:03AM -0800, Eric Dumazet wrote:
> From: Eric Dumazet <edumazet@google.com>
> 
> xfrm4_fill_dst() and xfrm6_fill_dst() build dst,
> getting a device reference that will likely be released
> by standard dst_release() code.
> 
> We have to track these references or risk a warning if
> CONFIG_NET_DEV_REFCNT_TRACKER=y
> 
> Note to XFRM maintainers :
> 
> Error path in xfrm6_fill_dst() releases the reference,
> but does not clear xdst->u.dst.dev, so I wonder
> if this could lead to double dev_put() in some cases,
> where a dst_release() _is_ called by the callers in their
> error path.

Yes, looks like it can, so this should be fixed.

> 
> This extra dev_put() was added in commit 84c4a9dfbf430 ("xfrm6:
> release dev before returning error")
> 
> Fixes: 9038c320001d ("net: dst: add net device refcount tracking to dst_entry")
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Cc: Cong Wang <amwang@redhat.com>
> Cc: Steffen Klassert <steffen.klassert@secunet.com>

As the refcount tracking infrastructure is not yet in ipsec-next:

Acked-by: Steffen Klassert <steffen.klassert@secunet.com>

Thanks!
