Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 94F46580BF9
	for <lists+netdev@lfdr.de>; Tue, 26 Jul 2022 08:55:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237672AbiGZGzz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jul 2022 02:55:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232075AbiGZGzw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Jul 2022 02:55:52 -0400
Received: from www262.sakura.ne.jp (www262.sakura.ne.jp [202.181.97.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22485275CD;
        Mon, 25 Jul 2022 23:55:49 -0700 (PDT)
Received: from fsav119.sakura.ne.jp (fsav119.sakura.ne.jp [27.133.134.246])
        by www262.sakura.ne.jp (8.15.2/8.15.2) with ESMTP id 26Q6taPg088886;
        Tue, 26 Jul 2022 15:55:36 +0900 (JST)
        (envelope-from penguin-kernel@I-love.SAKURA.ne.jp)
Received: from www262.sakura.ne.jp (202.181.97.72)
 by fsav119.sakura.ne.jp (F-Secure/fsigk_smtp/550/fsav119.sakura.ne.jp);
 Tue, 26 Jul 2022 15:55:36 +0900 (JST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/fsav119.sakura.ne.jp)
Received: from [192.168.1.9] (M106072142033.v4.enabler.ne.jp [106.72.142.33])
        (authenticated bits=0)
        by www262.sakura.ne.jp (8.15.2/8.15.2) with ESMTPSA id 26Q6tZJX088883
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NO);
        Tue, 26 Jul 2022 15:55:35 +0900 (JST)
        (envelope-from penguin-kernel@I-love.SAKURA.ne.jp)
Message-ID: <9487e319-7ab4-995a-ddfd-67c4c701680c@I-love.SAKURA.ne.jp>
Date:   Tue, 26 Jul 2022 15:55:35 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 6.3; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH v2] wifi: mac80211: do not abuse fq.lock in
 ieee80211_do_stop()
Content-Language: en-US
To:     Kalle Valo <kvalo@kernel.org>
Cc:     Johannes Berg <johannes@sipsolutions.net>,
        =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@kernel.org>,
        Felix Fietkau <nbd@nbd.name>, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org
References: <9cc9b81d-75a3-3925-b612-9d0ad3cab82b@I-love.SAKURA.ne.jp>
 <165814567948.32602.9899358496438464723.kvalo@kernel.org>
From:   Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
In-Reply-To: <165814567948.32602.9899358496438464723.kvalo@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Since this patch fixes a regression introduced in 5.19-rc7, can this patch go to 5.19-final ?

syzbot is failing to test linux.git for 12 days due to this regression.
syzbot will fail to bisect new bugs found in the upcoming merge window
if unable to test v5.19 due to this regression.

On 2022/07/18 21:01, Kalle Valo wrote:
> Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp> wrote:
> 
>> lockdep complains use of uninitialized spinlock at ieee80211_do_stop() [1],
>> for commit f856373e2f31ffd3 ("wifi: mac80211: do not wake queues on a vif
>> that is being stopped") guards clear_bit() using fq.lock even before
>> fq_init() from ieee80211_txq_setup_flows() initializes this spinlock.
>>
>> According to discussion [2], Toke was not happy with expanding usage of
>> fq.lock. Since __ieee80211_wake_txqs() is called under RCU read lock, we
>> can instead use synchronize_rcu() for flushing ieee80211_wake_txqs().
>>
>> Link: https://syzkaller.appspot.com/bug?extid=eceab52db7c4b961e9d6 [1]
>> Link: https://lkml.kernel.org/r/874k0zowh2.fsf@toke.dk [2]
>> Reported-by: syzbot <syzbot+eceab52db7c4b961e9d6@syzkaller.appspotmail.com>
>> Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
>> Fixes: f856373e2f31ffd3 ("wifi: mac80211: do not wake queues on a vif that is being stopped")
>> Tested-by: syzbot <syzbot+eceab52db7c4b961e9d6@syzkaller.appspotmail.com>
>> Acked-by: Toke Høiland-Jørgensen <toke@kernel.org>
> 
> Patch applied to wireless-next.git, thanks.
> 
> 3598cb6e1862 wifi: mac80211: do not abuse fq.lock in ieee80211_do_stop()
> 

