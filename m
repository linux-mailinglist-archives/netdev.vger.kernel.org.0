Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C087922382F
	for <lists+netdev@lfdr.de>; Fri, 17 Jul 2020 11:24:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726512AbgGQJWE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jul 2020 05:22:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726446AbgGQJWB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Jul 2020 05:22:01 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08A91C061755
        for <netdev@vger.kernel.org>; Fri, 17 Jul 2020 02:22:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=zHzQgg/pHH4i6y4VXe8d/ktFYbqn84Ea5jbrCmWUBlY=; b=B9+3A6k4+CQLX6P6E7BR9lfax
        rF1IVHp+UJ0tukRZvT19fMug0JKFarydnEKs+ghhcjG6BFkeNMAYHbbE+dSYvsIu5veDJnSEY+F32
        HOcitsQwlGr2Ba+fPCdZ3b8owIvZLlOMOLWvdJPLqXQZKJErsbO7c4/W0CHKmvgmjHdyusUbElr3G
        oKRuQBG6VvAT2rCSG5+CRrcjzckeUNwZLJG7Gv7s8lNF+RzSzRABIqofN9pGHWXl8eNqEGco6BoLE
        NskUcuTO2wkb8Yd9cQd3GQoZRa1zHp4wDi+wn/eU70Xqm+4/pNbuX6W6RyzRFF1irIYeZFFNtBFFp
        Ma1wZHl6w==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:40584)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1jwMZ2-0000Po-LB; Fri, 17 Jul 2020 10:21:56 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1jwMZ0-0001mh-1k; Fri, 17 Jul 2020 10:21:54 +0100
Date:   Fri, 17 Jul 2020 10:21:54 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Martin Rowe <martin.p.rowe@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>, netdev@vger.kernel.org,
        davem@davemloft.net, vivien.didelot@gmail.com
Subject: Re: bug: net: dsa: mv88e6xxx: unable to tx or rx with Clearfog GT 8K
 (with git bisect)
Message-ID: <20200717092153.GK1551@shell.armlinux.org.uk>
References: <CAOAjy5T63wDzDowikwZXPTC5fCnPL1QbH9P1v+MMOfydegV30w@mail.gmail.com>
 <20200711162349.GL1014141@lunn.ch>
 <20200711192255.GO1551@shell.armlinux.org.uk>
 <CAOAjy5TBOhovCRDF7NC-DWemA2k5as93tqq3gOT1chO4O0jpiA@mail.gmail.com>
 <20200712132554.GS1551@shell.armlinux.org.uk>
 <CAOAjy5T0oNJBsjru9r7MPu_oO8TSpY4PKDg7whq4yBJE12mPaA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOAjy5T0oNJBsjru9r7MPu_oO8TSpY4PKDg7whq4yBJE12mPaA@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 17, 2020 at 05:56:22AM +0000, Martin Rowe wrote:
> On Sun, 12 Jul 2020 at 13:26, Russell King - ARM Linux admin
> <linux@armlinux.org.uk> wrote:
> > If it is a port issue, that should help pinpoint it - if it's a problem
> > with the CPU port configuration, then ethtool can't read those registers
> > (and the only way to get them is to apply some debugfs patch that was
> > refused from being merged into mainline.)
> 
> It looks like this is the next step then. Do you have a link to the
> patch? I'll give it a go. What outputs would be useful for me to
> provide?

The patch below is what I'm still using - a forward ported version of
a Vivien's very old debugfs patch (but with bits of it disabled.) I
prefer the combined format of the "regs" file which dumps all the
switch registers in one place.

The key file is /sys/kernel/debug/mv88e6xxx.0/regs - please send the
contents of that file.

Thanks.

8<===
From: Vivien Didelot <vivien.didelot@savoirfairelinux.com>
Subject: [PATCH] net: dsa: mv88e6xxx: add debugfs interface

Add a debugfs directory named mv88e6xxx.X where X is the DSA switch
index. Mount the debugfs file system with:

    # mount -t debugfs none /sys/kernel/debug

Signed-off-by: Vivien Didelot <vivien.didelot@savoirfairelinux.com>
[Modified by rmk for current kernels.]
Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
---
 drivers/net/dsa/mv88e6xxx/chip.c              |    7 +
 drivers/net/dsa/mv88e6xxx/chip.h              |    2 +
 drivers/net/dsa/mv88e6xxx/mv88e6xxx_debugfs.c | 1102 +++++++++++++++++
 3 files changed, 1111 insertions(+)
 create mode 100644 drivers/net/dsa/mv88e6xxx/mv88e6xxx_debugfs.c

diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index 7627ea61e0ea..0bce26f1df93 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -3030,8 +3030,13 @@ static int mv88e6xxx_setup_devlink_resources(struct dsa_switch *ds)
 	return err;
 }
 
+#include "mv88e6xxx_debugfs.c"
+
 static void mv88e6xxx_teardown(struct dsa_switch *ds)
 {
+	struct mv88e6xxx_chip *chip = ds->priv;
+
+	mv88e6xxx_remove_debugfs(chip);
 	mv88e6xxx_teardown_devlink_params(ds);
 	dsa_devlink_resources_unregister(ds);
 }
@@ -3149,6 +3154,8 @@ static int mv88e6xxx_setup(struct dsa_switch *ds)
 	if (err)
 		goto unlock;
 
+	mv88e6xxx_init_debugfs(chip);
+
 unlock:
 	mv88e6xxx_reg_unlock(chip);
 
