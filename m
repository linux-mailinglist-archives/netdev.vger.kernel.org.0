Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DAD1425853
	for <lists+netdev@lfdr.de>; Tue, 21 May 2019 21:31:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727646AbfEUTbH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 May 2019 15:31:07 -0400
Received: from mail-qt1-f194.google.com ([209.85.160.194]:42575 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727547AbfEUTbG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 May 2019 15:31:06 -0400
Received: by mail-qt1-f194.google.com with SMTP id j53so21924045qta.9
        for <netdev@vger.kernel.org>; Tue, 21 May 2019 12:31:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=oGgntIOfX9PUmbxlHqCBqldMp9HY88JAOK2tk04LcFU=;
        b=YSd50non6Z3hzpan5HXah6NjCoBYm7n8ax6FY+wquvL6e3b8c1rtfkSj8JXJLSswWo
         P3x8zYFSaGhsGvMgpmQL9VSGYLgyHYT/Y8Jp9PYUpO/Tw3AdqHJNLRvAXgUBcianvgBe
         W2t64N7KpCAvCBT0RPKOsRVkDG2qx0XABLCIeNu8d+BDlJNoWTAKmdZlj755rJyJ4NeN
         NbxUl7AfcxFNAnCnjxf6QPhXgW0urpP7uZ+7HBfVI/ObTuCBsvCGHPGm7TMNQ6iWeyNa
         Jq82Iql78h3epn6jC/EHP2o8pZyUT0psXuRAIXZqSpbUatup4gQu8tAwBfcV0ENGrWOp
         VGqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=oGgntIOfX9PUmbxlHqCBqldMp9HY88JAOK2tk04LcFU=;
        b=GG9NBB8CkaD5F/PcezQaTLCTTy+F+S+16buzNIagRDMSeTwD/F4r0ztanBYiq1ME/8
         0kjn2ZFCbOcN5d0ZO117WsXcUVNIUq7w7r1AS+qXnrEbIiXd+BY3N+95d++hdOV3kAyM
         gbsfPJuCPZ7LpeioGuZNivzIJLC8rdk1cZJ+cxpntkJNoMq7lFhcKpI6hUBs9wx+Q16x
         0EhYiFI/XEYVxNjEB5Z3YQkaZGKfdLPuMR6osBbBOrTkTAa+wHF5BwXoxZsd89eqZMpi
         qWDGSngzgTH2ZBhEKIx9CeFZu1RPQsKL9+qvxjb/7nDVgMnJLVl1aTWLk2jiei2y0FXt
         IZng==
X-Gm-Message-State: APjAAAUXZrtL+XWCFIfp2V/um1cEZzaNWJLqBDIxWDYmoeQ2941z/vY9
        DY3ijXIe7CSmrbYpfg56rLoVRrul
X-Google-Smtp-Source: APXvYqw1K1xFozoKKV0XzcDGiJhn4lBdWNqGky5MNQgodjLxmKhmRflHysuk0SqWMRgOduk+ekY5ng==
X-Received: by 2002:ac8:30c6:: with SMTP id w6mr72771932qta.186.1558467064903;
        Tue, 21 May 2019 12:31:04 -0700 (PDT)
Received: from localhost (modemcable249.105-163-184.mc.videotron.ca. [184.163.105.249])
        by smtp.gmail.com with ESMTPSA id l3sm8799570qkd.49.2019.05.21.12.31.04
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 21 May 2019 12:31:04 -0700 (PDT)
From:   Vivien Didelot <vivien.didelot@gmail.com>
To:     netdev@vger.kernel.org
Cc:     cphealy@gmail.com, Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>
Subject: [RFC net-next 9/9] net: dsa: mv88e6xxx: setup RMU bus
Date:   Tue, 21 May 2019 15:30:04 -0400
Message-Id: <20190521193004.10767-10-vivien.didelot@gmail.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190521193004.10767-1-vivien.didelot@gmail.com>
References: <20190521193004.10767-1-vivien.didelot@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Implement the RMU register operations Read and Write and setup a
proper bus to use as an alternative for SMI.

Signed-off-by: Vivien Didelot <vivien.didelot@gmail.com>
---
 drivers/net/dsa/mv88e6xxx/chip.c |  14 ++
 drivers/net/dsa/mv88e6xxx/chip.h |  10 ++
 drivers/net/dsa/mv88e6xxx/rmu.c  | 256 +++++++++++++++++++++++++++++++
 drivers/net/dsa/mv88e6xxx/rmu.h  |   1 +
 4 files changed, 281 insertions(+)

diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index 048fdaf1335e..68c247e951aa 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -4573,6 +4573,19 @@ static int mv88e6xxx_port_egress_floods(struct dsa_switch *ds, int port,
 	return err;
 }
 
+static bool mv88e6xxx_rcv(struct dsa_switch *ds, struct sk_buff *skb)
+{
+	struct mv88e6xxx_chip *chip = ds->priv;
+
+	/* When this operation is called after a request,
+	 * the mutex must already be held.
+	 */
+	if (mutex_is_locked(&chip->reg_lock))
+		return !!mv88e6xxx_rmu_response(chip, skb);
+
+	return false;
+}
+
 static const struct dsa_switch_ops mv88e6xxx_switch_ops = {
 	.get_tag_protocol	= mv88e6xxx_get_tag_protocol,
 	.setup			= mv88e6xxx_setup,
@@ -4617,6 +4630,7 @@ static const struct dsa_switch_ops mv88e6xxx_switch_ops = {
 	.port_txtstamp		= mv88e6xxx_port_txtstamp,
 	.port_rxtstamp		= mv88e6xxx_port_rxtstamp,
 	.get_ts_info		= mv88e6xxx_get_ts_info,
+	.rcv			= mv88e6xxx_rcv,
 };
 
 static int mv88e6xxx_register_switch(struct mv88e6xxx_chip *chip)
diff --git a/drivers/net/dsa/mv88e6xxx/chip.h b/drivers/net/dsa/mv88e6xxx/chip.h
index 2af574169e14..bf328cea67c8 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.h
+++ b/drivers/net/dsa/mv88e6xxx/chip.h
@@ -12,6 +12,7 @@
 #ifndef _MV88E6XXX_CHIP_H
 #define _MV88E6XXX_CHIP_H
 
+#include <linux/completion.h>
 #include <linux/if_vlan.h>
 #include <linux/irq.h>
 #include <linux/gpio/consumer.h>
@@ -214,6 +215,15 @@ struct mv88e6xxx_chip {
 	struct mii_bus *bus;
 	int sw_addr;
 
+	/* Register access through the Remote Management Unit */
+	const struct mv88e6xxx_bus_ops *rmu_ops;
+	struct completion rmu_response_received;
+	const unsigned char *rmu_response_data;
+	size_t rmu_response_data_len;
+	struct sk_buff *rmu_response;
+	struct net_device *rmu_dev;
+	u8 rmu_sequence_num;
+
 	/* Handles automatic disabling and re-enabling of the PHY
 	 * polling unit.
 	 */
diff --git a/drivers/net/dsa/mv88e6xxx/rmu.c b/drivers/net/dsa/mv88e6xxx/rmu.c
index 71dabe6ecb46..b7dbd843753a 100644
--- a/drivers/net/dsa/mv88e6xxx/rmu.c
+++ b/drivers/net/dsa/mv88e6xxx/rmu.c
@@ -9,9 +9,255 @@
  * (at your option) any later version.
  */
 
+#include <linux/if_ether.h>
+
 #include "chip.h"
 #include "rmu.h"
 
+#define MV88E6XXX_RMU_TIMEOUT (msecs_to_jiffies(1000))
+
+static int mv88e6xxx_rmu_wait_response(struct mv88e6xxx_chip *chip)
+{
+	long timeout;
+
+	timeout = wait_for_completion_interruptible_timeout(&chip->rmu_response_received, MV88E6XXX_RMU_TIMEOUT);
+	if (timeout < 0)
+		return timeout;
+	if (timeout == 0)
+		return -ETIMEDOUT;
+
+	dev_dbg(chip->dev, "got RMU response for request %d in %d msecs\n",
+		chip->rmu_sequence_num, jiffies_to_msecs(MV88E6XXX_RMU_TIMEOUT - timeout));
+
+	return 0;
+}
+
+#define DSA_LEN		4
+
+struct edsahdr {
+	unsigned char	eth_dest_addr[ETH_ALEN];
+	unsigned char	eth_src_addr[ETH_ALEN];
+	__be16		edsa_ethertype;
+	__be16		edsa_reserved; /* 0x0000 */
+	unsigned char	dsa_tag[DSA_LEN];
+	__be16		eth_ethertype;
+} __attribute__((packed));
+
+struct dsahdr {
+	unsigned char	eth_dest_addr[ETH_ALEN];
+	unsigned char	eth_src_addr[ETH_ALEN];
+	unsigned char	dsa_tag[DSA_LEN];
+	__be16		eth_ethertype;
+} __attribute__((packed));
+
+struct mv88e6xxx_rmu_request {
+	__be16	format;
+	__be16	pad; /* 0x0000 on request, Prod Num/Rev on response */
+	__be16	code;
+} __attribute__((packed));
+
+static int mv88e6xxx_rmu_request(struct mv88e6xxx_chip *chip, u16 code, u8 *data, size_t len)
+{
+	const unsigned char dest_addr[ETH_ALEN] = { 0x01, 0x50, 0x43, 0x00, 0x00, 0x00 };
+	struct net_device *dev = chip->rmu_dev;
+	struct mv88e6xxx_rmu_request *req;
+	unsigned char *eth_dest_addr;
+	unsigned char *eth_src_addr;
+	unsigned char *dsa_tag;
+	__be16 *eth_ethertype;
+	struct edsahdr *edsa;
+	struct sk_buff *skb;
+	struct dsahdr *dsa;
+
+	if (!dev)
+		return -EOPNOTSUPP;
+
+	switch (dev->dsa_ptr->tag_ops->proto) {
+	case DSA_TAG_PROTO_DSA:
+		skb = alloc_skb(sizeof(*dsa) + sizeof(*req) + len, GFP_KERNEL);
+		if (!skb)
+			return -ENOMEM;
+
+		dsa = skb_put(skb, sizeof(*dsa));
+		eth_dest_addr = dsa->eth_dest_addr;
+		eth_src_addr = dsa->eth_src_addr;
+		dsa_tag = dsa->dsa_tag;
+		eth_ethertype = &dsa->eth_ethertype;
+		break;
+	case DSA_TAG_PROTO_EDSA:
+		skb = alloc_skb(sizeof(*edsa) + sizeof(*req) + len, GFP_KERNEL);
+		if (!skb)
+			return -ENOMEM;
+
+		edsa = skb_put(skb, sizeof(*edsa));
+		eth_dest_addr = edsa->eth_dest_addr;
+		eth_src_addr = edsa->eth_src_addr;
+		edsa->edsa_ethertype = htons(ETH_P_EDSA);
+		edsa->edsa_reserved = 0x0000;
+		dsa_tag = edsa->dsa_tag;
+		eth_ethertype = &edsa->eth_ethertype;
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	ether_addr_copy(eth_dest_addr, dest_addr); /* Marvell broadcast or switch MAC */
+	ether_addr_copy(eth_src_addr, dev->dev_addr);
+	dsa_tag[0] = 0x40 | (chip->ds->index & 0x1f); /* From_CPU */
+	dsa_tag[1] = 0xfa;
+	dsa_tag[2] = 0xf;
+	dsa_tag[3] = ++chip->rmu_sequence_num;
+	*eth_ethertype = htons(ETH_P_EDSA); /* User defined, useless really */
+
+	req = skb_put(skb, sizeof(*req));
+	req->format = htons(MV88E6XXX_RMU_REQUEST_FORMAT_SOHO);
+	req->pad = 0x0000;
+	req->code = htons(code);
+
+	skb_put_data(skb, data, len);
+
+	skb->dev = dev;
+
+	dsa_switch_xmit(chip->ds, skb);
+
+	return mv88e6xxx_rmu_wait_response(chip);
+}
+
+int mv88e6xxx_rmu_response(struct mv88e6xxx_chip *chip, struct sk_buff *skb)
+{
+	struct net_device *dev = chip->rmu_dev;
+	struct mv88e6xxx_rmu_request *req;
+	unsigned char *dsa_tag;
+	size_t data_offset; 
+	size_t req_offset;
+
+	/* Check if RMU is enabled */
+	if (dev != skb->dev)
+		return -EOPNOTSUPP;
+
+	if (chip->rmu_response)
+		return -EBUSY;
+
+	switch (dev->dsa_ptr->tag_ops->proto) {
+	case DSA_TAG_PROTO_DSA:
+		dsa_tag = skb->data - 2;
+		req_offset = DSA_LEN + ETH_TLEN - 2;
+		break;
+	case DSA_TAG_PROTO_EDSA:
+		/* skb->data points to the end of the (EDSA) ethertype */
+		dsa_tag = skb->data + 2;
+		req_offset = 2 + DSA_LEN + ETH_TLEN;
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	if ((dsa_tag[0] != chip->ds->index) ||
+            (dsa_tag[1] != 0x00) ||
+            ((dsa_tag[2] & 0x1f) != 0x1f) ||
+            (dsa_tag[3] != chip->rmu_sequence_num))
+		return -EINVAL;
+
+	data_offset = req_offset + sizeof(*req);
+	if (skb->len < data_offset)
+		return -EINVAL;
+
+	req = (struct mv88e6xxx_rmu_request *)(skb->data + req_offset);
+	if (ntohs(req->code) == 0xffff)
+		return -EINVAL;
+
+	chip->rmu_response_data_len = skb->len - data_offset;
+	if (chip->rmu_response_data_len > 0)
+		chip->rmu_response_data = skb->data + data_offset;
+	else
+		chip->rmu_response_data = NULL;
+
+	chip->rmu_response = skb_clone(skb, GFP_KERNEL);
+	if (!chip->rmu_response)
+		return -ENOMEM;
+
+	complete(&chip->rmu_response_received);
+
+	return 0;
+}
+
+static int mv88e6xxx_rmu_reg_read(struct mv88e6xxx_chip *chip,
+				  int dev, int reg, u16 *data)
+{
+	unsigned char request_data[8];
+	int err;
+
+	request_data[0] = 0x08 | ((dev >> 3) & 0x03);
+	request_data[1] = ((dev << 5) & 0xe0) | (reg & 0x1f);
+	request_data[2] = 0x00;
+	request_data[3] = 0x00;
+
+	/* End Of List Command */
+	memset(&request_data[4], 0xff, 4);
+
+	err = mv88e6xxx_rmu_request(chip, MV88E6XXX_RMU_REQUEST_CODE_READ_WRITE, request_data, sizeof(request_data));
+	if (err)
+		return err;
+
+	if (chip->rmu_response_data_len < sizeof(request_data))
+		err = -EINVAL;
+	else
+		*data = (chip->rmu_response_data[2] << 8) | chip->rmu_response_data[3];
+
+	kfree_skb(chip->rmu_response);
+	chip->rmu_response = NULL;
+
+	return err;
+}
+
+static int mv88e6xxx_rmu_reg_write(struct mv88e6xxx_chip *chip,
+				   int dev, int reg, u16 data)
+{
+	unsigned char request_data[8];
+	int err;
+
+	request_data[0] = 0x04 | ((dev >> 3) & 0x03);
+	request_data[1] = ((dev << 5) & 0xe0) | (reg & 0x1f);
+	request_data[2] = data >> 8;
+	request_data[3] = data & 0xff;
+
+	/* End Of List Command */
+	memset(&request_data[4], 0xff, 4);
+
+	err = mv88e6xxx_rmu_request(chip, MV88E6XXX_RMU_REQUEST_CODE_READ_WRITE, request_data, sizeof(request_data));
+	if (err)
+		return err;
+
+	if (chip->rmu_response_data_len < sizeof(request_data))
+		err = -EINVAL;
+
+	kfree_skb(chip->rmu_response);
+	chip->rmu_response = NULL;
+
+	return err;
+}
+
+static const struct mv88e6xxx_bus_ops mv88e6xxx_rmu_ops = {
+	.read = mv88e6xxx_rmu_reg_read,
+	.write = mv88e6xxx_rmu_reg_write,
+};
+
+static int mv88e6xxx_rmu_setup_bus(struct mv88e6xxx_chip *chip,
+				      struct net_device *dev)
+{
+	chip->rmu_ops = &mv88e6xxx_rmu_ops;
+	chip->rmu_dev = dev;
+
+	init_completion(&chip->rmu_response_received);
+
+	dev_info(chip->dev, "RMU reachable via %s\n", netdev_name(dev));
+
+	if (!chip->ops)
+		chip->ops = chip->rmu_ops;
+
+	return 0;
+}
+
 static int mv88e6xxx_rmu_setup_port(struct mv88e6xxx_chip *chip, int port)
 {
 	int err;
@@ -40,6 +286,7 @@ static int mv88e6xxx_rmu_setup_port(struct mv88e6xxx_chip *chip, int port)
 int mv88e6xxx_rmu_setup(struct mv88e6xxx_chip *chip)
 {
 	struct dsa_switch *ds = chip->ds;
+	struct net_device *dev;
 	int port;
 	int err;
 
@@ -50,6 +297,15 @@ int mv88e6xxx_rmu_setup(struct mv88e6xxx_chip *chip)
 			if (err)
 				continue;
 
+			/* When the control CPU is local, use the master interface */
+			dev = dsa_to_master(ds, port);
+			if (!dev)
+				return -ENODEV;
+
+			err = mv88e6xxx_rmu_setup_bus(chip, dev);
+			if (err)
+				return err;
+
 			return 0;
 		}
 	}
diff --git a/drivers/net/dsa/mv88e6xxx/rmu.h b/drivers/net/dsa/mv88e6xxx/rmu.h
index f7d849b169d2..099df0789bb5 100644
--- a/drivers/net/dsa/mv88e6xxx/rmu.h
+++ b/drivers/net/dsa/mv88e6xxx/rmu.h
@@ -29,5 +29,6 @@
 #include "chip.h"
 
 int mv88e6xxx_rmu_setup(struct mv88e6xxx_chip *chip);
+int mv88e6xxx_rmu_response(struct mv88e6xxx_chip *chip, struct sk_buff *skb);
 
 #endif /* _MV88E6XXX_RMU_H */
-- 
2.21.0

