Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D2D8C2CB866
	for <lists+netdev@lfdr.de>; Wed,  2 Dec 2020 10:18:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388120AbgLBJPT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Dec 2020 04:15:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388100AbgLBJPR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Dec 2020 04:15:17 -0500
Received: from mail-lf1-x142.google.com (mail-lf1-x142.google.com [IPv6:2a00:1450:4864:20::142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DC5EC0617A7
        for <netdev@vger.kernel.org>; Wed,  2 Dec 2020 01:14:31 -0800 (PST)
Received: by mail-lf1-x142.google.com with SMTP id d20so3138829lfe.11
        for <netdev@vger.kernel.org>; Wed, 02 Dec 2020 01:14:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=waldekranz-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :organization;
        bh=/KfAZdLcKAvjrpDU1E/2WOowI2qRomiaywYSfqciaZg=;
        b=gVAWd1dOMx+aviQupUF7gf+RCZkTrhs3eqQ8cNTASrhhpK70EN3LumVpYYMszWgTIi
         aiW8guv9tsHSCuXGmEX6SDuSHXrgCjlmGdao2APxrI739qHQGecKWU7epDjlbc7u3RPZ
         fCZmg7w5mCnDPABJDBEv/l/f0cvCmOZLdw75M4+j789OJRmgvLOtbc3hwCHOcBp+/Xqu
         VaX6Y3xKiB1JYFqjCCTEHU5Q1wdM9CnKOnV1gvewhlDq0p2YtzktyJT9a1qdFwafRro3
         ldogH3SBCr/8/ap9cIHPYduZ/3oYHCIDQ5RQ5GAuRoI4BcpMMI0SKoRfaRu2cWUc4AmJ
         hADQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:organization;
        bh=/KfAZdLcKAvjrpDU1E/2WOowI2qRomiaywYSfqciaZg=;
        b=hUpcMDhGbz784ry+bAtab2zY3DZq9bqM13xs+zn4iT2cD7e7fNijwlmVb1cOgcWsm0
         yZcrETnX7S2Ij+tZswAQ6kVq/CiPqxGGVJ5EGikdBz3iB85fqVKBSUIGtLVkC+VSASJu
         uwO9IrAyoPSRQNUgqTqPYUtFp3OcqE7CIIsAsl1ZuNjLDmUXvg8PRZ8NguLWPn8bNmAU
         EFpNX1JWZdN19XoIVaNbEiJEUDwewfHWvxWv61CuTA8ouHDDdVsNhJWx2a0GKWeIOxva
         RGuqgCmL8hirbYAIpSSTy2J+GTWggbZ1sOVJt7hPnM6OKav+KqZYgLB5mYMCZyuInWui
         vvYg==
X-Gm-Message-State: AOAM531Mbo9WCbSMCLt3Wd7oxOr/HEmpxTBIO9Z+7WKs4BLz60SrYbLj
        FwailpalAF+PcsRhuT0ln8HZFA==
X-Google-Smtp-Source: ABdhPJx3Ld1/tjXZ+d21lREu7TIqnYHs1MiPabru2+hMjz+sh2/zDf1jICXZAb6aozo+emLguRQoYw==
X-Received: by 2002:a19:c3cd:: with SMTP id t196mr897053lff.26.1606900469712;
        Wed, 02 Dec 2020 01:14:29 -0800 (PST)
Received: from veiron.westermo.com (static-193-12-47-89.cust.tele2.se. [193.12.47.89])
        by smtp.gmail.com with ESMTPSA id v1sm295970lfg.252.2020.12.02.01.14.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Dec 2020 01:14:29 -0800 (PST)
From:   Tobias Waldekranz <tobias@waldekranz.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        olteanv@gmail.com, j.vosburgh@gmail.com, vfalico@gmail.com,
        andy@greyhouse.net, netdev@vger.kernel.org
Subject: [PATCH v3 net-next 4/4] net: dsa: tag_dsa: Support reception of packets from LAG devices
Date:   Wed,  2 Dec 2020 10:13:56 +0100
Message-Id: <20201202091356.24075-5-tobias@waldekranz.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201202091356.24075-1-tobias@waldekranz.com>
References: <20201202091356.24075-1-tobias@waldekranz.com>
Organization: Westermo
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Packets ingressing on a LAG that egress on the CPU port, which are not
classified as management, will have a FORWARD tag that does not
contain the normal source device/port tuple. Instead the trunk bit
will be set, and the port field holds the LAG id.

Since the exact source port information is not available in the tag,
frames are injected directly on the LAG interface and thus do never
pass through any DSA port interface on ingress.

Management frames (TO_CPU) are not affected and will pass through the
DSA port interface as usual.

Signed-off-by: Tobias Waldekranz <tobias@waldekranz.com>
---
 net/dsa/dsa.c     | 12 +++++++++++-
 net/dsa/tag_dsa.c | 17 ++++++++++++++++-
 2 files changed, 27 insertions(+), 2 deletions(-)

diff --git a/net/dsa/dsa.c b/net/dsa/dsa.c
index a1b1dc8a4d87..7325bf4608e9 100644
--- a/net/dsa/dsa.c
+++ b/net/dsa/dsa.c
@@ -219,11 +219,21 @@ static int dsa_switch_rcv(struct sk_buff *skb, struct net_device *dev,
 	}
 
 	skb = nskb;
-	p = netdev_priv(skb->dev);
 	skb_push(skb, ETH_HLEN);
 	skb->pkt_type = PACKET_HOST;
 	skb->protocol = eth_type_trans(skb, skb->dev);
 
+	if (unlikely(!dsa_slave_dev_check(skb->dev))) {
+		/* Packet is to be injected directly on an upper
+		 * device, e.g. a team/bond, so skip all DSA-port
+		 * specific actions.
+		 */
+		netif_rx(skb);
+		return 0;
+	}
+
+	p = netdev_priv(skb->dev);
+
 	if (unlikely(cpu_dp->ds->untag_bridge_pvid)) {
 		nskb = dsa_untag_bridge_pvid(skb);
 		if (!nskb) {
diff --git a/net/dsa/tag_dsa.c b/net/dsa/tag_dsa.c
index 112c7c6dd568..be7271de8d0b 100644
--- a/net/dsa/tag_dsa.c
+++ b/net/dsa/tag_dsa.c
@@ -163,6 +163,7 @@ static struct sk_buff *dsa_rcv_ll(struct sk_buff *skb, struct net_device *dev,
 				  u8 extra)
 {
 	int source_device, source_port;
+	bool trunk = false;
 	enum dsa_code code;
 	enum dsa_cmd cmd;
 	u8 *dsa_header;
@@ -174,6 +175,8 @@ static struct sk_buff *dsa_rcv_ll(struct sk_buff *skb, struct net_device *dev,
 	switch (cmd) {
 	case DSA_CMD_FORWARD:
 		skb->offload_fwd_mark = 1;
+
+		trunk = !!(dsa_header[1] & 7);
 		break;
 
 	case DSA_CMD_TO_CPU:
@@ -216,7 +219,19 @@ static struct sk_buff *dsa_rcv_ll(struct sk_buff *skb, struct net_device *dev,
 	source_device = dsa_header[0] & 0x1f;
 	source_port = (dsa_header[1] >> 3) & 0x1f;
 
-	skb->dev = dsa_master_find_slave(dev, source_device, source_port);
+	if (trunk) {
+		struct dsa_port *cpu_dp = dev->dsa_ptr;
+
+		/* The exact source port is not available in the tag,
+		 * so we inject the frame directly on the upper
+		 * team/bond.
+		 */
+		skb->dev = dsa_lag_dev_by_id(cpu_dp->dst, source_port);
+	} else {
+		skb->dev = dsa_master_find_slave(dev, source_device,
+						 source_port);
+	}
+
 	if (!skb->dev)
 		return NULL;
 
-- 
2.17.1

