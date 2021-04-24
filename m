Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D99D36A00E
	for <lists+netdev@lfdr.de>; Sat, 24 Apr 2021 10:03:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236984AbhDXIDq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 24 Apr 2021 04:03:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:47342 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232593AbhDXICU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 24 Apr 2021 04:02:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EB0D2613CD;
        Sat, 24 Apr 2021 08:01:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1619251284;
        bh=Peq/ijxxH16gVfGMBL7Oxjl+lkCkgHk6to2gj9CHbi4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=h4c6UyfIcfULxymH/r2JCHRm04aR8KNi8LQYSkcdEr/Mz6VRoUk+xdK+CdfaPnlcN
         o2PlzWFv776MP93BKFFmpQxDIhqhuJH/tnY/K7yj+XgSUVnXBeaoLsboFT97O+ZqEb
         MGsZuv0VMmMQYLSDxDRmoxAe2/6h3QSrkci3yHXvmtxpWFBK4Pw+joFLIW/OUl0XIA
         5FKAmUruC6vdOcPBhyKf6nt321/A52IfnXKbj6Ty5pRakVbq/SwEviwyJ2wH0PQOmX
         M6O7vlsStS/bJ6stK6oK/e/qi7n7R+yCqKKFSTMd1mphVF61v8QU8+kWCCDPOcQsNq
         VYkhH4c1okCug==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Parav Pandit <parav@nvidia.com>,
        Jiri Pirko <jiri@nvidia.com>, Vu Pham <vuhuong@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next V2 06/11] devlink: Extend SF port attributes to have external attribute
Date:   Sat, 24 Apr 2021 01:01:10 -0700
Message-Id: <20210424080115.97273-7-saeed@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210424080115.97273-1-saeed@kernel.org>
References: <20210424080115.97273-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Parav Pandit <parav@nvidia.com>

Extended SF port attributes to have optional external flag similar to
PCI PF and VF port attributes.

External atttibute is required to generate unique phys_port_name when PF number
and SF number are overlapping between two controllers similar to SR-IOV
VFs.

When a SF is for external controller an example view of external SF
port and config sequence.

On eswitch system:
$ devlink dev eswitch set pci/0033:01:00.0 mode switchdev

$ devlink port show
pci/0033:01:00.0/196607: type eth netdev enP51p1s0f0np0 flavour physical port 0 splittable false
pci/0033:01:00.0/131072: type eth netdev eth0 flavour pcipf controller 1 pfnum 0 external true splittable false
  function:
    hw_addr 00:00:00:00:00:00

$ devlink port add pci/0033:01:00.0 flavour pcisf pfnum 0 sfnum 77 controller 1
pci/0033:01:00.0/163840: type eth netdev eth1 flavour pcisf controller 1 pfnum 0 sfnum 77 splittable false
  function:
    hw_addr 00:00:00:00:00:00 state inactive opstate detached

phys_port_name construction:
$ cat /sys/class/net/eth1/phys_port_name
c1pf0sf77

Signed-off-by: Parav Pandit <parav@nvidia.com>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
Reviewed-by: Vu Pham <vuhuong@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../ethernet/mellanox/mlx5/core/esw/devlink_port.c    |  2 +-
 include/net/devlink.h                                 |  5 ++++-
 net/core/devlink.c                                    | 11 ++++++++++-
 3 files changed, 15 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/esw/devlink_port.c b/drivers/net/ethernet/mellanox/mlx5/core/esw/devlink_port.c
index 8e825ef35cb7..183f782b940f 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/esw/devlink_port.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/esw/devlink_port.c
@@ -141,7 +141,7 @@ int mlx5_esw_devlink_sf_port_register(struct mlx5_eswitch *esw, struct devlink_p
 	mlx5_esw_get_port_parent_id(dev, &ppid);
 	memcpy(dl_port->attrs.switch_id.id, &ppid.id[0], ppid.id_len);
 	dl_port->attrs.switch_id.id_len = ppid.id_len;
-	devlink_port_attrs_pci_sf_set(dl_port, 0, pfnum, sfnum);
+	devlink_port_attrs_pci_sf_set(dl_port, 0, pfnum, sfnum, false);
 	devlink = priv_to_devlink(dev);
 	dl_port_index = mlx5_esw_vport_to_devlink_port_index(dev, vport_num);
 	err = devlink_port_register(devlink, dl_port, dl_port_index);
diff --git a/include/net/devlink.h b/include/net/devlink.h
index 853420db5d32..7c984cadfec4 100644
--- a/include/net/devlink.h
+++ b/include/net/devlink.h
@@ -98,11 +98,13 @@ struct devlink_port_pci_vf_attrs {
  * @controller: Associated controller number
  * @sf: Associated PCI SF for of the PCI PF for this port.
  * @pf: Associated PCI PF number for this port.
+ * @external: when set, indicates if a port is for an external controller
  */
 struct devlink_port_pci_sf_attrs {
 	u32 controller;
 	u32 sf;
 	u16 pf;
+	u8 external:1;
 };
 
 /**
@@ -1508,7 +1510,8 @@ void devlink_port_attrs_pci_pf_set(struct devlink_port *devlink_port, u32 contro
 void devlink_port_attrs_pci_vf_set(struct devlink_port *devlink_port, u32 controller,
 				   u16 pf, u16 vf, bool external);
 void devlink_port_attrs_pci_sf_set(struct devlink_port *devlink_port,
-				   u32 controller, u16 pf, u32 sf);
+				   u32 controller, u16 pf, u32 sf,
+				   bool external);
 int devlink_sb_register(struct devlink *devlink, unsigned int sb_index,
 			u32 size, u16 ingress_pools_count,
 			u16 egress_pools_count, u16 ingress_tc_count,
diff --git a/net/core/devlink.c b/net/core/devlink.c
index 737b61c2976e..4eb969518ee0 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -8599,9 +8599,10 @@ EXPORT_SYMBOL_GPL(devlink_port_attrs_pci_vf_set);
  *	@controller: associated controller number for the devlink port instance
  *	@pf: associated PF for the devlink port instance
  *	@sf: associated SF of a PF for the devlink port instance
+ *	@external: indicates if the port is for an external controller
  */
 void devlink_port_attrs_pci_sf_set(struct devlink_port *devlink_port, u32 controller,
-				   u16 pf, u32 sf)
+				   u16 pf, u32 sf, bool external)
 {
 	struct devlink_port_attrs *attrs = &devlink_port->attrs;
 	int ret;
@@ -8615,6 +8616,7 @@ void devlink_port_attrs_pci_sf_set(struct devlink_port *devlink_port, u32 contro
 	attrs->pci_sf.controller = controller;
 	attrs->pci_sf.pf = pf;
 	attrs->pci_sf.sf = sf;
+	attrs->pci_sf.external = external;
 }
 EXPORT_SYMBOL_GPL(devlink_port_attrs_pci_sf_set);
 
@@ -8667,6 +8669,13 @@ static int __devlink_port_phys_port_name_get(struct devlink_port *devlink_port,
 			     attrs->pci_vf.pf, attrs->pci_vf.vf);
 		break;
 	case DEVLINK_PORT_FLAVOUR_PCI_SF:
+		if (attrs->pci_sf.external) {
+			n = snprintf(name, len, "c%u", attrs->pci_sf.controller);
+			if (n >= len)
+				return -EINVAL;
+			len -= n;
+			name += n;
+		}
 		n = snprintf(name, len, "pf%usf%u", attrs->pci_sf.pf,
 			     attrs->pci_sf.sf);
 		break;
-- 
2.30.2

