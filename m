Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DBA2747817
	for <lists+netdev@lfdr.de>; Mon, 17 Jun 2019 04:08:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727796AbfFQCHz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 16 Jun 2019 22:07:55 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:45356 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727485AbfFQCG5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 16 Jun 2019 22:06:57 -0400
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x5H26rIi135268
        for <netdev@vger.kernel.org>; Sun, 16 Jun 2019 22:06:56 -0400
Received: from e06smtp02.uk.ibm.com (e06smtp02.uk.ibm.com [195.75.94.98])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2t5vdn7e7v-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Sun, 16 Jun 2019 22:06:55 -0400
Received: from localhost
        by e06smtp02.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <netdev@vger.kernel.org> from <alastair@au1.ibm.com>;
        Mon, 17 Jun 2019 03:06:52 +0100
Received: from b06cxnps3075.portsmouth.uk.ibm.com (9.149.109.195)
        by e06smtp02.uk.ibm.com (192.168.101.132) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Mon, 17 Jun 2019 03:06:44 +0100
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x5H26hnJ63242362
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 17 Jun 2019 02:06:43 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2930C52059;
        Mon, 17 Jun 2019 02:06:43 +0000 (GMT)
Received: from ozlabs.au.ibm.com (unknown [9.192.253.14])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 924825204E;
        Mon, 17 Jun 2019 02:06:42 +0000 (GMT)
Received: from adsilva.ozlabs.ibm.com (haven.au.ibm.com [9.192.254.114])
        (using TLSv1.2 with cipher DHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ozlabs.au.ibm.com (Postfix) with ESMTPSA id 7FC7BA0208;
        Mon, 17 Jun 2019 12:06:41 +1000 (AEST)
From:   "Alastair D'Silva" <alastair@au1.ibm.com>
To:     alastair@d-silva.org
Cc:     Jani Nikula <jani.nikula@linux.intel.com>,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Karsten Keil <isdn@linux-pingi.de>,
        Jassi Brar <jassisinghbrar@gmail.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jose Abreu <Jose.Abreu@synopsys.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Stanislaw Gruszka <sgruszka@redhat.com>,
        Benson Leung <bleung@chromium.org>,
        Enric Balletbo i Serra <enric.balletbo@collabora.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Petr Mladek <pmladek@suse.com>,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        David Laight <David.Laight@ACULAB.COM>,
        Andrew Morton <akpm@linux-foundation.org>,
        intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        ath10k@lists.infradead.org, linux-wireless@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-fbdev@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-fsdevel@vger.kernel.org
Subject: [PATCH v3 4/7] lib/hexdump.c: Replace ascii bool in hex_dump_to_buffer with flags
Date:   Mon, 17 Jun 2019 12:04:27 +1000
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190617020430.8708-1-alastair@au1.ibm.com>
References: <20190617020430.8708-1-alastair@au1.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
x-cbid: 19061702-0008-0000-0000-000002F449E1
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19061702-0009-0000-0000-000022615945
Message-Id: <20190617020430.8708-5-alastair@au1.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-06-17_01:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1011 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1906170019
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alastair D'Silva <alastair@d-silva.org>

In order to support additional features in hex_dump_to_buffer, replace
the ascii bool parameter with flags.

Signed-off-by: Alastair D'Silva <alastair@d-silva.org>
---
 drivers/gpu/drm/i915/intel_engine_cs.c            |  2 +-
 drivers/isdn/hardware/mISDN/mISDNisar.c           |  6 ++++--
 drivers/mailbox/mailbox-test.c                    |  2 +-
 drivers/net/ethernet/amd/xgbe/xgbe-drv.c          |  2 +-
 drivers/net/ethernet/synopsys/dwc-xlgmac-common.c |  2 +-
 drivers/net/wireless/ath/ath10k/debug.c           |  3 ++-
 drivers/net/wireless/intel/iwlegacy/3945-mac.c    |  2 +-
 drivers/platform/chrome/wilco_ec/debugfs.c        |  2 +-
 drivers/scsi/scsi_logging.c                       |  8 +++-----
 drivers/staging/fbtft/fbtft-core.c                |  2 +-
 fs/seq_file.c                                     |  3 ++-
 include/linux/printk.h                            |  8 ++++----
 lib/hexdump.c                                     | 15 ++++++++-------
 lib/test_hexdump.c                                |  5 +++--
 14 files changed, 33 insertions(+), 29 deletions(-)

diff --git a/drivers/gpu/drm/i915/intel_engine_cs.c b/drivers/gpu/drm/i915/intel_engine_cs.c
index eea9bec04f1b..5df5fffdb848 100644
--- a/drivers/gpu/drm/i915/intel_engine_cs.c
+++ b/drivers/gpu/drm/i915/intel_engine_cs.c
@@ -1340,7 +1340,7 @@ static void hexdump(struct drm_printer *m, const void *buf, size_t len)
 		WARN_ON_ONCE(hex_dump_to_buffer(buf + pos, len - pos,
 						rowsize, sizeof(u32),
 						line, sizeof(line),
-						false) >= sizeof(line));
+						0) >= sizeof(line));
 		drm_printf(m, "[%04zx] %s\n", pos, line);
 
 		prev = buf + pos;
