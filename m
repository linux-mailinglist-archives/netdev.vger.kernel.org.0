Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BBA157B3E1
	for <lists+netdev@lfdr.de>; Tue, 30 Jul 2019 22:01:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727357AbfG3UBa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jul 2019 16:01:30 -0400
Received: from mout.kundenserver.de ([212.227.126.134]:44405 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726859AbfG3UB3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Jul 2019 16:01:29 -0400
Received: from threadripper.lan ([149.172.19.189]) by mrelayeu.kundenserver.de
 (mreue011 [212.227.15.129]) with ESMTPA (Nemesis) id
 1MzR0i-1iEV4S49z6-00vL3y; Tue, 30 Jul 2019 22:01:21 +0200
From:   Arnd Bergmann <arnd@arndb.de>
To:     Alexander Viro <viro@zeniv.linux.org.uk>
Cc:     linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>,
        Marcel Holtmann <marcel@holtmann.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Deepa Dinamani <deepa.kernel@gmail.com>,
        linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH v5 19/29] compat_ioctl: move hci_sock handlers into driver
Date:   Tue, 30 Jul 2019 21:55:35 +0200
Message-Id: <20190730195819.901457-7-arnd@arndb.de>
X-Mailer: git-send-email 2.20.0
In-Reply-To: <20190730195819.901457-1-arnd@arndb.de>
References: <20190730192552.4014288-1-arnd@arndb.de>
 <20190730195819.901457-1-arnd@arndb.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:MRkTCynjx8ZKieEaweTLO5hE+mPqZVxegMLXPvi77ZFI1txQjJ9
 mTrIRI4m4fTqEgGSmmFN3Usqtf2R5hhD0UTDT/QRPC8IcYkJNc9RCybcAKzU9ok26pVCy5x
 ntkofHM1zI0tSnU5pRTvXGNm9jz6ODVkgpTv3FlyEqRYcF0gPPf0Zg4bNFKh5M/3p95jW3c
 NJpqqqWo8sTvCujeLhHJQ==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:imcKfvdmqYo=:DzN1SJA2kycqmDkWZRU/Nc
 NsiVwWKpUTSbb/mjgweqnGJqA8PbLpXcIVI0DnYKLcstHKQqUM9bO1645MdEsaq35cznVPvnq
 X9McomuGyhOeQ4PuSbktBrAlw0vSZNecfiZbb3tG7c3h22XpzdplbFOuxv3KhygMonfVWHRom
 q/lMAAoIWhR0QRDN3FJ7HuxgNRTr7sSsYzWLch8LnunYDT7RAzT8SXZWWJJLACkpr027DVyBm
 huvqteZ6Pd8c2x4Aggmq/hFTmsM3Zq9uPsl9lo935UhlkRild7uIT9VuPcWYPtlV2L+eoAnCS
 Pnlb4AdR2HlsodyDTCQeCcjUgzEHDub1fnFtoonfOdpw5bf22CbPFFcrFmFO6jrDrYeNuxmva
 ix3kaBzwtWdlwkm57P4mrdU6RkeO/B74i4gO1svQDK7My2+U8l3oD1c/ow7kpQyLk77k0i8PK
 raIm0SZOwvPAT/xC4YctG+JWo6dvw1nCt4x+GcshvZNS0bvVb+U671bBLfumJqbGql+jqSWvQ
 /7zT8QpcC5SMTxfJAGBChF6BIceVc3gKJCROeL+dXVKfyE9cBEhQZzVlSdphRCpuoFKPt8eLv
 Td5m7QCdZ+W8eXpu6wquobqfUhHJ12/2yxsqKSKfFpO3/Ag/TBXOKTuHKnVHNpVkmEiFU+2Mc
 lCLkOH5UiTCy359HjqQDgB2hX4PkesHavNc/hE3CnlZzRMAiUOuQi3br5MXWsqjDFmO5MYGw7
 47iC//C6Eal1Nx6VmsgdHZTfqrEtec8LChFJ6w==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

All these ioctl commands are compatible, so we can handle
them with a trivial wrapper in hci_sock.c and remove
the listing in fs/compat_ioctl.c.

A few of the commands pass integer arguments instead of
pointers, so for correctness skip the compat_ptr() conversion
here.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 fs/compat_ioctl.c        | 24 ------------------------
 net/bluetooth/hci_sock.c | 21 ++++++++++++++++++++-
 2 files changed, 20 insertions(+), 25 deletions(-)

