Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F0BFC3ADB79
	for <lists+netdev@lfdr.de>; Sat, 19 Jun 2021 21:12:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234982AbhFSTOk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 19 Jun 2021 15:14:40 -0400
Received: from so254-9.mailgun.net ([198.61.254.9]:27418 "EHLO
        so254-9.mailgun.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230413AbhFSTOi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 19 Jun 2021 15:14:38 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1624129947; h=Message-ID: References: In-Reply-To: Subject:
 Cc: To: From: Date: Content-Transfer-Encoding: Content-Type:
 MIME-Version: Sender; bh=v1aNjp9Lda9GSx5Lj2kSSJlN8OFxXPLTUfIdUdht+Y4=;
 b=JUYKzg2YfbbA+THQj5qfMz/Megg6/JlicEMCyWFwJXOB/H7gv+sBp+BLRQTulFTD7ixDYLA2
 nPOztL8qPJdOl1qmsp/P60uzymT8LEu+Ic9rPa3PuB/2QpN0B1XfaxZvkTimx//7coG1M2dc
 LUpIrY1EOw+5JG7NOfmhd/DmkKw=
X-Mailgun-Sending-Ip: 198.61.254.9
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n06.prod.us-east-1.postgun.com with SMTP id
 60ce418a6ddc3305c4bfd0e7 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Sat, 19 Jun 2021 19:12:10
 GMT
Sender: subashab=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 07C69C43217; Sat, 19 Jun 2021 19:12:10 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=2.0 tests=ALL_TRUSTED,BAYES_00
        autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: subashab)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 3C948C433F1;
        Sat, 19 Jun 2021 19:12:09 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Sat, 19 Jun 2021 13:12:09 -0600
From:   subashab@codeaurora.org
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     Sean Tranchetti <stranche@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH net-next] net: qualcomm: rmnet: fix two pointer math bugs
In-Reply-To: <YM32lkJIJdSgpR87@mwanda>
References: <YM32lkJIJdSgpR87@mwanda>
Message-ID: <027ae9e2ddc18f0ed30c5d9c7075c8b9@codeaurora.org>
X-Sender: subashab@codeaurora.org
User-Agent: Roundcube Webmail/1.3.9
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021-06-19 07:52, Dan Carpenter wrote:
> We recently changed these two pointers from void pointers to struct
> pointers and it breaks the pointer math so now the "txphdr" points
> beyond the end of the buffer.
> 
> Fixes: 56a967c4f7e5 ("net: qualcomm: rmnet: Remove some unneeded 
> casts")
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> ---
>  drivers/net/ethernet/qualcomm/rmnet/rmnet_map_data.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/ethernet/qualcomm/rmnet/rmnet_map_data.c
> b/drivers/net/ethernet/qualcomm/rmnet/rmnet_map_data.c
> index 3ee5c1a8b46e..3676976c875b 100644
> --- a/drivers/net/ethernet/qualcomm/rmnet/rmnet_map_data.c
> +++ b/drivers/net/ethernet/qualcomm/rmnet/rmnet_map_data.c
> @@ -168,7 +168,7 @@ static void
> rmnet_map_complement_ipv4_txporthdr_csum_field(struct iphdr *ip4h)
>  	void *txphdr;
>  	u16 *csum;
> 
> -	txphdr = ip4h + ip4h->ihl * 4;
> +	txphdr = (void *)ip4h + ip4h->ihl * 4;
> 
>  	if (ip4h->protocol == IPPROTO_TCP || ip4h->protocol == IPPROTO_UDP) {
>  		csum = (u16 *)rmnet_map_get_csum_field(ip4h->protocol, txphdr);
> @@ -203,7 +203,7 @@
> rmnet_map_complement_ipv6_txporthdr_csum_field(struct ipv6hdr *ip6h)
>  	void *txphdr;
>  	u16 *csum;
> 
> -	txphdr = ip6h + sizeof(struct ipv6hdr);
> +	txphdr = ip6h + 1;
> 
>  	if (ip6h->nexthdr == IPPROTO_TCP || ip6h->nexthdr == IPPROTO_UDP) {
>  		csum = (u16 *)rmnet_map_get_csum_field(ip6h->nexthdr, txphdr);

Hi Dan

Thanks for fixing this. Could you cast the ip4h to char* instead of 
void*.
Looks like gcc might raise issues if -Wpointer-arith is used.

https://gcc.gnu.org/onlinedocs/gcc-4.5.0/gcc/Pointer-Arith.html#Pointer-Arith
