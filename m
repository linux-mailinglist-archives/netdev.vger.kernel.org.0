Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7DF7E3C3DF3
	for <lists+netdev@lfdr.de>; Sun, 11 Jul 2021 18:32:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232820AbhGKQeD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 11 Jul 2021 12:34:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232774AbhGKQeD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 11 Jul 2021 12:34:03 -0400
Received: from mail-oi1-x22a.google.com (mail-oi1-x22a.google.com [IPv6:2607:f8b0:4864:20::22a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5677C0613DD
        for <netdev@vger.kernel.org>; Sun, 11 Jul 2021 09:31:15 -0700 (PDT)
Received: by mail-oi1-x22a.google.com with SMTP id h9so20657045oih.4
        for <netdev@vger.kernel.org>; Sun, 11 Jul 2021 09:31:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=wogmbwVaaXKYxI6im7LsS6EOsoOTZ0XDvVDb4ek9Rxg=;
        b=G0HZ3J/hQRnA0sefjQZXgOf4UOaB/ODtCMhHAJ16Mbme0z6N9T4hb/Lfu44Vf5J6Sj
         VLvBJWFvhqosOK2qahYrwSkBCHZLeC6fgGlBn9Bt3Nqhq7uJpYlSuxgyyo5mGHbD9gA+
         oCV1R7JsKhZu7Fy03AxtXc3jlgE/jRkN3llIbGo6rVJd8z2uEKS7WXFEWjeKQTTqV84v
         XQQF07FcbmnEk6d0L156eTg/wTEO0x+Z8pWWBIOWaCGrpU/mDmKta7otHF16Jp0keM87
         Q6Sr2sbRlQ5pcd1u+6mA7o+lfg4lJeAkFdF+hwpKvm71NHSwR61UkCi9/mSFE2dU8Uk4
         OtYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=wogmbwVaaXKYxI6im7LsS6EOsoOTZ0XDvVDb4ek9Rxg=;
        b=TR2Jho6BsCzbZgGB4aPDgVkRDP+IVkrt7vKTKFkWycNRIl8ts/aeeB6Vn9xWRYJGrp
         UADiCTrpgYGB4yadWVZvX9bLKe+tv+rCCZesSgsotJvTavzEggu8TrcWiMYJw20pBRL7
         xUZEFrKO6nHM3PEGzDPXoK6xOz1mxjWqpG8LFRoBKMYpmSyMu5AxTqSTUpZqXHuejdQC
         owTvgnAlQRh1ls7p73ytlTP44sr/qgTrgdCPpNigrEo1bBrc6x7FxmWPcgyoH5jx5csZ
         R3ELzYQb0NwMGGvn5HMpU3BEfnHrBOLDsWxciGvdTY8rzgXXGIx7ZnTDgbPby54qZbit
         Tp6Q==
X-Gm-Message-State: AOAM5308QUoXE7UQ6A1xSVly4LS8wFBHywi0acmxNFhdsUCfnqX8u8Nj
        VdD2QyyfXK7OYvOocW9P+b6QRf0fSpFuMA==
X-Google-Smtp-Source: ABdhPJzbG0GWi6ZCXMM+ibue3GP0C4jPX5sagAWcLYrNAdk7C3JlBuiUY4iBsOC/XbMAFoQuZFghWg==
X-Received: by 2002:a05:6808:692:: with SMTP id k18mr7114815oig.148.1626021075171;
        Sun, 11 Jul 2021 09:31:15 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([8.48.134.38])
        by smtp.googlemail.com with ESMTPSA id o9sm532644oiw.49.2021.07.11.09.31.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 11 Jul 2021 09:31:14 -0700 (PDT)
Subject: Re: [PATCH net-next 2/2] net: ipv4: Consolidate ipv4_mtu and
 ip_dst_mtu_maybe_forward
To:     Vadim Fedorenko <vfedorenko@novek.ru>,
        David Ahern <dsahern@kernel.org>, netdev@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        "David S. Miller" <davem@davemloft.net>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>
References: <20210705213617.18317-1-vfedorenko@novek.ru>
 <20210705213617.18317-3-vfedorenko@novek.ru>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <a65737a6-aaae-0fa3-537d-d07471d7d193@gmail.com>
Date:   Sun, 11 Jul 2021 10:31:13 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210705213617.18317-3-vfedorenko@novek.ru>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/5/21 3:36 PM, Vadim Fedorenko wrote:
> Consolidate IPv4 MTU code the same way it is done in IPv6 to have code
> aligned in both address families
> 
> Signed-off-by: Vadim Fedorenko <vfedorenko@novek.ru>
> ---
>  include/net/ip.h | 22 ++++++++++++++++++----
>  net/ipv4/route.c | 21 +--------------------
>  2 files changed, 19 insertions(+), 24 deletions(-)
> 

Reviewed-by: David Ahern <dsahern@kernel.org>


