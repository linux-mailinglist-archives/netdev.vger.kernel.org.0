Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5EDFB10AB7F
	for <lists+netdev@lfdr.de>; Wed, 27 Nov 2019 09:13:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726496AbfK0INV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Nov 2019 03:13:21 -0500
Received: from first.geanix.com ([116.203.34.67]:34836 "EHLO first.geanix.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726125AbfK0INU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 27 Nov 2019 03:13:20 -0500
Received: from [192.168.100.95] (unknown [95.138.208.137])
        by first.geanix.com (Postfix) with ESMTPSA id 3F04D93C59;
        Wed, 27 Nov 2019 08:09:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=geanix.com; s=first;
        t=1574842174; bh=oT3pv5IXClEy0k/GwQhUj3QqzfyqSHMYwgRhtzQDbZA=;
        h=Subject:From:To:Cc:References:Date:In-Reply-To;
        b=JPuPqMTc+tGqLEApA7g3sF9W/aN3I+5jLDLtOKPCaTx9i1AspJ6kOWOzhkIocwCVN
         ClJcT29rrzMZknJYvbDCTymDqH+aWh+EMrALKTfuPSgf8x36gDnpPGZWBGS/IuWwIQ
         /2vE5WttXxlk3BOOPYtdhIJOMFpcipWOMJb93Y4KXlRZJOoxNeb7FhZMt73/uxX9Hs
         lENYiCn5pgZr8wuYVi1ot9vKbqbcYwxoIoPAkr53d1xc6TdU1vI6jm2FIo4NH+Qu0g
         8hjLkqLvIXSBwcfau5PA2zmfVoKFrQBIBm5QCUlqXmgD26Z82d9+T+gq9Kja1PuTjZ
         4mDItnMccn3fA==
Subject: Re: [PATCH V2 0/4] can: flexcan: fixes for stop mode
From:   Sean Nyekjaer <sean@geanix.com>
To:     Joakim Zhang <qiangqing.zhang@nxp.com>,
        "mkl@pengutronix.de" <mkl@pengutronix.de>,
        "linux-can@vger.kernel.org" <linux-can@vger.kernel.org>
Cc:     dl-linux-imx <linux-imx@nxp.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <20191127055334.1476-1-qiangqing.zhang@nxp.com>
 <e936b9b1-d602-ac38-213c-7272df529bef@geanix.com>
Message-ID: <4a9c2e4a-c62d-6e88-bd9e-01778dab503b@geanix.com>
Date:   Wed, 27 Nov 2019 09:12:38 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <e936b9b1-d602-ac38-213c-7272df529bef@geanix.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US-large
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.1 required=4.0 tests=ALL_TRUSTED,BAYES_00,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,URIBL_BLOCKED
        autolearn=disabled version=3.4.2
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on b0d531b295e6
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 27/11/2019 07.12, Sean Nyekjaer wrote:
> 
> 
> On 27/11/2019 06.56, Joakim Zhang wrote:
>>     Could you help check the patch set? With your suggestions, I
>> have cooked a patch to exit stop mode during probe stage.
>>
>>     IMHO, I think this patch is unneed, now in flexcan driver,
>> enter stop mode when suspend, and then exit stop mode when resume.
>> AFAIK, as long as flexcan_suspend has been called, flexcan_resume will
>> be called, unless the system hang during suspend/resume. If so, only
>> code reset can activate OS again. Could you please tell me how does CAN
>> stucked in stop mode at your side?
> 
> Hi Joakim,
> 
> Thanks I'll test this :-)
> Guess I will have do some hacking to get it stuck in stop mode.
> 
> We have a lot of devices in the field that doesn't have:
> "can: flexcan: fix deadlock when using self wakeup"
> 
> And they have traffic on both CAN interfaces, that way it's quite easy 
> to get them stuck in stop mode.
> 
> /Sean

Hi Joakim,

I have been testing this.
I have a hacked version of the driver that calls 
flexcan_enter_stop_mode() as the last step in the probe function.

First insert of flexcan.ko when stop mode is activated:
flexcan 2090000.flexcan: Linked as a consumer to regulator.4

flexcan 2090000.flexcan: registering netdev failed

flexcan 2090000.flexcan: Dropping the link to regulator.4

flexcan: probe of 2090000.flexcan failed with error -110

flexcan 2094000.flexcan: Linked as a consumer to regulator.4

flexcan 2094000.flexcan: registering netdev failed

flexcan 2094000.flexcan: Dropping the link to regulator.4

flexcan: probe of 2094000.flexcan failed with error -110


When I insert a flexcan.ko with the patch
"can: flexcan: try to exit stop mode during probe stage":
flexcan 2090000.flexcan: Linked as a consumer to regulator.4

flexcan 2090000.flexcan: Unbalanced pm_runtime_enable!

flexcan 2094000.flexcan: Linked as a consumer to regulator.4

flexcan 2094000.flexcan: Unbalanced pm_runtime_enable!

I works as I expected but, I think we need to do some pm_runtime cleanup 
when bailing with error -110.
Anyways it works great, thanks for your work on this.

/Sean
