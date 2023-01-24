Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A610E67A00B
	for <lists+netdev@lfdr.de>; Tue, 24 Jan 2023 18:23:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233663AbjAXRXD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Jan 2023 12:23:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229681AbjAXRXC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Jan 2023 12:23:02 -0500
Received: from nbd.name (nbd.name [46.4.11.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 263BD2FCF2;
        Tue, 24 Jan 2023 09:23:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
        s=20160729; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:Subject:From
        :References:Cc:To:MIME-Version:Date:Message-ID:Sender:Reply-To:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=MYj9nCLj90PGC2wxkcR/ViTrY81E8h0VHrdqaID0ilg=; b=DbE783Hozxw6INRZSNBO4FkVll
        Kcbif1n/507Jg75eUs60XwFIbcUAag7NXUeWWYhzY7QghhRhHQOnCmmq6FBo+/sRZFZvX6HPFZTb1
        Dj2FFB8+jGVcoHaNm74sLlFi6jKgkAJ+NhDdK9zl5KSb0eUVXoWWlHQpkJI71j0xEYxo=;
Received: from [2a01:598:b1ac:c6:f0db:950f:e1fc:548d] (helo=nf.local)
        by ds12 with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.94.2)
        (envelope-from <nbd@nbd.name>)
        id 1pKN0Z-0026A3-3K; Tue, 24 Jan 2023 18:22:55 +0100
Message-ID: <19121deb-368f-9786-8700-f1c45d227a4c@nbd.name>
Date:   Tue, 24 Jan 2023 18:22:54 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.6.1
Content-Language: en-US
To:     Ilias Apalodimas <ilias.apalodimas@linaro.org>
Cc:     netdev@vger.kernel.org, Jesper Dangaard Brouer <hawk@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        linux-kernel@vger.kernel.org,
        Alexander Duyck <alexander.duyck@gmail.com>,
        Yunsheng Lin <linyunsheng@huawei.com>
References: <20230124124300.94886-1-nbd@nbd.name>
 <CAC_iWjKAEgUB8Z3WNNVgUK8omXD+nwt_VPSVyFn1i4EQzJadog@mail.gmail.com>
From:   Felix Fietkau <nbd@nbd.name>
Subject: Re: [PATCH] net: page_pool: fix refcounting issues with fragmented
 allocation
In-Reply-To: <CAC_iWjKAEgUB8Z3WNNVgUK8omXD+nwt_VPSVyFn1i4EQzJadog@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 24.01.23 15:11, Ilias Apalodimas wrote:
> Hi Felix,
> 
> ++cc Alexander and Yunsheng.
> 
> Thanks for the report
> 
> On Tue, 24 Jan 2023 at 14:43, Felix Fietkau <nbd@nbd.name> wrote:
>>
>> While testing fragmented page_pool allocation in the mt76 driver, I was able
>> to reliably trigger page refcount underflow issues, which did not occur with
>> full-page page_pool allocation.
>> It appears to me, that handling refcounting in two separate counters
>> (page->pp_frag_count and page refcount) is racy when page refcount gets
>> incremented by code dealing with skb fragments directly, and
>> page_pool_return_skb_page is called multiple times for the same fragment.
>>
>> Dropping page->pp_frag_count and relying entirely on the page refcount makes
>> these underflow issues and crashes go away.
>>
> 
> This has been discussed here [1].  TL;DR changing this to page
> refcount might blow up in other colorful ways.  Can we look closer and
> figure out why the underflow happens?
I don't see how the approch taken in my patch would blow up. From what I 
can tell, it should be fairly close to how refcount is handled in 
page_frag_alloc. The main improvement it adds is to prevent it from 
blowing up if pool-allocated fragments get shared across multiple skbs 
with corresponding get_page and page_pool_return_skb_page calls.

- Felix

