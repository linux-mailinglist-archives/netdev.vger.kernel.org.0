Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E30665F74D0
	for <lists+netdev@lfdr.de>; Fri,  7 Oct 2022 09:45:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229901AbiJGHpG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Oct 2022 03:45:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229838AbiJGHpD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Oct 2022 03:45:03 -0400
Received: from proxima.lasnet.de (proxima.lasnet.de [IPv6:2a01:4f8:121:31eb:3::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB3DE28E2D;
        Fri,  7 Oct 2022 00:45:00 -0700 (PDT)
Received: from [IPV6:2003:e9:d724:a7dd:f566:73:8aea:58ff] (p200300e9d724a7ddf56600738aea58ff.dip0.t-ipconnect.de [IPv6:2003:e9:d724:a7dd:f566:73:8aea:58ff])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits))
        (No client certificate requested)
        (Authenticated sender: stefan@datenfreihafen.org)
        by proxima.lasnet.de (Postfix) with ESMTPSA id 59072C05DE;
        Fri,  7 Oct 2022 09:44:58 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=datenfreihafen.org;
        s=2021; t=1665128698;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Je6hpNQNnFX/1LEDxLhTD+Kr3K4vDzzOqJ5LyfWIuas=;
        b=vlleGP6gfseQDPHOpgMVfPs7oZnQTtIqOY06/+giz8CigAn91dNc3FOMpyhE5GDsPsnMlt
        RZynKewnOLqb1yLVTyJr8TjDYBiLcSyek351VYNI7GXPoCLUyQmgkOzjgcYorhURILeQ6g
        H5uH2Cp4gZvu6Q33OSF/dDCFiaRyTm/mcrYbh4Ps3h+XrYuO430FX7IkJ48GWu+ZxaS/No
        2b6z1LtKuAB3b5RxO2RnLg33pPMbKE0tIYdQmnlZSckAyrCN8q96IjghQ1KDrJBIaQ3dEA
        zqaBKTNwkwFV9nIEBNFuoP0OKWmn/OIU7o3+CglrcncQ+Fli1f55+qEEr0GLPw==
Message-ID: <fce4d1a0-5fa9-84b7-52af-4bef48ea90b0@datenfreihafen.org>
Date:   Fri, 7 Oct 2022 09:44:58 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.1
Subject: Re: [PATCH] net: ieee802154: fix error return code in dgram_bind()
Content-Language: en-US
To:     Wei Yongjun <weiyongjun@huaweicloud.com>,
        Haimin Zhang <tcs.kernel@gmail.com>,
        Alexander Aring <alex.aring@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     Wei Yongjun <weiyongjun1@huawei.com>, linux-wpan@vger.kernel.org,
        netdev@vger.kernel.org
References: <20220919160830.1436109-1-weiyongjun@huaweicloud.com>
From:   Stefan Schmidt <stefan@datenfreihafen.org>
In-Reply-To: <20220919160830.1436109-1-weiyongjun@huaweicloud.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello.

On 19.09.22 18:08, Wei Yongjun wrote:
> From: Wei Yongjun <weiyongjun1@huawei.com>
> 
> Fix to return error code -EINVAL from the error handling
> case instead of 0, as done elsewhere in this function.
> 
> Fixes: 94160108a70c ("net/ieee802154: fix uninit value bug in dgram_sendmsg")
> Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>
> ---
>   net/ieee802154/socket.c | 4 +++-
>   1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/net/ieee802154/socket.c b/net/ieee802154/socket.c
> index 7889e1ef7fad..35c54dce74f9 100644
> --- a/net/ieee802154/socket.c
> +++ b/net/ieee802154/socket.c
> @@ -498,8 +498,10 @@ static int dgram_bind(struct sock *sk, struct sockaddr *uaddr, int len)
>   	if (err < 0)
>   		goto out;
>   
> -	if (addr->family != AF_IEEE802154)
> +	if (addr->family != AF_IEEE802154) {
> +		err = -EINVAL;
>   		goto out;
> +	}
>   
>   	ieee802154_addr_from_sa(&haddr, &addr->addr);
>   	dev = ieee802154_get_dev(sock_net(sk), &haddr);
> 

This patch has been applied to the wpan tree and will be
part of the next pull request to net. Thanks!

regards
Stefan Schmidt
