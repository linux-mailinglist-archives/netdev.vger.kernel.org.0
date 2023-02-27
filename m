Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1BE8E6A489A
	for <lists+netdev@lfdr.de>; Mon, 27 Feb 2023 18:52:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229932AbjB0RwW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Feb 2023 12:52:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229542AbjB0RwU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Feb 2023 12:52:20 -0500
Received: from mail.marcansoft.com (marcansoft.com [212.63.210.85])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33B7E23121;
        Mon, 27 Feb 2023 09:52:18 -0800 (PST)
Received: from [127.0.0.1] (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: marcan@marcan.st)
        by mail.marcansoft.com (Postfix) with ESMTPSA id 991C741A42;
        Mon, 27 Feb 2023 17:52:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=marcan.st; s=default;
        t=1677520336; bh=TyiSSdv8IGxdjz2utLKhWhCBuUwQHg47VZsc94zgZcw=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To;
        b=lFwzbz1lMl2mgUL8NMvLooNx9YligRkut+5/Iq991BfswLpk+aSlCgQpBFpw8Gvji
         H8bPnmw1MtNyS3y7CaA7I36J7x+aq8MzP3fWYUtHoWtj62wHZHtmiMOeaj76Vlti9x
         NfOO3VVKzhSDC7dzz8s9EI6vM1a8nspxntvC9LH0lidWpGCp6IUAozrvy3TLH1bC+f
         yXhP7uC0uRNbduoZwmYWCAkP3siUwz3sKcKysv5Uxjfb9xpgtxCoU0FNgpxERHxv1K
         m21qp+J3UiZxkteZvpdZxsY65jiwwDOQz7lBWRfxsyb66FdcUFiD8UCJChpHEGM7dN
         a+R8t5Ub+C7QA==
Message-ID: <181af6e9-799d-b730-dc14-ee2de2541f35@marcan.st>
Date:   Tue, 28 Feb 2023 02:52:08 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Subject: Re: [PATCH] brcmfmac: cfg80211: Use WSEC to set SAE password
Content-Language: en-US
To:     Arend van Spriel <arend.vanspriel@broadcom.com>,
        Arend van Spriel <aspriel@gmail.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Double Lo <double.lo@infineon.com>
Cc:     Sven Peter <sven@svenpeter.dev>,
        Alyssa Rosenzweig <alyssa@rosenzweig.io>,
        Linus Walleij <linus.walleij@linaro.org>,
        asahi@lists.linux.dev, linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        SHA-cyfmac-dev-list@infineon.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20230214093319.21077-1-marcan@marcan.st>
 <edcabef3-f440-9c15-e69f-845eb6a4de1b@broadcom.com>
 <65548ce6-d2d8-c913-a494-5ac044af2e35@marcan.st>
 <b4489e24-e226-4f99-1322-cab6c1269f09@broadcom.com>
From:   Hector Martin <marcan@marcan.st>
In-Reply-To: <b4489e24-e226-4f99-1322-cab6c1269f09@broadcom.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 14/02/2023 19.38, Arend van Spriel wrote:
> 
> 
> On 2/14/2023 11:30 AM, Hector Martin wrote:
>> On 14/02/2023 19.07, Arend van Spriel wrote:
>>> + Double Lo
>>>
>>> On 2/14/2023 10:33 AM, Hector Martin wrote:
>>>> Using the WSEC command instead of sae_password seems to be the supported
>>>> mechanism on newer firmware, and also how the brcmdhd driver does it.
>>>
>>> The SAE code in brcmfmac was added by Cypress/Infineon. For my BCA
>>> devices that did not work, but this change should be verified on Cypress
>>> hardware.
>>
>> Do you mean the existing SAE code does not work on BCA, or this version
>> doesn't?
> 
> I meant the existing SAE code. I will give your patches a spin on the 
> devices I have.
> 
>> I assume/hope this version works for WCC in general, since that is what
>> the Apple-relevant chips are tagged as. If so it sounds like we need a
>> firmware type conditional on this, if CYW needs the existing behavior.
> 
> Right. Let's hope we get some feedback from them.

Any news on this? Nothing from the Cypress guys (nor to any of my
previous emails about other stuff, for that matter), so if you can
confirm this works on your chips I'd rather just blindly add the CYW/not
firmware variant check and call it a day.

We can't wait forever for them to show up. If they expect their chips to
continue work with mainline they need to actually interact on the MLs,
otherwise they should expect us to possibly accidentally break things
even if we try not to. As far as I can tell they seem completely
disinterested in talking about anything, and we can't let that block
progress for everyone else.

- Hector
