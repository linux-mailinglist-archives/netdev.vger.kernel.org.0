Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 69815282D38
	for <lists+netdev@lfdr.de>; Sun,  4 Oct 2020 21:23:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726482AbgJDTXl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 4 Oct 2020 15:23:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726519AbgJDTXh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 4 Oct 2020 15:23:37 -0400
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 432A3C0613CE
        for <netdev@vger.kernel.org>; Sun,  4 Oct 2020 12:23:37 -0700 (PDT)
Received: by mail-pf1-x442.google.com with SMTP id k8so5102024pfk.2
        for <netdev@vger.kernel.org>; Sun, 04 Oct 2020 12:23:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=C0GsQflbuTXp9cT2ZK4a+ZMiDF+ok0r+zAHwxM7BBOw=;
        b=LWTmEhyibKp4f/ZtjoGh9RM5ZBbVV3k+rH3SLfMvjgAOLESqlMxPzQthqS1ri0iqB2
         9mc0+KPcjQqy7xqt1SQURJPdEjg2CK2DpyABSpuYfuwePmqsg8pnXk/C8aXIowOBCv/Q
         b29zJZtqAh3wwMcrGilx2stA/gMKcJ/XQYHYg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=C0GsQflbuTXp9cT2ZK4a+ZMiDF+ok0r+zAHwxM7BBOw=;
        b=nAz6/Q4JzTUe2XFeb/TAlWz7C1CZ3HV9rAemjO5bbf7zjb9nXIAyNpo+9m5jP8sQ/x
         0pCIzhIXk5BFuG3zr766KOUxiYwn8oxYtttVj+2NIz7876l+GdZLwSM1zHdYOwcOAqGE
         okf/Le8/UjLf9Y8sVHn93LQ+D2SZqByUu8qeqe8GXBvw1hBD1cZ0HBVkVPIS1ghFuAZf
         Jp87yAzWfyb6zKUhh2yNTLu2H+Am/eFROQk5Adg4VaUav6+F/YuAzy6hQAfJrHyDkvHv
         9whASn9pXdnchUzmAEmCKzxTcXUTF7B8YE8CnCEVeGr9urEJ4OAL9c+Mmn9f2S/P4Zs8
         zIfA==
X-Gm-Message-State: AOAM533FU9IBd/UPOSosPYtmUHdi2tO5D1Ob4ME1h0oQ1d0eISPp1YYQ
        yvQjGqK78PqHvoEhbODhbWyOL01qNFC3sw==
X-Google-Smtp-Source: ABdhPJyOTZgxcXa585fnd1S+HpTlJ5GkhjNTrTSW+ysUfUmmc1is5MOHkUwOtWvVByMoawKZnYjsOg==
X-Received: by 2002:a63:1061:: with SMTP id 33mr11740946pgq.204.1601839416313;
        Sun, 04 Oct 2020 12:23:36 -0700 (PDT)
Received: from localhost.swdvt.lab.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 138sm9824234pfu.180.2020.10.04.12.23.35
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 04 Oct 2020 12:23:35 -0700 (PDT)
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, kuba@kernel.org, gospo@broadcom.com
Subject: [PATCH net-next 11/11] bnxt_en: Eliminate unnecessary RX resets.
Date:   Sun,  4 Oct 2020 15:23:01 -0400
Message-Id: <1601839381-10446-12-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1601839381-10446-1-git-send-email-michael.chan@broadcom.com>
References: <1601839381-10446-1-git-send-email-michael.chan@broadcom.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="000000000000704bc405b0dd4dbd"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--000000000000704bc405b0dd4dbd

Currently, the driver will schedule RX ring reset when we get a buffer
error in the RX completion record.  These RX buffer errors can be due
to normal out-of-buffer conditions or a permanent error in the RX
ring.  Because the driver cannot distinguish between these 2
conditions, we assume all these buffer errors require reset.

This is very disruptive when it is just a normal out-of-buffer
condition.  Newer firmware will now monitor the rings for the permanent
failure and will send a notification to the driver when it happens.
This allows the driver to reset only when such a notification is
received.  In environments where we have predominently out-of-buffer
conditions, we now can avoid these unnecessary resets.

Reviewed-by: Edwin Peer <edwin.peer@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c | 53 ++++++++++++++++++++++-
 drivers/net/ethernet/broadcom/bnxt/bnxt.h |  1 +
 2 files changed, 53 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index 1e6764000a74..5e4b7fbeef06 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -254,6 +254,7 @@ static const u16 bnxt_async_events_arr[] = {
 	ASYNC_EVENT_CMPL_EVENT_ID_PORT_PHY_CFG_CHANGE,
 	ASYNC_EVENT_CMPL_EVENT_ID_RESET_NOTIFY,
 	ASYNC_EVENT_CMPL_EVENT_ID_ERROR_RECOVERY,
+	ASYNC_EVENT_CMPL_EVENT_ID_RING_MONITOR_MSG,
 };
 
 static struct workqueue_struct *bnxt_pf_wq;
