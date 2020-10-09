Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D7159288CE4
	for <lists+netdev@lfdr.de>; Fri,  9 Oct 2020 17:38:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389418AbgJIPgK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Oct 2020 11:36:10 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:30894 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2389257AbgJIPgJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Oct 2020 11:36:09 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 099FUj4h023506;
        Fri, 9 Oct 2020 08:36:01 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=pfpt0220;
 bh=+MnKRYKkIaIWtlImVHl99h7yOtkLJthUYtD35XL7TlY=;
 b=OJ+BLc8M0Fj8SjWtgV/rD9BEW9IGE/3bxgCwbBT470KUugclv2V2M6lMpUZT/eoK/6wZ
 iCvJF60S2B3wQPFWh4ohfcV/ZM+SgMhTJLsOXu9UnD2rgsBXWHSj+Lp8Ifoor1bDNWBd
 3Y7A+a/961rfebsdk36v5Y6L7IqPFM2699vz1MJVlWzlDabQ7ElOWuQhB8Pcrf4Sm4de
 6kLmuf+YRm3Q0UBpgCygJ7OywWjkx1/Nc/ma+qyki8OLpOKpjuYHDi3PsWTVi977CN4n
 jK4AAqfd99XldmKqsoXSuGsB7Vay74yi80/CcuSeYUXYKx44l0/QRqE8TkOGp7hccCoy eA== 
Received: from sc-exch03.marvell.com ([199.233.58.183])
        by mx0b-0016f401.pphosted.com with ESMTP id 3429hh34rd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Fri, 09 Oct 2020 08:36:00 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 9 Oct
 2020 08:35:59 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Fri, 9 Oct 2020 08:35:59 -0700
Received: from hyd1schalla-dt.marvell.com (hyd1schalla-dt.marvell.com [10.29.8.39])
        by maili.marvell.com (Postfix) with ESMTP id E7E4E3F703F;
        Fri,  9 Oct 2020 08:35:54 -0700 (PDT)
From:   Srujana Challa <schalla@marvell.com>
To:     <herbert@gondor.apana.org.au>, <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
        <kuba@kernel.org>, <sgoutham@marvell.com>, <gakula@marvell.com>,
        <sbhatta@marvell.com>, <schandran@marvell.com>,
        <pathreya@marvell.com>, Srujana Challa <schalla@marvell.com>
Subject: [PATCH v4,net-next,10/13] crypto: octeontx2: add mailbox for inline-IPsec RX LF cfg
Date:   Fri, 9 Oct 2020 21:04:18 +0530
Message-ID: <20201009153421.30562-11-schalla@marvell.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201009153421.30562-1-schalla@marvell.com>
References: <20201009153421.30562-1-schalla@marvell.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-10-09_06:2020-10-09,2020-10-09 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add new mailbox message to configure a LF for RX inline-IPsec.
This message is added to serve Marvell CPT VFIO driver, since
a VF can not send mailbox messages to admin function(AF)
directly.

Signed-off-by: Suheil Chandran <schandran@marvell.com>
Signed-off-by: Srujana Challa <schalla@marvell.com>
---
 .../marvell/octeontx2/otx2_cpt_common.h       | 12 +++
 drivers/crypto/marvell/octeontx2/otx2_cptpf.h |  1 +
 .../marvell/octeontx2/otx2_cptpf_main.c       | 44 +++++++++
 .../marvell/octeontx2/otx2_cptpf_mbox.c       | 97 ++++++++++++++++++-
 4 files changed, 152 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/marvell/octeontx2/otx2_cpt_common.h b/drivers/crypto/marvell/octeontx2/otx2_cpt_common.h
index 705a0503b962..1642e4f92d7c 100644
--- a/drivers/crypto/marvell/octeontx2/otx2_cpt_common.h
+++ b/drivers/crypto/marvell/octeontx2/otx2_cpt_common.h
@@ -17,6 +17,9 @@
 #define OTX2_CPT_MAX_VFS_NUM 128
 #define OTX2_CPT_RVU_FUNC_ADDR_S(blk, slot, offs) \
 		(((blk) << 20) | ((slot) << 12) | (offs))
