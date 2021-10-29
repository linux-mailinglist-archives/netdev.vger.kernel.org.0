Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 856E443F80C
	for <lists+netdev@lfdr.de>; Fri, 29 Oct 2021 09:48:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232320AbhJ2HvB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Oct 2021 03:51:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232290AbhJ2Hux (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Oct 2021 03:50:53 -0400
Received: from mail-pg1-x530.google.com (mail-pg1-x530.google.com [IPv6:2607:f8b0:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7AD88C061714
        for <netdev@vger.kernel.org>; Fri, 29 Oct 2021 00:48:25 -0700 (PDT)
Received: by mail-pg1-x530.google.com with SMTP id e65so9145513pgc.5
        for <netdev@vger.kernel.org>; Fri, 29 Oct 2021 00:48:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=6jIcDpdO9Ci/8DYhyd0odk7AqIemH//mL6+LpmIKVLM=;
        b=OMM3M1o4u4S0bT0/KpHTmHDP7GYbobgpJYRzccYvOXA4VLnqKAq5wvfpLYUsigsZxX
         w2/cjWQnuITo6gM8pbFmwvznZKcSSt4t+Z9/8HxXiH4fnELLsjqncAM/dt/VLueKiHqE
         yu4+KHLGoZP/TA2VyFASJYAxW9e89qU8cj7gY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=6jIcDpdO9Ci/8DYhyd0odk7AqIemH//mL6+LpmIKVLM=;
        b=E1bf/kj8pVk6f4VjN63ZhzNxNom8bWhd7JfJEqhtl8Z4sWKDbG+bP6ErNp6A7KSrev
         21Y2Nqt2FB43pvLB1twubbFojRzhiogpW1Tlvgdjej2TcDOOgM872NLm3s4FEJ3wStpP
         mDbLT5fFrgVNBbIQDJZY1SyVn40W/Qupm0P2hmY5+T9eYFtZY7+IqPy/8xJTEx6P4rt3
         DSRov2AvooIFB+RQQ4UIu7rmGLB4i8MKl9r7edgBzVdjreE4vzI0wBuHtB5JE3o3NbOl
         Mo/pFW8VSvT+2Pq55BWzA7UEJ4cX4Ugo/zpTtFQRHZEXS0lebIPf/JUqoRb+neTqLAZv
         /oSg==
X-Gm-Message-State: AOAM533fec1sBunStlGalVWyUeJNoteDiPz9PgYdkaYJo52l7y+z6vKL
        yZupyyj7al0ibD26neCDMi/EuQ==
X-Google-Smtp-Source: ABdhPJzcgz1EXbNyU/CJO7Q12IfcbudoBbCjIUgBcqgilqqad+cSqF3QC1QdSkd7wbos3uvjyF0qtA==
X-Received: by 2002:a63:ea4e:: with SMTP id l14mr2403911pgk.406.1635493704398;
        Fri, 29 Oct 2021 00:48:24 -0700 (PDT)
Received: from localhost.swdvt.lab.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id s18sm5721186pfc.87.2021.10.29.00.48.23
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 29 Oct 2021 00:48:23 -0700 (PDT)
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, kuba@kernel.org, edwin.peer@broadcom.com,
        gospo@broadcom.com, jiri@nvidia.com
Subject: [PATCH net-next v2 10/19] bnxt_en: Refactor coredump functions
Date:   Fri, 29 Oct 2021 03:47:47 -0400
Message-Id: <1635493676-10767-11-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1635493676-10767-1-git-send-email-michael.chan@broadcom.com>
References: <1635493676-10767-1-git-send-email-michael.chan@broadcom.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="00000000000055f39305cf790df8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--00000000000055f39305cf790df8

From: Edwin Peer <edwin.peer@broadcom.com>

The coredump functionality will be used by devlink health. Refactor
these functions that get coredump and coredump length. There is no
functional change, but the following checkpatch warnings were
addressed:

  - strscpy is preferred over strlcpy.
  - sscanf results should be checked, with an additional warning.

Signed-off-by: Edwin Peer <edwin.peer@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
---
 .../net/ethernet/broadcom/bnxt/bnxt_ethtool.c | 48 ++++++++++++-------
 1 file changed, 31 insertions(+), 17 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
index 15c518024965..fe832f97f905 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
@@ -3808,7 +3808,7 @@ bnxt_fill_coredump_record(struct bnxt *bp, struct bnxt_coredump_record *record,
 	record->low_version = 0;
 	record->high_version = 1;
 	record->asic_state = 0;
-	strlcpy(record->system_name, utsname()->nodename,
+	strscpy(record->system_name, utsname()->nodename,
 		sizeof(record->system_name));
 	record->year = cpu_to_le16(tm.tm_year + 1900);
 	record->month = cpu_to_le16(tm.tm_mon + 1);
@@ -3820,11 +3820,12 @@ bnxt_fill_coredump_record(struct bnxt *bp, struct bnxt_coredump_record *record,
 	strcpy(record->commandline, "ethtool -w");
 	record->total_segments = cpu_to_le32(total_segs);
 
-	sscanf(utsname()->release, "%u.%u", &os_ver_major, &os_ver_minor);
+	if (sscanf(utsname()->release, "%u.%u", &os_ver_major, &os_ver_minor) != 2)
+		netdev_warn(bp->dev, "Unknown OS release in coredump\n");
 	record->os_ver_major = cpu_to_le32(os_ver_major);
 	record->os_ver_minor = cpu_to_le32(os_ver_minor);
 
-	strlcpy(record->os_name, utsname()->sysname, 32);
+	strscpy(record->os_name, utsname()->sysname, sizeof(record->os_name));
 	time64_to_tm(end, 0, &tm);
 	record->end_year = cpu_to_le16(tm.tm_year + 1900);
 	record->end_month = cpu_to_le16(tm.tm_mon + 1);
@@ -3842,7 +3843,7 @@ bnxt_fill_coredump_record(struct bnxt *bp, struct bnxt_coredump_record *record,
 	record->ioctl_high_version = 0;
 }
 
-static int bnxt_get_coredump(struct bnxt *bp, void *buf, u32 *dump_len)
+static int __bnxt_get_coredump(struct bnxt *bp, void *buf, u32 *dump_len)
 {
 	u32 ver_get_resp_len = sizeof(struct hwrm_ver_get_output);
 	u32 offset = 0, seg_hdr_len, seg_record_len, buf_len = 0;
@@ -3945,6 +3946,30 @@ static int bnxt_get_coredump(struct bnxt *bp, void *buf, u32 *dump_len)
 	return rc;
 }
 
+static int bnxt_get_coredump(struct bnxt *bp, u16 dump_type, void *buf, u32 *dump_len)
+{
+	if (dump_type == BNXT_DUMP_CRASH) {
+#ifdef CONFIG_TEE_BNXT_FW
+		return tee_bnxt_copy_coredump(buf, 0, *dump_len);
+#else
+		return -EOPNOTSUPP;
+#endif
+	} else {
+		return __bnxt_get_coredump(bp, buf, dump_len);
+	}
+}
+
+static u32 bnxt_get_coredump_length(struct bnxt *bp, u16 dump_type)
+{
+	u32 len = 0;
+
+	if (dump_type == BNXT_DUMP_CRASH)
+		len = BNXT_CRASH_DUMP_LEN;
+	else
+		__bnxt_get_coredump(bp, NULL, &len);
+	return len;
+}
+
 static int bnxt_set_dump(struct net_device *dev, struct ethtool_dump *dump)
 {
 	struct bnxt *bp = netdev_priv(dev);
@@ -3976,10 +4001,7 @@ static int bnxt_get_dump_flag(struct net_device *dev, struct ethtool_dump *dump)
 			bp->ver_resp.hwrm_fw_rsvd_8b;
 
 	dump->flag = bp->dump_flag;
-	if (bp->dump_flag == BNXT_DUMP_CRASH)
-		dump->len = BNXT_CRASH_DUMP_LEN;
-	else
-		bnxt_get_coredump(bp, NULL, &dump->len);
+	dump->len = bnxt_get_coredump_length(bp, bp->dump_flag);
 	return 0;
 }
 
@@ -3994,15 +4016,7 @@ static int bnxt_get_dump_data(struct net_device *dev, struct ethtool_dump *dump,
 	memset(buf, 0, dump->len);
 
 	dump->flag = bp->dump_flag;
-	if (dump->flag == BNXT_DUMP_CRASH) {
-#ifdef CONFIG_TEE_BNXT_FW
-		return tee_bnxt_copy_coredump(buf, 0, dump->len);
-#endif
-	} else {
-		return bnxt_get_coredump(bp, buf, &dump->len);
-	}
-
-	return 0;
+	return bnxt_get_coredump(bp, dump->flag, buf, &dump->len);
 }
 
 static int bnxt_get_ts_info(struct net_device *dev,
-- 
2.18.1


--00000000000055f39305cf790df8
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
DQYJYIZIAWUDBAIBBQCggdQwLwYJKoZIhvcNAQkEMSIEIACMwbw2RnXGzJnXdeDJkugya3Th7pQJ
I9Ohf/0N9iLQMBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTIxMTAy
OTA3NDgyNVowaQYJKoZIhvcNAQkPMVwwWjALBglghkgBZQMEASowCwYJYIZIAWUDBAEWMAsGCWCG
SAFlAwQBAjAKBggqhkiG9w0DBzALBgkqhkiG9w0BAQowCwYJKoZIhvcNAQEHMAsGCWCGSAFlAwQC
ATANBgkqhkiG9w0BAQEFAASCAQC4iNAsv9mnh52xCglW6MZMGp28lHmtkoJreXR17BNAD0nLIjxw
uYyZDvFH4NNqw8UK0JyMG8n0RiavW2DRGFQQLmxdlq7Mce5WO/BBmHKKDcqOrb1P3pZHtaTiP7YV
wsuTeDPnSBVADwbBGBhVTYwozCPKLcKP+JapoZBxVrWRCe6OChTmaOLlk4ee/0QBdbWLDU5tCL5p
j7Av73hHMNLIdRWPwoITTqPDOv3p8ZEBCE0h5AD+ZuRHvPcVGGqczbfwPO2JF3QNlqf4OxYy6SRQ
OL7QZjkEhL+aPX5G9DTL5juf3Y6wCk3kcPPRKqitOIC870tUJkcS9pE7NSW4fMlU
--00000000000055f39305cf790df8--
