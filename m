Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF12A2FCAA3
	for <lists+netdev@lfdr.de>; Wed, 20 Jan 2021 06:34:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730708AbhATFOT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Jan 2021 00:14:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730641AbhATFHy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Jan 2021 00:07:54 -0500
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1947EC061575;
        Tue, 19 Jan 2021 21:07:14 -0800 (PST)
Received: by mail-pf1-x434.google.com with SMTP id m6so13769161pfm.6;
        Tue, 19 Jan 2021 21:07:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=ercs8Knsu+kUChYUSoxzGtpfGm98Ng2NObAizp65bH4=;
        b=jmgI0S6iY1CZoTGly8i7UIAvakqzAKUy5+AgIOozwqmMi4cZEwy3rLayb8N4oeYKop
         DqWkmYVirsThB2yzEbLzIGnCTNjmTC4gVJLeNL4B+Ltfb5ky/ognQ+v8sp3fxnRBpYQE
         WVG11g4yBlnvrVI7k37sgCdGqj0wFnBOhp10g9hx5TZHO3mBvUOtzHr1AufJ7DbcczIa
         eDZRAgOQpJWBtnt6ZBqdJhj31pM9HVkqedz9ZH5K4QMgaU1OrQ5L42mAOPjyZ1KeifE6
         NAj4owx6pJ++jmM74vDLS5A0JAO2RBbjioCHw1DAQlMihAw7lpHrheNtpTtbuhjwGuN/
         Rv0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ercs8Knsu+kUChYUSoxzGtpfGm98Ng2NObAizp65bH4=;
        b=IImjikMT1EYzeY68liq7QedrybXXx6UzMiYGQdfFhbjkFm6z5ldVtQk8B7/aRhNGAQ
         0BNknIQR05rPRSytoXs+h8QFxN+voCpEToqZAAO9A+9tldDkGfkSuOR9bc/ovJHschNX
         /Qub8ahJ0R5RAXSRw9zNeJMwBMWGNXKxEME59A98ZFW0hJt2UGt7NxFSW20Wt8Ynv6nf
         GPBZ6RaL0LzBC+CtbCxiZcDbbFXvRdeuJRMA7y19K41GKFmgxQ7zLwOFNvU+v4j5NkDn
         3bcnCuCPip4GBnuLXRuuAXRfz8H20yHUv9lUgVFA7YvCHFKXsHlOBpZI8WMJ3NUaU7EF
         8rSg==
X-Gm-Message-State: AOAM531h4tXNklbGXtuFWkHLH17DhhKvw4g78KbxzEN2ykv+g7fynLiU
        5ckT3r1yCb5zkLx0Ifa1Rr0cS70brYM=
X-Google-Smtp-Source: ABdhPJzIVor/dkzn0g4nVs9XzPe+AbBpeyzaEui1EjY+MZzE8/Eh0p+HHivGHOeYd2hQGMLXkMrD4Q==
X-Received: by 2002:a65:628a:: with SMTP id f10mr7583505pgv.380.1611119233231;
        Tue, 19 Jan 2021 21:07:13 -0800 (PST)
Received: from [10.230.29.29] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id z12sm715549pfn.186.2021.01.19.21.07.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 19 Jan 2021 21:07:12 -0800 (PST)
Subject: Re: [PATCH] net: systemport: free dev before on error path
To:     Pan Bian <bianpan2016@163.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     bcm-kernel-feedback-list@broadcom.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20210120044423.1704-1-bianpan2016@163.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <c291aebe-4cb4-9fe7-0635-5b518d92c311@gmail.com>
Date:   Tue, 19 Jan 2021 21:07:10 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <20210120044423.1704-1-bianpan2016@163.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 1/19/2021 8:44 PM, Pan Bian wrote:
> On the error path, it should goto the error handling label to free
> allocated memory rather than directly return.
> 
> Fixes: 6328a126896e ("net: systemport: Manage Wake-on-LAN clock")
> Signed-off-by: Pan Bian <bianpan2016@163.com>

The change is correct, but not the Fixes tag, it should be:

Fixes: 31bc72d97656 ("net: systemport: fetch and use clock resources")

Acked-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
