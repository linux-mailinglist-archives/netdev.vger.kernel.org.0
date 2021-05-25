Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9561839059C
	for <lists+netdev@lfdr.de>; Tue, 25 May 2021 17:38:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234239AbhEYPjl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 May 2021 11:39:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232078AbhEYPjl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 May 2021 11:39:41 -0400
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A728C061574
        for <netdev@vger.kernel.org>; Tue, 25 May 2021 08:38:11 -0700 (PDT)
Received: by mail-pf1-x42f.google.com with SMTP id 22so23514594pfv.11
        for <netdev@vger.kernel.org>; Tue, 25 May 2021 08:38:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version;
        bh=ogsn444GQIucWh30gOBxNOOapMKLZy9nSGJLZxW0+Sk=;
        b=egaFYLiPTPXLuhx/+ef6YEifISRTpDR/hASJppy70kk1fQOhpGAAPUTy86CwaE8XHg
         xWUctMrgBHmXjQo012iDZPoH/CQ+RKVyVvougpWKfrdqdmnBeH80xeFXPMmjqdDmKvyS
         Cx79BrCkVwThXmBxAw193Iw8j+m0mqfPdosoU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version;
        bh=ogsn444GQIucWh30gOBxNOOapMKLZy9nSGJLZxW0+Sk=;
        b=tWVkxlfsuSo9N7sMFcZ+7gNNqaM77ub0HKEO/d/YloBvuOscxK708NTzJsxCe/tGih
         vMsst3rZqD7dd4xKXIWnBo2eU2hiILUXf3cXN0wSjOshhfFCzTV7F3ZZ/p7A+3/GZYPJ
         o6aQEE/+OYhWepOTd64jtbZsjt/b2z/Hmv1x8yLJHeGK8xml9jg2zNQZfF6RSwVfXpS+
         hqtrRaN0oPmqXFH+y0KapRhMNFwBbt+zbynvTY2sTFnB1s2/iy1K+TuWcBJd2tD/+c82
         m728jsspD2BebEuQdcTHR4DtoUByS50us5GX1YEBI4Z0B6wk61RorVRfdlKb3NWT7Rw6
         ahxQ==
X-Gm-Message-State: AOAM530xKDxKCsbM1X3UT9bgfH0sDi8EDdy+EyhTWHTqjeNxci4PsFrs
        c4q61d0Ct23h22OwFUOR6K+YCcMpY+dQyjYJiB+xJjJKd7HdIg+qinTxlxWtIcwCNTmQQAQaoFU
        nA+V6jBjhYGLYmMrkTYaJ+KbgxdkYf8VpGFUEQgcuoZhoGrFf35+G62MOTqxQDXxzYV+AR80WhO
        d/sOJt+FU=
X-Google-Smtp-Source: ABdhPJyIZlm+bV4Z0Tb8MvthgcxEf1eB5Q1Y34Dxkni0d4SUXk5BRl96m97JODQXnKemy3GX4K23eQ==
X-Received: by 2002:a63:d245:: with SMTP id t5mr19462103pgi.172.1621957090623;
        Tue, 25 May 2021 08:38:10 -0700 (PDT)
Received: from localhost.localdomain ([192.19.250.250])
        by smtp.gmail.com with ESMTPSA id f14sm13388369pjq.50.2021.05.25.08.38.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 May 2021 08:38:10 -0700 (PDT)
From:   Boris Sukholitko <boris.sukholitko@broadcom.com>
To:     netdev@vger.kernel.org, Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Cong Wang <xiyou.wangcong@gmail.com>
Cc:     Ilya Lifshits <ilya.lifshits@broadcom.com>,
        Shmulik Ladkani <shmulik.ladkani@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Davide Caratti <dcaratti@redhat.com>,
        Boris Sukholitko <boris.sukholitko@broadcom.com>
Subject: [PATCH net-next v2 2/3] net/sched: act_vlan: No dump for unset priority
Date:   Tue, 25 May 2021 18:36:00 +0300
Message-Id: <20210525153601.6705-3-boris.sukholitko@broadcom.com>
X-Mailer: git-send-email 2.29.3
In-Reply-To: <20210525153601.6705-1-boris.sukholitko@broadcom.com>
References: <20210525153601.6705-1-boris.sukholitko@broadcom.com>
MIME-Version: 1.0
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="0000000000003fe34105c32950ef"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--0000000000003fe34105c32950ef
Content-Transfer-Encoding: 8bit

