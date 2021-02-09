Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 340B131568C
	for <lists+netdev@lfdr.de>; Tue,  9 Feb 2021 20:12:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233336AbhBITLV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Feb 2021 14:11:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233077AbhBIS6h (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Feb 2021 13:58:37 -0500
X-Greylist: delayed 570 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 09 Feb 2021 10:57:53 PST
Received: from mail.aperture-lab.de (mail.aperture-lab.de [IPv6:2a01:4f8:171:314c::100:a1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61827C0613D6;
        Tue,  9 Feb 2021 10:57:52 -0800 (PST)
From:   =?UTF-8?q?Linus=20L=C3=BCssing?= <linus.luessing@c0d3.blue>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=c0d3.blue; s=2018;
        t=1612896273;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=hOL6dc5Vpk4JALYPv2LREMiGbKlkP1zbjhOIL9R5Q5s=;
        b=KcV2u/Zza1WHX+6jeNi0bsy0ZZJerGiuy8DIlqmdYuBV3Z3PlXwV4TB8xnHK14QwYaie4c
        UjsRpMTyGF1kLdbGqsj0i7i5qsvh1MELtfMKzJ56yp5BM/SAyO6ziPK5iwy224TtC18Iwl
        ztPrb+BWp8GjUyk5uFK79gqdhRg3P0p1L1pJbqHmyya1xUeD/dzza1pmE4beD9SYAHEdQa
        IHF10XorFOqQLGRUcnFldPQYkxq993BFSqXF0XLT21Zo2bVNinoLj7a3pw17K57C4GwV/L
        ayvcKzW/nA0vLu5b5CFhmmEls0EhqlmyF6oP5Rn1hK1ASQUC/FfDTt5VIoVPFw==
To:     Kalle Valo <kvalo@codeaurora.org>, ath9k-devel@qca.qualcomm.com,
        Simon Wunderlich <sw@simonwunderlich.de>
Cc:     linux-wireless@vger.kernel.org,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Mathias Kretschmer <mathias.kretschmer@fit.fraunhofer.de>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        =?UTF-8?q?Linus=20L=C3=BCssing?= <ll@simonwunderlich.de>
Subject: [PATCH] ath9k: fix data bus crash when setting nf_override via debugfs
Date:   Tue,  9 Feb 2021 19:43:52 +0100
Message-Id: <20210209184352.4272-1-linus.luessing@c0d3.blue>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Authentication-Results: ORIGINATING;
        auth=pass smtp.auth=linus.luessing@c0d3.blue smtp.mailfrom=linus.luessing@c0d3.blue
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Linus Lüssing <ll@simonwunderlich.de>

When trying to set the noise floor via debugfs, a "data bus error"
crash like the following can happen:

[   88.433133] Data bus error, epc == 80221c28, ra == 83314e60
[   88.438895] Oops[#1]:
[   88.441246] CPU: 0 PID: 7263 Comm: sh Not tainted 4.14.195 #0
[   88.447174] task: 838a1c20 task.stack: 82d5e000
[   88.451847] $ 0   : 00000000 00000030 deadc0de 83141de4
[   88.457248] $ 4   : b810a2c4 0000a2c4 83230fd4 00000000
[   88.462652] $ 8   : 0000000a 00000000 00000001 00000000
[   88.468055] $12   : 7f8ef318 00000000 00000000 77f802a0
[   88.473457] $16   : 83230080 00000002 0000001b 83230080
[   88.478861] $20   : 83a1c3f8 00841000 77f7adb0 ffffff92
[   88.484263] $24   : 00000fa4 77edd860
[   88.489665] $28   : 82d5e000 82d5fda8 00000000 83314e60
[   88.495070] Hi    : 00000000
[   88.498044] Lo    : 00000000
[   88.501040] epc   : 80221c28 ioread32+0x8/0x10
[   88.505671] ra    : 83314e60 ath9k_hw_loadnf+0x88/0x520 [ath9k_hw]
[   88.512049] Status: 1000fc03 KERNEL EXL IE
[   88.516369] Cause : 5080801c (ExcCode 07)
[   88.520508] PrId  : 00019374 (MIPS 24Kc)
[   88.524556] Modules linked in: ath9k ath9k_common pppoe ppp_async l2tp_ppp cdc_mbim batman_adv ath9k_hw ath sr9700 smsc95xx sierra_net rndis_host qmi_wwan pppox ppp_generic pl2303 nf_conntrack_ipv6 mcs7830 mac80211 kalmia iptable_nat ipt_REJECT ipt_MASQUERADE huawei_cdc_ncm ftdi_sio dm9601 cfg80211 cdc_subset cdc_ncm cdc_ether cdc_eem ax88179_178a asix xt_time xt_tcpudp xt_tcpmss xt_statistic xt_state xt_nat xt_multiport xt_mark xt_mac xt_limit xt_length xt_hl xt_ecn xt_dscp xt_conntrack xt_comment xt_TCPMSS xt_REDIRECT xt_NETMAP xt_LOG xt_HL xt_FLOWOFFLOAD xt_DSCP xt_CLASSIFY usbserial usbnet usbhid slhc rtl8150 r8152 pegasus nf_reject_ipv4 nf_nat_redirect nf_nat_masquerade_ipv4 nf_conntrack_ipv4 nf_nat_ipv4 nf_nat nf_log_ipv4 nf_flow_table_hw nf_flow_table nf_defrag_ipv6 nf_defrag_ipv4 nf_conntrack
[   88.597894]  libcrc32c kaweth iptable_mangle iptable_filter ipt_ECN ipheth ip_tables hso hid_generic crc_ccitt compat cdc_wdm cdc_acm br_netfilter hid evdev input_core nf_log_ipv6 nf_log_common ip6table_mangle ip6table_filter ip6_tables ip6t_REJECT x_tables nf_reject_ipv6 l2tp_netlink l2tp_core udp_tunnel ip6_udp_tunnel xfrm6_mode_tunnel xfrm6_mode_transport xfrm6_mode_beet ipcomp6 xfrm6_tunnel esp6 ah6 xfrm4_tunnel xfrm4_mode_tunnel xfrm4_mode_transport xfrm4_mode_beet ipcomp esp4 ah4 tunnel6 tunnel4 tun xfrm_user xfrm_ipcomp af_key xfrm_algo sha256_generic sha1_generic jitterentropy_rng drbg md5 hmac echainiv des_generic deflate zlib_inflate zlib_deflate cbc authenc crypto_acompress ehci_platform ehci_hcd gpio_button_hotplug usbcore nls_base usb_common crc16 mii aead crypto_null cryptomgr crc32c_generic
[   88.671671]  crypto_hash
[   88.674292] Process sh (pid: 7263, threadinfo=82d5e000, task=838a1c20, tls=77f81efc)
[   88.682279] Stack : 00008060 00000008 00000200 00000000 00000000 00000000 00000000 00000002
[   88.690916]         80500000 83230080 82d5fe22 00841000 77f7adb0 00000000 00000000 83156858
[   88.699553]         00000000 8352fa00 83ad62b0 835302a8 00000000 300a00f8 00000003 82d5fe38
[   88.708190]         82d5fef4 00000001 77f54dc4 77f80000 77f7adb0 c79fe901 00000000 00000000
[   88.716828]         80510000 00000002 00841000 77f54dc4 77f80000 801ce4cc 0000000b 41824292
[   88.725465]         ...
[   88.727994] Call Trace:
[   88.730532] [<80221c28>] ioread32+0x8/0x10
[   88.734765] Code: 00000000  8c820000  0000000f <03e00008> 00000000  08088708  00000000  aca40000  03e00008
[   88.744846]
[   88.746464] ---[ end trace db226b2de1b69b9e ]---
[   88.753477] Kernel panic - not syncing: Fatal exception
[   88.759981] Rebooting in 3 seconds..

The "REG_READ(ah, AR_PHY_AGC_CONTROL)" in ath9k_hw_loadnf() does not
like being called when the hardware is asleep, leading to this crash.

The easiest way to reproduce this is trying to set nf_override while
the hardware is down:

  $ ip link set down dev wlan0
  $ echo "-85" > /sys/kernel/debug/ieee80211/phy0/ath9k/nf_override

Fixing this crash by waking the hardware up before trying to set the
noise floor. Similar to what other ath9k debugfs files do.

Tested on a Lima board from 8devices, which has a QCA 4531 chipset.

Fixes: b90189759a7f ("ath9k: add noise floor override option")
Cc: Simon Wunderlich <sw@simonwunderlich.de>
Signed-off-by: Linus Lüssing <ll@simonwunderlich.de>
---
 drivers/net/wireless/ath/ath9k/debug.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath9k/debug.c b/drivers/net/wireless/ath/ath9k/debug.c
index 017a43bc400c..4c81b1d7f417 100644
--- a/drivers/net/wireless/ath/ath9k/debug.c
+++ b/drivers/net/wireless/ath/ath9k/debug.c
@@ -1223,8 +1223,11 @@ static ssize_t write_file_nf_override(struct file *file,
 
 	ah->nf_override = val;
 
-	if (ah->curchan)
+	if (ah->curchan) {
+		ath9k_ps_wakeup(sc);
 		ath9k_hw_loadnf(ah, ah->curchan);
+		ath9k_ps_restore(sc);
+	}
 
 	return count;
 }
-- 
2.29.2

