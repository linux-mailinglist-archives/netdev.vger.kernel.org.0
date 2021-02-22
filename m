Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C3AB32142F
	for <lists+netdev@lfdr.de>; Mon, 22 Feb 2021 11:30:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230360AbhBVKab (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Feb 2021 05:30:31 -0500
Received: from m42-2.mailgun.net ([69.72.42.2]:22244 "EHLO m42-2.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230295AbhBVKaL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 22 Feb 2021 05:30:11 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1613989786; h=Content-Type: MIME-Version: Message-ID:
 In-Reply-To: Date: References: Subject: Cc: To: From: Sender;
 bh=DAA2tKZPWZ8kw7I/CYZgM9BJg4MDa6BL1U7zcmmc11U=; b=J0wBsMpl6InWHlo6chz2CiHSGY4ELkOEtnpFOiQLVSnhQuTPN6xoUI4diKJ1/P58iA7Xgefs
 g5cZDsZDuALRYjmFO6GGf6ikvCyXmbTBSJ1A7JpAbY29gCAMccKpZpLdhB2BpAYzqut9DkQO
 MqlnLnzinRxS37yD8pAX83FzXHQ=
X-Mailgun-Sending-Ip: 69.72.42.2
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n01.prod.us-east-1.postgun.com with SMTP id
 6033877b3bd0a42cc9c861bb (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Mon, 22 Feb 2021 10:29:15
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id EAFD6C43465; Mon, 22 Feb 2021 10:29:14 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=2.0 tests=ALL_TRUSTED,BAYES_00,SPF_FAIL,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 3183EC433C6;
        Mon, 22 Feb 2021 10:29:10 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 3183EC433C6
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Hao Chen <chenhaoa@uniontech.com>
Cc:     tony0620emma@gmail.com, davem@davemloft.net, kuba@kernel.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, timlee@realtek.com, arnd@arndb.de,
        zhanjun@uniontech.com
Subject: Re: [PATCH v2] rtw88: 8822ce: fix wifi disconnect after S3/S4 on HONOR laptop
References: <20210222094638.18392-1-chenhaoa@uniontech.com>
Date:   Mon, 22 Feb 2021 12:29:09 +0200
In-Reply-To: <20210222094638.18392-1-chenhaoa@uniontech.com> (Hao Chen's
        message of "Mon, 22 Feb 2021 17:46:38 +0800")
Message-ID: <87h7m4iefe.fsf@codeaurora.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hao Chen <chenhaoa@uniontech.com> writes:

> The laptop's wifi disconnect after the laptop HONOR MagicBook 14
> sleep to S3/S4 and wake up.
>
> The dmesg of kernel report:
> "[   99.990168] pcieport 0000:00:01.2: can't change power state from D3hot
> to D0 (config space inaccessible)
> [   99.990176] ACPI: EC: interrupt unblocked
> [   99.993334] rtw_pci 0000:01:00.0: can't change power state from D3hot
> to D0 (config space inaccessible)
> ......
> [  102.133500] rtw_pci 0000:01:00.0: mac power on failed
> [  102.133503] rtw_pci 0000:01:00.0: failed to power on mac
> [  102.133505] ------------[ cut here ]------------
> [  102.133506] Hardware became unavailable upon resume. This could be a
> software issue prior to suspend or a hardware issue.
> [  102.133569] WARNING: CPU: 4 PID: 5612 at net/mac80211/util.c:2232
> ieee80211_reconfig+0x9b/0x1490 [mac80211]
> [  102.133570] Modules linked in: ccm rfcomm uvcvideo videobuf2_vmalloc
> videobuf2_memops videobuf2_v4l2 videobuf2_common videodev mc cmac bnep 
> btusb btrtl btbcm btintel edac_mce_amd bluetooth kvm_amd ecdh_generic 
> ecc kvm nls_iso8859_1 rtwpci rtw88 crct10dif_pclmul crc32_pclmul mac80211 
> ghash_clmulni_intel aesni_intel snd_hda_codec_realtek crypto_simd huawei_wmi
> snd_hda_codec_generic cryptd cfg80211 wmi_bmof serio_raw sparse_keymap
> ledtrig_audio sp5100_tco glue_helper joydev snd_hda_codec_hdmi snd_hda_intel
> snd_intel_dspcfg wdat_wdt snd_hda_codec snd_hda_core pcspkr snd_hwdep snd_pcm
> efi_pstore snd_timer libarc4 k10temp snd soundcore snd_pci_acp3x ccp mac_hid
> binfmt_misc ip_tables x_tables autofs4 amdgpu amd_iommu_v2 gpu_sched 
> i2c_algo_bit ttm drm_kms_helper syscopyarea sysfillrect sysimgblt fb_sys_fops
> usbmouse cec nvme hid_generic i2c_piix4 usbhid nvme_core drm wmi video
> [  102.133617] CPU: 4 PID: 5612 Comm: kworker/u32:16 Not tainted 5.7.7-amd64-desktop-8822 #3
> [  102.133618] Hardware name: HUAWEI NBLL-WXX9/NBLL-WXX9-PCB, BIOS 1.06 09/29/2020
> [  102.133623] Workqueue: events_unbound async_run_entry_fn
> [  102.133651] RIP: 0010:ieee80211_reconfig+0x9b/0x1490 [mac80211]
> [  102.133654] Code: 31 db e8 e8 fb 27 c2 41 c6 85 34 05 00 00 00 4c 89 ef e8 38
> 56 fc ff 89 45 b8 85 c0 74 4c 48 c7 c7 d0 0c 09 c1 e8 01 e0 25 c2 <0f> 0b 4c
> 89 ef e8 2b d1 ff ff e9 02 03 00 00 80 7d 9f 00 0f 85 1d
> [  102.133655] RSP: 0018:ffffbe52c059fd08 EFLAGS: 00010286
> [  102.133657] RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000007
> [  102.133658] RDX: 0000000000000007 RSI: 0000000000000096 RDI: ffff9d573f519cc0
> [  102.133659] RBP: ffffbe52c059fd80 R08: ffffffffffd96245 R09: 000000000002cb80
> [  102.133660] R10: 000000016989e54c R11: 000000000002a360 R12: ffff9d5731f50300
> [  102.133661] R13: ffff9d5731f50800 R14: ffff9d5731f504c8 R15: ffffffff8463fbef
> [  102.133664] FS:  0000000000000000(0000) GS:ffff9d573f500000(0000) knlGS:0000000000000000
> [  102.133665] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [  102.133666] CR2: 0000000000000000 CR3: 000000033320a000 CR4: 0000000000340ee0
> [  102.133667] Call Trace:
> [  102.133673]  ? enqueue_entity+0xe3/0x680
> [  102.133705]  ieee80211_resume+0x55/0x70 [mac80211]
> [  102.133729]  wiphy_resume+0x84/0x130 [cfg80211]
> [  102.133752]  ? addresses_show+0xa0/0xa0 [cfg80211]
> [  102.133757]  dpm_run_callback+0x5b/0x150
> [  102.133760]  device_resume+0xad/0x1f0
> [  102.133762]  async_resume+0x1d/0x30
> [  102.133764]  async_run_entry_fn+0x3e/0x170
> [  102.133768]  process_one_work+0x1ab/0x380
> [  102.133771]  worker_thread+0x37/0x3b0
> [  102.133774]  kthread+0x120/0x140
> [  102.133776]  ? create_worker+0x1b0/0x1b0
> [  102.133778]  ? kthread_park+0x90/0x90
> [  102.133782]  ret_from_fork+0x22/0x40
> [  102.133785] ---[ end trace 46229bfd3a4273be ]---
> [  102.134137] ------------[ cut here ]------------
> [  102.134141] wlp1s0:  Failed check-sdata-in-driver check, flags: 0x0
> [  102.134195] WARNING: CPU: 0 PID: 5612 at net/mac80211/driver-ops.h:19
> drv_remove_interface+0xfe/0x110 [mac80211]"
>
> When try to pointer the driver.pm to NULL, the problem is fixed.
> It makes the sleep and wake procedure expected when pm's ops not NULL.
>
> By `git blame` command, I know that the assignment of .driver.pm =
> RTW_PM_OPS was in commit 44bc17f7f5b3 ("rtw88: support wowlan feature for
> 8822c"), and another
> commit 7dc7c41607d1 ("rtw88: avoid unused function warnings")
> pointed out rtw_pci_resume() and rtw_pci_suspend() are not used at
> all.
>
> So I think it's safe to remove them.
>
> Fixes: 7dc7c41607d1 ("rtw88: avoid unused function warnings")
> Fixes: 44bc17f7f5b3 ("rtw88: support wowlan feature for 8822c")
>
> Signed-off-by: Hao Chen <chenhaoa@uniontech.com>
> ---
>  drivers/net/wireless/realtek/rtw88/rtw8822ce.c | 1 -
>  1 file changed, 1 deletion(-)
>
> diff --git a/drivers/net/wireless/realtek/rtw88/rtw8822ce.c b/drivers/net/wireless/realtek/rtw88/rtw8822ce.c
> index 3845b1333dc3..4c063192f801 100644
> --- a/drivers/net/wireless/realtek/rtw88/rtw8822ce.c
> +++ b/drivers/net/wireless/realtek/rtw88/rtw8822ce.c
> @@ -25,7 +25,6 @@ static struct pci_driver rtw_8822ce_driver = {
>  	.id_table = rtw_8822ce_id_table,
>  	.probe = rtw_pci_probe,
>  	.remove = rtw_pci_remove,
> -	.driver.pm = &rtw_pm_ops,

Why just 8822ce? Why not remove rtw_pm_ops entirely if it just creates
problems?

drivers/net/wireless/realtek/rtw88/pci.c:SIMPLE_DEV_PM_OPS(rtw_pm_ops, rtw_pci_suspend, rtw_pci_resume);
drivers/net/wireless/realtek/rtw88/pci.c:EXPORT_SYMBOL(rtw_pm_ops);
drivers/net/wireless/realtek/rtw88/pci.h:extern const struct dev_pm_ops rtw_pm_ops;
drivers/net/wireless/realtek/rtw88/rtw8723de.c: .driver.pm = &rtw_pm_ops,
drivers/net/wireless/realtek/rtw88/rtw8821ce.c: .driver.pm = &rtw_pm_ops,
drivers/net/wireless/realtek/rtw88/rtw8822be.c: .driver.pm = &rtw_pm_ops,
drivers/net/wireless/realtek/rtw88/rtw8822ce.c: .driver.pm = &rtw_pm_ops,


-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
