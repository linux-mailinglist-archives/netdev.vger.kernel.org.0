Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1DA511BB1E8
	for <lists+netdev@lfdr.de>; Tue, 28 Apr 2020 01:14:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726328AbgD0XOS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Apr 2020 19:14:18 -0400
Received: from bert.scottdial.com ([104.237.142.221]:50484 "EHLO
        bert.scottdial.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726257AbgD0XOS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Apr 2020 19:14:18 -0400
Received: from mail.scottdial.com (mail.scottdial.com [10.8.0.6])
        by bert.scottdial.com (Postfix) with ESMTP id CE4C34E0CCE;
        Mon, 27 Apr 2020 19:14:16 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
        by mail.scottdial.com (Postfix) with ESMTP id 76B9A1155600;
        Mon, 27 Apr 2020 19:14:16 -0400 (EDT)
Received: from mail.scottdial.com ([127.0.0.1])
        by localhost (mail.scottdial.com [127.0.0.1]) (amavisd-new, port 10032)
        with ESMTP id jAHW5tW2ladp; Mon, 27 Apr 2020 19:14:15 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
        by mail.scottdial.com (Postfix) with ESMTP id 73F831155601;
        Mon, 27 Apr 2020 19:14:15 -0400 (EDT)
DKIM-Filter: OpenDKIM Filter v2.10.3 mail.scottdial.com 73F831155601
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=scottdial.com;
        s=24B7B964-7506-11E8-A7D6-CF6FBF8C6FCF; t=1588029255;
        bh=2FMXUY1dhExjT/qZ9dWzRE87Meb+ct5NT7MhltitxZw=;
        h=To:From:Message-ID:Date:MIME-Version;
        b=j740Ziwf9HjlxY3u5S6X43NkIf8L//H5ziJlU/slpLjUaJMhfb0hnhyQRmaBiACk5
         VocBmBwI2oyvXKQ5PE8aSO7FNavO2kq3q2kv8lIv3PP/kDoz0XCd987xvZZGx+NyuG
         ylPP5x6C5T8NnMelTMf4x48sjEh0jscIv0UCcpo1IBfliWbpnECd35wUGlV5MGe6d1
         fMEJhOMOQWsO51GK87E4XnrfaI/IezU4NEJg+5F5w++tk1g4a/SaiYHp3I7kFDI90g
         58mucPTr/HubwgqoO+dUUBfB9pLFEx7wihPIy6bsLoEMQE//fLo45CLsPGkMUxXkfK
         G8V1whjNnxw3A==
X-Virus-Scanned: amavisd-new at scottdial.com
Received: from mail.scottdial.com ([127.0.0.1])
        by localhost (mail.scottdial.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id J4QepVvZ6_-6; Mon, 27 Apr 2020 19:14:15 -0400 (EDT)
Received: from [172.17.2.2] (unknown [172.17.2.2])
        by mail.scottdial.com (Postfix) with ESMTPSA id 4A9A81155600;
        Mon, 27 Apr 2020 19:14:15 -0400 (EDT)
Subject: Re: [PATCH net] net: macsec: preserve ingress frame ordering
To:     David Miller <davem@davemloft.net>
Cc:     netdev@vger.kernel.org
References: <20200424225108.956252-1-scott@scottdial.com>
 <20200427.111227.1036449542794050922.davem@davemloft.net>
From:   Scott Dial <scott@scottdial.com>
Message-ID: <e83635ba-9cfb-f1a3-2da5-2cc4523b8248@scottdial.com>
Date:   Mon, 27 Apr 2020 19:14:15 -0400
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200427.111227.1036449542794050922.davem@davemloft.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/27/2020 2:12 PM, David Miller wrote:
> It's a real shame that instead of somehow fixing the most performant
> setup to be actually usable, we are just throwing our hands up in
> the air and simply avoiding to use it.
> 
> I feel _really_ bad for the person trying to figure out why they
> aren't getting the macsec performance they expect, scratching their
> heads for hours trying to figure out why the AES-NI x86 code isn't
> being used, and after days finding a commit like this.

Like most things, there are competing interests. I was the person
scratching my head for hours trying to figure out why my packets were
arriving out of of order causing packet drops and breaking UDP streams.
In the end, the only solution that I could ship without modifying the
kernel was blacklisting aesni_intel and ghash_clmulni_intel.

To be clear, the sync version of gcm(aes) on an AES-NI will still use
AES-NI for the block cipher if the FPU is available (and otherwise falls
back to non-FPU code). Unfortunately, there is not a synchronous version
of gcm(aes) implemented by AES-NI, but that would be a logical extension
of the pattern to provide maximum performance and correctness. With
regards to correctness, you can see that same decision being made in the
mac80211 code for handling the AES-GCMP and BIP-GMAC encryption modes. I
don't know if the crypto maintainers would entertain adding a sync
aes(gcm) implementation to aesni_intel, but it seems like it would be
straightforward to implement.

Otherwise, I entertained a module option (simple and covers my use case)
or even an attribute on the RXSA (a considerably more invasive change).
However, I didn't think this would be that controversial since there are
many places in the kernel that use AEAD algorithms in synchronous mode
for the same reason, and therefore do not get the complete benefits of
AES-NI acceleration.

>> -	tfm = crypto_alloc_aead("gcm(aes)", 0, 0);
>> +	/* Pick a sync gcm(aes) cipher to ensure order is preserved. */
>> +	tfm = crypto_alloc_aead("gcm(aes)", 0, CRYPTO_ALG_ASYNC);
> 
> How does this mask argument passed to crypto_alloc_aead() work?  You
> are specifying async, does this mean you're asking for async or
> non-async?

See crypto_requires_sync(type, mask) in include/crypto/algapi.h for the
logic of evaluating the mask. In short, the mask is what bits are not
allowed to be set, so this masks out any async algorithms.

Thanks for taking the time to evaluate my change!

-- 
Scott Dial
scott@scottdial.com
