Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E52D252C92B
	for <lists+netdev@lfdr.de>; Thu, 19 May 2022 03:17:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232263AbiESBRa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 May 2022 21:17:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232269AbiESBR3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 May 2022 21:17:29 -0400
X-Greylist: delayed 434 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Wed, 18 May 2022 18:17:27 PDT
Received: from mail.vladutescu-zopp.com (mail.vladutescu-zopp.com [178.13.10.128])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3336D66AC7;
        Wed, 18 May 2022 18:17:27 -0700 (PDT)
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id 8C2BB39DA8;
        Thu, 19 May 2022 03:09:50 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vladutescu-zopp.com;
        s=dkim; t=1652922609;
        h=from:subject:date:message-id:to:cc:mime-version:content-type:
         content-language; bh=/f4eYqJAhIzo57t3oiUNGKCzzzDhYBOiY8WsyELBOvs=;
        b=eYW2CW6em8cvvDlfozjEIPIflpnZp7lDqEAmGxxRnj8fW/sovCuZlam9ehq11uzmTddp02
        WzhgbxQTr1OIBNadpf8d0cPU70mXwrflk2LuuPql3Hz3QIBedzTBjdjzmrREl5RudRcuUw
        g1LJ/GgE7R48D7/o1pcAP2tGrS0y1tH+E44JazFdsRaF9X5qgBkvN+MVyKKw0mnLQJVO+F
        sA0E/PcAgk2H5e5haRXveRD7IyaI28pcRh2X7N7upsp5c25o9rNqrZNKu8WT6AIapOvKQf
        B81/yVRpEwEz40zDk4ZeqVvjw6ubIwdC2ypeP4xIZY/3ZIdaJj3TLw/DzdgXIQ==
Message-ID: <f9fab445-e4f4-88c1-c9a3-0129af1ccf27@vladutescu-zopp.com>
Date:   Thu, 19 May 2022 03:09:50 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
From:   Nikolaus Vladutescu-Zopp <nikolaus@vladutescu-zopp.com>
Subject: [PATCH] net: atlantic: Avoid out-of-bounds indexing
To:     irusskikh@marvell.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Nikolaus Vladutescu-Zopp <nikolaus@vladutescu-zopp.com>,
        blairuk@gmail.com, kai.heng.feng@canonical.com
Content-Language: en-US
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256; boundary="------------ms070702020902070608040700"
X-Last-TLS-Session-Version: TLSv1.3
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is a cryptographically signed message in MIME format.

--------------ms070702020902070608040700
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

A UBSAN warning is observed on atlantic driver:

[ 16.257086] UBSAN: array-index-out-of-bounds in 
drivers/net/ethernet/aquantia/atlantic/aq_nic.c:1268:48
[ 16.257090] index 8 is out of range for type 'aq_vec_s *[8]'

The index is assigned right before breaking out the loop, so there's no
actual deferencing happening.
So only use the index inside the loop to fix the issue.

Same issue was observed and corrected in two other places.

BugLink: https://bugs.launchpad.net/bugs/1958770
Suggested-by: bsdz <blairuk@gmail.com>
Suggested-by: Kai-Heng Feng <kai.heng.feng@canonical.com>
Tested-by: Nikolaus Vladutescu-Zopp <nikolaus@vladutescu-zopp.com>
Signed-off-by: Nikolaus Vladutescu-Zopp <nikolaus@vladutescu-zopp.com>

---
   drivers/net/ethernet/aquantia/atlantic/aq_nic.c | 17 ++++++++++-------
   1 file changed, 10 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_nic.c
b/drivers/net/ethernet/aquantia/atlantic/aq_nic.c
index 24d715c28a35..f49645d243ba 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_nic.c
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_nic.c
@@ -268,9 +268,10 @@ static void aq_nic_polling_timer_cb(struct
timer_list *t)
   	struct aq_vec_s *aq_vec = NULL;
   	unsigned int i = 0U;

