Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 77BC640B824
	for <lists+netdev@lfdr.de>; Tue, 14 Sep 2021 21:34:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233277AbhINTe6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Sep 2021 15:34:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232815AbhINTey (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Sep 2021 15:34:54 -0400
X-Greylist: delayed 484 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 14 Sep 2021 12:33:36 PDT
Received: from mail.aperture-lab.de (mail.aperture-lab.de [IPv6:2a01:4f8:c2c:665b::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5CFFCC061574;
        Tue, 14 Sep 2021 12:33:36 -0700 (PDT)
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id 7FA8241008;
        Tue, 14 Sep 2021 21:25:30 +0200 (CEST)
From:   =?UTF-8?q?Linus=20L=C3=BCssing?= <linus.luessing@c0d3.blue>
To:     Kalle Valo <kvalo@codeaurora.org>, Felix Fietkau <nbd@nbd.name>,
        Sujith Manoharan <c_manoha@qca.qualcomm.com>,
        ath9k-devel@qca.qualcomm.com
Cc:     linux-wireless@vger.kernel.org,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "John W . Linville" <linville@tuxdriver.com>,
        Felix Fietkau <nbd@openwrt.org>,
        Simon Wunderlich <sw@simonwunderlich.de>,
        Sven Eckelmann <sven@narfation.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        =?UTF-8?q?Linus=20L=C3=BCssing?= <ll@simonwunderlich.de>
Subject: [PATCH 1/3] ath9k: add option to reset the wifi chip via debugfs
Date:   Tue, 14 Sep 2021 21:25:13 +0200
Message-Id: <20210914192515.9273-2-linus.luessing@c0d3.blue>
In-Reply-To: <20210914192515.9273-1-linus.luessing@c0d3.blue>
References: <20210914192515.9273-1-linus.luessing@c0d3.blue>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Last-TLS-Session-Version: TLSv1.3
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Linus Lüssing <ll@simonwunderlich.de>

Sometimes, in yet unknown cases the wifi chip stops working. To allow a
watchdog in userspace to easily and quickly reset the wifi chip, add the
according functionality to userspace. A reset can then be triggered
via:

  $ echo 1 > /sys/kernel/debug/ieee80211/phy0/ath9k/reset

The number of user resets can further be tracked in the row "User reset"
in the same file.

So far people usually used "iw scan" to fix ath9k chip hangs from
userspace. Which triggers the ath9k_queue_reset(), too. The reset file
however has the advantage of less overhead, which makes debugging bugs
within ath9k_queue_reset() easier.

Signed-off-by: Linus Lüssing <ll@simonwunderlich.de>
---
 drivers/net/wireless/ath/ath9k/debug.c | 57 ++++++++++++++++++++++++--
 drivers/net/wireless/ath/ath9k/debug.h |  1 +
 2 files changed, 54 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/debug.c b/drivers/net/wireless/ath/ath9k/debug.c
index 4c81b1d7f417..fb7a2952d0ce 100644
--- a/drivers/net/wireless/ath/ath9k/debug.c
+++ b/drivers/net/wireless/ath/ath9k/debug.c
@@ -749,9 +749,9 @@ static int read_file_misc(struct seq_file *file, void *data)
 
 static int read_file_reset(struct seq_file *file, void *data)
 {
-	struct ieee80211_hw *hw = dev_get_drvdata(file->private);
-	struct ath_softc *sc = hw->priv;
+	struct ath_softc *sc = file->private;
 	static const char * const reset_cause[__RESET_TYPE_MAX] = {
+		[RESET_TYPE_USER] = "User reset",
 		[RESET_TYPE_BB_HANG] = "Baseband Hang",
 		[RESET_TYPE_BB_WATCHDOG] = "Baseband Watchdog",
 		[RESET_TYPE_FATAL_INT] = "Fatal HW Error",
@@ -779,6 +779,55 @@ static int read_file_reset(struct seq_file *file, void *data)
 	return 0;
 }
 
+static int open_file_reset(struct inode *inode, struct file *f)
+{
+	return single_open(f, read_file_reset, inode->i_private);
+}
+
+static ssize_t write_file_reset(struct file *file,
+				const char __user *user_buf,
+				size_t count, loff_t *ppos)
+{
+	struct ath_softc *sc = file_inode(file)->i_private;
+	struct ath_hw *ah = sc->sc_ah;
+	struct ath_common *common = ath9k_hw_common(ah);
+	unsigned long val;
+	char buf[32];
+	ssize_t len;
+
+	len = min(count, sizeof(buf) - 1);
+	if (copy_from_user(buf, user_buf, len))
+		return -EFAULT;
+
+	buf[len] = '\0';
+	if (kstrtoul(buf, 0, &val))
+		return -EINVAL;
+
+	if (val != 1)
+		return -EINVAL;
+
+	/* avoid rearming hw_reset_work on shutdown */
+	mutex_lock(&sc->mutex);
+	if (test_bit(ATH_OP_INVALID, &common->op_flags)) {
+		mutex_unlock(&sc->mutex);
+		return -EBUSY;
+	}
+
+	ath9k_queue_reset(sc, RESET_TYPE_USER);
+	mutex_unlock(&sc->mutex);
+
+	return count;
+}
+
+static const struct file_operations fops_reset = {
+	.read = seq_read,
+	.write = write_file_reset,
+	.open = open_file_reset,
+	.owner = THIS_MODULE,
+	.llseek = seq_lseek,
+	.release = single_release,
+};
+
 void ath_debug_stat_tx(struct ath_softc *sc, struct ath_buf *bf,
 		       struct ath_tx_status *ts, struct ath_txq *txq,
 		       unsigned int flags)
@@ -1393,8 +1442,8 @@ int ath9k_init_debug(struct ath_hw *ah)
 				    read_file_queues);
 	debugfs_create_devm_seqfile(sc->dev, "misc", sc->debug.debugfs_phy,
 				    read_file_misc);
-	debugfs_create_devm_seqfile(sc->dev, "reset", sc->debug.debugfs_phy,
-				    read_file_reset);
+	debugfs_create_file("reset", 0600, sc->debug.debugfs_phy,
+			    sc, &fops_reset);
 
 	ath9k_cmn_debug_recv(sc->debug.debugfs_phy, &sc->debug.stats.rxstats);
 	ath9k_cmn_debug_phy_err(sc->debug.debugfs_phy, &sc->debug.stats.rxstats);
diff --git a/drivers/net/wireless/ath/ath9k/debug.h b/drivers/net/wireless/ath/ath9k/debug.h
index 33826aa13687..389459c04d14 100644
--- a/drivers/net/wireless/ath/ath9k/debug.h
+++ b/drivers/net/wireless/ath/ath9k/debug.h
@@ -39,6 +39,7 @@ struct fft_sample_tlv;
 #endif
 
 enum ath_reset_type {
+	RESET_TYPE_USER,
 	RESET_TYPE_BB_HANG,
 	RESET_TYPE_BB_WATCHDOG,
 	RESET_TYPE_FATAL_INT,
-- 
2.31.0

