Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D0A62488D66
	for <lists+netdev@lfdr.de>; Mon, 10 Jan 2022 00:55:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235838AbiAIXzH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 9 Jan 2022 18:55:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235783AbiAIXzG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 9 Jan 2022 18:55:06 -0500
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5612CC061748
        for <netdev@vger.kernel.org>; Sun,  9 Jan 2022 15:55:06 -0800 (PST)
Received: by mail-pl1-x62c.google.com with SMTP id t18so1015069plg.9
        for <netdev@vger.kernel.org>; Sun, 09 Jan 2022 15:55:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=z54LVtJfnfER+Ao1qWQPEyz+M3URq4xmCOBuZ/F6LtQ=;
        b=btStm0kVG90dmS84LFHa+DgEBk1DwnJUgAiudRzbFTZ+oIgo4Q8YypuL+WSXY6pu0R
         9sTIV9uv1iMRzPW3pWDmeqj0YVsrStbJMcAia8Ar1rKRAA7LWi3AxrjM0wX0NBGgFne1
         vJOHzZ9O7033vrq42IYfNXinpSIsBNCaCgkO0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=z54LVtJfnfER+Ao1qWQPEyz+M3URq4xmCOBuZ/F6LtQ=;
        b=qOTVGoFpvH7sKWy9DVw2/L0Oc5GDh2WCLYUqCUJrTZtdJL7FD88GKXks4q3C/EPgm4
         8FrCJKpYo131TOJ7/rjol+7ssZQzzAiWxn5G2hPV96vcHQgNLBa45G4g8TAgrjai+Ds8
         6licMoN00fEubrgNAUmG0Y4W/MGnmEUfYy4n0oeEpiDWbH/Xo01F4dFFjj9i/EklJVfP
         nLwGD+Q1PJTWJfe/dgcskXL41Y0W9sCpKi6d7kB4g+PuIyBbEsqu7+peuCoS77MOeeS0
         97rpnlRdkY6XzV+i1ZmcCEYmfF3cbaScMolo0mNyr6p8fCZU7hpceWR87Q3o7Eka8lDc
         Xp/g==
X-Gm-Message-State: AOAM532Lc3GDGoJWLfv+1EWLRegSmVDFx558RPZ/TplgU7kIQgpppbl9
        ORp4myFcMi+DMids3vAxQAL+vg==
X-Google-Smtp-Source: ABdhPJwnzARI/Q9U2iXzxpxdGZZZNYknjBscbDO0DaznmQkFtpJaYPvd2MSEwrhuycrKeyQ7bc5LXQ==
X-Received: by 2002:a17:902:8345:b0:14a:1a98:4288 with SMTP id z5-20020a170902834500b0014a1a984288mr7349884pln.79.1641772505668;
        Sun, 09 Jan 2022 15:55:05 -0800 (PST)
Received: from localhost.swdvt.lab.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id ls6sm6948611pjb.33.2022.01.09.15.55.04
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 09 Jan 2022 15:55:05 -0800 (PST)
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, kuba@kernel.org, gospo@broadcom.com
Subject: [PATCH net-next v2 2/4] bnxt_en: improve VF error messages when PF is unavailable
Date:   Sun,  9 Jan 2022 18:54:43 -0500
Message-Id: <1641772485-10421-3-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1641772485-10421-1-git-send-email-michael.chan@broadcom.com>
References: <1641772485-10421-1-git-send-email-michael.chan@broadcom.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="00000000000007553b05d52ef363"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--00000000000007553b05d52ef363

From: Edwin Peer <edwin.peer@broadcom.com>

The current driver design relies on the PF netdev being open in order
to intercept the following HWRM commands from a VF:
    - HWRM_FUNC_VF_CFG
    - HWRM_CFA_L2_FILTER_ALLOC
    - HWRM_PORT_PHY_QCFG (only if FW_CAP_LINK_ADMIN is not supported)

If the PF is closed, then VFs are subjected to rather inscrutable error
messages in response to any configuration requests involving the above
command types. Recent firmware distinguishes this problem case from
other errors by returning HWRM_ERR_CODE_PF_UNAVAILABLE. In most cases,
the appropriate course of action is still to fail, but this can now be
accomplished with the aid of more user informative log messages. For L2
filter allocations that are already asynchronous, an automatic retry
seems more appropriate.

v2: Delete extra newline.

