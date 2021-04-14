Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E99F135F175
	for <lists+netdev@lfdr.de>; Wed, 14 Apr 2021 12:24:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233816AbhDNKYo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Apr 2021 06:24:44 -0400
Received: from mailout2.secunet.com ([62.96.220.49]:59536 "EHLO
        mailout2.secunet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233996AbhDNKYd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Apr 2021 06:24:33 -0400
X-Greylist: delayed 756 seconds by postgrey-1.27 at vger.kernel.org; Wed, 14 Apr 2021 06:24:32 EDT
Received: from cas-essen-02.secunet.de (unknown [10.53.40.202])
        by mailout2.secunet.com (Postfix) with ESMTP id D0C08800051;
        Wed, 14 Apr 2021 12:11:28 +0200 (CEST)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 cas-essen-02.secunet.de (10.53.40.202) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Wed, 14 Apr 2021 12:11:28 +0200
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2176.2; Wed, 14 Apr
 2021 12:11:28 +0200
Received: by gauss2.secunet.de (Postfix, from userid 1000)
        id 2788331803A8; Wed, 14 Apr 2021 12:11:28 +0200 (CEST)
Date:   Wed, 14 Apr 2021 12:11:28 +0200
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
CC:     <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
        <yoshfuji@linux-ipv6.org>, <dsahern@kernel.org>, <kuba@kernel.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] esp6: Simplify the calculation of variables
Message-ID: <20210414101128.GY62598@gauss3.secunet.de>
References: <1618307835-83161-1-git-send-email-jiapeng.chong@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1618307835-83161-1-git-send-email-jiapeng.chong@linux.alibaba.com>
X-ClientProxiedBy: cas-essen-01.secunet.de (10.53.40.201) To
 mbx-essen-01.secunet.de (10.53.40.197)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 13, 2021 at 05:57:15PM +0800, Jiapeng Chong wrote:
> Fix the following coccicheck warnings:
> 
> ./net/ipv6/esp6_offload.c:321:32-34: WARNING !A || A && B is equivalent
> to !A || B.
> 
> Reported-by: Abaci Robot <abaci@linux.alibaba.com>
> Signed-off-by: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
> ---
>  net/ipv6/esp6_offload.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/net/ipv6/esp6_offload.c b/net/ipv6/esp6_offload.c
> index 4af56af..40ed4fc 100644
> --- a/net/ipv6/esp6_offload.c
> +++ b/net/ipv6/esp6_offload.c
> @@ -318,7 +318,7 @@ static int esp6_xmit(struct xfrm_state *x, struct sk_buff *skb,  netdev_features
>  	esp.plen = esp.clen - skb->len - esp.tfclen;
>  	esp.tailen = esp.tfclen + esp.plen + alen;
>  
> -	if (!hw_offload || (hw_offload && !skb_is_gso(skb))) {
> +	if (!hw_offload || !skb_is_gso(skb)) {
>  		esp.nfrags = esp6_output_head(x, skb, &esp);
>  		if (esp.nfrags < 0)
>  			return esp.nfrags;

That one is already in ipsec-next:

Commit f076835a8bf2aa6ea48f718e4506587c815ab99f
Author: Junlin Yang <yangjunlin@yulong.com>
Date:   Thu Mar 11 10:07:56 2021 +0800

    esp6: remove a duplicative condition

    Fixes coccicheck warnings:
    ./net/ipv6/esp6_offload.c:319:32-34:
    WARNING !A || A && B is equivalent to !A || B

    Signed-off-by: Junlin Yang <yangjunlin@yulong.com>
    Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>

