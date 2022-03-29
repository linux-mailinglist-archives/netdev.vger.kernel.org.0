Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4653E4EABF1
	for <lists+netdev@lfdr.de>; Tue, 29 Mar 2022 13:07:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235563AbiC2LJ0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Mar 2022 07:09:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235574AbiC2LJY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Mar 2022 07:09:24 -0400
Received: from nbd.name (nbd.name [IPv6:2a01:4f8:221:3d45::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D10426111
        for <netdev@vger.kernel.org>; Tue, 29 Mar 2022 04:07:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
         s=20160729; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:References:
        To:Subject:From:MIME-Version:Date:Message-ID:Sender:Reply-To:Cc:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=8+EqvbVPtbotNhOJ0MCxh7WIRaXyoKSxSE3flw8UaRQ=; b=ef3V8Sxr9LPxFWSCYeeiGbc73J
        QY0H5mi3REW5XO7q+M+lqxENY+9RpaXC03l8nV2GUttX6PNHh4ewOwvPQmIpMFQF1GSkpdOQDlxwT
        gbiN6xnXlV2VCsZhn0QGKMdkmkkzDUfp9U/5YDkI4+qFPgYg37IX2QCkCId2HmIwF+D4=;
Received: from p200300daa70ef200e986bd084db59d32.dip0.t-ipconnect.de ([2003:da:a70e:f200:e986:bd08:4db5:9d32] helo=nf.local)
        by ds12 with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.89)
        (envelope-from <nbd@nbd.name>)
        id 1nZ9hJ-0003Dg-LF; Tue, 29 Mar 2022 13:07:37 +0200
Message-ID: <928253ff-7254-b8bb-20a7-ec12ad82e14d@nbd.name>
Date:   Tue, 29 Mar 2022 13:07:37 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.7.0
From:   Felix Fietkau <nbd@nbd.name>
Subject: Re: [RFC 2/2] net: bridge: add a software fast-path implementation
To:     Nikolay Aleksandrov <razor@blackwall.org>, netdev@vger.kernel.org
References: <20220210142401.4912-1-nbd@nbd.name>
 <20220210142401.4912-2-nbd@nbd.name>
 <bc499a39-64b9-ceb4-f36f-21dd74d6272d@nvidia.com>
 <e8f1e8f5-8417-84a8-61c3-793fa7803ac6@nbd.name>
 <0b4318af-4c12-bd5a-ae32-165c70af65b2@nvidia.com>
 <6d85d6a5-190e-2dfd-88f9-f09899c98ee7@nbd.name>
 <8bd7362f-0a23-e11c-445b-1e61d08bb70a@blackwall.org>
Content-Language: en-US
In-Reply-To: <8bd7362f-0a23-e11c-445b-1e61d08bb70a@blackwall.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 28.03.22 20:20, Nikolay Aleksandrov wrote:
> On 28/03/2022 18:15, Felix Fietkau wrote:
>> 
>> Hi Nik,
>> 
>> I'd like to follow up on our discussion regarding bridge offloading.
>> I managed to come up with a user space + eBPF implementation that replaces this code and shows mostly the same performance gain as my previous kernel space implementation.
>> 
>> At first I tried to use generic XDP, but after getting it working, performance was pretty bad (due to headroom issues) and I was told that this is by design and nobody should use it in production.
>> 
>> Then I reworked the code to use tc classifier instead and it worked much better.
>> 
>> It's not fully ready yet, I need to add some more tests for incompatible features, but I'm getting there...
>> The code is here: https://github.com/nbd168/bridger
>> 
>> There's one thing I haven't been able to figure out yet: What's the proper way to keep bridge fdb entries alive from user space without modifying them in any other way?
>> 
>> - Felix
> 
> Hi Felix,
> That's very nice! Interesting work. One way it's usually done is through periodic NTF_USE (refresh),
> another would be to mark them externally learned and delete them yourself (user-space aging).
> It really depends on the exact semantics you'd like.
I will try NTF_USE, thanks. I really just want to keep the bridge fdb 
entries alive while there is activity on the offloaded flows.

- Felix

