Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B21F13240A2
	for <lists+netdev@lfdr.de>; Wed, 24 Feb 2021 16:29:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233998AbhBXPRk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Feb 2021 10:17:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235743AbhBXNkJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Feb 2021 08:40:09 -0500
Received: from proxima.lasnet.de (proxima.lasnet.de [IPv6:2a01:4f8:121:31eb:3::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0290DC061786;
        Wed, 24 Feb 2021 05:37:48 -0800 (PST)
Received: from [IPv6:2003:e9:d72b:2a0f:18df:1c4d:541:33a8] (p200300e9d72b2a0f18df1c4d054133a8.dip0.t-ipconnect.de [IPv6:2003:e9:d72b:2a0f:18df:1c4d:541:33a8])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits))
        (No client certificate requested)
        (Authenticated sender: stefan@datenfreihafen.org)
        by proxima.lasnet.de (Postfix) with ESMTPSA id 5FA67C0C9D;
        Wed, 24 Feb 2021 14:37:47 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=datenfreihafen.org;
        s=2021; t=1614173867;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=a+Ru/xiqbGqbpEn9FQ/wW+ZwTqTcW+8sGrVgY1t43o4=;
        b=lTaXS+wy/MTIefokS3fOf+aCOfzbjkGQzzxJQBSbNenYftLLTbyrkn0T6ZuvSSme5+ncJk
        KaITO/04Br1Q/sNSvQmK/CpXLi89HrfSliL92qf1uAXa1wu7T8QznV/R3AbiM7DrJfhqCn
        Y04FWEtzeq6h6kLqD6P4UdIKfz8yNHzRM+T3opJTC88qIto7nKLc6oh6P93NMY7IpOlYLb
        ut50EvhNhU2TbpPQyqGqZOuKQGXnIiGr73uCii5vFXTT+3x1Hr56bd6qU9JPbKL4ZhHxGQ
        QFSvaIx5FJiG+SAmAhnFyeCpaRJ9ojfRABFp71YR2aa/idT1onL6EEhEVjsqIQ==
Subject: Re: [PATCH wpan 2/4] net: ieee802154: fix nl802154 del llsec dev
To:     Alexander Aring <aahringo@redhat.com>
Cc:     linux-wpan@vger.kernel.org, netdev@vger.kernel.org
References: <20210221174321.14210-1-aahringo@redhat.com>
 <20210221174321.14210-2-aahringo@redhat.com>
From:   Stefan Schmidt <stefan@datenfreihafen.org>
Message-ID: <fc4b9036-6b68-24d0-13ed-ffd0b24ce79a@datenfreihafen.org>
Date:   Wed, 24 Feb 2021 14:37:47 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20210221174321.14210-2-aahringo@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello.

On 21.02.21 18:43, Alexander Aring wrote:
> This patch fixes a nullpointer dereference if NL802154_ATTR_SEC_DEVICE is
> not set by the user. If this is the case nl802154 will return -EINVAL.
> 
> Reported-by: syzbot+d946223c2e751d136c94@syzkaller.appspotmail.com
> Signed-off-by: Alexander Aring <aahringo@redhat.com>
> ---
>   net/ieee802154/nl802154.c | 3 ++-
>   1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/net/ieee802154/nl802154.c b/net/ieee802154/nl802154.c
> index 2f0a138bd5eb..063b12cba71f 100644
> --- a/net/ieee802154/nl802154.c
> +++ b/net/ieee802154/nl802154.c
> @@ -1758,7 +1758,8 @@ static int nl802154_del_llsec_dev(struct sk_buff *skb, struct genl_info *info)
>   	struct nlattr *attrs[NL802154_DEV_ATTR_MAX + 1];
>   	__le64 extended_addr;
>   
> -	if (nla_parse_nested_deprecated(attrs, NL802154_DEV_ATTR_MAX, info->attrs[NL802154_ATTR_SEC_DEVICE], nl802154_dev_policy, info->extack))
> +	if (!info->attrs[NL802154_ATTR_SEC_DEVICE] ||
> +	    nla_parse_nested_deprecated(attrs, NL802154_DEV_ATTR_MAX, info->attrs[NL802154_ATTR_SEC_DEVICE], nl802154_dev_policy, info->extack))
>   		return -EINVAL;
>   
>   	if (!attrs[NL802154_DEV_ATTR_EXTENDED_ADDR])
> 


This patch has been applied to the wpan tree and will be
part of the next pull request to net. Thanks!

regards
Stefan Schmidt
