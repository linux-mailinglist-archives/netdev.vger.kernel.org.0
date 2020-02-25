Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C6F1716BF0A
	for <lists+netdev@lfdr.de>; Tue, 25 Feb 2020 11:45:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730398AbgBYKpm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Feb 2020 05:45:42 -0500
Received: from mail-wm1-f65.google.com ([209.85.128.65]:39664 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730377AbgBYKpj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Feb 2020 05:45:39 -0500
Received: by mail-wm1-f65.google.com with SMTP id c84so2612423wme.4
        for <netdev@vger.kernel.org>; Tue, 25 Feb 2020 02:45:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=hYgO2RdAljNfebakfE8lpmrMYi77WS78Xd/fXA6uUKs=;
        b=DPp65AjRxonyBSdrqf6fxRhhDcudCWvnh9kjn039c5h198Wn0BMVk9slZbTIm5kqMD
         Bsj9txm8Ji1DsQP0IFx+NPJnK5+0Mc6XuDCwhaDpntW9dkXn7Q9tm1xdhbnK/eExsnNB
         QxSjLTjpRUCYtAe7p4f80o7HUOlStIgLuOKFT++iBfFLeuDwm1d90G6X39pSO1M8mTky
         olOjL89JAjw5zcdW7aJ4hj6114SDy1nlYjD2SNZoD5/eG/xPcN6nfohQPIXBlVpT3WOG
         7nYlNxarJgJUgrJ02560Khe34Hmp1Fuu/AJ71KNQXxftWDUTZ7OMOOnI1pUshM7VTD+c
         4/fA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=hYgO2RdAljNfebakfE8lpmrMYi77WS78Xd/fXA6uUKs=;
        b=D4nrgt9sy+Hi9nttbj+X0KZFXmHz0oJ9bQjlsy+F7N0iJWt3X/xzZDfY5JfbLgU0hp
         F82vZshuVrfPMi9DK0Vy577LGjtlksvGqhw3t0xW+CBXs+TcjKBdNjaIteSvGreuYZLR
         n5OWfeI4+Je3A4sig8LEC4ZBpjzk6K3UL7vKA+K8Uvd+1Ax83ie7Nqt4iwEtq3rd5BGO
         Ik6R1uCmFxTBj7MloOfOjlYzSlOtNX9PcQXdUXXlqUiEkERaVnTQnuvziX+ncBng2DRw
         AYCBPa0wXj+y6tvznz4+BYEvVkmk1R3lYg24FaPWV7B/63QxD7SImDPyPZd5FD0bLkyx
         Kwdw==
X-Gm-Message-State: APjAAAUphQanuIRiJnWUGvOVt9LF0BQfyFiySKNentD74UMMDB1jEGj+
        IFXrugZIyC3xPGvmNfvzcWfoCxyx2UY=
X-Google-Smtp-Source: APXvYqyHXsKtflVhdaZ3+FLVK3N1drtNeMDZS1XOimgm3lYe64mGxXfBSwgLm8pfGlQ0kpmMxVn88Q==
X-Received: by 2002:a05:600c:34d:: with SMTP id u13mr4705106wmd.77.1582627537443;
        Tue, 25 Feb 2020 02:45:37 -0800 (PST)
Received: from localhost (ip-89-177-130-96.net.upcbroadband.cz. [89.177.130.96])
        by smtp.gmail.com with ESMTPSA id q14sm23642307wrj.81.2020.02.25.02.45.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Feb 2020 02:45:37 -0800 (PST)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, nhorman@tuxdriver.com,
        jhs@mojatatu.com, xiyou.wangcong@gmail.com, idosch@mellanox.com,
        mlxsw@mellanox.com
Subject: [patch net-next v2 07/10] mlxsw: pci: Extract cookie index for ACL discard trap packets
Date:   Tue, 25 Feb 2020 11:45:24 +0100
Message-Id: <20200225104527.2849-8-jiri@resnulli.us>
X-Mailer: git-send-email 2.21.1
In-Reply-To: <20200225104527.2849-1-jiri@resnulli.us>
References: <20200225104527.2849-1-jiri@resnulli.us>
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

