Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 04FC73DBF6D
	for <lists+netdev@lfdr.de>; Fri, 30 Jul 2021 22:14:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231283AbhG3UOG convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 30 Jul 2021 16:14:06 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:65408 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S230217AbhG3UOF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Jul 2021 16:14:05 -0400
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.16.0.43/8.16.0.43) with SMTP id 16UK82nP000365
        for <netdev@vger.kernel.org>; Fri, 30 Jul 2021 13:14:00 -0700
Received: from mail.thefacebook.com ([163.114.132.120])
        by m0001303.ppops.net with ESMTP id 3a4fprb4uw-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 30 Jul 2021 13:13:59 -0700
Received: from intmgw001.37.frc1.facebook.com (2620:10d:c085:108::4) by
 mail.thefacebook.com (2620:10d:c085:11d::5) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Fri, 30 Jul 2021 13:13:57 -0700
Received: by devvm2494.atn0.facebook.com (Postfix, from userid 172786)
        id 4F15BE66876E; Fri, 30 Jul 2021 13:13:54 -0700 (PDT)
From:   Jonathan Lemon <jonathan.lemon@gmail.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>,
        <richardcochran@gmail.com>
CC:     <netdev@vger.kernel.org>, <kernel-team@fb.com>
Subject: [PATCH net-next] ptp: ocp: Expose various resources on the timecard.
Date:   Fri, 30 Jul 2021 13:13:54 -0700
Message-ID: <20210730201354.1237659-1-jonathan.lemon@gmail.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-GUID: zajoHQAU_STYcfEFFR-uAtUjAMMbS5Lp
X-Proofpoint-ORIG-GUID: zajoHQAU_STYcfEFFR-uAtUjAMMbS5Lp
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-07-30_11:2021-07-30,2021-07-30 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 spamscore=0 clxscore=1034
 suspectscore=0 bulkscore=0 adultscore=0 priorityscore=1501 impostorscore=0
 malwarescore=0 phishscore=0 lowpriorityscore=0 mlxlogscore=999 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2107140000
 definitions=main-2107300137
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The OpenCompute timecard driver has additional functionality besides
a clock.  Make the following resources available:

 - The external timestamp channels (ts0/ts1)
 - devlink support for flashing and health reporting
 - GPS and MAC serial ports
 - board serial number (obtained from i2c device)

Also add watchdog functionality for when GNSS goes into holdover.

The resources are collected under a driver procfs directory:

  [jlemon@timecard ~]$ ls -g /proc/driver/ocp1
  total 0
  -rw-r--r--. 1 root  0 Jul 30 12:37 clock_source
  -r--r--r--. 1 root  0 Jul 30 12:37 gps_state
  lrwxrwxrwx. 1 root 26 Jul 30 12:37 i2c -> /sys/bus/i2c/devices/i2c-2/
  lrwxrwxrwx. 1 root  9 Jul 30 12:37 pps -> /dev/pps1
  lrwxrwxrwx. 1 root  9 Jul 30 12:37 ptp -> /dev/ptp2
  -r--r--r--. 1 root  0 Jul 30 12:37 serial
  lrwxrwxrwx. 1 root 10 Jul 30 12:37 ttyGPS -> /dev/ttyS7
  lrwxrwxrwx. 1 root 10 Jul 30 12:37 ttyMAC -> /dev/ttyS8

Signed-off-by: Jonathan Lemon <jonathan.lemon@gmail.com>
---
 drivers/ptp/Kconfig   |    7 +
 drivers/ptp/ptp_ocp.c | 1307 +++++++++++++++++++++++++++++++++++++++--
 2 files changed, 1269 insertions(+), 45 deletions(-)

diff --git a/drivers/ptp/Kconfig b/drivers/ptp/Kconfig
index 8c20e524e9ad..8b08745e1ca1 100644
--- a/drivers/ptp/Kconfig
+++ b/drivers/ptp/Kconfig
@@ -157,6 +157,13 @@ config PTP_1588_CLOCK_OCP
 	tristate "OpenCompute TimeCard as PTP clock"
 	depends on PTP_1588_CLOCK
 	depends on HAS_IOMEM && PCI
+	depends on SPI && I2C && MTD
+	imply SPI_MEM
+	imply SPI_XILINX
+	imply MTD_SPI_NOR
+	imply I2C_XILINX
+	select SERIAL_8250
+
 	default n
 	help
 	  This driver adds support for an OpenCompute time card.
diff --git a/drivers/ptp/ptp_ocp.c b/drivers/ptp/ptp_ocp.c
index 0d1034e3ed0f..dd6bbe396768 100644
--- a/drivers/ptp/ptp_ocp.c
+++ b/drivers/ptp/ptp_ocp.c
@@ -6,15 +6,25 @@
 #include <linux/module.h>
 #include <linux/init.h>
 #include <linux/pci.h>
+#include <linux/serial_8250.h>
+#include <linux/clkdev.h>
+#include <linux/clk-provider.h>
+#include <linux/platform_device.h>
 #include <linux/ptp_clock_kernel.h>
+#include <linux/spi/spi.h>
+#include <linux/spi/xilinx_spi.h>
+#include <net/devlink.h>
+#include <linux/i2c.h>
+#include <linux/mtd/mtd.h>
+#include <linux/proc_fs.h>
 
-static const struct pci_device_id ptp_ocp_pcidev_id[] = {
-	{ PCI_DEVICE(0x1d9b, 0x0400) },
-	{ 0 }
-};
-MODULE_DEVICE_TABLE(pci, ptp_ocp_pcidev_id);
+#ifndef PCI_VENDOR_ID_FACEBOOK
+#define PCI_VENDOR_ID_FACEBOOK 0x1d9b
+#endif
 
