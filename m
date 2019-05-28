Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 142502C682
	for <lists+netdev@lfdr.de>; Tue, 28 May 2019 14:31:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727164AbfE1MbW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 May 2019 08:31:22 -0400
Received: from new3-smtp.messagingengine.com ([66.111.4.229]:41457 "EHLO
        new3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726982AbfE1MbV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 May 2019 08:31:21 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailnew.nyi.internal (Postfix) with ESMTP id 7382C23E8;
        Tue, 28 May 2019 08:22:51 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Tue, 28 May 2019 08:22:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; bh=4Rnb/5/8f9iTqw95sSTg7pwdZVvXgvpkbQKPpaTqudQ=; b=XqUwnoPY
        MzDp99U6+Yh1OnbJS+tg4GAExh9Me/P56ylLBNEMJBUB/eLgVuNjCvz0Tg765jjn
        hg2neVN1jcWbyrCLT7uoPIzsOUOuGYBJcak04Tslg6tWeUO/5TKsCOsVv7I0lOBs
        W7ohrAQ6zx0ezN22XWupBRs9wDD6Q+MuEOO/MCT5+l8wtAqr4fKcOsQ1gbX83Lca
        b1B632Foij7ilQrL0CThuxzYYpADYagT1d3oGCF/ePs/AgwUPfkN+mANAXuxRFEL
        7UlDgST4WHJCtYIZmTyZFDQkfTroSOUwKOQ+I8AJN56ZS1xdhKgdndfubLBEyMBs
        pxoP9Ouqmzrmqw==
X-ME-Sender: <xms:GyjtXAKEFM0T9IudzgJVgKmzbRtJY1Zl5IDH4YrmjrI7KFtFwb6qvQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduuddruddvhedgheduucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecukfhppeduleefrdegjedrudeihedrvdehudenucfrrghrrghmpe
    hmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrghenucevlhhushhtvghr
    ufhiiigvpeei
X-ME-Proxy: <xmx:GyjtXEHA5MnsypYH8yPfInE0bKI3Auco2JP_ue_igk9mPZ-j-3Z-jA>
    <xmx:GyjtXFT4AhneCAlWmRvnCaUva8THazSIv4Ako3wLSp1zx8hFlhEv-Q>
    <xmx:GyjtXFU9dSzZbGBcKZusxuj1fuEgpQqzla6uAlVrGgGmTRzex_BoSA>
    <xmx:GyjtXHcr_TuHsOoE21E164SAW6DQ23qPsrO2hz0SamP6dUlod3_ZYA>
Received: from splinter.mtl.com (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id DF15D380088;
        Tue, 28 May 2019 08:22:48 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com, mlxsw@mellanox.com,
        dsahern@gmail.com, roopa@cumulusnetworks.com,
        nikolay@cumulusnetworks.com, andy@greyhouse.net,
        pablo@netfilter.org, jakub.kicinski@netronome.com,
        pieter.jansenvanvuuren@netronome.com, andrew@lunn.ch,
        f.fainelli@gmail.com, vivien.didelot@savoirfairelinux.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: [RFC PATCH net-next 07/12] mlxsw: pci: Query and store PCIe bandwidth during init
Date:   Tue, 28 May 2019 15:21:31 +0300
Message-Id: <20190528122136.30476-8-idosch@idosch.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190528122136.30476-1-idosch@idosch.org>
References: <20190528122136.30476-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@mellanox.com>

A subsequent patch will need to set the CPU policer for dropped packets
to 80% of available PCIe bandwidth. Query and store and PCIe bandwidth,
so that it can be used by the switch driver later on.

For I2C bus we simply return 0 as currently there is no use case for
which it is required.

Signed-off-by: Ido Schimmel <idosch@mellanox.com>
Acked-by: Jiri Pirko <jiri@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlxsw/core.h | 1 +
 drivers/net/ethernet/mellanox/mlxsw/pci.c  | 2 ++
 2 files changed, 3 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/core.h b/drivers/net/ethernet/mellanox/mlxsw/core.h
index e3832cb5bdda..5add61a7514e 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/core.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/core.h
@@ -354,6 +354,7 @@ struct mlxsw_bus_info {
 	u8 vsd[MLXSW_CMD_BOARDINFO_VSD_LEN];
 	u8 psid[MLXSW_CMD_BOARDINFO_PSID_LEN];
 	u8 low_frequency;
+	u32 bandwidth;	/* Mb/s */
 };
 
 struct mlxsw_hwmon;
diff --git a/drivers/net/ethernet/mellanox/mlxsw/pci.c b/drivers/net/ethernet/mellanox/mlxsw/pci.c
index b40455f8293d..3184b8ea1632 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/pci.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/pci.c
@@ -1740,6 +1740,8 @@ static int mlxsw_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	mlxsw_pci->bus_info.device_kind = driver_name;
 	mlxsw_pci->bus_info.device_name = pci_name(mlxsw_pci->pdev);
 	mlxsw_pci->bus_info.dev = &pdev->dev;
+	mlxsw_pci->bus_info.bandwidth = pcie_bandwidth_available(pdev, NULL,
+								 NULL, NULL);
 	mlxsw_pci->id = id;
 
 	err = mlxsw_core_bus_device_register(&mlxsw_pci->bus_info,
-- 
2.20.1

