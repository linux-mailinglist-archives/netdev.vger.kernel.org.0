Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 81CAC2F2BE9
	for <lists+netdev@lfdr.de>; Tue, 12 Jan 2021 10:55:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392877AbhALJyt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jan 2021 04:54:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730628AbhALJys (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Jan 2021 04:54:48 -0500
Received: from mail-wm1-x332.google.com (mail-wm1-x332.google.com [IPv6:2a00:1450:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB1ECC061786;
        Tue, 12 Jan 2021 01:54:07 -0800 (PST)
Received: by mail-wm1-x332.google.com with SMTP id y23so1487306wmi.1;
        Tue, 12 Jan 2021 01:54:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=4C7koV7P9bGKc+8BN3L92y65XqnLENV7qQnrXi9vunM=;
        b=IPMh9X5BrV1/JjonSuaCs7E9x+6WGO3aAUl8ReIGobx3T/2p8PMuEQyPwietoLfCcq
         L7LKDtMh2FziyR+3kuPAOJlo58Lne9hMVRZa64gMAgD5IevPqRxBw9QsNZbHHeIByGcc
         MD90h7SbWm+29I1ka3vigZpIz6a0OvFhK3C/byqpcjOk6pT8cxuO+aE4Ij4Ue3emWBWi
         dnABj7jE+tJSp7tOKpOhLauRhfhAxolnyWAvD5GEy6+QIKRvthXvpqGw9m4xuqjaQUon
         ts8uPeBCgr+zHVw3ROEiP1R1QNNnvLSo+Qa+pOneP3QGRmeAR69K2lPHs06CNRizr3L+
         gfxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=4C7koV7P9bGKc+8BN3L92y65XqnLENV7qQnrXi9vunM=;
        b=DRW5CEEHNbCNCWl0wkpQG0BnfHr0um9LWiOCOGhOorE7Td6HXhI+XLyTTBA2nRaNd1
         HtIonQf56GZxwVKnq0LcX4vKkGyTs1WmpY8IaQ8yT54LgFcEecl8w1V8+haru/HyY7D+
         CknAs1JIzm9Q0cbms2nZOwsImYd2mvTP35nErCgLN54KPDadal1xo9gvG/R8XRXFBeEZ
         Xxx7Kn5/OtJXt+WqpLg9vomPaJBrdPBluwHNzIOso2buTcxh8o8bGdrvmAlU4VM15FC0
         yu2OtYavS90z+KzoGVY4AwyqwkqOvqURjHccZ3UhRZ/V75/R0s/k4jy7zFT1pZBYxv0V
         953w==
X-Gm-Message-State: AOAM530QdPTXeHHMmijI7ursggQNVYY3xeL8sfhcxUUbNqzuFaG+eZsv
        QsOgBnh1pq8+Q85HpKBuLks16tXeMiZHkA==
X-Google-Smtp-Source: ABdhPJwF18MLwhoD3WVUiTBmIGtZqMEi6VY8eAKww2tvohbjOuX3m6HHG3M+2ZsIqRLEd+GpZGgtwA==
X-Received: by 2002:a1c:e342:: with SMTP id a63mr2804716wmh.64.1610445246608;
        Tue, 12 Jan 2021 01:54:06 -0800 (PST)
Received: from [192.168.1.122] (cpc159425-cmbg20-2-0-cust403.5-4.cable.virginm.net. [86.7.189.148])
        by smtp.gmail.com with ESMTPSA id s13sm2876036wmj.28.2021.01.12.01.54.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 12 Jan 2021 01:54:05 -0800 (PST)
Subject: Re: [PATCH net-next 0/5] skbuff: introduce skbuff_heads bulking and
 reusing
To:     Alexander Lobakin <alobakin@pm.me>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Eric Dumazet <edumazet@google.com>,
        Edward Cree <ecree@solarflare.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Willem de Bruijn <willemb@google.com>,
        Miaohe Lin <linmiaohe@huawei.com>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Guillaume Nault <gnault@redhat.com>,
        Yadu Kishore <kyk.segfault@gmail.com>,
        Al Viro <viro@zeniv.linux.org.uk>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20210111182655.12159-1-alobakin@pm.me>
From:   Edward Cree <ecree.xilinx@gmail.com>
Message-ID: <d4f4b6ba-fb3b-d873-23b2-4b5ba9cf4db8@gmail.com>
Date:   Tue, 12 Jan 2021 09:54:04 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.0
MIME-Version: 1.0
In-Reply-To: <20210111182655.12159-1-alobakin@pm.me>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Without wishing to weigh in on whether this caching is a good idea...
Wouldn't it be simpler, rather than having two separate "alloc" and "flush"
 caches, to have a single larger cache, such that whenever it becomes full
 we bulk flush the top half, and when it's empty we bulk alloc the bottom
 half?  That should mean fewer branches, fewer instructions etc. than
 having to decide which cache to act upon every time.

-ed
