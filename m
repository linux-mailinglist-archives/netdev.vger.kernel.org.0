Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AAA413240A7
	for <lists+netdev@lfdr.de>; Wed, 24 Feb 2021 16:30:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238443AbhBXPTK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Feb 2021 10:19:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237668AbhBXNmM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Feb 2021 08:42:12 -0500
Received: from proxima.lasnet.de (proxima.lasnet.de [IPv6:2a01:4f8:121:31eb:3::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9209C06178C;
        Wed, 24 Feb 2021 05:39:05 -0800 (PST)
Received: from [IPv6:2003:e9:d72b:2a0f:18df:1c4d:541:33a8] (p200300e9d72b2a0f18df1c4d054133a8.dip0.t-ipconnect.de [IPv6:2003:e9:d72b:2a0f:18df:1c4d:541:33a8])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits))
        (No client certificate requested)
        (Authenticated sender: stefan@datenfreihafen.org)
        by proxima.lasnet.de (Postfix) with ESMTPSA id 31AECC0D48;
        Wed, 24 Feb 2021 14:39:04 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=datenfreihafen.org;
        s=2021; t=1614173944;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=J5cbghaSwFZD/IikCR8HsnAC4lJh40SLPEZmRG7QVuU=;
        b=EoXsNuo0EljoQAOwb1ihNPn5+gOwGNKVf/TdkwlC87rvUV8hR8VmZCHHnWN34sJmYmxD+c
        QuswZGEgd/zLR9w+EJOsVrGBL5WsPjs2EQ5HC0IQsxRuuyajjKP0T5TeaxesI0dMlrOcFg
        oK/1dXIrnnoC0Eazg6HK53rELgRShPBEKIyAAIrLwcFZo4HXKnaAx85heKA9cx7Ki2GHwP
        C9tPRna5zoGXRVYEk4t2q2b8Txh7qKjcLdQL//LAuJmqfM9HnEbaRs1PWG4+g0GkorP06u
        /5OqDfYUvih51+4xcHT2em1Z/m90ORy61jYNMPM9Kj+INWyNu3LChzGxB6gm2A==
Subject: Re: [PATCH wpan 4/4] net: ieee802154: fix nl802154 del llsec devkey
To:     Alexander Aring <aahringo@redhat.com>
Cc:     linux-wpan@vger.kernel.org, netdev@vger.kernel.org
References: <20210221174321.14210-1-aahringo@redhat.com>
 <20210221174321.14210-4-aahringo@redhat.com>
From:   Stefan Schmidt <stefan@datenfreihafen.org>
Message-ID: <3a221f95-a1d1-2660-f6d3-318c487e0592@datenfreihafen.org>
Date:   Wed, 24 Feb 2021 14:39:03 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20210221174321.14210-4-aahringo@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello.

On 21.02.21 18:43, Alexander Aring wrote:
> This patch fixes a nullpointer dereference if NL802154_ATTR_SEC_DEVKEY is
> not set by the user. If this is the case nl802154 will return -EINVAL.
> 
> Reported-by: syzbot+368672e0da240db53b5f@syzkaller.appspotmail.com
> Signed-off-by: Alexander Aring <aahringo@redhat.com>
> ---
>   net/ieee802154/nl802154.c | 3 ++-
>   1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/net/ieee802154/nl802154.c b/net/ieee802154/nl802154.c
> index 3f6d86d63923..e9e4652cd592 100644
> --- a/net/ieee802154/nl802154.c
> +++ b/net/ieee802154/nl802154.c
> @@ -1916,7 +1916,8 @@ static int nl802154_del_llsec_devkey(struct sk_buff *skb, struct genl_info *info
>   	struct ieee802154_llsec_device_key key;
>   	__le64 extended_addr;
>   
> -	if (nla_parse_nested_deprecated(attrs, NL802154_DEVKEY_ATTR_MAX, info->attrs[NL802154_ATTR_SEC_DEVKEY], nl802154_devkey_policy, info->extack))
> +	if (!info->attrs[NL802154_ATTR_SEC_DEVKEY] ||
> +	    nla_parse_nested_deprecated(attrs, NL802154_DEVKEY_ATTR_MAX, info->attrs[NL802154_ATTR_SEC_DEVKEY], nl802154_devkey_policy, info->extack))
>   		return -EINVAL;
>   
>   	if (!attrs[NL802154_DEVKEY_ATTR_EXTENDED_ADDR])
> 
