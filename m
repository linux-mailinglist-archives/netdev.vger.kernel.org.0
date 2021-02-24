Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4816A3240A5
	for <lists+netdev@lfdr.de>; Wed, 24 Feb 2021 16:29:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238249AbhBXPTF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Feb 2021 10:19:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237669AbhBXNmM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Feb 2021 08:42:12 -0500
Received: from proxima.lasnet.de (proxima.lasnet.de [IPv6:2a01:4f8:121:31eb:3::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A9E3C061793;
        Wed, 24 Feb 2021 05:39:21 -0800 (PST)
Received: from [IPv6:2003:e9:d72b:2a0f:18df:1c4d:541:33a8] (p200300e9d72b2a0f18df1c4d054133a8.dip0.t-ipconnect.de [IPv6:2003:e9:d72b:2a0f:18df:1c4d:541:33a8])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits))
        (No client certificate requested)
        (Authenticated sender: stefan@datenfreihafen.org)
        by proxima.lasnet.de (Postfix) with ESMTPSA id 8E555C0D3E;
        Wed, 24 Feb 2021 14:39:19 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=datenfreihafen.org;
        s=2021; t=1614173959;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=gUKvWLAKd1MNtM/fQFvNkc+zTDuDowYtOowKwRCvZNY=;
        b=lcGariH+wdcW9DAt53d695DXi4KHUlvecNmXRHbMOWfrQdul2EEKhdKIgX/T6XFOhPEJ2W
        FHD49eYAeRPbHtEiTWp3KEPZkBiX/JvR6PC5MUjLIbBFdSvOdK67/r7wR9JmNHxXdVDbHX
        qwq4kGWImvzqTK2PBGGzh+kEkUiLtuewjSyr/xBpmBy+dcDkCVMj/L+5erV8jqtfI1yw7t
        ymP6fuNugeavyvP2PrHzPEIS7ZgeZVRRDOAa7PX9kcBvUrwGfuTNw1IVgXuCW9Y8KSrmk6
        MwYBf9TvrNv5ai7AweWUNePGvESPS0v+Au/l/QrTJCXvyI03ybOLYJrSWIhBmw==
Subject: Re: [PATCH wpan 4/4] net: ieee802154: fix nl802154 del llsec devkey
To:     Alexander Aring <aahringo@redhat.com>
Cc:     linux-wpan@vger.kernel.org, netdev@vger.kernel.org
References: <20210221174321.14210-1-aahringo@redhat.com>
 <20210221174321.14210-4-aahringo@redhat.com>
From:   Stefan Schmidt <stefan@datenfreihafen.org>
Message-ID: <0315acba-d115-c3b8-5b17-e88e85559612@datenfreihafen.org>
Date:   Wed, 24 Feb 2021 14:39:19 +0100
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

This patch has been applied to the wpan tree and will be
part of the next pull request to net. Thanks!

regards
Stefan Schmidt
