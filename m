Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 717DC2A36FB
	for <lists+netdev@lfdr.de>; Tue,  3 Nov 2020 00:13:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726482AbgKBXNX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Nov 2020 18:13:23 -0500
Received: from mx3.molgen.mpg.de ([141.14.17.11]:42779 "EHLO mx1.molgen.mpg.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725841AbgKBXNW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 2 Nov 2020 18:13:22 -0500
Received: from localhost.localdomain (ip5f5af1d0.dynamic.kabel-deutschland.de [95.90.241.208])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: pmenzel)
        by mx.molgen.mpg.de (Postfix) with ESMTPSA id 50C5420646DD7;
        Tue,  3 Nov 2020 00:13:20 +0100 (CET)
From:   Paul Menzel <pmenzel@molgen.mpg.de>
To:     Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     Jeffrey Townsend <jeffrey.townsend@bigswitch.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        John W Linville <linville@tuxdriver.com>,
        Paul Menzel <pmenzel@molgen.mpg.de>
Subject: [PATCH 1/2] ethernet: igb: Support PHY BCM5461S
Date:   Tue,  3 Nov 2020 00:13:06 +0100
Message-Id: <20201102231307.13021-2-pmenzel@molgen.mpg.de>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201102231307.13021-1-pmenzel@molgen.mpg.de>
References: <20201102231307.13021-1-pmenzel@molgen.mpg.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jeffrey Townsend <jeffrey.townsend@bigswitch.com>

The BCM5461S PHY is used in switches.

The patch is taken from Open Network Linux, and it was added there as
patch

    packages/base/any/kernels/3.16+deb8/patches/driver-support-intel-igb-bcm5461X-phy.patch

in ONL commit f32316c63c (Support the BCM54616 and BCM5461S.) [1]. Part
of this commit was already upstreamed in Linux commit eeb0149660 (igb:
support BCM54616 PHY) in 2017.

I applied the forward-ported

    packages/base/any/kernels/5.4-lts/patches/0002-driver-support-intel-igb-bcm5461S-phy.patch

added in ONL commit 5ace6bcdb3 (Add 5.4 LTS kernel build.) [2].

[1]: https://github.com/opencomputeproject/OpenNetworkLinux/commit/f32316c63ce3a64de125b7429115c6d45e942bd1
[2]: https://github.com/opencomputeproject/OpenNetworkLinux/commit/5ace6bcdb37cb8065dcd1d4404b3dcb6424f6331

Cc: Jeffrey Townsend <jeffrey.townsend@bigswitch.com>
Cc: John W Linville <linville@tuxdriver.com>
Signed-off-by: Paul Menzel <pmenzel@molgen.mpg.de>
---
 drivers/net/ethernet/intel/igb/e1000_82575.c  | 23 +++++-
 .../net/ethernet/intel/igb/e1000_defines.h    |  1 +
 drivers/net/ethernet/intel/igb/e1000_hw.h     |  1 +
 drivers/net/ethernet/intel/igb/e1000_phy.c    | 77 +++++++++++++++++++
 drivers/net/ethernet/intel/igb/e1000_phy.h    |  2 +
 drivers/net/ethernet/intel/igb/igb_main.c     |  8 ++
 6 files changed, 111 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/igb/e1000_82575.c b/drivers/net/ethernet/intel/igb/e1000_82575.c
index 50863fd87d53..83c14ae689b1 100644
--- a/drivers/net/ethernet/intel/igb/e1000_82575.c
+++ b/drivers/net/ethernet/intel/igb/e1000_82575.c
@@ -308,6 +308,12 @@ static s32 igb_init_phy_params_82575(struct e1000_hw *hw)
 		phy->ops.set_d3_lplu_state = igb_set_d3_lplu_state_82580;
 		phy->ops.force_speed_duplex = igb_phy_force_speed_duplex_m88;
 		break;
+	case BCM5461S_PHY_ID:
+		phy->type		= e1000_phy_bcm5461s;
+		phy->ops.check_polarity	= NULL;
+		phy->ops.get_cable_length = NULL;
+		phy->ops.force_speed_duplex = igb_phy_force_speed_duplex_82580;
+		break;
 	case BCM54616_E_PHY_ID:
 		phy->type = e1000_phy_bcm54616;
 		break;
@@ -866,6 +872,16 @@ static s32 igb_get_phy_id_82575(struct e1000_hw *hw)
 			goto out;
 		}
 		ret_val = igb_get_phy_id(hw);
+		if (ret_val && hw->mac.type == e1000_i354) {
+			/* we do a special check for bcm5461s phy by setting
+			 * the phy->addr to 5 and doing the phy check again. This
+			 * call will succeed and retrieve a valid phy id if we have
+			 * the bcm5461s phy
+			 */
+			phy->addr = 5;
+			phy->type = e1000_phy_bcm5461s;
+			ret_val = igb_get_phy_id(hw);
+		}
 		goto out;
 	}
 