diff --git a/drivers/isdn/hardware/mISDN/mISDNisar.c b/drivers/isdn/hardware/mISDN/mISDNisar.c
index fd5c52f37802..ccc0ee9d894f 100644
--- a/drivers/isdn/hardware/mISDN/mISDNisar.c
+++ b/drivers/isdn/hardware/mISDN/mISDNisar.c
@@ -71,7 +71,8 @@ send_mbox(struct isar_hw *isar, u8 his, u8 creg, u8 len, u8 *msg)
 
 			while (l < (int)len) {
 				hex_dump_to_buffer(msg + l, len - l, 32, 1,
-						   isar->log, 256, 1);
+						   isar->log, 256,
+						   HEXDUMP_ASCII);
 				pr_debug("%s: %s %02x: %s\n", isar->name,
 					 __func__, l, isar->log);
 				l += 32;
@@ -100,7 +101,8 @@ rcv_mbox(struct isar_hw *isar, u8 *msg)
 
 			while (l < (int)isar->clsb) {
 				hex_dump_to_buffer(msg + l, isar->clsb - l, 32,
-						   1, isar->log, 256, 1);
+						   1, isar->log, 256,
+						   HEXDUMP_ASCII);
 				pr_debug("%s: %s %02x: %s\n", isar->name,
 					 __func__, l, isar->log);
 				l += 32;
diff --git a/drivers/mailbox/mailbox-test.c b/drivers/mailbox/mailbox-test.c
index 4555d678fadd..23c3fbafdcb2 100644
--- a/drivers/mailbox/mailbox-test.c
+++ b/drivers/mailbox/mailbox-test.c
@@ -209,7 +209,7 @@ static ssize_t mbox_test_message_read(struct file *filp, char __user *userbuf,
 		hex_dump_to_buffer(ptr,
 				   MBOX_BYTES_PER_LINE,
 				   MBOX_BYTES_PER_LINE, 1, touser + l,
-				   MBOX_HEXDUMP_LINE_LEN, true);
+				   MBOX_HEXDUMP_LINE_LEN, HEXDUMP_ASCII);
 
 		ptr += MBOX_BYTES_PER_LINE;
 		l += MBOX_HEXDUMP_LINE_LEN;
diff --git a/drivers/net/ethernet/amd/xgbe/xgbe-drv.c b/drivers/net/ethernet/amd/xgbe/xgbe-drv.c
index 3dd0cecddba8..1e26410cf6c2 100644
--- a/drivers/net/ethernet/amd/xgbe/xgbe-drv.c
+++ b/drivers/net/ethernet/amd/xgbe/xgbe-drv.c
@@ -2992,7 +2992,7 @@ void xgbe_print_pkt(struct net_device *netdev, struct sk_buff *skb, bool tx_rx)
 		unsigned int len = min(skb->len - i, 32U);
 
 		hex_dump_to_buffer(&skb->data[i], len, 32, 1,
-				   buffer, sizeof(buffer), false);
+				   buffer, sizeof(buffer), 0);
 		netdev_dbg(netdev, "  %#06x: %s\n", i, buffer);
 	}
 
