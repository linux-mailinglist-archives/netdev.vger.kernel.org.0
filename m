Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D870E167E0E
	for <lists+netdev@lfdr.de>; Fri, 21 Feb 2020 14:10:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728466AbgBUNKV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Feb 2020 08:10:21 -0500
Received: from mout.kundenserver.de ([212.227.126.187]:42815 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728314AbgBUNKV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Feb 2020 08:10:21 -0500
Received: from kiste.fritz.box ([88.130.61.101]) by mrelayeu.kundenserver.de
 (mreue009 [212.227.15.167]) with ESMTPSA (Nemesis) id
 1MTznO-1ivk9E0gmQ-00R10t; Fri, 21 Feb 2020 14:10:06 +0100
From:   Hans Wippel <ndev@hwipl.net>
To:     kgraul@linux.ibm.com, ubraun@linux.ibm.com, davem@davemloft.net
Cc:     netdev@vger.kernel.org, Hans Wippel <ndev@hwipl.net>
Subject: [RFC net-next] net/smc: improve peer ID in CLC decline for SMC-R
Date:   Fri, 21 Feb 2020 14:08:05 +0100
Message-Id: <20200221130805.5988-1-ndev@hwipl.net>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:55SEOC7c80+h8rnXRBFN6YZ2HVyQf6Bb6S+LH8ZPefxQSFjzVXL
 G7S44GAtNGWw0iAISxpB8+Ho751swbtv/R8L5v+hIz7qTt0TOgUQy1TDAGHGYApwpjIF4zF
 NiRnB0qgfbcyxdja0257mmPyDaKwElI3gnWyke25b9ww1Q1LCdx4zDPCx8aer+Esp6waHd+
 NIXHTtI8iIliAu5oFVC/g==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:zMZaSNc75nY=:CCUIMBuNIRfcokr2rK7dsn
 6n5E+NcSEESHtSZA4uJ1UL6bYff5R4mKISFs8JJ7bcykbz6oyatdy53w2uTcl5CH3NRXOVWlM
 t4QQqJRX5QE6DA8uipeP+bQMOASroEkfmkmwJpj4zol/JrWKChWDcxFYAA43Z7VT9Be/u/CLW
 S6obWRan1Gh0S47DNq700rjd6LI3mUvwARRQEw34TgBZat5NNPRM5mTNKvItYXT/ZylNUlhHc
 jZuAU8YdKgYESZc99TasZb/agcYDcTjGM2IsOlF5lyYbwDr471W7LvIy3jLDpBQGfvsNNXXHA
 1qqpvyoxTB5YnW+fokVj7qMhO7WonGc1o3LcmmP4qPijcQzPd0WKRm4LUY/EM0x47yBLLhlJP
 0K3ysZ3NPBAHhGLOTKtjVFQRraD6PwMQNE2Yf7HC8ySaJkOHfNCGuvOk0cd0VmtcFx6HdLRYI
 ojluT8ThQBCChGckruY0fSkBo4D7YkGqHPGX0uSij0pTT3a09VbVFfObYgalzSj8qEqa1uz5e
 dfXcRQtBXwiMu9jGQz4FwEyHVpBXWY49yHXoiQSzGj4nFFtMnUWMIqy1QIOPwPyHWKqsylJ7H
 UsqOo6YuiDlxHEjp0CRt+7K/KxpA26R+50J756jNr6/KEkXRAvqiQnULBvRrHwnVGyqYW7/Ci
 DZv3CGyN8vN0HJt40CBtZQ2hGVNm8mlz2PD9dDC/vPIKjw/TyYraZiUMlTOrk3UIbpOgsCquh
 +5TuzGcNpTu2hpRusqqkmxXXDlu1l2fAnKva58c6Bz8NeX3bFtIr9EOFoZTLaDY47REDDCSLP
 uaGFrbWp9MOMPmEjWUauj2KtKV+lVqvwFFcZvEQRWR8F0+NM/Z/ymCsKPqltqCuaR+bdqme
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

According to RFC 7609, all CLC messages contain a peer ID that consists
of a unique instance ID and the MAC address of one of the host's RoCE
devices. But if a SMC-R connection cannot be established, e.g., because
no matching pnet table entry is found, the current implementation uses a
zero value in the CLC decline message although the host's peer ID is set
to a proper value.

This patch changes the peer ID handling in two ways:

(1) If no RoCE and no ISM device is usable for a connection, there is no
LGR and the LGR check in smc_clc_send_decline() prevents that the peer
ID is copied into the CLC decline message for both SMC-D and SMC-R. So,
this patch modifies the check to also accept the case of no LGR. Also,
only a valid peer ID is copied into the decline message.

(2) The patch initializes the peer ID to a random instance ID and a zero
MAC address. If a RoCE device is in the host, the MAC address part of
the peer ID is overwritten with the respective address. Also, a function
for checking if the peer ID is valid is added. A peer ID is considered
valid if the MAC address part contains a non-zero MAC address.

Signed-off-by: Hans Wippel <ndev@hwipl.net>
---
 net/smc/smc_clc.c |  9 ++++++---
 net/smc/smc_ib.c  | 19 ++++++++++++-------
 net/smc/smc_ib.h  |  1 +
 3 files changed, 19 insertions(+), 10 deletions(-)

diff --git a/net/smc/smc_clc.c b/net/smc/smc_clc.c
index 3e16b887cfcf..e2d3b5b95632 100644
--- a/net/smc/smc_clc.c
+++ b/net/smc/smc_clc.c
@@ -372,9 +372,12 @@ int smc_clc_send_decline(struct smc_sock *smc, u32 peer_diag_info)
 	dclc.hdr.length = htons(sizeof(struct smc_clc_msg_decline));
 	dclc.hdr.version = SMC_CLC_V1;
 	dclc.hdr.flag = (peer_diag_info == SMC_CLC_DECL_SYNCERR) ? 1 : 0;
-	if (smc->conn.lgr && !smc->conn.lgr->is_smcd)
-		memcpy(dclc.id_for_peer, local_systemid,
-		       sizeof(local_systemid));
+	if (!smc->conn.lgr || !smc->conn.lgr->is_smcd) {
+		if (smc_ib_is_valid_local_systemid()) {
+			memcpy(dclc.id_for_peer, local_systemid,
+			       sizeof(local_systemid));
+		}
+	}
 	dclc.peer_diagnosis = htonl(peer_diag_info);
 	memcpy(dclc.trl.eyecatcher, SMC_EYECATCHER, sizeof(SMC_EYECATCHER));
 
diff --git a/net/smc/smc_ib.c b/net/smc/smc_ib.c
index 6756bd5a3fe4..203dd05d7113 100644
--- a/net/smc/smc_ib.c
+++ b/net/smc/smc_ib.c
@@ -37,11 +37,7 @@ struct smc_ib_devices smc_ib_devices = {	/* smc-registered ib devices */
 	.list = LIST_HEAD_INIT(smc_ib_devices.list),
 };
 
-#define SMC_LOCAL_SYSTEMID_RESET	"%%%%%%%"
-
-u8 local_systemid[SMC_SYSTEMID_LEN] = SMC_LOCAL_SYSTEMID_RESET;	/* unique system
-								 * identifier
-								 */
+u8 local_systemid[SMC_SYSTEMID_LEN] = {0};	/* unique system identifier */
 
 static int smc_ib_modify_qp_init(struct smc_link *lnk)
 {
@@ -168,6 +164,15 @@ static inline void smc_ib_define_local_systemid(struct smc_ib_device *smcibdev,
 {
 	memcpy(&local_systemid[2], &smcibdev->mac[ibport - 1],
 	       sizeof(smcibdev->mac[ibport - 1]));
+}
+
+bool smc_ib_is_valid_local_systemid(void)
+{
+	return !is_zero_ether_addr(&local_systemid[2]);
+}
+
+static void smc_ib_init_local_systemid(void)
+{
 	get_random_bytes(&local_systemid[0], 2);
 }
 
@@ -224,8 +229,7 @@ static int smc_ib_remember_port_attr(struct smc_ib_device *smcibdev, u8 ibport)
 	rc = smc_ib_fill_mac(smcibdev, ibport);
 	if (rc)
 		goto out;
-	if (!strncmp(local_systemid, SMC_LOCAL_SYSTEMID_RESET,
-		     sizeof(local_systemid)) &&
+	if (!smc_ib_is_valid_local_systemid() &&
 	    smc_ib_port_active(smcibdev, ibport))
 		/* create unique system identifier */
 		smc_ib_define_local_systemid(smcibdev, ibport);
@@ -605,6 +609,7 @@ static struct ib_client smc_ib_client = {
 
 int __init smc_ib_register_client(void)
 {
+	smc_ib_init_local_systemid();
 	return ib_register_client(&smc_ib_client);
 }
 
diff --git a/net/smc/smc_ib.h b/net/smc/smc_ib.h
index 255db87547d3..5c2b115d36da 100644
--- a/net/smc/smc_ib.h
+++ b/net/smc/smc_ib.h
@@ -84,4 +84,5 @@ void smc_ib_sync_sg_for_device(struct smc_ib_device *smcibdev,
 			       enum dma_data_direction data_direction);
 int smc_ib_determine_gid(struct smc_ib_device *smcibdev, u8 ibport,
 			 unsigned short vlan_id, u8 gid[], u8 *sgid_index);
+bool smc_ib_is_valid_local_systemid(void);
 #endif
-- 
2.25.1

