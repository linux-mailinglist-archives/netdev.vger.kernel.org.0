Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CEE9032409E
	for <lists+netdev@lfdr.de>; Wed, 24 Feb 2021 16:29:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234409AbhBXPQV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Feb 2021 10:16:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235407AbhBXNkB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Feb 2021 08:40:01 -0500
X-Greylist: delayed 55484 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Wed, 24 Feb 2021 05:37:28 PST
Received: from proxima.lasnet.de (proxima.lasnet.de [IPv6:2a01:4f8:121:31eb:3::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90807C06174A;
        Wed, 24 Feb 2021 05:37:28 -0800 (PST)
Received: from [IPv6:2003:e9:d72b:2a0f:18df:1c4d:541:33a8] (p200300e9d72b2a0f18df1c4d054133a8.dip0.t-ipconnect.de [IPv6:2003:e9:d72b:2a0f:18df:1c4d:541:33a8])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: stefan@datenfreihafen.org)
        by proxima.lasnet.de (Postfix) with ESMTPSA id 4B7EDC05A1;
        Wed, 24 Feb 2021 14:37:23 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=datenfreihafen.org;
        s=2021; t=1614173843;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Amkvf5qN9XKmH8/Ok3kxmyekG+LXaF6QYue28yqqkfQ=;
        b=hBs388VN355Xc0NYGtvkPYh8h9CjMLb74SbrjdWZblOS1bgnoCHGbcjV8rj102tfGnHXls
        PucLO4LAfKExsOVvQXOlgh7KSOqspO9cA8cw3YVSOU90rYlWOwZ09/VgsdkHKddfv7KOLB
        bkvDm1Fciw+aoShw47bt+gXq8O4dYB+nXN4obdPDs12fPlPrbXNvWqidrQCHpdzy2QypWX
        NW2GOf6er3db4NGLONFJ9wNN2wwOtmQWjVmY2keNiYyVG8d+PSabesYudt7a0p3zgwZHMX
        4XDnClmT/OZWH0Qerjt2XgqiEi0FjA9kE5S924bp+iVlFgcztz3Rzj5Z1dQSpA==
Subject: Re: [PATCH wpan 1/4] net: ieee802154: fix nl802154 del llsec key
To:     Alexander Aring <aahringo@redhat.com>
Cc:     linux-wpan@vger.kernel.org, netdev@vger.kernel.org
References: <20210221174321.14210-1-aahringo@redhat.com>
From:   Stefan Schmidt <stefan@datenfreihafen.org>
Message-ID: <469c5201-a93e-a3d5-1b0c-39519f4e267e@datenfreihafen.org>
Date:   Wed, 24 Feb 2021 14:37:19 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20210221174321.14210-1-aahringo@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello.

On 21.02.21 18:43, Alexander Aring wrote:
> This patch fixes a nullpointer dereference if NL802154_ATTR_SEC_KEY is
> not set by the user. If this is the case nl802154 will return -EINVAL.
> 
> Reported-by: syzbot+ac5c11d2959a8b3c4806@syzkaller.appspotmail.com
> Signed-off-by: Alexander Aring <aahringo@redhat.com>
> ---
>   net/ieee802154/nl802154.c | 3 ++-
>   1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/net/ieee802154/nl802154.c b/net/ieee802154/nl802154.c
> index 7c5a1aa5adb4..2f0a138bd5eb 100644
> --- a/net/ieee802154/nl802154.c
> +++ b/net/ieee802154/nl802154.c
> @@ -1592,7 +1592,8 @@ static int nl802154_del_llsec_key(struct sk_buff *skb, struct genl_info *info)
>   	struct nlattr *attrs[NL802154_KEY_ATTR_MAX + 1];
>   	struct ieee802154_llsec_key_id id;
>   
> -	if (nla_parse_nested_deprecated(attrs, NL802154_KEY_ATTR_MAX, info->attrs[NL802154_ATTR_SEC_KEY], nl802154_key_policy, info->extack))
> +	if (!info->attrs[NL802154_ATTR_SEC_KEY] ||
> +	    nla_parse_nested_deprecated(attrs, NL802154_KEY_ATTR_MAX, info->attrs[NL802154_ATTR_SEC_KEY], nl802154_key_policy, info->extack))
>   		return -EINVAL;
>   
>   	if (ieee802154_llsec_parse_key_id(attrs[NL802154_KEY_ATTR_ID], &id) < 0)
> 

This patch has been applied to the wpan tree and will be
part of the next pull request to net. Thanks!

regards
Stefan Schmidt
