Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BFE8A6C34A0
	for <lists+netdev@lfdr.de>; Tue, 21 Mar 2023 15:45:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231478AbjCUOpI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Mar 2023 10:45:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231342AbjCUOpG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Mar 2023 10:45:06 -0400
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8105AB458
        for <netdev@vger.kernel.org>; Tue, 21 Mar 2023 07:45:04 -0700 (PDT)
Received: by mail-pl1-x629.google.com with SMTP id iw3so16254838plb.6
        for <netdev@vger.kernel.org>; Tue, 21 Mar 2023 07:45:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1679409903;
        h=mime-version:references:in-reply-to:message-id:date:subject:cc:to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=u4MW3tSZzUQ5IMGV2vXdYAEiBarTCXWuP4tSK4aEPBk=;
        b=NZl1Pf0vrZXbYTte5NVVz6TRi+OIoW25d0LVV2ILTqz8j7fLGgtnCpzma9H7b+VyN9
         SNl6PoaDGNGe30HvyZ2CNbg5Y9Zl7QkvF9R5fnFT/R3js2ElUGYMQwu3meGQiv0aJMJF
         Qngs0hxLqGC8taO1bgrNOCQBHi7hiLKVPnvuk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679409903;
        h=mime-version:references:in-reply-to:message-id:date:subject:cc:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=u4MW3tSZzUQ5IMGV2vXdYAEiBarTCXWuP4tSK4aEPBk=;
        b=4GEdlS7s/Cgw/G5Wnx6TFbqS6M+YOImKyPeU5hglbYSCo4WC5LU+U/pGe7/6nIaBnj
         jdiLTAvw5qkLDQAGBahpOOFHtdy0c/+sIeZBuJP/CL3XvYU63TJAIgw/LEi1u5RRAP0k
         fbDYA1zaLErtMOFw/jbcFnWjmBTTyhMLIHvQI/kwe7jfG/YMgFVkfb0bMMQnJHflcqsp
         ikVBBTLi63abnvVKgqBySE/wm68XShvaAA/Zk2cyg2QbZRVUgPLR78iHH4ndSLpNUkR0
         XNuRbrRGbkSP8Sg5WNhJJVbFw8lXJ6FVfFsqN0maP9bLbLifYZah1uctUcBZxqugO2yE
         hXlQ==
X-Gm-Message-State: AO0yUKW6010i4xH2xpkgssHhFQxvDwrEZ4x30IQsyz+CqnbSy7ALrtmr
        43oz2cohep7UuGmWDFu8TIAbUQ==
X-Google-Smtp-Source: AK7set9kUxhPgaDJ3YaDFdJsnkL9ruwtmlDksDR5+ji1G/8Cvrc6Aj7FkKCQzYXt0gogOIrTeZRN9g==
X-Received: by 2002:a17:902:d50a:b0:1a1:e237:5f0 with SMTP id b10-20020a170902d50a00b001a1e23705f0mr3178848plg.58.1679409903340;
        Tue, 21 Mar 2023 07:45:03 -0700 (PDT)
Received: from PC-MID-R740.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id h13-20020a170902f7cd00b0019d1f42b00csm8834243plw.17.2023.03.21.07.45.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Mar 2023 07:45:03 -0700 (PDT)
From:   Pavan Chebbi <pavan.chebbi@broadcom.com>
To:     michael.chan@broadcom.com, kuba@kernel.org
Cc:     davem@davemloft.net, edumazet@google.com, gospo@broadcom.com,
        netdev@vger.kernel.org, pabeni@redhat.com,
        richardcochran@gmail.com, Pavan Chebbi <pavan.chebbi@broadcom.com>,
        Edwin Peer <edwin.peer@broadcom.com>
Subject: [PATCH net-next v2 1/3] bnxt: Change fw_cap to u64 to accommodate more capability bits
Date:   Tue, 21 Mar 2023 07:44:47 -0700
Message-Id: <20230321144449.15289-2-pavan.chebbi@broadcom.com>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230321144449.15289-1-pavan.chebbi@broadcom.com>
References: <20230321144449.15289-1-pavan.chebbi@broadcom.com>
MIME-Version: 1.0
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="000000000000be19df05f76a164e"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,UPPERCASE_50_75,URIBL_BLOCKED autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--000000000000be19df05f76a164e
Content-Transfer-Encoding: 8bit

The current fw_cap field (u32) has run out of bits to save any
new capability.

Change the field to u64.

Signed-off-by: Pavan Chebbi <pavan.chebbi@broadcom.com>
Reviewed-by: Edwin Peer <edwin.peer@broadcom.com>
Reviewed-by: Michael Chan <michael.chan@broadcom.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.h | 56 +++++++++++------------
 1 file changed, 28 insertions(+), 28 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.h b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
