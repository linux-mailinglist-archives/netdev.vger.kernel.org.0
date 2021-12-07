Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E3B846BE90
	for <lists+netdev@lfdr.de>; Tue,  7 Dec 2021 16:01:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238479AbhLGPDj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Dec 2021 10:03:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238469AbhLGPDd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Dec 2021 10:03:33 -0500
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA94DC061756;
        Tue,  7 Dec 2021 07:00:02 -0800 (PST)
Received: by mail-ed1-x529.google.com with SMTP id g14so57486451edb.8;
        Tue, 07 Dec 2021 07:00:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Lrxvm/YMo9RPdu6lnz1JYsvuKaJkhSXAhimn2KvvSNE=;
        b=A3xxPF0iZCNCbaeoPtdqsCawsu9ftiBeBje3yNelyrean30f6F/gm7GaBnJMo2qIFe
         +nrpOorA0wJY5HZA6hyyo/WbEC9fTwForw7CctkdyKYVhOzsIJw15wafSx8k3LeY/FhC
         xaNHuGueUtPKOzgpfUt99i/S6U/TcwBXQQKBjrnxwB3uOeNz2U02fCp+x3S/TrL+HJhD
         700Jg7PDpryVy2gtf8sX/9QCtWfOz5rAawrGuM4/tsweq2DpB609NGpPEEGfrp21NHEC
         zAbhZfwD8yhU6ZqNi+t+lw4y75TnzFKcrw+nyAS3TvhEBmXgSgvtnJXjpIYmFdl/jqvM
         t46w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Lrxvm/YMo9RPdu6lnz1JYsvuKaJkhSXAhimn2KvvSNE=;
        b=o2e+YO60WlEKjvPzuYUo2LcrXP7UEQLPxS7/Z2fqhSGu7Z6+v5maMIgSOYRaEvPF1F
         IBObyuN7QvmpAIeyZSPkIzWc3ABb/RlqFx54uHwPzamEL7IADY+DI+KSJ7xgR3AwtI0q
         YCxjqmqugebdi8troy60cU/HEAWoUxrPL5+LixTZzG0zu7Xazu3MyMPjc/pH8i1USO6T
         0DDNF0+cmHPBbSoW41UguBad+HqPuqH8W8ahtj6fwiU0j5YlFs8uH/I+Z/fe9TcDFiLG
         Q0ZEBIgTmAg/uYN9XiBorpTlhV0nIVIk7mSzVYurihSQklWdVXVkgGFs1zLG9pE+fDc3
         VBww==
X-Gm-Message-State: AOAM533XuwEvYE4rF7UG4cTeqw5mmjkMH7Taw0XMCZCRyeF1sHdRbptB
        O+IaNpzreGiy0xm1+TRQa8U=
X-Google-Smtp-Source: ABdhPJxEf5Q9HuIEZLWJBodwMvNtMLhHbXscoQymwT5I7jYmKbD1cc0/ZpdbK2Eb2Yu9ZQtGbXQ7XQ==
X-Received: by 2002:a17:907:1689:: with SMTP id hc9mr52133341ejc.445.1638889201162;
        Tue, 07 Dec 2021 07:00:01 -0800 (PST)
Received: from localhost.localdomain (93-42-71-246.ip85.fastwebnet.it. [93.42.71.246])
        by smtp.googlemail.com with ESMTPSA id i10sm9131821ejw.48.2021.12.07.07.00.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Dec 2021 07:00:00 -0800 (PST)
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     Ansuel Smith <ansuelsmth@gmail.com>
Subject: [net-next RFC PATCH 5/6] net: dsa: tag_qca: Add support for handling mdio read/write packet
Date:   Tue,  7 Dec 2021 15:59:41 +0100
Message-Id: <20211207145942.7444-6-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211207145942.7444-1-ansuelsmth@gmail.com>
References: <20211207145942.7444-1-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Handle mdio read/write Ethernet packet.
When a packet is received, these operation are done:
1. Qca HDR is checked.
2. Packet type is checked.
3. If the type is an mdio read/write packet is parsed.
4. The header data is parsed and put in the generic mdio struct.
5. The rest of the data is copied to the data mdio struct.
6. The seq number is checked and copared with the one in the mdio struct
7. The ack is set to true to set a correct read/write operation
8. The completion is complete
9. The packet is dropped.

Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
---
 net/dsa/tag_qca.c | 28 +++++++++++++++++++++++++++-
 1 file changed, 27 insertions(+), 1 deletion(-)

diff --git a/net/dsa/tag_qca.c b/net/dsa/tag_qca.c
index b8b05d54a74c..1d2c4f519c99 100644
--- a/net/dsa/tag_qca.c
+++ b/net/dsa/tag_qca.c
@@ -9,6 +9,30 @@
 
 #include "dsa_priv.h"
 
+static void qca_tag_handle_mdio_packet(struct sk_buff *skb,
+				       struct net_device *dev)
+{
+	struct mdio_ethhdr *mdio_ethhdr;
+	struct qca8k_port_tag *header;
+	struct dsa_port *cpu_dp;
+
+	cpu_dp = dev->dsa_ptr;
+	header = cpu_dp->priv;
+
+	mdio_ethhdr = (struct mdio_ethhdr *)skb_mac_header(skb);
+
+	header->data[0] = mdio_ethhdr->mdio_data;
+
+	/* Get the rest of the 12 byte of data */
+	memcpy(header->data + 1, skb->data, QCA_HDR_MDIO_DATA2_LEN);
+
+	/* Make sure the seq match the requested packet */
+	if (mdio_ethhdr->seq == header->seq)
+		header->ack = true;
+
+	complete(&header->rw_done);
+}
+
 static struct sk_buff *qca_tag_xmit(struct sk_buff *skb, struct net_device *dev)
 {
 	struct dsa_port *dp = dsa_slave_to_port(dev);
@@ -52,8 +76,10 @@ static struct sk_buff *qca_tag_rcv(struct sk_buff *skb, struct net_device *dev)
 	pk_type = FIELD_GET(QCA_HDR_RECV_TYPE, hdr);
 
 	/* MDIO read/write packet */
-	if (pk_type == QCA_HDR_RECV_TYPE_RW_REG_ACK)
+	if (pk_type == QCA_HDR_RECV_TYPE_RW_REG_ACK) {
+		qca_tag_handle_mdio_packet(skb, dev);
 		return NULL;
+	}
 
 	/* Remove QCA tag and recalculate checksum */
 	skb_pull_rcsum(skb, QCA_HDR_LEN);
-- 
2.32.0

