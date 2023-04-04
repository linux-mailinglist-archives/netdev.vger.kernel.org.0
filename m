Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8CC806D6698
	for <lists+netdev@lfdr.de>; Tue,  4 Apr 2023 17:00:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235342AbjDDPAS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Apr 2023 11:00:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232808AbjDDO7c (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Apr 2023 10:59:32 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB79E49D1
        for <netdev@vger.kernel.org>; Tue,  4 Apr 2023 07:59:15 -0700 (PDT)
Received: from moin.white.stw.pengutronix.de ([2a0a:edc0:0:b01:1d::7b] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1pji7u-0001aq-0y
        for netdev@vger.kernel.org; Tue, 04 Apr 2023 16:59:14 +0200
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id 1AFEE1A684A
        for <netdev@vger.kernel.org>; Tue,  4 Apr 2023 14:59:13 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id 0215F1A683A;
        Tue,  4 Apr 2023 14:59:10 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id 9a4d36d8;
        Tue, 4 Apr 2023 14:59:09 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de, Oliver Hartkopp <socketcan@hartkopp.net>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH net-next 01/10] can: isotp: add module parameter for maximum pdu size
Date:   Tue,  4 Apr 2023 16:58:59 +0200
Message-Id: <20230404145908.1714400-2-mkl@pengutronix.de>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230404145908.1714400-1-mkl@pengutronix.de>
References: <20230404145908.1714400-1-mkl@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2a0a:edc0:0:b01:1d::7b
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-2.3 required=5.0 tests=RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Oliver Hartkopp <socketcan@hartkopp.net>

With ISO 15765-2:2016 the PDU size is not limited to 2^12 - 1 (4095)
bytes but can be represented as a 32 bit unsigned integer value which
allows 2^32 - 1 bytes (~4GB). The use-cases like automotive unified
diagnostic services (UDS) and flashing of ECUs still use the small
static buffers which are provided at socket creation time.

When a use-case requires to transfer PDUs up to 1025 kByte the maximum
PDU size can now be extended by setting the module parameter
max_pdu_size. The extended size buffers are only allocated on a
per-socket/connection base when needed at run-time.

changes since v2: https://lore.kernel.org/all/20230313172510.3851-1-socketcan@hartkopp.net
- use ARRAY_SIZE() to reference DEFAULT_MAX_PDU_SIZE only at one place

changes since v1: https://lore.kernel.org/all/20230311143446.3183-1-socketcan@hartkopp.net
- limit the minimum 'max_pdu_size' to 4095 to maintain the classic
  behavior before ISO 15765-2:2016

Link: https://github.com/raspberrypi/linux/issues/5371
Signed-off-by: Oliver Hartkopp <socketcan@hartkopp.net>
Link: https://lore.kernel.org/all/20230326115911.15094-1-socketcan@hartkopp.net
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 net/can/isotp.c | 65 ++++++++++++++++++++++++++++++++++++++++++-------
 1 file changed, 56 insertions(+), 9 deletions(-)

diff --git a/net/can/isotp.c b/net/can/isotp.c
index 9bc344851704..f1ea91772ae7 100644
--- a/net/can/isotp.c
+++ b/net/can/isotp.c
@@ -85,10 +85,21 @@ MODULE_ALIAS("can-proto-6");
 
 /* ISO 15765-2:2016 supports more than 4095 byte per ISO PDU as the FF_DL can
  * take full 32 bit values (4 Gbyte). We would need some good concept to handle
- * this between user space and kernel space. For now increase the static buffer
- * to something about 64 kbyte to be able to test this new functionality.
+ * this between user space and kernel space. For now set the static buffer to
+ * something about 8 kbyte to be able to test this new functionality.
  */
-#define MAX_MSG_LENGTH 66000
+#define DEFAULT_MAX_PDU_SIZE 8300
+
+/* maximum PDU size before ISO 15765-2:2016 extension was 4095 */
+#define MAX_12BIT_PDU_SIZE 4095
+
+/* limit the isotp pdu size from the optional module parameter to 1MByte */
+#define MAX_PDU_SIZE (1025 * 1024U)
+
+static unsigned int max_pdu_size __read_mostly = DEFAULT_MAX_PDU_SIZE;
+module_param(max_pdu_size, uint, 0444);
+MODULE_PARM_DESC(max_pdu_size, "maximum isotp pdu size (default "
+		 __stringify(DEFAULT_MAX_PDU_SIZE) ")");
 
 /* N_PCI type values in bits 7-4 of N_PCI bytes */
 #define N_PCI_SF 0x00	/* single frame */
@@ -123,13 +134,15 @@ enum {
 };
 
 struct tpcon {
-	unsigned int idx;
+	u8 *buf;
+	unsigned int buflen;
 	unsigned int len;
+	unsigned int idx;
 	u32 state;
 	u8 bs;
 	u8 sn;
 	u8 ll_dl;
-	u8 buf[MAX_MSG_LENGTH + 1];
+	u8 sbuf[DEFAULT_MAX_PDU_SIZE];
 };
 
 struct isotp_sock {
@@ -503,7 +516,17 @@ static int isotp_rcv_ff(struct sock *sk, struct canfd_frame *cf, int ae)
 	if (so->rx.len + ae + off + ff_pci_sz < so->rx.ll_dl)
 		return 1;
 
-	if (so->rx.len > MAX_MSG_LENGTH) {
+	/* PDU size > default => try max_pdu_size */
+	if (so->rx.len > so->rx.buflen && so->rx.buflen < max_pdu_size) {
+		u8 *newbuf = kmalloc(max_pdu_size, GFP_ATOMIC);
+
+		if (newbuf) {
+			so->rx.buf = newbuf;
+			so->rx.buflen = max_pdu_size;
+		}
+	}
+
+	if (so->rx.len > so->rx.buflen) {
 		/* send FC frame with overflow status */
 		isotp_send_fc(sk, ae, ISOTP_FC_OVFLW);
 		return 1;
@@ -807,7 +830,7 @@ static void isotp_create_fframe(struct canfd_frame *cf, struct isotp_sock *so,
 		cf->data[0] = so->opt.ext_address;
 
 	/* create N_PCI bytes with 12/32 bit FF_DL data length */
-	if (so->tx.len > 4095) {
+	if (so->tx.len > MAX_12BIT_PDU_SIZE) {
 		/* use 32 bit FF_DL notation */
 		cf->data[ae] = N_PCI_FF;
 		cf->data[ae + 1] = 0;
@@ -947,7 +970,17 @@ static int isotp_sendmsg(struct socket *sock, struct msghdr *msg, size_t size)
 		so->tx.state = ISOTP_SENDING;
 	}
 
-	if (!size || size > MAX_MSG_LENGTH) {
+	/* PDU size > default => try max_pdu_size */
+	if (size > so->tx.buflen && so->tx.buflen < max_pdu_size) {
+		u8 *newbuf = kmalloc(max_pdu_size, GFP_KERNEL);
+
+		if (newbuf) {
+			so->tx.buf = newbuf;
+			so->tx.buflen = max_pdu_size;
+		}
+	}
+
+	if (!size || size > so->tx.buflen) {
 		err = -EINVAL;
 		goto err_out_drop;
 	}
@@ -1195,6 +1228,12 @@ static int isotp_release(struct socket *sock)
 	so->ifindex = 0;
 	so->bound = 0;
 
+	if (so->rx.buf != so->rx.sbuf)
+		kfree(so->rx.buf);
+
+	if (so->tx.buf != so->tx.sbuf)
+		kfree(so->tx.buf);
+
 	sock_orphan(sk);
 	sock->sk = NULL;
 
@@ -1591,6 +1630,11 @@ static int isotp_init(struct sock *sk)
 	so->rx.state = ISOTP_IDLE;
 	so->tx.state = ISOTP_IDLE;
 
+	so->rx.buf = so->rx.sbuf;
+	so->tx.buf = so->tx.sbuf;
+	so->rx.buflen = ARRAY_SIZE(so->rx.sbuf);
+	so->tx.buflen = ARRAY_SIZE(so->tx.sbuf);
+
 	hrtimer_init(&so->rxtimer, CLOCK_MONOTONIC, HRTIMER_MODE_REL_SOFT);
 	so->rxtimer.function = isotp_rx_timer_handler;
 	hrtimer_init(&so->txtimer, CLOCK_MONOTONIC, HRTIMER_MODE_REL_SOFT);
@@ -1658,7 +1702,10 @@ static __init int isotp_module_init(void)
 {
 	int err;
 
-	pr_info("can: isotp protocol\n");
+	max_pdu_size = max_t(unsigned int, max_pdu_size, MAX_12BIT_PDU_SIZE);
+	max_pdu_size = min_t(unsigned int, max_pdu_size, MAX_PDU_SIZE);
+
+	pr_info("can: isotp protocol (max_pdu_size %d)\n", max_pdu_size);
 
 	err = can_proto_register(&isotp_can_proto);
 	if (err < 0)

base-commit: 4cee0fb9cc4b5477637fdeb2e965f5fc7d624622
-- 
2.39.2


