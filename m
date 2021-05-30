Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 644003950AD
	for <lists+netdev@lfdr.de>; Sun, 30 May 2021 13:41:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229640AbhE3LnE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 30 May 2021 07:43:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229580AbhE3LnD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 30 May 2021 07:43:03 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86152C061574
        for <netdev@vger.kernel.org>; Sun, 30 May 2021 04:41:25 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id ot16so5034902pjb.3
        for <netdev@vger.kernel.org>; Sun, 30 May 2021 04:41:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:mime-version;
        bh=42AwqpXwsWi3EwJvaWn6paCggPFyOXNRr44FlvApJk8=;
        b=SyEqM40hRfDFImS0c45Umd9+1CKubC9Osd5MCqJe0w866fajHCsNuCdY6lTkhCulfa
         tHLYcKcdk9kCUuYzuF91eUo3nGKM5VCPUWwUrBaPspjoRd1AJaru98oc4c8MgBGYSLK0
         302m6kpAIjRbaPJi/g5ObV717dwQuO5Sq5j50=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version;
        bh=42AwqpXwsWi3EwJvaWn6paCggPFyOXNRr44FlvApJk8=;
        b=FwIVctQCv19QKGoZEJp7rbgmI8l7EvbFu4N4KLBcHb8w5BNWgAsO7/Gil25Adaclby
         5RYTqgiIzild2R79ZFZSvb4l3bT0AM/dVTdmq1G64A7Uxd9yutm41tRWhFFYzMX3+QF3
         iOv2/OGDOs4iTqxQfclia0agZ9Wyuweg3sVvLLGdamKD3M8/oiGy2L9WjtvOYKWWlQT6
         qJ6FieqTVSmXqrMrXy7D9PJzgY9LKsVMhhAaT/hCw/kJYpBaUuzhHLLJdxsY3duLPs13
         4IxM72M8ndDZqmIOZhon7FSzibLP6XqjhT/8B/wIuu6N8v8UYL1tEjCc9rstjssG1oSY
         B06g==
X-Gm-Message-State: AOAM531SmIUj4ws3UOBQIFpoT3PQiKfcx7p/OV5DCDA5yIg+XQEAtD6P
        ivvqzLD93kzbItU6AXEUZ26Lo6y2b3LAIMPShnNdzFDhFnjTn1xt3WkD+6SIqiWpTGRkS88PbtW
        GN5lCZtDHncMEo2YLOkWnK24ZfwXVWjxvvE5mxCnrWookGPMvNUGkvVpA0az7mA2FBp05+BFM6n
        bU+Tydruo=
X-Google-Smtp-Source: ABdhPJzEDIYtJ6S1kW2faE6BHtoGjhcgRkhjoYRvO80xT46vjpKUhTMdK59NLo6gcoOk/0MAt4G6Lw==
X-Received: by 2002:a17:902:8f93:b029:f0:ad44:35ee with SMTP id z19-20020a1709028f93b02900f0ad4435eemr15762448plo.43.1622374884495;
        Sun, 30 May 2021 04:41:24 -0700 (PDT)
Received: from localhost.localdomain ([192.19.250.250])
        by smtp.gmail.com with ESMTPSA id o17sm8126093pjp.33.2021.05.30.04.41.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 30 May 2021 04:41:23 -0700 (PDT)
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
Subject: [PATCH net-next v3 0/3] net/sched: act_vlan: Fix modify to allow 0
Date:   Sun, 30 May 2021 14:40:49 +0300
Message-Id: <20210530114052.16483-1-boris.sukholitko@broadcom.com>
X-Mailer: git-send-email 2.29.3
MIME-Version: 1.0
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="000000000000b7147805c38a9609"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--000000000000b7147805c38a9609
Content-Transfer-Encoding: 8bit

Currently vlan modification action checks existence of vlan priority by
comparing it to 0. Therefore it is impossible to modify existing vlan
tag to have priority 0.

For example, the following tc command will change the vlan id but will
not affect vlan priority:

tc filter add dev eth1 ingress matchall action vlan modify id 300 \
        priority 0 pipe mirred egress redirect dev eth2

The incoming packet on eth1:

ethertype 802.1Q (0x8100), vlan 200, p 4, ethertype IPv4

will be changed to:

ethertype 802.1Q (0x8100), vlan 300, p 4, ethertype IPv4

although the user has intended to have p == 0.

The fix is to add tcfv_push_prio_exists flag to struct tcf_vlan_params
and rely on it when deciding to set the priority.

The same flag is used to avoid dumping unset vlan priority.

Change Log:
v2 -> v3:
- Push assumes that the priority is being set
- tcf_vlan_get_fill_size accounts for priority existence

v1 -> v2:
- Do not dump unset priority and fix tests accordingly
- Test for priority 0 modification

Boris Sukholitko (3):
  net/sched: act_vlan: Fix modify to allow 0
  net/sched: act_vlan: No dump for unset priority
  net/sched: act_vlan: Test priority 0 modification

 include/net/tc_act/tc_vlan.h                  |  1 +
 net/sched/act_vlan.c                          | 26 ++++++++++++-----
 .../tc-testing/tc-tests/actions/vlan.json     | 28 +++++++++++++++++--
 3 files changed, 46 insertions(+), 9 deletions(-)

-- 
2.29.3


--000000000000b7147805c38a9609
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
s4pyqb3D0zeGSCUwDQYJYIZIAWUDBAIBBQCggdQwLwYJKoZIhvcNAQkEMSIEIC+oSBe9q0GFhOKe
SfJYHLvHKCIc9ekZXmFUe6TEegttMBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcN
AQkFMQ8XDTIxMDUzMDExNDEyNVowaQYJKoZIhvcNAQkPMVwwWjALBglghkgBZQMEASowCwYJYIZI
AWUDBAEWMAsGCWCGSAFlAwQBAjAKBggqhkiG9w0DBzALBgkqhkiG9w0BAQowCwYJKoZIhvcNAQEH
MAsGCWCGSAFlAwQCATANBgkqhkiG9w0BAQEFAASCAQCV0Hmsx/tE2FoJios+eE9nzuGw6L8m51fg
vbbj+Qi0pCQwzwGwsbOgW/Pb01g/zqHJqpMOTFkUQPM4YhdjDALHjB3vKTTday79hWlBkECcW8Xg
MXqvbDY3Qm+ZxuZHxiDCoWV4ppDAiuW61cPdjVuUbpTDbyjU9oarN++aYCy3VWfrEBj1xfOZeiOf
/J+tmxbuHrgm5RvST8Bc7jIiL9OfmYjJW/IeIzIbFWXYgSyHDLpDa9LmCNgkEK6Lu905PGFDz2uk
KG/rAA4LT0o1OZVj6E3p6p6h/awDRncm7wHXKkChKF6srhEFYRGdoEXbfBbOuhpsB2G5tVSobVe5
mcWE
--000000000000b7147805c38a9609--
