Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 74CE847805
	for <lists+netdev@lfdr.de>; Mon, 17 Jun 2019 04:07:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727602AbfFQCH2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 16 Jun 2019 22:07:28 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:57920 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727573AbfFQCG7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 16 Jun 2019 22:06:59 -0400
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x5H26vft098038
        for <netdev@vger.kernel.org>; Sun, 16 Jun 2019 22:06:58 -0400
Received: from e06smtp02.uk.ibm.com (e06smtp02.uk.ibm.com [195.75.94.98])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2t5v3b7rbv-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Sun, 16 Jun 2019 22:06:58 -0400
Received: from localhost
        by e06smtp02.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <netdev@vger.kernel.org> from <alastair@au1.ibm.com>;
        Mon, 17 Jun 2019 03:06:52 +0100
Received: from b06cxnps3075.portsmouth.uk.ibm.com (9.149.109.195)
        by e06smtp02.uk.ibm.com (192.168.101.132) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Mon, 17 Jun 2019 03:06:44 +0100
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x5H26hHs26214440
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 17 Jun 2019 02:06:43 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 125B45204F;
        Mon, 17 Jun 2019 02:06:43 +0000 (GMT)
Received: from ozlabs.au.ibm.com (unknown [9.192.253.14])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 7068C52051;
        Mon, 17 Jun 2019 02:06:42 +0000 (GMT)
