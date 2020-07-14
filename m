Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C8B7721F3CD
	for <lists+netdev@lfdr.de>; Tue, 14 Jul 2020 16:23:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728560AbgGNOWD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jul 2020 10:22:03 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:42641 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728505AbgGNOWA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jul 2020 10:22:00 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id A79605C00EA;
        Tue, 14 Jul 2020 10:21:59 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Tue, 14 Jul 2020 10:21:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=TofqFlcb/Yk7BY2YOpz9XosgRullqb7quJ/1TXuyQ4w=; b=jlW8rXgI
        HL3LXxQxs1/v3M2pUgCqOX6Uf4mdJGiACU8ltqrmnvwroNAQPTfweNpk7LHPnzG3
        dwJCkKYcOe+mx48N9VUZfI+lRDLw3kjd191S7ayGxlJFMPyTrIbHu4hCvF8p6sQa
        AQpoNxxhTJHEBd3+tx7PDX8UdXJKT29WA6sfrT8qftYwll4go9+gwQKXM0DxecuL
        DyX/7gU9qmGFSpcTYHR9Ybe3X+tQ6kzijFtFShumEgHF+D83mzTYrDX0v+d5ldPJ
        4JKZG4CksomuJy1PIpI99JZiRvPc7H5Zrg0aRSPrG9gC5FV5lsgxdQidfwpSsgIe
        493QyETtjYHS+w==
X-ME-Sender: <xms:h78NXyNdPyVwuGV8nZGObxISYY4dR9nVCq4ar2rXUmjr09zFL10euw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedrfedtgdejkecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtkeertd
    ertddtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihguohhs
    tghhrdhorhhgqeenucggtffrrghtthgvrhhnpeduteeiveffffevleekleejffekhfekhe
    fgtdfftefhledvjefggfehgfevjeekhfenucfkphepuddtledrieeirdduledrudeffeen
    ucevlhhushhtvghrufhiiigvpeelnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiughosh
    gthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:h78NXw824kcJTpN0DnUwYXgaOhJ4WlgVYD1JH1ZOQs7BjeYhHKipHg>
    <xmx:h78NX5TWFqegY9ufTqtLHf5f8uFE_-E76T0hBtlhdR5LgvzgWF22kA>
    <xmx:h78NXyvB1RY0C4j2ONY0XaWwhinMrwyEBaynJ77yUALIPrTPirKUDA>
    <xmx:h78NX64U5Z-e0TSsJOCitk1gDIVHxVMH6qAqKc7L11baoTwjVVWKHQ>
Received: from shredder.mtl.com (bzq-109-66-19-133.red.bezeqint.net [109.66.19.133])
        by mail.messagingengine.com (Postfix) with ESMTPA id D43FB306005F;
        Tue, 14 Jul 2020 10:21:57 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@mellanox.com,
        petrm@mellanox.com, amitc@mellanox.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 12/13] mlxsw: pci: Retrieve mirror reason from CQE during receive
Date:   Tue, 14 Jul 2020 17:21:05 +0300
Message-Id: <20200714142106.386354-13-idosch@idosch.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200714142106.386354-1-idosch@idosch.org>
References: <20200714142106.386354-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@mellanox.com>

In case the mirror reason is valid, retrieve it into the Rx information
so that it could be used during listener lookup in a later patch.

Reviewed-by: Jiri Pirko <jiri@mellanox.com>
Signed-off-by: Petr Machata <petrm@mellanox.com>
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlxsw/core.h | 1 +
 drivers/net/ethernet/mellanox/mlxsw/pci.c  | 6 +++++-
 2 files changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/core.h b/drivers/net/ethernet/mellanox/mlxsw/core.h
index 7d6b0a232789..c736b8673791 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/core.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/core.h
@@ -176,6 +176,7 @@ struct mlxsw_rx_info {
 		u16 lag_id;
 	} u;
 	u8 lag_port_index;
+	u8 mirror_reason;
 	int trap_id;
 };
 
diff --git a/drivers/net/ethernet/mellanox/mlxsw/pci.c b/drivers/net/ethernet/mellanox/mlxsw/pci.c
index c04ec1a92826..1c64b03ff48e 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/pci.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/pci.c
@@ -547,9 +547,9 @@ static void mlxsw_pci_cqe_rdq_handle(struct mlxsw_pci *mlxsw_pci,
 {
 	struct pci_dev *pdev = mlxsw_pci->pdev;
 	struct mlxsw_pci_queue_elem_info *elem_info;
+	struct mlxsw_rx_info rx_info = {};
 	char *wqe;
 	struct sk_buff *skb;
-	struct mlxsw_rx_info rx_info;
 	u16 byte_count;
 	int err;
 
@@ -582,6 +582,10 @@ static void mlxsw_pci_cqe_rdq_handle(struct mlxsw_pci *mlxsw_pci,
 		if (mlxsw_pci->max_cqe_ver >= MLXSW_PCI_CQE_V2)
 			cookie_index = mlxsw_pci_cqe2_user_def_val_orig_pkt_len_get(cqe);
 		mlxsw_skb_cb(skb)->cookie_index = cookie_index;
+	} else if (rx_info.trap_id >= MLXSW_TRAP_ID_MIRROR_SESSION0 &&
+		   rx_info.trap_id <= MLXSW_TRAP_ID_MIRROR_SESSION7 &&
+		   mlxsw_pci->max_cqe_ver >= MLXSW_PCI_CQE_V2) {
+		rx_info.mirror_reason = mlxsw_pci_cqe2_mirror_reason_get(cqe);
 	}
 
 	byte_count = mlxsw_pci_cqe_byte_count_get(cqe);
-- 
2.26.2