-#define OCP_REGISTER_OFFSET	0x01000000
+#ifndef PCI_DEVICE_ID_FACEBOOK_TIMECARD
+#define PCI_DEVICE_ID_FACEBOOK_TIMECARD 0x0400
+#endif
 
 struct ocp_reg {
 	u32	ctrl;
@@ -29,18 +39,29 @@ struct ocp_reg {
 	u32	__pad1[2];
 	u32	offset_ns;
 	u32	offset_window_ns;
+	u32	__pad2[2];
+	u32	drift_ns;
+	u32	drift_window_ns;
+	u32	__pad3[6];
+	u32	servo_offset_p;
+	u32	servo_offset_i;
+	u32	servo_drift_p;
+	u32	servo_drift_i;
 };
 
 #define OCP_CTRL_ENABLE		BIT(0)
 #define OCP_CTRL_ADJUST_TIME	BIT(1)
 #define OCP_CTRL_ADJUST_OFFSET	BIT(2)
+#define OCP_CTRL_ADJUST_DRIFT	BIT(3)
+#define OCP_CTRL_ADJUST_SERVO	BIT(8)
 #define OCP_CTRL_READ_TIME_REQ	BIT(30)
 #define OCP_CTRL_READ_TIME_DONE	BIT(31)
 
 #define OCP_STATUS_IN_SYNC	BIT(0)
+#define OCP_STATUS_IN_HOLDOVER	BIT(1)
 
 #define OCP_SELECT_CLK_NONE	0
-#define OCP_SELECT_CLK_REG	6
+#define OCP_SELECT_CLK_REG	0xfe
 
 struct tod_reg {
 	u32	ctrl;
@@ -55,8 +76,6 @@ struct tod_reg {
 	u32	leap;
 };
 
-#define TOD_REGISTER_OFFSET	0x01050000
-
 #define TOD_CTRL_PROTOCOL	BIT(28)
 #define TOD_CTRL_DISABLE_FMT_A	BIT(17)
 #define TOD_CTRL_DISABLE_FMT_B	BIT(16)
@@ -68,16 +87,262 @@ struct tod_reg {
 #define TOD_STATUS_UTC_VALID	BIT(8)
 #define TOD_STATUS_LEAP_VALID	BIT(16)
 
+struct ts_reg {
+	u32	enable;
+	u32	error;
+	u32	polarity;
+	u32	version;
+	u32	__pad0[4];
+	u32	cable_delay;
+	u32	__pad1[3];
+	u32	intr;
+	u32	intr_mask;
+	u32	event_count;
+	u32	__pad2[1];
+	u32	ts_count;
+	u32	time_ns;
+	u32	time_sec;
+	u32	data_width;
+	u32	data;
+};
+
+struct pps_reg {
+	u32	ctrl;
+	u32	status;
+};
+
+#define PPS_STATUS_FILTER_ERR	BIT(0)
+#define PPS_STATUS_SUPERV_ERR	BIT(1)
+
+struct img_reg {
+	u32	version;
+};
+
+struct ptp_ocp_flash_info {
+	const char *name;
+	int pci_offset;
+	int data_size;
+	void *data;
+};
+
+struct ptp_ocp_ext_info {
+	const char *name;
+	int index;
+	irqreturn_t (*irq_fcn)(int irq, void *priv);
+	int (*enable)(void *priv, bool enable);
+};
+
+struct ptp_ocp_ext_src {
+	void __iomem		*mem;
+	struct ptp_ocp		*bp;
+	struct ptp_ocp_ext_info	*info;
+	int			irq_vec;
+};
+
 struct ptp_ocp {
 	struct pci_dev		*pdev;
+	struct ocp_resource	*res_tbl;
 	spinlock_t		lock;
-	void __iomem		*base;
 	struct ocp_reg __iomem	*reg;
 	struct tod_reg __iomem	*tod;
+	struct pps_reg __iomem	*pps_monitor;
+	struct ptp_ocp_ext_src	*pps;
+	struct ptp_ocp_ext_src	*ts0;
+	struct ptp_ocp_ext_src	*ts1;
+	struct img_reg __iomem	*image;
 	struct ptp_clock	*ptp;
 	struct ptp_clock_info	ptp_info;
+	struct platform_device	*i2c_osc;
+	struct platform_device	*spi_flash;
+	struct proc_dir_entry	*i2c_pde;
+	struct clk_hw		*i2c_clk;
+	struct devlink_health_reporter *health;
+	struct proc_dir_entry	*proc;
+	struct timer_list	watchdog;
+	time64_t		gps_lost;
+	int			id;
+	int			n_irqs;
+	int			gps_port;
+	int			mac_port;	/* miniature atomic clock */
+	u8			serial[6];
+	int			flash_start;
+	bool			has_serial;
+	bool			pending_image;
+};
+
+struct ocp_resource {
+	unsigned long offset;
+	int size;
+	int irq_vec;
+	int (*setup)(struct ptp_ocp *bp, struct ocp_resource *r);
+	void *extra;
+	unsigned long bp_offset;
 };
 
+static void ptp_ocp_health_update(struct ptp_ocp *bp);
+static int ptp_ocp_register_mem(struct ptp_ocp *bp, struct ocp_resource *r);
+static int ptp_ocp_register_i2c(struct ptp_ocp *bp, struct ocp_resource *r);
+static int ptp_ocp_register_spi(struct ptp_ocp *bp, struct ocp_resource *r);
+static int ptp_ocp_register_serial(struct ptp_ocp *bp, struct ocp_resource *r);
+static int ptp_ocp_register_ext(struct ptp_ocp *bp, struct ocp_resource *r);
+static int ptp_ocp_fb_board_init(struct ptp_ocp *bp, struct ocp_resource *r);
+static irqreturn_t ptp_ocp_ts_irq(int irq, void *priv);
+static int ptp_ocp_ts_enable(void *priv, bool enable);
+
+#define bp_assign_entry(bp, res, val) ({				\
+	uintptr_t addr = (uintptr_t)(bp) + (res)->bp_offset;		\
+	*(typeof(val) *)addr = val;					\
+})
+
+#define OCP_RES_LOCATION(member) \
+	.bp_offset = offsetof(struct ptp_ocp, member)
+
+#define OCP_MEM_RESOURCE(member) \
+	OCP_RES_LOCATION(member), .setup = ptp_ocp_register_mem
+
+#define OCP_SERIAL_RESOURCE(member) \
+	OCP_RES_LOCATION(member), .setup = ptp_ocp_register_serial
+
+#define OCP_I2C_RESOURCE(member) \
+	OCP_RES_LOCATION(member), .setup = ptp_ocp_register_i2c
+
+#define OCP_SPI_RESOURCE(member) \
+	OCP_RES_LOCATION(member), .setup = ptp_ocp_register_spi
+
+#define OCP_EXT_RESOURCE(member) \
+	OCP_RES_LOCATION(member), .setup = ptp_ocp_register_ext
+
+/* This is the MSI vector mapping used.
+ * 0: N/C
+ * 1: TS0
+ * 2: TS1
+ * 3: GPS
+ * 4: GPS2 (n/c)
+ * 5: MAC
+ * 6: SPI IMU (inertial measurement unit)
+ * 7: I2C oscillator
+ * 8: HWICAP
+ * 9: SPI Flash
+ */
+
+static struct ocp_resource ocp_fb_resource[] = {
+	{
+		OCP_MEM_RESOURCE(reg),
+		.offset = 0x01000000, .size = 0x10000,
+	},
+	{
+		OCP_EXT_RESOURCE(ts0),
+		.offset = 0x01010000, .size = 0x10000, .irq_vec = 1,
+		.extra = &(struct ptp_ocp_ext_info) {
+			.name = "ts0", .index = 0,
+			.irq_fcn = ptp_ocp_ts_irq,
+			.enable = ptp_ocp_ts_enable,
+		},
+	},
+	{
+		OCP_EXT_RESOURCE(ts1),
+		.offset = 0x01020000, .size = 0x10000, .irq_vec = 2,
+		.extra = &(struct ptp_ocp_ext_info) {
+			.name = "ts1", .index = 1,
+			.irq_fcn = ptp_ocp_ts_irq,
+			.enable = ptp_ocp_ts_enable,
+		},
+	},
+	{
+		OCP_MEM_RESOURCE(pps_monitor),
+		.offset = 0x01040000, .size = 0x10000,
+	},
+	{
+		OCP_MEM_RESOURCE(tod),
+		.offset = 0x01050000, .size = 0x10000,
+	},
+	{
+		OCP_MEM_RESOURCE(image),
+		.offset = 0x00020000, .size = 0x1000,
+	},
+	{
+		OCP_I2C_RESOURCE(i2c_osc),
+		.offset = 0x00150000, .size = 0x10000, .irq_vec = 7,
+	},
+	{
+		OCP_SERIAL_RESOURCE(gps_port),
+		.offset = 0x00160000 + 0x1000, .irq_vec = 3,
+	},
+	{
+		OCP_SERIAL_RESOURCE(mac_port),
+		.offset = 0x00180000 + 0x1000, .irq_vec = 5,
+	},
+	{
+		OCP_SPI_RESOURCE(spi_flash),
+		.offset = 0x00310000, .size = 0x10000, .irq_vec = 9,
+		.extra = &(struct ptp_ocp_flash_info) {
+			.name = "xilinx_spi", .pci_offset = 0,
+			.data_size = sizeof(struct xspi_platform_data),
+			.data = &(struct xspi_platform_data) {
+				.num_chipselect = 1,
+				.bits_per_word = 8,
+				.num_devices = 1,
+				.devices = &(struct spi_board_info) {
+					.modalias = "spi-nor",
+				},
+			},
+		},
+	},
+	{
+		.setup = ptp_ocp_fb_board_init,
+	},
+	{ }
+};
+
+static const struct pci_device_id ptp_ocp_pcidev_id[] = {
+	{ PCI_DEVICE_DATA(FACEBOOK, TIMECARD, &ocp_fb_resource) },
+	{ 0 }
+};
+MODULE_DEVICE_TABLE(pci, ptp_ocp_pcidev_id);
+
+static DEFINE_MUTEX(ptp_ocp_lock);
+static DEFINE_IDR(ptp_ocp_idr);
+
+static struct {
+	const char *name;
+	int value;
+} ptp_ocp_clock[] = {
+	{ .name = "NONE",	.value = 0 },
+	{ .name = "TOD",	.value = 1 },
+	{ .name = "IRIG",	.value = 2 },
+	{ .name = "PPS",	.value = 3 },
+	{ .name = "PTP",	.value = 4 },
+	{ .name = "RTC",	.value = 5 },
+	{ .name = "DCF",	.value = 6 },
+	{ .name = "REGS",	.value = 0xfe },
+	{ .name = "EXT",	.value = 0xff },
+};
+
+static const char *
+ptp_ocp_clock_name_from_val(int val)
+{
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(ptp_ocp_clock); i++)
+		if (ptp_ocp_clock[i].value == val)
+			return ptp_ocp_clock[i].name;
+	return NULL;
+}
+
+static int
+ptp_ocp_clock_val_from_name(const char *name)
+{
+	const char *clk;
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(ptp_ocp_clock); i++) {
+		clk = ptp_ocp_clock[i].name;
+		if (!strncasecmp(name, clk, strlen(clk)))
+			return ptp_ocp_clock[i].value;
+	}
+	return -EINVAL;
+}
+
 static int
 __ptp_ocp_gettime_locked(struct ptp_ocp *bp, struct timespec64 *ts,
 			 struct ptp_system_timestamp *sts)
