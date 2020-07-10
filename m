Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E239321BA8A
	for <lists+netdev@lfdr.de>; Fri, 10 Jul 2020 18:16:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728276AbgGJQOX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jul 2020 12:14:23 -0400
Received: from pbmsgap02.intersil.com ([192.157.179.202]:47036 "EHLO
        pbmsgap02.intersil.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727943AbgGJQOX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jul 2020 12:14:23 -0400
X-Greylist: delayed 1944 seconds by postgrey-1.27 at vger.kernel.org; Fri, 10 Jul 2020 12:14:21 EDT
Received: from pps.filterd (pbmsgap02.intersil.com [127.0.0.1])
        by pbmsgap02.intersil.com (8.16.0.27/8.16.0.27) with SMTP id 06AFYSj6031844;
        Fri, 10 Jul 2020 11:41:55 -0400
Received: from pbmxdp01.intersil.corp (pbmxdp01.pb.intersil.com [132.158.200.222])
        by pbmsgap02.intersil.com with ESMTP id 325k328snd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Fri, 10 Jul 2020 11:41:55 -0400
Received: from pbmxdp03.intersil.corp (132.158.200.224) by
 pbmxdp01.intersil.corp (132.158.200.222) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384) id
 15.1.1979.3; Fri, 10 Jul 2020 11:41:54 -0400
Received: from localhost (132.158.202.109) by pbmxdp03.intersil.corp
 (132.158.200.224) with Microsoft SMTP Server id 15.1.1979.3 via Frontend
 Transport; Fri, 10 Jul 2020 11:41:53 -0400
From:   <min.li.xe@renesas.com>
To:     <richardcochran@gmail.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Min Li <min.li.xe@renesas.com>
Subject: [PATCH net-next] ptp: add debugfs support for IDT family of timing devices
Date:   Fri, 10 Jul 2020 11:41:25 -0400
Message-ID: <1594395685-25199-1-git-send-email-min.li.xe@renesas.com>
X-Mailer: git-send-email 2.7.4
X-TM-AS-MML: disable
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-10_10:2020-07-10,2020-07-10 signatures=0
X-Proofpoint-Spam-Details: rule=junk_notspam policy=junk score=0 suspectscore=4 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-2006250000 definitions=main-2007100106
X-Proofpoint-Spam-Reason: mlx
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Min Li <min.li.xe@renesas.com>

This patch is to add debugfs support for ptp_clockmatrix and ptp_idt82p33.
It will create a debugfs directory called idtptp{x} and x is the ptp index.
Three inerfaces are present, which are cmd, help and regs. help is read
only and will display a brief help message. regs is read only amd will show
all register values. cmd is write only and will accept certain commands.
Currently, the accepted commands are combomode to set comobo mode and write
to write up to 4 registers.

Signed-off-by: Min Li <min.li.xe@renesas.com>
---
 drivers/ptp/Kconfig           |   2 +
 drivers/ptp/Makefile          |   4 +-
 drivers/ptp/ptp_idt_debugfs.c | 354 ++++++++++++++++++++++++++++++++++++++++++
 drivers/ptp/ptp_idt_debugfs.h |  83 ++++++++++
 4 files changed, 442 insertions(+), 1 deletion(-)
 create mode 100644 drivers/ptp/ptp_idt_debugfs.c
 create mode 100644 drivers/ptp/ptp_idt_debugfs.h

diff --git a/drivers/ptp/Kconfig b/drivers/ptp/Kconfig
index 942f72d..25b74a2 100644
--- a/drivers/ptp/Kconfig
+++ b/drivers/ptp/Kconfig
@@ -118,6 +118,7 @@ config PTP_1588_CLOCK_KVM
 config PTP_1588_CLOCK_IDT82P33
 	tristate "IDT 82P33xxx PTP clock"
 	depends on PTP_1588_CLOCK && I2C
+	select DEBUG_FS
 	default n
 	help
 	  This driver adds support for using the IDT 82P33xxx as a PTP
@@ -130,6 +131,7 @@ config PTP_1588_CLOCK_IDT82P33
 config PTP_1588_CLOCK_IDTCM
 	tristate "IDT CLOCKMATRIX as PTP clock"
 	depends on PTP_1588_CLOCK && I2C
