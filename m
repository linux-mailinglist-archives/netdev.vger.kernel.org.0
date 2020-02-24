Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 631D316B61F
	for <lists+netdev@lfdr.de>; Tue, 25 Feb 2020 00:59:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728477AbgBXX7o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Feb 2020 18:59:44 -0500
Received: from mout.kundenserver.de ([217.72.192.74]:46693 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728135AbgBXX7k (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Feb 2020 18:59:40 -0500
Received: from kiste.fritz.box ([94.134.180.186]) by mrelayeu.kundenserver.de
 (mreue108 [212.227.15.183]) with ESMTPSA (Nemesis) id
 1Mspu2-1jQFy61tay-00tFnf; Tue, 25 Feb 2020 00:59:30 +0100
From:   Hans Wippel <ndev@hwipl.net>
To:     kgraul@linux.ibm.com, ubraun@linux.ibm.com, davem@davemloft.net
Cc:     netdev@vger.kernel.org, Hans Wippel <ndev@hwipl.net>
Subject: [PATCH net-next 1/2] net/smc: rework peer ID handling
Date:   Tue, 25 Feb 2020 00:59:00 +0100
Message-Id: <20200224235901.304311-2-ndev@hwipl.net>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200224235901.304311-1-ndev@hwipl.net>
References: <20200224235901.304311-1-ndev@hwipl.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:lUTYc+GeGOwpgL5MyXLQIl7pk5nXZbe/5gdyn19zsxzCWXZ7eNX
 fsEIRwhY0xQfTtYRqeLyguT2Xgc/sOzZM4eKMfxuhbBQ2GdI8WWEtfK4/PyFjhwyvr9TOoL
 y4p1vm0Hgt/wD+lHZpnca36s88dqzGR9g7B3VukI1ThVACSy48/yEJ93OjTQbe/fBMdv/oI
 FFpAOcVnM28TLUAoEO4pw==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:epUYHw9Md9A=:EaVSz/DBM88SazRX98TPoe
 ANFSfl88NVNss2YoJeWl/FFtcPoHusmsF9uP5mc9ggDnuQ3WsSHkldSNLOJFmLF4UrpMZpeyt
 +xqxd7B3h+/vaQJEHlSDbcxUkO/jJQFTrwUpBtFugzV+pUAA3MBOtUwia547qpof+IGXevCJK
 +To6HfZg+xSPPBsUa1Ofeectq3RY9Nvlxs7h29Ch/GBIwXxhjw5u+WRvso/FB24P4eLA6eqw6
 jp3QQp2/g9d8UlSRfwGIaEh4/0pdSlDPJ683a7SQkBxH49DhPEynRNOe9YBpubR7wFng6QlK7
 UMdIZzQsnGYHxhgS52yZOkV/+xNmQh9ucXprBNTv/PLfyaWN4a60FtxnkBH6vpGRpJn+/7sSx
 dAP28lNOWg5d9MFwIXqW9H+UspCOPt1fxXXfsyhmNacYnXtWwFfeT27i/HTi6ay0K+IXvtCs4
 O8ZToauaBvZgDpDLKpKDGwtpIjC+2XRAoPu/jcxNzdSZh4qA3sW3kAjq698tzZwXV+qxyu1h+
 Y/0kwnRcnJJNxgLoK/mDZo2uE4a0t4buqpreIBdEFt1saRQZM664IUs4EEEHopJnKeK9W9KzX
 1+rsGx62Xr+IeKnBbHvGLRBBvK5P0psSJKBgEk0VBEjs9hgZsWtyRN7of5QI/Rbj1gtuSzi0S
 zCB+l7QxeCYbacjOqndG8TLUUPUo78l/cN3U3HxMC568qqd1LFxRJlYBl455LZUo8X6rciLIB
 NJ5WFGUiRgybjF18havi6D5vilo09lMEFEZdfvelYxd10oxnvnRCFXeP/pRGEbXC1MZNX0PaQ
 2D40Dvp+LSRaCnHaZEdaxVxyu4Ugz4mhVozX7uYKE/gaq6zzMM6DBD8MagKrOPdbMgpvnu5
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch initializes the peer ID to a random instance ID and a zero
MAC address. If a RoCE device is in the host, the MAC address part of
the peer ID is overwritten with the respective address. Also, a function
for checking if the peer ID is valid is added. A peer ID is considered
valid if the MAC address part contains a non-zero MAC address.

Signed-off-by: Hans Wippel <ndev@hwipl.net>
---
 net/smc/smc_ib.c | 19 ++++++++++++-------
 1 file changed, 12 insertions(+), 7 deletions(-)

diff --git a/net/smc/smc_ib.c b/net/smc/smc_ib.c
index 6756bd5a3fe4..3444de27fecd 100644
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
+u8 local_systemid[SMC_SYSTEMID_LEN];		/* unique system identifier */
 
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
 
-- 
2.25.1

