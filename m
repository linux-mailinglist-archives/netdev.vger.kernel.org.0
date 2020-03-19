Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DA7A318B24A
	for <lists+netdev@lfdr.de>; Thu, 19 Mar 2020 12:26:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727045AbgCSL0T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Mar 2020 07:26:19 -0400
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:46939 "EHLO
        out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726188AbgCSL0S (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Mar 2020 07:26:18 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id 2099B5C02CD;
        Thu, 19 Mar 2020 07:26:17 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Thu, 19 Mar 2020 07:26:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :message-id:mime-version:subject:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=y5trE7kCu0P1/uhF8
        98LAGD1kgCGvqOLiC02Ap42UwE=; b=BG0KIfG4eMIC5dsJe2AujjMVbneD17d3o
        AYjEdVwt/rpXwa8C3jYDkZhfeJ5IYzCe29JoD54f0khpGdjkqcPiRBTwwV7kQ/51
        4ThMCMVmOf/lfQlog2ciDc0GM2aCTijJMzpjcj65kGtY8Oo+JtoIkKqLfJ5HEC7X
        yvxrE3KcyIhmbfQ7Rp7txvwK367vDnIUkGuME+guUjB+zsVVE4Cwg4IlJO3e/rE9
        q6UAvniKMVuVNS4Bd78868+V1I9MRgDfxp0WxHkW4zjyp7b/tLuDNLEOeWJkTqWN
        6Nm/4nOO+3c603rUUjEVzz08Q377ki3T4k9XtX7ZGpqOZVD1QSjcw==
X-ME-Sender: <xms:2FZzXtSiIo1YiQ_jgfHJwtlLTk7JQbuwnLziW9BLbrc6dxvvmDVRCw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrudefledgvdekucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgggfestdekredtre
    dttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiughoshgt
    hhdrohhrgheqnecukfhppeejledrudekfedrkedrudekudenucevlhhushhtvghrufhiii
    gvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiughoshgthhesihguohhstghhrdho
    rhhg
X-ME-Proxy: <xmx:2FZzXjcYJDfHA-sQrarPvxBcVTTvajK3txr5ccTnATA6nMwNs891qQ>
    <xmx:2FZzXmucwWaZq17CcRvTqDzLh8S0lUoho7UWbBzPvkNJNvo-wLFEhg>
    <xmx:2FZzXvKuYU1tV3AusA5xhGZJOCSF-depmzi_zkz1GQeFWZHUH7ltQQ>
    <xmx:2VZzXgNahBhXDBetncKXVbEj3HxXWisBe064yCtZKgmh8IJrXUdz9w>
Received: from splinter.mtl.com (bzq-79-183-8-181.red.bezeqint.net [79.183.8.181])
        by mail.messagingengine.com (Postfix) with ESMTPA id DCB103061856;
        Thu, 19 Mar 2020 07:26:15 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net] mlxsw: pci: Only issue reset when system is ready
Date:   Thu, 19 Mar 2020 13:25:39 +0200
Message-Id: <20200319112539.1030494-1-idosch@idosch.org>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@mellanox.com>

During initialization the driver issues a software reset command and
then waits for the system status to change back to "ready" state.

However, before issuing the reset command the driver does not check that
the system is actually in "ready" state. On Spectrum-{1,2} systems this
was always the case as the hardware initialization time is very short.
On Spectrum-3 systems this is no longer the case. This results in the
software reset command timing-out and the driver failing to load:

[ 6.347591] mlxsw_spectrum3 0000:06:00.0: Cmd exec timed-out (opcode=40(ACCESS_REG),opcode_mod=0,in_mod=0)
[ 6.358382] mlxsw_spectrum3 0000:06:00.0: Reg cmd access failed (reg_id=9023(mrsr),type=write)
[ 6.368028] mlxsw_spectrum3 0000:06:00.0: cannot register bus device
[ 6.375274] mlxsw_spectrum3: probe of 0000:06:00.0 failed with error -110

