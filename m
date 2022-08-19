Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 73CF8599D91
	for <lists+netdev@lfdr.de>; Fri, 19 Aug 2022 16:28:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349533AbiHSOUN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Aug 2022 10:20:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349522AbiHSOUJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Aug 2022 10:20:09 -0400
Received: from EUR05-AM6-obe.outbound.protection.outlook.com (mail-am6eur05on2085.outbound.protection.outlook.com [40.107.22.85])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D309883DB;
        Fri, 19 Aug 2022 07:20:06 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kmxfH8QAmbrxE/LfUADoDBMXku37jLsqB1cgBA9YwBA7KvneFedd7bVjKs9CCu9UPJ2YfHG1Po+ocCnyjKIE2GQ/48I31iNq+nV82M/jPsM0q3Qj9utOBjUjfn1Emd9iT1e4TgJbrdu6Wt8MfJlGReKd2/kRbS7wBCa+PUFt3Ne2hk/2/chwe+hoI8M7qshLjQJPTpEvztepKwjPBRwdvLcNfh7vf7mOZCVpvK2mDQiKNJmaPjFe67QBpqc+2jjvXJq26pROgKnHPcecti96nRUaly2HG1Ng/GVgDAyecmpOBj4HRpPIf5LxjsCCYBerkMp0JtKDgBa6/DWPhROSHg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bIw6y4WbAA7yFSf1262G0r7FpG7qJzbCExcuf2jKbHQ=;
 b=ed6v9YDWZiFEs0OU5fU28e9SWi3up2x8Bpb/uyCG8CqOVX3BIB8mc3py2UVTBmA4PJ3gtGNXEut8qH8f2PBAUKhYY0DkneMLKTQEcM7sgfb4DY2LEZSEN5Ik2C7hTKClMku/dHl3AsYTp1XoBJPb6AKhQUH42YoTtzKsA7hxFg2IVdbxnABzNx3vxnUUHTi60tPyComdglNsCYevQ7UJgAJf+6/wN2tnsCgd1zw+hWc5XH+OgejW8f2Z7ym5Crjb0RpwDEbWJfbYaIyrgjhLKQroGKrPLGvPPVaWFm4ju2vUekKWQYM7dc0c613iaum1LUidGBP24u3F40FcwlJNXg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=stud.acs.upb.ro; dmarc=pass action=none
 header.from=stud.acs.upb.ro; dkim=pass header.d=stud.acs.upb.ro; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=stud.acs.upb.ro;
