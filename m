Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 45EB962E57
	for <lists+netdev@lfdr.de>; Tue,  9 Jul 2019 04:54:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727296AbfGICxs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Jul 2019 22:53:48 -0400
Received: from mail-qk1-f195.google.com ([209.85.222.195]:38869 "EHLO
        mail-qk1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727215AbfGICxs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Jul 2019 22:53:48 -0400
Received: by mail-qk1-f195.google.com with SMTP id a27so14952400qkk.5
        for <netdev@vger.kernel.org>; Mon, 08 Jul 2019 19:53:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=tsxcxDGdL/lA0VexALmxpSgwP+ANvA0KwEWquzB2XEk=;
        b=u5Sqm50c2AXdNrI2RkHw8DPG+J930Zia6JsxNjipvvIgpkb6jC3uj5ZlI4Mh8TAF2e
         bs+omCWJu+ISqd7SwWg1WJrujJb/Q32x5+jd0OyJmjmAdNbv3L+wrxYnK8fUHH4dqeO7
         e9w4GYCfHY0gCEtg/Kr3/bGmpzwsB4Rqnv2S+UgicIf7SHkkp82OfAUgu8P6ZZ8ka9iK
         NGCSJq8ejTucBSgs6R0kltLVOlbOJw5nktlsTSYMQZWyXEpp0PBU/TnTjVMarjQrIgf6
         PlRVMiGFbrVcu2KhupuXBbZjCItws2jfnnMgjQSIDU1NyDV9VrwlgkTNTL2LoH7/6rhG
         5+HQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=tsxcxDGdL/lA0VexALmxpSgwP+ANvA0KwEWquzB2XEk=;
        b=f1dcvhdvsdZ4Ly6E6g32NlDRd1jOTU8W3L7Z7La16WpFCAUoxiTZ+IrxOWQkbngRq2
         sjxEd8sqDK/JRLwKjCDss0HzBz6g13hcHqetcNZ61LGmqQo62EMgKczhllR3Ezm6Y/bv
         wE68PrMansHlgsho042x0QzLuGsSzzP6muiIK6QvxEvKpaOj515A6uYym8EW+vom6iJJ
         L5F8t/CvVIj9do3vCT24F1ZXgNb5Gl6RaucbcZyVg1OIYczAmoEvZmzSZ03kzKIRAByj
         VdzAbcaPRIZwelB26k5d44a/RgIdVL/7T+MtToiSWDo8CC66Dv97AUobvAdM7MIWfN54
         J6rA==
X-Gm-Message-State: APjAAAV7p1Yi+t6BkRsN3l9hCK3XT9a9z6Gj2T3RAYwlSK2jwTRnyef9
        OKVMub33QwE+1UJLayS1MtH4ayBmTFg=
X-Google-Smtp-Source: APXvYqw8w9EhN3xVWBJzuqU5chXKGIrGsRjvAOe5AsAjXQeOen8OzJXRqMEVA92tX8/4qgSzk4tjSw==
X-Received: by 2002:a37:be86:: with SMTP id o128mr17161091qkf.40.1562640827250;
        Mon, 08 Jul 2019 19:53:47 -0700 (PDT)
Received: from jkicinski-Precision-T1700.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id g13sm8148837qkm.17.2019.07.08.19.53.46
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 08 Jul 2019 19:53:46 -0700 (PDT)
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, oss-drivers@netronome.com,
        alexei.starovoitov@gmail.com,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Dirk van der Merwe <dirk.vandermerwe@netronome.com>
Subject: [PATCH net-next 02/11] nfp: tls: move setting ipver_vlan to a helper
Date:   Mon,  8 Jul 2019 19:53:09 -0700
Message-Id: <20190709025318.5534-3-jakub.kicinski@netronome.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190709025318.5534-1-jakub.kicinski@netronome.com>
References: <20190709025318.5534-1-jakub.kicinski@netronome.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Long lines are ugly.  No functional changes.

Signed-off-by: Jakub Kicinski <jakub.kicinski@netronome.com>
Reviewed-by: Dirk van der Merwe <dirk.vandermerwe@netronome.com>
---
 drivers/net/ethernet/netronome/nfp/crypto/tls.c | 16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/netronome/nfp/crypto/tls.c b/drivers/net/ethernet/netronome/nfp/crypto/tls.c
index 086bea0a7f2d..b13b3dbd4843 100644
--- a/drivers/net/ethernet/netronome/nfp/crypto/tls.c
+++ b/drivers/net/ethernet/netronome/nfp/crypto/tls.c
@@ -147,6 +147,14 @@ static void nfp_net_tls_del_fw(struct nfp_net *nn, __be32 *fw_handle)
 				       NFP_CCM_TYPE_CRYPTO_DEL);
 }
 
+static void
+nfp_net_tls_set_ipver_vlan(struct nfp_crypto_req_add_front *front, u8 ipver)
+{
+	front->ipver_vlan = cpu_to_be16(FIELD_PREP(NFP_NET_TLS_IPVER, ipver) |
+					FIELD_PREP(NFP_NET_TLS_VLAN,
+						   NFP_NET_TLS_VLAN_UNUSED));
+}
+
 static struct nfp_crypto_req_add_back *
 nfp_net_tls_set_ipv4(struct nfp_crypto_req_add_v4 *req, struct sock *sk,
 		     int direction)
@@ -154,9 +162,6 @@ nfp_net_tls_set_ipv4(struct nfp_crypto_req_add_v4 *req, struct sock *sk,
 	struct inet_sock *inet = inet_sk(sk);
 
 	req->front.key_len += sizeof(__be32) * 2;
-	req->front.ipver_vlan = cpu_to_be16(FIELD_PREP(NFP_NET_TLS_IPVER, 4) |
-					    FIELD_PREP(NFP_NET_TLS_VLAN,
-						       NFP_NET_TLS_VLAN_UNUSED));
 
 	if (direction == TLS_OFFLOAD_CTX_DIR_TX) {
 		req->src_ip = inet->inet_saddr;
@@ -177,9 +182,6 @@ nfp_net_tls_set_ipv6(struct nfp_crypto_req_add_v6 *req, struct sock *sk,
 	struct ipv6_pinfo *np = inet6_sk(sk);
 
 	req->front.key_len += sizeof(struct in6_addr) * 2;
-	req->front.ipver_vlan = cpu_to_be16(FIELD_PREP(NFP_NET_TLS_IPVER, 6) |
-					    FIELD_PREP(NFP_NET_TLS_VLAN,
-						       NFP_NET_TLS_VLAN_UNUSED));
 
 	if (direction == TLS_OFFLOAD_CTX_DIR_TX) {
 		memcpy(req->src_ip, &np->saddr, sizeof(req->src_ip));
@@ -304,6 +306,8 @@ nfp_net_tls_add(struct net_device *netdev, struct sock *sk,
 	front->opcode = nfp_tls_1_2_dir_to_opcode(direction);
 	memset(front->resv, 0, sizeof(front->resv));
 
+	nfp_net_tls_set_ipver_vlan(front, ipv6 ? 6 : 4);
+
 	if (ipv6)
 		back = nfp_net_tls_set_ipv6((void *)skb->data, sk, direction);
 	else
-- 
2.21.0

