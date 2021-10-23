Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F6A54384F0
	for <lists+netdev@lfdr.de>; Sat, 23 Oct 2021 21:32:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231416AbhJWTep (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 23 Oct 2021 15:34:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231393AbhJWTen (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 23 Oct 2021 15:34:43 -0400
Received: from mail-pg1-x533.google.com (mail-pg1-x533.google.com [IPv6:2607:f8b0:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E6A0C061714
        for <netdev@vger.kernel.org>; Sat, 23 Oct 2021 12:32:24 -0700 (PDT)
Received: by mail-pg1-x533.google.com with SMTP id c4so6614277pgv.11
        for <netdev@vger.kernel.org>; Sat, 23 Oct 2021 12:32:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=SSMXTxzFh3cN8A9drrO21tijdUE+h2S+FmVLy/J+JE8=;
        b=Osc5rDY/+q2Jf33nw90tTRJbZhwATq50k+ScN7wYmlDtk5nevqzGRM/Ur6RaSAUdgN
         zAd0rV8YDSa8KjUd84xM5TpQGie0lUhNUc/NDHm4nGjjrqzHNAxuEggOdIuY7/1zbRZ0
         3oeSj1jktdr01YU0SMi7GmEzNFgVy+JfOirho=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=SSMXTxzFh3cN8A9drrO21tijdUE+h2S+FmVLy/J+JE8=;
        b=tZl/qqm0VaKDl86sZiDr7FJKS6np2W2LeqYXzykMegVS3wJG5jNlfRcGxkstZmstG8
         HkzGpee810oCNHxCdglN1gXZAsZQBwEVtXhUouJdZJp4z/aEmyAFSbPvRdeCd3btCwzh
         XYxTzuOVtbpAsOxDpURxAcMCt6ewkeuXhWQnLkgK8tfuXePKMs0GKUt9XyOU2azx0n7h
         m/od/8OsP0gBP47iT7obFdZMGWUbbC0rUo+hzfflDvH/WvjEqsEtR8Vtyok5D+4wvzWx
         mazVVDEf6yDhEu6qGGsHQcBJgm1qkyoS+oLBuKLyessNCj9zjZe/RwiZ7J6U7CzzaSWg
         XPiw==
X-Gm-Message-State: AOAM532QWhOwaaKChJT6AbqFCdwb7NPl0NaOcFYR5CWBLt6EuGg1fCkK
        cI0Tu1ksTZsmXc7aUvWj5k5qRw==
X-Google-Smtp-Source: ABdhPJwkuMWPj88oi+1Ha4NBDBgPOGbK1qp22Xsu+pVtVxv9Xo+QRX4RBQ1v/H0u9slP1U026uapLA==
X-Received: by 2002:a63:f30c:: with SMTP id l12mr5867106pgh.360.1635017543423;
        Sat, 23 Oct 2021 12:32:23 -0700 (PDT)
Received: from localhost.swdvt.lab.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id f7sm2461532pfv.152.2021.10.23.12.32.22
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 23 Oct 2021 12:32:22 -0700 (PDT)
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, kuba@kernel.org, edwin.peer@broadcom.com,
        gospo@broadcom.com, jiri@nvidia.com
Subject: [PATCH net-next 04/19] bnxt_en: implement devlink dev reload fw_activate
Date:   Sat, 23 Oct 2021 15:31:51 -0400
Message-Id: <1635017526-16963-5-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1635017526-16963-1-git-send-email-michael.chan@broadcom.com>
References: <1635017526-16963-1-git-send-email-michael.chan@broadcom.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="000000000000e866a205cf0a2fd0"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--000000000000e866a205cf0a2fd0

From: Edwin Peer <edwin.peer@broadcom.com>

Similar to reload driver_reinit, the RTNL lock is held across reload
down and up to prevent interleaving state changes.  But we need to
subsequently release the RTNL lock while waiting for firmware reset
to complete.

Also keep a statistic on fw_activate resets initiated remotely from
other functions.

Signed-off-by: Edwin Peer <edwin.peer@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c     |  8 ++-
 drivers/net/ethernet/broadcom/bnxt/bnxt.h     |  7 +++
 .../net/ethernet/broadcom/bnxt/bnxt_devlink.c | 52 ++++++++++++++++++-
 .../net/ethernet/broadcom/bnxt/bnxt_devlink.h |  7 +++
 .../net/ethernet/broadcom/bnxt/bnxt_ethtool.c |  4 +-
 .../net/ethernet/broadcom/bnxt/bnxt_ethtool.h |  2 +
 6 files changed, 76 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index 35dcd5b8dc46..a674f39fd971 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -2134,7 +2134,9 @@ static int bnxt_async_event_process(struct bnxt *bp,
 		bp->fw_reset_max_dsecs = le16_to_cpu(cmpl->timestamp_hi);
 		if (!bp->fw_reset_max_dsecs)
 			bp->fw_reset_max_dsecs = BNXT_DFLT_FW_RST_MAX_DSECS;
-		if (EVENT_DATA1_RESET_NOTIFY_FATAL(data1)) {
+		if (EVENT_DATA1_RESET_NOTIFY_FW_ACTIVATION(data1)) {
+			set_bit(BNXT_STATE_FW_ACTIVATE_RESET, &bp->state);
+		} else if (EVENT_DATA1_RESET_NOTIFY_FATAL(data1)) {
 			fatal_str = "fatal";
 			set_bit(BNXT_STATE_FW_FATAL_COND, &bp->state);
 		}
@@ -12149,6 +12151,9 @@ static void bnxt_fw_reset_task(struct work_struct *work)
 			}
 		}
 		clear_bit(BNXT_STATE_FW_FATAL_COND, &bp->state);
+		if (test_and_clear_bit(BNXT_STATE_FW_ACTIVATE_RESET, &bp->state) &&
+		    !test_bit(BNXT_STATE_FW_ACTIVATE, &bp->state))
+			bnxt_dl_remote_reload(bp);
 		if (pci_enable_device(bp->pdev)) {
 			netdev_err(bp->dev, "Cannot re-enable PCI device\n");
 			rc = -ENODEV;
@@ -12200,6 +12205,7 @@ static void bnxt_fw_reset_task(struct work_struct *work)
 		bnxt_ptp_reapply_pps(bp);
 		bnxt_dl_health_recovery_done(bp);
 		bnxt_dl_health_status_update(bp, true);
+		clear_bit(BNXT_STATE_FW_ACTIVATE, &bp->state);
 		rtnl_unlock();
 		break;
 	}
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.h b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
index 4a9bdab90c28..38c23b4106a1 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.h
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
@@ -489,6 +489,11 @@ struct rx_tpa_end_cmp_ext {
 	  ASYNC_EVENT_CMPL_RESET_NOTIFY_EVENT_DATA1_REASON_CODE_MASK) ==\
 	 ASYNC_EVENT_CMPL_RESET_NOTIFY_EVENT_DATA1_REASON_CODE_FW_EXCEPTION_FATAL)
 
+#define EVENT_DATA1_RESET_NOTIFY_FW_ACTIVATION(data1)			\
+	(((data1) &							\
+	  ASYNC_EVENT_CMPL_RESET_NOTIFY_EVENT_DATA1_REASON_CODE_MASK) ==\
+	ASYNC_EVENT_CMPL_RESET_NOTIFY_EVENT_DATA1_REASON_CODE_FW_ACTIVATION)
+
 #define EVENT_DATA1_RECOVERY_MASTER_FUNC(data1)				\
 	!!((data1) &							\
 	   ASYNC_EVENT_CMPL_ERROR_RECOVERY_EVENT_DATA1_FLAGS_MASTER_FUNC)
@@ -1888,6 +1893,8 @@ struct bnxt {
 #define BNXT_STATE_DRV_REGISTERED	7
 #define BNXT_STATE_PCI_CHANNEL_IO_FROZEN	8
 #define BNXT_STATE_NAPI_DISABLED	9
+#define BNXT_STATE_FW_ACTIVATE		11
+#define BNXT_STATE_FW_ACTIVATE_RESET	14
 
 #define BNXT_NO_FW_ACCESS(bp)					\
 	(test_bit(BNXT_STATE_FW_FATAL_COND, &(bp)->state) ||	\
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c
index ca2e51d7de52..e9a98160acf9 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c
@@ -322,6 +322,26 @@ static int bnxt_dl_reload_down(struct devlink *dl, bool netns_change,
 		bp->ctx = NULL;
 		break;
 	}
+	case DEVLINK_RELOAD_ACTION_FW_ACTIVATE: {
+		if (~bp->fw_cap & BNXT_FW_CAP_HOT_RESET) {
+			NL_SET_ERR_MSG_MOD(extack, "Device not capable, requires reboot");
+			return -EOPNOTSUPP;
+		}
+		rtnl_lock();
+		if (netif_running(bp->dev))
+			set_bit(BNXT_STATE_FW_ACTIVATE, &bp->state);
+		rc = bnxt_hwrm_firmware_reset(bp->dev,
+					      FW_RESET_REQ_EMBEDDED_PROC_TYPE_CHIP,
+					      FW_RESET_REQ_SELFRST_STATUS_SELFRSTASAP,
+					      FW_RESET_REQ_FLAGS_RESET_GRACEFUL |
+					      FW_RESET_REQ_FLAGS_FW_ACTIVATION);
+		if (rc) {
+			NL_SET_ERR_MSG_MOD(extack, "Failed to activate firmware");
+			clear_bit(BNXT_STATE_FW_ACTIVATE, &bp->state);
+			rtnl_unlock();
+		}
+		break;
+	}
 	default:
 		rc = -EOPNOTSUPP;
 	}
@@ -350,6 +370,35 @@ static int bnxt_dl_reload_up(struct devlink *dl, enum devlink_reload_action acti
 		}
 		break;
 	}
+	case DEVLINK_RELOAD_ACTION_FW_ACTIVATE: {
+		unsigned long start = jiffies;
+		unsigned long timeout = start + BNXT_DFLT_FW_RST_MAX_DSECS * HZ / 10;
+
+		if (bp->fw_cap & BNXT_FW_CAP_ERROR_RECOVERY)
+			timeout = start + bp->fw_health->normal_func_wait_dsecs * HZ / 10;
+		if (!netif_running(bp->dev))
+			NL_SET_ERR_MSG_MOD(extack,
+					   "Device is closed, not waiting for reset notice that will never come");
+		rtnl_unlock();
+		while (test_bit(BNXT_STATE_FW_ACTIVATE, &bp->state)) {
+			if (time_after(jiffies, timeout)) {
+				NL_SET_ERR_MSG_MOD(extack, "Activation incomplete");
+				rc = -ETIMEDOUT;
+				break;
+			}
+			if (test_bit(BNXT_STATE_ABORT_ERR, &bp->state)) {
+				NL_SET_ERR_MSG_MOD(extack, "Activation aborted");
+				rc = -ENODEV;
+				break;
+			}
+			msleep(50);
+		}
+		rtnl_lock();
+		if (!rc)
+			*actions_performed |= BIT(DEVLINK_RELOAD_ACTION_DRIVER_REINIT);
+		clear_bit(BNXT_STATE_FW_ACTIVATE, &bp->state);
+		break;
+	}
 	default:
 		return -EOPNOTSUPP;
 	}
@@ -376,7 +425,8 @@ static const struct devlink_ops bnxt_dl_ops = {
 #endif /* CONFIG_BNXT_SRIOV */
 	.info_get	  = bnxt_dl_info_get,
 	.flash_update	  = bnxt_dl_flash_update,
-	.reload_actions	  = BIT(DEVLINK_RELOAD_ACTION_DRIVER_REINIT),
+	.reload_actions	  = BIT(DEVLINK_RELOAD_ACTION_DRIVER_REINIT) |
+			    BIT(DEVLINK_RELOAD_ACTION_FW_ACTIVATE),
 	.reload_down	  = bnxt_dl_reload_down,
 	.reload_up	  = bnxt_dl_reload_up,
 };
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.h b/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.h
index 406dc655a5fc..a189cfe1e441 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.h
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.h
@@ -20,6 +20,13 @@ static inline struct bnxt *bnxt_get_bp_from_dl(struct devlink *dl)
 	return ((struct bnxt_dl *)devlink_priv(dl))->bp;
 }
 
+static inline void bnxt_dl_remote_reload(struct bnxt *bp)
+{
+	devlink_remote_reload_actions_performed(bp->dl, 0,
+						BIT(DEVLINK_RELOAD_ACTION_DRIVER_REINIT) |
+						BIT(DEVLINK_RELOAD_ACTION_FW_ACTIVATE));
+}
+
 #define NVM_OFF_MSIX_VEC_PER_PF_MAX	108
 #define NVM_OFF_MSIX_VEC_PER_PF_MIN	114
 #define NVM_OFF_IGNORE_ARI		164
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
index fbb56b1f70fd..ac8df5c6906f 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
@@ -2180,8 +2180,8 @@ static int bnxt_flash_nvram(struct net_device *dev, u16 dir_type,
 	return rc;
 }
 
-static int bnxt_hwrm_firmware_reset(struct net_device *dev, u8 proc_type,
-				    u8 self_reset, u8 flags)
+int bnxt_hwrm_firmware_reset(struct net_device *dev, u8 proc_type,
+			     u8 self_reset, u8 flags)
 {
 	struct bnxt *bp = netdev_priv(dev);
 	struct hwrm_fw_reset_input *req;
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.h b/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.h
index 0a57cb6a4a4b..bbf184c63b0a 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.h
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.h
@@ -94,6 +94,8 @@ u32 bnxt_fw_to_ethtool_speed(u16);
 u16 bnxt_get_fw_auto_link_speeds(u32);
 int bnxt_hwrm_nvm_get_dev_info(struct bnxt *bp,
 			       struct hwrm_nvm_get_dev_info_output *nvm_dev_info);
+int bnxt_hwrm_firmware_reset(struct net_device *dev, u8 proc_type,
+			     u8 self_reset, u8 flags);
 int bnxt_flash_package_from_fw_obj(struct net_device *dev, const struct firmware *fw,
 				   u32 install_type);
 void bnxt_ethtool_init(struct bnxt *bp);
-- 
2.18.1


--000000000000e866a205cf0a2fd0
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
DQYJYIZIAWUDBAIBBQCggdQwLwYJKoZIhvcNAQkEMSIEIFigxBc8D4DJw0if3pzUJZSAipwQJtvE
/hI6/DZzwRgCMBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTIxMTAy
MzE5MzIyM1owaQYJKoZIhvcNAQkPMVwwWjALBglghkgBZQMEASowCwYJYIZIAWUDBAEWMAsGCWCG
SAFlAwQBAjAKBggqhkiG9w0DBzALBgkqhkiG9w0BAQowCwYJKoZIhvcNAQEHMAsGCWCGSAFlAwQC
ATANBgkqhkiG9w0BAQEFAASCAQBR9gYQH8W4XiNsggh00HoDoEbyXHGY4/R9LwuJIi0XvOT16nLu
73shYEoe3Jn502Qw8w2YwkCBT1RMOXboNxmtGLWukJEUSz3H+EVcWZqd0BiAuipK/7sKZqiICZOH
L1Zk9ytUzbUjkgqCHB7z4Uiz/DSOKRUAfB3qe08RXrMhKU/jTIcXjjFqxglQSV1mL/CcO8etJFC3
LLyjrYfR2ctsMZd+dmGJNo9MtPtJ2wBPuVlA6g6vHoEPaSlf6SsavJRFBpphNF9l4nLJZ8wsgKIQ
VtqHc3aUaBFftcCixL3ayFHfjZdcGqgENyZGZvQHV9W0IF9cNXwIeZpHLshOPk73
--000000000000e866a205cf0a2fd0--
