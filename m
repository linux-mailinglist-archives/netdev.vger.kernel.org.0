Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9A59116B61D
	for <lists+netdev@lfdr.de>; Tue, 25 Feb 2020 00:59:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728424AbgBXX7k (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Feb 2020 18:59:40 -0500
Received: from mout.kundenserver.de ([212.227.17.10]:51761 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726651AbgBXX7k (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Feb 2020 18:59:40 -0500
Received: from kiste.fritz.box ([94.134.180.186]) by mrelayeu.kundenserver.de
 (mreue108 [212.227.15.183]) with ESMTPSA (Nemesis) id
 1M730b-1j3vrh2dVH-008Z8W; Tue, 25 Feb 2020 00:59:30 +0100
From:   Hans Wippel <ndev@hwipl.net>
To:     kgraul@linux.ibm.com, ubraun@linux.ibm.com, davem@davemloft.net
Cc:     netdev@vger.kernel.org, Hans Wippel <ndev@hwipl.net>
Subject: [PATCH net-next 2/2] net/smc: improve peer ID in CLC decline for SMC-R
Date:   Tue, 25 Feb 2020 00:59:01 +0100
Message-Id: <20200224235901.304311-3-ndev@hwipl.net>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200224235901.304311-1-ndev@hwipl.net>
References: <20200224235901.304311-1-ndev@hwipl.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:O3ssSVLsQFXS3Q1XWboOrz/W5XCctT4nTENlSLptjN6xGKd/VR/
 Lmopi04CMfSDDecxCDeDDZSfZ9dO7t0CgAJDryjzso5fIaFSb3URaXI/5rhGNnRMFhD40TR
 FyJx5KuvUs9UZC+q+IaWL/ipm7kihkDn6KB97vlSNufUeHug1XoGWzUqBsSlzkiZ0NO2O3r
 Fr8aUU1kAapR2BDNSOsvA==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:MkZttnZGw90=:6N2l+h0qPj7bIUxXSrXdhp
 CcDQ6mHZlcYsi30oMkYtnAd+ShoOWNqQuExsMoAuij0+FJkZo+4zcbMpEJHrcn9RW45855wxB
 tG4gbWqOLye9WVqVU08WVFgzvGK2xoqIhudRqLsQG2WipQv6WkIf/k5SvTbjWUzA9rASzfJIo
 gx4P8bGTNU8v0DZoYGa1sIRlbhS1Yc6LoLXIIqwZygLl2iIGfz1XgdJ5E5RcoKh165GLb2SdO
 kSJ3javSsmf3HnZZmsG3auQakOERQdpBo17DrUfoH0P4aukbSOD1gB9/+mitagquyTNMUWxnS
 Q61UE26WsYxlu37EDshnj5Et4LbBsb50nWAy/oUMIptWVKfjSDzPjbNQVHfjM14l1RUO0WxF8
 a0Z7T4Wb7WjW8gg9eQDBh+mGP2YHQj3aV4U8zpro8kGfDDhBJrQsPxdZg3izrkL7bjq4d9yzP
 InQtR9hYAoWfrLAvlXxzAydzCO9kYeElDOlliDFivAw3B9Ne6W9A/ZBW5fQw8zQmYsZt6lUzi
 YaBi4c250TnqZzf+GGhXExYga3OZFXSDl1DNWm603ZVtBEV9zdM0KlML6WvI8wjYz4+7H8WDB
 YhNmiiuSF1AEn6wLbqbhnh8qcKn8knxk+es2/y7Kl8zoDuT4CEaVfOd7wMHZa2STlpZ6w3zhP
 FgoJ/sA6CEDtg2bjaXvq56q8VzDQoZzmcrU8wdlv6PGBXZ2Glj24wtMho+qAFQWXAH72j4PsS
 8V1Iog+FSitFr4bPXuu3K8+bTCQxn8FBos5s77/OUueebFjHF0VhAXq22EpDnudGQG0YCkcC5
 FZWUSSLU+l0a4/wCc89qByBFViAavm5p1AbmfiNkM5TdD3JobInHwshe2sNInCEiR5iLIdn
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
 net/smc/smc_clc.c | 9 ++++++---
 net/smc/smc_ib.h  | 1 +
 2 files changed, 7 insertions(+), 3 deletions(-)

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

