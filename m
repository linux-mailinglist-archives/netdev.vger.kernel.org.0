Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DF9696748EC
	for <lists+netdev@lfdr.de>; Fri, 20 Jan 2023 02:37:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230020AbjATBhe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Jan 2023 20:37:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230021AbjATBhd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Jan 2023 20:37:33 -0500
Received: from novek.ru (unknown [213.148.174.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9338CA296B
        for <netdev@vger.kernel.org>; Thu, 19 Jan 2023 17:37:31 -0800 (PST)
Received: from [192.168.0.18] (unknown [37.228.234.209])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by novek.ru (Postfix) with ESMTPSA id 25A8650063B;
        Fri, 20 Jan 2023 04:32:12 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 novek.ru 25A8650063B
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=novek.ru; s=mail;
        t=1674178334; bh=aVa+1sLz8XT5Lq5FVCHsTzUXVEZa0DZXmC6nRAWRAyE=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=zsGN7WPWc9fabb3JBXR9mNwzcf47LZPID6hwkHYlJH/uoSlzxuU+RMVmdZtyv1pR7
         6toRW4IjsPCKzsISbVtb2CF7+lgVUO6W1qGAE+3D1fLkWlUCJLc2HS8IHVHGv4TcRc
         pRnnczSvtSkP2awiRpYrP6ob4u1Sb9O4uTkDxg1s=
Message-ID: <45c5fe42-29a8-5322-636b-e30da0f2ee18@novek.ru>
Date:   Fri, 20 Jan 2023 01:37:25 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH net-next 0/5] tls: implement key updates for TLS1.3
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>,
        Sabrina Dubroca <sd@queasysnail.net>
Cc:     netdev@vger.kernel.org, Frantisek Krenzelok <fkrenzel@redhat.com>,
        Gal Pressman <gal@nvidia.com>
References: <cover.1673952268.git.sd@queasysnail.net>
 <20230117180351.1cf46cb3@kernel.org> <Y8fEodSWeJZyp+Sh@hog>
 <20230118185522.44c75f73@kernel.org>
From:   Vadim Fedorenko <vfedorenko@novek.ru>
In-Reply-To: <20230118185522.44c75f73@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 19.01.2023 02:55, Jakub Kicinski wrote:
> On Wed, 18 Jan 2023 11:06:25 +0100 Sabrina Dubroca wrote:
>> 2023-01-17, 18:03:51 -0800, Jakub Kicinski wrote:
>>> On Tue, 17 Jan 2023 14:45:26 +0100 Sabrina Dubroca wrote:
>>>> This adds support for receiving KeyUpdate messages (RFC 8446, 4.6.3
>>>> [1]). A sender transmits a KeyUpdate message and then changes its TX
>>>> key. The receiver should react by updating its RX key before
>>>> processing the next message.
>>>>
>>>> This patchset implements key updates by:
>>>>   1. pausing decryption when a KeyUpdate message is received, to avoid
>>>>      attempting to use the old key to decrypt a record encrypted with
>>>>      the new key
>>>>   2. returning -EKEYEXPIRED to syscalls that cannot receive the
>>>>      KeyUpdate message, until the rekey has been performed by userspace
>>>
>>> Why? We return to user space after hitting a cmsg, don't we?
>>> If the user space wants to keep reading with the old key - 🤷️
>>
>> But they won't be able to read anything. Either we don't pause
>> decryption, and the socket is just broken when we look at the next
>> record, or we pause, and there's nothing to read until the rekey is
>> done. I think that -EKEYEXPIRED is better than breaking the socket
>> just because a read snuck in between getting the cmsg and setting the
>> new key.
> 
> IDK, we don't interpret any other content types/cmsgs, and for well
> behaved user space there should be no problem (right?).
> I'm weakly against, if nobody agrees with me you can keep as is.
> 
>>>>   3. passing the KeyUpdate message to userspace as a control message
>>>>   4. allowing updates of the crypto_info via the TLS_TX/TLS_RX
>>>>      setsockopts
>>>>
>>>> This API has been tested with gnutls to make sure that it allows
>>>> userspace libraries to implement key updates [2]. Thanks to Frantisek
>>>> Krenzelok <fkrenzel@redhat.com> for providing the implementation in
>>>> gnutls and testing the kernel patches.
>>>
>>> Please explain why - the kernel TLS is not faster than user space,
>>> the point of it is primarily to enable offload. And you don't add
>>> offload support here.
>>
>> Well, TLS1.3 support was added 4 years ago, and yet the offload still
>> doesn't support 1.3 at all.
> 
> I'm pretty sure some devices support it. None of the vendors could
> be bothered to plumb in the kernel support, yet, tho.
> I don't know of anyone supporting rekeying.
> 
>> IIRC support for KeyUpdates is mandatory in TLS1.3, so currently the
>> kernel can't claim to support 1.3, independent of offloading.
> 
> The problem is that we will not be able to rekey offloaded connections.
> For Tx it's a non-trivial problem given the current architecture.
> The offload is supposed to be transparent, we can't fail the rekey just
> because the TLS gotten offloaded.

But we really don't have any HW offload implementation for TLSv1.3. But it would 
be great to have SW implementation better align to RFC.

>> Some folks did tests with and without kTLS using nbdcopy and found a
>> small but noticeable performance improvement (around 8-10%).

