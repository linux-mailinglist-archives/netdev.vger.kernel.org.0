Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F271B44834
	for <lists+netdev@lfdr.de>; Thu, 13 Jun 2019 19:07:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393397AbfFMRFY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Jun 2019 13:05:24 -0400
Received: from mail-qt1-f193.google.com ([209.85.160.193]:32882 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389476AbfFMRFY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Jun 2019 13:05:24 -0400
Received: by mail-qt1-f193.google.com with SMTP id x2so22497907qtr.0
        for <netdev@vger.kernel.org>; Thu, 13 Jun 2019 10:05:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=4K7zwXAPgbVzwuM1IVU5EiM5bpOmaNDg2s3SE0Ufa/c=;
        b=BbMVeyDc3s4q1ZPpUHAds4LmmaQwVF7ygF92jvsLICXyJKhg58j6zgVk7LLz87jEMC
         iMOuYgitHyB1z7p2nzwFLFTvtAN3sNA/ZjTxPUp1DVBgCBxL0NMe9uvvE1tB3Dgv7j1v
         M+T+2fh0rn2ohlmHKYP5eLPyVHOb4D/ra7fAYt4Ejc6msTk3jeA/0KXbt6RwVRVtuKXL
         zjQ4MTY2+XXwxLnbv3Qu4wrsuRsDUJ4l3UzXRII9PvTTXMsdHBorhTkDlHlN+6A1pJVZ
         nIARV7gkwF3ERltNdBlknG+1BUpE+o+I+vrJl2cu8CjXR1MJnSyiqe5GeJnJsDirS3Jg
         LVNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=4K7zwXAPgbVzwuM1IVU5EiM5bpOmaNDg2s3SE0Ufa/c=;
        b=eAns2Jvd2A+vaeYpA71z7+DdvCZO+ACHDY+RRar2E4x+PpemEJDkO5bTMg1e8YAsNh
         yXqRMI3ryNecZ+oqBRRj6otkukMMDpKu91uGGt1LHbjFOseyaAAVkb1fnMBBAK8hswbB
         wxQb1/ELJ3psT+Q33m1XJiA/G3YVc90fSzBHIn5vw83lmJqTmd2SOiXGzKUZJUVV0Dlk
         bD8sEooB8X7A5gfGJC6xUUSjGprlJdw7uTvqCB2lhFnt2awRvgroBui46mtQnO/VUFCF
         /l8R7M2hH0Upfd4goO2Aw81gvXyDlwMY2CSx1b8dzdEJy9Jnp4/Hl/wBTtSqqIKvEa1z
         MSjg==
X-Gm-Message-State: APjAAAU8ALg3kbrV4j+C7YArnaRdqpjRSb8SzhtS8l778aRxQSqqrVfz
        bOM8ip0tYwFxXz+Uu8zpuQ0JB5HbPg==
X-Google-Smtp-Source: APXvYqwV0gI2xqLlRQq8Myyn4eJANjRRm9FYrTfhNM+gI9sg/6WWTvCpW6k+1UfHRm0i1FzhAaeBAg==
X-Received: by 2002:a0c:fd48:: with SMTP id j8mr4521696qvs.10.1560445522548;
        Thu, 13 Jun 2019 10:05:22 -0700 (PDT)
Received: from localhost.localdomain ([104.238.32.36])
        by smtp.gmail.com with ESMTPSA id v186sm71988qkc.36.2019.06.13.10.05.21
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 13 Jun 2019 10:05:21 -0700 (PDT)
From:   Stephen Suryaputra <ssuryaextr@gmail.com>
To:     netdev@vger.kernel.org
Cc:     nikolay@cumulusnetworks.com,
        Stephen Suryaputra <ssuryaextr@gmail.com>
Subject: [PATCH net-next v2] ipv4: Support multipath hashing on inner IP pkts for GRE tunnel
Date:   Thu, 13 Jun 2019 13:03:30 -0400
Message-Id: <20190613170330.8783-1-ssuryaextr@gmail.com>
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
Signed-off-by: Stephen Suryaputra <ssuryaextr@gmail.com>
---
 Documentation/networking/ip-sysctl.txt |  1 +
 net/ipv4/route.c                       | 20 ++++++++++++++++++++
 net/ipv4/sysctl_net_ipv4.c             |  2 +-
 3 files changed, 22 insertions(+), 1 deletion(-)

diff --git a/Documentation/networking/ip-sysctl.txt b/Documentation/networking/ip-sysctl.txt
index 5eedc6941ce5..2f3bc910895a 100644
--- a/Documentation/networking/ip-sysctl.txt
+++ b/Documentation/networking/ip-sysctl.txt
@@ -80,6 +80,7 @@ fib_multipath_hash_policy - INTEGER
 	Possible values:
 	0 - Layer 3
 	1 - Layer 4
+	2 - Inner Layer 3 for tunneled IP packets.
 
 fib_sync_mem - UNSIGNED INTEGER
 	Amount of dirty memory from fib entries that can be backlogged before
diff --git a/net/ipv4/route.c b/net/ipv4/route.c
index 14c7fdacaa72..c3e03bce0a3a 100644
--- a/net/ipv4/route.c
+++ b/net/ipv4/route.c
@@ -1872,6 +1872,26 @@ int fib_multipath_hash(const struct net *net, const struct flowi4 *fl4,
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
+			hash_keys.ports.src = keys.ports.src;
+			hash_keys.ports.dst = keys.ports.dst;
+			hash_keys.basic.ip_proto = keys.basic.ip_proto;
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

