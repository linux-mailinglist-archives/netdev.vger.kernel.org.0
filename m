Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E1943D9EE9
	for <lists+netdev@lfdr.de>; Thu, 29 Jul 2021 09:42:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234816AbhG2HmN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Jul 2021 03:42:13 -0400
Received: from m43-7.mailgun.net ([69.72.43.7]:18085 "EHLO m43-7.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234686AbhG2HmL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 29 Jul 2021 03:42:11 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1627544529; h=Content-Type: MIME-Version: Message-ID:
 In-Reply-To: Date: References: Subject: Cc: To: From: Sender;
 bh=fww5ogjd817pxnS7aQC2gFqywD6P7w10xRuVy1Mu8aU=; b=pkIrDFXOqdp0GQ7VJyei0YOx0saBQAw0xxq1wqLjKUblGeYYPvO8qyaDNlPy6foleiHP0yS2
 jecnRq+8B+AaSW8QEct/ND/YeDocRbmapKRlcTWsXvWYtuU8i0rcKDAfYaiUQQlRG6VEatjb
 yfhzVWvcFUpADKwL2WooW7q/OwU=
X-Mailgun-Sending-Ip: 69.72.43.7
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n01.prod.us-east-1.postgun.com with SMTP id
 61025bc24815712f3a9202a0 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Thu, 29 Jul 2021 07:41:54
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 1C960C433D3; Thu, 29 Jul 2021 07:41:54 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=2.0 tests=ALL_TRUSTED,BAYES_00,SPF_FAIL
        autolearn=no autolearn_force=no version=3.4.0
Received: from tykki (tynnyri.adurom.net [51.15.11.48])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id C0526C433D3;
        Thu, 29 Jul 2021 07:41:51 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org C0526C433D3
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Rajat Asthana <rajatasthana4@gmail.com>
Cc:     ath9k-devel@qca.qualcomm.com, davem@davemloft.net, kuba@kernel.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] ath9k_htc: Add a missing spin_lock_init()
References: <738fa8cc-c9c4-66c1-e2ee-fe02caa7ef63@gmail.com>
        <20210728192533.18727-1-rajatasthana4@gmail.com>
Date:   Thu, 29 Jul 2021 10:41:49 +0300
In-Reply-To: <20210728192533.18727-1-rajatasthana4@gmail.com> (Rajat Asthana's
        message of "Thu, 29 Jul 2021 00:55:33 +0530")
Message-ID: <87h7gdftxe.fsf@codeaurora.org>
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
> event is WMI_TXSTATUS_EVENTID. So, add a spin_lock_init() in
> ath9k_init_wmi().
>
> Signed-off-by: Rajat Asthana <rajatasthana4@gmail.com>

I assume this version is also not tested on a real device. Can someone
review and/or test this, please?

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