Dump vlan priority only if it has been previously set.

Fix the tests accordingly.

Signed-off-by: Boris Sukholitko <boris.sukholitko@broadcom.com>
---
 net/sched/act_vlan.c                           |  4 ++--
 .../tc-testing/tc-tests/actions/vlan.json      | 18 +++++++++---------
 2 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/net/sched/act_vlan.c b/net/sched/act_vlan.c
index cca10b5e99c9..6765096b99b3 100644
--- a/net/sched/act_vlan.c
+++ b/net/sched/act_vlan.c
@@ -307,8 +307,8 @@ static int tcf_vlan_dump(struct sk_buff *skb, struct tc_action *a,
 	    (nla_put_u16(skb, TCA_VLAN_PUSH_VLAN_ID, p->tcfv_push_vid) ||
 	     nla_put_be16(skb, TCA_VLAN_PUSH_VLAN_PROTOCOL,
 			  p->tcfv_push_proto) ||
-	     (nla_put_u8(skb, TCA_VLAN_PUSH_VLAN_PRIORITY,
-					      p->tcfv_push_prio))))
+	     (p->tcfv_push_prio_exists &&
+	      nla_put_u8(skb, TCA_VLAN_PUSH_VLAN_PRIORITY, p->tcfv_push_prio))))
 		goto nla_put_failure;
 
 	if (p->tcfv_action == TCA_VLAN_ACT_PUSH_ETH) {
diff --git a/tools/testing/selftests/tc-testing/tc-tests/actions/vlan.json b/tools/testing/selftests/tc-testing/tc-tests/actions/vlan.json
index 41d783254b08..4675f1c04d17 100644
--- a/tools/testing/selftests/tc-testing/tc-tests/actions/vlan.json
+++ b/tools/testing/selftests/tc-testing/tc-tests/actions/vlan.json
@@ -297,7 +297,7 @@
         "cmdUnderTest": "$TC actions add action vlan push id 123 index 18",
         "expExitCode": "0",
         "verifyCmd": "$TC actions get action vlan index 18",
-        "matchPattern": "action order [0-9]+: vlan.*push id 123 protocol 802.1Q priority 0 pipe.*index 18 ref",
+        "matchPattern": "action order [0-9]+: vlan.*push id 123 protocol 802.1Q pipe.*index 18 ref",
         "matchCount": "1",
         "teardown": [
             "$TC actions flush action vlan"
@@ -345,7 +345,7 @@
         "cmdUnderTest": "$TC actions add action vlan push id 1024 protocol 802.1AD pass index 10000",
         "expExitCode": "0",
         "verifyCmd": "$TC actions get action vlan index 10000",
-        "matchPattern": "action order [0-9]+: vlan.*push id 1024 protocol 802.1ad priority 0 pass.*index 10000 ref",
+        "matchPattern": "action order [0-9]+: vlan.*push id 1024 protocol 802.1ad pass.*index 10000 ref",
         "matchCount": "1",
         "teardown": [
             "$TC actions flush action vlan"
@@ -369,7 +369,7 @@
         "cmdUnderTest": "$TC actions add action vlan push id 4094 index 1",
         "expExitCode": "0",
         "verifyCmd": "$TC actions get action vlan index 1",
-        "matchPattern": "action order [0-9]+: vlan.*push id 4094.*protocol 802.1Q.*priority 0.*index 1 ref",
+        "matchPattern": "action order [0-9]+: vlan.*push id 4094.*protocol 802.1Q.*index 1 ref",
         "matchCount": "1",
         "teardown": [
             "$TC actions flush action vlan"
@@ -463,7 +463,7 @@
         "cmdUnderTest": "$TC actions add action vlan modify protocol 802.1Q id 5 index 100",
         "expExitCode": "0",
         "verifyCmd": "$TC actions get action vlan index 100",
-        "matchPattern": "action order [0-9]+: vlan.*modify id 100 protocol 802.1Q priority 0 pipe.*index 100 ref",
+        "matchPattern": "action order [0-9]+: vlan.*modify id 100 protocol 802.1Q pipe.*index 100 ref",
         "matchCount": "0",
         "teardown": [
             "$TC actions flush action vlan"
@@ -487,7 +487,7 @@
         "cmdUnderTest": "$TC actions add action vlan modify protocol 802.1ad id 500 reclassify index 12",
         "expExitCode": "0",
         "verifyCmd": "$TC actions get action vlan index 12",
-        "matchPattern": "action order [0-9]+: vlan.*modify id 500 protocol 802.1ad priority 0 reclassify.*index 12 ref",
+        "matchPattern": "action order [0-9]+: vlan.*modify id 500 protocol 802.1ad reclassify.*index 12 ref",
         "matchCount": "1",
         "teardown": [
             "$TC actions flush action vlan"
@@ -512,7 +512,7 @@
         "cmdUnderTest": "$TC actions replace action vlan push id 700 pipe index 12",
         "expExitCode": "0",
         "verifyCmd": "$TC actions get action vlan index 12",
-        "matchPattern": "action order [0-9]+: vlan.*push id 700 protocol 802.1Q priority 0 pipe.*index 12 ref",
+        "matchPattern": "action order [0-9]+: vlan.*push id 700 protocol 802.1Q pipe.*index 12 ref",
         "matchCount": "1",
         "teardown": [
             "$TC actions flush action vlan"
@@ -537,7 +537,7 @@
         "cmdUnderTest": "$TC actions replace action vlan push id 1 protocol 802.1ad pipe index 1",
         "expExitCode": "0",
         "verifyCmd": "$TC actions get action vlan index 1",
-        "matchPattern": "action order [0-9]+: vlan.*push id 1 protocol 802.1ad priority 0 pipe.*index 1 ref",
+        "matchPattern": "action order [0-9]+: vlan.*push id 1 protocol 802.1ad pipe.*index 1 ref",
         "matchCount": "1",
         "teardown": [
             "$TC actions flush action vlan"
@@ -635,7 +635,7 @@
         "cmdUnderTest": "$TC actions del action vlan index 999",
         "expExitCode": "0",
         "verifyCmd": "$TC actions list action vlan",
-        "matchPattern": "action order [0-9]+: vlan.*push id 4094 protocol 802.1Q priority 0 pipe.*index 999 ref",
+        "matchPattern": "action order [0-9]+: vlan.*push id 4094 protocol 802.1Q pipe.*index 999 ref",
         "matchCount": "0",
         "teardown": []
     },
@@ -708,7 +708,7 @@
         "cmdUnderTest": "$TC actions replace action vlan push id 500 goto chain 42 index 90 cookie c1a0c1a0",
         "expExitCode": "255",
         "verifyCmd": "$TC actions get action vlan index 90",
-        "matchPattern": "action order [0-9]+: vlan.*push id 500 protocol 802.1Q priority 0 pass.*index 90 ref",
+        "matchPattern": "action order [0-9]+: vlan.*push id 500 protocol 802.1Q pass.*index 90 ref",
         "matchCount": "1",
         "teardown": [
             "$TC actions flush action vlan"
-- 
2.29.3


--0000000000003fe34105c32950ef
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
s4pyqb3D0zeGSCUwDQYJYIZIAWUDBAIBBQCggdQwLwYJKoZIhvcNAQkEMSIEIMJ/uLx3DTJvsftX
0L+1LaUEGpKbIJ6Yyy0MLTthAjSOMBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcN
AQkFMQ8XDTIxMDUyNTE1MzgxMFowaQYJKoZIhvcNAQkPMVwwWjALBglghkgBZQMEASowCwYJYIZI
AWUDBAEWMAsGCWCGSAFlAwQBAjAKBggqhkiG9w0DBzALBgkqhkiG9w0BAQowCwYJKoZIhvcNAQEH
MAsGCWCGSAFlAwQCATANBgkqhkiG9w0BAQEFAASCAQCWsBZ9uKq+DPgV797xwb1jeYFNiJLQC+Dt
9wfJzuGOPexOHTq3+XPU5s0DJ4060Xe6Z4OdDGazCZzD0miIbU5Rs9+h6xkNJ1Ht9k/e816srMM/
JjkowBUpxqpIVRBaGZZFDsLyWFVHwxxArA9qKAXis8VXIU0O4SJlWXsgYgEUIWU9IDKNXFlTf9Qz
Qi85bpYldmlGmoLZ6iQ9mSB/bFIiEyBzKLfBjlXwIl7ocAbDA9NYAYKpqPAnCM5yCHMmVTm526I3
FNPCPbAcIJQOuRntw6nmcd30u+WN4HODgCjShaMvVUetWXuwKMxFjXLxzLhKg06rBqKe0m0W+U/J
MBdn
--0000000000003fe34105c32950ef--
