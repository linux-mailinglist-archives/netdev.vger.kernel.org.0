Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 27A86100953
	for <lists+netdev@lfdr.de>; Mon, 18 Nov 2019 17:40:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726690AbfKRQk3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Nov 2019 11:40:29 -0500
Received: from mail-pf1-f193.google.com ([209.85.210.193]:36464 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726322AbfKRQk3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Nov 2019 11:40:29 -0500
Received: by mail-pf1-f193.google.com with SMTP id b19so10650640pfd.3
        for <netdev@vger.kernel.org>; Mon, 18 Nov 2019 08:40:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=la4pyXW4tapWYkAy7ps5pFS33AnfENEPYV6hMWTWO3Q=;
        b=rOQGgDJjTrFYxV+/PbuuzdnS9LLKcEYo+OskvQGlvjXc/8Oxmqxy9rhJekr9WK++zZ
         ENGTrmFYG23xm3VjqtjydKBd8+2FftslMOXgYl0FJovyXcJDT+GJMX+GjtDXBNZVV9yj
         C2hXlPPshrmJjnPlTsLptir+E4wxZ8Hie//btGAlNJpcSM17dG7wGcwBYdw8TQGQFUa+
         fQVYgpUxQrSHFNv06CL6URzxzo8SGTA9X0Y42dC4No9OBa1y+AZZ75HRmgWDTZ1lDUkg
         6Z5guU+lJsEUyUR9HuvOOI6a6Xd93fmSI+GovnDhasQ8ZRP+tv7TrebfxfK33dHU0dXj
         ac7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=la4pyXW4tapWYkAy7ps5pFS33AnfENEPYV6hMWTWO3Q=;
        b=a+agMyi+HlsBvzCG2HOg+2Y7LBteX/G9dmb+wQAN20PsLIHJ7Hkzs4IkgVC+Wfg8J0
         giwUnb2/dfxTAn4OijAZY4G2g8638gT6UUvraYJpMVzgcWKWfKzU6rW7A09y0Iw+HsVB
         aNP1N3pPpgIgD7lS1IAOPT6S0ic9AOKNgNGDRC5vZ/9jZ5a74ED5Z9VZMb9rrgmlswKG
         gczuPQ3hDgHVDLs/lvxwrky/I1qqx3lX689MvQiL8dz+Q4GmzTxPu8noTsGv0QaBD4Gt
         HbnC/y3F4BQQIGTuLJTJ7qJE4C2vdpYNasIlEhbQV03nicdgfho1GHsUL4MBiCcfvW4S
         juHA==
X-Gm-Message-State: APjAAAXFKtcX6KM7aEcnO63VCNpjJUH3ZAXeN86OpGdDAgKwI+QtPtNH
        C/eelay4q0oAH8f2EaoEkHE=
X-Google-Smtp-Source: APXvYqxASUZOSMk4T0qVNlyc8nTCNJ6iYeFie3/GllNb9PYb2K0VkxQrWr4OgWStjacksrv8t6VlKw==
X-Received: by 2002:a62:1953:: with SMTP id 80mr231692pfz.72.1574095228911;
        Mon, 18 Nov 2019 08:40:28 -0800 (PST)
Received: from dahern-DO-MB.local ([2601:282:800:fd80:bd88:fb6d:6b19:f7d1])
        by smtp.googlemail.com with ESMTPSA id 129sm21024740pfd.174.2019.11.18.08.40.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 18 Nov 2019 08:40:28 -0800 (PST)
Subject: Re: [PATCH net-next v2 2/2] ipv4: use dst hint for ipv4 list receive
To:     Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        Edward Cree <ecree@solarflare.com>
References: <cover.1574071944.git.pabeni@redhat.com>
 <592c763828171c414e8927878b1a22027e33dee7.1574071944.git.pabeni@redhat.com>
 <f81feaf9-8792-a648-431f-be14e17e2ace@gmail.com>
 <3327209c4ac29e9051d1ebf41fb88a5749b46292.camel@redhat.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <4fff8cfe-a8ef-f057-cf41-1437c757c2a7@gmail.com>
Date:   Mon, 18 Nov 2019 09:40:26 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <3327209c4ac29e9051d1ebf41fb88a5749b46292.camel@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/18/19 9:31 AM, Paolo Abeni wrote:
>> Also, for readability it would be better to have 2 helpers in
>> include//net/fib_rules.h that return true false and manage the net
>> namespace issue.
> 
> Double checking I parsed the above correctly. Do you mean something
> like the following - I think net/ip_fib.h fits more, as it already
> deals with CONFIG_IP_MULTIPLE_TABLES?

sure.

And it looks like they already exist in net//ipv4/fib_frontend.c, so
those can be moved to ip_fib.h


