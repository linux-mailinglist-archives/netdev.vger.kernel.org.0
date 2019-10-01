Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BE8A1C408B
	for <lists+netdev@lfdr.de>; Tue,  1 Oct 2019 21:00:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726678AbfJAS6f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Oct 2019 14:58:35 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:34520 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726413AbfJAS6d (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Oct 2019 14:58:33 -0400
Received: by mail-wm1-f65.google.com with SMTP id y135so3205035wmc.1
        for <netdev@vger.kernel.org>; Tue, 01 Oct 2019 11:58:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=4XmMCwacbhfx+GNe3M2A8fazL/6Apsrbd0MVUWfC12Y=;
        b=a3P8xBSKHA24VYaI3G2svlc7L5EvpcDiAxLrzC/jez3/3K3GwQ3x9GXL7Nk29T0F+6
         W5sy1uJC2drBrk3NbWdqX1X5GP2S4XTl5LSTZfcZZyHSvWRr6aVf+oArYuPx+o3OX/f4
         AXQ3zbgpkxrXd0d2ycEsOxUlMQfaeMkiDqRLnFqEPy2XUdVBjrQv4CAM4qmqsJeqHNF/
         9k/Q5dtzY8Yune8grp2rQTuSt+kb8uIna8ZXcW4hG19XXoz06SHPd2WX4DmXI+HXvog/
         HGmmnJyxYoAJ0O5a5jPesur/tfcm+fTl6YeY+n8HdBu78UT4FS+SZHCdhKlQAy/CGRye
         RJvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=4XmMCwacbhfx+GNe3M2A8fazL/6Apsrbd0MVUWfC12Y=;
        b=VyzpM/SmXC5vz9I+uJDEhg9hsjvEfRRG5ig6gtuJi6a8pTVCRo9n+Af0WPutT9F6x+
         AExAJ70q1nZ4Mvjw1WzFpSt5DF6+1wykuVsuFtIUA3Bt+7E1fTQ8n3wE/T0NVMDXbnYg
         3sKe2XUR3ObCOjffnb2ZHcdfL4yK+JeZLnAyokwLx9ZDrZkt8WB32kCWHQ9ftYVIwlqa
         RO8WjkY0APFzKeDfJU5lNCOWs9ccVoZvF6V+3vX3LEk40fxp/VGJjUeNz0JhNCFXF8Gl
         v9X4zA8pekoDMsc8fMh9Gm8V1ayFDRscTxDULEDkn2jTxqNtALfHHBD/unIPuxlg4oy0
         45ug==
X-Gm-Message-State: APjAAAXSXd6Y/QK+sOlT2tptkzvXJHD0Zh7DHLGj787QZiINYd8gr/Qi
        Gv8Muz82lltgkoAxgSaV+GU=
X-Google-Smtp-Source: APXvYqwFlkn8dhqVHCY50AEpsBdXTx5M0pEva3qsx5SPPkH2Q8LS8++RZdMsFz8i57Arx4+NHhQAIw==
X-Received: by 2002:a7b:c4c9:: with SMTP id g9mr5415644wmk.150.1569956309688;
        Tue, 01 Oct 2019 11:58:29 -0700 (PDT)
Received: from localhost.localdomain ([86.124.196.40])
        by smtp.gmail.com with ESMTPSA id f143sm8066997wme.40.2019.10.01.11.58.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Oct 2019 11:58:29 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     richardcochran@gmail.com, andrew@lunn.ch, f.fainelli@gmail.com,
        vivien.didelot@gmail.com, davem@davemloft.net
Cc:     netdev@vger.kernel.org, Vladimir Oltean <olteanv@gmail.com>
Subject: [PATCH v2 net 2/2] net: dsa: sja1105: Fix sleeping while atomic in .port_hwtstamp_set
Date:   Tue,  1 Oct 2019 21:58:19 +0300
Message-Id: <20191001185819.2539-3-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191001185819.2539-1-olteanv@gmail.com>
References: <20191001185819.2539-1-olteanv@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently this stack trace can be seen with CONFIG_DEBUG_ATOMIC_SLEEP=y:

[   41.568348] BUG: sleeping function called from invalid context at kernel/locking/mutex.c:909
[   41.576757] in_atomic(): 1, irqs_disabled(): 0, pid: 208, name: ptp4l
[   41.583212] INFO: lockdep is turned off.
[   41.587123] CPU: 1 PID: 208 Comm: ptp4l Not tainted 5.3.0-rc6-01445-ge950f2d4bc7f-dirty #1827
[   41.599873] [<c0313d7c>] (unwind_backtrace) from [<c030e13c>] (show_stack+0x10/0x14)
[   41.607584] [<c030e13c>] (show_stack) from [<c1212d50>] (dump_stack+0xd4/0x100)
[   41.614863] [<c1212d50>] (dump_stack) from [<c037dfc8>] (___might_sleep+0x1c8/0x2b4)
[   41.622574] [<c037dfc8>] (___might_sleep) from [<c122ea90>] (__mutex_lock+0x48/0xab8)
[   41.630368] [<c122ea90>] (__mutex_lock) from [<c122f51c>] (mutex_lock_nested+0x1c/0x24)
[   41.638340] [<c122f51c>] (mutex_lock_nested) from [<c0c6fe08>] (sja1105_static_config_reload+0x30/0x27c)
[   41.647779] [<c0c6fe08>] (sja1105_static_config_reload) from [<c0c7015c>] (sja1105_hwtstamp_set+0x108/0x1cc)
[   41.657562] [<c0c7015c>] (sja1105_hwtstamp_set) from [<c0feb650>] (dev_ifsioc+0x18c/0x330)
[   41.665788] [<c0feb650>] (dev_ifsioc) from [<c0febbd8>] (dev_ioctl+0x320/0x6e8)
[   41.673064] [<c0febbd8>] (dev_ioctl) from [<c0f8b1f4>] (sock_ioctl+0x334/0x5e8)
[   41.680340] [<c0f8b1f4>] (sock_ioctl) from [<c05404a8>] (do_vfs_ioctl+0xb0/0xa10)
[   41.687789] [<c05404a8>] (do_vfs_ioctl) from [<c0540e3c>] (ksys_ioctl+0x34/0x58)
[   41.695151] [<c0540e3c>] (ksys_ioctl) from [<c0301000>] (ret_fast_syscall+0x0/0x28)
[   41.702768] Exception stack(0xe8495fa8 to 0xe8495ff0)
[   41.707796] 5fa0:                   beff4a8c 00000001 00000011 000089b0 beff4a8c beff4a80
[   41.715933] 5fc0: beff4a8c 00000001 0000000c 00000036 b6fa98c8 004e19c1 00000001 00000000
[   41.724069] 5fe0: 004dcedc beff4a6c 004c0738 b6e7af4c
[   41.729860] BUG: scheduling while atomic: ptp4l/208/0x00000002
[   41.735682] INFO: lockdep is turned off.

Enabling RX timestamping will logically disturb the fastpath (processing
of meta frames). Replace bool hwts_rx_en with a bit that is checked
atomically from the fastpath and temporarily unset from the sleepable
context during a change of the RX timestamping process (a destructive
operation anyways, requires switch reset).
If found unset, the fastpath (net/dsa/tag_sja1105.c) will just drop any
received meta frame and not take the meta_lock at all.

Fixes: a602afd200f5 ("net: dsa: sja1105: Expose PTP timestamping ioctls to userspace")
Signed-off-by: Vladimir Oltean <olteanv@gmail.com>
---
 drivers/net/dsa/sja1105/sja1105_main.c | 19 +++++++++++--------
 include/linux/dsa/sja1105.h            |  4 +++-
 net/dsa/tag_sja1105.c                  | 12 +++++++++++-
 3 files changed, 25 insertions(+), 10 deletions(-)

diff --git a/drivers/net/dsa/sja1105/sja1105_main.c b/drivers/net/dsa/sja1105/sja1105_main.c
index ea2e7f4f96d0..7687ddcae159 100644
--- a/drivers/net/dsa/sja1105/sja1105_main.c
+++ b/drivers/net/dsa/sja1105/sja1105_main.c
@@ -1897,7 +1897,9 @@ static int sja1105_set_ageing_time(struct dsa_switch *ds,
 	return sja1105_static_config_reload(priv);
 }
 
-/* Caller must hold priv->tagger_data.meta_lock */
+/* Must be called only with priv->tagger_data.state bit
+ * SJA1105_HWTS_RX_EN cleared
+ */
 static int sja1105_change_rxtstamping(struct sja1105_private *priv,
 				      bool on)
 {
@@ -1954,16 +1956,17 @@ static int sja1105_hwtstamp_set(struct dsa_switch *ds, int port,
 		break;
 	}
 
-	if (rx_on != priv->tagger_data.hwts_rx_en) {
-		spin_lock(&priv->tagger_data.meta_lock);
+	if (rx_on != test_bit(SJA1105_HWTS_RX_EN, &priv->tagger_data.state)) {
+		clear_bit(SJA1105_HWTS_RX_EN, &priv->tagger_data.state);
+
 		rc = sja1105_change_rxtstamping(priv, rx_on);
-		spin_unlock(&priv->tagger_data.meta_lock);
 		if (rc < 0) {
 			dev_err(ds->dev,
 				"Failed to change RX timestamping: %d\n", rc);
-			return -EFAULT;
+			return rc;
 		}
-		priv->tagger_data.hwts_rx_en = rx_on;
+		if (rx_on)
+			set_bit(SJA1105_HWTS_RX_EN, &priv->tagger_data.state);
 	}
 
 	if (copy_to_user(ifr->ifr_data, &config, sizeof(config)))
@@ -1982,7 +1985,7 @@ static int sja1105_hwtstamp_get(struct dsa_switch *ds, int port,
 		config.tx_type = HWTSTAMP_TX_ON;
 	else
 		config.tx_type = HWTSTAMP_TX_OFF;
-	if (priv->tagger_data.hwts_rx_en)
+	if (test_bit(SJA1105_HWTS_RX_EN, &priv->tagger_data.state))
 		config.rx_filter = HWTSTAMP_FILTER_PTP_V2_L2_EVENT;
 	else
 		config.rx_filter = HWTSTAMP_FILTER_NONE;
@@ -2031,7 +2034,7 @@ static bool sja1105_port_rxtstamp(struct dsa_switch *ds, int port,
 	struct sja1105_private *priv = ds->priv;
 	struct sja1105_tagger_data *data = &priv->tagger_data;
 
-	if (!data->hwts_rx_en)
+	if (!test_bit(SJA1105_HWTS_RX_EN, &data->state))
 		return false;
 
 	/* We need to read the full PTP clock to reconstruct the Rx
diff --git a/include/linux/dsa/sja1105.h b/include/linux/dsa/sja1105.h
index 79435cfc20eb..897e799dbcb9 100644
--- a/include/linux/dsa/sja1105.h
+++ b/include/linux/dsa/sja1105.h
@@ -31,6 +31,8 @@
 #define SJA1105_META_SMAC			0x222222222222ull
 #define SJA1105_META_DMAC			0x0180C200000Eull
 
+#define SJA1105_HWTS_RX_EN			0
+
 /* Global tagger data: each struct sja1105_port has a reference to
  * the structure defined in struct sja1105_private.
  */
@@ -42,7 +44,7 @@ struct sja1105_tagger_data {
 	 * from taggers running on multiple ports on SMP systems
 	 */
 	spinlock_t meta_lock;
-	bool hwts_rx_en;
+	unsigned long state;
 };
 
 struct sja1105_skb_cb {
diff --git a/net/dsa/tag_sja1105.c b/net/dsa/tag_sja1105.c
index 9c9aff3e52cf..63ef2a14c934 100644
--- a/net/dsa/tag_sja1105.c
+++ b/net/dsa/tag_sja1105.c
@@ -156,7 +156,11 @@ static struct sk_buff
 	/* Step 1: A timestampable frame was received.
 	 * Buffer it until we get its meta frame.
 	 */
-	if (is_link_local && sp->data->hwts_rx_en) {
+	if (is_link_local) {
+		if (!test_bit(SJA1105_HWTS_RX_EN, &sp->data->state))
+			/* Do normal processing. */
+			return skb;
+
 		spin_lock(&sp->data->meta_lock);
 		/* Was this a link-local frame instead of the meta
 		 * that we were expecting?
@@ -187,6 +191,12 @@ static struct sk_buff
 	} else if (is_meta) {
 		struct sk_buff *stampable_skb;
 
+		/* Drop the meta frame if we're not in the right state
+		 * to process it.
+		 */
+		if (!test_bit(SJA1105_HWTS_RX_EN, &sp->data->state))
+			return NULL;
+
 		spin_lock(&sp->data->meta_lock);
 
 		stampable_skb = sp->data->stampable_skb;
-- 
2.17.1

