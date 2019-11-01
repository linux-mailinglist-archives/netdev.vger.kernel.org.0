Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D5B96EBC52
	for <lists+netdev@lfdr.de>; Fri,  1 Nov 2019 04:21:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729678AbfKADVD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 31 Oct 2019 23:21:03 -0400
Received: from mxout2.idt.com ([157.165.5.26]:57590 "EHLO mxout2.idt.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726803AbfKADVC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 31 Oct 2019 23:21:02 -0400
Received: from mail3.idt.com (localhost [127.0.0.1])
        by mxout2.idt.com (8.14.4/8.14.4) with ESMTP id xA13Kpqf023020;
        Thu, 31 Oct 2019 20:20:51 -0700
Received: from corpml1.corp.idt.com (corpml1.corp.idt.com [157.165.140.20])
        by mail3.idt.com (8.14.4/8.14.4) with ESMTP id xA13Kohr004852;
        Thu, 31 Oct 2019 20:20:50 -0700
Received: from vcheng-VirtualBox.localdomain (corpimss2.corp.idt.com [157.165.141.30])
        by corpml1.corp.idt.com (8.11.7p1+Sun/8.11.7) with ESMTP id xA13KnV10344;
        Thu, 31 Oct 2019 20:20:49 -0700 (PDT)
From:   vincent.cheng.xh@renesas.com
To:     robh+dt@kernel.org, mark.rutland@arm.com, richardcochran@gmail.com
Cc:     devicetree@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Vincent Cheng <vincent.cheng.xh@renesas.com>
Subject: [PATCH v4 2/2] ptp: Add a ptp clock driver for IDT ClockMatrix.
Date:   Thu, 31 Oct 2019 23:20:07 -0400
Message-Id: <1572578407-32532-2-git-send-email-vincent.cheng.xh@renesas.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1572578407-32532-1-git-send-email-vincent.cheng.xh@renesas.com>
References: <1572578407-32532-1-git-send-email-vincent.cheng.xh@renesas.com>
X-TM-AS-MML: disable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vincent Cheng <vincent.cheng.xh@renesas.com>

The IDT ClockMatrix (TM) family includes integrated devices that provide
eight PLL channels.  Each PLL channel can be independently configured as a
frequency synthesizer, jitter attenuator, digitally controlled
oscillator (DCO), or a digital phase lock loop (DPLL).  Typically
these devices are used as timing references and clock sources for PTP
applications.  This patch adds support for the device.

Co-developed-by: Richard Cochran <richardcochran@gmail.com>
Signed-off-by: Richard Cochran <richardcochran@gmail.com>
Signed-off-by: Vincent Cheng <vincent.cheng.xh@renesas.com>
---
Changes since v3:
 - No changes

Changes since v2:
 - As suggested by Andrew Lunn:
   1. 'err' is an int, replace s32 with int.
   2. Return -EINVAL instead of -1
   3. Remove indirection that is used only for unit testing.

 - As suggested by Rob Herring:
   1. Remove '-ptp' from compatible string
   2. Replace wildcard 'x' with the part numbers.

Changes since v1:
 - Reported-by: kbuild test robot <lkp@intel.com>
   Fix ARCH=i386 build failure: ERROR: "__divdi3" undefined!

 - As suggested by Andrew Lunn:
   1. Replace pr_err with dev_err because we are an i2c device
   2. Replace set_current_state()+schedule_timeout() with
      msleep_interruptable()
   3. Downgrade pr_info to dev_dbg where appropriate
---
 drivers/ptp/Kconfig           |   12 +
 drivers/ptp/Makefile          |    1 +
 drivers/ptp/idt8a340_reg.h    |  659 +++++++++++++++++++
 drivers/ptp/ptp_clockmatrix.c | 1425 +++++++++++++++++++++++++++++++++++++++++
 drivers/ptp/ptp_clockmatrix.h |  104 +++
 5 files changed, 2201 insertions(+)
 create mode 100644 drivers/ptp/idt8a340_reg.h
 create mode 100644 drivers/ptp/ptp_clockmatrix.c
 create mode 100644 drivers/ptp/ptp_clockmatrix.h

diff --git a/drivers/ptp/Kconfig b/drivers/ptp/Kconfig
index 0517272..c48ad23 100644
--- a/drivers/ptp/Kconfig
+++ b/drivers/ptp/Kconfig
@@ -119,4 +119,16 @@ config PTP_1588_CLOCK_KVM
 	  To compile this driver as a module, choose M here: the module
 	  will be called ptp_kvm.
 
+config PTP_1588_CLOCK_IDTCM
+	tristate "IDT CLOCKMATRIX as PTP clock"
+	select PTP_1588_CLOCK
+	default n
+	help
+	  This driver adds support for using IDT CLOCKMATRIX(TM) as a PTP
+	  clock. This clock is only useful if your time stamping MAC
+	  is connected to the IDT chip.
+
+	  To compile this driver as a module, choose M here: the module
+	  will be called ptp_clockmatrix.
+
 endmenu
diff --git a/drivers/ptp/Makefile b/drivers/ptp/Makefile
index 677d1d1..69a06f8 100644
--- a/drivers/ptp/Makefile
+++ b/drivers/ptp/Makefile
@@ -12,3 +12,4 @@ obj-$(CONFIG_PTP_1588_CLOCK_KVM)	+= ptp_kvm.o
 obj-$(CONFIG_PTP_1588_CLOCK_QORIQ)	+= ptp-qoriq.o
 ptp-qoriq-y				+= ptp_qoriq.o
 ptp-qoriq-$(CONFIG_DEBUG_FS)		+= ptp_qoriq_debugfs.o
+obj-$(CONFIG_PTP_1588_CLOCK_IDTCM)	+= ptp_clockmatrix.o
\ No newline at end of file
diff --git a/drivers/ptp/idt8a340_reg.h b/drivers/ptp/idt8a340_reg.h
new file mode 100644
index 0000000..9263bc3
--- /dev/null
+++ b/drivers/ptp/idt8a340_reg.h
@@ -0,0 +1,659 @@
+/* SPDX-License-Identifier: GPL-2.0+ */
+/* idt8a340_reg.h
+ *
+ * Originally generated by regen.tcl on Thu Feb 14 19:23:44 PST 2019
+ * https://github.com/richardcochran/regen
+ *
+ * Hand modified to include some HW registers.
+ * Based on 4.8.0, SCSR rev C commit a03c7ae5
+ */
+#ifndef HAVE_IDT8A340_REG
+#define HAVE_IDT8A340_REG
+
+#define PAGE_ADDR_BASE                    0x0000
+#define PAGE_ADDR                         0x00fc
+
+#define HW_REVISION                       0x8180
+#define REV_ID                            0x007a
+
+#define HW_DPLL_0                         (0x8a00)
+#define HW_DPLL_1                         (0x8b00)
+#define HW_DPLL_2                         (0x8c00)
+#define HW_DPLL_3                         (0x8d00)
+
+#define HW_DPLL_TOD_SW_TRIG_ADDR__0       (0x080)
+#define HW_DPLL_TOD_CTRL_1                (0x089)
+#define HW_DPLL_TOD_CTRL_2                (0x08A)
+#define HW_DPLL_TOD_OVR__0                (0x098)
+#define HW_DPLL_TOD_OUT_0__0              (0x0B0)
+
+#define HW_Q0_Q1_CH_SYNC_CTRL_0           (0xa740)
+#define HW_Q0_Q1_CH_SYNC_CTRL_1           (0xa741)
+#define HW_Q2_Q3_CH_SYNC_CTRL_0           (0xa742)
+#define HW_Q2_Q3_CH_SYNC_CTRL_1           (0xa743)
+#define HW_Q4_Q5_CH_SYNC_CTRL_0           (0xa744)
+#define HW_Q4_Q5_CH_SYNC_CTRL_1           (0xa745)
+#define HW_Q6_Q7_CH_SYNC_CTRL_0           (0xa746)
+#define HW_Q6_Q7_CH_SYNC_CTRL_1           (0xa747)
+#define HW_Q8_CH_SYNC_CTRL_0              (0xa748)
+#define HW_Q8_CH_SYNC_CTRL_1              (0xa749)
+#define HW_Q9_CH_SYNC_CTRL_0              (0xa74a)
+#define HW_Q9_CH_SYNC_CTRL_1              (0xa74b)
+#define HW_Q10_CH_SYNC_CTRL_0             (0xa74c)
+#define HW_Q10_CH_SYNC_CTRL_1             (0xa74d)
+#define HW_Q11_CH_SYNC_CTRL_0             (0xa74e)
+#define HW_Q11_CH_SYNC_CTRL_1             (0xa74f)
+
+#define SYNC_SOURCE_DPLL0_TOD_PPS	0x14
+#define SYNC_SOURCE_DPLL1_TOD_PPS	0x15
+#define SYNC_SOURCE_DPLL2_TOD_PPS	0x16
+#define SYNC_SOURCE_DPLL3_TOD_PPS	0x17
+
+#define SYNCTRL1_MASTER_SYNC_RST	BIT(7)
+#define SYNCTRL1_MASTER_SYNC_TRIG	BIT(5)
+#define SYNCTRL1_TOD_SYNC_TRIG		BIT(4)
+#define SYNCTRL1_FBDIV_FRAME_SYNC_TRIG	BIT(3)
+#define SYNCTRL1_FBDIV_SYNC_TRIG	BIT(2)
+#define SYNCTRL1_Q1_DIV_SYNC_TRIG	BIT(1)
+#define SYNCTRL1_Q0_DIV_SYNC_TRIG	BIT(0)
+
+#define RESET_CTRL                        0xc000
+#define SM_RESET                          0x0012
+#define SM_RESET_CMD                      0x5A
+
+#define GENERAL_STATUS                    0xc014
+#define HW_REV_ID                         0x000A
+#define BOND_ID                           0x000B
+#define HW_CSR_ID                         0x000C
+#define HW_IRQ_ID                         0x000E
+
+#define MAJ_REL                           0x0010
+#define MIN_REL                           0x0011
+#define HOTFIX_REL                        0x0012
+
+#define PIPELINE_ID                       0x0014
+#define BUILD_ID                          0x0018
+
+#define JTAG_DEVICE_ID                    0x001c
+#define PRODUCT_ID                        0x001e
+
+#define STATUS                            0xc03c
+#define USER_GPIO0_TO_7_STATUS            0x008a
+#define USER_GPIO8_TO_15_STATUS           0x008b
+
+#define GPIO_USER_CONTROL                 0xc160
+#define GPIO0_TO_7_OUT                    0x0000
+#define GPIO8_TO_15_OUT                   0x0001
+
+#define STICKY_STATUS_CLEAR               0xc164
+
+#define GPIO_TOD_NOTIFICATION_CLEAR       0xc16c
+
+#define ALERT_CFG                         0xc188
+
+#define SYS_DPLL_XO                       0xc194
+
+#define SYS_APLL                          0xc19c
+
+#define INPUT_0                           0xc1b0
+
+#define INPUT_1                           0xc1c0
+
+#define INPUT_2                           0xc1d0
+
+#define INPUT_3                           0xc200
+
+#define INPUT_4                           0xc210
+
+#define INPUT_5                           0xc220
+
+#define INPUT_6                           0xc230
+
+#define INPUT_7                           0xc240
+
+#define INPUT_8                           0xc250
+
+#define INPUT_9                           0xc260
+
+#define INPUT_10                          0xc280
+
+#define INPUT_11                          0xc290
+
+#define INPUT_12                          0xc2a0
+
+#define INPUT_13                          0xc2b0
+
+#define INPUT_14                          0xc2c0
+
+#define INPUT_15                          0xc2d0
+
+#define REF_MON_0                         0xc2e0
+
+#define REF_MON_1                         0xc2ec
+
+#define REF_MON_2                         0xc300
+
+#define REF_MON_3                         0xc30c
+
+#define REF_MON_4                         0xc318
+
+#define REF_MON_5                         0xc324
+
+#define REF_MON_6                         0xc330
+
+#define REF_MON_7                         0xc33c
+
+#define REF_MON_8                         0xc348
+
+#define REF_MON_9                         0xc354
+
+#define REF_MON_10                        0xc360
+
+#define REF_MON_11                        0xc36c
+
+#define REF_MON_12                        0xc380
+
+#define REF_MON_13                        0xc38c
+
+#define REF_MON_14                        0xc398
+
+#define REF_MON_15                        0xc3a4
+
+#define DPLL_0                            0xc3b0
+#define DPLL_CTRL_REG_0                   0x0002
+#define DPLL_CTRL_REG_1                   0x0003
+#define DPLL_CTRL_REG_2                   0x0004
+#define DPLL_TOD_SYNC_CFG                 0x0031
+#define DPLL_COMBO_SLAVE_CFG_0            0x0032
+#define DPLL_COMBO_SLAVE_CFG_1            0x0033
+#define DPLL_SLAVE_REF_CFG                0x0034
+#define DPLL_REF_MODE                     0x0035
+#define DPLL_PHASE_MEASUREMENT_CFG        0x0036
+#define DPLL_MODE                         0x0037
+
+#define DPLL_1                            0xc400
+
+#define DPLL_2                            0xc438
+
+#define DPLL_3                            0xc480
+
+#define DPLL_4                            0xc4b8
+
+#define DPLL_5                            0xc500
+
+#define DPLL_6                            0xc538
+
+#define DPLL_7                            0xc580
+
+#define SYS_DPLL                          0xc5b8
+
+#define DPLL_CTRL_0                       0xc600
+#define DPLL_CTRL_DPLL_MANU_REF_CFG       0x0001
+
+#define DPLL_CTRL_1                       0xc63c
+
+#define DPLL_CTRL_2                       0xc680
+
+#define DPLL_CTRL_3                       0xc6bc
+
+#define DPLL_CTRL_4                       0xc700
+
+#define DPLL_CTRL_5                       0xc73c
+
+#define DPLL_CTRL_6                       0xc780
+
+#define DPLL_CTRL_7                       0xc7bc
+
+#define SYS_DPLL_CTRL                     0xc800
+
+#define DPLL_PHASE_0                      0xc818
+
+/* Signed 42-bit FFO in units of 2^(-53) */
+#define DPLL_WR_PHASE                     0x0000
+
+#define DPLL_PHASE_1                      0xc81c
+
+#define DPLL_PHASE_2                      0xc820
+
+#define DPLL_PHASE_3                      0xc824
+
+#define DPLL_PHASE_4                      0xc828
+
+#define DPLL_PHASE_5                      0xc82c
+
+#define DPLL_PHASE_6                      0xc830
+
+#define DPLL_PHASE_7                      0xc834
+
+#define DPLL_FREQ_0                       0xc838
+
+/* Signed 42-bit FFO in units of 2^(-53) */
+#define DPLL_WR_FREQ                      0x0000
+
+#define DPLL_FREQ_1                       0xc840
+
+#define DPLL_FREQ_2                       0xc848
+
+#define DPLL_FREQ_3                       0xc850
+
+#define DPLL_FREQ_4                       0xc858
+
+#define DPLL_FREQ_5                       0xc860
+
+#define DPLL_FREQ_6                       0xc868
+
+#define DPLL_FREQ_7                       0xc870
+
+#define DPLL_PHASE_PULL_IN_0              0xc880
+#define PULL_IN_OFFSET                    0x0000 /* Signed 32 bit */
+#define PULL_IN_SLOPE_LIMIT               0x0004 /* Unsigned 24 bit */
+#define PULL_IN_CTRL                      0x0007
+
+#define DPLL_PHASE_PULL_IN_1              0xc888
+
+#define DPLL_PHASE_PULL_IN_2              0xc890
+
+#define DPLL_PHASE_PULL_IN_3              0xc898
+
+#define DPLL_PHASE_PULL_IN_4              0xc8a0
+
+#define DPLL_PHASE_PULL_IN_5              0xc8a8
+
+#define DPLL_PHASE_PULL_IN_6              0xc8b0
+
+#define DPLL_PHASE_PULL_IN_7              0xc8b8
+
+#define GPIO_CFG                          0xc8c0
+#define GPIO_CFG_GBL                      0x0000
+
+#define GPIO_0                            0xc8c2
+#define GPIO_DCO_INC_DEC                  0x0000
+#define GPIO_OUT_CTRL_0                   0x0001
+#define GPIO_OUT_CTRL_1                   0x0002
+#define GPIO_TOD_TRIG                     0x0003
+#define GPIO_DPLL_INDICATOR               0x0004
+#define GPIO_LOS_INDICATOR                0x0005
+#define GPIO_REF_INPUT_DSQ_0              0x0006
+#define GPIO_REF_INPUT_DSQ_1              0x0007
+#define GPIO_REF_INPUT_DSQ_2              0x0008
+#define GPIO_REF_INPUT_DSQ_3              0x0009
+#define GPIO_MAN_CLK_SEL_0                0x000a
+#define GPIO_MAN_CLK_SEL_1                0x000b
+#define GPIO_MAN_CLK_SEL_2                0x000c
+#define GPIO_SLAVE                        0x000d
+#define GPIO_ALERT_OUT_CFG                0x000e
+#define GPIO_TOD_NOTIFICATION_CFG         0x000f
+#define GPIO_CTRL                         0x0010
+
+#define GPIO_1                            0xc8d4
+
+#define GPIO_2                            0xc8e6
+
+#define GPIO_3                            0xc900
+
+#define GPIO_4                            0xc912
+
+#define GPIO_5                            0xc924
+
+#define GPIO_6                            0xc936
+
+#define GPIO_7                            0xc948
+
+#define GPIO_8                            0xc95a
+
+#define GPIO_9                            0xc980
+
+#define GPIO_10                           0xc992
+
+#define GPIO_11                           0xc9a4
+
+#define GPIO_12                           0xc9b6
+
+#define GPIO_13                           0xc9c8
+
+#define GPIO_14                           0xc9da
+
+#define GPIO_15                           0xca00
+
+#define OUT_DIV_MUX                       0xca12
+
+#define OUTPUT_0                          0xca14
+/* FOD frequency output divider value */
+#define OUT_DIV                           0x0000
+#define OUT_DUTY_CYCLE_HIGH               0x0004
+#define OUT_CTRL_0                        0x0008
+#define OUT_CTRL_1                        0x0009
+/* Phase adjustment in FOD cycles */
+#define OUT_PHASE_ADJ                     0x000c
+
+#define OUTPUT_1                          0xca24
+
+#define OUTPUT_2                          0xca34
+
+#define OUTPUT_3                          0xca44
+
+#define OUTPUT_4                          0xca54
+
+#define OUTPUT_5                          0xca64
+
+#define OUTPUT_6                          0xca80
+
+#define OUTPUT_7                          0xca90
+
+#define OUTPUT_8                          0xcaa0
+
+#define OUTPUT_9                          0xcab0
+
+#define OUTPUT_10                         0xcac0
+
+#define OUTPUT_11                         0xcad0
+
+#define SERIAL                            0xcae0
+
+#define PWM_ENCODER_0                     0xcb00
+
+#define PWM_ENCODER_1                     0xcb08
+
+#define PWM_ENCODER_2                     0xcb10
+
+#define PWM_ENCODER_3                     0xcb18
+
+#define PWM_ENCODER_4                     0xcb20
+
+#define PWM_ENCODER_5                     0xcb28
+
+#define PWM_ENCODER_6                     0xcb30
+
+#define PWM_ENCODER_7                     0xcb38
+
+#define PWM_DECODER_0                     0xcb40
+
+#define PWM_DECODER_1                     0xcb48
+
+#define PWM_DECODER_2                     0xcb50
+
+#define PWM_DECODER_3                     0xcb58
+
+#define PWM_DECODER_4                     0xcb60
+
+#define PWM_DECODER_5                     0xcb68
+
+#define PWM_DECODER_6                     0xcb70
+
+#define PWM_DECODER_7                     0xcb80
+
+#define PWM_DECODER_8                     0xcb88
+
+#define PWM_DECODER_9                     0xcb90
+
+#define PWM_DECODER_10                    0xcb98
+
+#define PWM_DECODER_11                    0xcba0
+
+#define PWM_DECODER_12                    0xcba8
+
+#define PWM_DECODER_13                    0xcbb0
+
+#define PWM_DECODER_14                    0xcbb8
+
+#define PWM_DECODER_15                    0xcbc0
+
+#define PWM_USER_DATA                     0xcbc8
+
+#define TOD_0                             0xcbcc
+
+/* Enable TOD counter, output channel sync and even-PPS mode */
+#define TOD_CFG                           0x0000
+
+#define TOD_1                             0xcbce
+
+#define TOD_2                             0xcbd0
+
+#define TOD_3                             0xcbd2
+
+
+#define TOD_WRITE_0                       0xcc00
+/* 8-bit subns, 32-bit ns, 48-bit seconds */
+#define TOD_WRITE                         0x0000
+/* Counter increments after TOD write is completed */
+#define TOD_WRITE_COUNTER                 0x000c
+/* TOD write trigger configuration */
+#define TOD_WRITE_SELECT_CFG_0            0x000d
+/* TOD write trigger selection */
+#define TOD_WRITE_CMD                     0x000f
+
+#define TOD_WRITE_1                       0xcc10
+
+#define TOD_WRITE_2                       0xcc20
+
+#define TOD_WRITE_3                       0xcc30
+
+#define TOD_READ_PRIMARY_0                0xcc40
+/* 8-bit subns, 32-bit ns, 48-bit seconds */
+#define TOD_READ_PRIMARY                  0x0000
+/* Counter increments after TOD write is completed */
+#define TOD_READ_PRIMARY_COUNTER          0x000b
+/* Read trigger configuration */
+#define TOD_READ_PRIMARY_SEL_CFG_0        0x000c
+/* Read trigger selection */
+#define TOD_READ_PRIMARY_CMD              0x000e
+
+#define TOD_READ_PRIMARY_1                0xcc50
+
+#define TOD_READ_PRIMARY_2                0xcc60
+
+#define TOD_READ_PRIMARY_3                0xcc80
+
+#define TOD_READ_SECONDARY_0              0xcc90
+
+#define TOD_READ_SECONDARY_1              0xcca0
+
+#define TOD_READ_SECONDARY_2              0xccb0
+
+#define TOD_READ_SECONDARY_3              0xccc0
+
+#define OUTPUT_TDC_CFG                    0xccd0
+
+#define OUTPUT_TDC_0                      0xcd00
+
+#define OUTPUT_TDC_1                      0xcd08
+
+#define OUTPUT_TDC_2                      0xcd10
+
+#define OUTPUT_TDC_3                      0xcd18
+
+#define INPUT_TDC                         0xcd20
+
+#define SCRATCH                           0xcf50
+
+#define EEPROM                            0xcf68
+
+#define OTP                               0xcf70
+
+#define BYTE                              0xcf80
+
+/* Bit definitions for the MAJ_REL register */
+#define MAJOR_SHIFT                       (1)
+#define MAJOR_MASK                        (0x7f)
+#define PR_BUILD                          BIT(0)
+
+/* Bit definitions for the USER_GPIO0_TO_7_STATUS register */
+#define GPIO0_LEVEL                       BIT(0)
+#define GPIO1_LEVEL                       BIT(1)
+#define GPIO2_LEVEL                       BIT(2)
+#define GPIO3_LEVEL                       BIT(3)
+#define GPIO4_LEVEL                       BIT(4)
+#define GPIO5_LEVEL                       BIT(5)
+#define GPIO6_LEVEL                       BIT(6)
+#define GPIO7_LEVEL                       BIT(7)
+
+/* Bit definitions for the USER_GPIO8_TO_15_STATUS register */
+#define GPIO8_LEVEL                       BIT(0)
+#define GPIO9_LEVEL                       BIT(1)
+#define GPIO10_LEVEL                      BIT(2)
+#define GPIO11_LEVEL                      BIT(3)
+#define GPIO12_LEVEL                      BIT(4)
+#define GPIO13_LEVEL                      BIT(5)
+#define GPIO14_LEVEL                      BIT(6)
+#define GPIO15_LEVEL                      BIT(7)
+
+/* Bit definitions for the GPIO0_TO_7_OUT register */
+#define GPIO0_DRIVE_LEVEL                 BIT(0)
+#define GPIO1_DRIVE_LEVEL                 BIT(1)
+#define GPIO2_DRIVE_LEVEL                 BIT(2)
+#define GPIO3_DRIVE_LEVEL                 BIT(3)
+#define GPIO4_DRIVE_LEVEL                 BIT(4)
+#define GPIO5_DRIVE_LEVEL                 BIT(5)
+#define GPIO6_DRIVE_LEVEL                 BIT(6)
+#define GPIO7_DRIVE_LEVEL                 BIT(7)
+
+/* Bit definitions for the GPIO8_TO_15_OUT register */
+#define GPIO8_DRIVE_LEVEL                 BIT(0)
+#define GPIO9_DRIVE_LEVEL                 BIT(1)
+#define GPIO10_DRIVE_LEVEL                BIT(2)
+#define GPIO11_DRIVE_LEVEL                BIT(3)
+#define GPIO12_DRIVE_LEVEL                BIT(4)
+#define GPIO13_DRIVE_LEVEL                BIT(5)
+#define GPIO14_DRIVE_LEVEL                BIT(6)
+#define GPIO15_DRIVE_LEVEL                BIT(7)
+
+/* Bit definitions for the DPLL_TOD_SYNC_CFG register */
+#define TOD_SYNC_SOURCE_SHIFT             (1)
+#define TOD_SYNC_SOURCE_MASK              (0x3)
+#define TOD_SYNC_EN                       BIT(0)
+
+/* Bit definitions for the DPLL_MODE register */
+#define WRITE_TIMER_MODE                  BIT(6)
+#define PLL_MODE_SHIFT                    (3)
+#define PLL_MODE_MASK                     (0x7)
+#define STATE_MODE_SHIFT                  (0)
+#define STATE_MODE_MASK                   (0x7)
+
+/* Bit definitions for the GPIO_CFG_GBL register */
+#define SUPPLY_MODE_SHIFT                 (0)
+#define SUPPLY_MODE_MASK                  (0x3)
+
+/* Bit definitions for the GPIO_DCO_INC_DEC register */
+#define INCDEC_DPLL_INDEX_SHIFT           (0)
+#define INCDEC_DPLL_INDEX_MASK            (0x7)
+
+/* Bit definitions for the GPIO_OUT_CTRL_0 register */
+#define CTRL_OUT_0                        BIT(0)
+#define CTRL_OUT_1                        BIT(1)
+#define CTRL_OUT_2                        BIT(2)
+#define CTRL_OUT_3                        BIT(3)
+#define CTRL_OUT_4                        BIT(4)
+#define CTRL_OUT_5                        BIT(5)
+#define CTRL_OUT_6                        BIT(6)
+#define CTRL_OUT_7                        BIT(7)
+
+/* Bit definitions for the GPIO_OUT_CTRL_1 register */
+#define CTRL_OUT_8                        BIT(0)
+#define CTRL_OUT_9                        BIT(1)
+#define CTRL_OUT_10                       BIT(2)
+#define CTRL_OUT_11                       BIT(3)
+#define CTRL_OUT_12                       BIT(4)
+#define CTRL_OUT_13                       BIT(5)
+#define CTRL_OUT_14                       BIT(6)
+#define CTRL_OUT_15                       BIT(7)
+
+/* Bit definitions for the GPIO_TOD_TRIG register */
+#define TOD_TRIG_0                        BIT(0)
+#define TOD_TRIG_1                        BIT(1)
+#define TOD_TRIG_2                        BIT(2)
+#define TOD_TRIG_3                        BIT(3)
+
+/* Bit definitions for the GPIO_DPLL_INDICATOR register */
+#define IND_DPLL_INDEX_SHIFT              (0)
+#define IND_DPLL_INDEX_MASK               (0x7)
+
+/* Bit definitions for the GPIO_LOS_INDICATOR register */
+#define REFMON_INDEX_SHIFT                (0)
+#define REFMON_INDEX_MASK                 (0xf)
+/* Active level of LOS indicator, 0=low 1=high */
+#define ACTIVE_LEVEL                      BIT(4)
+
+/* Bit definitions for the GPIO_REF_INPUT_DSQ_0 register */
+#define DSQ_INP_0                         BIT(0)
+#define DSQ_INP_1                         BIT(1)
+#define DSQ_INP_2                         BIT(2)
+#define DSQ_INP_3                         BIT(3)
+#define DSQ_INP_4                         BIT(4)
+#define DSQ_INP_5                         BIT(5)
+#define DSQ_INP_6                         BIT(6)
+#define DSQ_INP_7                         BIT(7)
+
+/* Bit definitions for the GPIO_REF_INPUT_DSQ_1 register */
+#define DSQ_INP_8                         BIT(0)
+#define DSQ_INP_9                         BIT(1)
+#define DSQ_INP_10                        BIT(2)
+#define DSQ_INP_11                        BIT(3)
+#define DSQ_INP_12                        BIT(4)
+#define DSQ_INP_13                        BIT(5)
+#define DSQ_INP_14                        BIT(6)
+#define DSQ_INP_15                        BIT(7)
+
+/* Bit definitions for the GPIO_REF_INPUT_DSQ_2 register */
+#define DSQ_DPLL_0                        BIT(0)
+#define DSQ_DPLL_1                        BIT(1)
+#define DSQ_DPLL_2                        BIT(2)
+#define DSQ_DPLL_3                        BIT(3)
+#define DSQ_DPLL_4                        BIT(4)
+#define DSQ_DPLL_5                        BIT(5)
+#define DSQ_DPLL_6                        BIT(6)
+#define DSQ_DPLL_7                        BIT(7)
+
+/* Bit definitions for the GPIO_REF_INPUT_DSQ_3 register */
+#define DSQ_DPLL_SYS                      BIT(0)
+#define GPIO_DSQ_LEVEL                    BIT(1)
+
+/* Bit definitions for the GPIO_TOD_NOTIFICATION_CFG register */
+#define DPLL_TOD_SHIFT                    (0)
+#define DPLL_TOD_MASK                     (0x3)
+#define TOD_READ_SECONDARY                BIT(2)
+#define GPIO_ASSERT_LEVEL                 BIT(3)
+
+/* Bit definitions for the GPIO_CTRL register */
+#define GPIO_FUNCTION_EN                  BIT(0)
+#define GPIO_CMOS_OD_MODE                 BIT(1)
+#define GPIO_CONTROL_DIR                  BIT(2)
+#define GPIO_PU_PD_MODE                   BIT(3)
+#define GPIO_FUNCTION_SHIFT               (4)
+#define GPIO_FUNCTION_MASK                (0xf)
+
+/* Bit definitions for the OUT_CTRL_1 register */
+#define OUT_SYNC_DISABLE                  BIT(7)
+#define SQUELCH_VALUE                     BIT(6)
+#define SQUELCH_DISABLE                   BIT(5)
+#define PAD_VDDO_SHIFT                    (2)
+#define PAD_VDDO_MASK                     (0x7)
+#define PAD_CMOSDRV_SHIFT                 (0)
+#define PAD_CMOSDRV_MASK                  (0x3)
+
+/* Bit definitions for the TOD_CFG register */
+#define TOD_EVEN_PPS_MODE                 BIT(2)
+#define TOD_OUT_SYNC_ENABLE               BIT(1)
+#define TOD_ENABLE                        BIT(0)
+
+/* Bit definitions for the TOD_WRITE_SELECT_CFG_0 register */
+#define WR_PWM_DECODER_INDEX_SHIFT        (4)
+#define WR_PWM_DECODER_INDEX_MASK         (0xf)
+#define WR_REF_INDEX_SHIFT                (0)
+#define WR_REF_INDEX_MASK                 (0xf)
+
+/* Bit definitions for the TOD_WRITE_CMD register */
+#define TOD_WRITE_SELECTION_SHIFT         (0)
+#define TOD_WRITE_SELECTION_MASK          (0xf)
+
+/* Bit definitions for the TOD_READ_PRIMARY_SEL_CFG_0 register */
+#define RD_PWM_DECODER_INDEX_SHIFT        (4)
+#define RD_PWM_DECODER_INDEX_MASK         (0xf)
+#define RD_REF_INDEX_SHIFT                (0)
+#define RD_REF_INDEX_MASK                 (0xf)
+
+/* Bit definitions for the TOD_READ_PRIMARY_CMD register */
+#define TOD_READ_TRIGGER_MODE             BIT(4)
+#define TOD_READ_TRIGGER_SHIFT            (0)
+#define TOD_READ_TRIGGER_MASK             (0xf)
+
+#endif
diff --git a/drivers/ptp/ptp_clockmatrix.c b/drivers/ptp/ptp_clockmatrix.c
new file mode 100644
index 0000000..cf5889b
--- /dev/null
+++ b/drivers/ptp/ptp_clockmatrix.c
@@ -0,0 +1,1425 @@
+// SPDX-License-Identifier: GPL-2.0+
+/*
+ * PTP hardware clock driver for the IDT ClockMatrix(TM) family of timing and
+ * synchronization devices.
+ *
+ * Copyright (C) 2019 Integrated Device Technology, Inc., a Renesas Company.
+ */
+#include <linux/firmware.h>
+#include <linux/i2c.h>
+#include <linux/module.h>
+#include <linux/ptp_clock_kernel.h>
+#include <linux/delay.h>
+#include <linux/kernel.h>
+#include <linux/timekeeping.h>
+
+#include "ptp_private.h"
+#include "ptp_clockmatrix.h"
+
+MODULE_DESCRIPTION("Driver for IDT ClockMatrix(TM) family");
+MODULE_AUTHOR("Richard Cochran <richardcochran@gmail.com>");
+MODULE_AUTHOR("IDT support-1588 <IDT-support-1588@lm.renesas.com>");
+MODULE_VERSION("1.0");
+MODULE_LICENSE("GPL");
+
+#define SETTIME_CORRECTION (0)
+
+static int char_array_to_timespec(u8 *buf,
+				  u8 count,
+				  struct timespec64 *ts)
+{
+	u8 i;
+	u64 nsec;
+	time64_t sec;
+
+	if (count < TOD_BYTE_COUNT)
+		return 1;
+
+	/* Sub-nanoseconds are in buf[0]. */
+	nsec = buf[4];
+	for (i = 0; i < 3; i++) {
+		nsec <<= 8;
+		nsec |= buf[3 - i];
+	}
+
+	sec = buf[10];
+	for (i = 0; i < 5; i++) {
+		sec <<= 8;
+		sec |= buf[9 - i];
+	}
+
+	ts->tv_sec = sec;
+	ts->tv_nsec = nsec;
+
+	return 0;
+}
+
+static int timespec_to_char_array(struct timespec64 const *ts,
+				  u8 *buf,
+				  u8 count)
+{
+	u8 i;
+	s32 nsec;
+	time64_t sec;
+
+	if (count < TOD_BYTE_COUNT)
+		return 1;
+
+	nsec = ts->tv_nsec;
+	sec = ts->tv_sec;
+
+	/* Sub-nanoseconds are in buf[0]. */
+	buf[0] = 0;
+	for (i = 1; i < 5; i++) {
+		buf[i] = nsec & 0xff;
+		nsec >>= 8;
+	}
+
+	for (i = 5; i < TOD_BYTE_COUNT; i++) {
+
+		buf[i] = sec & 0xff;
+		sec >>= 8;
+	}
+
+	return 0;
+}
+
+static int idtcm_xfer(struct idtcm *idtcm,
+		      u8 regaddr,
+		      u8 *buf,
+		      u16 count,
+		      bool write)
+{
+	struct i2c_client *client = idtcm->client;
+	struct i2c_msg msg[2];
+	int cnt;
+
+	msg[0].addr = client->addr;
+	msg[0].flags = 0;
+	msg[0].len = 1;
+	msg[0].buf = &regaddr;
+
+	msg[1].addr = client->addr;
+	msg[1].flags = write ? 0 : I2C_M_RD;
+	msg[1].len = count;
+	msg[1].buf = buf;
+
+	cnt = i2c_transfer(client->adapter, msg, 2);
+
+	if (cnt < 0) {
+		dev_err(&client->dev, "i2c_transfer returned %d\n", cnt);
+		return cnt;
+	} else if (cnt != 2) {
+		dev_err(&client->dev,
+			"i2c_transfer sent only %d of %d messages\n", cnt, 2);
+		return -EIO;
+	}
+
+	return 0;
+}
+
+static int idtcm_page_offset(struct idtcm *idtcm, u8 val)
+{
+	u8 buf[4];
+	int err;
+
+	if (idtcm->page_offset == val)
+		return 0;
+
+	buf[0] = 0x0;
+	buf[1] = val;
+	buf[2] = 0x10;
+	buf[3] = 0x20;
+
+	err = idtcm_xfer(idtcm, PAGE_ADDR, buf, sizeof(buf), 1);
+
+	if (err)
+		dev_err(&idtcm->client->dev, "failed to set page offset\n");
+	else
+		idtcm->page_offset = val;
+
+	return err;
+}
+
+static int _idtcm_rdwr(struct idtcm *idtcm,
+		       u16 regaddr,
+		       u8 *buf,
+		       u16 count,
+		       bool write)
+{
+	u8 hi;
+	u8 lo;
+	int err;
+
+	hi = (regaddr >> 8) & 0xff;
+	lo = regaddr & 0xff;
+
+	err = idtcm_page_offset(idtcm, hi);
+
+	if (err)
+		goto out;
+
+	err = idtcm_xfer(idtcm, lo, buf, count, write);
+out:
+	return err;
+}
+
+static int idtcm_read(struct idtcm *idtcm,
+		      u16 module,
+		      u16 regaddr,
+		      u8 *buf,
+		      u16 count)
+{
+	return _idtcm_rdwr(idtcm, module + regaddr, buf, count, false);
+}
+
+static int idtcm_write(struct idtcm *idtcm,
+		       u16 module,
+		       u16 regaddr,
+		       u8 *buf,
+		       u16 count)
+{
+	return _idtcm_rdwr(idtcm, module + regaddr, buf, count, true);
+}
+
+static int _idtcm_gettime(struct idtcm_channel *channel,
+			  struct timespec64 *ts)
+{
+	struct idtcm *idtcm = channel->idtcm;
+	u8 buf[TOD_BYTE_COUNT];
+	u8 trigger;
+	int err;
+
+	err = idtcm_read(idtcm, channel->tod_read_primary,
+			 TOD_READ_PRIMARY_CMD, &trigger, sizeof(trigger));
+	if (err)
+		return err;
+
+	trigger &= ~(TOD_READ_TRIGGER_MASK << TOD_READ_TRIGGER_SHIFT);
+	trigger |= (1 << TOD_READ_TRIGGER_SHIFT);
+	trigger |= TOD_READ_TRIGGER_MODE;
+
+	err = idtcm_write(idtcm, channel->tod_read_primary,
+			  TOD_READ_PRIMARY_CMD, &trigger, sizeof(trigger));
+
+	if (err)
+		return err;
+
+	if (idtcm->calculate_overhead_flag)
+		idtcm->start_time = ktime_get_raw();
+
+	err = idtcm_read(idtcm, channel->tod_read_primary,
+			 TOD_READ_PRIMARY, buf, sizeof(buf));
+
+	if (err)
+		return err;
+
+	err = char_array_to_timespec(buf, sizeof(buf), ts);
+
+	return err;
+}
+
+static int _sync_pll_output(struct idtcm *idtcm,
+			    u8 pll,
+			    u8 sync_src,
+			    u8 qn,
+			    u8 qn_plus_1)
+{
+	int err;
+	u8 val;
+	u16 sync_ctrl0;
+	u16 sync_ctrl1;
+
+	if ((qn == 0) && (qn_plus_1 == 0))
+		return 0;
+
+	switch (pll) {
+	case 0:
+		sync_ctrl0 = HW_Q0_Q1_CH_SYNC_CTRL_0;
+		sync_ctrl1 = HW_Q0_Q1_CH_SYNC_CTRL_1;
+		break;
+	case 1:
+		sync_ctrl0 = HW_Q2_Q3_CH_SYNC_CTRL_0;
+		sync_ctrl1 = HW_Q2_Q3_CH_SYNC_CTRL_1;
+		break;
+	case 2:
+		sync_ctrl0 = HW_Q4_Q5_CH_SYNC_CTRL_0;
+		sync_ctrl1 = HW_Q4_Q5_CH_SYNC_CTRL_1;
+		break;
+	case 3:
+		sync_ctrl0 = HW_Q6_Q7_CH_SYNC_CTRL_0;
+		sync_ctrl1 = HW_Q6_Q7_CH_SYNC_CTRL_1;
+		break;
+	case 4:
+		sync_ctrl0 = HW_Q8_CH_SYNC_CTRL_0;
+		sync_ctrl1 = HW_Q8_CH_SYNC_CTRL_1;
+		break;
+	case 5:
+		sync_ctrl0 = HW_Q9_CH_SYNC_CTRL_0;
+		sync_ctrl1 = HW_Q9_CH_SYNC_CTRL_1;
+		break;
+	case 6:
+		sync_ctrl0 = HW_Q10_CH_SYNC_CTRL_0;
+		sync_ctrl1 = HW_Q10_CH_SYNC_CTRL_1;
+		break;
+	case 7:
+		sync_ctrl0 = HW_Q11_CH_SYNC_CTRL_0;
+		sync_ctrl1 = HW_Q11_CH_SYNC_CTRL_1;
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	val = SYNCTRL1_MASTER_SYNC_RST;
+
+	/* Place master sync in reset */
+	err = idtcm_write(idtcm, 0, sync_ctrl1, &val, sizeof(val));
+	if (err)
+		return err;
+
+	err = idtcm_write(idtcm, 0, sync_ctrl0, &sync_src, sizeof(sync_src));
+	if (err)
+		return err;
+
+	/* Set sync trigger mask */
+	val |= SYNCTRL1_FBDIV_FRAME_SYNC_TRIG | SYNCTRL1_FBDIV_SYNC_TRIG;
+
+	if (qn)
+		val |= SYNCTRL1_Q0_DIV_SYNC_TRIG;
+
+	if (qn_plus_1)
+		val |= SYNCTRL1_Q1_DIV_SYNC_TRIG;
+
+	err = idtcm_write(idtcm, 0, sync_ctrl1, &val, sizeof(val));
+	if (err)
+		return err;
+
+	/* Place master sync out of reset */
+	val &= ~(SYNCTRL1_MASTER_SYNC_RST);
+	err = idtcm_write(idtcm, 0, sync_ctrl1, &val, sizeof(val));
+
+	return err;
+}
+
+static int idtcm_sync_pps_output(struct idtcm_channel *channel)
+{
+	struct idtcm *idtcm = channel->idtcm;
+
+	u8 pll;
+	u8 sync_src;
+	u8 qn;
+	u8 qn_plus_1;
+	int err = 0;
+
+	u16 output_mask = channel->output_mask;
+
+	switch (channel->dpll_n) {
+	case DPLL_0:
+		sync_src = SYNC_SOURCE_DPLL0_TOD_PPS;
+		break;
+	case DPLL_1:
+		sync_src = SYNC_SOURCE_DPLL1_TOD_PPS;
+		break;
+	case DPLL_2:
+		sync_src = SYNC_SOURCE_DPLL2_TOD_PPS;
+		break;
+	case DPLL_3:
+		sync_src = SYNC_SOURCE_DPLL3_TOD_PPS;
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	for (pll = 0; pll < 8; pll++) {
+
+		qn = output_mask & 0x1;
+		output_mask = output_mask >> 1;
+
+		if (pll < 4) {
+			/* First 4 pll has 2 outputs */
+			qn_plus_1 = output_mask & 0x1;
+			output_mask = output_mask >> 1;
+		} else {
+			qn_plus_1 = 0;
+		}
+
+		if ((qn != 0) || (qn_plus_1 != 0))
+			err = _sync_pll_output(idtcm, pll, sync_src, qn,
+					       qn_plus_1);
+
+		if (err)
+			return err;
+	}
+
+	return err;
+}
+
+static int _idtcm_set_dpll_tod(struct idtcm_channel *channel,
+			       struct timespec64 const *ts,
+			       enum hw_tod_write_trig_sel wr_trig)
+{
+	struct idtcm *idtcm = channel->idtcm;
+
+	u8 buf[TOD_BYTE_COUNT];
+	u8 cmd;
+	int err;
+	struct timespec64 local_ts = *ts;
+	s64 total_overhead_ns;
+
+	/* Configure HW TOD write trigger. */
+	err = idtcm_read(idtcm, channel->hw_dpll_n, HW_DPLL_TOD_CTRL_1,
+			 &cmd, sizeof(cmd));
+
+	if (err)
+		return err;
+
+	cmd &= ~(0x0f);
+	cmd |= wr_trig | 0x08;
+
+	err = idtcm_write(idtcm, channel->hw_dpll_n, HW_DPLL_TOD_CTRL_1,
+			  &cmd, sizeof(cmd));
+
+	if (err)
+		return err;
+
+	if (wr_trig  != HW_TOD_WR_TRIG_SEL_MSB) {
+
+		err = timespec_to_char_array(&local_ts, buf, sizeof(buf));
+
+		if (err)
+			return err;
+
+		err = idtcm_write(idtcm, channel->hw_dpll_n,
+				  HW_DPLL_TOD_OVR__0, buf, sizeof(buf));
+
+		if (err)
+			return err;
+	}
+
+	/* ARM HW TOD write trigger. */
+	cmd &= ~(0x08);
+
+	err = idtcm_write(idtcm, channel->hw_dpll_n, HW_DPLL_TOD_CTRL_1,
+			  &cmd, sizeof(cmd));
+
+	if (wr_trig == HW_TOD_WR_TRIG_SEL_MSB) {
+
+		if (idtcm->calculate_overhead_flag) {
+			total_overhead_ns =  ktime_to_ns(ktime_get_raw()
+							 - idtcm->start_time)
+					     + idtcm->tod_write_overhead_ns
+					     + SETTIME_CORRECTION;
+
+			timespec64_add_ns(&local_ts, total_overhead_ns);
+
+			idtcm->calculate_overhead_flag = 0;
+		}
+
+		err = timespec_to_char_array(&local_ts, buf, sizeof(buf));
+
+		if (err)
+			return err;
+
+		err = idtcm_write(idtcm, channel->hw_dpll_n,
+				  HW_DPLL_TOD_OVR__0, buf, sizeof(buf));
+	}
+
+	return err;
+}
+
+static int _idtcm_settime(struct idtcm_channel *channel,
+			  struct timespec64 const *ts,
+			  enum hw_tod_write_trig_sel wr_trig)
+{
+	struct idtcm *idtcm = channel->idtcm;
+	s32 retval;
+	int err;
+	int i;
+	u8 trig_sel;
+
+	err = _idtcm_set_dpll_tod(channel, ts, wr_trig);
+
+	if (err)
+		return err;
+
+	/* Wait for the operation to complete. */
+	for (i = 0; i < 10000; i++) {
+		err = idtcm_read(idtcm, channel->hw_dpll_n,
+				 HW_DPLL_TOD_CTRL_1, &trig_sel,
+				 sizeof(trig_sel));
+
+		if (err)
+			return err;
+
+		if (trig_sel == 0x4a)
+			break;
+
+		err = 1;
+	}
+
+	if (err)
+		return err;
+
+	retval = idtcm_sync_pps_output(channel);
+
+	return retval;
+}
+
+static int idtcm_set_phase_pull_in_offset(struct idtcm_channel *channel,
+					  s32 offset_ns)
+{
+	int err;
+	int i;
+	struct idtcm *idtcm = channel->idtcm;
+
+	u8 buf[4];
+
+	for (i = 0; i < 4; i++) {
+		buf[i] = 0xff & (offset_ns);
+		offset_ns >>= 8;
+	}
+
+	err = idtcm_write(idtcm, channel->dpll_phase_pull_in, PULL_IN_OFFSET,
+			  buf, sizeof(buf));
+
+	return err;
+}
+
+static int idtcm_set_phase_pull_in_slope_limit(struct idtcm_channel *channel,
+					       u32 max_ffo_ppb)
+{
+	int err;
+	u8 i;
+	struct idtcm *idtcm = channel->idtcm;
+
+	u8 buf[3];
+
+	if (max_ffo_ppb & 0xff000000)
+		max_ffo_ppb = 0;
+
+	for (i = 0; i < 3; i++) {
+		buf[i] = 0xff & (max_ffo_ppb);
+		max_ffo_ppb >>= 8;
+	}
+
+	err = idtcm_write(idtcm, channel->dpll_phase_pull_in,
+			  PULL_IN_SLOPE_LIMIT, buf, sizeof(buf));
+
+	return err;
+}
+
+static int idtcm_start_phase_pull_in(struct idtcm_channel *channel)
+{
+	int err;
+	struct idtcm *idtcm = channel->idtcm;
+
+	u8 buf;
+
+	err = idtcm_read(idtcm, channel->dpll_phase_pull_in, PULL_IN_CTRL,
+			 &buf, sizeof(buf));
+
+	if (err)
+		return err;
+
+	if (buf == 0) {
+		buf = 0x01;
+		err = idtcm_write(idtcm, channel->dpll_phase_pull_in,
+				  PULL_IN_CTRL, &buf, sizeof(buf));
+	} else {
+		err = -EBUSY;
+	}
+
+	return err;
+}
+
+static int idtcm_do_phase_pull_in(struct idtcm_channel *channel,
+				  s32 offset_ns,
+				  u32 max_ffo_ppb)
+{
+	int err;
+
+	err = idtcm_set_phase_pull_in_offset(channel, -offset_ns);
+
+	if (err)
+		return err;
+
+	err = idtcm_set_phase_pull_in_slope_limit(channel, max_ffo_ppb);
+
+	if (err)
+		return err;
+
+	err = idtcm_start_phase_pull_in(channel);
+
+	return err;
+}
+
+static int _idtcm_adjtime(struct idtcm_channel *channel, s64 delta)
+{
+	int err;
+	struct idtcm *idtcm = channel->idtcm;
+	struct timespec64 ts;
+	s64 now;
+
+	if (abs(delta) < PHASE_PULL_IN_THRESHOLD_NS) {
+		err = idtcm_do_phase_pull_in(channel, delta, 0);
+	} else {
+		idtcm->calculate_overhead_flag = 1;
+
+		err = _idtcm_gettime(channel, &ts);
+
+		if (err)
+			return err;
+
+		now = timespec64_to_ns(&ts);
+		now += delta;
+
+		ts = ns_to_timespec64(now);
+
+		err = _idtcm_settime(channel, &ts, HW_TOD_WR_TRIG_SEL_MSB);
+	}
+
+	return err;
+}
+
+static int idtcm_state_machine_reset(struct idtcm *idtcm)
+{
+	int err;
+	u8 byte = SM_RESET_CMD;
+
+	err = idtcm_write(idtcm, RESET_CTRL, SM_RESET, &byte, sizeof(byte));
+
+	if (!err)
+		msleep_interruptible(POST_SM_RESET_DELAY_MS);
+
+	return err;
+}
+
+static int idtcm_read_hw_rev_id(struct idtcm *idtcm, u8 *hw_rev_id)
+{
+	return idtcm_read(idtcm,
+			  GENERAL_STATUS,
+			  HW_REV_ID,
+			  hw_rev_id,
+			  sizeof(u8));
+}
+
+static int idtcm_read_bond_id(struct idtcm *idtcm, u8 *bond_id)
+{
+	return idtcm_read(idtcm,
+			  GENERAL_STATUS,
+			  BOND_ID,
+			  bond_id,
+			  sizeof(u8));
+}
+
+static int idtcm_read_hw_csr_id(struct idtcm *idtcm, u16 *hw_csr_id)
+{
+	int err;
+	u8 buf[2] = {0};
+
+	err = idtcm_read(idtcm, GENERAL_STATUS, HW_CSR_ID, buf, sizeof(buf));
+
+	*hw_csr_id = (buf[1] << 8) | buf[0];
+
+	return err;
+}
+
+static int idtcm_read_hw_irq_id(struct idtcm *idtcm, u16 *hw_irq_id)
+{
+	int err;
+	u8 buf[2] = {0};
+
+	err = idtcm_read(idtcm, GENERAL_STATUS, HW_IRQ_ID, buf, sizeof(buf));
+
+	*hw_irq_id = (buf[1] << 8) | buf[0];
+
+	return err;
+}
+
+static int idtcm_read_product_id(struct idtcm *idtcm, u16 *product_id)
+{
+	int err;
+	u8 buf[2] = {0};
+
+	err = idtcm_read(idtcm, GENERAL_STATUS, PRODUCT_ID, buf, sizeof(buf));
+
+	*product_id = (buf[1] << 8) | buf[0];
+
+	return err;
+}
+
+static int idtcm_read_major_release(struct idtcm *idtcm, u8 *major)
+{
+	int err;
+	u8 buf = 0;
+
+	err = idtcm_read(idtcm, GENERAL_STATUS, MAJ_REL, &buf, sizeof(buf));
+
+	*major = buf >> 1;
+
+	return err;
+}
+
+static int idtcm_read_minor_release(struct idtcm *idtcm, u8 *minor)
+{
+	return idtcm_read(idtcm, GENERAL_STATUS, MIN_REL, minor, sizeof(u8));
+}
+
+static int idtcm_read_hotfix_release(struct idtcm *idtcm, u8 *hotfix)
+{
+	return idtcm_read(idtcm,
+			  GENERAL_STATUS,
+			  HOTFIX_REL,
+			  hotfix,
+			  sizeof(u8));
+}
+
+static int idtcm_read_pipeline(struct idtcm *idtcm, u32 *pipeline)
+{
+	int err;
+	u8 buf[4] = {0};
+
+	err = idtcm_read(idtcm,
+			 GENERAL_STATUS,
+			 PIPELINE_ID,
+			 &buf[0],
+			 sizeof(buf));
+
+	*pipeline = (buf[3] << 24) | (buf[2] << 16) | (buf[1] << 8) | buf[0];
+
+	return err;
+}
+
+static int process_pll_mask(struct idtcm *idtcm, u32 addr, u8 val, u8 *mask)
+{
+	int err = 0;
+
+	if (addr == PLL_MASK_ADDR) {
+		if ((val & 0xf0) || !(val & 0xf)) {
+			dev_err(&idtcm->client->dev,
+				"Invalid PLL mask 0x%hhx\n", val);
+			err = -EINVAL;
+		}
+		*mask = val;
+	}
+
+	return err;
+}
+
+static int set_pll_output_mask(struct idtcm *idtcm, u16 addr, u8 val)
+{
+	int err = 0;
+
+	switch (addr) {
+	case OUTPUT_MASK_PLL0_ADDR:
+		SET_U16_LSB(idtcm->channel[0].output_mask, val);
+		break;
+	case OUTPUT_MASK_PLL0_ADDR + 1:
+		SET_U16_MSB(idtcm->channel[0].output_mask, val);
+		break;
+	case OUTPUT_MASK_PLL1_ADDR:
+		SET_U16_LSB(idtcm->channel[1].output_mask, val);
+		break;
+	case OUTPUT_MASK_PLL1_ADDR + 1:
+		SET_U16_MSB(idtcm->channel[1].output_mask, val);
+		break;
+	case OUTPUT_MASK_PLL2_ADDR:
+		SET_U16_LSB(idtcm->channel[2].output_mask, val);
+		break;
+	case OUTPUT_MASK_PLL2_ADDR + 1:
+		SET_U16_MSB(idtcm->channel[2].output_mask, val);
+		break;
+	case OUTPUT_MASK_PLL3_ADDR:
+		SET_U16_LSB(idtcm->channel[3].output_mask, val);
+		break;
+	case OUTPUT_MASK_PLL3_ADDR + 1:
+		SET_U16_MSB(idtcm->channel[3].output_mask, val);
+		break;
+	default:
+		err = -EINVAL;
+		break;
+	}
+
+	return err;
+}
+
+static int check_and_set_masks(struct idtcm *idtcm,
+			       u16 regaddr,
+			       u8 val)
+{
+	int err = 0;
+
+	if (set_pll_output_mask(idtcm, regaddr, val)) {
+		/* Not an output mask, check for pll mask */
+		err = process_pll_mask(idtcm, regaddr, val, &idtcm->pll_mask);
+	}
+
+	return err;
+}
+
+static void display_pll_and_output_masks(struct idtcm *idtcm)
+{
+	u8 i;
+	u8 mask;
+
+	dev_dbg(&idtcm->client->dev, "pllmask = 0x%02x\n", idtcm->pll_mask);
+
+	for (i = 0; i < MAX_PHC_PLL; i++) {
+		mask = 1 << i;
+
+		if (mask & idtcm->pll_mask)
+			dev_dbg(&idtcm->client->dev,
+				"PLL%d output_mask = 0x%04x\n",
+				i, idtcm->channel[i].output_mask);
+	}
+}
+
+static int idtcm_load_firmware(struct idtcm *idtcm,
+			       struct device *dev)
+{
+	const struct firmware *fw;
+	struct idtcm_fwrc *rec;
+	u32 regaddr;
+	int err;
+	s32 len;
+	u8 val;
+	u8 loaddr;
+
+	dev_dbg(&idtcm->client->dev, "requesting firmware '%s'\n", FW_FILENAME);
+
+	err = request_firmware(&fw, FW_FILENAME, dev);
+
+	if (err)
+		return err;
+
+	dev_dbg(&idtcm->client->dev, "firmware size %zu bytes\n", fw->size);
+
+	rec = (struct idtcm_fwrc *) fw->data;
+
+	if (fw->size > 0)
+		idtcm_state_machine_reset(idtcm);
+
+	for (len = fw->size; len > 0; len -= sizeof(*rec)) {
+
+		if (rec->reserved) {
+			dev_err(&idtcm->client->dev,
+				"bad firmware, reserved field non-zero\n");
+			err = -EINVAL;
+		} else {
+			regaddr = rec->hiaddr << 8;
+			regaddr |= rec->loaddr;
+
+			val = rec->value;
+			loaddr = rec->loaddr;
+
+			rec++;
+
+			err = check_and_set_masks(idtcm, regaddr, val);
+		}
+
+		if (err == 0) {
+			/* Top (status registers) and bottom are read-only */
+			if ((regaddr < GPIO_USER_CONTROL)
+			    || (regaddr >= SCRATCH))
+				continue;
+
+			/* Page size 128, last 4 bytes of page skipped */
+			if (((loaddr > 0x7b) && (loaddr <= 0x7f))
+			     || ((loaddr > 0xfb) && (loaddr <= 0xff)))
+				continue;
+
+			err = idtcm_write(idtcm, regaddr, 0, &val, sizeof(val));
+		}
+
+		if (err)
+			goto out;
+	}
+
+	display_pll_and_output_masks(idtcm);
+
+out:
+	release_firmware(fw);
+	return err;
+}
+
+static int idtcm_pps_enable(struct idtcm_channel *channel, bool enable)
+{
+	struct idtcm *idtcm = channel->idtcm;
+	u32 module;
+	u8 val;
+	int err;
+
+	/*
+	 * This assumes that the 1-PPS is on the second of the two
+	 * output.  But is this always true?
+	 */
+	switch (channel->dpll_n) {
+	case DPLL_0:
+		module = OUTPUT_1;
+		break;
+	case DPLL_1:
+		module = OUTPUT_3;
+		break;
+	case DPLL_2:
+		module = OUTPUT_5;
+		break;
+	case DPLL_3:
+		module = OUTPUT_7;
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	err = idtcm_read(idtcm, module, OUT_CTRL_1, &val, sizeof(val));
+
+	if (err)
+		return err;
+
+	if (enable)
+		val |= SQUELCH_DISABLE;
+	else
+		val &= ~SQUELCH_DISABLE;
+
+	err = idtcm_write(idtcm, module, OUT_CTRL_1, &val, sizeof(val));
+
+	if (err)
+		return err;
+
+	return 0;
+}
+
+static int idtcm_set_pll_mode(struct idtcm_channel *channel,
+			      enum pll_mode pll_mode)
+{
+	struct idtcm *idtcm = channel->idtcm;
+	int err;
+	u8 dpll_mode;
+
+	err = idtcm_read(idtcm, channel->dpll_n, DPLL_MODE,
+			 &dpll_mode, sizeof(dpll_mode));
+	if (err)
+		return err;
+
+	dpll_mode &= ~(PLL_MODE_MASK << PLL_MODE_SHIFT);
+
+	dpll_mode |= (pll_mode << PLL_MODE_SHIFT);
+
+	channel->pll_mode = pll_mode;
+
+	err = idtcm_write(idtcm, channel->dpll_n, DPLL_MODE,
+			  &dpll_mode, sizeof(dpll_mode));
+	if (err)
+		return err;
+
+	return 0;
+}
+
+/* PTP Hardware Clock interface */
+
+static int idtcm_adjfreq(struct ptp_clock_info *ptp, s32 ppb)
+{
+	struct idtcm_channel *channel =
+		container_of(ptp, struct idtcm_channel, caps);
+	struct idtcm *idtcm = channel->idtcm;
+	u8 i;
+	bool neg_adj = 0;
+	int err;
+	u8 buf[6] = {0};
+	s64 fcw;
+
+	if (channel->pll_mode  != PLL_MODE_WRITE_FREQUENCY) {
+		err = idtcm_set_pll_mode(channel, PLL_MODE_WRITE_FREQUENCY);
+		if (err)
+			return err;
+	}
+
+	/*
+	 * Frequency Control Word unit is: 1.11 * 10^-10 ppm
+	 *
+	 * adjfreq:
+	 *       ppb * 10^9
+	 * FCW = ----------
+	 *          111
+	 *
+	 * adjfine:
+	 *       ppm_16 * 5^12
+	 * FCW = -------------
+	 *         111 * 2^4
+	 */
+	if (ppb < 0) {
+		neg_adj = 1;
+		ppb = -ppb;
+	}
+
+	/* 2 ^ -53 = 1.1102230246251565404236316680908e-16 */
+	fcw = ppb * 1000000000000ULL;
+
+	fcw = div_u64(fcw, 111022);
+
+	if (neg_adj)
+		fcw = -fcw;
+
+	for (i = 0; i < 6; i++) {
+		buf[i] = fcw & 0xff;
+		fcw >>= 8;
+	}
+
+	mutex_lock(&idtcm->reg_lock);
+
+	err = idtcm_write(idtcm, channel->dpll_freq, DPLL_WR_FREQ,
+			  buf, sizeof(buf));
+
+	mutex_unlock(&idtcm->reg_lock);
+	return err;
+}
+
+static int idtcm_gettime(struct ptp_clock_info *ptp, struct timespec64 *ts)
+{
+	struct idtcm_channel *channel =
+		container_of(ptp, struct idtcm_channel, caps);
+	struct idtcm *idtcm = channel->idtcm;
+	int err;
+
+	mutex_lock(&idtcm->reg_lock);
+
+	err = _idtcm_gettime(channel, ts);
+
+	mutex_unlock(&idtcm->reg_lock);
+
+	return err;
+}
+
+static int idtcm_settime(struct ptp_clock_info *ptp,
+			 const struct timespec64 *ts)
+{
+	struct idtcm_channel *channel =
+		container_of(ptp, struct idtcm_channel, caps);
+	struct idtcm *idtcm = channel->idtcm;
+	int err;
+
+	mutex_lock(&idtcm->reg_lock);
+
+	err = _idtcm_settime(channel, ts, HW_TOD_WR_TRIG_SEL_MSB);
+
+	mutex_unlock(&idtcm->reg_lock);
+
+	return err;
+}
+
+static int idtcm_adjtime(struct ptp_clock_info *ptp, s64 delta)
+{
+	struct idtcm_channel *channel =
+		container_of(ptp, struct idtcm_channel, caps);
+	struct idtcm *idtcm = channel->idtcm;
+	int err;
+
+	mutex_lock(&idtcm->reg_lock);
+
+	err = _idtcm_adjtime(channel, delta);
+
+	mutex_unlock(&idtcm->reg_lock);
+
+	return err;
+}
+
+static int idtcm_enable(struct ptp_clock_info *ptp,
+			struct ptp_clock_request *rq, int on)
+{
+	struct idtcm_channel *channel =
+		container_of(ptp, struct idtcm_channel, caps);
+
+	switch (rq->type) {
+	case PTP_CLK_REQ_PEROUT:
+		if (!on)
+			return idtcm_pps_enable(channel, false);
+
+		/* Only accept a 1-PPS aligned to the second. */
+		if (rq->perout.start.nsec || rq->perout.period.sec != 1 ||
+		    rq->perout.period.nsec)
+			return -ERANGE;
+
+		return idtcm_pps_enable(channel, true);
+	default:
+		break;
+	}
+
+	return -EOPNOTSUPP;
+}
+
+static int idtcm_enable_tod(struct idtcm_channel *channel)
+{
+	struct idtcm *idtcm = channel->idtcm;
+	struct timespec64 ts = {0, 0};
+	u8 cfg;
+	int err;
+
+	err = idtcm_pps_enable(channel, false);
+	if (err)
+		return err;
+
+	/*
+	 * Start the TOD clock ticking.
+	 */
+	err = idtcm_read(idtcm, channel->tod_n, TOD_CFG, &cfg, sizeof(cfg));
+	if (err)
+		return err;
+
+	cfg |= TOD_ENABLE;
+
+	err = idtcm_write(idtcm, channel->tod_n, TOD_CFG, &cfg, sizeof(cfg));
+	if (err)
+		return err;
+
+	return _idtcm_settime(channel, &ts, HW_TOD_WR_TRIG_SEL_MSB);
+}
+
+static void idtcm_display_version_info(struct idtcm *idtcm)
+{
+	u8 major;
+	u8 minor;
+	u8 hotfix;
+	u32 pipeline;
+	u16 product_id;
+	u16 csr_id;
+	u16 irq_id;
+	u8 hw_rev_id;
+	u8 bond_id;
+
+	idtcm_read_major_release(idtcm, &major);
+	idtcm_read_minor_release(idtcm, &minor);
+	idtcm_read_hotfix_release(idtcm, &hotfix);
+	idtcm_read_pipeline(idtcm, &pipeline);
+
+	idtcm_read_product_id(idtcm, &product_id);
+	idtcm_read_hw_rev_id(idtcm, &hw_rev_id);
+	idtcm_read_bond_id(idtcm, &bond_id);
+	idtcm_read_hw_csr_id(idtcm, &csr_id);
+	idtcm_read_hw_irq_id(idtcm, &irq_id);
+
+	dev_info(&idtcm->client->dev, "Version:  %d.%d.%d, Pipeline %u\t"
+		 "0x%04x, Rev %d, Bond %d, CSR %d, IRQ %d\n",
+		 major, minor, hotfix, pipeline,
+		 product_id, hw_rev_id, bond_id, csr_id, irq_id);
+}
+
+static struct ptp_clock_info idtcm_caps = {
+	.owner		= THIS_MODULE,
+	.max_adj	= 244000,
+	.n_per_out	= 1,
+	.adjfreq	= &idtcm_adjfreq,
+	.adjtime	= &idtcm_adjtime,
+	.gettime64	= &idtcm_gettime,
+	.settime64	= &idtcm_settime,
+	.enable		= &idtcm_enable,
+};
+
+static int idtcm_enable_channel(struct idtcm *idtcm, u32 index)
+{
+	struct idtcm_channel *channel;
+	int err;
+
+	if (!(index < MAX_PHC_PLL))
+		return -EINVAL;
+
+	channel = &idtcm->channel[index];
+
+	switch (index) {
+	case 0:
+		channel->dpll_freq = DPLL_FREQ_0;
+		channel->dpll_n = DPLL_0;
+		channel->tod_read_primary = TOD_READ_PRIMARY_0;
+		channel->tod_write = TOD_WRITE_0;
+		channel->tod_n = TOD_0;
+		channel->hw_dpll_n = HW_DPLL_0;
+		channel->dpll_phase = DPLL_PHASE_0;
+		channel->dpll_ctrl_n = DPLL_CTRL_0;
+		channel->dpll_phase_pull_in = DPLL_PHASE_PULL_IN_0;
+		break;
+	case 1:
+		channel->dpll_freq = DPLL_FREQ_1;
+		channel->dpll_n = DPLL_1;
+		channel->tod_read_primary = TOD_READ_PRIMARY_1;
+		channel->tod_write = TOD_WRITE_1;
+		channel->tod_n = TOD_1;
+		channel->hw_dpll_n = HW_DPLL_1;
+		channel->dpll_phase = DPLL_PHASE_1;
+		channel->dpll_ctrl_n = DPLL_CTRL_1;
+		channel->dpll_phase_pull_in = DPLL_PHASE_PULL_IN_1;
+		break;
+	case 2:
+		channel->dpll_freq = DPLL_FREQ_2;
+		channel->dpll_n = DPLL_2;
+		channel->tod_read_primary = TOD_READ_PRIMARY_2;
+		channel->tod_write = TOD_WRITE_2;
+		channel->tod_n = TOD_2;
+		channel->hw_dpll_n = HW_DPLL_2;
+		channel->dpll_phase = DPLL_PHASE_2;
+		channel->dpll_ctrl_n = DPLL_CTRL_2;
+		channel->dpll_phase_pull_in = DPLL_PHASE_PULL_IN_2;
+		break;
+	case 3:
+		channel->dpll_freq = DPLL_FREQ_3;
+		channel->dpll_n = DPLL_3;
+		channel->tod_read_primary = TOD_READ_PRIMARY_3;
+		channel->tod_write = TOD_WRITE_3;
+		channel->tod_n = TOD_3;
+		channel->hw_dpll_n = HW_DPLL_3;
+		channel->dpll_phase = DPLL_PHASE_3;
+		channel->dpll_ctrl_n = DPLL_CTRL_3;
+		channel->dpll_phase_pull_in = DPLL_PHASE_PULL_IN_3;
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	channel->idtcm = idtcm;
+
+	channel->caps = idtcm_caps;
+	snprintf(channel->caps.name, sizeof(channel->caps.name),
+		 "IDT CM PLL%u", index);
+
+	err = idtcm_set_pll_mode(channel, PLL_MODE_WRITE_FREQUENCY);
+	if (err)
+		return err;
+
+	err = idtcm_enable_tod(channel);
+	if (err)
+		return err;
+
+	channel->ptp_clock = ptp_clock_register(&channel->caps, NULL);
+
+	if (IS_ERR(channel->ptp_clock)) {
+		err = PTR_ERR(channel->ptp_clock);
+		channel->ptp_clock = NULL;
+		return err;
+	}
+
+	if (!channel->ptp_clock)
+		return -ENOTSUPP;
+
+	dev_info(&idtcm->client->dev, "PLL%d registered as ptp%d\n",
+		 index, channel->ptp_clock->index);
+
+	return 0;
+}
+
+static void ptp_clock_unregister_all(struct idtcm *idtcm)
+{
+	u8 i;
+	struct idtcm_channel *channel;
+
+	for (i = 0; i < MAX_PHC_PLL; i++) {
+
+		channel = &idtcm->channel[i];
+
+		if (channel->ptp_clock)
+			ptp_clock_unregister(channel->ptp_clock);
+	}
+}
+
+static void set_default_masks(struct idtcm *idtcm)
+{
+	idtcm->pll_mask = DEFAULT_PLL_MASK;
+
+	idtcm->channel[0].output_mask = DEFAULT_OUTPUT_MASK_PLL0;
+	idtcm->channel[1].output_mask = DEFAULT_OUTPUT_MASK_PLL1;
+	idtcm->channel[2].output_mask = DEFAULT_OUTPUT_MASK_PLL2;
+	idtcm->channel[3].output_mask = DEFAULT_OUTPUT_MASK_PLL3;
+}
+
+static int set_tod_write_overhead(struct idtcm *idtcm)
+{
+	int err;
+	u8 i;
+
+	s64 total_ns = 0;
+
+	ktime_t start;
+	ktime_t stop;
+
+	char buf[TOD_BYTE_COUNT];
+
+	struct idtcm_channel *channel = &idtcm->channel[2];
+
+	/* Set page offset */
+	idtcm_write(idtcm, channel->hw_dpll_n, HW_DPLL_TOD_OVR__0,
+		    buf, sizeof(buf));
+
+	for (i = 0; i < TOD_WRITE_OVERHEAD_COUNT_MAX; i++) {
+
+		start = ktime_get_raw();
+
+		err = idtcm_write(idtcm, channel->hw_dpll_n,
+				  HW_DPLL_TOD_OVR__0, buf, sizeof(buf));
+
+		if (err)
+			return err;
+
+		stop = ktime_get_raw();
+
+		total_ns += ktime_to_ns(stop - start);
+	}
+
+	idtcm->tod_write_overhead_ns = div_s64(total_ns,
+					       TOD_WRITE_OVERHEAD_COUNT_MAX);
+
+	return err;
+}
+
+static int idtcm_probe(struct i2c_client *client,
+		       const struct i2c_device_id *id)
+{
+	struct idtcm *idtcm;
+	int err;
+	u8 i;
+
+	/* Unused for now */
+	(void)id;
+
+	idtcm = devm_kzalloc(&client->dev, sizeof(struct idtcm), GFP_KERNEL);
+
+	if (!idtcm)
+		return -ENOMEM;
+
+	idtcm->client = client;
+	idtcm->page_offset = 0xff;
+	idtcm->calculate_overhead_flag = 0;
+
+	set_default_masks(idtcm);
+
+	mutex_init(&idtcm->reg_lock);
+	mutex_lock(&idtcm->reg_lock);
+
+	idtcm_display_version_info(idtcm);
+
+	err = set_tod_write_overhead(idtcm);
+
+	if (err)
+		return err;
+
+	err = idtcm_load_firmware(idtcm, &client->dev);
+
+	if (err)
+		dev_warn(&idtcm->client->dev,
+			 "loading firmware failed with %d\n", err);
+
+	if (idtcm->pll_mask) {
+		for (i = 0; i < MAX_PHC_PLL; i++) {
+			if (idtcm->pll_mask & (1 << i)) {
+				err = idtcm_enable_channel(idtcm, i);
+				if (err)
+					break;
+			}
+		}
+	} else {
+		dev_err(&idtcm->client->dev,
+			"no PLLs flagged as PHCs, nothing to do\n");
+		err = -ENODEV;
+	}
+
+	mutex_unlock(&idtcm->reg_lock);
+
+	if (err) {
+		ptp_clock_unregister_all(idtcm);
+		return err;
+	}
+
+	i2c_set_clientdata(client, idtcm);
+
+	return 0;
+}
+
+static int idtcm_remove(struct i2c_client *client)
+{
+	struct idtcm *idtcm = i2c_get_clientdata(client);
+
+	ptp_clock_unregister_all(idtcm);
+
+	mutex_destroy(&idtcm->reg_lock);
+
+	return 0;
+}
+
+#ifdef CONFIG_OF
+static const struct of_device_id idtcm_dt_id[] = {
+	{ .compatible = "idt,8a34000" },
+	{ .compatible = "idt,8a34001" },
+	{ .compatible = "idt,8a34002" },
+	{ .compatible = "idt,8a34003" },
+	{ .compatible = "idt,8a34004" },
+	{ .compatible = "idt,8a34005" },
+	{ .compatible = "idt,8a34006" },
+	{ .compatible = "idt,8a34007" },
+	{ .compatible = "idt,8a34008" },
+	{ .compatible = "idt,8a34009" },
+	{ .compatible = "idt,8a34010" },
+	{ .compatible = "idt,8a34011" },
+	{ .compatible = "idt,8a34012" },
+	{ .compatible = "idt,8a34013" },
+	{ .compatible = "idt,8a34014" },
+	{ .compatible = "idt,8a34015" },
+	{ .compatible = "idt,8a34016" },
+	{ .compatible = "idt,8a34017" },
+	{ .compatible = "idt,8a34018" },
+	{ .compatible = "idt,8a34019" },
+	{ .compatible = "idt,8a34040" },
+	{ .compatible = "idt,8a34041" },
+	{ .compatible = "idt,8a34042" },
+	{ .compatible = "idt,8a34043" },
+	{ .compatible = "idt,8a34044" },
+	{ .compatible = "idt,8a34045" },
+	{ .compatible = "idt,8a34046" },
+	{ .compatible = "idt,8a34047" },
+	{ .compatible = "idt,8a34048" },
+	{ .compatible = "idt,8a34049" },
+	{},
+};
+MODULE_DEVICE_TABLE(of, idtcm_dt_id);
+#endif
+
+static const struct i2c_device_id idtcm_i2c_id[] = {
+	{ "8a34000" },
+	{ "8a34001" },
+	{ "8a34002" },
+	{ "8a34003" },
+	{ "8a34004" },
+	{ "8a34005" },
+	{ "8a34006" },
+	{ "8a34007" },
+	{ "8a34008" },
+	{ "8a34009" },
+	{ "8a34010" },
+	{ "8a34011" },
+	{ "8a34012" },
+	{ "8a34013" },
+	{ "8a34014" },
+	{ "8a34015" },
+	{ "8a34016" },
+	{ "8a34017" },
+	{ "8a34018" },
+	{ "8a34019" },
+	{ "8a34040" },
+	{ "8a34041" },
+	{ "8a34042" },
+	{ "8a34043" },
+	{ "8a34044" },
+	{ "8a34045" },
+	{ "8a34046" },
+	{ "8a34047" },
+	{ "8a34048" },
+	{ "8a34049" },
+	{},
+};
+MODULE_DEVICE_TABLE(i2c, idtcm_i2c_id);
+
+static struct i2c_driver idtcm_driver = {
+	.driver = {
+		.of_match_table	= of_match_ptr(idtcm_dt_id),
+		.name		= "idtcm",
+	},
+	.probe		= idtcm_probe,
+	.remove		= idtcm_remove,
+	.id_table	= idtcm_i2c_id,
+};
+
+module_i2c_driver(idtcm_driver);
diff --git a/drivers/ptp/ptp_clockmatrix.h b/drivers/ptp/ptp_clockmatrix.h
new file mode 100644
index 0000000..6c1f93a
--- /dev/null
+++ b/drivers/ptp/ptp_clockmatrix.h
@@ -0,0 +1,104 @@
+/* SPDX-License-Identifier: GPL-2.0+ */
+/*
+ * PTP hardware clock driver for the IDT ClockMatrix(TM) family of timing and
+ * synchronization devices.
+ *
+ * Copyright (C) 2019 Integrated Device Technology, Inc., a Renesas Company.
+ */
+#ifndef PTP_IDTCLOCKMATRIX_H
+#define PTP_IDTCLOCKMATRIX_H
+
+#include <linux/ktime.h>
+
+#include "idt8a340_reg.h"
+
+#define FW_FILENAME	"idtcm.bin"
+#define MAX_PHC_PLL	4
+
+#define PLL_MASK_ADDR		(0xFFA5)
+#define DEFAULT_PLL_MASK	(0x04)
+
+#define SET_U16_LSB(orig, val8) (orig = (0xff00 & (orig)) | (val8))
+#define SET_U16_MSB(orig, val8) (orig = (0x00ff & (orig)) | (val8 << 8))
+
+#define OUTPUT_MASK_PLL0_ADDR		(0xFFB0)
+#define OUTPUT_MASK_PLL1_ADDR		(0xFFB2)
+#define OUTPUT_MASK_PLL2_ADDR		(0xFFB4)
+#define OUTPUT_MASK_PLL3_ADDR		(0xFFB6)
+
+#define DEFAULT_OUTPUT_MASK_PLL0	(0x003)
+#define DEFAULT_OUTPUT_MASK_PLL1	(0x00c)
+#define DEFAULT_OUTPUT_MASK_PLL2	(0x030)
+#define DEFAULT_OUTPUT_MASK_PLL3	(0x0c0)
+
+#define POST_SM_RESET_DELAY_MS		(3000)
+#define PHASE_PULL_IN_THRESHOLD_NS	(150000)
+#define TOD_WRITE_OVERHEAD_COUNT_MAX    (5)
+#define TOD_BYTE_COUNT                  (11)
+
+/* Values of DPLL_N.DPLL_MODE.PLL_MODE */
+enum pll_mode {
+	PLL_MODE_MIN = 0,
+	PLL_MODE_NORMAL = PLL_MODE_MIN,
+	PLL_MODE_WRITE_PHASE = 1,
+	PLL_MODE_WRITE_FREQUENCY = 2,
+	PLL_MODE_GPIO_INC_DEC = 3,
+	PLL_MODE_SYNTHESIS = 4,
+	PLL_MODE_PHASE_MEASUREMENT = 5,
+	PLL_MODE_MAX = PLL_MODE_PHASE_MEASUREMENT,
+};
+
+enum hw_tod_write_trig_sel {
+	HW_TOD_WR_TRIG_SEL_MIN = 0,
+	HW_TOD_WR_TRIG_SEL_MSB = HW_TOD_WR_TRIG_SEL_MIN,
+	HW_TOD_WR_TRIG_SEL_RESERVED = 1,
+	HW_TOD_WR_TRIG_SEL_TOD_PPS = 2,
+	HW_TOD_WR_TRIG_SEL_IRIGB_PPS = 3,
+	HW_TOD_WR_TRIG_SEL_PWM_PPS = 4,
+	HW_TOD_WR_TRIG_SEL_GPIO = 5,
+	HW_TOD_WR_TRIG_SEL_FOD_SYNC = 6,
+	WR_TRIG_SEL_MAX = HW_TOD_WR_TRIG_SEL_FOD_SYNC,
+};
+
+struct idtcm;
+
+struct idtcm_channel {
+	struct ptp_clock_info	caps;
+	struct ptp_clock	*ptp_clock;
+	struct idtcm		*idtcm;
+	u16			dpll_phase;
+	u16			dpll_freq;
+	u16			dpll_n;
+	u16			dpll_ctrl_n;
+	u16			dpll_phase_pull_in;
+	u16			tod_read_primary;
+	u16			tod_write;
+	u16			tod_n;
+	u16			hw_dpll_n;
+	enum pll_mode		pll_mode;
+	u16			output_mask;
+};
+
+struct idtcm {
+	struct idtcm_channel	channel[MAX_PHC_PLL];
+	struct i2c_client	*client;
+	u8			page_offset;
+	u8			pll_mask;
+
+	/* Overhead calculation for adjtime */
+	u8			calculate_overhead_flag;
+	s64			tod_write_overhead_ns;
+	ktime_t			start_time;
+
+	/* Protects I2C read/modify/write registers from concurrent access */
+	struct mutex		reg_lock;
+};
+
+struct idtcm_fwrc {
+	u8 hiaddr;
+	u8 loaddr;
+	u8 value;
+	u8 reserved;
+} __packed;
+
+#endif /* PTP_IDTCLOCKMATRIX_H */
-- 
2.7.4