Signed-off-by: Edwin Peer <edwin.peer@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c     | 44 +++++++++++++++----
 drivers/net/ethernet/broadcom/bnxt/bnxt.h     |  1 +
 .../net/ethernet/broadcom/bnxt/bnxt_hwrm.c    |  4 +-
 3 files changed, 40 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index 203d2ddb5504..46f28ee4d05d 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -8637,7 +8637,10 @@ static int bnxt_init_chip(struct bnxt *bp, bool irq_re_init)
 	/* Filter for default vnic 0 */
 	rc = bnxt_hwrm_set_vnic_filter(bp, 0, 0, bp->dev->dev_addr);
 	if (rc) {
-		netdev_err(bp->dev, "HWRM vnic filter failure rc: %x\n", rc);
+		if (BNXT_VF(bp) && rc == -ENODEV)
+			netdev_err(bp->dev, "Cannot configure L2 filter while PF is unavailable\n");
+		else
+			netdev_err(bp->dev, "HWRM vnic filter failure rc: %x\n", rc);
 		goto err_out;
 	}
 	vnic->uc_filter_count = 1;
@@ -9430,6 +9433,10 @@ int bnxt_update_link(struct bnxt *bp, bool chng_link_state)
 	rc = hwrm_req_send(bp, req);
 	if (rc) {
 		hwrm_req_drop(bp, req);
+		if (BNXT_VF(bp) && rc == -ENODEV) {
+			netdev_warn(bp->dev, "Cannot obtain link state while PF unavailable.\n");
+			rc = 0;
+		}
 		return rc;
 	}
 
@@ -10828,12 +10835,21 @@ static int bnxt_cfg_rx_mode(struct bnxt *bp)
 	for (i = 1, off = 0; i < vnic->uc_filter_count; i++, off += ETH_ALEN) {
 		rc = bnxt_hwrm_set_vnic_filter(bp, 0, i, vnic->uc_list + off);
 		if (rc) {
-			netdev_err(bp->dev, "HWRM vnic filter failure rc: %x\n",
-				   rc);
+			if (BNXT_VF(bp) && rc == -ENODEV) {
+				if (!test_and_set_bit(BNXT_STATE_L2_FILTER_RETRY, &bp->state))
+					netdev_warn(bp->dev, "Cannot configure L2 filters while PF is unavailable, will retry\n");
+				else
+					netdev_dbg(bp->dev, "PF still unavailable while configuring L2 filters.\n");
+				rc = 0;
+			} else {
+				netdev_err(bp->dev, "HWRM vnic filter failure rc: %x\n", rc);
+			}
 			vnic->uc_filter_count = i;
 			return rc;
 		}
 	}
+	if (test_and_clear_bit(BNXT_STATE_L2_FILTER_RETRY, &bp->state))
+		netdev_notice(bp->dev, "Retry of L2 filter configuration successful.\n");
 
 skip_uc:
 	if ((vnic->rx_mask & CFA_L2_SET_RX_MASK_REQ_MASK_PROMISCUOUS) &&
@@ -11398,6 +11414,11 @@ static void bnxt_timer(struct timer_list *t)
 		}
 	}
 
