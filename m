Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 98D9E3EEC28
	for <lists+netdev@lfdr.de>; Tue, 17 Aug 2021 14:07:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239846AbhHQMIJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Aug 2021 08:08:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239876AbhHQMIH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Aug 2021 08:08:07 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FD96C0613C1
        for <netdev@vger.kernel.org>; Tue, 17 Aug 2021 05:07:34 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=[IPv6:::1])
        by metis.ext.pengutronix.de with esmtp (Exim 4.92)
        (envelope-from <a.fatoum@pengutronix.de>)
        id 1mFxsM-00085S-Dz; Tue, 17 Aug 2021 14:07:26 +0200
Subject: Re: [PATCH] brcmfmac: pcie: fix oops on failure to resume and reprobe
From:   Ahmad Fatoum <a.fatoum@pengutronix.de>
To:     Andy Shevchenko <andy.shevchenko@gmail.com>
Cc:     "brcm80211-dev-list.pdl@broadcom.com" 
        <brcm80211-dev-list.pdl@broadcom.com>,
        Arend van Spriel <aspriel@gmail.com>,
        Chung-hsien Hsu <chung-hsien.hsu@infineon.com>,
        Chi-hsien Lin <chi-hsien.lin@infineon.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Wright Feng <wright.feng@infineon.com>,
        "SHA-cyfmac-dev-list@infineon.com" <SHA-cyfmac-dev-list@infineon.com>,
        "kernel@pengutronix.de" <kernel@pengutronix.de>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Kalle Valo <kvalo@codeaurora.org>,
        Franky Lin <franky.lin@broadcom.com>
References: <20210817063521.22450-1-a.fatoum@pengutronix.de>
 <CAHp75Vfc_T04p95PgVUd+CK+ttPwX2aOC4WPD35Z01WQV1MxKw@mail.gmail.com>
 <3a9a3789-5a13-7e72-b909-8f0826b8ab86@pengutronix.de>
 <CAHp75VfahF=_CmS7kw5PbKs46+hXFweweq=sjwd83hccRsrH9g@mail.gmail.com>
 <e59b23ba-7e5b-00e3-e8c9-f5c2bb89b860@pengutronix.de>
Message-ID: <85e30fb4-ce7d-6402-f93e-09efadbbcd06@pengutronix.de>
Date:   Tue, 17 Aug 2021 14:07:22 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <e59b23ba-7e5b-00e3-e8c9-f5c2bb89b860@pengutronix.de>
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

On 17.08.21 14:03, Ahmad Fatoum wrote:
> On 17.08.21 13:54, Andy Shevchenko wrote:
>> On Tue, Aug 17, 2021 at 2:11 PM Ahmad Fatoum <a.fatoum@pengutronix.de> wrote:
>>> On 17.08.21 13:02, Andy Shevchenko wrote:
>>>> On Tuesday, August 17, 2021, Ahmad Fatoum <a.fatoum@pengutronix.de> wrote:
>>
>> ...
>>
>>>>>         err = brcmf_pcie_probe(pdev, NULL);
>>>>>         if (err)
>>>>> -               brcmf_err(bus, "probe after resume failed, err=%d\n", err);
>>>>> +               __brcmf_err(NULL, __func__, "probe after resume failed,
>>>>> err=%d\n",
>>>>
>>>>
>>>> This is weird looking line now. Why can’t you simply use dev_err() /
>>>> netdev_err()?
>>>
>>> That's what brcmf_err normally expands to, but in this file the macro
>>> is overridden to add the extra first argument.
>>
>> So, then the problem is in macro here. You need another portion of
>> macro(s) that will use the dev pointer directly. When you have a valid
>> device, use it. And here it seems the case.
> 
> Ah, you mean using pdev instead of the stale bus. Ye, I could do that.
> Thanks for pointing out.

Ah, not so easy: __brcmf_err accepts a struct brcmf_bus * as first argument,
but there is none I can pass along. As the whole file uses the brcm_
logging functions, I'd just leave this one without a device.

> 
>>
>>> The brcmf_ logging function write to brcmf trace buffers. This is not
>>> done with netdev_err/dev_err (and replacing the existing logging
>>> is out of scope for a regression fix anyway).
>>
>> I see.
>>
> 
> 


-- 
Pengutronix e.K.                           |                             |
Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
