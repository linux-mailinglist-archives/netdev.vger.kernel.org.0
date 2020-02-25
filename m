Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3353116B633
	for <lists+netdev@lfdr.de>; Tue, 25 Feb 2020 01:01:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728690AbgBYABL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Feb 2020 19:01:11 -0500
Received: from gateway22.websitewelcome.com ([192.185.46.229]:13044 "EHLO
        gateway22.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728653AbgBYABJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Feb 2020 19:01:09 -0500
Received: from cm11.websitewelcome.com (cm11.websitewelcome.com [100.42.49.5])
        by gateway22.websitewelcome.com (Postfix) with ESMTP id C777FB121
        for <netdev@vger.kernel.org>; Mon, 24 Feb 2020 18:01:07 -0600 (CST)
Received: from gator4166.hostgator.com ([108.167.133.22])
        by cmsmtp with SMTP
        id 6NetjIrOKSl8q6Netjxu3w; Mon, 24 Feb 2020 18:01:07 -0600
X-Authority-Reason: nr=8
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=embeddedor.com; s=default; h=Content-Type:MIME-Version:Message-ID:Subject:
        Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=7YVRuLJggwkZM9arqIBIu//jc9M46qO2P0Pzk4kTM/w=; b=uIacdZO+gRUXg6Nz6B0j5wvSrt
        xoho3tMu8NiCqxEaKm94kMqvXlp9exLIxhSFpgiuH1q1XlywHUU/l3CkAdCmbRgcupovYgDtTVKYh
        7kr7+Z4Go+x45891K+W7cm4dgUrdaopS7WMMmiomDDSzmmFdNsy2BOAsuBIroN5oUBo2pFN6jKC0+
        VOZfvhvq5uBrSa3/2GPakrk4Fur75rT0ENiOfnCA2dWnf/OSqTqsm3VGJ3zSaXn7xJ9mgDIrC33cN
        Ychjk69lr+0Z/vE7FdxnmD56zRFstNZPWnYI4WCjTcRCDN0xPCfQXyK5jzFmPGLPj3jSiFWdzzfdZ
        OBAFGkww==;
Received: from [201.166.191.75] (port=54190 helo=embeddedor)
        by gator4166.hostgator.com with esmtpa (Exim 4.92)
        (envelope-from <gustavo@embeddedor.com>)
        id 1j6Ner-002K9u-L7; Mon, 24 Feb 2020 18:01:06 -0600
Date:   Mon, 24 Feb 2020 18:03:55 -0600
From:   "Gustavo A. R. Silva" <gustavo@embeddedor.com>
To:     Manish Chopra <manishc@marvell.com>,
        Rahul Verma <rahulv@marvell.com>,
        "GR-Linux-NIC-Dev@marvell.com David S. Miller" <davem@davemloft.net>,
        Shahed Shaikh <shshaikh@marvell.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Subject: [PATCH][next] qlogic: Replace zero-length array with flexible-array
 member
Message-ID: <20200225000355.GA16193@embeddedor>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.9.4 (2018-02-28)
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - gator4166.hostgator.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - embeddedor.com
X-BWhitelist: no
X-Source-IP: 201.166.191.75
X-Source-L: No
X-Exim-ID: 1j6Ner-002K9u-L7
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: (embeddedor) [201.166.191.75]:54190
X-Source-Auth: gustavo@embeddedor.com
X-Email-Count: 5
X-Source-Cap: Z3V6aWRpbmU7Z3V6aWRpbmU7Z2F0b3I0MTY2Lmhvc3RnYXRvci5jb20=
X-Local-Domain: yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The current codebase makes use of the zero-length array language
extension to the C90 standard, but the preferred mechanism to declare
variable-length types such as these ones is a flexible array member[1][2],
introduced in C99:

struct foo {
        int stuff;
        struct boo array[];
};

By making use of the mechanism above, we will get a compiler warning
in case the flexible array does not occur last in the structure, which
will help us prevent some kind of undefined behavior bugs from being
inadvertently introduced[3] to the codebase from now on.

Also, notice that, dynamic memory allocations won't be affected by
this change:

"Flexible array members have incomplete type, and so the sizeof operator
may not be applied. As a quirk of the original implementation of
zero-length arrays, sizeof evaluates to zero."[1]

This issue was detected with the help of Coccinelle.

[1] https://gcc.gnu.org/onlinedocs/gcc/Zero-Length.html
[2] https://github.com/KSPP/linux/issues/21
[3] commit 76497732932f ("cxgb3/l2t: Fix undefined behaviour")

Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
---
 drivers/net/ethernet/qlogic/netxen/netxen_nic.h | 2 +-
 drivers/net/ethernet/qlogic/qlcnic/qlcnic.h     | 8 ++++----
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/qlogic/netxen/netxen_nic.h b/drivers/net/ethernet/qlogic/netxen/netxen_nic.h
index 3dce769d83a1..86153660d245 100644
--- a/drivers/net/ethernet/qlogic/netxen/netxen_nic.h
+++ b/drivers/net/ethernet/qlogic/netxen/netxen_nic.h
@@ -1316,7 +1316,7 @@ struct netxen_minidump_template_hdr {
 	u32 driver_info_word4;
 	u32 saved_state_array[NX_DUMP_STATE_ARRAY_LEN];
 	u32 capture_size_array[NX_DUMP_CAP_SIZE_ARRAY_LEN];
-	u32 rsvd[0];
+	u32 rsvd[];
 };
 
 /* Common Entry Header:  Common to All Entry Types */
diff --git a/drivers/net/ethernet/qlogic/qlcnic/qlcnic.h b/drivers/net/ethernet/qlogic/qlcnic/qlcnic.h
index 374a4d4371f9..134611aa2c9a 100644
--- a/drivers/net/ethernet/qlogic/qlcnic/qlcnic.h
+++ b/drivers/net/ethernet/qlogic/qlcnic/qlcnic.h
@@ -418,7 +418,7 @@ struct qlcnic_83xx_dump_template_hdr {
 	u32	saved_state[16];
 	u32	cap_sizes[8];
 	u32	ocm_wnd_reg[16];
-	u32	rsvd[0];
+	u32	rsvd[];
 };
 
 struct qlcnic_82xx_dump_template_hdr {
@@ -436,7 +436,7 @@ struct qlcnic_82xx_dump_template_hdr {
 	u32	cap_sizes[8];
 	u32	rsvd[7];
 	u32	capabilities;
-	u32	rsvd1[0];
+	u32	rsvd1[];
 };
 
 #define QLC_PEX_DMA_READ_SIZE	(PAGE_SIZE * 16)
@@ -740,7 +740,7 @@ struct qlcnic_hostrq_rx_ctx {
 	   The following is packed:
 	   - N hostrq_rds_rings
 	   - N hostrq_sds_rings */
-	char data[0];
+	char data[];
 } __packed;
 
 struct qlcnic_cardrsp_rds_ring{
@@ -769,7 +769,7 @@ struct qlcnic_cardrsp_rx_ctx {
 	   The following is packed:
 	   - N cardrsp_rds_rings
 	   - N cardrs_sds_rings */
-	char data[0];
+	char data[];
 } __packed;
 
 #define SIZEOF_HOSTRQ_RX(HOSTRQ_RX, rds_rings, sds_rings)	\
-- 
2.25.0

