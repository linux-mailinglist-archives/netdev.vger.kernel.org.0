Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A60003EEC11
	for <lists+netdev@lfdr.de>; Tue, 17 Aug 2021 14:04:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239879AbhHQMEG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Aug 2021 08:04:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239878AbhHQMEE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Aug 2021 08:04:04 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B603C061764
        for <netdev@vger.kernel.org>; Tue, 17 Aug 2021 05:03:31 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=[IPv6:::1])
        by metis.ext.pengutronix.de with esmtp (Exim 4.92)
        (envelope-from <a.fatoum@pengutronix.de>)
        id 1mFxoO-0007VN-FN; Tue, 17 Aug 2021 14:03:20 +0200
Subject: Re: [PATCH] brcmfmac: pcie: fix oops on failure to resume and reprobe
To:     Andy Shevchenko <andy.shevchenko@gmail.com>
Cc:     Arend van Spriel <aspriel@gmail.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Chi-hsien Lin <chi-hsien.lin@infineon.com>,
        Wright Feng <wright.feng@infineon.com>,
        Chung-hsien Hsu <chung-hsien.hsu@infineon.com>,
        "kernel@pengutronix.de" <kernel@pengutronix.de>,
        "SHA-cyfmac-dev-list@infineon.com" <SHA-cyfmac-dev-list@infineon.com>,
        "brcm80211-dev-list.pdl@broadcom.com" 
        <brcm80211-dev-list.pdl@broadcom.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <20210817063521.22450-1-a.fatoum@pengutronix.de>
 <CAHp75Vfc_T04p95PgVUd+CK+ttPwX2aOC4WPD35Z01WQV1MxKw@mail.gmail.com>
 <3a9a3789-5a13-7e72-b909-8f0826b8ab86@pengutronix.de>
 <CAHp75VfahF=_CmS7kw5PbKs46+hXFweweq=sjwd83hccRsrH9g@mail.gmail.com>
From:   Ahmad Fatoum <a.fatoum@pengutronix.de>
Message-ID: <e59b23ba-7e5b-00e3-e8c9-f5c2bb89b860@pengutronix.de>
Date:   Tue, 17 Aug 2021 14:03:16 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <CAHp75VfahF=_CmS7kw5PbKs46+hXFweweq=sjwd83hccRsrH9g@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: a.fatoum@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 17.08.21 13:54, Andy Shevchenko wrote:
> On Tue, Aug 17, 2021 at 2:11 PM Ahmad Fatoum <a.fatoum@pengutronix.de> wrote:
>> On 17.08.21 13:02, Andy Shevchenko wrote:
>>> On Tuesday, August 17, 2021, Ahmad Fatoum <a.fatoum@pengutronix.de> wrote:
> 
> ...
> 
>>>>         err = brcmf_pcie_probe(pdev, NULL);
>>>>         if (err)
>>>> -               brcmf_err(bus, "probe after resume failed, err=%d\n", err);
>>>> +               __brcmf_err(NULL, __func__, "probe after resume failed,
>>>> err=%d\n",
>>>
>>>
>>> This is weird looking line now. Why can’t you simply use dev_err() /
>>> netdev_err()?
>>
>> That's what brcmf_err normally expands to, but in this file the macro
>> is overridden to add the extra first argument.
> 
> So, then the problem is in macro here. You need another portion of
> macro(s) that will use the dev pointer directly. When you have a valid
> device, use it. And here it seems the case.

Ah, you mean using pdev instead of the stale bus. Ye, I could do that.
Thanks for pointing out.

> 
>> The brcmf_ logging function write to brcmf trace buffers. This is not
>> done with netdev_err/dev_err (and replacing the existing logging
>> is out of scope for a regression fix anyway).
> 
> I see.
> 


-- 
Pengutronix e.K.                           |                             |
Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
