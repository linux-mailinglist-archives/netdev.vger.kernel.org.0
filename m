Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A0A632B3CA
	for <lists+netdev@lfdr.de>; Wed,  3 Mar 2021 05:22:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1835876AbhCCEGr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Mar 2021 23:06:47 -0500
Received: from proxima.lasnet.de ([78.47.171.185]:36418 "EHLO
        proxima.lasnet.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1448179AbhCBVS6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Mar 2021 16:18:58 -0500
Received: from [IPv6:2003:e9:d72a:21a0:8b4a:5ec4:afc4:817c] (p200300e9d72a21a08b4a5ec4afc4817c.dip0.t-ipconnect.de [IPv6:2003:e9:d72a:21a0:8b4a:5ec4:afc4:817c])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: stefan@datenfreihafen.org)
        by proxima.lasnet.de (Postfix) with ESMTPSA id 6D246C07F4;
        Tue,  2 Mar 2021 22:18:15 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=datenfreihafen.org;
        s=2021; t=1614719895;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=kdo6eum8wkd2iODfotmdqvpBWhx/QCj5SmddN3Nhegw=;
        b=mecsQ6MkrEaxjuLy86lDGI/P41tcSX+OE/oE8Hp70lcO/30Zt14zV6TJ+Ne70Eh9Q2t3ku
        8rpwqp9JTG6mVt42lS13homYXOI/44D7TrasHlu590SfvP+NjQ/P2qs4zxxisWl/oEFN7G
        ed2ZIsrJJHzbId80Z76wbIp5yXyT3jUj2WQPy3p6aoPCEXpQjfCjVeAkp+JPKpu+rNaclT
        7mHz920ojCIISCI//lHapGo3lzwOkcoh+6DJPb/SlzokImWRbF1ssz1946n768T++9Ac6F
        pO3s7/fgypPnTY/HA4WkvWinAFwtEaOHaify3KQSaheXNB8/DnuYr0Aq8XpSCA==
Subject: Re: [PATCH wpan 01/17] net: ieee802154: make shift exponent unsigned
To:     Alexander Aring <aahringo@redhat.com>
Cc:     linux-wpan@vger.kernel.org, netdev@vger.kernel.org
References: <20210228151817.95700-1-aahringo@redhat.com>
 <20210228151817.95700-2-aahringo@redhat.com>
From:   Stefan Schmidt <stefan@datenfreihafen.org>
Message-ID: <b9baaf49-0e25-4c74-e8b7-f826157e1d48@datenfreihafen.org>
Date:   Tue, 2 Mar 2021 22:18:14 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20210228151817.95700-2-aahringo@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Alex.

On 28.02.21 16:18, Alexander Aring wrote:
> This patch changes the iftype type variable to unsigned that it can
> never be reach a negative value.
> 
> Reported-by: syzbot+7bf7b22759195c9a21e9@syzkaller.appspotmail.com
> Signed-off-by: Alexander Aring <aahringo@redhat.com>
> ---
>   net/ieee802154/nl802154.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/net/ieee802154/nl802154.c b/net/ieee802154/nl802154.c
> index e9e4652cd592..3ee09f6d13b7 100644
> --- a/net/ieee802154/nl802154.c
> +++ b/net/ieee802154/nl802154.c
> @@ -898,8 +898,8 @@ static int nl802154_get_interface(struct sk_buff *skb, struct genl_info *info)
>   static int nl802154_new_interface(struct sk_buff *skb, struct genl_info *info)
>   {
>   	struct cfg802154_registered_device *rdev = info->user_ptr[0];
> -	enum nl802154_iftype type = NL802154_IFTYPE_UNSPEC;
>   	__le64 extended_addr = cpu_to_le64(0x0000000000000000ULL);
> +	u32 type = NL802154_IFTYPE_UNSPEC;
>   
>   	/* TODO avoid failing a new interface
>   	 * creation due to pending removal?
> 

I am concerned about this one. Maybe you can shed some light on it.
NL802154_IFTYPE_UNSPEC is -1 which means the u32 will not hold this 
value, but something at the end of the range for u32.

There is a path (info->attrs[NL802154_ATTR_IFTYPE] is not true) where we 
put type forward to  rdev_add_virtual_intf() with its changed value but 
it would expect and enum which could hold -1 for UNSPEC.

regards
Stefan Schmidt
