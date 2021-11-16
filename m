Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 361AA453970
	for <lists+netdev@lfdr.de>; Tue, 16 Nov 2021 19:32:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239517AbhKPSe5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Nov 2021 13:34:57 -0500
Received: from proxima.lasnet.de ([78.47.171.185]:58680 "EHLO
        proxima.lasnet.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239510AbhKPSes (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Nov 2021 13:34:48 -0500
Received: from [172.29.15.1] (unknown [185.214.200.54])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: stefan@datenfreihafen.org)
        by proxima.lasnet.de (Postfix) with ESMTPSA id 0479CC0387;
        Tue, 16 Nov 2021 19:31:47 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=datenfreihafen.org;
        s=2021; t=1637087508;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=q33VKNmnBYWaMgxXXz7vJiugiVjwWfFa7bPXnZywGAI=;
        b=A401T7QmAKbJcVQAOdyXhmRhUTrRslyXmUWgf/vhhq0DJM0/o0EDdn7atSuONXikAqB99a
        Kjvmok8KyCNfrVCYGeq3kCTnyUQ9gkafPYqVpM1+MeZwZnypfrmKdVf9ksZiB6/UA/4XjM
        MPngdNWuWGezOqH2JY/nuG+ZKP6vm7pgd+iiQz6wVNx85jOSwjpNDvFLZNyGtw68IFJCHs
        lxbkgyXMxYGtjPDknIu2I3xMy7TT26vfDVnwDapZ0O3+5gQFoQSo0yrfu6HH1zA1w3yHeH
        GupMNlnckiila01DNDs7sArQgQNmGovGUBGR8zaMFOEX9AhlK2eqFKaFqZRIuQ==
Message-ID: <9442473c-27fc-12d5-d520-206796e4edfa@datenfreihafen.org>
Date:   Tue, 16 Nov 2021 19:31:46 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.0
Subject: Re: [PATCH wpan] net: ieee802154: handle iftypes as u32
Content-Language: en-US
To:     Alexander Aring <aahringo@redhat.com>, mudongliangabcd@gmail.com
Cc:     linux-wpan@vger.kernel.org, netdev@vger.kernel.org
References: <20211112030916.685793-1-aahringo@redhat.com>
From:   Stefan Schmidt <stefan@datenfreihafen.org>
In-Reply-To: <20211112030916.685793-1-aahringo@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello.

On 12.11.21 04:09, Alexander Aring wrote:
> This patch fixes an issue that an u32 netlink value is handled as a
> signed enum value which doesn't fit into the range of u32 netlink type.
> If it's handled as -1 value some BIT() evaluation ends in a
> shift-out-of-bounds issue. To solve the issue we set the to u32 max which
> is s32 "-1" value to keep backwards compatibility and let the followed enum
> values start counting at 0. This brings the compiler to never handle the
> enum as signed and a check if the value is above NL802154_IFTYPE_MAX should
> filter -1 out.
> 
> Fixes: f3ea5e44231a ("ieee802154: add new interface command")
> Signed-off-by: Alexander Aring <aahringo@redhat.com>
> ---
>   include/net/nl802154.h | 7 ++++---
>   1 file changed, 4 insertions(+), 3 deletions(-)
> 
> diff --git a/include/net/nl802154.h b/include/net/nl802154.h
> index ddcee128f5d9..145acb8f2509 100644
> --- a/include/net/nl802154.h
> +++ b/include/net/nl802154.h
> @@ -19,6 +19,8 @@
>    *
>    */
>   
> +#include <linux/types.h>
> +
>   #define NL802154_GENL_NAME "nl802154"
>   
>   enum nl802154_commands {
> @@ -150,10 +152,9 @@ enum nl802154_attrs {
>   };
>   
>   enum nl802154_iftype {
> -	/* for backwards compatibility TODO */
> -	NL802154_IFTYPE_UNSPEC = -1,
> +	NL802154_IFTYPE_UNSPEC = (~(__u32)0),
>   
> -	NL802154_IFTYPE_NODE,
> +	NL802154_IFTYPE_NODE = 0,
>   	NL802154_IFTYPE_MONITOR,
>   	NL802154_IFTYPE_COORD,
>   


This patch has been applied to the wpan tree and will be
part of the next pull request to net. Thanks!

regards
Stefan Schmidt
