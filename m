Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5406E22B6CD
	for <lists+netdev@lfdr.de>; Thu, 23 Jul 2020 21:35:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726135AbgGWTf1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jul 2020 15:35:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725894AbgGWTf1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jul 2020 15:35:27 -0400
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9040C0619DC;
        Thu, 23 Jul 2020 12:35:26 -0700 (PDT)
Received: by mail-pg1-x542.google.com with SMTP id z5so3675654pgb.6;
        Thu, 23 Jul 2020 12:35:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=EriDlxJbLUx9YWDVqlIDiRYGXreOTYLExqGTTF3O8SI=;
        b=gkkFB+Fmhaiipy43B1F7PJbZguA/fY2N72/IseI2ow3Se2ao9ZkXgtmz0NXUL3PKuE
         KN9xvFLjqjNEFzeMwzHC0NM4kzMjnwmRTwbERHnXCbYtNrkjBLP4Vh/nyqO8A3n+4jTB
         KagJzQDpOvnYc5JTiAAQNi5Sx6QDxIDfUWk2l8f2tRRGGwtwoPbpSbmXx7WwR4UCds1q
         hQJ2v91Os5x7shbbpcJ7hi7SrvOowZSvPnZzYFIcRvzbHeEfFyNYuzHx/YCjFLjdZqZk
         oSZHGli6NNrLQ/LNi4ilGxJgNA3mN+exRZAzUWMX9HokzE1+zVGL1nh1PYnT62EXyfGc
         0ZMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=EriDlxJbLUx9YWDVqlIDiRYGXreOTYLExqGTTF3O8SI=;
        b=DBtu51mvlEAn3FQanO3cAsr76c1orz8xGdtwvJ3gTgdBhcQcu1XctNqhP77+kVSSCK
         ckvLJshQ0AT8wlLhZMWWwTATNZeN+iGmbwHbotveo6+lcYZOkQPiYLNpmaI8xXTMZjXF
         pJ3HwuG7ufoiVKKvFv+y7Jv+9CRqruKxhUmtR2klJC0JVqOrOeASnyFCEC2IY7hzvlS8
         8bPabP4lzf4vxEQPi0Mvjy301OGJJE3pE2PCa9GtH8bnPU5AaMpw6tqhgjN8uE21MFgv
         K2EpU71nTbxecAnZ5N/zmebL9tTqKVFicDwryJeIgRBOCHKyBV+wW+P+hqdDdhJHdYL5
         c1YA==
X-Gm-Message-State: AOAM533CJiEtzdlkSSqp4VySfT7pr4PawuHOdkuVwehejGNOYBrIBKJm
        +RyvU10zVQC0V78qgjKvDeE=
X-Google-Smtp-Source: ABdhPJwj9YlYDUE6feFrSgms/8G69BVK00Z4/Lm7wRgtAERUbjbbweYgGphlNhrDYp609GVkimpqUw==
X-Received: by 2002:a62:1646:: with SMTP id 67mr5464187pfw.281.1595532926516;
        Thu, 23 Jul 2020 12:35:26 -0700 (PDT)
Received: from [10.1.10.11] (c-73-241-150-58.hsd1.ca.comcast.net. [73.241.150.58])
        by smtp.gmail.com with ESMTPSA id m20sm3835140pgn.62.2020.07.23.12.35.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 23 Jul 2020 12:35:25 -0700 (PDT)
Subject: Re: [PATCH] netlink: add buffer boundary checking
To:     Mark Salyzyn <salyzyn@android.com>, linux-kernel@vger.kernel.org
Cc:     kernel-team@android.com, netdev@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Thomas Graf <tgraf@suug.ch>
References: <20200723182136.2550163-1-salyzyn@android.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <09cd1829-8e41-bef5-ba5e-1c446c166778@gmail.com>
Date:   Thu, 23 Jul 2020 12:35:24 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <20200723182136.2550163-1-salyzyn@android.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/23/20 11:21 AM, Mark Salyzyn wrote:
> Many of the nla_get_* inlines fail to check attribute's length before
> copying the content resulting in possible out-of-boundary accesses.
> Adjust the inlines to perform nla_len checking, for the most part
> using the nla_memcpy function to faciliate since these are not
> necessarily performance critical and do not need a likely fast path.
> 
> Signed-off-by: Mark Salyzyn <salyzyn@android.com>
> Cc: netdev@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
> Cc: kernel-team@android.com
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Jakub Kicinski <kuba@kernel.org>
> Cc: Thomas Graf <tgraf@suug.ch>
> Fixes: bfa83a9e03cf ("[NETLINK]: Type-safe netlink messages/attributes interface")
> ---
>  include/net/netlink.h | 66 +++++++++++++++++++++++++++++++++++--------
>  1 file changed, 54 insertions(+), 12 deletions(-)
> 
> diff --git a/include/net/netlink.h b/include/net/netlink.h
> index c0411f14fb53..11c0f153be7c 100644
> --- a/include/net/netlink.h
> +++ b/include/net/netlink.h
> @@ -1538,7 +1538,11 @@ static inline int nla_put_bitfield32(struct sk_buff *skb, int attrtype,
>   */
>  static inline u32 nla_get_u32(const struct nlattr *nla)
>  {
> -	return *(u32 *) nla_data(nla);
> +	u32 tmp;
> +
> +	nla_memcpy(&tmp, nla, sizeof(tmp));
> +
> +	return tmp;

I believe this will hide bugs, that syzbot was able to catch.

Instead, you could perhaps introduce a CONFIG_DEBUG_NETLINK option,
and add a WARN_ON_ONCE(nla_len(nla) < sizeof(u32)) so that we can detect bugs in callers.


