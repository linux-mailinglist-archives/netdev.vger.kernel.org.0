Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B7B045B281
	for <lists+netdev@lfdr.de>; Wed, 24 Nov 2021 04:15:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237303AbhKXDSn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Nov 2021 22:18:43 -0500
Received: from pi.codeconstruct.com.au ([203.29.241.158]:56166 "EHLO
        codeconstruct.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230517AbhKXDSl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Nov 2021 22:18:41 -0500
Received: by codeconstruct.com.au (Postfix, from userid 10001)
        id DE9D9202CF; Wed, 24 Nov 2021 11:15:22 +0800 (AWST)
Date:   Wed, 24 Nov 2021 11:15:22 +0800
From:   Matt Johnston <matt@codeconstruct.com.au>
To:     Wolfram Sang <wsa@kernel.org>, zev@bewilderbeest.net,
        robh+dt@kernel.org, davem@davemloft.net, kuba@kernel.org,
        brendanhiggins@google.com, benh@kernel.crashing.org,
        joel@jms.id.au, andrew@aj.id.au, avifishman70@gmail.com,
        tmaimon77@gmail.com, tali.perry1@gmail.com, venture@google.com,
        yuenn@google.com, benjaminfair@google.com, jk@codeconstruct.com.au,
        linux-i2c@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH net-next v3 0/6] MCTP I2C driver
Message-ID: <20211124031522.GB18900@codeconstruct.com.au>
References: <20211115024926.205385-1-matt@codeconstruct.com.au>
 <163698601142.19991.3686735228078461111.git-patchwork-notify@kernel.org>
 <YZJ9H4eM/M7OXVN0@shikoro>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YZJ9H4eM/M7OXVN0@shikoro>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Wolfram,

> (extending SMBus calls to 255 byte) is complicated because we need ABI
> backwards compatibility.

Is it only the i2c-dev ABI that you are concerned about?

I've tested various edge cases of the I2C dev interface, the only ABI
change seen is that I2C_RDWR ioctl will now read larger messages with
I2C_M_RECV_LEN if userspace provides a larger buffer. I think that is a
reasonable change. The i2ctransfer tool provides a 256 byte buffer
already.

The attached driver patch creates an artifical I2C bus for testing, with
fixed I2C endpoints 0x30 (for block reads) and 0x40 (for block writes).
This was written just to test this case, though could be committed if
you think it's more useful generally.

The script below runs through the edge cases around 32 bytes, with
either 32 or 255 blockmax on two separate i2c-testbus adapters. The
patch applies on top of the 255 byte patch series. The script behaviour
is the same applied on a clean tree (after fixing up 'V3' code), apart
from the final test as expected.

Cheers,
Matt


#!/bin/sh

# Tests for edge cases around 32 byte block size handling in i2c dev
# Matt Johnston <matt@codeconstruct.com.au> 2021

# Two i2c-testbus adapter numbers.
# Bus 15 has v2-only set on i2c-testbus devicetree node, 32 block max
V2_BUS=15
# Bus 14 accepts 255 block max
V3_BUS=14

EXPECT_FAIL="exit 3"
FAIL="exit 2"

# Behaviour of 32 byte (V2) and 255 byte (V3) busses is the same for most operations
for b in $V2_BUS $V3_BUS; do

echo "Testing bus $b"

############

echo "Testing 31 byte read"
i2cget -y $b 0x30 31 s || $FAIL
echo "Testing 32 byte read"
i2cget -y $b 0x30 32 s || $FAIL

echo "Testing 33 byte read, should fail"
i2cget -y $b 0x30 33 s && $EXPECT_FAIL

echo "Testing 35 byte i2c read, should succeed"
i2cget -y $b 0x30 35 i || $FAIL

echo "Testing 32 byte i2c set length"
i2cset -y $b 0x30 32 || $FAIL
echo "Testing 32 byte i2c read, should succeed"
i2ctransfer -y $b 'r?@0x30' || $FAIL

############

echo "Testing 31 byte smbus write"
i2cset -y $b 0x40 0x0f 0x77 0x77 0x77 0x77 0x77 0x77 0x77 0x77 0x77 0x77 0x77 0x77 0x77 0x77 0x77 0x77 0x77 0x77 0x77 0x77 0x77 0x77 0x77 0x77 0x77 0x77 0x77 0x77 0x77 0x77 0x77 s || $FAIL
wl=$(i2cget -y $b 0x40)
echo "check length ($wl) is 33==0x21"
[ $wl = 0x21 ] || $FAIL

