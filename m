Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A635916F148
	for <lists+netdev@lfdr.de>; Tue, 25 Feb 2020 22:42:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728818AbgBYVmm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Feb 2020 16:42:42 -0500
Received: from mout.kundenserver.de ([212.227.17.10]:53045 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726130AbgBYVml (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Feb 2020 16:42:41 -0500
Received: from kiste.fritz.box ([94.134.180.105]) by mrelayeu.kundenserver.de
 (mreue109 [212.227.15.183]) with ESMTPSA (Nemesis) id
 1MRTEp-1ijNnX1da9-00NQWx; Tue, 25 Feb 2020 22:42:30 +0100
From:   Hans Wippel <ndev@hwipl.net>
To:     kgraul@linux.ibm.com, ubraun@linux.ibm.com, davem@davemloft.net
Cc:     netdev@vger.kernel.org, Hans Wippel <ndev@hwipl.net>
Subject: [PATCH net-next v2 1/2] net/smc: rework peer ID handling
Date:   Tue, 25 Feb 2020 22:41:21 +0100
Message-Id: <20200225214122.335292-2-ndev@hwipl.net>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200225214122.335292-1-ndev@hwipl.net>
References: <20200225214122.335292-1-ndev@hwipl.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:81N7Is7afIPjSfZawRgQYPJYz+TFoeiQ7W8RoA28jx5vwc7nq6k
 VPIck6ew++kR4kjwLAiFmvPkHfHXOTjF81c0K37SdF5XY0e5atn5rJW7ddXXBmZuWDe/DjA
 q6QFWS+r65ZlB4XPVboX4YiWb67EUO9yUhC/uR9TMb16oIH8hBzI/v+HHo2VxAAjUQVo8jy
 SqNLcp5ncZgxJZsv0QvhA==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:ZG1nMITVZmA=:gvd+Pb45sbKmptDlzVo02g
 rCCH0FWIxGQ0zr3mWnxHgZXvZh3tZ0fUPc9BwWmHc6t80xUiIF1cuV+DcLUihrbLN3DBRY10/
 sGfzpeoiGDa4X9ykLySLVVVNiKzLphtfd5Rfz+7hTjgeIvLiLaO6dlSEojYYZf5k5Sis+yNOR
 lAdeGAfwuKdloQQymDZibtspdJHIClHfK3FUQAbq3Cv4bku8N1/SuAEuS4h46S3WLLsjzATEe
 tc/sIpLZNftcKnIO2cJrtq4Cwwezaykme8YLCxcSzzMRF9aClkALlqfv9tttAXCb0kodyCegg
 BgZv/Ehqo/XLkeIMYYXuBxPJ2L8xEfczx7vc5+3quFP6fCvonCqHBv90QXJ9NLRdke0WwX7mp
 SDXQDw2cZqtDp8qUovxTXEg5mG+2PEWRI819uSEFsJEU5xNzvm2jzHwd4dOAe8vpbTUTCpkA4
 GWCU4OIt1mZ73n49QKBy0O3XnpyFQnBgfcdp3AS3WsDFIxlx/Vr7FRLamAEI+nq/S2+xGyqUK
 /qfw8bxbqzkLEVRYvnmMmk8l1HEMBdenZKI2LasrG4VagRgBEVK2hlmBiaSMp+Lni0OWNho8A
 ZzSe8Ymqt2FmB4t7xzp8P7vYAxD3yOWNUcYmHLMLYZsKhgm+gpuTinNHkoUlVFbjALhK/UQcy
 Nj1q4Ot/OTRdKyjJSRfqTZhkPUmUx6e+EsK4QnNBmxQ1a7fYwUeq6MZy3sDAvhzggNL7taUtG
 NA2YsUUyipSacoegm0f4uDeoGICZdRuf+d29ts0c6sR4UtUcklxuaNLVobRbwByJL0nuqMkDI
 LE+ed0CqQmA/Mz7Z6YUsxIcBXwhEqZks6pEWnKKXuFYu8fysRXtC2t1j/YHjMPW3O5YzEgS
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
index 6756bd5a3fe4..e0592d337a94 100644
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
+static bool smc_ib_is_valid_local_systemid(void)
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

