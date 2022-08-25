Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A73D95A13B5
	for <lists+netdev@lfdr.de>; Thu, 25 Aug 2022 16:35:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241798AbiHYOfC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Aug 2022 10:35:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241861AbiHYOe5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Aug 2022 10:34:57 -0400
Received: from www262.sakura.ne.jp (www262.sakura.ne.jp [202.181.97.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE061DB9;
        Thu, 25 Aug 2022 07:34:55 -0700 (PDT)
Received: from fsav113.sakura.ne.jp (fsav113.sakura.ne.jp [27.133.134.240])
        by www262.sakura.ne.jp (8.15.2/8.15.2) with ESMTP id 27PEYXXY086332;
        Thu, 25 Aug 2022 23:34:33 +0900 (JST)
        (envelope-from penguin-kernel@I-love.SAKURA.ne.jp)
Received: from www262.sakura.ne.jp (202.181.97.72)
 by fsav113.sakura.ne.jp (F-Secure/fsigk_smtp/550/fsav113.sakura.ne.jp);
 Thu, 25 Aug 2022 23:34:33 +0900 (JST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/fsav113.sakura.ne.jp)
Received: from [192.168.1.9] (M106072142033.v4.enabler.ne.jp [106.72.142.33])
        (authenticated bits=0)
        by www262.sakura.ne.jp (8.15.2/8.15.2) with ESMTPSA id 27PEYXvK086329
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NO);
        Thu, 25 Aug 2022 23:34:33 +0900 (JST)
        (envelope-from penguin-kernel@I-love.SAKURA.ne.jp)
Message-ID: <1a0b4d24-6903-464f-7af0-65c9788545af@I-love.SAKURA.ne.jp>
Date:   Thu, 25 Aug 2022 23:34:32 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 6.3; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.1.2
Subject: Re: KMSAN: uninit-value in ath9k_htc_rx_msg
Content-Language: en-US
To:     Alexander Potapenko <glider@google.com>, phil@philpotter.co.uk
Cc:     ath9k-devel@qca.qualcomm.com, David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>
References: <000000000000c98a7f05ac744f53@google.com>
 <000000000000734fe705acb9f3a2@google.com>
 <a142d63c-7810-40ff-9c24-7160c63bafebn@googlegroups.com>
 <CAG_fn=U=Vfv3ymNM6W++sbivieQoUuXfAxsC9SsmdtQiTjSi8g@mail.gmail.com>
From:   Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
In-Reply-To: <CAG_fn=U=Vfv3ymNM6W++sbivieQoUuXfAxsC9SsmdtQiTjSi8g@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello.

I found that your patch was applied. But since the reproducer tested only 0 byte
case, I think that rejecting only less than sizeof(struct htc_frame_hdr) bytes
is not sufficient.

More complete patch with Ack from Toke is waiting at
https://lkml.kernel.org/r/7acfa1be-4b5c-b2ce-de43-95b0593fb3e5@I-love.SAKURA.ne.jp .

Please consider overriding with my version.

On 2022/08/24 22:30, Alexander Potapenko wrote:
> (adding back people originally CCed on the syzkaller bug.
> Unfortunately it isn't possible to reply to all in Google Groups)
> 
> On Wed, Aug 24, 2022 at 3:26 PM Alexander Potapenko wrote:
>> This bug bites us quite often on syzbot: https://syzkaller.appspot.com/bug?id=659ddf411502a2fe220c8f9be696d5a8d8db726e (17k crashes)
>> The patch below by phil@philpotter.co.uk (https://syzkaller.appspot.com/text?tag=Patch&x=173dcb51d00000) seems to fix the problem, but I have no idea what's going on there.
>>
>> ==============================================================
>> diff --git a/drivers/net/wireless/ath/ath9k/htc_hst.c b/drivers/net/wireless/ath/ath9k/htc_hst.c
>> index 510e61e97dbc..9dbfff7a388e 100644
>> --- a/drivers/net/wireless/ath/ath9k/htc_hst.c
>> +++ b/drivers/net/wireless/ath/ath9k/htc_hst.c
>> @@ -403,7 +403,7 @@ void ath9k_htc_rx_msg(struct htc_target *htc_handle,
>>      struct htc_endpoint *endpoint;
>>      __be16 *msg_id;
>>
>> -    if (!htc_handle || !skb)
>> +    if (!htc_handle || !skb || !pskb_may_pull(skb, sizeof(struct htc_frame_hdr)))
>>          return;
>>
>>      htc_hdr = (struct htc_frame_hdr *) skb->data;
>> ==============================================================
> 

> 