+	select DEBUG_FS
 	default n
 	help
 	  This driver adds support for using IDT CLOCKMATRIX(TM) as a PTP
diff --git a/drivers/ptp/Makefile b/drivers/ptp/Makefile
index 7aff75f..a4a9e35 100644
--- a/drivers/ptp/Makefile
+++ b/drivers/ptp/Makefile
@@ -12,6 +12,8 @@ obj-$(CONFIG_PTP_1588_CLOCK_KVM)	+= ptp_kvm.o
 obj-$(CONFIG_PTP_1588_CLOCK_QORIQ)	+= ptp-qoriq.o
 ptp-qoriq-y				+= ptp_qoriq.o
 ptp-qoriq-$(CONFIG_DEBUG_FS)		+= ptp_qoriq_debugfs.o
-obj-$(CONFIG_PTP_1588_CLOCK_IDTCM)	+= ptp_clockmatrix.o
+obj-$(CONFIG_PTP_1588_CLOCK_IDTCM)	+= ptp_idtcm.o
 obj-$(CONFIG_PTP_1588_CLOCK_IDT82P33)	+= ptp_idt82p33.o
 obj-$(CONFIG_PTP_1588_CLOCK_VMW)	+= ptp_vmw.o
+
+ptp_idtcm-objs += ptp_clockmatrix.o ptp_idt_debugfs.o
diff --git a/drivers/ptp/ptp_idt_debugfs.c b/drivers/ptp/ptp_idt_debugfs.c
new file mode 100644
index 0000000..0ae02f7
--- /dev/null
+++ b/drivers/ptp/ptp_idt_debugfs.c
@@ -0,0 +1,354 @@
+// SPDX-License-Identifier: GPL-2.0+
+/*
+ * PTP debugfs interface for the IDT family of timing and
+ * synchronization devices.
+ *
+ * Copyright (C) 2019 Integrated Device Technology, Inc., a Renesas Company.
+ */
+#include <linux/debugfs.h>
+#include <linux/module.h>
+#include <linux/seq_file.h>
+#include <linux/slab.h>
+#include <linux/uaccess.h>
+
+#include "ptp_idt_debugfs.h"
+
+MODULE_LICENSE("GPL");
+
+#define DEBUGFS_CMD_MAX_WRITE_SIZE (4)
+#define DEBUGFS_CMD_MENU_SIZE (4)
+#define DEBUGFS_CMD_MAX_SIZE (64)
+#define DEBUGFS_CMD_HELP \
+	"1) set combomode:\n" \
+	"echo -n \"combomode:mode[current/fast/slow/hold]\" > cmd\n" \
+	"2) write up to 4 registers:\n" \
+	"echo -n \"write:addr[hex]:value[hex]:num of bytes[max 4]\" > cmd\n" \
+	"3) show all registers:\n" \
+	"cat regs"
+
+struct idtptp_debugfs {
+	idtptp_debugfs_handle handle;
+	struct ptp_clock_info *info;
+	debugfs_cmd_handler handler;
+	struct idtptp_debugfs_regs space;
+	struct dentry *root;
+	struct dentry *cmd;
+	struct dentry *regs;
+	struct dentry *help;
+};
+
+struct idtptp_debugfs_menu {
+	const char *input[DEBUGFS_CMD_MENU_SIZE];
+	const int output[DEBUGFS_CMD_MENU_SIZE];
+	const int size;
+};
+
+static struct idtptp_debugfs_menu cmdmenu = {
+	.input = {"combomode", "write", "read"},
+	.output = {IDTPTP_DEBUGFS_COMBOMODE,
+		   IDTPTP_DEBUGFS_WRITE_REG,
+		   IDTPTP_DEBUGFS_READ_REG},
+	.size = 3,
+};
+
+static struct idtptp_debugfs_menu combomodemenu = {
+	.input = {"current", "fast", "slow", "hold"},
+	.output = {E_COMBOMODE_CURRENT,
+		   E_COMBOMODE_FASTAVG,
+		   E_COMBOMODE_SLOWAVG,
+		   E_COMBOMODE_HOLDOVER},
+	.size = 4,
+};
+
+static inline int
+idtptp_debugfs_parse_menu(char *input,
+			  struct idtptp_debugfs_menu *menu)
+{
+	int i;
+
+	for (i = 0; i < menu->size; i++) {
+		if (strcmp(input, menu->input[i]) == 0)
+			return menu->output[i];
+	}
+
+	return -EINVAL;
+}
+
+static inline int
+idtptp_debugfs_parse_combomode(char *param,
+			       struct idtptp_debugfs_data *data)
+{
+	char **strp = &param;
+	char *modein;
+
+	modein = strsep(strp, ":");
+	if (modein == NULL)
+		return -EINVAL;
+
+	data->combomode = idtptp_debugfs_parse_menu(modein, &combomodemenu);
+
+	return data->combomode;
+}
+
+static inline int
+idtptp_debugfs_parse_write(char *param,
+			   struct idtptp_debugfs_regs space,
+			   struct idtptp_debugfs_data *data)
+{
+	struct idtptp_debugfs_wr *wr = &data->wr;
+	char *addrin, *valuein, *bytesin;
+	unsigned int addr, value, bytes;
+	char **strp = &param;
+	int ret, i;
+
+	addrin = strsep(strp, ":");
+	if (addrin == NULL)
+		return -EINVAL;
+
+	ret = kstrtouint(addrin, 16, &addr);
+	if (ret < 0)
+		return ret;
+
+	if (addr < space.addr || addr > space.addr + space.length - 1)
+		return -EINVAL;
+
+	valuein = strsep(strp, ":");
+	if (valuein == NULL)
+		return -EINVAL;
+
+	ret = kstrtouint(valuein, 16, &value);
+	if (ret < 0)
+		return ret;
+
+	bytesin = strsep(strp, ":");
+	if (bytesin == NULL)
+		return -EINVAL;
+
+	ret = kstrtouint(bytesin, 16, &bytes);
+	if (ret < 0)
+		return ret;
+
+	if (bytes > DEBUGFS_CMD_MAX_WRITE_SIZE)
+		return -EINVAL;
+
+	wr->addr = (u16)addr;
+	wr->length = bytes;
+
+	for (i = 0; i < bytes; i++) {
+		wr->buf[i] = value & 0xff;
+		value >>= 8;
+	}
+
+	return 0;
+}
+
+
+static int idtptp_debugfs_help_show(struct seq_file *m, void *data)
+{
+	seq_printf(m, "%s\n", DEBUGFS_CMD_HELP);
+
+	return 0;
+}
+
+static int idtptp_debugfs_help_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, idtptp_debugfs_help_show, inode->i_private);
+}
+
+static const struct file_operations fops_help = {
+	.owner = THIS_MODULE,
+	.open = idtptp_debugfs_help_open,
+	.read = seq_read,
+	.llseek = seq_lseek,
+	.release = single_release,
+};
+
+static int idtptp_debugfs_reg_show(struct seq_file *m, void *data)
+{
+	struct idtptp_debugfs *dbg = m->private;
+	struct idtptp_debugfs_data wrdata;
+	u16 regaddr = dbg->space.addr;
+	u8 buf[8] = {0};
+	int i, err;
+
+	wrdata.wr.buf = buf;
+	wrdata.wr.length = 8;
+
+	for (i = 0; i < dbg->space.length; i += 8, regaddr += 8) {
+		wrdata.wr.addr = regaddr;
+
+		err = dbg->handler(dbg->info, IDTPTP_DEBUGFS_READ_REG, &wrdata);
+
+		if (err)
+			return err;
+
+		seq_printf(m,
+			   "%04x %03x: %02x %02x %02x %02x %02x %02x %02x %02x\n",
+			   regaddr, i,
+			   buf[0], buf[1], buf[2], buf[3],
+			   buf[4], buf[5], buf[6], buf[7]);
+	}
+
+	return err;
+}
+
+static int idtptp_debugfs_reg_r_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, idtptp_debugfs_reg_show, inode->i_private);
+}
+
+static const struct file_operations fops_reg_r = {
+	.owner = THIS_MODULE,
+	.open = idtptp_debugfs_reg_r_open,
+	.read = seq_read,
+	.llseek = seq_lseek,
+	.release = single_release,
+};
+
+static int idtptp_debugfs_parse(struct idtptp_debugfs *dbg,
+				char *cmdstr,
+				struct idtptp_debugfs_data *data)
+{
+	char **strp = &cmdstr;
+	int cmd, ret;
+	char *cmdin;
+
+	cmdin = strsep(strp, ":");
+	if (cmdin == NULL)
+		return -EINVAL;
+
+	cmd = idtptp_debugfs_parse_menu(cmdin, &cmdmenu);
+
+	switch (cmd) {
+	case IDTPTP_DEBUGFS_COMBOMODE:
+		ret = idtptp_debugfs_parse_combomode(cmdstr, data);
+		break;
+	case IDTPTP_DEBUGFS_WRITE_REG:
+		ret = idtptp_debugfs_parse_write(cmdstr, dbg->space, data);
+		break;
+	case IDTPTP_DEBUGFS_READ_REG:
+	default:
+		ret = -EINVAL;
+	}
+
+	if (ret < 0)
+		return ret;
+
+	return cmd;
+}
+
+static ssize_t idtptp_debugfs_cmd(struct file *file,
+				  const char __user *ptr,
+				  size_t len, loff_t *off)
+{
+	struct idtptp_debugfs *dbg = file->private_data;
+
+	struct idtptp_debugfs_data data;
+	char cmdstr[DEBUGFS_CMD_MAX_SIZE];
+	int cmd, err;
+	u8 wr_buf[DEBUGFS_CMD_MAX_WRITE_SIZE] = {0};
+
+	if (*off != 0)
+		return 0;
+
+	if (len > DEBUGFS_CMD_MAX_SIZE - 1)
+		len = DEBUGFS_CMD_MAX_SIZE - 1;
+
+	err = strncpy_from_user(cmdstr, ptr, len);
+	if (err < 0)
+		return err;
+	cmdstr[len] = '\0';
+
+	data.wr.buf = wr_buf;
+	data.wr.length = sizeof(wr_buf);
+
+	cmd = idtptp_debugfs_parse(dbg, cmdstr, &data);
+	if (cmd < 0)
+		return cmd;
+
+	err = dbg->handler(dbg->info, cmd, &data);
+	if (err < 0)
+		return err;
+
+	return len;
+}
+
+static const struct file_operations fops_cmd = {
+	.owner = THIS_MODULE,
+	.open = simple_open,
+	.write = idtptp_debugfs_cmd,
+	.llseek = noop_llseek,
+};
+
+idtptp_debugfs_handle *
+idtptp_debugfs_init(int index, struct ptp_clock_info *info,
+		    debugfs_cmd_handler handler,
+		    struct idtptp_debugfs_regs space)
+{
+	struct idtptp_debugfs *dbg;
+	char name[16];
+	int err = 0;
+
+	dbg = kzalloc(sizeof(struct idtptp_debugfs), GFP_KERNEL);
+	if (dbg == NULL)
+		return ERR_PTR(-ENOMEM);
+
+	dbg->info = info;
+	dbg->handle = index;
+	dbg->handler = handler;
+	dbg->space = space;
+
+	snprintf(name, sizeof(name), "idtptp%u", index);
+
+	dbg->root = debugfs_create_dir(name, NULL);
+	if (!dbg->root) {
+		err = -ENOMEM;
+		goto ret;
+	}
+
+	dbg->help = debugfs_create_file("help", S_IFREG | S_IRUSR,
+					dbg->root, dbg, &fops_help);
+	if (!dbg->help) {
+		err = -ENOMEM;
+		goto ret;
+	}
+
+	dbg->regs = debugfs_create_file("regs", S_IFREG | S_IRUSR,
+					dbg->root, dbg, &fops_reg_r);
+	if (!dbg->regs) {
+		err = -ENOMEM;
+		goto ret;
+	}
+
+	dbg->cmd = debugfs_create_file("cmd", S_IFREG | S_IWUSR,
+					dbg->root, dbg, &fops_cmd);
+	if (!dbg->cmd) {
+		err = -ENOMEM;
+		goto ret;
+	}
+
+ret:
+	if (err < 0) {
+		idtptp_debugfs_exit(&dbg->handle);
+		return ERR_PTR(err);
+	}
+	return &dbg->handle;
+}
+EXPORT_SYMBOL(idtptp_debugfs_init);
+
+void idtptp_debugfs_exit(idtptp_debugfs_handle *handle)
+{
+	struct idtptp_debugfs *dbg =
+		container_of(handle, struct idtptp_debugfs, handle);
+
+	if (dbg == NULL)
+		return;
+
+	debugfs_remove(dbg->help);
+	debugfs_remove(dbg->regs);
+	debugfs_remove(dbg->cmd);
+	debugfs_remove(dbg->root);
+
+	kfree(dbg);
+}
+EXPORT_SYMBOL(idtptp_debugfs_exit);
diff --git a/drivers/ptp/ptp_idt_debugfs.h b/drivers/ptp/ptp_idt_debugfs.h
new file mode 100644
index 0000000..3c5e670
--- /dev/null
+++ b/drivers/ptp/ptp_idt_debugfs.h
@@ -0,0 +1,83 @@
+/* SPDX-License-Identifier: GPL-2.0+
+ *
+ * PTP debugfs interface for the IDT family of timing and
+ * synchronization devices.
+ *
+ * Copyright (C) 2019 Integrated Device Technology, Inc., a Renesas Company.
+ */
+#ifndef PTP_IDT_DEBUGFS_H
+#define PTP_IDT_DEBUGFS_H
+
+enum idtptp_debugfs_cmd {
+	IDTPTP_DEBUGFS_READ_REG = 0, /* read registers */
+	IDTPTP_DEBUGFS_WRITE_REG,    /* write registers */
+	IDTPTP_DEBUGFS_COMBOMODE,    /* set combo mode */
+	IDTPTP_DEBUGFS_MAX,
+};
+
+/**
+ * @brief Enumerated type listing DPLL combination modes
+ */
+enum idtdpll_combomode {
+	E_COMBOMODE_CURRENT = 0,   /* CURRENT/INSTANEOUS HOLDOVER OFFSET */
+	E_COMBOMODE_FASTAVG,       /* FAST AVERAGED HOLDOVER OFFSET */
+	E_COMBOMODE_SLOWAVG,       /* SLOW AVERAGED HOLDOVER OFFSET */
+	E_COMBOMODE_HOLDOVER,      /* HOLDER OVER OFFSET REGISTER VALUE USED */
+	E_COMBOMODE_MAX,
+};
+
+/* for register read/write */
+struct idtptp_debugfs_wr {
+	u16 addr;
+	u8 *buf;
+	u16 length;
+};
+
+/* device register space */
+struct idtptp_debugfs_regs {
+	u16 addr;
+	u16 length;
+};
+
+/* data passing to phc driver */
+struct idtptp_debugfs_data {
+	union {
+		enum idtdpll_combomode combomode;
+		struct idtptp_debugfs_wr wr;
+	};
+};
+
+struct ptp_clock_info;
+
+/* command handler provided by phc driver to handle idtptp_debugfs_cmd */
+typedef int (*debugfs_cmd_handler)(struct ptp_clock_info *info,
+				   enum idtptp_debugfs_cmd cmd,
+				   struct idtptp_debugfs_data *data);
+
+typedef int idtptp_debugfs_handle;
+
+/**
+ * idtptp_debugfs_init() - initialize idtptp debugfs interface
+ *
+ * @index   idtptp${index} as debugfs dir name
+ * @info    phc registered ptp_clock_info
+ * @handler handle idtptp_debugfs_cmd
+ * @space   device register space
+ *
+ * Returns a valid handle pointer on success or PTR_ERR on failure.
+ */
+idtptp_debugfs_handle *
+idtptp_debugfs_init(int index, struct ptp_clock_info *info,
+		    debugfs_cmd_handler handler,
+		    struct idtptp_debugfs_regs space);
+
+/**
+ * idtptp_debugfs_exit() - delete idtptp debugfs interface
+ *
+ * @handle  handle pointer from idtptp_debugfs_init
+ *
+ */
+void idtptp_debugfs_exit(idtptp_debugfs_handle *handle);
+
+#endif/* PTP_IDT_DEBUGFS_H */
+
-- 
2.7.4

