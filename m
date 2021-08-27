Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 82BF03F9E72
	for <lists+netdev@lfdr.de>; Fri, 27 Aug 2021 20:01:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239183AbhH0SCF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Aug 2021 14:02:05 -0400
Received: from mail-eopbgr30046.outbound.protection.outlook.com ([40.107.3.46]:40590
        "EHLO EUR03-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231359AbhH0SCE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 27 Aug 2021 14:02:04 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=K/HmpI8cz/DbHIrmEEp0wGAHNOJTFeOdJdGzEKgV58JLg7XVtQCTpK6dvnZB0g5L4x8dYL4ZycEJq6QNsuhj7gnsuXUFbzhP8ue8wkQVkFNEF6sHnwtRsWBzQQJe/S8OL29MYs3GjmxE66yhDqjfYUf781wpqyWqlzS0mXNxl2kJt0aiB7qLi6ZV3+W59C+V07OyrvqGetnGoYtSmd9wT8cIPB6ToW3iahwggpyGFbO/KJYVN3aoMbAHvkq89c8aslrra8yKGh5ltViVEkFoLFzF8rav+gq0WtASmY26xbyC7fuUI3Yq4y9oOJ1kCbrm/6DB/heSFxpX+heMXvulUw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Wj8zfwnsmQUwUkaMK6Wl+QCCDVczgzIWA63ja2LLrAw=;
 b=Kdm3UWxfogXl7u9ZOVsGeKLqUP4MCXtKqDsY0LgUv+oM+Kw3ayiu/tjpIoIGFRPuy41P5ySj4VLLLwBAHEj07QitBB5OAm9ep2Yc5B8Vnxnh1dQ9+A/L0j1WFgTH3qHL087sOvahWeCHANGK8WggjOY3pVBBxWmcGBCITSwRJCYHyyHMsvXscWuzWxYSMaYKEohP/JIrnOv+JF4xqKiNEOg4m426zdzKCgpBCHjk7G/eLiuaF4p7p+da9Rn61pAW1jsYBy6Yi3oiwVhnCRC0/n6iQooVS1fnNSz8xBh0R0LXbexSR1P6LqNrxMES0BWpZFRnFNkb9fG75CoCJ5r8tQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Wj8zfwnsmQUwUkaMK6Wl+QCCDVczgzIWA63ja2LLrAw=;
 b=M/FvzaCJUa4/6BBJhIEoliMbsL6vvUTG1OHQBwQuwx4zSBl0nwyT5K9hjull1IZR8Wlt5NMTAZkjCOZq2OGZWvQx7QDPoLwir+PiASVzy01/rD9CPixxT6V0oTCOnk8MUylncoXvkJHGkWKR9cm2WChIiwqJY76AmJroA4CFjow=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB5856.eurprd04.prod.outlook.com (2603:10a6:803:eb::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4457.23; Fri, 27 Aug
 2021 18:01:12 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0%2]) with mapi id 15.20.4436.027; Fri, 27 Aug 2021
 18:01:11 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>
Subject: [PATCH net] net: dsa: mv88e6xxx: stop calling irq_domain_add_simple with the reg_lock held
Date:   Fri, 27 Aug 2021 21:01:01 +0300
Message-Id: <20210827180101.2330929-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR0601CA0012.eurprd06.prod.outlook.com
 (2603:10a6:800:1e::22) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (82.78.148.104) by VI1PR0601CA0012.eurprd06.prod.outlook.com (2603:10a6:800:1e::22) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4457.20 via Frontend Transport; Fri, 27 Aug 2021 18:01:11 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 28205229-e299-42cc-cd5c-08d96984a775
