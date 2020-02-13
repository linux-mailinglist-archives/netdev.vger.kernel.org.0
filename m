Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B8A9015C845
	for <lists+netdev@lfdr.de>; Thu, 13 Feb 2020 17:33:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728078AbgBMQdF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Feb 2020 11:33:05 -0500
Received: from mail-wm1-f65.google.com ([209.85.128.65]:40953 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727828AbgBMQdF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Feb 2020 11:33:05 -0500
Received: by mail-wm1-f65.google.com with SMTP id t14so7469252wmi.5
        for <netdev@vger.kernel.org>; Thu, 13 Feb 2020 08:33:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=6wind.com; s=google;
        h=reply-to:subject:to:references:from:organization:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=9tHgekIHlC5+cihMkWFyyekxwRBJeo3gDHbBhpXzdUI=;
        b=VnuRT2MBphLMUVUlAuVys1hgQ2ewyy9uvuwxTtjRkQyG+GjW1HoMnTI6N8EqpsPoOW
         mgvTIIpIB7wYOfbIz2i0bYDkOx/bjBvOX3dhm1vMdmgDWNWtYXDOrhgsOe98bvLVrckd
         87klj417thhcm2uRrKFNUMICxW2tNSqeBMiSUncKrunIYFuuz0k/Q5mBozo39degIgka
         oCUe5Fjc1KmBOl59hWt8Y6QznFG0OTASV7I5+s3maMd+iBlucywMG6ME9nFEvJC6B1UI
         MUzw1CuAM43ILuItSquj/g485Art+vcINJTWSMNFy5Wwh3YZV5rNWcVHvXq3QiSnRSeM
         8nHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:subject:to:references:from:organization
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=9tHgekIHlC5+cihMkWFyyekxwRBJeo3gDHbBhpXzdUI=;
        b=XuqyXhZ2wSXXqjxXx8wextXVg5Tp+JYRtN0lQQEuR4BRs9C5K5FnfnaCSj+ITVvOah
         XcqvvUJl0pJSo98zAexb/3QQsCzQrD7i9qKRdqSw1XFavt9ZqapWitxFob1myI4UFRxi
         sYRM9tjBp+MTFYAQO764JoX4o93YixS0rJdMquWs/rsVsJppA3rMKe2FesUsaiOWNQUe
         VJl5gcZlKybaa7W4GvYBAFtnR/1ey5a3LFWrYut8ENl9N2sYH/IFO6Ivxl0ng4YadpI8
         HI5N26ny0IEIvwnCvpODc3DPYrcoXcZ+G7+PTGXSqZSW+9owoLEv3AGFC7F1/KZDqxRU
         kTDw==
X-Gm-Message-State: APjAAAU3WFKNVlSs4vE/Ebwkcux5PR1kTohhL3Gs2mqP24jCF8ZGdVWS
        SqNSZYrk0o05+HW8WwmW5eEtgd8juYQ=
X-Google-Smtp-Source: APXvYqzpjv55RQMLX6eNx3bSKVToLVRO8UwHbyj4PRBo9g0d6tLyCWYRuFYe9IXtcRagj7V0YU1VOg==
X-Received: by 2002:a7b:cae9:: with SMTP id t9mr6570686wml.186.1581611583011;
        Thu, 13 Feb 2020 08:33:03 -0800 (PST)
Received: from ?IPv6:2a01:e0a:410:bb00:7cb8:8eea:bf1c:ed6? ([2a01:e0a:410:bb00:7cb8:8eea:bf1c:ed6])
        by smtp.gmail.com with ESMTPSA id x6sm3459098wmi.44.2020.02.13.08.33.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 13 Feb 2020 08:33:02 -0800 (PST)
Reply-To: nicolas.dichtel@6wind.com
Subject: Re: [PATCH v4 net] net, ip6_tunnel: enhance tunnel locate with link
 check
To:     William Dauchy <w.dauchy@criteo.com>, netdev@vger.kernel.org
References: <cc378ec7-03ec-58ec-e3c9-158fb02b283e@6wind.com>
 <20200213153552.330380-1-w.dauchy@criteo.com>
From:   Nicolas Dichtel <nicolas.dichtel@6wind.com>
Organization: 6WIND
Message-ID: <cf5ef569-1742-a22f-ec7d-f987287e12fb@6wind.com>
Date:   Thu, 13 Feb 2020 17:33:01 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200213153552.330380-1-w.dauchy@criteo.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Le 13/02/2020 à 16:35, William Dauchy a écrit :
[snip]
> @@ -1420,9 +1441,11 @@ ip6_tnl_start_xmit(struct sk_buff *skb, struct net_device *dev)
>  static void ip6_tnl_link_config(struct ip6_tnl *t)
>  {
>  	struct net_device *dev = t->dev;
> +	struct net_device *tdev = NULL;
>  	struct __ip6_tnl_parm *p = &t->parms;
>  	struct flowi6 *fl6 = &t->fl.u.ip6;
>  	int t_hlen;
> +	int mtu;
>  
>  	memcpy(dev->dev_addr, &p->laddr, sizeof(struct in6_addr));
>  	memcpy(dev->broadcast, &p->raddr, sizeof(struct in6_addr));
> @@ -1457,22 +1480,24 @@ static void ip6_tnl_link_config(struct ip6_tnl *t)
>  		struct rt6_info *rt = rt6_lookup(t->net,
>  						 &p->raddr, &p->laddr,
>  						 p->link, NULL, strict);
> +		if (!IS_ERR(rt)) {
Why IS_ERR()? rt6_lookup() returns a valid pointer or NULL.

> +			tdev = rt->dst.dev;
> +			ip6_rt_put(rt);
> +		} else if (t->parms.link) {
> +			tdev = __dev_get_by_index(t->net, t->parms.link);
p->link to be consistent with the rest of the function.

> +		}
>  
> -		if (!rt)
> -			return;
> -
> -		if (rt->dst.dev) {
But rt->dst.dev can be NULL.

> -			dev->hard_header_len = rt->dst.dev->hard_header_len +
> -				t_hlen;
> +		if (tdev) {
> +			dev->hard_header_len = tdev->hard_header_len + t_hlen;
> +			mtu = min(tdev->mtu, IP_MAX_MTU);
IP6_MAX_MTU?

>  
> -			dev->mtu = rt->dst.dev->mtu - t_hlen;
> +			dev->mtu = mtu - t_hlen;
>  			if (!(t->parms.flags & IP6_TNL_F_IGN_ENCAP_LIMIT))
>  				dev->mtu -= 8;
>  
>  			if (dev->mtu < IPV6_MIN_MTU)
>  				dev->mtu = IPV6_MIN_MTU;
>  		}
> -		ip6_rt_put(rt);
>  	}
>  }
>  
> 