Received: from AM6PR0102MB3159.eurprd01.prod.exchangelabs.com
 (2603:10a6:209:3::16) by AS8PR01MB8023.eurprd01.prod.exchangelabs.com
 (2603:10a6:20b:376::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5504.14; Fri, 19 Aug
 2022 14:20:01 +0000
Received: from AM6PR0102MB3159.eurprd01.prod.exchangelabs.com
 ([fe80::19b7:7216:e4a2:b0b]) by
 AM6PR0102MB3159.eurprd01.prod.exchangelabs.com ([fe80::19b7:7216:e4a2:b0b%7])
 with mapi id 15.20.5504.028; Fri, 19 Aug 2022 14:20:01 +0000
From:   andrei.tachici@stud.acs.upb.ro
To:     linux-kernel@vger.kernel.org
Cc:     andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org,
        vegard.nossum@oracle.com, joel@jms.id.au, l.stelmach@samsung.com,
        robh+dt@kernel.org, krzysztof.kozlowski+dt@linaro.org,
        devicetree@vger.kernel.org
Subject: [net-next v5 2/3] net: ethernet: adi: Add ADIN1110 support
Date:   Fri, 19 Aug 2022 17:19:40 +0300
Message-Id: <20220819141941.39635-3-andrei.tachici@stud.acs.upb.ro>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220819141941.39635-1-andrei.tachici@stud.acs.upb.ro>
References: <20220819141941.39635-1-andrei.tachici@stud.acs.upb.ro>
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-ClientProxiedBy: BE0P281CA0006.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:b10:a::16) To AM6PR0102MB3159.eurprd01.prod.exchangelabs.com
 (2603:10a6:209:3::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 87d43a7f-1c87-42a8-554c-08da81ede70e
X-MS-TrafficTypeDiagnostic: AS8PR01MB8023:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: O0Rla4hPjOqBVWK57Z+elUF1prVuA2Th6Z9+liK32Wa++DKPjgDdmqeNfdyyy1uo8drWlVj/nztZTyh1lvdBEhg4LZF8EM4cdOgshVEj/o6/0qaXSeQ4Gfe7oIJGTGJLByQ+q6RWcQzgKCSG5fOfKTayx/WCVrEIWG60YxhxxT01PRCL5gF+9BrFiqwvXTUpp4HM/h7dl/SQ4QHu7ZZib0gVNL4CcrHFhPBXQEPEsWav8VnTB7jvX5un80jd+gxLGD2cFoK5Bl4bnyBY/WdbQtVNNr8zlvHSlmPxoZtv4GSCvv7Ap56WkPGVUguYi7M1KVcH7mTIjqkhN38hJfZMtPvHMBLGk9QB+ZOU7HTm9uWXPYs3wWE+VGNiGvsKlUVGL/Y0NxAyPdBfUhghDATZBKFuQPq/zTT8PMvX+kZdr5QlySBQOs8Jz75eGTAEHzS7OYnpOVUEDFbwPd2mkqlT9LzNjOnTf14z52LBD02OEJTZmm8JaSPaK4ahBkiXRsdQ1vCUbG9Tgc+8f9jVTtacPNxWd/X2qM/1WK1I2YvnhedBk1i8fBpTFOtT3GLlJrxVOYVCmsV78av6YSO9dwTJUYTR8K82PPYtL7TZK5q2ODyVWZ64tCc4z8/Ixhr006DDrKK/T1dAaHk286Oc8GmJ2lVbBoc3udrodRVzi9Kge/dFlJNvZbDilEetgmBS5pW9GZWJdd1YBlyTMm4tysDr8Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM6PR0102MB3159.eurprd01.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230016)(346002)(136003)(376002)(396003)(366004)(39860400002)(6512007)(86362001)(478600001)(52116002)(6666004)(6506007)(9686003)(2616005)(1076003)(186003)(6486002)(83380400001)(41300700001)(5660300002)(41320700001)(66476007)(6916009)(4326008)(8676002)(786003)(316002)(7416002)(66946007)(66556008)(30864003)(2906002)(8936002)(38100700002)(579004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?aBXwFjG/bk4j6rDkmrG6xDkyXxWJE6WWc+s2pSYkLU/jnHGjOcseaoxqEegi?=
 =?us-ascii?Q?RAhWTqoX6cdS6kJi05QO5PxcfAgIOKatylk01LS/ZZKaW0Y6H392VAJi0YLX?=
 =?us-ascii?Q?7X4a0ttsWcAjBbXnplm/SdnJS8AoZN1p6321at9HjDkncbc0No9RexpoyFAd?=
 =?us-ascii?Q?kByZ2bRabJswD7u8C6nXDLvt8ZE8dMXvdZKFPcNu8HZFW7ak5HMRp8Y5CVkb?=
 =?us-ascii?Q?AvdRmPLppKHS5UDIxqjzlwpzJNcQg/CAvMqsr841/VjZYt4dGleI1jZhF3i1?=
 =?us-ascii?Q?Tbt9FB8IpF/EFGqz62kK0guXq3Qdv4ZhJdum8KjWQdMpBtgUfetbiTAkUCnt?=
 =?us-ascii?Q?79vPrBB/Qtrb+YCMKc2z/PayA9Yg8LIMsglocsTIE+BOANd87GpHS4N308WK?=
 =?us-ascii?Q?XZqC8xXsHvG2Ot2Wc0zK65HLuXtk0NKPJUcbFqTHwAkD2j8gyjb5CdD5RQf5?=
 =?us-ascii?Q?pPjbxKvhVfASK8AVr1bWLIRy3y80AHLnFumxiSVypqU6fhSC9xaHjIfR1H99?=
 =?us-ascii?Q?EU3LT0XS4UAe6AfjPZHsZvy1kowuFZ3YtIoDl8evvhRV3kSjVm26xX9cvEUf?=
 =?us-ascii?Q?hd0WwgElS38bKb9VD0xDlHHCQzmikZwQiXCgZFVQAEmyXUUr7NTW8JQKow9e?=
 =?us-ascii?Q?mHTSYSw1fJM9zztvIDLr4/bA8K1tOxkSELHqufDIfArjxHyA62I4Nedm1jty?=
 =?us-ascii?Q?qDHRTq0IB75ApdTNbuXcwFZNYo8S4f/XkryYJEGSTFQKkfQ6rO0QkK1lPkEv?=
 =?us-ascii?Q?TXFvAvzn3/9HIKWmx5hg0C0ZcklFeGjjS5fsOmKmqOsIjOB42bDimhkubsbF?=
 =?us-ascii?Q?RkwvFAjdMIZkH+INe74pOPVvUWnSOlfd/9pZVF8kX8BoaSAbHMrUDIoc6STh?=
 =?us-ascii?Q?zbkBIHE3GxFryX/2hy32ipU+WUSDyPNDi/Nnsi+I0083MVyJYW+EDSj+dw04?=
 =?us-ascii?Q?OPK9eOjxYU8BLbvJzAFfiW7P4eXSWQn4CDrhAJF4LmJStdtppXZWYkRLVA3e?=
 =?us-ascii?Q?7TOrL74fTCGdy+kfS2UJE3UJWqlwulMbdeGGzhQCXNi7Uq745XmDE6dvOAoP?=
 =?us-ascii?Q?Nz3JQYJVnnDfJcF7ke5EbHV1uli22VdHd7/cmhzBmnI2PD9OeuBfsTcDuh3L?=
 =?us-ascii?Q?MKzwcUno5OwkHwNTuXamcJ38cRJm5aLoRXRh/8aPTdySN7JiGOL7K0DDdKKq?=
 =?us-ascii?Q?eP0iqCqSSmSySwIMe3Hd93wNHpkKqHNEuW6FOzrpnb0TpHuvJTcAXoRNDgp4?=
 =?us-ascii?Q?xewtgQ8+2iOW8EHpDO95as0jWJezzephA1xbt2hsQJAuei9nN2PTDsAVMq1H?=
 =?us-ascii?Q?Jhe/EQmL/ErQdc8N83GjsIVZm41mUA5m2iXE8m+pD0j+w6SDLe5GzD/k/z61?=
 =?us-ascii?Q?ixvO+RQ10OcQaakwc6ZwIGiS6YI3zvXxhx/r+B/U0dHMUNOFdPSOk0i0BIpk?=
 =?us-ascii?Q?oMxVMG79sCeuleUJ851PhwzDT7qfG8gj9CScZJ13iNdOPwYPghA4JYbFnrNN?=
 =?us-ascii?Q?udwbkdvZrgCONnPA0w5IRbtjitM6Vg4EK0Tdtzx1sJDr+Hj+ZHSwb95ih5Mz?=
 =?us-ascii?Q?U3u1vWt/QDhrQyzbB7+AW6IgdtJB/ST/yrxjHTZL/Mlk9/PV74G26rKu6XtX?=
 =?us-ascii?Q?0PeHiXGidQo/QKIOk3sts0lA0l+Zh47xHC+d4t4Kw0ACfLMI4YlYjYGs5Enk?=
 =?us-ascii?Q?o3d7VnRZYu+fI6jMJkBRXoySCaw=3D?=
X-OriginatorOrg: stud.acs.upb.ro
X-MS-Exchange-CrossTenant-Network-Message-Id: 87d43a7f-1c87-42a8-554c-08da81ede70e
X-MS-Exchange-CrossTenant-AuthSource: AM6PR0102MB3159.eurprd01.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Aug 2022 14:20:01.2554
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 2d8cc8ba-8dda-4334-9e5c-fac2092e9bac
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +V0GquQ6HLMzUeOAOIMMbx4/9x3I+4cML6ToBzVKHJXsz1pje9wBeyWq4UX0I0vhjBzvaypnW5klI3KHzmmdWmVUgp8WpHApwioJliVd3o0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR01MB8023
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alexandru Tachici <alexandru.tachici@analog.com>

The ADIN1110 is a low power single port 10BASE-T1L MAC-PHY
designed for industrial Ethernet applications. It integrates
an Ethernet PHY core with a MAC and all the associated analog
circuitry, input and output clock buffering.

ADIN1110 MAC-PHY encapsulates the ADIN1100 PHY. The PHY registers
can be accessed through the MDIO MAC registers.
We are registering an MDIO bus with custom read/write in order
to let the PHY to be discovered by the PAL. This will let
the ADIN1100 Linux driver to probe and take control of
the PHY.

The ADIN2111 is a low power, low complexity, two-Ethernet ports
switch with integrated 10BASE-T1L PHYs and one serial peripheral
interface (SPI) port.

The device is designed for industrial Ethernet applications using
low power constrained nodes and is compliant with the IEEE 802.3cg-2019
Ethernet standard for long reach 10 Mbps single pair Ethernet (SPE).
The switch supports various routing configurations between
the two Ethernet ports and the SPI host port providing a flexible
solution for line, daisy-chain, or ring network topologies.

The ADIN2111 supports cable reach of up to 1700 meters with ultra
low power consumption of 77 mW. The two PHY cores support the
1.0 V p-p operating mode and the 2.4 V p-p operating mode defined
in the IEEE 802.3cg standard.

The device integrates the switch, two Ethernet physical layer (PHY)
cores with a media access control (MAC) interface and all the
associated analog circuitry, and input and output clock buffering.

The device also includes internal buffer queues, the SPI and
subsystem registers, as well as the control logic to manage the reset
and clock control and hardware pin configuration.

Access to the PHYs is exposed via an internal MDIO bus. Writes/reads
can be performed by reading/writing to the ADIN2111 MDIO registers
via SPI.

On probe, for each port, a struct net_device is allocated and
registered. When both ports are added to the same bridge, the driver
will enable offloading of frame forwarding at the hardware level.

Driver offers STP support. Normal operation on forwarding state.
Allows only frames with the 802.1d DA to be passed to the host
when in any of the other states.

Supports both VEB and VEPA modes. In VEB mode multicast/broadcast
and unknown frames are handled by the ADIN2111, sw bridge will
not see them (this is to save SPI bandwidth). In VEPA mode,
all forwarding will be handled by the sw bridge, ADIN2111 will
not attempt to forward any frames in hardware to the other port.

Co-developed-by: Lennart Franzen <lennart@lfdomain.com>
Signed-off-by: Lennart Franzen <lennart@lfdomain.com>
Signed-off-by: Alexandru Tachici <alexandru.tachici@analog.com>
---
 drivers/net/ethernet/Kconfig        |    1 +
 drivers/net/ethernet/Makefile       |    1 +
 drivers/net/ethernet/adi/Kconfig    |   28 +
 drivers/net/ethernet/adi/Makefile   |    6 +
 drivers/net/ethernet/adi/adin1110.c | 1458 +++++++++++++++++++++++++++
 5 files changed, 1494 insertions(+)
 create mode 100644 drivers/net/ethernet/adi/Kconfig
 create mode 100644 drivers/net/ethernet/adi/Makefile
 create mode 100644 drivers/net/ethernet/adi/adin1110.c

diff --git a/drivers/net/ethernet/Kconfig b/drivers/net/ethernet/Kconfig
index 9a55c1d5a0a1..1917da784191 100644
--- a/drivers/net/ethernet/Kconfig
+++ b/drivers/net/ethernet/Kconfig
@@ -121,6 +121,7 @@ config LANTIQ_XRX200
 	  Support for the PMAC of the Gigabit switch (GSWIP) inside the
 	  Lantiq / Intel VRX200 VDSL SoC
 
+source "drivers/net/ethernet/adi/Kconfig"
 source "drivers/net/ethernet/litex/Kconfig"
 source "drivers/net/ethernet/marvell/Kconfig"
 source "drivers/net/ethernet/mediatek/Kconfig"
diff --git a/drivers/net/ethernet/Makefile b/drivers/net/ethernet/Makefile
index c06e75ed4231..0d872d4efcd1 100644
--- a/drivers/net/ethernet/Makefile
+++ b/drivers/net/ethernet/Makefile
@@ -8,6 +8,7 @@ obj-$(CONFIG_NET_VENDOR_8390) += 8390/
 obj-$(CONFIG_NET_VENDOR_ACTIONS) += actions/
 obj-$(CONFIG_NET_VENDOR_ADAPTEC) += adaptec/
 obj-$(CONFIG_GRETH) += aeroflex/
+obj-$(CONFIG_NET_VENDOR_ADI) += adi/
 obj-$(CONFIG_NET_VENDOR_AGERE) += agere/
 obj-$(CONFIG_NET_VENDOR_ALACRITECH) += alacritech/
 obj-$(CONFIG_NET_VENDOR_ALLWINNER) += allwinner/
diff --git a/drivers/net/ethernet/adi/Kconfig b/drivers/net/ethernet/adi/Kconfig
new file mode 100644
index 000000000000..da3bdd302502
--- /dev/null
+++ b/drivers/net/ethernet/adi/Kconfig
@@ -0,0 +1,28 @@
+# SPDX-License-Identifier: GPL-2.0 OR BSD-2-Clause
+#
+# Analog Devices device configuration
+#
+
+config NET_VENDOR_ADI
+	bool "Analog Devices devices"
+	default y
+	depends on SPI
+	help
+	  If you have a network (Ethernet) card belonging to this class, say Y.
+
+	  Note that the answer to this question doesn't directly affect the
+	  kernel: saying N will just cause the configurator to skip all
+	  the questions about ADI devices. If you say Y, you will be asked
+	  for your specific card in the following questions.
+
+if NET_VENDOR_ADI
+
+config ADIN1110
+	tristate "Analog Devices ADIN1110 MAC-PHY"
+	depends on SPI && NET_SWITCHDEV
+	select CRC8
+	help
+	  Say yes here to build support for Analog Devices ADIN1110
+	  Low Power 10BASE-T1L Ethernet MAC-PHY.
+
+endif # NET_VENDOR_ADI
diff --git a/drivers/net/ethernet/adi/Makefile b/drivers/net/ethernet/adi/Makefile
new file mode 100644
index 000000000000..d0383d94303c
--- /dev/null
+++ b/drivers/net/ethernet/adi/Makefile
@@ -0,0 +1,6 @@
+# SPDX-License-Identifier: GPL-2.0 OR BSD-2-Clause
+#
+# Makefile for the Analog Devices network device drivers.
+#
+
+obj-$(CONFIG_ADIN1110) += adin1110.o
diff --git a/drivers/net/ethernet/adi/adin1110.c b/drivers/net/ethernet/adi/adin1110.c
new file mode 100644
index 000000000000..dd5c7624b752
--- /dev/null
+++ b/drivers/net/ethernet/adi/adin1110.c
@@ -0,0 +1,1458 @@
+// SPDX-License-Identifier: GPL-2.0 OR BSD-2-Clause
+/* ADIN1110 Low Power 10BASE-T1L Ethernet MAC-PHY
+ * ADIN2111 2-Port Ethernet Switch with Integrated 10BASE-T1L PHY
+ *
+ * Copyright 2021 Analog Devices Inc.
+ */
+
+#include <linux/bitfield.h>
+#include <linux/bits.h>
+#include <linux/cache.h>
+#include <linux/crc8.h>
+#include <linux/etherdevice.h>
+#include <linux/ethtool.h>
+#include <linux/if_bridge.h>
+#include <linux/interrupt.h>
+#include <linux/iopoll.h>
+#include <linux/gpio.h>
+#include <linux/kernel.h>
+#include <linux/mii.h>
+#include <linux/module.h>
+#include <linux/netdevice.h>
+#include <linux/regulator/consumer.h>
+#include <linux/phy.h>
+#include <linux/property.h>
+#include <linux/spi/spi.h>
+
+#include <net/switchdev.h>
+
+#include <asm/unaligned.h>
+
+#define ADIN1110_PHY_ID				0x1
+
+#define ADIN1110_RESET				0x03
+#define   ADIN1110_SWRESET			BIT(0)
+
+#define ADIN1110_CONFIG1			0x04
+#define   ADIN1110_CONFIG1_SYNC			BIT(15)
+
+#define ADIN1110_CONFIG2			0x06
+#define   ADIN2111_FWD_UNK2PORT			GENMASK(14, 13)
+#define   ADIN2111_P2_FWD_UNK2HOST		BIT(12)
+#define   ADIN1110_CRC_APPEND			BIT(5)
+#define   ADIN1110_FWD_UNK2HOST			BIT(2)
+
+#define ADIN1110_STATUS0			0x08
+
+#define ADIN1110_STATUS1			0x09
+#define   ADIN2111_P2_RX_RDY			BIT(17)
+#define   ADIN1110_SPI_ERR			BIT(10)
+#define   ADIN1110_RX_RDY			BIT(4)
+
+#define ADIN1110_IMASK1				0x0D
+#define   ADIN2111_RX_RDY_IRQ			BIT(17)
+#define   ADIN1110_SPI_ERR_IRQ			BIT(10)
+#define   ADIN1110_RX_RDY_IRQ			BIT(4)
+#define   ADIN1110_TX_RDY_IRQ			BIT(3)
+
+#define ADIN1110_MDIOACC			0x20
+#define   ADIN1110_MDIO_TRDONE			BIT(31)
+#define   ADIN1110_MDIO_ST			GENMASK(29, 28)
+#define   ADIN1110_MDIO_OP			GENMASK(27, 26)
+#define   ADIN1110_MDIO_PRTAD			GENMASK(25, 21)
+#define   ADIN1110_MDIO_DEVAD			GENMASK(20, 16)
+#define   ADIN1110_MDIO_DATA			GENMASK(15, 0)
+
+#define ADIN1110_TX_FSIZE			0x30
+#define ADIN1110_TX				0x31
+#define ADIN1110_TX_SPACE			0x32
+
+#define ADIN1110_MAC_ADDR_FILTER_UPR		0x50
+#define   ADIN2111_MAC_ADDR_APPLY2PORT2		BIT(31)
+#define   ADIN1110_MAC_ADDR_APPLY2PORT		BIT(30)
+#define   ADIN2111_MAC_ADDR_TO_OTHER_PORT	BIT(17)
+#define   ADIN1110_MAC_ADDR_TO_HOST		BIT(16)
+
+#define ADIN1110_MAC_ADDR_FILTER_LWR		0x51
+
+#define ADIN1110_MAC_ADDR_MASK_UPR		0x70
+#define ADIN1110_MAC_ADDR_MASK_LWR		0x71
+
+#define ADIN1110_RX_FSIZE			0x90
+#define ADIN1110_RX				0x91
+
+#define ADIN2111_RX_P2_FSIZE			0xC0
+#define ADIN2111_RX_P2				0xC1
+
+#define ADIN1110_CLEAR_STATUS0			0xFFF
+
+/* MDIO_OP codes */
+#define ADIN1110_MDIO_OP_WR			0x1
+#define ADIN1110_MDIO_OP_RD			0x3
+
+#define ADIN1110_CD				BIT(7)
+#define ADIN1110_WRITE				BIT(5)
+
+#define ADIN1110_MAX_BUFF			2048
+#define ADIN1110_MAX_FRAMES_READ		64
+#define ADIN1110_WR_HEADER_LEN			2
+#define ADIN1110_FRAME_HEADER_LEN		2
+#define ADIN1110_INTERNAL_SIZE_HEADER_LEN	2
+#define ADIN1110_RD_HEADER_LEN			3
+#define ADIN1110_REG_LEN			4
+#define ADIN1110_FEC_LEN			4
+
+#define ADIN1110_PHY_ID_VAL			0x0283BC91
+#define ADIN2111_PHY_ID_VAL			0x0283BCA1
+
+#define ADIN_MAC_MAX_PORTS			2
+
+#define ADIN_MAC_MULTICAST_ADDR_SLOT		0
+#define ADIN_MAC_BPDU_ADDR_SLOT			1
+#define ADIN_MAC_P1_ADDR_SLOT			1
+#define ADIN_MAC_P2_ADDR_SLOT			2
+#define ADIN_MAC_BROADCAST_ADDR_SLOT		3
+
+DECLARE_CRC8_TABLE(adin1110_crc_table);
+
+enum adin1110_chips_id {
+	ADIN1110_MAC = 0,
+	ADIN2111_MAC,
+};
+
+struct adin1110_cfg {
+	enum adin1110_chips_id	id;
+	char			name[MDIO_NAME_SIZE];
+	u32			phy_ids[PHY_MAX_ADDR];
+	u32			ports_nr;
+	u32			phy_id_val;
+};
+
+struct adin1110_port_priv {
+	struct adin1110_priv		*priv;
+	struct net_device		*netdev;
+	struct net_device		*bridge;
+	struct phy_device		*phydev;
+	struct work_struct		tx_work;
+	u64				rx_packets;
+	u64				tx_packets;
+	u64				rx_bytes;
+	u64				tx_bytes;
+	struct work_struct		rx_mode_work;
+	u32				flags;
+	struct sk_buff_head		txq;
+	u32				nr;
+	u8				state;
+	struct adin1110_cfg		*cfg;
+};
+
+struct adin1110_priv {
+	struct mutex			lock; /* protect spi */
+	spinlock_t			state_lock; /* protect RX mode */
+	bool				forwarding;
+	bool				br_mode;
+	struct mii_bus			*mii_bus;
+	struct spi_device		*spidev;
+	bool				append_crc;
+	struct adin1110_cfg		*cfg;
+	u32				tx_space;
+	u32				irq_mask;
+	int				irq;
+	struct adin1110_port_priv	*ports[ADIN_MAC_MAX_PORTS];
+	char				mii_bus_name[MII_BUS_ID_SIZE];
+	u8				data[ADIN1110_MAX_BUFF] ____cacheline_aligned;
+};
+
+static struct adin1110_cfg adin1110_cfgs[] = {
+	{
+		.id = ADIN1110_MAC,
+		.name = "adin1110",
+		.phy_ids = {1},
+		.ports_nr = 1,
+		.phy_id_val = ADIN1110_PHY_ID_VAL,
+	},
+	{
+		.id = ADIN2111_MAC,
+		.name = "adin2111",
+		.phy_ids = {1, 2},
+		.ports_nr = 2,
+		.phy_id_val = ADIN2111_PHY_ID_VAL,
+	},
+};
+
+static u8 adin1110_crc_data(u8 *data, u32 len)
+{
+	return crc8(adin1110_crc_table, data, len, 0);
+}
+
+static int adin1110_read_reg(struct adin1110_priv *priv, u16 reg, u32 *val)
+{
+	u32 header_len = ADIN1110_RD_HEADER_LEN;
+	u32 read_len = ADIN1110_REG_LEN;
+	struct spi_transfer t[2] = {0};
+	int ret;
+
+	priv->data[0] = ADIN1110_CD | FIELD_GET(GENMASK(12, 8), reg);
+	priv->data[1] = FIELD_GET(GENMASK(7, 0), reg);
+	priv->data[2] = 0x00;
+
+	if (priv->append_crc) {
+		priv->data[2] = adin1110_crc_data(&priv->data[0], 2);
+		priv->data[3] = 0x00;
+		header_len++;
+	}
+
+	t[0].tx_buf = &priv->data[0];
+	t[0].len = header_len;
+
+	if (priv->append_crc)
+		read_len++;
+
+	memset(&priv->data[header_len], 0, read_len);
+	t[1].rx_buf = &priv->data[header_len];
+	t[1].len = read_len;
+
+	ret = spi_sync_transfer(priv->spidev, t, 2);
+	if (ret)
+		return ret;
+
+	if (priv->append_crc) {
+		u8 recv_crc;
+		u8 crc;
+
+		crc = adin1110_crc_data(&priv->data[header_len], ADIN1110_REG_LEN);
+		recv_crc = priv->data[header_len + ADIN1110_REG_LEN];
+
+		if (crc != recv_crc) {
+			dev_err_ratelimited(&priv->spidev->dev, "CRC error.");
+			return -EBADMSG;
+		}
+	}
+
+	*val = get_unaligned_be32(&priv->data[header_len]);
+
+	return ret;
+}
+
+static int adin1110_write_reg(struct adin1110_priv *priv, u16 reg, u32 val)
+{
+	u32 header_len = ADIN1110_WR_HEADER_LEN;
+	u32 write_len = ADIN1110_REG_LEN;
+
+	priv->data[0] = ADIN1110_CD | ADIN1110_WRITE | FIELD_GET(GENMASK(12, 8), reg);
+	priv->data[1] = FIELD_GET(GENMASK(7, 0), reg);
+
+	if (priv->append_crc) {
+		priv->data[2] = adin1110_crc_data(&priv->data[0], header_len);
+		header_len++;
+	}
+
+	put_unaligned_be32(val, &priv->data[header_len]);
+	if (priv->append_crc) {
+		priv->data[header_len + write_len] = adin1110_crc_data(&priv->data[header_len],
+								       write_len);
+		write_len++;
+	}
+
+	return spi_write(priv->spidev, &priv->data[0], header_len + write_len);
+}
+
+static int adin1110_set_bits(struct adin1110_priv *priv, u16 reg, unsigned long mask,
+			     unsigned long val)
+{
+	u32 write_val;
+	int ret;
+
+	ret = adin1110_read_reg(priv, reg, &write_val);
+	if (ret < 0)
+		return ret;
+
+	set_mask_bits(&write_val, mask, val);
+
+	return adin1110_write_reg(priv, reg, write_val);
+}
+
+static int adin1110_round_len(int len)
+{
+	/* can read/write only mutiples of 4 bytes of payload */
+	len = ALIGN(len, 4);
+
+	/* NOTE: ADIN1110_WR_HEADER_LEN should be used for write ops. */
+	if (len + ADIN1110_RD_HEADER_LEN > ADIN1110_MAX_BUFF)
+		return -EINVAL;
+
+	return len;
+}
+
+static int adin1110_read_fifo(struct adin1110_port_priv *port_priv)
+{
+	struct adin1110_priv *priv = port_priv->priv;
+	u32 header_len = ADIN1110_RD_HEADER_LEN;
+	struct spi_transfer t[2] = {0};
+	u32 frame_size_no_fcs;
+	struct sk_buff *rxb;
+	u32 frame_size;
+	int round_len;
+	u16 reg;
+	int ret;
+
+	if (!port_priv->nr) {
+		reg = ADIN1110_RX;
+		ret = adin1110_read_reg(priv, ADIN1110_RX_FSIZE, &frame_size);
+	} else {
+		reg = ADIN2111_RX_P2;
+		ret = adin1110_read_reg(priv, ADIN2111_RX_P2_FSIZE, &frame_size);
+	}
+
+	if (ret < 0)
+		return ret;
+
+	/* the read frame size includes the extra 2 bytes from the  ADIN1110 frame header */
+	if (frame_size < ADIN1110_FRAME_HEADER_LEN + ADIN1110_FEC_LEN)
+		return ret;
+
+	round_len = adin1110_round_len(frame_size);
+	if (round_len < 0)
+		return ret;
+
+	frame_size_no_fcs = frame_size - ADIN1110_FRAME_HEADER_LEN - ADIN1110_FEC_LEN;
+
+	rxb = netdev_alloc_skb(port_priv->netdev, round_len);
+	if (!rxb)
+		return -ENOMEM;
+
+	memset(priv->data, 0, round_len + ADIN1110_RD_HEADER_LEN);
+
+	priv->data[0] = ADIN1110_CD | FIELD_GET(GENMASK(12, 8), reg);
+	priv->data[1] = FIELD_GET(GENMASK(7, 0), reg);
+
+	if (priv->append_crc) {
+		priv->data[2] = adin1110_crc_data(&priv->data[0], 2);
+		header_len++;
+	}
+
+	skb_put(rxb, frame_size_no_fcs + ADIN1110_FRAME_HEADER_LEN);
+
+	t[0].tx_buf = &priv->data[0];
+	t[0].len = header_len;
+
+	t[1].rx_buf = &rxb->data[0];
+	t[1].len = round_len;
+
+	ret = spi_sync_transfer(priv->spidev, t, 2);
+	if (ret) {
+		kfree_skb(rxb);
+		return ret;
+	}
+
+	skb_pull(rxb, ADIN1110_FRAME_HEADER_LEN);
+
+	/* Already forwarded to the other port if it did not match any MAC Addresses. */
+	if (priv->forwarding)
+		rxb->offload_fwd_mark = 1;
+
+	rxb->protocol = eth_type_trans(rxb, port_priv->netdev);
+
+	netif_rx(rxb);
+
+	port_priv->rx_bytes += frame_size - ADIN1110_FRAME_HEADER_LEN;
+	port_priv->rx_packets++;
+
+	return 0;
+}
+
+static int adin1110_write_fifo(struct adin1110_port_priv *port_priv, struct sk_buff *txb)
+{
+	struct adin1110_priv *priv = port_priv->priv;
+	u32 header_len = ADIN1110_WR_HEADER_LEN;
+	__be16 frame_header;
+	int padding = 0;
+	int padded_len;
+	int round_len;
+	int ret;
+
+	/* Pad frame to 64 byte length,
+	 * MAC nor PHY will otherwise add the
+	 * required padding.
+	 * The FEC will be added by the MAC internally.
+	 */
+	if (txb->len + ADIN1110_FEC_LEN < 64)
+		padding = 64 - (txb->len + ADIN1110_FEC_LEN);
+
+	padded_len = txb->len + padding + ADIN1110_FRAME_HEADER_LEN;
+
+	round_len = adin1110_round_len(padded_len);
+	if (round_len < 0)
+		return round_len;
+
+	ret = adin1110_write_reg(priv, ADIN1110_TX_FSIZE, padded_len);
+	if (ret < 0)
+		return ret;
+
+	memset(priv->data, 0, round_len + ADIN1110_WR_HEADER_LEN);
+
+	priv->data[0] = ADIN1110_CD | ADIN1110_WRITE | FIELD_GET(GENMASK(12, 8), ADIN1110_TX);
+	priv->data[1] = FIELD_GET(GENMASK(7, 0), ADIN1110_TX);
+	if (priv->append_crc) {
+		priv->data[2] = adin1110_crc_data(&priv->data[0], 2);
+		header_len++;
+	}
+
+	/* mention the port on which to send the frame in the frame header */
+	frame_header = cpu_to_be16(port_priv->nr);
+	memcpy(&priv->data[header_len], &frame_header, ADIN1110_FRAME_HEADER_LEN);
+
+	memcpy(&priv->data[header_len + ADIN1110_FRAME_HEADER_LEN], txb->data, txb->len);
+
+	ret = spi_write(priv->spidev, &priv->data[0], round_len + header_len);
+	if (ret < 0)
+		return ret;
+
+	port_priv->tx_bytes += txb->len;
+	port_priv->tx_packets++;
+
+	return 0;
+}
+
+static int adin1110_read_mdio_acc(struct adin1110_priv *priv)
+{
+	u32 val;
+	int ret;
+
+	mutex_lock(&priv->lock);
+	ret = adin1110_read_reg(priv, ADIN1110_MDIOACC, &val);
+	mutex_unlock(&priv->lock);
+	if (ret < 0)
+		return 0;
+
+	return val;
+}
+
+static int adin1110_mdio_read(struct mii_bus *bus, int phy_id, int reg)
+{
+	struct adin1110_priv *priv = bus->priv;
+	u32 val = 0;
+	int ret;
+
+	if (mdio_phy_id_is_c45(phy_id))
+		return -EOPNOTSUPP;
+
+	val |= FIELD_PREP(ADIN1110_MDIO_OP, ADIN1110_MDIO_OP_RD);
+	val |= FIELD_PREP(ADIN1110_MDIO_ST, 0x1);
+	val |= FIELD_PREP(ADIN1110_MDIO_PRTAD, phy_id);
+	val |= FIELD_PREP(ADIN1110_MDIO_DEVAD, reg);
+
+	/* write the clause 22 read command to the chip */
+	mutex_lock(&priv->lock);
+	ret = adin1110_write_reg(priv, ADIN1110_MDIOACC, val);
+	mutex_unlock(&priv->lock);
+	if (ret < 0)
+		return ret;
+
+	/* ADIN1110_MDIO_TRDONE BIT of the ADIN1110_MDIOACC
+	 * register is set when the read is done.
+	 * After the transaction is done, ADIN1110_MDIO_DATA
+	 * bitfield of ADIN1110_MDIOACC register will contain
+	 * the requested register value.
+	 */
+	ret = readx_poll_timeout(adin1110_read_mdio_acc, priv, val, (val & ADIN1110_MDIO_TRDONE),
+				 10000, 30000);
+	if (ret < 0)
+		return ret;
+
+	return (val & ADIN1110_MDIO_DATA);
+}
+
+static int adin1110_mdio_write(struct mii_bus *bus, int phy_id, int reg, u16 reg_val)
+{
+	struct adin1110_priv *priv = bus->priv;
+	u32 val = 0;
+	int ret;
+
+	if (mdio_phy_id_is_c45(phy_id))
+		return -EOPNOTSUPP;
+
+	val |= FIELD_PREP(ADIN1110_MDIO_OP, ADIN1110_MDIO_OP_WR);
+	val |= FIELD_PREP(ADIN1110_MDIO_ST, 0x1);
+	val |= FIELD_PREP(ADIN1110_MDIO_PRTAD, phy_id);
+	val |= FIELD_PREP(ADIN1110_MDIO_DEVAD, reg);
+	val |= FIELD_PREP(ADIN1110_MDIO_DATA, reg_val);
+
+	/* write the clause 22 write command to the chip */
+	mutex_lock(&priv->lock);
+	ret = adin1110_write_reg(priv, ADIN1110_MDIOACC, val);
+	mutex_unlock(&priv->lock);
+	if (ret < 0)
+		return ret;
+
+	return readx_poll_timeout(adin1110_read_mdio_acc, priv, val, (val & ADIN1110_MDIO_TRDONE),
+				  10000, 30000);
+}
+
+/* ADIN1110 MAC-PHY contains an ADIN1100 PHY.
+ * ADIN2111 MAC-PHY contains two ADIN1100 PHYs.
+ * By registering a new MDIO bus we allow the PAL to discover
+ * the encapsulated PHY and probe the ADIN1100 driver.
+ */
+static int adin1110_register_mdiobus(struct adin1110_priv *priv, struct device *dev)
+{
+	struct mii_bus *mii_bus;
+	int ret;
+
+	mii_bus = devm_mdiobus_alloc(dev);
+	if (!mii_bus)
+		return -ENOMEM;
+
+	snprintf(priv->mii_bus_name, MII_BUS_ID_SIZE, "%s-%u",
+		 priv->cfg->name, priv->spidev->chip_select);
+
+	mii_bus->name = priv->mii_bus_name;
+	mii_bus->read = adin1110_mdio_read;
+	mii_bus->write = adin1110_mdio_write;
+	mii_bus->priv = priv;
+	mii_bus->parent = dev;
+	mii_bus->phy_mask = ~((u32)GENMASK(2, 0));
+	mii_bus->probe_capabilities = MDIOBUS_C22;
+	snprintf(mii_bus->id, MII_BUS_ID_SIZE, "%s", dev_name(dev));
+
+	ret = devm_mdiobus_register(dev, mii_bus);
+	if (ret)
+		return ret;
+
+	priv->mii_bus = mii_bus;
+
+	return 0;
+}
+
+static bool adin1110_port_rx_ready(struct adin1110_port_priv *port_priv, u32 status)
+{
+	if (!port_priv->nr)
+		return !!(status & ADIN1110_RX_RDY);
+	else
+		return !!(status & ADIN2111_P2_RX_RDY);
+}
+
+static void adin1110_read_frames(struct adin1110_port_priv *port_priv, unsigned int budget)
+{
+	struct adin1110_priv *priv = port_priv->priv;
+	u32 status1;
+	int ret;
+
+	while (budget) {
+		ret = adin1110_read_reg(priv, ADIN1110_STATUS1, &status1);
+		if (ret < 0)
+			return;
+
+		if (!adin1110_port_rx_ready(port_priv, status1))
+			break;
+
+		ret = adin1110_read_fifo(port_priv);
+		if (ret < 0)
+			return;
+
+		budget--;
+	}
+}
+
+static void adin1110_wake_queues(struct adin1110_priv *priv)
+{
+	int i;
+
+	for (i = 0; i < priv->cfg->ports_nr; i++)
+		netif_wake_queue(priv->ports[i]->netdev);
+}
+
+static irqreturn_t adin1110_irq(int irq, void *p)
+{
+	struct adin1110_priv *priv = p;
+	u32 status1;
+	u32 val;
+	int ret;
+	int i;
+
+	mutex_lock(&priv->lock);
+
+	ret = adin1110_read_reg(priv, ADIN1110_STATUS1, &status1);
+	if (ret < 0)
+		goto out;
+
+	if (priv->append_crc && (status1 & ADIN1110_SPI_ERR))
+		dev_warn_ratelimited(&priv->spidev->dev, "SPI CRC error on write.\n");
+
+	ret = adin1110_read_reg(priv, ADIN1110_TX_SPACE, &val);
+	if (ret < 0)
+		goto out;
+
+	/* TX FIFO space is expressed in half-words */
+	priv->tx_space = 2 * val;
+
+	for (i = 0; i < priv->cfg->ports_nr; i++) {
+		if (adin1110_port_rx_ready(priv->ports[i], status1))
+			adin1110_read_frames(priv->ports[i], ADIN1110_MAX_FRAMES_READ);
+	}
+
+	/* clear IRQ sources */
+	adin1110_write_reg(priv, ADIN1110_STATUS0, ADIN1110_CLEAR_STATUS0);
+	adin1110_write_reg(priv, ADIN1110_STATUS1, priv->irq_mask);
+
+out:
+	mutex_unlock(&priv->lock);
+
+	if (priv->tx_space > 0 && ret >= 0)
+		adin1110_wake_queues(priv);
+
+	return IRQ_HANDLED;
+}
+
+/* ADIN1110 can filter up to 16 MAC addresses, mac_nr here is the slot used */
+static int adin1110_write_mac_address(struct adin1110_port_priv *port_priv, int mac_nr,
+				      const u8 *addr, u8 *mask)
+{
+	struct adin1110_priv *priv = port_priv->priv;
+	u32 offset = mac_nr * 2;
+	u32 port_rules;
+	int ret;
+	u32 val;
+
+	port_rules = ADIN1110_MAC_ADDR_APPLY2PORT;
+	if (priv->cfg->id == ADIN2111_MAC)
+		port_rules |= ADIN2111_MAC_ADDR_APPLY2PORT2;
+
+	if (mac_nr != ADIN_MAC_P1_ADDR_SLOT && mac_nr != ADIN_MAC_P2_ADDR_SLOT && priv->forwarding)
+		port_rules |= ADIN2111_MAC_ADDR_TO_OTHER_PORT;
+
+	/* tell MAC to forward this DA to host */
+	val = port_rules | ADIN1110_MAC_ADDR_TO_HOST;
+	val |= get_unaligned_be16(&addr[0]);
+	ret = adin1110_write_reg(priv, ADIN1110_MAC_ADDR_FILTER_UPR + offset, val);
+	if (ret < 0)
+		return ret;
+
+	val = get_unaligned_be32(&addr[2]);
+	ret =  adin1110_write_reg(priv, ADIN1110_MAC_ADDR_FILTER_LWR + offset, val);
+	if (ret < 0)
+		return ret;
+
+	/* only the first two MAC address slots support masking */
+	if (mac_nr < ADIN_MAC_P2_ADDR_SLOT) {
+		val = get_unaligned_be16(&mask[0]);
+		ret = adin1110_write_reg(priv, ADIN1110_MAC_ADDR_MASK_UPR + offset, val);
+		if (ret < 0)
+			return ret;
+
+		val = get_unaligned_be32(&mask[2]);
+		return adin1110_write_reg(priv, ADIN1110_MAC_ADDR_MASK_LWR + offset, val);
+	}
+
+	return 0;
+}
+
+static int adin1110_clear_mac_address(struct adin1110_port_priv *port_priv, int mac_nr)
+{
+	struct adin1110_priv *priv = port_priv->priv;
+	u32 offset = mac_nr * 2;
+	int ret;
+
+	ret = adin1110_write_reg(priv, ADIN1110_MAC_ADDR_FILTER_UPR + offset, 0);
+	if (ret < 0)
+		return ret;
+
+	ret =  adin1110_write_reg(priv, ADIN1110_MAC_ADDR_FILTER_LWR + offset, 0);
+	if (ret < 0)
+		return ret;
+
+	/* only the first two MAC address slots are maskable */
+	if (mac_nr <= 1) {
+		ret = adin1110_write_reg(priv, ADIN1110_MAC_ADDR_MASK_UPR + offset, 0);
+		if (ret < 0)
+			return ret;
+
+		ret = adin1110_write_reg(priv, ADIN1110_MAC_ADDR_MASK_LWR + offset, 0);
+	}
+
+	return ret;
+}
+
+static int adin1110_multicast_filter(struct adin1110_port_priv *port_priv, int mac_nr,
+				     bool accept_multicast)
+{
+	u8 mask[ETH_ALEN] = {0};
+	u8 mac[ETH_ALEN] = {0};
+
+	if (accept_multicast) {
+		mask[0] = BIT(0);
+		mac[0] = BIT(0);
+
+		return adin1110_write_mac_address(port_priv, mac_nr, mac, mask);
+	}
+
+	return adin1110_clear_mac_address(port_priv, mac_nr);
+}
+
+static int adin1110_broadcasts_filter(struct adin1110_port_priv *port_priv, int mac_nr,
+				      bool accept_broadcast)
+{
+	u8 mask[ETH_ALEN];
+
+	memset(mask, 0xFF, ETH_ALEN);
+
+	if (accept_broadcast)
+		return adin1110_write_mac_address(port_priv, mac_nr, mask, mask);
+	else
+		return adin1110_clear_mac_address(port_priv, mac_nr);
+}
+
+static int adin1110_set_mac_address(struct net_device *netdev, const unsigned char *dev_addr)
+{
+	struct adin1110_port_priv *port_priv = netdev_priv(netdev);
+	u8 mask[ETH_ALEN];
+	u32 mac_slot;
+
+	if (!is_valid_ether_addr(dev_addr))
+		return -EADDRNOTAVAIL;
+
+	eth_hw_addr_set(netdev, dev_addr);
+	memset(mask, 0xFF, ETH_ALEN);
+
+	mac_slot = (!port_priv->nr) ?  ADIN_MAC_P1_ADDR_SLOT : ADIN_MAC_P2_ADDR_SLOT;
+
+	return adin1110_write_mac_address(port_priv, mac_slot, netdev->dev_addr, mask);
+}
+
+static int adin1110_ndo_set_mac_address(struct net_device *netdev, void *addr)
+{
+	struct sockaddr *sa = addr;
+
+	if (netif_running(netdev))
+		return -EBUSY;
+
+	return adin1110_set_mac_address(netdev, sa->sa_data);
+}
+
+static int adin1110_ioctl(struct net_device *netdev, struct ifreq *rq, int cmd)
+{
+	if (!netif_running(netdev))
+		return -EINVAL;
+
+	return phy_do_ioctl(netdev, rq, cmd);
+}
+
+static int adin1110_set_promisc_mode(struct adin1110_port_priv *port_priv, bool promisc)
+{
+	struct adin1110_priv *priv = port_priv->priv;
+	u32 mask;
+
+	if (!port_priv->nr)
+		mask = ADIN1110_FWD_UNK2HOST;
+	else
+		mask = ADIN2111_P2_FWD_UNK2HOST;
+
+	return adin1110_set_bits(priv, ADIN1110_CONFIG2, mask, promisc ? mask : 0);
+}
+
+static int adin1110_setup_rx_mode(struct adin1110_port_priv *port_priv)
+{
+	int ret;
+
+	/* If ADIN2111 does not forward to the other port any frames allow the bridge to set the
+	 * port in promisc mode in order to see all frames
+	 */
+	if (!port_priv->priv->forwarding) {
+		ret = adin1110_set_promisc_mode(port_priv, !!(port_priv->flags & IFF_PROMISC));
+		if (ret < 0)
+			return ret;
+	} else {
+		ret = adin1110_set_promisc_mode(port_priv, false);
+		if (ret < 0)
+			return ret;
+	}
+
+	ret = adin1110_multicast_filter(port_priv, ADIN_MAC_MULTICAST_ADDR_SLOT,
+					!!(port_priv->flags & IFF_ALLMULTI));
+	if (ret < 0)
+		return ret;
+
+	ret = adin1110_broadcasts_filter(port_priv, ADIN_MAC_BROADCAST_ADDR_SLOT,
+					 !!(port_priv->flags & IFF_BROADCAST));
+	if (ret < 0)
+		return ret;
+
+	return adin1110_set_bits(port_priv->priv, ADIN1110_CONFIG1, ADIN1110_CONFIG1_SYNC,
+				 ADIN1110_CONFIG1_SYNC);
+}
+
+static bool adin1110_can_offload_forwarding(struct adin1110_priv *priv)
+{
+	int i;
+
+	if (priv->cfg->id != ADIN2111_MAC)
+		return false;
+
+	/* Let the bridge core do all the forwarding in VEPA mode. */
+	if (priv->br_mode == BRIDGE_MODE_VEPA)
+		return false;
+
+	/* Can't enable forwarding if ports do not belong to the same bridge */
+	if (priv->ports[0]->bridge != priv->ports[1]->bridge || !priv->ports[0]->bridge)
+		return false;
+
+	/* Can't enable forwarding if there is a port that has been blocked by STP */
+	for (i = 0; i < priv->cfg->ports_nr; i++) {
+		if (priv->ports[i]->state != BR_STATE_FORWARDING)
+			return false;
+	}
+
+	return true;
+}
+
+/* Hardware forwarding will take place on ADIN2111 only when both ports belong to the
+ * same bridge and bridge is in VEB mode.
+ */
+static int adin1110_hw_forwarding(struct adin1110_priv *priv, bool enable)
+{
+	int ret;
+
+	mutex_lock(&priv->lock);
+
+	/* Configure MAC to forward unknown host to other port. */
+	ret = adin1110_set_bits(priv, ADIN1110_CONFIG2, ADIN2111_FWD_UNK2PORT,
+				enable ? ADIN2111_FWD_UNK2PORT : 0);
+	if (ret < 0)
+		goto out;
+
+	ret = adin1110_set_bits(priv, ADIN1110_CONFIG1, ADIN1110_CONFIG1_SYNC,
+				ADIN1110_CONFIG1_SYNC);
+
+out:
+	mutex_unlock(&priv->lock);
+
+	if (ret < 0)
+		return ret;
+
+	priv->forwarding = enable;
+
+	return 0;
+}
+
+static void adin1110_rx_mode_work(struct work_struct *work)
+{
+	struct adin1110_port_priv *port_priv = container_of(work, struct adin1110_port_priv, rx_mode_work);
+	struct adin1110_priv *priv = port_priv->priv;
+
+	if (adin1110_can_offload_forwarding(priv))
+		adin1110_hw_forwarding(priv, true);
+	else
+		adin1110_hw_forwarding(priv, false);
+
+	mutex_lock(&priv->lock);
+	adin1110_setup_rx_mode(port_priv);
+	mutex_unlock(&priv->lock);
+}
+
+static void adin1110_set_rx_mode(struct net_device *dev)
+{
+	struct adin1110_port_priv *port_priv = netdev_priv(dev);
+	struct adin1110_priv *priv = port_priv->priv;
+
+	spin_lock(&priv->state_lock);
+
+	port_priv->flags = dev->flags;
+	schedule_work(&port_priv->rx_mode_work);
+
+	spin_unlock(&priv->state_lock);
+}
+
+static int adin1110_net_open(struct net_device *net_dev)
+{
+	struct adin1110_port_priv *port_priv = netdev_priv(net_dev);
+	struct adin1110_priv *priv = port_priv->priv;
+	u32 val;
+	int ret;
+
+	mutex_lock(&priv->lock);
+
+	/* Configure MAC to compute and append the FCS itself. */
+	ret = adin1110_set_bits(priv, ADIN1110_CONFIG2, ADIN1110_CRC_APPEND, ADIN1110_CRC_APPEND);
+	if (ret < 0)
+		goto out;
+
+	val = ADIN1110_TX_RDY_IRQ | ADIN1110_RX_RDY_IRQ | ADIN1110_SPI_ERR_IRQ;
+	if (priv->cfg->id == ADIN2111_MAC)
+		val |= ADIN2111_RX_RDY_IRQ;
+
+	priv->irq_mask = val;
+	ret = adin1110_write_reg(priv, ADIN1110_IMASK1, ~val);
+	if (ret < 0) {
+		netdev_err(net_dev, "Failed to enable chip IRQs: %d\n", ret);
+		goto out;
+	}
+
+	ret = adin1110_read_reg(priv, ADIN1110_TX_SPACE, &val);
+	if (ret < 0) {
+		netdev_err(net_dev, "Failed to read TX FIFO space: %d\n", ret);
+		goto out;
+	}
+
+	priv->tx_space = 2 * val;
+
+	ret = adin1110_set_mac_address(net_dev, net_dev->dev_addr);
+	if (ret < 0) {
+		netdev_err(net_dev, "Could not set MAC address: %pM, %d\n", net_dev->dev_addr, ret);
+		goto out;
+	}
+
+	ret = adin1110_set_bits(priv, ADIN1110_CONFIG1, ADIN1110_CONFIG1_SYNC,
+				ADIN1110_CONFIG1_SYNC);
+
+out:
+	mutex_unlock(&priv->lock);
+
+	if (ret < 0)
+		return ret;
+
+	phy_start(port_priv->phydev);
+
+	netif_start_queue(net_dev);
+
+	return 0;
+}
+
+static int adin1110_net_stop(struct net_device *net_dev)
+{
+	struct adin1110_port_priv *port_priv = netdev_priv(net_dev);
+
+	netif_stop_queue(port_priv->netdev);
+	flush_work(&port_priv->tx_work);
+	phy_stop(port_priv->phydev);
+
+	return 0;
+}
+
+static void adin1110_tx_work(struct work_struct *work)
+{
+	struct adin1110_port_priv *port_priv = container_of(work, struct adin1110_port_priv, tx_work);
+	struct adin1110_priv *priv = port_priv->priv;
+	struct sk_buff *txb;
+	bool last;
+	int ret;
+
+	mutex_lock(&priv->lock);
+
+	last = skb_queue_empty(&port_priv->txq);
+
+	while (!last) {
+		txb = skb_dequeue(&port_priv->txq);
+		last = skb_queue_empty(&port_priv->txq);
+
+		if (txb) {
+			ret = adin1110_write_fifo(port_priv, txb);
+			if (ret < 0)
+				netdev_err(port_priv->netdev, "Frame write error: %d\n", ret);
+
+			dev_kfree_skb(txb);
+		}
+	}
+
+	mutex_unlock(&priv->lock);
+}
+
+static netdev_tx_t adin1110_start_xmit(struct sk_buff *skb, struct net_device *dev)
+{
+	struct adin1110_port_priv *port_priv = netdev_priv(dev);
+	struct adin1110_priv *priv = port_priv->priv;
+	netdev_tx_t netdev_ret = NETDEV_TX_OK;
+	u32 tx_space_needed;
+
+	spin_lock(&priv->state_lock);
+
+	tx_space_needed = skb->len + ADIN1110_FRAME_HEADER_LEN + ADIN1110_INTERNAL_SIZE_HEADER_LEN;
+	if (tx_space_needed > priv->tx_space) {
+		netif_stop_queue(dev);
+		netdev_ret = NETDEV_TX_BUSY;
+	} else {
+		priv->tx_space -= tx_space_needed;
+		skb_queue_tail(&port_priv->txq, skb);
+	}
+
+	spin_unlock(&priv->state_lock);
+
+	schedule_work(&port_priv->tx_work);
+
+	return netdev_ret;
+}
+
+static void adin1110_ndo_get_stats64(struct net_device *dev, struct rtnl_link_stats64 *storage)
+{
+	struct adin1110_port_priv *port_priv = netdev_priv(dev);
+
+	storage->rx_packets = port_priv->rx_packets;
+	storage->tx_packets = port_priv->tx_packets;
+
+	storage->rx_bytes = port_priv->rx_bytes;
+	storage->tx_bytes = port_priv->tx_bytes;
+}
+
+static int adin1110_port_get_port_parent_id(struct net_device *dev,
+					    struct netdev_phys_item_id *ppid)
+{
+	struct adin1110_port_priv *port_priv = netdev_priv(dev);
+	struct adin1110_priv *priv = port_priv->priv;
+
+	ppid->id_len = strnlen(priv->mii_bus_name, MII_BUS_ID_SIZE);
+	memcpy(ppid->id, priv->mii_bus_name, ppid->id_len);
+
+	return 0;
+}
+
+static int adin1110_ndo_get_phys_port_name(struct net_device *dev, char *name, size_t len)
+{
+	struct adin1110_port_priv *port_priv = netdev_priv(dev);
+	int err;
+
+	err = snprintf(name, len, "p%d", port_priv->nr);
+	if (err >= len)
+		return -EINVAL;
+
+	return 0;
+}
+
+static int adin1110_net_bridge_getlink(struct sk_buff *skb, u32 pid, u32 seq,
+				       struct net_device *dev, u32 filter_mask, int nlflags)
+{
+	struct adin1110_port_priv *port_priv = netdev_priv(dev);
+
+	return ndo_dflt_bridge_getlink(skb, pid, seq, dev, port_priv->priv->br_mode, 0, 0,
+				       nlflags, filter_mask, NULL);
+}
+
+static int adin1110_net_bridge_setlink(struct net_device *dev, struct nlmsghdr *nlh, u16 flags,
+				       struct netlink_ext_ack *extack)
+{
+	struct adin1110_port_priv *port_priv = netdev_priv(dev);
+	struct nlattr *br_spec;
+	struct nlattr *attr;
+	int rem;
+
+	br_spec = nlmsg_find_attr(nlh, sizeof(struct ifinfomsg), IFLA_AF_SPEC);
+	if (!br_spec)
+		return -EINVAL;
+
+	nla_for_each_nested(attr, br_spec, rem) {
+		u16 mode;
+
+		if (nla_type(attr) != IFLA_BRIDGE_MODE)
+			continue;
+
+		if (nla_len(attr) < sizeof(mode))
+			return -EINVAL;
+
+		port_priv->priv->br_mode = nla_get_u16(attr);
+		adin1110_set_rx_mode(dev);
+		break;
+	}
+
+	return 0;
+}
+
+static const struct net_device_ops adin1110_netdev_ops = {
+	.ndo_open		= adin1110_net_open,
+	.ndo_stop		= adin1110_net_stop,
+	.ndo_do_ioctl		= adin1110_ioctl,
+	.ndo_start_xmit		= adin1110_start_xmit,
+	.ndo_set_mac_address	= adin1110_ndo_set_mac_address,
+	.ndo_set_rx_mode	= adin1110_set_rx_mode,
+	.ndo_validate_addr	= eth_validate_addr,
+	.ndo_get_stats64	= adin1110_ndo_get_stats64,
+	.ndo_get_port_parent_id	= adin1110_port_get_port_parent_id,
+	.ndo_get_phys_port_name	= adin1110_ndo_get_phys_port_name,
+	.ndo_bridge_getlink     = adin1110_net_bridge_getlink,
+	.ndo_bridge_setlink     = adin1110_net_bridge_setlink,
+};
+
+static void adin1110_get_drvinfo(struct net_device *dev, struct ethtool_drvinfo *di)
+{
+	strscpy(di->driver, "ADIN1110", sizeof(di->driver));
+	strscpy(di->bus_info, dev_name(dev->dev.parent), sizeof(di->bus_info));
+}
+
+static const struct ethtool_ops adin1110_ethtool_ops = {
+	.get_drvinfo		= adin1110_get_drvinfo,
+	.get_link		= ethtool_op_get_link,
+	.get_link_ksettings	= phy_ethtool_get_link_ksettings,
+	.set_link_ksettings	= phy_ethtool_set_link_ksettings,
+};
+
+static void adin1110_adjust_link(struct net_device *dev)
+{
+	struct phy_device *phydev = dev->phydev;
+
+	if (!phydev->link)
+		phy_print_status(phydev);
+}
+
+/* PHY ID is stored in the MAC registers too, check spi connection by reading it */
+static int adin1110_check_spi(struct adin1110_priv *priv)
+{
+	int ret;
+	u32 val;
+
+	ret = adin1110_read_reg(priv, ADIN1110_PHY_ID, &val);
+	if (ret < 0)
+		return ret;
+
+	if (val != priv->cfg->phy_id_val) {
+		dev_err(&priv->spidev->dev, "PHY ID expected: %x, read: %x\n",
+			priv->cfg->phy_id_val, val);
+		return -EIO;
+	}
+
+	return 0;
+}
+
+static void adin1110_disconnect_phy(void *data)
+{
+	phy_disconnect(data);
+}
+
+static int adin1110_port_bridge_join(struct adin1110_port_priv *port_priv,
+				     struct net_device *bridge)
+{
+	struct adin1110_priv *priv = port_priv->priv;
+	int ret;
+
+	port_priv->bridge = bridge;
+
+	if (adin1110_can_offload_forwarding(priv)) {
+		ret = adin1110_hw_forwarding(priv, true);
+		if (ret < 0)
+			return ret;
+	}
+
+	mutex_lock(&priv->lock);
+	ret = adin1110_setup_rx_mode(port_priv);
+	mutex_unlock(&priv->lock);
+
+	return ret;
+}
+
+static int adin1110_port_bridge_leave(struct adin1110_port_priv *port_priv,
+				      struct net_device *bridge)
+{
+	struct adin1110_priv *priv = port_priv->priv;
+	int ret = 0;
+
+	ret = adin1110_hw_forwarding(priv, false);
+	if (ret < 0)
+		return ret;
+
+	port_priv->bridge = NULL;
+
+	mutex_lock(&priv->lock);
+	ret = adin1110_setup_rx_mode(port_priv);
+	mutex_unlock(&priv->lock);
+
+	return ret;
+}
+
+static int adin1110_netdevice_event(struct notifier_block *unused, unsigned long event, void *ptr)
+{
+	struct net_device *dev = netdev_notifier_info_to_dev(ptr);
+	struct adin1110_port_priv *port_priv = netdev_priv(dev);
+	struct netdev_notifier_changeupper_info *info = ptr;
+	int ret = 0;
+
+	switch (event) {
+	case NETDEV_CHANGEUPPER:
+		if (netif_is_bridge_master(info->upper_dev)) {
+			if (info->linking)
+				ret = adin1110_port_bridge_join(port_priv, info->upper_dev);
+			else
+				ret = adin1110_port_bridge_leave(port_priv, info->upper_dev);
+		}
+		break;
+	default:
+		break;
+	}
+
+	return notifier_from_errno(ret);
+}
+
+static struct notifier_block adin1110_netdevice_nb = {
+	.notifier_call = adin1110_netdevice_event,
+};
+
+static bool adin1110_port_dev_check(const struct net_device *dev)
+{
+	return dev->netdev_ops == &adin1110_netdev_ops;
+}
+
+static int adin1110_port_set_forwarding_state(struct adin1110_port_priv *port_priv)
+{
+	struct adin1110_priv *priv = port_priv->priv;
+	int ret;
+
+	port_priv->state = BR_STATE_FORWARDING;
+
+	if (adin1110_can_offload_forwarding(priv)) {
+		ret = adin1110_hw_forwarding(priv, true);
+		if (ret < 0)
+			return ret;
+	}
+
+	mutex_lock(&priv->lock);
+	ret = adin1110_set_mac_address(port_priv->netdev, port_priv->netdev->dev_addr);
+	if (ret < 0)
+		goto out;
+
+	ret = adin1110_setup_rx_mode(port_priv);
+out:
+	mutex_unlock(&priv->lock);
+
+	return ret;
+}
+
+static int adin1110_port_set_blocking_state(struct adin1110_port_priv *port_priv)
+{
+	u8 mac[ETH_ALEN] = {0x01, 0x80, 0xC2, 0x00, 0x00, 0x00};
+	struct adin1110_priv *priv = port_priv->priv;
+	u8 mask[ETH_ALEN];
+	int ret;
+	int i;
+
+	port_priv->state = BR_STATE_BLOCKING;
+
+	ret = adin1110_hw_forwarding(priv, false);
+	if (ret < 0)
+		return ret;
+
+	mutex_lock(&priv->lock);
+
+	for (i = 0; i <= ADIN_MAC_BROADCAST_ADDR_SLOT; i++) {
+		ret = adin1110_clear_mac_address(port_priv, i);
+		if (ret < 0)
+			goto out;
+	}
+
+	/* Allow only BPDUs to be passed to the CPU */
+	memset(mask, 0xFF, ETH_ALEN);
+	ret = adin1110_write_mac_address(port_priv, ADIN_MAC_BPDU_ADDR_SLOT, mac, mask);
+out:
+	mutex_unlock(&priv->lock);
+
+	return ret;
+}
+
+/* ADIN1110/2111 does not have any native STP support. Listen for bridge core state changes and
+ * allow all frames to pass or only the BPDUs.
+ */
+static int adin1110_port_attr_stp_state_set(struct adin1110_port_priv *port_priv, u8 state)
+{
+	switch (state) {
+	case BR_STATE_FORWARDING:
+		return adin1110_port_set_forwarding_state(port_priv);
+	case BR_STATE_LEARNING:
+	case BR_STATE_LISTENING:
+	case BR_STATE_DISABLED:
+	case BR_STATE_BLOCKING:
+		return adin1110_port_set_blocking_state(port_priv);
+	default:
+		return -EINVAL;
+	}
+}
+
+static int adin1110_port_attr_set(struct net_device *dev, const void *ctx,
+				  const struct switchdev_attr *attr,
+				  struct netlink_ext_ack *extack)
+{
+	struct adin1110_port_priv *port_priv = netdev_priv(dev);
+
+	switch (attr->id) {
+	case SWITCHDEV_ATTR_ID_PORT_STP_STATE:
+		return adin1110_port_attr_stp_state_set(port_priv, attr->u.stp_state);
+	default:
+		return -EOPNOTSUPP;
+	}
+}
+
+static int adin1110_switchdev_blocking_event(struct notifier_block *unused, unsigned long event,
+					     void *ptr)
+{
+	struct net_device *netdev = switchdev_notifier_info_to_dev(ptr);
+	int ret;
+
+	if (event == SWITCHDEV_PORT_ATTR_SET) {
+		ret = switchdev_handle_port_attr_set(netdev, ptr, adin1110_port_dev_check,
+						     adin1110_port_attr_set);
+
+		return notifier_from_errno(ret);
+	}
+
+	return NOTIFY_DONE;
+}
+
+static struct notifier_block adin1110_switchdev_blocking_notifier = {
+	.notifier_call = adin1110_switchdev_blocking_event,
+};
+
+static void adin1110_unregister_notifiers(void *data)
+{
+	unregister_netdevice_notifier(&adin1110_netdevice_nb);
+	unregister_switchdev_blocking_notifier(&adin1110_switchdev_blocking_notifier);
+}
+
+static int adin1110_probe_netdevs(struct adin1110_priv *priv)
+{
+	struct device *dev = &priv->spidev->dev;
+	struct adin1110_port_priv *port_priv;
+	struct net_device *netdev;
+	int ret;
+	int i;
+
+	for (i = 0; i < priv->cfg->ports_nr; i++) {
+		netdev = devm_alloc_etherdev(dev, sizeof(*port_priv));
+		if (!netdev)
+			return -ENOMEM;
+
+		port_priv = netdev_priv(netdev);
+		port_priv->netdev = netdev;
+		port_priv->priv = priv;
+		port_priv->cfg = priv->cfg;
+		port_priv->nr = i;
+		priv->ports[i] = port_priv;
+		SET_NETDEV_DEV(netdev, dev);
+
+		ret = device_get_ethdev_address(dev, netdev);
+		if (ret < 0)
+			return ret;
+
+		netdev->irq = priv->spidev->irq;
+		INIT_WORK(&port_priv->tx_work, adin1110_tx_work);
+		INIT_WORK(&port_priv->rx_mode_work, adin1110_rx_mode_work);
+		skb_queue_head_init(&port_priv->txq);
+
+		netif_carrier_off(netdev);
+
+		netdev->if_port = IF_PORT_10BASET;
+		netdev->netdev_ops = &adin1110_netdev_ops;
+		netdev->ethtool_ops = &adin1110_ethtool_ops;
+		netdev->priv_flags |= IFF_UNICAST_FLT;
+		netdev->features |= NETIF_F_NETNS_LOCAL;
+
+		port_priv->phydev = get_phy_device(priv->mii_bus, i + 1, false);
+		if (!port_priv->phydev) {
+			netdev_err(netdev, "Could not find PHY with device address: %d.\n", i);
+			return -ENODEV;
+		}
+
+		port_priv->phydev = phy_connect(netdev, phydev_name(port_priv->phydev),
+						adin1110_adjust_link, PHY_INTERFACE_MODE_INTERNAL);
+		if (IS_ERR(port_priv->phydev)) {
+			netdev_err(netdev, "Could not connect PHY with device address: %d.\n", i);
+			return PTR_ERR(port_priv->phydev);
+		}
+
+		ret = devm_add_action_or_reset(dev, adin1110_disconnect_phy, port_priv->phydev);
+		if (ret < 0)
+			return ret;
+	}
+
+	/* ADIN1110 INT_N pin will be used to signal the host */
+	ret = devm_request_threaded_irq(dev, priv->spidev->irq, NULL, adin1110_irq,
+					IRQF_TRIGGER_LOW | IRQF_ONESHOT, dev_name(dev), priv);
+	if (ret < 0)
+		return ret;
+
+	ret = register_netdevice_notifier(&adin1110_netdevice_nb);
+	if (ret < 0)
+		return ret;
+
+	ret = register_switchdev_blocking_notifier(&adin1110_switchdev_blocking_notifier);
+	if (ret < 0) {
+		unregister_netdevice_notifier(&adin1110_netdevice_nb);
+		return ret;
+	}
+
+	ret = devm_add_action_or_reset(dev, adin1110_unregister_notifiers, NULL);
+	if (ret < 0)
+		return ret;
+
+	for (i = 0; i < priv->cfg->ports_nr; i++) {
+		ret = devm_register_netdev(dev, priv->ports[i]->netdev);
+		if (ret < 0) {
+			dev_err(dev, "Failed to register network device.\n");
+			return ret;
+		}
+	}
+
+	return 0;
+}
+
+static int adin1110_probe(struct spi_device *spi)
+{
+	const struct spi_device_id *dev_id = spi_get_device_id(spi);
+	struct device *dev = &spi->dev;
+	struct adin1110_priv *priv;
+	int ret;
+
+	priv = devm_kzalloc(dev, sizeof(struct adin1110_priv), GFP_KERNEL);
+	if (!priv)
+		return -ENOMEM;
+
+	priv->spidev = spi;
+	priv->cfg = &adin1110_cfgs[dev_id->driver_data];
+	spi->bits_per_word = 8;
+	spi->mode = SPI_MODE_0;
+
+	mutex_init(&priv->lock);
+	spin_lock_init(&priv->state_lock);
+
+	/* use of CRC on control and data transactions is pin dependent */
+	priv->append_crc = device_property_read_bool(dev, "adi,spi-crc");
+	if (priv->append_crc)
+		crc8_populate_msb(adin1110_crc_table, 0x7);
+
+	ret = adin1110_check_spi(priv);
+	if (ret < 0) {
+		dev_err(dev, "Probe SPI Read check failed: %d\n", ret);
+		return ret;
+	}
+
+	ret = adin1110_write_reg(priv, ADIN1110_RESET, ADIN1110_SWRESET);
+	if (ret < 0)
+		return ret;
+
+	ret = adin1110_register_mdiobus(priv, dev);
+	if (ret < 0) {
+		dev_err(dev, "Could not register MDIO bus %d\n", ret);
+		return ret;
+	}
+
+	return adin1110_probe_netdevs(priv);
+}
+
+static const struct of_device_id adin1110_match_table[] = {
+	{ .compatible = "adi,adin1110" },
+	{ .compatible = "adi,adin2111" },
+	{ }
+};
+MODULE_DEVICE_TABLE(of, adin1110_match_table);
+
+static const struct spi_device_id adin1110_spi_id[] = {
+	{ .name = "adin1110", .driver_data = ADIN1110_MAC },
+	{ .name = "adin2111", .driver_data = ADIN2111_MAC },
+	{ }
+};
+
+static struct spi_driver adin1110_driver = {
+	.driver = {
+		.name = "adin1110",
+		.of_match_table = adin1110_match_table,
+	},
+	.probe = adin1110_probe,
+	.id_table = adin1110_spi_id,
+};
+module_spi_driver(adin1110_driver);
+
+MODULE_DESCRIPTION("ADIN1110 Network driver");
+MODULE_AUTHOR("Alexandru Tachici <alexandru.tachici@analog.com>");
+MODULE_LICENSE("Dual BSD/GPL");
-- 
2.25.1