X-MS-TrafficTypeDiagnostic: VI1PR04MB5856:
X-Microsoft-Antispam-PRVS: <VI1PR04MB5856C4D00FFD73257E0CD7E7E0C89@VI1PR04MB5856.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: CkQU5zelHtdgHPCvrE994jGyH9/Bqz1K+lRtu2i6fNmjdxaJJQJpxJC4tg1abS8XT1K/D3XgIBDg0M1VFskunjfrfJdHEYnQub9BvnUGUq3JMJuIERG3hFLxV9jtwIYL24i+xeIS51GLAHKtxpi2mc3sJktC3M75d+xpf1ELlEXY8uT7DUBW9FErCTuKiP9Aq6La4wT4iP9X64oEO4sYE8Wc1c1I5147iB3fcvqLcCx08rzFIB80MTlX7DTRLVQ+/17EJ1VdlDgm/UY15ZFq5cvEQs4Q79F9OlgjHPVfmQBWwVKEXLWPxH2OP41dxxd9NCmqTHs6elkVpSYab44lg9+Pnu6TweWEuAeWOFwZsJP0pl2/gXXfhDnqJySA0DsbSlMbbGOqzjE8uHkHQo6NA89+ls1YpDGoWvNKCoFtwzheyc5lAUC0mOnbG2rkPa6oKV7ewGYot7Vc6wE4ByjraVqPk3MXvVfMNO0FBDwvzXNVNYb1AdfG3eefmspzvSGHyI2kWq5rc/n49GJFZxjm179acxGphnLrNmMuv1PBWHHTS2+2QkStpZYia1MIjPpo6Gbv7koLHsZJAUfXtnyb7XIkGx0XJmmKH+9ZET3ndDRt3Ds5Hxq/uGm73hI+c6qsQq4fFxgyz/Lj4QKdQHOH5W8DGEHewL+HoavFzbRJhxi7ZMyW4BvF7xHbWe5e1WsWt/8Ae3xzuwwIDgF+C/pWHw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(136003)(346002)(39860400002)(366004)(396003)(478600001)(2616005)(52116002)(6506007)(8936002)(26005)(1076003)(186003)(316002)(956004)(66476007)(6666004)(8676002)(2906002)(38350700002)(86362001)(44832011)(38100700002)(6916009)(66556008)(6512007)(6486002)(5660300002)(4326008)(66946007)(83380400001)(36756003)(54906003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?MHwhGQ6dnYvPHaWxtD/aVncHYul49iepiH/T3z7CN3JM0hS+62uNiqBmffZS?=
 =?us-ascii?Q?XuvPp3+A4Ehb/GYV6/OzfcifpHco2A0H3caFTxieePjzDUqEPduJPxiLjB9C?=
 =?us-ascii?Q?BUgf0rQm3/hXpxrhmoUl7GF1I9LQf5ZjDSpCZsfLetAZgARD0Z4oHbALL84m?=
 =?us-ascii?Q?TbA01+M/rOIXXaLzjOeSAdAw0USeS5xEXgPVs10ORiRBBx79jyQOh7v9ZnC4?=
 =?us-ascii?Q?4RWATRxzrO2YGXK3d2tjwzhpoS5Bw+ZJxoygmNfBc5DxS2NaSVNVKNhfTxeQ?=
 =?us-ascii?Q?FZbixRBeWWS5uv/P7Gn79K0F+U7nQZihpR1P3i7EDBLa+2TmnGsw8xbLCpzg?=
 =?us-ascii?Q?QX+b+u/K9n5Rr0tZH6rxHpAcQlj4pxI6KPNE421YyPSDTSgNrBkajoDnyabd?=
 =?us-ascii?Q?shP7sOXdH3tCpY+z6ku7LlGHMzzK2apXgBqbBiI0qU96RO5LF+YDYIa0AmEr?=
 =?us-ascii?Q?iVz7N1n1Etlcyn58B8AjReVAUbQjNHDUx6wwNeLEx8hehDIeC676wTk4+m4D?=
 =?us-ascii?Q?I9GVYYwpAANMrk6pO0JkGo9WpYS+RgBnajByRkA+rJBxSZk/sqU1A+ANHAYG?=
 =?us-ascii?Q?D68VRLzUkx7B6NG3+D+py6cYnwh6kWXUYVyKRkzmlO1i1G/DckhxdZ0dcSel?=
 =?us-ascii?Q?fZEop6FmHqklgC5pC15gMrFHoNitS3GY1LqSdKds9qpwUPGslMbIwvkBRN0V?=
 =?us-ascii?Q?9Xarj8+u8l62K62M0XAVMbBpBLXX7MiVWpoSWAUafqh3JO5tnppWW/1co/6c?=
 =?us-ascii?Q?x/aeZ5GZj2m/ho7A9h+cJufs8OLG1WNm2kHdjyMiQWFKKZ5whwSHboJd+msy?=
 =?us-ascii?Q?Al10e8TLxMwtt2PMHRb4rLG0nsW+foLwn3+Il0cgPZ4ejf2CsvkM1MrFJ62y?=
 =?us-ascii?Q?zDbrF4eR6BA5NYtpXak9KH5SyQOMhbafL/v67gcK/5JQPTqdohqP1ggcMlhd?=
 =?us-ascii?Q?FbIArONLBW+ZC581JLae2yxwlzHxPIhesjVVgibzqLHrAnQasVQrYRZ2VQ6T?=
 =?us-ascii?Q?D3wA3mxMZIG8Y73m8ldDIYhpLpeRy9o9A6B/7RSpf1E0rrFsdY8Z52/iX+8A?=
 =?us-ascii?Q?6xkJK/uTZ+Y2g32XReoxfxAsp+qIWBGmNyw25wq/l9fYusv4NmZ5OGL6RAWK?=
 =?us-ascii?Q?zjdzZ75MhM/zi0obQa77wK3rwqjhd2WVlL3p0SLPtlONBo/Nr4SzKRU9gSnH?=
 =?us-ascii?Q?2HkMmfh0cbuAup8lLASmUi8tvoVyRgAg5+/x9WZTqpoIpvx1QBjNvWMqT/o5?=
 =?us-ascii?Q?ZfPPh2H1rgfiXIhPd4Jau+vUfvZnPBfMYsFMBI9hDT16n9MLiGjinNNAvVNp?=
 =?us-ascii?Q?ydCfZfg8nfvDGQ6veWExny1H?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 28205229-e299-42cc-cd5c-08d96984a775
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Aug 2021 18:01:11.7649
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jRlbjYuTok4aLhcsRs9jR4vx88ATumOmFbXniB5FZ0zWlPBsSUjzzMAzbbtqBwoorttqoJvRKzGdYPWqlZREiA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB5856
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The mv88e6xxx IRQ setup code has some pretty horrible locking patterns,
and wrong.

Lockdep warns that mv88e6xxx_probe calls irq_domain_create_simple with
reg_lock held, because irq_domain_create_simple takes the
irq_domain_mutex through its call to __irq_domain_add.

But there also exists the reverse locking scheme: this driver implements
struct irq_chip :: irq_bus_lock as being the same old mv88e6xxx_reg_lock.
So there are code paths in the IRQ core, like this one:

mv88e6xxx_mdio_register
-> of_mdiobus_register
   -> fwnode_mdiobus_register_phy
      -> of_irq_get
         -> irq_create_of_mapping
            -> irq_create_fwspec_mapping
               -> irq_create_mapping_affinity
                  -> irq_domain_associate <- this takes the &irq_domain_mutex
                     -> mv88e6xxx_g2_irq_domain_map
                        -> irq_set_chip_and_handler_name
                           -> __irq_set_handler
                              -> irq_get_desc_buslock
                                 -> mv88e6xxx_g2_irq_bus_lock <- this takes the reg_lock

So there are at least in theory the premises of a deadlock, but in
practice just an ugly antipattern.

I've no idea why the reg_lock is taken so broadly just to temporarily
drop around request_threaded_irq() - and why that in itself was not
enough of an indication that something is wrong with this scheme.

Only hardware access should need the register lock, and this in itself
is for the mv88e6xxx_smi_indirect_ops to work properly and nothing more,
unless I'm misunderstanding something - but if that's the case, I don't
know why it isn't put inside mv88e6xxx_smi_{read,write} and instead it
is left to bloat the code so much, and then have other more specific
locks on top, rather than a single, giant "register" lock. Anyway...

This scheme also makes life harder when considering that the current
convention for mv88e6xxx_g1_irq_free_common is for the caller to take
the mutex. This is just because the mutex is taken top-level in one of
its 3 (indirect) callers, which is mv88e6xxx_g1_irq_setup_common.

But since this patch is to drop the reg_lock from being taken top-level
when we call mv88e6xxx_g1_irq_setup_common (or its poll alternative) and
instead just circle the hardware reads/writes with it, then we can drop
the locking requirement from mv88e6xxx_g1_irq_free_common too, and
follow the exact same pattern there too: locks around hw reads/writes.

Fixes: dc30c35be720 ("net: dsa: mv88e6xxx: Implement interrupt support.")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/dsa/mv88e6xxx/chip.c | 23 ++++++++++++-----------
 1 file changed, 12 insertions(+), 11 deletions(-)

diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index 272b0535d946..c9631302df0f 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -244,16 +244,19 @@ static const struct irq_domain_ops mv88e6xxx_g1_irq_domain_ops = {
 	.xlate	= irq_domain_xlate_twocell,
 };
 
-/* To be called with reg_lock held */
 static void mv88e6xxx_g1_irq_free_common(struct mv88e6xxx_chip *chip)
 {
 	int irq, virq;
 	u16 mask;
 
+	mv88e6xxx_reg_lock(chip);
+
 	mv88e6xxx_g1_read(chip, MV88E6XXX_G1_CTL1, &mask);
 	mask &= ~GENMASK(chip->g1_irq.nirqs, 0);
 	mv88e6xxx_g1_write(chip, MV88E6XXX_G1_CTL1, mask);
 
+	mv88e6xxx_reg_unlock(chip);
+
 	for (irq = 0; irq < chip->g1_irq.nirqs; irq++) {
 		virq = irq_find_mapping(chip->g1_irq.domain, irq);
 		irq_dispose_mapping(virq);
@@ -270,9 +273,7 @@ static void mv88e6xxx_g1_irq_free(struct mv88e6xxx_chip *chip)
 	 */
 	free_irq(chip->irq, chip);
 
-	mv88e6xxx_reg_lock(chip);
 	mv88e6xxx_g1_irq_free_common(chip);
-	mv88e6xxx_reg_unlock(chip);
 }
 
 static int mv88e6xxx_g1_irq_setup_common(struct mv88e6xxx_chip *chip)
@@ -293,9 +294,11 @@ static int mv88e6xxx_g1_irq_setup_common(struct mv88e6xxx_chip *chip)
 	chip->g1_irq.chip = mv88e6xxx_g1_irq_chip;
 	chip->g1_irq.masked = ~0;
 
+	mv88e6xxx_reg_lock(chip);
+
 	err = mv88e6xxx_g1_read(chip, MV88E6XXX_G1_CTL1, &mask);
 	if (err)
-		goto out_mapping;
+		goto out_unlock;
 
 	mask &= ~GENMASK(chip->g1_irq.nirqs, 0);
 
@@ -308,13 +311,17 @@ static int mv88e6xxx_g1_irq_setup_common(struct mv88e6xxx_chip *chip)
 	if (err)
 		goto out_disable;
 
+	mv88e6xxx_reg_unlock(chip);
+
 	return 0;
 
 out_disable:
 	mask &= ~GENMASK(chip->g1_irq.nirqs, 0);
 	mv88e6xxx_g1_write(chip, MV88E6XXX_G1_CTL1, mask);
 
-out_mapping:
+out_unlock:
+	mv88e6xxx_reg_unlock(chip);
+
 	for (irq = 0; irq < 16; irq++) {
 		virq = irq_find_mapping(chip->g1_irq.domain, irq);
 		irq_dispose_mapping(virq);
@@ -344,12 +351,10 @@ static int mv88e6xxx_g1_irq_setup(struct mv88e6xxx_chip *chip)
 	snprintf(chip->irq_name, sizeof(chip->irq_name),
 		 "mv88e6xxx-%s", dev_name(chip->dev));
 
-	mv88e6xxx_reg_unlock(chip);
 	err = request_threaded_irq(chip->irq, NULL,
 				   mv88e6xxx_g1_irq_thread_fn,
 				   IRQF_ONESHOT | IRQF_SHARED,
 				   chip->irq_name, chip);
-	mv88e6xxx_reg_lock(chip);
 	if (err)
 		mv88e6xxx_g1_irq_free_common(chip);
 
@@ -393,9 +398,7 @@ static void mv88e6xxx_irq_poll_free(struct mv88e6xxx_chip *chip)
 	kthread_cancel_delayed_work_sync(&chip->irq_poll_work);
 	kthread_destroy_worker(chip->kworker);
 
-	mv88e6xxx_reg_lock(chip);
 	mv88e6xxx_g1_irq_free_common(chip);
-	mv88e6xxx_reg_unlock(chip);
 }
 
 static int mv88e6xxx_port_config_interface(struct mv88e6xxx_chip *chip,
@@ -6286,12 +6289,10 @@ static int mv88e6xxx_probe(struct mdio_device *mdiodev)
 	 * the PHYs will link their interrupts to these interrupt
 	 * controllers
 	 */
-	mv88e6xxx_reg_lock(chip);
 	if (chip->irq > 0)
 		err = mv88e6xxx_g1_irq_setup(chip);
 	else
 		err = mv88e6xxx_irq_poll_setup(chip);
-	mv88e6xxx_reg_unlock(chip);
 
 	if (err)
 		goto out;
-- 
2.25.1

