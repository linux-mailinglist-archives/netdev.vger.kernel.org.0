Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C09E43D889B
	for <lists+netdev@lfdr.de>; Wed, 28 Jul 2021 09:11:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234241AbhG1HLl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Jul 2021 03:11:41 -0400
Received: from so254-9.mailgun.net ([198.61.254.9]:46065 "EHLO
        so254-9.mailgun.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233182AbhG1HLk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Jul 2021 03:11:40 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1627456299; h=Content-Type: MIME-Version: Message-ID:
 In-Reply-To: Date: References: Subject: Cc: To: From: Sender;
 bh=813rZu0o4l/+ANEq2PXBvIY1vR/Z/a/QCl8CyrWAoA4=; b=HygV4Qtf8hYjvXM5qp1I8L9QPYzeSyqHgxxjc8rzxr18pEdvHTAao/sSVFU2vkVBBybbJHl/
 qcTdyDl4vJAiy9nHVPjhzQgTtKfkT7Ae9BPRvs2ilXR0NUUacsD6qu6Py179PG0se1MzyO2G
 0szOrC0wiox7vSzwreFDJ4HQE90=
X-Mailgun-Sending-Ip: 198.61.254.9
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n04.prod.us-east-1.postgun.com with SMTP id
 6101032bb653fbdaddcb087e (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Wed, 28 Jul 2021 07:11:39
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 65AE7C43217; Wed, 28 Jul 2021 07:11:38 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=2.0 tests=ALL_TRUSTED,BAYES_00,SPF_FAIL
        autolearn=no autolearn_force=no version=3.4.0
Received: from tykki (tynnyri.adurom.net [51.15.11.48])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id E6312C433D3;
        Wed, 28 Jul 2021 07:11:35 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org E6312C433D3
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Rajat Asthana <rajatasthana4@gmail.com>
Cc:     ath9k-devel@qca.qualcomm.com, davem@davemloft.net, kuba@kernel.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ath9k_htc: Add a missing spin_lock_init()
References: <20210727214358.466397-1-rajatasthana4@gmail.com>
Date:   Wed, 28 Jul 2021 10:11:32 +0300
In-Reply-To: <20210727214358.466397-1-rajatasthana4@gmail.com> (Rajat
        Asthana's message of "Wed, 28 Jul 2021 03:13:58 +0530")
Message-ID: <87y29qgbff.fsf@codeaurora.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Rajat Asthana <rajatasthana4@gmail.com> writes:

> Syzkaller reported a lockdep warning on non-initialized spinlock:
>
> INFO: trying to register non-static key.
> The code is fine but needs lockdep annotation, or maybe
> you didn't initialize this object before use?
> turning off the locking correctness validator.
> CPU: 0 PID: 10 Comm: ksoftirqd/0 Not tainted 5.13.0-rc4-syzkaller #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
> Call Trace:
>  __dump_stack lib/dump_stack.c:79 [inline]
>  dump_stack+0x143/0x1db lib/dump_stack.c:120
>  assign_lock_key kernel/locking/lockdep.c:937 [inline]
>  register_lock_class+0x1077/0x1180 kernel/locking/lockdep.c:1249
>  __lock_acquire+0x102/0x5230 kernel/locking/lockdep.c:4781
>  lock_acquire kernel/locking/lockdep.c:5512 [inline]
>  lock_acquire+0x19d/0x700 kernel/locking/lockdep.c:5477
>  __raw_spin_lock_bh include/linux/spinlock_api_smp.h:135 [inline]
>  _raw_spin_lock_bh+0x2f/0x40 kernel/locking/spinlock.c:175
>  spin_lock_bh include/linux/spinlock.h:359 [inline]
>  ath9k_wmi_event_tasklet+0x231/0x3f0 drivers/net/wireless/ath/ath9k/wmi.c:172
>  tasklet_action_common.constprop.0+0x201/0x2e0 kernel/softirq.c:784
>  __do_softirq+0x1b0/0x944 kernel/softirq.c:559
>  run_ksoftirqd kernel/softirq.c:921 [inline]
>  run_ksoftirqd+0x21/0x50 kernel/softirq.c:913
>  smpboot_thread_fn+0x3ec/0x870 kernel/smpboot.c:165
>  kthread+0x38c/0x460 kernel/kthread.c:313
>  ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:294
>
> We missed a spin_lock_init() in ath9k_wmi_event_tasklet() when the wmi
> event is WMI_TXSTATUS_EVENTID. Placing this init here instead of
> ath9k_init_wmi() is fine mainly because we need this spinlock when the
> event is WMI_TXSTATUS_EVENTID and hence it should be initialized when it
> is needed.
>
> Signed-off-by: Rajat Asthana <rajatasthana4@gmail.com>
> ---
>  drivers/net/wireless/ath/ath9k/wmi.c | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/drivers/net/wireless/ath/ath9k/wmi.c b/drivers/net/wireless/ath/ath9k/wmi.c
> index fe29ad4b9023..446b7ca459df 100644
> --- a/drivers/net/wireless/ath/ath9k/wmi.c
> +++ b/drivers/net/wireless/ath/ath9k/wmi.c
> @@ -169,6 +169,7 @@ void ath9k_wmi_event_tasklet(struct tasklet_struct *t)
>  					     &wmi->drv_priv->fatal_work);
>  			break;
>  		case WMI_TXSTATUS_EVENTID:
> +			spin_lock_init(&priv->tx.tx_lock);
>  			spin_lock_bh(&priv->tx.tx_lock);
>  			if (priv->tx.flags & ATH9K_HTC_OP_TX_DRAIN) {
>  				spin_unlock_bh(&priv->tx.tx_lock);

This is not making sense to me. You need to elaborate in the commit log
a lot more why this is "fine". For example, what happens when there are
multiple WMI_TXSTATUS_EVENTID events?

Did you test this on a real device?

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
