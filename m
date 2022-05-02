Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EE4015173DC
	for <lists+netdev@lfdr.de>; Mon,  2 May 2022 18:11:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348239AbiEBQOa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 May 2022 12:14:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1386288AbiEBQN7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 May 2022 12:13:59 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2128638AD;
        Mon,  2 May 2022 09:10:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1651507830; x=1683043830;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=/B3VA8gEmFCmALksMUHQDPU9gjbSWu4RHNjOwFXoqEY=;
  b=a842HmxzFq1ZOSU3FKPH1ia6ypV9BOq9DiCxk+S5uJVh2kWIKdBt4udv
   3Rlf+FCJ8VTNh9m4/lRYBjHY8UnnKkYQ6kILo1aOUKJg89klvJN5pDWmV
   7wF/Y+AzshwcsVM6ejigtzQxNoFpcb9l65zexdiPoFHWRKB0USK2Elax4
   Xn2l1N+aOvd5JzO9kfVUQe800qq9rCf8JvSXm5y6MjZBqwb0d1kbjXX75
   O0Ooou4ZZrJxxISI1uxhCRLwjju9PnAryS4YXDSvvhThB6gPuUMS536oo
   bOuhdIMFmwM/RjePaSPz4+cjJHXsJDuJgZQbqzOFHbLiKMYXifW/jHgte
   g==;
X-IronPort-AV: E=Sophos;i="5.91,192,1647327600"; 
   d="scan'208";a="94281684"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 02 May 2022 09:10:28 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Mon, 2 May 2022 09:10:28 -0700
Received: from CHE-LT-I17769U.microchip.com (10.10.115.15) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server id
 15.1.2375.17 via Frontend Transport; Mon, 2 May 2022 09:10:08 -0700
From:   Arun Ramadoss <arun.ramadoss@microchip.com>
To:     <bpf@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     KP Singh <kpsingh@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Yonghong Song <yhs@fb.com>, Song Liu <songliubraving@fb.com>,
        "Martin KaFai Lau" <kafai@fb.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        "Paolo Abeni" <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        "Vladimir Oltean" <olteanv@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "Vivien Didelot" <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>, <UNGLinuxDriver@microchip.com>,
        Woojung Huh <woojung.huh@microchip.com>
Subject: [Patch net-next v12 11/13] net: dsa: microchip: add support for port mirror operations
Date:   Mon, 2 May 2022 21:40:01 +0530
Message-ID: <20220502161001.7378-1-arun.ramadoss@microchip.com>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Prasanna Vengateshan <prasanna.vengateshan@microchip.com>

Added support for port_mirror_add() and port_mirror_del operations

Sniffing is limited to one port & alert the user if any new
sniffing port is selected

Signed-off-by: Prasanna Vengateshan <prasanna.vengateshan@microchip.com>
Signed-off-by: Arun Ramadoss <arun.ramadoss@microchip.com>
Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
---
 drivers/net/dsa/microchip/lan937x_main.c | 83 ++++++++++++++++++++++++
 1 file changed, 83 insertions(+)

diff --git a/drivers/net/dsa/microchip/lan937x_main.c b/drivers/net/dsa/microchip/lan937x_main.c
index 6d0b0d62b8e1..58ce2912215c 100644
--- a/drivers/net/dsa/microchip/lan937x_main.c
+++ b/drivers/net/dsa/microchip/lan937x_main.c
@@ -65,6 +65,87 @@ static void lan937x_port_stp_state_set(struct dsa_switch *ds, int port,
 	ksz_port_stp_state_set(ds, port, state, P_STP_CTRL);
 }
 
+static int lan937x_port_mirror_add(struct dsa_switch *ds, int port,
+				   struct dsa_mall_mirror_tc_entry *mirror,
+				   bool ingress, struct netlink_ext_ack *extack)
+{
+	struct ksz_device *dev = ds->priv;
+	int ret, p;
+	u8 data;
+
+	/* Limit to one sniffer port
+	 * Check if any of the port is already set for sniffing
+	 * If yes, instruct the user to remove the previous entry & exit
+	 */
+	for (p = 0; p < dev->port_cnt; p++) {
+		/* Skip the current sniffing port */
+		if (p == mirror->to_local_port)
+			continue;
+
+		ret = lan937x_pread8(dev, p, P_MIRROR_CTRL, &data);
+		if (ret < 0)
+			return ret;
+
+		if (data & PORT_MIRROR_SNIFFER) {
+			NL_SET_ERR_MSG_MOD(extack,
+					   "Sniffer port is already configured, delete existing rules & retry");
+			return -EBUSY;
+		}
+	}
+
+	/* Configure ingress/egress mirroring */
+	if (ingress)
+		ret = lan937x_port_cfg(dev, port, P_MIRROR_CTRL, PORT_MIRROR_RX,
+				       true);
+	else
+		ret = lan937x_port_cfg(dev, port, P_MIRROR_CTRL, PORT_MIRROR_TX,
+				       true);
+	if (ret < 0)
+		return ret;
+
+	/* Configure sniffer port as other ports do not have
+	 * PORT_MIRROR_SNIFFER is set
+	 */
+	ret = lan937x_port_cfg(dev, mirror->to_local_port, P_MIRROR_CTRL,
+			       PORT_MIRROR_SNIFFER, true);
+	if (ret < 0)
+		return ret;
+
+	return lan937x_cfg(dev, S_MIRROR_CTRL, SW_MIRROR_RX_TX, false);
+}
+
+static void lan937x_port_mirror_del(struct dsa_switch *ds, int port,
+				    struct dsa_mall_mirror_tc_entry *mirror)
+{
+	struct ksz_device *dev = ds->priv;
+	bool in_use = false;
+	u8 data;
+	int p;
+
+	/* clear ingress/egress mirroring port */
+	if (mirror->ingress)
+		lan937x_port_cfg(dev, port, P_MIRROR_CTRL, PORT_MIRROR_RX,
+				 false);
+	else
+		lan937x_port_cfg(dev, port, P_MIRROR_CTRL, PORT_MIRROR_TX,
+				 false);
+
+	/* Check if any of the port is still referring to sniffer port */
+	for (p = 0; p < dev->port_cnt; p++) {
+		lan937x_pread8(dev, p, P_MIRROR_CTRL, &data);
+
+		if ((data & (PORT_MIRROR_RX | PORT_MIRROR_TX))) {
+			in_use = true;
+			break;
+		}
+	}
+
+	/* delete sniffing if there are no other mirroring rule exist */
+	if (!in_use)
+		lan937x_port_cfg(dev, mirror->to_local_port, P_MIRROR_CTRL,
+				 PORT_MIRROR_SNIFFER, false);
+}
+
 static void lan937x_config_cpu_port(struct dsa_switch *ds)
 {
 	struct ksz_device *dev = ds->priv;
@@ -439,6 +520,8 @@ const struct dsa_switch_ops lan937x_switch_ops = {
 	.port_bridge_leave = ksz_port_bridge_leave,
 	.port_stp_state_set = lan937x_port_stp_state_set,
 	.port_fast_age = ksz_port_fast_age,
+	.port_mirror_add = lan937x_port_mirror_add,
+	.port_mirror_del = lan937x_port_mirror_del,
 	.port_max_mtu = lan937x_get_max_mtu,
 	.port_change_mtu = lan937x_change_mtu,
 	.phylink_get_caps = lan937x_phylink_get_caps,
-- 
2.33.0