@@ -192,6 +457,45 @@ ptp_ocp_null_adjfine(struct ptp_clock_info *ptp_info, long scaled_ppm)
 	return -EOPNOTSUPP;
 }
 
+static int
+ptp_ocp_adjphase(struct ptp_clock_info *ptp_info, s32 phase_ns)
+{
+	return -EOPNOTSUPP;
+}
+
+static int
+ptp_ocp_enable(struct ptp_clock_info *ptp_info, struct ptp_clock_request *rq,
+	       int on)
+{
+	struct ptp_ocp *bp = container_of(ptp_info, struct ptp_ocp, ptp_info);
+	struct ptp_ocp_ext_src *ext = NULL;
+	int err;
+
+	switch (rq->type) {
+	case PTP_CLK_REQ_EXTTS:
+		switch (rq->extts.index) {
+		case 0:
+			ext = bp->ts0;
+			break;
+		case 1:
+			ext = bp->ts1;
+			break;
+		}
+		break;
+	case PTP_CLK_REQ_PPS:
+		ext = bp->pps;
+		break;
+	default:
+		return -EOPNOTSUPP;
+	}
+
+	err = -ENXIO;
+	if (ext)
+		err = ext->info->enable(ext, on);
+
+	return err;
+}
+
 static const struct ptp_clock_info ptp_ocp_clock_info = {
 	.owner		= THIS_MODULE,
 	.name		= KBUILD_MODNAME,
@@ -200,10 +504,59 @@ static const struct ptp_clock_info ptp_ocp_clock_info = {
 	.settime64	= ptp_ocp_settime,
 	.adjtime	= ptp_ocp_adjtime,
 	.adjfine	= ptp_ocp_null_adjfine,
+	.adjphase	= ptp_ocp_adjphase,
+	.enable		= ptp_ocp_enable,
+	.pps		= true,
+	.n_ext_ts	= 2,
 };
 
+static void
+__ptp_ocp_clear_drift_locked(struct ptp_ocp *bp)
+{
+	u32 ctrl, select;
+
+	select = ioread32(&bp->reg->select);
+	iowrite32(OCP_SELECT_CLK_REG, &bp->reg->select);
+
+	iowrite32(0, &bp->reg->drift_ns);
+
+	ctrl = ioread32(&bp->reg->ctrl);
+	ctrl |= OCP_CTRL_ADJUST_DRIFT;
+	iowrite32(ctrl, &bp->reg->ctrl);
+
+	/* restore clock selection */
+	iowrite32(select >> 16, &bp->reg->select);
+}
+
+static void
+ptp_ocp_watchdog(struct timer_list *t)
+{
+	struct ptp_ocp *bp = from_timer(bp, t, watchdog);
+	unsigned long flags;
+	u32 status;
+
+	status = ioread32(&bp->pps_monitor->status);
+
+	if (status & PPS_STATUS_SUPERV_ERR) {
+		iowrite32(status, &bp->pps_monitor->status);
+		if (!bp->gps_lost) {
+			spin_lock_irqsave(&bp->lock, flags);
+			__ptp_ocp_clear_drift_locked(bp);
+			spin_unlock_irqrestore(&bp->lock, flags);
+			bp->gps_lost = ktime_get_real_seconds();
+			ptp_ocp_health_update(bp);
+		}
+
+	} else if (bp->gps_lost) {
+		bp->gps_lost = 0;
+		ptp_ocp_health_update(bp);
+	}
+
+	mod_timer(&bp->watchdog, jiffies + HZ);
+}
+
 static int
-ptp_ocp_check_clock(struct ptp_ocp *bp)
+ptp_ocp_init_clock(struct ptp_ocp *bp)
 {
 	struct timespec64 ts;
 	bool sync;
@@ -214,6 +567,17 @@ ptp_ocp_check_clock(struct ptp_ocp *bp)
 	ctrl |= OCP_CTRL_ENABLE;
 	iowrite32(ctrl, &bp->reg->ctrl);
 
+	/* NO DRIFT Correction */
+	/* offset_p:i 1/8, offset_i: 1/16, drift_p: 0, drift_i: 0 */
+	iowrite32(0x2000, &bp->reg->servo_offset_p);
+	iowrite32(0x1000, &bp->reg->servo_offset_i);
+	iowrite32(0,	  &bp->reg->servo_drift_p);
+	iowrite32(0,	  &bp->reg->servo_drift_i);
+
+	/* latch servo values */
+	ctrl |= OCP_CTRL_ADJUST_SERVO;
+	iowrite32(ctrl, &bp->reg->ctrl);
+
 	if ((ioread32(&bp->reg->ctrl) & OCP_CTRL_ENABLE) == 0) {
 		dev_err(&bp->pdev->dev, "clock not enabled\n");
 		return -ENODEV;
@@ -229,6 +593,9 @@ ptp_ocp_check_clock(struct ptp_ocp *bp)
 			 ts.tv_sec, ts.tv_nsec,
 			 sync ? "in-sync" : "UNSYNCED");
 
+	timer_setup(&bp->watchdog, ptp_ocp_watchdog, 0);
+	mod_timer(&bp->watchdog, jiffies + HZ);
+
 	return 0;
 }
 
@@ -278,82 +645,886 @@ ptp_ocp_tod_info(struct ptp_ocp *bp)
 		 reg & TOD_STATUS_LEAP_VALID ? 1 : 0);
 }
 