diff --git a/drivers/net/dsa/mv88e6xxx/chip.h b/drivers/net/dsa/mv88e6xxx/chip.h
index e5430cf2ad71..f78536bdfe39 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.h
+++ b/drivers/net/dsa/mv88e6xxx/chip.h
@@ -333,6 +333,8 @@ struct mv88e6xxx_chip {
 
 	/* Array of port structures. */
 	struct mv88e6xxx_port ports[DSA_MAX_PORTS];
+
+	struct dentry *dbgfs;
 };
 
 struct mv88e6xxx_bus_ops {
diff --git a/drivers/net/dsa/mv88e6xxx/mv88e6xxx_debugfs.c b/drivers/net/dsa/mv88e6xxx/mv88e6xxx_debugfs.c
new file mode 100644
index 000000000000..4005a4760884
--- /dev/null
+++ b/drivers/net/dsa/mv88e6xxx/mv88e6xxx_debugfs.c
@@ -0,0 +1,1102 @@
+#include <linux/debugfs.h>
+#include <linux/seq_file.h>
+
+#define GLOBAL2_PVT_ADDR	0x0b
+#define GLOBAL2_PVT_ADDR_BUSY	BIT(15)
+#define GLOBAL2_PVT_ADDR_OP_INIT_ONES	((0x01 << 12) | GLOBAL2_PVT_ADDR_BUSY)
+#define GLOBAL2_PVT_ADDR_OP_WRITE_PVLAN	((0x03 << 12) | GLOBAL2_PVT_ADDR_BUSY)
+#define GLOBAL2_PVT_ADDR_OP_READ	((0x04 << 12) | GLOBAL2_PVT_ADDR_BUSY)
+#define GLOBAL2_PVT_DATA	0x0c
+
+#define ADDR_GLOBAL2	0x1c
+
+static int mv88e6xxx_serdes_read(struct mv88e6xxx_chip *chip, int reg, u16 *val)
+{
+	return mv88e6xxx_phy_page_read(chip, MV88E6352_ADDR_SERDES,
+				       MV88E6352_SERDES_PAGE_FIBER,
+				       reg, val);
+}
+
+static int mv88e6xxx_serdes_write(struct mv88e6xxx_chip *chip, int reg, u16 val)
+{
+	return mv88e6xxx_phy_page_write(chip, MV88E6352_ADDR_SERDES,
+					MV88E6352_SERDES_PAGE_FIBER,
+					reg, val);
+}
+
+static int _mv88e6xxx_pvt_wait(struct mv88e6xxx_chip *chip)
+{
+	return mv88e6xxx_wait_mask(chip, ADDR_GLOBAL2, GLOBAL2_PVT_ADDR,
+				   GLOBAL2_PVT_ADDR_BUSY, 0);
+}
+
+static int _mv88e6xxx_pvt_cmd(struct mv88e6xxx_chip *chip, int src_dev,
+			      int src_port, u16 op)
+{
+	u16 reg = op;
+	int err;
+
+	/* 9-bit Cross-chip PVT pointer: with GLOBAL2_MISC_5_BIT_PORT cleared,
+	 * source device is 5-bit, source port is 4-bit.
+	 */
+	reg |= (src_dev & 0x1f) << 4;
+	reg |= (src_port & 0xf);
+
+	err = mv88e6xxx_g2_write(chip, GLOBAL2_PVT_ADDR, reg);
+	if (err)
+		return err;
+
+	return _mv88e6xxx_pvt_wait(chip);
+}
+
+static int _mv88e6xxx_pvt_read(struct mv88e6xxx_chip *chip, int src_dev,
+			       int src_port, u16 *data)
+{
+	int ret;
+
+	ret = _mv88e6xxx_pvt_wait(chip);
+	if (ret < 0)
+		return ret;
+
+	ret = _mv88e6xxx_pvt_cmd(chip, src_dev, src_port,
+				GLOBAL2_PVT_ADDR_OP_READ);
+	if (ret < 0)
+		return ret;
+
+	return mv88e6xxx_g2_read(chip, GLOBAL2_PVT_DATA, data);
+}
+
+static int _mv88e6xxx_pvt_write(struct mv88e6xxx_chip *chip, int src_dev,
+				int src_port, u16 data)
+{
+	int err;
+
+	err = _mv88e6xxx_pvt_wait(chip);
+	if (err)
+		return err;
+
+	err = mv88e6xxx_g2_write(chip, GLOBAL2_PVT_DATA, data);
+	if (err)
+		return err;
+
+        return _mv88e6xxx_pvt_cmd(chip, src_dev, src_port,
+				  GLOBAL2_PVT_ADDR_OP_WRITE_PVLAN);
+}
+
+static int mv88e6xxx_regs_show(struct seq_file *s, void *p)
+{
+	struct mv88e6xxx_chip *chip = s->private;
+	int port, reg, ret;
+	u16 data;
+
+	seq_puts(s, "    GLOBAL GLOBAL2 SERDES   ");
+	for (port = 0; port < mv88e6xxx_num_ports(chip); port++)
+		seq_printf(s, " %2d  ", port);
+	seq_puts(s, "\n");
+
+	mutex_lock(&chip->reg_lock);
+
+	for (reg = 0; reg < 32; reg++) {
+		seq_printf(s, "%2x:", reg);
+
+		ret = mv88e6xxx_g1_read(chip, reg, &data);
+		if (ret < 0)
+			goto unlock;
+		seq_printf(s, "  %4x  ", data);
+
+		ret = mv88e6xxx_g2_read(chip, reg, &data);
+		if (ret < 0)
+			goto unlock;
+		seq_printf(s, "  %4x  ", data);
+
+		if (reg != MV88E6XXX_PHY_PAGE) {
+			ret = mv88e6xxx_serdes_read(chip, reg, &data);
+			if (ret < 0)
+				goto unlock;
+		} else {
+			data = 0;
+		}
+		seq_printf(s, "  %4x  ", data);
+
+		/* Port regs 0x1a-0x1f are reserved in 6185 family */
+		if (chip->info->family == MV88E6XXX_FAMILY_6185 && reg > 25) {
+			for (port = 0; port < mv88e6xxx_num_ports(chip); ++port)
+				seq_printf(s, "%4c ", '-');
+			seq_puts(s, "\n");
+			continue;
+		}
+
+		for (port = 0; port < mv88e6xxx_num_ports(chip); ++port) {
+			ret = mv88e6xxx_port_read(chip, port, reg, &data);
+			if (ret < 0)
+				goto unlock;
+
+			seq_printf(s, "%4x ", data);
+		}
+
+		seq_puts(s, "\n");
+	}
+
+	ret = 0;
+unlock:
+	mutex_unlock(&chip->reg_lock);
+
+	return ret;
+}
+
+static ssize_t mv88e6xxx_regs_write(struct file *file, const char __user *buf,
+				    size_t count, loff_t *ppos)
+{
+	struct seq_file *s = file->private_data;
+	struct mv88e6xxx_chip *chip = s->private;
+	char cmd[32], name[32] = { 0 };
+	unsigned int port, reg, val;
+	int ret;
+
+	if (count > sizeof(name) - 1)
+		return -EINVAL;
+
+	if (copy_from_user(cmd, buf, sizeof(cmd)))
+		return -EFAULT;
+
+	ret = sscanf(cmd, "%s %x %x", name, &reg, &val);
+	if (ret != 3)
+		return -EINVAL;
+
+	if (reg > 0x1f || val > 0xffff)
+		return -ERANGE;
+
+	mutex_lock(&chip->reg_lock);
+
+	if (strcasecmp(name, "GLOBAL") == 0)
+		ret = mv88e6xxx_g1_write(chip, reg, val);
+	else if (strcasecmp(name, "GLOBAL2") == 0)
+		ret = mv88e6xxx_g2_write(chip, reg, val);
+	else if (strcasecmp(name, "SERDES") == 0)
+		ret = mv88e6xxx_serdes_write(chip, reg, val);
+	else if (kstrtouint(name, 10, &port) == 0 && port < mv88e6xxx_num_ports(chip))
+		ret = mv88e6xxx_port_write(chip, port, reg, val);
+	else
+		ret = -EINVAL;
+
+	mutex_unlock(&chip->reg_lock);
+
+	return ret < 0 ? ret : count;
+}
+
+static int mv88e6xxx_regs_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, mv88e6xxx_regs_show, inode->i_private);
+}
+
+static const struct file_operations mv88e6xxx_regs_fops = {
+	.open   = mv88e6xxx_regs_open,
+	.read   = seq_read,
+	.write  = mv88e6xxx_regs_write,
+	.llseek = no_llseek,
+	.release = single_release,
+	.owner  = THIS_MODULE,
+};
+
+static int mv88e6xxx_name_show(struct seq_file *s, void *p)
+{
+	struct mv88e6xxx_chip *chip = s->private;
+	struct dsa_switch *ds = chip->ds;
+	struct dsa_switch_tree *dst = ds->dst;
+	struct dsa_port *dp;
+	int i;
+
+	if (!ds->cd)
+		return 0;
+
+	seq_puts(s, " Port  Name\n");
+
+	list_for_each_entry(dp, &dst->ports, list) {
+		if (dp->ds != ds)
+			continue;
+
+		i = dp->index;
+		if (!ds->cd->port_names[i])
+			continue;
+
+		seq_printf(s, "%4d   %s", i, ds->cd->port_names[i]);
+
+		if (dp->slave)
+			seq_printf(s, " (%s)", netdev_name(dp->slave));
+
+		seq_puts(s, "\n");
+	}
+
+	return 0;
+}
+
+static int mv88e6xxx_name_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, mv88e6xxx_name_show, inode->i_private);
+}
+
+static const struct file_operations mv88e6xxx_name_fops = {
+	.open		= mv88e6xxx_name_open,
+	.read		= seq_read,
+	.llseek		= no_llseek,
+	.release	= single_release,
+	.owner		= THIS_MODULE,
+};
+
+static int mv88e6xxx_atu_show(struct seq_file *s, void *p)
+{
+	struct mv88e6xxx_chip *chip = s->private;
+	struct mv88e6xxx_atu_entry addr;
+	const char *state;
+	int fid, i, err;
+
+	seq_puts(s, " FID  MAC Addr                  State         Trunk?  DPV/Trunk ID\n");
+
+	for (fid = 0; fid < mv88e6xxx_num_databases(chip); ++fid) {
+		addr.state = 0;
+		eth_broadcast_addr(addr.mac);
+
+		do {
+			mutex_lock(&chip->reg_lock);
+			err = mv88e6xxx_g1_atu_getnext(chip, fid, &addr);
+			mutex_unlock(&chip->reg_lock);
+			if (err)
+				return err;
+
+			if (addr.state == 0)
+				break;
+
+			/* print ATU entry */
+			seq_printf(s, "%4d  %pM", fid, addr.mac);
+
+			if (is_multicast_ether_addr(addr.mac)) {
+				switch (addr.state) {
+				case MV88E6XXX_G1_ATU_DATA_STATE_MC_STATIC_PO:
+					state = "MC_STATIC_PO";
+					break;
+				case MV88E6XXX_G1_ATU_DATA_STATE_MC_STATIC_DA_MGMT_PO:
+					state = "MC_STATIC_MGMT_PO";
+					break;
+				case MV88E6XXX_G1_ATU_DATA_STATE_MC_STATIC_AVB_NRL_PO:
+					state = "MC_STATIC_NRL_PO";
+					break;
+				case MV88E6XXX_G1_ATU_DATA_STATE_MC_STATIC_POLICY_PO:
+					state = "MC_STATIC_POLICY_PO";
+					break;
+				case MV88E6XXX_G1_ATU_DATA_STATE_MC_STATIC:
+					state = "MC_STATIC";
+					break;
+				case MV88E6XXX_G1_ATU_DATA_STATE_MC_STATIC_DA_MGMT:
+					state = "MC_STATIC_MGMT";
+					break;
+				case MV88E6XXX_G1_ATU_DATA_STATE_MC_STATIC_AVB_NRL:
+					state = "MC_STATIC_NRL";
+					break;
+				case MV88E6XXX_G1_ATU_DATA_STATE_MC_STATIC_POLICY:
+					state = "MC_STATIC_POLICY";
+					break;
+				case 0xb: case 0xa: case 0x9: case 0x8:
+					/* Reserved for future use */
+				case 0x3: case 0x2: case 0x1:
+					/* Reserved for future use */
+				case MV88E6XXX_G1_ATU_DATA_STATE_MC_UNUSED:
+				default:
+					state = "???";
+					break;
+				}
+			} else {
+				switch (addr.state) {
+				case MV88E6XXX_G1_ATU_DATA_STATE_UC_STATIC_PO:
+					state = "UC_STATIC_PO";
+					break;
+				case MV88E6XXX_G1_ATU_DATA_STATE_UC_STATIC:
+					state = "UC_STATIC";
+					break;
+				case MV88E6XXX_G1_ATU_DATA_STATE_UC_STATIC_DA_MGMT_PO:
+					state = "UC_STATIC_MGMT_PO";
+					break;
+				case MV88E6XXX_G1_ATU_DATA_STATE_UC_STATIC_DA_MGMT:
+					state = "UC_STATIC_MGMT";
+					break;
+				case MV88E6XXX_G1_ATU_DATA_STATE_UC_STATIC_AVB_NRL_PO:
+					state = "UC_STATIC_NRL_PO";
+					break;
+				case MV88E6XXX_G1_ATU_DATA_STATE_UC_STATIC_AVB_NRL:
+					state = "UC_STATIC_NRL";
+					break;
+				case MV88E6XXX_G1_ATU_DATA_STATE_UC_STATIC_POLICY_PO:
+					state = "UC_STATIC_POLICY_PO";
+					break;
+				case MV88E6XXX_G1_ATU_DATA_STATE_UC_STATIC_POLICY:
+					state = "UC_STATIC_POLICY";
+					break;
+				case MV88E6XXX_G1_ATU_DATA_STATE_UC_AGE_7_NEWEST:
+					state = "Age 7 (newest)";
+					break;
+				case MV88E6XXX_G1_ATU_DATA_STATE_UC_AGE_6:
+					state = "Age 6";
+					break;
+				case MV88E6XXX_G1_ATU_DATA_STATE_UC_AGE_5:
+					state = "Age 5";
+					break;
+				case MV88E6XXX_G1_ATU_DATA_STATE_UC_AGE_4:
+					state = "Age 4";
+					break;
+				case MV88E6XXX_G1_ATU_DATA_STATE_UC_AGE_3:
+					state = "Age 3";
+					break;
+				case MV88E6XXX_G1_ATU_DATA_STATE_UC_AGE_2:
+					state = "Age 2";
+					break;
+				case MV88E6XXX_G1_ATU_DATA_STATE_UC_AGE_1_OLDEST:
+					state = "Age 1 (oldest)";
+					break;
+				case MV88E6XXX_G1_ATU_DATA_STATE_UC_UNUSED:
+				default:
+					state = "???";
+					break;
+				}
+			}
+
+			seq_printf(s, "  %19s", state);
+
+			if (addr.trunk) {
+				seq_printf(s, "       y  %d",
+					   addr.portvec);
+			} else {
+				seq_puts(s, "       n ");
+				for (i = 0; i < mv88e6xxx_num_ports(chip); ++i)
+					seq_printf(s, " %c",
+						   addr.portvec & BIT(i) ?
+						   48 + i : '-');
+			}
+
+			seq_puts(s, "\n");
+		} while (!is_broadcast_ether_addr(addr.mac));
+	}
+
+	return 0;
+}
+
+static ssize_t mv88e6xxx_atu_write(struct file *file, const char __user *buf,
+				   size_t count, loff_t *ppos)
+{
+	struct seq_file *s = file->private_data;
+	struct mv88e6xxx_chip *chip = s->private;
+	char cmd[64];
+	unsigned int fid;
+	int ret;
+
+	if (copy_from_user(cmd, buf, sizeof(cmd)))
+		return -EFAULT;
+
+	ret = sscanf(cmd, "%u", &fid);
+	if (ret != 1)
+		return -EINVAL;
+
+	if (fid >= mv88e6xxx_num_databases(chip))
+		return -ERANGE;
+
+	mutex_lock(&chip->reg_lock);
+	ret = mv88e6xxx_g1_atu_flush(chip, fid, true);
+	mutex_unlock(&chip->reg_lock);
+
+	return ret < 0 ? ret : count;
+}
+
+static int mv88e6xxx_atu_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, mv88e6xxx_atu_show, inode->i_private);
+}
+
+static const struct file_operations mv88e6xxx_atu_fops = {
+	.open   = mv88e6xxx_atu_open,
+	.read   = seq_read,
+	.write   = mv88e6xxx_atu_write,
+	.llseek = no_llseek,
+	.release = single_release,
+	.owner  = THIS_MODULE,
+};
+
+static int mv88e6xxx_default_vid_show(struct seq_file *s, void *p)
+{
+	struct mv88e6xxx_chip *chip = s->private;
+	u16 pvid;
+	int i, err;
+
+	seq_puts(s, " Port  DefaultVID\n");
+
+	mutex_lock(&chip->reg_lock);
+
+	for (i = 0; i < mv88e6xxx_num_ports(chip); ++i) {
+		err = mv88e6xxx_port_get_pvid(chip, i, &pvid);
+		if (err)
+			break;
+
+		seq_printf(s, "%4d  %d\n", i, pvid);
+	}
+
+	mutex_unlock(&chip->reg_lock);
+
+	return err;
+}
+
+static ssize_t mv88e6xxx_default_vid_write(struct file *file,
+					   const char __user *buf, size_t count,
+					   loff_t *ppos)
+{
+	struct seq_file *s = file->private_data;
+	struct mv88e6xxx_chip *chip = s->private;
+	char cmd[32];
+	unsigned int port, pvid;
+	int ret;
+
+	if (copy_from_user(cmd, buf, sizeof(cmd)))
+		return -EFAULT;
+
+	ret = sscanf(cmd, "%u %u", &port, &pvid);
+	if (ret != 2)
+		return -EINVAL;
+
+	if (port >= mv88e6xxx_num_ports(chip) || pvid > 0xfff)
+		return -ERANGE;
+
+	mutex_lock(&chip->reg_lock);
+	ret = mv88e6xxx_port_set_pvid(chip, port, pvid);
+	mutex_unlock(&chip->reg_lock);
+
+	return ret < 0 ? ret : count;
+}
+
+static int mv88e6xxx_default_vid_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, mv88e6xxx_default_vid_show, inode->i_private);
+}
+
+static const struct file_operations mv88e6xxx_default_vid_fops = {
+	.open		= mv88e6xxx_default_vid_open,
+	.read		= seq_read,
+	.write		= mv88e6xxx_default_vid_write,
+	.llseek		= no_llseek,
+	.release	= single_release,
+	.owner		= THIS_MODULE,
+};
+
+static int mv88e6xxx_fid_show(struct seq_file *s, void *p)
+{
+	struct mv88e6xxx_chip *chip = s->private;
+	u16 fid;
+	int i, err;
+
+	seq_puts(s, " Port  FID\n");
+
+	mutex_lock(&chip->reg_lock);
+
+	for (i = 0; i < mv88e6xxx_num_ports(chip); ++i) {
+		err = mv88e6xxx_port_get_fid(chip, i, &fid);
+		if (err)
+			break;
+
+		seq_printf(s, "%4d  %d\n", i, fid);
+	}
+
+	mutex_unlock(&chip->reg_lock);
+
+	return err;
+}
+
+static int mv88e6xxx_fid_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, mv88e6xxx_fid_show, inode->i_private);
+}
+
+static const struct file_operations mv88e6xxx_fid_fops = {
+	.open		= mv88e6xxx_fid_open,
+	.read		= seq_read,
+	.llseek		= no_llseek,
+	.release	= single_release,
+	.owner		= THIS_MODULE,
+};
+
+static const char * const mv88e6xxx_port_state_names[] = {
+	[MV88E6XXX_PORT_CTL0_STATE_DISABLED] = "Disabled",
+	[MV88E6XXX_PORT_CTL0_STATE_BLOCKING] = "Blocking/Listening",
+	[MV88E6XXX_PORT_CTL0_STATE_LEARNING] = "Learning",
+	[MV88E6XXX_PORT_CTL0_STATE_FORWARDING] = "Forwarding",
+};
+
+static int mv88e6xxx_state_show(struct seq_file *s, void *p)
+{
+	struct mv88e6xxx_chip *chip = s->private;
+	int i, ret;
+	u16 data;
+
+	/* header */
+	seq_puts(s, " Port  Mode\n");
+
+	mutex_lock(&chip->reg_lock);
+
+	/* One line per input port */
+	for (i = 0; i < mv88e6xxx_num_ports(chip); ++i) {
+		seq_printf(s, "%4d ", i);
+
+		ret = mv88e6xxx_port_read(chip, i, MV88E6XXX_PORT_CTL0, &data);
+		if (ret < 0)
+			goto unlock;
+
+		data &= MV88E6XXX_PORT_CTL0_STATE_MASK;
+		seq_printf(s, " %s\n", mv88e6xxx_port_state_names[data]);
+		ret = 0;
+	}
+
+unlock:
+	mutex_unlock(&chip->reg_lock);
+
+	return ret;
+}
+
+static int mv88e6xxx_state_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, mv88e6xxx_state_show, inode->i_private);
+}
+
+static const struct file_operations mv88e6xxx_state_fops = {
+	.open		= mv88e6xxx_state_open,
+	.read		= seq_read,
+	.llseek		= no_llseek,
+	.release	= single_release,
+	.owner		= THIS_MODULE,
+};
+
+static const char * const mv88e6xxx_port_8021q_mode_names[] = {
+	[MV88E6XXX_PORT_CTL2_8021Q_MODE_DISABLED] = "Disabled",
+	[MV88E6XXX_PORT_CTL2_8021Q_MODE_FALLBACK] = "Fallback",
+	[MV88E6XXX_PORT_CTL2_8021Q_MODE_CHECK] = "Check",
+	[MV88E6XXX_PORT_CTL2_8021Q_MODE_SECURE] = "Secure",
+};
+
+static int mv88e6xxx_8021q_mode_show(struct seq_file *s, void *p)
+{
+	struct mv88e6xxx_chip *chip = s->private;
+	int i, ret;
+	u16 data;
+
+	/* header */
+	seq_puts(s, " Port  Mode\n");
+
+	mutex_lock(&chip->reg_lock);
+
+	/* One line per input port */
+	for (i = 0; i < mv88e6xxx_num_ports(chip); ++i) {
+		seq_printf(s, "%4d ", i);
+
+		ret = mv88e6xxx_port_read(chip, i, MV88E6XXX_PORT_CTL2, &data);
+		if (ret < 0)
+			goto unlock;
+
+		data &= MV88E6XXX_PORT_CTL2_8021Q_MODE_MASK;
+		seq_printf(s, " %s\n", mv88e6xxx_port_8021q_mode_names[data]);
+		ret = 0;
+	}
+
+unlock:
+	mutex_unlock(&chip->reg_lock);
+
+	return ret;
+}
+
+static int mv88e6xxx_8021q_mode_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, mv88e6xxx_8021q_mode_show, inode->i_private);
+}
+
+static const struct file_operations mv88e6xxx_8021q_mode_fops = {
+	.open		= mv88e6xxx_8021q_mode_open,
+	.read		= seq_read,
+	.llseek		= no_llseek,
+	.release	= single_release,
+	.owner		= THIS_MODULE,
+};
+
+static int mv88e6xxx_vlan_table_show(struct seq_file *s, void *p)
+{
+	struct mv88e6xxx_chip *chip = s->private;
+	int i, j, ret;
+	u16 data;
+
+	/* header */
+	seq_puts(s, " Port");
+	for (i = 0; i < mv88e6xxx_num_ports(chip); ++i)
+		seq_printf(s, " %2d", i);
+	seq_puts(s, "\n");
+
+	mutex_lock(&chip->reg_lock);
+
+	/* One line per input port */
+	for (i = 0; i < mv88e6xxx_num_ports(chip); ++i) {
+		seq_printf(s, "%4d ", i);
+
+		ret = mv88e6xxx_port_read(chip, i, MV88E6XXX_PORT_BASE_VLAN, &data);
+		if (ret < 0)
+			goto unlock;
+
+		/* One column per output port */
+		for (j = 0; j < mv88e6xxx_num_ports(chip); ++j)
+			seq_printf(s, "  %c", data & BIT(j) ? '*' : '-');
+		seq_puts(s, "\n");
+	}
+
+	ret = 0;
+unlock:
+	mutex_unlock(&chip->reg_lock);
+
+	return ret;
+}
+
+static int mv88e6xxx_vlan_table_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, mv88e6xxx_vlan_table_show, inode->i_private);
+}
+
+static const struct file_operations mv88e6xxx_vlan_table_fops = {
+	.open		= mv88e6xxx_vlan_table_open,
+	.read		= seq_read,
+	.llseek		= no_llseek,
+	.release	= single_release,
+	.owner		= THIS_MODULE,
+};
+
+static int mv88e6xxx_pvt_show(struct seq_file *s, void *p)
+{
+#if 0
+	struct mv88e6xxx_chip *chip = s->private;
+	struct dsa_switch_tree *dst = chip->ds->dst;
+	int port, src_dev, src_port;
+	u16 pvlan;
+	int err = 0;
+
+	if (chip->info->family == MV88E6XXX_FAMILY_6185)
+		return -ENODEV;
+
+	/* header */
+	seq_puts(s, " Dev Port PVLAN");
+	for (port = 0; port < mv88e6xxx_num_ports(chip); ++port)
+		seq_printf(s, " %2d", port);
+	seq_puts(s, "\n");
+
+	mutex_lock(&chip->reg_lock);
+
+	/* One line per external port */
+	for (src_dev = 0; src_dev < DSA_MAX_SWITCHES; ++src_dev) {
+		if (!dst->ds[src_dev])
+			break;
+
+		if (src_dev == chip->ds->index)
+			continue;
+
+		seq_puts(s, "\n");
+		for (src_port = 0; src_port < 16; ++src_port) {
+			if (src_port >= DSA_MAX_PORTS)
+				break;
+
+			err = _mv88e6xxx_pvt_read(chip, src_dev, src_port,
+						  &pvlan);
+			if (err)
+				goto unlock;
+
+			seq_printf(s, "  %d   %2d   %03hhx ", src_dev, src_port,
+				   pvlan);
+
+			/* One column per internal output port */
+			for (port = 0; port < mv88e6xxx_num_ports(chip); ++port)
+				seq_printf(s, "  %c",
+					   pvlan & BIT(port) ? '*' : '-');
+			seq_puts(s, "\n");
+		}
+	}
+
+unlock:
+	mutex_unlock(&chip->reg_lock);
+	return err;
+#else
+	return 0;
+#endif
+}
+
+static ssize_t mv88e6xxx_pvt_write(struct file *file, const char __user *buf,
+				    size_t count, loff_t *ppos)
+{
+	struct seq_file *s = file->private_data;
+	struct mv88e6xxx_chip *chip = s->private;
+	const u16 mask = (1 << mv88e6xxx_num_ports(chip)) - 1;
+	char cmd[32];
+	unsigned int src_dev, src_port, pvlan;
+	int ret;
+
+	if (copy_from_user(cmd, buf, sizeof(cmd)))
+		return -EFAULT;
+
+	if (sscanf(cmd, "%d %d %x", &src_dev, &src_port, &pvlan) != 3)
+		return -EINVAL;
+
+	if (src_dev >= 32 || src_port >= 16 || pvlan & ~mask)
+		return -ERANGE;
+
+	mutex_lock(&chip->reg_lock);
+	ret = _mv88e6xxx_pvt_write(chip, src_dev, src_port, pvlan);
+	mutex_unlock(&chip->reg_lock);
+
+	return ret < 0 ? ret : count;
+}
+
+static int mv88e6xxx_pvt_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, mv88e6xxx_pvt_show, inode->i_private);
+}
+
+static const struct file_operations mv88e6xxx_pvt_fops = {
+	.open		= mv88e6xxx_pvt_open,
+	.read		= seq_read,
+	.write		= mv88e6xxx_pvt_write,
+	.llseek		= no_llseek,
+	.release	= single_release,
+	.owner		= THIS_MODULE,
+};
+
+static int mv88e6xxx_vtu_show(struct seq_file *s, void *p)
+{
+	struct mv88e6xxx_chip *chip = s->private;
+	struct mv88e6xxx_vtu_entry next = { 0 };
+	int port, ret = 0;
+
+	seq_puts(s, " VID  FID  SID");
+	for (port = 0; port < mv88e6xxx_num_ports(chip); ++port)
+		seq_printf(s, " %2d", port);
+	seq_puts(s, "\n");
+
+	if (!chip->info->ops->vtu_getnext)
+		return 0;
+
+	next.vid = chip->info->max_vid; /* first or lowest VID */
+
+	do {
+		mutex_lock(&chip->reg_lock);
+		ret = chip->info->ops->vtu_getnext(chip, &next);
+		mutex_unlock(&chip->reg_lock);
+		if (ret < 0)
+			break;
+
+		if (!next.valid)
+			break;
+
+		seq_printf(s, "%4d %4d   %2d", next.vid, next.fid, next.sid);
+		for (port = 0; port < mv88e6xxx_num_ports(chip); ++port) {
+			switch (next.member[port]) {
+			case MV88E6XXX_G1_VTU_DATA_MEMBER_TAG_UNMODIFIED:
+				seq_puts(s, "  =");
+				break;
+			case MV88E6XXX_G1_VTU_DATA_MEMBER_TAG_UNTAGGED:
+				seq_puts(s, "  u");
+				break;
+			case MV88E6XXX_G1_VTU_DATA_MEMBER_TAG_TAGGED:
+				seq_puts(s, "  t");
+				break;
+			case MV88E6XXX_G1_VTU_DATA_MEMBER_TAG_NON_MEMBER:
+				seq_puts(s, "  x");
+				break;
+			default:
+				seq_puts(s, " ??");
+				break;
+			}
+		}
+		seq_puts(s, "\n");
+	} while (next.vid < chip->info->max_vid);
+
+	return ret;
+}
+
+static ssize_t mv88e6xxx_vtu_write(struct file *file, const char __user *buf,
+				   size_t count, loff_t *ppos)
+{
+	struct seq_file *s = file->private_data;
+	struct mv88e6xxx_chip *chip = s->private;
+	struct mv88e6xxx_vtu_entry entry = { 0 };
+	bool valid = true;
+	char cmd[64], tags[12]; /* DSA_MAX_PORTS */
+	int vid, fid, sid, port, ret;
+
+	if (!chip->info->ops->vtu_loadpurge)
+		return -EOPNOTSUPP;
+
+	if (copy_from_user(cmd, buf, sizeof(cmd)))
+		return -EFAULT;
+
+	/* scan 12 chars instead of num_ports to avoid dynamic scanning... */
+	ret = sscanf(cmd, "%d %d %d %c %c %c %c %c %c %c %c %c %c %c %c", &vid,
+		     &fid, &sid, &tags[0], &tags[1], &tags[2], &tags[3],
+		     &tags[4], &tags[5], &tags[6], &tags[7], &tags[8], &tags[9],
+		     &tags[10], &tags[11]);
+	if (ret == 1)
+		valid = false;
+	else if (ret != 3 + mv88e6xxx_num_ports(chip))
+		return -EINVAL;
+
+	entry.vid = vid;
+	entry.valid = valid;
+
+	if (valid) {
+		entry.fid = fid;
+		entry.sid = sid;
+		/* Note: The VTU entry pointed by VID will be loaded but not
+		 * considered valid until the STU entry pointed by SID is valid.
+		 */
+
+		for (port = 0; port < mv88e6xxx_num_ports(chip); ++port) {
+			u8 tag;
+
+			switch (tags[port]) {
+			case 'u':
+				tag = MV88E6XXX_G1_VTU_DATA_MEMBER_TAG_UNTAGGED;
+				break;
+			case 't':
+				tag = MV88E6XXX_G1_VTU_DATA_MEMBER_TAG_TAGGED;
+				break;
+			case 'x':
+				tag = MV88E6XXX_G1_VTU_DATA_MEMBER_TAG_NON_MEMBER;
+				break;
+			case '=':
+				tag = MV88E6XXX_G1_VTU_DATA_MEMBER_TAG_UNMODIFIED;
+				break;
+			default:
+				return -EINVAL;
+			}
+
+			entry.member[port] = tag;
+		}
+	}
+
+	mutex_lock(&chip->reg_lock);
+	ret = chip->info->ops->vtu_loadpurge(chip, &entry);
+	mutex_unlock(&chip->reg_lock);
+
+	return ret < 0 ? ret : count;
+}
+
+static int mv88e6xxx_vtu_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, mv88e6xxx_vtu_show, inode->i_private);
+}
+
+static const struct file_operations mv88e6xxx_vtu_fops = {
+	.open		= mv88e6xxx_vtu_open,
+	.read		= seq_read,
+	.write		= mv88e6xxx_vtu_write,
+	.llseek		= no_llseek,
+	.release	= single_release,
+	.owner		= THIS_MODULE,
+};
+#if 0
+static int mv88e6xxx_stats_show(struct seq_file *s, void *p)
+{
+	struct mv88e6xxx_chip *chip = s->private;
+	char *strs;
+	u64 *stats;
+	int stat, port, num_stats, num_ports;
+	int err = 0;
+
+	num_stats = mv88e6xxx_get_sset_count(chip->ds);
+	if (num_stats == 0)
+		return 0;
+
+	num_ports = mv88e6xxx_num_ports(chip);
+
+	strs = kcalloc(num_stats, ETH_GSTRING_LEN, GFP_KERNEL);
+	stats = kcalloc(num_stats, num_ports * sizeof(*stats), GFP_KERNEL);
+	if (!strs || !strs) {
+		kfree(strs);
+		kfree(stats);
+		return -ENOMEM;
+	}
+
+	mv88e6xxx_get_strings(chip->ds, 0, strs);
+
+	for (port = 0; port < num_ports; port++)
+		mv88e6xxx_get_ethtool_stats(chip->ds, port, stats + (port * num_stats));
+
+	seq_puts(s, "          Statistic  ");
+	for (port = 0; port < mv88e6xxx_num_ports(chip); port++)
+		seq_printf(s, " Port %2d ", port);
+	seq_puts(s, "\n");
+
+	for (stat = 0; stat < num_stats; stat++) {
+		seq_printf(s, "%19s: ", strs + stat * ETH_GSTRING_LEN);
+		for (port = 0 ; port < num_ports; port++) {
+			u64 value = stats[stat + port * num_stats];
+
+			seq_printf(s, "%8llu ", value);
+		}
+		seq_puts(s, "\n");
+	}
+
+	kfree(stats);
+	kfree(strs);
+
+	return err;
+}
+
+static int mv88e6xxx_stats_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, mv88e6xxx_stats_show, inode->i_private);
+}
+
+static const struct file_operations mv88e6xxx_stats_fops = {
+	.open   = mv88e6xxx_stats_open,
+	.read   = seq_read,
+	.llseek = no_llseek,
+	.release = single_release,
+	.owner  = THIS_MODULE,
+};
+#endif
+static int mv88e6xxx_device_map_show(struct seq_file *s, void *p)
+{
+	struct mv88e6xxx_chip *chip = s->private;
+	int target, ret;
+	u16 data, port_mask;
+
+	seq_puts(s, "Target Port\n");
+
+	/* FIXME */
+	port_mask = MV88E6390_G2_DEVICE_MAPPING_PORT_MASK;
+
+	mutex_lock(&chip->reg_lock);
+	for (target = 0; target < 32; target++) {
+		ret = mv88e6xxx_g2_write(chip, MV88E6XXX_G2_DEVICE_MAPPING,
+			target << 8 /* MV88E6XXX_G2_DEVICE_MAPPING_DEV_MASK */);
+		if (ret < 0)
+			goto out;
+		ret = mv88e6xxx_g2_read(chip, MV88E6XXX_G2_DEVICE_MAPPING, &data);
+		if (ret < 0)
+			goto out;
+		seq_printf(s, "  %2d   %2d\n", target, data & port_mask);
+	}
+out:
+	mutex_unlock(&chip->reg_lock);
+
+	return 0;
+}
+
+static int mv88e6xxx_device_map_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, mv88e6xxx_device_map_show, inode->i_private);
+}
+
+static const struct file_operations mv88e6xxx_device_map_fops = {
+	.open   = mv88e6xxx_device_map_open,
+	.read   = seq_read,
+	.llseek = no_llseek,
+	.release = single_release,
+	.owner  = THIS_MODULE,
+};
+
+/* Must be called with SMI lock held */
+static int _mv88e6xxx_scratch_wait(struct mv88e6xxx_chip *chip)
+{
+	return mv88e6xxx_wait_mask(chip, ADDR_GLOBAL2,
+				   MV88E6XXX_G2_SCRATCH_MISC_MISC,
+			           MV88E6XXX_G2_SCRATCH_MISC_UPDATE, 0);
+}
+
+static int mv88e6xxx_scratch_show(struct seq_file *s, void *p)
+{
+	struct mv88e6xxx_chip *chip = s->private;
+	int reg, ret;
+	u16 data;
+
+	seq_puts(s, "Register Value\n");
+
+	mutex_lock(&chip->reg_lock);
+	for (reg = 0; reg < 0x80; reg++) {
+		ret = mv88e6xxx_g2_write(chip, MV88E6XXX_G2_SCRATCH_MISC_MISC,
+			reg << 8 /* MV88E6XXX_G2_SCRATCH_MISC_PTR_MASK */);
+		if (ret < 0)
+			goto out;
+
+		ret = _mv88e6xxx_scratch_wait(chip);
+		if (ret < 0)
+			goto out;
+
+		ret = mv88e6xxx_g2_read(chip, MV88E6XXX_G2_SCRATCH_MISC_MISC, &data);
+		seq_printf(s, "  %2x   %2x\n", reg,
+			   data & MV88E6XXX_G2_SCRATCH_MISC_DATA_MASK);
+	}
+out:
+	mutex_unlock(&chip->reg_lock);
+
+	return 0;
+}
+
+static int mv88e6xxx_scratch_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, mv88e6xxx_scratch_show, inode->i_private);
+}
+
+static const struct file_operations mv88e6xxx_scratch_fops = {
+	.open   = mv88e6xxx_scratch_open,
+	.read   = seq_read,
+	.llseek = no_llseek,
+	.release = single_release,
+	.owner  = THIS_MODULE,
+};
+
+static void mv88e6xxx_init_debugfs(struct mv88e6xxx_chip *chip)
+{
+	char *name;
+
+	name = kasprintf(GFP_KERNEL, "mv88e6xxx.%d", chip->ds->index);
+	chip->dbgfs = debugfs_create_dir(name, NULL);
+
+	kfree(name);
+
+	debugfs_create_file("regs", S_IRUGO | S_IWUSR, chip->dbgfs, chip,
+			    &mv88e6xxx_regs_fops);
+
+	debugfs_create_file("name", S_IRUGO, chip->dbgfs, chip,
+			    &mv88e6xxx_name_fops);
+
+	debugfs_create_file("atu", S_IRUGO | S_IWUSR, chip->dbgfs, chip,
+			    &mv88e6xxx_atu_fops);
+
+	debugfs_create_file("default_vid", S_IRUGO | S_IWUSR, chip->dbgfs, chip,
+			    &mv88e6xxx_default_vid_fops);
+
+	debugfs_create_file("fid", S_IRUGO, chip->dbgfs, chip, &mv88e6xxx_fid_fops);
+
+	debugfs_create_file("state", S_IRUGO, chip->dbgfs, chip,
+			    &mv88e6xxx_state_fops);
+
+	debugfs_create_file("8021q_mode", S_IRUGO, chip->dbgfs, chip,
+			    &mv88e6xxx_8021q_mode_fops);
+
+	debugfs_create_file("vlan_table", S_IRUGO, chip->dbgfs, chip,
+			    &mv88e6xxx_vlan_table_fops);
+
+	debugfs_create_file("pvt", S_IRUGO | S_IWUSR, chip->dbgfs, chip,
+			    &mv88e6xxx_pvt_fops);
+
+	debugfs_create_file("vtu", S_IRUGO | S_IWUSR, chip->dbgfs, chip,
+			    &mv88e6xxx_vtu_fops);
+#if 0
+	debugfs_create_file("stats", S_IRUGO, chip->dbgfs, chip,
+			    &mv88e6xxx_stats_fops);
+#endif
+	debugfs_create_file("device_map", S_IRUGO, chip->dbgfs, chip,
+			    &mv88e6xxx_device_map_fops);
+
+	debugfs_create_file("scratch", S_IRUGO, chip->dbgfs, chip,
+			    &mv88e6xxx_scratch_fops);
+}
+
+static void mv88e6xxx_remove_debugfs(struct mv88e6xxx_chip *chip)
+{
+	debugfs_remove_recursive(chip->dbgfs);
+}
-- 
2.20.1


-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
