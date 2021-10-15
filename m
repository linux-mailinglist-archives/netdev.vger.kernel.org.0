Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A43842FD38
	for <lists+netdev@lfdr.de>; Fri, 15 Oct 2021 23:07:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238548AbhJOVI2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Oct 2021 17:08:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:34702 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235480AbhJOVI2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 15 Oct 2021 17:08:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id F1B4F611C3;
        Fri, 15 Oct 2021 21:06:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634331981;
        bh=IlGnn3wCr7fmULA2UgnK3XEPOiEF2ongKGvx6w0II7Y=;
        h=From:To:Cc:Subject:Date:From;
        b=EOUlfSJDKIcdQsnN/TCxm7RjxWX4ynK2+/3llvqKcNygog4IQ5VlxTxtJVp2CwCsC
         DG82Ssk4AeRpWhoTEd2nViVAj0jvnSBcw5lySQ/xpru9pK/sakj3p1ho6/ZtNq53qD
         4rr2t2gCZGNs8MQSQNyTwbYJmREVimwTJvplyrReRZW4cfYW0X0Sf7ilx0QvwCpiYd
         5wlh2iPwvbxhsd0c0fZTdyZ4ajdssUFUJTn9Il7skZtcxiLBgQC9XfS/Cm+awtSlxS
         XNsAKjgkYrW2FonOnIn2cUcPG2hsTm2Era6Vsq26v32M9fYR3d1pcMPKx9POXD0Jc/
         CAB8eOi+293YQ==
From:   Arnd Bergmann <arnd@kernel.org>
To:     Sunil Goutham <sgoutham@marvell.com>,
        Geetha sowjanya <gakula@marvell.com>,
        Subbaraya Sundeep <sbhatta@marvell.com>,
        hariprasad <hkelam@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Naveen Mamindlapalli <naveenm@marvell.com>
Cc:     Arnd Bergmann <arnd@arndb.de>,
        Colin Ian King <colin.king@canonical.com>,
        Yi Guo <yig@marvell.com>,
        Zheng Yongjun <zhengyongjun3@huawei.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next] octeontx2-nic: fix mixed module build
Date:   Fri, 15 Oct 2021 23:06:01 +0200
Message-Id: <20211015210616.884437-1-arnd@kernel.org>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

Building the VF and PF side of this driver differently, with one being
a loadable module and the other one built-in results in a link failure
for the common PTP driver:

ld.lld: error: undefined symbol: __this_module
>>> referenced by otx2_ptp.c
>>>               net/ethernet/marvell/octeontx2/nic/otx2_ptp.o:(otx2_ptp_init) in archive drivers/built-in.a
>>> referenced by otx2_ptp.c
>>>               net/ethernet/marvell/octeontx2/nic/otx2_ptp.o:(otx2_ptp_init) in archive drivers/built-in.a

Move the otx2_ptp.c code into a separate module that gets built for
both configurations, making it built-in if at least one of the other
two is built-in.

Fixes: 43510ef4ddad ("octeontx2-nicvf: Add PTP hardware clock support to NIX VF")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/net/ethernet/marvell/octeontx2/nic/Makefile   | 8 ++++----
 drivers/net/ethernet/marvell/octeontx2/nic/otx2_ptp.c | 8 ++++++++
 2 files changed, 12 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/Makefile b/drivers/net/ethernet/marvell/octeontx2/nic/Makefile
index aaf9accc40ed..0048b5946712 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/Makefile
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/Makefile
@@ -3,12 +3,12 @@
 # Makefile for Marvell's RVU Ethernet device drivers
 #
 
-obj-$(CONFIG_OCTEONTX2_PF) += rvu_nicpf.o
-obj-$(CONFIG_OCTEONTX2_VF) += rvu_nicvf.o
+obj-$(CONFIG_OCTEONTX2_PF) += rvu_nicpf.o otx2_ptp.o
+obj-$(CONFIG_OCTEONTX2_VF) += rvu_nicvf.o otx2_ptp.o
 
 rvu_nicpf-y := otx2_pf.o otx2_common.o otx2_txrx.o otx2_ethtool.o \
-               otx2_ptp.o otx2_flows.o otx2_tc.o cn10k.o otx2_dmac_flt.o \
+               otx2_flows.o otx2_tc.o cn10k.o otx2_dmac_flt.o \
                otx2_devlink.o
-rvu_nicvf-y := otx2_vf.o otx2_devlink.o otx2_ptp.o
+rvu_nicvf-y := otx2_vf.o otx2_devlink.o
 
 ccflags-y += -I$(srctree)/drivers/net/ethernet/marvell/octeontx2/af
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_ptp.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_ptp.c
index 85b1f140d3dd..0ef68fdd1f26 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_ptp.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_ptp.c
@@ -297,6 +297,7 @@ int otx2_ptp_init(struct otx2_nic *pfvf)
 error:
 	return err;
 }
+EXPORT_SYMBOL_GPL(otx2_ptp_init);
 
 void otx2_ptp_destroy(struct otx2_nic *pfvf)
 {
@@ -309,6 +310,7 @@ void otx2_ptp_destroy(struct otx2_nic *pfvf)
 	kfree(ptp);
 	pfvf->ptp = NULL;
 }
+EXPORT_SYMBOL_GPL(otx2_ptp_destroy);
 
 int otx2_ptp_clock_index(struct otx2_nic *pfvf)
 {
@@ -317,6 +319,7 @@ int otx2_ptp_clock_index(struct otx2_nic *pfvf)
 
 	return ptp_clock_index(pfvf->ptp->ptp_clock);
 }
+EXPORT_SYMBOL_GPL(otx2_ptp_clock_index);
 
 int otx2_ptp_tstamp2time(struct otx2_nic *pfvf, u64 tstamp, u64 *tsns)
 {
@@ -327,3 +330,8 @@ int otx2_ptp_tstamp2time(struct otx2_nic *pfvf, u64 tstamp, u64 *tsns)
 
 	return 0;
 }
+EXPORT_SYMBOL_GPL(otx2_ptp_tstamp2time);
+
+MODULE_AUTHOR("Sunil Goutham <sgoutham@marvell.com>");
+MODULE_DESCRIPTION("Marvell RVU NIC PTP Driver");
+MODULE_LICENSE("GPL v2");
-- 
2.29.2

