Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 23EB5422B1A
	for <lists+netdev@lfdr.de>; Tue,  5 Oct 2021 16:35:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235085AbhJEOhE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Oct 2021 10:37:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233705AbhJEOhD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Oct 2021 10:37:03 -0400
Received: from mail-ot1-x335.google.com (mail-ot1-x335.google.com [IPv6:2607:f8b0:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36D62C061749
        for <netdev@vger.kernel.org>; Tue,  5 Oct 2021 07:35:13 -0700 (PDT)
Received: by mail-ot1-x335.google.com with SMTP id e66-20020a9d2ac8000000b0054da8bdf2aeso23888645otb.12
        for <netdev@vger.kernel.org>; Tue, 05 Oct 2021 07:35:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=3lJE1vVoBxcOuVpndni9d4PBf8hJwrOfedgdu/OO6Rg=;
        b=a+tDF/OgcaiKs4DYUAu7wHz9UWTqVA0I3fwl6Y27lTy8bS24n9CjinAmOKb+G79lFL
         c/qoPfkI3SvvnyqeOJ200ck/BmI/6PH+hOI0SiAvmfJrJE4jof1i2tEyP+ehH1uR4quE
         SsENxQwUNOp3XdILLuNNYmiqW06MkPMxEwyrKpYovRG25sYsNpX0gnkcbg9qeYPlESR/
         zx44X2zE00XdUt67zrefDRwDMlUABJIBi/TpLfhdYv2NoyWS3lJY7EUlUa7wu/6txni6
         yNbh6S5rk7v6+H7a3xtr6NTR6z/yE5zYX/LL/z3fTS3WYajLU/RycOMprVD7tO59GJGF
         3/BQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=3lJE1vVoBxcOuVpndni9d4PBf8hJwrOfedgdu/OO6Rg=;
        b=b5rgHNqJQBNCMCc678VARs7oMdSlQE9UyPhq/lfxWpaGrMOpisCMM1rHrMfGRLPcRl
         RzLXi89bTiON3WLl/rAUgtegeoLnIbYM6eOYOC3oQYPlw4UbXtsER7AvwWdibiCLZXQm
         BlKCtKmk3w1xu4q25YetHYDKlKhDYMGv6OrDvhRIKMqHKioHcSLh5ovCacGcb2pfv7il
         FuGdHkujgjphV+7aqu0OpQtA0oSEwN13y1/1SLE042/at5mtbArQvvQgxwXrgi8za8Cb
         jgX25MKERAp7+peqp7ScDjwMtDAM7rySfEICZjb1rsWAP6HcBLamfpzxr9vlFuIfQ9/W
         SOkA==
X-Gm-Message-State: AOAM5335qCQyvID8LFOmCtcuCDEgKE7j/sIQivibTxQjiWprx/abk6Fu
        UJnjjZ+7dNs7QZmQVtxip7U=
X-Google-Smtp-Source: ABdhPJzeanh0G0bnG/TwTzd6R6b4RxqluuLsQHQ1ejpZL3ifsn7IhPtwelM1NTqAPx+onjDlkwXYXA==
X-Received: by 2002:a9d:7093:: with SMTP id l19mr14454516otj.15.1633444512603;
        Tue, 05 Oct 2021 07:35:12 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([8.48.134.30])
        by smtp.googlemail.com with ESMTPSA id u2sm3590223otg.51.2021.10.05.07.35.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 05 Oct 2021 07:35:08 -0700 (PDT)
Subject: Re: [PATCH iproute2-next] ip: nexthop: keep cache netlink socket open
To:     Nikolay Aleksandrov <razor@blackwall.org>, netdev@vger.kernel.org
Cc:     roopa@nvidia.com, Nikolay Aleksandrov <nikolay@nvidia.com>
References: <c036dc79-0d78-df8b-343b-fa9a913bd5cf@gmail.com>
 <20211004090328.2329012-1-razor@blackwall.org>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <016dbae1-3a80-e731-d056-3a23ad2f7265@gmail.com>
Date:   Tue, 5 Oct 2021 08:35:04 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20211004090328.2329012-1-razor@blackwall.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/4/21 3:03 AM, Nikolay Aleksandrov wrote:
> From: Nikolay Aleksandrov <nikolay@nvidia.com>
> 
> Since we use the cache netlink socket for each nexthop we can keep it open
> instead of opening and closing it on every add call. The socket is opened
> once, on the first add call and then reused for the rest.
> 
> Suggested-by: David Ahern <dsahern@gmail.com>
> Signed-off-by: Nikolay Aleksandrov <nikolay@nvidia.com>
> ---
> I actually had this in my initial patchset, but switched it with the
> open/close on each call. TBH, I don't recall why, perhaps to be the same
> as the link cache. I don't see a reason not to keep the socket open.
> 
> I've re-run the stress test and the selftests, all look good.
> 
>  ip/ipnexthop.c | 9 +++++----
>  1 file changed, 5 insertions(+), 4 deletions(-)
> 

applied to iproute2-next. Thanks,

