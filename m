Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 146643950B1
	for <lists+netdev@lfdr.de>; Sun, 30 May 2021 13:41:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229813AbhE3Ln0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 30 May 2021 07:43:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229810AbhE3LnZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 30 May 2021 07:43:25 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE3E5C061574
        for <netdev@vger.kernel.org>; Sun, 30 May 2021 04:41:47 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id b15-20020a17090a550fb029015dad75163dso5099314pji.0
        for <netdev@vger.kernel.org>; Sun, 30 May 2021 04:41:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version;
        bh=YPiZ+Ti+hk3NrozLRodgguH6djqTkuizz+c1SHc/lbQ=;
        b=JfGhJiFyXqmemoqcI7xMJXp5HdLZHtLNREUwOOcIASL/27RBOdbHfDr29IGlRrivi1
         KlIUmCxOzCwUFmpjLRXLMjLVGXmbeLY9xFcbE0TSc+mGipcEt1RhxZxHD7P3P3JPAI7+
         VYFbIRhohJLYiLNVfvzHOnvrJIDXboA01QgUc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version;
        bh=YPiZ+Ti+hk3NrozLRodgguH6djqTkuizz+c1SHc/lbQ=;
        b=lpMs3L3zoBxIayg/CecAzKPFHMLpLP8IeRFMn0dYF7NvJHP6B2OBPmFZGwvBPt2YWn
         OfBLUTZvTGo9KwXD3lHqGtEqFkvVj306hEN/OOfPrdg9vnO1yp6GXWgRxTeRFkkhF1OP
         uzG8WhVmaaKYDCJA+prKnDsQg+nm98uVQsqXGPEIs9uWzHb5KAFTqLAb85zMDig4xij2
         d0TEAF+TwMhXobZxwUrGPCGHYOZnKYD/bMkCIdS7JE4cvqxWvBMf7O7Y+0Ht2BZMU/K6
         Tigz/B192r22h3W3L+yXd/jhmdEos3vn9W63ofopXcKjcOO3xDtmoEeiEQs3aDkrjLLP
         8pEQ==
X-Gm-Message-State: AOAM532ojBO9ZTQQ2YrprktDxdzBCnqReHLRDPt/5pFhOmq/+u2dtUSm
        dfVQdywxxOHDxoZIs6XX4U0Z04jimxQavteJP+nOmUvkV7rFBiszyhi2qDBJtRNNz7+3Fw+0UKr
        9N7DO16MY18bG213ja57PvrGn+Ng08G3TVZcqIaCzDn0fLMKvqx7h7yV3OEWAooKuVea1nMEfiA
        goMU8M1iM=
X-Google-Smtp-Source: ABdhPJwfEE/JdsLGRjkYlwdc4OtTscgN37CdPC+Rqws+UNJAHfIj3wB4y7QYKw667gfROrwtmo/TtA==
X-Received: by 2002:a17:902:c3d5:b029:100:742f:fce9 with SMTP id j21-20020a170902c3d5b0290100742ffce9mr12363207plj.46.1622374906752;
        Sun, 30 May 2021 04:41:46 -0700 (PDT)
Received: from localhost.localdomain ([192.19.250.250])
        by smtp.gmail.com with ESMTPSA id o17sm8126093pjp.33.2021.05.30.04.41.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 30 May 2021 04:41:46 -0700 (PDT)
From:   Boris Sukholitko <boris.sukholitko@broadcom.com>
To:     netdev@vger.kernel.org, Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Cong Wang <xiyou.wangcong@gmail.com>
Cc:     linux-kselftest@vger.kernel.org, shuah@kernel.org,
        Ilya Lifshits <ilya.lifshits@broadcom.com>,
        Shmulik Ladkani <shmulik.ladkani@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Davide Caratti <dcaratti@redhat.com>,
        Boris Sukholitko <boris.sukholitko@broadcom.com>
Subject: [PATCH net-next v3 2/3] net/sched: act_vlan: No dump for unset priority
Date:   Sun, 30 May 2021 14:40:51 +0300
Message-Id: <20210530114052.16483-3-boris.sukholitko@broadcom.com>
X-Mailer: git-send-email 2.29.3
In-Reply-To: <20210530114052.16483-1-boris.sukholitko@broadcom.com>
References: <20210530114052.16483-1-boris.sukholitko@broadcom.com>
MIME-Version: 1.0
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="0000000000000866d205c38a98f7"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--0000000000000866d205c38a98f7
Content-Transfer-Encoding: 8bit

