Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 055A82B5490
	for <lists+netdev@lfdr.de>; Mon, 16 Nov 2020 23:48:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730735AbgKPWqn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Nov 2020 17:46:43 -0500
Received: from m42-4.mailgun.net ([69.72.42.4]:14447 "EHLO m42-4.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729529AbgKPWqm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 16 Nov 2020 17:46:42 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1605566800; h=References: In-Reply-To: Message-Id: Date:
 Subject: Cc: To: From: Sender;
 bh=UVfRRMqmShedh6bH5WQy5emWFo9eq5VyvFD4qYG3JWg=; b=NJPCn/PBAERebPoDV/HXvkUpR+jwuPBZp6oztkoOC12Unescy6jFFl0BTEwEdRkzmXvWTOMz
 knmRhuE7aPe6mAapFvKt49lEOyO+4/LhMaezvD9qR4Fqw9KbcVTFRz2WWFlGBoQxug8opyXE
 DyjtVJ+FGQTtNsDM6q643Du9x8o=
X-Mailgun-Sending-Ip: 69.72.42.4
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n07.prod.us-east-1.postgun.com with SMTP id
 5fb3014bd6e6336a4ee4d7a1 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Mon, 16 Nov 2020 22:46:35
 GMT
Sender: hemantk=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 30AC8C43460; Mon, 16 Nov 2020 22:46:35 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=2.0 tests=ALL_TRUSTED,BAYES_00,SPF_FAIL,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from codeaurora.org (i-global254.qualcomm.com [199.106.103.254])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: hemantk)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 0C32CC433C6;
        Mon, 16 Nov 2020 22:46:33 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 0C32CC433C6
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=hemantk@codeaurora.org
From:   Hemant Kumar <hemantk@codeaurora.org>
To:     manivannan.sadhasivam@linaro.org, gregkh@linuxfoundation.org
Cc:     linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        jhugo@codeaurora.org, bbhatt@codeaurora.org,
        loic.poulain@linaro.org, netdev@vger.kernel.org,
        skhan@linuxfoundation.org, Hemant Kumar <hemantk@codeaurora.org>
Subject: [PATCH v12 5/5] selftest: mhi: Add support to test MHI LOOPBACK channel
Date:   Mon, 16 Nov 2020 14:46:22 -0800
Message-Id: <1605566782-38013-6-git-send-email-hemantk@codeaurora.org>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1605566782-38013-1-git-send-email-hemantk@codeaurora.org>
References: <1605566782-38013-1-git-send-email-hemantk@codeaurora.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Loopback test opens the MHI device file node and writes
a data buffer to it. MHI UCI kernel space driver copies
the data and sends it to MHI uplink (Tx) LOOPBACK channel.
MHI device loops back the same data to MHI downlink (Rx)
LOOPBACK channel. This data is read by test application
and compared against the data sent. Test passes if data
buffer matches between Tx and Rx. Test application performs
open(), poll(), write(), read() and close() file operations.

Signed-off-by: Hemant Kumar <hemantk@codeaurora.org>
---
 Documentation/mhi/uci.rst                          |  32 +
 tools/testing/selftests/Makefile                   |   1 +
 tools/testing/selftests/drivers/.gitignore         |   1 +
 tools/testing/selftests/drivers/mhi/Makefile       |   8 +
 tools/testing/selftests/drivers/mhi/config         |   2 +
 .../testing/selftests/drivers/mhi/loopback_test.c  | 802 +++++++++++++++++++++
 6 files changed, 846 insertions(+)
 create mode 100644 tools/testing/selftests/drivers/mhi/Makefile
 create mode 100644 tools/testing/selftests/drivers/mhi/config
 create mode 100644 tools/testing/selftests/drivers/mhi/loopback_test.c

diff --git a/Documentation/mhi/uci.rst b/Documentation/mhi/uci.rst
index ce8740e..0a04afe 100644
--- a/Documentation/mhi/uci.rst
+++ b/Documentation/mhi/uci.rst
@@ -79,6 +79,38 @@ MHI client driver performs read operation, same data gets looped back to MHI
 host using LOOPBACK channel 1. LOOPBACK channel is used to verify data path
 and data integrity between MHI Host and MHI device.
 
