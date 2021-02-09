Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7DF3E314964
	for <lists+netdev@lfdr.de>; Tue,  9 Feb 2021 08:22:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230194AbhBIHTT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Feb 2021 02:19:19 -0500
Received: from so15.mailgun.net ([198.61.254.15]:32156 "EHLO so15.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229752AbhBIHTL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 9 Feb 2021 02:19:11 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1612855127; h=Date: Message-Id: Cc: To: References:
 In-Reply-To: From: Subject: Content-Transfer-Encoding: MIME-Version:
 Content-Type: Sender; bh=Tz8B3SKK8X3XicV4RNnbjFdYo4FlBMTms7jwtNxn2o0=;
 b=bLpHmkdG6pIRjdKOcK24NIKDT8GWRufXhx93W4tDnn9/RAK89u7P+OPSvH0gWoGyxzyiZZMs
 D2QZy50pXBaM8PLmFzNaRiPQ734wQaYevluUYum5rXNRrwA/oKSObS5vJojTlmDF751oVB5T
 CXqOvuQPOV/m+WmSqJpzIbh9148=
X-Mailgun-Sending-Ip: 198.61.254.15
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n01.prod.us-west-2.postgun.com with SMTP id
 6022373a4bd23a05ae3c756a (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Tue, 09 Feb 2021 07:18:18
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 3513DC43463; Tue,  9 Feb 2021 07:18:18 +0000 (UTC)
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
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 5A89CC433CA;
        Tue,  9 Feb 2021 07:18:15 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 5A89CC433CA
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] ath10k: Fix lockdep assertion warning in
 ath10k_sta_statistics
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20210202144033.1.I9e556f9fb1110d58c31d04a8a1293995fb8bb678@changeid>
References: <20210202144033.1.I9e556f9fb1110d58c31d04a8a1293995fb8bb678@changeid>
To:     Anand K Mistry <amistry@google.com>
Cc:     ath10k@lists.infradead.org, Anand K Mistry <amistry@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Wen Gong <wgong@codeaurora.org>, linux-kernel@vger.kernel.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.5.2
Message-Id: <20210209071818.3513DC43463@smtp.codeaurora.org>
Date:   Tue,  9 Feb 2021 07:18:18 +0000 (UTC)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Anand K Mistry <amistry@google.com> wrote:

> ath10k_debug_fw_stats_request just be called with conf_mutex held,
> otherwise the following warning is seen when lock debugging is enabled:
> 
> WARNING: CPU: 0 PID: 793 at drivers/net/wireless/ath/ath10k/debug.c:357 ath10k_debug_fw_stats_request+0x12c/0x133 [ath10k_core]
> Modules linked in: snd_hda_codec_hdmi designware_i2s snd_hda_intel snd_intel_dspcfg snd_hda_codec i2c_piix4 snd_hwdep snd_hda_core acpi_als kfifo_buf industrialio snd_soc_max98357a snd_soc_adau7002 snd_soc_acp_da7219mx98357_mach snd_soc_da7219 acp_audio_dma ccm xt_MASQUERADE fuse ath10k_pci ath10k_core lzo_rle ath lzo_compress mac80211 zram cfg80211 r8152 mii joydev
> CPU: 0 PID: 793 Comm: wpa_supplicant Tainted: G        W         5.10.9 #5
> Hardware name: HP Grunt/Grunt, BIOS Google_Grunt.11031.104.0 09/05/2019
> RIP: 0010:ath10k_debug_fw_stats_request+0x12c/0x133 [ath10k_core]
> Code: 1e bb a1 ff ff ff 4c 89 ef 48 c7 c6 d3 31 2e c0 89 da 31 c0 e8 bd f8 ff ff 89 d8 eb 02 31 c0 5b 41 5c 41 5d 41 5e 41 5f 5d c3 <0f> 0b e9 04 ff ff ff 0f 1f 44 00 00 55 48 89 e5 41 56 53 48 89 fb
> RSP: 0018:ffffb2478099f7d0 EFLAGS: 00010246
> RAX: 0000000000000000 RBX: ffff9e432700cce0 RCX: 11c85cfd6b8e3b00
> RDX: ffff9e432700cce0 RSI: ffff9e43127c5668 RDI: ffff9e4318deddf0
> RBP: ffffb2478099f7f8 R08: 0000000000000002 R09: 00000003fd7068cc
> R10: ffffffffc01b2749 R11: ffffffffc029efaf R12: ffff9e432700c000
> R13: ffff9e43127c33e0 R14: ffffb2478099f918 R15: ffff9e43127c33e0
> FS:  00007f7ea48e2740(0000) GS:ffff9e432aa00000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 000059aa799ddf38 CR3: 0000000118de2000 CR4: 00000000001506f0
> Call Trace:
>  ath10k_sta_statistics+0x4d/0x270 [ath10k_core]
>  sta_set_sinfo+0x1be/0xaec [mac80211]
>  ieee80211_get_station+0x58/0x76 [mac80211]
>  rdev_get_station+0xf1/0x11e [cfg80211]
>  nl80211_get_station+0x7f/0x146 [cfg80211]
>  genl_rcv_msg+0x32e/0x35e
>  ? nl80211_stop_ap+0x19/0x19 [cfg80211]
>  ? nl80211_get_station+0x146/0x146 [cfg80211]
>  ? genl_rcv+0x19/0x36
>  ? genl_rcv+0x36/0x36
>  netlink_rcv_skb+0x89/0xfb
>  genl_rcv+0x28/0x36
>  netlink_unicast+0x169/0x23b
>  netlink_sendmsg+0x38a/0x402
>  sock_sendmsg+0x72/0x76
>  ____sys_sendmsg+0x153/0x1cc
>  ? copy_msghdr_from_user+0x5d/0x85
>  ___sys_sendmsg+0x7c/0xb5
>  ? lock_acquire+0x181/0x23d
>  ? syscall_trace_enter+0x15e/0x160
>  ? find_held_lock+0x3d/0xb2
>  ? syscall_trace_enter+0x15e/0x160
>  ? sched_clock_cpu+0x15/0xc6
>  __sys_sendmsg+0x62/0x9a
>  do_syscall_64+0x43/0x55
>  entry_SYSCALL_64_after_hwframe+0x44/0xa9
> 
> Fixes: 4913e675630e ("ath10k: enable rx duration report default for wmi tlv")
> Signed-off-by: Anand K Mistry <amistry@google.com>
> Signed-off-by: Kalle Valo <kvalo@codeaurora.org>

Patch applied to ath-next branch of ath.git, thanks.

7df28718928d ath10k: Fix lockdep assertion warning in ath10k_sta_statistics

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20210202144033.1.I9e556f9fb1110d58c31d04a8a1293995fb8bb678@changeid/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

