Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 13FF766BEB5
	for <lists+netdev@lfdr.de>; Mon, 16 Jan 2023 14:07:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231517AbjAPNHI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Jan 2023 08:07:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231478AbjAPNGk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Jan 2023 08:06:40 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CEF146AD;
        Mon, 16 Jan 2023 05:06:31 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 298E360F8C;
        Mon, 16 Jan 2023 13:06:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5839C433EF;
        Mon, 16 Jan 2023 13:06:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673874390;
        bh=IB+veTmklBKw7PiVo8v/NfpEJifNCfbu55nd+mTVPUg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Zq1PeBxWasNH9Dc8TC5hkRkJlGnfrUF4cWKlF4/fG9vW4QUdGsdaxsghZtSzGekgL
         Ql33dt1b+c8IiQ26vu0nGPhqhXCrfk9adXxFZXDxdtwDHR4x6iJ3SaSyZYBepeCwBZ
         Kc1h7HaqLwA7JpvpcHUpLHDiYeVw/LVwcm3Qkh0MIpAuak9cURPQnFRsQWsR/l+0Yk
         wUKGvViiPRzzYkrTDFpzf2TnxIG8excmNjlptAdTQM7ps0xm/RB3itb2zPmaoGw6tz
         ZlhHeHiLEOPWtUTi0h9Lawmhs2MdwmLgHHbEwdPoDN5CS39q3fayP03G9NKAQ6Vrgl
         DHhkfMNo2J7fQ==
From:   Leon Romanovsky <leon@kernel.org>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Israel Rukshin <israelr@nvidia.com>,
        Bryan Tan <bryantan@vmware.com>,
        Christoph Hellwig <hch@lst.de>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>, Jens Axboe <axboe@fb.com>,
        Keith Busch <kbusch@kernel.org>, linux-kernel@vger.kernel.org,
        linux-nvme@lists.infradead.org, linux-rdma@vger.kernel.org,
        linux-trace-kernel@vger.kernel.org,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Max Gurtovoy <mgurtovoy@nvidia.com>, netdev@vger.kernel.org,
        Paolo Abeni <pabeni@redhat.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Sagi Grimberg <sagi@grimberg.me>,
        Selvin Xavier <selvin.xavier@broadcom.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Vishnu Dasa <vdasa@vmware.com>,
        Yishai Hadas <yishaih@nvidia.com>
Subject: [PATCH rdma-next 07/13] RDMA/core: Add support for creating crypto enabled QPs
Date:   Mon, 16 Jan 2023 15:05:54 +0200
Message-Id: <7a772388d517a28052fa5f0b8ea507cb3fe471fe.1673873422.git.leon@kernel.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <cover.1673873422.git.leon@kernel.org>
References: <cover.1673873422.git.leon@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Israel Rukshin <israelr@nvidia.com>

Add a list of crypto MRs and introduce a crypto WR type to post
on those QPs.

Signed-off-by: Israel Rukshin <israelr@nvidia.com>
Signed-off-by: Leon Romanovsky <leon@kernel.org>
---
 drivers/infiniband/core/verbs.c |  3 +++
 include/rdma/ib_verbs.h         | 12 +++++++++++-
 2 files changed, 14 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/core/verbs.c b/drivers/infiniband/core/verbs.c
index 61473fee4b54..01aefff6760e 100644
--- a/drivers/infiniband/core/verbs.c
+++ b/drivers/infiniband/core/verbs.c
@@ -1223,6 +1223,7 @@ static struct ib_qp *create_qp(struct ib_device *dev, struct ib_pd *pd,
 	spin_lock_init(&qp->mr_lock);
 	INIT_LIST_HEAD(&qp->rdma_mrs);
 	INIT_LIST_HEAD(&qp->sig_mrs);
+	INIT_LIST_HEAD(&qp->crypto_mrs);
 
 	qp->send_cq = attr->send_cq;
 	qp->recv_cq = attr->recv_cq;
@@ -1363,6 +1364,8 @@ struct ib_qp *ib_create_qp_kernel(struct ib_pd *pd,
 				 device->attrs.max_sge_rd);
 	if (qp_init_attr->create_flags & IB_QP_CREATE_INTEGRITY_EN)
 		qp->integrity_en = true;
+	if (qp_init_attr->create_flags & IB_QP_CREATE_CRYPTO_EN)
+		qp->crypto_en = true;
 
 	return qp;
 
diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index 7507661c78d0..1770cd30c0f0 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -1175,6 +1175,8 @@ enum ib_qp_create_flags {
 	IB_QP_CREATE_INTEGRITY_EN		= 1ULL << 34,
 	/* Create an accelerated UD QP */
 	IB_QP_CREATE_NETDEV_USE			= 1ULL << 35,
+	/* The created QP can carry out cryptographic handover operations */
+	IB_QP_CREATE_CRYPTO_EN			= 1ULL << 36,
 };
 
 /*
@@ -1352,6 +1354,12 @@ enum ib_wr_opcode {
 	/* These are kernel only and can not be issued by userspace */
 	IB_WR_REG_MR = 0x20,
 	IB_WR_REG_MR_INTEGRITY,
+	/*
+	 * It is used to assign crypto properties to a MKey. Use the MKey in
+	 * any RDMA transaction (SEND/RECV/READ/WRITE) to encrypt/decrypt data
+	 * on-the-fly.
+	 */
+	IB_WR_REG_MR_CRYPTO,
 
 	/* reserve values for low level drivers' internal use.
 	 * These values will not be used at all in the ib core layer.
@@ -1800,6 +1808,7 @@ struct ib_qp {
 	int			mrs_used;
 	struct list_head	rdma_mrs;
 	struct list_head	sig_mrs;
+	struct list_head	crypto_mrs;
 	struct ib_srq	       *srq;
 	struct ib_xrcd	       *xrcd; /* XRC TGT QPs only */
 	struct list_head	xrcd_list;
@@ -1822,7 +1831,8 @@ struct ib_qp {
 	struct ib_qp_security  *qp_sec;
 	u32			port;
 
-	bool			integrity_en;
+	u8			integrity_en:1;
+	u8			crypto_en:1;
 	/*
 	 * Implementation details of the RDMA core, don't use in drivers:
 	 */
-- 
2.39.0