@@ -1777,7 +1778,8 @@ static int bnxt_rx_pkt(struct bnxt *bp, struct bnxt_cp_ring_info *cpr,
 		rc = -EIO;
 		if (rx_err & RX_CMPL_ERRORS_BUFFER_ERROR_MASK) {
 			bnapi->cp_ring.sw_stats.rx.rx_buf_errors++;
-			if (!(bp->flags & BNXT_FLAG_CHIP_P5)) {
+			if (!(bp->flags & BNXT_FLAG_CHIP_P5) &&
+			    !(bp->fw_cap & BNXT_FW_CAP_RING_MONITOR)) {
 				netdev_warn_once(bp->dev, "RX buffer error %x\n",
 						 rx_err);
 				bnxt_sched_reset(bp, rxr);
@@ -1946,10 +1948,33 @@ u32 bnxt_fw_health_readl(struct bnxt *bp, int reg_idx)
 	return val;
 }
 
+static u16 bnxt_agg_ring_id_to_grp_idx(struct bnxt *bp, u16 ring_id)
+{
+	int i;
+
+	for (i = 0; i < bp->rx_nr_rings; i++) {
+		u16 grp_idx = bp->rx_ring[i].bnapi->index;
+		struct bnxt_ring_grp_info *grp_info;
+
+		grp_info = &bp->grp_info[grp_idx];
+		if (grp_info->agg_fw_ring_id == ring_id)
+			return grp_idx;
+	}
+	return INVALID_HW_RING_ID;
+}
+
 #define BNXT_GET_EVENT_PORT(data)	\
 	((data) &			\
 	 ASYNC_EVENT_CMPL_PORT_CONN_NOT_ALLOWED_EVENT_DATA1_PORT_ID_MASK)
 
+#define BNXT_EVENT_RING_TYPE(data2)	\
+	((data2) &			\
+	 ASYNC_EVENT_CMPL_RING_MONITOR_MSG_EVENT_DATA2_DISABLE_RING_TYPE_MASK)
+
+#define BNXT_EVENT_RING_TYPE_RX(data2)	\
+	(BNXT_EVENT_RING_TYPE(data2) ==	\
+	 ASYNC_EVENT_CMPL_RING_MONITOR_MSG_EVENT_DATA2_DISABLE_RING_TYPE_RX)
+
 static int bnxt_async_event_process(struct bnxt *bp,
 				    struct hwrm_async_event_cmpl *cmpl)
 {
@@ -2057,6 +2082,30 @@ static int bnxt_async_event_process(struct bnxt *bp,
 			bnxt_fw_health_readl(bp, BNXT_FW_RESET_CNT_REG);
 		goto async_event_process_exit;
 	}
+	case ASYNC_EVENT_CMPL_EVENT_ID_RING_MONITOR_MSG: {
+		u32 data1 = le32_to_cpu(cmpl->event_data1);
+		u32 data2 = le32_to_cpu(cmpl->event_data2);
+		struct bnxt_rx_ring_info *rxr;
+		u16 grp_idx;
+
+		if (bp->flags & BNXT_FLAG_CHIP_P5)
+			goto async_event_process_exit;
+
+		netdev_warn(bp->dev, "Ring monitor event, ring type %lu id 0x%x\n",
+			    BNXT_EVENT_RING_TYPE(data2), data1);
+		if (!BNXT_EVENT_RING_TYPE_RX(data2))
+			goto async_event_process_exit;
+
+		grp_idx = bnxt_agg_ring_id_to_grp_idx(bp, data1);
+		if (grp_idx == INVALID_HW_RING_ID) {
+			netdev_warn(bp->dev, "Unknown RX agg ring id 0x%x\n",
+				    data1);
+			goto async_event_process_exit;
+		}
+		rxr = bp->bnapi[grp_idx]->rx_ring;
+		bnxt_sched_reset(bp, rxr);
+		goto async_event_process_exit;
+	}
 	default:
 		goto async_event_process_exit;
 	}
@@ -6649,6 +6698,8 @@ static int bnxt_hwrm_func_qcfg(struct bnxt *bp)
 	}
 	if (BNXT_PF(bp) && (flags & FUNC_QCFG_RESP_FLAGS_MULTI_HOST))
 		bp->flags |= BNXT_FLAG_MULTI_HOST;
+	if (flags & FUNC_QCFG_RESP_FLAGS_RING_MONITOR_ENABLED)
+		bp->fw_cap |= BNXT_FW_CAP_RING_MONITOR;
 
 	switch (resp->port_partition_type) {
 	case FUNC_QCFG_RESP_PORT_PARTITION_TYPE_NPAR1_0:
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.h b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
index 7d0e6022dc19..b208ff7c5d14 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.h
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
@@ -1822,6 +1822,7 @@ struct bnxt {
 	#define BNXT_FW_CAP_VLAN_TX_INSERT		0x02000000
 	#define BNXT_FW_CAP_EXT_HW_STATS_SUPPORTED	0x04000000
 	#define BNXT_FW_CAP_PORT_STATS_NO_RESET		0x10000000
+	#define BNXT_FW_CAP_RING_MONITOR		0x40000000
 
 #define BNXT_NEW_RM(bp)		((bp)->fw_cap & BNXT_FW_CAP_NEW_RM)
 	u32			hwrm_spec_code;
-- 
2.18.1


--000000000000704bc405b0dd4dbd
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
ENt96uQJNu/QKZCsRxnu8bu9XkzIQTTFs7+NKghvf+h9ck5SSEvV5vlzS8HDlhKReyLBOxx5AgMB
AAGjggHQMIIBzDAOBgNVHQ8BAf8EBAMCBaAwgZ4GCCsGAQUFBwEBBIGRMIGOME0GCCsGAQUFBzAC
hkFodHRwOi8vc2VjdXJlLmdsb2JhbHNpZ24uY29tL2NhY2VydC9nc3BlcnNvbmFsc2lnbjJzaGEy
ZzNvY3NwLmNydDA9BggrBgEFBQcwAYYxaHR0cDovL29jc3AyLmdsb2JhbHNpZ24uY29tL2dzcGVy
c29uYWxzaWduMnNoYTJnMzBNBgNVHSAERjBEMEIGCisGAQQBoDIBKAowNDAyBggrBgEFBQcCARYm
aHR0cHM6Ly93d3cuZ2xvYmFsc2lnbi5jb20vcmVwb3NpdG9yeS8wCQYDVR0TBAIwADBEBgNVHR8E
PTA7MDmgN6A1hjNodHRwOi8vY3JsLmdsb2JhbHNpZ24uY29tL2dzcGVyc29uYWxzaWduMnNoYTJn
My5jcmwwJAYDVR0RBB0wG4EZbWljaGFlbC5jaGFuQGJyb2FkY29tLmNvbTATBgNVHSUEDDAKBggr
BgEFBQcDBDAfBgNVHSMEGDAWgBRpcoJiMWeVRIV3kYDEBDZJnXsLYTAdBgNVHQ4EFgQUyZbpLEwR
KZHEh+rXp6GbCZmMEwUwDQYJKoZIhvcNAQELBQADggEBADZsABrJEwqeVLJJcX+rKN/oFPl/Sb1f
4NQRqf0J5IHlqI7oSUUaSVHviPvq4QyTMh7P9KHkuTwANTnTPr4f4y1SirdtxgZKy1xDmt1KjL5u
nA4rBLSA+Kp/mo0DMxKKQY/LsZNS3Zn+HIAZpXTUEFotC5qgN35ua7sP0hTynKzfLG8Fi565tQkX
Si7Gzq+VM1jcLa3+kjHalTIlC7q7gkvVhgEwmztW1SuO7pJn0/GOncxYGQXEk3PIH3QbPNO8VMkx
3YeEtbaXosR5XLWchobv9S5HB9h4t0TUbZh2kX0HlGzgFLCPif27aL7ZpahFcoCS928kT+/V4tAj
BB+IwnkxggJvMIICawIBATBtMF0xCzAJBgNVBAYTAkJFMRkwFwYDVQQKExBHbG9iYWxTaWduIG52
LXNhMTMwMQYDVQQDEypHbG9iYWxTaWduIFBlcnNvbmFsU2lnbiAyIENBIC0gU0hBMjU2IC0gRzMC
DF5npqHWO504Sj4Q1TANBglghkgBZQMEAgEFAKCB1DAvBgkqhkiG9w0BCQQxIgQgK2qS0mWnqd9r
CHGCJlveI34HgxsBp9IUU/DXngpPbOswGAYJKoZIhvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG
9w0BCQUxDxcNMjAxMDA0MTkyMzM3WjBpBgkqhkiG9w0BCQ8xXDBaMAsGCWCGSAFlAwQBKjALBglg
hkgBZQMEARYwCwYJYIZIAWUDBAECMAoGCCqGSIb3DQMHMAsGCSqGSIb3DQEBCjALBgkqhkiG9w0B
AQcwCwYJYIZIAWUDBAIBMA0GCSqGSIb3DQEBAQUABIIBAHqThd72ndA3sGa2hiD1CDVdfbK1lVOX
ymohs2tFAdr1ogEdT9J4Y2lJjYtzL5NAzMyuH8DQiCHW5icAy5nGfKnrXjQNeK0rNcxiGNmbdYtK
cYhlV6HErBu9CeebIyulcqTCzx8W2l+8utWnPaR28wAmMsPVVzDOWT4z1Nml8vldeKu3/oFX5rs6
+/0hrP/Rlv3q7oSBU4hHav0ZH0wD7X219kws9QQ3VdVk0cnaK8kqkGouRDItOdm/uUSQQLW7xU7B
IXE5Ujh9cRZ98XX6hX/faj9pn0ZsG3QOQANXsAMx6U6ysLpKPWFbHiaC5IerokV5mzzshuUcownt
G6MfUg0=
--000000000000704bc405b0dd4dbd--
