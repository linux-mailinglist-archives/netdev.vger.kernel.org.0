Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C55165FEBC0
	for <lists+netdev@lfdr.de>; Fri, 14 Oct 2022 11:36:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229977AbiJNJgq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Oct 2022 05:36:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230009AbiJNJgn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Oct 2022 05:36:43 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D937216087D
        for <netdev@vger.kernel.org>; Fri, 14 Oct 2022 02:36:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1665740200;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=p0SEIR1oauwA7OkBeXPV0qqgYW1Tj4fVslwVYSK5xHs=;
        b=icDPei5GUdzkeIKj7kntR6k42Y9no5FOUJ7Q1Tu3iFG0gAmmrMcIZgmYWiXYmXOBdMk7/C
        LqC6o/PPAbDHRq9GwKqASBos2Tq1cz9xxX1hDj6sX5sf5VG7PqupRhfdsB6W+XXf6g/aQ1
        4jb48hqw0QOvA8x4FDLxY57kZFvOvYk=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-639-qvuhLnrJOCK8qFuhzwB-kA-1; Fri, 14 Oct 2022 05:36:35 -0400
X-MC-Unique: qvuhLnrJOCK8qFuhzwB-kA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id BC53B381494C;
        Fri, 14 Oct 2022 09:36:34 +0000 (UTC)
Received: from shalem.redhat.com (unknown [10.39.195.155])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8BE6221449A0;
        Fri, 14 Oct 2022 09:36:33 +0000 (UTC)
From:   Hans de Goede <hdegoede@redhat.com>
To:     M Chetan Kumar <m.chetan.kumar@intel.com>,
        Intel Corporation <linuxwwan@intel.com>,
        Loic Poulain <loic.poulain@linaro.org>,
        Sergey Ryazanov <ryazanov.s.a@gmail.com>,
        Johannes Berg <johannes@sipsolutions.net>
Cc:     Hans de Goede <hdegoede@redhat.com>, netdev@vger.kernel.org
Subject: [PATCH] net: wwan: iosm: initialize pc_wwan->if_mutex earlier
Date:   Fri, 14 Oct 2022 11:36:32 +0200
Message-Id: <20221014093632.8487-1-hdegoede@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

wwan_register_ops() ends up calls ipc_wwan_newlink() before it returns.

ipc_wwan_newlink() uses pc_wwan->if_mutex, so we must initialize it
before calling wwan_register_ops(). This fixes the following WARN()
when lock-debugging is enabled:

