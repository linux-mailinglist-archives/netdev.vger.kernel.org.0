Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 04827399D53
	for <lists+netdev@lfdr.de>; Thu,  3 Jun 2021 11:01:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229755AbhFCJDj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Jun 2021 05:03:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229610AbhFCJDi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Jun 2021 05:03:38 -0400
Received: from proxima.lasnet.de (proxima.lasnet.de [IPv6:2a01:4f8:121:31eb:3::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2BC3C06174A;
        Thu,  3 Jun 2021 02:01:53 -0700 (PDT)
Received: from [IPv6:2003:e9:d722:28a1:9240:5b8a:f037:504] (p200300e9d72228a192405b8af0370504.dip0.t-ipconnect.de [IPv6:2003:e9:d722:28a1:9240:5b8a:f037:504])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits))
        (No client certificate requested)
        (Authenticated sender: stefan@datenfreihafen.org)
        by proxima.lasnet.de (Postfix) with ESMTPSA id B82F1C0542;
        Thu,  3 Jun 2021 11:01:51 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=datenfreihafen.org;
        s=2021; t=1622710911;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=EquOF3L85NGLb2EjoTiXBRVqUAA5DMvQV13UsmvqEj8=;
        b=V1t42NxkMUQBsS21i8B1xRB5X0c/XHSOrjXe01m+OQ2HlF1EWB0++h5b4xOO1CEFYriMWL
        ++267Qzf0j5t1ktsLufano9KlUwMulqeuoMspOqV4pwJUGMtMOKWYmDGv4/mlIFDwVmP6a
        t6CwmiCOIqsB1zldc7s693PwVfOWEtn8LzlFHTaXIkH+kxxRyuRQ+bc/ltTavEEigJnBn8
        Wu7DD0JzTd41A8DaCWtPSSgMr1esvMh+c6VsWal6o84hlyrztWeMB6BswO1yz8LaPaDQx4
        Y28gzW7S+Zo4FFs7L+Hd6aiNc8HChCt6Qw9EMwGr5lRr7DksnWT24vG1rnui3g==
Subject: Re: [PATCH net-next] ieee802154: fix error return code in
 ieee802154_llsec_getparams()
To:     Wei Yongjun <weiyongjun1@huawei.com>,
        Alexander Aring <alex.aring@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     linux-wpan@vger.kernel.org, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org, Hulk Robot <hulkci@huawei.com>
References: <20210519141614.3040055-1-weiyongjun1@huawei.com>
From:   Stefan Schmidt <stefan@datenfreihafen.org>
Message-ID: <b8700eed-1791-fd55-4568-dc4efeda35eb@datenfreihafen.org>
Date:   Thu, 3 Jun 2021 11:01:51 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20210519141614.3040055-1-weiyongjun1@huawei.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello.

On 19.05.21 16:16, Wei Yongjun wrote:
> Fix to return negative error code -ENOBUFS from the error handling
> case instead of 0, as done elsewhere in this function.
> 
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>
> ---
>   net/ieee802154/nl-mac.c | 4 +++-
>   1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/net/ieee802154/nl-mac.c b/net/ieee802154/nl-mac.c
> index 0c1b0770c59e..c23c152860b7 100644
> --- a/net/ieee802154/nl-mac.c
> +++ b/net/ieee802154/nl-mac.c
> @@ -680,8 +680,10 @@ int ieee802154_llsec_getparams(struct sk_buff *skb, struct genl_info *info)
>   	    nla_put_u8(msg, IEEE802154_ATTR_LLSEC_SECLEVEL, params.out_level) ||
>   	    nla_put_u32(msg, IEEE802154_ATTR_LLSEC_FRAME_COUNTER,
>   			be32_to_cpu(params.frame_counter)) ||
> -	    ieee802154_llsec_fill_key_id(msg, &params.out_key))
> +	    ieee802154_llsec_fill_key_id(msg, &params.out_key)) {
> +		rc = -ENOBUFS;
>   		goto out_free;
> +	}
>   
>   	dev_put(dev);


This patch has been applied to the wpan tree and will be
part of the next pull request to net. Thanks!

regards
Stefan Schmidt
