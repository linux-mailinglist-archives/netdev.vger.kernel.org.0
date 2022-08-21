Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8345459B6D8
	for <lists+netdev@lfdr.de>; Mon, 22 Aug 2022 01:51:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231781AbiHUXve (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 21 Aug 2022 19:51:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231328AbiHUXvd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 21 Aug 2022 19:51:33 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29A9B1A078;
        Sun, 21 Aug 2022 16:51:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BF22B60D57;
        Sun, 21 Aug 2022 23:51:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 343C0C433D7;
        Sun, 21 Aug 2022 23:51:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661125892;
        bh=7QedBrBPobCgVlHtVTuuI4zsOXIu5+PiUEdMbLfNPOc=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=eTSOzacj8JuOB43GURSzL3FpXTIFbunEanZOBHfwFRNpRkLgXwBTJhM3KvkvGGcjc
         CeYVZ5SDxtkupE6Q8xmCIywtmBcrWvtEkRvutYUcsYG+YvjmoAMWxyPeL+rIJq7znh
         uS5ExRxJ5pq4mkSubUxHrLEcwyoOmKGH+Y8Qyb2qwtmTadfqo2itCc4NhW5cZKbG11
         Qj0SfigqsReI2YvAt6FVR+OQdW4g+v/Tppl+ZWjAv95MQyo+t/mNL8CwEBAI2PzknL
         z+MnuSi4Tg/aY4vHUPsyPQSevdoDxPPk2Xpme8/0eZXozl7yF/btOrAZ9yImFtt82z
         zRAjhYrN3haOw==
Message-ID: <a83e24c9-ab25-6ca0-8b81-268f92791ae5@kernel.org>
Date:   Sun, 21 Aug 2022 17:51:28 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.12.0
Subject: Re: [PATCH 00/31] net/tcp: Add TCP-AO support
Content-Language: en-US
To:     Leonard Crestez <cdleonard@gmail.com>,
        Dmitry Safonov <dima@arista.com>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Andy Lutomirski <luto@amacapital.net>,
        Ard Biesheuvel <ardb@kernel.org>,
        Bob Gilligan <gilligan@arista.com>,
        Dmitry Safonov <0x7f454c46@gmail.com>,
        Eric Biggers <ebiggers@kernel.org>,
        Francesco Ruggeri <fruggeri@arista.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Ivan Delalande <colona@arista.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Salam Noureddine <noureddine@arista.com>,
        Shuah Khan <shuah@kernel.org>, netdev@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20220818170005.747015-1-dima@arista.com>
 <fc05893d-7733-1426-3b12-7ba60ef2698f@gmail.com>
From:   David Ahern <dsahern@kernel.org>
In-Reply-To: <fc05893d-7733-1426-3b12-7ba60ef2698f@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/21/22 2:34 PM, Leonard Crestez wrote:
> On 8/18/22 19:59, Dmitry Safonov wrote:
>> This patchset implements the TCP-AO option as described in RFC5925. There
>> is a request from industry to move away from TCP-MD5SIG and it seems
>> the time
>> is right to have a TCP-AO upstreamed. This TCP option is meant to replace
>> the TCP MD5 option and address its shortcomings. Specifically, it
>> provides
>> more secure hashing, key rotation and support for long-lived connections
>> (see the summary of TCP-AO advantages over TCP-MD5 in (1.3) of RFC5925).
>> The patch series starts with six patches that are not specific to TCP-AO
>> but implement a general crypto facility that we thought is useful
>> to eliminate code duplication between TCP-MD5SIG and TCP-AO as well as
>> other
>> crypto users. These six patches are being submitted separately in
>> a different patchset [1]. Including them here will show better the gain
>> in code sharing. Next are 18 patches that implement the actual TCP-AO
>> option,
>> followed by patches implementing selftests.
>>
>> The patch set was written as a collaboration of three authors (in
>> alphabetical
>> order): Dmitry Safonov, Francesco Ruggeri and Salam Noureddine.
>> Additional
>> credits should be given to Prasad Koya, who was involved in early
>> prototyping
>> a few years back. There is also a separate submission done by Leonard
>> Crestez
>> whom we thank for his efforts getting an implementation of RFC5925
>> submitted
>> for review upstream [2]. This is an independent implementation that makes
>> different design decisions.
> 
> Is this based on something that Arista has had running for a while now
> or is a recent new development?
> 

...

> Seeing an entirely distinct unrelated implementation is very unexpected.
> What made you do this?
> 

I am curious as well. You are well aware of Leonard's efforts which go
back a long time, why go off and do a separate implementation?