diff --git a/drivers/net/ethernet/synopsys/dwc-xlgmac-common.c b/drivers/net/ethernet/synopsys/dwc-xlgmac-common.c
index eb1c6b03c329..b80adfa1f890 100644
--- a/drivers/net/ethernet/synopsys/dwc-xlgmac-common.c
+++ b/drivers/net/ethernet/synopsys/dwc-xlgmac-common.c
@@ -349,7 +349,7 @@ void xlgmac_print_pkt(struct net_device *netdev,
 		unsigned int len = min(skb->len - i, 32U);
 
 		hex_dump_to_buffer(&skb->data[i], len, 32, 1,
-				   buffer, sizeof(buffer), false);
+				   buffer, sizeof(buffer), 0);
 		netdev_dbg(netdev, "  %#06x: %s\n", i, buffer);
 	}
 
diff --git a/drivers/net/wireless/ath/ath10k/debug.c b/drivers/net/wireless/ath/ath10k/debug.c
index 32d967a31c65..4c99ea03226d 100644
--- a/drivers/net/wireless/ath/ath10k/debug.c
+++ b/drivers/net/wireless/ath/ath10k/debug.c
@@ -2662,7 +2662,8 @@ void ath10k_dbg_dump(struct ath10k *ar,
 						(unsigned int)(ptr - buf));
 			hex_dump_to_buffer(ptr, len - (ptr - buf), 16, 1,
 					   linebuf + linebuflen,
-					   sizeof(linebuf) - linebuflen, true);
+					   sizeof(linebuf) - linebuflen,
+					   HEXDUMP_ASCII);
 			dev_printk(KERN_DEBUG, ar->dev, "%s\n", linebuf);
 		}
 	}
diff --git a/drivers/net/wireless/intel/iwlegacy/3945-mac.c b/drivers/net/wireless/intel/iwlegacy/3945-mac.c
index b82da75a9ae3..81c4b178527a 100644
--- a/drivers/net/wireless/intel/iwlegacy/3945-mac.c
+++ b/drivers/net/wireless/intel/iwlegacy/3945-mac.c
@@ -3232,7 +3232,7 @@ il3945_show_measurement(struct device *d, struct device_attribute *attr,
 
 	while (size && PAGE_SIZE - len) {
 		hex_dump_to_buffer(data + ofs, size, 16, 1, buf + len,
-				   PAGE_SIZE - len, true);
+				   PAGE_SIZE - len, HEXDUMP_ASCII);
 		len = strlen(buf);
 		if (PAGE_SIZE - len)
 			buf[len++] = '\n';
diff --git a/drivers/platform/chrome/wilco_ec/debugfs.c b/drivers/platform/chrome/wilco_ec/debugfs.c
index f163476d080d..c53b18539f52 100644
--- a/drivers/platform/chrome/wilco_ec/debugfs.c
+++ b/drivers/platform/chrome/wilco_ec/debugfs.c
@@ -148,7 +148,7 @@ static ssize_t raw_read(struct file *file, char __user *user_buf, size_t count,
 					     debug_info->response_size,
 					     16, 1, debug_info->formatted_data,
 					     sizeof(debug_info->formatted_data),
-					     true);
+					     HEXDUMP_ASCII);
 		/* Only return response the first time it is read */
 		debug_info->response_size = 0;
 	}
diff --git a/drivers/scsi/scsi_logging.c b/drivers/scsi/scsi_logging.c
index 39b8cc4574b4..c7f3eb41d32c 100644
--- a/drivers/scsi/scsi_logging.c
+++ b/drivers/scsi/scsi_logging.c
@@ -262,7 +262,7 @@ void scsi_print_command(struct scsi_cmnd *cmd)
 						 "CDB[%02x]: ", k);
 				hex_dump_to_buffer(&cmd->cmnd[k], linelen,
 						   16, 1, logbuf + off,
-						   logbuf_len - off, false);
+						   logbuf_len - off, 0);
 			}
 			dev_printk(KERN_INFO, &cmd->device->sdev_gendev, "%s",
 				   logbuf);
