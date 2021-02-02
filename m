Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 00C9930B5F4
	for <lists+netdev@lfdr.de>; Tue,  2 Feb 2021 04:44:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231447AbhBBDlr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Feb 2021 22:41:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231417AbhBBDln (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Feb 2021 22:41:43 -0500
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D986C06174A
        for <netdev@vger.kernel.org>; Mon,  1 Feb 2021 19:41:03 -0800 (PST)
Received: by mail-yb1-xb4a.google.com with SMTP id f127so22157853ybf.12
        for <netdev@vger.kernel.org>; Mon, 01 Feb 2021 19:41:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:message-id:mime-version:subject:from:to:cc
         :content-transfer-encoding;
        bh=D+oCaSH/egr+du/U15EDzXJujV6XfQaQ8BeRYeS+FOw=;
        b=Z2iGEcqXRzha0hs4uB18on6WXhNOiwH5oIuNWxO7+i9pFgG4yO5+PNFxSpdi2OX1we
         mejdIp3pPbvVGoWEQF+PhFNM6gKtNqSKTclDzgyIr0M4r25ZhZWlrk1+AwDAFFbmK7gd
         5Sr3tHstKgYdbZnTngG8XYBvXNTeToAFoq9H7+dF47qS6NC/pKY5lCR9kYqVNPx2eCKR
         6GMTSRnyu661BY4iIzYCW2+gUWl3J9KBu8REjzX7/kGgVjbwsjGvDQSbpbZ6icivZsMx
         SUT9OD6R9PyTP8VRC3MeM6jLrBUPgeA4KhypXyhaZO51v5/6gh8icG6yyz8pPbBmMGUm
         98fw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:message-id:mime-version:subject:from
         :to:cc:content-transfer-encoding;
        bh=D+oCaSH/egr+du/U15EDzXJujV6XfQaQ8BeRYeS+FOw=;
        b=IWdLjkbsXvFBhaVhziaZOkO1lxUrfZInu+f9PtdtaQl6zGyxGcBymStBKqTJAFkTd3
         LKe0JnYt5pcQy8CJwIFNG+qGSOUksldl9QywvY4IjLp/tudXPT3psUqedP+R7EDXgVxu
         lPegl7HsmsRSUPwuroz6/Te1zs97ZhZH5kecyVM5CO5vT098rpfm/ufI56TJ3pirppVh
         fykE8WSfQhPmuIi4UI3MX57rWFO7lV9BoDqoKqpufQOMLVdn74NijSgf0XFm37c6GskL
         ExKX3miP9I0SoalkfKti32T/b201EeSLHWBi7vfNInEW8cjAxr8r0dQl2PXrH8zwDAuM
         /mKw==
X-Gm-Message-State: AOAM532q6m5XqJ4naQXptVsdHQ3w1uFfmpwrKjBHT6e1ndDIhYBqXkBp
        cxFEyt679sLYyvLguMcCLIboohMBYfYE
X-Google-Smtp-Source: ABdhPJw2ETAX1hsONKJlzEjpJMMlOH2itMPuxoZlT4BvLRw3NBtE9/epg4w/92S2E6Cx0SVNqFt2xCUeCq7k
Sender: "amistry via sendgmr" <amistry@nandos.syd.corp.google.com>
X-Received: from nandos.syd.corp.google.com ([2401:fa00:9:14:243a:8f72:7104:7a64])
 (user=amistry job=sendgmr) by 2002:a25:2d43:: with SMTP id
 s3mr14022034ybe.33.1612237262751; Mon, 01 Feb 2021 19:41:02 -0800 (PST)
Date:   Tue,  2 Feb 2021 14:40:55 +1100
Message-Id: <20210202144033.1.I9e556f9fb1110d58c31d04a8a1293995fb8bb678@changeid>
Mime-Version: 1.0
X-Mailer: git-send-email 2.30.0.365.g02bc693789-goog
Subject: [PATCH] ath10k: Fix lockdep assertion warning in ath10k_sta_statistics
From:   Anand K Mistry <amistry@google.com>
To:     ath10k@lists.infradead.org
Cc:     Anand K Mistry <amistry@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        Wen Gong <wgong@codeaurora.org>, linux-kernel@vger.kernel.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

ath10k_debug_fw_stats_request just be called with conf_mutex held,
otherwise the following warning is seen when lock debugging is enabled:

WARNING: CPU: 0 PID: 793 at drivers/net/wireless/ath/ath10k/debug.c:357 ath=
10k_debug_fw_stats_request+0x12c/0x133 [ath10k_core]
Modules linked in: snd_hda_codec_hdmi designware_i2s snd_hda_intel snd_inte=
l_dspcfg snd_hda_codec i2c_piix4 snd_hwdep snd_hda_core acpi_als kfifo_buf =
industrialio snd_soc_max98357a snd_soc_adau7002 snd_soc_acp_da7219mx98357_m=
ach snd_soc_da7219 acp_audio_dma ccm xt_MASQUERADE fuse ath10k_pci ath10k_c=
ore lzo_rle ath lzo_compress mac80211 zram cfg80211 r8152 mii joydev
CPU: 0 PID: 793 Comm: wpa_supplicant Tainted: G        W         5.10.9 #5
Hardware name: HP Grunt/Grunt, BIOS Google_Grunt.11031.104.0 09/05/2019
RIP: 0010:ath10k_debug_fw_stats_request+0x12c/0x133 [ath10k_core]
Code: 1e bb a1 ff ff ff 4c 89 ef 48 c7 c6 d3 31 2e c0 89 da 31 c0 e8 bd f8 =
ff ff 89 d8 eb 02 31 c0 5b 41 5c 41 5d 41 5e 41 5f 5d c3 <0f> 0b e9 04 ff f=
f ff 0f 1f 44 00 00 55 48 89 e5 41 56 53 48 89 fb
RSP: 0018:ffffb2478099f7d0 EFLAGS: 00010246
RAX: 0000000000000000 RBX: ffff9e432700cce0 RCX: 11c85cfd6b8e3b00
RDX: ffff9e432700cce0 RSI: ffff9e43127c5668 RDI: ffff9e4318deddf0
RBP: ffffb2478099f7f8 R08: 0000000000000002 R09: 00000003fd7068cc
R10: ffffffffc01b2749 R11: ffffffffc029efaf R12: ffff9e432700c000
R13: ffff9e43127c33e0 R14: ffffb2478099f918 R15: ffff9e43127c33e0
FS:  00007f7ea48e2740(0000) GS:ffff9e432aa00000(0000) knlGS:000000000000000=
0
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 000059aa799ddf38 CR3: 0000000118de2000 CR4: 00000000001506f0
Call Trace:
 ath10k_sta_statistics+0x4d/0x270 [ath10k_core]
 sta_set_sinfo+0x1be/0xaec [mac80211]
 ieee80211_get_station+0x58/0x76 [mac80211]
 rdev_get_station+0xf1/0x11e [cfg80211]
 nl80211_get_station+0x7f/0x146 [cfg80211]
 genl_rcv_msg+0x32e/0x35e
 ? nl80211_stop_ap+0x19/0x19 [cfg80211]
 ? nl80211_get_station+0x146/0x146 [cfg80211]
 ? genl_rcv+0x19/0x36
 ? genl_rcv+0x36/0x36
 netlink_rcv_skb+0x89/0xfb
 genl_rcv+0x28/0x36
 netlink_unicast+0x169/0x23b
 netlink_sendmsg+0x38a/0x402
 sock_sendmsg+0x72/0x76
 ____sys_sendmsg+0x153/0x1cc
 ? copy_msghdr_from_user+0x5d/0x85
 ___sys_sendmsg+0x7c/0xb5
 ? lock_acquire+0x181/0x23d
 ? syscall_trace_enter+0x15e/0x160
 ? find_held_lock+0x3d/0xb2
 ? syscall_trace_enter+0x15e/0x160
 ? sched_clock_cpu+0x15/0xc6
 __sys_sendmsg+0x62/0x9a
 do_syscall_64+0x43/0x55
 entry_SYSCALL_64_after_hwframe+0x44/0xa9

Fixes: 4913e675630e ("ath10k: enable rx duration report default for wmi tlv=
")

Signed-off-by: Anand K Mistry <amistry@google.com>
---

 drivers/net/wireless/ath/ath10k/mac.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/a=
th/ath10k/mac.c
index 7d98250380ec..e815aab412d7 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -9117,7 +9117,9 @@ static void ath10k_sta_statistics(struct ieee80211_hw=
 *hw,
 	if (!ath10k_peer_stats_enabled(ar))
 		return;
=20
+	mutex_lock(&ar->conf_mutex);
 	ath10k_debug_fw_stats_request(ar);
+	mutex_unlock(&ar->conf_mutex);
=20
 	sinfo->rx_duration =3D arsta->rx_duration;
 	sinfo->filled |=3D BIT_ULL(NL80211_STA_INFO_RX_DURATION);
--=20
2.30.0.365.g02bc693789-goog

