Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 86BE025A628
	for <lists+netdev@lfdr.de>; Wed,  2 Sep 2020 09:11:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726467AbgIBHKy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Sep 2020 03:10:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726285AbgIBHKx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Sep 2020 03:10:53 -0400
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 196C5C061244
        for <netdev@vger.kernel.org>; Wed,  2 Sep 2020 00:10:52 -0700 (PDT)
Received: by mail-wr1-x441.google.com with SMTP id z1so4037147wrt.3
        for <netdev@vger.kernel.org>; Wed, 02 Sep 2020 00:10:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=FNSYEovvGuUo8gHoJgFvzxdikJW6Apm4lLlwAui/ppc=;
        b=a6TFR+tukUWHXZ5J4k90GxEgS3DMIIQA7Ep24SGM6qnj/YMNHJzbCsrKtrvTX5xMOP
         Cgh2LNS5ltd2bZO0maU92bzG/1KaGHvtrRKNidURF2ZkGEkFVjRMRvsLZ/MxM0LZGzi7
         3uucbi0IhdhfR5ECv4KQQsjQNpd9H+RmUztW8dwpn7nW9J9atz5vFrtFdYWWgE6zcMYZ
         O2m3t0+aH9zsEUjT/OhIGMbrITe2yroyDiweA/TQbHzSa7me+EMyEN4Zwv+umuY0LP2d
         FHcq3IuRVPSDjBW3XceBT+66ezgwEWxxR9fEnZ4H+TrSrq9BYK2Fvh2Oe0lAZazGuli0
         kmLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=FNSYEovvGuUo8gHoJgFvzxdikJW6Apm4lLlwAui/ppc=;
        b=fmmeYZFtYmkI+Iec1SgOFCJ0HeHicLQqWecu0Kzz4z6duJ7Ft34r2Cp7WHGVSlSJwU
         09knEjmtJNrM6mWy+ya8hlRmBqdWIZDazl/b3tKDMhBkatUs1qQkrtw6qLhtanZ35VCX
         kHluPM7yjKj/l4O5wru/B8BG6AKzGI4m8jHrU73ND0sgjhTYYsm0mJZQPQrd2kaKmEEw
         BqM/MzqOCQTjph9lf7I6X9T11HZ+0X7x8AR4bFkKzY4aWLYo4vOIY7Mbgp8FaJbZS5dx
         eR9Q8pWagDuDiVUw729CBpjLa6rNWV+dq07sC+3Jkky5BFO0JUOq4XWx4ISyWZjrsAQq
         Detg==
X-Gm-Message-State: AOAM531fkpBKlnucbFqRnxZZuCCrI5R64ajdGCcoePdbW77vvYckbD73
        RBz6+Nad65IZnMBUsNq6O04=
X-Google-Smtp-Source: ABdhPJzOUjW2iZga9JQpCx9yGVLW1/nYlp4MEsrdfJl3e9s+ADmsOvV57pAgKqQ743bw/Q60yUT03A==
X-Received: by 2002:adf:e6cf:: with SMTP id y15mr5649717wrm.346.1599030651580;
        Wed, 02 Sep 2020 00:10:51 -0700 (PDT)
Received: from [192.168.8.147] ([37.170.201.185])
        by smtp.gmail.com with ESMTPSA id f14sm5872830wrv.72.2020.09.02.00.10.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 02 Sep 2020 00:10:50 -0700 (PDT)
Subject: Re: [net] tipc: fix using smp_processor_id() in preemptible
To:     Tuong Tong Lien <tuong.t.lien@dektech.com.au>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "jmaloy@redhat.com" <jmaloy@redhat.com>,
        "maloy@donjonn.com" <maloy@donjonn.com>,
        "ying.xue@windriver.com" <ying.xue@windriver.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Cc:     "tipc-discussion@lists.sourceforge.net" 
        <tipc-discussion@lists.sourceforge.net>
References: <20200829193755.9429-1-tuong.t.lien@dektech.com.au>
 <f81eafce-e1d1-bb18-cb70-cfdf45bb2ed0@gmail.com>
 <AM8PR05MB733222C45D3F0CC19E909BB0E2510@AM8PR05MB7332.eurprd05.prod.outlook.com>
 <0ed21ba7-2b3b-9d4f-563e-10d329ebeecb@gmail.com>
 <AM8PR05MB7332E91A67120D78823353F6E2510@AM8PR05MB7332.eurprd05.prod.outlook.com>
 <3f858962-4e38-0b72-4341-1304ec03cd7a@gmail.com>
 <AM8PR05MB7332BE4B6E0381D2894E057AE22E0@AM8PR05MB7332.eurprd05.prod.outlook.com>
 <338d5df9-fe4e-7acf-1480-99984dfeab34@gmail.com>
 <AM8PR05MB7332020CE2FB9E0B416D70BAE22E0@AM8PR05MB7332.eurprd05.prod.outlook.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <2b31e772-3229-3c67-1faf-9ae88849ce77@gmail.com>
Date:   Wed, 2 Sep 2020 09:10:49 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <AM8PR05MB7332020CE2FB9E0B416D70BAE22E0@AM8PR05MB7332.eurprd05.prod.outlook.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 9/1/20 10:52 AM, Tuong Tong Lien wrote:

> Ok, I've got your concern now. Actually when writing this code, I had the same thought as you, but decided to relax it because of the following reasons:
> 1. I don't want to use any locking methods here that can lead to competition (thus affect overall performance...);
> 2. The list is not an usual list but a fixed "ring" of persistent elements (no one will insert/remove any element after it is created);
> 3. It does _not_ matter at all if the function calls will result in the same element, or one call points to the 1st element while another at the same time points to the 3rd one, etc. as long as it returns an element in the list. Also, the per-cpu pointer is _not_ required to exactly point to the next element, but needs to be moved on this or next time..., so just relaxing!
> 4. Isn't a "write" to the per-cpu variable atomic?
> 

I think I will give up, this code is clearly racy, and will consider TIPC as broken.

Your patch only silenced syzbot report, but the bug is still there.


