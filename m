Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0D826A485A
	for <lists+netdev@lfdr.de>; Sun,  1 Sep 2019 10:04:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728919AbfIAIDr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 1 Sep 2019 04:03:47 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:55420 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727083AbfIAIDo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 1 Sep 2019 04:03:44 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 01DF16076C; Sun,  1 Sep 2019 08:03:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1567325023;
        bh=s3Qd8teK9Pse+c22d4E8V6jGZ+kuODY5cnFtVMtOy9k=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=mGwoiqIVDRXNPUlFGTey+0JcjgcZCeRCM/dv8B7xrPGhrXkYowXI8/x1FbcnJmeA+
         Bj+J7gQIsULkHofJUzNmpp5aMH0qDqQk1EdWPKM3bnzYNwsqbckYESAgqVxywSaEf0
         Zx7b7N6h7iZBIbejRaRGotcDF5MZGQ53ZlGC1ANk=
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        pdx-caf-mail.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.7 required=2.0 tests=ALL_TRUSTED,BAYES_00,
        DKIM_INVALID,DKIM_SIGNED,SPF_NONE autolearn=no autolearn_force=no
        version=3.4.0
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 62DB960159;
        Sun,  1 Sep 2019 08:03:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1567325021;
        bh=s3Qd8teK9Pse+c22d4E8V6jGZ+kuODY5cnFtVMtOy9k=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=FOVi+y8Oq9cGml0+3ekpjfudzoAfQDldqv2osYPc3mzjB+S1xuk9v3HwmlQxGWl4l
         5kPQzMp/XA6cIzTFFYtUkQtNSBpGOzyvXaJrvaYDQQ0wnOEtxOf216z3s4TwwTdLGE
         RuKDy6pEmFP0GKk4j103lrvlZkWaf/SxnKBEtYvM=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 62DB960159
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     Hui Peng <benquike@gmail.com>, security@kernel.org,
        Mathias Payer <mathias.payer@nebelwelt.net>,
        "David S. Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fix a double free bug in rsi_91x_deinit
References: <20190819220230.10597-1-benquike@gmail.com>
        <20190831181852.GA22160@roeck-us.net>
Date:   Sun, 01 Sep 2019 11:03:36 +0300
In-Reply-To: <20190831181852.GA22160@roeck-us.net> (Guenter Roeck's message of
        "Sat, 31 Aug 2019 11:18:52 -0700")
Message-ID: <87k1asqw87.fsf@kamboji.qca.qualcomm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Guenter Roeck <linux@roeck-us.net> writes:

> On Mon, Aug 19, 2019 at 06:02:29PM -0400, Hui Peng wrote:
>> `dev` (struct rsi_91x_usbdev *) field of adapter
>> (struct rsi_91x_usbdev *) is allocated  and initialized in
>> `rsi_init_usb_interface`. If any error is detected in information
>> read from the device side,  `rsi_init_usb_interface` will be
>> freed. However, in the higher level error handling code in
>> `rsi_probe`, if error is detected, `rsi_91x_deinit` is called
>> again, in which `dev` will be freed again, resulting double free.
>> 
>> This patch fixes the double free by removing the free operation on
>> `dev` in `rsi_init_usb_interface`, because `rsi_91x_deinit` is also
>> used in `rsi_disconnect`, in that code path, the `dev` field is not
>>  (and thus needs to be) freed.
>> 
>> This bug was found in v4.19, but is also present in the latest version
>> of kernel.
>> 
>> Reported-by: Hui Peng <benquike@gmail.com>
>> Reported-by: Mathias Payer <mathias.payer@nebelwelt.net>
>> Signed-off-by: Hui Peng <benquike@gmail.com>
>
> FWIW:
>
> Reviewed-by: Guenter Roeck <linux@roeck-us.net>
>
> This patch is listed as fix for CVE-2019-15504, which has a CVSS 2.0 score
> of 10.0 (high) and CVSS 3.0 score of 9.8 (critical).

A double free in error path is considered as a critical CVE issue? I'm
very curious, why is that?

> Are there any plans to apply this patch to the upstream kernel anytime
> soon ?

I was on vacation last week and hence I have not been able to apply any
wireless patches. I should be able to catch up next week.

-- 
https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
