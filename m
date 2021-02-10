Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 567ED3160BC
	for <lists+netdev@lfdr.de>; Wed, 10 Feb 2021 09:14:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233916AbhBJIOU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Feb 2021 03:14:20 -0500
Received: from so15.mailgun.net ([198.61.254.15]:44819 "EHLO so15.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233910AbhBJIOI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 10 Feb 2021 03:14:08 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1612944830; h=Date: Message-Id: Cc: To: References:
 In-Reply-To: From: Subject: Content-Transfer-Encoding: MIME-Version:
 Content-Type: Sender; bh=IRzUsolklWJ8q/rjQMpMiYe3i/nQFmXbBRtsW+ljWFg=;
 b=SgUDLdaTdZico2FB+tnws+kEJ1idPfJWbqjyiRYL8fycozmtRtTKUzjwUJyGtFApNyfQf7wL
 BtPu0hPkofQf+qJ+Mv6LBlA8ozR0Juq+ma+5mb4zutro4DR/etC/o7gP8+i3Y2ctDnywdSar
 9e/KYXhj0owx870li2SH6v6MRUU=
X-Mailgun-Sending-Ip: 198.61.254.15
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n04.prod.us-west-2.postgun.com with SMTP id
 602395a034db06ef79e7d2bd (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Wed, 10 Feb 2021 08:13:20
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 25BBDC43462; Wed, 10 Feb 2021 08:13:20 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=2.0 tests=ALL_TRUSTED,BAYES_00,
        MISSING_DATE,MISSING_MID,SPF_FAIL,URIBL_BLOCKED autolearn=no
        autolearn_force=no version=3.4.0
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 78FE0C433CA;
        Wed, 10 Feb 2021 08:13:17 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 78FE0C433CA
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH 2/5] ath10k: fix WARNING: suspicious RCU usage
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <23a1333dfb0367cc69e7177a2e373df0b6d42980.1612915444.git.skhan@linuxfoundation.org>
References: <23a1333dfb0367cc69e7177a2e373df0b6d42980.1612915444.git.skhan@linuxfoundation.org>
To:     Shuah Khan <skhan@linuxfoundation.org>
Cc:     davem@davemloft.net, kuba@kernel.org,
        Shuah Khan <skhan@linuxfoundation.org>,
        ath10k@lists.infradead.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.5.2
Message-Id: <20210210081320.25BBDC43462@smtp.codeaurora.org>
Date:   Wed, 10 Feb 2021 08:13:20 +0000 (UTC)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Shuah Khan <skhan@linuxfoundation.org> wrote:

> ieee80211_find_sta_by_ifaddr() must be called under the RCU lock and
> the resulting pointer is only valid under RCU lock as well.
> 
> Fix ath10k_wmi_tlv_parse_peer_stats_info() to hold RCU lock before it
> calls ieee80211_find_sta_by_ifaddr() and release it when the resulting
> pointer is no longer needed. The log below shows the problem.
> 
> While at it, fix ath10k_wmi_tlv_op_pull_peer_stats_info() to do the same.
> 
> =============================
> WARNING: suspicious RCU usage
> 5.11.0-rc7+ #20 Tainted: G        W
> -----------------------------
> include/linux/rhashtable.h:594 suspicious rcu_dereference_check() usage!
> other info that might help us debug this:
>                rcu_scheduler_active = 2, debug_locks = 1
> no locks held by ksoftirqd/5/44.
> 
> stack backtrace:
> CPU: 5 PID: 44 Comm: ksoftirqd/5 Tainted: G        W         5.11.0-rc7+ #20
> Hardware name: LENOVO 10VGCTO1WW/3130, BIOS M1XKT45A 08/21/2019
> Call Trace:
>  dump_stack+0x7d/0x9f
>  lockdep_rcu_suspicious+0xdb/0xe5
>  __rhashtable_lookup+0x1eb/0x260 [mac80211]
>  ieee80211_find_sta_by_ifaddr+0x5b/0xc0 [mac80211]
>  ath10k_wmi_tlv_parse_peer_stats_info+0x3e/0x90 [ath10k_core]
>  ath10k_wmi_tlv_iter+0x6a/0xc0 [ath10k_core]
>  ? ath10k_wmi_tlv_op_pull_mgmt_tx_bundle_compl_ev+0xe0/0xe0 [ath10k_core]
>  ath10k_wmi_tlv_op_rx+0x5da/0xda0 [ath10k_core]
>  ? trace_hardirqs_on+0x54/0xf0
>  ? ath10k_ce_completed_recv_next+0x4e/0x60 [ath10k_core]
>  ath10k_wmi_process_rx+0x1d/0x40 [ath10k_core]
>  ath10k_htc_rx_completion_handler+0x115/0x180 [ath10k_core]
>  ath10k_pci_process_rx_cb+0x149/0x1b0 [ath10k_pci]
>  ? ath10k_htc_process_trailer+0x2d0/0x2d0 [ath10k_core]
>  ? ath10k_pci_sleep.part.0+0x6a/0x80 [ath10k_pci]
>  ath10k_pci_htc_rx_cb+0x15/0x20 [ath10k_pci]
>  ath10k_ce_per_engine_service+0x61/0x80 [ath10k_core]
>  ath10k_ce_per_engine_service_any+0x7d/0xa0 [ath10k_core]
>  ath10k_pci_napi_poll+0x48/0x120 [ath10k_pci]
>  net_rx_action+0x136/0x500
>  __do_softirq+0xc6/0x459
>  ? smpboot_thread_fn+0x2b/0x1f0
>  run_ksoftirqd+0x2b/0x60
>  smpboot_thread_fn+0x116/0x1f0
>  kthread+0x14b/0x170
>  ? smpboot_register_percpu_thread+0xe0/0xe0
>  ? __kthread_bind_mask+0x70/0x70
>  ret_from_fork+0x22/0x30
> 
> Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>

Unlucky timing also on this one, it conflicts with a patch I applied yesterday:

https://git.kernel.org/pub/scm/linux/kernel/git/kvalo/ath.git/commit/?h=ath-next&id=2615e3cdbd9c0e864f5906279c952a309871d225

Can you redo the patch to only change ath10k_wmi_event_tdls_peer()?

error: patch failed: drivers/net/wireless/ath/ath10k/wmi-tlv.c:240
error: drivers/net/wireless/ath/ath10k/wmi-tlv.c: patch does not apply
stg import: Diff does not apply cleanly

Patch set to Changes Requested.

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/23a1333dfb0367cc69e7177a2e373df0b6d42980.1612915444.git.skhan@linuxfoundation.org/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

