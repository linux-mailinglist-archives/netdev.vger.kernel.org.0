Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EE2365A1BE
	for <lists+netdev@lfdr.de>; Fri, 28 Jun 2019 19:04:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726688AbfF1REZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jun 2019 13:04:25 -0400
Received: from mail-io1-f65.google.com ([209.85.166.65]:45122 "EHLO
        mail-io1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726056AbfF1REZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Jun 2019 13:04:25 -0400
Received: by mail-io1-f65.google.com with SMTP id e3so13938355ioc.12;
        Fri, 28 Jun 2019 10:04:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=QzmSngCldiet4Ce1UUt+feV2L1nSDfkHJ0UbTbBtSwA=;
        b=vhETsdkuDe/z0ufBVN7g2tHejedidw9mY1L+Dpur6jpmPLxofvv9DXmhAd95D4AJna
         +9SoN+e3XnHPOFxt3zeOmVAW/mAIWDiP4gebZBptnoy33f++TvLg5xFvL/XOI26I6J9O
         Ejse/xmZpsc5w2WSsNB5O10+Q5+E5K5KsTmhyIBqvc0pjF7owwz3eibv03XhI1RwY8dy
         y+pbKNNJ+z3aXYJ8kbHEQlVA+E1mdFye0cH5rfAcgU92GRm6bGM02yIRpSFQl7HKBzXI
         bxO4/s2RIcmjrITor6dqg7xdG81sdj/FsnAAetrIeI16BLCU83TxurSJOhsoqwlL83el
         ZmIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=QzmSngCldiet4Ce1UUt+feV2L1nSDfkHJ0UbTbBtSwA=;
        b=HylfKKGNV6R9KFswr9uC4wBntlSfOIz0hKfgPzTUXYLDJmvezZ2PlrxUWbUkwIglrF
         a7BpQPeq+iYfbrGxGJTxGs4aSSr1pGo4Ahm6otjwNrU3TM8rJ3+uDFf0ZdBBb+Pn51H8
         gD8HKkSRBVl7zvctC1o/jcuO0xZxEgU5948FBKf7eSScJjbSqaZKMK6Z5hPuUZkD6e1M
         atPqZsNUMR5DBwg1ZfAUBVAGYfWD3I4HI1o+U6hTD0NVSu5DJqvgFXHgrIetqCEB7JS2
         BtijjM318OHgxb4/imZmG3gyF6oLh4ejEQM+apcWcye7+6HRa0QTcFO2c+K2yaDuBO5P
         9anA==
X-Gm-Message-State: APjAAAWA3KdUEJR5IDqjqghmmsMtSEC3shFveict4ocAQD53ORyxtRMD
        6JiTbkqq4RXkPM8M7KnwIRI=
X-Google-Smtp-Source: APXvYqyCJ2GraWa9zHtNqffQN5Ep3QkJtBmxhF4jLYFjvo11r028ZjaElr2UWdpM0P3kEKnLDXJkuA==
X-Received: by 2002:a6b:f711:: with SMTP id k17mr2212810iog.273.1561741464749;
        Fri, 28 Jun 2019 10:04:24 -0700 (PDT)
Received: from ?IPv6:2601:282:800:fd80:a468:85d6:9e2b:8578? ([2601:282:800:fd80:a468:85d6:9e2b:8578])
        by smtp.googlemail.com with ESMTPSA id p10sm3762067iob.54.2019.06.28.10.04.22
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 28 Jun 2019 10:04:23 -0700 (PDT)
Subject: Re: [PATCH v4] net: netfilter: Fix rpfilter dropping vrf packets by
 mistake
To:     Miaohe Lin <linmiaohe@huawei.com>, pablo@netfilter.org,
        kadlec@blackhole.kfki.hu, fw@strlen.de, davem@davemloft.net,
        kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     mingfangsen@huawei.com
References: <1561712803-195184-1-git-send-email-linmiaohe@huawei.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <4d8ff353-5bda-35b5-cdc2-ccf3fe8b97fa@gmail.com>
Date:   Fri, 28 Jun 2019 11:04:22 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:52.0)
 Gecko/20100101 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <1561712803-195184-1-git-send-email-linmiaohe@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/28/19 3:06 AM, Miaohe Lin wrote:
> diff --git a/net/ipv6/netfilter/ip6t_rpfilter.c b/net/ipv6/netfilter/ip6t_rpfilter.c
> index 6bcaf7357183..3c4a1772c15f 100644
> --- a/net/ipv6/netfilter/ip6t_rpfilter.c
> +++ b/net/ipv6/netfilter/ip6t_rpfilter.c
> @@ -55,6 +55,10 @@ static bool rpfilter_lookup_reverse6(struct net *net, const struct sk_buff *skb,
>  	if (rpfilter_addr_linklocal(&iph->saddr)) {
>  		lookup_flags |= RT6_LOOKUP_F_IFACE;
>  		fl6.flowi6_oif = dev->ifindex;
> +	/* Set flowi6_oif for vrf devices to lookup route in l3mdev domain. */
> +	} else if (netif_is_l3_master(dev) || netif_is_l3_slave(dev)) {
> +		lookup_flags |= FLOWI_FLAG_SKIP_NH_OIF;

you don't need to set that flag here. It is done by the fib_rules code
as needed.