@@ -1253,6 +1269,9 @@ static s32 igb_get_cfg_done_82575(struct e1000_hw *hw)
 	    (hw->phy.type == e1000_phy_igp_3))
 		igb_phy_init_script_igp3(hw);
 
+	if (hw->phy.type == e1000_phy_bcm5461s)
+		igb_phy_init_script_5461s(hw);
+
 	return 0;
 }
 
@@ -1582,6 +1601,7 @@ static s32 igb_setup_copper_link_82575(struct e1000_hw *hw)
 	case e1000_i350:
 	case e1000_i210:
 	case e1000_i211:
+	case e1000_i354:
 		phpm_reg = rd32(E1000_82580_PHY_POWER_MGMT);
 		phpm_reg &= ~E1000_82580_PM_GO_LINKD;
 		wr32(E1000_82580_PHY_POWER_MGMT, phpm_reg);
@@ -1627,7 +1647,8 @@ static s32 igb_setup_copper_link_82575(struct e1000_hw *hw)
 		ret_val = igb_copper_link_setup_82580(hw);
 		break;
 	case e1000_phy_bcm54616:
-		ret_val = 0;
+		break;
+	case e1000_phy_bcm5461s:
 		break;
 	default:
 		ret_val = -E1000_ERR_PHY;
diff --git a/drivers/net/ethernet/intel/igb/e1000_defines.h b/drivers/net/ethernet/intel/igb/e1000_defines.h
index d2e2c50ce257..0561ef6cb29c 100644
--- a/drivers/net/ethernet/intel/igb/e1000_defines.h
+++ b/drivers/net/ethernet/intel/igb/e1000_defines.h
@@ -886,6 +886,7 @@
 #define M88E1543_E_PHY_ID    0x01410EA0
 #define M88E1512_E_PHY_ID    0x01410DD0
 #define BCM54616_E_PHY_ID    0x03625D10
+#define BCM5461S_PHY_ID      0x002060C0
 
 /* M88E1000 Specific Registers */
 #define M88E1000_PHY_SPEC_CTRL     0x10  /* PHY Specific Control Register */
