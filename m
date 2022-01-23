Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A74CB4971F5
	for <lists+netdev@lfdr.de>; Sun, 23 Jan 2022 15:16:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236715AbiAWOQN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 Jan 2022 09:16:13 -0500
Received: from mo4-p01-ob.smtp.rzone.de ([81.169.146.167]:34295 "EHLO
        mo4-p01-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236705AbiAWOQM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 23 Jan 2022 09:16:12 -0500
X-Greylist: delayed 358 seconds by postgrey-1.27 at vger.kernel.org; Sun, 23 Jan 2022 09:16:12 EST
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1642947009;
    s=strato-dkim-0002; d=hartkopp.net;
    h=In-Reply-To:From:References:Cc:To:Subject:Date:Message-ID:Cc:Date:
    From:Subject:Sender;
    bh=J2oWFlT79qzBZRqQlQFG00cyNcRSTH+u8Kb4UO8Elqs=;
    b=QSn/57BB3ttJknsug9A2WZesRpKEt4hALpRIl/j0rMLlyS1O4J437ZLvy8fCRTu3tI
    rYrPXxnorv0Dw8vruD8sYKtehwXLqmgaJ7+23gsRZA+GaR6vR7YR0TnGfu1FjZS/zsjT
    C80F9cVm9wfoZV7fu0SGpDnRbpDtCAgHHe0GbdwawOpfEoDHNsLgONfuMnwM9uqm2d24
    BsjQRDN7n0LV+Oirvf3m5g9LRgazS94iEKsV5hmyyqwiitSfvo/fD8ggjXXYDkreZ0wo
    CbQMdRH1yL70Z7v/0uh1yQIF7xd6iLSzaLc/c5ymDt1u6Ew5MwHFcsUHNDWF3n3qd4gw
    tceg==
Authentication-Results: strato.com;
    dkim=none
X-RZG-AUTH: ":P2MHfkW8eP4Mre39l357AZT/I7AY/7nT2yrDxb8mjG14FZxedJy6qgO1qCHSa1GLptZHusx3hdd0DIgVuBOfXTKq7w=="
X-RZG-CLASS-ID: mo00
Received: from [IPV6:2a00:6020:1cfa:f900::bd7]
    by smtp.strato.de (RZmta 47.38.0 AUTH)
    with ESMTPSA id zaacbfy0NEA88WV
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
    Sun, 23 Jan 2022 15:10:08 +0100 (CET)
Message-ID: <f1e819b6-d37b-286f-85d5-9893a6fdb83e@hartkopp.net>
Date:   Sun, 23 Jan 2022 15:10:01 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH 4.14] can: bcm: fix UAF of bcm op
Content-Language: en-US
To:     Greg KH <gregkh@linuxfoundation.org>,
        Ziyang Xuan <william.xuanziyang@huawei.com>
Cc:     mkl@pengutronix.de, davem@davemloft.net, stable@vger.kernel.org,
        netdev@vger.kernel.org, linux-can@vger.kernel.org
References: <20220122102506.2898032-1-william.xuanziyang@huawei.com>
 <Yevc134xM9BDEyNd@kroah.com>
From:   Oliver Hartkopp <socketcan@hartkopp.net>
In-Reply-To: <Yevc134xM9BDEyNd@kroah.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 22.01.22 11:30, Greg KH wrote:
> On Sat, Jan 22, 2022 at 06:25:06PM +0800, Ziyang Xuan wrote:
>> Stopping tasklet and hrtimer rely on the active state of tasklet and
>> hrtimer sequentially in bcm_remove_op(), the op object will be freed
>> if they are all unactive. Assume the hrtimer timeout is short, the
>> hrtimer cb has been excuted after tasklet conditional judgment which
>> must be false after last round tasklet_kill() and before condition
>> hrtimer_active(), it is false when execute to hrtimer_active(). Bug
>> is triggerd, because the stopping action is end and the op object
>> will be freed, but the tasklet is scheduled. The resources of the op
>> object will occur UAF bug.
>>
>> Move hrtimer_cancel() behind tasklet_kill() and switch 'while () {...}'
>> to 'do {...} while ()' to fix the op UAF problem.
>>
>> Fixes: a06393ed0316 ("can: bcm: fix hrtimer/tasklet termination in bcm op removal")
>> Reported-by: syzbot+5ca851459ed04c778d1d@syzkaller.appspotmail.com
>> Cc: stable@vger.kernel.org
>> Signed-off-by: Ziyang Xuan <william.xuanziyang@huawei.com>
>> ---
>>   net/can/bcm.c | 20 ++++++++++----------
>>   1 file changed, 10 insertions(+), 10 deletions(-)
> 
> What is the git commit id of this change in Linus's tree?

Linus' tree has been fixed by removing the tasklet implementation and 
replacing it with a HRTIMER_MODE_SOFT approach here:

commit bf74aa86e111a ("can: bcm: switch timer to HRTIMER_MODE_SOFT and 
remove hrtimer_tasklet")

This patch from Ziyang Xuan fixes the 'old' tasklet implementation for 
'old' stable kernels that lack the HRTIMER_MODE_SOFT infrastructure.

Acked-by: Oliver Hartkopp <socketcan@hartkopp.net>

Best regards,
Oliver




> 
> thanks,
> 
> greg k-h
