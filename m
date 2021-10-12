Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C1BBB42A315
	for <lists+netdev@lfdr.de>; Tue, 12 Oct 2021 13:21:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236192AbhJLLXB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Oct 2021 07:23:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236184AbhJLLXA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Oct 2021 07:23:00 -0400
Received: from mout-p-102.mailbox.org (mout-p-102.mailbox.org [IPv6:2001:67c:2050::465:102])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE642C061570;
        Tue, 12 Oct 2021 04:20:58 -0700 (PDT)
Received: from smtp2.mailbox.org (smtp2.mailbox.org [IPv6:2001:67c:2050:105:465:1:2:0])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mout-p-102.mailbox.org (Postfix) with ESMTPS id 4HTCs36VXgzQkkS;
        Tue, 12 Oct 2021 13:20:55 +0200 (CEST)
X-Virus-Scanned: amavisd-new at heinlein-support.de
Message-ID: <3c98ea6c-b80f-59d4-ad84-85cf1c9ff440@v0yd.nl>
Date:   Tue, 12 Oct 2021 13:20:46 +0200
MIME-Version: 1.0
Subject: Re: [PATCH] mwifiex: Add quirk resetting the PCI bridge on MS Surface
 devices
Content-Language: en-US
To:     =?UTF-8?Q?Pali_Roh=c3=a1r?= <pali@kernel.org>
Cc:     Bjorn Helgaas <helgaas@kernel.org>,
        Amitkumar Karwar <amitkarwar@gmail.com>,
        Ganapathi Bhat <ganapathi017@gmail.com>,
        Xinming Hu <huxinming820@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Tsuchiya Yuto <kitakar@gmail.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        Maximilian Luz <luzmaximilian@gmail.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        Brian Norris <briannorris@chromium.org>,
        David Laight <David.Laight@ACULAB.COM>,
        Alex Williamson <alex.williamson@redhat.com>
References: <20211011165301.GA1650148@bhelgaas>
 <fee8b431-617f-3890-3ad2-67a61d3ffca2@v0yd.nl>
 <20211012090037.v3w4za5hshtm253f@pali>
From:   =?UTF-8?Q?Jonas_Dre=c3=9fler?= <verdre@v0yd.nl>
In-Reply-To: <20211012090037.v3w4za5hshtm253f@pali>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: CBF09183C
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/12/21 11:00, Pali Rohár wrote:
> On Tuesday 12 October 2021 10:48:49 Jonas Dreßler wrote:
>> 1) Revert the cards firmware in linux-firmware back to the second-latest
>> version. That firmware didn't report a fixed LTR value and also doesn't
>> have any other obvious issues I know of compared to the latest one.
> 
> FYI, there are new bugs with new firmware versions for 8997 sent by NXP
> to linux-firmware repository... and questions what to do with it. Seems
> that NXP again do not respond to any questions after new version was
> merged into linux-firmware repo.
> 
> https://lore.kernel.org/linux-firmware/edeb34bc-7c85-7f1d-79e4-e3e21df86334@gk2.net/
> 
> So firmware revert also for other ex-Marvell / NXP chips is not
> something which could not happen.
> 

Argh, nevermind, it seems like my memory is fooling me once again, sorry.
I just tried the older firmware and I was completely wrong, there's no
difference at all between the versions when it comes to LTR messages. So
there goes alternative 1).

Something interesting and reassuring I noticed though: After resuming from
suspend the firmware actually doesn't send a new LTR message, which means
now the LTR is 0 and we enter PC10/S0ix just fine. So basically the change
this patch does is already in effect, just after one suspend/resume cycle.
That gives me more confidence that we should maybe apply this patch for
all 8897 devices, not only Surface devices?
