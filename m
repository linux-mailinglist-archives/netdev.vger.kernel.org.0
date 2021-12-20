Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6462647B0A3
	for <lists+netdev@lfdr.de>; Mon, 20 Dec 2021 16:50:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236262AbhLTPuW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Dec 2021 10:50:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234029AbhLTPuV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Dec 2021 10:50:21 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CC82C061574;
        Mon, 20 Dec 2021 07:50:21 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2B09FB80ED8;
        Mon, 20 Dec 2021 15:50:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE1A7C36AE7;
        Mon, 20 Dec 2021 15:50:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1640015418;
        bh=v+9CtZXiA9EjjyEXdU5Lt4dfPsrm9XFJc1CwMwiHg+w=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=dTmnAW6cTWMPPIC6FAkL0TUCwK1/HpnFZ+RJ6KyEo5a90ig7SNwE2IroOzYrXiAS1
         d7tRPxlsQTVtzxx1zM4HZeHIINnNaXD4OdpeWZEGZDFOqWviHFspQ3yaBJ1H5XxZ14
         Z/Tt0cOVJTE3R7Yp6/ikTWapb/jPS6yPkEilGqtGx0l2uMlPX5a3WZvmDx3//DhxS/
         hd79FjAsSqURAAj6SCDXln1zylOn6CQ85e6vNhxnVBlhYjBMy+EpMMLc+iDjrxR+kh
         rv/lTsA6qdtZ+/J+7RUh+WZ4pRrAsDx/2PnPPB+HuJBO8g6T5iNXAtpU6lXiyVkMB+
         Z+7lHgV0j+BRA==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v2] ath9k_htc: Add a missing spin_lock_init()
From:   Kalle Valo <kvalo@kernel.org>
In-Reply-To: <20210728192533.18727-1-rajatasthana4@gmail.com>
References: <20210728192533.18727-1-rajatasthana4@gmail.com>
To:     Rajat Asthana <rajatasthana4@gmail.com>
Cc:     ath9k-devel@qca.qualcomm.com, kvalo@codeaurora.org,
        davem@davemloft.net, kuba@kernel.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Rajat Asthana <rajatasthana4@gmail.com>
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-ID: <164001541255.24859.9658352340660901028.kvalo@kernel.org>
Date:   Mon, 20 Dec 2021 15:50:16 +0000 (UTC)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Rajat Asthana <rajatasthana4@gmail.com> wrote:

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
> Signed-off-by: Kalle Valo <quic_kvalo@quicinc.com>

The lock is already initialised in ath9k_init_priv(), so now the same lock is
initialised twice. ath9k_init_wmi() is called before ath9k_init_priv(), so it
looks like we have a race somewhere.

Patch set to Changes Requested.

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20210728192533.18727-1-rajatasthana4@gmail.com/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