diff --git a/fs/compat_ioctl.c b/fs/compat_ioctl.c
index 8dbef92b10fd..9302157d1471 100644
--- a/fs/compat_ioctl.c
+++ b/fs/compat_ioctl.c
@@ -40,9 +40,6 @@
 
 #include "internal.h"
 
-#include <net/bluetooth/bluetooth.h>
-#include <net/bluetooth/hci_sock.h>
-
 #ifdef CONFIG_BLOCK
 #include <linux/cdrom.h>
 #include <linux/fd.h>
@@ -646,27 +643,6 @@ COMPATIBLE_IOCTL(RNDADDENTROPY)
 COMPATIBLE_IOCTL(RNDZAPENTCNT)
 COMPATIBLE_IOCTL(RNDCLEARPOOL)
 /* Bluetooth */
-COMPATIBLE_IOCTL(HCIDEVUP)
-COMPATIBLE_IOCTL(HCIDEVDOWN)
-COMPATIBLE_IOCTL(HCIDEVRESET)
-COMPATIBLE_IOCTL(HCIDEVRESTAT)
-COMPATIBLE_IOCTL(HCIGETDEVLIST)
-COMPATIBLE_IOCTL(HCIGETDEVINFO)
-COMPATIBLE_IOCTL(HCIGETCONNLIST)
-COMPATIBLE_IOCTL(HCIGETCONNINFO)
-COMPATIBLE_IOCTL(HCIGETAUTHINFO)
-COMPATIBLE_IOCTL(HCISETRAW)
-COMPATIBLE_IOCTL(HCISETSCAN)
-COMPATIBLE_IOCTL(HCISETAUTH)
-COMPATIBLE_IOCTL(HCISETENCRYPT)
-COMPATIBLE_IOCTL(HCISETPTYPE)
-COMPATIBLE_IOCTL(HCISETLINKPOL)
-COMPATIBLE_IOCTL(HCISETLINKMODE)
-COMPATIBLE_IOCTL(HCISETACLMTU)
-COMPATIBLE_IOCTL(HCISETSCOMTU)
-COMPATIBLE_IOCTL(HCIBLOCKADDR)
-COMPATIBLE_IOCTL(HCIUNBLOCKADDR)
-COMPATIBLE_IOCTL(HCIINQUIRY)
 COMPATIBLE_IOCTL(HCIUARTSETPROTO)
 COMPATIBLE_IOCTL(HCIUARTGETPROTO)
 COMPATIBLE_IOCTL(HCIUARTGETDEVICE)
diff --git a/net/bluetooth/hci_sock.c b/net/bluetooth/hci_sock.c
index d32077b28433..5d0ed28c0d3a 100644
--- a/net/bluetooth/hci_sock.c
+++ b/net/bluetooth/hci_sock.c
@@ -23,7 +23,7 @@
 */
 
 /* Bluetooth HCI sockets. */
-
+#include <linux/compat.h>
 #include <linux/export.h>
 #include <linux/utsname.h>
 #include <linux/sched.h>
@@ -1054,6 +1054,22 @@ static int hci_sock_ioctl(struct socket *sock, unsigned int cmd,
 	return err;
 }
 
+#ifdef CONFIG_COMPAT
+static int hci_sock_compat_ioctl(struct socket *sock, unsigned int cmd,
+				 unsigned long arg)
+{
+	switch (cmd) {
+	case HCIDEVUP:
+	case HCIDEVDOWN:
+	case HCIDEVRESET:
+	case HCIDEVRESTAT:
+		return hci_sock_ioctl(sock, cmd, arg);
+	}
+
+	return hci_sock_ioctl(sock, cmd, (unsigned long)compat_ptr(arg));
+}
+#endif
+
 static int hci_sock_bind(struct socket *sock, struct sockaddr *addr,
 			 int addr_len)
 {
@@ -1974,6 +1990,9 @@ static const struct proto_ops hci_sock_ops = {
 	.sendmsg	= hci_sock_sendmsg,
 	.recvmsg	= hci_sock_recvmsg,
 	.ioctl		= hci_sock_ioctl,
+#ifdef CONFIG_COMPAT
+	.compat_ioctl	= hci_sock_compat_ioctl,
+#endif
 	.poll		= datagram_poll,
 	.listen		= sock_no_listen,
 	.shutdown	= sock_no_shutdown,
-- 
2.20.0