index c0628ac1b798..d7eb0d244f42 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.h
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
@@ -1968,34 +1968,34 @@ struct bnxt {
 
 	u32			msg_enable;
 
-	u32			fw_cap;
-	#define BNXT_FW_CAP_SHORT_CMD			0x00000001
-	#define BNXT_FW_CAP_LLDP_AGENT			0x00000002
-	#define BNXT_FW_CAP_DCBX_AGENT			0x00000004
-	#define BNXT_FW_CAP_NEW_RM			0x00000008
-	#define BNXT_FW_CAP_IF_CHANGE			0x00000010
-	#define BNXT_FW_CAP_KONG_MB_CHNL		0x00000080
-	#define BNXT_FW_CAP_OVS_64BIT_HANDLE		0x00000400
-	#define BNXT_FW_CAP_TRUSTED_VF			0x00000800
-	#define BNXT_FW_CAP_ERROR_RECOVERY		0x00002000
-	#define BNXT_FW_CAP_PKG_VER			0x00004000
-	#define BNXT_FW_CAP_CFA_ADV_FLOW		0x00008000
-	#define BNXT_FW_CAP_CFA_RFS_RING_TBL_IDX_V2	0x00010000
-	#define BNXT_FW_CAP_PCIE_STATS_SUPPORTED	0x00020000
-	#define BNXT_FW_CAP_EXT_STATS_SUPPORTED		0x00040000
-	#define BNXT_FW_CAP_RSS_HASH_TYPE_DELTA		0x00080000
-	#define BNXT_FW_CAP_ERR_RECOVER_RELOAD		0x00100000
-	#define BNXT_FW_CAP_HOT_RESET			0x00200000
-	#define BNXT_FW_CAP_PTP_RTC			0x00400000
-	#define BNXT_FW_CAP_RX_ALL_PKT_TS		0x00800000
-	#define BNXT_FW_CAP_VLAN_RX_STRIP		0x01000000
-	#define BNXT_FW_CAP_VLAN_TX_INSERT		0x02000000
-	#define BNXT_FW_CAP_EXT_HW_STATS_SUPPORTED	0x04000000
-	#define BNXT_FW_CAP_LIVEPATCH			0x08000000
-	#define BNXT_FW_CAP_PTP_PPS			0x10000000
-	#define BNXT_FW_CAP_HOT_RESET_IF		0x20000000
-	#define BNXT_FW_CAP_RING_MONITOR		0x40000000
-	#define BNXT_FW_CAP_DBG_QCAPS			0x80000000
+	u64			fw_cap;
+	#define BNXT_FW_CAP_SHORT_CMD			BIT_ULL(0)
+	#define BNXT_FW_CAP_LLDP_AGENT			BIT_ULL(1)
+	#define BNXT_FW_CAP_DCBX_AGENT			BIT_ULL(2)
+	#define BNXT_FW_CAP_NEW_RM			BIT_ULL(3)
+	#define BNXT_FW_CAP_IF_CHANGE			BIT_ULL(4)
+	#define BNXT_FW_CAP_KONG_MB_CHNL		BIT_ULL(7)
+	#define BNXT_FW_CAP_OVS_64BIT_HANDLE		BIT_ULL(10)
+	#define BNXT_FW_CAP_TRUSTED_VF			BIT_ULL(11)
+	#define BNXT_FW_CAP_ERROR_RECOVERY		BIT_ULL(13)
+	#define BNXT_FW_CAP_PKG_VER			BIT_ULL(14)
+	#define BNXT_FW_CAP_CFA_ADV_FLOW		BIT_ULL(15)
+	#define BNXT_FW_CAP_CFA_RFS_RING_TBL_IDX_V2	BIT_ULL(16)
+	#define BNXT_FW_CAP_PCIE_STATS_SUPPORTED	BIT_ULL(17)
+	#define BNXT_FW_CAP_EXT_STATS_SUPPORTED		BIT_ULL(18)
+	#define BNXT_FW_CAP_RSS_HASH_TYPE_DELTA		BIT_ULL(19)
+	#define BNXT_FW_CAP_ERR_RECOVER_RELOAD		BIT_ULL(20)
+	#define BNXT_FW_CAP_HOT_RESET			BIT_ULL(21)
+	#define BNXT_FW_CAP_PTP_RTC			BIT_ULL(22)
+	#define BNXT_FW_CAP_RX_ALL_PKT_TS		BIT_ULL(23)
+	#define BNXT_FW_CAP_VLAN_RX_STRIP		BIT_ULL(24)
+	#define BNXT_FW_CAP_VLAN_TX_INSERT		BIT_ULL(25)
+	#define BNXT_FW_CAP_EXT_HW_STATS_SUPPORTED	BIT_ULL(26)
+	#define BNXT_FW_CAP_LIVEPATCH			BIT_ULL(27)
+	#define BNXT_FW_CAP_PTP_PPS			BIT_ULL(28)
+	#define BNXT_FW_CAP_HOT_RESET_IF		BIT_ULL(29)
+	#define BNXT_FW_CAP_RING_MONITOR		BIT_ULL(30)
+	#define BNXT_FW_CAP_DBG_QCAPS			BIT_ULL(31)
 
 	u32			fw_dbg_cap;
 
-- 
2.39.1


--000000000000be19df05f76a164e
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
OltyqaGBuzv+bJTUL+bmV7E4QBLIqGt4jVr1R9hJdH6KxXwJdyfHZ9C6qXmoe2NQhiFUyBOJ0wgk
dB9Z1IU7nCwvNKYg2JMoJs93tIgbhPJg/D7pqW8gabkCAwEAAaOCAdowggHWMA4GA1UdDwEB/wQE
AwIFoDCBowYIKwYBBQUHAQEEgZYwgZMwTgYIKwYBBQUHMAKGQmh0dHA6Ly9zZWN1cmUuZ2xvYmFs
c2lnbi5jb20vY2FjZXJ0L2dzZ2NjcjNwZXJzb25hbHNpZ24yY2EyMDIwLmNydDBBBggrBgEFBQcw
AYY1aHR0cDovL29jc3AuZ2xvYmFsc2lnbi5jb20vZ3NnY2NyM3BlcnNvbmFsc2lnbjJjYTIwMjAw
TQYDVR0gBEYwRDBCBgorBgEEAaAyASgKMDQwMgYIKwYBBQUHAgEWJmh0dHBzOi8vd3d3Lmdsb2Jh
bHNpZ24uY29tL3JlcG9zaXRvcnkvMAkGA1UdEwQCMAAwSQYDVR0fBEIwQDA+oDygOoY4aHR0cDov
L2NybC5nbG9iYWxzaWduLmNvbS9nc2djY3IzcGVyc29uYWxzaWduMmNhMjAyMC5jcmwwJAYDVR0R
BB0wG4EZcGF2YW4uY2hlYmJpQGJyb2FkY29tLmNvbTATBgNVHSUEDDAKBggrBgEFBQcDBDAfBgNV
HSMEGDAWgBSWM9HmWBdbNHWKgVZk1b5I3qGPzzAdBgNVHQ4EFgQUEV6y/89alKPoFbKUaJXsvWu5
fdowDQYJKoZIhvcNAQELBQADggEBAEHSIB6g652wVb+r2YCmfHW47Jo+5TuCBD99Hla8PYhaWGkd
9HIyD3NPhb6Vb6vtMWJW4MFGQF42xYRrAS4LZj072DuMotr79rI09pbOiWg0FlRRFt6R9vgUgebu
pWSH7kmwVXcPtY94XSMMak4b7RSKig2mKbHDpD4bC7eGlwl5RxzYkgrHtMNRmHmQor5Nvqe52cFJ
25Azqtwvjt5nbrEd81iBmboNTEnLaKuxbbCtLaMEP8xKeDjAKnNOqHUMps0AsQT8c0EGq39YHpjp
Wn1l67VU0rMShbEFsiUf9WYgE677oinpdm0t2mdCjxr35tryxptoTZXKHDxr/Yy6l6ExggJtMIIC
aQIBATBrMFsxCzAJBgNVBAYTAkJFMRkwFwYDVQQKExBHbG9iYWxTaWduIG52LXNhMTEwLwYDVQQD
EyhHbG9iYWxTaWduIEdDQyBSMyBQZXJzb25hbFNpZ24gMiBDQSAyMDIwAgwV/XkICjVscn4SNZMw
DQYJYIZIAWUDBAIBBQCggdQwLwYJKoZIhvcNAQkEMSIEIClJH4OVJg0iwdKguDpU65MzG0UxqUN3
YL/K/c16oDbxMBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTIzMDMy
MTE0NDUwM1owaQYJKoZIhvcNAQkPMVwwWjALBglghkgBZQMEASowCwYJYIZIAWUDBAEWMAsGCWCG
SAFlAwQBAjAKBggqhkiG9w0DBzALBgkqhkiG9w0BAQowCwYJKoZIhvcNAQEHMAsGCWCGSAFlAwQC
ATANBgkqhkiG9w0BAQEFAASCAQCDvKodrvkl5Of6L2GBD4WZh+Q4yR/cKDKULhfKjYCBbswvn6jE
rSqlH4DBjpir/lkTINUy5hTVDUKGG2XrnKNjQSJxsipsi2xDmY/e0IDpF3GW/xzWigA8VvOMHU4c
0vV8+wAyDtpdLjCP4+SH/dcFhE+hc4nx425pSXyVkA4/xeMHQ5mduklMBmcm3s1BaEbOcBq6tnSI
W7H7+QL6wS/1eP/QyGl5rsjBJe3JnJaj7KfpXCrejuWZXcCRTerd+blbbrDUibkMmAXtJf+bPWtB
Evw33Kz1FWtNHmxBABX0HSqUF0Et1K6O/VCydE+aaILUlg7LQXQjeuxtfXYNAmeq
--000000000000be19df05f76a164e--
