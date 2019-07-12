Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2646F673F0
	for <lists+netdev@lfdr.de>; Fri, 12 Jul 2019 19:06:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727024AbfGLRGQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Jul 2019 13:06:16 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:40203 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726811AbfGLRGQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Jul 2019 13:06:16 -0400
Received: by mail-pf1-f193.google.com with SMTP id p184so4564059pfp.7
        for <netdev@vger.kernel.org>; Fri, 12 Jul 2019 10:06:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=VGtHY9YyYzbtGzcQ2bYbFxHB4jBh/AFGqSCESEHs+VA=;
        b=TJVHBOyH8t9AM9GPxSW7U/TwIIZ9H+QeJb4EUACtYEkRVfMqL7PBaINuz6j3kZIza6
         JcCiFhe5v0WU5qx5f+1+m4huHIRwDveAmcQRXJc9keRFFyXfdcRGAosIOJwCJl2WVMTM
         MxVIjP67nUMKcc/XGHN5W0xUQOyyExx+bGhIov3UiCBqDeIABSIw2RbYCetz/dtuZknx
         glsJzNtv4d+YREwZDju60GvIhfYbQASzvxI7wyQYhfuaQXaGgeFch+ceMAFdHa2/eQ/o
         EI4YaUel9IXi5vgMf1YLCH2H8eQQ3dzOBDUPXrtTbs2xagQNCyxvImt5exrUDcm2QObt
         EVHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=VGtHY9YyYzbtGzcQ2bYbFxHB4jBh/AFGqSCESEHs+VA=;
        b=YF+c20c5TN+c6VTBq0gxwEgyMw28r4PbDice4wmdMdWYKmuNpVH8SDT9AN9wh2idwz
         GT2NFKfueRfakvm4pDYLU4J7QyozbLpggvuxFrMLYzolSlI/xqX4F9KNx4PtdNvffovl
         R7EdEbIUGH93voeWxMiVxVpSuQPCiiO/5L37GVMrXSM1NpJu4ao4pMIFFvglQIJ4GUu1
         YoEYZaVSfcCLEOKd46rm1KkQIkv77M9nfPv5NiZhMJhVM5Xu5ICUOl9OinQIEwlr9PSv
         kg55FGy+iJaSNlvkxgw7UH6798Nd/qqe12uVnySaatmdkiy5AgHd7d1JClo7CYdLoqnS
         svsg==
X-Gm-Message-State: APjAAAXQyv1DUJDd2P6Ky2UJgORBsvjrR1OGeSVSayEcGQUKL8yJCjNl
        Ay/PiOjvWI8IB1YTKaOop9YYKKpLew8=
X-Google-Smtp-Source: APXvYqytpWUfywzUSzrXE7c1IXUxOgwOA0j5X8G0PBMh3PQ1egiVlUl+Mmf4L7rKwtIEUGhAaQJxBQ==
X-Received: by 2002:a65:44c8:: with SMTP id g8mr11825457pgs.443.1562951175427;
        Fri, 12 Jul 2019 10:06:15 -0700 (PDT)
Received: from [172.20.166.209] ([2620:10d:c090:180::1:76be])
        by smtp.gmail.com with ESMTPSA id s43sm12178708pjb.10.2019.07.12.10.06.14
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 12 Jul 2019 10:06:14 -0700 (PDT)
From:   "Jonathan Lemon" <jonathan.lemon@gmail.com>
To:     "Edward Cree" <ecree@solarflare.com>
Cc:     "Sabrina Dubroca" <sd@queasysnail.net>, netdev@vger.kernel.org,
        "Andreas Steinmetz" <ast@domdv.de>
Subject: Re: [PATCH net] net: fix use-after-free in __netif_receive_skb_core
Date:   Fri, 12 Jul 2019 10:06:13 -0700
X-Mailer: MailMate (1.12.5r5635)
Message-ID: <77B7C763-CB82-43D7-8379-0A758BA216FA@gmail.com>
In-Reply-To: <8166b82f-8430-1441-32e7-540c1829754e@solarflare.com>
References: <e909b8fe24b9eac71de52c4f80f7f3f6e5770199.1562766613.git.sd@queasysnail.net>
 <62ad16f6-c33a-407e-2f55-9be382b7ec52@solarflare.com>
 <20190710224724.GA28254@bistromath.localdomain>
 <8166b82f-8430-1441-32e7-540c1829754e@solarflare.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 12 Jul 2019, at 8:29, Edward Cree wrote:

> On 10/07/2019 23:47, Sabrina Dubroca wrote:
>> 2019-07-10, 16:07:43 +0100, Edward Cree wrote:
>>> On 10/07/2019 14:52, Sabrina Dubroca wrote:
>>>> -static int __netif_receive_skb_core(struct sk_buff *skb, bool 
>>>> pfmemalloc,
>>>> +static int __netif_receive_skb_core(struct sk_buff **pskb, bool 
>>>> pfmemalloc,
>>>>  				    struct packet_type **ppt_prev)
>>>>  {
>>>>  	struct packet_type *ptype, *pt_prev;
>>>>  	rx_handler_func_t *rx_handler;
>>>> +	struct sk_buff *skb = *pskb;
>>> Would it not be simpler just to change all users of skb to *pskb?
>>> Then you avoid having to keep doing "*pskb = skb;" whenever skb 
>>> changes
>>>  (with concomitant risk of bugs if one gets missed).
>> Yes, that would be less risky. I wrote a version of the patch that 
>> did
>> exactly that, but found it really too ugly (both the patch and the
>> resulting code).
> If you've still got that version (or can dig it out of your reflog), 
> can
>  you post it so we can see just how ugly it turns out?
>
>>  We have more than 50 occurences of skb, including
>> things like:
>>
>>     atomic_long_inc(&skb->dev->rx_dropped);
> Ooh, yes, I can see why that ends up looking funny...
>
> Here's a thought, how about switching round the 
> return-vs-pass-by-pointer
>  and writing:
>
> static struct sk_buff *__netif_receive_skb_core(struct sk_buff *skb, 
> bool pfmemalloc,
>                                                 struct packet_type 
> **ppt_prev, int *ret)
> ?
> (Although, you might want to rename 'ret' in that case.)
>
> Does that make things any less ugly?

That was actually my first thought as well - this seems to fit well with 
the
other APIS which can return a different skb.
-- 
Jonathan

