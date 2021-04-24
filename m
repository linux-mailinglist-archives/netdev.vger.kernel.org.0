Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 68EE436A2EB
	for <lists+netdev@lfdr.de>; Sat, 24 Apr 2021 22:21:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237298AbhDXUP3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 24 Apr 2021 16:15:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237074AbhDXUPZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 24 Apr 2021 16:15:25 -0400
Received: from mail-pg1-x534.google.com (mail-pg1-x534.google.com [IPv6:2607:f8b0:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 825B9C061574
        for <netdev@vger.kernel.org>; Sat, 24 Apr 2021 13:14:46 -0700 (PDT)
Received: by mail-pg1-x534.google.com with SMTP id d10so37496661pgf.12
        for <netdev@vger.kernel.org>; Sat, 24 Apr 2021 13:14:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=LaU+YFZcXV78gbWkrECUiY0O8bzhC8KaMna0O3Y3ccY=;
        b=XYrKSSQ82U0+a/Ajd1M0IdOh1blqumbB392VtnFH4u67gWXb9BbvggU8r5k2SrfqsM
         O/0gfZncMQmX4y2RBr2ylWkJRavZE+4UjSLAi0NgxPz6Wf1DBXPVaIEdDVX9XDba7JsO
         0yENa3cLdE9ZR5DVju2qClH9L8nbL031N8mBc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=LaU+YFZcXV78gbWkrECUiY0O8bzhC8KaMna0O3Y3ccY=;
        b=r37it/dJpHW9KFM/H0hoKhavKYDkLoxl8sERYUpWvH1HZQhf+EbhVkbpMlnsNbbKtu
         Sv4kZ6yquuuA9GQxEjq9r+mjQDs4ibwLo9vy4NeF9tp0wfnkKx9m9nygD5nEmqPBvZIu
         RatU0lYZAcNKxiD6w1AnMo1v1KbdRP9QhTkbJRM6HYLKqFSd6YeJRJWIPReV/5D6OYHr
         aUuHvh8D6/S04SSmYw8MeDPqUAH8yT4SBWfZRebcpxkV88AnrkA9/vmV+10LTd9wu0Fh
         tZf+rJVQ6JXcWXudkTZYEwzlvB0BajA6R22+c5aev5H/jVqpydroJ9JWk0hRxtcE8VR6
         bTCQ==
X-Gm-Message-State: AOAM531U4fR5ybawpwFd1asZgl0Gjw5FWhfzI7//sbAkAipcPXCUCUdL
        tWtQDQ1Ubse9EnAxIhiUfGgqqA==
X-Google-Smtp-Source: ABdhPJzs3vwCIrLJXFOPnD4urgvkCBUfQGR92JPL0Mt8I6Qi6NeidYy0/2IG2iCiDxoELZKsh5USgQ==
X-Received: by 2002:a63:204f:: with SMTP id r15mr2797595pgm.315.1619295285798;
        Sat, 24 Apr 2021 13:14:45 -0700 (PDT)
Received: from localhost.swdvt.lab.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id z29sm7914070pga.52.2021.04.24.13.14.45
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 24 Apr 2021 13:14:45 -0700 (PDT)
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, kuba@kernel.org, gospo@broadcom.com
Subject: [PATCH net-next 04/10] bnxt_en: allow promiscuous mode for trusted VFs
Date:   Sat, 24 Apr 2021 16:14:25 -0400
Message-Id: <1619295271-30853-5-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1619295271-30853-1-git-send-email-michael.chan@broadcom.com>
References: <1619295271-30853-1-git-send-email-michael.chan@broadcom.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="00000000000054001805c0bd90f1"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--00000000000054001805c0bd90f1

From: Edwin Peer <edwin.peer@broadcom.com>

Firmware previously only allowed promiscuous mode for VFs associated with
a default VLAN. It is now possible to enable promiscuous mode for a VF
having no VLAN configured provided that it is trusted. In such cases the
VF will see all packets received by the PF, irrespective of destination
MAC or VLAN.

Note, it is necessary to query firmware at the time of bnxt_promisc_ok()
instead of in bnxt_hwrm_func_qcfg() because the trusted status might be
altered by the PF after the VF has been configured. This check must now
also be deferred because the firmware call sleeps.

Signed-off-by: Edwin Peer <edwin.peer@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c       | 11 +++++++----
 drivers/net/ethernet/broadcom/bnxt/bnxt_sriov.c |  6 +++---
 drivers/net/ethernet/broadcom/bnxt/bnxt_sriov.h |  1 +
 3 files changed, 11 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index dcf1598afac2..9862f517960d 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -8340,11 +8340,11 @@ static int bnxt_alloc_rfs_vnics(struct bnxt *bp)
 #endif
 }
 
-/* Allow PF and VF with default VLAN to be in promiscuous mode */
+/* Allow PF, trusted VFs and VFs with default VLAN to be in promiscuous mode */
 static bool bnxt_promisc_ok(struct bnxt *bp)
 {
 #ifdef CONFIG_BNXT_SRIOV
-	if (BNXT_VF(bp) && !bp->vf.vlan)
+	if (BNXT_VF(bp) && !bp->vf.vlan && !bnxt_is_trusted_vf(bp, &bp->vf))
 		return false;
 #endif
 	return true;
@@ -8441,7 +8441,7 @@ static int bnxt_init_chip(struct bnxt *bp, bool irq_re_init)
 	if (bp->dev->flags & IFF_BROADCAST)
 		vnic->rx_mask |= CFA_L2_SET_RX_MASK_REQ_MASK_BCAST;
 
-	if ((bp->dev->flags & IFF_PROMISC) && bnxt_promisc_ok(bp))
+	if (bp->dev->flags & IFF_PROMISC)
 		vnic->rx_mask |= CFA_L2_SET_RX_MASK_REQ_MASK_PROMISCUOUS;
 
 	if (bp->dev->flags & IFF_ALLMULTI) {
@@ -10485,7 +10485,7 @@ static void bnxt_set_rx_mode(struct net_device *dev)
 		  CFA_L2_SET_RX_MASK_REQ_MASK_ALL_MCAST |
 		  CFA_L2_SET_RX_MASK_REQ_MASK_BCAST);
 
-	if ((dev->flags & IFF_PROMISC) && bnxt_promisc_ok(bp))
+	if (dev->flags & IFF_PROMISC)
 		mask |= CFA_L2_SET_RX_MASK_REQ_MASK_PROMISCUOUS;
 
 	uc_update = bnxt_uc_list_updated(bp);
@@ -10561,6 +10561,9 @@ static int bnxt_cfg_rx_mode(struct bnxt *bp)
 	}
 
 skip_uc:
+	if ((vnic->rx_mask & CFA_L2_SET_RX_MASK_REQ_MASK_PROMISCUOUS) &&
+	    !bnxt_promisc_ok(bp))
+		vnic->rx_mask &= ~CFA_L2_SET_RX_MASK_REQ_MASK_PROMISCUOUS;
 	rc = bnxt_hwrm_cfa_l2_set_rx_mask(bp, 0);
 	if (rc && vnic->mc_list_count) {
 		netdev_info(bp->dev, "Failed setting MC filters rc: %d, turning on ALL_MCAST mode\n",
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_sriov.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_sriov.c
index a217316228f4..4da52f812585 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_sriov.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_sriov.c
@@ -113,7 +113,7 @@ static int bnxt_hwrm_func_qcfg_flags(struct bnxt *bp, struct bnxt_vf_info *vf)
 	int rc;
 
 	bnxt_hwrm_cmd_hdr_init(bp, &req, HWRM_FUNC_QCFG, -1, -1);
-	req.fid = cpu_to_le16(vf->fw_fid);
+	req.fid = cpu_to_le16(BNXT_PF(bp) ? vf->fw_fid : 0xffff);
 	mutex_lock(&bp->hwrm_cmd_lock);
 	rc = _hwrm_send_message(bp, &req, sizeof(req), HWRM_CMD_TIMEOUT);
 	if (rc) {
@@ -125,9 +125,9 @@ static int bnxt_hwrm_func_qcfg_flags(struct bnxt *bp, struct bnxt_vf_info *vf)
 	return 0;
 }
 
-static bool bnxt_is_trusted_vf(struct bnxt *bp, struct bnxt_vf_info *vf)
+bool bnxt_is_trusted_vf(struct bnxt *bp, struct bnxt_vf_info *vf)
 {
-	if (!(bp->fw_cap & BNXT_FW_CAP_TRUSTED_VF))
+	if (BNXT_PF(bp) && !(bp->fw_cap & BNXT_FW_CAP_TRUSTED_VF))
 		return !!(vf->flags & BNXT_VF_TRUST);
 
 	bnxt_hwrm_func_qcfg_flags(bp, vf);
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_sriov.h b/drivers/net/ethernet/broadcom/bnxt/bnxt_sriov.h
index 629641bf6fc5..995535e4c11b 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_sriov.h
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_sriov.h
@@ -34,6 +34,7 @@ int bnxt_set_vf_vlan(struct net_device *, int, u16, u8, __be16);
 int bnxt_set_vf_bw(struct net_device *, int, int, int);
 int bnxt_set_vf_link_state(struct net_device *, int, int);
 int bnxt_set_vf_spoofchk(struct net_device *, int, bool);
+bool bnxt_is_trusted_vf(struct bnxt *bp, struct bnxt_vf_info *vf);
 int bnxt_set_vf_trust(struct net_device *dev, int vf_id, bool trust);
 int bnxt_sriov_configure(struct pci_dev *pdev, int num_vfs);
 int bnxt_cfg_hw_sriov(struct bnxt *bp, int *num_vfs, bool reset);
-- 
2.18.1


--00000000000054001805c0bd90f1
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
xV4Em+0wQoEIR2kPG6yiZNtUK0tNCaZejYU/Mf/bzdKSwud3pLgHV8ls83y2OU/ha9xgJMLpRswv
xucFCxMsPmk0yoVmpbr92kIpLm+TomNZsL++LcDRa2ECAwEAAaOCAdowggHWMA4GA1UdDwEB/wQE
AwIFoDCBowYIKwYBBQUHAQEEgZYwgZMwTgYIKwYBBQUHMAKGQmh0dHA6Ly9zZWN1cmUuZ2xvYmFs
c2lnbi5jb20vY2FjZXJ0L2dzZ2NjcjNwZXJzb25hbHNpZ24yY2EyMDIwLmNydDBBBggrBgEFBQcw
AYY1aHR0cDovL29jc3AuZ2xvYmFsc2lnbi5jb20vZ3NnY2NyM3BlcnNvbmFsc2lnbjJjYTIwMjAw
TQYDVR0gBEYwRDBCBgorBgEEAaAyASgKMDQwMgYIKwYBBQUHAgEWJmh0dHBzOi8vd3d3Lmdsb2Jh
bHNpZ24uY29tL3JlcG9zaXRvcnkvMAkGA1UdEwQCMAAwSQYDVR0fBEIwQDA+oDygOoY4aHR0cDov
L2NybC5nbG9iYWxzaWduLmNvbS9nc2djY3IzcGVyc29uYWxzaWduMmNhMjAyMC5jcmwwJAYDVR0R
BB0wG4EZbWljaGFlbC5jaGFuQGJyb2FkY29tLmNvbTATBgNVHSUEDDAKBggrBgEFBQcDBDAfBgNV
HSMEGDAWgBSWM9HmWBdbNHWKgVZk1b5I3qGPzzAdBgNVHQ4EFgQUz2bMvqtXpXM0u3vAvRkalz60
CjswDQYJKoZIhvcNAQELBQADggEBAGUgeqqI/q2pkETeLr6oS7nnm1bkeNmtnJ2bnybNO/RdrbPj
DHVSiDCCrWr6xrc+q6OiZDKm0Ieq6BN+Wfr8h5mCkZMUdJikI85WcQTRk6EEF2lzIiaULmFD7U15
FSWQptLx+kiu63idTII4r3k/7+dJ5AhLRr4WCoXEme2GZkfSbYC3fEL46tb1w7w+25OEFCv1MtDZ
1CHkODrS2JGwDQxXKmyF64MhJiOutWHmqoGmLJVz1jnDvClsYtgT4zcNtoqKtjpWDYAefncWDPIQ
DauX1eWVM+KepL7zoSNzVbTipc65WuZFLR8ngOwkpknqvS9n/nKd885m23oIocC+GA4xggJtMIIC
aQIBATBrMFsxCzAJBgNVBAYTAkJFMRkwFwYDVQQKExBHbG9iYWxTaWduIG52LXNhMTEwLwYDVQQD
EyhHbG9iYWxTaWduIEdDQyBSMyBQZXJzb25hbFNpZ24gMiBDQSAyMDIwAgwQeU+Y6hbenPzRMJsw
DQYJYIZIAWUDBAIBBQCggdQwLwYJKoZIhvcNAQkEMSIEIMkPTcc531b6crTW58z8Mz6jO8sQr5wd
yafMt87tZyzoMBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTIxMDQy
NDIwMTQ0NlowaQYJKoZIhvcNAQkPMVwwWjALBglghkgBZQMEASowCwYJYIZIAWUDBAEWMAsGCWCG
SAFlAwQBAjAKBggqhkiG9w0DBzALBgkqhkiG9w0BAQowCwYJKoZIhvcNAQEHMAsGCWCGSAFlAwQC
ATANBgkqhkiG9w0BAQEFAASCAQB6YbqWNi9jC7Uk7mxtGMpx1iKa8Sb/8R0Mw7iVU77F1lr1QiVn
DbBFlNy1SKI1roFYM77akdGFduhhLbdzMeyWHCiQQlLZGUi0H0kexFqIMUR634H+plxeA3Y+ZGx0
V3ytd/iJI8VW46k2XzShCgRxW+sGZvGD77Xe2JtWAAqLty7ZnWtpBHlALWysq9xDNXupkN06cgMB
/VHPDdWJi9vL9ovQtCos6Jd6AKDEYhj/BJ/Y/NwIgSzwd+p2Ng6DlAxPyx2VJg8GWQPkMatRxW2V
mAuUM0tigpCw4yayeI7HMvnoXMtIoiSBBJJJ+ZOg/eC4dWjk1D84r3Yjq1y4liKx
--00000000000054001805c0bd90f1--
