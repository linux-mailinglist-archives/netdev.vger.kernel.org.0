Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F00D3A483C
	for <lists+netdev@lfdr.de>; Sun,  1 Sep 2019 09:55:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728865AbfIAHzz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 1 Sep 2019 03:55:55 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:53430 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725887AbfIAHzy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 1 Sep 2019 03:55:54 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id D4992607EB; Sun,  1 Sep 2019 07:55:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1567324553;
        bh=Q8AFvlCqM8riRdgz/ITzP8CxLVE9Flu8eH1HtXTq798=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=QfGIqeG+/i7+GoSzsPwmM6vwzGmH9cly81z6HP8VXvKScy01D0wfMcF5EufUch4qb
         eDfCT8fWLo2tZluhTaeAiDiDp5mTs0ciLJ2t4YUGd6xfWWN3TodLXu7jsRq+rxyyuE
         R4t9Nb9ILLjoj/Ibs08k9cxZLYuWI9eaknegb7Iw=
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
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 179F76076A;
        Sun,  1 Sep 2019 07:55:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1567324552;
        bh=Q8AFvlCqM8riRdgz/ITzP8CxLVE9Flu8eH1HtXTq798=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=MK9cZIdSPGuA3OlBYVxHbVcFYDKNeN01bYliE9iEreD30MgarxdjgKvFveKOIb4z8
         D0HKCIx09Bf3IZcv/cmP+geov5Q6exWhpJGqgq9pJHUmLmA26J903XSHg+EJZ5Hei7
         v0wHIIm4t772JMKbYz9Si0/TuMwUSQEUC5tzHqVk=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 179F76076A
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     Hui Peng <benquike@gmail.com>, davem@davemloft.net,
        Mathias Payer <mathias.payer@nebelwelt.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] Fix a NULL-ptr-deref bug in ath6kl_usb_alloc_urb_from_pipe
References: <20190804002905.11292-1-benquike@gmail.com>
        <20190831180219.GA20860@roeck-us.net>
Date:   Sun, 01 Sep 2019 10:55:48 +0300
In-Reply-To: <20190831180219.GA20860@roeck-us.net> (Guenter Roeck's message of
        "Sat, 31 Aug 2019 11:02:19 -0700")
Message-ID: <87sgpgqwl7.fsf@kamboji.qca.qualcomm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Guenter Roeck <linux@roeck-us.net> writes:

> On Sat, Aug 03, 2019 at 08:29:04PM -0400, Hui Peng wrote:
>> The `ar_usb` field of `ath6kl_usb_pipe_usb_pipe` objects
>> are initialized to point to the containing `ath6kl_usb` object
>> according to endpoint descriptors read from the device side, as shown
>> below in `ath6kl_usb_setup_pipe_resources`:
>> 
>> for (i = 0; i < iface_desc->desc.bNumEndpoints; ++i) {
>> 	endpoint = &iface_desc->endpoint[i].desc;
>> 
>> 	// get the address from endpoint descriptor
>> 	pipe_num = ath6kl_usb_get_logical_pipe_num(ar_usb,
>> 						endpoint->bEndpointAddress,
>> 						&urbcount);
>> 	......
>> 	// select the pipe object
>> 	pipe = &ar_usb->pipes[pipe_num];
>> 
>> 	// initialize the ar_usb field
>> 	pipe->ar_usb = ar_usb;
>> }
>> 
>> The driver assumes that the addresses reported in endpoint
>> descriptors from device side  to be complete. If a device is
>> malicious and does not report complete addresses, it may trigger
>> NULL-ptr-deref `ath6kl_usb_alloc_urb_from_pipe` and
>> `ath6kl_usb_free_urb_to_pipe`.
>> 
>> This patch fixes the bug by preventing potential NULL-ptr-deref.
>> 
>> Signed-off-by: Hui Peng <benquike@gmail.com>
>> Reported-by: Hui Peng <benquike@gmail.com>
>> Reported-by: Mathias Payer <mathias.payer@nebelwelt.net>
>
> I don't see this patch in the upstream kernel or in -next.
>
> At the same time, it is supposed to fix CVE-2019-15098, which has
> a CVSS v2.0 score of 7.8 (high).
>
> Is this patch going to be applied to the upstream kernel ?

Lately I have been very busy and I have not had a chance to apply ath6kl
nor ath10k patches. This patch is on my queue and my plan is to go
through my patch queue next week.

-- 
https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
