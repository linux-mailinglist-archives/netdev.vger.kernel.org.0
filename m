Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DE30D197BEE
	for <lists+netdev@lfdr.de>; Mon, 30 Mar 2020 14:34:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730176AbgC3Met (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Mar 2020 08:34:49 -0400
Received: from forwardcorp1p.mail.yandex.net ([77.88.29.217]:54140 "EHLO
        forwardcorp1p.mail.yandex.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729972AbgC3Mes (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Mar 2020 08:34:48 -0400
Received: from mxbackcorp2j.mail.yandex.net (mxbackcorp2j.mail.yandex.net [IPv6:2a02:6b8:0:1619::119])
        by forwardcorp1p.mail.yandex.net (Yandex) with ESMTP id 8742C2E145B;
        Mon, 30 Mar 2020 15:34:45 +0300 (MSK)
Received: from vla5-58875c36c028.qloud-c.yandex.net (vla5-58875c36c028.qloud-c.yandex.net [2a02:6b8:c18:340b:0:640:5887:5c36])
        by mxbackcorp2j.mail.yandex.net (mxbackcorp/Yandex) with ESMTP id sJNm8W33zB-Yi88MPBg;
        Mon, 30 Mar 2020 15:34:45 +0300
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex-team.ru; s=default;
        t=1585571685; bh=D5hxrkeuTPe28Dn+5LHGq2bHTkYTYq7ip7aP/kwuLUs=;
        h=In-Reply-To:Message-ID:From:Date:References:To:Subject:Cc;
        b=Nc8A4MU+qyUgcau0J2Rhiah8ciSKAmxmltKPrmXaI9XBeSxcDYmzov9lXem7X8JLU
         DQuJuP0VkM65p/W/+/iyOg1KprQzda/kYVrxTVMN0HKTP8ynGBU1Yuq7QVs7wSQLoY
         OE9cjBNh+ezy2FrxJfp/ioA7EWBw3KIRhigqwvug=
Authentication-Results: mxbackcorp2j.mail.yandex.net; dkim=pass header.i=@yandex-team.ru
Received: from unknown (unknown [2a02:6b8:b080:8617::1:1])
        by vla5-58875c36c028.qloud-c.yandex.net (smtpcorp/Yandex) with ESMTPSA id 7cEwYPC9vo-YiX8sWrY;
        Mon, 30 Mar 2020 15:34:44 +0300
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (Client certificate not present)
Subject: Re: [PATCH v2 net] inet_diag: add cgroup id attribute
To:     Dmitry Yakunin <zeil@yandex-team.ru>, davem@davemloft.net,
        netdev@vger.kernel.org
References: <20200330113803.GA19490@yandex-team.ru>
From:   Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
Cc:     cgroups@vger.kernel.org, bpf@vger.kernel.org
Message-ID: <e343dd4f-4ac7-90ba-29cd-bb01721ee613@yandex-team.ru>
Date:   Mon, 30 Mar 2020 15:34:44 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200330113803.GA19490@yandex-team.ru>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-CA
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 30/03/2020 14.38, Dmitry Yakunin wrote:
> This patch adds cgroup v2 id to common inet diag message attributes.
> This allows investigate sockets on per cgroup basis when
> net_cls/net_prio cgroup not used.

After second thought:
Option CONFIG_SOCK_CGROUP_DATA are not directly enabled in config.
It's selected by CONFIG_CGROUP_BPF or legacy CGROUP_NET_CLASSID/PRIO.

So, it would be more clear to put this code under ifdef CONFIG_CGROUP_BPF.
Because it exposes cgroup2 id and has nothing to do with legacy cgroups.

+CC cgroups@vger.kernel.org and bpf@vger.kernel.org

> 
> Signed-off-by: Dmitry Yakunin <zeil@yandex-team.ru>
> Reviewed-by: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
> ---
>   include/linux/inet_diag.h      | 6 +++++-
>   include/uapi/linux/inet_diag.h | 1 +
>   net/ipv4/inet_diag.c           | 7 +++++++
>   3 files changed, 13 insertions(+), 1 deletion(-)
> 
> diff --git a/include/linux/inet_diag.h b/include/linux/inet_diag.h
> index c91cf2d..8bc5e7d 100644
> --- a/include/linux/inet_diag.h
> +++ b/include/linux/inet_diag.h
> @@ -66,7 +66,11 @@ static inline size_t inet_diag_msg_attrs_size(void)
>   		+ nla_total_size(1)  /* INET_DIAG_SKV6ONLY */
>   #endif
>   		+ nla_total_size(4)  /* INET_DIAG_MARK */
> -		+ nla_total_size(4); /* INET_DIAG_CLASS_ID */
> +		+ nla_total_size(4)  /* INET_DIAG_CLASS_ID */
> +#ifdef CONFIG_SOCK_CGROUP_DATA
> +		+ nla_total_size(8)  /* INET_DIAG_CGROUP_ID */
> +#endif
> +		;
>   }
>   int inet_diag_msg_attrs_fill(struct sock *sk, struct sk_buff *skb,
>   			     struct inet_diag_msg *r, int ext,
> diff --git a/include/uapi/linux/inet_diag.h b/include/uapi/linux/inet_diag.h
> index a1ff345..dc87ad6 100644
> --- a/include/uapi/linux/inet_diag.h
> +++ b/include/uapi/linux/inet_diag.h
> @@ -154,6 +154,7 @@ enum {
>   	INET_DIAG_CLASS_ID,	/* request as INET_DIAG_TCLASS */
>   	INET_DIAG_MD5SIG,
>   	INET_DIAG_ULP_INFO,
> +	INET_DIAG_CGROUP_ID,
>   	__INET_DIAG_MAX,
>   };
>   
> diff --git a/net/ipv4/inet_diag.c b/net/ipv4/inet_diag.c
> index 8c83775..ba0bb14 100644
> --- a/net/ipv4/inet_diag.c
> +++ b/net/ipv4/inet_diag.c
> @@ -161,6 +161,13 @@ int inet_diag_msg_attrs_fill(struct sock *sk, struct sk_buff *skb,
>   			goto errout;
>   	}
>   
> +#ifdef CONFIG_SOCK_CGROUP_DATA
> +	if (nla_put_u64_64bit(skb, INET_DIAG_CGROUP_ID,
> +			      cgroup_id(sock_cgroup_ptr(&sk->sk_cgrp_data)),
> +			      INET_DIAG_PAD))
> +		goto errout;
> +#endif
> +
>   	r->idiag_uid = from_kuid_munged(user_ns, sock_i_uid(sk));
>   	r->idiag_inode = sock_i_ino(sk);
>   
> 
