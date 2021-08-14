Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B409D3EC39E
	for <lists+netdev@lfdr.de>; Sat, 14 Aug 2021 17:40:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238786AbhHNPkw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 Aug 2021 11:40:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238181AbhHNPkv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 14 Aug 2021 11:40:51 -0400
Received: from mail-lf1-x12f.google.com (mail-lf1-x12f.google.com [IPv6:2a00:1450:4864:20::12f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15783C061764;
        Sat, 14 Aug 2021 08:40:22 -0700 (PDT)
Received: by mail-lf1-x12f.google.com with SMTP id g30so25807116lfv.4;
        Sat, 14 Aug 2021 08:40:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=b5x9onDowLY9kdCBmhBl6gMMO/oHJDfzGWOx2H9cis4=;
        b=R3EhuP7N68CSRz0zTENaIikPo63JNJgLBmXfZZL9giwyZvvdZfjwGqHXTZdgVaeytb
         y8NWKNQIOyIaxIYOxCEVFsUgjd7zxDgrkD0dF5rfdhrI/WZbdlLjWnIylmMr13cmlUZe
         KKOD3rdQKeBx4WKOPs3d5AuZyxzIHxKifqBqYSYHie5EnkyYOOLa4xTUoW+4A4soWqBK
         shQsxlrAT7blllexRuJRkJWsU79BGi3jpBUmviQHhhUHtjwMn9Sn8Fe8hsGgLKd/SFo2
         RHmKTXU7HwW2b6xbwKoPI/qykX1ujULOI2IUQx3JtzrX6uL8+Td2uRmugsFL+4S9FV6p
         z2zw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=b5x9onDowLY9kdCBmhBl6gMMO/oHJDfzGWOx2H9cis4=;
        b=bbrle2sEMpaS29rWDFlQf96wkMKPAeNBg3HDvTkPvb/ZozOpOPwy8tYMUjPENk4QMf
         gxsp7K/nv42M2FQyzW4xFHzFOd/OtYXUpNCO4WhLhybgEz8kLEW5ffQG4S5kRmA/rT7+
         rbqhTS0TIxBaPaDusPEVtO0963CKVUjTMs+8FhzKmaL33NBnmaGwHhJA5Y/4PoZV34T5
         Y/CIvJtofyJ0vlbeEcSWTwUjKB8Y8iQq142mMbNdckc/yVieN7/b1NxtNQ2bjPBHM/3d
         eHT7bnSjo8+uzJ9lQiEwmE8tY5WYJ/iN6HRd6bfXiUkjzuOFAmBosh2+2+066zBmUKBC
         qa5A==
X-Gm-Message-State: AOAM531mDKp0ZB1ZU+bvA0RsQJxa+vw/9Ib41NKqox211802fMNLR0aF
        hQQzpg3Lg1xLOjWcCXN0gDg=
X-Google-Smtp-Source: ABdhPJx8SZ3EIhejwDVMAgXeCM9HbGcos6mDpbERHk3d9AkTQLepxWfGkIH2rrTPvzjMk8YBtbJ8ew==
X-Received: by 2002:a05:6512:3f5:: with SMTP id n21mr414544lfq.359.1628955620432;
        Sat, 14 Aug 2021 08:40:20 -0700 (PDT)
Received: from localhost.localdomain ([185.215.60.122])
        by smtp.gmail.com with ESMTPSA id f25sm516922ljj.69.2021.08.14.08.40.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 14 Aug 2021 08:40:20 -0700 (PDT)
Subject: Re: [PATCH v3] net: asix: fix uninit value bugs
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     davem@davemloft.net, kuba@kernel.org, linux@rempel-privat.de,
        robert.foss@collabora.com, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        syzbot+a631ec9e717fb0423053@syzkaller.appspotmail.com
References: <20210813155226.651c74f0@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20210814135505.11920-1-paskripkin@gmail.com> <YRfjFr9GbcoJrycc@lunn.ch>
From:   Pavel Skripkin <paskripkin@gmail.com>
Message-ID: <74ef4391-50e4-beb1-830b-d88cca785290@gmail.com>
Date:   Sat, 14 Aug 2021 18:40:19 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <YRfjFr9GbcoJrycc@lunn.ch>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/14/21 6:36 PM, Andrew Lunn wrote:
> On Sat, Aug 14, 2021 at 04:55:05PM +0300, Pavel Skripkin wrote:
>> Syzbot reported uninit-value in asix_mdio_read(). The problem was in
>> missing error handling. asix_read_cmd() should initialize passed stack
>> variable smsr, but it can fail in some cases. Then while condidition
>> checks possibly uninit smsr variable.
>> 
>> Since smsr is uninitialized stack variable, driver can misbehave,
>> because smsr will be random in case of asix_read_cmd() failure.
>> Fix it by adding error handling and just continue the loop instead of
>> checking uninit value.
>> 
>> Also, same loop was used in 3 other functions. Fixed uninit value bug
>> in them too.
> 
> Hi Pavel
> 
> Which suggests it might make sense to refactor the code to make a
> helper? I will leave you to decide if you want to do that.

It makes sense. Will add a helper function in v4. Thank you for 
suggestion and review!

> 
> The code does looks correct now.
> 



With regards,
Pavel Skripkin
