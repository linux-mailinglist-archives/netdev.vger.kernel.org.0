Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DE0E3576D3D
	for <lists+netdev@lfdr.de>; Sat, 16 Jul 2022 12:04:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231797AbiGPKDv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 Jul 2022 06:03:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229540AbiGPKDt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 16 Jul 2022 06:03:49 -0400
X-Greylist: delayed 4292 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Sat, 16 Jul 2022 03:03:45 PDT
Received: from a1-bg02.venev.name (a1-bg02.venev.name [IPv6:2001:470:20aa::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57A5426D4;
        Sat, 16 Jul 2022 03:03:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=venev.name;
        s=default; h=Content-Transfer-Encoding:Message-Id:Date:Subject:To:From:
        Content-Type:Reply-To:Sender; bh=fPmDHOyG2Rqp5CIpnIIQbmLxoYS8Nalj3lW5lVyk8Ps=
        ; b=iLqyE3/Ft7mvjmD9vgScixnQsyaDSgyE/ttsEIWIj3cX5stt6ncxfxQtutaqjWEWNbZwo5vyu
        N5n9FzAnjqT/EvMSBhcIKuCNMDbLokI6f9LzdGdFGtyRc0xGUh+VI0M4eB9XEi9hcH8qh4UZuFjl9
        Fhhv8YgBJLssXAFOE2KWd9qeJP+UqTXYpFNaqIqD7NGHgT2ZyYPyJmZyKGxGuz3WPFmT6GBSkkTug
        +Nt8Rv6eCcAkgOeeM1VovHb7y7/AvbMbaxI17reKnujiMzzykVZKIc1eoxI3Gqa7uXmhpnZ0jvzdL
        sFZLdd2xEiD1Llxbki1ZDsd9baJsQtbd5ugex6VuJ0RO/qklIAWsAJaCZ/nDfHrIO7Sn/KACVrSYL
        0DBOyeUPygbUtro4HiVhXNShm1AQbQ1vrhc6zfKCW0MEmCugruYn3uOTMR8Ijo1AYiC8UUV8Jy1hq
        dklP8sV6vlEzkr3L3+DdhW0MQqNO9DbMFT4edV5jeQ4INWsxFUHxFdnE2sbqpwdsv03iqyrSz144i
        rrZ8ynq3fd5/M7ZjxsBlzMddOuqQevbE59y3BZeUO3Ts+aU92MTZVVDvx+2f5omtURATe7KpRkf+6
        5HE+aQ/oxSe1r8g2lexZ9yoYdnLWRw2As+MNa1jSUQ5VSYy0tKd3yNkF64cvZtTl436cxno=;
X-Check-Malware: ok
Received: from a1-bg02.venev.name ([213.240.239.49] helo=pmx1.venev.name)
        by a1-bg02.venev.name with esmtps
        id 1oCdWt-0001az-T6
        (TLS1.3:TLS_AES_256_GCM_SHA384:256)
        (envelope-from <hristo@venev.name>);
        Sat, 16 Jul 2022 08:52:04 +0000
Received: from venev.name ([213.240.239.49])
        by pmx1.venev.name with ESMTPSA
        id jwWRIDJ80mL1FwAAdB6GMg
        (envelope-from <hristo@venev.name>); Sat, 16 Jul 2022 08:52:03 +0000
From:   Hristo Venev <hristo@venev.name>
To:     netdev@vger.kernel.org
Cc:     Hristo Venev <hristo@venev.name>,
        Ajit Khaparde <ajit.khaparde@broadcom.com>,
        Sriharsha Basavapatna <sriharsha.basavapatna@broadcom.com>,
        Somnath Kotur <somnath.kotur@broadcom.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Mark Leonard <mark.leonard@emulex.com>,
        Sathya Perla <sathya.perla@emulex.com>,
        Suresh Reddy <Suresh.Reddy@emulex.com>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH] be2net: Fix buffer overflow in be_get_module_eeprom
Date:   Sat, 16 Jul 2022 11:51:34 +0300
Message-Id: <20220716085134.6095-1-hristo@venev.name>
X-Mailer: git-send-email 2.37.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

be_cmd_read_port_transceiver_data assumes that it is given a buffer that
is at least PAGE_DATA_LEN long, or twice that if the module supports SFF
8472. However, this is not always the case.

Fix this by passing the desired offset and length to
be_cmd_read_port_transceiver_data so that we only copy the bytes once.

Fixes: e36edd9d26cf ("be2net: add ethtool "-m" option support")
Signed-off-by: Hristo Venev <hristo@venev.name>
---
 drivers/net/ethernet/emulex/benet/be_cmds.c   | 10 +++---
 drivers/net/ethernet/emulex/benet/be_cmds.h   |  2 +-
 .../net/ethernet/emulex/benet/be_ethtool.c    | 31 ++++++++++++-------
 3 files changed, 25 insertions(+), 18 deletions(-)

diff --git a/drivers/net/ethernet/emulex/benet/be_cmds.c b/drivers/net/ethernet/emulex/benet/be_cmds.c
index 528eb0f223b1..b4f5e57d0285 100644
--- a/drivers/net/ethernet/emulex/benet/be_cmds.c
+++ b/drivers/net/ethernet/emulex/benet/be_cmds.c
@@ -2287,7 +2287,7 @@ int be_cmd_get_beacon_state(struct be_adapter *adapter, u8 port_num, u32 *state)
 
 /* Uses sync mcc */
 int be_cmd_read_port_transceiver_data(struct be_adapter *adapter,
-				      u8 page_num, u8 *data)
+				      u8 page_num, u32 off, u32 len, u8 *data)
 {
 	struct be_dma_mem cmd;
 	struct be_mcc_wrb *wrb;
@@ -2321,10 +2321,10 @@ int be_cmd_read_port_transceiver_data(struct be_adapter *adapter,
 	req->port = cpu_to_le32(adapter->hba_port_num);
 	req->page_num = cpu_to_le32(page_num);
 	status = be_mcc_notify_wait(adapter);
-	if (!status) {
+	if (!status && len > 0) {
 		struct be_cmd_resp_port_type *resp = cmd.va;
 
-		memcpy(data, resp->page_data, PAGE_DATA_LEN);
+		memcpy(data, resp->page_data + off, len);
 	}
 err:
 	mutex_unlock(&adapter->mcc_lock);
@@ -2415,7 +2415,7 @@ int be_cmd_query_cable_type(struct be_adapter *adapter)
 	int status;
 
 	status = be_cmd_read_port_transceiver_data(adapter, TR_PAGE_A0,
-						   page_data);
+						   0, PAGE_DATA_LEN, page_data);
 	if (!status) {
 		switch (adapter->phy.interface_type) {
 		case PHY_TYPE_QSFP:
@@ -2440,7 +2440,7 @@ int be_cmd_query_sfp_info(struct be_adapter *adapter)
 	int status;
 
 	status = be_cmd_read_port_transceiver_data(adapter, TR_PAGE_A0,
-						   page_data);
+						   0, PAGE_DATA_LEN, page_data);
 	if (!status) {
 		strlcpy(adapter->phy.vendor_name, page_data +
 			SFP_VENDOR_NAME_OFFSET, SFP_VENDOR_NAME_LEN - 1);
diff --git a/drivers/net/ethernet/emulex/benet/be_cmds.h b/drivers/net/ethernet/emulex/benet/be_cmds.h
index db1f3b908582..e2085c68c0ee 100644
--- a/drivers/net/ethernet/emulex/benet/be_cmds.h
+++ b/drivers/net/ethernet/emulex/benet/be_cmds.h
@@ -2427,7 +2427,7 @@ int be_cmd_set_beacon_state(struct be_adapter *adapter, u8 port_num, u8 beacon,
 int be_cmd_get_beacon_state(struct be_adapter *adapter, u8 port_num,
 			    u32 *state);
 int be_cmd_read_port_transceiver_data(struct be_adapter *adapter,
-				      u8 page_num, u8 *data);
+				      u8 page_num, u32 off, u32 len, u8 *data);
 int be_cmd_query_cable_type(struct be_adapter *adapter);
 int be_cmd_query_sfp_info(struct be_adapter *adapter);
 int lancer_cmd_read_object(struct be_adapter *adapter, struct be_dma_mem *cmd,
diff --git a/drivers/net/ethernet/emulex/benet/be_ethtool.c b/drivers/net/ethernet/emulex/benet/be_ethtool.c
index dfa784339781..bd0df189d871 100644
--- a/drivers/net/ethernet/emulex/benet/be_ethtool.c
+++ b/drivers/net/ethernet/emulex/benet/be_ethtool.c
@@ -1344,7 +1344,7 @@ static int be_get_module_info(struct net_device *netdev,
 		return -EOPNOTSUPP;
 
 	status = be_cmd_read_port_transceiver_data(adapter, TR_PAGE_A0,
-						   page_data);
+						   0, PAGE_DATA_LEN, page_data);
 	if (!status) {
 		if (!page_data[SFP_PLUS_SFF_8472_COMP]) {
 			modinfo->type = ETH_MODULE_SFF_8079;
@@ -1362,25 +1362,32 @@ static int be_get_module_eeprom(struct net_device *netdev,
 {
 	struct be_adapter *adapter = netdev_priv(netdev);
 	int status;
+	u32 begin, end;
 
 	if (!check_privilege(adapter, MAX_PRIVILEGES))
 		return -EOPNOTSUPP;
 
-	status = be_cmd_read_port_transceiver_data(adapter, TR_PAGE_A0,
-						   data);
-	if (status)
-		goto err;
+	begin = eeprom->offset;
+	end = eeprom->offset + eeprom->len;
+
+	if (begin < PAGE_DATA_LEN) {
+		status = be_cmd_read_port_transceiver_data(adapter, TR_PAGE_A0, begin,
+							   min_t(u32, end, PAGE_DATA_LEN) - begin,
+							   data);
+		if (status)
+			goto err;
+
+		data += PAGE_DATA_LEN - begin;
+		begin = PAGE_DATA_LEN;
+	}
 
-	if (eeprom->offset + eeprom->len > PAGE_DATA_LEN) {
-		status = be_cmd_read_port_transceiver_data(adapter,
-							   TR_PAGE_A2,
-							   data +
-							   PAGE_DATA_LEN);
+	if (end > PAGE_DATA_LEN) {
+		status = be_cmd_read_port_transceiver_data(adapter, TR_PAGE_A2,
+							   begin - PAGE_DATA_LEN,
+							   end - begin, data);
 		if (status)
 			goto err;
 	}
-	if (eeprom->offset)
-		memcpy(data, data + eeprom->offset, eeprom->len);
 err:
 	return be_cmd_status(status);
 }
-- 
2.37.1

