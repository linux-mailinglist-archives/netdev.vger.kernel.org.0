Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 00A0EB5766
	for <lists+netdev@lfdr.de>; Tue, 17 Sep 2019 23:14:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726857AbfIQVOQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Sep 2019 17:14:16 -0400
Received: from mail-ed1-f65.google.com ([209.85.208.65]:43113 "EHLO
        mail-ed1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726134AbfIQVOP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Sep 2019 17:14:15 -0400
Received: by mail-ed1-f65.google.com with SMTP id r9so4634957edl.10
        for <netdev@vger.kernel.org>; Tue, 17 Sep 2019 14:14:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=A5He5jFbrK9Du1LpUEi4UmQqqjnmeLRIjJwj+71y3LU=;
        b=UjoN+ohAqfqLzNOGdldKumIPYQdR7yTzsMswjbI9RZ8oc8/juK7oO3XiShb+nzyi35
         JMgYzP06hC2dFDvhgDp6ZRhxNwBfdLvEeKFKEVdNya0WFdpgYd3slCEplC/4a/RYON02
         7eW2diA9XgnG7qrf6RVyl4VUvjO1/9adkObTfiRbmELX69FfnrfHWhgACq3p3sxczxKC
         X3AmF1GducNGx01dojk7ei9OrMCeFVrphQasdQWG3c2GjVYM1hanRE3YTh72Gia9dVYf
         oumEtPvNC0huux4a3NoJ04O2IPBIUjsX6aNUbbTIsZG5ul5TP4K2f02KB0Wz7g2tydKE
         NTNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=A5He5jFbrK9Du1LpUEi4UmQqqjnmeLRIjJwj+71y3LU=;
        b=trqBKHQPU1ws0qNWofM8ZUX8J5lLtC1nwYs+U6kgn80FQc9rcirz1QIjnNhaIi3XKr
         VZPVJoTG07hy94RUNJmut5pGO9BDSaFw9qTQnPX2RGiI9i94sYGhjghX3icrsf1a5kg/
         kL90XUff/Gqqn5jgUNCNZeoaTqo3oYhPlrKPFdzR7M5rB9LJ47XC4W3HSuy7ScsMMijA
         w89HlX6qJFx4rHK8+S/MN8/nsTjKpQNi9TXYjPVpnej+BNIemBinLzDu+Q5FZGmirSlX
         DAe1QE7uOiPFzr3oa3GR0G4lxdLWXJHLGCgRx8CRuCsyxHQ2/HnwnVQa+DvAPgItNu1Q
         auHg==
X-Gm-Message-State: APjAAAWlC2ShhvFnocxfwWgPSUz1wsSgAFj4hFp62knvMsMyzvyVMfTV
        6qmCC4QcvPmZsRAPjt7WqHJcNsj15SVJzA==
X-Google-Smtp-Source: APXvYqyfdpYqGzvviiBj/uunqHfJdH5/dXy0wUoP2pkWvKjqs2BVbCns13qbAgtG2aeeN4Nu0RqCRA==
X-Received: by 2002:aa7:c749:: with SMTP id c9mr6988455eds.232.1568754853192;
        Tue, 17 Sep 2019 14:14:13 -0700 (PDT)
Received: from kvmhost.ch.hwng.net (kvmhost.ch.hwng.net. [69.16.191.151])
        by smtp.gmail.com with ESMTPSA id c6sm5065ejz.79.2019.09.17.14.14.11
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 17 Sep 2019 14:14:12 -0700 (PDT)
From:   Pooja Trivedi <poojatrivedi@gmail.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jakub.kicinski@netronome.com,
        daniel@iogearbox.net, john.fastabend@gmail.com, davejwatson@fb.com,
        aviadye@mellanox.com, borisp@mellanox.com,
        Pooja Trivedi <pooja.trivedi@stackpath.com>
Subject: [PATCH V2 net 1/1] net/tls(TLS_SW): Fix list_del double free caused by a race condition in tls_tx_records
Date:   Tue, 17 Sep 2019 21:13:56 +0000
Message-Id: <1568754836-25124-1-git-send-email-poojatrivedi@gmail.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <CAOrEdsmiz-ssFUpcT_43JfASLYRbt60R7Ta0KxuhrMN35cP0Sw@mail.gmail.com>
References: <CAOrEdsmiz-ssFUpcT_43JfASLYRbt60R7Ta0KxuhrMN35cP0Sw@mail.gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Pooja Trivedi <pooja.trivedi@stackpath.com>

Enclosing tls_tx_records within lock_sock/release_sock pair to ensure
write-synchronization is not sufficient because socket lock gets released
under memory pressure situation by sk_wait_event while it sleeps waiting
for memory, allowing another writer into tls_tx_records. This causes a
race condition with record deletion post transmission.

To fix this bug, use a flag set in tx_bitmask field of TLS context to
ensure single writer in tls_tx_records at a time

The bug resulted in the following crash:

[  270.888952] ------------[ cut here ]------------
[  270.890450] list_del corruption, ffff91cc3753a800->prev is
LIST_POISON2 (dead000000000122)
[  270.891194] WARNING: CPU: 1 PID: 7387 at lib/list_debug.c:50
__list_del_entry_valid+0x62/0x90
[  270.892037] Modules linked in: n5pf(OE) netconsole tls(OE) bonding
intel_rapl_msr intel_rapl_common sb_edac x86_pkg_temp_thermal
intel_powerclamp coretemp kvm_intel kvm iTCO_wdt iTCO_vendor_support
irqbypass crct10dif_pclmul crc32_pclmul ghash_clmulni_intel
aesni_intel crypto_simd mei_me cryptd glue_helper ipmi_si sg mei
lpc_ich pcspkr joydev ioatdma i2c_i801 ipmi_devintf ipmi_msghandler
wmi ip_tables xfs libcrc32c sd_mod mgag200 drm_vram_helper ttm
drm_kms_helper syscopyarea sysfillrect sysimgblt fb_sys_fops drm isci
libsas ahci scsi_transport_sas libahci crc32c_intel serio_raw igb
libata ptp pps_core dca i2c_algo_bit dm_mirror dm_region_hash dm_log
dm_mod [last unloaded: nitrox_drv]
[  270.896836] CPU: 1 PID: 7387 Comm: uperf Kdump: loaded Tainted: G
        OE     5.3.0-rc4 #1
[  270.897711] Hardware name: Supermicro SYS-1027R-N3RF/X9DRW, BIOS
3.0c 03/24/2014
[  270.898597] RIP: 0010:__list_del_entry_valid+0x62/0x90
[  270.899478] Code: 00 00 00 c3 48 89 fe 48 89 c2 48 c7 c7 e0 f9 ee
8d e8 b2 cf c8 ff 0f 0b 31 c0 c3 48 89 fe 48 c7 c7 18 fa ee 8d e8 9e
cf c8 ff <0f> 0b 31 c0 c3 48 89 f2 48 89 fe 48 c7 c7 50 fa ee 8d e8 87
cf c8
[  270.901321] RSP: 0018:ffffb6ea86eb7c20 EFLAGS: 00010282
[  270.902240] RAX: 0000000000000000 RBX: ffff91cc3753c000 RCX: 0000000000000000
[  270.903157] RDX: ffff91bc3f867080 RSI: ffff91bc3f857738 RDI: ffff91bc3f857738
[  270.904074] RBP: ffff91bc36020940 R08: 0000000000000560 R09: 0000000000000000
[  270.904988] R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000000
[  270.905902] R13: ffff91cc3753a800 R14: ffff91cc37cc6400 R15: ffff91cc3753a800
[  270.906809] FS:  00007f454a88d700(0000) GS:ffff91bc3f840000(0000)
knlGS:0000000000000000
[  270.907715] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  270.908606] CR2: 00007f453c00292c CR3: 000000103554e003 CR4: 00000000001606e0
[  270.909490] Call Trace:
[  270.910373]  tls_tx_records+0x138/0x1c0 [tls]
[  270.911262]  tls_sw_sendpage+0x3e0/0x420 [tls]
[  270.912154]  inet_sendpage+0x52/0x90
[  270.913045]  ? direct_splice_actor+0x40/0x40
[  270.913941]  kernel_sendpage+0x1a/0x30
[  270.914831]  sock_sendpage+0x20/0x30
[  270.915714]  pipe_to_sendpage+0x62/0x90
[  270.916592]  __splice_from_pipe+0x80/0x180
[  270.917461]  ? direct_splice_actor+0x40/0x40
[  270.918334]  splice_from_pipe+0x5d/0x90
[  270.919208]  direct_splice_actor+0x35/0x40
[  270.920086]  splice_direct_to_actor+0x103/0x230
[  270.920966]  ? generic_pipe_buf_nosteal+0x10/0x10
[  270.921850]  do_splice_direct+0x9a/0xd0
[  270.922733]  do_sendfile+0x1c9/0x3d0
[  270.923612]  __x64_sys_sendfile64+0x5c/0xc0

