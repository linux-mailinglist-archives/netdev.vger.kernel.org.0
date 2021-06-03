Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C451399D39
	for <lists+netdev@lfdr.de>; Thu,  3 Jun 2021 10:54:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229911AbhFCIzm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Jun 2021 04:55:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229623AbhFCIzl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Jun 2021 04:55:41 -0400
Received: from proxima.lasnet.de (proxima.lasnet.de [IPv6:2a01:4f8:121:31eb:3::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66C4DC06174A;
        Thu,  3 Jun 2021 01:53:57 -0700 (PDT)
Received: from [IPv6:2003:e9:d722:28a1:9240:5b8a:f037:504] (p200300e9d72228a192405b8af0370504.dip0.t-ipconnect.de [IPv6:2003:e9:d722:28a1:9240:5b8a:f037:504])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits))
        (No client certificate requested)
        (Authenticated sender: stefan@datenfreihafen.org)
        by proxima.lasnet.de (Postfix) with ESMTPSA id A472EC02EE;
        Thu,  3 Jun 2021 10:53:55 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=datenfreihafen.org;
        s=2021; t=1622710435;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=joNf4+AILeuIn49vemAPcdrgOG/ZJnkV8zC3Ten9Yi0=;
        b=KAq4psuj+Yagbs7GznIl9wEJNRpfDe2NH4Nq4otXtzGZ0Jc4vJly4zRxNzHvpmf5L94wuu
        3K/yUBIT5XnLZUPplMohT1N9s+760qxqiwQ+1LPj7YAR5yMBfI+5AfCUSBx6E5ApoMfW/5
        xBo3/vnI0ONWB3vYRqRWKmRUom/82BFC36U1HLs6ENO7uWBSA+ekUUR868naXF4ktUZqEm
        vjOnm6AaRVPRk2iCpsYgUrTT+VWSmKM3kk2XE4oz8JAuS5QmYfvX7crL/a9qd2yFiZzid2
        FkY3nNq1T1gKWoX7kauzwHh/mTaYHYIeNcGIRrEp7MnPUxxwXhq10FtHAYzu7A==
Subject: Re: [PATCH 1/1] ieee802154: fix error return code in
 ieee802154_add_iface()
To:     Zhen Lei <thunder.leizhen@huawei.com>,
        Alexander Aring <alex.aring@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-wpan <linux-wpan@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
References: <20210508062517.2574-1-thunder.leizhen@huawei.com>
From:   Stefan Schmidt <stefan@datenfreihafen.org>
Message-ID: <03320214-828c-4ac8-0fb8-89bd78b85c97@datenfreihafen.org>
Date:   Thu, 3 Jun 2021 10:53:55 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20210508062517.2574-1-thunder.leizhen@huawei.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello.

On 08.05.21 08:25, Zhen Lei wrote:
> Fix to return a negative error code from the error handling
> case instead of 0, as done elsewhere in this function.
> 
> Fixes: be51da0f3e34 ("ieee802154: Stop using NLA_PUT*().")
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: Zhen Lei <thunder.leizhen@huawei.com>
> ---
>   net/ieee802154/nl-phy.c | 4 +++-
>   1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/net/ieee802154/nl-phy.c b/net/ieee802154/nl-phy.c
> index 2cdc7e63fe17..88215b5c93aa 100644
> --- a/net/ieee802154/nl-phy.c
> +++ b/net/ieee802154/nl-phy.c
> @@ -241,8 +241,10 @@ int ieee802154_add_iface(struct sk_buff *skb, struct genl_info *info)
>   	}
>   
>   	if (nla_put_string(msg, IEEE802154_ATTR_PHY_NAME, wpan_phy_name(phy)) ||
> -	    nla_put_string(msg, IEEE802154_ATTR_DEV_NAME, dev->name))
> +	    nla_put_string(msg, IEEE802154_ATTR_DEV_NAME, dev->name)) {
> +		rc = -EMSGSIZE;
>   		goto nla_put_failure;
> +	}
>   	dev_put(dev);
>   
>   	wpan_phy_put(phy);
> 

Good find. We could indeed hit a case where the IEEE802154_ATTR_HW_ADDR 
attribute is present and rc would be assigned 0 before reaching this 
goto nla_put_failure

This patch has been applied to the wpan tree and will be
part of the next pull request to net. Thanks!

regards
Stefan Schmidt
