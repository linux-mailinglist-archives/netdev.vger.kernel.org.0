Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A7B2B5BC3A8
	for <lists+netdev@lfdr.de>; Mon, 19 Sep 2022 09:48:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229908AbiISHsg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Sep 2022 03:48:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229893AbiISHse (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Sep 2022 03:48:34 -0400
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6EB0F1EC48
        for <netdev@vger.kernel.org>; Mon, 19 Sep 2022 00:48:33 -0700 (PDT)
Received: by mail-pl1-x635.google.com with SMTP id x1so27178874plv.5
        for <netdev@vger.kernel.org>; Mon, 19 Sep 2022 00:48:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=gfzk34BrRFZWdhnNXVJhtPVgt569wpPWtum9HHwYo2w=;
        b=cg4tnA/vBnKnKK6v27VKKQ1GvWEZiZ/+OUqivkbl6Vf+nESACOPMWFH44CCmXkv2Wo
         xt6VvDYom40MFzvceKs0HijHbWSdRvWXesnnv4jP+SXQ01y/okKpS0SmEPfuOCXao3Hg
         DuLDqgdxnnXRJ+yQ4kVwHdxXnUxMrWIJrn8Mg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=gfzk34BrRFZWdhnNXVJhtPVgt569wpPWtum9HHwYo2w=;
        b=1zlPux7TwjrMLX5SDTtRETcxxqY36QCY6D0PNi9095yygPyPFuPUNC85x9L7v24NlU
         fpwn0w/nDZnm4UaQPGT8IgzD3vylJZ5a8VfcjnofeXfNR2L5ocQksA9ylRP41DG1B+Ip
         YbkGrVAwY3yJY5dFRkiD3JM6TJe4Xoo9FlN8QI/WsykduEnw5+rRGfWAFKqPZ9V/D6h1
         HfeRw+zFEAJX3V2KSz6K7b/9DyE6cBjU+eEzHI7hiDSjsFBbhpKviu3EakQ+wVsI/0ad
         rdyeBm/HnKrwpeNhaoLIH9L/IXZ/+J7UDrKDVy+2sshWcoNoRasDTZt+7dc1DSKcy2TD
         6fyQ==
X-Gm-Message-State: ACrzQf1pZ9LsMce3HQcl9rWJRKHsBD4TbowELmc2q0l2rNNrwjAHGtbf
        FUYJjEs2z1Mvn9O2Wlhep/m+Q6/56EydsNLL8BUT/Kd0IgBFo8DXXaGqI9IJetCsINJfboagYYP
        Tuxed8sH978piUtPQaNuXaYv26EoDwUyVzEXsZ4qYjEXGTLkjeYMDobjPPihhSKVYHpndaz1pDn
        ilPYs=
X-Google-Smtp-Source: AMsMyM6QmqoMISLP/bfM7/nPYKylBhpQOat5c6Ct98OToJ/pj50N7r9TDtiSbT8UVOmMs4/bIiptiQ==
X-Received: by 2002:a17:902:ab01:b0:178:fee:c607 with SMTP id ik1-20020a170902ab0100b001780feec607mr11464337plb.20.1663573712365;
        Mon, 19 Sep 2022 00:48:32 -0700 (PDT)
Received: from bld-sha-bca-01.sha.broadcom.net ([192.19.236.250])
        by smtp.googlemail.com with ESMTPSA id i7-20020a17090a2ac700b002004380686bsm5934271pjg.46.2022.09.19.00.48.27
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 19 Sep 2022 00:48:31 -0700 (PDT)
From:   Qingqing Yang <qingqing.yang@broadcom.com>
To:     netdev@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, boris.sukholitko@broadcom.com,
        kurt@linutronix.de, f.fainelli@gmail.com, paulb@nvidia.com,
        wojciech.drewek@intel.com, komachi.yoshiki@gmail.com,
        ludovic.cintrat@gatewatcher.com
Cc:     Qingqing Yang <qingqing.yang@broadcom.com>
Subject: [PATCH] flow_dissector: Do not count vlan tags inside tunnel payload
Date:   Mon, 19 Sep 2022 15:48:08 +0800
Message-Id: <20220919074808.136640-1-qingqing.yang@broadcom.com>
X-Mailer: git-send-email 2.16.6
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="00000000000037ef8e05e902f038"
X-Spam-Status: No, score=-0.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        MIME_HEADER_CTYPE_ONLY,MIME_NO_TEXT,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_NONE,T_TVD_MIME_NO_HEADERS autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--00000000000037ef8e05e902f038

We've met the problem that when there is a vlan tag inside
GRE encapsulation, the match of num_of_vlans fails.
It is caused by the vlan tag inside GRE payload has been
counted into num_of_vlans, which is not expected.

One example packet is like this:
Ethernet II, Src: Broadcom_68:56:07 (00:10:18:68:56:07)
                   Dst: Broadcom_68:56:08 (00:10:18:68:56:08)
802.1Q Virtual LAN, PRI: 0, DEI: 0, ID: 100
Internet Protocol Version 4, Src: 192.168.1.4, Dst: 192.168.1.200
Generic Routing Encapsulation (Transparent Ethernet bridging)
Ethernet II, Src: Broadcom_68:58:07 (00:10:18:68:58:07)
                   Dst: Broadcom_68:58:08 (00:10:18:68:58:08)
802.1Q Virtual LAN, PRI: 0, DEI: 0, ID: 200
...
It should match the (num_of_vlans 1) rule, but it matches
the (num_of_vlans 2) rule.

The vlan tags inside the GRE or other tunnel encapsulated payload
should not be taken into num_of_vlans.
The fix is to stop counting the vlan number when the encapsulation
bit is set.

Fixes: 34951fcf26c5 ("flow_dissector: Add number of vlan tags dissector")
Signed-off-by: Qingqing Yang <qingqing.yang@broadcom.com>
Reviewed-by: Boris Sukholitko <boris.sukholitko@broadcom.com>
---
 net/core/flow_dissector.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/core/flow_dissector.c b/net/core/flow_dissector.c
index 5dc3860e9fc7..7105529abb0f 100644
--- a/net/core/flow_dissector.c
+++ b/net/core/flow_dissector.c
@@ -1173,8 +1173,8 @@ bool __skb_flow_dissect(const struct net *net,
 			nhoff += sizeof(*vlan);
 		}
 
-		if (dissector_uses_key(flow_dissector,
-				       FLOW_DISSECTOR_KEY_NUM_OF_VLANS)) {
+		if (dissector_uses_key(flow_dissector, FLOW_DISSECTOR_KEY_NUM_OF_VLANS) &&
+		    !(key_control->flags & FLOW_DIS_ENCAPSULATION)) {
 			struct flow_dissector_key_num_of_vlans *key_nvs;
 
 			key_nvs = skb_flow_dissector_target(flow_dissector,
-- 
2.16.6


--00000000000037ef8e05e902f038
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
Cgs7nS6q1rxqX3jKIG3fs+/YDIjMV+N+GrkI0OhZqUcSEV4yaj28fKEsRlMc6b5IWxpsT0dhsGVO
1FRE/3trYJ822j7uYTX9Nczr3HHUZgCjWXj9VK7lQR3WTQIDAQABo4IB2zCCAdcwDgYDVR0PAQH/
BAQDAgWgMIGjBggrBgEFBQcBAQSBljCBkzBOBggrBgEFBQcwAoZCaHR0cDovL3NlY3VyZS5nbG9i
YWxzaWduLmNvbS9jYWNlcnQvZ3NnY2NyM3BlcnNvbmFsc2lnbjJjYTIwMjAuY3J0MEEGCCsGAQUF
BzABhjVodHRwOi8vb2NzcC5nbG9iYWxzaWduLmNvbS9nc2djY3IzcGVyc29uYWxzaWduMmNhMjAy
MDBNBgNVHSAERjBEMEIGCisGAQQBoDIBKAowNDAyBggrBgEFBQcCARYmaHR0cHM6Ly93d3cuZ2xv
YmFsc2lnbi5jb20vcmVwb3NpdG9yeS8wCQYDVR0TBAIwADBJBgNVHR8EQjBAMD6gPKA6hjhodHRw
Oi8vY3JsLmdsb2JhbHNpZ24uY29tL2dzZ2NjcjNwZXJzb25hbHNpZ24yY2EyMDIwLmNybDAlBgNV
HREEHjAcgRpxaW5ncWluZy55YW5nQGJyb2FkY29tLmNvbTATBgNVHSUEDDAKBggrBgEFBQcDBDAf
BgNVHSMEGDAWgBSWM9HmWBdbNHWKgVZk1b5I3qGPzzAdBgNVHQ4EFgQUHxFzA6edD3YeplCdaUL/
loMMPJgwDQYJKoZIhvcNAQELBQADggEBADkIXJ/U954MQG4Gvjg5JNibR7xCUhMH21pzH0XkiMeE
DDrsQ/m3r7I5XcTYX9GuQX2JSTREabAEvLFi3EsmL83hD8xjWKx16r4VlFmwSjYH5/A395f+mwUp
Yc7oIJ5pP/OzBhSoHE91jMYikKKieZA7xkDRlLPmH55MbrD1QFgdOhjVTZfeHa0UWRnD2AUYQo3z
qdqHpUYHFDjTwLyVT2ytAGjGqDtszwBGRDd9bgnGT70IHkQ1R8Ejzax74RiWmWc6WFcqTf2HwWpd
LDUdXN+rJxR6hVcveMoY0ciEdsHZkZkBEKYi4HCwqU+9dhdyjS67r55dk5tUdeCSpS5XMc4xggJt
MIICaQIBATBrMFsxCzAJBgNVBAYTAkJFMRkwFwYDVQQKExBHbG9iYWxTaWduIG52LXNhMTEwLwYD
VQQDEyhHbG9iYWxTaWduIEdDQyBSMyBQZXJzb25hbFNpZ24gMiBDQSAyMDIwAgwldcP7pjEFDJDQ
Hv0wDQYJYIZIAWUDBAIBBQCggdQwLwYJKoZIhvcNAQkEMSIEICseBg6F3Wm//2FzApb1EShGlbtz
z45uzqZXwdzyBNQfMBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTIy
MDkxOTA3NDgzMlowaQYJKoZIhvcNAQkPMVwwWjALBglghkgBZQMEASowCwYJYIZIAWUDBAEWMAsG
CWCGSAFlAwQBAjAKBggqhkiG9w0DBzALBgkqhkiG9w0BAQowCwYJKoZIhvcNAQEHMAsGCWCGSAFl
AwQCATANBgkqhkiG9w0BAQEFAASCAQA0DgsFh13Xt6bV9r0TrUMCjq+qyUL1HMcMKIOKLytuVz8w
ZnqGmR92VXWfFG1bYNlcRiPR9xf8Un0LMaMJmyASsXi2NL19NevWRcVUbPbhYBHP2jq5/2cZ+xeY
6jVXyIf698or1gRE0psySQoVeGUzPL9hw8N2UtB3F1KJsR2y27MOeCSaPp7wAc8YRERnK7W7TD2C
5UEOuD/1SCLmmyIQi+n/EpZBWxfoikcRVXOZwpI8tm9TE3mA4lXc4gKBGIkuvB8dqUudNsa050pj
D2WhFGW4geacgnUEr+WK32povyrP2JMnuLMs4EehDQjrlQmswMc5FxWhlRnf+kZNLdd4
--00000000000037ef8e05e902f038--