+	if (test_bit(BNXT_STATE_L2_FILTER_RETRY, &bp->state)) {
+		set_bit(BNXT_RX_MASK_SP_EVENT, &bp->sp_event);
+		bnxt_queue_sp_work(bp);
+	}
+
 	if ((bp->flags & BNXT_FLAG_CHIP_P5) && !bp->chip_rev &&
 	    netif_carrier_ok(dev)) {
 		set_bit(BNXT_RING_COAL_NOW_SP_EVENT, &bp->sp_event);
@@ -13104,7 +13125,7 @@ static int bnxt_set_dflt_rings(struct bnxt *bp, bool sh)
 	bp->tx_nr_rings = bp->tx_nr_rings_per_tc;
 
 	rc = __bnxt_reserve_rings(bp);
-	if (rc)
+	if (rc && rc != -ENODEV)
 		netdev_warn(bp->dev, "Unable to reserve tx rings\n");
 	bp->tx_nr_rings_per_tc = bp->tx_nr_rings;
 	if (sh)
@@ -13113,7 +13134,7 @@ static int bnxt_set_dflt_rings(struct bnxt *bp, bool sh)
 	/* Rings may have been trimmed, re-reserve the trimmed rings. */
 	if (bnxt_need_reserve_rings(bp)) {
 		rc = __bnxt_reserve_rings(bp);
-		if (rc)
+		if (rc && rc != -ENODEV)
 			netdev_warn(bp->dev, "2nd rings reservation failed.\n");
 		bp->tx_nr_rings_per_tc = bp->tx_nr_rings;
 	}
@@ -13139,7 +13160,10 @@ static int bnxt_init_dflt_ring_mode(struct bnxt *bp)
 	bnxt_clear_int_mode(bp);
 	rc = bnxt_set_dflt_rings(bp, true);
 	if (rc) {
-		netdev_err(bp->dev, "Not enough rings available.\n");
+		if (BNXT_VF(bp) && rc == -ENODEV)
+			netdev_err(bp->dev, "Cannot configure VF rings while PF is unavailable.\n");
+		else
+			netdev_err(bp->dev, "Not enough rings available.\n");
 		goto init_dflt_ring_err;
 	}
 	rc = bnxt_init_int_mode(bp);
@@ -13427,8 +13451,12 @@ static int bnxt_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 	bnxt_set_ring_params(bp);
 	rc = bnxt_set_dflt_rings(bp, true);
 	if (rc) {
-		netdev_err(bp->dev, "Not enough rings available.\n");
-		rc = -ENOMEM;
+		if (BNXT_VF(bp) && rc == -ENODEV) {
+			netdev_err(bp->dev, "Cannot configure VF rings while PF is unavailable.\n");
+		} else {
+			netdev_err(bp->dev, "Not enough rings available.\n");
+			rc = -ENOMEM;
+		}
 		goto init_err_pci_clean;
 	}
 
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.h b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
index 7bd9c5d237d9..5ec251a1100f 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.h
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
@@ -1916,6 +1916,7 @@ struct bnxt {
 #define BNXT_STATE_DRV_REGISTERED	7
 #define BNXT_STATE_PCI_CHANNEL_IO_FROZEN	8
 #define BNXT_STATE_NAPI_DISABLED	9
+#define BNXT_STATE_L2_FILTER_RETRY	10
 #define BNXT_STATE_FW_ACTIVATE		11
 #define BNXT_STATE_RECOVER		12
 #define BNXT_STATE_FW_NON_FATAL_COND	13
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_hwrm.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_hwrm.c
index a16d1ff6359c..f75b2de8a14b 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_hwrm.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_hwrm.c
@@ -359,6 +359,8 @@ static int __hwrm_to_stderr(u32 hwrm_err)
 		return -EAGAIN;
 	case HWRM_ERR_CODE_CMD_NOT_SUPPORTED:
 		return -EOPNOTSUPP;
+	case HWRM_ERR_CODE_PF_UNAVAILABLE:
+		return -ENODEV;
 	default:
 		return -EIO;
 	}
@@ -648,7 +650,7 @@ static int __hwrm_send(struct bnxt *bp, struct bnxt_hwrm_ctx *ctx)
 	if (rc == HWRM_ERR_CODE_BUSY && !(ctx->flags & BNXT_HWRM_CTX_SILENT))
 		netdev_warn(bp->dev, "FW returned busy, hwrm req_type 0x%x\n",
 			    req_type);
-	else if (rc)
+	else if (rc && rc != HWRM_ERR_CODE_PF_UNAVAILABLE)
 		hwrm_err(bp, ctx, "hwrm req_type 0x%x seq id 0x%x error 0x%x\n",
 			 req_type, token->seq_id, rc);
 	rc = __hwrm_to_stderr(rc);
-- 
2.18.1


--00000000000007553b05d52ef363
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
DQYJYIZIAWUDBAIBBQCggdQwLwYJKoZIhvcNAQkEMSIEIJcsWq6plJr5SN/orOfytE6oYL4yiv2p
AH98U6Lq22cYMBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTIyMDEw
OTIzNTUwNlowaQYJKoZIhvcNAQkPMVwwWjALBglghkgBZQMEASowCwYJYIZIAWUDBAEWMAsGCWCG
SAFlAwQBAjAKBggqhkiG9w0DBzALBgkqhkiG9w0BAQowCwYJKoZIhvcNAQEHMAsGCWCGSAFlAwQC
ATANBgkqhkiG9w0BAQEFAASCAQBQSIt42ME88//ufpE9jr66h1DcSAgrNQn4/hmWG/RVw0kbQSB3
3AyxnTTo1GK4Kcw5uP5ev5QMLtgdjoZ/27KG6865WWnRHulwl1cNWpNh0i/vi0KYWPSEhOsGnT34
INoByKdxMrN5pqtlRg7iqH5EweH1Ki0CgiKIwWxeGrOxpmFHliBexIgaJSrpdT3nuayTWfELTvZU
YcueLVoUO5/UyyUtBKPdW4PI4nTYWmlFNGn4IFaPwUwJ+IVrGcFbygMYORY2AyBMcrZOib0dj+bZ
JHkS6/OnBzfoC+bcQ3DzI5eiQLDNOuKAeisGAj47fkAUx2fW2pv7cyKpGGBWZxsZ
--00000000000007553b05d52ef363--
