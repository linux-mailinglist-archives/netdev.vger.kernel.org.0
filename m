Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BEF4442D0C4
	for <lists+netdev@lfdr.de>; Thu, 14 Oct 2021 05:05:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229913AbhJNDHr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Oct 2021 23:07:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229834AbhJNDHr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Oct 2021 23:07:47 -0400
Received: from mail-oo1-xc33.google.com (mail-oo1-xc33.google.com [IPv6:2607:f8b0:4864:20::c33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BCBAC061570;
        Wed, 13 Oct 2021 20:05:43 -0700 (PDT)
Received: by mail-oo1-xc33.google.com with SMTP id n15-20020a4ad12f000000b002b6e3e5fd5dso1446992oor.1;
        Wed, 13 Oct 2021 20:05:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=d1385PWcZJRF7AKd4UEG4AV7ybG/wi0GEJ0BosT22g8=;
        b=pXKAMmR/xzMljbw/eNfBG8AuOseS2mPEMgiIEKceLbWLKcjP81ozhY9W5V5Cdy7Qgp
         BGOIHvLPcVYP11vhOOAdhoytozAQ/hA627OtLzuPft++hivhcvdQ160zBPsZO8GkY5DE
         vZ6xoA+6+Jg4ARXxjkmqlmxhFYxxncjLhMt0kx+KcgAB6NhJNH+4RU7Sbj2FqtyXtV+l
         q4jh1/oAR5hhECoSlaOH90TABOVAEqeCfNwe1lAqaTsphXcdBmJ8hBRRfgA0jXuY+CQG
         HrLokNTr5KOvnYDilgXI5mbBmgbzYVeZhIRGw7fW80dkCAm4G80c133AjrxCdNH7kamu
         LnUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=d1385PWcZJRF7AKd4UEG4AV7ybG/wi0GEJ0BosT22g8=;
        b=v2jezdAXhpwC/RYp4Cxa1d1wPzp63LjI1Hm4xriy0yAgSexQ4h7t1TigrHjB7qGBdw
         +OJGuvuYCl9xHN0ndB2jZm2vTU0TfCw6WO4IJHUGscZ48o0enOPuJt/BTRi9dtpBCHCC
         BGxWj+Qb5UKipttB3MoT7kxiFGq4LOYkXqo5aCAph5iUxZeaVW2Z4CP13eE1o7twVe4F
         gyT8ZPQqpOW7bRN7gEuL3Xb9Eu/GSGhmcGWeX3cRzQWt5YIbpTfoEObMXEFhqCGbD+XL
         s6thwpfE956SiXwCkYAh2YBozqXB/HX6AhfOezbmpRjk6/uyXVDbZajfFot9X5ZmkQWv
         AMyQ==
X-Gm-Message-State: AOAM530CIS7D8N3DoZWpfupTGGs+4CDnRtYt43iqi3+fAfxX55Al82Dj
        F2RZCJXplgWlwcYY5iFzwul2LGsStAJrwg==
X-Google-Smtp-Source: ABdhPJyMU3EjySfOQ6JyMsRrLZcxyafz4scF+7NQeAec7TbUuE5tLE7xrLtL0hD7XG2a2bu/LssKvA==
X-Received: by 2002:a4a:d5c8:: with SMTP id a8mr1784724oot.18.1634180741652;
        Wed, 13 Oct 2021 20:05:41 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([8.48.134.40])
        by smtp.googlemail.com with ESMTPSA id c3sm314906otr.42.2021.10.13.20.05.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 13 Oct 2021 20:05:40 -0700 (PDT)
Subject: Re: [PATCH v2 1/4] tcp: md5: Fix overlap between vrf and non-vrf keys
To:     Leonard Crestez <cdleonard@gmail.com>,
        David Ahern <dsahern@kernel.org>,
        Eric Dumazet <edumazet@google.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Kuniyuki Iwashima <kuniyu@amazon.co.jp>,
        Yonghong Song <yhs@fb.com>,
        Alexander Duyck <alexanderduyck@fb.com>,
        Florian Westphal <fw@strlen.de>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <cover.1634107317.git.cdleonard@gmail.com>
 <6d99312c4863c37ad394c815f8529ee635bdb0d0.1634107317.git.cdleonard@gmail.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <65cb2c9f-28f8-8570-3275-b1080232a7f8@gmail.com>
Date:   Wed, 13 Oct 2021 21:05:39 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <6d99312c4863c37ad394c815f8529ee635bdb0d0.1634107317.git.cdleonard@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/13/21 12:50 AM, Leonard Crestez wrote:
> With net.ipv4.tcp_l3mdev_accept=1 it is possible for a listen socket to
> accept connection from the same client address in different VRFs. It is
> also possible to set different MD5 keys for these clients which differ
> only in the tcpm_l3index field.
> 
> This appears to work when distinguishing between different VRFs but not
> between non-VRF and VRF connections. In particular:
> 
>  * tcp_md5_do_lookup_exact will match a non-vrf key against a vrf key.
> This means that adding a key with l3index != 0 after a key with l3index
> == 0 will cause the earlier key to be deleted. Both keys can be present
> if the non-vrf key is added later.
>  * _tcp_md5_do_lookup can match a non-vrf key before a vrf key. This
> casues failures if the passwords differ.
> 
> Fix this by making tcp_md5_do_lookup_exact perform an actual exact
> comparison on l3index and by making  __tcp_md5_do_lookup perfer
> vrf-bound keys above other considerations like prefixlen.
> 
> Fixes: dea53bb80e07 ("tcp: Add l3index to tcp_md5sig_key and md5 functions")
> Signed-off-by: Leonard Crestez <cdleonard@gmail.com>
> ---
>  net/ipv4/tcp_ipv4.c | 19 ++++++++++++++++---
>  1 file changed, 16 insertions(+), 3 deletions(-)
> 

Reviewed-by: David Ahern <dsahern@kernel.org>


