Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC9143EC3C5
	for <lists+netdev@lfdr.de>; Sat, 14 Aug 2021 18:20:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234953AbhHNQVA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 Aug 2021 12:21:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229818AbhHNQUy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 14 Aug 2021 12:20:54 -0400
Received: from mail-lj1-x22e.google.com (mail-lj1-x22e.google.com [IPv6:2a00:1450:4864:20::22e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3A1CC061764;
        Sat, 14 Aug 2021 09:20:24 -0700 (PDT)
Received: by mail-lj1-x22e.google.com with SMTP id m18so20487101ljo.1;
        Sat, 14 Aug 2021 09:20:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=bl7r4qrb6xUTi4mDeMdsRG1lrv7yu9bngpbCfg8eQBA=;
        b=vSqg0338evwSRFKeOprp+ufGTxcJvScmp8uXTYHopZ/i9ibmtMembxoQQmti1RoDBt
         nDfmOuFbu3h0cz67yZbgD8yYGT+NMlr0C1IKhqxw0XzVeZZrX83kpzM2nk8K/tsJhSGm
         mRKokRmx+payI7xvi6o1pfeKCgMxRRgBaaUz6OIG0NwVZhl020VjB5ZcQKkB+ONJS/Hq
         8AbdLT2GW38CZhXdKnyhCk/Pe/zm0G/BY9OETlcbHRvNq5a76YhT51gF73yd2jKKPi92
         s3q3p5l/LhHI3DB5Wp9BPaUcjZB4ykBcxLScJmDP+DepH+6224m8vrG/kDpif82Zwkus
         mbvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=bl7r4qrb6xUTi4mDeMdsRG1lrv7yu9bngpbCfg8eQBA=;
        b=tiv5/Gj5boFmUD6UBdTLtwNwKJtECKdVOanzqw51AGmA1UAXB2kb6rrWoAFs2qFJfK
         dKCXB2lOs7rDmbGC15ACcVKStwiL/R4XOzgRXrgJblAHZBGTrBJzothPb5/ZBXapi3Li
         3UAqls0qrmP5HARAk7nVCVcx25p16R5PGYFJk6jxrfteeV7Fhag8mPVK7FIO/ABDVkJB
         iJGK3s0qO9M1vwnAehg50lvKoCa/ipXb04CKxQ6Z9c6WZvr9fo7r5M5Is7tU7FYaPQYG
         ttFHP0/6LRuuoyP+eCYPUHeo0vnj7mDZ6ttpmYqxSokPp2i4n8mNzhqntr3398IhyVnM
         MCdw==
X-Gm-Message-State: AOAM530CrUqEoUs0Ckzfd8P7bg/pF9NogqKhreGK1+EWA/p1sscYk7VF
        5G1drAhFoM6jrt41dJ0oVi8=
X-Google-Smtp-Source: ABdhPJwm0tquAnmFtYRlGkc3Lm6OjqWAu+hSXjijwVeKH03zh//qsNXqixJua657zMubYPfKTXNedA==
X-Received: by 2002:a2e:9355:: with SMTP id m21mr5849920ljh.445.1628958023203;
        Sat, 14 Aug 2021 09:20:23 -0700 (PDT)
Received: from localhost.localdomain ([185.215.60.122])
        by smtp.gmail.com with ESMTPSA id f30sm449604lfj.219.2021.08.14.09.20.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 14 Aug 2021 09:20:22 -0700 (PDT)
Subject: Re: [PATCH v3] net: asix: fix uninit value bugs
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     davem@davemloft.net, kuba@kernel.org, linux@rempel-privat.de,
        robert.foss@collabora.com, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        syzbot+a631ec9e717fb0423053@syzkaller.appspotmail.com
References: <20210813155226.651c74f0@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20210814135505.11920-1-paskripkin@gmail.com> <YRfjFr9GbcoJrycc@lunn.ch>
From:   Pavel Skripkin <paskripkin@gmail.com>
Message-ID: <5bf26e79-b612-9590-0970-09a03e0ac0ea@gmail.com>
Date:   Sat, 14 Aug 2021 19:20:21 +0300
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
> 
> The code does looks correct now.
> 
> 	Andrew
> 

I noticed strange thing. For example: driver looped 30 times, there 
wasn't any errors with usb transfer, but Host_En bit is not set. 
Datasheet says, that if Host_En is not set, that means software access 
will be ignored. Driver code doesn't handle this situation. We only 
check if ret is -ENODEV or -ETIMEOUT.

I guess, next register access will fail, but anyway, does it make sense 
to return when Host_En bit is not set?


With regards,
Pavel Skripkin
