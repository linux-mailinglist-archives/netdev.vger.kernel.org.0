Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C0B3C366E20
	for <lists+netdev@lfdr.de>; Wed, 21 Apr 2021 16:25:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239852AbhDUO0X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Apr 2021 10:26:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237528AbhDUO0V (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Apr 2021 10:26:21 -0400
Received: from mail-lf1-x130.google.com (mail-lf1-x130.google.com [IPv6:2a00:1450:4864:20::130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2D69C06174A;
        Wed, 21 Apr 2021 07:25:47 -0700 (PDT)
Received: by mail-lf1-x130.google.com with SMTP id x20so36845126lfu.6;
        Wed, 21 Apr 2021 07:25:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=lbp80Z2/m16q78yp5xUIMHweqZaqCt6hIC8nVbgvRUI=;
        b=l5sPqpJYICsJQGVW0x1RPcyFCm/bo4zkcOyfWXw8t9rOB7jcs8RtfpPWAgXbhByrwZ
         i1yq3SLLH5PnHkBzTPgRdVpdFkzNCKi5jCjs7PF2A4oWcoNojcnZXkfcERBQtsiQ8eiP
         aw4przHk0A4XQLPbqhYIgGu35d7ahd3jqo9R5tRQ6N7uKVl7n+SDfDbA8cgw6sNv9RzC
         bXi2pvcDEBhkS8ExEibnT0Fd9BLwKzQs8h0KPUFAnYAT6TieFyH811UtRL6UQUNnoM1d
         uFOYbowgplrKLsbOlNcAcq1kTSJTJ2Y0ycO7i+7BHp872FG7kf/wScnbCUyoOzIcxteS
         czqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=lbp80Z2/m16q78yp5xUIMHweqZaqCt6hIC8nVbgvRUI=;
        b=Sd8EB3hSF8x2xvzJcnsJEKfQK9MV/PhPKb0FAul7TqXzLgfgGniXcUU3c6h3m8FV9v
         0cqQI1TqCSokhVZPkACUf2RUZq4Ikg9bMygAeu9Y/gR5bi7vBrdAMZ4zzjPpiCjJ7AKK
         +ob5DMyb1RlhKYqoa+RFFRcKDu/6/E7rE6HezvxOM9GjdRW/dhqymWfxeqZ/N3JAmCO1
         He79zNG9d0SqzCC8L8z0hcnG9RSVVUX9OVqgu6ZFiDMWvGJJMYi3BBt5gpsk2MQGKVgn
         gCpBeVvNl0dv6Vb2vYRHdByq0o5LfmV9C6W1cVZWVdEfkWPq56YvUHabxb+fit4ZixQq
         jnpQ==
X-Gm-Message-State: AOAM530VvsHH7NxAf6cs/IrRDvqzgqyk7aO/JWhRT2h15uU+scnAh0BW
        G9kZfL9DDfXtJP2vhK0yYW8wbwqSrkA=
X-Google-Smtp-Source: ABdhPJxibOjfoGZApiCpR+P+jRW7w2w89HoaUN6PTu6njNc8WfS3bJvmUfmeHQMHZSlZz/3paQ8KWA==
X-Received: by 2002:a05:6512:b26:: with SMTP id w38mr19512765lfu.152.1619015146177;
        Wed, 21 Apr 2021 07:25:46 -0700 (PDT)
Received: from [192.168.1.102] ([31.173.86.146])
        by smtp.gmail.com with ESMTPSA id u6sm229441ljj.82.2021.04.21.07.25.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 21 Apr 2021 07:25:45 -0700 (PDT)
Subject: Re: [PATCH] net: ethernet: ravb: Fix release of refclk
To:     Adam Ford <aford173@gmail.com>, netdev@vger.kernel.org
Cc:     aford@beaconembedded.com, "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        linux-renesas-soc@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20210421140505.30756-1-aford173@gmail.com>
From:   Sergei Shtylyov <sergei.shtylyov@gmail.com>
Message-ID: <3937a792-8985-10c1-b818-af2fbc2241df@gmail.com>
Date:   Wed, 21 Apr 2021 17:25:39 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210421140505.30756-1-aford173@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/21/21 5:05 PM, Adam Ford wrote:

> The call to clk_disable_unprepare() can happen before priv is
> initialized.

   This still doesn't make sense for me...

> This means moving clk_disable_unprepare out of
                                         ^ call
> out_release into a new label.
> 
> Fixes: 8ef7adc6beb2 ("net: ethernet: ravb: Enable optional refclk")
> Signed-off-by: Adam Ford <aford173@gmail.com>

Reviewed-by: Sergei Shtylyov <sergei.shtylyov@gmail.com>


[...]

MBR, Sergei
