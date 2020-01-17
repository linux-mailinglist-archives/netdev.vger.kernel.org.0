Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 26C42140F09
	for <lists+netdev@lfdr.de>; Fri, 17 Jan 2020 17:35:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727115AbgAQQfO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jan 2020 11:35:14 -0500
Received: from mail-pj1-f65.google.com ([209.85.216.65]:39533 "EHLO
        mail-pj1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726506AbgAQQfL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Jan 2020 11:35:11 -0500
Received: by mail-pj1-f65.google.com with SMTP id e11so3549058pjt.4;
        Fri, 17 Jan 2020 08:35:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=mNwIwagSDRdEcritBAJ+cZ+CoMsUw6XeDByiOPsSvGU=;
        b=c+aoFo0Y+lvtMfvc642gD4QUGha+92uABLZ5MCoEb6aSbIukexfZ+qBQf0fOPRMetG
         QCvruneRdqQGzLemJ1VBcipcA0GE6Mr2HIIE0kND8DVoHsvfyg2LPR292i+zJsuHO5tR
         QKH/BgQklyDCGmEO2aaMB0s4Pyn6NBSNawGc3qyju9uuI8aeF4z0oqNsO7jdw8QpItol
         agtuchvFck9k+uOdKj2mQIC63HNvpSAGNX/RYsK5vF1Un4sKgEQ96G9DjdQzrb/mEXJk
         acXrq9ecc6qfa7o217OrXNzsHJN5pjIn7JEWiXNi3ePuuH4FBP2bs46N3CAY7bRbkl2b
         vfaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=mNwIwagSDRdEcritBAJ+cZ+CoMsUw6XeDByiOPsSvGU=;
        b=AG4k43d9UXOcrFCwwTSRZ6FtkoFyLvkfzzFgHZQaHmpw3xHtwwaICuIcxzjmemwcJK
         7KbGDghW18gLSDuF466barsaTOh4kmJwKfjWvfI4YpvzmIjCTBHmTte45hGWV7LOXdsN
         EGFNFGqQ2OfK9dvF0iCENzu2chBgAS/nkOd1Lm0wwNbKRGPTFjPUeBP5YtlR3YuxstVU
         VohC4jredhLFGfGXlD0UtybJij8xsTdVep0CnUUwWsU0N/E9KBxKJIfejQvofak9/1Kj
         bvhZgMXsEuWTL7GmGjRGpLrxdUUn38u88lbLBJ5udtgxkuvb2crxQGyumVvpbcg4B3qD
         dK2A==
X-Gm-Message-State: APjAAAVD/mtns8d4pWzdmgq7tv6+m5bomzzloz7kHkINHVDQCvjneaYV
        Z2brGhnDHl67ODAMMd/j3R0=
X-Google-Smtp-Source: APXvYqxr2K5JnU80mtYaxoPvReZWPg1BWc2oFawzf55arIJWDZxMg6cD+XMPWE04o2pEsnPrBWWJFQ==
X-Received: by 2002:a17:902:a617:: with SMTP id u23mr11034698plq.20.1579278910619;
        Fri, 17 Jan 2020 08:35:10 -0800 (PST)
Received: from [192.168.86.235] (c-73-241-150-58.hsd1.ca.comcast.net. [73.241.150.58])
        by smtp.gmail.com with ESMTPSA id v143sm30494035pfc.71.2020.01.17.08.35.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 17 Jan 2020 08:35:09 -0800 (PST)
Subject: Re: [PATCH] net: optimize cmpxchg in ip_idents_reserve
To:     Peter Zijlstra <peterz@infradead.org>,
        Shaokun Zhang <zhangshaokun@hisilicon.com>
Cc:     Eric Dumazet <eric.dumazet@gmail.com>,
        David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, jinyuqi@huawei.com,
        kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org, edumazet@google.com,
        guoyang2@huawei.com, Will Deacon <will@kernel.org>
References: <1579058620-26684-1-git-send-email-zhangshaokun@hisilicon.com>
 <20200116.042722.153124126288244814.davem@davemloft.net>
 <930faaff-4d18-452d-2e44-ef05b65dc858@gmail.com>
 <1b3aaddf-22f5-1846-90f1-42e68583c1e4@gmail.com>
 <430496fc-9f26-8cb4-91d8-505fda9af230@hisilicon.com>
 <20200117123253.GC14879@hirez.programming.kicks-ass.net>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <7e6c6202-24bb-a532-adde-d53dd6fb14c3@gmail.com>
Date:   Fri, 17 Jan 2020 08:35:07 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <20200117123253.GC14879@hirez.programming.kicks-ass.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 1/17/20 4:32 AM, Peter Zijlstra wrote:

> 
> That's crazy, just accept that UBSAN is taking bonghits and ignore it.
> Use atomic_add_return() unconditionally.
> 

Yes, we might simply add a comment so that people do not bug us if
their compiler is too old.

/* If UBSAN reports an error there, please make sure your compiler
 * supports -fno-strict-overflow before reporting it.
 */
return atomic_add_return(segs + delta, p_id) - segs;

