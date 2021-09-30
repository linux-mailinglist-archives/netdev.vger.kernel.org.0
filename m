Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CADE341D6E4
	for <lists+netdev@lfdr.de>; Thu, 30 Sep 2021 11:58:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349608AbhI3KAI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Sep 2021 06:00:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349504AbhI3KAH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Sep 2021 06:00:07 -0400
Received: from mail-lf1-x12e.google.com (mail-lf1-x12e.google.com [IPv6:2a00:1450:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C288C06176A
        for <netdev@vger.kernel.org>; Thu, 30 Sep 2021 02:58:24 -0700 (PDT)
Received: by mail-lf1-x12e.google.com with SMTP id i4so23080017lfv.4
        for <netdev@vger.kernel.org>; Thu, 30 Sep 2021 02:58:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:subject:to:cc:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=6GzQTyAF2VGYqd7dcJq+7AL2s5uGZU/GWKT3YhT9MPI=;
        b=cGxicDBPIsTdGjH/AJi5g4wL+dfBrUGgLpDk+0KJIg8jwOKalpDfJUyJLOS+j6ipM7
         PQTMpJyYzEZFJu65Zucop4MHsTXBaBJu8l7+NrjDhqAzLUdXZs5dAujSNrYMa64V8aCw
         T421CFE+Ge3FEKhtm8z2fT4JN7bzz+KGUcs6mFTiHQUa4vK8C6abNF58FTDfyigmZijc
         kRNz1iumHPs+6y427QOkz9nnyAaz+QIM0QuevMxs9CLBgq2JzI99LgOe2OoA60fHDCOQ
         cVz6JLzsCDX6BVDiv18gkbHWnfDTsGcimDzs3BMExXaoL1Syy//a53V8Yk98VEvtH0eb
         ORUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:subject:to:cc:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=6GzQTyAF2VGYqd7dcJq+7AL2s5uGZU/GWKT3YhT9MPI=;
        b=qBT17wiEp088Xl2zmVpQXnLMKc/4WCEi9NopzkmV99KoQ9C0Qxv/sJ1e25foEAdkLD
         rMHmOoud7ZitBE6lZx7SyMCmAQjNYh/CLrG1HFhHf7uSHqENizGk4Y9Grv50CIe7zB/l
         DmNtQStVBJqlFuYga597AZHey1chdJpmz3KxoI4y9X7xSFRj7jS6LGKVigCgq4h4FbEC
         QFpRN528XLHElU8tBv6VbXPvixFu4falCHNHuBPru7lZtoePTEFGnCdFMJNPk393wlIG
         DnH0F5hybbIqvGcI9lf+hXtsY5EfTjIriudnBo+fCcbSEgbW99YPrAc7sFiT4Sb1Pa7s
         ILBA==
X-Gm-Message-State: AOAM533Al0JvrF1XYNIU3W4c/hZ4VpGRMpLubX6jlejpKr3N2uXp0yy3
        ZW/2Gf+92cgRg93KH574Vpw=
X-Google-Smtp-Source: ABdhPJynHmzpQmYYmIJCMDj7Xz++1Ocbqor55FUVF27btGRmj/mYYgeVyT3iDxQ8duCpZY++9z8RCA==
X-Received: by 2002:a2e:9782:: with SMTP id y2mr4760433lji.421.1632995902775;
        Thu, 30 Sep 2021 02:58:22 -0700 (PDT)
Received: from localhost.localdomain (ip-194-187-74-233.konfederacka.maverick.com.pl. [194.187.74.233])
        by smtp.googlemail.com with ESMTPSA id k10sm293427ljj.24.2021.09.30.02.58.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 30 Sep 2021 02:58:22 -0700 (PDT)
From:   =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Subject: Lockup in phy_probe() for MDIO device (Broadcom's switch)
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Network Development <netdev@vger.kernel.org>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        BCM Kernel Feedback <bcm-kernel-feedback-list@broadcom.com>,
        Vivek Unune <npcomplete13@gmail.com>
Message-ID: <2b1dc053-8c9a-e3e4-b450-eecdfca3fe16@gmail.com>
Date:   Thu, 30 Sep 2021 11:58:21 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.1
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

I've just received a report of kernel lockup after switching OpenWrt
platform from kernel 5.4 to kernel 5.10:
https://bugs.openwrt.org/index.php?do=details&task_id=4055

The problem is phy_probe() and its:
mutex_lock(&phydev->lock);

It seems to me that "lock" mutex doesn't get initalized. It seems
phy_device_create() doesn't get called for an MDIO device.

This isn't necessarily a PHY / MDIO regression. It could be some core
change that exposed a PHY / MDIO bug.


*** Lockup ***

[    0.000000] Booting Linux on physical CPU 0x0
[    0.000000] Linux version 5.10.64 (rmilecki@localhost.localdomain) (arm-openwrt-linux-muslgnueabi-gcc (OpenWrt GCC 11.2.0 r17558+1-71e96532df) 11.2.0, GNU ld (GNU Binutils) 2.36.1) #0 SMP Wed Sep 29 20:08:07 2021
(...)
[    5.592447] libphy: Fixed MDIO Bus: probed
[    5.596809] [of_mdiobus_register:254] np:/mdio@18003000
[    5.602333] libphy: iProc MDIO bus: probed
[    5.606479] iproc-mdio 18003000.mdio: Broadcom iProc MDIO bus registered
[    5.613439] [of_mdiobus_register:254] np:/mdio-mux@18003000/mdio@0
[    5.620101] libphy: mdio_mux: probed
[    5.623709] [of_mdiobus_register:282] child:/mdio-mux@18003000/mdio@0/usb3-phy@10
[    5.631571] [of_mdiobus_register:254] np:/mdio-mux@18003000/mdio@200
[    5.638426] libphy: mdio_mux: probed
[    5.642032] [of_mdiobus_register:282] child:/mdio-mux@18003000/mdio@200/switch@0
[    5.649841] ------------[ cut here ]------------
[    5.654503] WARNING: CPU: 0 PID: 1 at drivers/net/phy/phy_device.c:2839 phy_probe+0x58/0x1e8
[    5.662983] Modules linked in:
[    5.666055] CPU: 0 PID: 1 Comm: swapper/0 Not tainted 5.10.64 #0
[    5.672074] Hardware name: BCM5301X
[    5.675587] [<c0108410>] (unwind_backtrace) from [<c0104bc4>] (show_stack+0x10/0x14)
[    5.683359] [<c0104bc4>] (show_stack) from [<c03dbfc8>] (dump_stack+0x94/0xa8)
[    5.690609] [<c03dbfc8>] (dump_stack) from [<c01183e4>] (__warn+0xb8/0x114)
[    5.697591] [<c01183e4>] (__warn) from [<c01184a8>] (warn_slowpath_fmt+0x68/0x78)
[    5.705095] [<c01184a8>] (warn_slowpath_fmt) from [<c04b85d0>] (phy_probe+0x58/0x1e8)
[    5.712951] [<c04b85d0>] (phy_probe) from [<c04569f8>] (really_probe+0xfc/0x4e0)
[    5.720361] [<c04569f8>] (really_probe) from [<c0454c50>] (bus_for_each_drv+0x74/0x98)
[    5.728298] [<c0454c50>] (bus_for_each_drv) from [<c0456f90>] (__device_attach+0xcc/0x120)
[    5.736584] [<c0456f90>] (__device_attach) from [<c0455bd8>] (bus_probe_device+0x84/0x8c)
[    5.744782] [<c0455bd8>] (bus_probe_device) from [<c0452284>] (device_add+0x300/0x77c)
[    5.752724] [<c0452284>] (device_add) from [<c04b9c4c>] (mdio_device_register+0x24/0x48)
[    5.760836] [<c04b9c4c>] (mdio_device_register) from [<c04c15d4>] (of_mdiobus_register+0x1f8/0x330)
[    5.769904] [<c04c15d4>] (of_mdiobus_register) from [<c04c1c1c>] (mdio_mux_init+0x178/0x2c0)
[    5.778363] [<c04c1c1c>] (mdio_mux_init) from [<c04c1ef8>] (mdio_mux_mmioreg_probe+0x138/0x1fc)
[    5.787089] [<c04c1ef8>] (mdio_mux_mmioreg_probe) from [<c04587bc>] (platform_drv_probe+0x34/0x70)
[    5.796066] [<c04587bc>] (platform_drv_probe) from [<c04569f8>] (really_probe+0xfc/0x4e0)
[    5.804266] [<c04569f8>] (really_probe) from [<c04573dc>] (device_driver_attach+0xe4/0xf4)
[    5.812552] [<c04573dc>] (device_driver_attach) from [<c0457468>] (__driver_attach+0x7c/0x110)
[    5.821186] [<c0457468>] (__driver_attach) from [<c0454bb0>] (bus_for_each_dev+0x64/0x90)
[    5.829385] [<c0454bb0>] (bus_for_each_dev) from [<c0455dd0>] (bus_add_driver+0xf8/0x1e0)
[    5.837585] [<c0455dd0>] (bus_add_driver) from [<c0457a74>] (driver_register+0x88/0x118)
[    5.845697] [<c0457a74>] (driver_register) from [<c01017e4>] (do_one_initcall+0x54/0x1e8)
[    5.853907] [<c01017e4>] (do_one_initcall) from [<c0801118>] (kernel_init_freeable+0x23c/0x290)
[    5.862628] [<c0801118>] (kernel_init_freeable) from [<c065a550>] (kernel_init+0x8/0x118)
[    5.870826] [<c065a550>] (kernel_init) from [<c0100128>] (ret_from_fork+0x14/0x2c)
[    5.878413] Exception stack(0xc1035fb0 to 0xc1035ff8)
[    5.883470] 5fa0:                                     00000000 00000000 00000000 00000000
[    5.891662] 5fc0: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000
[    5.899852] 5fe0: 00000000 00000000 00000000 00000000 00000013 00000000
[    5.906509] ---[ end trace 6a8fa3807352bffb ]---
[    5.911144] Broadcom B53 (2) 0.200:00: [phy_probe:2840] TAKING LOCK...
[   26.924625] rcu: INFO: rcu_sched self-detected stall on CPU
[   26.930213] rcu:     0-....: (2099 ticks this GP) idle=e3e/1/0x40000002 softirq=109/109 fqs=1050
[   26.938844]  (t=2100 jiffies g=-1111 q=287)
[   26.943031] NMI backtrace for cpu 0
[   26.946523] CPU: 0 PID: 1 Comm: swapper/0 Tainted: G        W         5.10.64 #0
[   26.953934] Hardware name: BCM5301X
[   26.957437] [<c0108410>] (unwind_backtrace) from [<c0104bc4>] (show_stack+0x10/0x14)
[   26.965206] [<c0104bc4>] (show_stack) from [<c03dbfc8>] (dump_stack+0x94/0xa8)
[   26.972450] [<c03dbfc8>] (dump_stack) from [<c03e3890>] (nmi_cpu_backtrace+0xc8/0xf4)
[   26.980295] [<c03e3890>] (nmi_cpu_backtrace) from [<c03e39c0>] (nmi_trigger_cpumask_backtrace+0x104/0x13c)
[   26.989974] [<c03e39c0>] (nmi_trigger_cpumask_backtrace) from [<c01700a0>] (rcu_dump_cpu_stacks+0xe4/0x10c)
[   26.999743] [<c01700a0>] (rcu_dump_cpu_stacks) from [<c0175444>] (rcu_sched_clock_irq+0x6e4/0x8ac)
[   27.008731] [<c0175444>] (rcu_sched_clock_irq) from [<c017b47c>] (update_process_times+0x88/0xbc)
[   27.017632] [<c017b47c>] (update_process_times) from [<c018ac8c>] (tick_sched_timer+0x78/0x274)
[   27.026349] [<c018ac8c>] (tick_sched_timer) from [<c017b9e8>] (__hrtimer_run_queues+0x15c/0x218)
[   27.035157] [<c017b9e8>] (__hrtimer_run_queues) from [<c017c5c8>] (hrtimer_interrupt+0x11c/0x298)
[   27.044056] [<c017c5c8>] (hrtimer_interrupt) from [<c0107a30>] (twd_handler+0x34/0x3c)
[   27.051993] [<c0107a30>] (twd_handler) from [<c0167c68>] (handle_percpu_devid_irq+0x78/0x148)
[   27.060547] [<c0167c68>] (handle_percpu_devid_irq) from [<c0162470>] (__handle_domain_irq+0x84/0xd8)
[   27.069706] [<c0162470>] (__handle_domain_irq) from [<c03f48e8>] (gic_handle_irq+0x80/0x94)
[   27.078076] [<c03f48e8>] (gic_handle_irq) from [<c0100aec>] (__irq_svc+0x6c/0x90)
[   27.085575] Exception stack(0xc1035c28 to 0xc1035c70)
[   27.090634] 5c20:                   c116648c 00000000 0000c116 00006488 c1166488 ffffe000
[   27.098825] 5c40: 00000000 c1034000 00000002 c0982be8 c116648c 00000000 00000000 c1035c78
[   27.107022] 5c60: c065ce58 c065fe64 80000013 ffffffff
[   27.112086] [<c0100aec>] (__irq_svc) from [<c065fe64>] (_raw_spin_lock+0x2c/0x40)
[   27.119585] [<c065fe64>] (_raw_spin_lock) from [<c065ce58>] (__mutex_lock.constprop.0+0x1b8/0x520)
[   27.128571] [<c065ce58>] (__mutex_lock.constprop.0) from [<c04b85f4>] (phy_probe+0x7c/0x1e8)
[   27.137032] [<c04b85f4>] (phy_probe) from [<c04569f8>] (really_probe+0xfc/0x4e0)
[   27.144444] [<c04569f8>] (really_probe) from [<c0454c50>] (bus_for_each_drv+0x74/0x98)
[   27.152380] [<c0454c50>] (bus_for_each_drv) from [<c0456f90>] (__device_attach+0xcc/0x120)
[   27.160667] [<c0456f90>] (__device_attach) from [<c0455bd8>] (bus_probe_device+0x84/0x8c)
[   27.168865] [<c0455bd8>] (bus_probe_device) from [<c0452284>] (device_add+0x300/0x77c)
[   27.176797] [<c0452284>] (device_add) from [<c04b9c4c>] (mdio_device_register+0x24/0x48)
[   27.184911] [<c04b9c4c>] (mdio_device_register) from [<c04c15d4>] (of_mdiobus_register+0x1f8/0x330)
[   27.193977] [<c04c15d4>] (of_mdiobus_register) from [<c04c1c1c>] (mdio_mux_init+0x178/0x2c0)
[   27.202437] [<c04c1c1c>] (mdio_mux_init) from [<c04c1ef8>] (mdio_mux_mmioreg_probe+0x138/0x1fc)
[   27.211154] [<c04c1ef8>] (mdio_mux_mmioreg_probe) from [<c04587bc>] (platform_drv_probe+0x34/0x70)
[   27.220133] [<c04587bc>] (platform_drv_probe) from [<c04569f8>] (really_probe+0xfc/0x4e0)
[   27.228331] [<c04569f8>] (really_probe) from [<c04573dc>] (device_driver_attach+0xe4/0xf4)
[   27.236609] [<c04573dc>] (device_driver_attach) from [<c0457468>] (__driver_attach+0x7c/0x110)
[   27.245243] [<c0457468>] (__driver_attach) from [<c0454bb0>] (bus_for_each_dev+0x64/0x90)
[   27.253434] [<c0454bb0>] (bus_for_each_dev) from [<c0455dd0>] (bus_add_driver+0xf8/0x1e0)
[   27.261633] [<c0455dd0>] (bus_add_driver) from [<c0457a74>] (driver_register+0x88/0x118)
[   27.269746] [<c0457a74>] (driver_register) from [<c01017e4>] (do_one_initcall+0x54/0x1e8)
[   27.277949] [<c01017e4>] (do_one_initcall) from [<c0801118>] (kernel_init_freeable+0x23c/0x290)
[   27.286667] [<c0801118>] (kernel_init_freeable) from [<c065a550>] (kernel_init+0x8/0x118)
[   27.294865] [<c065a550>] (kernel_init) from [<c0100128>] (ret_from_fork+0x14/0x2c)
[   27.302452] Exception stack(0xc1035fb0 to 0xc1035ff8)
[   27.307511] 5fa0:                                     00000000 00000000 00000000 00000000
[   27.315702] 5fc0: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000
[   27.323891] 5fe0: 00000000 00000000 00000000 00000000 00000013 00000000


*** Device tree ***

Base: arch/arm/boot/dts/bcm5301x.dtsi

Relevant part:

mdio-bus-mux@18003000 {
	compatible = "mdio-mux-mmioreg";
	mdio-parent-bus = <&mdio>;
	#address-cells = <1>;
	#size-cells = <0>;
	reg = <0x18003000 0x4>;
	mux-mask = <0x200>;

	mdio@0 {
		reg = <0x0>;
		#address-cells = <1>;
		#size-cells = <0>;

		usb3_phy: usb3-phy@10 {
			compatible = "brcm,ns-ax-usb3-phy";
			reg = <0x10>;
			usb3-dmp-syscon = <&usb3_dmp>;
			#phy-cells = <0>;
			status = "disabled";
		};
	};

	mdio@200 {
		reg = <0x200>;
		#address-cells = <1>;
		#size-cells = <0>;

		switch@0  {
			compatible = "brcm,bcm53125";
			#address-cells = <1>;
			#size-cells = <0>;
			reset-gpios = <&chipcommon 10 GPIO_ACTIVE_LOW>;
			reset-names = "robo_reset";
			reg = <0>;
			dsa,member = <1 0>;
			pinctrl-names = "default";
			pinctrl-0 = <&pinmux_mdio>;

			ports {
				#address-cells = <1>;
				#size-cells = <0>;

				port@0 {
					reg = <0>;
					label = "lan1";
				};

				port@1 {
					reg = <1>;
					label = "lan5";
				};

				port@2 {
					reg = <2>;
					label = "lan2";
				};

				port@3 {
					reg = <3>;
					label = "lan6";
				};

				port@4 {
					reg = <4>;
					label = "lan3";
				};
			};
		};
	};
};


*** Used debugging diff ***

diff --git a/drivers/net/mdio/of_mdio.c b/drivers/net/mdio/of_mdio.c
index 4daf94bb5..dde775c92 100644
--- a/drivers/net/mdio/of_mdio.c
+++ b/drivers/net/mdio/of_mdio.c
@@ -251,6 +251,7 @@ int of_mdiobus_register(struct mii_bus *mdio, struct device_node *np)
         bool scanphys = false;
         int addr, rc;

+pr_info("[%s:%d] np:%pOF\n", __func__, __LINE__, np);
         if (!np)
                 return mdiobus_register(mdio);

@@ -278,6 +279,7 @@ int of_mdiobus_register(struct mii_bus *mdio, struct device_node *np)

         /* Loop over the child nodes and register a phy_device for each phy */
         for_each_available_child_of_node(np, child) {
+pr_info("[%s:%d] child:%pOF\n", __func__, __LINE__, child);
                 addr = of_mdio_parse_addr(&mdio->dev, child);
                 if (addr < 0) {
                         scanphys = true;
diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
index 950277e4d..a0a46af82 100644
--- a/drivers/net/phy/phy_device.c
+++ b/drivers/net/phy/phy_device.c
@@ -592,6 +592,7 @@ struct phy_device *phy_device_create(struct mii_bus *bus, int addr, u32 phy_id,

         dev->state = PHY_DOWN;

+dev_info(&mdiodev->dev, "[%s:%d] INIT MUTEX\n", __func__, __LINE__);
         mutex_init(&dev->lock);
         INIT_DELAYED_WORK(&dev->state_queue, phy_state_machine);

@@ -2835,7 +2836,10 @@ static int phy_probe(struct device *dev)
         if (phydrv->flags & PHY_IS_INTERNAL)
                 phydev->is_internal = true;

+WARN_ON(1);
+dev_info(dev, "[%s:%d] TAKING LOCK...\n", __func__, __LINE__);
         mutex_lock(&phydev->lock);
+dev_info(dev, "[%s:%d] LOCKED\n", __func__, __LINE__);

         /* Deassert the reset signal */
         phy_device_reset(phydev, 0);
