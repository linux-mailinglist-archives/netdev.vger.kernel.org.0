Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A57C343F806
	for <lists+netdev@lfdr.de>; Fri, 29 Oct 2021 09:48:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232301AbhJ2Huw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Oct 2021 03:50:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232269AbhJ2Huq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Oct 2021 03:50:46 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07767C061714
        for <netdev@vger.kernel.org>; Fri, 29 Oct 2021 00:48:18 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id oa12-20020a17090b1bcc00b0019f715462a8so6798993pjb.3
        for <netdev@vger.kernel.org>; Fri, 29 Oct 2021 00:48:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=bbQX5WVPVIqufnUmGiuLnApH/9E7ggRXV4bZEahByZs=;
        b=dwWwLkjNd0MJfzSh4ljVLeVonzzW3hfjgGTVZNeO1MkZqCm8WwAS8lxk5hLhDbWeOb
         ifCZ8uuylADoFMXtwWSmE8Wm4FQcN742WcWUNvw4y8JGaOet2dcsA1YQKsYzkmZ0kZAJ
         DUmhzMJUlBy1Sl7j6Td3O4Ymw73PvwMgAvsLs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=bbQX5WVPVIqufnUmGiuLnApH/9E7ggRXV4bZEahByZs=;
        b=6X4LXW75XALT+eRmnzhKkskOhjUZUbZTTbUi+8IoNNfWJuF8rK2MauzsgEWiF9vt++
         imhNCKiv4euNJzUwJ48lHZ/B7oosi4eaOCY4ODhyyV/SRWGRyl0jP2voLtce5i241FsU
         kwtmC11hhDu4Xhtft964QKJqcSH0unqUEhuWbsjz5w7Nj27LlZzht6f0kNtuUUIBFXJA
         KW1eVe1i1Kkbi0Fe02GC79poMaiqKQf0CfS3yXZHUyVotvIE/8oZYWHq64OA34O26SpE
         A2As6gwF0V1+SCTNbsi1hq/3cYnItLSJ/ygy0EfJcbCEM6j17ZvkhOvnNRhR07pdQtXq
         WZdQ==
X-Gm-Message-State: AOAM533hH6OLxCy4239rLyKCWab4h7XgDvuxtYE5acvAHuo/HCx3EvBU
        lD5gYHjHGuahkLeg/pl7m4lWzw==
X-Google-Smtp-Source: ABdhPJxjljN4kqLTzhN31wQQeFJlsM5jv94D3Kpyj3b4meeXGPYXZOASzFSro4HJh3K7EMWddVHynw==
X-Received: by 2002:a17:90b:388f:: with SMTP id mu15mr9827055pjb.28.1635493697183;
        Fri, 29 Oct 2021 00:48:17 -0700 (PDT)
Received: from localhost.swdvt.lab.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id s18sm5721186pfc.87.2021.10.29.00.48.16
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 29 Oct 2021 00:48:16 -0700 (PDT)
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, kuba@kernel.org, edwin.peer@broadcom.com,
        gospo@broadcom.com, jiri@nvidia.com
Subject: [PATCH net-next v2 04/19] bnxt_en: implement devlink dev reload fw_activate
Date:   Fri, 29 Oct 2021 03:47:41 -0400
Message-Id: <1635493676-10767-5-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1635493676-10767-1-git-send-email-michael.chan@broadcom.com>
References: <1635493676-10767-1-git-send-email-michael.chan@broadcom.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="000000000000e3daca05cf790c2a"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--000000000000e3daca05cf790c2a

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
 .../net/ethernet/broadcom/bnxt/bnxt_devlink.c | 56 ++++++++++++++++++-
 .../net/ethernet/broadcom/bnxt/bnxt_devlink.h |  7 +++
 .../net/ethernet/broadcom/bnxt/bnxt_ethtool.c |  4 +-
 .../net/ethernet/broadcom/bnxt/bnxt_ethtool.h |  2 +
 6 files changed, 80 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index 24a17ce35703..cd5932c75997 100644
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
index d875469f72ce..9922c1428129 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c
@@ -327,6 +327,30 @@ static int bnxt_dl_reload_down(struct devlink *dl, bool netns_change,
 		bp->ctx = NULL;
 		break;
 	}
+	case DEVLINK_RELOAD_ACTION_FW_ACTIVATE: {
+		if (~bp->fw_cap & BNXT_FW_CAP_HOT_RESET) {
+			NL_SET_ERR_MSG_MOD(extack, "Device not capable, requires reboot");
+			return -EOPNOTSUPP;
+		}
+		rtnl_lock();
+		if (bp->dev->reg_state == NETREG_UNREGISTERED) {
+			rtnl_unlock();
+			return -ENODEV;
+		}
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
@@ -355,6 +379,35 @@ static int bnxt_dl_reload_up(struct devlink *dl, enum devlink_reload_action acti
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
@@ -381,7 +434,8 @@ static const struct devlink_ops bnxt_dl_ops = {
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


--000000000000e3daca05cf790c2a
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
DQYJYIZIAWUDBAIBBQCggdQwLwYJKoZIhvcNAQkEMSIEICUtJL/PpWvdvsCQkcQ0XeBgfBAgemmi
xSuD2yPvmyw7MBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTIxMTAy
OTA3NDgxN1owaQYJKoZIhvcNAQkPMVwwWjALBglghkgBZQMEASowCwYJYIZIAWUDBAEWMAsGCWCG
SAFlAwQBAjAKBggqhkiG9w0DBzALBgkqhkiG9w0BAQowCwYJKoZIhvcNAQEHMAsGCWCGSAFlAwQC
ATANBgkqhkiG9w0BAQEFAASCAQAW31NGbvff6CgqDIFBO5ZCn6thmKXJAV0s9WZqLIi83CMkNSIG
BSEmycP30+aLXo0UBXw6azx5uDcS8Bj3M/u+8eKP8viBU+bZQADqP3ysuqH2s7SQ4LpPQyBs6vRS
rPgmobNEGzsnDZFY/Wuy9H9RLtxgJnwNLszK/89xnHlgJR73ZpS0oAl6c3OCXuGiF6MVcfvm/1mD
jb+GmaI2ZkY0bCIl2IACf18+vELkM0Fh0gCbkD0+e5WNGlN811wG9jRvWOTqtRUZoUeHcbJB64F7
0o5RmwE8hICfp5FIYbxjukwt68M10Rt6HqjvYNu40apM2ddq3yStQGdgV28spnUj
--000000000000e3daca05cf790c2a--
