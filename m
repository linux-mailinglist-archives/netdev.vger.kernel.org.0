Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8A7CD44ADE
	for <lists+netdev@lfdr.de>; Thu, 13 Jun 2019 20:39:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728488AbfFMSjP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Jun 2019 14:39:15 -0400
Received: from mail-qk1-f196.google.com ([209.85.222.196]:34701 "EHLO
        mail-qk1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727284AbfFMSjP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Jun 2019 14:39:15 -0400
Received: by mail-qk1-f196.google.com with SMTP id t8so57034qkt.1
        for <netdev@vger.kernel.org>; Thu, 13 Jun 2019 11:39:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=fG7KdnOGeTizXdkjtcRpcBTWJOSVA0iTVzumG80kjhE=;
        b=QGtVS0sE+FDYpmUfVMyZ2cAKVrCaebMduJ2NanSmpj5NnGb+ECGvlg7Vmegzcs1Ij2
         YAgd7UMYz9yKBeffuvCW+qVnX2gVlVIfwNX/OCnexpxyXynG6awZRZDm1mrW2gr5SlsO
         URwfIM7MOIS7pLMX3sFOsaMtcwZ16SQHyc/z29ZmJ/DxWPSTlAqQ1wajdqQ2qm8JWf1S
         3QGtMu+2z7pL90SfzScVgIayU6/hBXNmvVAcLN1+m2DGW1RkqkXzzUX9mtLdCbl5CbVm
         Vg8lNEFzq0/gjF3OzWfeAOks994rx1Vt6mUhaTwaBtRmjs15aXXx9ToLoxKEuUiqm1bH
         6TBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=fG7KdnOGeTizXdkjtcRpcBTWJOSVA0iTVzumG80kjhE=;
        b=SncDoiBscvTOrT+Ktim1AyYd0QP3q1w7+bCJtbP4v01JXCs681C5hQgHmGFbWND3WP
         OpLlxyjezJDZYS22ZiaEaq7acxlsxC+/eKZJJj9cCQD9hg7kS3FW2FEJouHAas0Be9JJ
         AA8DhLa0Qc6osxCoj9OEA616KP49UB0jEY5eSzq8XUd0jxsBpwzuzC1YXWumcyodzEH5
         eYRpmUUUU1Dlln82dp9f+vBq+s0fijCay9HDw7XtYeSZhVOlPoZWAX5TRJSgqHBHYCzx
         U35YtyL0OgJ86EccvOOW2kj8VJU8kGDv5xNM9fZnL2WzRtL+gVUcfp+TsS1yXEcVnrJ5
         QbSg==
X-Gm-Message-State: APjAAAW41hbjY7lWxPBqZJfv3HiZZ3s51DBpV7s9M3OHItuPyr0t13jh
        AEhRI4mF95SYqlTejapN+0TMENLcUQ==
X-Google-Smtp-Source: APXvYqx67y2YqCNIszcvrT30cX+sVwJ+UPMT8GrarkzAQRvqIPZ2XaGo8VXPuSI45/u6G+VPFjpxFQ==
X-Received: by 2002:a37:a86:: with SMTP id 128mr51649765qkk.169.1560451154044;
        Thu, 13 Jun 2019 11:39:14 -0700 (PDT)
Received: from localhost.localdomain ([104.238.32.36])
        by smtp.gmail.com with ESMTPSA id p37sm269753qtc.35.2019.06.13.11.39.12
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 13 Jun 2019 11:39:13 -0700 (PDT)
From:   Stephen Suryaputra <ssuryaextr@gmail.com>
To:     netdev@vger.kernel.org
Cc:     nikolay@cumulusnetworks.com,
        Stephen Suryaputra <ssuryaextr@gmail.com>
Subject: [PATCH net-next v3] ipv4: Support multipath hashing on inner IP pkts for GRE tunnel
Date:   Thu, 13 Jun 2019 14:38:58 -0400
Message-Id: <20190613183858.9892-1-ssuryaextr@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Multipath hash policy value of 0 isn't distributing since the outer IP
dest and src aren't varied eventhough the inner ones are. Since the flow
is on the inner ones in the case of tunneled traffic, hashing on them is
desired.

This is done mainly for IP over GRE, hence only tested for that. But
anything else supported by flow dissection should work.

v2: Use skb_flow_dissect_flow_keys() directly so that other tunneling
    can be supported through flow dissection (per Nikolay Aleksandrov).
v3: Remove accidental inclusion of ports in the hash keys and clarify
    the documentation (Nikolay Alexandrov).
Signed-off-by: Stephen Suryaputra <ssuryaextr@gmail.com>
---
 Documentation/networking/ip-sysctl.txt |  1 +
 net/ipv4/route.c                       | 17 +++++++++++++++++
 net/ipv4/sysctl_net_ipv4.c             |  2 +-
 3 files changed, 19 insertions(+), 1 deletion(-)

diff --git a/Documentation/networking/ip-sysctl.txt b/Documentation/networking/ip-sysctl.txt
index 5eedc6941ce5..f2ee426f13ad 100644
--- a/Documentation/networking/ip-sysctl.txt
+++ b/Documentation/networking/ip-sysctl.txt
@@ -80,6 +80,7 @@ fib_multipath_hash_policy - INTEGER
 	Possible values:
 	0 - Layer 3
 	1 - Layer 4
+	2 - Layer 3 or inner Layer 3 if present
 
 fib_sync_mem - UNSIGNED INTEGER
 	Amount of dirty memory from fib entries that can be backlogged before
diff --git a/net/ipv4/route.c b/net/ipv4/route.c
index 14c7fdacaa72..7ad96121ed8e 100644
--- a/net/ipv4/route.c
+++ b/net/ipv4/route.c
@@ -1872,6 +1872,23 @@ int fib_multipath_hash(const struct net *net, const struct flowi4 *fl4,
 			hash_keys.basic.ip_proto = fl4->flowi4_proto;
 		}
 		break;
+	case 2:
+		memset(&hash_keys, 0, sizeof(hash_keys));
+		hash_keys.control.addr_type = FLOW_DISSECTOR_KEY_IPV4_ADDRS;
+		/* skb is currently provided only when forwarding */
+		if (skb) {
+			struct flow_keys keys;
+
+			skb_flow_dissect_flow_keys(skb, &keys, 0);
+
+			hash_keys.addrs.v4addrs.src = keys.addrs.v4addrs.src;
+			hash_keys.addrs.v4addrs.dst = keys.addrs.v4addrs.dst;
+		} else {
+			/* Same as case 0 */
+			hash_keys.addrs.v4addrs.src = fl4->saddr;
+			hash_keys.addrs.v4addrs.dst = fl4->daddr;
+		}
+		break;
 	}
 	mhash = flow_hash_from_keys(&hash_keys);
 
diff --git a/net/ipv4/sysctl_net_ipv4.c b/net/ipv4/sysctl_net_ipv4.c
index 2316c08e9591..e1efc2e62d21 100644
--- a/net/ipv4/sysctl_net_ipv4.c
+++ b/net/ipv4/sysctl_net_ipv4.c
@@ -960,7 +960,7 @@ static struct ctl_table ipv4_net_table[] = {
 		.mode		= 0644,
 		.proc_handler	= proc_fib_multipath_hash_policy,
 		.extra1		= &zero,
-		.extra2		= &one,
+		.extra2		= &two,
 	},
 #endif
 	{
-- 
2.17.1