@@ -273,8 +273,7 @@ void scsi_print_command(struct scsi_cmnd *cmd)
 	if (!WARN_ON(off > logbuf_len - 49)) {
 		off += scnprintf(logbuf + off, logbuf_len - off, " ");
 		hex_dump_to_buffer(cmd->cmnd, cmd->cmd_len, 16, 1,
-				   logbuf + off, logbuf_len - off,
-				   false);
+				   logbuf + off, logbuf_len - off, 0);
 	}
 out_printk:
 	dev_printk(KERN_INFO, &cmd->device->sdev_gendev, "%s", logbuf);
@@ -353,8 +352,7 @@ scsi_log_dump_sense(const struct scsi_device *sdev, const char *name, int tag,
 		off = sdev_format_header(logbuf, logbuf_len,
 					 name, tag);
 		hex_dump_to_buffer(&sense_buffer[i], len, 16, 1,
-				   logbuf + off, logbuf_len - off,
-				   false);
+				   logbuf + off, logbuf_len - off, 0);
 		dev_printk(KERN_INFO, &sdev->sdev_gendev, "%s", logbuf);
 	}
 	scsi_log_release_buffer(logbuf);
diff --git a/drivers/staging/fbtft/fbtft-core.c b/drivers/staging/fbtft/fbtft-core.c
index 9b07badf4c6c..2e5df5cc9d61 100644
--- a/drivers/staging/fbtft/fbtft-core.c
+++ b/drivers/staging/fbtft/fbtft-core.c
@@ -61,7 +61,7 @@ void fbtft_dbg_hex(const struct device *dev, int groupsize,
 	va_end(args);
 
 	hex_dump_to_buffer(buf, len, 32, groupsize, text + text_len,
-			   512 - text_len, false);
+			   512 - text_len, 0);
 
 	if (len > 32)
 		dev_info(dev, "%s ...\n", text);
diff --git a/fs/seq_file.c b/fs/seq_file.c
index abe27ec43176..472a8acb7405 100644
--- a/fs/seq_file.c
+++ b/fs/seq_file.c
@@ -874,7 +874,8 @@ void seq_hex_dump(struct seq_file *m, const char *prefix_str, int prefix_type,
 
 		size = seq_get_buf(m, &buffer);
 		ret = hex_dump_to_buffer(ptr + i, linelen, rowsize, groupsize,
-					 buffer, size, ascii);
+					 buffer, size,
+					 ascii ? HEXDUMP_ASCII : 0);
 		seq_commit(m, ret < size ? ret : -1);
 
 		seq_putc(m, '\n');
diff --git a/include/linux/printk.h b/include/linux/printk.h
index d7754799cfe0..97dd29a2bd77 100644
--- a/include/linux/printk.h
+++ b/include/linux/printk.h
@@ -482,13 +482,13 @@ enum {
 	DUMP_PREFIX_OFFSET
 };
 
-extern int hex_dump_to_buffer(const void *buf, size_t len, int rowsize,
-			      int groupsize, char *linebuf, size_t linebuflen,
-			      bool ascii);
-
 #define HEXDUMP_ASCII			BIT(0)
 #define HEXDUMP_SUPPRESS_REPEATED	BIT(1)
 
