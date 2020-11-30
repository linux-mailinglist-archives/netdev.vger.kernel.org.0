Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA7C42C8631
	for <lists+netdev@lfdr.de>; Mon, 30 Nov 2020 15:08:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726483AbgK3OHR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Nov 2020 09:07:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726462AbgK3OHQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Nov 2020 09:07:16 -0500
Received: from mail-lf1-x143.google.com (mail-lf1-x143.google.com [IPv6:2a00:1450:4864:20::143])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 527A8C0613D6
        for <netdev@vger.kernel.org>; Mon, 30 Nov 2020 06:06:30 -0800 (PST)
Received: by mail-lf1-x143.google.com with SMTP id q13so21172736lfr.10
        for <netdev@vger.kernel.org>; Mon, 30 Nov 2020 06:06:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=waldekranz-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :organization;
        bh=/KfAZdLcKAvjrpDU1E/2WOowI2qRomiaywYSfqciaZg=;
        b=vNB9SwC5wg9AbaXfqahB3YL/TkMHRjFJDG9vu89UX+HNqQvwOCM1rAGMtoZaIKrB9G
         qrbD9sgQG5lPsDJYu0rURFrwgg+7KLLrVm1oacb7snpB01Gx3igFhAwb94HeeFi84dGR
         iYb6OyhBcsLS0B/6wFdIuCOM1iga1OvKEGhvuazKKb+F+uyZxvPYiPPvNia7q3A7/GCk
         u8JiTXhyc7uH5+ax+gz9OezGQEOUaMMBL1HH/KLqwQ4y/YAijdb9wkpfL4kok77n992r
         231o5UW9n1XOv/tlA6nsepKVzf6N48OmEz72ML6TdPbJPNqopdGDjhA92UBMq9mmOhN8
         jo4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:organization;
        bh=/KfAZdLcKAvjrpDU1E/2WOowI2qRomiaywYSfqciaZg=;
        b=CtaoTBwCHg3pb8tNRIdHsZgjZerp5maftjuDb1NOxYmbxFYLfCqWZv1a9h+cFVcRXg
         0RILyrYOyi8/gf9g0jk9ZHl45HQs7LK2DZJVKw8/kXmDl3Ur1WdHDNC5bTNATGcKgUpO
         dDUaAdht4GfSfQyLf05mjWXOQOlKyRX4xs500KL42YksR9sVKCKvMryatNnyXnx+xvAe
         3aZQWE7S3Zf/b4d4df1xe8LbIlzGqM4wJGoDK3mM8yPHQEtY3cOKu0YucFiwtOxDmG+J
         xJ8wE3GlsSh0K9/2O7fEdCXCZcsCgjAvC997cAmTFxC7C44ubbPKzj8w+k++/uovcR5B
         ZArQ==
X-Gm-Message-State: AOAM530e9lfwhiC73iVxYfGIshCYXGPYawDWg40or0nNZuwO5TBEu7I+
        UEZJXvalbzy4tawPSeHEfHFxog==
X-Google-Smtp-Source: ABdhPJyQfxVu3Bowv4DoFKpJxGsQ0Ld8EbWjtRij45k1HM9Wl4Qw61eClDLnZ4whDzF3C/GVELChNw==
X-Received: by 2002:a19:ac02:: with SMTP id g2mr9509274lfc.536.1606745188622;
        Mon, 30 Nov 2020 06:06:28 -0800 (PST)
Received: from veiron.westermo.com (static-193-12-47-89.cust.tele2.se. [193.12.47.89])
        by smtp.gmail.com with ESMTPSA id v22sm2977292ljd.9.2020.11.30.06.06.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Nov 2020 06:06:27 -0800 (PST)
From:   Tobias Waldekranz <tobias@waldekranz.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        olteanv@gmail.com, j.vosburgh@gmail.com, vfalico@gmail.com,
        andy@greyhouse.net, netdev@vger.kernel.org
Subject: [PATCH v2 net-next 4/4] net: dsa: tag_dsa: Support reception of packets from LAG devices
Date:   Mon, 30 Nov 2020 15:06:10 +0100
Message-Id: <20201130140610.4018-5-tobias@waldekranz.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201130140610.4018-1-tobias@waldekranz.com>
References: <20201130140610.4018-1-tobias@waldekranz.com>
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

