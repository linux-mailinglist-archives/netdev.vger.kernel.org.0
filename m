Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 424746E2C87
	for <lists+netdev@lfdr.de>; Sat, 15 Apr 2023 00:41:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229546AbjDNWl2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Apr 2023 18:41:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229450AbjDNWl1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Apr 2023 18:41:27 -0400
Received: from sender3-op-o17.zoho.com (sender3-op-o17.zoho.com [136.143.184.17])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15B105581
        for <netdev@vger.kernel.org>; Fri, 14 Apr 2023 15:41:25 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1681512073; cv=none; 
        d=zohomail.com; s=zohoarc; 
        b=cuE1dGfCEyeOpthhVq5VKzysVybYkhuGXBBmQYuGRdVO62Ntlu3NIHDQ4g1R1MJND1N22Cf343eM4/XmsY7xlYtxtuqBuQysx1UawjmM01WQ30dm4qAINSi5e+BJ678lZZbQLeh9F8KL0slDin3L2fC92W19a3jxd7ROWeVhGLw=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
        t=1681512073; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:MIME-Version:Message-ID:Subject:To; 
        bh=bc4Psn76lUY3Qp8/XMHf7UqHbkujH+xjUzpuoihgaOs=; 
        b=Es+xaiKfbvaubcHfNFWRZGN6ofKb5U3oZgeQMcA5bRJkh9l340cJObCHkow2YqWcbJb+2FDMt5tkBAye7bztwXKigvFLtaZygdrF27FTFboPkhgFPfrk4o6AVdOWrba4EYRL1oc2YqFrQpCIHaFfT61V+M/HqC1NDMsjocgrzU4=
ARC-Authentication-Results: i=1; mx.zohomail.com;
        dkim=pass  header.i=arinc9.com;
        spf=pass  smtp.mailfrom=arinc.unal@arinc9.com;
        dmarc=pass header.from=<arinc.unal@arinc9.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1681512073;
        s=zmail; d=arinc9.com; i=arinc.unal@arinc9.com;
        h=Message-ID:Date:Date:MIME-Version:From:From:To:To:Cc:Cc:Subject:Subject:Content-Type:Content-Transfer-Encoding:Message-Id:Reply-To;
        bh=bc4Psn76lUY3Qp8/XMHf7UqHbkujH+xjUzpuoihgaOs=;
        b=FpgK/PE68vjnBFbj/SioVCwgLHgjbpHSdzO/U07QDdRSSAH2941dzHKGveDL0Zts
        cWoufjt99DCpY7S6+GCWlD4+KgpFUzNMdnfBi7XCpSkZthsJIpU3mitbED34hAGuhLg
        fUGE4L8QgYLSMTBPrNL98/WF+yBWV74Wex78KTWI=
Received: from [10.10.10.3] (149.91.1.15 [149.91.1.15]) by mx.zohomail.com
        with SMTPS id 1681512071320609.2696103643955; Fri, 14 Apr 2023 15:41:11 -0700 (PDT)
Message-ID: <896514df-af33-6408-8b33-d8fd06e671ef@arinc9.com>
Date:   Sat, 15 Apr 2023 01:41:07 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
From:   =?UTF-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>
To:     Vladimir Oltean <olteanv@gmail.com>,
        Daniel Golle <daniel@makrotopia.org>,
        Frank Wunderlich <frank-w@public-files.de>
Cc:     netdev <netdev@vger.kernel.org>, erkin.bozoglu@xeront.com
Content-Language: en-US
Subject: mt7530: dsa_switch_parse_of() fails, causes probe code to run twice
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ZohoMailClient: External
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hey there,

I've been working on the MT7530 DSA subdriver. While doing some tests, I
realised mt7530_probe() runs twice. I moved enabling the regulators from
mt7530_setup() to mt7530_probe(). Enabling the regulators there ends up
with exception warnings on the first time. It works fine when
mt7530_probe() is run again.

This should not be an expected behaviour, right? Any ideas how we can make
it work the first time?

diff --git a/drivers/net/dsa/mt7530.c b/drivers/net/dsa/mt7530.c
index 02410ac439b7..57b262099791 100644
--- a/drivers/net/dsa/mt7530.c
+++ b/drivers/net/dsa/mt7530.c
@@ -3248,6 +3248,8 @@ mt7530_probe(struct mdio_device *mdiodev)
  	struct mt7530_priv *priv;
  	struct device_node *dn;
  
+	dev_info(&mdiodev->dev, "mt7530_probe() is running\n");
+
  	dn = mdiodev->dev.of_node;
  
  	priv = devm_kzalloc(&mdiodev->dev, sizeof(*priv), GFP_KERNEL);
