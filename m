Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4BAE9341A47
	for <lists+netdev@lfdr.de>; Fri, 19 Mar 2021 11:44:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229512AbhCSKne (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Mar 2021 06:43:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229524AbhCSKnO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Mar 2021 06:43:14 -0400
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 611F4C06174A;
        Fri, 19 Mar 2021 03:43:14 -0700 (PDT)
Received: by mail-wr1-x432.google.com with SMTP id e18so8613701wrt.6;
        Fri, 19 Mar 2021 03:43:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=8zTF3XjRrTXJesSju14px5T0UCOaTESdK/3HSU0rgLg=;
        b=K05cQOofbFZIG0kbTpwTS+LznsRUxV2WO9QkPRdn764odDfSBRZK6j0Ke4srMHyHQc
         qY0tqBPHodAgPe3F3HgiNvGIrul6OYJ7iSGyYmWdMFAdzBlnbagCUr/3Njar+f6QqQwz
         RMNAXRZtnrQCl9zxXg+r2zmmgI93M92Aa1xAv70pYMFRa8UOr0lzUH3M0X3KSdmkb3H+
         sEm5S9whGpPR0RYsWMbT1B4Lq/8/qvjcTHScP/Aq/VJiqS1SdRITUBB0CGYF/TVndcHm
         2tGrseFdSgbBHdPAe31oLBqbKtI9t24RgCbTzGLX0QyZg4FSUrlEgRKBxxrGZ6RUr26l
         YSHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=8zTF3XjRrTXJesSju14px5T0UCOaTESdK/3HSU0rgLg=;
        b=S3uBNZPCbOAh6VbiYC/vJTtMbASRWJcb8vo72WMmyEzdo9P/vYeiot0uqC0MW0n08n
         748NK6Cfdd7ufQGjndirFGKq9M9cmsG2Yjmi5b+aTtWYGKKLDG7OphvBqKE4W6xLg1VR
         qQqdOB6fM+zJ3oBAJ6scbPPNobq8jee4sljdYtPiaegykYMd/8nTWh09Xs7fj7deuIzL
         nEx5kSCLy7WIDAd7rH3DWGinDh3B9VUZU1BAZ5tZl7Pfct+3Qbp8HV9gpL7Cc8Yg/4rY
         f1BcKRS9U1qrv4FSqGXtEn94JcpHnpx1XEbzEm/0GfcwgpfWLI3BVbcKYddZ5ztJ1PhS
         u6GQ==
X-Gm-Message-State: AOAM530KxLQ/lw0nCSkbbGFbohDsOD+6HubQgYUjNcQaS63sHC6mexog
        BuBV/JrYnX6iHaBvEuNTenraM6SDGWUq1Q==
X-Google-Smtp-Source: ABdhPJwZD4034lzcDKSxbKwA0wW2JjAkew3JLGDNYb/PWjf7aD0dITbpf7GzEoTN5e73IFdSvCFxKw==
X-Received: by 2002:adf:fe8d:: with SMTP id l13mr3746264wrr.81.1616150592839;
        Fri, 19 Mar 2021 03:43:12 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f1f:bb00:fd2c:a424:dc3d:ffa1? (p200300ea8f1fbb00fd2ca424dc3dffa1.dip0.t-ipconnect.de. [2003:ea:8f1f:bb00:fd2c:a424:dc3d:ffa1])
        by smtp.googlemail.com with ESMTPSA id t23sm7536601wra.50.2021.03.19.03.43.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 19 Mar 2021 03:43:12 -0700 (PDT)
To:     Luca Coelho <luciano.coelho@intel.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Johannes Berg <johannes.berg@intel.com>
Cc:     Jakub Kicinski <kuba@kernel.org>, linux-wireless@vger.kernel.org,
        David Miller <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: Problem in iwl_pcie_gen2_enqueue_hcmd if irqs are disabled
Message-ID: <0af0ac51-1e13-8406-221e-db2c31b3695e@gmail.com>
Date:   Fri, 19 Mar 2021 11:43:04 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I get the following error on linux-next when bringing the device up.
It's such an obvious error that I wonder how it could pass your QA.

led_trigger_event() disables interrupts, and spin_unlock_bh() complains
about this. The following fixes the warning for me.

I'd say this means also commit "iwlwifi: pcie: don't disable interrupts
for reg_lock" is wrong.


diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/tx-gen2.c b/drivers/net/wireless/intel/iwlwifi/pcie/tx-gen2.c
index 4456abb9a..34bde8c87 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/tx-gen2.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/tx-gen2.c
@@ -40,6 +40,7 @@ int iwl_pcie_gen2_enqueue_hcmd(struct iwl_trans *trans,
 	const u8 *cmddata[IWL_MAX_CMD_TBS_PER_TFD];
 	u16 cmdlen[IWL_MAX_CMD_TBS_PER_TFD];
 	struct iwl_tfh_tfd *tfd;
+	unsigned long flags;
 
 	copy_size = sizeof(struct iwl_cmd_header_wide);
 	cmd_size = sizeof(struct iwl_cmd_header_wide);
@@ -108,14 +109,14 @@ int iwl_pcie_gen2_enqueue_hcmd(struct iwl_trans *trans,
 		goto free_dup_buf;
 	}
 
-	spin_lock_bh(&txq->lock);
+	spin_lock_irqsave(&txq->lock, flags);
 
 	idx = iwl_txq_get_cmd_index(txq, txq->write_ptr);
 	tfd = iwl_txq_get_tfd(trans, txq, txq->write_ptr);
 	memset(tfd, 0, sizeof(*tfd));
 
 	if (iwl_txq_space(trans, txq) < ((cmd->flags & CMD_ASYNC) ? 2 : 1)) {
-		spin_unlock_bh(&txq->lock);
+		spin_unlock_irqrestore(&txq->lock, flags);
 
 		IWL_ERR(trans, "No space in command queue\n");
 		iwl_op_mode_cmd_queue_full(trans->op_mode);
@@ -250,7 +251,7 @@ int iwl_pcie_gen2_enqueue_hcmd(struct iwl_trans *trans,
 	spin_unlock(&trans_pcie->reg_lock);
 
 out:
-	spin_unlock_bh(&txq->lock);
+	spin_unlock_irqrestore(&txq->lock, flags);
 free_dup_buf:
 	if (idx < 0)
 		kfree(dup_buf);
-- 
2.31.0







[   19.783986] ------------[ cut here ]------------
[   19.784096] WARNING: CPU: 1 PID: 2318 at kernel/softirq.c:178 __local_bh_enable_ip+0x85/0xc0
[   19.784166] Modules linked in: snd_hda_codec_hdmi snd_hda_codec_realtek snd_hda_codec_generic ledtrig_audio cmac bnep iwlmvm led_class vfat fat mac80211 libarc4 x86_pkg_temp_thermal coretemp iwlwifi btusb btintel snd_hda_intel snd_intel_dspcfg bluetooth aesni_intel i915 snd_hda_codec crypto_simd snd_hda_core ecdh_generic cryptd ecc snd_pcm r8169 i2c_i801 intel_gtt realtek snd_timer i2c_algo_bit i2c_smbus snd mdio_devres drm_kms_helper cfg80211 syscopyarea sysfillrect libphy sysimgblt rfkill mei_me fb_sys_fops mei sch_fq_codel crypto_user drm efivarfs ext4 mbcache jbd2 ums_realtek crc32c_intel ahci libahci libata
[   19.784646] CPU: 1 PID: 2318 Comm: ip Not tainted 5.12.0-rc3-next-20210315+ #1
[   19.784699] Hardware name: NA ZBOX-CI327NANO-GS-01/ZBOX-CI327NANO-GS-01, BIOS 5.12 04/28/2020
[   19.784759] RIP: 0010:__local_bh_enable_ip+0x85/0xc0
[   19.784800] Code: 8b 05 7f c9 da 62 a9 00 ff ff 00 74 32 65 ff 0d 71 c9 da 62 e8 2c be 0e 00 fb 5b 41 5c 5d c3 65 8b 05 3b cf da 62 85 c0 75 ae <0f> 0b eb aa e8 42 bd 0e 00 eb ab 4c 89 e7 e8 b8 fa 05 00 eb b4 65
[   19.784922] RSP: 0018:ffff9ef9c038f1b8 EFLAGS: 00010046
[   19.784962] RAX: 0000000000000000 RBX: 0000000000000201 RCX: 0000000000000000
[   19.785011] RDX: 0000000000000003 RSI: 0000000000000201 RDI: ffffffffc09488b4
[   19.785062] RBP: ffff9ef9c038f1c8 R08: 0000000000000000 R09: 0000000000000001
[   19.785111] R10: 0000000000000001 R11: 0000000000000000 R12: ffffffffc09488b4
[   19.785159] R13: ffff8ed2c29f6b40 R14: 0000000000000000 R15: 000000000000000c
[   19.785210] FS:  00007f5948d9b740(0000) GS:ffff8ed33bc80000(0000) knlGS:0000000000000000
[   19.785267] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   19.785308] CR2: 0000559281ddfcc0 CR3: 000000010b378000 CR4: 00000000003506e0
[   19.785361] Call Trace:
[   19.785381]  _raw_spin_unlock_bh+0x2c/0x40
[   19.785416]  iwl_pcie_gen2_enqueue_hcmd+0x504/0x870 [iwlwifi]
[   19.785481]  iwl_trans_txq_send_hcmd+0x68/0x3b0 [iwlwifi]
[   19.785539]  iwl_trans_send_cmd+0x7d/0x170 [iwlwifi]
[   19.785593]  iwl_mvm_send_cmd+0x29/0x80 [iwlmvm]
[   19.785649]  iwl_mvm_led_set+0xa5/0xd0 [iwlmvm]
[   19.785704]  iwl_led_brightness_set+0x1a/0x20 [iwlmvm]
[   19.785761]  led_set_brightness_nosleep+0x24/0x50
[   19.785800]  led_set_brightness+0x41/0x50
[   19.785832]  led_trigger_event+0x46/0x70
[   19.785863]  ieee80211_led_radio+0x24/0x30 [mac80211]
[   19.785980]  ieee80211_do_open+0x4c4/0x9a0 [mac80211]
[   19.786074]  ieee80211_open+0x69/0x90 [mac80211]
[   19.786165]  __dev_open+0xd6/0x190
