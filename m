Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AA0C050F955
	for <lists+netdev@lfdr.de>; Tue, 26 Apr 2022 11:58:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348177AbiDZJ5E (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Apr 2022 05:57:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347918AbiDZJ44 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Apr 2022 05:56:56 -0400
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4408936B42
        for <netdev@vger.kernel.org>; Tue, 26 Apr 2022 02:14:59 -0700 (PDT)
Received: by mail-pf1-x42e.google.com with SMTP id t13so3766570pfg.2
        for <netdev@vger.kernel.org>; Tue, 26 Apr 2022 02:14:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version;
        bh=ZBiMD4tEBeedkhTRdDHEgPGHqhk4eSsoe9CIMP5yimc=;
        b=HL6T/nzIgmoJIRdMkM63HEVcQsIZXzeQB9BFBd5b1LG5vT5AeompwzEptCXZNOBzmQ
         /EuelSIZ459MOQZQlXXos9mHEgl6lX5HAFw967ze3AYotNuQxv7k90NMjUiKpYsS7p8X
         nOcllKsdqnuBeBJIc/TC6lWM61mGCyqwJEts0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version;
        bh=ZBiMD4tEBeedkhTRdDHEgPGHqhk4eSsoe9CIMP5yimc=;
        b=bD+1vnLdC5iGmnyen0LB3O6DnGm0f47X6FE6elOxmNbLpPy0BajeVllcHwO9INZg3O
         vLJH3VintClhpQrVTUI0/kJd6nbiOyijmPjKxW2U2B3tTW4NouS/TuzKMYsul4XqRFD8
         0rLvXzd+Ir1yFGYsQzuZJhjdSznbKK5VBLAZBBndnXaSZ6HyRR/UzGpB+cwM/wbG8VVq
         QItIR99oXBaOmd1GBSrJYvqwo/QYeZn5T5MpryQKpQUBaZdOmMrUTCv1m1fwWUfAkBsx
         zK+NYn+vvvtaKfkILJR1btVgQ8wD89hC5ooC0ml1jxNH9UO7KsCAtZxLdXJwV0r/wIgC
         pxSg==
X-Gm-Message-State: AOAM530t9NPUObiXZoLpWgnGfnHwtAvxEoOyr+tKp4iZdWi0nSYVHLVj
        aTC/6+sbRnEc2PXzGVCVkRdSMmDjc1u4BcltL+QE+aaHI0ZovnjvXfBjK2GZ+fXLW4fzMv+LUXm
        TEX2S/Ql9WCHote5flwx7pMGgYv8eEHgVIIvFbw4EEhOoFAPQ9+Lu5vmjlQ8WZ+kqmJBI9Pu8DY
        vgwJ+r
X-Google-Smtp-Source: ABdhPJxK2nHFACzlOaqNdMzWpl/rgIpAdqhoUwuYeOvEOf9G/ZkVLrbttb2sXXzO1r0mAUvEy59xmA==
X-Received: by 2002:a63:8ac7:0:b0:3aa:fa62:5a28 with SMTP id y190-20020a638ac7000000b003aafa625a28mr13137938pgd.400.1650964497939;
        Tue, 26 Apr 2022 02:14:57 -0700 (PDT)
Received: from localhost.localdomain ([192.19.250.250])
        by smtp.gmail.com with ESMTPSA id z10-20020a62d10a000000b0050d3c3668bcsm7593829pfg.137.2022.04.26.02.14.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Apr 2022 02:14:57 -0700 (PDT)
From:   Boris Sukholitko <boris.sukholitko@broadcom.com>
To:     netdev@vger.kernel.org, David Ahern <dsahern@kernel.org>
Cc:     Ilya Lifshits <ilya.lifshits@broadcom.com>,
        Boris Sukholitko <boris.sukholitko@broadcom.com>
Subject: [PATCH iproute2-next v3 2/2] f_flower: Check args with num_of_vlans
Date:   Tue, 26 Apr 2022 12:14:17 +0300
Message-Id: <20220426091417.7153-3-boris.sukholitko@broadcom.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20220426091417.7153-1-boris.sukholitko@broadcom.com>
References: <20220426091417.7153-1-boris.sukholitko@broadcom.com>
MIME-Version: 1.0
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="00000000000075fae305dd8b205a"
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--00000000000075fae305dd8b205a
Content-Transfer-Encoding: 8bit

Having more than one vlan allows matching on the vlan tag parameters.
This patch changes vlan key validation to take number of vlan tags into
account.

Signed-off-by: Boris Sukholitko <boris.sukholitko@broadcom.com>
---
 tc/f_flower.c | 41 +++++++++++++++++++++++------------------
 1 file changed, 23 insertions(+), 18 deletions(-)

diff --git a/tc/f_flower.c b/tc/f_flower.c
index 25ffd295..fbb7042f 100644
--- a/tc/f_flower.c
+++ b/tc/f_flower.c
@@ -160,21 +160,23 @@ err:
 	return err;
 }
 
