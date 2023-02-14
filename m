Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1B8C56960BE
	for <lists+netdev@lfdr.de>; Tue, 14 Feb 2023 11:30:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232402AbjBNKaV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Feb 2023 05:30:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229647AbjBNKaU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Feb 2023 05:30:20 -0500
Received: from mail.marcansoft.com (marcansoft.com [212.63.210.85])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CDE77233DA;
        Tue, 14 Feb 2023 02:30:18 -0800 (PST)
Received: from [127.0.0.1] (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits))
        (No client certificate requested)
        (Authenticated sender: marcan@marcan.st)
        by mail.marcansoft.com (Postfix) with ESMTPSA id 5BD2C3FA55;
        Tue, 14 Feb 2023 10:30:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=marcan.st; s=default;
        t=1676370617; bh=imb1OrlC2L4fhlGYWYO9ydzZ8X82aRztwsYTQ4mpkvs=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To;
        b=ZykmX5JNjkB3Y2h1/1GRLL+fijsmHvUBD60tmVyCD6yhG7QlsRKgHefVISM7GHE/u
         H5lgKlNbrTgU36J59T1YLh20aa53BBvWozzjTA55LHZMGqAiw/KeI4DSGl1I4Iac8F
         0b9u30zROlSRIIggJjky6bgDkNzGv96+9mdfoW9wjXB14tKQ9efIaL+m3FgzrUHDcA
         gg7dIIIHDhfEy5HuJ+UlMJxsZGcoJw4iOzF0F6Aih6EtYjN6yzfn4nKVcs5Amr9Vp9
         k2/qdJBTc+B7CW/7srsXmaLPd+jq7K7DDUX2hL2qjwiuCTouhJ2okV2BsnyzI10kZH
         Pjrn9j2ijK4mw==
Message-ID: <65548ce6-d2d8-c913-a494-5ac044af2e35@marcan.st>
Date:   Tue, 14 Feb 2023 19:30:10 +0900
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
From:   Hector Martin <marcan@marcan.st>
In-Reply-To: <edcabef3-f440-9c15-e69f-845eb6a4de1b@broadcom.com>
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

On 14/02/2023 19.07, Arend van Spriel wrote:
> + Double Lo
> 
> On 2/14/2023 10:33 AM, Hector Martin wrote:
>> Using the WSEC command instead of sae_password seems to be the supported
>> mechanism on newer firmware, and also how the brcmdhd driver does it.
> 
> The SAE code in brcmfmac was added by Cypress/Infineon. For my BCA 
> devices that did not work, but this change should be verified on Cypress 
> hardware.

Do you mean the existing SAE code does not work on BCA, or this version
doesn't?

I assume/hope this version works for WCC in general, since that is what
the Apple-relevant chips are tagged as. If so it sounds like we need a
firmware type conditional on this, if CYW needs the existing behavior.

- Hector
