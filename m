Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 949D37A9F3
	for <lists+netdev@lfdr.de>; Tue, 30 Jul 2019 15:45:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730070AbfG3NpP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jul 2019 09:45:15 -0400
Received: from mail-io1-f66.google.com ([209.85.166.66]:36277 "EHLO
        mail-io1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725793AbfG3NpP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Jul 2019 09:45:15 -0400
Received: by mail-io1-f66.google.com with SMTP id o9so24546748iom.3;
        Tue, 30 Jul 2019 06:45:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=6RTHpENjgGcT8n7j+cscZh1Hx+zz2xzTQGyqiFTLqBA=;
        b=YJkMeQcWNgcV5b9gw9EbJVWAWxthAnkH+/mH/F/ILz8lIDE8pGtYLGtN4F2haS2hsF
         y9dQUWDEl6U3dxV3RZ/Qp+Vuu1jGBYJ8vdli9ZFb2Ewx1waN0hUQj539dZLGlS8L+ng6
         zRIh0h+ieTLzGrd0U63IZ634sXeIndQbwedCTAAdZ7YXdOc9q4lGSkRJ27tIQxMm33Qr
         AiZRlMhCLtEE2+UHyOydLWLC4B1Yha9ETZiWXDky9syIL57MwY/LcO5nXMBAa17RYlbh
         cDrmsZR2kpI4RCedyW9RQiowz3FUnX6RAPFbK0xpRl1kdn+Gzgrng82tzSYAC2Snlat/
         DiUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=6RTHpENjgGcT8n7j+cscZh1Hx+zz2xzTQGyqiFTLqBA=;
        b=ITT02ikf1l6aKz4Yvb7gFzzieqtM8E1eVnJdNlEVrvdv3n6W+8bPYPlHzvlGvqKpQ9
         bmgC8FQgwuWANmffEybLn7RPnT7/BD90n9xymhJRE1DIeaxdrg5MkXbzawkNUs/TMqcH
         IKHQS6X3gHTEvGVhX44pLG2xHQ4r0nCz71o8k956E1FKPfqSdu+xhJnp04KmTkThcabe
         /dfAdlBZJdKQaUlE+vZ1EQ3B1z8AZ47NQPkQZrYEWE9UkLcCblsOc9Lip4FjWNc65hKT
         G7A82vISX/Ae21LvN6By89TLjfGtjQBhok1+Vw8FK4rBIYJdQ+oB786++Hc8fBY3El7U
         0zww==
X-Gm-Message-State: APjAAAWqpxwL47Es4j1ObB9LlcQ+J6liKDyqafrnuYMOSb1Dvkxt/og6
        L0BV+fpQ4fFMZfxqLeBuvSEPrwouERs=
X-Google-Smtp-Source: APXvYqxszlTQxzY4NG08MHIjZ8Yt5xXid6uHqwTFG5wNg6lt0Gh3KRmNuPR7nn4ixo2I59NotGzZLQ==
X-Received: by 2002:a02:1c0a:: with SMTP id c10mr123387725jac.69.1564494314225;
        Tue, 30 Jul 2019 06:45:14 -0700 (PDT)
Received: from ?IPv6:2601:282:800:fd80:48fd:47f6:b7d0:19dc? ([2601:282:800:fd80:48fd:47f6:b7d0:19dc])
        by smtp.googlemail.com with ESMTPSA id n7sm50370331ioo.79.2019.07.30.06.45.12
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 30 Jul 2019 06:45:13 -0700 (PDT)
Subject: Re: [PATCH net v2] net: ipv6: Fix a bug in ndisc_send_ns when netdev
 only has a global address
To:     Su Yanjun <suyj.fnst@cn.fujitsu.com>, davem@davemloft.net,
        kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1564454115-66184-1-git-send-email-suyj.fnst@cn.fujitsu.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <ca410806-2d2d-4297-7da6-57b782a5b9fc@gmail.com>
Date:   Tue, 30 Jul 2019 07:45:08 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:52.0)
 Gecko/20100101 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <1564454115-66184-1-git-send-email-suyj.fnst@cn.fujitsu.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/29/19 8:35 PM, Su Yanjun wrote:
> diff --git a/net/ipv6/ndisc.c b/net/ipv6/ndisc.c
> index 083cc1c..156c027 100644
> --- a/net/ipv6/ndisc.c
> +++ b/net/ipv6/ndisc.c
> @@ -603,11 +603,14 @@ void ndisc_send_ns(struct net_device *dev, const struct in6_addr *solicit,
>  	int inc_opt = dev->addr_len;
>  	int optlen = 0;
>  	struct nd_msg *msg;
> +	u32 banned_flags = IFA_F_TENTATIVE | IFA_F_OPTIMISTIC;
>  
>  	if (!saddr) {

banned_flags should be declared here, under !saddr since that is the
scope of its use.


> -		if (ipv6_get_lladdr(dev, &addr_buf,
> -				   (IFA_F_TENTATIVE|IFA_F_OPTIMISTIC)))
> -			return;
> +		if (ipv6_get_lladdr(dev, &addr_buf, banned_flags)) {
> +			/* try global address */
> +			if (ipv6_get_addr(dev, &addr_buf, banned_flags))
> +				return;
> +		}
>  		saddr = &addr_buf;
>  	}
>  
> 

