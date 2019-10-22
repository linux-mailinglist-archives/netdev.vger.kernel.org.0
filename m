Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 15C01DFFAE
	for <lists+netdev@lfdr.de>; Tue, 22 Oct 2019 10:38:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388438AbfJVIhz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Oct 2019 04:37:55 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:54692 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388393AbfJVIhy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Oct 2019 04:37:54 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 621F46079C; Tue, 22 Oct 2019 08:37:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1571733473;
        bh=Po5RtiTU4/a1PjWYIFhSvt3ysgdj+uj3Q97l1tGoGno=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=QCCCcIC789yQ7vbQZCHzAEybmJpv0vZdd2l3JH455L1ATtObglxlqGa3Mevq6K7t+
         QEcCnfnJwgsLraluQWKf4zK9AejH43f7u+H3LWYMpIs8CnrO/GUhpuLz+QeogAUIwR
         PB6O61Alyb4w5ROOD6RWvjzr+xx/RRSHcQTQ17nA=
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        pdx-caf-mail.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=2.0 tests=ALL_TRUSTED,BAYES_00,
        DKIM_INVALID,DKIM_SIGNED,MISSING_DATE,MISSING_MID,SPF_NONE autolearn=no
        autolearn_force=no version=3.4.0
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 8C0B66081E;
        Tue, 22 Oct 2019 08:37:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1571733468;
        bh=Po5RtiTU4/a1PjWYIFhSvt3ysgdj+uj3Q97l1tGoGno=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=S+TEhuqHHOLxBvvFbhB4Fg/0nbgR8jLvULtLxz34XMRYJ1ZrEH2uoixCBf1BT0aGQ
         XapuA4XFkIkgBxjEYlBHtuvpoqnD7+SjujRhfeQsiwkRsMrsjjtpwpvFAV3J5KXW6/
         b9XS1mAnHnbxutmCYP5i6EHXsjV6fCyS/gOcQgFo=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 8C0B66081E
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v2] ath10k: Fix a NULL-ptr-deref bug in
 ath10k_usb_alloc_urb_from_pipe
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20191018133516.12606-1-linux@roeck-us.net>
References: <20191018133516.12606-1-linux@roeck-us.net>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     ath10k@lists.infradead.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Hui Peng <benquike@gmail.com>,
        Guenter Roeck <linux@roeck-us.net>
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20191022083752.621F46079C@smtp.codeaurora.org>
Date:   Tue, 22 Oct 2019 08:37:51 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Guenter Roeck <linux@roeck-us.net> wrote:

> The `ar_usb` field of `ath10k_usb_pipe_usb_pipe` objects
> are initialized to point to the containing `ath10k_usb` object
> according to endpoint descriptors read from the device side, as shown
> below in `ath10k_usb_setup_pipe_resources`:
> 
> for (i = 0; i < iface_desc->desc.bNumEndpoints; ++i) {
>         endpoint = &iface_desc->endpoint[i].desc;
> 
>         // get the address from endpoint descriptor
>         pipe_num = ath10k_usb_get_logical_pipe_num(ar_usb,
>                                                 endpoint->bEndpointAddress,
>                                                 &urbcount);
>         ......
>         // select the pipe object
>         pipe = &ar_usb->pipes[pipe_num];
> 
>         // initialize the ar_usb field
>         pipe->ar_usb = ar_usb;
> }
> 
> The driver assumes that the addresses reported in endpoint
> descriptors from device side  to be complete. If a device is
> malicious and does not report complete addresses, it may trigger
> NULL-ptr-deref `ath10k_usb_alloc_urb_from_pipe` and
> `ath10k_usb_free_urb_to_pipe`.
> 
> This patch fixes the bug by preventing potential NULL-ptr-deref.
> 
> Signed-off-by: Hui Peng <benquike@gmail.com>
> Reported-by: Hui Peng <benquike@gmail.com>
> Reported-by: Mathias Payer <mathias.payer@nebelwelt.net>
> Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> [groeck: Add driver tag to subject, fix build warning]
> Signed-off-by: Guenter Roeck <linux@roeck-us.net>
> Signed-off-by: Kalle Valo <kvalo@codeaurora.org>

Patch applied to ath-next branch of ath.git, thanks.

bfd6e6e6c5d2 ath10k: Fix a NULL-ptr-deref bug in ath10k_usb_alloc_urb_from_pipe

-- 
https://patchwork.kernel.org/patch/11198433/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

