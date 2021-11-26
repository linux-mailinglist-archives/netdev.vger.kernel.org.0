Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4498545E603
	for <lists+netdev@lfdr.de>; Fri, 26 Nov 2021 04:01:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358342AbhKZCrN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Nov 2021 21:47:13 -0500
Received: from mail.kernel.org ([198.145.29.99]:50238 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1358889AbhKZCpN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 25 Nov 2021 21:45:13 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9C4DC611ED;
        Fri, 26 Nov 2021 02:36:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637894173;
        bh=3pmL7kQ4n/I/dsMAcvpwr8nPHd9gs9T8hceqHeWNdjQ=;
        h=From:To:Cc:Subject:Date:From;
        b=OHAPO8EIDfyxCNdLDgKjrVhFMjO1CyPtz45OZ7dGteUwufuYVyqj6RlFErky5K6pY
         IfP61ogvpO5LEJ3Kg00wTM25etz8z5K2Ce48w29J06vFwOXSfgRecED8Q+r5JOd7Cq
         uGabK3qtX1USGqprkaPH1bRiHDVOt7YF077eOdMtj6CjNWf6ihoUGTJ8IbH5C/+AAi
         T8zg9di5SbQWr3Z4ZAe/HJzorMGz0IkzWvQg4nlD797UwsPOIlqBj6vX91fK7ETi04
         NrK8Hg+RuCXjWnksng8VlIIofMRxweo/4xcNGezKzN0mojpGc+FK8+RLeXF3XEmh4E
         eH8anE4cuNSJg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Zekun Shen <bruceshenzk@gmail.com>,
        Brendan Dolan-Gavitt <brendandg@nyu.edu>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, irusskikh@marvell.com,
        kuba@kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 01/12] atlantic: Fix OOB read and write in hw_atl_utils_fw_rpc_wait
Date:   Thu, 25 Nov 2021 21:35:57 -0500
Message-Id: <20211126023611.443098-1-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Zekun Shen <bruceshenzk@gmail.com>

[ Upstream commit b922f622592af76b57cbc566eaeccda0b31a3496 ]

This bug report shows up when running our research tools. The
reports is SOOB read, but it seems SOOB write is also possible
a few lines below.

In details, fw.len and sw.len are inputs coming from io. A len
over the size of self->rpc triggers SOOB. The patch fixes the
bugs by adding sanity checks.

The bugs are triggerable with compromised/malfunctioning devices.
They are potentially exploitable given they first leak up to
0xffff bytes and able to overwrite the region later.

The patch is tested with QEMU emulater.
This is NOT tested with a real device.

Attached is the log we found by fuzzing.

BUG: KASAN: slab-out-of-bounds in
	hw_atl_utils_fw_upload_dwords+0x393/0x3c0 [atlantic]
Read of size 4 at addr ffff888016260b08 by task modprobe/213
CPU: 0 PID: 213 Comm: modprobe Not tainted 5.6.0 #1
Call Trace:
 dump_stack+0x76/0xa0
 print_address_description.constprop.0+0x16/0x200
 ? hw_atl_utils_fw_upload_dwords+0x393/0x3c0 [atlantic]
 ? hw_atl_utils_fw_upload_dwords+0x393/0x3c0 [atlantic]
 __kasan_report.cold+0x37/0x7c
 ? aq_hw_read_reg_bit+0x60/0x70 [atlantic]
 ? hw_atl_utils_fw_upload_dwords+0x393/0x3c0 [atlantic]
 kasan_report+0xe/0x20
 hw_atl_utils_fw_upload_dwords+0x393/0x3c0 [atlantic]
 hw_atl_utils_fw_rpc_call+0x95/0x130 [atlantic]
 hw_atl_utils_fw_rpc_wait+0x176/0x210 [atlantic]
 hw_atl_utils_mpi_create+0x229/0x2e0 [atlantic]
 ? hw_atl_utils_fw_rpc_wait+0x210/0x210 [atlantic]
 ? hw_atl_utils_initfw+0x9f/0x1c8 [atlantic]
 hw_atl_utils_initfw+0x12a/0x1c8 [atlantic]
 aq_nic_ndev_register+0x88/0x650 [atlantic]
 ? aq_nic_ndev_init+0x235/0x3c0 [atlantic]
 aq_pci_probe+0x731/0x9b0 [atlantic]
 ? aq_pci_func_init+0xc0/0xc0 [atlantic]
 local_pci_probe+0xd3/0x160
 pci_device_probe+0x23f/0x3e0

Reported-by: Brendan Dolan-Gavitt <brendandg@nyu.edu>
Signed-off-by: Zekun Shen <bruceshenzk@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../ethernet/aquantia/atlantic/hw_atl/hw_atl_utils.c   | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_utils.c b/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_utils.c
index 1fe016fc4bc70..5a7a1fd44d3fa 100644
--- a/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_utils.c
+++ b/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_utils.c
@@ -209,6 +209,11 @@ static int hw_atl_utils_fw_rpc_wait(struct aq_hw_s *self,
 			goto err_exit;
 
 		if (fw.len == 0xFFFFU) {
+			if (sw.len > sizeof(self->rpc)) {
+				printk(KERN_INFO "Invalid sw len: %x\n", sw.len);
+				err = -EINVAL;
+				goto err_exit;
+			}
 			err = hw_atl_utils_fw_rpc_call(self, sw.len);
 			if (err < 0)
 				goto err_exit;
@@ -219,6 +224,11 @@ static int hw_atl_utils_fw_rpc_wait(struct aq_hw_s *self,
 
 	if (rpc) {
 		if (fw.len) {
+			if (fw.len > sizeof(self->rpc)) {
+				printk(KERN_INFO "Invalid fw len: %x\n", fw.len);
+				err = -EINVAL;
+				goto err_exit;
+			}
 			err =
 			hw_atl_utils_fw_downld_dwords(self,
 						      PHAL_ATLANTIC->rpc_addr,
-- 
2.33.0

