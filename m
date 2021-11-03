Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CDC98444173
	for <lists+netdev@lfdr.de>; Wed,  3 Nov 2021 13:25:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231521AbhKCM23 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Nov 2021 08:28:29 -0400
Received: from mout-p-102.mailbox.org ([80.241.56.152]:52762 "EHLO
        mout-p-102.mailbox.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229816AbhKCM22 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Nov 2021 08:28:28 -0400
Received: from smtp202.mailbox.org (smtp202.mailbox.org [IPv6:2001:67c:2050:105:465:1:4:0])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mout-p-102.mailbox.org (Postfix) with ESMTPS id 4HkmFp4rVxzQjXt;
        Wed,  3 Nov 2021 13:25:50 +0100 (CET)
X-Virus-Scanned: amavisd-new at heinlein-support.de
Message-ID: <cc7432f4-824a-abe2-e304-5ba019ac8c89@v0yd.nl>
Date:   Wed, 3 Nov 2021 13:25:44 +0100
MIME-Version: 1.0
Subject: Re: [PATCH] mwifiex: Add quirk to disable deep sleep with certain
 hardware revision
Content-Language: en-US
To:     Brian Norris <briannorris@chromium.org>
Cc:     Amitkumar Karwar <amitkarwar@gmail.com>,
        Ganapathi Bhat <ganapathi017@gmail.com>,
        Xinming Hu <huxinming820@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Tsuchiya Yuto <kitakar@gmail.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Maximilian Luz <luzmaximilian@gmail.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        =?UTF-8?Q?Pali_Roh=c3=a1r?= <pali@kernel.org>
References: <20211028073729.24408-1-verdre@v0yd.nl>
 <CA+ASDXOrad3b=b8+vwuF6m3+ZcigVaoJySpDXXZOnC3O8CJBSw@mail.gmail.com>
From:   =?UTF-8?Q?Jonas_Dre=c3=9fler?= <verdre@v0yd.nl>
In-Reply-To: <CA+ASDXOrad3b=b8+vwuF6m3+ZcigVaoJySpDXXZOnC3O8CJBSw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 80FB026B
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/28/21 23:27, Brian Norris wrote:
> On Thu, Oct 28, 2021 at 12:37 AM Jonas Dreßler <verdre@v0yd.nl> wrote:
>>
>> The 88W8897 PCIe+USB card in the hardware revision 20 apparently has a
>> hardware issue where the card wakes up from deep sleep randomly and very
>> often, somewhat depending on the card activity, maybe the hardware has a
>> floating wakeup pin or something.
> 
> What makes you think it's associated with the particular "hardware
> revision 20"? Have you used multiple revisions on the same platform
> and found that only certain ones fail in this way? Otherwise, your
> theory in the last part of your sentence sounds like a platform issue,
> where you might do a DMI match instead.

The issue only appeared for some community members using Surface devices,
happening on the Surface Book 2 of one person, but not on the Surface Book
2 of another person. When investigating we were poking around in the dark
for a long time and almost gave up until we found that those two devices
had different hardware revisions of the same wifi card installed (ChipRev
20 vs 21).

So it seems pretty clear that with revision 21 they fixed some hardware
bug that causes those spurious wakeups.

FWIW, obviously a proper workaround for this would have to be implemented
in the firmware.

> 
>> --- a/drivers/net/wireless/marvell/mwifiex/sta_cmdresp.c
>> +++ b/drivers/net/wireless/marvell/mwifiex/sta_cmdresp.c
>> @@ -708,6 +708,22 @@ static int mwifiex_ret_ver_ext(struct mwifiex_private *priv,
>>   {
>>          struct host_cmd_ds_version_ext *ver_ext = &resp->params.verext;
>>
>> +       if (test_and_clear_bit(MWIFIEX_IS_REQUESTING_FW_VEREXT, &priv->adapter->work_flags)) {
>> +               if (strncmp(ver_ext->version_str, "ChipRev:20, BB:9b(10.00), RF:40(21)", 128) == 0) {
> 
> Rather than memorize the 128-size array here, maybe use
> sizeof(ver_ext->version_str) ?

Sounds like a good idea, yeah.

> 
> Brian
> 

