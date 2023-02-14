Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 85D51695E5B
	for <lists+netdev@lfdr.de>; Tue, 14 Feb 2023 10:10:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230240AbjBNJKS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Feb 2023 04:10:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231921AbjBNJJg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Feb 2023 04:09:36 -0500
Received: from mail.marcansoft.com (marcansoft.com [212.63.210.85])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 822F223D8D;
        Tue, 14 Feb 2023 01:08:41 -0800 (PST)
Received: from [127.0.0.1] (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits))
        (No client certificate requested)
        (Authenticated sender: marcan@marcan.st)
        by mail.marcansoft.com (Postfix) with ESMTPSA id 6110B41EF0;
        Tue, 14 Feb 2023 09:08:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=marcan.st; s=default;
        t=1676365719; bh=sXctWKw0c/PmrHsXFJH3m9VOhMRLi/XPipzQrk3zinA=;
        h=Date:To:Cc:References:From:Subject:In-Reply-To;
        b=ChtawK16CjuYKY74B5JyBTZ/4YMzEtTD5S6ljWIxbb+74vjPQfVijax6j6VDYV43v
         LMoAYNQjNBBjzC2J+pMHIGB6daF6MMwF9zOh1te1cWpdnU7TcHXb35ZEuECpo5a4TK
         Vag6SiMgO8GZtbsKibs1EhyPceZvjSEOKfCpbewtclfbvFpenEihAXojXY8oI6ZJkp
         Gmwg4mMNjnzDLU0AquSZyD4tb1zxGfrKfV9JNNSwkm/lttB97sj/QPyiGJKUzqTMZ9
         yItGfPRyBdy96AL7vCEizVMvAJebVZr9myZN5iiefCaSi0OWYiIThtcNdJRSJfvmOK
         up1Y8YqwobhJA==
Message-ID: <a9281140-8b9d-41ca-bc2d-3c2d2e78259e@marcan.st>
Date:   Tue, 14 Feb 2023 18:08:32 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Content-Language: en-US
To:     Julian Calaby <julian.calaby@gmail.com>,
        Arend van Spriel <aspriel@gmail.com>
Cc:     Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Sven Peter <sven@svenpeter.dev>,
        Alyssa Rosenzweig <alyssa@rosenzweig.io>,
        Linus Walleij <linus.walleij@linaro.org>,
        asahi@lists.linux.dev, linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        SHA-cyfmac-dev-list@infineon.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20230214080034.3828-1-marcan@marcan.st>
 <20230214080034.3828-3-marcan@marcan.st>
 <CAGRGNgV6YMhBa1bdkf_EQ0Z+nwbfhJkKcTxtc=ukWVMWtvQ2PA@mail.gmail.com>
From:   Hector Martin <marcan@marcan.st>
Subject: Re: [PATCH 2/2] brcmfmac: pcie: Provide a buffer of random bytes to
 the device
In-Reply-To: <CAGRGNgV6YMhBa1bdkf_EQ0Z+nwbfhJkKcTxtc=ukWVMWtvQ2PA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 14/02/2023 18.00, Julian Calaby wrote:
> Hi Arend,
> 
> On Tue, Feb 14, 2023 at 7:04 PM Hector Martin <marcan@marcan.st> wrote:
>>
>> Newer Apple firmwares on chipsets without a hardware RNG require the
>> host to provide a buffer of 256 random bytes to the device on
>> initialization. This buffer is present immediately before NVRAM,
>> suffixed by a footer containing a magic number and the buffer length.
>>
>> This won't affect chips/firmwares that do not use this feature, so do it
>> unconditionally for all Apple platforms (those with an Apple OTP).
> 
> Following on from the conversation a year ago, is there a way to
> detect chipsets that need these random bytes? While I'm sure Apple is
> doing their own special thing for special Apple reasons, it seems
> relatively sensible to omit a RNG on lower-cost chipsets, so would
> other chipsets need it?

I think we could include a list of chips known not to have the RNG (I
think it's only the ones shipped on T2 machines). The main issue is I
don't have access to those machines so it's hard for me to test exactly
which ones need it. IIRC Apple's driver unconditionally provides the
randomness. I could at least test the newer chips on AS platforms and
figure out if they need it to exclude them... but then again, all I can
do is test whether they work without the blob, but they might still want
it (and simply become less secure without it).

So I guess the answer is "maybe, I don't know, and it's kind of hard to
know for sure"... the joys of reverse engineering hardware without
vendor documentation.

If you mean whether other chips with non-apple firmware can use this, I
have no idea. That's probably something for Arend to answer. My gut
feeling is Apple added this as part of a hardening mechanism and
non-Apple firmware does not use it (and Broadcom then probably started
shipping chips with a hardware RNG and firmware that uses it directly
across all vendors), in which case the answer is no.

- Hector
