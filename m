Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 76F2C480962
	for <lists+netdev@lfdr.de>; Tue, 28 Dec 2021 14:07:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232084AbhL1NHK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Dec 2021 08:07:10 -0500
Received: from out30-56.freemail.mail.aliyun.com ([115.124.30.56]:39831 "EHLO
        out30-56.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232019AbhL1NHI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Dec 2021 08:07:08 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R211e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e01424;MF=tonylu@linux.alibaba.com;NM=1;PH=DS;RN=6;SR=0;TI=SMTPD_---0V07F2T5_1640696825;
Received: from localhost(mailfrom:tonylu@linux.alibaba.com fp:SMTPD_---0V07F2T5_1640696825)
          by smtp.aliyun-inc.com(127.0.0.1);
          Tue, 28 Dec 2021 21:07:05 +0800
From:   Tony Lu <tonylu@linux.alibaba.com>
To:     kgraul@linux.ibm.com
Cc:     kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-rdma@vger.kernel.org
Subject: [PATCH 2/4] net/smc: Add netlink net namespace support
Date:   Tue, 28 Dec 2021 21:06:10 +0800
Message-Id: <20211228130611.19124-3-tonylu@linux.alibaba.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211228130611.19124-1-tonylu@linux.alibaba.com>
References: <20211228130611.19124-1-tonylu@linux.alibaba.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This adds net namespace ID to diag of linkgroup, helps us to distinguish
different namespaces, and net_cookie is unique in the whole system.

Signed-off-by: Tony Lu <tonylu@linux.alibaba.com>
---
 include/uapi/linux/smc.h      |  2 ++
 include/uapi/linux/smc_diag.h | 11 ++++++-----
 net/smc/smc_core.c            |  3 +++
 net/smc/smc_diag.c            | 16 +++++++++-------
 4 files changed, 20 insertions(+), 12 deletions(-)

diff --git a/include/uapi/linux/smc.h b/include/uapi/linux/smc.h
index 20f33b27787f..6c2874fd2c00 100644
--- a/include/uapi/linux/smc.h
+++ b/include/uapi/linux/smc.h
@@ -119,6 +119,8 @@ enum {
 	SMC_NLA_LGR_R_CONNS_NUM,	/* u32 */
 	SMC_NLA_LGR_R_V2_COMMON,	/* nest */
 	SMC_NLA_LGR_R_V2,		/* nest */
+	SMC_NLA_LGR_R_NET_COOKIE,	/* u64 */
+	SMC_NLA_LGR_R_PAD,		/* flag */
 	__SMC_NLA_LGR_R_MAX,
 	SMC_NLA_LGR_R_MAX = __SMC_NLA_LGR_R_MAX - 1
 };
diff --git a/include/uapi/linux/smc_diag.h b/include/uapi/linux/smc_diag.h
index 8cb3a6fef553..c7008d87f1a4 100644
--- a/include/uapi/linux/smc_diag.h
+++ b/include/uapi/linux/smc_diag.h
@@ -84,11 +84,12 @@ struct smc_diag_conninfo {
 /* SMC_DIAG_LINKINFO */
 
 struct smc_diag_linkinfo {
-	__u8 link_id;			/* link identifier */
-	__u8 ibname[IB_DEVICE_NAME_MAX]; /* name of the RDMA device */
-	__u8 ibport;			/* RDMA device port number */
-	__u8 gid[40];			/* local GID */
-	__u8 peer_gid[40];		/* peer GID */
+	__u8		link_id;		    /* link identifier */
+	__u8		ibname[IB_DEVICE_NAME_MAX]; /* name of the RDMA device */
+	__u8		ibport;			    /* RDMA device port number */
+	__u8		gid[40];		    /* local GID */
+	__u8		peer_gid[40];		    /* peer GID */
+	__aligned_u64	net_cookie;                 /* RDMA device net namespace */
 };
 
 struct smc_diag_lgrinfo {
diff --git a/net/smc/smc_core.c b/net/smc/smc_core.c
index 05c11bbe4318..b9d6148d1287 100644
--- a/net/smc/smc_core.c
+++ b/net/smc/smc_core.c
@@ -348,6 +348,9 @@ static int smc_nl_fill_lgr(struct smc_link_group *lgr,
 		goto errattr;
 	if (nla_put_u8(skb, SMC_NLA_LGR_R_VLAN_ID, lgr->vlan_id))
 		goto errattr;
+	if (nla_put_u64_64bit(skb, SMC_NLA_LGR_R_NET_COOKIE,
+			      lgr->net->net_cookie, SMC_NLA_LGR_R_PAD))
+		goto errattr;
 	memcpy(smc_target, lgr->pnet_id, SMC_MAX_PNETID_LEN);
 	smc_target[SMC_MAX_PNETID_LEN] = 0;
 	if (nla_put_string(skb, SMC_NLA_LGR_R_PNETID, smc_target))
diff --git a/net/smc/smc_diag.c b/net/smc/smc_diag.c
index c952986a6aca..7c8dad28c18d 100644
--- a/net/smc/smc_diag.c
+++ b/net/smc/smc_diag.c
@@ -145,19 +145,21 @@ static int __smc_diag_dump(struct sock *sk, struct sk_buff *skb,
 	if (smc->conn.lgr && !smc->conn.lgr->is_smcd &&
 	    (req->diag_ext & (1 << (SMC_DIAG_LGRINFO - 1))) &&
 	    !list_empty(&smc->conn.lgr->list)) {
+		struct smc_link *link = smc->conn.lnk;
+		struct net *net = read_pnet(&link->smcibdev->ibdev->coredev.rdma_net);
+
 		struct smc_diag_lgrinfo linfo = {
 			.role = smc->conn.lgr->role,
-			.lnk[0].ibport = smc->conn.lnk->ibport,
-			.lnk[0].link_id = smc->conn.lnk->link_id,
+			.lnk[0].ibport = link->ibport,
+			.lnk[0].link_id = link->link_id,
+			.lnk[0].net_cookie = net->net_cookie,
 		};
 
 		memcpy(linfo.lnk[0].ibname,
 		       smc->conn.lgr->lnk[0].smcibdev->ibdev->name,
-		       sizeof(smc->conn.lnk->smcibdev->ibdev->name));
-		smc_gid_be16_convert(linfo.lnk[0].gid,
-				     smc->conn.lnk->gid);
-		smc_gid_be16_convert(linfo.lnk[0].peer_gid,
-				     smc->conn.lnk->peer_gid);
+		       sizeof(link->smcibdev->ibdev->name));
+		smc_gid_be16_convert(linfo.lnk[0].gid, link->gid);
+		smc_gid_be16_convert(linfo.lnk[0].peer_gid, link->peer_gid);
 
 		if (nla_put(skb, SMC_DIAG_LGRINFO, sizeof(linfo), &linfo) < 0)
 			goto errout;
-- 
2.32.0.3.g01195cf9f

