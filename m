Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A7F14A6A6D
	for <lists+netdev@lfdr.de>; Wed,  2 Feb 2022 04:09:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243936AbiBBDJH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Feb 2022 22:09:07 -0500
Received: from vmicros1.altlinux.org ([194.107.17.57]:35664 "EHLO
        vmicros1.altlinux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230342AbiBBDJG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Feb 2022 22:09:06 -0500
Received: from mua.local.altlinux.org (mua.local.altlinux.org [192.168.1.14])
        by vmicros1.altlinux.org (Postfix) with ESMTP id EC7A172C8FA;
        Wed,  2 Feb 2022 06:09:04 +0300 (MSK)
Received: by mua.local.altlinux.org (Postfix, from userid 508)
        id DA5887CCAAC; Wed,  2 Feb 2022 06:09:04 +0300 (MSK)
Date:   Wed, 2 Feb 2022 06:09:04 +0300
From:   "Dmitry V. Levin" <ldv@altlinux.org>
To:     Karsten Graul <kgraul@linux.ibm.com>
Cc:     Tony Lu <tonylu@linux.alibaba.com>, kuba@kernel.org,
        davem@davemloft.net, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-rdma@vger.kernel.org,
        linux-api@vger.kernel.org
Subject: [PATCH] Partially revert "net/smc: Add netlink net namespace support"
Message-ID: <20220202030904.GA9742@altlinux.org>
References: <20211228130611.19124-1-tonylu@linux.alibaba.com>
 <20211228130611.19124-3-tonylu@linux.alibaba.com>
 <20220131002453.GA7599@altlinux.org>
 <521e3f2a-8b00-43d4-b296-1253c351a3d2@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <521e3f2a-8b00-43d4-b296-1253c351a3d2@linux.ibm.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The change of sizeof(struct smc_diag_linkinfo) by commit 79d39fc503b4
("net/smc: Add netlink net namespace support") introduced an ABI
regression: since struct smc_diag_lgrinfo contains an object of
type "struct smc_diag_linkinfo", offset of all subsequent members
of struct smc_diag_lgrinfo was changed by that change.

As result, applications compiled with the old version
of struct smc_diag_linkinfo will receive garbage in
struct smc_diag_lgrinfo.role if the kernel implements
this new version of struct smc_diag_linkinfo.

Fix this regression by reverting the part of commit 79d39fc503b4 that
changes struct smc_diag_linkinfo.  After all, there is SMC_GEN_NETLINK
interface which is good enough, so there is probably no need to touch
the smc_diag ABI in the first place.

Fixes: 79d39fc503b4 ("net/smc: Add netlink net namespace support")
Signed-off-by: Dmitry V. Levin <ldv@altlinux.org>
---
 include/uapi/linux/smc_diag.h | 11 +++++------
 net/smc/smc_diag.c            |  2 --
 2 files changed, 5 insertions(+), 8 deletions(-)

diff --git a/include/uapi/linux/smc_diag.h b/include/uapi/linux/smc_diag.h
index c7008d87f1a4..8cb3a6fef553 100644
--- a/include/uapi/linux/smc_diag.h
+++ b/include/uapi/linux/smc_diag.h
@@ -84,12 +84,11 @@ struct smc_diag_conninfo {
 /* SMC_DIAG_LINKINFO */
 
 struct smc_diag_linkinfo {
-	__u8		link_id;		    /* link identifier */
-	__u8		ibname[IB_DEVICE_NAME_MAX]; /* name of the RDMA device */
-	__u8		ibport;			    /* RDMA device port number */
-	__u8		gid[40];		    /* local GID */
-	__u8		peer_gid[40];		    /* peer GID */
-	__aligned_u64	net_cookie;                 /* RDMA device net namespace */
+	__u8 link_id;			/* link identifier */
+	__u8 ibname[IB_DEVICE_NAME_MAX]; /* name of the RDMA device */
+	__u8 ibport;			/* RDMA device port number */
+	__u8 gid[40];			/* local GID */
+	__u8 peer_gid[40];		/* peer GID */
 };
 
 struct smc_diag_lgrinfo {
diff --git a/net/smc/smc_diag.c b/net/smc/smc_diag.c
index b8898c787d23..1fca2f90a9c7 100644
--- a/net/smc/smc_diag.c
+++ b/net/smc/smc_diag.c
@@ -146,13 +146,11 @@ static int __smc_diag_dump(struct sock *sk, struct sk_buff *skb,
 	    (req->diag_ext & (1 << (SMC_DIAG_LGRINFO - 1))) &&
 	    !list_empty(&smc->conn.lgr->list)) {
 		struct smc_link *link = smc->conn.lnk;
-		struct net *net = read_pnet(&link->smcibdev->ibdev->coredev.rdma_net);
 
 		struct smc_diag_lgrinfo linfo = {
 			.role = smc->conn.lgr->role,
 			.lnk[0].ibport = link->ibport,
 			.lnk[0].link_id = link->link_id,
-			.lnk[0].net_cookie = net->net_cookie,
 		};
 
 		memcpy(linfo.lnk[0].ibname,
-- 
ldv
