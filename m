Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 964CD77C82
	for <lists+netdev@lfdr.de>; Sun, 28 Jul 2019 02:32:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387859AbfG1Ack (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 27 Jul 2019 20:32:40 -0400
Received: from mail-io1-f68.google.com ([209.85.166.68]:39372 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726526AbfG1Ack (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 27 Jul 2019 20:32:40 -0400
Received: by mail-io1-f68.google.com with SMTP id f4so112460767ioh.6;
        Sat, 27 Jul 2019 17:32:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Gc7hJOMCYYUlzXVlEg8HfUg4RlT7fJ1IyZ9SQFOPTw8=;
        b=YXULFW/pveoU0GBUoO1Mzyctep1lnmE1Z4Wf46OnNzM+xxG5e9o5FfnUdT+Gr9G+f7
         pq9X35V3A9MkztVIULlRS8Yj05GrlbJGOjYLnsbaN7u4+8qLyeK2w86zFqa5epwe84lI
         1NcY9+JJAS/b7/dd9p2YY00BKOoDnVmnVEufxL91/vWLvJDLA5a0lV4604o59og+ajzm
         eSm4PCh9hIQNqIH4ESGu8PlFugRHK/zJ4qUgBQ/6I8S6S0gdtqaKuJof7OhtdeYL0IUu
         4JcRuoK+rO/JGSH4JRbXo0Xl+1e1VMuHo0P8t+HFo62SLYkRvfZqtrvSvzqRYqk/z7ep
         t1bg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Gc7hJOMCYYUlzXVlEg8HfUg4RlT7fJ1IyZ9SQFOPTw8=;
        b=iiLq77UQ5CFADTQ6BP5MnBFo6fXIkJnRB9CT4/IRvn4VrVeoJ4ny/HKkuuNb555XEq
         fFzxoBrcljvcQ5JpcZ4RsIMXknuEPhqs0HSIpV4bKt7fHLD5GTVspkSUfJGbWvfflhsW
         HAMx7mOZWJmkBGX4kRlRwW4Wwd6L5/nHR/MyIECdOyTJCXecqRxg2axUk9Akt3xv6Ljv
         BG9TN6EubPVh9FUTir2rSJnFLI+neHXupoZlz94d6MgJKbkM+1u/sLjZOYc9lDmemggw
         LyQSRtWglXYWqxRCpzuFYrSC9bubF9tyiW3G+yl1SheFEE4yDV4VsVY8NxP78QoVI+Nq
         5F+A==
X-Gm-Message-State: APjAAAW2yADzHlXlNbgF0bNxzXXu/5T7rG5WDe3S1kL6JQZxH8lV1Day
        4EQFEDNPBXWtMfqKO1ZlAmzKu6NH
X-Google-Smtp-Source: APXvYqyUve1fmJNdtxsJteT827jKPt8wK2K5WNM+uZgOMeBe3c+xq5OxBrKVA8dUBOikM8DcpBj1fQ==
X-Received: by 2002:a5e:a710:: with SMTP id b16mr21019831iod.38.1564273959214;
        Sat, 27 Jul 2019 17:32:39 -0700 (PDT)
Received: from ?IPv6:2601:282:800:fd80:8d96:da24:c7b3:3d25? ([2601:282:800:fd80:8d96:da24:c7b3:3d25])
        by smtp.googlemail.com with ESMTPSA id i23sm40996185ioj.24.2019.07.27.17.32.37
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 27 Jul 2019 17:32:38 -0700 (PDT)
Subject: Re: [PATCH] rocker: fix memory leaks of fib_work on two error return
 paths
To:     Colin King <colin.king@canonical.com>,
        Jiri Pirko <jiri@resnulli.us>,
        "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20190727233726.3121-1-colin.king@canonical.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <d3b8bb71-21d3-97ae-0807-d0300ba44a04@gmail.com>
Date:   Sat, 27 Jul 2019 18:32:33 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:52.0)
 Gecko/20100101 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <20190727233726.3121-1-colin.king@canonical.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/27/19 5:37 PM, Colin King wrote:
> From: Colin Ian King <colin.king@canonical.com>
> 
> Currently there are two error return paths that leak memory allocated
> to fib_work. Fix this by kfree'ing fib_work before returning.
> 
> Addresses-Coverity: ("Resource leak")
> Fixes: 19a9d136f198 ("ipv4: Flag fib_info with a fib_nh using IPv6 gateway")
> Fixes: dbcc4fa718ee ("rocker: Fail attempts to use routes with nexthop objects")
> Signed-off-by: Colin Ian King <colin.king@canonical.com>
> ---
>  drivers/net/ethernet/rocker/rocker_main.c | 2 ++
>  1 file changed, 2 insertions(+)
> 

Thanks for the patch,
Reviewed-by: David Ahern <dsahern@gmail.com>
