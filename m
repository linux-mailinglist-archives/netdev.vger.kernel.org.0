Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4036F2553FD
	for <lists+netdev@lfdr.de>; Fri, 28 Aug 2020 07:20:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726626AbgH1FUI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Aug 2020 01:20:08 -0400
Received: from a.mx.secunet.com ([62.96.220.36]:36570 "EHLO a.mx.secunet.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725849AbgH1FUH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 28 Aug 2020 01:20:07 -0400
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id 15DC92055E;
        Fri, 28 Aug 2020 07:20:06 +0200 (CEST)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id QiY9wRnrxaYN; Fri, 28 Aug 2020 07:20:04 +0200 (CEST)
Received: from mail-essen-01.secunet.de (mail-essen-01.secunet.de [10.53.40.204])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id E939720504;
        Fri, 28 Aug 2020 07:20:04 +0200 (CEST)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 mail-essen-01.secunet.de (10.53.40.204) with Microsoft SMTP Server (TLS) id
 14.3.487.0; Fri, 28 Aug 2020 07:20:04 +0200
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1979.3; Fri, 28 Aug
 2020 07:20:04 +0200
Received: by gauss2.secunet.de (Postfix, from userid 1000)      id C6EAB3180662;
 Fri, 28 Aug 2020 07:20:03 +0200 (CEST)
Date:   Fri, 28 Aug 2020 07:20:03 +0200
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     Antony Antony <antony.antony@secunet.com>
CC:     <netdev@vger.kernel.org>, Herbert Xu <herbert@gondor.apana.org.au>,
        "Antony Antony" <antony@phenome.org>
Subject: Re: [PATCH v2 4/4] xfrm: clone whole liftime_cur structure in
 xfrm_do_migrate
Message-ID: <20200828052003.GD20687@gauss3.secunet.de>
References: <20200820181158.GA19658@moon.secunet.de>
 <20200826194026.GA15058@moon.secunet.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20200826194026.GA15058@moon.secunet.de>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: cas-essen-01.secunet.de (10.53.40.201) To
 mbx-essen-01.secunet.de (10.53.40.197)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 26, 2020 at 09:40:40PM +0200, Antony Antony wrote:
> When we clone state only add_time was cloned. It missed values like
> bytes, packets.  Now clone the all members of the structure.
> 
> Fixes: 80c9abaabf42 ("[XFRM]: Extension for dynamic update of endpoint address(es)")
> Signed-off-by: Antony Antony <antony.antony@secunet.com>
> ---
>  net/xfrm/xfrm_state.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/net/xfrm/xfrm_state.c b/net/xfrm/xfrm_state.c
> index 16988303aed6..64eb4a6fcfc2 100644
> --- a/net/xfrm/xfrm_state.c
> +++ b/net/xfrm/xfrm_state.c
> @@ -1550,7 +1550,7 @@ static struct xfrm_state *xfrm_state_clone(struct xfrm_state *orig,
>  	x->tfcpad = orig->tfcpad;
>  	x->replay_maxdiff = orig->replay_maxdiff;
>  	x->replay_maxage = orig->replay_maxage;
> -	x->curlft.add_time = orig->curlft.add_time;
> +	x->curlft = orig->curlft;

You should use memcpy if you want to copy the whole structure.