Fix this by waiting for the system to become ready both before issuing
the reset command and afterwards. In case of failure, print the last
system status to aid in debugging.

Fixes: da382875c616 ("mlxsw: spectrum: Extend to support Spectrum-3 ASIC")
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
Reviewed-by: Jiri Pirko <jiri@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlxsw/pci.c | 50 ++++++++++++++++++-----
 1 file changed, 39 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/pci.c b/drivers/net/ethernet/mellanox/mlxsw/pci.c
index 914c33e46fb4..e9ded1a6e131 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/pci.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/pci.c
@@ -1322,36 +1322,64 @@ static void mlxsw_pci_mbox_free(struct mlxsw_pci *mlxsw_pci,
 			    mbox->mapaddr);
 }
 
-static int mlxsw_pci_sw_reset(struct mlxsw_pci *mlxsw_pci,
-			      const struct pci_device_id *id)
+static int mlxsw_pci_sys_ready_wait(struct mlxsw_pci *mlxsw_pci,
+				    const struct pci_device_id *id,
+				    u32 *p_sys_status)
 {
 	unsigned long end;
-	char mrsr_pl[MLXSW_REG_MRSR_LEN];
-	int err;
+	u32 val;
 
-	mlxsw_reg_mrsr_pack(mrsr_pl);
-	err = mlxsw_reg_write(mlxsw_pci->core, MLXSW_REG(mrsr), mrsr_pl);
-	if (err)
-		return err;
 	if (id->device == PCI_DEVICE_ID_MELLANOX_SWITCHX2) {
 		msleep(MLXSW_PCI_SW_RESET_TIMEOUT_MSECS);
 		return 0;
 	}
 
-	/* We must wait for the HW to become responsive once again. */
+	/* We must wait for the HW to become responsive. */
 	msleep(MLXSW_PCI_SW_RESET_WAIT_MSECS);
 
 	end = jiffies + msecs_to_jiffies(MLXSW_PCI_SW_RESET_TIMEOUT_MSECS);
 	do {
-		u32 val = mlxsw_pci_read32(mlxsw_pci, FW_READY);
-
+		val = mlxsw_pci_read32(mlxsw_pci, FW_READY);
 		if ((val & MLXSW_PCI_FW_READY_MASK) == MLXSW_PCI_FW_READY_MAGIC)
 			return 0;
 		cond_resched();
 	} while (time_before(jiffies, end));
+
+	*p_sys_status = val & MLXSW_PCI_FW_READY_MASK;
+
 	return -EBUSY;
 }
 
+static int mlxsw_pci_sw_reset(struct mlxsw_pci *mlxsw_pci,
+			      const struct pci_device_id *id)
+{
+	struct pci_dev *pdev = mlxsw_pci->pdev;
+	char mrsr_pl[MLXSW_REG_MRSR_LEN];
+	u32 sys_status;
+	int err;
+
+	err = mlxsw_pci_sys_ready_wait(mlxsw_pci, id, &sys_status);
+	if (err) {
+		dev_err(&pdev->dev, "Failed to reach system ready status before reset. Status is 0x%x\n",
+			sys_status);
+		return err;
+	}
+
+	mlxsw_reg_mrsr_pack(mrsr_pl);
+	err = mlxsw_reg_write(mlxsw_pci->core, MLXSW_REG(mrsr), mrsr_pl);
+	if (err)
+		return err;
+
+	err = mlxsw_pci_sys_ready_wait(mlxsw_pci, id, &sys_status);
+	if (err) {
+		dev_err(&pdev->dev, "Failed to reach system ready status after reset. Status is 0x%x\n",
+			sys_status);
+		return err;
+	}
+
+	return 0;
+}
+
 static int mlxsw_pci_alloc_irq_vectors(struct mlxsw_pci *mlxsw_pci)
 {
 	int err;
-- 
2.24.1

