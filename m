Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 799C7282D3C
	for <lists+netdev@lfdr.de>; Sun,  4 Oct 2020 21:23:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726685AbgJDTXk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 4 Oct 2020 15:23:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726294AbgJDTXd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 4 Oct 2020 15:23:33 -0400
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 640A7C0613D0
        for <netdev@vger.kernel.org>; Sun,  4 Oct 2020 12:23:33 -0700 (PDT)
Received: by mail-pg1-x543.google.com with SMTP id t14so4334255pgl.10
        for <netdev@vger.kernel.org>; Sun, 04 Oct 2020 12:23:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=HUmvziSH10+NSBA4K69lu3ErQwLVzy6PHh7gve51sqI=;
        b=KIimXRHEAbj/dCXmHsHKEvtmtYvHmXnE/N0mVDd4x2gQHPo397byeSf45Zpni/VLm+
         jt2RCrjunk0peWE6eA4JfcKR8JLe8HKOA8ZEQoVUAFZrpheIyTXUIUpZNYXDfgIS9KMF
         j/gXoepD+nYXHsSG9M54ptEqbmhQ5tkAhkkGY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=HUmvziSH10+NSBA4K69lu3ErQwLVzy6PHh7gve51sqI=;
        b=Kjlz7ueSo2PFI2J3dQpHzXOsnN/CjZf13LrjxpjoPNGcHi4/I4pofBmq08ZUjVi3UB
         ePr0DNPCJc0C8gMWr9wInLXWhkOoUJUhb0cuqH9HawIPNg+ZzkBQ/Sive1QOCy0IQt+Z
         v9k6woXefT6cA5Gov3STK63gEUJ/BminVSsaY/ulT8YI7N0CRnPH4mpgO1XTtGxhnQY3
         gncALPiLXKPfXKcqITo1bf9hU3XowOfGG4io/Rg6FXL710CSswHMMCSsvRDKTqNFrE4/
         ywYKLmv6+HftBIYzJdq63QBawXT9H63R9xWkmHo5/6y1MCh2YX82YBObXZcaVrwu8wP5
         xpeQ==
X-Gm-Message-State: AOAM533HU98Y78s4atcobPJbab+sAozhjp9HSHh1shnUJskI7p+qyJeC
        uLykyjUBqu3YqngaF2MQ48u2jVtV+/0mHQ==
X-Google-Smtp-Source: ABdhPJz1YI5f39B5TnYL42MQk3dvCLx0fH0U7Fm8x0IxkFBWPHTCBaadK74ISWyU5bRVeAGyEGZ65w==
X-Received: by 2002:a65:6086:: with SMTP id t6mr11077390pgu.146.1601839412622;
        Sun, 04 Oct 2020 12:23:32 -0700 (PDT)
Received: from localhost.swdvt.lab.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 138sm9824234pfu.180.2020.10.04.12.23.31
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 04 Oct 2020 12:23:31 -0700 (PDT)
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, kuba@kernel.org, gospo@broadcom.com,
        Edwin Peer <edwin.peer@broadcom.com>
Subject: [PATCH net-next 08/11] bnxt_en: Implement RX ring reset in response to buffer errors.
Date:   Sun,  4 Oct 2020 15:22:58 -0400
Message-Id: <1601839381-10446-9-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1601839381-10446-1-git-send-email-michael.chan@broadcom.com>
References: <1601839381-10446-1-git-send-email-michael.chan@broadcom.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="0000000000003611d305b0dd4d45"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--0000000000003611d305b0dd4d45

On some older chips, it is necessary to do a reset when we get buffer
errors associated with an RX ring.  These buffer errors may become
frequent if the RX ring underruns under heavy traffic.  The current
code does a global reset of all reasources when this happens.  This
works but creates a big disruption of all rings when one RX ring is
having problem.  This patch implements a localized RX ring reset of
just the RX ring having the issue.  All other rings including all
TX rings will not be affected by this single RX ring reset.

Only the older chips prior to the P5 class supports this reset.
Because it is not a global reset, packets may still be arriving
while we are calling firmware to reset that ring.  We need to be
sure that we don't post any buffers during this time while the
ring is undergoing reset.  After firmware completes successfully,
the ring will be in the reset state with no buffers and we can start
filling it with new buffers and posting them.

