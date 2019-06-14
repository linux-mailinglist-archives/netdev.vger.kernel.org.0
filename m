Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 799E945802
	for <lists+netdev@lfdr.de>; Fri, 14 Jun 2019 10:54:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726930AbfFNIxt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Jun 2019 04:53:49 -0400
Received: from a.mx.secunet.com ([62.96.220.36]:58022 "EHLO a.mx.secunet.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726202AbfFNIxt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 14 Jun 2019 04:53:49 -0400
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id 7A72A201DA;
        Fri, 14 Jun 2019 10:53:47 +0200 (CEST)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id uXX0zk-f0Pkv; Fri, 14 Jun 2019 10:53:47 +0200 (CEST)
Received: from mail-essen-01.secunet.de (mail-essen-01.secunet.de [10.53.40.204])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id 1539F200AC;
        Fri, 14 Jun 2019 10:53:47 +0200 (CEST)
Received: from gauss2.secunet.de (10.182.7.193) by mail-essen-01.secunet.de
 (10.53.40.204) with Microsoft SMTP Server id 14.3.439.0; Fri, 14 Jun 2019
 10:53:47 +0200
Received: by gauss2.secunet.de (Postfix, from userid 1000)      id B08F33180B3C;
 Fri, 14 Jun 2019 10:53:46 +0200 (CEST)
Date:   Fri, 14 Jun 2019 10:53:46 +0200
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     Young Xiao <92siuyang@gmail.com>
CC:     <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] af_key: Fix memory leak in key_notify_policy.
Message-ID: <20190614085346.GN17989@gauss3.secunet.de>
References: <1560500786-572-1-git-send-email-92siuyang@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1560500786-572-1-git-send-email-92siuyang@gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 14, 2019 at 04:26:26PM +0800, Young Xiao wrote:
> We leak the allocated out_skb in case pfkey_xfrm_policy2msg() fails.
> Fix this by freeing it on error.
> 
> Signed-off-by: Young Xiao <92siuyang@gmail.com>
> ---
>  net/key/af_key.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/net/key/af_key.c b/net/key/af_key.c
> index 4af1e1d..ec414f6 100644
> --- a/net/key/af_key.c
> +++ b/net/key/af_key.c
> @@ -2443,6 +2443,7 @@ static int key_pol_get_resp(struct sock *sk, struct xfrm_policy *xp, const struc
>  	}
>  	err = pfkey_xfrm_policy2msg(out_skb, xp, dir);
>  	if (err < 0)
> +		kfree_skb(out_skb);
>  		goto out;

Did you test this?

You need to add braces, otherwise 'goto out' will happen unconditionally.

>  
>  	out_hdr = (struct sadb_msg *) out_skb->data;
> @@ -2695,6 +2696,7 @@ static int dump_sp(struct xfrm_policy *xp, int dir, int count, void *ptr)
>  
>  	err = pfkey_xfrm_policy2msg(out_skb, xp, dir);
>  	if (err < 0)
> +		kfree_skb(out_skb);
>  		return err;

Same here.
