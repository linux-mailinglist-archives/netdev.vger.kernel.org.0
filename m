Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 38A65314962
	for <lists+netdev@lfdr.de>; Tue,  9 Feb 2021 08:19:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229691AbhBIHSx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Feb 2021 02:18:53 -0500
Received: from so15.mailgun.net ([198.61.254.15]:15710 "EHLO so15.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230034AbhBIHSi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 9 Feb 2021 02:18:38 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1612855095; h=Date: Message-Id: Cc: To: References:
 In-Reply-To: From: Subject: Content-Transfer-Encoding: MIME-Version:
 Content-Type: Sender; bh=mK5kpgAF6AMLuw5RtubhdeZQP/uo/1+WEDAN+fkDY9I=;
 b=IR7cZRTYlD6GYKkxX9ZmBl48/KN6yhKFtKmpgaFRZsvCLCbkn/0UmwIohRCI5hym6N6mBqcx
 1kL4dHgQY4kkThQ8rbz0JHfcR1xMDQaU6DPV50kCeqGD4oJTw3Ss/BRaXAG3s2YKTXQJ8kC0
 JzDUob20aQC+iDWOvH2S0wvmKl8=
X-Mailgun-Sending-Ip: 198.61.254.15
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n02.prod.us-west-2.postgun.com with SMTP id
 602237168e43a988b75f0fe0 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Tue, 09 Feb 2021 07:17:42
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id F35C0C43463; Tue,  9 Feb 2021 07:17:41 +0000 (UTC)
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
        by smtp.codeaurora.org (Postfix) with ESMTPSA id CC4ACC433CA;
        Tue,  9 Feb 2021 07:17:38 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org CC4ACC433CA
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] ath10k: Fix suspicious RCU usage warning in
 ath10k_wmi_tlv_parse_peer_stats_info()
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20210202134451.1.I0d2e83c42755671b7143504b62787fd06cd914ed@changeid>
References: <20210202134451.1.I0d2e83c42755671b7143504b62787fd06cd914ed@changeid>
To:     Anand K Mistry <amistry@google.com>
Cc:     ath10k@lists.infradead.org, Anand K Mistry <amistry@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Wen Gong <wgong@codeaurora.org>, linux-kernel@vger.kernel.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.5.2
Message-Id: <20210209071741.F35C0C43463@smtp.codeaurora.org>
Date:   Tue,  9 Feb 2021 07:17:41 +0000 (UTC)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Anand K Mistry <amistry@google.com> wrote:

> The ieee80211_find_sta_by_ifaddr call in
> ath10k_wmi_tlv_parse_peer_stats_info must be called while holding the
> RCU read lock. Otherwise, the following warning will be seen when RCU
> usage checking is enabled:
> 
> =============================
> WARNING: suspicious RCU usage
> 5.10.3 #8 Tainted: G        W
> -----------------------------
> include/linux/rhashtable.h:594 suspicious rcu_dereference_check() usage!
> 
> other info that might help us debug this:
> 
> rcu_scheduler_active = 2, debug_locks = 1
> no locks held by ksoftirqd/1/16.
> 
> stack backtrace:
> CPU: 1 PID: 16 Comm: ksoftirqd/1 Tainted: G        W         5.10.3 #8
> Hardware name: HP Grunt/Grunt, BIOS Google_Grunt.11031.104.0 09/05/2019
> Call Trace:
>  dump_stack+0xab/0x115
>  sta_info_hash_lookup+0x71/0x1e9 [mac80211]
>  ? lock_is_held_type+0xe6/0x12f
>  ? __kasan_kmalloc+0xfb/0x112
>  ieee80211_find_sta_by_ifaddr+0x12/0x61 [mac80211]
>  ath10k_wmi_tlv_parse_peer_stats_info+0xbd/0x10b [ath10k_core]
>  ath10k_wmi_tlv_iter+0x8b/0x1a1 [ath10k_core]
>  ? ath10k_wmi_tlv_iter+0x1a1/0x1a1 [ath10k_core]
>  ath10k_wmi_tlv_event_peer_stats_info+0x103/0x13b [ath10k_core]
>  ath10k_wmi_tlv_op_rx+0x722/0x80d [ath10k_core]
>  ath10k_htc_rx_completion_handler+0x16e/0x1d7 [ath10k_core]
>  ath10k_pci_process_rx_cb+0x116/0x22c [ath10k_pci]
>  ? ath10k_htc_process_trailer+0x332/0x332 [ath10k_core]
>  ? _raw_spin_unlock_irqrestore+0x34/0x61
>  ? lockdep_hardirqs_on+0x8e/0x12e
>  ath10k_ce_per_engine_service+0x55/0x74 [ath10k_core]
>  ath10k_ce_per_engine_service_any+0x76/0x84 [ath10k_core]
>  ath10k_pci_napi_poll+0x49/0x141 [ath10k_pci]
>  net_rx_action+0x11a/0x347
>  __do_softirq+0x2d3/0x539
>  run_ksoftirqd+0x4b/0x86
>  smpboot_thread_fn+0x1d0/0x2ab
>  ? cpu_report_death+0x7f/0x7f
>  kthread+0x189/0x191
>  ? cpu_report_death+0x7f/0x7f
>  ? kthread_blkcg+0x31/0x31
>  ret_from_fork+0x22/0x30
> 
> Fixes: 0f7cb26830a6e ("ath10k: add rx bitrate report for SDIO")
> Signed-off-by: Anand K Mistry <amistry@google.com>
> Signed-off-by: Kalle Valo <kvalo@codeaurora.org>

Patch applied to ath-next branch of ath.git, thanks.

2615e3cdbd9c ath10k: Fix suspicious RCU usage warning in ath10k_wmi_tlv_parse_peer_stats_info()

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20210202134451.1.I0d2e83c42755671b7143504b62787fd06cd914ed@changeid/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

