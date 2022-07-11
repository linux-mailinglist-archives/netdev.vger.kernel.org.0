Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0B75557097C
	for <lists+netdev@lfdr.de>; Mon, 11 Jul 2022 19:51:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231502AbiGKRvU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jul 2022 13:51:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229903AbiGKRvT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Jul 2022 13:51:19 -0400
Received: from mail-pg1-x52e.google.com (mail-pg1-x52e.google.com [IPv6:2607:f8b0:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A7531837A;
        Mon, 11 Jul 2022 10:51:18 -0700 (PDT)
Received: by mail-pg1-x52e.google.com with SMTP id 23so5339626pgc.8;
        Mon, 11 Jul 2022 10:51:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=4oDZ1Crn9MlQE04m4pVvJlit0fCvsFP5x7XIgH7fYfM=;
        b=b8LwSRw/PlW65zqssb8/WFS8QFhfvSLTlv+2tAg4djYUI+uysSprVrq3jSImT3Qs7Q
         NdMfjL8v45aMoZ7P7xv9JuHxvbZ5TmFzHVePbzJDTVEqvRZ70UgpMTUzyllZzQAO5lvx
         nEqjZ8E6qKYxo2jAT8WZVMGOE9mDLt5GDe2kgYpPMbrTJ+MpIleZmMBZ9196dNsXI7b4
         DDknlx8XpcZ1QXbXhuaqu1sCn6WOnFEVHMRP3wTW9qtX7rc/Rl0jMUEQ9GK6IShYFoT/
         GtcsrMLHvRcTTgQVw016jN8/bd4Te4B8bS0pX9htERsnbemCPihb0BI+igpP5qJKPbwX
         XB/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=4oDZ1Crn9MlQE04m4pVvJlit0fCvsFP5x7XIgH7fYfM=;
        b=VgsxfFd+sJuN6I9y9VtaU5nkW7XB5bOFSOIvyTtjx163sYYuL6oIZ+iDjzwGqMN0JH
         skuvqlkA18cBImjraLmXoi+qLAS7yfVSWhh8GT2jw/OMlmNXUdgQyhwHbPGVnl1w5PAu
         7FvVF+jwWatkK+h8bkZFkifgJgeuuSeDbw27w7wizEVGV3al+kDfm6q2d9uQjLXlQPRW
         n156lpuJ0YGOS/K5w7YeCY9igs8EOAsyzcWWg3TTDlIHn5nsJMAEX9aoeJrBlTNf8pJb
         g7/k9dIllTl/+uMuvxWdc17sem7n/kqP15wa3GezL6DozIQHfIdWlnyk/CSv6mhEzUiS
         FM9A==
X-Gm-Message-State: AJIora+mAQeoXhfVQBbsnI4034OF36yuOvNk0lC21rrTuj0zB3N2AT8e
        kSb80U9spJKhBD5Gm1rVkgnRqwyXAdn/s+foLjA=
X-Google-Smtp-Source: AGRyM1scyMivBoMnJl+5WqLQ90qHV1rOHD8vHnPgTUYntorLUvpupNY2EYI1H828kZeLbZyrdbB1sA==
X-Received: by 2002:a63:de43:0:b0:40d:a0f0:441 with SMTP id y3-20020a63de43000000b0040da0f00441mr16569383pgi.121.1657561877486;
        Mon, 11 Jul 2022 10:51:17 -0700 (PDT)
Received: from localhost.localdomain ([64.141.80.140])
        by smtp.gmail.com with ESMTPSA id h14-20020a056a00000e00b0051bbe085f16sm5041737pfk.104.2022.07.11.10.51.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Jul 2022 10:51:17 -0700 (PDT)
From:   Jaehee Park <jhpark1013@gmail.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        shuah@kernel.org, linux-kernel@vger.kernel.org, aajith@arista.com,
        roopa@nvidia.com, aroulin@nvidia.com, sbrivio@redhat.com,
        jhpark1013@gmail.com
Subject: [PATCH net-next 1/3] net: ipv4: new arp_accept option to accept garp only if in-network
Date:   Mon, 11 Jul 2022 13:51:16 -0400
Message-Id: <3d46841cb86de597157121c6c1f2dc6a8a8bf981.1657556229.git.jhpark1013@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <cover.1657556229.git.jhpark1013@gmail.com>
References: <cover.1657556229.git.jhpark1013@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In many deployments, we want the option to not learn a neighbor from
garp if the src ip is not in the subnet of addresses configured on the
interface. net.ipv4.arp_accept sysctl is currently used to control
creation of a neigh from a received garp packet. This patch adds a
new option '2' to net.ipv4.arp_accept which extends option '1' by
including the subnet check.

Signed-off-by: Jaehee Park <jhpark1013@gmail.com>
Suggested-by: Roopa Prabhu <roopa@nvidia.com>
---
 Documentation/networking/ip-sysctl.rst |  4 +++-
 include/linux/inetdevice.h             |  2 +-
 net/ipv4/arp.c                         | 24 ++++++++++++++++++++++--
 3 files changed, 26 insertions(+), 4 deletions(-)

diff --git a/Documentation/networking/ip-sysctl.rst b/Documentation/networking/ip-sysctl.rst
index 4c8bbf5acfd1..599373601a2b 100644
--- a/Documentation/networking/ip-sysctl.rst
+++ b/Documentation/networking/ip-sysctl.rst
@@ -1633,12 +1633,14 @@ arp_notify - BOOLEAN
 	     or hardware address changes.
 	 ==  ==========================================================
 
-arp_accept - BOOLEAN
+arp_accept - INTEGER
 	Define behavior for gratuitous ARP frames who's IP is not
 	already present in the ARP table:
 
 	- 0 - don't create new entries in the ARP table
 	- 1 - create new entries in the ARP table
+	- 2 - create new entries only if src ip is in the same subnet as
+	  the configured address on the received interface
 
 	Both replies and requests type gratuitous arp will trigger the
 	ARP table to be updated, if this setting is on.
diff --git a/include/linux/inetdevice.h b/include/linux/inetdevice.h
index ead323243e7b..ddb27fc0ee8c 100644
--- a/include/linux/inetdevice.h
+++ b/include/linux/inetdevice.h
@@ -131,7 +131,7 @@ static inline void ipv4_devconf_setall(struct in_device *in_dev)
 	IN_DEV_ORCONF((in_dev), IGNORE_ROUTES_WITH_LINKDOWN)
 
 #define IN_DEV_ARPFILTER(in_dev)	IN_DEV_ORCONF((in_dev), ARPFILTER)
-#define IN_DEV_ARP_ACCEPT(in_dev)	IN_DEV_ORCONF((in_dev), ARP_ACCEPT)
+#define IN_DEV_ARP_ACCEPT(in_dev)	IN_DEV_MAXCONF((in_dev), ARP_ACCEPT)
 #define IN_DEV_ARP_ANNOUNCE(in_dev)	IN_DEV_MAXCONF((in_dev), ARP_ANNOUNCE)
 #define IN_DEV_ARP_IGNORE(in_dev)	IN_DEV_MAXCONF((in_dev), ARP_IGNORE)
 #define IN_DEV_ARP_NOTIFY(in_dev)	IN_DEV_MAXCONF((in_dev), ARP_NOTIFY)
diff --git a/net/ipv4/arp.c b/net/ipv4/arp.c
index af2f12ffc9ca..5eedb042c50b 100644
--- a/net/ipv4/arp.c
+++ b/net/ipv4/arp.c
@@ -429,6 +429,26 @@ static int arp_ignore(struct in_device *in_dev, __be32 sip, __be32 tip)
 	return !inet_confirm_addr(net, in_dev, sip, tip, scope);
 }
 
+static int arp_accept(struct in_device *in_dev, __be32 sip)
+{
+	struct net *net = dev_net(in_dev->dev);
+	int scope = RT_SCOPE_LINK;
+
+	switch (IN_DEV_ARP_ACCEPT(in_dev)) {
+	case 0: /* don't create new entries from garp */
+		return 0;
+	case 1: /* create new entries from garp */
+		return 1;
+	case 2: /*
+		 * create garp only if sip is in the same subnet
+		 * as an address configured on the incoming interface
+		 */
+		return inet_confirm_addr(net, in_dev, sip, 0, scope) ? 1 : 0;
+	default:
+		return 0;
+	}
+}
+
 static int arp_filter(__be32 sip, __be32 tip, struct net_device *dev)
 {
 	struct rtable *rt;
@@ -868,12 +888,12 @@ static int arp_process(struct net *net, struct sock *sk, struct sk_buff *skb)
 	n = __neigh_lookup(&arp_tbl, &sip, dev, 0);
 
 	addr_type = -1;
-	if (n || IN_DEV_ARP_ACCEPT(in_dev)) {
+	if (n || arp_accept(in_dev, sip)) {
 		is_garp = arp_is_garp(net, dev, &addr_type, arp->ar_op,
 				      sip, tip, sha, tha);
 	}
 
-	if (IN_DEV_ARP_ACCEPT(in_dev)) {
+	if (arp_accept(in_dev, sip)) {
 		/* Unsolicited ARP is not accepted by default.
 		   It is possible, that this option should be enabled for some
 		   devices (strip is candidate)
-- 
2.30.2

