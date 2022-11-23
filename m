Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2AF73636E88
	for <lists+netdev@lfdr.de>; Thu, 24 Nov 2022 00:46:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229452AbiKWXqX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Nov 2022 18:46:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229450AbiKWXqV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Nov 2022 18:46:21 -0500
Received: from www262.sakura.ne.jp (www262.sakura.ne.jp [202.181.97.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E477FAF0BC
        for <netdev@vger.kernel.org>; Wed, 23 Nov 2022 15:46:20 -0800 (PST)
Received: from fsav314.sakura.ne.jp (fsav314.sakura.ne.jp [153.120.85.145])
        by www262.sakura.ne.jp (8.15.2/8.15.2) with ESMTP id 2ANNjQJX038859;
        Thu, 24 Nov 2022 08:45:26 +0900 (JST)
        (envelope-from penguin-kernel@I-love.SAKURA.ne.jp)
Received: from www262.sakura.ne.jp (202.181.97.72)
 by fsav314.sakura.ne.jp (F-Secure/fsigk_smtp/550/fsav314.sakura.ne.jp);
 Thu, 24 Nov 2022 08:45:26 +0900 (JST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/fsav314.sakura.ne.jp)
Received: from [192.168.1.9] (M106072142033.v4.enabler.ne.jp [106.72.142.33])
        (authenticated bits=0)
        by www262.sakura.ne.jp (8.15.2/8.15.2) with ESMTPSA id 2ANNjQkd038852
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NO);
        Thu, 24 Nov 2022 08:45:26 +0900 (JST)
        (envelope-from penguin-kernel@I-love.SAKURA.ne.jp)
Message-ID: <a21b646a-385f-2907-fe9f-84ef341b22fb@I-love.SAKURA.ne.jp>
Date:   Thu, 24 Nov 2022 08:45:25 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 6.3; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [PATCH] sctp: relese sctp_stream_priorities at
 sctp_stream_outq_migrate()
Content-Language: en-US
To:     Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Cc:     syzbot <syzbot+29c402e56c4760763cc0@syzkaller.appspotmail.com>,
        syzkaller-bugs@googlegroups.com,
        Vlad Yasevich <vyasevich@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        linux-sctp@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org, pabeni@redhat.com
References: <000000000000e99e2705edb7d6cf@google.com>
 <c5ba2194-dbb6-586d-992d-9dfcd27062e7@I-love.SAKURA.ne.jp>
 <Y34mxTlLaRcR9d4z@t14s.localdomain>
From:   Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
In-Reply-To: <Y34mxTlLaRcR9d4z@t14s.localdomain>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2022/11/23 22:57, Marcelo Ricardo Leitner wrote:
> On Wed, Nov 23, 2022 at 07:36:00PM +0900, Tetsuo Handa wrote:
>> syzbot is reporting memory leak on sctp_stream_priorities [1], for
>> sctp_stream_outq_migrate() is resetting SCTP_SO(stream, i)->ext to NULL
>> without clearing SCTP_SO(new, i)->ext->prio_head list allocated by
>> sctp_sched_prio_new_head(). Since sctp_sched_prio_free() is too late to
>> clear if stream->outcnt was already shrunk or SCTP_SO(stream, i)->ext
>> was already NULL, add a callback for clearing that list before shrinking
>> stream->outcnt and/or resetting SCTP_SO(stream, i)->ext.
>>
>> Link: https://syzkaller.appspot.com/bug?exrid=29c402e56c4760763cc0 [1]
>> Reported-by: syzbot <syzbot+29c402e56c4760763cc0@syzkaller.appspotmail.com>
>> Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
>> ---
>> I can observe that the reproducer no longer reports memory leak. But
>> is this change correct and sufficient? Are there similar locations?
> 
> Thanks, but please see my email from yesterday. This is on the right
> way but a cleanup then is possible:
> https://lore.kernel.org/linux-sctp/Y31ct%2FlSXNTm9ev9@t14s.localdomain/

Oops, duplicated work again. Googling with this address did not hit, and
a thread at syzkaller-bugs group did not have your patch.

Please consider including syzbot+XXXXXXXXXXXXXXXXXXXX@syzkaller.appspotmail.com
and syzkaller-bugs@googlegroups.com into the Cc: list so that we can google for
your patch.