[  610.708713] ------------[ cut here ]------------
[  610.708721] DEBUG_LOCKS_WARN_ON(lock->magic != lock)
[  610.708727] WARNING: CPU: 11 PID: 506 at kernel/locking/mutex.c:582 __mutex_lock+0x3e4/0x7e0
[  610.708736] Modules linked in: iosm snd_seq_dummy snd_hrtimer rfcomm qrtr bnep binfmt_misc snd_ctl_led snd_soc_skl_hda_dsp snd_soc_intel_hda_dsp_common snd_soc_hdac_hdmi snd_sof_probes snd_soc_dmic iTCO_wdt intel_pmc_bxt mei_hdcp mei_pxp iTCO_vendor_support pmt_telemetry intel_rapl_msr pmt_class intel_tcc_cooling x86_pkg_temp_thermal intel_powerclamp coretemp kvm_intel kvm irqbypass rapl intel_cstate intel_uncore pcspkr think_lmi firmware_attributes_class wmi_bmof snd_hda_codec_hdmi snd_hda_codec_realtek snd_hda_codec_generic snd_sof_pci_intel_tgl snd_sof_intel_hda_common soundwire_intel soundwire_generic_allocation soundwire_cadence snd_sof_intel_hda snd_sof_pci snd_sof_xtensa_dsp snd_sof snd_sof_utils snd_soc_hdac_hda snd_hda_ext_core snd_soc_acpi_intel_match snd_soc_acpi soundwire_bus snd_soc_core snd_compress ac97_bus snd_pcm_dmaengine snd_hda_intel snd_intel_dspcfg snd_intel_sdw_acpi snd_hda_codec snd_hda_core iwlmvm snd_hwdep snd_seq btusb snd_seq_device btrtl btbcm snd_pcm
[  610.708767]  btintel mei_me mac80211 i2c_i801 btmtk libarc4 i2c_smbus snd_timer mei bluetooth hid_sensor_gyro_3d iwlwifi hid_sensor_accel_3d idma64 hid_sensor_trigger hid_sensor_iio_common ecdh_generic industrialio_triggered_buffer kfifo_buf cfg80211 joydev industrialio int3403_thermal soc_button_array ov2740 v4l2_fwnode v4l2_async videodev mc intel_skl_int3472_tps68470 tps68470_regulator clk_tps68470 intel_skl_int3472_discrete intel_hid sparse_keymap int3400_thermal acpi_thermal_rel acpi_tad acpi_pad vfat fat processor_thermal_device_pci processor_thermal_device processor_thermal_rfim processor_thermal_mbox processor_thermal_rapl thunderbolt intel_rapl_common intel_vsec int340x_thermal_zone igen6_edac zram dm_crypt hid_sensor_hub intel_ishtp_hid i915 thinkpad_acpi drm_buddy drm_display_helper snd soundcore ledtrig_audio crct10dif_pclmul wacom platform_profile crc32_pclmul cec nvme intel_ish_ipc rfkill crc32c_intel ucsi_acpi hid_multitouch serio_raw typec_ucsi ghash_clmulni_intel
[  610.708798]  nvme_core video intel_ishtp ttm typec i2c_hid_acpi i2c_hid wmi pinctrl_tigerlake ip6_tables ip_tables i2c_dev fuse
[  610.708806] CPU: 11 PID: 506 Comm: kworker/11:2 Tainted: G        W          6.0.0+ #505
[  610.708809] Hardware name: LENOVO 21CEZ9Q3US/21CEZ9Q3US, BIOS N3AET66W (1.31 ) 09/09/2022
[  610.708811] Workqueue: events ipc_imem_run_state_worker [iosm]
[  610.708831] RIP: 0010:__mutex_lock+0x3e4/0x7e0
[  610.708836] Code: ff 85 c0 0f 84 9b fc ff ff 8b 15 6f 54 11 01 85 d2 0f 85 8d fc ff ff 48 c7 c6 f0 f0 84 94 48 c7 c7 83 07 83 94 e8 91 33 f8 ff <0f> 0b e9 73 fc ff ff f6 83 d1 0c 00 00 01 0f 85 4b ff ff ff 4c 89
[  610.708837] RSP: 0018:ffffaf0b80767a50 EFLAGS: 00010282
[  610.708840] RAX: 0000000000000028 RBX: 0000000000000000 RCX: 0000000000000000
[  610.708841] RDX: 0000000000000001 RSI: ffffffff948b357c RDI: 00000000ffffffff
[  610.708842] RBP: ffffaf0b80767ae0 R08: 0000000000000000 R09: ffffaf0b80767900
[  610.708843] R10: 0000000000000003 R11: ffff9c191b7fffe8 R12: 0000000000000002
[  610.708845] R13: 0000000000000000 R14: ffff9c16a3044450 R15: ffff9c15e342ce40
[  610.708846] FS:  0000000000000000(0000) GS:ffff9c18fd6c0000(0000) knlGS:0000000000000000
[  610.708848] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  610.708849] CR2: 00001d40ba7bd008 CR3: 00000001d6c26002 CR4: 0000000000770ee0
[  610.708850] PKRU: 55555554
[  610.708851] Call Trace:
[  610.708852]  <TASK>
[  610.708856]  ? ipc_wwan_newlink+0x46/0xb0 [iosm]
[  610.708862]  ? wwan_port_fops_read+0x1b0/0x1b0
[  610.708867]  ? ipc_wwan_newlink+0x46/0xb0 [iosm]
[  610.708872]  ipc_wwan_newlink+0x46/0xb0 [iosm]
[  610.708877]  wwan_rtnl_newlink+0x7e/0xd0
[  610.708880]  wwan_create_default_link+0x24c/0x2e0
[  610.708890]  wwan_register_ops+0x71/0x90
[  610.708893]  ipc_wwan_init+0x48/0x90 [iosm]
[  610.708897]  ipc_imem_wwan_channel_init+0x81/0xa0 [iosm]
[  610.708902]  ipc_imem_run_state_worker+0xab/0x1b0 [iosm]
[  610.708907]  process_one_work+0x254/0x570
[  610.708914]  worker_thread+0x4f/0x3a0
[  610.708917]  ? process_one_work+0x570/0x570
[  610.708919]  kthread+0xf2/0x120
[  610.708922]  ? kthread_complete_and_exit+0x20/0x20
[  610.708924]  ret_from_fork+0x1f/0x30
[  610.708931]  </TASK>
[  610.708931] irq event stamp: 89949
[  610.708933] hardirqs last  enabled at (89949): [<ffffffff93ebc630>] _raw_spin_unlock_irqrestore+0x30/0x60
[  610.708936] hardirqs last disabled at (89948): [<ffffffff93ebc3bf>] _raw_spin_lock_irqsave+0x5f/0x70
[  610.708938] softirqs last  enabled at (89876): [<ffffffff93bc2509>] __netdev_alloc_skb+0xe9/0x150
[  610.708942] softirqs last disabled at (89874): [<ffffffff93bc2509>] __netdev_alloc_skb+0xe9/0x150
[  610.708944] ---[ end trace 0000000000000000 ]---

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
---
 drivers/net/wwan/iosm/iosm_ipc_wwan.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/wwan/iosm/iosm_ipc_wwan.c b/drivers/net/wwan/iosm/iosm_ipc_wwan.c
index 27151148c782..f21233f3206d 100644
--- a/drivers/net/wwan/iosm/iosm_ipc_wwan.c
+++ b/drivers/net/wwan/iosm/iosm_ipc_wwan.c
@@ -322,6 +322,7 @@ struct iosm_wwan *ipc_wwan_init(struct iosm_imem *ipc_imem, struct device *dev)
 
 	ipc_wwan->dev = dev;
 	ipc_wwan->ipc_imem = ipc_imem;
+	mutex_init(&ipc_wwan->if_mutex);
 
 	/* WWAN core will create a netdev for the default IP MUX channel */
 	if (wwan_register_ops(ipc_wwan->dev, &iosm_wwan_ops, ipc_wwan,
@@ -330,8 +331,6 @@ struct iosm_wwan *ipc_wwan_init(struct iosm_imem *ipc_imem, struct device *dev)
 		return NULL;
 	}
 
-	mutex_init(&ipc_wwan->if_mutex);
-
 	return ipc_wwan;
 }
 
-- 
2.37.3

