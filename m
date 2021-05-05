Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9212E374919
	for <lists+netdev@lfdr.de>; Wed,  5 May 2021 22:09:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233847AbhEEUKX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 May 2021 16:10:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230227AbhEEUKW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 May 2021 16:10:22 -0400
Received: from mail-lj1-x232.google.com (mail-lj1-x232.google.com [IPv6:2a00:1450:4864:20::232])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A51C1C061574;
        Wed,  5 May 2021 13:09:23 -0700 (PDT)
Received: by mail-lj1-x232.google.com with SMTP id y9so4113613ljn.6;
        Wed, 05 May 2021 13:09:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=9IT8URu6dSEQHMxh7iWmAyPGFUYt95msbdrmiPzmDi8=;
        b=VsfBFztF5Of9/DaVD3kcrva/FUamygmxdW16Z9ul0/ON6z19KprBG+EOLWOPwVYJuv
         Sw00aql9v3A8yETBYlZEO13nE1OINXfvlU3Zve64qb8wN7ulkETIgd+RP5kZEZ/mx0TK
         A23/OM5uaEaf7B9wbgBh4yoMkBLfiDEvMvrk21WjlxJO1kzqQC8Vdk5gZSp5gV2wxKAk
         iT7H/Kc5IjlGoZiPRrr3mg7WpU3RnngzQF1TcFbPrAtysVhvNUQUnVy1F1gNEOIA8U+s
         5CgBKhCjapEwzwDRLNYDffvsmIftMQFbk6Iza6D6cdkduuyVJP5dvgtD00kSjT89v7nk
         qAUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=9IT8URu6dSEQHMxh7iWmAyPGFUYt95msbdrmiPzmDi8=;
        b=Pd4XSN7CMMeS+D/zyd82GcmHLYNPUMBLchFtLiw//h8uNJ2c8s288nFSBIDrjvelri
         j7SWlLIGZIHcUI3og8NGCzc2sLI+9jHqaEV75TJyhoNjc8YBulwQWpzQeaoLn0rxUeL2
         VtIYJ4Vqima7HgOMB1GiNvX+clD/a9deW1OVNNqgHhSRhgrMuiQ9t1E/Mz0Pq+P5VXKj
         0WDFIf79xhd/XzFR9QtZ6VGAjTU6sBksgIOIkqUpaFPjUFz/fGJCDkApoPBV7T4bTxbD
         UXGFUM7aGd0tbXTUqT7RORckliWMfKIyI7x+xARTAGYe1u5JYj6jA8cInd5IHuBN4QZk
         0HSg==
X-Gm-Message-State: AOAM532qbyyEDMSbj7kX/c1WA+t3cZMkTRBMlF33701ihf/TP3K9L3Mr
        dHXbRMGmcTlBVF+94E0cHC4sH7wTJ30=
X-Google-Smtp-Source: ABdhPJzIGr17ix9wP/TFo74owdc5s0zlGSNQqAYc7x2mgIupWTHYpVw8R1GpmC02IgTfklKE+ADjRQ==
X-Received: by 2002:a2e:9e4b:: with SMTP id g11mr412827ljk.1.1620245361984;
        Wed, 05 May 2021 13:09:21 -0700 (PDT)
Received: from [192.168.1.102] ([31.173.85.20])
        by smtp.gmail.com with ESMTPSA id n10sm94006lfu.216.2021.05.05.13.09.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 05 May 2021 13:09:21 -0700 (PDT)
Subject: Re: [PATCH] net: renesas: ravb: Fix a stuck issue when a lot of
 frames are received
From:   Sergei Shtylyov <sergei.shtylyov@gmail.com>
To:     David Miller <davem@davemloft.net>
Cc:     patchwork-bot+netdevbpf@kernel.org,
        yoshihiro.shimoda.uh@renesas.com, kuba@kernel.org,
        netdev@vger.kernel.org, linux-renesas-soc@vger.kernel.org
References: <20210421045246.215779-1-yoshihiro.shimoda.uh@renesas.com>
 <161902800958.24373.15370499378110944137.git-patchwork-notify@kernel.org>
 <d5dd135b-241f-6116-466d-8505b7e7d697@gmail.com>
 <20210421.112020.2130812672604395386.davem@davemloft.net>
 <c9afe6d8-12e8-32af-4fb0-527f6fd51703@gmail.com>
Message-ID: <9a019c8a-fdb1-ab1b-dd74-c503d01eb325@gmail.com>
Date:   Wed, 5 May 2021 23:09:12 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <c9afe6d8-12e8-32af-4fb0-527f6fd51703@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/5/21 10:00 PM, Sergei Shtylyov wrote:

>    Sorry for the late reply -- the patch got into my spam folder, and I haven't seen it

   Not the patch, your reply got into spam. :-)

> until this evening. Blame GMail for that.

[...]

>> Thanks.
> 
> MBR, Sergei
