Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B0072553FA
	for <lists+netdev@lfdr.de>; Fri, 28 Aug 2020 07:19:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726146AbgH1FST (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Aug 2020 01:18:19 -0400
Received: from a.mx.secunet.com ([62.96.220.36]:36524 "EHLO a.mx.secunet.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725809AbgH1FSS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 28 Aug 2020 01:18:18 -0400
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id 7FF7C205DB;
        Fri, 28 Aug 2020 07:18:16 +0200 (CEST)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id 14p-fLBfBE6M; Fri, 28 Aug 2020 07:18:15 +0200 (CEST)
Received: from mail-essen-02.secunet.de (mail-essen-02.secunet.de [10.53.40.205])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id 428FA2055E;
        Fri, 28 Aug 2020 07:18:15 +0200 (CEST)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 mail-essen-02.secunet.de (10.53.40.205) with Microsoft SMTP Server (TLS) id
 14.3.487.0; Fri, 28 Aug 2020 07:18:15 +0200
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1979.3; Fri, 28 Aug
 2020 07:18:14 +0200
Received: by gauss2.secunet.de (Postfix, from userid 1000)      id 914283180662;
 Fri, 28 Aug 2020 07:18:14 +0200 (CEST)
Date:   Fri, 28 Aug 2020 07:18:14 +0200
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     Antony Antony <antony.antony@secunet.com>
CC:     <netdev@vger.kernel.org>, Herbert Xu <herbert@gondor.apana.org.au>,
        "Antony Antony" <antony@phenome.org>
Subject: Re: [PATCH v2 3/4] xfrm: clone XFRMA_SEC_CTX in xfrm_do_migrate
Message-ID: <20200828051814.GC20687@gauss3.secunet.de>
References: <20200820181158.GA19658@moon.secunet.de>
 <20200826194009.GA15030@moon.secunet.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20200826194009.GA15030@moon.secunet.de>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: cas-essen-02.secunet.de (10.53.40.202) To
 mbx-essen-01.secunet.de (10.53.40.197)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 26, 2020 at 09:40:09PM +0200, Antony Antony wrote:
> XFRMA_SEC_CTX was not cloned from the old to the new.
> Migrate this attribute during XFRMA_MSG_MIGRATE
> 
> v1->v2:
>  - return -ENOMEM on error
> 
> Fixes: 80c9abaabf42 ("[XFRM]: Extension for dynamic update of endpoint address(es)")
> Signed-off-by: Antony Antony <antony.antony@secunet.com>
> ---
>  net/xfrm/xfrm_state.c | 28 ++++++++++++++++++++++++++++
>  1 file changed, 28 insertions(+)
> 
> diff --git a/net/xfrm/xfrm_state.c b/net/xfrm/xfrm_state.c
> index 3a000f289dcd..16988303aed6 100644
> --- a/net/xfrm/xfrm_state.c
> +++ b/net/xfrm/xfrm_state.c
> @@ -1441,6 +1441,30 @@ int xfrm_state_add(struct xfrm_state *x)
>  EXPORT_SYMBOL(xfrm_state_add);
>  
>  #ifdef CONFIG_XFRM_MIGRATE
> +static inline bool clone_security(struct xfrm_state *x, struct xfrm_sec_ctx *security)
> +{
> +	struct xfrm_user_sec_ctx *uctx;
> +	int size = sizeof(*uctx) + security->ctx_len;
> +	int err;
> +
> +	uctx = kmalloc(size, GFP_KERNEL);
> +	if (!uctx)
> +		return -ENOMEM;

Now that this function returns error values, it should be
of type 'int' not 'bool'.

