Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 974CB4384EF
	for <lists+netdev@lfdr.de>; Sat, 23 Oct 2021 21:32:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231408AbhJWTen (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 23 Oct 2021 15:34:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231393AbhJWTem (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 23 Oct 2021 15:34:42 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03C01C061714
        for <netdev@vger.kernel.org>; Sat, 23 Oct 2021 12:32:23 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id o4-20020a17090a3d4400b001a1c8344c3fso6123209pjf.3
        for <netdev@vger.kernel.org>; Sat, 23 Oct 2021 12:32:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=11TRWnAsJa8PWfOsOCxz2pj6yOn8sa2ITLATZxLiE78=;
        b=B4MlKCFafJZg67LRKKqVUTZqJDB5fcjFB4f49oPc6Tzv/x34+FM8e4TYZtrjDUtfX/
         HN1crgZX9zx2dTSGIiRoscaDWW2lff7ADOERPR2dALSMZ+dXmF8s2tK6fwHs37/TBeDe
         Nid8tENY781d644piQfYDCAa02/o0YZi+nuBQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=11TRWnAsJa8PWfOsOCxz2pj6yOn8sa2ITLATZxLiE78=;
        b=sYh5b7OM7eI6bsVFbUo7SGyqU4GQcx81KWKSJVGEEuuY2/vUF5ZbdqsCWGJQOtHKS1
         yj5kxKpt83Y4r2NBV+oZGQDSSE5uRuHyjlcUcK6FsiRrY6xSqQCmMHNbKDC7PLJbDBOl
         GjiltyQUIepPgiIwW7ZEHycXIlVYi2st6jxND9zx7d6ju6rHD5m/E2HkBC0yfRkC7A6O
         qGbUaTgZyzUCZFg0iWJ7dYxkeqw67OBG+KN0cvDiHpbsE3Mp/p0JoIJlLw8E6XvR/y90
         P0FY9+Iym6EKN/EQKVtaQjkC6l9t7LWt3NR8oYvz8wdPx9B+UOoL+9Gv8ueNi2jmUlNK
         puzg==
X-Gm-Message-State: AOAM532QDkNSsbhmFeesJKqF3Lw3owAlCtiX7qyqpRE5EVSQ7wJ/s4iT
        ennAI43AVxTSpVWT7d0mQ7GU0w==
X-Google-Smtp-Source: ABdhPJzIUVHAcssFk/OnOvbOrHFiQLqNfhDBxmq93azXFvpYWtsgbHpaG/WgNxOv3LNUnPTBt1tYug==
X-Received: by 2002:a17:90b:98:: with SMTP id bb24mr8818509pjb.194.1635017542131;
        Sat, 23 Oct 2021 12:32:22 -0700 (PDT)
Received: from localhost.swdvt.lab.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id f7sm2461532pfv.152.2021.10.23.12.32.20
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 23 Oct 2021 12:32:21 -0700 (PDT)
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, kuba@kernel.org, edwin.peer@broadcom.com,
        gospo@broadcom.com, jiri@nvidia.com
Subject: [PATCH net-next 03/19] bnxt_en: implement devlink dev reload driver_reinit
Date:   Sat, 23 Oct 2021 15:31:50 -0400
Message-Id: <1635017526-16963-4-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1635017526-16963-1-git-send-email-michael.chan@broadcom.com>
References: <1635017526-16963-1-git-send-email-michael.chan@broadcom.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="000000000000d6c6c205cf0a2fce"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--000000000000d6c6c205cf0a2fce

From: Edwin Peer <edwin.peer@broadcom.com>

The RTNL lock must be held between down and up to prevent interleaving
state changes, especially since external state changes might release
and allocate different driver resource subsets that would otherwise
need to be tracked and carefully handled. If the down function fails,
then devlink will not call the corresponding up function, thus the
lock is released in the down error paths.

Signed-off-by: Edwin Peer <edwin.peer@broadcom.com>
Signed-Off-by: Michael Chan <michael.chan@broadcom.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c     | 16 ++--
 drivers/net/ethernet/broadcom/bnxt/bnxt.h     |  5 +
 .../net/ethernet/broadcom/bnxt/bnxt_devlink.c | 92 +++++++++++++++++++
 drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.c |  2 -
 drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.h |  3 +
 5 files changed, 107 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index 8471e47d0480..35dcd5b8dc46 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -49,8 +49,6 @@
 #include <linux/log2.h>
 #include <linux/aer.h>
 #include <linux/bitmap.h>
-#include <linux/ptp_clock_kernel.h>
-#include <linux/timecounter.h>
 #include <linux/cpu_rmap.h>
 #include <linux/cpumask.h>
 #include <net/pkt_cls.h>
@@ -4603,7 +4601,7 @@ int bnxt_hwrm_func_drv_rgtr(struct bnxt *bp, unsigned long *bmap, int bmap_size,
 	return rc;
 }
 
-static int bnxt_hwrm_func_drv_unrgtr(struct bnxt *bp)
+int bnxt_hwrm_func_drv_unrgtr(struct bnxt *bp)
 {
 	struct hwrm_func_drv_unrgtr_input *req;
 	int rc;
@@ -7144,7 +7142,7 @@ static void bnxt_free_ctx_pg_tbls(struct bnxt *bp,
 	ctx_pg->nr_pages = 0;
 }
 
-static void bnxt_free_ctx_mem(struct bnxt *bp)
+void bnxt_free_ctx_mem(struct bnxt *bp)
 {
 	struct bnxt_ctx_mem_info *ctx = bp->ctx;
 	int i;
@@ -9198,7 +9196,7 @@ static char *bnxt_report_fec(struct bnxt_link_info *link_info)
 	}
 }
 
-static void bnxt_report_link(struct bnxt *bp)
+void bnxt_report_link(struct bnxt *bp)
 {
 	if (bp->link_info.link_up) {
 		const char *signal = "";
@@ -9643,8 +9641,6 @@ static int bnxt_hwrm_shutdown_link(struct bnxt *bp)
 	return hwrm_req_send(bp, req);
 }
 
-static int bnxt_fw_init_one(struct bnxt *bp);
-
 static int bnxt_fw_reset_via_optee(struct bnxt *bp)
 {
 #ifdef CONFIG_TEE_BNXT_FW
@@ -10279,7 +10275,7 @@ void bnxt_half_close_nic(struct bnxt *bp)
 	bnxt_free_mem(bp, false);
 }
 
-static void bnxt_reenable_sriov(struct bnxt *bp)
+void bnxt_reenable_sriov(struct bnxt *bp)
 {
 	if (BNXT_PF(bp)) {
 		struct bnxt_pf_info *pf = &bp->pf;
@@ -11950,7 +11946,7 @@ static void bnxt_fw_init_one_p3(struct bnxt *bp)
 
 static int bnxt_probe_phy(struct bnxt *bp, bool fw_dflt);
 
-static int bnxt_fw_init_one(struct bnxt *bp)
+int bnxt_fw_init_one(struct bnxt *bp)
 {
 	int rc;
 
@@ -12763,6 +12759,7 @@ static void bnxt_remove_one(struct pci_dev *pdev)
 	struct net_device *dev = pci_get_drvdata(pdev);
 	struct bnxt *bp = netdev_priv(dev);
 
+	devlink_reload_disable(bp->dl);
 	if (BNXT_PF(bp))
 		bnxt_sriov_disable(bp);
 
@@ -13356,6 +13353,7 @@ static int bnxt_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 	bnxt_print_device_info(bp);
 
 	pci_save_state(pdev);
+	devlink_reload_enable(bp->dl);
 	return 0;
 
 init_err_cleanup:
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.h b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
index 5ca4f19936c3..4a9bdab90c28 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.h
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
@@ -2230,11 +2230,13 @@ void bnxt_set_ring_params(struct bnxt *);
 int bnxt_set_rx_skb_mode(struct bnxt *bp, bool page_mode);
 int bnxt_hwrm_func_drv_rgtr(struct bnxt *bp, unsigned long *bmap,
 			    int bmap_size, bool async_only);
+int bnxt_hwrm_func_drv_unrgtr(struct bnxt *bp);
 int bnxt_get_nr_rss_ctxs(struct bnxt *bp, int rx_rings);
 int bnxt_hwrm_vnic_cfg(struct bnxt *bp, u16 vnic_id);
 int __bnxt_hwrm_get_tx_rings(struct bnxt *bp, u16 fid, int *tx_rings);
 int bnxt_nq_rings_in_use(struct bnxt *bp);
 int bnxt_hwrm_set_coal(struct bnxt *);
+void bnxt_free_ctx_mem(struct bnxt *bp);
 unsigned int bnxt_get_max_func_stat_ctxs(struct bnxt *bp);
 unsigned int bnxt_get_avail_stat_ctxs_for_en(struct bnxt *bp);
 unsigned int bnxt_get_max_func_cp_rings(struct bnxt *bp);
@@ -2243,6 +2245,7 @@ int bnxt_get_avail_msix(struct bnxt *bp, int num);
 int bnxt_reserve_rings(struct bnxt *bp, bool irq_re_init);
 void bnxt_tx_disable(struct bnxt *bp);
 void bnxt_tx_enable(struct bnxt *bp);
+void bnxt_report_link(struct bnxt *bp);
 int bnxt_update_link(struct bnxt *bp, bool chng_link_state);
 int bnxt_hwrm_set_pause(struct bnxt *);
 int bnxt_hwrm_set_link_setting(struct bnxt *, bool, bool);
@@ -2255,6 +2258,7 @@ int bnxt_hwrm_fw_set_time(struct bnxt *);
 int bnxt_open_nic(struct bnxt *, bool, bool);
 int bnxt_half_open_nic(struct bnxt *bp);
 void bnxt_half_close_nic(struct bnxt *bp);
+void bnxt_reenable_sriov(struct bnxt *bp);
 int bnxt_close_nic(struct bnxt *, bool, bool);
 int bnxt_dbg_hwrm_rd_reg(struct bnxt *bp, u32 reg_off, u16 num_words,
 			 u32 *reg_buf);
@@ -2262,6 +2266,7 @@ void bnxt_fw_exception(struct bnxt *bp);
 void bnxt_fw_reset(struct bnxt *bp);
 int bnxt_check_rings(struct bnxt *bp, int tx, int rx, bool sh, int tcs,
 		     int tx_xdp);
+int bnxt_fw_init_one(struct bnxt *bp);
 int bnxt_setup_mq_tc(struct net_device *dev, u8 tc);
 int bnxt_get_max_rings(struct bnxt *, int *, int *, bool);
 int bnxt_restore_pf_fw_resources(struct bnxt *bp);
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c
index 951c0c00cc95..ca2e51d7de52 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c
@@ -16,6 +16,8 @@
 #include "bnxt_vfr.h"
 #include "bnxt_devlink.h"
 #include "bnxt_ethtool.h"
+#include "bnxt_ulp.h"
+#include "bnxt_ptp.h"
 
 static int
 bnxt_dl_flash_update(struct devlink *dl,
@@ -280,6 +282,93 @@ void bnxt_dl_health_recovery_done(struct bnxt *bp)
 static int bnxt_dl_info_get(struct devlink *dl, struct devlink_info_req *req,
 			    struct netlink_ext_ack *extack);
 
+static int bnxt_dl_reload_down(struct devlink *dl, bool netns_change,
+			       enum devlink_reload_action action,
+			       enum devlink_reload_limit limit,
+			       struct netlink_ext_ack *extack)
+{
+	struct bnxt *bp = bnxt_get_bp_from_dl(dl);
+	int rc = 0;
+
+	switch (action) {
+	case DEVLINK_RELOAD_ACTION_DRIVER_REINIT: {
+		if (BNXT_PF(bp) && bp->pf.active_vfs) {
+			NL_SET_ERR_MSG_MOD(extack, "reload is unsupported when VFs are allocated\n");
+			return -EOPNOTSUPP;
+		}
+		rtnl_lock();
+		bnxt_ulp_stop(bp);
+		if (netif_running(bp->dev)) {
+			rc = bnxt_close_nic(bp, true, true);
+			if (rc) {
+				NL_SET_ERR_MSG_MOD(extack, "Failed to close");
+				dev_close(bp->dev);
+				rtnl_unlock();
+				break;
+			}
+		}
+		bnxt_vf_reps_free(bp);
+		rc = bnxt_hwrm_func_drv_unrgtr(bp);
+		if (rc) {
+			NL_SET_ERR_MSG_MOD(extack, "Failed to deregister");
+			if (netif_running(bp->dev))
+				dev_close(bp->dev);
+			rtnl_unlock();
+			break;
+		}
+		bnxt_cancel_reservations(bp, false);
+		bnxt_free_ctx_mem(bp);
+		kfree(bp->ctx);
+		bp->ctx = NULL;
+		break;
+	}
+	default:
+		rc = -EOPNOTSUPP;
+	}
+
+	return rc;
+}
+
+static int bnxt_dl_reload_up(struct devlink *dl, enum devlink_reload_action action,
+			     enum devlink_reload_limit limit, u32 *actions_performed,
+			     struct netlink_ext_ack *extack)
+{
+	struct bnxt *bp = bnxt_get_bp_from_dl(dl);
+	int rc = 0;
+
+	*actions_performed = 0;
+	switch (action) {
+	case DEVLINK_RELOAD_ACTION_DRIVER_REINIT: {
+		bnxt_fw_init_one(bp);
+		bnxt_vf_reps_alloc(bp);
+		if (netif_running(bp->dev))
+			rc = bnxt_open_nic(bp, true, true);
+		bnxt_ulp_start(bp, rc);
+		if (!rc) {
+			bnxt_reenable_sriov(bp);
+			bnxt_ptp_reapply_pps(bp);
+		}
+		break;
+	}
+	default:
+		return -EOPNOTSUPP;
+	}
+
+	if (!rc) {
+		bnxt_print_device_info(bp);
+		if (netif_running(bp->dev)) {
+			mutex_lock(&bp->link_lock);
+			bnxt_report_link(bp);
+			mutex_unlock(&bp->link_lock);
+		}
+		*actions_performed |= BIT(action);
+	} else if (netif_running(bp->dev)) {
+		dev_close(bp->dev);
+	}
+	rtnl_unlock();
+	return rc;
+}
+
 static const struct devlink_ops bnxt_dl_ops = {
 #ifdef CONFIG_BNXT_SRIOV
 	.eswitch_mode_set = bnxt_dl_eswitch_mode_set,
@@ -287,6 +376,9 @@ static const struct devlink_ops bnxt_dl_ops = {
 #endif /* CONFIG_BNXT_SRIOV */
 	.info_get	  = bnxt_dl_info_get,
 	.flash_update	  = bnxt_dl_flash_update,
+	.reload_actions	  = BIT(DEVLINK_RELOAD_ACTION_DRIVER_REINIT),
+	.reload_down	  = bnxt_dl_reload_down,
+	.reload_up	  = bnxt_dl_reload_up,
 };
 
 static const struct devlink_ops bnxt_vf_dl_ops;
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.c
index f0aa480799ca..8388be119f9a 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.c
@@ -11,9 +11,7 @@
 #include <linux/pci.h>
 #include <linux/netdevice.h>
 #include <linux/etherdevice.h>
-#include <linux/ptp_clock_kernel.h>
 #include <linux/net_tstamp.h>
-#include <linux/timecounter.h>
 #include <linux/timekeeping.h>
 #include <linux/ptp_classify.h>
 #include "bnxt_hsi.h"
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.h b/drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.h
index fa5f05708e6d..7c528e1f8713 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.h
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.h
@@ -10,6 +10,9 @@
 #ifndef BNXT_PTP_H
 #define BNXT_PTP_H
 
+#include <linux/ptp_clock_kernel.h>
+#include <linux/timecounter.h>
+
 #define BNXT_PTP_GRC_WIN	6
 #define BNXT_PTP_GRC_WIN_BASE	0x6000
 
-- 
2.18.1


--000000000000d6c6c205cf0a2fce
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
DQYJYIZIAWUDBAIBBQCggdQwLwYJKoZIhvcNAQkEMSIEIHTU9despDtJN7R1OhizoiqtN40cYjpT
GhoKrd+/hJlsMBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTIxMTAy
MzE5MzIyMlowaQYJKoZIhvcNAQkPMVwwWjALBglghkgBZQMEASowCwYJYIZIAWUDBAEWMAsGCWCG
SAFlAwQBAjAKBggqhkiG9w0DBzALBgkqhkiG9w0BAQowCwYJKoZIhvcNAQEHMAsGCWCGSAFlAwQC
ATANBgkqhkiG9w0BAQEFAASCAQC3bHOqCzYKm9Sho57hmMf424zm/BNkG/17ydpbE5cBGcQVs1/b
7yyGSfN3aYvWELNyupFL5FkA6uc/Zl1zoG91QmvYZ6iskc6Q/cLd5qpioZ4yiQPCOkDoX4Eiy/Lk
m2bHgiUYz5nGRRZ8hOwLJDjIpIf7WBHjmUUz+1nb4u/2vEjaVd9+S6DJ4XCnpQ3MSJ4MkyrxrWPR
QbS2bo0XbgIkPWwYGxGUtgVR6jztnS3qb5q+btzJ06yppcGUkVBJUZ1xaZ+rzbo4HwOxIZ2WDWBW
QdvFOIdpr9+vXaLa0/L6TJgudxnZ22Oz4wOfwdyT/BICAapv0ZQizqoYg9ump3kI
--000000000000d6c6c205cf0a2fce--
