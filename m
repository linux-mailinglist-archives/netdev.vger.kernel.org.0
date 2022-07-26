Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5CE555815F0
	for <lists+netdev@lfdr.de>; Tue, 26 Jul 2022 17:05:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239510AbiGZPF1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jul 2022 11:05:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239515AbiGZPFW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Jul 2022 11:05:22 -0400
Received: from dispatch1-us1.ppe-hosted.com (dispatch1-us1.ppe-hosted.com [148.163.129.52])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9982F65FB;
        Tue, 26 Jul 2022 08:05:20 -0700 (PDT)
X-Virus-Scanned: Proofpoint Essentials engine
Received: from mx1-us1.ppe-hosted.com (unknown [10.7.66.134])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id DD6621C0094;
        Tue, 26 Jul 2022 15:05:14 +0000 (UTC)
Received: from mail3.candelatech.com (mail2.candelatech.com [208.74.158.173])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id 22F14680095;
        Tue, 26 Jul 2022 15:05:13 +0000 (UTC)
Received: from [192.168.100.195] (50-251-239-81-static.hfc.comcastbusiness.net [50.251.239.81])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail3.candelatech.com (Postfix) with ESMTPSA id 2FC5713C2B0;
        Tue, 26 Jul 2022 08:05:13 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mail3.candelatech.com 2FC5713C2B0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=candelatech.com;
        s=default; t=1658847913;
        bh=DEERnH2hjNi0X6IYykoN5SMcoGES5UGGCHHyy0q4eKE=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=KYvf678X5F2q3eqhAPbUFAyupYfrm92qMt6/pHuglOq47Ybp1XOL1uZdnCmQBv9oQ
         ufTjHwYCI3TAe3vJFcl5PT3uq8Mvc03UcCwUdJyhHac8yMRToysdwJELdImqKo+8PP
         HzKcmnQKclPDz+5QPowEUgNIZW2f+HIgFMTJcHRU=
Subject: Re: [PATCH v2] wifi: mac80211: do not abuse fq.lock in
 ieee80211_do_stop()
To:     Kalle Valo <kvalo@kernel.org>,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc:     Johannes Berg <johannes@sipsolutions.net>,
        =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@kernel.org>,
        Felix Fietkau <nbd@nbd.name>, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org
References: <9cc9b81d-75a3-3925-b612-9d0ad3cab82b@I-love.SAKURA.ne.jp>
 <165814567948.32602.9899358496438464723.kvalo@kernel.org>
 <9487e319-7ab4-995a-ddfd-67c4c701680c@I-love.SAKURA.ne.jp>
 <87o7xcq6qt.fsf@kernel.org>
From:   Ben Greear <greearb@candelatech.com>
Organization: Candela Technologies
Message-ID: <df9efa23-e729-d1d0-b66f-248d7ae67c60@candelatech.com>
Date:   Tue, 26 Jul 2022 08:05:12 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <87o7xcq6qt.fsf@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-MDID: 1658847915-YS-IlGmw5TkY
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/26/22 7:38 AM, Kalle Valo wrote:
> (please don't top post, I manually fixed that)
> 
> Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp> writes:
> 
>> On 2022/07/18 21:01, Kalle Valo wrote:
>>> Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp> wrote:
>>>
>>>> lockdep complains use of uninitialized spinlock at ieee80211_do_stop() [1],
>>>> for commit f856373e2f31ffd3 ("wifi: mac80211: do not wake queues on a vif
>>>> that is being stopped") guards clear_bit() using fq.lock even before
>>>> fq_init() from ieee80211_txq_setup_flows() initializes this spinlock.
>>>>
>>>> According to discussion [2], Toke was not happy with expanding usage of
>>>> fq.lock. Since __ieee80211_wake_txqs() is called under RCU read lock, we
>>>> can instead use synchronize_rcu() for flushing ieee80211_wake_txqs().
>>>>
>>>> Link: https://syzkaller.appspot.com/bug?extid=eceab52db7c4b961e9d6 [1]
>>>> Link: https://lkml.kernel.org/r/874k0zowh2.fsf@toke.dk [2]
>>>> Reported-by: syzbot <syzbot+eceab52db7c4b961e9d6@syzkaller.appspotmail.com>
>>>> Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
>>>> Fixes: f856373e2f31ffd3 ("wifi: mac80211: do not wake queues on a vif that is being stopped")
>>>> Tested-by: syzbot <syzbot+eceab52db7c4b961e9d6@syzkaller.appspotmail.com>
>>>> Acked-by: Toke Høiland-Jørgensen <toke@kernel.org>
>>>
>>> Patch applied to wireless-next.git, thanks.
>>>
>>> 3598cb6e1862 wifi: mac80211: do not abuse fq.lock in ieee80211_do_stop()
>>
>> Since this patch fixes a regression introduced in 5.19-rc7, can this patch go to 5.19-final ?
>>
>> syzbot is failing to test linux.git for 12 days due to this regression.
>> syzbot will fail to bisect new bugs found in the upcoming merge window
>> if unable to test v5.19 due to this regression.
> 
> I took this to wireless-next as I didn't think there's enough time to
> get this to v5.19 (and I only heard Linus' -rc8 plans after the fact).
> So this will be in v5.20-rc1 and I recommend pushing this to a v5.19
> stable release.

Would it be worth reverting the patch that broke things until the first stable 5.19.x
tree then?  Seems lame to ship an official kernel with a known bug like this.

Thanks,
Ben


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

