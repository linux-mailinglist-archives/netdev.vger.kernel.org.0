Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F2BF39CAC4
	for <lists+netdev@lfdr.de>; Sat,  5 Jun 2021 21:39:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230099AbhFETlS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Jun 2021 15:41:18 -0400
Received: from mail-wr1-f41.google.com ([209.85.221.41]:36811 "EHLO
        mail-wr1-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229998AbhFETlR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 5 Jun 2021 15:41:17 -0400
Received: by mail-wr1-f41.google.com with SMTP id e11so2508975wrg.3;
        Sat, 05 Jun 2021 12:39:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=3GrYxT56XNME4bKlaCycc5lDDPukBRXU2exTZWylSWo=;
        b=Vp36yZCt2ooPxJXPANdCH2/6FDMlsKuNbiUQgu56IgA3VNdGzHC1ng5O3vGeY6aJae
         H3XYnLUbl9pNS8OIBGuUWvlsXnk3pCYJjeW44jaz+hY0vjBe8D8O6/8f8FploI86X/4G
         uErSQfXaI0rYYojbvoG0fNWrx9uQ9DJ12d+xFmRhxq8tiB3ZL9m81CmsubOqugWvpO8P
         8Oejsfe4jgCSlH+66Q74/Ox39mp1iQMoADv9WyA8lNqJ6Ce7Zzbj9QVjVouAxeQb8h1W
         vmMv5ZMwFY4daY/72RDlFWAUMtNxhePbI/HEeA2Nln9pmfjhtVcPqH2XyV9XHTV71E+S
         iSbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=3GrYxT56XNME4bKlaCycc5lDDPukBRXU2exTZWylSWo=;
        b=m0oQVFULND3NWzP6JFb8TR8MpTzJTgihbzIdPbDksEzMgZYakNod0/WUja4LxwOlBs
         GyZhYornTyMoykhTV5FccM2HWqW0kUpjVKEdisd8Z9toxsADxz3f6ndSaMaWXIwizQav
         BL+Ejjb1iSrfH+2Znn84q5/kkOXsekOcOI846EXY9+0YCTEIcLNeo9Zun7lcxIzKPL9I
         vcHGzsfuMwrSHK3i49VAUYhXE9Cbw7i6BPOapsZPcUZ5nSKgyJZ9O7ZDibUlNxmjoijY
         BzR3W7VFxuCaC9vSS9Rji0oMt7AwC9YDq/RmVbsijOM09AhaAZPvPUfcDlEFSnoEzpZf
         6sig==
X-Gm-Message-State: AOAM53373E3ke+HSjv4ZmRlHs7yyfwzjLMeM+3VM4TOBSOw5cGvh9YgN
        2HzRmoWUr98DNLW8IMeNSE1A0H4H8w8=
X-Google-Smtp-Source: ABdhPJzCOK97CjRyQZ44LI4gfLgk1Qlq0v4ujR0Oj5I8fm4lcTyabOK4YkTEqdxI3pt4ost+PgZfzw==
X-Received: by 2002:a5d:5752:: with SMTP id q18mr9767435wrw.419.1622921891645;
        Sat, 05 Jun 2021 12:38:11 -0700 (PDT)
Received: from cluster5 ([80.76.206.81])
        by smtp.gmail.com with ESMTPSA id m21sm7009243wms.42.2021.06.05.12.38.10
        (version=TLS1 cipher=ECDHE-ECDSA-AES128-SHA bits=128/128);
        Sat, 05 Jun 2021 12:38:11 -0700 (PDT)
From:   Matthew Hagan <mnhagan88@gmail.com>
Cc:     Matthew Hagan <mnhagan88@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [RFC PATCH net-next] net: dsa: tag_qca: Check for upstream VLAN tag
Date:   Sat,  5 Jun 2021 20:37:48 +0100
Message-Id: <20210605193749.730836-1-mnhagan88@gmail.com>
X-Mailer: git-send-email 2.26.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The qca_tag_rcv function unconditionally expects a QCA tag to be present
between source MAC and EtherType. However if an upstream switch is used,
this may create a special case where VLAN tags are subsequently inserted
between the source MAC and the QCA tag. Thus when qca_tag_rcv is called,
it will attempt to read the 802.1q TPID as a QCA tag. This results in
complication since the TPID will pass the QCA tag version checking on bits
14 and 15, but the resulting packet after trimming the TPID will be
unusable.

The tested case is a Meraki MX65 which features two QCA8337 switches with
their CPU ports attached to a BCM58625 switch ports 4 and 5 respectively.
In this case a VLAN tag with VID 0 is added by the upstream BCM switch
when the port is unconfigured and packets with this VLAN tag or without
will be accepted at the BCM's CPU port. However, it is arguably possible
that other switches may be configured to drop VLAN untagged traffic at
their respective CPU port. Thus where packets are VLAN untagged, the
default VLAN tag, added by the upstream switch, should be maintained. Where
inbound packets are already VLAN tagged when arriving at the QCA switch, we
should replace the default VLAN tag, added by the upstream port, with the
correct VLAN tag.

This patch introduces:
  1 - A check for a VLAN tag before EtherType. If found, skip past this to
      find the QCA tag.
  2 - Check for a second VLAN tag after the QCA tag if one was found in 1.
      If found, remove both the initial VLAN tag and the QCA tag. If not
      found, remove only the QCA tag to maintain the VLAN tag added by the
      upstream switch.

Signed-off-by: Matthew Hagan <mnhagan88@gmail.com>
---
 net/dsa/tag_qca.c | 41 +++++++++++++++++++++++++++++++----------
 1 file changed, 31 insertions(+), 10 deletions(-)

diff --git a/net/dsa/tag_qca.c b/net/dsa/tag_qca.c
index 88181b52f480..e5273a27bf8a 100644
--- a/net/dsa/tag_qca.c
+++ b/net/dsa/tag_qca.c
@@ -52,18 +52,27 @@ static struct sk_buff *qca_tag_rcv(struct sk_buff *skb, struct net_device *dev,
 				   struct packet_type *pt)
 {
 	u8 ver;
-	u16  hdr;
-	int port;
-	__be16 *phdr;
+	u16 hdr, vlan_hdr;
+	int port, vlan_offset = 0, vlan_skip = 0;
+	__be16 *phdr, *vlan_phdr;
 
 	if (unlikely(!pskb_may_pull(skb, QCA_HDR_LEN)))
 		return NULL;
 
-	/* The QCA header is added by the switch between src addr and Ethertype
-	 * At this point, skb->data points to ethertype so header should be
-	 * right before
+	/* The QCA header is added by the switch between src addr and
+	 * Ethertype. Normally at this point, skb->data points to ethertype so the
+	 * header should be right before. However if a VLAN tag has subsequently
+	 * been added upstream, we need to skip past it to find the QCA header.
 	 */
-	phdr = (__be16 *)(skb->data - 2);
+	vlan_phdr = (__be16 *)(skb->data - 2);
+	vlan_hdr = ntohs(*vlan_phdr);
+
+	/* Check for VLAN tag before QCA tag */
+	if (!(vlan_hdr ^ ETH_P_8021Q))
+		vlan_offset = VLAN_HLEN;
+
+	/* Look for QCA tag at the correct location */
+	phdr = (__be16 *)(skb->data - 2 + vlan_offset);
 	hdr = ntohs(*phdr);
 
 	/* Make sure the version is correct */
@@ -71,10 +80,22 @@ static struct sk_buff *qca_tag_rcv(struct sk_buff *skb, struct net_device *dev,
 	if (unlikely(ver != QCA_HDR_VERSION))
 		return NULL;
 
+	/* Check for second VLAN tag after QCA tag if one was found prior */
+	if (!!(vlan_offset)) {
+		vlan_phdr = (__be16 *)(skb->data + 4);
+		vlan_hdr = ntohs(*vlan_phdr);
+		if (!!(vlan_hdr ^ ETH_P_8021Q)) {
+		/* Do not remove existing tag in case a tag is required */
+			vlan_offset = 0;
+			vlan_skip = VLAN_HLEN;
+		}
+	}
+
 	/* Remove QCA tag and recalculate checksum */
-	skb_pull_rcsum(skb, QCA_HDR_LEN);
-	memmove(skb->data - ETH_HLEN, skb->data - ETH_HLEN - QCA_HDR_LEN,
-		ETH_HLEN - QCA_HDR_LEN);
+	skb_pull_rcsum(skb, QCA_HDR_LEN + vlan_offset);
+	memmove(skb->data - ETH_HLEN,
+		skb->data - ETH_HLEN - QCA_HDR_LEN - vlan_offset,
+		ETH_HLEN - QCA_HDR_LEN + vlan_skip);
 
 	/* Get source port information */
 	port = (hdr & QCA_HDR_RECV_SOURCE_PORT_MASK);
-- 
2.26.3

