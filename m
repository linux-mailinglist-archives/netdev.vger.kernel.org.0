Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC3924020CA
	for <lists+netdev@lfdr.de>; Mon,  6 Sep 2021 22:53:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231659AbhIFUw4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Sep 2021 16:52:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231256AbhIFUwz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Sep 2021 16:52:55 -0400
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A559C061575
        for <netdev@vger.kernel.org>; Mon,  6 Sep 2021 13:51:50 -0700 (PDT)
Received: by mail-wr1-x42c.google.com with SMTP id t18so645465wrb.0
        for <netdev@vger.kernel.org>; Mon, 06 Sep 2021 13:51:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:cc:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=AHnFdvyNKtI6UG1OE8xeKVAdClaVAzZSn3ODDP1zYRQ=;
        b=EOOVqtqt717ynHJdzYpoL+5c6CFo6Pf29n+hZi68wpIDuX0J3AlPInD27vwhcNNRRo
         DnTynY17xthnju36fOTfdshRAtLzTLogXpz1AA1NwdTbb4T4aOe2dxf1yu37PH7EQbuN
         xHRMRy4EPaidUe5Qov1cs7d2etWgeWJKij1mF0CxZyIr2284y3YETeC9AgDlOvDvtbzH
         HfGyHA1NHZJBwEhH1D9Am7i1tFyrZeH4cCZELpLnqX0QFoW0xcWKcbhC8CusBQMg4N9L
         +dp8jlep60iUvHjLOkiL44+LFvl29KFXIgXdKZ2cLaeRy4BU9/igJCIaTn3f5WESxgS9
         64hQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=AHnFdvyNKtI6UG1OE8xeKVAdClaVAzZSn3ODDP1zYRQ=;
        b=sLCt7uvsXGGU2kZEYJd9QoSdS+jYI89GstayQ5SIKUjD3HXTIhgOlYJDWDyxwI6Q4i
         PVPPwQAL1NW+HCnh5x1HvPn7ni0Zx/PGjy3WwczrD0Wf30oZ3mjUuqro0nAvX/V3n23O
         3NJttOe592ABc3ZarM88TAp3go9YcoRcuDD1BoywYBditGZKiZhR3M93pmv0aoqyRP/R
         Zak0y7SVBPplodYQL11xYkB1iD1n+bJwCIK07EaOhc/WzmQ/bHq/6peKANN+yXZOVTIw
         jkkZvRj8JOtDcZE8lQ78B9sPFGJVRSjarISpU2R8L/9qiwShtlC0hTplI00ruJh7kBiF
         Z6Sw==
X-Gm-Message-State: AOAM533Xs3re/fINyi+NA+o3ilTaBjLmqtRdtuk9vMmKjFlEtixvICZd
        zfFEFNZTwrnrQUrKkXH99EB+yR0cTD4=
X-Google-Smtp-Source: ABdhPJyiSrWQ6SI61+0jHCfqmd4DnHK4hBHpfbFQnswR3GhA0vVuaCYmbUmcqgMs4rJP6eRdLwSEfA==
X-Received: by 2002:a5d:69c8:: with SMTP id s8mr15180890wrw.324.1630961509192;
        Mon, 06 Sep 2021 13:51:49 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f08:4500:2cc2:5e4b:8e61:1e2c? (p200300ea8f0845002cc25e4b8e611e2c.dip0.t-ipconnect.de. [2003:ea:8f08:4500:2cc2:5e4b:8e61:1e2c])
        by smtp.googlemail.com with ESMTPSA id z17sm9162349wrh.66.2021.09.06.13.51.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 06 Sep 2021 13:51:48 -0700 (PDT)
To:     Raju Rangoju <rajur@chelsio.com>, Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        =?UTF-8?B?w43DsWlnbyBIdWd1ZXQ=?= <ihuguet@redhat.com>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: [PATCH net] cxgb3: fix oops on module removal
Message-ID: <2200f320-37dd-3a89-fc74-6f4003bbdf16@gmail.com>
Date:   Mon, 6 Sep 2021 22:51:33 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When removing the driver module w/o bringing an interface up before
the error below occurs. Reason seems to be that cancel_work_sync() is
called in t3_sge_stop() for a queue that hasn't been initialized yet.

