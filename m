Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D0BB83242E8
	for <lists+netdev@lfdr.de>; Wed, 24 Feb 2021 18:08:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236044AbhBXRGl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Feb 2021 12:06:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236006AbhBXRFz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Feb 2021 12:05:55 -0500
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D06FC06174A
        for <netdev@vger.kernel.org>; Wed, 24 Feb 2021 09:05:14 -0800 (PST)
Received: by mail-pj1-x1029.google.com with SMTP id l18so1738212pji.3
        for <netdev@vger.kernel.org>; Wed, 24 Feb 2021 09:05:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=jXe4eoOUt1Iw+Kyc8T6LgYJD4gfmsOg9wn2gGSl3w/A=;
        b=eQOK0X8jkjVqbrioivA4cUZM2YfBD80jBxhlGmH8JSvNcZg0j/AqJxizEkoI0Db94J
         QqBsDFTKbYADD3sc0TxlzT1qAWGDMtup2x3c9GsoIfTocYsmQ+5xTwj58YrpuLg9o9QK
         DTc8M89smNuwr6Wqv6bPcE1tSMgPao35oxSR/bJczznDk6O8OUrXJETk+Fp0WoR1iOQ/
         VOhaHPTV/uTujA/5x7RoCjPYvp4KTH7XQVX5G1tccaOX9jUxXjPOAXN3pT1tlxBD2jpE
         AXHxeXo/IrCn03L4FIfUApzMgzsBDsPasQcK2oLcQ7lVlgq0GJ02fJ2TEgLBgzuTKTQn
         1/JA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=jXe4eoOUt1Iw+Kyc8T6LgYJD4gfmsOg9wn2gGSl3w/A=;
        b=B5bk8tKJTmoWJftPSEek92NoIBak4WUTl99cBcItGT7LT9hz6/L5227Z/aop7PxeoK
         YMKhs7kKm0gw5kuK2629IIZEHgaW+uaLsX7lyqg56ySqfCU3Po+qcAOlvSySfbeWl47D
         EyO8hvcR6Yc4jXFoNrD4T+/ufGqdJB1iKht4Zn3faEQlgNK/PPzMjl37sXxZfk+/5KXO
         iKivOdGOJ/92dBBGwUT4TL3ewgTJfuEGJuyzr5hXO7B0Tu3FIio+TQoUBDjCDm/5GFOQ
         quTkiXt3sEWVBbH1yo01t6+IvDC10AQC9+rw6tEioIRPhOhDmj38SjqHiMKmHwbl2MdT
         arLQ==
X-Gm-Message-State: AOAM533KaTiNyJptVb6bllFTY2Hqm2e6iV/UI7EfUiPQ8o5f4NHWV29Q
        ejOpde8PwKbZj7grzs40tiA=
X-Google-Smtp-Source: ABdhPJz3QDwz5brGzV3dHN4/FRpeRpNk5dv46JsxqDpJPhqTfBDFSIy8+TISsvEH8VGtUQ7o2OOmoA==
X-Received: by 2002:a17:90a:1f86:: with SMTP id x6mr5297955pja.135.1614186313997;
        Wed, 24 Feb 2021 09:05:13 -0800 (PST)
Received: from [10.230.29.30] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id y20sm3343414pfo.210.2021.02.24.09.05.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 24 Feb 2021 09:05:13 -0800 (PST)
Subject: Re: [PATCH net] net: broadcom: bcm4908_enet: fix RX path possible mem
 leak
To:     =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, bcm-kernel-feedback-list@broadcom.com,
        =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <rafal@milecki.pl>
References: <20210224151842.2419-1-zajec5@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <1bc6b65e-fa63-8dee-426e-c4cdbaab697c@gmail.com>
Date:   Wed, 24 Feb 2021 09:05:10 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <20210224151842.2419-1-zajec5@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2/24/2021 7:18 AM, Rafał Miłecki wrote:
> From: Rafał Miłecki <rafal@milecki.pl>
> 
> After filling RX ring slot with new skb it's required to free old skb.
> Immediately on error or later in the net subsystem.
> 
> Signed-off-by: Rafał Miłecki <rafal@milecki.pl>

Acked-by: Florian Fainelli <f.fainelli@gmail.com>
Fixes: 4feffeadbcb2 ("net: broadcom: bcm4908enet: add BCM4908 controller
driver")
-- 
Florian
