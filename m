Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6085716B18A
	for <lists+netdev@lfdr.de>; Mon, 24 Feb 2020 22:08:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727978AbgBXVIP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Feb 2020 16:08:15 -0500
Received: from mail-wr1-f66.google.com ([209.85.221.66]:35062 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727513AbgBXVIK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Feb 2020 16:08:10 -0500
Received: by mail-wr1-f66.google.com with SMTP id w12so12122317wrt.2
        for <netdev@vger.kernel.org>; Mon, 24 Feb 2020 13:08:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=hYgO2RdAljNfebakfE8lpmrMYi77WS78Xd/fXA6uUKs=;
        b=CuPEAUV37RT6d5j6AwZjREypuLI4BvI9maUhqRCg+Jck3vvgMbG1Zr3APrKSoJ4lIr
         FsTofH3M+RfIZtdBy6GTklgexpEweQJGsK6T/yg7fUtgo/GH6SBmNPFMp97s+Wbvm3E9
         nSsKwuZf2/0YCt0stteDcYCNwpOAHRWhuXz8soXpnP9q05/j8d9BiITux8p14QOrYIvU
         jOZEtZWrB0TSRuXJj4wGGHdliQewRGiwoVzcAO//oNtsmEEnHVKc5xjrsF/DxHccD1Ve
         bqxdCG74kslb02SyuQ29/nU8VMpM0mF2dxCX7AReKPP1oBhfAr8qsG7xk0w3GldDje1E
         Rodg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=hYgO2RdAljNfebakfE8lpmrMYi77WS78Xd/fXA6uUKs=;
        b=o61cqez+P5DLNZXtOyl0gpa3kUZeBmPsfGGkGKvHNXt3juUUKwlYZs7LME//TitY6L
         1dAfX1EQo8Ff8q1Cz1g47ipenL131rUcA3Tot1SY4vXmBSIQ72BTDplap9vvzvEqKiSW
         9KP6qmurPYew7orrF/BZ+2u3r8ey52iCebZp/R24W5q2H5Z1zMOiT3aP6srjrjX3uHRn
         1uC/m44ke+3MEdt3YLDotdpbGSeYAxDdUj6n7K18vjocsFgBnmsF0RNNE8RDwcOA50hN
         a+u4MVska+rVqxai1s+XCr12VzaNbrUd0gigTzg3kHDLHAaeqX1RUFqgDD/pvvICNmyu
         PPtQ==
X-Gm-Message-State: APjAAAVM5zsy3x1BQBHp47K1CKSx6v3nOF0I4F3PnHvGxtnEznEMlCBY
        IBFYOHI+aQYpu9J2+gDFLtyIC9ir7vo=
X-Google-Smtp-Source: APXvYqwK6X9oBpzlyerFdQO1f6O+b+bW7lxN7D8bn7XR8eGOOa6wmGkvUS3r+2g9+XoUcGRzSUdeDw==
X-Received: by 2002:a5d:4d06:: with SMTP id z6mr69352704wrt.241.1582578489217;
        Mon, 24 Feb 2020 13:08:09 -0800 (PST)
Received: from localhost (ip-89-177-130-96.net.upcbroadband.cz. [89.177.130.96])
        by smtp.gmail.com with ESMTPSA id a9sm21423846wrn.3.2020.02.24.13.08.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Feb 2020 13:08:08 -0800 (PST)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, nhorman@tuxdriver.com,
        jhs@mojatatu.com, xiyou.wangcong@gmail.com, idosch@mellanox.com,
        mlxsw@mellanox.com
Subject: [patch net-next 07/10] mlxsw: pci: Extract cookie index for ACL discard trap packets
Date:   Mon, 24 Feb 2020 22:07:55 +0100
Message-Id: <20200224210758.18481-8-jiri@resnulli.us>
X-Mailer: git-send-email 2.21.1
In-Reply-To: <20200224210758.18481-1-jiri@resnulli.us>
References: <20200224210758.18481-1-jiri@resnulli.us>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@mellanox.com>

In case the received packet comes in due to one of ACL discard traps,
take the user_def_val_orig_pkt_len field from CQE and store it
in skb->cb as ACL cookie index.

Signed-off-by: Jiri Pirko <jiri@mellanox.com>
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlxsw/core.h   | 5 ++++-
 drivers/net/ethernet/mellanox/mlxsw/pci.c    | 9 +++++++++
 drivers/net/ethernet/mellanox/mlxsw/pci_hw.h | 5 +++++
 3 files changed, 18 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/core.h b/drivers/net/ethernet/mellanox/mlxsw/core.h
index 00e44e778aca..46226823c7a6 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/core.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/core.h
@@ -473,7 +473,10 @@ enum mlxsw_devlink_param_id {
 };
 
 struct mlxsw_skb_cb {
-	struct mlxsw_tx_info tx_info;
+	union {
+		struct mlxsw_tx_info tx_info;
+		u32 cookie_index; /* Only used during receive */
+	};
 };
 
 static inline struct mlxsw_skb_cb *mlxsw_skb_cb(struct sk_buff *skb)
diff --git a/drivers/net/ethernet/mellanox/mlxsw/pci.c b/drivers/net/ethernet/mellanox/mlxsw/pci.c
index 914c33e46fb4..67ee0da75af2 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/pci.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/pci.c
@@ -575,6 +575,15 @@ static void mlxsw_pci_cqe_rdq_handle(struct mlxsw_pci *mlxsw_pci,
 
 	rx_info.trap_id = mlxsw_pci_cqe_trap_id_get(cqe);
 
+	if (rx_info.trap_id == MLXSW_TRAP_ID_DISCARD_INGRESS_ACL ||
+	    rx_info.trap_id == MLXSW_TRAP_ID_DISCARD_EGRESS_ACL) {
+		u32 cookie_index = 0;
+
+		if (mlxsw_pci->max_cqe_ver >= MLXSW_PCI_CQE_V2)
+			cookie_index = mlxsw_pci_cqe2_user_def_val_orig_pkt_len_get(cqe);
+		mlxsw_skb_cb(skb)->cookie_index = cookie_index;
+	}
+
 	byte_count = mlxsw_pci_cqe_byte_count_get(cqe);
 	if (mlxsw_pci_cqe_crc_get(cqe_v, cqe))
 		byte_count -= ETH_FCS_LEN;
diff --git a/drivers/net/ethernet/mellanox/mlxsw/pci_hw.h b/drivers/net/ethernet/mellanox/mlxsw/pci_hw.h
index c5ceb0bb6485..32c7cabfb261 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/pci_hw.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/pci_hw.h
@@ -208,6 +208,11 @@ MLXSW_ITEM32(pci, cqe0, dqn, 0x0C, 1, 5);
 MLXSW_ITEM32(pci, cqe12, dqn, 0x0C, 1, 6);
 mlxsw_pci_cqe_item_helpers(dqn, 0, 12, 12);
 
+/* pci_cqe_user_def_val_orig_pkt_len
+ * When trap_id is an ACL: User defined value from policy engine action.
+ */
+MLXSW_ITEM32(pci, cqe2, user_def_val_orig_pkt_len, 0x14, 0, 20);
+
 /* pci_cqe_owner
  * Ownership bit.
  */
-- 
2.21.1

