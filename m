Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 18EAF5AAD3
	for <lists+netdev@lfdr.de>; Sat, 29 Jun 2019 14:19:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727017AbfF2MT0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 29 Jun 2019 08:19:26 -0400
Received: from mail-io1-f68.google.com ([209.85.166.68]:41471 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726906AbfF2MTZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 29 Jun 2019 08:19:25 -0400
Received: by mail-io1-f68.google.com with SMTP id w25so18312968ioc.8;
        Sat, 29 Jun 2019 05:19:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=LQjCzj6kSAyiqgx/XnEaKVR/sAwnNleQB4HH0jju7V8=;
        b=bpIP4kxPiE+RWJOuxStAinVwrrG63ZYrHRp2HCJwRYwAdR+lFxIYpqvGF3sWc2ZLPi
         zrGbBlFq4ZTm7REMzBqLIA0DFC47AFjYmn7eT3BUl6yHQQMvk3UOXnG+vaOGmRNJi28L
         ofuHSMYEvHT2nbFS9ccP5Zn6txZzHctp+Kt9hDbdYlONjeLC5f3vInzVTi3yuyEg2ep7
         BzdfgqEZRKpDlR3MhB2vvHjxT5f8+TPK1h28FJPufjgNfpqRsX/JUh3G93WYaVfXDy9W
         NqXufPp3tQL7hQqRTXu4NaFvbgU4EwDxKsWYNujafWId1VkiWvS8Cg08BxxOice4Nfdz
         0K/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=LQjCzj6kSAyiqgx/XnEaKVR/sAwnNleQB4HH0jju7V8=;
        b=ttrL8ACGPKBjFa0JkGODRU+kv2E4HSf7uzgcuFcXLODW3Oq3xC8I5VnMg/fhqmbCKJ
         i7B9J5TSU0XMAY84f311PvVeL5q3eW5Ap1BlcAWEtUw+7TmFR0L2BSDsU369rvFot9V3
         aA73LHQXC0IOFQf77/YCWKGIj8d1vwFyR+hOeFiXVvKQG98tVh9y6dX+3PtyaxhBG4jV
         5WJQbBWwEJD2K21sapCEOYoUUVqLZW3jy0DzAHpbjyW5JlRPDeT+Jb0JDDy9t5LLXWdX
         oEuJTyFWJcpCsQpdJ+BkvWZ+73+scwVi0UyWHa5/rVWDpJGWSPJvhPsCG9Cr/sw/SbBZ
         siow==
X-Gm-Message-State: APjAAAWOHPwybQO23WKztIY9ozQ6HYQzmT0MqN3ULbKEPrB9nMhiiHeN
        BXfkf0wiBmaYqoihYw7XJweSOcaj
X-Google-Smtp-Source: APXvYqyCvOSFAQauAhkgL2UBuPYzxiopJq4a3k5G6qQi2Y/DyBwRIt5xEtWt8QQMf1/iVWIf/Kw++A==
X-Received: by 2002:a05:6638:6a3:: with SMTP id d3mr17657118jad.33.1561810764861;
        Sat, 29 Jun 2019 05:19:24 -0700 (PDT)
Received: from ?IPv6:2601:282:800:fd80:958e:c3e2:46b7:3acd? ([2601:282:800:fd80:958e:c3e2:46b7:3acd])
        by smtp.googlemail.com with ESMTPSA id a7sm8887373iok.19.2019.06.29.05.19.23
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 29 Jun 2019 05:19:23 -0700 (PDT)
Subject: Re: [PATCH v4] net: netfilter: Fix rpfilter dropping vrf packets by
 mistake
To:     linmiaohe <linmiaohe@huawei.com>,
        "pablo@netfilter.org" <pablo@netfilter.org>
Cc:     "kadlec@blackhole.kfki.hu" <kadlec@blackhole.kfki.hu>,
        "fw@strlen.de" <fw@strlen.de>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuznet@ms2.inr.ac.ru" <kuznet@ms2.inr.ac.ru>,
        "yoshfuji@linux-ipv6.org" <yoshfuji@linux-ipv6.org>,
        "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>,
        "coreteam@netfilter.org" <coreteam@netfilter.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Mingfangsen <mingfangsen@huawei.com>
References: <2213b3e722a14ee48768ecc7118efc46@huawei.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <08740476-acfb-d35a-50b7-3aee42f23bfa@gmail.com>
Date:   Sat, 29 Jun 2019 06:19:22 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:52.0)
 Gecko/20100101 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <2213b3e722a14ee48768ecc7118efc46@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/28/19 8:13 PM, linmiaohe wrote:
> You're right. Fib rules code would set FLOWI_FLAG_SKIP_NH_OIF flag.  But I set
> it here for distinguish with the flags & XT_RPFILTER_LOOSE branch. Without
> this, they do the same work and maybe should be  combined. I don't want to
> do that as that makes code confusing.
> Is this code snipet below ok ? If so, I would delete this flag setting.
>  
>        } else if (netif_is_l3_master(dev) || netif_is_l3_slave(dev)) {
>                fl6.flowi6_oif = dev->ifindex;
>         } else if ((flags & XT_RPFILTER_LOOSE) == 0)
>                 fl6.flowi6_oif = dev->ifindex;

that looks fine to me, but it is up to Pablo.
