Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D62E2141063
	for <lists+netdev@lfdr.de>; Fri, 17 Jan 2020 19:03:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728779AbgAQSDa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jan 2020 13:03:30 -0500
Received: from mail-qk1-f195.google.com ([209.85.222.195]:40338 "EHLO
        mail-qk1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726603AbgAQSD3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Jan 2020 13:03:29 -0500
Received: by mail-qk1-f195.google.com with SMTP id c17so23517156qkg.7;
        Fri, 17 Jan 2020 10:03:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:date:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=xU4VBanglVPXt7ngdr39qz422X3JP6/qDcudzGbwI4E=;
        b=Ltw0xlbbDd3T6Yq0dSVi4aqLfuk0vFTBHazMFWMSYU8yiqLSSuA0lDb/1xen40XcH0
         cqOv83k0WRiJqxXhwTJPNZJkmtgbduF1fYpW6H/8PtCLXjM+7SJ3caItDskt8EN0ZIN6
         o5/tHmOftvWd7Cg+FIC69Yv6fjIhe8VcLA3qiRgRqODaq2oSW5Ef5wqb3iMP52WeZLqI
         iAzHGocaNXnRyhho0iERF5Clxmxr418Q/nESOJft0SqV4aShORm8SZj1/l5JkfOVHZZc
         mw1FYoYKH6FBNiq3vB/Nbizzo2k3wbWBjv0DGXIp1yICX6k9/A7nUW4UxvrzcNh0cR5p
         ilUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:date:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=xU4VBanglVPXt7ngdr39qz422X3JP6/qDcudzGbwI4E=;
        b=An6DJfFAcPoL/RlurF2u8FrMJ9u8xCSg6w8V4ggqRxLICijPI1KtZ0Y0eCQUV5Wbf0
         hvAeBG2iJ2uor1+n9UpXuYV41VapI9zoe+3j+RB2wvEthDOa7KTT9xfQqrUx+3RJQ8T/
         58dStQDUB32OnooZhBrB83oYxNBYwNtYt2ydfjv1Y0PmyIcwpQK0REpAGKU12b1LEGga
         m/8uXQQgyiSt8DEAbh2J9UI6Asy1F6Tx9IsRqDuMNhDSFKqDgXCJ1G+/LyGc21BRT90F
         Os93JIjETf+dARxcmCzCce/VNwvETC1n9zHBXMVMXcV9Ha6ba/FP9DJqxCH0LceVe9M0
         awqA==
X-Gm-Message-State: APjAAAU4EVp4pYMygrIKfBd22a0hqk5czRuADFtFYc9unk6iPcvXMEM2
        O9aoePs82Cyp30eKKBsDnBM=
X-Google-Smtp-Source: APXvYqyCPiG09VXkOIjOy2jkrRHpRdY7DZQqsAECIdmiP32K/o24L2Khmyz3qUwMqv7EC7M+coGglw==
X-Received: by 2002:a37:664d:: with SMTP id a74mr39032122qkc.4.1579284208522;
        Fri, 17 Jan 2020 10:03:28 -0800 (PST)
Received: from rani.riverdale.lan ([2001:470:1f07:5f3::b55f])
        by smtp.gmail.com with ESMTPSA id q35sm13523418qta.19.2020.01.17.10.03.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Jan 2020 10:03:28 -0800 (PST)
From:   Arvind Sankar <nivedita@alum.mit.edu>
X-Google-Original-From: Arvind Sankar <arvind@rani.riverdale.lan>
Date:   Fri, 17 Jan 2020 13:03:26 -0500
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Shaokun Zhang <zhangshaokun@hisilicon.com>,
        David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, jinyuqi@huawei.com,
        kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org, edumazet@google.com,
        guoyang2@huawei.com, Will Deacon <will@kernel.org>
Subject: Re: [PATCH] net: optimize cmpxchg in ip_idents_reserve
Message-ID: <20200117180324.GA2623847@rani.riverdale.lan>
References: <1579058620-26684-1-git-send-email-zhangshaokun@hisilicon.com>
 <20200116.042722.153124126288244814.davem@davemloft.net>
 <930faaff-4d18-452d-2e44-ef05b65dc858@gmail.com>
 <1b3aaddf-22f5-1846-90f1-42e68583c1e4@gmail.com>
 <430496fc-9f26-8cb4-91d8-505fda9af230@hisilicon.com>
 <20200117123253.GC14879@hirez.programming.kicks-ass.net>
 <7e6c6202-24bb-a532-adde-d53dd6fb14c3@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <7e6c6202-24bb-a532-adde-d53dd6fb14c3@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 17, 2020 at 08:35:07AM -0800, Eric Dumazet wrote:
> 
> 
> On 1/17/20 4:32 AM, Peter Zijlstra wrote:
> 
> > 
> > That's crazy, just accept that UBSAN is taking bonghits and ignore it.
> > Use atomic_add_return() unconditionally.
> > 
> 
> Yes, we might simply add a comment so that people do not bug us if
> their compiler is too old.
> 
> /* If UBSAN reports an error there, please make sure your compiler
>  * supports -fno-strict-overflow before reporting it.
>  */
> return atomic_add_return(segs + delta, p_id) - segs;
> 

Do we need that comment any more? The flag was apparently introduced in
gcc-4.2 and we only support 4.6+ anyway?
