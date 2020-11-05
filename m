Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 21B1B2A8554
	for <lists+netdev@lfdr.de>; Thu,  5 Nov 2020 18:53:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727376AbgKERxs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Nov 2020 12:53:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:37682 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725862AbgKERxs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 5 Nov 2020 12:53:48 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D160120709;
        Thu,  5 Nov 2020 17:53:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604598827;
        bh=aWk23RoG/q2I9hI1+3STHfRXlrFIPvZBFjmYdVDSUGU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Qi2D/N6cPltdD3uTy09WmDK8mXmdcwh7hm2lmYMQtxuxz3T76pG+NxiQkS5iOlxdy
         fOHax2mgdcqFWMvlmZkcxVRoV68ejJ4xpDBLnhAaYp/QEG4BctWIrhn7BRT7WO+WJB
         YnsVA3pffqYSE5p2NkxC9sE/5vDbrHx3shzXfhiw=
Date:   Thu, 5 Nov 2020 09:53:44 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Vinay Kumar Yadav <vinay.yadav@chelsio.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, borisp@nvidia.com,
        secdev@chelsio.com
Subject: Re: [PATCH net] net/tls: Fix kernel panic when socket is in TLS ULP
Message-ID: <20201105095344.0edecafa@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <976e0bb7-1846-94cc-0be7-9a9e62563130@chelsio.com>
References: <20201103104702.798-1-vinay.yadav@chelsio.com>
        <20201104171609.78d410db@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <976e0bb7-1846-94cc-0be7-9a9e62563130@chelsio.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 5 Nov 2020 23:20:13 +0530 Vinay Kumar Yadav wrote:
> On 11/5/2020 6:46 AM, Jakub Kicinski wrote:
> > On Tue,  3 Nov 2020 16:17:03 +0530 Vinay Kumar Yadav wrote:  
> >> user can initialize tls ulp using setsockopt call on socket
> >> before listen() in case of tls-toe (TLS_HW_RECORD) and same
> >> setsockopt call on connected socket in case of kernel tls (TLS_SW).
> >> In presence of tls-toe devices, TLS ulp is initialized, tls context
> >> is allocated per listen socket and socket is listening at adapter
> >> as well as kernel tcp stack. now consider the scenario, connections
> >> are established in kernel stack.
> >> on every connection close which is established in kernel stack,
> >> it clears tls context which is created on listen socket causing
> >> kernel panic.
> >> Addressed the issue by setting child socket to base (non TLS ULP)
> >> when tls ulp is initialized on parent socket (listen socket).
> >>
> >> Fixes: 76f7164d02d4 ("net/tls: free ctx in sock destruct")
> >> Signed-off-by: Vinay Kumar Yadav <vinay.yadav@chelsio.com>  
> > 
> > We should prevent from the socket getting into LISTEN state in the
> > first place. Can we make a copy of proto_ops (like tls_sw_proto_ops)
> > and set listen to sock_no_listen?
> 
> Once tls-toe (TLS_HW_RECORD) is configured on a socket, listen() call 
> from user on same socket will create hash at two places.

What I'm saying is - disallow listen calls on sockets with tls-toe
installed on them. Is that not possible?

> tls_toe_hash() ---> ctx->sk_proto->hash(sk); dev->hash(dev, sk);
> 
> when connection establishes, same sock is cloned in case of both
> (connection in adapter or kernel stack).
> 
> Please suggest if we can handle it other way?

