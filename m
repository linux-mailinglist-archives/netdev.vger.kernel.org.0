Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 272C5FCFC2
	for <lists+netdev@lfdr.de>; Thu, 14 Nov 2019 21:38:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726533AbfKNUiM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Nov 2019 15:38:12 -0500
Received: from mail-lj1-f196.google.com ([209.85.208.196]:46153 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726549AbfKNUiM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Nov 2019 15:38:12 -0500
Received: by mail-lj1-f196.google.com with SMTP id e9so8131214ljp.13
        for <netdev@vger.kernel.org>; Thu, 14 Nov 2019 12:38:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cogentembedded-com.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:organization:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=oc3P5Afq3KH5qXhVRmfQSbsKXA7kwebSZi8EfNwho84=;
        b=S61QlzamJgZG9f05uS4TssEeCYKifsXtXiqkkBUgBMiYgOfLxai2Dog9/pz9lW2Fns
         a0W9NXM6rJWf7QC4unVfvV2rI/F0ud/qJcSxTecE9uZsYreMEJp0/yCKNzCeEWxj17sw
         BBIwtTlm6zjFy1u/yYDcPthT2Mv1YeEciQMX6EAH8lcTcloCgAEU/F5euQeOt0Es+gsB
         GIh2TDbhHtrzI5ljeTI0qpRtXz/6VHh4nm0BNL7+d9+2QrUCT0xkIecaeKPHgJOuN2Il
         T5TPPqkkmroLQYgUPcvlRnr1yAQGxsRV9qnQVM0uAwljBfFIhsF6Qj4L2CnKvqKNHSFh
         Qk1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:organization
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=oc3P5Afq3KH5qXhVRmfQSbsKXA7kwebSZi8EfNwho84=;
        b=smkkaEU9pfc98WOkf65l36NT8rWKQXPW42go5TxzB26hLt5EL7F38y2Y09D7J8KSPC
         m1cCysZY7GNwcDQJZS4vmrbXla6auO95CGdJHx8MsvDKPYE3GkZavjycpL+TRFz7SF8a
         xFAkYsM1m1bosymIiXtveNMZ0BbSFZB8O1c+eTkrafXP98zxdGut6k5Q5GTKM1XgDxJA
         QAki6qy8dgdt248tAi1go8TUH+8KZjJ+8kqflpJSNadE1QTQNjo6tG8dz9vnTuL89oVP
         wE6/DOjXEDYrLYauYOiZYKZcnyDGu2FSC7BUdrn5NyE1n6lO4AclTjHvrgZhM77o2A+F
         OaUw==
X-Gm-Message-State: APjAAAXE0N03AHNX14l9LyU0wvtJM6DiDI4VClc+jDn4Lpbb95NZ4ZLY
        FxYlfZQDIZgeinFBlh5LMuztSw==
X-Google-Smtp-Source: APXvYqzxFajzQp7aiaJfpWxsvEfCHLSfcxtEeJw8+CLeSZnVmK1Xnea/evdkSg0HvvbcWibekw759Q==
X-Received: by 2002:a2e:7c12:: with SMTP id x18mr8340062ljc.130.1573763889935;
        Thu, 14 Nov 2019 12:38:09 -0800 (PST)
Received: from wasted.cogentembedded.com ([109.167.219.12])
        by smtp.gmail.com with ESMTPSA id u17sm3330545ljl.90.2019.11.14.12.38.08
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 14 Nov 2019 12:38:09 -0800 (PST)
Subject: Re: [PATCH v4] ravb: implement MTU change while device is up
To:     Ulrich Hecht <uli+renesas@fpond.eu>,
        linux-renesas-soc@vger.kernel.org
Cc:     netdev@vger.kernel.org, davem@davemloft.net,
        niklas.soderlund@ragnatech.se, wsa@the-dreams.de,
        horms@verge.net.au, magnus.damm@gmail.com, geert@glider.be
References: <20191114014949.31057-1-uli+renesas@fpond.eu>
From:   Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Organization: Cogent Embedded
Message-ID: <e2e24b1b-a175-f0b4-2528-a09d786d380b@cogentembedded.com>
Date:   Thu, 14 Nov 2019 23:38:08 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.1
MIME-Version: 1.0
In-Reply-To: <20191114014949.31057-1-uli+renesas@fpond.eu>
Content-Type: text/plain; charset=utf-8
Content-Language: en-MW
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello!

On 11/14/2019 04:49 AM, Ulrich Hecht wrote:

> Pre-allocates buffers sufficient for the maximum supported MTU (2026) in
> order to eliminate the possibility of resource exhaustion when changing the
> MTU while the device is up.
> 
> Signed-off-by: Ulrich Hecht <uli+renesas@fpond.eu>

Reviewed-by: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>

> ---
>  drivers/net/ethernet/renesas/ravb.h      |  3 ++-
>  drivers/net/ethernet/renesas/ravb_main.c | 26 +++++++++++++-----------
>  2 files changed, 16 insertions(+), 13 deletions(-)
> 
> diff --git a/drivers/net/ethernet/renesas/ravb.h b/drivers/net/ethernet/renesas/ravb.h
> index a9c89d5d8898..9f88b5db4f89 100644
> --- a/drivers/net/ethernet/renesas/ravb.h
> +++ b/drivers/net/ethernet/renesas/ravb.h
> @@ -955,6 +955,8 @@ enum RAVB_QUEUE {
>  #define NUM_RX_QUEUE	2
>  #define NUM_TX_QUEUE	2
>  
> +#define RX_BUF_SZ	(2048 - ETH_FCS_LEN + sizeof(__sum16))

   That's smart but won't scale iff we decide to support e.g. Jumbo frames (the real AVB h/w
supports up to 128 KiB frames.

[...]

MBR, Sergei
