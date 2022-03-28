Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5C0524E9ACC
	for <lists+netdev@lfdr.de>; Mon, 28 Mar 2022 17:15:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235039AbiC1PR0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Mar 2022 11:17:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230330AbiC1PR0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Mar 2022 11:17:26 -0400
Received: from nbd.name (nbd.name [IPv6:2a01:4f8:221:3d45::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2A0C1AF13
        for <netdev@vger.kernel.org>; Mon, 28 Mar 2022 08:15:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
         s=20160729; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:Subject:
        From:References:To:MIME-Version:Date:Message-ID:Sender:Reply-To:Cc:Content-ID
        :Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:
        Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe
        :List-Post:List-Owner:List-Archive;
        bh=AqExq93rXlXw4LuP4dJw/8jliMif9kaaCtXeUlixSjs=; b=fRxhEYuZgtn9iZXa4rmObogMxO
        OSxuzo3H3+mx+70fAUKykgU/GuuvaeKqh8OpT3rN7sF7v5+JejmjaOWaTmTgm4VM00+PjyqY0kg3B
        4GHF8z1fjGL+L8N8xdLh0BD1WZ7oPAnrNrBNvTalSyPkSAVozbX+a1o/xOHs5HN2MYdc=;
Received: from p200300daa70ef200457252b09d12924e.dip0.t-ipconnect.de ([2003:da:a70e:f200:4572:52b0:9d12:924e] helo=nf.local)
        by ds12 with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.89)
        (envelope-from <nbd@nbd.name>)
        id 1nYr5q-0006mk-MC; Mon, 28 Mar 2022 17:15:42 +0200
Message-ID: <6d85d6a5-190e-2dfd-88f9-f09899c98ee7@nbd.name>
Date:   Mon, 28 Mar 2022 17:15:42 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.7.0
Content-Language: en-US
To:     Nikolay Aleksandrov <nikolay@nvidia.com>, netdev@vger.kernel.org
References: <20220210142401.4912-1-nbd@nbd.name>
 <20220210142401.4912-2-nbd@nbd.name>
 <bc499a39-64b9-ceb4-f36f-21dd74d6272d@nvidia.com>
 <e8f1e8f5-8417-84a8-61c3-793fa7803ac6@nbd.name>
 <0b4318af-4c12-bd5a-ae32-165c70af65b2@nvidia.com>
From:   Felix Fietkau <nbd@nbd.name>
Subject: Re: [RFC 2/2] net: bridge: add a software fast-path implementation
In-Reply-To: <0b4318af-4c12-bd5a-ae32-165c70af65b2@nvidia.com>
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


Hi Nik,

I'd like to follow up on our discussion regarding bridge offloading.
I managed to come up with a user space + eBPF implementation that 
replaces this code and shows mostly the same performance gain as my 
previous kernel space implementation.

At first I tried to use generic XDP, but after getting it working, 
performance was pretty bad (due to headroom issues) and I was told that 
this is by design and nobody should use it in production.

Then I reworked the code to use tc classifier instead and it worked much 
better.

It's not fully ready yet, I need to add some more tests for incompatible 
features, but I'm getting there...
The code is here: https://github.com/nbd168/bridger

There's one thing I haven't been able to figure out yet: What's the 
proper way to keep bridge fdb entries alive from user space without 
modifying them in any other way?

- Felix