Dump vlan priority only if it has been previously set.

Fix the tests accordingly.

Signed-off-by: Boris Sukholitko <boris.sukholitko@broadcom.com>
---
 net/sched/act_vlan.c                          | 19 ++++++++++++++-----
 .../tc-testing/tc-tests/actions/vlan.json     |  4 ++--
 2 files changed, 16 insertions(+), 7 deletions(-)

diff --git a/net/sched/act_vlan.c b/net/sched/act_vlan.c
index a108469c664f..ccd1acfa4c55 100644
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
@@ -362,10 +362,19 @@ static int tcf_vlan_search(struct net *net, struct tc_action **a, u32 index)
 
 static size_t tcf_vlan_get_fill_size(const struct tc_action *act)
 {
-	return nla_total_size(sizeof(struct tc_vlan))
+	struct tcf_vlan *v = to_vlan(act);
+	struct tcf_vlan_params *p;
+	size_t ret = nla_total_size(sizeof(struct tc_vlan))
 		+ nla_total_size(sizeof(u16)) /* TCA_VLAN_PUSH_VLAN_ID */
-		+ nla_total_size(sizeof(u16)) /* TCA_VLAN_PUSH_VLAN_PROTOCOL */
-		+ nla_total_size(sizeof(u8)); /* TCA_VLAN_PUSH_VLAN_PRIORITY */
+		+ nla_total_size(sizeof(u16)); /* TCA_VLAN_PUSH_VLAN_PROTOCOL */
+
+	spin_lock_bh(&v->tcf_lock);
+	p = rcu_dereference_protected(v->vlan_p, lockdep_is_held(&v->tcf_lock));
+	if (p->tcfv_push_prio_exists)
+		ret += nla_total_size(sizeof(u8)); /* TCA_VLAN_PUSH_VLAN_PRIORITY */
+	spin_unlock_bh(&v->tcf_lock);
+
+	return ret;
 }
 
 static struct tc_action_ops act_vlan_ops = {
diff --git a/tools/testing/selftests/tc-testing/tc-tests/actions/vlan.json b/tools/testing/selftests/tc-testing/tc-tests/actions/vlan.json
index 527ce5410314..1d9d261aa0b3 100644
--- a/tools/testing/selftests/tc-testing/tc-tests/actions/vlan.json
+++ b/tools/testing/selftests/tc-testing/tc-tests/actions/vlan.json
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
-- 
2.29.3


--0000000000000866d205c38a98f7
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
s4pyqb3D0zeGSCUwDQYJYIZIAWUDBAIBBQCggdQwLwYJKoZIhvcNAQkEMSIEIG6GvFdh+IL9ejkA
ZJNitjlSRa52sy8o1i6p8Jj7jbLTMBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcN
AQkFMQ8XDTIxMDUzMDExNDE0N1owaQYJKoZIhvcNAQkPMVwwWjALBglghkgBZQMEASowCwYJYIZI
AWUDBAEWMAsGCWCGSAFlAwQBAjAKBggqhkiG9w0DBzALBgkqhkiG9w0BAQowCwYJKoZIhvcNAQEH
MAsGCWCGSAFlAwQCATANBgkqhkiG9w0BAQEFAASCAQCKZhucakRsYy6hXqttzDMbQwi3vSxLa/xO
arT8FrXD8JrZiWnxaOuW8+GNzKDWMM4fBCgPC7H/K44TzQdQXD+aHj/m6i4pyYt/so/WBy7smy9a
wUvNJDvpmrF2WDwzujeoh7N5bdcbDTxjEbTVogjyj8fp3710hDsWxJ/eqK2czzUwMs2rvX+0b5lE
85Ct1evkX2TvxCCwbvib9BWOwmLeMk5K+dQI1g/ETJDWukDtXJkXyerBUpfSMhTjQ1r0KXcG6QmA
Whu9K7koQksDYIeV9uaO1sq+FimeSvkEvZh7vOeo7pK4pwvSHbIQnWlVFEqJVPQ9XGwLx3f0HlPY
HpvN
--0000000000000866d205c38a98f7--
