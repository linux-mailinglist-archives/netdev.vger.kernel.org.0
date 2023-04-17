Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C377B6E3ED5
	for <lists+netdev@lfdr.de>; Mon, 17 Apr 2023 07:20:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229926AbjDQFU0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Apr 2023 01:20:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229518AbjDQFUY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Apr 2023 01:20:24 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3120173B;
        Sun, 16 Apr 2023 22:20:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 49C3A60FAC;
        Mon, 17 Apr 2023 05:20:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2CA2BC433EF;
        Mon, 17 Apr 2023 05:20:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681708822;
        bh=utLr9q/tilmsgA9ydZ94KoWcI92v9Hk3brelgERnjDA=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=OqW6EGeeliksOWrGP/mACTVCzNkC2C5WnbNBzPTY11QxJJvZmDsaRCJKoIObAYJCL
         5qs1ElkMGrANTlHcnf+KO2dpmfWYZxqt3gzMmKaQlR90WNi8aXqGT6MlUAJx04dUeO
         UUKLDzcW0JgYUwuWK13JXYdkJWP2iUOifMcOWuln1LSMqUw4oSFp4OChSp7tMvT3uA
         Cc3THhncqYVQECPUSRvN1tqcOBBsGEeR7gN3HRmbMSBdiI4Y25Xb1g636prmcuVa1G
         C8K7KEfEeYQdUtfntwZwXvOUZMjpSvtazlLtGbLA3NWk/Kqwz4TeOluNwblVkirOwl
         wFyjeUYa3PjCQ==
From:   Kalle Valo <kvalo@kernel.org>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     Hector Martin <marcan@marcan.st>,
        Arend van Spriel <aspriel@gmail.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        SHA-cyfmac-dev-list@infineon.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, asahi@lists.linux.dev,
        stable@vger.kernel.org
Subject: Re: [PATCH 1/2] wifi: brcmfmac: Demote vendor-specific attach/detach messages to info
References: <20230416-brcmfmac-noise-v1-0-f0624e408761@marcan.st>
        <20230416-brcmfmac-noise-v1-1-f0624e408761@marcan.st>
        <2023041631-crying-contour-5e11@gregkh>
Date:   Mon, 17 Apr 2023 08:20:14 +0300
In-Reply-To: <2023041631-crying-contour-5e11@gregkh> (Greg KH's message of
        "Sun, 16 Apr 2023 14:46:48 +0200")
Message-ID: <875y9vxey9.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Greg KH <gregkh@linuxfoundation.org> writes:

> On Sun, Apr 16, 2023 at 09:42:17PM +0900, Hector Martin wrote:
>
>> People are getting spooked by brcmfmac errors on their boot console.
>> There's no reason for these messages to be errors.
>> 
>> Cc: stable@vger.kernel.org
>> Fixes: d6a5c562214f ("wifi: brcmfmac: add support for vendor-specific firmware api")
>> Signed-off-by: Hector Martin <marcan@marcan.st>
>> ---
>>  drivers/net/wireless/broadcom/brcm80211/brcmfmac/bca/core.c | 4 ++--
>>  drivers/net/wireless/broadcom/brcm80211/brcmfmac/cyw/core.c | 4 ++--
>>  drivers/net/wireless/broadcom/brcm80211/brcmfmac/wcc/core.c | 4 ++--
>>  3 files changed, 6 insertions(+), 6 deletions(-)
>> 
>> diff --git
>> a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bca/core.c
>> b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bca/core.c
>> index ac3a36fa3640..c83bc435b257 100644
>> --- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bca/core.c
>> +++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bca/core.c
>> @@ -12,13 +12,13 @@
>>  
>>  static int brcmf_bca_attach(struct brcmf_pub *drvr)
>>  {
>> -	pr_err("%s: executing\n", __func__);
>> +	pr_info("%s: executing\n", __func__);
>
> Why are these here at all?  Please just remove these entirely, you can
> get this information normally with ftrace.
>
> Or, just delete these functions, why have empty ones at all?

Yeah, deleting these sound like the best idea.

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