echo "Testing 32 byte smbus write"
i2cset -y $b 0x40 0x0f 0x77 0x77 0x77 0x77 0x77 0x77 0x77 0x77 0x77 0x77 0x77 0x77 0x77 0x77 0x77 0x77 0x77 0x77 0x77 0x77 0x77 0x77 0x77 0x77 0x77 0x77 0x77 0x77 0x77 0x77 0x77 0x77 s || $FAIL
wl=$(i2cget -y $b 0x40)
echo "Check length ($wl) is 34==0x22"
[ $wl = 0x22 ] || $FAIL

echo "Testing 33 byte smbus write (fails)"
i2cset -y $b 0x40 0x0f 0x77 0x77 0x77 0x77 0x77 0x77 0x77 0x77 0x77 0x77 0x77 0x77 0x77 0x77 0x77 0x77 0x77 0x77 0x77 0x77 0x77 0x77 0x77 0x77 0x77 0x77 0x77 0x77 0x77 0x77 0x77 0x77 0x77 s && $EXPECT_FAIL

echo "Testing 70 byte i2c write"
i2ctransfer -y $b w70@0x40 123- || $FAIL
wl=$(i2cget -y $b 0x40)
echo "Check length ($wl) is 70==0x46"
[ $wl = 0x46 ] || $FAIL

echo "Done testing bus $b"

done

########## Behaviour V2 vs V3 differs with tests below

echo "Testing difference of V2 bus $V2_BUS"
b=$V2_BUS

echo "Testing 44 byte read set-length (succeeds with a warning of further failure)"
i2cset -y $b 0x30 44 || $FAIL
# i2c-testbus checks size against I2C_SMBUS_BLOCK_MAX in the v2-only case.
# This is similar to the I2C_SMBUS_BLOCK_MAX vs I2C_SMBUS_V3_BLOCK_MAX
# checks changed in i2c-npcm7xx and i2c-aspeed
echo "Testing 44 byte i2c read, fails"
i2ctransfer -y $b 'r?@0x30' && $EXPECT_FAIL

echo "Done with difference of V2 bus $V2_BUS"

############

echo "Testing difference of V3 bus $V3_BUS"
b=$V3_BUS

echo "Testing 44 byte read set-length"
i2cset -y $b 0x30 44 || $FAIL
echo "Testing 44 byte i2c read, succeeds. (failed prior to 255 byte patch)"
i2ctransfer -y $b 'r?@0x30' || $FAIL

echo "Done with difference of V3 bus $V3_BUS"

############

echo
echo "All tests completed as expected"

--
Subject: [PATCH] i2c testbus: Add an I2C bus for testing

The bus provides fixed endpoints to be used for testing i2c-dev or
drivers, without needing real hardware. In particular these can test
block size limitations.

Devicetree property "v2-only" will limit the bus to 32 byte
SMBus messages, otherwise it supports 255 byte SMBus v3 message.

Examples have i2c-testbus attached as bus number 14:

Address 0x30 provides an endpoint to test block reads

    i2cget -y 14 0x30 31 s

will read 31 bytes as an smbus read. >32 bytes will fail.

    i2cset -y 14 0x30 200
    i2ctransfer -y 14 r?@0x30

will read 200 bytes as an I2C read.

Address 0x40 is an endpoint to test block writes. The number of bytes
written can be read back from the endpoint.

i2cset -y 14 0x40 0x32 0x12 0x13 s

i2ctransfer -y 14 w30@0x40 0xff 0x19-

Signed-off-by: Matt Johnston <matt@codeconstruct.com.au>
---
 drivers/i2c/busses/Kconfig       |   9 ++
 drivers/i2c/busses/Makefile      |   1 +
 drivers/i2c/busses/i2c-testbus.c | 252 +++++++++++++++++++++++++++++++
 3 files changed, 262 insertions(+)
 create mode 100644 drivers/i2c/busses/i2c-testbus.c

diff --git a/drivers/i2c/busses/Kconfig b/drivers/i2c/busses/Kconfig
index dce392839017..238d48b42d93 100644
--- a/drivers/i2c/busses/Kconfig
+++ b/drivers/i2c/busses/Kconfig
@@ -1418,4 +1418,13 @@ config I2C_VIRTIO
           This driver can also be built as a module. If so, the module
           will be called i2c-virtio.
 
+config I2C_TESTBUS
+        tristate "Testing I2C Bus Adapter"
+        help
+          Build a driver for testing I2C functionality. The bus provides
+          various clients at fixed addresses with different functionality.
+
+          This driver can also be built as a module. If so, the module
+          will be called i2c-testbus.
+
 endmenu
