Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BB6AFFD867
	for <lists+netdev@lfdr.de>; Fri, 15 Nov 2019 10:08:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727264AbfKOJH6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Nov 2019 04:07:58 -0500
Received: from first.geanix.com ([116.203.34.67]:33642 "EHLO first.geanix.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725829AbfKOJH6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 15 Nov 2019 04:07:58 -0500
Received: from [192.168.100.95] (unknown [95.138.208.137])
        by first.geanix.com (Postfix) with ESMTPSA id 0287790AA3;
        Fri, 15 Nov 2019 09:05:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=geanix.com; s=first;
        t=1573808705; bh=g0DWjx2a8cI1qvWhxkwO30DlLgqF5kULweMswSMI8vE=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To;
        b=J7tLi7a/XqaV7mDH67rF9FRY5mKubEUEKl3Z2dDrzSt09phE+4rEb39JOiwImD2tI
         ATYe8X6c8iMAExefsVpSpGVnaLgXKqaJpEjWKYhrfzojFF4OLF4j5lF2KkDj5ipa6I
         ycHKzcisnhwKf6jl+c0+SJCP7lGzqBTwuJ7U4c/tP3MS9OO3CtusmgGpHR2jL9R0DS
         CRA7gsJc7IxqDNRHKHXx86nlY53xzC6iLQdUHRELPGsrjrCem78BIi/DTcmKpmQeHe
         bM/FkKLXpSgyvcpoBpUPakyJTT103xHhipUOefYDcltS9D/7T32WOwPvVjewC2u+/r
         GuwoI+Dg2Kscg==
Subject: Re: [PATCH 1/3] can: flexcan: fix deadlock when using self wakeup
To:     Joakim Zhang <qiangqing.zhang@nxp.com>,
        "mkl@pengutronix.de" <mkl@pengutronix.de>,
        "linux-can@vger.kernel.org" <linux-can@vger.kernel.org>
Cc:     dl-linux-imx <linux-imx@nxp.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <20191115050032.25928-1-qiangqing.zhang@nxp.com>
 <DB7PR04MB4618335E8A90387EDAE17F21E6700@DB7PR04MB4618.eurprd04.prod.outlook.com>
 <986c06e6-644a-5ad4-b7e0-ce431605b626@geanix.com>
 <DB7PR04MB4618824F3A331AF9EC207C55E6700@DB7PR04MB4618.eurprd04.prod.outlook.com>
From:   Sean Nyekjaer <sean@geanix.com>
Message-ID: <91802fbe-5840-5b14-9b5e-afc278017dba@geanix.com>
Date:   Fri, 15 Nov 2019 10:07:20 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <DB7PR04MB4618824F3A331AF9EC207C55E6700@DB7PR04MB4618.eurprd04.prod.outlook.com>
Content-Type: text/plain; charset=gbk; format=flowed
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



On 15/11/2019 10.06, Joakim Zhang wrote:
> 
>> -----Original Message-----
>> From: Sean Nyekjaer <sean@geanix.com>
>> Sent: 2019Äê11ÔÂ15ÈÕ 16:54
>> To: Joakim Zhang <qiangqing.zhang@nxp.com>; mkl@pengutronix.de;
>> linux-can@vger.kernel.org
>> Cc: dl-linux-imx <linux-imx@nxp.com>; netdev@vger.kernel.org
>> Subject: Re: [PATCH 1/3] can: flexcan: fix deadlock when using self wakeup
>>
>>
>>
>> On 15/11/2019 06.09, Joakim Zhang wrote:
>>>
>>> Hi Sean,
>>>
>>> I remember that you are the first one sending out the patch to fix this issue,
>> and I NACK the patch before.
>>> I am so sorry for that, it can work fine after testing at my side.
>>> Could you help double check at your side for this patch? Both wakeup from
>> totally suspend and wakeup from suspending?
>>>
>>> With this patch, we can fix two problems:
>>> 1) fix deadlock when using self wakeup
>>> 2) frames out-of-order in first IRQ handler run after wakeup
>>>
>>> Thanks a lot!
>>>
>>> Best Regards,
>>> Joakim Zhang
>>
>> Hi Joakim,
>>
>>
>>
>> We are mostly listening for broadcast packages, so we haven't noticed frames
>> out-of-order :-)
> 
> Okay, I have discussed with Marc before, this could be possible. You can test with two boards, one receive and another transmit.
>>
>>
>> I have checked this series, it comes out of suspend every time :-)
> 
> I am not quite understand, could you explain more, this patch cannot fix deadlock issue?

It fixes the deadlock issue :)
> 
> Best Regards,
> Joakim Zhang
>> /Sean
> 