-static bool eth_type_vlan(__be16 ethertype)
+static bool eth_type_vlan(__be16 ethertype, bool good_num_of_vlans)
 {
 	return ethertype == htons(ETH_P_8021Q) ||
-	       ethertype == htons(ETH_P_8021AD);
+	       ethertype == htons(ETH_P_8021AD) ||
+	       good_num_of_vlans;
 }
 
 static int flower_parse_vlan_eth_type(char *str, __be16 eth_type, int type,
 				      __be16 *p_vlan_eth_type,
-				      struct nlmsghdr *n)
+				      struct nlmsghdr *n, bool good_num_of_vlans)
 {
 	__be16 vlan_eth_type;
 
-	if (!eth_type_vlan(eth_type)) {
-		fprintf(stderr, "Can't set \"%s\" if ethertype isn't 802.1Q or 802.1AD\n",
-			type == TCA_FLOWER_KEY_VLAN_ETH_TYPE ? "vlan_ethtype" : "cvlan_ethtype");
+	if (!eth_type_vlan(eth_type, good_num_of_vlans)) {
+		fprintf(stderr, "Can't set \"%s\" if ethertype isn't 802.1Q or 802.1AD and num_of_vlans %s\n",
+			type == TCA_FLOWER_KEY_VLAN_ETH_TYPE ? "vlan_ethtype" : "cvlan_ethtype",
+			type == TCA_FLOWER_KEY_VLAN_ETH_TYPE ? "is 0" : "less than 2");
 		return -1;
 	}
 
@@ -1425,6 +1427,7 @@ static int flower_parse_opt(struct filter_util *qu, char *handle,
 	__be16 tc_proto = TC_H_MIN(t->tcm_info);
 	__be16 eth_type = tc_proto;
 	__be16 vlan_ethtype = 0;
+	__u8 num_of_vlans = 0;
 	__u8 ip_proto = 0xff;
 	__u32 flags = 0;
 	__u32 mtf = 0;
@@ -1527,8 +1530,6 @@ static int flower_parse_opt(struct filter_util *qu, char *handle,
 				invarg("\"indev\" not a valid ifname", *argv);
 			addattrstrz(n, MAX_MSG, TCA_FLOWER_INDEV, *argv);
 		} else if (matches(*argv, "num_of_vlans") == 0) {
-			__u8 num_of_vlans;
-
 			NEXT_ARG();
 			ret = get_u8(&num_of_vlans, *argv, 10);
 			if (ret < 0) {
@@ -1541,8 +1542,9 @@ static int flower_parse_opt(struct filter_util *qu, char *handle,
 			__u16 vid;
 
 			NEXT_ARG();
-			if (!eth_type_vlan(tc_proto)) {
-				fprintf(stderr, "Can't set \"vlan_id\" if ethertype isn't 802.1Q or 802.1AD\n");
+			if (!eth_type_vlan(tc_proto, num_of_vlans > 0)) {
+				fprintf(stderr, "Can't set \"vlan_id\" if ethertype isn't 802.1Q or 802.1AD"
+						" and num_of_vlans is 0\n");
 				return -1;
 			}
 			ret = get_u16(&vid, *argv, 10);
@@ -1555,8 +1557,9 @@ static int flower_parse_opt(struct filter_util *qu, char *handle,
 			__u8 vlan_prio;
 
 			NEXT_ARG();
-			if (!eth_type_vlan(tc_proto)) {
-				fprintf(stderr, "Can't set \"vlan_prio\" if ethertype isn't 802.1Q or 802.1AD\n");
+			if (!eth_type_vlan(tc_proto, num_of_vlans > 0)) {
+				fprintf(stderr, "Can't set \"vlan_prio\" if ethertype isn't 802.1Q or 802.1AD"
+						" and num_of_vlans is 0\n");
 				return -1;
 			}
 			ret = get_u8(&vlan_prio, *argv, 10);
@@ -1570,7 +1573,7 @@ static int flower_parse_opt(struct filter_util *qu, char *handle,
 			NEXT_ARG();
 			ret = flower_parse_vlan_eth_type(*argv, eth_type,
 						 TCA_FLOWER_KEY_VLAN_ETH_TYPE,
-						 &vlan_ethtype, n);
+						 &vlan_ethtype, n, num_of_vlans > 0);
 			if (ret < 0)
 				return -1;
 			/* get new ethtype for later parsing  */
@@ -1579,8 +1582,9 @@ static int flower_parse_opt(struct filter_util *qu, char *handle,
 			__u16 vid;
 
 			NEXT_ARG();
-			if (!eth_type_vlan(vlan_ethtype)) {
-				fprintf(stderr, "Can't set \"cvlan_id\" if inner vlan ethertype isn't 802.1Q or 802.1AD\n");
+			if (!eth_type_vlan(vlan_ethtype, num_of_vlans > 1)) {
+				fprintf(stderr, "Can't set \"cvlan_id\" if inner vlan ethertype isn't 802.1Q or 802.1AD"
+						" and num_of_vlans is less than 2\n");
 				return -1;
 			}
 			ret = get_u16(&vid, *argv, 10);
@@ -1593,8 +1597,9 @@ static int flower_parse_opt(struct filter_util *qu, char *handle,
 			__u8 cvlan_prio;
 
 			NEXT_ARG();
-			if (!eth_type_vlan(vlan_ethtype)) {
-				fprintf(stderr, "Can't set \"cvlan_prio\" if inner vlan ethertype isn't 802.1Q or 802.1AD\n");
+			if (!eth_type_vlan(vlan_ethtype, num_of_vlans > 1)) {
+				fprintf(stderr, "Can't set \"cvlan_prio\" if inner vlan ethertype isn't 802.1Q or 802.1AD"
+						" and num_of_vlans is less than 2\n");
 				return -1;
 			}
 			ret = get_u8(&cvlan_prio, *argv, 10);
@@ -1609,7 +1614,7 @@ static int flower_parse_opt(struct filter_util *qu, char *handle,
 			/* get new ethtype for later parsing */
 			ret = flower_parse_vlan_eth_type(*argv, vlan_ethtype,
 						 TCA_FLOWER_KEY_CVLAN_ETH_TYPE,
-						 &eth_type, n);
+						 &eth_type, n, num_of_vlans > 1);
 			if (ret < 0)
 				return -1;
 		} else if (matches(*argv, "mpls") == 0) {
-- 
2.29.2


--00000000000075fae305dd8b205a
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
s4pyqb3D0zeGSCUwDQYJYIZIAWUDBAIBBQCggdQwLwYJKoZIhvcNAQkEMSIEIKZIj+9sMUg5v9/F
xMnkhY0v9dSkcieyiNBrHlRNxhZRMBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcN
AQkFMQ8XDTIyMDQyNjA5MTQ1OFowaQYJKoZIhvcNAQkPMVwwWjALBglghkgBZQMEASowCwYJYIZI
AWUDBAEWMAsGCWCGSAFlAwQBAjAKBggqhkiG9w0DBzALBgkqhkiG9w0BAQowCwYJKoZIhvcNAQEH
MAsGCWCGSAFlAwQCATANBgkqhkiG9w0BAQEFAASCAQA0/+ojCMCaUuwjik4lHLcGC4ai4XpEUhF8
TeiRm3/o/KupUewZnv2p+6CaumZFU4PqT63JRejGGnrPE3x4m9bWClWhW4IyCty3vsJCfm2o46Pm
3auE5sZR3MOIHcD6KVa2r/E9Zf1E1HnIE5TgC+s+kFUtQ8Gi/1ADzcGG7UlSaXM8I9p2sXw8f3kf
DAxnYn2AHP9sYihwFunEvj644gHksnD8NDeRGP00FeP1fR2ebnEThaHxh2VXaH4iKRfsof2KrhkJ
81N8d46f1jSP4UdJdnROcdao7sCy0ik8mp823pyUEveLRrMA0hlIYN7BEMbZNfrvx+03R8MllM4D
IJu6
--00000000000075fae305dd8b205a--
