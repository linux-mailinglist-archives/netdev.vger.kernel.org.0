Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 801A330A80
	for <lists+netdev@lfdr.de>; Fri, 31 May 2019 10:41:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726792AbfEaIlj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 May 2019 04:41:39 -0400
Received: from forwardcorp1p.mail.yandex.net ([77.88.29.217]:47778 "EHLO
        forwardcorp1p.mail.yandex.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726275AbfEaIlj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 May 2019 04:41:39 -0400
Received: from mxbackcorp1j.mail.yandex.net (mxbackcorp1j.mail.yandex.net [IPv6:2a02:6b8:0:1619::162])
        by forwardcorp1p.mail.yandex.net (Yandex) with ESMTP id CE2702E0AB0;
        Fri, 31 May 2019 11:41:36 +0300 (MSK)
Received: from smtpcorp1p.mail.yandex.net (smtpcorp1p.mail.yandex.net [2a02:6b8:0:1472:2741:0:8b6:10])
        by mxbackcorp1j.mail.yandex.net (nwsmtp/Yandex) with ESMTP id u5CC01sR0p-fapuG1Ip;
        Fri, 31 May 2019 11:41:36 +0300
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex-team.ru; s=default;
        t=1559292096; bh=edlakIqys1EdR30bTlTf/7K6sUUQ9lHl37saY9QUR/g=;
        h=In-Reply-To:References:Date:Message-ID:From:To:Subject;
        b=t+uyd+xUy0rwqBCTXxa3Vzm2snstqubkENUenaABLNup1R+4CBDyZX7AaSoNJ96Op
         8Ci7T7gdVW6NRsfuf9MbQ6ULfN5a4VowIhTZESwbTYlSVkHSO6ITeKBV0EGx6wUiYl
         eZaxtg9ldHL/3lc/ZNrfKUoIUmUTSc7nEcY2M9vU=
Authentication-Results: mxbackcorp1j.mail.yandex.net; dkim=pass header.i=@yandex-team.ru
Received: from dynamic-red.dhcp.yndx.net (dynamic-red.dhcp.yndx.net [2a02:6b8:0:40c:e11a:bf12:5fb7:ef8d])
        by smtpcorp1p.mail.yandex.net (nwsmtp/Yandex) with ESMTPSA id us6fNVY8LI-fZdSAmGp;
        Fri, 31 May 2019 11:41:36 +0300
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (Client certificate not present)
Subject: Re: [PATCH] net/neighbour: fix potential null pointer deference
To:     Young Xiao <92siuyang@gmail.com>, davem@davemloft.net,
        dsahern@gmail.com, roopa@cumulusnetworks.com, christian@brauner.io,
        netdev@vger.kernel.org
References: <1559291383-5814-1-git-send-email-92siuyang@gmail.com>
From:   Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
Message-ID: <d4fac6b5-e392-b7a8-4287-ffa3aef79f4e@yandex-team.ru>
Date:   Fri, 31 May 2019 11:41:35 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <1559291383-5814-1-git-send-email-92siuyang@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-CA
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 31.05.2019 11:29, Young Xiao wrote:
> There is a possible null pointer deference bugs in neigh_fill_info(),
> which is similar to the bug which was fixed in commit 6adc5fd6a142
> ("net/neighbour: fix crash at dumping device-agnostic proxy entries").

Have you seen this in real life?
I see nobody who could produce neighbour with null device pointer._

> 
> Signed-off-by: Young Xiao <92siuyang@gmail.com>
> ---
>   net/core/neighbour.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/net/core/neighbour.c b/net/core/neighbour.c
> index dfa8710..33c3ff1 100644
> --- a/net/core/neighbour.c
> +++ b/net/core/neighbour.c
> @@ -2440,7 +2440,7 @@ static int neigh_fill_info(struct sk_buff *skb, struct neighbour *neigh,
>   	ndm->ndm_pad2    = 0;
>   	ndm->ndm_flags	 = neigh->flags;
>   	ndm->ndm_type	 = neigh->type;
> -	ndm->ndm_ifindex = neigh->dev->ifindex;
> +	ndm->ndm_ifindex = neigh->dev ? neigh->dev->ifindex : 0;
>   
>   	if (nla_put(skb, NDA_DST, neigh->tbl->key_len, neigh->primary_key))
>   		goto nla_put_failure;
> 