diff --git a/net/dsa/dsa.c b/net/dsa/dsa.c
index e5f156940c67..738ca4420e85 100644
--- a/net/dsa/dsa.c
+++ b/net/dsa/dsa.c
@@ -1488,9 +1488,12 @@ static int dsa_switch_probe(struct dsa_switch *ds)
  		return -EINVAL;
  
  	if (np) {
+		dev_info(ds->dev, "np is true\n");
  		err = dsa_switch_parse_of(ds, np);
-		if (err)
+		if (err) {
+			dev_info(ds->dev, "np dts parse failed\n");
  			dsa_switch_release_ports(ds);
+		}
  	} else if (pdata) {
  		err = dsa_switch_parse(ds, pdata);
  		if (err)
@@ -1502,6 +1505,8 @@ static int dsa_switch_probe(struct dsa_switch *ds)
  	if (err)
  		return err;
  
+	dev_info(ds->dev, "np is successful\n");
+
  	dst = ds->dst;
  	dsa_tree_get(dst);
  	err = dsa_tree_setup(dst);

[    3.150567] mt7530 mdio-bus:1f: mt7530_probe() is running
[    3.156403] mt7530 mdio-bus:1f: np is true
[    3.160608] mt7530 mdio-bus:1f: np dts parse failed
[    3.167094] mtk_soc_eth 1b100000.ethernet: generated random MAC address 96:70:de:9e:c0:88
[    3.176535] mtk_soc_eth 1b100000.ethernet eth0: mediatek frame engine at 0xf09e0000, irq 213
[...]
[    4.121791] mt7530 mdio-bus:1f: mt7530_probe() is running
[    4.127678] mt7530 mdio-bus:1f: np is true
[    4.138242] mt7530 mdio-bus:1f: np is successful
[    4.154957] mt7530 mdio-bus:1f: no interrupt support
[    4.189915] mt7530 mdio-bus:1f: configuring for fixed/trgmii link mode
[    4.198619] mt7530 mdio-bus:1f: Link is Up - 1Gbps/Full - flow control rx/tx
[    4.206437] mt7530 mdio-bus:1f wan (uninitialized): PHY [mt7530-0:00] driver [MediaTek MT7530 PHY] (irq=POLL)
[    4.218450] mt7530 mdio-bus:1f lan0 (uninitialized): PHY [mt7530-0:01] driver [MediaTek MT7530 PHY] (irq=POLL)
[    4.230201] mt7530 mdio-bus:1f lan1 (uninitialized): PHY [mt7530-0:02] driver [MediaTek MT7530 PHY] (irq=POLL)
[    4.242000] mt7530 mdio-bus:1f lan2 (uninitialized): PHY [mt7530-0:03] driver [MediaTek MT7530 PHY] (irq=POLL)
[    4.253755] mt7530 mdio-bus:1f lan3 (uninitialized): PHY [mt7530-0:04] driver [MediaTek MT7530 PHY] (irq=POLL)
[    4.265271] mtk_soc_eth 1b100000.ethernet eth0: entered promiscuous mode
[    4.272101] DSA: tree 0 setup

The exceptions:

[    8.160099] ------------[ cut here ]------------
[    8.164753] WARNING: CPU: 3 PID: 1 at drivers/regulator/core.c:2405 _regulator_put+0x170/0x178
[    8.173450] Modules linked in:
[    8.176519] CPU: 3 PID: 1 Comm: swapper/0 Not tainted 6.3.0-rc6-next-20230413+ #17
[    8.184105] Hardware name: Mediatek Cortex-A7 (Device Tree)
[    8.189693]  unwind_backtrace from show_stack+0x18/0x1c
[    8.194947]  show_stack from dump_stack_lvl+0x40/0x4c
[    8.200022]  dump_stack_lvl from __warn+0x80/0x12c
[    8.204839]  __warn from warn_slowpath_fmt+0xc0/0x184
[    8.209916]  warn_slowpath_fmt from _regulator_put+0x170/0x178
[    8.215775]  _regulator_put from regulator_put+0x24/0x34
[    8.221109]  regulator_put from release_nodes+0x50/0xc4
[    8.226356]  release_nodes from devres_release_all+0x84/0xd0
[    8.232034]  devres_release_all from device_unbind_cleanup+0x14/0x68
[    8.238411]  device_unbind_cleanup from really_probe+0x268/0x400
[    8.244441]  really_probe from __driver_probe_device+0xa4/0x208
[    8.250384]  __driver_probe_device from driver_probe_device+0x38/0xc8
[    8.256847]  driver_probe_device from __device_attach_driver+0xb0/0x128
[    8.263484]  __device_attach_driver from bus_for_each_drv+0x98/0xec
[    8.269773]  bus_for_each_drv from __device_attach+0xb0/0x1dc
[    8.275540]  __device_attach from bus_probe_device+0x90/0x94
[    8.281221]  bus_probe_device from device_add+0x4d4/0x6c4
[    8.286639]  device_add from mdio_device_register+0x44/0x88
[    8.292230]  mdio_device_register from __of_mdiobus_register+0x1d8/0x3cc
[    8.298949]  __of_mdiobus_register from mtk_mdio_init+0x1c4/0x23c
[    8.305065]  mtk_mdio_init from mtk_probe+0x7cc/0x8ac
[    8.310140]  mtk_probe from platform_probe+0x64/0xb8
[    8.315123]  platform_probe from really_probe+0xe8/0x400
[    8.320453]  really_probe from __driver_probe_device+0xa4/0x208
[    8.326396]  __driver_probe_device from driver_probe_device+0x38/0xc8
[    8.332859]  driver_probe_device from __driver_attach+0x124/0x1d4
[    8.338975]  __driver_attach from bus_for_each_dev+0x84/0xd4
[    8.344656]  bus_for_each_dev from bus_add_driver+0xe8/0x208
[    8.350335]  bus_add_driver from driver_register+0x84/0x11c
[    8.355930]  driver_register from do_one_initcall+0x60/0x210
[    8.361612]  do_one_initcall from kernel_init_freeable+0x214/0x270
[    8.367817]  kernel_init_freeable from kernel_init+0x20/0x138
[    8.373588]  kernel_init from ret_from_fork+0x14/0x2c
[    8.378658] Exception stack(0xf0825fb0 to 0xf0825ff8)
[    8.383720] 5fa0:                                     00000000 00000000 00000000 00000000
[    8.391910] 5fc0: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000
[    8.400099] 5fe0: 00000000 00000000 00000000 00000000 00000013 00000000
[    8.406761] ---[ end trace 0000000000000000 ]---
[    8.411588] ------------[ cut here ]------------
[    8.416221] WARNING: CPU: 3 PID: 1 at drivers/regulator/core.c:2405 _regulator_put+0x170/0x178
[    8.424906] Modules linked in:
[    8.428001] CPU: 3 PID: 1 Comm: swapper/0 Tainted: G        W          6.3.0-rc6-next-20230413+ #17
[    8.437064] Hardware name: Mediatek Cortex-A7 (Device Tree)
[    8.442646]  unwind_backtrace from show_stack+0x18/0x1c
[    8.447898]  show_stack from dump_stack_lvl+0x40/0x4c
[    8.452970]  dump_stack_lvl from __warn+0x80/0x12c
[    8.457787]  __warn from warn_slowpath_fmt+0xc0/0x184
[    8.462864]  warn_slowpath_fmt from _regulator_put+0x170/0x178
[    8.468722]  _regulator_put from regulator_put+0x24/0x34
[    8.474056]  regulator_put from release_nodes+0x50/0xc4
[    8.479302]  release_nodes from devres_release_all+0x84/0xd0
[    8.484980]  devres_release_all from device_unbind_cleanup+0x14/0x68
[    8.491355]  device_unbind_cleanup from really_probe+0x268/0x400
[    8.497385]  really_probe from __driver_probe_device+0xa4/0x208
[    8.503327]  __driver_probe_device from driver_probe_device+0x38/0xc8
[    8.509790]  driver_probe_device from __device_attach_driver+0xb0/0x128
[    8.516427]  __device_attach_driver from bus_for_each_drv+0x98/0xec
[    8.522716]  bus_for_each_drv from __device_attach+0xb0/0x1dc
[    8.528484]  __device_attach from bus_probe_device+0x90/0x94
[    8.534165]  bus_probe_device from device_add+0x4d4/0x6c4
[    8.539582]  device_add from mdio_device_register+0x44/0x88
[    8.545172]  mdio_device_register from __of_mdiobus_register+0x1d8/0x3cc
[    8.551889]  __of_mdiobus_register from mtk_mdio_init+0x1c4/0x23c
[    8.558004]  mtk_mdio_init from mtk_probe+0x7cc/0x8ac
[    8.563079]  mtk_probe from platform_probe+0x64/0xb8
[    8.568062]  platform_probe from really_probe+0xe8/0x400
[    8.573392]  really_probe from __driver_probe_device+0xa4/0x208
[    8.579335]  __driver_probe_device from driver_probe_device+0x38/0xc8
[    8.585799]  driver_probe_device from __driver_attach+0x124/0x1d4
[    8.591914]  __driver_attach from bus_for_each_dev+0x84/0xd4
[    8.597594]  bus_for_each_dev from bus_add_driver+0xe8/0x208
[    8.603274]  bus_add_driver from driver_register+0x84/0x11c
[    8.608868]  driver_register from do_one_initcall+0x60/0x210
[    8.614549]  do_one_initcall from kernel_init_freeable+0x214/0x270
[    8.620753]  kernel_init_freeable from kernel_init+0x20/0x138
[    8.626523]  kernel_init from ret_from_fork+0x14/0x2c
[    8.631594] Exception stack(0xf0825fb0 to 0xf0825ff8)
[    8.636654] 5fa0:                                     00000000 00000000 00000000 00000000
[    8.644844] 5fc0: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000
[    8.653033] 5fe0: 00000000 00000000 00000000 00000000 00000013 00000000
[    8.659681] ---[ end trace 0000000000000000 ]---

Arınç
