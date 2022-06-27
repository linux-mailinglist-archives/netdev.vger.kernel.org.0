Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7E4C255C931
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 14:56:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239818AbiF0SUF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jun 2022 14:20:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234890AbiF0SUF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jun 2022 14:20:05 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DED3BE0DD
        for <netdev@vger.kernel.org>; Mon, 27 Jun 2022 11:20:02 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id w24so10105957pjg.5
        for <netdev@vger.kernel.org>; Mon, 27 Jun 2022 11:20:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fungible.com; s=google;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=AUlKhvKSjzeI5cLspDHMu5nnFXaHuMw/V5S0p0g0tUU=;
        b=lb9s6jtfI0BHZ6c33RNZEfCGWZw5e4cRQ6AQ2UTfzY7wxjkwheFzeHJCAINwpMuL0b
         4w7pgzTgC4IouQ6VkJjrSE1DcH36C8E4qD5TVDUtb4H+QmuzGwNazyct0MR8UswO1R3k
         uLqTYxKbrtuEf8Z90FPE1G2Rt/oiSf09s2X2M=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=AUlKhvKSjzeI5cLspDHMu5nnFXaHuMw/V5S0p0g0tUU=;
        b=Sw98PTBOVLkFxV++pVc8NFYCMWKZ4xh4PPtNcSNoguCXP/4h7ZQgLWBIYMSrHSLd0l
         lOPCFIUJmpltL094epTTjSv2jw4TNiZoRicxdsWF2gxj/E9Oi2U6aOVidqPVV2X2FRb8
         zULtToAUEjHEugnf0HrfIIqqzdjMuQxgO0wfuiA+Xl9aRyNupYO/z8cAFMXzW09pLm34
         trvudRuP7+V25ZTppkUaufzTzCaXptM0CXj3KePxskEyTo7V+wByz7FTWCdb7WM88OBL
         PjGULOitb0hcIeE3PnwiZg7HLmWt76rAXWfmYKbWVNBa9UnRFuc34G1R4hcvO9VBd/im
         IQeg==
X-Gm-Message-State: AJIora8BBUH1Keretbvv77ju6/gu2iIZsubHFfrlqvSyeWso2EtnrA/k
        IBJ9YHZz8PG6sYqXYWDZ8jQjvA==
X-Google-Smtp-Source: AGRyM1uf291LtqNYxUXoOkDRwLPNdtS17vq9ozwFPzMVlUXJQJRlNPWf6iKGaYgmSmHy85BtgcL+yA==
X-Received: by 2002:a17:90b:1e0e:b0:1ec:adbe:3b35 with SMTP id pg14-20020a17090b1e0e00b001ecadbe3b35mr23314304pjb.134.1656354002388;
        Mon, 27 Jun 2022 11:20:02 -0700 (PDT)
Received: from cab09-qa-09.fungible.local ([12.190.10.11])
        by smtp.gmail.com with ESMTPSA id x12-20020a17090300cc00b001624dab05edsm7597064plc.8.2022.06.27.11.20.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Jun 2022 11:20:02 -0700 (PDT)
From:   Dimitris Michailidis <d.michailidis@fungible.com>
X-Google-Original-From: Dimitris Michailidis <dmichail@fungible.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, d.michailidis@fungible.com
Subject: [PATCH net-next] net/funeth: Support for ethtool -m
Date:   Mon, 27 Jun 2022 11:20:00 -0700
Message-Id: <20220627182000.8198-1-dmichail@fungible.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add the FW command for reading port module memory pages and implement
ethtool's get_module_eeprom_by_page operation.

Signed-off-by: Dimitris Michailidis <dmichail@fungible.com>
---
 .../net/ethernet/fungible/funcore/fun_hci.h   | 40 +++++++++++++++++++
 .../ethernet/fungible/funeth/funeth_ethtool.c | 34 ++++++++++++++++
 2 files changed, 74 insertions(+)

diff --git a/drivers/net/ethernet/fungible/funcore/fun_hci.h b/drivers/net/ethernet/fungible/funcore/fun_hci.h
index 257203e94b68..f21819670106 100644
--- a/drivers/net/ethernet/fungible/funcore/fun_hci.h
+++ b/drivers/net/ethernet/fungible/funcore/fun_hci.h
@@ -442,6 +442,7 @@ enum fun_port_lane_attr {
 };
 
 enum fun_admin_port_subop {
+	FUN_ADMIN_PORT_SUBOP_XCVR_READ = 0x23,
 	FUN_ADMIN_PORT_SUBOP_INETADDR_EVENT = 0x24,
 };
 
@@ -595,6 +596,19 @@ struct fun_admin_port_req {
 
 			struct fun_admin_read48_req read48[];
 		} read;
