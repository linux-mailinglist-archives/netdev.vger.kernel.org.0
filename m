Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CFE4E30A82
	for <lists+netdev@lfdr.de>; Fri, 31 May 2019 10:42:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726799AbfEaImg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 May 2019 04:42:36 -0400
Received: from mx1.redhat.com ([209.132.183.28]:54782 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726275AbfEaImg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 31 May 2019 04:42:36 -0400
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 240673078AAC;
        Fri, 31 May 2019 08:42:31 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.32.181.103])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1C7D817507;
        Fri, 31 May 2019 08:42:25 +0000 (UTC)
Message-ID: <4105f63de712c8aa462aff6e3042d8689f68a33f.camel@redhat.com>
Subject: Re: [PATCH] net/neighbour: fix potential null pointer deference
From:   Paolo Abeni <pabeni@redhat.com>
To:     Young Xiao <92siuyang@gmail.com>, davem@davemloft.net,
        dsahern@gmail.com, roopa@cumulusnetworks.com, christian@brauner.io,
        khlebnikov@yandex-team.ru, netdev@vger.kernel.org
Date:   Fri, 31 May 2019 10:42:25 +0200
In-Reply-To: <1559291383-5814-1-git-send-email-92siuyang@gmail.com>
References: <1559291383-5814-1-git-send-email-92siuyang@gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.30.5 (3.30.5-1.fc29) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.48]); Fri, 31 May 2019 08:42:36 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 2019-05-31 at 16:29 +0800, Young Xiao wrote:
> There is a possible null pointer deference bugs in neigh_fill_info(),
> which is similar to the bug which was fixed in commit 6adc5fd6a142
> ("net/neighbour: fix crash at dumping device-agnostic proxy entries").
> 
> Signed-off-by: Young Xiao <92siuyang@gmail.com>
> ---
>  net/core/neighbour.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/net/core/neighbour.c b/net/core/neighbour.c
> index dfa8710..33c3ff1 100644
> --- a/net/core/neighbour.c
> +++ b/net/core/neighbour.c
> @@ -2440,7 +2440,7 @@ static int neigh_fill_info(struct sk_buff *skb, struct neighbour *neigh,
>  	ndm->ndm_pad2    = 0;
>  	ndm->ndm_flags	 = neigh->flags;
>  	ndm->ndm_type	 = neigh->type;
> -	ndm->ndm_ifindex = neigh->dev->ifindex;
> +	ndm->ndm_ifindex = neigh->dev ? neigh->dev->ifindex : 0;
>  
>  	if (nla_put(skb, NDA_DST, neigh->tbl->key_len, neigh->primary_key))
>  		goto nla_put_failure;

AFAICS, neigh->dev is requested to be != NULL at neighbour creation
time (see ___neigh_create()), so the above NULL ptr dereference looks
impossible. Am I missing something?

Thanks,

Paolo