Reviewed-by: Pavan Chebbi <pavan.chebbi@broadcom.com>
Signed-off-by: Edwin Peer <edwin.peer@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c | 79 +++++++++++++++++++++--
 1 file changed, 75 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index ef0267060a46..31877fb4ddd9 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -1172,7 +1172,10 @@ static void bnxt_sched_reset(struct bnxt *bp, struct bnxt_rx_ring_info *rxr)
 {
 	if (!rxr->bnapi->in_reset) {
 		rxr->bnapi->in_reset = true;
-		set_bit(BNXT_RESET_TASK_SP_EVENT, &bp->sp_event);
+		if (bp->flags & BNXT_FLAG_CHIP_P5)
+			set_bit(BNXT_RESET_TASK_SP_EVENT, &bp->sp_event);
+		else
+			set_bit(BNXT_RST_RING_SP_EVENT, &bp->sp_event);
 		bnxt_queue_sp_work(bp);
 	}
 	rxr->rx_next_cons = 0xffff;
@@ -1773,8 +1776,8 @@ static int bnxt_rx_pkt(struct bnxt *bp, struct bnxt_cp_ring_info *cpr,
 		if (rx_err & RX_CMPL_ERRORS_BUFFER_ERROR_MASK) {
 			bnapi->cp_ring.sw_stats.rx.rx_buf_errors++;
 			if (!(bp->flags & BNXT_FLAG_CHIP_P5)) {
-				netdev_warn(bp->dev, "RX buffer error %x\n",
-					    rx_err);
+				netdev_warn_once(bp->dev, "RX buffer error %x\n",
+						 rx_err);
 				bnxt_sched_reset(bp, rxr);
 			}
 		}
@@ -2250,7 +2253,7 @@ static void __bnxt_poll_work_done(struct bnxt *bp, struct bnxt_napi *bnapi)
 		bnapi->tx_pkts = 0;
 	}
 
-	if (bnapi->events & BNXT_RX_EVENT) {
+	if ((bnapi->events & BNXT_RX_EVENT) && !(bnapi->in_reset)) {
 		struct bnxt_rx_ring_info *rxr = bnapi->rx_ring;
 
 		if (bnapi->events & BNXT_AGG_EVENT)
@@ -10510,6 +10513,23 @@ static void bnxt_dbg_dump_states(struct bnxt *bp)
 	}
 }
 
+static int bnxt_hwrm_rx_ring_reset(struct bnxt *bp, int ring_nr)
+{
+	struct bnxt_rx_ring_info *rxr = &bp->rx_ring[ring_nr];
+	struct hwrm_ring_reset_input req = {0};
+	struct bnxt_napi *bnapi = rxr->bnapi;
+	struct bnxt_cp_ring_info *cpr;
+	u16 cp_ring_id;
+
+	cpr = &bnapi->cp_ring;
+	cp_ring_id = cpr->cp_ring_struct.fw_ring_id;
+	bnxt_hwrm_cmd_hdr_init(bp, &req, HWRM_RING_RESET, cp_ring_id, -1);
+	req.ring_type = RING_RESET_REQ_RING_TYPE_RX_RING_GRP;
+	req.ring_id = cpu_to_le16(bp->grp_info[bnapi->index].fw_grp_id);
+	return hwrm_send_message_silent(bp, &req, sizeof(req),
+					HWRM_CMD_TIMEOUT);
+}
+
 static void bnxt_reset_task(struct bnxt *bp, bool silent)
 {
 	if (!silent)
@@ -10645,6 +10665,54 @@ static void bnxt_reset(struct bnxt *bp, bool silent)
 	bnxt_rtnl_unlock_sp(bp);
 }
 
+/* Only called from bnxt_sp_task() */
+static void bnxt_rx_ring_reset(struct bnxt *bp)
+{
+	int i;
+
+	bnxt_rtnl_lock_sp(bp);
+	if (!test_bit(BNXT_STATE_OPEN, &bp->state)) {
+		bnxt_rtnl_unlock_sp(bp);
+		return;
+	}
+	/* Disable and flush TPA before resetting the RX ring */
+	if (bp->flags & BNXT_FLAG_TPA)
+		bnxt_set_tpa(bp, false);
+	for (i = 0; i < bp->rx_nr_rings; i++) {
+		struct bnxt_rx_ring_info *rxr = &bp->rx_ring[i];
+		struct bnxt_cp_ring_info *cpr;
+		int rc;
+
+		if (!rxr->bnapi->in_reset)
+			continue;
+
+		rc = bnxt_hwrm_rx_ring_reset(bp, i);
+		if (rc) {
+			if (rc == -EINVAL || rc == -EOPNOTSUPP)
+				netdev_info_once(bp->dev, "RX ring reset not supported by firmware, falling back to global reset\n");
+			else
+				netdev_warn(bp->dev, "RX ring reset failed, rc = %d, falling back to global reset\n",
+					    rc);
+			bnxt_reset_task(bp, false);
+			break;
+		}
+		bnxt_free_one_rx_ring_skbs(bp, i);
+		rxr->rx_prod = 0;
+		rxr->rx_agg_prod = 0;
+		rxr->rx_sw_agg_prod = 0;
+		rxr->rx_next_cons = 0;
+		rxr->bnapi->in_reset = false;
+		bnxt_alloc_one_rx_ring(bp, i);
+		cpr = &rxr->bnapi->cp_ring;
+		if (bp->flags & BNXT_FLAG_AGG_RINGS)
+			bnxt_db_write(bp, &rxr->rx_agg_db, rxr->rx_agg_prod);
+		bnxt_db_write(bp, &rxr->rx_db, rxr->rx_prod);
+	}
+	if (bp->flags & BNXT_FLAG_TPA)
+		bnxt_set_tpa(bp, true);
+	bnxt_rtnl_unlock_sp(bp);
+}
+
 static void bnxt_fw_reset_close(struct bnxt *bp)
 {
 	bnxt_ulp_stop(bp);
@@ -10933,6 +11001,9 @@ static void bnxt_sp_task(struct work_struct *work)
 	if (test_and_clear_bit(BNXT_RESET_TASK_SILENT_SP_EVENT, &bp->sp_event))
 		bnxt_reset(bp, true);
 
+	if (test_and_clear_bit(BNXT_RST_RING_SP_EVENT, &bp->sp_event))
+		bnxt_rx_ring_reset(bp);
+
 	if (test_and_clear_bit(BNXT_FW_RESET_NOTIFY_SP_EVENT, &bp->sp_event))
 		bnxt_devlink_health_report(bp, BNXT_FW_RESET_NOTIFY_SP_EVENT);
 
-- 
2.18.1


--0000000000003611d305b0dd4d45
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

MIIQQgYJKoZIhvcNAQcCoIIQMzCCEC8CAQExDzANBglghkgBZQMEAgEFADALBgkqhkiG9w0BBwGg
gg2XMIIE6DCCA9CgAwIBAgIOSBtqCRO9gCTKXSLwFPMwDQYJKoZIhvcNAQELBQAwTDEgMB4GA1UE
CxMXR2xvYmFsU2lnbiBSb290IENBIC0gUjMxEzARBgNVBAoTCkdsb2JhbFNpZ24xEzARBgNVBAMT
Ckdsb2JhbFNpZ24wHhcNMTYwNjE1MDAwMDAwWhcNMjQwNjE1MDAwMDAwWjBdMQswCQYDVQQGEwJC
RTEZMBcGA1UEChMQR2xvYmFsU2lnbiBudi1zYTEzMDEGA1UEAxMqR2xvYmFsU2lnbiBQZXJzb25h
bFNpZ24gMiBDQSAtIFNIQTI1NiAtIEczMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEA
tpZok2X9LAHsYqMNVL+Ly6RDkaKar7GD8rVtb9nw6tzPFnvXGeOEA4X5xh9wjx9sScVpGR5wkTg1
fgJIXTlrGESmaqXIdPRd9YQ+Yx9xRIIIPu3Jp/bpbiZBKYDJSbr/2Xago7sb9nnfSyjTSnucUcIP
ZVChn6hKneVGBI2DT9yyyD3PmCEJmEzA8Y96qT83JmVH2GaPSSbCw0C+Zj1s/zqtKUbwE5zh8uuZ
p4vC019QbaIOb8cGlzgvTqGORwK0gwDYpOO6QQdg5d03WvIHwTunnJdoLrfvqUg2vOlpqJmqR+nH
9lHS+bEstsVJtZieU1Pa+3LzfA/4cT7XA/pnwwIDAQABo4IBtTCCAbEwDgYDVR0PAQH/BAQDAgEG
MGoGA1UdJQRjMGEGCCsGAQUFBwMCBggrBgEFBQcDBAYIKwYBBQUHAwkGCisGAQQBgjcUAgIGCisG
AQQBgjcKAwQGCSsGAQQBgjcVBgYKKwYBBAGCNwoDDAYIKwYBBQUHAwcGCCsGAQUFBwMRMBIGA1Ud
EwEB/wQIMAYBAf8CAQAwHQYDVR0OBBYEFGlygmIxZ5VEhXeRgMQENkmdewthMB8GA1UdIwQYMBaA
FI/wS3+oLkUkrk1Q+mOai97i3Ru8MD4GCCsGAQUFBwEBBDIwMDAuBggrBgEFBQcwAYYiaHR0cDov
L29jc3AyLmdsb2JhbHNpZ24uY29tL3Jvb3RyMzA2BgNVHR8ELzAtMCugKaAnhiVodHRwOi8vY3Js
Lmdsb2JhbHNpZ24uY29tL3Jvb3QtcjMuY3JsMGcGA1UdIARgMF4wCwYJKwYBBAGgMgEoMAwGCisG
AQQBoDIBKAowQQYJKwYBBAGgMgFfMDQwMgYIKwYBBQUHAgEWJmh0dHBzOi8vd3d3Lmdsb2JhbHNp
Z24uY29tL3JlcG9zaXRvcnkvMA0GCSqGSIb3DQEBCwUAA4IBAQConc0yzHxn4gtQ16VccKNm4iXv
6rS2UzBuhxI3XDPiwihW45O9RZXzWNgVcUzz5IKJFL7+pcxHvesGVII+5r++9eqI9XnEKCILjHr2
DgvjKq5Jmg6bwifybLYbVUoBthnhaFB0WLwSRRhPrt5eGxMw51UmNICi/hSKBKsHhGFSEaJQALZy
4HL0EWduE6ILYAjX6BSXRDtHFeUPddb46f5Hf5rzITGLsn9BIpoOVrgS878O4JnfUWQi29yBfn75
HajifFvPC+uqn+rcVnvrpLgsLOYG/64kWX/FRH8+mhVe+mcSX3xsUpcxK9q9vLTVtroU/yJUmEC4
OcH5dQsbHBqjMIIDXzCCAkegAwIBAgILBAAAAAABIVhTCKIwDQYJKoZIhvcNAQELBQAwTDEgMB4G
A1UECxMXR2xvYmFsU2lnbiBSb290IENBIC0gUjMxEzARBgNVBAoTCkdsb2JhbFNpZ24xEzARBgNV
BAMTCkdsb2JhbFNpZ24wHhcNMDkwMzE4MTAwMDAwWhcNMjkwMzE4MTAwMDAwWjBMMSAwHgYDVQQL
ExdHbG9iYWxTaWduIFJvb3QgQ0EgLSBSMzETMBEGA1UEChMKR2xvYmFsU2lnbjETMBEGA1UEAxMK
R2xvYmFsU2lnbjCCASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEBAMwldpB5BngiFvXAg7aE
yiie/QV2EcWtiHL8RgJDx7KKnQRfJMsuS+FggkbhUqsMgUdwbN1k0ev1LKMPgj0MK66X17YUhhB5
uzsTgHeMCOFJ0mpiLx9e+pZo34knlTifBtc+ycsmWQ1z3rDI6SYOgxXG71uL0gRgykmmKPZpO/bL
yCiR5Z2KYVc3rHQU3HTgOu5yLy6c+9C7v/U9AOEGM+iCK65TpjoWc4zdQQ4gOsC0p6Hpsk+QLjJg
6VfLuQSSaGjlOCZgdbKfd/+RFO+uIEn8rUAVSNECMWEZXriX7613t2Saer9fwRPvm2L7DWzgVGkW
qQPabumDk3F2xmmFghcCAwEAAaNCMEAwDgYDVR0PAQH/BAQDAgEGMA8GA1UdEwEB/wQFMAMBAf8w
HQYDVR0OBBYEFI/wS3+oLkUkrk1Q+mOai97i3Ru8MA0GCSqGSIb3DQEBCwUAA4IBAQBLQNvAUKr+
yAzv95ZURUm7lgAJQayzE4aGKAczymvmdLm6AC2upArT9fHxD4q/c2dKg8dEe3jgr25sbwMpjjM5
RcOO5LlXbKr8EpbsU8Yt5CRsuZRj+9xTaGdWPoO4zzUhw8lo/s7awlOqzJCK6fBdRoyV3XpYKBov
Hd7NADdBj+1EbddTKJd+82cEHhXXipa0095MJ6RMG3NzdvQXmcIfeg7jLQitChws/zyrVQ4PkX42
68NXSb7hLi18YIvDQVETI53O9zJrlAGomecsMx86OyXShkDOOyyGeMlhLxS67ttVb9+E7gUJTb0o
2HLO02JQZR7rkpeDMdmztcpHWD9fMIIFRDCCBCygAwIBAgIMXmemodY7nThKPhDVMA0GCSqGSIb3
DQEBCwUAMF0xCzAJBgNVBAYTAkJFMRkwFwYDVQQKExBHbG9iYWxTaWduIG52LXNhMTMwMQYDVQQD
EypHbG9iYWxTaWduIFBlcnNvbmFsU2lnbiAyIENBIC0gU0hBMjU2IC0gRzMwHhcNMjAwOTIxMTQ0
MzQ4WhcNMjIwOTIyMTQ0MzQ4WjCBjjELMAkGA1UEBhMCSU4xEjAQBgNVBAgTCUthcm5hdGFrYTES
MBAGA1UEBxMJQmFuZ2Fsb3JlMRYwFAYDVQQKEw1Ccm9hZGNvbSBJbmMuMRUwEwYDVQQDEwxNaWNo
YWVsIENoYW4xKDAmBgkqhkiG9w0BCQEWGW1pY2hhZWwuY2hhbkBicm9hZGNvbS5jb20wggEiMA0G
CSqGSIb3DQEBAQUAA4IBDwAwggEKAoIBAQCzvTuOFaHAhIIrIXYLJ1QZpV36s3f9hlbZaYtz/62Y
SlCURfQ+8H3lJAzgIK2y0H/wT6TqqTDDJiRnDEm/g+5cRmc+bgdu6tGTmj0TIB5Z9wl5SCszDgme
/pPQJf8bD0McWRyaJctmS3DJWgBKl3Fg+tEwUtE4vjA2Yc8WK/S2gtZopdx2gDtvb9ckkJO1LENm
VqhZWob5BsD9/3+ouwWAGUFyA14cXchjfxAeuf4j03ckshYX3DVIp802zOgdQZ5QPfeLUIDSj4yF
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
DF5npqHWO504Sj4Q1TANBglghkgBZQMEAgEFAKCB1DAvBgkqhkiG9w0BCQQxIgQgdMqUSZUcvwGV
FPNMzA+F40rDjtbYsGmiOdl9Tpe35q4wGAYJKoZIhvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG
9w0BCQUxDxcNMjAxMDA0MTkyMzMzWjBpBgkqhkiG9w0BCQ8xXDBaMAsGCWCGSAFlAwQBKjALBglg
hkgBZQMEARYwCwYJYIZIAWUDBAECMAoGCCqGSIb3DQMHMAsGCSqGSIb3DQEBCjALBgkqhkiG9w0B
AQcwCwYJYIZIAWUDBAIBMA0GCSqGSIb3DQEBAQUABIIBAHzIocW6qeYCYNJGoPh1GGfNcQ1YMXgt
vDyRf8emqBXhi2Jiy2OUiy0ASQUEQuQblq3LxVYN8YWLWhY9X+bBMn1e8hphma88+vyejUJhAZQU
3Th47zem335OqZBc6PwL/kECPigIuKKgl/fp+5Sg3/q5UCygPjuJBazcKizzW63x9Ga6cE9/tjfl
zn68ji7Q/xveV0+R2YQ4bYyNSYtCKWazyEFXBhnG5bGW59WgH3yW7yi+PW5rrOH7vWh3sr1fL/GW
GUXsQLmo/ZGtMEQwB/rPw3mFpT69HZHrSKmPu8RJT3PqpgaBUKJKntGwCMDA00lXl9n7MJ6AxOsw
mhUeTjU=
--0000000000003611d305b0dd4d45--