-	for (i = 0U, aq_vec = self->aq_vec[0];
-		self->aq_vecs > i; ++i, aq_vec = self->aq_vec[i])
+	for (i = 0U; self->aq_vecs > i; ++i) {
+		aq_vec = self->aq_vec[i];
   		aq_vec_isr(i, (void *)aq_vec);
+	}

   	mod_timer(&self->polling_timer, jiffies +
   		  AQ_CFG_POLLING_TIMER_INTERVAL);
@@ -928,9 +929,10 @@ u64 *aq_nic_get_stats(struct aq_nic_s *self, u64 *data)
   	data += i;

   	for (tc = 0U; tc < self->aq_nic_cfg.tcs; tc++) {
-		for (i = 0U, aq_vec = self->aq_vec[0];
-		     aq_vec && self->aq_vecs > i;
-		     ++i, aq_vec = self->aq_vec[i]) {
+		for (i = 0U; self->aq_vecs > i; ++i) {
+			aq_vec = self->aq_vec[i];
+			if (!aq_vec)
+				break;
   			data += count;
   			count = aq_vec_get_sw_stats(aq_vec, tc, data);
   		}
@@ -1264,9 +1266,10 @@ int aq_nic_stop(struct aq_nic_s *self)

   	aq_ptp_irq_free(self);

-	for (i = 0U, aq_vec = self->aq_vec[0];
-		self->aq_vecs > i; ++i, aq_vec = self->aq_vec[i])
+	for (i = 0U; self->aq_vecs > i; ++i) {
+		aq_vec = self->aq_vec[i];
   		aq_vec_stop(aq_vec);
+	}

   	aq_ptp_ring_stop(self);

-- 
2.34.1

--------------ms070702020902070608040700
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

MIAGCSqGSIb3DQEHAqCAMIACAQExDzANBglghkgBZQMEAgEFADCABgkqhkiG9w0BBwEAAKCC
DWcwggXyMIID2qADAgECAhBOmWu24Si91guOjOmV1XUNMA0GCSqGSIb3DQEBCwUAMIGBMQsw
CQYDVQQGEwJJVDEQMA4GA1UECAwHQmVyZ2FtbzEZMBcGA1UEBwwQUG9udGUgU2FuIFBpZXRy
bzEXMBUGA1UECgwOQWN0YWxpcyBTLnAuQS4xLDAqBgNVBAMMI0FjdGFsaXMgQ2xpZW50IEF1
dGhlbnRpY2F0aW9uIENBIEczMB4XDTIyMDQyMTEzMzYxOFoXDTIzMDQyMTEzMzYxOFowJzEl
MCMGA1UEAwwcbmlrb2xhdXNAdmxhZHV0ZXNjdS16b3BwLmNvbTCCASIwDQYJKoZIhvcNAQEB
BQADggEPADCCAQoCggEBALbPH4tP4CZQLm4HAkITmvtFPUDYVoSwHg4yUpB8RU7coRI9sTBT
aaP5SSBN9unV2bF9Z/kap1+VG2a+/xOXqjRgL9axOpLQGzsZ9H10HVJUMgRtJsekuqlL+JJJ
XWinF5dQbdTOybFFdMid7C3nd7os6apst8PjeG9TuBNIxMpKXGBrsN3CYLGFG/MUCqc3tOBS
c8GAjeD2ifLm+Ojl96B6cEhAQodv0nQDxP1rI1xe2D1cqtz0eOKAWLA7Vxp4sUmdkPOkbivl
dOubMR6jXcTGu8MeVH3y/r9zgu7Io76Csn4rVfBYARHvGPT2KSjzewBHQgkZG5p1KmtVlIo/
qb0CAwEAAaOCAb0wggG5MAwGA1UdEwEB/wQCMAAwHwYDVR0jBBgwFoAUvpepqoS/gL8QU30J
MvnhLjIbz3cwfgYIKwYBBQUHAQEEcjBwMDsGCCsGAQUFBzAChi9odHRwOi8vY2FjZXJ0LmFj
dGFsaXMuaXQvY2VydHMvYWN0YWxpcy1hdXRjbGlnMzAxBggrBgEFBQcwAYYlaHR0cDovL29j
c3AwOS5hY3RhbGlzLml0L1ZBL0FVVEhDTC1HMzAnBgNVHREEIDAegRxuaWtvbGF1c0B2bGFk
dXRlc2N1LXpvcHAuY29tMEcGA1UdIARAMD4wPAYGK4EfARgBMDIwMAYIKwYBBQUHAgEWJGh0
dHBzOi8vd3d3LmFjdGFsaXMuaXQvYXJlYS1kb3dubG9hZDAdBgNVHSUEFjAUBggrBgEFBQcD
AgYIKwYBBQUHAwQwSAYDVR0fBEEwPzA9oDugOYY3aHR0cDovL2NybDA5LmFjdGFsaXMuaXQv
UmVwb3NpdG9yeS9BVVRIQ0wtRzMvZ2V0TGFzdENSTDAdBgNVHQ4EFgQUs8gxkEWh0N1BgPU2
PtAaG9st7f4wDgYDVR0PAQH/BAQDAgWgMA0GCSqGSIb3DQEBCwUAA4ICAQDTbpRp0b2V5vV/
9jyYnfjNHchnGMY7xh/P4smDxVMOIBZ96SRRuonGFMhR8W1lBqNMl0kbwoc+9jn8aLusoDyA
CBP5VLLS9ALbsema/v20gQxnfkVw3XW3SJR6CIwxjWmAEpdV/qAYGKSD5/D93AMatb5YTALs
qWXUBv6pEzGUXmO3FSnJkFf6K8wC2poigHXsoFyHuAqTEQ9kz7an1g99jhda/0dNTpZMPcff
VUygmIeVN+psoyNaulwdtvpO0UyEtNMnA/mIsG6SCtX8BwmfOw7cOB7VrNbC00Wfco8yM1Jb
Z0QadGPwPDUS08WdIIzHJLkuRnghvLktwdsKCrYjQKHFtNOrTYg9Z/lv2bCfpJmGYt8jmZMJ
ctcKhFk36HUXtaM/C844dMi0NLCGjrlVZ7VTJeoICg9A2A+niGv/hfosYFDTHsOGNPfRf4s7
1k9os9s64hS01b/MtRv79pUXdKuxeNoyr3WPHjy7bVLJjUKPlnWtdvmGit0IIIr9vOuxhBzl
PqGWoJuR2+V/kPOOHN/+cIHemhqfepZ7GkFv2X5HDU6UGRMYEIVQBeYZMlREOF6WNSa+9S4O
zCpqBdw9YYla8XTEsg2SKmyCmS0HHxaCkzWf5GneXTUhQTbM2vpB7xVehHAzus7HGzHUCpC+
uf+JWJq2vRPGMFGxNzP2XzCCB20wggVVoAMCAQICEBcQPt49ihy1ygZRk+fKQ2swDQYJKoZI
hvcNAQELBQAwazELMAkGA1UEBhMCSVQxDjAMBgNVBAcMBU1pbGFuMSMwIQYDVQQKDBpBY3Rh
bGlzIFMucC5BLi8wMzM1ODUyMDk2NzEnMCUGA1UEAwweQWN0YWxpcyBBdXRoZW50aWNhdGlv
biBSb290IENBMB4XDTIwMDcwNjA4NDU0N1oXDTMwMDkyMjExMjIwMlowgYExCzAJBgNVBAYT
AklUMRAwDgYDVQQIDAdCZXJnYW1vMRkwFwYDVQQHDBBQb250ZSBTYW4gUGlldHJvMRcwFQYD
VQQKDA5BY3RhbGlzIFMucC5BLjEsMCoGA1UEAwwjQWN0YWxpcyBDbGllbnQgQXV0aGVudGlj
YXRpb24gQ0EgRzMwggIiMA0GCSqGSIb3DQEBAQUAA4ICDwAwggIKAoICAQDt5oeWocGktu3C
QlX3Pw8PImBfE+CmQ4iGSZF5HBsvGlAP3EYB7va6OobMUWHvxA+ACHEpWq0YfNh6rRUlULOG
cIpEFtVf4nAiEvdQtiFQBmtWJSn3naoMHqpMvmwZ4lL0Xr1U9JHmTqkU3DuYcNNO3S+hYWDZ
pWQbeSGibNVeiJ4kY6JDh0fvqloK1BsuS3n2OgArPYGfAYtDjCvT2d+6Ym3kArHZjEcrZeBI
+yVVnjPwbTSCKax8DtS2NP/CJ6RjpnRvuSwusRy84OdwdB71VKs1EDXj1ITcCWRZpkz+OhV6
L8Zh+P0rmOSJF6KdHiaozfncURx4s54GFJNRGkx1DnCxcuL0NJMYG42/hrDYOjNv+oGWSEZO
/CT3aaLSMB5wTbZKfcD1R+tTanXD+5Gz5Mi15DTE7QH8naZjZxqqhyxL1KyuIgaVDxvQtPSj
o5vTsoa09rn+Ui8ybHnvYO/a/68OIQIHLGbUd2COnwm0TiZ3Jg/oYGxwnJPvU1nDXNcecWTI
JvFF5qD2ppJH3HgJVVePUEOY1E4Kp3k0B8hdRdhMV5n+O6RCKCTFcZaESF8sELgdrqnCLPP1
+rX7DA8pxZoX0/9Jk64EOsbfQyLIJlrrob2YS0Xlku6HisZ8qrHLhnkzF5y7O34xmatIp8oZ
5c54QP+K5flnTYzWjuIxLwIDAQABo4IB9DCCAfAwDwYDVR0TAQH/BAUwAwEB/zAfBgNVHSME
GDAWgBRS2Ig6yJ94Zu2J83s4cJTJAgI20DBBBggrBgEFBQcBAQQ1MDMwMQYIKwYBBQUHMAGG
JWh0dHA6Ly9vY3NwMDUuYWN0YWxpcy5pdC9WQS9BVVRILVJPT1QwRQYDVR0gBD4wPDA6BgRV
HSAAMDIwMAYIKwYBBQUHAgEWJGh0dHBzOi8vd3d3LmFjdGFsaXMuaXQvYXJlYS1kb3dubG9h
ZDAdBgNVHSUEFjAUBggrBgEFBQcDAgYIKwYBBQUHAwQwgeMGA1UdHwSB2zCB2DCBlqCBk6CB
kIaBjWxkYXA6Ly9sZGFwMDUuYWN0YWxpcy5pdC9jbiUzZEFjdGFsaXMlMjBBdXRoZW50aWNh
dGlvbiUyMFJvb3QlMjBDQSxvJTNkQWN0YWxpcyUyMFMucC5BLiUyZjAzMzU4NTIwOTY3LGMl
M2RJVD9jZXJ0aWZpY2F0ZVJldm9jYXRpb25MaXN0O2JpbmFyeTA9oDugOYY3aHR0cDovL2Ny
bDA1LmFjdGFsaXMuaXQvUmVwb3NpdG9yeS9BVVRILVJPT1QvZ2V0TGFzdENSTDAdBgNVHQ4E
FgQUvpepqoS/gL8QU30JMvnhLjIbz3cwDgYDVR0PAQH/BAQDAgEGMA0GCSqGSIb3DQEBCwUA
A4ICAQAmm+cbWQ10sxID6edV94SAhc1CwzthHFfHpuYS30gisWUfWpgp43Dg1XzG2in3VGV7
XrzCCGZh4JM/XQWp+4oxmyV42Qjz9vc8GRksgo6X2nYObPYZzQjda9wxsCB38i4G3H33w8lf
9sFvl0xm4ZXZ2s2bF/PdqvrK0ZgvF51+MoIPnli/wJBw3p72xbk5Sb1MneSO3tZ293WFzDmz
7tuGU0PfytYUkG7O6annGqbU1I6CA6QVKUqeFLPodSODAFqJ3pimKD0vX9MuuSa0QinH7Cki
PtZMD0mpwwzIsnSs3qOOl60tIZQOTc0I6lCe1LLhrz7Q75J6nNL9N5zVwZ1I3o2Lb8Dt7BA1
3VFuZvZIzapUGV83R7pmSVaj1Bik1nJ/R393e6mwppsT140KDVLh4Oenywmp2VpBDuEj9RgI
CAO0sibv8n379LbO7ARa0kw9y9pggFzN2PAX25b7w0n9m78kpv3z3vW65rs6wl7E8VEHNfv8
+cnb81dxN3C51KElz+l31zchFTurD5HFEpyEhzO/fMS5AkweRJIzwozxNs7OL/S/SVTpJLJL
1ukZ1lnHHX0d3xCzRy/5HqfK3uiG22LPB5+RjNDobPAjAz2BKMfkF/+v0pzn8mqqkopQaJzE
AbLbMpgQYHRCjvrUxxwjJyUFb2Z+40UNtMF4MTK7zTGCA/MwggPvAgEBMIGWMIGBMQswCQYD
VQQGEwJJVDEQMA4GA1UECAwHQmVyZ2FtbzEZMBcGA1UEBwwQUG9udGUgU2FuIFBpZXRybzEX
MBUGA1UECgwOQWN0YWxpcyBTLnAuQS4xLDAqBgNVBAMMI0FjdGFsaXMgQ2xpZW50IEF1dGhl
bnRpY2F0aW9uIENBIEczAhBOmWu24Si91guOjOmV1XUNMA0GCWCGSAFlAwQCAQUAoIICLTAY
BgkqhkiG9w0BCQMxCwYJKoZIhvcNAQcBMBwGCSqGSIb3DQEJBTEPFw0yMjA1MTkwMTA5NTBa
MC8GCSqGSIb3DQEJBDEiBCBghPF+aqI48zjdZjkqvLgbNKcJpiDI8jEiz6mlCCziJjBsBgkq
hkiG9w0BCQ8xXzBdMAsGCWCGSAFlAwQBKjALBglghkgBZQMEAQIwCgYIKoZIhvcNAwcwDgYI
KoZIhvcNAwICAgCAMA0GCCqGSIb3DQMCAgFAMAcGBSsOAwIHMA0GCCqGSIb3DQMCAgEoMIGn
BgkrBgEEAYI3EAQxgZkwgZYwgYExCzAJBgNVBAYTAklUMRAwDgYDVQQIDAdCZXJnYW1vMRkw
FwYDVQQHDBBQb250ZSBTYW4gUGlldHJvMRcwFQYDVQQKDA5BY3RhbGlzIFMucC5BLjEsMCoG
A1UEAwwjQWN0YWxpcyBDbGllbnQgQXV0aGVudGljYXRpb24gQ0EgRzMCEE6Za7bhKL3WC46M
6ZXVdQ0wgakGCyqGSIb3DQEJEAILMYGZoIGWMIGBMQswCQYDVQQGEwJJVDEQMA4GA1UECAwH
QmVyZ2FtbzEZMBcGA1UEBwwQUG9udGUgU2FuIFBpZXRybzEXMBUGA1UECgwOQWN0YWxpcyBT
LnAuQS4xLDAqBgNVBAMMI0FjdGFsaXMgQ2xpZW50IEF1dGhlbnRpY2F0aW9uIENBIEczAhBO
mWu24Si91guOjOmV1XUNMA0GCSqGSIb3DQEBAQUABIIBAI50Q6+4NIpYu92G/mZ0sOQ8Kl7m
dt32CTSzi8yHYlTwX3BelASygXZ9Mm9950dT9yq6FxxogykSWVxa/BfJ7cBMdbDEzucCKdxl
rxGnkPJTPuzP81s4LdYk1KeiemaCjOgIi6LBczKNqwKU+HcR+BSEAy/0bcS8u0ixQ1WB9wNb
VVQlnebkelw9qVDhT82DEJlEdrZAJsT7+LjnOvCdMQ1AQ6FHvRkRI4AO/dXJgho55b683nt6
Osw+UiGwDjo/XdokiFpU0rVlfVYKBePa47HaG5wELbgDuK/G6vDD4Sim0GiLMpbxBOU1gFPG
UEdQ6j6L1uEhVoljs96JZ04RlJIAAAAAAAA=
--------------ms070702020902070608040700--