+extern int hex_dump_to_buffer(const void *buf, size_t len, int rowsize,
+			      int groupsize, char *linebuf, size_t linebuflen,
+			      u32 flags);
+
 #ifdef CONFIG_PRINTK
 extern void print_hex_dump_ext(const char *level, const char *prefix_str,
 			   int prefix_type, int rowsize, int groupsize,
diff --git a/lib/hexdump.c b/lib/hexdump.c
index b781f888884e..08c6084d7daa 100644
--- a/lib/hexdump.c
+++ b/lib/hexdump.c
@@ -85,7 +85,8 @@ EXPORT_SYMBOL(bin2hex);
  * @groupsize: number of bytes to print at a time (1, 2, 4, 8; default = 1)
  * @linebuf: where to put the converted data
  * @linebuflen: total size of @linebuf, including space for terminating NUL
- * @ascii: include ASCII after the hex output
+ * @flags: A bitwise OR of the following flags:
+ *	HEXDUMP_ASCII:			include ASCII after the hex output
  *
  * hex_dump_to_buffer() works on one "line" of output at a time, converting
  * <groupsize> bytes of input to hexadecimal (and optionally printable ASCII)
@@ -97,7 +98,7 @@ EXPORT_SYMBOL(bin2hex);
  *
  * E.g.:
  *   hex_dump_to_buffer(frame->data, frame->len, 16, 1,
- *			linebuf, sizeof(linebuf), true);
+ *			linebuf, sizeof(linebuf), HEXDUMP_ASCII);
  *
  * example output buffer:
  * 40 41 42 43 44 45 46 47 48 49 4a 4b 4c 4d 4e 4f  @ABCDEFGHIJKLMNO
@@ -109,7 +110,7 @@ EXPORT_SYMBOL(bin2hex);
  * string if enough space had been available.
  */
 int hex_dump_to_buffer(const void *buf, size_t len, int rowsize, int groupsize,
-		       char *linebuf, size_t linebuflen, bool ascii)
+		       char *linebuf, size_t linebuflen, u32 flags)
 {
 	const u8 *ptr = buf;
 	int ngroups;
@@ -187,7 +188,7 @@ int hex_dump_to_buffer(const void *buf, size_t len, int rowsize, int groupsize,
 		if (j)
 			lx--;
 	}
-	if (!ascii)
+	if (!(flags & HEXDUMP_ASCII))
 		goto nil;
 
 	while (lx < ascii_column) {
@@ -207,7 +208,8 @@ int hex_dump_to_buffer(const void *buf, size_t len, int rowsize, int groupsize,
 overflow2:
 	linebuf[lx++] = '\0';
 overflow1:
-	return ascii ? ascii_column + len : (groupsize * 2 + 1) * ngroups - 1;
+	return (flags & HEXDUMP_ASCII) ? ascii_column + len :
+					 (groupsize * 2 + 1) * ngroups - 1;
 }
 EXPORT_SYMBOL(hex_dump_to_buffer);
 
@@ -336,8 +338,7 @@ void print_hex_dump_ext(const char *level, const char *prefix_str,
 		}
 
 		hex_dump_to_buffer(ptr + i, linelen, rowsize, groupsize,
-				   linebuf, linebuf_len,
-				   flags & HEXDUMP_ASCII);
+				   linebuf, linebuf_len, flags);
 
 		switch (prefix_type) {
 		case DUMP_PREFIX_ADDRESS:
diff --git a/lib/test_hexdump.c b/lib/test_hexdump.c
index 6ab75a209b43..ae340c5c1c6f 100644
--- a/lib/test_hexdump.c
+++ b/lib/test_hexdump.c
@@ -166,7 +166,7 @@ static void __init test_hexdump(size_t len, int rowsize, int groupsize,
 
 	memset(real, FILL_CHAR, sizeof(real));
 	hex_dump_to_buffer(data_b, len, rowsize, groupsize, real, sizeof(real),
-			   ascii);
+			   ascii ? HEXDUMP_ASCII : 0);
 
 	memset(test, FILL_CHAR, sizeof(test));
 	test_hexdump_prepare_test(len, rowsize, groupsize, test, sizeof(test),
@@ -204,7 +204,8 @@ static void __init test_hexdump_overflow(size_t buflen, size_t len,
 
 	memset(buf, FILL_CHAR, sizeof(buf));
 
-	rc = hex_dump_to_buffer(data_b, len, rowsize, groupsize, buf, buflen, ascii);
+	rc = hex_dump_to_buffer(data_b, len, rowsize, groupsize, buf, buflen,
+				ascii ? HEXDUMP_ASCII : 0);
 
 	/*
 	 * Caller must provide the data length multiple of groupsize. The
-- 
2.21.0

