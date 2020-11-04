Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 68AF92A64A9
	for <lists+netdev@lfdr.de>; Wed,  4 Nov 2020 13:51:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729484AbgKDMve (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Nov 2020 07:51:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728922AbgKDMve (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Nov 2020 07:51:34 -0500
Received: from mail-wr1-x443.google.com (mail-wr1-x443.google.com [IPv6:2a00:1450:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9108BC0613D3;
        Wed,  4 Nov 2020 04:51:33 -0800 (PST)
Received: by mail-wr1-x443.google.com with SMTP id k10so20595877wrw.13;
        Wed, 04 Nov 2020 04:51:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=pLlGk+cZ5H+bPN4ICXizwdh/rPzTm72DYXYeQwOXCr0=;
        b=Tk7tVGSahYOHlMXSNvEBkehn7INsUSuXVmTxbRu96ErkVy5nIkklFOpdHV8jo1+tXS
         kDb8fdQqrhfXeXPgkSbBiHSAJrMMd6cdjk4kBzXWg361UcfiTMW0KHUWAzsjK3kcSc2P
         jqOhsSbafcy5rZ4v5FJOQs6/F/k4guUtiBWbQWrehexn8pBd4lcidjOKbVRi2cd/SuTQ
         fNyO+8TkixUa/czAyI4GikrMfOpN8JuAH9Au+ys8w2HZQSW3uypjPxzQ0VyQuielg6VX
         alg+kydyXHFYrMpma1rsmkP/TAoCcugwydAOCEElr7mjDy49c5gzu8Xu2iUVtbnBYhL1
         t+xA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=pLlGk+cZ5H+bPN4ICXizwdh/rPzTm72DYXYeQwOXCr0=;
        b=LFZyy0gbD51ccp0bBo/dIUk9yhzgswpiEwcBGie2uwtOlJy6A1wswE2zeX8SesXVl4
         n79o4gOwAr0HgwjNGr9RZcytSWloKkRcum1jGP9dtLB4aav3I6Q+bXo44naSJ4zoy8ZW
         wLVeQIyd4A76rTKQPOIO8EpY/WqggLBe+nEJsTtNp6NHwuCyHjayl/ZoDRUB3fKblv6A
         7TrT45iCYtz1/4h78UNNuutog89MiTgBkGlTbL65GVnJrCtzmM8s9tq7XNquuPyKfb3/
         ZI5DB9GqJ/B57JuXd7rWV3PO1ip11515gzPnG9KFgSGEpiqsHrt0HQ9xPA7WaqJP+JmO
         cI6g==
X-Gm-Message-State: AOAM53219GnNLvThBc3cSd374Xh4ILW0kobXSlwQA0ttPX31ElzUIn1l
        d/EqQFYYl6DA5tfgfyf2VBU=
X-Google-Smtp-Source: ABdhPJzOQ0NRbvYHtqTnDIRsY8tJqtdseDoZpKi1RFjwxdMac8x7eWhLibNCb4s785rNtv6INKWLCQ==
X-Received: by 2002:a5d:5083:: with SMTP id a3mr31111254wrt.93.1604494292254;
        Wed, 04 Nov 2020 04:51:32 -0800 (PST)
Received: from [192.168.8.114] ([37.172.5.208])
        by smtp.gmail.com with ESMTPSA id c18sm2330160wrt.10.2020.11.04.04.51.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 04 Nov 2020 04:51:31 -0800 (PST)
Subject: Re: [PATCH 1/1] mm: avoid re-using pfmemalloc page in
 page_frag_alloc()
To:     Matthew Wilcox <willy@infradead.org>,
        Eric Dumazet <eric.dumazet@gmail.com>
Cc:     Rama Nichanamatlu <rama.nichanamatlu@oracle.com>,
        Dongli Zhang <dongli.zhang@oracle.com>, linux-mm@kvack.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, davem@davemloft.net, kuba@kernel.org,
        aruna.ramakrishna@oracle.com, bert.barbe@oracle.com,
        venkat.x.venkatsubra@oracle.com, manjunath.b.patil@oracle.com,
        joe.jin@oracle.com, srinivas.eeda@oracle.com
References: <20201103193239.1807-1-dongli.zhang@oracle.com>
 <20201103203500.GG27442@casper.infradead.org>
 <7141038d-af06-70b2-9f50-bf9fdf252e22@oracle.com>
 <20201103211541.GH27442@casper.infradead.org>
 <20201104011640.GE2445@rnichana-ThinkPad-T480>
 <2bce996a-0a62-9d14-4310-a4c5cb1ddeae@gmail.com>
 <20201104123659.GA17076@casper.infradead.org>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <053d1d51-430a-2fa9-fb72-fee5d2f9785c@gmail.com>
Date:   Wed, 4 Nov 2020 13:51:29 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.3.1
MIME-Version: 1.0
In-Reply-To: <20201104123659.GA17076@casper.infradead.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 11/4/20 1:36 PM, Matthew Wilcox wrote:
> On Wed, Nov 04, 2020 at 09:50:30AM +0100, Eric Dumazet wrote:
>> On 11/4/20 2:16 AM, Rama Nichanamatlu wrote:
>>>> Thanks for providing the numbers.  Do you think that dropping (up to)
>>>> 7 packets is acceptable?
>>>
>>> net.ipv4.tcp_syn_retries = 6
>>>
>>> tcp clients wouldn't even get that far leading to connect establish issues.
>>
>> This does not really matter. If host was under memory pressure,
>> dropping a few packets is really not an issue.
>>
>> Please do not add expensive checks in fast path, just to "not drop a packet"
>> even if the world is collapsing.
> 
> Right, that was my first patch -- to only recheck if we're about to
> reuse the page.  Do you think that's acceptable, or is that still too
> close to the fast path?

I think it is totally acceptable.

The same strategy is used in NIC drivers, before recycling a page.

If page_is_pfmemalloc() returns true, they simply release the 'problematic'page
and attempt a new allocation.

( git grep -n page_is_pfmemalloc -- drivers/net/ethernet/ )


> 
>> Also consider that NIC typically have thousands of pre-allocated page/frags
>> for their RX ring buffers, they might all have pfmemalloc set, so we are speaking
>> of thousands of packet drops before the RX-ring can be refilled with normal (non pfmemalloc) page/frags.
>>
>> If we want to solve this issue more generically, we would have to try
>> to copy data into a non pfmemalloc frag instead of dropping skb that
>> had frags allocated minutes ago under memory pressure.
> 
> I don't think we need to copy anything.  We need to figure out if the
> system is still under memory pressure, and if not, we can clear the
> pfmemalloc bit on the frag, as in my second patch.  The 'least change'
> way of doing that is to try to allocate a page, but the VM could export
> a symbol that says "we're not under memory pressure any more".
> 
> Did you want to move checking that into the networking layer, or do you
> want to keep it in the pagefrag allocator?

I think your proposal is fine, thanks !

