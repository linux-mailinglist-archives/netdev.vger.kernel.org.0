Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B1F83A485E
	for <lists+netdev@lfdr.de>; Sun,  1 Sep 2019 10:06:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728882AbfIAIGN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 1 Sep 2019 04:06:13 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:55778 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728807AbfIAIGN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 1 Sep 2019 04:06:13 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id CBACA607C3; Sun,  1 Sep 2019 08:06:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1567325171;
        bh=0di5kjor58mU5K1O24hMMYng4gdlXWeKha9jYaqTdTA=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=fD8dwNEX2JuXvfAO577IcFn3gC9Rl2D10xiWFBqIDACcvN74JtlVKjzAZ19OfYCVC
         4JE2HDvKBzDCpC7xYBDF3gqXaMgxSp6QQzSkpGRZHCGDBRaRyNSbwq+N3tGmVdw4DZ
         mH/rgg5ZYO521IYKKU5h5gjmrs6cYC/ByPs93qVc=
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
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 85C4660159;
        Sun,  1 Sep 2019 08:06:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1567325171;
        bh=0di5kjor58mU5K1O24hMMYng4gdlXWeKha9jYaqTdTA=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=fD8dwNEX2JuXvfAO577IcFn3gC9Rl2D10xiWFBqIDACcvN74JtlVKjzAZ19OfYCVC
         4JE2HDvKBzDCpC7xYBDF3gqXaMgxSp6QQzSkpGRZHCGDBRaRyNSbwq+N3tGmVdw4DZ
         mH/rgg5ZYO521IYKKU5h5gjmrs6cYC/ByPs93qVc=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 85C4660159
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     Hui Peng <benquike@gmail.com>, davem@davemloft.net,
        Mathias Payer <mathias.payer@nebelwelt.net>,
        ath10k@lists.infradead.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] Fix a NULL-ptr-deref bug in ath10k_usb_alloc_urb_from_pipe
References: <20190804003101.11541-1-benquike@gmail.com>
        <20190831213139.GA32507@roeck-us.net>
Date:   Sun, 01 Sep 2019 11:06:05 +0300
In-Reply-To: <20190831213139.GA32507@roeck-us.net> (Guenter Roeck's message of
        "Sat, 31 Aug 2019 14:31:39 -0700")
Message-ID: <87ftlgqw42.fsf@kamboji.qca.qualcomm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Guenter Roeck <linux@roeck-us.net> writes:

> Hi,
>
> On Sat, Aug 03, 2019 at 08:31:01PM -0400, Hui Peng wrote:
>> The `ar_usb` field of `ath10k_usb_pipe_usb_pipe` objects
>> are initialized to point to the containing `ath10k_usb` object
>> according to endpoint descriptors read from the device side, as shown
>> below in `ath10k_usb_setup_pipe_resources`:
>> 
>> for (i = 0; i < iface_desc->desc.bNumEndpoints; ++i) {
>>         endpoint = &iface_desc->endpoint[i].desc;
>> 
>>         // get the address from endpoint descriptor
>>         pipe_num = ath10k_usb_get_logical_pipe_num(ar_usb,
>>                                                 endpoint->bEndpointAddress,
>>                                                 &urbcount);
>>         ......
>>         // select the pipe object
>>         pipe = &ar_usb->pipes[pipe_num];
>> 
>>         // initialize the ar_usb field
>>         pipe->ar_usb = ar_usb;
>> }
>> 
>> The driver assumes that the addresses reported in endpoint
>> descriptors from device side  to be complete. If a device is
>> malicious and does not report complete addresses, it may trigger
>> NULL-ptr-deref `ath10k_usb_alloc_urb_from_pipe` and
>> `ath10k_usb_free_urb_to_pipe`.
>> 
>> This patch fixes the bug by preventing potential NULL-ptr-deref.
>> 
>> Signed-off-by: Hui Peng <benquike@gmail.com>
>> Reported-by: Hui Peng <benquike@gmail.com>
>> Reported-by: Mathias Payer <mathias.payer@nebelwelt.net>
>
> This patch fixes CVE-2019-15099, which has CVSS scores of 7.5 (CVSS 3.0)
> and 7.8 (CVSS 2.0). Yet, I don't find it in the upstream kernel or in Linux
> next.
>
> Is the patch going to be applied to the upstream kernel anytime soon ?

Same answer as in patch 1:

https://patchwork.kernel.org/patch/11074655/

-- 
https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