[10085.941785] ------------[ cut here ]------------
[10085.941799] WARNING: CPU: 1 PID: 5850 at kernel/workqueue.c:3074 __flush_work+0x3ff/0x480
[10085.941819] Modules linked in: vfat snd_hda_codec_hdmi fat snd_hda_codec_realtek snd_hda_codec_generic ledtrig_audio led_class ee1004 iTCO_
wdt intel_tcc_cooling x86_pkg_temp_thermal coretemp aesni_intel crypto_simd cryptd snd_hda_intel snd_intel_dspcfg snd_hda_codec snd_hda_core r
8169 snd_pcm realtek mdio_devres snd_timer snd i2c_i801 i2c_smbus libphy i915 i2c_algo_bit cxgb3(-) intel_gtt ttm mdio drm_kms_helper mei_me s
yscopyarea sysfillrect sysimgblt mei fb_sys_fops acpi_pad sch_fq_codel crypto_user drm efivarfs ext4 mbcache jbd2 crc32c_intel
[10085.941944] CPU: 1 PID: 5850 Comm: rmmod Not tainted 5.14.0-rc7-next-20210826+ #6
[10085.941974] Hardware name: System manufacturer System Product Name/PRIME H310I-PLUS, BIOS 2603 10/21/2019
[10085.941992] RIP: 0010:__flush_work+0x3ff/0x480
[10085.942003] Code: c0 74 6b 65 ff 0d d1 bd 78 75 e8 bc 2f 06 00 48 c7 c6 68 b1 88 8a 48 c7 c7 e0 5f b4 8b 45 31 ff e8 e6 66 04 00 e9 4b fe ff ff <0f> 0b 45 31 ff e9 41 fe ff ff e8 72 c1 79 00 85 c0 74 87 80 3d 22
[10085.942036] RSP: 0018:ffffa1744383fc08 EFLAGS: 00010246
[10085.942048] RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000923
[10085.942062] RDX: 0000000000000000 RSI: 0000000000000001 RDI: ffff91c901710a88
[10085.942076] RBP: ffffa1744383fce8 R08: 0000000000000001 R09: 0000000000000001
[10085.942090] R10: 00000000000000c2 R11: 0000000000000000 R12: ffff91c901710a88
[10085.942104] R13: 0000000000000000 R14: ffff91c909a96100 R15: 0000000000000001
[10085.942118] FS:  00007fe417837740(0000) GS:ffff91c969d00000(0000) knlGS:0000000000000000
[10085.942134] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[10085.942146] CR2: 000055a8d567ecd8 CR3: 0000000121690003 CR4: 00000000003706e0
[10085.942160] Call Trace:
[10085.942166]  ? __lock_acquire+0x3af/0x22e0
[10085.942177]  ? cancel_work_sync+0xb/0x10
[10085.942187]  __cancel_work_timer+0x128/0x1b0
[10085.942197]  ? __pm_runtime_resume+0x5b/0x90
[10085.942208]  cancel_work_sync+0xb/0x10
[10085.942217]  t3_sge_stop+0x2f/0x50 [cxgb3]
[10085.942234]  remove_one+0x26/0x190 [cxgb3]
[10085.942248]  pci_device_remove+0x39/0xa0
[10085.942258]  __device_release_driver+0x15e/0x240
[10085.942269]  driver_detach+0xd9/0x120
[10085.942278]  bus_remove_driver+0x53/0xd0
[10085.942288]  driver_unregister+0x2c/0x50
[10085.942298]  pci_unregister_driver+0x31/0x90
[10085.942307]  cxgb3_cleanup_module+0x10/0x18c [cxgb3]
[10085.942324]  __do_sys_delete_module+0x191/0x250
[10085.942336]  ? syscall_enter_from_user_mode+0x21/0x60
[10085.942347]  ? trace_hardirqs_on+0x2a/0xe0
[10085.942357]  __x64_sys_delete_module+0x13/0x20
[10085.942368]  do_syscall_64+0x40/0x90
[10085.942377]  entry_SYSCALL_64_after_hwframe+0x44/0xae
[10085.942389] RIP: 0033:0x7fe41796323b

Fixes: 5e0b8928927f ("net:cxgb3: replace tasklets with works")
Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/ethernet/chelsio/cxgb3/sge.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/ethernet/chelsio/cxgb3/sge.c b/drivers/net/ethernet/chelsio/cxgb3/sge.c
index e21a2e691..c3afec104 100644
--- a/drivers/net/ethernet/chelsio/cxgb3/sge.c
+++ b/drivers/net/ethernet/chelsio/cxgb3/sge.c
@@ -3301,6 +3301,9 @@ void t3_sge_stop(struct adapter *adap)
 
 	t3_sge_stop_dma(adap);
 
+	/* workqueues aren't initialized otherwise */
+	if (!(adap->flags & FULL_INIT_DONE))
+		return;
 	for (i = 0; i < SGE_QSETS; ++i) {
 		struct sge_qset *qs = &adap->sge.qs[i];
 
-- 
2.33.0

