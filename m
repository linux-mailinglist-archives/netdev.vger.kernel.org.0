Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0BEA63F043D
	for <lists+netdev@lfdr.de>; Wed, 18 Aug 2021 15:04:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236977AbhHRNE6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Aug 2021 09:04:58 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:17039 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236629AbhHRNEv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Aug 2021 09:04:51 -0400
Received: from dggeme758-chm.china.huawei.com (unknown [172.30.72.53])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4GqSgJ41DfzbffH;
        Wed, 18 Aug 2021 21:00:28 +0800 (CST)
Received: from SZX1000464847.huawei.com (10.21.59.169) by
 dggeme758-chm.china.huawei.com (10.3.19.104) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Wed, 18 Aug 2021 21:04:12 +0800
From:   Dongdong Liu <liudongdong3@huawei.com>
To:     <helgaas@kernel.org>, <hch@infradead.org>, <kw@linux.com>,
        <logang@deltatee.com>, <leon@kernel.org>,
        <linux-pci@vger.kernel.org>, <rajur@chelsio.com>,
        <hverkuil-cisco@xs4all.nl>
CC:     <linux-media@vger.kernel.org>, <netdev@vger.kernel.org>
Subject: [PATCH V8 8/8] PCI/IOV: Enable 10-Bit Tag support for PCIe VF devices
Date:   Wed, 18 Aug 2021 21:01:57 +0800
Message-ID: <1629291717-38564-9-git-send-email-liudongdong3@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1629291717-38564-1-git-send-email-liudongdong3@huawei.com>
References: <1629291717-38564-1-git-send-email-liudongdong3@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.21.59.169]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 dggeme758-chm.china.huawei.com (10.3.19.104)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Enable 10-Bit Tag Requester for the VF devices below the
Root Port that support 10-Bit Tag Completer.

Signed-off-by: Dongdong Liu <liudongdong3@huawei.com>
---
 drivers/pci/iov.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/drivers/pci/iov.c b/drivers/pci/iov.c
index 757e77d..1c40baf 100644
--- a/drivers/pci/iov.c
+++ b/drivers/pci/iov.c
@@ -691,6 +691,15 @@ static int sriov_enable(struct pci_dev *dev, int nr_virtfn)
 
 	pci_iov_set_numvfs(dev, nr_virtfn);
 	iov->ctrl |= PCI_SRIOV_CTRL_VFE | PCI_SRIOV_CTRL_MSE;
+
+	if ((pcie_tag_config == PCIE_TAG_DEFAULT) &&
+	    (iov->cap & PCI_SRIOV_CAP_VF_10BIT_TAG_REQ) &&
+	    pcie_rp_10bit_tag_cmp_supported(dev))
+		iov->ctrl |= PCI_SRIOV_CTRL_VF_10BIT_TAG_REQ_EN;
+
+	if (pcie_tag_config == PCIE_TAG_PEER2PEER)
+		iov->ctrl &= ~PCI_SRIOV_CTRL_VF_10BIT_TAG_REQ_EN;
+
 	pci_cfg_access_lock(dev);
 	pci_write_config_word(dev, iov->pos + PCI_SRIOV_CTRL, iov->ctrl);
 	msleep(100);
@@ -707,6 +716,7 @@ static int sriov_enable(struct pci_dev *dev, int nr_virtfn)
 
 err_pcibios:
 	iov->ctrl &= ~(PCI_SRIOV_CTRL_VFE | PCI_SRIOV_CTRL_MSE);
+	iov->ctrl &= ~PCI_SRIOV_CTRL_VF_10BIT_TAG_REQ_EN;
 	pci_cfg_access_lock(dev);
 	pci_write_config_word(dev, iov->pos + PCI_SRIOV_CTRL, iov->ctrl);
 	ssleep(1);
@@ -739,6 +749,7 @@ static void sriov_disable(struct pci_dev *dev)
 
 	sriov_del_vfs(dev);
 	iov->ctrl &= ~(PCI_SRIOV_CTRL_VFE | PCI_SRIOV_CTRL_MSE);
+	iov->ctrl &= ~PCI_SRIOV_CTRL_VF_10BIT_TAG_REQ_EN;
 	pci_cfg_access_lock(dev);
 	pci_write_config_word(dev, iov->pos + PCI_SRIOV_CTRL, iov->ctrl);
 	ssleep(1);
-- 
2.7.4

