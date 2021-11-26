Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1964045E4E9
	for <lists+netdev@lfdr.de>; Fri, 26 Nov 2021 03:39:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358109AbhKZChn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Nov 2021 21:37:43 -0500
Received: from mail.kernel.org ([198.145.29.99]:47828 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1357704AbhKZCfm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 25 Nov 2021 21:35:42 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6002C61155;
        Fri, 26 Nov 2021 02:32:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637893938;
        bh=f8FDVQlSX/kwqMVCs12n3hux8Hv+01Gm08VbV2EG0pI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=L/2mMTqL06Ac8KMkiQ/Dd7wiyoLUC5kfkLZ5fTUjIJPwI+6SV0GTfSxAPulHMyn2L
         7ZvyXUA2ALFHq0gODpbmLxckurWBwccbmpR67YI1QNT0oT+CCOemVb2m0PH1IHxOoh
         7wEQwRsNv4ff1stoxD3+5e69gNB4Z3awsfmZlg5gWGSd5IPMA/YJBJmX7SQHCIJuls
         U2irv6L5oYTwU9/l/GngivoS/f1VBnzSsipTJ68+DfL4bqiQxoNxDB/2QNemlvFQ/g
         uNVKFoxdCP21pNnWzvKXcXT19jV+R3E6xTl1m1Q9gVUn2VK416SEDgEcQhTJQrYgII
         ReIWvmncL9Kog==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Zekun Shen <bruceshenzk@gmail.com>,
        Brendan Dolan-Gavitt <brendandg@nyu.edu>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, irusskikh@marvell.com,
        kuba@kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 11/39] atlantic: Fix OOB read and write in hw_atl_utils_fw_rpc_wait
Date:   Thu, 25 Nov 2021 21:31:28 -0500
Message-Id: <20211126023156.441292-11-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211126023156.441292-1-sashal@kernel.org>
References: <20211126023156.441292-1-sashal@kernel.org>
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
index 404cbf60d3f2f..da1d185f6d226 100644
--- a/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_utils.c
+++ b/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_utils.c
@@ -559,6 +559,11 @@ int hw_atl_utils_fw_rpc_wait(struct aq_hw_s *self,
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
@@ -567,6 +572,11 @@ int hw_atl_utils_fw_rpc_wait(struct aq_hw_s *self,
 
 	if (rpc) {
 		if (fw.len) {
+			if (fw.len > sizeof(self->rpc)) {
+				printk(KERN_INFO "Invalid fw len: %x\n", fw.len);
+				err = -EINVAL;
+				goto err_exit;
+			}
 			err =
 			hw_atl_utils_fw_downld_dwords(self,
 						      self->rpc_addr,
-- 
2.33.0