+Loopback Test
+~~~~~~~~~~~~~
+
+Loopback test application is used to verify data integrity between MHI host and
+MHI device over LOOPBACK channel. This also confirms that basic MHI data path
+is working properly. Test performs write() to send tx buffer to MHI device file
+node for LOOPBACK uplink channel. MHI LOOPBACK downlink channel loops back
+transmit data to MHI Host. Test application receives data in receive buffer as
+part of read(). It verifies if tx buffer matches rx buffer. Test application
+performs poll() before making write() and read() system calls. Test passes if
+match is found.
+
+Test is present under tools/testing/selftests/drivers/mhi. It is compiled using
+following command in same dir:-
+
+make loopback_test
+
+Test is run using following command arguments:-
+
+loopback_test -c <device_node> -b <transmit buffer size> -l <log level> -i
+<number of iterations>
+
+Required argument:
+-c : loopback chardev node
+
+Optional argument:
+-b : transmit buffer size. If not present 1024 bytes size transmit buffer
+     is sent.
+-i : Number of iterations to perform, If not present only one transmit buffer
+     is sent.
+-l : Log level. If not present defaults to DBG_LVL_INFO.
+
 Other Use Cases
 ---------------
 
diff --git a/tools/testing/selftests/Makefile b/tools/testing/selftests/Makefile
index d9c2835..084bc1e 100644
--- a/tools/testing/selftests/Makefile
+++ b/tools/testing/selftests/Makefile
@@ -10,6 +10,7 @@ TARGETS += core
 TARGETS += cpufreq
 TARGETS += cpu-hotplug
 TARGETS += drivers/dma-buf
+TARGETS += drivers/mhi
 TARGETS += efivarfs
 TARGETS += exec
 TARGETS += filesystems
diff --git a/tools/testing/selftests/drivers/.gitignore b/tools/testing/selftests/drivers/.gitignore
index ca74f2e..e4806d5 100644
--- a/tools/testing/selftests/drivers/.gitignore
+++ b/tools/testing/selftests/drivers/.gitignore
@@ -1,2 +1,3 @@
 # SPDX-License-Identifier: GPL-2.0-only
 /dma-buf/udmabuf
