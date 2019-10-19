Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B1118DDB32
	for <lists+netdev@lfdr.de>; Sat, 19 Oct 2019 23:26:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726175AbfJSV0A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 19 Oct 2019 17:26:00 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:46752 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726136AbfJSV0A (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 19 Oct 2019 17:26:00 -0400
Received: by mail-pg1-f194.google.com with SMTP id e15so5285881pgu.13;
        Sat, 19 Oct 2019 14:26:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=LuC1R6V8c/Kdme5A156FRd/JC432a1mSGvBSl/q3ZUU=;
        b=ZnOrNkETUnKKV2W50EUrhkGSYwpwQNjMDU3i/s1Yt+3ugs4jYR9+Ebc4N+fes7DyCY
         hwGaBTmdFew8YbeTNiwU9G9hoCyBC4Y8s0wmJQPrNpvH0/7iGvwMk1I/nPbLBBsO6VJR
         zKL/d4eLt1F5QwLgEBjKVHsFYaord9+kJL/spIIfDR7F1B6lqLaE1wOzL/QFx9I5vAhi
         KcenwImPB93iCyK6tQkA/6+7pX/8u+jFiN640F4z2snMr8zATrB8TzY/+a50S4Inl2nr
         iTD4AzY45cw7TuJiRSNzetfcD3VOfuB+lTFvRQ9o0jseO6Bd2R5gF8NjhsvyvJWgtJx0
         5Ffg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=LuC1R6V8c/Kdme5A156FRd/JC432a1mSGvBSl/q3ZUU=;
        b=AW1mJeDMnh9eRv9P4RlpUw1d5lORyuz4GrS2FI+BVOQBcYkXmi9TE5bOTMIhaqaTk/
         NbJTInmajydRM9ikueJj1ms/71vmiGEQnWPatbdJnf/tWSxqBj68AoGDHdMo3GgJHHs+
         qCyZiLbjIrFDpR+M5ODxMrqvZduJiKwPgWnpo2OUYDt3VyWDnGOojXG0DpoiROObYXCo
         eT4aCtTvCizPue4QHv2a/x6SBR3xCZoJvzopfOFBZTv9KsVOTmDHczfrOKAv4MnqujOE
         rNo3JBnXXZQtCTg0AEX3IUa+kFpMLPb1JjDU2ztNIzNFbSWGXk25gpzBgJz9CtPDb5H/
         tIeA==
X-Gm-Message-State: APjAAAX8L4AiggtQDacPlNVBod+twUAL+UJFUJuKNDGcOlufiIeKvMdX
        Ls2Q8NS6P/MNVnHfhQzT9UE=
X-Google-Smtp-Source: APXvYqwWjIurUxYv1G3ixEDYP9XzaOXOxmAuaYRQDj248y1tyU9RGVycj8IDeRkcqClyFgYhvZ8gSA==
X-Received: by 2002:a63:560d:: with SMTP id k13mr17083611pgb.437.1571520359768;
        Sat, 19 Oct 2019 14:25:59 -0700 (PDT)
Received: from [192.168.86.235] (c-73-241-150-70.hsd1.ca.comcast.net. [73.241.150.70])
        by smtp.gmail.com with ESMTPSA id w5sm9925023pfn.96.2019.10.19.14.25.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 19 Oct 2019 14:25:58 -0700 (PDT)
Subject: Re: [PATCH] net: fix sk_page_frag() recursion from memory reclaim
To:     Tejun Heo <tj@kernel.org>, Eric Dumazet <eric.dumazet@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        kernel-team@fb.com, linux-kernel@vger.kernel.org,
        Josef Bacik <josef@toxicpanda.com>
References: <20191019170141.GQ18794@devbig004.ftw2.facebook.com>
 <dc6ff540-e7fc-695e-ed71-2bc0a92a0a9b@gmail.com>
 <20191019211856.GR18794@devbig004.ftw2.facebook.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <41874d3e-584c-437c-0110-83e001abf1b9@gmail.com>
Date:   Sat, 19 Oct 2019 14:25:57 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191019211856.GR18794@devbig004.ftw2.facebook.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 10/19/19 2:18 PM, Tejun Heo wrote:

> Whatever works is fine by me.  gfpflags_allow_blocking() is clearer
> than testing __GFP_DIRECT_RECLAIM directly tho.  Maybe a better way is
> introducing a new gfpflags_ helper?

Sounds good to me !