Signed-off-by: Pooja Trivedi <pooja.trivedi@stackpath.com>
---
 include/net/tls.h | 1 +
 net/tls/tls_sw.c  | 7 +++++++
 2 files changed, 8 insertions(+)

diff --git a/include/net/tls.h b/include/net/tls.h
index 41b2d41..f346a54 100644
--- a/include/net/tls.h
+++ b/include/net/tls.h
@@ -161,6 +161,7 @@ struct tls_sw_context_tx {
 
 #define BIT_TX_SCHEDULED	0
 #define BIT_TX_CLOSING		1
+#define BIT_TX_IN_PROGRESS	2
 	unsigned long tx_bitmask;
 };
 
diff --git a/net/tls/tls_sw.c b/net/tls/tls_sw.c
index 91d21b0..6e99c61 100644
--- a/net/tls/tls_sw.c
+++ b/net/tls/tls_sw.c
@@ -367,6 +367,10 @@ int tls_tx_records(struct sock *sk, int flags)
 	struct sk_msg *msg_en;
 	int tx_flags, rc = 0;
 
+	/* If another writer is already in tls_tx_records, backoff and leave */
+	if (test_and_set_bit(BIT_TX_IN_PROGRESS, &ctx->tx_bitmask))
+		return 0;
+
 	if (tls_is_partially_sent_record(tls_ctx)) {
 		rec = list_first_entry(&ctx->tx_list,
 				       struct tls_rec, list);
@@ -415,6 +419,9 @@ int tls_tx_records(struct sock *sk, int flags)
 	if (rc < 0 && rc != -EAGAIN)
 		tls_err_abort(sk, EBADMSG);
 
+	/* clear the bit so another writer can get into tls_tx_records */
+	clear_bit(BIT_TX_IN_PROGRESS, &ctx->tx_bitmask);
+
 	return rc;
 }
 
-- 
1.8.3.1