+#define OTX2_CPT_RVU_PFFUNC(pf, func)	\
+		((((pf) & RVU_PFVF_PF_MASK) << RVU_PFVF_PF_SHIFT) | \
+		(((func) & RVU_PFVF_FUNC_MASK) << RVU_PFVF_FUNC_SHIFT))
 
 #define OTX2_CPT_INVALID_CRYPTO_ENG_GRP 0xFF
 #define OTX2_CPT_NAME_LENGTH 64
@@ -34,6 +37,7 @@ enum otx2_cpt_eng_type {
 /* Take mbox id from end of CPT mbox range in AF (range 0xA00 - 0xBFF) */
 #define MBOX_MSG_GET_ENG_GRP_NUM        0xBFF
 #define MBOX_MSG_GET_CAPS               0xBFD
+#define MBOX_MSG_RX_INLINE_IPSEC_LF_CFG 0xBFE
 
 /*
  * Message request and response to get engine group number
@@ -84,6 +88,14 @@ struct otx2_cpt_caps_rsp {
 	u8 cpt_revision;
 	union otx2_cpt_eng_caps eng_caps[OTX2_CPT_MAX_ENG_TYPES];
 };
+/*
+ * Message request to config cpt lf for inline inbound ipsec.
+ * This message is only used between CPT PF <=> CPT VF
+ */
+struct otx2_cpt_rx_inline_lf_cfg {
+	struct mbox_msghdr hdr;
+	u16 sso_pf_func;
+};
 
 static inline void otx2_cpt_write64(void __iomem *reg_base, u64 blk, u64 slot,
 				    u64 offs, u64 val)
diff --git a/drivers/crypto/marvell/octeontx2/otx2_cptpf.h b/drivers/crypto/marvell/octeontx2/otx2_cptpf.h
index fabe9fd33ee7..7ed28c1176dd 100644
--- a/drivers/crypto/marvell/octeontx2/otx2_cptpf.h
+++ b/drivers/crypto/marvell/octeontx2/otx2_cptpf.h
@@ -42,6 +42,7 @@ struct otx2_cptpf_dev {
 	u8 pf_id;               /* RVU PF number */
 	u8 max_vfs;		/* Maximum number of VFs supported by CPT */
 	u8 enabled_vfs;		/* Number of enabled VFs */
+	u8 sso_pf_func_ovrd;	/* SSO PF_FUNC override bit */
 };
 
 irqreturn_t otx2_cptpf_afpf_mbox_intr(int irq, void *arg);
diff --git a/drivers/crypto/marvell/octeontx2/otx2_cptpf_main.c b/drivers/crypto/marvell/octeontx2/otx2_cptpf_main.c
index 548bf614dda5..d6e3f6244eca 100644
--- a/drivers/crypto/marvell/octeontx2/otx2_cptpf_main.c
+++ b/drivers/crypto/marvell/octeontx2/otx2_cptpf_main.c
@@ -216,6 +216,42 @@ static void cptpf_afpf_mbox_destroy(struct otx2_cptpf_dev *cptpf)
 	otx2_mbox_destroy(&cptpf->afpf_mbox);
 }
 
