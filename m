Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 314E032B3CB
	for <lists+netdev@lfdr.de>; Wed,  3 Mar 2021 05:22:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1835889AbhCCEGu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Mar 2021 23:06:50 -0500
Received: from proxima.lasnet.de ([78.47.171.185]:36988 "EHLO
        proxima.lasnet.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1381845AbhCBVez (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Mar 2021 16:34:55 -0500
Received: from [IPv6:2003:e9:d72a:21a0:8b4a:5ec4:afc4:817c] (p200300e9d72a21a08b4a5ec4afc4817c.dip0.t-ipconnect.de [IPv6:2003:e9:d72a:21a0:8b4a:5ec4:afc4:817c])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits))
        (No client certificate requested)
        (Authenticated sender: stefan@datenfreihafen.org)
        by proxima.lasnet.de (Postfix) with ESMTPSA id C8351C0A66;
        Tue,  2 Mar 2021 22:33:17 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=datenfreihafen.org;
        s=2021; t=1614720798;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=OqMTRRyluB1sCfHyssYtnEiA+exUEHJ21ivCDAdaazQ=;
        b=eKa92Tog7kraMSM355h/9FmG3hBmW3sNO1EP17iyz8lBVkwkePzgTOhsShFT/eWtUaS9bU
        DtIVVuaWb/hPP2hkQsrm1lcKXNMTel4rXU8iwbOugIPD5YIr0O35cD967yizN0KZgMefX9
        LoQtZzVaPl7078CZ9uTyobNjglGmqqufgBPqxfp+vMV94KywAshji0fQyivYJBG4xZRY2Z
        CNh/TBip7N7UWU1DHDdFm+sx4AIfl+FviMACgIzMHIkbC6GmhPmzBYD8xFqVcWAJhmCWIq
        sknLTDQufY1MvIaP8U7Bd+KwLfyphuWHDV6AAjfu8jOBf9CIKDtXggDDnU6HWw==
Subject: Re: [PATCH wpan 03/17] net: ieee802154: nl-mac: fix check on panid
To:     Alexander Aring <aahringo@redhat.com>
Cc:     linux-wpan@vger.kernel.org, netdev@vger.kernel.org
References: <20210228151817.95700-1-aahringo@redhat.com>
 <20210228151817.95700-4-aahringo@redhat.com>
From:   Stefan Schmidt <stefan@datenfreihafen.org>
Message-ID: <9eb955c5-3f27-63d5-e292-0217ed56b8cb@datenfreihafen.org>
Date:   Tue, 2 Mar 2021 22:33:17 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20210228151817.95700-4-aahringo@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello.

On 28.02.21 16:18, Alexander Aring wrote:
> This patch fixes a null pointer derefence for panid handle by move the
> check for the netlink variable directly before accessing them.
> 
> Reported-by: syzbot+d4c07de0144f6f63be3a@syzkaller.appspotmail.com
> Signed-off-by: Alexander Aring <aahringo@redhat.com>
> ---
>   net/ieee802154/nl-mac.c | 7 ++++---
>   1 file changed, 4 insertions(+), 3 deletions(-)
> 
> diff --git a/net/ieee802154/nl-mac.c b/net/ieee802154/nl-mac.c
> index 9c640d670ffe..0c1b0770c59e 100644
> --- a/net/ieee802154/nl-mac.c
> +++ b/net/ieee802154/nl-mac.c
> @@ -551,9 +551,7 @@ ieee802154_llsec_parse_key_id(struct genl_info *info,
>   	desc->mode = nla_get_u8(info->attrs[IEEE802154_ATTR_LLSEC_KEY_MODE]);
>   
>   	if (desc->mode == IEEE802154_SCF_KEY_IMPLICIT) {
> -		if (!info->attrs[IEEE802154_ATTR_PAN_ID] &&
> -		    !(info->attrs[IEEE802154_ATTR_SHORT_ADDR] ||
> -		      info->attrs[IEEE802154_ATTR_HW_ADDR]))
> +		if (!info->attrs[IEEE802154_ATTR_PAN_ID])
>   			return -EINVAL;
>   
>   		desc->device_addr.pan_id = nla_get_shortaddr(info->attrs[IEEE802154_ATTR_PAN_ID]);
> @@ -562,6 +560,9 @@ ieee802154_llsec_parse_key_id(struct genl_info *info,
>   			desc->device_addr.mode = IEEE802154_ADDR_SHORT;
>   			desc->device_addr.short_addr = nla_get_shortaddr(info->attrs[IEEE802154_ATTR_SHORT_ADDR]);
>   		} else {
> +			if (!info->attrs[IEEE802154_ATTR_HW_ADDR])
> +				return -EINVAL;
> +
>   			desc->device_addr.mode = IEEE802154_ADDR_LONG;
>   			desc->device_addr.extended_addr = nla_get_hwaddr(info->attrs[IEEE802154_ATTR_HW_ADDR]);
>   		}
> 

This patch has been applied to the wpan tree and will be
part of the next pull request to net. Thanks!

regards
Stefan Schmidt
