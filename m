Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EF179578172
	for <lists+netdev@lfdr.de>; Mon, 18 Jul 2022 14:01:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234531AbiGRMB1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jul 2022 08:01:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229535AbiGRMBZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Jul 2022 08:01:25 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A75422BC2;
        Mon, 18 Jul 2022 05:01:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 00563613FB;
        Mon, 18 Jul 2022 12:01:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECD77C341C0;
        Mon, 18 Jul 2022 12:01:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658145683;
        bh=59TfTKomQWQEdpvtlqBGTvgXy++6OxNy3oyk20gvWp8=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=D0Ez+R15G12c78ymc1Dd+Mjh+PXxhQGk8EXYIST6x0n+ltfTXd7xXtgqMKevzTxiS
         G5UpCoqfdYSTSPNpfnK+ILjDjkr2QTKjNjFGbNueNeLUC2eeoyBC3SoUJZa2B9+xwM
         P4RQSmvZ2p9Ai038pWXJfBbB++xm7nTVSKVMLVkVmMSAO5+duTu2FJCcJhdk88COqB
         uRB7FflZBjFt+EkXnRpfVpJ2GXq/O5dqnaSJRfgN3nomymw9icNgGc3JJDx+u51VgQ
         unLvcKyBC+KyuYddLhQsj96tdx4krQnjz25CpT7gStwpPrCxXpcHlWofO/ziRt40G0
         SVIRuxvyH9MoQ==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2] wifi: mac80211: do not abuse fq.lock in
 ieee80211_do_stop()
From:   Kalle Valo <kvalo@kernel.org>
In-Reply-To: <9cc9b81d-75a3-3925-b612-9d0ad3cab82b@I-love.SAKURA.ne.jp>
References: <9cc9b81d-75a3-3925-b612-9d0ad3cab82b@I-love.SAKURA.ne.jp>
To:     Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc:     Johannes Berg <johannes@sipsolutions.net>,
        =?utf-8?q?Toke_H=C3=B8iland-J?= =?utf-8?q?=C3=B8rgensen?= 
        <toke@kernel.org>, Felix Fietkau <nbd@nbd.name>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
User-Agent: pwcli/0.1.1-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-ID: <165814567948.32602.9899358496438464723.kvalo@kernel.org>
Date:   Mon, 18 Jul 2022 12:01:21 +0000 (UTC)
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp> wrote:

> lockdep complains use of uninitialized spinlock at ieee80211_do_stop() [1],
> for commit f856373e2f31ffd3 ("wifi: mac80211: do not wake queues on a vif
> that is being stopped") guards clear_bit() using fq.lock even before
> fq_init() from ieee80211_txq_setup_flows() initializes this spinlock.
> 
> According to discussion [2], Toke was not happy with expanding usage of
> fq.lock. Since __ieee80211_wake_txqs() is called under RCU read lock, we
> can instead use synchronize_rcu() for flushing ieee80211_wake_txqs().
> 
> Link: https://syzkaller.appspot.com/bug?extid=eceab52db7c4b961e9d6 [1]
> Link: https://lkml.kernel.org/r/874k0zowh2.fsf@toke.dk [2]
> Reported-by: syzbot <syzbot+eceab52db7c4b961e9d6@syzkaller.appspotmail.com>
> Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
> Fixes: f856373e2f31ffd3 ("wifi: mac80211: do not wake queues on a vif that is being stopped")
> Tested-by: syzbot <syzbot+eceab52db7c4b961e9d6@syzkaller.appspotmail.com>
> Acked-by: Toke Høiland-Jørgensen <toke@kernel.org>

Patch applied to wireless-next.git, thanks.

3598cb6e1862 wifi: mac80211: do not abuse fq.lock in ieee80211_do_stop()

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/9cc9b81d-75a3-3925-b612-9d0ad3cab82b@I-love.SAKURA.ne.jp/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