diff --git a/drivers/i2c/busses/Makefile b/drivers/i2c/busses/Makefile
index d85899fef8c7..e67773637f01 100644
--- a/drivers/i2c/busses/Makefile
+++ b/drivers/i2c/busses/Makefile
@@ -149,5 +149,6 @@ obj-$(CONFIG_I2C_XGENE_SLIMPRO) += i2c-xgene-slimpro.o
 obj-$(CONFIG_SCx200_ACB)	+= scx200_acb.o
 obj-$(CONFIG_I2C_FSI)		+= i2c-fsi.o
 obj-$(CONFIG_I2C_VIRTIO)	+= i2c-virtio.o
+obj-$(CONFIG_I2C_TESTBUS)	+= i2c-testbus.o
 
 ccflags-$(CONFIG_I2C_DEBUG_BUS) := -DDEBUG
diff --git a/drivers/i2c/busses/i2c-testbus.c b/drivers/i2c/busses/i2c-testbus.c
new file mode 100644
index 000000000000..e04c9e96c9bc
--- /dev/null
+++ b/drivers/i2c/busses/i2c-testbus.c
@@ -0,0 +1,252 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Testing I2C adapter.
+ * Copyright (c) 2021 Code Construct
+ *
+ * Presents artificial I2C client endpoints for testing I2C core/dev
+ * functionality, in particular block transfer sizes.
+ *
+ *
+ * Should be instantiated in devicetree, with an optional v2-only
+ * property to limit to 32 byte block transfers.
+
+	testi2c1 {
+		compatible = "testing-i2c-bus";
+		#address-cells = <1>;
+		#size-cells = <0>;
+		// optional limit to 32 byte blocks
+		v2-only;
+	};
+ *
+ */
+
+#include <linux/clk.h>
+#include <linux/completion.h>
+#include <linux/err.h>
+#include <linux/errno.h>
+#include <linux/i2c.h>
+#include <linux/init.h>
+#include <linux/interrupt.h>
+#include <linux/io.h>
+#include <linux/irq.h>
+#include <linux/irqchip/chained_irq.h>
+#include <linux/irqdomain.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/of_address.h>
+#include <linux/of_irq.h>
+#include <linux/of_platform.h>
+#include <linux/platform_device.h>
+#include <linux/reset.h>
+#include <linux/slab.h>
+
+struct testing_i2c_bus {
+	struct i2c_adapter		adap;
+	struct device			*dev;
+	spinlock_t			lock;
+
+	// Don't advertise I2C_FUNC_SMBUS_V3_BLOCK functionality
+	bool v2_only;
+
+	int client_30_len;
+	u8 client_30_val;
+
+	int client_40_len;
+};
+
+static int bus_block_max(struct testing_i2c_bus *bus)
+{
+	return bus->v2_only ? I2C_SMBUS_BLOCK_MAX : I2C_SMBUS_V3_BLOCK_MAX;
+}
+
+/*
+ * 0x30 is a 'read block' i2c endpoint.
+ * A single byte can be written to the "client", indicating the length
+ * of subsequent block reads.
+ */
+int handle_xfer_30(struct testing_i2c_bus *bus, struct i2c_msg *msg)
+{
+	int len, index, i;
+	int block_max = bus_block_max(bus);
+
+	if (msg->flags & I2C_M_RD) {
+		// Read
+		if (msg->flags & I2C_M_RECV_LEN) {
+			// sanity check, should already be limited by Write path below
+			if (bus->client_30_len > block_max) {
+				dev_warn(bus->dev,
+					"%s: addr 0x30 read length %d too large, -EPROTO",
+					__func__, bus->client_30_len);
+				return -EPROTO;
+			}
+			len = bus->client_30_len;
+			msg->buf[0] = len;
+			index = 1;
+			msg->len = len+1;
+		} else {
+			len = msg->len;
+			index = 0;
+		}
+		dev_dbg(bus->dev, "%s read len %d\n", __func__, len);
+		// Fill the buffer with something arbitrary
+		for (i = 0; i < len; i++) {
+			msg->buf[index + i] = bus->client_30_val;
+			(bus->client_30_val)++;
+		}
+	} else {
+		// Write
+		if (msg->len != 1) {
+			dev_warn(bus->dev, "%s: Bad write length to 0x30, must be 1\n",
+				__func__);
+			return -EIO;
+		}
+		len = msg->buf[0];
+		if (len > block_max) {
+			dev_warn(bus->dev,
+				"%s: addr 0x30 read length was set to %d which is > %d (BLOCK_MAX). smbus reads will fail.",
+				__func__, len, block_max);
+		}
+		dev_dbg(bus->dev, "%s write set len %d\n", __func__, len);
+		bus->client_30_len = len;
+	}
+	return 0;
+}
+
+/*
+ * 0x40 is a 'write block' i2c endpoint.
+ * After a block write, the block length can be read back.
+ */
+int handle_xfer_40(struct testing_i2c_bus *bus, struct i2c_msg *msg)
+{
+	int index;
+
+	if (msg->flags & I2C_M_RD) {
+		// Read
+		index = 0;
+		if (msg->flags & I2C_M_RECV_LEN) {
+			// limit to valid API buffer lengths
+			msg->buf[0] = 1;
+			index = 1;
+			msg->len = 2;
+		} else if (msg->len != 1) {
+			dev_warn(bus->dev, "%s bad read len to 0x40, must be 1\n",
+				__func__);
+			return -EIO;
+		}
+		// return the byte count previously written
+		msg->buf[index] = bus->client_40_len;
+	} else {
+		// Write
+		bus->client_40_len = msg->len;
+		dev_dbg(bus->dev, "%s wrote %d bytes: %*ph\n",
+			__func__, bus->client_40_len,
+			msg->len, msg->buf);
+	}
+	return 0;
+}
+static int testing_i2c_master_xfer(struct i2c_adapter *adap,
+				  struct i2c_msg *msgs, int num)
+{
+	struct testing_i2c_bus *bus = i2c_get_adapdata(adap);
+	int i, rc = 0;
+
+	for (i = 0; i < num; i++) {
+		struct i2c_msg *msg = &msgs[i];
+
+		switch (msg->addr) {
+		case 0x30:
+			rc = handle_xfer_30(bus, msg);
+			break;
+		case 0x40:
+			rc = handle_xfer_40(bus, msg);
+			break;
+		default:
+			// unused address
+			rc = -ENXIO;
+		}
+
+		if (rc) {
+			dev_warn(bus->dev, "%s return err %d\n", __func__, rc);
+			return rc;
+		}
+	}
+
+	return num;
+}
+
+static u32 testing_i2c_functionality(struct i2c_adapter *adap)
+{
+	struct testing_i2c_bus *bus = i2c_get_adapdata(adap);
+	int func = I2C_FUNC_I2C | I2C_FUNC_SMBUS_EMUL |
+		I2C_FUNC_SMBUS_BLOCK_DATA;
+
+	if (!bus->v2_only)
+		func |= I2C_FUNC_SMBUS_V3_BLOCK;
+	return func;
+}
+
+static const struct i2c_algorithm testing_i2c_algo = {
+	.master_xfer	= testing_i2c_master_xfer,
+	.functionality	= testing_i2c_functionality,
+};
+
+static const struct of_device_id testing_i2c_bus_of_table[] = {
+	{
+		.compatible = "testing-i2c-bus",
+	},
+	{ },
+};
+MODULE_DEVICE_TABLE(of, testing_i2c_bus_of_table);
+
+static int testing_i2c_probe_bus(struct platform_device *pdev)
+{
+	struct testing_i2c_bus *bus;
+	int ret;
+
+	bus = devm_kzalloc(&pdev->dev, sizeof(*bus), GFP_KERNEL);
+	if (!bus)
+		return -ENOMEM;
+
+	/* Initialize the I2C adapter */
+	spin_lock_init(&bus->lock);
+	bus->adap.owner = THIS_MODULE;
+	bus->adap.retries = 0;
+	bus->adap.algo = &testing_i2c_algo;
+	bus->adap.dev.parent = &pdev->dev;
+	bus->adap.dev.of_node = pdev->dev.of_node;
+	strscpy(bus->adap.name, pdev->name, sizeof(bus->adap.name));
+	i2c_set_adapdata(&bus->adap, bus);
+	bus->dev = &pdev->dev;
+	bus->v2_only = of_property_read_bool(pdev->dev.of_node, "v2-only");
+
+	ret = i2c_add_adapter(&bus->adap);
+	if (ret < 0)
+		return ret;
+
+	platform_set_drvdata(pdev, bus);
+
+	dev_info(bus->dev, "testing i2c bus %d registered. max block %d bytes.\n",
+		 bus->adap.nr, bus_block_max(bus));
+
+	return 0;
+}
+
+static int testing_i2c_remove_bus(struct platform_device *pdev)
+{
+	struct testing_i2c_bus *bus = platform_get_drvdata(pdev);
+
+	i2c_del_adapter(&bus->adap);
+
+	return 0;
+}
+
+static struct platform_driver testing_i2c_bus_driver = {
+	.probe		= testing_i2c_probe_bus,
+	.remove		= testing_i2c_remove_bus,
+	.driver		= {
+		.name		= "testing-i2c-bus",
+		.of_match_table	= testing_i2c_bus_of_table,
+	},
+};
+module_platform_driver(testing_i2c_bus_driver);
+
-- 
2.32.0