+		struct fun_admin_port_xcvr_read_req {
+			u8 subop;
+			u8 rsvd0;
+			__be16 flags;
+			__be32 id;
+
+			u8 bank;
+			u8 page;
+			u8 offset;
+			u8 length;
+			u8 dev_addr;
+			u8 rsvd1[3];
+		} xcvr_read;
 		struct fun_admin_port_inetaddr_event_req {
 			__u8 subop;
 			__u8 rsvd0;
@@ -625,6 +639,15 @@ struct fun_admin_port_req {
 		.id = cpu_to_be32(_id),                          \
 	}
 
+#define FUN_ADMIN_PORT_XCVR_READ_REQ_INIT(_flags, _id, _bank, _page,   \
+					  _offset, _length, _dev_addr) \
+	((struct fun_admin_port_xcvr_read_req) {                       \
+		.subop = FUN_ADMIN_PORT_SUBOP_XCVR_READ,               \
+		.flags = cpu_to_be16(_flags), .id = cpu_to_be32(_id),  \
+		.bank = (_bank), .page = (_page), .offset = (_offset), \
+		.length = (_length), .dev_addr = (_dev_addr),          \
+	})
+
 struct fun_admin_port_rsp {
 	struct fun_admin_rsp_common common;
 
@@ -659,6 +682,23 @@ struct fun_admin_port_rsp {
 	} u;
 };
 
+struct fun_admin_port_xcvr_read_rsp {
+	struct fun_admin_rsp_common common;
+
+	u8 subop;
+	u8 rsvd0[3];
+	__be32 id;
+
+	u8 bank;
+	u8 page;
+	u8 offset;
+	u8 length;
+	u8 dev_addr;
+	u8 rsvd1[3];
+
+	u8 data[128];
+};
+
 enum fun_xcvr_type {
 	FUN_XCVR_BASET = 0x0,
 	FUN_XCVR_CU = 0x1,
diff --git a/drivers/net/ethernet/fungible/funeth/funeth_ethtool.c b/drivers/net/ethernet/fungible/funeth/funeth_ethtool.c
index da42dd53a87c..31aa185f4d17 100644
--- a/drivers/net/ethernet/fungible/funeth/funeth_ethtool.c
+++ b/drivers/net/ethernet/fungible/funeth/funeth_ethtool.c
@@ -1118,6 +1118,39 @@ static int fun_set_fecparam(struct net_device *netdev,
 	return fun_port_write_cmd(fp, FUN_ADMIN_PORT_KEY_FEC, fec_mode);
 }
 
+static int fun_get_port_module_page(struct net_device *netdev,
+				    const struct ethtool_module_eeprom *req,
+				    struct netlink_ext_ack *extack)
+{
+	union {
+		struct fun_admin_port_req req;
+		struct fun_admin_port_xcvr_read_rsp rsp;
+	} cmd;
+	struct funeth_priv *fp = netdev_priv(netdev);
+	int rc;
+
+	if (fp->port_caps & FUN_PORT_CAP_VPORT) {
+		NL_SET_ERR_MSG_MOD(extack,
+				   "Specified port is virtual, only physical ports have modules");
+		return -EOPNOTSUPP;
+	}
+
+	cmd.req.common = FUN_ADMIN_REQ_COMMON_INIT2(FUN_ADMIN_OP_PORT,
+						    sizeof(cmd.req));
+	cmd.req.u.xcvr_read =
+		FUN_ADMIN_PORT_XCVR_READ_REQ_INIT(0, netdev->dev_port,
+						  req->bank, req->page,
+						  req->offset, req->length,
+						  req->i2c_address);
+	rc = fun_submit_admin_sync_cmd(fp->fdev, &cmd.req.common, &cmd.rsp,
+				       sizeof(cmd.rsp), 0);
+	if (rc)
+		return rc;
+
+	memcpy(req->data, cmd.rsp.data, req->length);
+	return req->length;
+}
+
 static const struct ethtool_ops fun_ethtool_ops = {
 	.supported_coalesce_params = ETHTOOL_COALESCE_USECS |
 				     ETHTOOL_COALESCE_MAX_FRAMES,
@@ -1156,6 +1189,7 @@ static const struct ethtool_ops fun_ethtool_ops = {
 	.get_eth_mac_stats   = fun_get_802_3_stats,
 	.get_eth_ctrl_stats  = fun_get_802_3_ctrl_stats,
 	.get_rmon_stats      = fun_get_rmon_stats,
+	.get_module_eeprom_by_page = fun_get_port_module_page,
 };
 
 void fun_set_ethtool_ops(struct net_device *netdev)
-- 
2.25.1