+/mhi/loopback_test
diff --git a/tools/testing/selftests/drivers/mhi/Makefile b/tools/testing/selftests/drivers/mhi/Makefile
new file mode 100644
index 0000000..c06c925
--- /dev/null
+++ b/tools/testing/selftests/drivers/mhi/Makefile
@@ -0,0 +1,8 @@
+# SPDX-License-Identifier: GPL-2.0-only
+CFLAGS += -I../../../../../usr/include/ -g -Wall
+
+LDLIBS = -lpthread
+TEST_GEN_PROGS := loopback_test
+
+include ../../lib.mk
+
diff --git a/tools/testing/selftests/drivers/mhi/config b/tools/testing/selftests/drivers/mhi/config
new file mode 100644
index 0000000..471dc92
--- /dev/null
+++ b/tools/testing/selftests/drivers/mhi/config
@@ -0,0 +1,2 @@
+CONFIG_MHI_BUS=y
+CONFIG_MHi_UCI=y
diff --git a/tools/testing/selftests/drivers/mhi/loopback_test.c b/tools/testing/selftests/drivers/mhi/loopback_test.c
new file mode 100644
index 0000000..99b7712
--- /dev/null
+++ b/tools/testing/selftests/drivers/mhi/loopback_test.c
@@ -0,0 +1,802 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Loopback test application performs write() to send tx buffer to MHI device
+ * file node for LOOPBACK uplink channel. MHI LOOPBACK downlink channel loops
+ * back transmit data to MHI Host. Test application receives data in receive
+ * buffer as part of read(). It verifies if tx buffer matches rx buffer. Test
+ * application performs poll() before making write() and read() system
+ * calls. Test passes if match is found.
+ *
+ * Test is compiled using following command:-
+ *
+ * make loopback_test
+ *
+ * Test is run using following command arguments:-
+ *
+ * loopback_test -c <device_node> -b <transmit buffer size> -l <log level> -i
+ * <number of iterations>
+ *
+ * Required argument:
+ * -c : loopback chardev node
+ *
+ * Optional argument:
+ * -b : transmit buffer size. If not present 1024 bytes size transmit buffer
+ *      is sent.
+ * -i : Number of iterations to perform, If not present only one transmit buffer
+ *      is sent.
+ * -l : Log level. If not present defaults to DBG_LVL_INFO.
+ */
+
+#include <errno.h>
+#include <fcntl.h>
+#include <getopt.h>
+#include <pthread.h>
+#include <stdbool.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+#include <sys/poll.h>
+#include <unistd.h>
+
+enum debug_level {
+	DBG_LVL_VERBOSE,
+	DBG_LVL_INFO,
+	DBG_LVL_ERROR,
+};
+
+enum test_status {
+	TEST_STATUS_SUCCESS,
+	TEST_STATUS_ERROR,
+	TEST_STATUS_NO_DEV,
+};
+
+struct lb_test_ctx {
+	char dev_node[256];
+	unsigned char *tx_buff;
+	unsigned char *rx_buff;
+	unsigned int rx_pkt_count;
+	unsigned int tx_pkt_count;
+	int iterations;
+	bool iter_complete;
+	bool comp_complete;
+	bool test_complete;
+	bool all_complete;
+	unsigned long buff_size;
+	long byte_recvd;
+	long byte_sent;
+};
+
+bool force_exit;
+char write_data = 'a';
+int completed_iterations;
+
+struct lb_test_ctx test_ctxt;
+enum debug_level msg_lvl;
+struct pollfd read_fd;
+struct pollfd write_fd;
+enum test_status mhi_test_return_value;
+enum test_status tx_status;
+enum test_status rx_status;
+enum test_status cmp_rxtx_status;
+
+#define test_log(test_msg_lvl, format, ...) do { \
+		if (test_msg_lvl >= msg_lvl) \
+			fprintf(stderr, format, ##__VA_ARGS__); \
+} while (0)
+
+static void loopback_test_sleep_ms(int ms)
+{
+	usleep(1000 * ms);
+}
+
+static enum test_status loopback_test_open(struct pollfd *write_fd,
+					struct pollfd *read_fd, char *dev_name)
+{
+	enum test_status ret_val = TEST_STATUS_SUCCESS;
+
+	write_fd->fd = open(dev_name, O_SYNC | O_WRONLY);
+	if (write_fd->fd < 0) {
+		test_log(DBG_LVL_ERROR, "Error opening file for w: errno: %d\n", errno);
+		ret_val = TEST_STATUS_ERROR;
+	} else {
+		test_log(DBG_LVL_INFO, "Opened %s, return code: %i.\n",
+			 dev_name, write_fd->fd);
+		write_fd->events = POLLOUT;
+	}
+
+	read_fd->fd = open(dev_name, O_SYNC | O_RDONLY);
+	if (read_fd->fd < 0) {
+		test_log(DBG_LVL_ERROR, "Error opening file for r: errno: %d\n", errno);
+		ret_val = TEST_STATUS_ERROR;
+	} else {
+		test_log(DBG_LVL_INFO, "Opened %s, return code: %i.\n",
+			 dev_name, read_fd->fd);
+		read_fd->events = POLLIN;
+	}
+
+	return ret_val;
+}
+
+static enum test_status loopback_test_close(struct pollfd *write_fd,
+						 struct pollfd *read_fd)
+{
+	enum test_status ret_val = TEST_STATUS_SUCCESS;
+
+	if (close(read_fd->fd) == 0) {
+		test_log(DBG_LVL_INFO, "Closed device handle\n");
+	} else {
+		test_log(DBG_LVL_ERROR, "Unable to close handle to device\n");
+		ret_val = TEST_STATUS_ERROR;
+	}
+
+	if (close(write_fd->fd) == 0) {
+		test_log(DBG_LVL_INFO, "Closed device handle\n");
+	} else {
+		test_log(DBG_LVL_ERROR, "Unable to close handle to device\n");
+		ret_val = TEST_STATUS_ERROR;
+	}
+
+	return ret_val;
+}
+
+static enum test_status loopback_test_alloc_rx_tx_buff(void)
+{
+	test_ctxt.rx_buff = (unsigned char *)malloc(test_ctxt.buff_size);
+	if (!test_ctxt.rx_buff) {
+		test_log(DBG_LVL_ERROR, "Failed to allocate rx buff\n");
+		return TEST_STATUS_ERROR;
+	}
+
+	memset(test_ctxt.rx_buff, 0x00, sizeof(test_ctxt.buff_size));
+	test_ctxt.tx_buff = (unsigned char *)malloc(test_ctxt.buff_size);
+	if (!test_ctxt.tx_buff) {
+		test_log(DBG_LVL_ERROR, "Failed to allocate tx buff\n");
+		return TEST_STATUS_ERROR;
+	}
+
+	return TEST_STATUS_SUCCESS;
+}
+
+static enum test_status loopback_test_write(struct pollfd *write_fd)
+{
+	enum test_status ret_value = TEST_STATUS_SUCCESS;
+	signed long temp_bytes_sent = 0;
+	signed long total_bytes_sent = 0;
+
+	test_log(DBG_LVL_VERBOSE, "About to write %lu\n", test_ctxt.buff_size);
+
+	temp_bytes_sent = write(write_fd->fd,
+		test_ctxt.tx_buff + test_ctxt.byte_sent, test_ctxt.buff_size);
+
+	test_log(DBG_LVL_VERBOSE, "Returned %li\n", temp_bytes_sent);
+	test_log(DBG_LVL_INFO, "Wrote packet with %li bytes of %02x\n",
+		 temp_bytes_sent, *(test_ctxt.tx_buff + test_ctxt.byte_sent));
+
+	if (temp_bytes_sent < 0) {
+		/* write returned a negative value i.e. write failed */
+		test_log(DBG_LVL_ERROR, "write() failed: err code %d\n", errno);
+		return TEST_STATUS_ERROR;
+	}
+
+	if ((unsigned long)temp_bytes_sent > test_ctxt.buff_size) {
+		test_log(DBG_LVL_ERROR, "Wrote more bytes than intended\n");
+		return TEST_STATUS_ERROR;
+	}
+
+	if (temp_bytes_sent == 0) {
+		loopback_test_sleep_ms(10);
+	} else if (temp_bytes_sent > 0) {
+		test_ctxt.tx_pkt_count++;
+		test_ctxt.byte_sent += temp_bytes_sent;
+		total_bytes_sent += temp_bytes_sent;
+		test_log(DBG_LVL_INFO, "Total written packets %d\n",
+			 test_ctxt.tx_pkt_count);
+	}
+
+	return ret_value;
+}
+
+static void loopback_test_reset_ctxt(void)
+{
+	test_ctxt.byte_sent = 0;
+	__sync_synchronize();
+	test_ctxt.byte_recvd = 0;
+	test_ctxt.rx_pkt_count = 0;
+	test_ctxt.tx_pkt_count = 0;
+	test_ctxt.comp_complete = false;
+	memset((void *)test_ctxt.rx_buff, 0x00, test_ctxt.buff_size);
+}
+
+static enum test_status loopback_test_time_out(int *time_count)
+{
+	enum test_status ret_val = TEST_STATUS_SUCCESS;
+
+	loopback_test_sleep_ms(3);
+	if ((++*time_count) > 100000) {
+		test_log(DBG_LVL_ERROR, "Error: all bytes not received for this iteration\n");
+		ret_val = TEST_STATUS_ERROR;
+		while (1)
+			loopback_test_sleep_ms(1000);
+	}
+
+	return ret_val;
+}
+
+static enum test_status loopback_test_poll(struct pollfd *fd,
+						bool poll_timeout)
+{
+	enum test_status ret_val = TEST_STATUS_SUCCESS;
+	int poll_return = 0;
+	int i = 0;
+	int timeout = 1000; /* poll-wait 1 second */
+	int file_desc_type = -1;
+
+	if (fd->events == POLLIN) {
+		file_desc_type = 1; /* read */
+		test_log(DBG_LVL_VERBOSE,
+			 "Poll: opened read handle to device\n");
+	} else if (fd->events == POLLOUT) {
+		file_desc_type = 0; /* write */
+		test_log(DBG_LVL_VERBOSE,
+			 "Poll: opened write handle to device\n");
+	}
+
+	if (poll_timeout == false)
+		timeout = -1; /* poll-wait forever */
+
+	while (ret_val == TEST_STATUS_SUCCESS) {
+		if (force_exit == true) {
+			ret_val = TEST_STATUS_ERROR;
+		} else {
+			test_log(DBG_LVL_VERBOSE, "%s Polling %i\n",
+				 file_desc_type ? "Read" : "Write", i);
+
+			poll_return = poll(fd, 1, timeout);
+			if (poll_return == -1) {
+				test_log(DBG_LVL_ERROR, "%s Poll error - %d\n",
+					 file_desc_type ? "Read" : "Write",
+					 errno);
+				return TEST_STATUS_ERROR;
+			} else if (((file_desc_type == 1) &&
+				   (fd->revents & POLLIN)) ||
+				   ((file_desc_type == 0) &&
+				   (fd->revents & POLLOUT))) {
+				test_log(DBG_LVL_VERBOSE,
+					 "%s Poll Returned\n",
+					 file_desc_type ? "Read" : "Write");
+				return TEST_STATUS_SUCCESS;
+			} else if (poll_timeout == true) {
+				i++;
+				poll_return = 0;
+				if (i >= 250) {
+					test_log(DBG_LVL_ERROR,
+						 "Poll: %s Timed out: 10s\n",
+					file_desc_type ? "Read" : "Write");
+					return TEST_STATUS_ERROR;
+				}
+			}
+
+			loopback_test_sleep_ms(10);
+		}
+	}
+
+	return ret_val;
+}
+
+static void *loopback_test_rx(void *data)
+{
+	bool poll_timeout = true;
+	unsigned long read_size = test_ctxt.buff_size;
+	long temp_bytes_rec;
+	enum test_status status;
+
+	rx_status = TEST_STATUS_SUCCESS;
+
+	while (force_exit == false) {
+		if (test_ctxt.test_complete) {
+			test_log(DBG_LVL_INFO, "Rx: exiting thread\n");
+			pthread_exit(&rx_status);
+			return NULL;
+		}
+
+		while ((test_ctxt.byte_sent > test_ctxt.byte_recvd) &&
+		       (force_exit == false)) {
+			test_log(DBG_LVL_VERBOSE,
+				 "Rx: Bytes Sent: %li, Received %li\n",
+				test_ctxt.byte_sent, test_ctxt.byte_recvd);
+
+			temp_bytes_rec = 0;
+
+			if (test_ctxt.comp_complete == false) {
+				status = loopback_test_poll(&read_fd,
+							    poll_timeout);
+				if (status == TEST_STATUS_ERROR) {
+					if (test_ctxt.test_complete == true)
+						rx_status = TEST_STATUS_SUCCESS;
+					else
+						rx_status = TEST_STATUS_ERROR;
+
+					test_log(DBG_LVL_INFO,
+						 "Rx: exiting thread\n");
+					pthread_exit(&rx_status);
+					return NULL;
+				}
+
+				test_log(DBG_LVL_VERBOSE, "Rx: before read\n");
+				temp_bytes_rec = read(read_fd.fd,
+					test_ctxt.rx_buff + test_ctxt.byte_recvd,
+					read_size);
+				if (temp_bytes_rec < 0) {
+					test_log(DBG_LVL_ERROR,
+					"Rx: read() failed - err code %d\n",
+					errno);
+					rx_status = TEST_STATUS_ERROR;
+					pthread_exit(&rx_status);
+					return NULL;
+				}
+
+				if (temp_bytes_rec == 0) {
+					loopback_test_sleep_ms(10);
+					rx_status = TEST_STATUS_ERROR;
+					pthread_exit(&rx_status);
+					return NULL;
+				}
+
+				test_ctxt.rx_pkt_count++;
+				test_log(DBG_LVL_INFO,
+				"Rx: Read packet with %li bytes of %02x\n",
+				temp_bytes_rec,
+				*(test_ctxt.rx_buff + test_ctxt.byte_recvd));
+				test_ctxt.byte_recvd += temp_bytes_rec;
+				test_log(DBG_LVL_INFO,
+					 "Rx: Total byte_recvd: %li\n",
+					test_ctxt.byte_recvd);
+				test_log(DBG_LVL_INFO,
+					 "Rx: Total read packets %d\n",
+					test_ctxt.rx_pkt_count);
+				test_log(DBG_LVL_INFO,
+					 "Rx: %lu byte buff_size\n",
+					test_ctxt.buff_size);
+
+				read_fd.revents = 0;
+			}
+		}
+	}
+	rx_status = TEST_STATUS_ERROR;
+	pthread_exit(&rx_status);
+	return NULL;
+}
+
+/* This single compare thread, will compare each byte of tx and rx Buff */
+static void *loopback_test_compare_rxtx(void *data)
+{
+	int k;
+	bool completion = true;
+	long curr_ptr = 0;
+
+	test_log(DBG_LVL_INFO, "CompareRxTxThread: Inside thread\n");
+	cmp_rxtx_status = TEST_STATUS_SUCCESS;
+
+	for (;;) {
+		/* if the test is completed exit thread */
+		if (test_ctxt.all_complete == true) {
+			curr_ptr = 0;
+			test_log(DBG_LVL_INFO,
+				 "CompareRxTx: exiting thread\n");
+			pthread_exit(&cmp_rxtx_status);
+			return NULL;
+		}
+
+		/* Simply compares each byte in each Tx and Rx buffer */
+		while (curr_ptr < test_ctxt.byte_recvd) {
+			if (*(test_ctxt.rx_buff + curr_ptr) !=
+					*(test_ctxt.tx_buff + curr_ptr)) {
+				test_log(DBG_LVL_ERROR,
+					 "Mismatch Byte num %li\n", curr_ptr);
+				test_log(DBG_LVL_ERROR,
+					 "Bytes: Sent 0x%x, Received 0x%x\n",
+					 *(test_ctxt.tx_buff + curr_ptr),
+					 *(test_ctxt.rx_buff + curr_ptr));
+				test_log(DBG_LVL_VERBOSE, "Rx buffer dump:\n");
+				for (k = 0; k < 1024; k++)
+					test_log(DBG_LVL_VERBOSE, "%d:0x%x ", k,
+						 *(test_ctxt.rx_buff + k));
+
+				test_log(DBG_LVL_VERBOSE, "\n");
+
+				test_log(DBG_LVL_INFO,
+					 "CompareRxTx: finished iterations %i\n",
+					completed_iterations);
+				test_log(DBG_LVL_INFO,
+					 "CompareRxTx: Total pkts sent %u\n",
+					test_ctxt.tx_pkt_count);
+
+				curr_ptr = 0;
+				force_exit = true;
+				cmp_rxtx_status = TEST_STATUS_ERROR;
+				pthread_exit(&cmp_rxtx_status);
+				return NULL;
+			}
+
+			test_log(DBG_LVL_VERBOSE,
+			"CompareRxTx: Bytes Sent 0x%x, Received 0x%x\n",
+			*(test_ctxt.tx_buff + curr_ptr),
+			*(test_ctxt.rx_buff + curr_ptr));
+			curr_ptr++;
+		}
+
+		/*
+		 * completion will start as true and change depending if the
+		 * iterations has been completed for all client threads
+		 */
+		if (curr_ptr >= test_ctxt.byte_sent)
+			completion = (completion && test_ctxt.iter_complete);
+		else
+			completion = false;
+
+		/*
+		 * Once all client threads have finished their iteration, reset
+		 * everything and allow the client thread to start their next
+		 * iteration
+		 */
+		if (completion) {
+			test_ctxt.byte_sent = 0;
+			__sync_synchronize();
+			test_ctxt.byte_recvd = 0;
+			test_ctxt.iter_complete = false;
+			test_ctxt.comp_complete = true;
+			curr_ptr = 0;
+			test_log(DBG_LVL_INFO, "CompareRxTx: TX and RX match\n");
+		} else {
+			completion = true;
+		}
+	}
+}
+
+static void loopback_test_display_err_data(void)
+{
+	test_log(DBG_LVL_ERROR, "Wrote %lu bytes out of a %lu buff size\n",
+		 test_ctxt.byte_sent, test_ctxt.buff_size);
+	test_log(DBG_LVL_ERROR, "Remaining bytes to write %lu\n",
+		 (test_ctxt.buff_size - test_ctxt.byte_sent));
+}
+
+static enum test_status loopback_test_setup_write_packet(void)
+{
+	bool poll_timeout = true;
+
+	if (loopback_test_poll(&write_fd, poll_timeout) == TEST_STATUS_ERROR)
+		return TEST_STATUS_ERROR;
+
+	test_log(DBG_LVL_VERBOSE, "revents: %d\n", write_fd.revents);
+
+	if (write_fd.revents & POLLOUT) {
+		memset(test_ctxt.tx_buff + test_ctxt.byte_sent, write_data,
+		       test_ctxt.buff_size);
+		test_log(DBG_LVL_VERBOSE, "Write %02x of size %lu\n", write_data,
+			 test_ctxt.buff_size);
+
+		if (loopback_test_write(&write_fd) != TEST_STATUS_SUCCESS) {
+			loopback_test_sleep_ms(1000);
+			return TEST_STATUS_ERROR;
+		}
+
+		test_log(DBG_LVL_INFO, "Total byte_sent %li\n",
+			 test_ctxt.byte_sent);
+		write_fd.revents = 0;
+	}
+
+	return TEST_STATUS_SUCCESS;
+}
+
+static enum test_status loopback_test_wait_to_get_bytes_back(void)
+{
+	int time_count = 0;
+
+	test_log(DBG_LVL_INFO, "Sent %li bytes, received %li bytes\n",
+		 test_ctxt.byte_sent, test_ctxt.byte_recvd);
+
+	/* read thread will fill bytesRec and wait till it equals byte_sent */
+	while (test_ctxt.byte_recvd != test_ctxt.byte_sent) {
+		if (loopback_test_time_out(&time_count) == TEST_STATUS_ERROR)
+			return TEST_STATUS_ERROR;
+	}
+
+	return TEST_STATUS_SUCCESS;
+}
+
+static void *loopback_test_tx(void *data)
+{
+	int i;
+	int time_count = 0;
+	int failed_iterations = 0;
+	enum test_status status = TEST_STATUS_SUCCESS;
+
+	tx_status = TEST_STATUS_SUCCESS;
+
+	for (i = 0; i < test_ctxt.iterations; i++) {
+		loopback_test_reset_ctxt();
+
+		test_ctxt.iter_complete = false;
+
+		/* While the bytes sent is less than the buffsize */
+		while (((unsigned int)test_ctxt.byte_sent < test_ctxt.buff_size)
+			&& (status == TEST_STATUS_SUCCESS)) {
+			if (force_exit == true)
+				goto exit;
+
+			if (status != TEST_STATUS_SUCCESS) {
+				loopback_test_display_err_data();
+				tx_status = TEST_STATUS_ERROR;
+				goto exit;
+			}
+
+			status = loopback_test_setup_write_packet();
+			if (status == TEST_STATUS_ERROR) {
+				test_log(DBG_LVL_INFO,
+					 "Failed after %d iterations\n", i);
+				failed_iterations++;
+				goto exit;
+			}
+		}
+
+		if (loopback_test_wait_to_get_bytes_back() ==
+			TEST_STATUS_ERROR) {
+			tx_status = TEST_STATUS_ERROR;
+			goto exit;
+		}
+
+		__sync_synchronize();
+
+		test_ctxt.iter_complete = true;
+
+		while (!test_ctxt.comp_complete) {
+			if (loopback_test_time_out(&time_count) ==
+				TEST_STATUS_ERROR) {
+				tx_status = TEST_STATUS_ERROR;
+				goto exit;
+			}
+		}
+		time_count = 0;
+	}
+
+	if (failed_iterations > 0)
+		test_log(DBG_LVL_INFO, "Amount of Failed Iterations: %d\n",
+			 failed_iterations);
+
+exit:
+	loopback_test_reset_ctxt();
+
+	/* all of the iterations for this client thread have been completed */
+	test_ctxt.test_complete = true;
+
+	/* close the opened file descriptors */
+	loopback_test_close(&write_fd, &read_fd);
+
+	test_log(DBG_LVL_INFO, "mhi_test_loopback: exiting thread\n");
+
+	pthread_exit(&tx_status);
+
+	return NULL;
+}
+
+/*
+ * This function will be called when the user wishes to perform a loopback test.
+ * In this function, a compare thread will be created to compare the tx buffer
+ * and the rx Buffer. Device file node is opened for write and read. Tx thread
+ * is created to send data and Rx thread to receive data.
+ */
+enum test_status loopback_test_thread_create(void)
+{
+	int i = 0;
+	enum test_status status = TEST_STATUS_SUCCESS;
+	enum test_status *write_thread_retval;
+	enum test_status *read_thread_retval;
+	enum test_status *compare_thread_retval;
+
+	pthread_t compare_rx_tx_thread;
+	pthread_t loopback_thread;
+	pthread_t receive_thread;
+
+	/* set all tests (including open/close) to not completed */
+	test_ctxt.all_complete = false;
+
+	/* set current test to not completed */
+	test_ctxt.test_complete = false;
+
+	if (loopback_test_alloc_rx_tx_buff() == TEST_STATUS_ERROR) {
+		status = TEST_STATUS_ERROR;
+		goto exit;
+	}
+
+	/* Create thread for comparing the rx and tx buffers */
+	if (pthread_create(&compare_rx_tx_thread, NULL,
+			   loopback_test_compare_rxtx, NULL) != 0) {
+		test_log(DBG_LVL_ERROR, "Error creating compare thread\n");
+		status = TEST_STATUS_ERROR;
+		goto exit;
+	}
+
+	test_log(DBG_LVL_INFO, "dev_node: %s\n", test_ctxt.dev_node);
+
+	/* closing the device node will happen in the loopback thread */
+	status = loopback_test_open(&write_fd, &read_fd, test_ctxt.dev_node);
+	if (status == TEST_STATUS_ERROR) {
+		test_log(DBG_LVL_ERROR, "Failed to open device node\n");
+		goto exit;
+	}
+
+	/* Spawn the loopback tx thread */
+	if (pthread_create(&loopback_thread, NULL, loopback_test_tx, NULL)
+			   != 0) {
+		test_log(DBG_LVL_ERROR, "Error creating tx thread");
+		status = TEST_STATUS_ERROR;
+		goto exit;
+	}
+
+	/* Create thread for receiving packets */
+	if (pthread_create(&receive_thread, NULL, loopback_test_rx, NULL)
+			   != 0) {
+		test_log(DBG_LVL_ERROR, "Error creating rx thread\n");
+		status = TEST_STATUS_ERROR;
+		goto exit;
+	}
+
+	test_log(DBG_LVL_INFO, "Waiting for Tx and Rx threads to complete\n");
+
+	/* wait till all client and receive threads have finished */
+	pthread_join(loopback_thread, (void **)(&write_thread_retval));
+	pthread_join(receive_thread, (void **)(&read_thread_retval));
+
+	test_log(DBG_LVL_VERBOSE, "TX and Rx threads completed\n");
+
+	test_log(DBG_LVL_INFO, "Write thread status: %s\n",
+		 *write_thread_retval ? "Fail" : "Pass");
+	test_log(DBG_LVL_INFO, "Read thread status: %s\n",
+		 *read_thread_retval ? "Fail" : "Pass");
+
+	if ((*write_thread_retval == TEST_STATUS_ERROR) ||
+	    (*read_thread_retval == TEST_STATUS_ERROR)) {
+		test_log(DBG_LVL_ERROR, "Returned error, exiting\n");
+		status = TEST_STATUS_ERROR;
+		goto exit;
+	}
+
+	test_log(DBG_LVL_INFO, "Thread %i of tests complete\n", i);
+	test_ctxt.test_complete = false;
+
+	test_log(DBG_LVL_INFO, "All loopback threads completed\n");
+
+	test_ctxt.all_complete = true;
+
+	test_log(DBG_LVL_INFO, "Waiting for comp thread to exit\n");
+
+	pthread_join(compare_rx_tx_thread, (void **)(&compare_thread_retval));
+	if (*compare_thread_retval == TEST_STATUS_ERROR) {
+		test_log(DBG_LVL_ERROR, "Compare thread returned error\n");
+		status = TEST_STATUS_ERROR;
+	}
+
+exit:
+	/* All threads have finished using the Tx and Rx Buffers, free them */
+	free(test_ctxt.tx_buff);
+	test_ctxt.tx_buff = NULL;
+	free(test_ctxt.rx_buff);
+	test_ctxt.rx_buff = NULL;
+
+	return status;
+}
+
+static void *loopback_test_run(void *data)
+{
+	enum test_status status = TEST_STATUS_SUCCESS;
+
+	force_exit = false;
+	srand(time(NULL));
+
+	status = loopback_test_thread_create();
+
+	pthread_exit(&status);
+
+	return NULL;
+}
+
+static void loopback_test_set_defaults(void)
+{
+	msg_lvl = DBG_LVL_INFO;
+
+	memset(&test_ctxt, 0, sizeof(test_ctxt));
+	test_ctxt.iterations = 1;
+	test_ctxt.buff_size = 1024;
+}
+
+static void usage(void)
+{
+	test_log(DBG_LVL_INFO, "\nUsage:\n");
+	test_log(DBG_LVL_INFO, "-c: Device node\n");
+	test_log(DBG_LVL_INFO, "-b: Buffer size (default: 1024 bytes)\n");
+	test_log(DBG_LVL_INFO, "-i: Number of iterations\n");
+	test_log(DBG_LVL_INFO, "-l: log level, default - 1\n");
+	test_log(DBG_LVL_INFO, "log level : 0 -verbose, 1 -info , 2 -err\n");
+}
+
+static int loopback_test_parse(int argc, char *argv[])
+{
+	int i = 0;
+	int command = 0;
+	int indexptr = 0;
+	char *optstr = "-:c:b:i:l:";
+	int *return_value = NULL;
+	int status = -EINVAL;
+	pthread_t run_test;
+
+	optind = 1;
+
+	static const struct option optlongstr[] = {
+			{ "device node", required_argument, NULL, 'c'},
+			{0, 0, 0, 0}
+	};
+
+	test_log(DBG_LVL_INFO, "\nStarting MHI loopback tests\n");
+
+	test_log(DBG_LVL_VERBOSE, "argc: %d\n", argc);
+	for (i = 0; i < argc; i++)
+		test_log(DBG_LVL_VERBOSE, "argv[%i] = %s; ", i, argv[i]);
+
+	while ((command = getopt_long(argc, (char **)argv, optstr, optlongstr,
+				      &indexptr)) && (command != -1)) {
+		switch (command) {
+		case 'c':
+			sprintf(test_ctxt.dev_node, "%s", optarg);
+			test_log(DBG_LVL_INFO, "%s\n", test_ctxt.dev_node);
+			break;
+		case 'b':
+			test_ctxt.buff_size = atoi(optarg);
+			test_log(DBG_LVL_INFO, "%lu\n", test_ctxt.buff_size);
+			break;
+		case 'i':
+			test_ctxt.iterations = atoi(optarg);
+			test_log(DBG_LVL_INFO, "%u\n", test_ctxt.iterations);
+			break;
+		case 'l':
+			msg_lvl = atoi(optarg);
+			test_log(DBG_LVL_INFO, "log level: %d\n", atoi(optarg));
+			break;
+		default:
+			test_log(DBG_LVL_ERROR, "Invalid Option: %d\n",
+				 command);
+			usage();
+			return TEST_STATUS_ERROR;
+		}
+	}
+
+	if (pthread_create(&run_test, NULL, loopback_test_run, NULL) != 0) {
+		test_log(DBG_LVL_ERROR, "Error creating run_mhi_test\n");
+	} else {
+		pthread_join(run_test, (void **)(&return_value));
+
+		if (*return_value != TEST_STATUS_SUCCESS) {
+			test_log(DBG_LVL_ERROR, "Test Failed\n");
+		} else {
+			test_log(DBG_LVL_INFO, "Test Passed\n");
+			status = 0;
+		}
+	}
+
+	return status;
+}
+
+int main(int argc, char *argv[])
+{
+	int ret = 0;
+
+	loopback_test_set_defaults();
+	test_log(DBG_LVL_INFO, "MHI Loopback test App\n");
+
+	if (argc > 1)
+		ret = loopback_test_parse(argc, argv);
+	else
+		usage();
+
+	return ret;
+}
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project