diff --git a/drivers/net/ethernet/intel/igb/e1000_hw.h b/drivers/net/ethernet/intel/igb/e1000_hw.h
index 5d87957b2627..a660675d6218 100644
--- a/drivers/net/ethernet/intel/igb/e1000_hw.h
+++ b/drivers/net/ethernet/intel/igb/e1000_hw.h
@@ -110,6 +110,7 @@ enum e1000_phy_type {
 	e1000_phy_82580,
 	e1000_phy_i210,
 	e1000_phy_bcm54616,
+	e1000_phy_bcm5461s,
 };
 
 enum e1000_bus_type {
diff --git a/drivers/net/ethernet/intel/igb/e1000_phy.c b/drivers/net/ethernet/intel/igb/e1000_phy.c
index 8c8eb82e6272..4e0b4ba09a00 100644
--- a/drivers/net/ethernet/intel/igb/e1000_phy.c
+++ b/drivers/net/ethernet/intel/igb/e1000_phy.c
@@ -126,6 +126,13 @@ s32 igb_read_phy_reg_mdic(struct e1000_hw *hw, u32 offset, u16 *data)
 	 * Control register.  The MAC will take care of interfacing with the
 	 * PHY to retrieve the desired data.
 	 */
+	if (phy->type == e1000_phy_bcm5461s) {
+		mdic = rd32(E1000_MDICNFG);
+		mdic &= ~E1000_MDICNFG_PHY_MASK;
+		mdic |= (phy->addr << E1000_MDICNFG_PHY_SHIFT);
+		wr32(E1000_MDICNFG, mdic);
+	}
+
 	mdic = ((offset << E1000_MDIC_REG_SHIFT) |
 		(phy->addr << E1000_MDIC_PHY_SHIFT) |
 		(E1000_MDIC_OP_READ));
@@ -182,6 +189,13 @@ s32 igb_write_phy_reg_mdic(struct e1000_hw *hw, u32 offset, u16 data)
 	 * Control register.  The MAC will take care of interfacing with the
 	 * PHY to retrieve the desired data.
 	 */
+	if (phy->type == e1000_phy_bcm5461s) {
+		mdic = rd32(E1000_MDICNFG);
+		mdic &= ~E1000_MDICNFG_PHY_MASK;
+		mdic |= (phy->addr << E1000_MDICNFG_PHY_SHIFT);
+		wr32(E1000_MDICNFG, mdic);
+	}
+
 	mdic = (((u32)data) |
 		(offset << E1000_MDIC_REG_SHIFT) |
 		(phy->addr << E1000_MDIC_PHY_SHIFT) |
@@ -2628,3 +2642,66 @@ static s32 igb_set_master_slave_mode(struct e1000_hw *hw)
 
 	return hw->phy.ops.write_reg(hw, PHY_1000T_CTRL, phy_data);
 }
+
+/**
+ *  igb_phy_init_script_5461s - Inits the BCM5461S PHY
+ *  @hw: pointer to the HW structure
+ *
+ *  Initializes a Broadcom Gigabit PHY.
+ **/
+s32 igb_phy_init_script_5461s(struct e1000_hw *hw)
+{
+	u16 mii_reg_led = 0;
+
+	/* 1. Speed LED (Set the Link LED mode), Shadow 00010, 0x1C.bit2=1 */
+	hw->phy.ops.write_reg(hw, 0x1C, 0x0800);
+	hw->phy.ops.read_reg(hw, 0x1C, &mii_reg_led);
+	mii_reg_led |= 0x0004;
+	hw->phy.ops.write_reg(hw, 0x1C, mii_reg_led | 0x8000);
+
+	/* 2. Active LED (Set the Link LED mode), Shadow 01001, 0x1C.bit4=1, 0x10.bit5=0 */
+	hw->phy.ops.write_reg(hw, 0x1C, 0x2400);
+	hw->phy.ops.read_reg(hw, 0x1C, &mii_reg_led);
+	mii_reg_led |= 0x0010;
+	hw->phy.ops.write_reg(hw, 0x1C, mii_reg_led | 0x8000);
+	hw->phy.ops.read_reg(hw, 0x10, &mii_reg_led);
+	mii_reg_led &= 0xffdf;
+	hw->phy.ops.write_reg(hw, 0x10, mii_reg_led);
+
+	return 0;
+}
+
+/**
+ *  igb_get_phy_info_5461s - Retrieve 5461s PHY information
+ *  @hw: pointer to the HW structure
+ *
+ *  Read PHY status to determine if link is up.  If link is up, then
+ *  set/determine 10base-T extended distance and polarity correction.  Read
+ *  PHY port status to determine MDI/MDIx and speed.  Based on the speed,
+ *  determine on the cable length, local and remote receiver.
+ **/
+s32 igb_get_phy_info_5461s(struct e1000_hw *hw)
+{
+	struct e1000_phy_info *phy = &hw->phy;
+	s32 ret_val;
+	bool link;
+
+	ret_val = igb_phy_has_link(hw, 1, 0, &link);
+	if (ret_val)
+		goto out;
+
+	if (!link) {
+		ret_val = -E1000_ERR_CONFIG;
+		goto out;
+	}
+
+	phy->polarity_correction = true;
+
+	phy->is_mdix = true;
+	phy->cable_length = E1000_CABLE_LENGTH_UNDEFINED;
+	phy->local_rx = e1000_1000t_rx_status_ok;
+	phy->remote_rx = e1000_1000t_rx_status_ok;
+
+out:
+	return ret_val;
+}
diff --git a/drivers/net/ethernet/intel/igb/e1000_phy.h b/drivers/net/ethernet/intel/igb/e1000_phy.h
index 5894e4b1d0a8..aa888efc05f2 100644
--- a/drivers/net/ethernet/intel/igb/e1000_phy.h
+++ b/drivers/net/ethernet/intel/igb/e1000_phy.h
@@ -41,6 +41,8 @@ s32  igb_phy_has_link(struct e1000_hw *hw, u32 iterations,
 void igb_power_up_phy_copper(struct e1000_hw *hw);
 void igb_power_down_phy_copper(struct e1000_hw *hw);
 s32  igb_phy_init_script_igp3(struct e1000_hw *hw);
+s32  igb_phy_init_script_5461s(struct e1000_hw *hw);
+s32  igb_get_phy_info_5461s(struct e1000_hw *hw);
 s32  igb_initialize_M88E1512_phy(struct e1000_hw *hw);
 s32  igb_initialize_M88E1543_phy(struct e1000_hw *hw);
 s32  igb_read_phy_reg_mdic(struct e1000_hw *hw, u32 offset, u16 *data);
diff --git a/drivers/net/ethernet/intel/igb/igb_main.c b/drivers/net/ethernet/intel/igb/igb_main.c
index 5fc2c381da55..275fac4cbf63 100644
--- a/drivers/net/ethernet/intel/igb/igb_main.c
+++ b/drivers/net/ethernet/intel/igb/igb_main.c
@@ -8923,11 +8923,19 @@ static int igb_mii_ioctl(struct net_device *netdev, struct ifreq *ifr, int cmd)
 		data->phy_id = adapter->hw.phy.addr;
 		break;
 	case SIOCGMIIREG:
+		adapter->hw.phy.addr = data->phy_id;
 		if (igb_read_phy_reg(&adapter->hw, data->reg_num & 0x1F,
 				     &data->val_out))
 			return -EIO;
 		break;
 	case SIOCSMIIREG:
+		if (!capable(CAP_NET_ADMIN))
+			return -EPERM;
+		adapter->hw.phy.addr = data->phy_id;
+		if (igb_write_phy_reg(&adapter->hw, data->reg_num & 0x1F,
+				      data->val_in))
+			return -EIO;
+		break;
 	default:
 		return -EOPNOTSUPP;
 	}
-- 
2.29.1

