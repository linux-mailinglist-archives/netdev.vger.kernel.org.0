Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1CEC069B35B
	for <lists+netdev@lfdr.de>; Fri, 17 Feb 2023 20:51:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229601AbjBQTvb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Feb 2023 14:51:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229461AbjBQTva (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Feb 2023 14:51:30 -0500
Received: from smtp.smtpout.orange.fr (smtp-14.smtpout.orange.fr [80.12.242.14])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F00D9505DF
        for <netdev@vger.kernel.org>; Fri, 17 Feb 2023 11:51:28 -0800 (PST)
Received: from [192.168.1.18] ([86.243.2.178])
        by smtp.orange.fr with ESMTPA
        id T6lQpg4mYbhnbT6lQpVFTX; Fri, 17 Feb 2023 20:51:26 +0100
X-ME-Helo: [192.168.1.18]
X-ME-Auth: Y2hyaXN0b3BoZS5qYWlsbGV0QHdhbmFkb28uZnI=
X-ME-Date: Fri, 17 Feb 2023 20:51:26 +0100
X-ME-IP: 86.243.2.178
Message-ID: <af667999-c465-2814-3ca2-cdccfce72754@wanadoo.fr>
Date:   Fri, 17 Feb 2023 20:51:24 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH] wifi: wfx: Remove some dead code
Content-Language: fr, en-US
To:     =?UTF-8?B?SsOpcsO0bWUgUG91aWxsZXI=?= <jerome.pouiller@silabs.com>,
        Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org
References: <809c4a645c8d1306c0d256345515865c40ec731c.1676464422.git.christophe.jaillet@wanadoo.fr>
 <5176724.BZd2XUeKfp@pc-42>
From:   Christophe JAILLET <christophe.jaillet@wanadoo.fr>
In-Reply-To: <5176724.BZd2XUeKfp@pc-42>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Le 15/02/2023 à 14:23, Jérôme Pouiller a écrit :
> Hello Christophe,
> 
> On Wednesday 15 February 2023 13:34:37 CET Christophe JAILLET wrote:
>>
>> wait_for_completion_timeout() can not return a <0 value.
>> So simplify the logic and remove dead code.
>>
>> -ERESTARTSYS can not be returned by do_wait_for_common() for tasks with
>> TASK_UNINTERRUPTIBLE, which is the case for wait_for_completion_timeout()
>>
>> Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
>> ---
>>   drivers/net/wireless/silabs/wfx/main.c | 10 +++-------
>>   1 file changed, 3 insertions(+), 7 deletions(-)
>>
>> diff --git a/drivers/net/wireless/silabs/wfx/main.c b/drivers/net/wireless/silabs/wfx/main.c
>> index 6b9864e478ac..0b50f7058bbb 100644
>> --- a/drivers/net/wireless/silabs/wfx/main.c
>> +++ b/drivers/net/wireless/silabs/wfx/main.c
>> @@ -358,13 +358,9 @@ int wfx_probe(struct wfx_dev *wdev)
>>
>>          wfx_bh_poll_irq(wdev);
>>          err = wait_for_completion_timeout(&wdev->firmware_ready, 1 * HZ);
>> -       if (err <= 0) {
>> -               if (err == 0) {
>> -                       dev_err(wdev->dev, "timeout while waiting for startup indication\n");
>> -                       err = -ETIMEDOUT;
>> -               } else if (err == -ERESTARTSYS) {
>> -                       dev_info(wdev->dev, "probe interrupted by user\n");
> 
> This code is ran during modprobe/insmod. We would like to allow the user
> to interrupt (Ctrl+C) the probing if something is going wrong with the
> device.
> 
> So, the real issue is wait_for_completion_interruptible_timeout() should
> be used instead of wait_for_completion_timeout().

Hmmm, not that clear.

See commit 01088cd143a9.

Let me know if you prefer this patch as-is or if 01088cd143a9 should be 
reverted.

CJ

> 
> (By reading this code again, it also seems the test "if (err <= 0)" is
> useless)
> 
> 