Received: from adsilva.ozlabs.ibm.com (haven.au.ibm.com [9.192.254.114])
        (using TLSv1.2 with cipher DHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ozlabs.au.ibm.com (Postfix) with ESMTPSA id 596AAA0273;
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
Subject: [PATCH v3 2/7] lib/hexdump.c: Relax rowsize checks in hex_dump_to_buffer
Date:   Mon, 17 Jun 2019 12:04:25 +1000
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190617020430.8708-1-alastair@au1.ibm.com>
References: <20190617020430.8708-1-alastair@au1.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
x-cbid: 19061702-0008-0000-0000-000002F449E0
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19061702-0009-0000-0000-000022615946
Message-Id: <20190617020430.8708-3-alastair@au1.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-06-17_01:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1906170019
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alastair D'Silva <alastair@d-silva.org>

This patch removes the hardcoded row limits and allows for
other lengths. These lengths must still be a multiple of
groupsize.

This allows structs that are not 16/32 bytes to display on
a single line.

This patch also expands the self-tests to test row sizes
up to 64 bytes (though they can now be arbitrarily long).

Signed-off-by: Alastair D'Silva <alastair@d-silva.org>
---
 lib/hexdump.c      | 48 ++++++++++++++++++++++++++++--------------
 lib/test_hexdump.c | 52 ++++++++++++++++++++++++++++++++++++++--------
 2 files changed, 75 insertions(+), 25 deletions(-)

diff --git a/lib/hexdump.c b/lib/hexdump.c
index 81b70ed37209..3943507bc0e9 100644
--- a/lib/hexdump.c
+++ b/lib/hexdump.c
@@ -12,6 +12,7 @@
 #include <linux/errno.h>
 #include <linux/kernel.h>
 #include <linux/export.h>
+#include <linux/slab.h>
 #include <asm/unaligned.h>
 
 const char hex_asc[] = "0123456789abcdef";
@@ -80,14 +81,15 @@ EXPORT_SYMBOL(bin2hex);
  * hex_dump_to_buffer - convert a blob of data to "hex ASCII" in memory
  * @buf: data blob to dump
  * @len: number of bytes in the @buf
- * @rowsize: number of bytes to print per line; must be 16 or 32
+ * @rowsize: number of bytes to print per line; must be a multiple of groupsize
  * @groupsize: number of bytes to print at a time (1, 2, 4, 8; default = 1)
  * @linebuf: where to put the converted data
  * @linebuflen: total size of @linebuf, including space for terminating NUL
  * @ascii: include ASCII after the hex output
  *
- * hex_dump_to_buffer() works on one "line" of output at a time, i.e.,
- * 16 or 32 bytes of input data converted to hex + ASCII output.
+ * hex_dump_to_buffer() works on one "line" of output at a time, converting
+ * <groupsize> bytes of input to hexadecimal (and optionally printable ASCII)
+ * until <rowsize> bytes have been emitted.
  *
  * Given a buffer of u8 data, hex_dump_to_buffer() converts the input data
  * to a hex + ASCII dump at the supplied memory location.
@@ -116,16 +118,17 @@ int hex_dump_to_buffer(const void *buf, size_t len, int rowsize, int groupsize,
 	int ascii_column;
 	int ret;
 
-	if (rowsize != 16 && rowsize != 32)
-		rowsize = 16;
-
-	if (len > rowsize)		/* limit to one line at a time */
-		len = rowsize;
 	if (!is_power_of_2(groupsize) || groupsize > 8)
 		groupsize = 1;
 	if ((len % groupsize) != 0)	/* no mixed size output */
 		groupsize = 1;
 
+	if (rowsize % groupsize)
+		rowsize -= rowsize % groupsize;
+
+	if (len > rowsize)		/* limit to one line at a time */
+		len = rowsize;
+
 	ngroups = len / groupsize;
 	ascii_column = rowsize * 2 + rowsize / groupsize + 1;
 
@@ -216,7 +219,7 @@ EXPORT_SYMBOL(hex_dump_to_buffer);
  *  caller supplies trailing spaces for alignment if desired
  * @prefix_type: controls whether prefix of an offset, address, or none
  *  is printed (%DUMP_PREFIX_OFFSET, %DUMP_PREFIX_ADDRESS, %DUMP_PREFIX_NONE)
- * @rowsize: number of bytes to print per line; must be 16 or 32
+ * @rowsize: number of bytes to print per line; must be a multiple of groupsize
  * @groupsize: number of bytes to print at a time (1, 2, 4, 8; default = 1)
  * @buf: data blob to dump
  * @len: number of bytes in the @buf
@@ -226,10 +229,9 @@ EXPORT_SYMBOL(hex_dump_to_buffer);
  * to the kernel log at the specified kernel log level, with an optional
  * leading prefix.
  *
- * print_hex_dump() works on one "line" of output at a time, i.e.,
- * 16 or 32 bytes of input data converted to hex + ASCII output.
  * print_hex_dump() iterates over the entire input @buf, breaking it into
- * "line size" chunks to format and print.
+ * lines of rowsize/groupsize groups of input data converted to hex +
+ * (optionally) ASCII output.
  *
  * E.g.:
  *   print_hex_dump(KERN_DEBUG, "raw data: ", DUMP_PREFIX_ADDRESS,
@@ -246,17 +248,29 @@ void print_hex_dump(const char *level, const char *prefix_str, int prefix_type,
 {
 	const u8 *ptr = buf;
 	int i, linelen, remaining = len;
-	unsigned char linebuf[32 * 3 + 2 + 32 + 1];
+	unsigned char *linebuf;
+	unsigned int linebuf_len;
 
-	if (rowsize != 16 && rowsize != 32)
-		rowsize = 16;
+	if (rowsize % groupsize)
+		rowsize -= rowsize % groupsize;
+
+	/* Worst case line length:
+	 * 2 hex chars + space per byte in, 2 spaces, 1 char per byte in, NULL
+	 */
+	linebuf_len = rowsize * 3 + 2 + rowsize + 1;
+	linebuf = kzalloc(linebuf_len, GFP_KERNEL);
+	if (!linebuf) {
+		printk("%s%shexdump: Could not alloc %u bytes for buffer\n",
+			level, prefix_str, linebuf_len);
+		return;
+	}
 
 	for (i = 0; i < len; i += rowsize) {
 		linelen = min(remaining, rowsize);
 		remaining -= rowsize;
 
 		hex_dump_to_buffer(ptr + i, linelen, rowsize, groupsize,
-				   linebuf, sizeof(linebuf), ascii);
+				   linebuf, linebuf_len, ascii);
 
 		switch (prefix_type) {
 		case DUMP_PREFIX_ADDRESS:
@@ -271,6 +285,8 @@ void print_hex_dump(const char *level, const char *prefix_str, int prefix_type,
 			break;
 		}
 	}
+
+	kfree(linebuf);
 }
 EXPORT_SYMBOL(print_hex_dump);
 
diff --git a/lib/test_hexdump.c b/lib/test_hexdump.c
index d78ddd62ffd0..6ab75a209b43 100644
--- a/lib/test_hexdump.c
+++ b/lib/test_hexdump.c
@@ -14,15 +14,25 @@ static const unsigned char data_b[] = {
 	'\x70', '\xba', '\xc4', '\x24', '\x7d', '\x83', '\x34', '\x9b',	/* 08 - 0f */
 	'\xa6', '\x9c', '\x31', '\xad', '\x9c', '\x0f', '\xac', '\xe9',	/* 10 - 17 */
 	'\x4c', '\xd1', '\x19', '\x99', '\x43', '\xb1', '\xaf', '\x0c',	/* 18 - 1f */
+	'\x00', '\x01', '\x02', '\x03', '\x04', '\x05', '\x06', '\x07', /* 20 - 27 */
+	'\x0f', '\x0e', '\x0d', '\x0c', '\x0b', '\x0a', '\x09', '\x08', /* 28 - 2f */
+	'\x10', '\x11', '\x12', '\x13', '\x14', '\x15', '\x16', '\x17', /* 30 - 37 */
+	'\x1f', '\x1e', '\x1d', '\x1c', '\x1b', '\x1a', '\x19', '\x18', /* 38 - 3f */
 };
 
-static const unsigned char data_a[] = ".2.{....p..$}.4...1.....L...C...";
+static const unsigned char data_a[] = ".2.{....p..$}.4...1.....L...C..."
+				      "................................";
 
 static const char * const test_data_1[] __initconst = {
 	"be", "32", "db", "7b", "0a", "18", "93", "b2",
 	"70", "ba", "c4", "24", "7d", "83", "34", "9b",
 	"a6", "9c", "31", "ad", "9c", "0f", "ac", "e9",
 	"4c", "d1", "19", "99", "43", "b1", "af", "0c",
+	"00", "01", "02", "03", "04", "05", "06", "07",
+	"0f", "0e", "0d", "0c", "0b", "0a", "09", "08",
+	"10", "11", "12", "13", "14", "15", "16", "17",
+	"1f", "1e", "1d", "1c", "1b", "1a", "19", "18",
+	NULL
 };
 
 static const char * const test_data_2_le[] __initconst = {
@@ -30,6 +40,11 @@ static const char * const test_data_2_le[] __initconst = {
 	"ba70", "24c4", "837d", "9b34",
 	"9ca6", "ad31", "0f9c", "e9ac",
 	"d14c", "9919", "b143", "0caf",
+	"0100", "0302", "0504", "0706",
+	"0e0f", "0c0d", "0a0b", "0809",
+	"1110", "1312", "1514", "1716",
+	"1e1f", "1c1d", "1a1b", "1819",
+	NULL
 };
 
 static const char * const test_data_2_be[] __initconst = {
@@ -37,26 +52,43 @@ static const char * const test_data_2_be[] __initconst = {
 	"70ba", "c424", "7d83", "349b",
 	"a69c", "31ad", "9c0f", "ace9",
 	"4cd1", "1999", "43b1", "af0c",
+	"0001", "0203", "0405", "0607",
+	"0f0e", "0d0c", "0b0a", "0908",
+	"1011", "1213", "1415", "1617",
+	"1f1e", "1d1c", "1b1a", "1918",
+	NULL
 };
 
 static const char * const test_data_4_le[] __initconst = {
 	"7bdb32be", "b293180a", "24c4ba70", "9b34837d",
 	"ad319ca6", "e9ac0f9c", "9919d14c", "0cafb143",
+	"03020100", "07060504", "0c0d0e0f", "08090a0b",
+	"13121110", "17161514", "1c1d1e1f", "18191a1b",
+	NULL
 };
 
 static const char * const test_data_4_be[] __initconst = {
 	"be32db7b", "0a1893b2", "70bac424", "7d83349b",
 	"a69c31ad", "9c0face9", "4cd11999", "43b1af0c",
+	"00010203", "04050607",	"0f0e0d0c", "0b0a0908",
+	"10111213", "14151617",	"1f1e1d1c", "1b1a1918",
+	NULL
 };
 
 static const char * const test_data_8_le[] __initconst = {
 	"b293180a7bdb32be", "9b34837d24c4ba70",
 	"e9ac0f9cad319ca6", "0cafb1439919d14c",
+	"0706050403020100", "08090a0b0c0d0e0f",
+	"1716151413121110", "18191a1b1c1d1e1f",
+	NULL
 };
 
 static const char * const test_data_8_be[] __initconst = {
 	"be32db7b0a1893b2", "70bac4247d83349b",
 	"a69c31ad9c0face9", "4cd1199943b1af0c",
+	"0001020304050607", "0f0e0d0c0b0a0908",
+	"1011121314151617", "1f1e1d1c1b1a1918",
+	NULL
 };
 
 #define FILL_CHAR	'#'
@@ -75,9 +107,6 @@ static void __init test_hexdump_prepare_test(size_t len, int rowsize,
 	unsigned int i;
 	const bool is_be = IS_ENABLED(CONFIG_CPU_BIG_ENDIAN);
 
-	if (rs != 16 && rs != 32)
-		rs = 16;
-
 	if (l > rs)
 		l = rs;
 
@@ -97,7 +126,12 @@ static void __init test_hexdump_prepare_test(size_t len, int rowsize,
 	p = test;
 	for (i = 0; i < l / gs; i++) {
 		const char *q = *result++;
-		size_t amount = strlen(q);
+		size_t amount;
+
+		if (!q)
+			break;
+
+		amount = strlen(q);
 
 		memcpy(p, q, amount);
 		p += amount;
@@ -120,7 +154,7 @@ static void __init test_hexdump_prepare_test(size_t len, int rowsize,
 	*p = '\0';
 }
 
-#define TEST_HEXDUMP_BUF_SIZE		(32 * 3 + 2 + 32 + 1)
+#define TEST_HEXDUMP_BUF_SIZE		(64 * 3 + 2 + 64 + 1)
 
 static void __init test_hexdump(size_t len, int rowsize, int groupsize,
 				bool ascii)
@@ -215,7 +249,7 @@ static void __init test_hexdump_overflow(size_t buflen, size_t len,
 static void __init test_hexdump_overflow_set(size_t buflen, bool ascii)
 {
 	unsigned int i = 0;
-	int rs = (get_random_int() % 2 + 1) * 16;
+	int rs = (get_random_int() % 4 + 1) * 16;
 
 	do {
 		int gs = 1 << i;
@@ -230,11 +264,11 @@ static int __init test_hexdump_init(void)
 	unsigned int i;
 	int rowsize;
 
-	rowsize = (get_random_int() % 2 + 1) * 16;
+	rowsize = (get_random_int() % 4 + 1) * 16;
 	for (i = 0; i < 16; i++)
 		test_hexdump_set(rowsize, false);
 
-	rowsize = (get_random_int() % 2 + 1) * 16;
+	rowsize = (get_random_int() % 4 + 1) * 16;
 	for (i = 0; i < 16; i++)
 		test_hexdump_set(rowsize, true);
 
-- 
2.21.0