+/*
+ * Create sysfs entry to allow user to configure source of sso_pf_func.
+ */
+static ssize_t sso_pf_func_ovrd_show(struct device *dev,
+				     struct device_attribute *attr, char *buf)
+{
+	struct otx2_cptpf_dev *cptpf = dev_get_drvdata(dev);
+
+	return sprintf(buf, "%d\n", cptpf->sso_pf_func_ovrd);
+}
+
+static ssize_t sso_pf_func_ovrd_store(struct device *dev,
+				      struct device_attribute *attr,
+				      const char *buf, size_t count)
+{
+	struct otx2_cptpf_dev *cptpf = dev_get_drvdata(dev);
+	u8 sso_pf_func_ovrd;
+
+	if (kstrtou8(buf, 0, &sso_pf_func_ovrd))
+		return -EINVAL;
+
+	cptpf->sso_pf_func_ovrd = sso_pf_func_ovrd;
+
+	return count;
+}
+static DEVICE_ATTR_RW(sso_pf_func_ovrd);
+
+static struct attribute *cptpf_attrs[] = {
+	&dev_attr_sso_pf_func_ovrd.attr,
+	NULL
+};
+
+static const struct attribute_group cptpf_sysfs_group = {
+	.attrs = cptpf_attrs,
+};
+
 static int cpt_is_pf_usable(struct otx2_cptpf_dev *cptpf)
 {
 	u64 rev;
@@ -439,7 +475,13 @@ static int otx2_cptpf_probe(struct pci_dev *pdev,
 	if (err)
 		goto unregister_intr;
 
+	err = sysfs_create_group(&dev->kobj, &cptpf_sysfs_group);
+	if (err)
+		goto cleanup_eng_grps;
+
 	return 0;
+cleanup_eng_grps:
+	otx2_cpt_cleanup_eng_grps(pdev, &cptpf->eng_grps);
 unregister_intr:
 	cptpf_disable_afpf_mbox_intr(cptpf);
 free_mbox:
@@ -457,6 +499,8 @@ static void otx2_cptpf_remove(struct pci_dev *pdev)
 		return;
 
 	cptpf_sriov_disable(pdev);
+	/* Delete sysfs entry created for sso_pf_func_ovrd bit. */
+	sysfs_remove_group(&pdev->dev.kobj, &cptpf_sysfs_group);
 	/* Cleanup engine groups */
 	otx2_cpt_cleanup_eng_grps(pdev, &cptpf->eng_grps);
 	/* Disable AF<=>PF mailbox interrupt */
diff --git a/drivers/crypto/marvell/octeontx2/otx2_cptpf_mbox.c b/drivers/crypto/marvell/octeontx2/otx2_cptpf_mbox.c
index c273e6a2a3b7..398bbb656e0c 100644
--- a/drivers/crypto/marvell/octeontx2/otx2_cptpf_mbox.c
+++ b/drivers/crypto/marvell/octeontx2/otx2_cptpf_mbox.c
@@ -5,11 +5,13 @@
 #include "otx2_cptpf.h"
 #include "rvu_reg.h"
 
+/* Fastpath ipsec opcode with inplace processing */
+#define CPT_INLINE_RX_OPCODE (0x26 | (1 << 6))
 /*
  * CPT PF driver version, It will be incremented by 1 for every feature
  * addition in CPT mailbox messages.
  */
-#define OTX2_CPT_PF_DRV_VERSION 0x1
+#define OTX2_CPT_PF_DRV_VERSION 0x2
 
 static int forward_to_af(struct otx2_cptpf_dev *cptpf,
 			 struct otx2_cptvf_info *vf,
@@ -41,6 +43,92 @@ static int forward_to_af(struct otx2_cptpf_dev *cptpf,
 	return 0;
 }
 
+static int rx_inline_ipsec_lf_cfg(struct otx2_cptpf_dev *cptpf, u8 egrp,
+				  u16 sso_pf_func, bool enable)
+{
+	struct cpt_inline_ipsec_cfg_msg *req;
+	struct nix_inline_ipsec_cfg *nix_req;
+	struct pci_dev *pdev = cptpf->pdev;
+	int ret;
+
+	nix_req = (struct nix_inline_ipsec_cfg *)
+		   otx2_mbox_alloc_msg_rsp(&cptpf->afpf_mbox, 0,
+					   sizeof(*nix_req),
+					   sizeof(struct msg_rsp));
+	if (nix_req == NULL) {
+		dev_err(&pdev->dev, "RVU MBOX failed to get message.\n");
+		return -EFAULT;
+	}
+	memset(nix_req, 0, sizeof(*nix_req));
+	nix_req->hdr.id = MBOX_MSG_NIX_INLINE_IPSEC_CFG;
+	nix_req->hdr.sig = OTX2_MBOX_REQ_SIG;
+	nix_req->enable = enable;
+	nix_req->cpt_credit = OTX2_CPT_INST_QLEN_MSGS - 1;
+	nix_req->gen_cfg.egrp = egrp;
+	nix_req->gen_cfg.opcode = CPT_INLINE_RX_OPCODE;
+	nix_req->inst_qsel.cpt_pf_func = OTX2_CPT_RVU_PFFUNC(cptpf->pf_id, 0);
+	nix_req->inst_qsel.cpt_slot = 0;
+	ret = otx2_cpt_send_mbox_msg(&cptpf->afpf_mbox, pdev);
+	if (ret)
+		return ret;
+
+	req = (struct cpt_inline_ipsec_cfg_msg *)
+	      otx2_mbox_alloc_msg_rsp(&cptpf->afpf_mbox, 0,
+				      sizeof(*req), sizeof(struct msg_rsp));
+	if (req == NULL) {
+		dev_err(&pdev->dev, "RVU MBOX failed to get message.\n");
+		return -EFAULT;
+	}
+	memset(req, 0, sizeof(*req));
+	req->hdr.id = MBOX_MSG_CPT_INLINE_IPSEC_CFG;
+	req->hdr.sig = OTX2_MBOX_REQ_SIG;
+	req->hdr.pcifunc = OTX2_CPT_RVU_PFFUNC(cptpf->pf_id, 0);
+	req->dir = CPT_INLINE_INBOUND;
+	req->slot = 0;
+	req->sso_pf_func_ovrd = cptpf->sso_pf_func_ovrd;
+	req->sso_pf_func = sso_pf_func;
+	req->enable = enable;
+
+	return otx2_cpt_send_mbox_msg(&cptpf->afpf_mbox, pdev);
+}
+
+static int handle_msg_rx_inline_ipsec_lf_cfg(struct otx2_cptpf_dev *cptpf,
+					     struct mbox_msghdr *req)
+{
+	struct otx2_cpt_rx_inline_lf_cfg *cfg_req;
+	u8 egrp;
+	int ret;
+
+	cfg_req = (struct otx2_cpt_rx_inline_lf_cfg *)req;
+	if (cptpf->lfs.lfs_num) {
+		dev_err(&cptpf->pdev->dev,
+			"LF is already configured for RX inline ipsec.\n");
+		return -EEXIST;
+	}
+	/*
+	 * Allow LFs to execute requests destined to only grp IE_TYPES and
+	 * set queue priority of each LF to high
+	 */
+	egrp = otx2_cpt_get_eng_grp(&cptpf->eng_grps, OTX2_CPT_IE_TYPES);
+	if (egrp == OTX2_CPT_INVALID_CRYPTO_ENG_GRP) {
+		dev_err(&cptpf->pdev->dev,
+			"Engine group for inline ipsec is not available\n");
+		return -ENOENT;
+	}
+	ret = otx2_cptlf_init(&cptpf->lfs, 1 << egrp, OTX2_CPT_QUEUE_HI_PRIO, 1);
+	if (ret)
+		return ret;
+
+	ret = rx_inline_ipsec_lf_cfg(cptpf, egrp, cfg_req->sso_pf_func, true);
+	if (ret)
+		goto lf_cleanup;
+
+	return 0;
+lf_cleanup:
+	otx2_cptlf_shutdown(&cptpf->lfs);
+	return ret;
+}
+
 static int handle_msg_get_caps(struct otx2_cptpf_dev *cptpf,
 			       struct otx2_cptvf_info *vf,
 			       struct mbox_msghdr *req)
@@ -103,6 +191,9 @@ static int cptpf_handle_vf_req(struct otx2_cptpf_dev *cptpf,
 	case MBOX_MSG_GET_CAPS:
 		err = handle_msg_get_caps(cptpf, vf, req);
 		break;
+	case MBOX_MSG_RX_INLINE_IPSEC_LF_CFG:
+		err = handle_msg_rx_inline_ipsec_lf_cfg(cptpf, req);
+		break;
 	default:
 		err = forward_to_af(cptpf, vf, req, size);
 		break;
@@ -246,7 +337,9 @@ static void process_afpf_mbox_msg(struct otx2_cptpf_dev *cptpf,
 		if (!msg->rc)
 			cptpf->lfs.are_lfs_attached = 0;
 		break;
-
+	case MBOX_MSG_CPT_INLINE_IPSEC_CFG:
+	case MBOX_MSG_NIX_INLINE_IPSEC_CFG:
+		break;
 	default:
 		dev_err(dev,
 			"Unsupported msg %d received.\n", msg->id);
-- 
2.28.0

