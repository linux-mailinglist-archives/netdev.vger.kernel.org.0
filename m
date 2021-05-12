Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7CF0D37C05E
	for <lists+netdev@lfdr.de>; Wed, 12 May 2021 16:38:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231396AbhELOjN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 May 2021 10:39:13 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:3735 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231192AbhELOjJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 May 2021 10:39:09 -0400
Received: from DGGEMS406-HUB.china.huawei.com (unknown [172.30.72.60])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4FgHP83D3PzqTXg;
        Wed, 12 May 2021 22:34:36 +0800 (CST)
Received: from SZX1000464847.huawei.com (10.21.59.169) by
 DGGEMS406-HUB.china.huawei.com (10.3.19.206) with Microsoft SMTP Server id
 14.3.498.0; Wed, 12 May 2021 22:37:56 +0800
From:   Dongdong Liu <liudongdong3@huawei.com>
To:     <helgaas@kernel.org>, <hch@infradead.org>,
        <linux-pci@vger.kernel.org>, <rajur@chelsio.com>,
        <verkuil-cisco@xs4all.nl>
CC:     <linux-media@vger.kernel.org>, <netdev@vger.kernel.org>
Subject: [PATCH V3 5/6] PCI/IOV: Enable 10-Bit tag support for PCIe VF devices
Date:   Wed, 12 May 2021 22:37:36 +0800
Message-ID: <20210512143737.42352-6-liudongdong3@huawei.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512143737.42352-1-liudongdong3@huawei.com>
References: <20210512143737.42352-1-liudongdong3@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.21.59.169]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Enable VF 10-Bit Tag Requester when it's upstream component support
10-bit Tag Completer.

Signed-off-by: Dongdong Liu <liudongdong3@huawei.com>
---
 drivers/pci/iov.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/pci/iov.c b/drivers/pci/iov.c
index afc06e6..3eb4348 100644
--- a/drivers/pci/iov.c
+++ b/drivers/pci/iov.c
@@ -627,6 +627,10 @@ static int sriov_enable(struct pci_dev *dev, int nr_virtfn)
 
 	pci_iov_set_numvfs(dev, nr_virtfn);
 	iov->ctrl |= PCI_SRIOV_CTRL_VFE | PCI_SRIOV_CTRL_MSE;
+	if ((iov->cap & PCI_SRIOV_CAP_VF_10BIT_TAG_REQ) &&
+	    dev->ext_10bit_tag)
+		iov->ctrl |= PCI_SRIOV_CTRL_VF_10BIT_TAG_REQ_EN;
+
 	pci_cfg_access_lock(dev);
 	pci_write_config_word(dev, iov->pos + PCI_SRIOV_CTRL, iov->ctrl);
 	msleep(100);
@@ -643,6 +647,8 @@ static int sriov_enable(struct pci_dev *dev, int nr_virtfn)
 
 err_pcibios:
 	iov->ctrl &= ~(PCI_SRIOV_CTRL_VFE | PCI_SRIOV_CTRL_MSE);
+	if (iov->ctrl & PCI_SRIOV_CTRL_VF_10BIT_TAG_REQ_EN)
+		iov->ctrl &= ~PCI_SRIOV_CTRL_VF_10BIT_TAG_REQ_EN;
 	pci_cfg_access_lock(dev);
 	pci_write_config_word(dev, iov->pos + PCI_SRIOV_CTRL, iov->ctrl);
 	ssleep(1);
@@ -675,6 +681,8 @@ static void sriov_disable(struct pci_dev *dev)
 
 	sriov_del_vfs(dev);
 	iov->ctrl &= ~(PCI_SRIOV_CTRL_VFE | PCI_SRIOV_CTRL_MSE);
+	if (iov->ctrl & PCI_SRIOV_CTRL_VF_10BIT_TAG_REQ_EN)
+		iov->ctrl &= ~PCI_SRIOV_CTRL_VF_10BIT_TAG_REQ_EN;
 	pci_cfg_access_lock(dev);
 	pci_write_config_word(dev, iov->pos + PCI_SRIOV_CTRL, iov->ctrl);
 	ssleep(1);
-- 
2.7.4