+static int
+ptp_ocp_firstchild(struct device *dev, void *data)
+{
+	return 1;
+}
+
+static int
+ptp_ocp_read_i2c(struct i2c_adapter *adap, u8 addr, u8 reg, u8 sz, u8 *data)
+{
+	struct i2c_msg msgs[2] = {
+		{
+			.addr = addr,
+			.len = 1,
+			.buf = &reg,
+		},
+		{
+			.addr = addr,
+			.flags = I2C_M_RD,
+			.len = 2,
+			.buf = data,
+		},
+	};
+	int err;
+	u8 len;
+
+	/* xiic-i2c for some stupid reason only does 2 byte reads. */
+	while (sz) {
+		len = min_t(u8, sz, 2);
+		msgs[1].len = len;
+		err = i2c_transfer(adap, msgs, 2);
+		if (err != msgs[1].len)
+			return err;
+		msgs[1].buf += len;
+		reg += len;
+		sz -= len;
+	}
+	return 0;
+}
+
+static void
+ptp_ocp_get_serial_number(struct ptp_ocp *bp)
+{
+	struct i2c_adapter *adap;
+	struct device *dev;
+	int err;
+
+	dev = device_find_child(&bp->i2c_osc->dev, NULL, ptp_ocp_firstchild);
+	if (!dev) {
+		dev_err(&bp->pdev->dev, "Can't find I2C adapter\n");
+		return;
+	}
+
+	adap = i2c_verify_adapter(dev);
+	if (!adap) {
+		dev_err(&bp->pdev->dev, "device '%s' isn't an I2C adapter\n",
+			dev_name(dev));
+		goto out;
+	}
+
+	err = ptp_ocp_read_i2c(adap, 0x58, 0x9A, 6, bp->serial);
+	if (err) {
+		dev_err(&bp->pdev->dev, "could not read eeprom: %d\n", err);
+		goto out;
+	}
+
+	bp->has_serial = true;
+
+out:
+	put_device(dev);
+}
+
 static void
 ptp_ocp_info(struct ptp_ocp *bp)
 {
-	static const char * const clock_name[] = {
-		"NO", "TOD", "IRIG", "PPS", "PTP", "RTC", "REGS", "EXT"
-	};
 	u32 version, select;
 
 	version = ioread32(&bp->reg->version);
 	select = ioread32(&bp->reg->select);
 	dev_info(&bp->pdev->dev, "Version %d.%d.%d, clock %s, device ptp%d\n",
 		 version >> 24, (version >> 16) & 0xff, version & 0xffff,
-		 clock_name[select & 7],
+		 ptp_ocp_clock_name_from_val(select >> 16),
 		 ptp_clock_index(bp->ptp));
 
 	ptp_ocp_tod_info(bp);
 }
 
