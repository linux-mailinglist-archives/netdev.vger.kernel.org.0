Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B27B44CFCCD
	for <lists+netdev@lfdr.de>; Mon,  7 Mar 2022 12:28:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239332AbiCGL3a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Mar 2022 06:29:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242099AbiCGL15 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Mar 2022 06:27:57 -0500
Received: from mail-lj1-x22c.google.com (mail-lj1-x22c.google.com [IPv6:2a00:1450:4864:20::22c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 509A425EB2
        for <netdev@vger.kernel.org>; Mon,  7 Mar 2022 03:06:39 -0800 (PST)
Received: by mail-lj1-x22c.google.com with SMTP id bn33so19830603ljb.6
        for <netdev@vger.kernel.org>; Mon, 07 Mar 2022 03:06:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=waldekranz-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version:organization
         :content-transfer-encoding;
        bh=WifnMpfCywQgn9v4uMmELkW8tbTMccZxaKxLll5l1aQ=;
        b=eAnQsrE7cV3O7z0DfiC9M6ePQ7R6Wf/NTn5yUiSvOOMRMEVAWu1841E+H9xmJgYPrg
         tN2F6ST9n6LKoA9AdoZq0J5wpjIVEfWp3vnZTc/UrhuyKQ2vU7Akwg+8dUTszWGoFo3Q
         u6Iv51ux37VgNJ9yli65JXJxItOuPM+mZ/sSaxmiUBEhMe8tt50kgxpAW7we+GJM85Z5
         3sugu20i0n6gsNifr+SyQ2EMmIHwA6hSkAuIkqJHlQQDWEHF763LAYsBeanN/XaPcaOz
         V9WF8LEUFSw3IkKo8nwFBNzDspCYMH8X9I5uuG5OYg+5+h1vZeQB2BrwKa8zWf27kFtb
         gl6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :organization:content-transfer-encoding;
        bh=WifnMpfCywQgn9v4uMmELkW8tbTMccZxaKxLll5l1aQ=;
        b=Xw8Xw7LejjZSwSbigPjSUCKo6X65dZgxYrE7d8swCP9EBF4Y5wmUFw54aJmunCJrHz
         q1cv6xZW9QJUKds58NtbYlHwnKRQtACf04TKg91TDDs/JLS95gNfD9R31N9chUY2q1WE
         dyRX4xpbnIaTPI1YpIciL6gQ0DLQJSG4IyUy+HoCsndr4b/b397+AHJl0bzmnPOHNf9q
         zJvpmj3HlB6N6WBcC2AObKTX+B6CwxwQV8G1w6NYkFbakxDIeBpe+qA21LqJt0Pk/pZk
         hyuqeT258ceTyLG1tWqB24JCExVgGfJ8FZVgqH7HT/XtYU5QoS9fBWxis9lXIXe0vdhy
         CxKg==
X-Gm-Message-State: AOAM5304mr0rcIlWsAQBi4vqXEcda00fem3xYFp8x18UTfF8KEAe+SrM
        ZD3G1luAdoswkg4LYY7xAfJINA==
X-Google-Smtp-Source: ABdhPJys6R6uyln+J9vxt+xgmUASyxV+ZscA/tTaibo7IdkPflGPTlBL6k5RdlSFPyBwtDa+ZGzI+g==
X-Received: by 2002:a2e:9f0e:0:b0:244:ddb5:8685 with SMTP id u14-20020a2e9f0e000000b00244ddb58685mr7474369ljk.151.1646651197442;
        Mon, 07 Mar 2022 03:06:37 -0800 (PST)
Received: from veiron.westermo.com (static-193-12-47-89.cust.tele2.se. [193.12.47.89])
        by smtp.gmail.com with ESMTPSA id u17-20020a056512095100b0044381f00805sm2793765lft.139.2022.03.07.03.06.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Mar 2022 03:06:36 -0800 (PST)
From:   Tobias Waldekranz <tobias@waldekranz.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH net-next] net: dsa: tag_dsa: Fix tx from VLAN uppers on non-filtering bridges
Date:   Mon,  7 Mar 2022 12:05:48 +0100
Message-Id: <20220307110548.812455-1-tobias@waldekranz.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Organization: Westermo
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In this situation (VLAN filtering disabled on br0):

    br0.10
     /
   br0
   / \
swp0 swp1

When a frame is transmitted from the VLAN upper, the bridge will send
it down to one of the switch ports with forward offloading
enabled. This will cause tag_dsa to generate a FORWARD tag. Before
this change, that tag would have it's VID set to 10, even though VID
10 is not loaded in the VTU.

Before the blamed commit, the frame would trigger a VTU miss and be
forwarded according to the PVT configuration. Now that all fabric
ports are in 802.1Q secure mode, the frame is dropped instead.

Therefore, restrict the condition under which we rewrite an 802.1Q tag
to a DSA tag. On standalone port's, reuse is always safe since we will
always generate FROM_CPU tags in that case. For bridged ports though,
we must ensure that VLAN filtering is enabled, which in turn
guarantees that the VID in question is loaded into the VTU.

Fixes: d352b20f4174 ("net: dsa: mv88e6xxx: Improve multichip isolation of standalone ports")
Signed-off-by: Tobias Waldekranz <tobias@waldekranz.com>
---
 net/dsa/tag_dsa.c | 15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

diff --git a/net/dsa/tag_dsa.c b/net/dsa/tag_dsa.c
index c8b4bbd46191..e4b6e3f2a3db 100644
--- a/net/dsa/tag_dsa.c
+++ b/net/dsa/tag_dsa.c
@@ -127,6 +127,7 @@ static struct sk_buff *dsa_xmit_ll(struct sk_buff *skb, struct net_device *dev,
 				   u8 extra)
 {
 	struct dsa_port *dp = dsa_slave_to_port(dev);
+	struct net_device *br_dev;
 	u8 tag_dev, tag_port;
 	enum dsa_cmd cmd;
 	u8 *dsa_header;
@@ -149,7 +150,16 @@ static struct sk_buff *dsa_xmit_ll(struct sk_buff *skb, struct net_device *dev,
 		tag_port = dp->index;
 	}
 
-	if (skb->protocol == htons(ETH_P_8021Q)) {
+	br_dev = dsa_port_bridge_dev_get(dp);
+
+	/* If frame is already 802.1Q tagged, we can convert it to a DSA
+	 * tag (avoiding a memmove), but only if the port is standalone
+	 * (in which case we always send FROM_CPU) or if the port's
+	 * bridge has VLAN filtering enabled (in which case the CPU port
+	 * will be a member of the VLAN).
+	 */
+	if (skb->protocol == htons(ETH_P_8021Q) &&
+	    (!br_dev || br_vlan_enabled(br_dev))) {
 		if (extra) {
 			skb_push(skb, extra);
 			dsa_alloc_etype_header(skb, extra);
@@ -166,10 +176,9 @@ static struct sk_buff *dsa_xmit_ll(struct sk_buff *skb, struct net_device *dev,
 			dsa_header[2] &= ~0x10;
 		}
 	} else {
-		struct net_device *br = dsa_port_bridge_dev_get(dp);
 		u16 vid;
 
-		vid = br ? MV88E6XXX_VID_BRIDGED : MV88E6XXX_VID_STANDALONE;
+		vid = br_dev ? MV88E6XXX_VID_BRIDGED : MV88E6XXX_VID_STANDALONE;
 
 		skb_push(skb, DSA_HLEN + extra);
 		dsa_alloc_etype_header(skb, DSA_HLEN + extra);
-- 
2.25.1

