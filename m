Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 77E834E50C1
	for <lists+netdev@lfdr.de>; Wed, 23 Mar 2022 11:57:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243635AbiCWK6s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Mar 2022 06:58:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236170AbiCWK6p (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Mar 2022 06:58:45 -0400
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5FFD05F8CD
        for <netdev@vger.kernel.org>; Wed, 23 Mar 2022 03:57:16 -0700 (PDT)
Received: by mail-pg1-x52c.google.com with SMTP id z128so813323pgz.2
        for <netdev@vger.kernel.org>; Wed, 23 Mar 2022 03:57:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version;
        bh=cbE4kL7VCryp+0XBxWUBmI8bbdZbrOSKHdwl74h8AIc=;
        b=HBIRcCjOqea65d6IBWbNaHkSiDDQ57Xwj6Q7jtoirHe4XMNagiCahtcfwMYpUu0VfU
         QqbMPm/teFg0paVjGBBEFut6phDLlPTZ+o2O6j1Rm5JZkwkvB5ZOtPFkfAiDrRRGb53t
         Gq+qtaXZu7b+C5b+Hh9HjaAwaX57CJrfjKpj0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version;
        bh=cbE4kL7VCryp+0XBxWUBmI8bbdZbrOSKHdwl74h8AIc=;
        b=LnUPs4te8dJlgXJPptLwp/TDa0hMwQWdcUt7LUNdLiIHucZrkC80XtIcwIFldt0mfG
         qwwYzPQ6/b6v+nrGCb2aCdM39xU8QZYahOtB1v/7FGV8ERyD+nuTtdJ9XkIHYxeUsekl
         5Sqgds+rebmbPflVvTX7FPEyK/twv3t/igisRqeUS0Hijx2QUGJIwB+l6AyK+Dlxkr20
         Hkgqr7ypsDLKd6svt75lOujgWn00szl14EIlLtpUfpp6S7qKKSVGHVIDypKyWkYDXBG4
         iMPqtuNlSKyf4FGJMNIC19HFmt8vpaUlqMDdX75z0v+fTdVdPg7TUdBNKKcnq6NhzBOM
         SaHg==
X-Gm-Message-State: AOAM530GkYzHi5sWTURya85IIf5gkIRdVovxcwrPMy9m3q3cRIKG7GRS
        4hg0NMLHh24vRojMbGbLJiq07cwvAfsMXV0cBha3tf8wAf8egxHvlnt1/jSX6q0y25a4jJP82Ba
        DDCKL1lTELInejxIBGQZTmaRmIiPrv+ExxO10fIvW/F39niqY9E3RcljRqqtSR1OPbBhiOQ354+
        28cTWA++FOAg==
X-Google-Smtp-Source: ABdhPJwtSaWppfMG6wKHyuHOUT1iYYtoHkJ8pZTxzN7T5l3q+5QhN4whVDqkvE5ly0n4LH0pS7sK8g==
X-Received: by 2002:a05:6a00:1f08:b0:4fa:8a47:cf35 with SMTP id be8-20020a056a001f0800b004fa8a47cf35mr19432254pfb.22.1648033035520;
        Wed, 23 Mar 2022 03:57:15 -0700 (PDT)
Received: from localhost.localdomain ([192.19.250.250])
        by smtp.gmail.com with ESMTPSA id d11-20020aa7868b000000b004f768dfe93asm25535927pfo.176.2022.03.23.03.57.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Mar 2022 03:57:15 -0700 (PDT)
From:   Boris Sukholitko <boris.sukholitko@broadcom.com>
To:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        "Gustavo A . R . Silva" <gustavoars@kernel.org>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Eric Dumazet <edumazet@google.com>,
        zhang kai <zhangkaiheb@126.com>,
        Yoshiki Komachi <komachi.yoshiki@gmail.com>
Cc:     Ilya Lifshits <ilya.lifshits@broadcom.com>,
        Boris Sukholitko <boris.sukholitko@broadcom.com>
Subject: [PATCH net-next 2/5] Reduce identation after is_key_vlan refactoring
Date:   Wed, 23 Mar 2022 12:55:59 +0200
Message-Id: <20220323105602.30072-3-boris.sukholitko@broadcom.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20220323105602.30072-1-boris.sukholitko@broadcom.com>
References: <20220323105602.30072-1-boris.sukholitko@broadcom.com>
MIME-Version: 1.0
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="000000000000af52db05dae0971e"
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--000000000000af52db05dae0971e
Content-Transfer-Encoding: 8bit

Whitespace only.

Signed-off-by: Boris Sukholitko <boris.sukholitko@broadcom.com>
---
 net/sched/cls_flower.c | 30 +++++++++++++++---------------
 1 file changed, 15 insertions(+), 15 deletions(-)

diff --git a/net/sched/cls_flower.c b/net/sched/cls_flower.c
index 6c355b293f02..e073787dfd1d 100644
--- a/net/sched/cls_flower.c
+++ b/net/sched/cls_flower.c
@@ -1530,21 +1530,21 @@ static int fl_set_key(struct net *net, struct nlattr **tb,
 		       sizeof(key->eth.src));
 
 	if (is_vlan_key(tb[TCA_FLOWER_KEY_ETH_TYPE], &ethertype, key, mask)) {
-			fl_set_key_vlan(tb, ethertype, TCA_FLOWER_KEY_VLAN_ID,
-					TCA_FLOWER_KEY_VLAN_PRIO, &key->vlan,
-					&mask->vlan);
-
-			if (is_vlan_key(tb[TCA_FLOWER_KEY_VLAN_ETH_TYPE], &ethertype, key, mask)) {
-					fl_set_key_vlan(tb, ethertype,
-							TCA_FLOWER_KEY_CVLAN_ID,
-							TCA_FLOWER_KEY_CVLAN_PRIO,
-							&key->cvlan, &mask->cvlan);
-					fl_set_key_val(tb, &key->basic.n_proto,
-						       TCA_FLOWER_KEY_CVLAN_ETH_TYPE,
-						       &mask->basic.n_proto,
-						       TCA_FLOWER_UNSPEC,
-						       sizeof(key->basic.n_proto));
-			}
+		fl_set_key_vlan(tb, ethertype, TCA_FLOWER_KEY_VLAN_ID,
+				TCA_FLOWER_KEY_VLAN_PRIO, &key->vlan,
+				&mask->vlan);
+
+		if (is_vlan_key(tb[TCA_FLOWER_KEY_VLAN_ETH_TYPE], &ethertype, key, mask)) {
+			fl_set_key_vlan(tb, ethertype,
+					TCA_FLOWER_KEY_CVLAN_ID,
+					TCA_FLOWER_KEY_CVLAN_PRIO,
+					&key->cvlan, &mask->cvlan);
+			fl_set_key_val(tb, &key->basic.n_proto,
+				       TCA_FLOWER_KEY_CVLAN_ETH_TYPE,
+				       &mask->basic.n_proto,
+				       TCA_FLOWER_UNSPEC,
+				       sizeof(key->basic.n_proto));
+		}
 	}
 
 	if (key->basic.n_proto == htons(ETH_P_IP) ||
-- 
2.29.2


--000000000000af52db05dae0971e
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
riBJ/K1AFUjRAjFhGV64l++td7dkmnq/X8ET75ti+w1s4FRpFqkD2m7pg5NxdsZphYIXAgMBAAGj
QjBAMA4GA1UdDwEB/wQEAwIBBjAPBgNVHRMBAf8EBTADAQH/MB0GA1UdDgQWBBSP8Et/qC5FJK5N
UPpjmove4t0bvDANBgkqhkiG9w0BAQsFAAOCAQEAS0DbwFCq/sgM7/eWVEVJu5YACUGssxOGhigH
M8pr5nS5ugAtrqQK0/Xx8Q+Kv3NnSoPHRHt44K9ubG8DKY4zOUXDjuS5V2yq/BKW7FPGLeQkbLmU
Y/vcU2hnVj6DuM81IcPJaP7O2sJTqsyQiunwXUaMld16WCgaLx3ezQA3QY/tRG3XUyiXfvNnBB4V
14qWtNPeTCekTBtzc3b0F5nCH3oO4y0IrQocLP88q1UOD5F+NuvDV0m+4S4tfGCLw0FREyOdzvcy
a5QBqJnnLDMfOjsl0oZAzjsshnjJYS8Uuu7bVW/fhO4FCU29KNhyztNiUGUe65KXgzHZs7XKR1g/
XzCCBVgwggRAoAMCAQICDDSzinKpvcPTN4ZIJTANBgkqhkiG9w0BAQsFADBbMQswCQYDVQQGEwJC
RTEZMBcGA1UEChMQR2xvYmFsU2lnbiBudi1zYTExMC8GA1UEAxMoR2xvYmFsU2lnbiBHQ0MgUjMg
UGVyc29uYWxTaWduIDIgQ0EgMjAyMDAeFw0yMTAyMjIwNzMwMDRaFw0yMjA5MDUwNzM3NTVaMIGW
MQswCQYDVQQGEwJJTjESMBAGA1UECBMJS2FybmF0YWthMRIwEAYDVQQHEwlCYW5nYWxvcmUxFjAU
BgNVBAoTDUJyb2FkY29tIEluYy4xGTAXBgNVBAMTEEJvcmlzIFN1a2hvbGl0a28xLDAqBgkqhkiG
9w0BCQEWHWJvcmlzLnN1a2hvbGl0a29AYnJvYWRjb20uY29tMIIBIjANBgkqhkiG9w0BAQEFAAOC
AQ8AMIIBCgKCAQEAy/C7bjpxs+95egWV8sWrK9KO0SQi6Nxu14tJBgP+MOK5tvokizPFHoiXTymZ
7ClfnmbcqT4PzWgI3thyfk64bgUo1nQkCTApn7ov3IRsWjmHExLSNoJ/siUHagO6BPAk4JSycrj5
9tC9sL4FnIAbAHmOSILCyGyyaBAcmiyH/3toYqXyjJkK+vbWQSTxk2NlqJLIN/ypLJ1pYffVZGUs
52g1hlQtHhgLIznB1Qx3Fop3nOUk8nNpQLON/aM8K5sl18964c7aXh7YZnalUQv3md4p2rAQQqIR
rZ8HBc7YjlZynwOnZl1NrK4cP5aM9lMkbfRGIUitHTIhoDYp8IZ1dwIDAQABo4IB3jCCAdowDgYD
VR0PAQH/BAQDAgWgMIGjBggrBgEFBQcBAQSBljCBkzBOBggrBgEFBQcwAoZCaHR0cDovL3NlY3Vy
ZS5nbG9iYWxzaWduLmNvbS9jYWNlcnQvZ3NnY2NyM3BlcnNvbmFsc2lnbjJjYTIwMjAuY3J0MEEG
CCsGAQUFBzABhjVodHRwOi8vb2NzcC5nbG9iYWxzaWduLmNvbS9nc2djY3IzcGVyc29uYWxzaWdu
MmNhMjAyMDBNBgNVHSAERjBEMEIGCisGAQQBoDIBKAowNDAyBggrBgEFBQcCARYmaHR0cHM6Ly93
d3cuZ2xvYmFsc2lnbi5jb20vcmVwb3NpdG9yeS8wCQYDVR0TBAIwADBJBgNVHR8EQjBAMD6gPKA6
hjhodHRwOi8vY3JsLmdsb2JhbHNpZ24uY29tL2dzZ2NjcjNwZXJzb25hbHNpZ24yY2EyMDIwLmNy
bDAoBgNVHREEITAfgR1ib3Jpcy5zdWtob2xpdGtvQGJyb2FkY29tLmNvbTATBgNVHSUEDDAKBggr
BgEFBQcDBDAfBgNVHSMEGDAWgBSWM9HmWBdbNHWKgVZk1b5I3qGPzzAdBgNVHQ4EFgQUtBmGs9S4
t1FcFSfkrP2LKQQwBKMwDQYJKoZIhvcNAQELBQADggEBAJMAjVBkRmr1lvVvEjMaLfvMhwGpUfh6
CMZsKICyz/ZZmvTmIZNwy+7b9r6gjLCV4tP63tz4U72X9qJwfzldAlYLYWIq9e/DKDjwJRYlzN8H
979QJ0DHPSJ9EpvSKXob7Ci/FMkTfq1eOLjkPRF72mn8KPbHjeN3VVcn7oTe5IdIXaaZTryjM5Ud
bR7s0ZZh6mOhJtqk3k1L1DbDTVB4tOZXZHRDghEGaQSnwU/qxCNlvQ52fImLFVwXKPnw6+9dUvFR
ORaZ1pZbapCGbs/4QLplv8UaBmpFfK6MW/44zcsDbtCFfgIP3fEJBByIREhvRC5mtlRtdM+SSjgS
ZiNfUggxggJtMIICaQIBATBrMFsxCzAJBgNVBAYTAkJFMRkwFwYDVQQKExBHbG9iYWxTaWduIG52
LXNhMTEwLwYDVQQDEyhHbG9iYWxTaWduIEdDQyBSMyBQZXJzb25hbFNpZ24gMiBDQSAyMDIwAgw0
s4pyqb3D0zeGSCUwDQYJYIZIAWUDBAIBBQCggdQwLwYJKoZIhvcNAQkEMSIEIHSUNPdMN/e4JG8n
3c07q0/pqRKbgNyOlrYl40jRt1IqMBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcN
AQkFMQ8XDTIyMDMyMzEwNTcxNVowaQYJKoZIhvcNAQkPMVwwWjALBglghkgBZQMEASowCwYJYIZI
AWUDBAEWMAsGCWCGSAFlAwQBAjAKBggqhkiG9w0DBzALBgkqhkiG9w0BAQowCwYJKoZIhvcNAQEH
MAsGCWCGSAFlAwQCATANBgkqhkiG9w0BAQEFAASCAQBy2ZKPk4oeHokVIWz5LOgu6DiIx696zedG
rS3oVjwbaqIT0ErIQXHAb2ro0COEXbKrNLHh0nXR0mm5Ni1ta8toZF/EFSCvePaq0JYfG9/ks4GE
P8qW2fSR4BIwzdKU6PlRTCBmXblzw645Er/PEMSNJatRWFKW8IkhXLPPqgfOrT4Pq2wImFtdPmTz
vJfMxE48mCq8Ww+rXEyjTAxF8aKG01t6J6nsb1o8l5jG4YRkM/635d1K+au0G1eGfKBg7mEzU/Cf
u2k4HYFQI4qlTjyvi+daue68dd/0+hDiNOYpp0q3o4zpejnk7e+pQPv4iivMnTPwsJdpt/Bp2J0A
Tc2v
--000000000000af52db05dae0971e--
