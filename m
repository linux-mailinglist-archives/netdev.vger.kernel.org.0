Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 074E3100041
	for <lists+netdev@lfdr.de>; Mon, 18 Nov 2019 09:22:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726465AbfKRIWZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Nov 2019 03:22:25 -0500
Received: from first.geanix.com ([116.203.34.67]:60412 "EHLO first.geanix.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726404AbfKRIWY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 18 Nov 2019 03:22:24 -0500
Received: from [192.168.100.95] (unknown [95.138.208.137])
        by first.geanix.com (Postfix) with ESMTPSA id 93964910FF;
        Mon, 18 Nov 2019 08:19:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=geanix.com; s=first;
        t=1574065157; bh=e22tKl2eZF6QnF4WPR/X0tVrQs0JaE7kygfloxzFABM=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To;
        b=MmIrQzW5+Z//Y1ULanqhVAj2uwQ83fPFrWSS7ajdcjhZfg3h1pG2qItdpGP0rD2KW
         nXkNWSabFxt+Hc6BRNDI0ckZ9/YAKe04pZB7pkcsUgDv+fFiZYjhN7FJzvYp4hmR78
         KbhB98TRObeYS9sbNfaZOLd1iKtrtToXWGLAxw7+mkxUbRzYw1SklzSyqYEsMnrIuo
         pzPHaauaIHn9rbjVCs1yPdb2uXvaM6B2jkqeIPMfMcuCWJqo+1JVPVGmwF0CIABlei
         YfEGmJ2gCKKr96K1uFkdRG/IGxGo2xrQ70naEK06/Mhb3wU/J+rzOqzDtAGKz2kj5J
         FWeKHhBUofN9g==
Subject: Re: [PATCH 1/3] can: flexcan: fix deadlock when using self wakeup
To:     Joakim Zhang <qiangqing.zhang@nxp.com>,
        "mkl@pengutronix.de" <mkl@pengutronix.de>
Cc:     "linux-can@vger.kernel.org" <linux-can@vger.kernel.org>,
        dl-linux-imx <linux-imx@nxp.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <20191115050032.25928-1-qiangqing.zhang@nxp.com>
 <9870ec21-b664-522e-e0df-290ab56fbb32@geanix.com>
 <DB7PR04MB4618220095E1F844A44DB480E64D0@DB7PR04MB4618.eurprd04.prod.outlook.com>
 <16a0aa7b-875e-8dd9-085c-3341d3f1ac51@geanix.com>
 <DB7PR04MB461895F57FD4F360A723D2FAE64D0@DB7PR04MB4618.eurprd04.prod.outlook.com>
From:   Sean Nyekjaer <sean@geanix.com>
Message-ID: <12e03487-d468-c009-72c7-88804e87e256@geanix.com>
Date:   Mon, 18 Nov 2019 09:21:45 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <DB7PR04MB461895F57FD4F360A723D2FAE64D0@DB7PR04MB4618.eurprd04.prod.outlook.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US-large
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.1 required=4.0 tests=ALL_TRUSTED,BAYES_00,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,URIBL_BLOCKED
        autolearn=disabled version=3.4.2
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on b0d531b295e6
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 18/11/2019 09.04, Joakim Zhang wrote:
>>>> Hi Joakim and Marc
>>>>
>>>> We have quite a few devices in the field where flexcan is stuck in Stop-Mode.
>>>> We do not have the possibility to cold reboot them, and hot reboot
>>>> will not get flexcan out of stop-mode.
>>>> So flexcan comes up with:
>>>> [  279.444077] flexcan: probe of 2090000.flexcan failed with error
>>>> -110 [  279.501405] flexcan: probe of 2094000.flexcan failed with
>>>> error -110
>>>>
>>>> They are on, de3578c198c6 ("can: flexcan: add self wakeup support")
>>>>
>>>> Would it be a solution to add a check in the probe function to pull
>>>> it out of stop-mode?
>>>
>>> Hi Sean,
>>>
>>> Soft reset cannot be applied when clocks are shut down in a low power mode.
>> The module should be first removed from low power mode, and then soft reset
>> can be applied.
>>> And exit from stop mode happens when the Stop mode request is removed,
>> or when activity is detected on the CAN bus and the Self Wake Up mechanism is
>> enabled.
>>>
>>> So from my point of view, we can add a check in the probe function to
>>> pull it out of stop mode, since controller actually could be stuck in stop mode
>> if suspend/resume failed and users just want a warm reset for the system.
>>
>> Exactly what I thought could be done :)
>>
>>>
>>> Could you please tell me how can I generate a warm reset? AFAIK, both
>> "reboot" command put into prompt and RST KEY in our EVK board all play a role
>> of cold reset.
>>
>> Warm reset is just `reboot` :-) Cold is poweroff...
> 
> I add the code flexcan_enter_stop_mode(priv) at the end of the probe function, 'reboot' the system directly after system active.
> However, I do not meet the probe error, it can probe successfully. Do you know the reason?

You will have to get it in the deadlock situation first :)

This can be achieved by using de3578c198c6 and sending can messages to 
both can interfaces while calling suspend.

/Sean
