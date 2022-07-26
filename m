Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CDB59581581
	for <lists+netdev@lfdr.de>; Tue, 26 Jul 2022 16:38:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239296AbiGZOi2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jul 2022 10:38:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229530AbiGZOi0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Jul 2022 10:38:26 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 919E020BD5;
        Tue, 26 Jul 2022 07:38:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 39D3EB8167A;
        Tue, 26 Jul 2022 14:38:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7ABC5C433D6;
        Tue, 26 Jul 2022 14:38:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658846302;
        bh=cgZg+rhtv9wr0MSR6nX51BTfEgBAgbyS5aVLOMUs23M=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=PJPxEPfEIFg2xolAKB7coxbpIv0p8AB8FcsczpwMwAwjd9r8AR/s56M2qIEtRDQv1
         WsCWnBBIEL6Qo0dkC7pIxPucVrznY6KgQP1kTk4Nd+8E9OwFoDKtjQXtwVsFCRVBQJ
         F0tsUicHtyk4aa32KenTIJRx7wirDOaMdrQxPV0FGdL3Bs7HxrVNrsy8K8I1FxVjVx
         ik5c+Q9fCCwmAVELnqReWI5vdF5sDlR3Q3h+nqRG6Pmnmk9MlvuZBGXBIIThSaBlbe
         S5V3BeYjc3xDGS0wJug/RG0O7FCIAdzgsBIOSylDPQYueuI8LSl15kVa9TeIzQQnPb
         4mC9g3ZXvZorA==
From:   Kalle Valo <kvalo@kernel.org>
To:     Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc:     Johannes Berg <johannes@sipsolutions.net>,
        Toke =?utf-8?Q?H=C3=B8ilan?= =?utf-8?Q?d-J=C3=B8rgensen?= 
        <toke@kernel.org>, Felix Fietkau <nbd@nbd.name>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH v2] wifi: mac80211: do not abuse fq.lock in ieee80211_do_stop()
References: <9cc9b81d-75a3-3925-b612-9d0ad3cab82b@I-love.SAKURA.ne.jp>
        <165814567948.32602.9899358496438464723.kvalo@kernel.org>
        <9487e319-7ab4-995a-ddfd-67c4c701680c@I-love.SAKURA.ne.jp>
Date:   Tue, 26 Jul 2022 17:38:18 +0300
In-Reply-To: <9487e319-7ab4-995a-ddfd-67c4c701680c@I-love.SAKURA.ne.jp>
        (Tetsuo Handa's message of "Tue, 26 Jul 2022 15:55:35 +0900")
Message-ID: <87o7xcq6qt.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

(please don't top post, I manually fixed that)

Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp> writes:

> On 2022/07/18 21:01, Kalle Valo wrote:
>> Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp> wrote:
>>=20
>>> lockdep complains use of uninitialized spinlock at ieee80211_do_stop() =
[1],
>>> for commit f856373e2f31ffd3 ("wifi: mac80211: do not wake queues on a v=
if
>>> that is being stopped") guards clear_bit() using fq.lock even before
>>> fq_init() from ieee80211_txq_setup_flows() initializes this spinlock.
>>>
>>> According to discussion [2], Toke was not happy with expanding usage of
>>> fq.lock. Since __ieee80211_wake_txqs() is called under RCU read lock, we
>>> can instead use synchronize_rcu() for flushing ieee80211_wake_txqs().
>>>
>>> Link: https://syzkaller.appspot.com/bug?extid=3Deceab52db7c4b961e9d6 [1]
>>> Link: https://lkml.kernel.org/r/874k0zowh2.fsf@toke.dk [2]
>>> Reported-by: syzbot <syzbot+eceab52db7c4b961e9d6@syzkaller.appspotmail.=
com>
>>> Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
>>> Fixes: f856373e2f31ffd3 ("wifi: mac80211: do not wake queues on a vif t=
hat is being stopped")
>>> Tested-by: syzbot <syzbot+eceab52db7c4b961e9d6@syzkaller.appspotmail.co=
m>
>>> Acked-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@kernel.org>
>>=20
>> Patch applied to wireless-next.git, thanks.
>>=20
>> 3598cb6e1862 wifi: mac80211: do not abuse fq.lock in ieee80211_do_stop()
>
> Since this patch fixes a regression introduced in 5.19-rc7, can this patc=
h go to 5.19-final ?
>
> syzbot is failing to test linux.git for 12 days due to this regression.
> syzbot will fail to bisect new bugs found in the upcoming merge window
> if unable to test v5.19 due to this regression.

I took this to wireless-next as I didn't think there's enough time to
get this to v5.19 (and I only heard Linus' -rc8 plans after the fact).
So this will be in v5.20-rc1 and I recommend pushing this to a v5.19
stable release.

--=20
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatc=
hes
