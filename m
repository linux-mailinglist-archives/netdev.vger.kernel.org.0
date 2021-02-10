Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB4A9315B8B
	for <lists+netdev@lfdr.de>; Wed, 10 Feb 2021 01:46:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234529AbhBJApw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Feb 2021 19:45:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233588AbhBJAnW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Feb 2021 19:43:22 -0500
Received: from mail-ot1-x32f.google.com (mail-ot1-x32f.google.com [IPv6:2607:f8b0:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68441C06178B
        for <netdev@vger.kernel.org>; Tue,  9 Feb 2021 16:42:31 -0800 (PST)
Received: by mail-ot1-x32f.google.com with SMTP id d7so279900otq.6
        for <netdev@vger.kernel.org>; Tue, 09 Feb 2021 16:42:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=cI1Wn7QQuF0sK59lLixArXYXLfpnIwJV8oZPdAl0F9I=;
        b=DIvvnk6wC8ONJvFq9cTGdR3t5x/Tc4iGsaCj21MPN2ATDuZtlI7MnoRCkXsx8u/A6F
         XL71KEb2gHg8vMfwwrz1WlOqPT0W8csrMcnpvBDOGvQFyFYltgo08+oifi56gbd0Yh0b
         miKFg7PFvi0WjKFK4TORSVojMT39LF1llklBg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=cI1Wn7QQuF0sK59lLixArXYXLfpnIwJV8oZPdAl0F9I=;
        b=cKqYAd6sF2sot/LWxuJVe9vnSwb84mC6JawcHV71E8n30fto1sZxk9rkEFGHCmQRby
         OFa9jUGmePXUOSLYZXR+tF28dWdK1XtjYVHhrgKevBgzpns2vbBxxuKImbRO8aYH+INr
         gt7egw9bMYGI8hGpEiuRVaW/3aqSuHLgVAhbHxuw4jty4oQJI9E9B9jpfvHGT7XjBxHf
         DD/R5dDx/uxnIGyfwt1Hsq+G6M+R6iVhx0bgoUpKtDQh4vIxfahZrX6dk6v2uzrNi+l6
         dhKpaZxDIYNrlwA7I5HtK+FrnZqLWhro9P30FRDXyXejHeGQV1HpzQyw/sP+ohB3WKV0
         dYtQ==
X-Gm-Message-State: AOAM532Rr+TxpSe8SfgNu6sDWj6DBrJnh2mT73bSLReuvJzkvRI2l/tF
        6j2ywCRlz4NfP3XHmGbUJCKDSg==
X-Google-Smtp-Source: ABdhPJzKQa0dSZJCF0TM5/ZcnkFLZt3bvK+BZ0jF/xZh3XELFHCeH3EjFvlM737bclqF5vunbMW+kw==
X-Received: by 2002:a05:6830:573:: with SMTP id f19mr229610otc.117.1612917750861;
        Tue, 09 Feb 2021 16:42:30 -0800 (PST)
Received: from shuah-t480s.internal (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id s123sm103060oos.3.2021.02.09.16.42.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Feb 2021 16:42:30 -0800 (PST)
From:   Shuah Khan <skhan@linuxfoundation.org>
To:     kvalo@codeaurora.org, davem@davemloft.net, kuba@kernel.org
Cc:     Shuah Khan <skhan@linuxfoundation.org>, ath10k@lists.infradead.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/5] ath10k: fix conf_mutex lock assert in ath10k_debug_fw_stats_request()
Date:   Tue,  9 Feb 2021 17:42:22 -0700
Message-Id: <1c38ef6d39ed89a564bc817d964d923ff0676c53.1612915444.git.skhan@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <cover.1612915444.git.skhan@linuxfoundation.org>
References: <cover.1612915444.git.skhan@linuxfoundation.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

ath10k_debug_fw_stats_request() is called ath10k_sta_statistics()
without holding conf_mutex. ath10k_debug_fw_stats_request() simply
returns when CONFIG_ATH10K_DEBUGFS is disabled.

When CONFIG_ATH10K_DEBUGFS is enabled, ath10k_debug_fw_stats_request()
code path isn't protected. This assert is triggered when CONFIG_LOCKDEP
and CONFIG_ATH10K_DEBUGFS are enabled.

All other ath10k_debug_fw_stats_request() callers hold conf_mutex.
Fix ath10k_sta_statistics() to do the same.

WARNING: CPU: 5 PID: 696 at drivers/net/wireless/ath/ath10k/debug.c:357 ath10k_debug_fw_stats_request+0x29a/0x2d0 [ath10k_core]
Modules linked in: rfcomm ccm fuse cmac algif_hash algif_skcipher af_alg bnep binfmt_misc nls_iso8859_1 intel_rapl_msr intel_rapl_common snd_hda_codec_realtek snd_hda_codec_generic ledtrig_audio snd_hda_codec_hdmi snd_hda_intel snd_intel_dspcfg snd_hda_codec snd_hda_core snd_hwdep snd_pcm amdgpu snd_seq_midi snd_seq_midi_event snd_rawmidi edac_mce_amd snd_seq ath10k_pci ath10k_core aesni_intel gpu_sched drm_ttm_helper btusb ttm glue_helper crypto_simd btrtl ath cryptd drm_kms_helper snd_seq_device btbcm snd_timer rapl btintel cec i2c_algo_bit mac80211 bluetooth fb_sys_fops input_leds ecdh_generic snd wmi_bmof syscopyarea ecc serio_raw efi_pstore ccp k10temp sysfillrect soundcore sysimgblt snd_pci_acp3x cfg80211 ipmi_devintf libarc4 ipmi_msghandler mac_hid sch_fq_codel parport_pc ppdev lp parport drm ip_tables x_tables autofs4 hid_generic usbhid hid crc32_pclmul psmouse ahci nvme libahci i2c_piix4 nvme_core r8169 realtek wmi video
CPU: 5 PID: 696 Comm: NetworkManager Tainted: G        W         5.11.0-rc7+ #20
Hardware name: LENOVO 10VGCTO1WW/3130, BIOS M1XKT45A 08/21/2019
RIP: 0010:ath10k_debug_fw_stats_request+0x29a/0x2d0 [ath10k_core]
Code: 83 c4 10 44 89 f8 5b 41 5c 41 5d 41 5e 41 5f 5d c3 48 8d bf e8 20 00 00 be ff ff ff ff e8 de 2d 47 fa 85 c0 0f 85 8d fd ff ff <0f> 0b e9 86 fd ff ff 41 bf a1 ff ff ff 44 89 fa 48 c7 c6 2c 71 c4
RSP: 0018:ffffaffbc124b7d0 EFLAGS: 00010246
RAX: 0000000000000000 RBX: ffff93d02e4fec70 RCX: 0000000000000001
RDX: 0000000000000000 RSI: ffff93d00cba5248 RDI: ffff93d00ab309a0
RBP: ffffaffbc124b808 R08: 0000000000000000 R09: ffff93d02e4fec70
R10: 0000000000000001 R11: 0000000000000246 R12: ffff93d00cba3160
R13: ffff93d00cba3160 R14: ffff93d02e4fe4f0 R15: 0000000000000001
FS:  00007f7ce8d50bc0(0000) GS:ffff93d137d40000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007fc3595ad160 CR3: 000000010d492000 CR4: 00000000003506e0
Call Trace:
 ? sta_info_get_bss+0xeb/0x1f0 [mac80211]
 ath10k_sta_statistics+0x4f/0x280 [ath10k_core]
 sta_set_sinfo+0xda/0xd20 [mac80211]
 ieee80211_get_station+0x58/0x80 [mac80211]
 nl80211_get_station+0xbd/0x340 [cfg80211]
 genl_family_rcv_msg_doit+0xe7/0x150
 genl_rcv_msg+0xe2/0x1e0
 ? nl80211_dump_station+0x3a0/0x3a0 [cfg80211]
 ? nl80211_send_station+0xef0/0xef0 [cfg80211]
 ? genl_get_cmd+0xd0/0xd0
 netlink_rcv_skb+0x55/0x100
 genl_rcv+0x29/0x40
 netlink_unicast+0x1a8/0x270
 netlink_sendmsg+0x253/0x480
 sock_sendmsg+0x65/0x70
 ____sys_sendmsg+0x219/0x260
 ? __import_iovec+0x32/0x170
 ___sys_sendmsg+0xb7/0x100
 ? end_opal_session+0x39/0xd0
 ? __fget_files+0xe0/0x1d0
 ? find_held_lock+0x31/0x90
 ? __fget_files+0xe0/0x1d0
 ? __fget_files+0x103/0x1d0
 ? __fget_light+0x32/0x80
 __sys_sendmsg+0x5a/0xa0
 ? syscall_enter_from_user_mode+0x21/0x60
 __x64_sys_sendmsg+0x1f/0x30
 do_syscall_64+0x38/0x50
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
RIP: 0033:0x7f7cea2c791d
Code: 28 89 54 24 1c 48 89 74 24 10 89 7c 24 08 e8 4a ee ff ff 8b 54 24 1c 48 8b 74 24 10 41 89 c0 8b 7c 24 08 b8 2e 00 00 00 0f 05 <48> 3d 00 f0 ff ff 77 33 44 89 c7 48 89 44 24 08 e8 9e ee ff ff 48
RSP: 002b:00007ffedf612a30 EFLAGS: 00000293 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 00005618c4cfec00 RCX: 00007f7cea2c791d
RDX: 0000000000000000 RSI: 00007ffedf612a80 RDI: 000000000000000b
RBP: 00007ffedf612a80 R08: 0000000000000000 R09: 00005618c4e74000
R10: 00005618c4da0590 R11: 0000000000000293 R12: 00005618c4cfec00
R13: 00005618c4cfe2c0 R14: 00007f7cea32ef80 R15: 00005618c4cff340
irq event stamp: 520897
hardirqs last  enabled at (520903): [<ffffffffba501cc5>] console_unlock+0x4e5/0x5d0
hardirqs last disabled at (520908): [<ffffffffba501c38>] console_unlock+0x458/0x5d0
softirqs last  enabled at (520722): [<ffffffffbb201002>] asm_call_irq_on_stack+0x12/0x20
softirqs last disabled at (520717): [<ffffffffbb201002>] asm_call_irq_on_stack+0x12/0x20

Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
---
 drivers/net/wireless/ath/ath10k/mac.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index 7d98250380ec..e815aab412d7 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -9117,7 +9117,9 @@ static void ath10k_sta_statistics(struct ieee80211_hw *hw,
 	if (!ath10k_peer_stats_enabled(ar))
 		return;
 
+	mutex_lock(&ar->conf_mutex);
 	ath10k_debug_fw_stats_request(ar);
+	mutex_unlock(&ar->conf_mutex);
 
 	sinfo->rx_duration = arsta->rx_duration;
 	sinfo->filled |= BIT_ULL(NL80211_STA_INFO_RX_DURATION);
-- 
2.27.0

