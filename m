Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1183C24F8FC
	for <lists+netdev@lfdr.de>; Mon, 24 Aug 2020 11:39:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729600AbgHXJjx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Aug 2020 05:39:53 -0400
Received: from a.mx.secunet.com ([62.96.220.36]:44370 "EHLO a.mx.secunet.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728894AbgHXIqe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 24 Aug 2020 04:46:34 -0400
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id A193420523;
        Mon, 24 Aug 2020 10:46:32 +0200 (CEST)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id Y937E9JgfOG3; Mon, 24 Aug 2020 10:46:31 +0200 (CEST)
Received: from cas-essen-02.secunet.de (202.40.53.10.in-addr.arpa [10.53.40.202])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id C73202051F;
        Mon, 24 Aug 2020 10:46:31 +0200 (CEST)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 cas-essen-02.secunet.de (10.53.40.202) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Mon, 24 Aug 2020 10:46:31 +0200
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1979.3; Mon, 24 Aug
 2020 10:46:31 +0200
Received: by gauss2.secunet.de (Postfix, from userid 1000)
        id 41B8F3180449; Mon, 24 Aug 2020 10:46:31 +0200 (CEST)
Date:   Mon, 24 Aug 2020 10:46:31 +0200
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     Antony Antony <antony.antony@secunet.com>
CC:     <netdev@vger.kernel.org>, Herbert Xu <herbert@gondor.apana.org.au>,
        "Antony Antony" <antony@phenome.org>
Subject: Re: [PATCH 3/3] xfrm: clone XFRMA_SEC_CTX during xfrm_do_migrate
Message-ID: <20200824084631.GP20687@gauss3.secunet.de>
References: <20200820181158.GA19658@moon.secunet.de>
 <20200820181608.GA19772@moon.secunet.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20200820181608.GA19772@moon.secunet.de>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: cas-essen-01.secunet.de (10.53.40.201) To
 mbx-essen-01.secunet.de (10.53.40.197)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 20, 2020 at 08:16:08PM +0200, Antony Antony wrote:
> XFRMA_SEC_CTX was not cloned from the old to the new.
> Migrate this attribute during XFRMA_MSG_MIGRATE
> 
> Signed-off-by: Antony Antony <antony.antony@secunet.com>
> ---
>  net/xfrm/xfrm_state.c | 28 ++++++++++++++++++++++++++++
>  1 file changed, 28 insertions(+)
> 
> diff --git a/net/xfrm/xfrm_state.c b/net/xfrm/xfrm_state.c
> index 20a12c67a931..dbcb71b800b8 100644
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
> +		return true;
> +
> +	uctx->exttype = XFRMA_SEC_CTX;
> +	uctx->len = size;
> +	uctx->ctx_doi = security->ctx_doi;
> +	uctx->ctx_alg = security->ctx_alg;
> +	uctx->ctx_len = security->ctx_len;
> +	memcpy(uctx + 1, security->ctx_str, security->ctx_len);
> +	err = security_xfrm_state_alloc(x, uctx);
> +	kfree(uctx);
> +	if (err)
> +		return true;

Returning 'true' on memory allocation errors is a bit odd,
please return -ENOMEM instead.

