Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 665B544E635
	for <lists+netdev@lfdr.de>; Fri, 12 Nov 2021 13:17:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234800AbhKLMUf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Nov 2021 07:20:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231147AbhKLMUe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Nov 2021 07:20:34 -0500
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34A90C061766
        for <netdev@vger.kernel.org>; Fri, 12 Nov 2021 04:17:44 -0800 (PST)
Received: by mail-pj1-x102b.google.com with SMTP id o6-20020a17090a0a0600b001a64b9a11aeso7424868pjo.3
        for <netdev@vger.kernel.org>; Fri, 12 Nov 2021 04:17:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=R8Wf0VQUaiy90EirTAD5Upj4b+og1WFU1VbLImU0Zak=;
        b=CB9Bg7k9g01rHWfwFnoBazrtaYRz/jqwEOwXmw33VegeGlJH+xVUym9q7hvAaTYmnk
         s4GxkPQiR9BljK9GTRrLK7jOnhMCKiD1oO5bIBuJJZuaJmXgvIDzxE1ja0F4+WsJ3nHf
         D2uyjyeF7t1SukE9VgTBSgNXOMi/zFDMSRu7lpTgeRRPrAEaO4I+/pjiAi8ofhmVqiXg
         kiC+1+FKkLLFYlFY3aGIHXqACjsaJqPkj7ZsmktJH1y7bdbIF1jc58RuaTal+OSwh9ds
         Kf74Rh1Sv98ZfLS2klnRmwIDatZ9ZQT/eQJNqXFb1EAy8+r5x5w0fZmTRelGS/NYZfcJ
         qFAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=R8Wf0VQUaiy90EirTAD5Upj4b+og1WFU1VbLImU0Zak=;
        b=FCvqEICBDavErAxJ1McV3asJqNPayD4cBA4ugHJT5mxo4KG2YHfvFu8mtstmYLTLp7
         WprYbKKxTlz9A/eaYxxft6mRx5GoxPqCAq+M59zql/F2fxJSMpoCFQNQMGjj1g30/3y2
         tjFlLd8eZesQ3xdlNi2shZ1bFATZw/IuxznKS4idTcZDrIa+1+4nTtnFSBxwtNxcr5Ux
         BviWTL3y7D8oKjA/IJwnibIrjvwK3Dmp8K5reiZ3MZB/USauxccNH8LpEx2t9iilZMAD
         n7DWGWV6ms6eZnk9CxJ8wNhQWDX+QGv+M5L2AGgZyPxn1zjK5CaOTcu7LvoXEzpAM7gY
         bgsA==
X-Gm-Message-State: AOAM53377/RAP+aCoTGe8RwpBC8IPFC2cnuPzT1OtU5fsZyLLb/W5wwG
        NZWeX5Vzuc6MNtW6Viky4b3M+Hc0naI=
X-Google-Smtp-Source: ABdhPJzllech+yrzeKG8oGRXU5pcClkkkBZ0YZ41utr9+fL9fLV0j3vef6Rkq9jCdhTzpuLtVMzuzQ==
X-Received: by 2002:a17:902:a509:b0:143:7eb6:c953 with SMTP id s9-20020a170902a50900b001437eb6c953mr7339128plq.4.1636719463240;
        Fri, 12 Nov 2021 04:17:43 -0800 (PST)
Received: from [192.168.0.4] ([49.173.165.50])
        by smtp.gmail.com with ESMTPSA id 32sm4791018pgn.31.2021.11.12.04.17.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 12 Nov 2021 04:17:42 -0800 (PST)
Subject: Re: [PATCH net] amt: use cancel_delayed_work() instead of
 flush_delayed_work() in amt_fini()
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org
References: <20211108145340.17208-1-ap420073@gmail.com>
 <20211111073748.136d2e85@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Taehee Yoo <ap420073@gmail.com>
Message-ID: <3282b92a-926e-a39f-b1f6-dc90e29dba06@gmail.com>
Date:   Fri, 12 Nov 2021 21:17:39 +0900
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20211111073748.136d2e85@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jakub,
Thank you for your review!

On 11/12/21 12:37 AM, Jakub Kicinski wrote:
 > On Mon,  8 Nov 2021 14:53:40 +0000 Taehee Yoo wrote:
 >> When the amt module is being removed, it calls flush_delayed_work() 
to exit
 >> source_gc_wq. But it wouldn't be exited properly because the
 >> amt_source_gc_work(), which is the callback function of source_gc_wq
 >> internally calls mod_delayed_work() again.
 >> So, amt_source_gc_work() would be called after the amt module is 
removed.
 >> Therefore kernel panic would occur.
 >> In order to avoid it, cancel_delayed_work() should be used instead of
 >> flush_delayed_work().
 >
 > Somehow I convinced myself this is correct but now I'm not sure, again.
 >
 >> diff --git a/drivers/net/amt.c b/drivers/net/amt.c
 >> index c384b2694f9e..47a04c330885 100644
 >> --- a/drivers/net/amt.c
 >> +++ b/drivers/net/amt.c
 >> @@ -3286,7 +3286,7 @@ static void __exit amt_fini(void)
 >>   {
 >>   	rtnl_link_unregister(&amt_link_ops);
 >>   	unregister_netdevice_notifier(&amt_notifier_block);
 >> -	flush_delayed_work(&source_gc_wq);
 >> +	cancel_delayed_work(&source_gc_wq);
 >
 > This doesn't guarantee that the work is not running _right_ now and
 > will re-arm itself on the next clock cycle, so to speak.
 >
 >   CPU 0                      CPU 1
 >   -----                      -----
 >
 >   worker gets the work
 >   clears pending
 >   work starts running
 >                              cancel_work
 >                              grabs pending
 >                              clears pending
 >   mod_delayed_work()
 >
 > You need cancel_delayed_work_sync(), right?
 >

you're right!
I think cancel_delayed_work() is async so that it can't clearly fix this 
problem.
So, I will send a new patch after some tests.
Thank you so much for catching it!

Thanks a lot,
Taehee
