Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0EF2716F14A
	for <lists+netdev@lfdr.de>; Tue, 25 Feb 2020 22:42:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729071AbgBYVmo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Feb 2020 16:42:44 -0500
Received: from mout.kundenserver.de ([217.72.192.74]:52137 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729062AbgBYVmn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Feb 2020 16:42:43 -0500
Received: from kiste.fritz.box ([94.134.180.105]) by mrelayeu.kundenserver.de
 (mreue109 [212.227.15.183]) with ESMTPSA (Nemesis) id
 1M1HmG-1j9T802JWE-002roK; Tue, 25 Feb 2020 22:42:30 +0100
From:   Hans Wippel <ndev@hwipl.net>
To:     kgraul@linux.ibm.com, ubraun@linux.ibm.com, davem@davemloft.net
Cc:     netdev@vger.kernel.org, Hans Wippel <ndev@hwipl.net>
Subject: [PATCH net-next v2 2/2] net/smc: improve peer ID in CLC decline for SMC-R
Date:   Tue, 25 Feb 2020 22:41:22 +0100
Message-Id: <20200225214122.335292-3-ndev@hwipl.net>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200225214122.335292-1-ndev@hwipl.net>
References: <20200225214122.335292-1-ndev@hwipl.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:EmdaMQ+Pd5tqIkdpmwtCMLmktggUZBUskyC8fqunkEUfbsWhlgd
 pRrnQAYbhkglw6o+bNGlVT5dpDNGBhlcAKpbirt1rbebhHoZb67E6fyG6USILMInmhuV+HD
 YdlYX5WnDPcJmIVx80gLvBiXUBiHjdjx3YAlfZkRufW1K7qMaUlZWA9uwD1bDgpGKU1shqn
 IdoxywPPiaeRb+2q1d68Q==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:bIKAsvkU/8M=:BQKPEfTTzK+ET9qkSuj09b
 3aLjmXsbGobVoDgRX5URuoyoK5iFyQs4v6OLK1czWsF8ikPv2rJ3KU65FxXxXxGgQuUwjPNyQ
 J2PVQ92T4mao5LERYtuTDf+rkZYCCrpOW3q4C6msbHPVXk0/e+mlUS63ZSdJp1d7c+YeJYEFC
 YOnZfUFUTifN/EWPry31jjLWpxoUVHb/n01x1lc3de78n3oSHVxckt5+NwdEpWisGbiAPDDr3
 YgAoMAA27dbOwjygRVjRmG6jfnsIKOtRalmwMFcrOR2ATsxD4Ssb0vE+7Mwt/hfVK7dnZOW5d
 nDAKXB0TbBMPfUdhZQdGkvgFWqZmSYeJMV3hvdeh5aX7NK1HctiSQMl07HeRxt59yG6XjaLcQ
 RkQEUV6hh0EwjAchQMIAWXmcH0vWkv5gyK1C4xsi9vNQuBlyXFh9j1eWPwEPWsPWBHt4oOfvF
 04FeUJfo9ELpU2PNpYfw/oJ4skQJTagY/h3clannuLG/1w3bAOSLfK2r5ELLy7l6Q9b94+4v/
 ADkgw9YsvoJ9HjzgzTLun/FC4P7v0cDqJF6Qax4tMr0CPgmJJhGZ5BGL2fQYWhlZ4E83tXJVm
 ncq+4UkiUWTzFoYNG7BN6cgVYFiD5EY8DhICbZeJBoyeluBp4FhUY8HsuPM0PxGXeUALArvld
 DUj/Y64LEz16yYYkTCK8JZz8u4OqSlNaepNm0mXcmjkS/4GLVNnpvDnjE5THczRUISDyYXIkP
 XmuURPy0VuUJ0b1prkDhVvXMCT4H2OOI6zbI+ZSF0iXmtGiyqhMPONRqYWVLpCo1V8L573sKC
 aGKMRYhu63Lw1x2EB5AZFjqldtCEH9fhaObKaKm4RxWI+S6dVW3HCC1oUf8nW2CDMGa0sPF
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

If no RoCE and no ISM device is usable for a connection, there is no LGR
and the LGR check in smc_clc_send_decline() prevents that the peer ID is
copied into the CLC decline message for both SMC-D and SMC-R. So, this
patch modifies the check to also accept the case of no LGR. Also, only a
valid peer ID is copied into the decline message.

Signed-off-by: Hans Wippel <ndev@hwipl.net>
---
 net/smc/smc_clc.c | 3 ++-
 net/smc/smc_ib.c  | 2 +-
 net/smc/smc_ib.h  | 1 +
 3 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/net/smc/smc_clc.c b/net/smc/smc_clc.c
index 3e16b887cfcf..ea0068f0173c 100644
--- a/net/smc/smc_clc.c
+++ b/net/smc/smc_clc.c
@@ -372,7 +372,8 @@ int smc_clc_send_decline(struct smc_sock *smc, u32 peer_diag_info)
 	dclc.hdr.length = htons(sizeof(struct smc_clc_msg_decline));
 	dclc.hdr.version = SMC_CLC_V1;
 	dclc.hdr.flag = (peer_diag_info == SMC_CLC_DECL_SYNCERR) ? 1 : 0;
-	if (smc->conn.lgr && !smc->conn.lgr->is_smcd)
+	if ((!smc->conn.lgr || !smc->conn.lgr->is_smcd) &&
+	    smc_ib_is_valid_local_systemid())
 		memcpy(dclc.id_for_peer, local_systemid,
 		       sizeof(local_systemid));
 	dclc.peer_diagnosis = htonl(peer_diag_info);
diff --git a/net/smc/smc_ib.c b/net/smc/smc_ib.c
index e0592d337a94..3444de27fecd 100644
--- a/net/smc/smc_ib.c
+++ b/net/smc/smc_ib.c
@@ -166,7 +166,7 @@ static inline void smc_ib_define_local_systemid(struct smc_ib_device *smcibdev,
 	       sizeof(smcibdev->mac[ibport - 1]));
 }
 
-static bool smc_ib_is_valid_local_systemid(void)
+bool smc_ib_is_valid_local_systemid(void)
 {
 	return !is_zero_ether_addr(&local_systemid[2]);
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

