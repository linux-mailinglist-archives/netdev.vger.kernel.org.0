Return-Path: <netdev+bounces-9564-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 78BB4729C95
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 16:18:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 33EA22818D5
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 14:18:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 770D8182B7;
	Fri,  9 Jun 2023 14:18:20 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AB93182B5
	for <netdev@vger.kernel.org>; Fri,  9 Jun 2023 14:18:20 +0000 (UTC)
Received: from relay7-d.mail.gandi.net (relay7-d.mail.gandi.net [217.70.183.200])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6808135A9;
	Fri,  9 Jun 2023 07:18:16 -0700 (PDT)
X-GND-Sasl: alexis.lothore@bootlin.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
	t=1686320295;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=W+Vlu9friBOCTMyp0uxc69MbnwzC+52I1B39QfhvQrM=;
	b=jzDyozm7zpvmi82J9hKpAKqzzqfwHe7ZYnDNt5Qb04+YhXrwFdn7HmQS/sD9/A3LKcjKoS
	4ZdYB86q01msP2HC7CyBdh80PTT2G2bkFQZVISZ9Cg1NXqP6SsFZWVXbfLgkN50hDFI4zJ
	Uvxlqfrm9zvoiGSeTnRRWMINU+I3Pw6BzUNITpAOO750HHkE5BDgIYCYmzp8yL4l+1/iRC
	FOONZ93DpegAVftJWq1aXmpjbmbKfFauWc623kGMVn+uB9w43PNa+LYzXdWLzDh66THmkO
	rY4RyDeDVzblzTPrVBpAqnk3FpnDL9gZ53mCaP4Warrrj44joSt5x93s8/b9UA==
X-GND-Sasl: alexis.lothore@bootlin.com
X-GND-Sasl: alexis.lothore@bootlin.com
X-GND-Sasl: alexis.lothore@bootlin.com
X-GND-Sasl: alexis.lothore@bootlin.com
X-GND-Sasl: alexis.lothore@bootlin.com
X-GND-Sasl: alexis.lothore@bootlin.com
X-GND-Sasl: alexis.lothore@bootlin.com
X-GND-Sasl: alexis.lothore@bootlin.com
X-GND-Sasl: alexis.lothore@bootlin.com
X-GND-Sasl: alexis.lothore@bootlin.com
X-GND-Sasl: alexis.lothore@bootlin.com
Received: by mail.gandi.net (Postfix) with ESMTPSA id 3C60120011;
	Fri,  9 Jun 2023 14:18:14 +0000 (UTC)
From: alexis.lothore@bootlin.com
To: Andrew Lunn <andrew@lunn.ch>,
	Florian Fainelli <f.fainelli@gmail.com>,
	Vladimir Oltean <olteanv@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>
Cc: linux-kernel@vger.kernel.org ,
	netdev@vger.kernel.org ,
	Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
	paul.arola@telus.com ,
	scott.roberts@telus.com 
Subject: [PATCH net-next 1/2] net: dsa: mv88e6xxx: allow driver to hook TC callback
Date: Fri,  9 Jun 2023 16:18:11 +0200
Message-ID: <20230609141812.297521-2-alexis.lothore@bootlin.com>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230609141812.297521-1-alexis.lothore@bootlin.com>
References: <20230609141812.297521-1-alexis.lothore@bootlin.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
	RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

From: Alexis Lothoré <alexis.lothore@bootlin.com>

Marvell switches have some traffic control offloading capabilities, like
for example per-port rate limiting. Allow driver to benefit from this
offloading by hooking TC setup callback in DSA

Signed-off-by: Alexis Lothoré <alexis.lothore@bootlin.com>
---
 drivers/net/dsa/mv88e6xxx/chip.c | 17 +++++++++++++++++
 drivers/net/dsa/mv88e6xxx/chip.h |  3 ++-
 2 files changed, 19 insertions(+), 1 deletion(-)

diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index 8b51756bd805..0f1ae2aeaf00 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -7091,6 +7091,22 @@ static int mv88e6xxx_crosschip_lag_leave(struct dsa_switch *ds, int sw_index,
 	return err_sync ? : err_pvt;
 }
 
+static int mv88e6xxx_port_setup_tc(struct dsa_switch *ds, int port,
+				   enum tc_setup_type type, void *type_data)
+{
+	struct mv88e6xxx_chip *chip = ds->priv;
+	int err;
+
+	if (!chip->info->ops->port_setup_tc)
+		return -EOPNOTSUPP;
+
+	mv88e6xxx_reg_lock(chip);
+	err = chip->info->ops->port_setup_tc(ds, port, type, type_data);
+	mv88e6xxx_reg_unlock(chip);
+
+	return err;
+}
+
 static const struct dsa_switch_ops mv88e6xxx_switch_ops = {
 	.get_tag_protocol	= mv88e6xxx_get_tag_protocol,
 	.change_tag_protocol	= mv88e6xxx_change_tag_protocol,
@@ -7158,6 +7174,7 @@ static const struct dsa_switch_ops mv88e6xxx_switch_ops = {
 	.crosschip_lag_change	= mv88e6xxx_crosschip_lag_change,
 	.crosschip_lag_join	= mv88e6xxx_crosschip_lag_join,
 	.crosschip_lag_leave	= mv88e6xxx_crosschip_lag_leave,
+	.port_setup_tc		= mv88e6xxx_port_setup_tc,
 };
 
 static int mv88e6xxx_register_switch(struct mv88e6xxx_chip *chip)
diff --git a/drivers/net/dsa/mv88e6xxx/chip.h b/drivers/net/dsa/mv88e6xxx/chip.h
index 0ad34b2d8913..b259671b2cd7 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.h
+++ b/drivers/net/dsa/mv88e6xxx/chip.h
@@ -560,7 +560,8 @@ struct mv88e6xxx_ops {
 	 */
 	int (*port_set_upstream_port)(struct mv88e6xxx_chip *chip, int port,
 				      int upstream_port);
-
+	int (*port_setup_tc)(struct dsa_switch *ds, int port,
+			     enum tc_setup_type type, void *type_data);
 	/* Snapshot the statistics for a port. The statistics can then
 	 * be read back a leisure but still with a consistent view.
 	 */
-- 
2.41.0


