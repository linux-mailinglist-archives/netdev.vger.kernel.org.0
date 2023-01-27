Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6BED767DE70
	for <lists+netdev@lfdr.de>; Fri, 27 Jan 2023 08:22:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232550AbjA0HV7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Jan 2023 02:21:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231276AbjA0HV5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Jan 2023 02:21:57 -0500
Received: from nbd.name (nbd.name [46.4.11.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C93034F346;
        Thu, 26 Jan 2023 23:21:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
        s=20160729; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
        References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=RglOHXJjcRN1FwmB6CXBFDfmWlFEc/Ve0u5WDn4laio=; b=YfkDRKFMP64Em9zpxbSnYzVxM+
        aTUScEtBNv8EoZTQzDzu4auLG5mOZWeL/dabqyf7bEFxxDcwN6f8rJ9cEv3RAe0pjzzweoVP2O1/Q
        NnCy7VfLeWJtTy99t9OmQSG2oRwXS+ywk/X2vOXyGCNlBRitfQGJey5f1GOmZPJHzzow=;
Received: from p200300daa7090b02d88931c5a0ff75a3.dip0.t-ipconnect.de ([2003:da:a709:b02:d889:31c5:a0ff:75a3] helo=nf.local)
        by ds12 with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.94.2)
        (envelope-from <nbd@nbd.name>)
        id 1pLJ3K-002lyo-KZ; Fri, 27 Jan 2023 08:21:38 +0100
Message-ID: <f6a5d04b-cb89-7939-33f0-3cce84c67782@nbd.name>
Date:   Fri, 27 Jan 2023 08:21:38 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.6.1
Subject: Re: [net PATCH] skb: Do mix page pool and page referenced frags in
 GRO
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>,
        Alexander Duyck <alexander.duyck@gmail.com>
Cc:     davem@davemloft.net, edumazet@google.com, hawk@kernel.org,
        ilias.apalodimas@linaro.org, linux-kernel@vger.kernel.org,
        linyunsheng@huawei.com, lorenzo@kernel.org, netdev@vger.kernel.org,
        pabeni@redhat.com
References: <04e27096-9ace-07eb-aa51-1663714a586d@nbd.name>
 <167475990764.1934330.11960904198087757911.stgit@localhost.localdomain>
 <20230126151317.73d67045@kernel.org>
From:   Felix Fietkau <nbd@nbd.name>
In-Reply-To: <20230126151317.73d67045@kernel.org>
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

On 27.01.23 00:13, Jakub Kicinski wrote:
> On Thu, 26 Jan 2023 11:06:59 -0800 Alexander Duyck wrote:
>> From: Alexander Duyck <alexanderduyck@fb.com>
>> 
>> GSO should not merge page pool recycled frames with standard reference
>> counted frames. Traditionally this didn't occur, at least not often.
>> However as we start looking at adding support for wireless adapters there
>> becomes the potential to mix the two due to A-MSDU repartitioning frames in
>> the receive path. There are possibly other places where this may have
>> occurred however I suspect they must be few and far between as we have not
>> seen this issue until now.
>> 
>> Fixes: 53e0961da1c7 ("page_pool: add frag page recycling support in page pool")
>> Reported-by: Felix Fietkau <nbd@nbd.name>
>> Signed-off-by: Alexander Duyck <alexanderduyck@fb.com>
> 
> Exciting investigation!
> Felix, out of curiosity - the impact of loosing GRO on performance is
> not significant enough to care?  We could possibly try to switch to
> using the frag list if we can't merge into frags safely.
Since this only affects combining page_pool and non-page_pool packets, 
the performance loss should be neglegible.

- Felix