+static const struct devlink_param ptp_ocp_devlink_params[] = {
+};
+
+static void
+ptp_ocp_devlink_set_params_init_values(struct devlink *devlink)
+{
+}
+
+static int
+ptp_ocp_devlink_register(struct devlink *devlink, struct device *dev)
+{
+	int err;
+
+	err = devlink_register(devlink, dev);
+	if (err)
+		return err;
+
+	err = devlink_params_register(devlink, ptp_ocp_devlink_params,
+				      ARRAY_SIZE(ptp_ocp_devlink_params));
+	ptp_ocp_devlink_set_params_init_values(devlink);
+	if (err)
+		goto out;
+	devlink_params_publish(devlink);
+
+	return 0;
+
+out:
+	devlink_unregister(devlink);
+	return err;
+}
+
+static void
+ptp_ocp_devlink_unregister(struct devlink *devlink)
+{
+	devlink_params_unregister(devlink, ptp_ocp_devlink_params,
+				  ARRAY_SIZE(ptp_ocp_devlink_params));
+	devlink_unregister(devlink);
+}
+
+static struct device *
+ptp_ocp_find_flash(struct ptp_ocp *bp)
+{
+	struct device *dev, *last;
+
+	last = NULL;
+	dev = &bp->spi_flash->dev;
+
+	while ((dev = device_find_child(dev, NULL, ptp_ocp_firstchild))) {
+		if (!strcmp("mtd", dev_bus_name(dev)))
+			break;
+		put_device(last);
+		last = dev;
+	}
+	put_device(last);
+
+	return dev;
+}
+
+static int
+ptp_ocp_devlink_flash(struct devlink *devlink, struct device *dev,
+		      const struct firmware *fw)
+{
+	struct mtd_info *mtd = dev_get_drvdata(dev);
+	struct ptp_ocp *bp = devlink_priv(devlink);
+	size_t off, len, resid, wrote;
+	struct erase_info erase;
+	size_t base, blksz;
+	int err;
+
+	off = 0;
+	base = bp->flash_start;
+	blksz = 4096;
+	resid = fw->size;
+
+	while (resid) {
+		devlink_flash_update_status_notify(devlink, "Flashing",
+						   NULL, off, fw->size);
+
+		len = min_t(size_t, resid, blksz);
+		erase.addr = base + off;
+		erase.len = blksz;
+
+		err = mtd_erase(mtd, &erase);
+		if (err)
+			goto out;
+
+		err = mtd_write(mtd, base + off, len, &wrote, &fw->data[off]);
+		if (err)
+			goto out;
+
+		off += blksz;
+		resid -= len;
+	}
+out:
+	return err;
+}
+
+static int
+ptp_ocp_devlink_flash_update(struct devlink *devlink,
+			     struct devlink_flash_update_params *params,
+			     struct netlink_ext_ack *extack)
+{
+	struct ptp_ocp *bp = devlink_priv(devlink);
+	struct device *dev;
+	const char *msg;
+	int err;
+
+	dev = ptp_ocp_find_flash(bp);
+	if (!dev) {
+		dev_err(&bp->pdev->dev, "Can't find Flash SPI adapter\n");
+		return -ENODEV;
+	}
+
+	devlink_flash_update_status_notify(devlink, "Preparing to flash",
+					   NULL, 0, 0);
+
+	err = ptp_ocp_devlink_flash(devlink, dev, params->fw);
+
+	msg = err ? "Flash error" : "Flash complete";
+	devlink_flash_update_status_notify(devlink, msg, NULL, 0, 0);
+
+	bp->pending_image = true;
+
+	put_device(dev);
+	return err;
+}
+
+static int
+ptp_ocp_devlink_info_get(struct devlink *devlink, struct devlink_info_req *req,
+			 struct netlink_ext_ack *extack)
+{
+	struct ptp_ocp *bp = devlink_priv(devlink);
+	char buf[32];
+	int err;
+
+	err = devlink_info_driver_name_put(req, KBUILD_MODNAME);
+	if (err)
+		return err;
+
+	if (bp->pending_image) {
+		err = devlink_info_version_stored_put(req,
+						      "timecard", "pending");
+		if (err)
+			return err;
+	}
+
+	if (bp->image) {
+		u32 ver = bp->image->version;
+		if (ver & 0xffff) {
+			sprintf(buf, "%d", ver);
+			err = devlink_info_version_running_put(req,
+					"timecard", buf);
+		} else {
+			sprintf(buf, "%d", ver >> 16);
+			err = devlink_info_version_running_put(req,
+					"golden flash", buf);
+		}
+		if (err)
+			return err;
+	}
+
+	if (!bp->has_serial)
+		ptp_ocp_get_serial_number(bp);
+
+	if (bp->has_serial) {
+		sprintf(buf, "%pM", bp->serial);
+		err = devlink_info_serial_number_put(req, buf);
+		if (err)
+			return err;
+	}
+
+	return 0;
+}
+
+static const struct devlink_ops ptp_ocp_devlink_ops = {
+	.flash_update = ptp_ocp_devlink_flash_update,
+	.info_get = ptp_ocp_devlink_info_get,
+};
+
+static int
+ptp_ocp_health_diagnose(struct devlink_health_reporter *reporter,
+			struct devlink_fmsg *fmsg,
+			struct netlink_ext_ack *extack)
+{
+	struct ptp_ocp *bp = devlink_health_reporter_priv(reporter);
+	char buf[32];
+	int err;
+
+	if (!bp->gps_lost)
+		return 0;
+
+	sprintf(buf, "%ptT", &bp->gps_lost);
+	err = devlink_fmsg_string_pair_put(fmsg, "Lost sync at", buf);
+	if (err)
+		return err;
+
+	return 0;
+}
+
+static void
+ptp_ocp_health_update(struct ptp_ocp *bp)
+{
+	int state;
+
+	state = bp->gps_lost ? DEVLINK_HEALTH_REPORTER_STATE_ERROR
+			     : DEVLINK_HEALTH_REPORTER_STATE_HEALTHY;
+
+	if (bp->gps_lost)
+		devlink_health_report(bp->health, "No GPS signal", NULL);
+
+	devlink_health_reporter_state_update(bp->health, state);
+}
+
+static const struct devlink_health_reporter_ops ptp_ocp_health_ops = {
+	.name = "gps_sync",
+	.diagnose = ptp_ocp_health_diagnose,
+};
+
+static void
+ptp_ocp_devlink_health_register(struct devlink *devlink)
+{
+	struct ptp_ocp *bp = devlink_priv(devlink);
+	struct devlink_health_reporter *r;
+
+	r = devlink_health_reporter_create(devlink, &ptp_ocp_health_ops, 0, bp);
+	if (IS_ERR(r))
+		dev_err(&bp->pdev->dev, "Failed to create reporter, err %ld\n",
+			PTR_ERR(r));
+	bp->health = r;
+}
+
+static void __iomem *
+__ptp_ocp_get_mem(struct ptp_ocp *bp, unsigned long start, int size)
+{
+	struct resource res = DEFINE_RES_MEM_NAMED(start, size, "ptp_ocp");
+
+	return devm_ioremap_resource(&bp->pdev->dev, &res);
+}
+
+static void __iomem *
+ptp_ocp_get_mem(struct ptp_ocp *bp, struct ocp_resource *r)
+{
+	unsigned long start;
+
+	start = pci_resource_start(bp->pdev, 0) + r->offset;
+	return __ptp_ocp_get_mem(bp, start, r->size);
+}
+
+static void
+ptp_ocp_set_irq_resource(struct resource *res, int irq)
+{
+	struct resource r = DEFINE_RES_IRQ(irq);
+	*res = r;
+}
+
+static void
+ptp_ocp_set_mem_resource(struct resource *res, unsigned long start, int size)
+{
+	struct resource r = DEFINE_RES_MEM(start, size);
+	*res = r;
+}
+
+static int
+ptp_ocp_register_spi(struct ptp_ocp *bp, struct ocp_resource *r)
+{
+	struct ptp_ocp_flash_info *info;
+	struct pci_dev *pdev = bp->pdev;
+	struct platform_device *p;
+	struct resource res[2];
+	unsigned long start;
+	int id;
+
+	/* XXX hack to work around old FPGA */
+	if (bp->n_irqs < 10) {
+		dev_err(&bp->pdev->dev, "FPGA does not have SPI devices\n");
+		return 0;
+	}
+
+	if (r->irq_vec > bp->n_irqs) {
+		dev_err(&bp->pdev->dev, "spi device irq %d out of range\n",
+			r->irq_vec);
+		return 0;
+	}
+
+	start = pci_resource_start(pdev, 0) + r->offset;
+	ptp_ocp_set_mem_resource(&res[0], start, r->size);
+	ptp_ocp_set_irq_resource(&res[1], pci_irq_vector(pdev, r->irq_vec));
+
+	info = r->extra;
+	id = pci_dev_id(pdev) << 1;
+	id += info->pci_offset;
+
+	p = platform_device_register_resndata(&pdev->dev,
+		info->name, id, res, 2, info->data, info->data_size);
+	if (IS_ERR(p))
+		return PTR_ERR(p);
+
+	bp_assign_entry(bp, r, p);
+
+	return 0;
+}
+
+static struct platform_device *
+ptp_ocp_i2c_bus(struct pci_dev *pdev, struct ocp_resource *r, int id)
+{
+	struct resource res[2];
+	unsigned long start;
+
+	start = pci_resource_start(pdev, 0) + r->offset;
+	ptp_ocp_set_mem_resource(&res[0], start, r->size);
+	ptp_ocp_set_irq_resource(&res[1], pci_irq_vector(pdev, r->irq_vec));
+
+	return platform_device_register_resndata(&pdev->dev, "xiic-i2c",
+						 id, res, 2, NULL, 0);
+}
+
+static int
+ptp_ocp_register_i2c(struct ptp_ocp *bp, struct ocp_resource *r)
+{
+	struct pci_dev *pdev = bp->pdev;
+	struct platform_device *p;
+	struct clk_hw *clk;
+	char buf[32];
+	int id;
+
+	if (r->irq_vec > bp->n_irqs) {
+		dev_err(&bp->pdev->dev, "i2c device irq %d out of range\n",
+			r->irq_vec);
+		return 0;
+	}
+
+	id = pci_dev_id(bp->pdev);
+
+	sprintf(buf, "AXI.%d", id);
+	clk = clk_hw_register_fixed_rate(&pdev->dev, buf, NULL, 0, 50000000);
+	if (IS_ERR(clk))
+		return PTR_ERR(clk);
+	bp->i2c_clk = clk;
+
+	sprintf(buf, "xiic-i2c.%d", id);
+	devm_clk_hw_register_clkdev(&pdev->dev, clk, NULL, buf);
+	p = ptp_ocp_i2c_bus(bp->pdev, r, id);
+	if (IS_ERR(p))
+		return PTR_ERR(p);
+
+	bp_assign_entry(bp, r, p);
+
+	return 0;
+}
+
+static irqreturn_t
+ptp_ocp_ts_irq(int irq, void *priv)
+{
+	struct ptp_ocp_ext_src *ext = priv;
+	struct ts_reg __iomem *reg = ext->mem;
+	struct ptp_clock_event ev;
+	u32 sec, nsec;
+
+	/* XXX should fix API - this converts s/ns -> ts -> s/ns */
+	sec = ioread32(&reg->time_sec);
+	nsec = ioread32(&reg->time_ns);
+
+	ev.type = PTP_CLOCK_EXTTS;
+	ev.index = ext->info->index;
+	ev.timestamp = sec * 1000000000ULL + nsec;
+
+	ptp_clock_event(ext->bp->ptp, &ev);
+
+	iowrite32(1, &reg->intr);	/* write 1 to ack */
+
+	return IRQ_HANDLED;
+}
+
+static int
+ptp_ocp_ts_enable(void *priv, bool enable)
+{
+	struct ptp_ocp_ext_src *ext = priv;
+	struct ts_reg __iomem *reg = ext->mem;
+
+	if (enable) {
+		iowrite32(1, &reg->enable);
+		iowrite32(1, &reg->intr_mask);
+		iowrite32(1, &reg->intr);
+	} else {
+		iowrite32(0, &reg->intr_mask);
+		iowrite32(0, &reg->enable);
+	}
+
+	return 0;
+}
+
+static void
+ptp_ocp_unregister_ext(struct ptp_ocp_ext_src *ext)
+{
+	ext->info->enable(ext, false);
+	pci_free_irq(ext->bp->pdev, ext->irq_vec, ext);
+	kfree(ext);
+}
+
+static int
+ptp_ocp_register_ext(struct ptp_ocp *bp, struct ocp_resource *r)
+{
+	struct pci_dev *pdev = bp->pdev;
+	struct ptp_ocp_ext_src *ext;
+	int err;
+
+	ext = kzalloc(sizeof(*ext), GFP_KERNEL);
+	if (!ext)
+		return -ENOMEM;
+
+	err = -EINVAL;
+	ext->mem = ptp_ocp_get_mem(bp, r);
+	if (!ext->mem)
+		goto out;
+
+	ext->bp = bp;
+	ext->info = r->extra;
+	ext->irq_vec = r->irq_vec;
+
+	err = pci_request_irq(pdev, r->irq_vec, ext->info->irq_fcn, 0,
+			      ext, "ocp%d.%s", bp->id, ext->info->name);
+	if (err) {
+		dev_err(&pdev->dev, "Could not get irq %d\n", r->irq_vec);
+		goto out;
+	}
+
+	bp_assign_entry(bp, r, ext);
+
+	return 0;
+
+out:
+	kfree(ext);
+	return err;
+}
+
+static int
+ptp_ocp_serial_line(struct ptp_ocp *bp, struct ocp_resource *r)
+{
+	struct pci_dev *pdev = bp->pdev;
+	struct uart_8250_port uart;
+
+	/* Setting UPF_IOREMAP and leaving port.membase unspecified lets
+	 * the serial port device claim and release the pci resource.
+	 */
+	memset(&uart, 0, sizeof(uart));
+	uart.port.dev = &pdev->dev;
+	uart.port.iotype = UPIO_MEM;
+	uart.port.regshift = 2;
+	uart.port.mapbase = pci_resource_start(pdev, 0) + r->offset;
+	uart.port.irq = pci_irq_vector(pdev, r->irq_vec);
+	uart.port.uartclk = 50000000;
+	uart.port.flags = UPF_FIXED_TYPE | UPF_IOREMAP;
+	uart.port.type = PORT_16550A;
+
+	return serial8250_register_8250_port(&uart);
+}
+
+static int
+ptp_ocp_register_serial(struct ptp_ocp *bp, struct ocp_resource *r)
+{
+	int port;
+
+	if (r->irq_vec > bp->n_irqs) {
+		dev_err(&bp->pdev->dev, "serial device irq %d out of range\n",
+			r->irq_vec);
+		return 0;
+	}
+
+	port = ptp_ocp_serial_line(bp, r);
+	if (port < 0)
+		return port;
+
+	bp_assign_entry(bp, r, port);
+
+	return 0;
+}
+
+static int
+ptp_ocp_register_mem(struct ptp_ocp *bp, struct ocp_resource *r)
+{
+	void __iomem *mem;
+
+	mem = ptp_ocp_get_mem(bp, r);
+	if (!mem)
+		return -EINVAL;
+
+	bp_assign_entry(bp, r, mem);
+
+	return 0;
+}
+
+/* FB specific board initializers; last "resource" registered. */
+static int
+ptp_ocp_fb_board_init(struct ptp_ocp *bp, struct ocp_resource *r)
+{
+	bp->flash_start = 1024 * 4096;
+
+	return ptp_ocp_init_clock(bp);
+}
+
+static int
+ptp_ocp_register_resources(struct ptp_ocp *bp)
+{
+	struct ocp_resource *r;
+	int err = 0;
+
+	for (r = bp->res_tbl; r->setup; r++) {
+		err = r->setup(bp, r);
+		if (err)
+			break;
+	}
+	return err;
+}
+
+static int
+ptp_ocp_proc_serial(struct seq_file *seq, void *v)
+{
+	struct ptp_ocp *bp = seq->private;
+
+	if (!bp->has_serial)
+		ptp_ocp_get_serial_number(bp);
+
+	seq_printf(seq, "%pM\n", bp->serial);
+	return 0;
+}
+
+static int
+ptp_ocp_proc_gps_sync(struct seq_file *seq, void *v)
+{
+	struct ptp_ocp *bp = seq->private;
+
+	if (bp->gps_lost)
+		seq_printf(seq, "LOST @ %ptT\n", &bp->gps_lost);
+	else
+		seq_printf(seq, "SYNC\n");
+	return 0;
+}
+
+static int
+ptp_ocp_procfs_init(struct ptp_ocp *bp)
+{
+	char buf[32];
+	int err;
+
+	mutex_lock(&ptp_ocp_lock);
+	err = idr_alloc(&ptp_ocp_idr, bp, 0, 0, GFP_KERNEL);
+	mutex_unlock(&ptp_ocp_lock);
+	if (err < 0) {
+		dev_err(&bp->pdev->dev, "idr_alloc failed: %d\n", err);
+		return err;
+	}
+	bp->id = err;
+
+	sprintf(buf, "driver/ocp%d", bp->id);
+	bp->proc = proc_mkdir(buf, NULL);
+
+	return 0;
+}
+
+static ssize_t
+ptp_ocp_proc_source_write(struct file *file, const char __user *user_buf,
+			  size_t nbytes, loff_t *ppos)
+{
+	struct ptp_ocp *bp = PDE_DATA(file_inode(file));
+	unsigned long flags;
+	char buf[16];
+	size_t sz;
+	int val;
+
+	sz = min_t(ssize_t, nbytes, sizeof(buf) - 1);
+	if (copy_from_user(buf, user_buf, sz))
+		return -EFAULT;
+	buf[sz] = 0;
+
+	val = ptp_ocp_clock_val_from_name(buf);
+	if (val < 0)
+		return val;
+
+	spin_lock_irqsave(&bp->lock, flags);
+	iowrite32(val, &bp->reg->select);
+	spin_unlock_irqrestore(&bp->lock, flags);
+
+	return nbytes;
+}
+
+static int
+ptp_ocp_proc_source_show(struct seq_file *seq, void *v)
+{
+	struct ptp_ocp *bp = seq->private;
+	const char *p;
+	u32 select;
+
+	select = ioread32(&bp->reg->select);
+	p = ptp_ocp_clock_name_from_val(select >> 16);
+	seq_printf(seq, "%s\n", p);
+
+	return 0;
+}
+
+static int
+ptp_ocp_proc_source_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, ptp_ocp_proc_source_show, PDE_DATA(inode));
+}
+
+static const struct proc_ops ptp_ocp_proc_source_ops = {
+	.proc_open	= ptp_ocp_proc_source_open,
+	.proc_read	= seq_read,
+	.proc_lseek	= seq_lseek,
+	.proc_write	= ptp_ocp_proc_source_write,
+	.proc_release	= single_release,
+};
+
+static int
+ptp_ocp_procfs_complete(struct ptp_ocp *bp)
+{
+	struct pps_device *pps;
+	char buf[32];
+
+	if (bp->gps_port != -1) {
+		sprintf(buf, "/dev/ttyS%d", bp->gps_port);
+		proc_symlink("ttyGPS", bp->proc, buf);
+	}
+	if (bp->mac_port != -1) {
+		sprintf(buf, "/dev/ttyS%d", bp->mac_port);
+		proc_symlink("ttyMAC", bp->proc, buf);
+	}
+	sprintf(buf, "/dev/ptp%d", ptp_clock_index(bp->ptp));
+	proc_symlink("ptp", bp->proc, buf);
+
+	pps = pps_lookup_dev(bp->ptp);
+	if (pps) {
+		sprintf(buf, "/dev/%s", dev_name(pps->dev));
+		proc_symlink("pps", bp->proc, buf);
+	}
+
+	proc_create_single_data("serial",
+				0, bp->proc, ptp_ocp_proc_serial, bp);
+	proc_create_single_data("gps_state",
+				0, bp->proc, ptp_ocp_proc_gps_sync, bp);
+	proc_create_data("clock_source",
+			 0644, bp->proc, &ptp_ocp_proc_source_ops, bp);
+
+	return 0;
+}
+
+static int
+ptp_ocp_procfs_del(struct ptp_ocp *bp)
+{
+
+	mutex_lock(&ptp_ocp_lock);
+	idr_remove(&ptp_ocp_idr, bp->id);
+	mutex_unlock(&ptp_ocp_lock);
+
+	proc_remove(bp->proc);
+
+	return 0;
+}
+
+static void
+ptp_ocp_resource_summary(struct ptp_ocp *bp)
+{
+	struct device *dev = &bp->pdev->dev;
+
+	if (bp->image) {
+		u32 ver = bp->image->version;
+		dev_info(dev, "version %x\n", ver);
+		if (ver & 0xffff)
+			dev_info(dev, "regular image, version %d\n",
+				 ver & 0xffff);
+		else
+			dev_info(dev, "golden image, version %d\n",
+				 ver >> 16);
+	}
+	if (bp->gps_port != -1)
+		dev_info(dev, "GPS @ /dev/ttyS%d  115200\n", bp->gps_port);
+	if (bp->mac_port != -1)
+		dev_info(dev, "MAC @ /dev/ttyS%d   57600\n", bp->mac_port);
+}
+
+static void
+ptp_ocp_detach(struct ptp_ocp *bp)
+{
+
+	if (timer_pending(&bp->watchdog))
+		del_timer_sync(&bp->watchdog);
+	if (bp->id != -1)
+		ptp_ocp_procfs_del(bp);
+	if (bp->ts0)
+		ptp_ocp_unregister_ext(bp->ts0);
+	if (bp->ts1)
+		ptp_ocp_unregister_ext(bp->ts1);
+	if (bp->pps)
+		ptp_ocp_unregister_ext(bp->pps);
+	if (bp->gps_port != -1)
+		serial8250_unregister_port(bp->gps_port);
+	if (bp->mac_port != -1)
+		serial8250_unregister_port(bp->mac_port);
+	if (bp->spi_flash)
+		platform_device_unregister(bp->spi_flash);
+	if (bp->i2c_osc)
+		platform_device_unregister(bp->i2c_osc);
+	if (bp->i2c_clk)
+		clk_hw_unregister_fixed_rate(bp->i2c_clk);
+	if (bp->n_irqs)
+		pci_free_irq_vectors(bp->pdev);
+	if (bp->ptp)
+		ptp_clock_unregister(bp->ptp);
+	if (bp->health)
+		devlink_health_reporter_destroy(bp->health);
+}
+
 static int
 ptp_ocp_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 {
+	struct devlink *devlink;
 	struct ptp_ocp *bp;
 	int err;
 
-	bp = kzalloc(sizeof(*bp), GFP_KERNEL);
-	if (!bp)
+	devlink = devlink_alloc(&ptp_ocp_devlink_ops, sizeof(*bp));
+	if (!devlink) {
+		dev_err(&pdev->dev, "devlink_alloc failed\n");
 		return -ENOMEM;
+	}
+
+	err = ptp_ocp_devlink_register(devlink, &pdev->dev);
+	if (err)
+		goto out_free;
+
+	bp = devlink_priv(devlink);
+
+	bp->ptp_info = ptp_ocp_clock_info;
+	spin_lock_init(&bp->lock);
+	bp->gps_port = -1;
+	bp->mac_port = -1;
+	bp->id = -1;
 	bp->pdev = pdev;
+	bp->res_tbl = (struct ocp_resource *)id->driver_data;
+
 	pci_set_drvdata(pdev, bp);
 
 	err = pci_enable_device(pdev);
 	if (err) {
 		dev_err(&pdev->dev, "pci_enable_device\n");
-		goto out_free;
+		goto out_unregister;
 	}
 
-	err = pci_request_regions(pdev, KBUILD_MODNAME);
-	if (err) {
-		dev_err(&pdev->dev, "pci_request_region\n");
-		goto out_disable;
+	/* compat mode.
+	 * Older FPGA firmware only returns 2 irq's.
+	 * allow this - if not all of the IRQ's are returned, skip the
+	 * extra devices and just register the clock.
+	 */
+	err = pci_alloc_irq_vectors(pdev, 1, 10, PCI_IRQ_MSI | PCI_IRQ_MSIX);
+	if (err < 0) {
+		dev_err(&pdev->dev, "alloc_irq_vectors err: %d\n", err);
+		goto out;
 	}
+	bp->n_irqs = err;
+	pci_set_master(pdev);
 
-	bp->base = pci_ioremap_bar(pdev, 0);
-	if (!bp->base) {
-		dev_err(&pdev->dev, "io_remap bar0\n");
-		err = -ENOMEM;
-		goto out_release_regions;
-	}
-	bp->reg = bp->base + OCP_REGISTER_OFFSET;
-	bp->tod = bp->base + TOD_REGISTER_OFFSET;
-	bp->ptp_info = ptp_ocp_clock_info;
-	spin_lock_init(&bp->lock);
+	err = ptp_ocp_procfs_init(bp);
+	if (err)
+		goto out;
 
-	err = ptp_ocp_check_clock(bp);
+	err = ptp_ocp_register_resources(bp);
 	if (err)
 		goto out;
 
 	bp->ptp = ptp_clock_register(&bp->ptp_info, &pdev->dev);
 	if (IS_ERR(bp->ptp)) {
-		dev_err(&pdev->dev, "ptp_clock_register\n");
 		err = PTR_ERR(bp->ptp);
+		dev_err(&pdev->dev, "ptp_clock_register: %d\n", err);
+		bp->ptp = 0;
 		goto out;
 	}
 
+	err = ptp_ocp_procfs_complete(bp);
+	if (err)
+		goto out;
+
 	ptp_ocp_info(bp);
+	ptp_ocp_resource_summary(bp);
+	ptp_ocp_devlink_health_register(devlink);
 
 	return 0;
 
 out:
-	pci_iounmap(pdev, bp->base);
-out_release_regions:
-	pci_release_regions(pdev);
-out_disable:
+	ptp_ocp_detach(bp);
 	pci_disable_device(pdev);
+out_unregister:
+	pci_set_drvdata(pdev, NULL);
+	ptp_ocp_devlink_unregister(devlink);
 out_free:
-	kfree(bp);
+	devlink_free(devlink);
 
 	return err;
 }
@@ -362,13 +1533,14 @@ static void
 ptp_ocp_remove(struct pci_dev *pdev)
 {
 	struct ptp_ocp *bp = pci_get_drvdata(pdev);
+	struct devlink *devlink = priv_to_devlink(bp);
 
-	ptp_clock_unregister(bp->ptp);
-	pci_iounmap(pdev, bp->base);
-	pci_release_regions(pdev);
+	ptp_ocp_detach(bp);
 	pci_disable_device(pdev);
 	pci_set_drvdata(pdev, NULL);
-	kfree(bp);
+
+	ptp_ocp_devlink_unregister(devlink);
+	devlink_free(devlink);
 }
 
 static struct pci_driver ptp_ocp_driver = {
@@ -378,18 +1550,63 @@ static struct pci_driver ptp_ocp_driver = {
 	.remove		= ptp_ocp_remove,
 };
 
+static int
+ptp_ocp_i2c_notifier_call(struct notifier_block *nb,
+			  unsigned long action, void *data)
+{
+	struct device *dev = data;
+	struct ptp_ocp *bp;
+	char buf[32];
+	bool add;
+
+	switch (action) {
+	case BUS_NOTIFY_ADD_DEVICE:
+	case BUS_NOTIFY_DEL_DEVICE:
+		add = action == BUS_NOTIFY_ADD_DEVICE;
+		break;
+	default:
+		return 0;
+	}
+
+	if (!i2c_verify_adapter(dev))
+		return 0;
+
+	sprintf(buf, "/sys/bus/i2c/devices/%s", dev_name(dev));
+
+	while ((dev = dev->parent))
+		if (dev->driver && !strcmp(dev->driver->name, KBUILD_MODNAME))
+			goto found;
+	return 0;
+
+found:
+	bp = dev_get_drvdata(dev);
+	if (add)
+		bp->i2c_pde = proc_symlink("i2c", bp->proc, buf);
+	else {
+		proc_remove(bp->i2c_pde);
+		bp->i2c_pde = 0;
+	}
+
+	return 0;
+}
+
+static struct notifier_block ptp_ocp_i2c_notifier = {
+	.notifier_call = ptp_ocp_i2c_notifier_call,
+};
+
 static int __init
 ptp_ocp_init(void)
 {
 	int err;
 
-	err = pci_register_driver(&ptp_ocp_driver);
-	return err;
+	err = bus_register_notifier(&i2c_bus_type, &ptp_ocp_i2c_notifier);
+	return pci_register_driver(&ptp_ocp_driver);
 }
 
 static void __exit
 ptp_ocp_fini(void)
 {
+	bus_unregister_notifier(&i2c_bus_type, &ptp_ocp_i2c_notifier);
 	pci_unregister_driver(&ptp_ocp_driver);
 }
 
-- 
2.31.1

