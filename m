Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BFD9040FA23
	for <lists+netdev@lfdr.de>; Fri, 17 Sep 2021 16:29:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241900AbhIQOa4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Sep 2021 10:30:56 -0400
Received: from mail-eopbgr50049.outbound.protection.outlook.com ([40.107.5.49]:58734
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233943AbhIQOaw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 17 Sep 2021 10:30:52 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LsqzLzfDL2yDK2ItgQ+eI1HYcHxulMImvNWLBvQYyaS9v1jy7sEAWd1cagfXunGHlwmQNEwEVLM8V2jC/AAQZuSs+q+wEK0ChNnlC+3WDnJvUwPoVCJMbogTxbQH8syAgRODuzJMyzXMya3EKX9vS1w1UvcYDJA5qPE8iSwTA6KdCHuChKFh3f1ePdkoYXsxdVTekijQmHSv5pijrK85ln7rrXqxLI63N7HDm+fz/q4dc5atTrn8QUtM15FQ0l1sot/R4P13P6lzFmCUPtRhIVxTnDnfOIbJ63pfaOEO0L7CDQe+HM/XfIRZ19PaVO5L3BrtPBHYIKHGIR1YG/VVeg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=sitKBKroyj6gAHpeBPK70gjr1qSXRBe02e6vJIX+Xlk=;
 b=oFytQhdifG8oom+2MPx0xtEjywA43ujn/1WpJirrwPptFszNj71r1ffDi7ltPRuJCfxmC8sIqZ8393eowaJvRvSvwYQNP+kaZdWOXF0nVLHZql7+KrxMB2Khic1Z83icq95MBfoJBLMGZCiPJaKUBp96pXHNj3idbSKKrCxehP+W0AJmvWCduEaUetdzDiZgkqI5aO8fzj2JPDrRImnm7SOIfCbBO41ZIYrhqEL+FnE461qTZyn+b6ybmIW9dfzPAHNq6Rahdpi8lSODQDVD+Gj9YeKaSiDpsIDr2835clFazO1bWSmK1rlTdH/nkl02SqVqxZCX5qdNCA02MHqgyw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sitKBKroyj6gAHpeBPK70gjr1qSXRBe02e6vJIX+Xlk=;
 b=JuHotRxlyMBk0k83y5x8lEbGYqtBTTVqgJFGKjDL1ITB51qHvBB0AhBWz3JuQFNGlx2uRRbdb1agOCChMFiTfDeL97B6w45eA4Tk2fwlMW/jV7u24YOTRvjqHMotcVMhV0qg2gVnULvhLDNY8EdMMb1tbau9yMucCD85DjWOFRA=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB5293.eurprd04.prod.outlook.com (2603:10a6:803:5f::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4523.14; Fri, 17 Sep
 2021 14:29:28 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0%2]) with mapi id 15.20.4500.019; Fri, 17 Sep 2021
 14:29:28 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>
Subject: [PATCH v2 net] net: dsa: tear down devlink port regions when tearing down the devlink port on error
Date:   Fri, 17 Sep 2021 17:29:16 +0300
Message-Id: <20210917142916.688090-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM3PR07CA0075.eurprd07.prod.outlook.com
 (2603:10a6:207:4::33) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (82.78.148.104) by AM3PR07CA0075.eurprd07.prod.outlook.com (2603:10a6:207:4::33) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4523.9 via Frontend Transport; Fri, 17 Sep 2021 14:29:27 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6c14f67a-e5e3-4786-aa45-08d979e78e60
X-MS-TrafficTypeDiagnostic: VI1PR04MB5293:
X-Microsoft-Antispam-PRVS: <VI1PR04MB52933F4C333ADCC8ED1BE3CDE0DD9@VI1PR04MB5293.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: RomZS4GkC2FyHjLvB+jx9YtcfU6Ulsh2muNmxQ21W9O7K7STDxIQ7qIj7RSSHwJBJrfZhFKR+HldgAwoc/bhTJKW15vnDQzv4AcuntzZthEMowS4xdH7xlADAhxVVA07pwbgnFwlVNf7FovZhKCTzmOQnc/zVAGEb+EIktayMEbDJureuR7vELXYwD1alj6QJX9/BFsSlldMyezIB+xWarGM7WoFWTviQEjjNbVWWYrPGk4Dff81qEZ6mmJAnn7yq8bXxze8DH/h6qsrG5VX8+JBkVv+JnK3x5PIPd5FqBEb2HKZ0PEtlV67yPX0ieZZr+oR6+aFIyi6TOL3+Ab/HglVvbSl97sYV2IH0yzTi488YYg210OE7Ah0sJIMZW8A2mnx5tdcXLwW1Os8Ka09hTiQ6cvkb2SQJKuFMnX2KAwQ4s7noe9uQnk8CjNcyoH5sLF1z2k4q9KJXNBHLCm/Eb2uJlimtgz+uWEW8IOQN8UHOCmMhALLX/sTUEe58IXGIT7S3b8vuH/sksQmmQICrl3c8KeEW2amiiJyLMhgSnTxtEBcn8qiIXGKeEjPiarTapqggknTKRYaOIPxGBn0hAwOgiyK8oYp4ACWdwtm3uNPKCf+o4cNHy0AWIUsbUhDvd3khRzEyL+re5RBRq9CIxtq4+8/UU9uVWnRNtNdiO6IjVAJ6/41cEUrLpVhSel0oTxfG14VCgXXWCa0tzQRjg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(366004)(136003)(376002)(396003)(346002)(38100700002)(38350700002)(6486002)(5660300002)(86362001)(6506007)(66946007)(26005)(30864003)(478600001)(956004)(2616005)(44832011)(66556008)(66476007)(186003)(4326008)(6512007)(1076003)(2906002)(52116002)(83380400001)(6916009)(8936002)(54906003)(36756003)(8676002)(6666004)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?tUq1HU0B+pnTLt7WCsfsYIKIPnvPet0LCsZYgT7rlBo2SQ/4VTtmUtP9YqNw?=
 =?us-ascii?Q?Cpr6XNEQzruEDKSX9Hl0xA8mhuqeo2Yrt07OZ6gzVWeZ+vXkpmdUEgdKVEXd?=
 =?us-ascii?Q?rb8eezzPjcorMoYubJ6O62FoPUOa4UhPqmMww9TRP5MI9AeWwfEB+5Qttj6n?=
 =?us-ascii?Q?cO2ejrRhUS6C5WFbSMQSLZXQiAVVXCsVh5a3ramL8FPEoIiTqI/8aDiurN7Z?=
 =?us-ascii?Q?pw+QQ7nvVXbLgwHjyucDYilw5EWxdJweSfersOZGXoZ9/nvOl7AzcUM8A6wT?=
 =?us-ascii?Q?sLURx5IJDPR7ZLcPyAiAvaKxf9lrZjkJx5l0XJu8FYTInV4z8+WwKWM3xbbo?=
 =?us-ascii?Q?WbvRpeb3RZK9ypU0wfv9tqUUX/I203S9XRdDwQGCs36j4GK8sFS8HLbSRUBb?=
 =?us-ascii?Q?mQv84OesW76nczBQe2RJZg843c9XqtGm6CtTBzTgZcmDSAVzBPbKYIr+popH?=
 =?us-ascii?Q?g6QgMW9p6fj5bDXvuF5ARhKRdYynVsNMlfh3zbKc38QudUg1LNes+47apkec?=
 =?us-ascii?Q?H9Ha971As72Hs3EDwyqa+8XinCwqOx3e6p7kwhHYcIRimTDdN0OXaCHJmbQj?=
 =?us-ascii?Q?HHhWus0h776NIFZ6G4r3hBjY3i+rA7esyAVo+ZrVMF6keVQjue3aTvJtmngs?=
 =?us-ascii?Q?00qIY6GtCmePFOV8Amo6ZY0Y0AN9jod/aK+ip0QCI7a8hrywDpsKv5Doi/UL?=
 =?us-ascii?Q?pgNVSRSm5DhgGqn0QIrnPaNFeEDSvUnSshRGVp13JZ6wjYx4PdOorI7VkVFg?=
 =?us-ascii?Q?2wmZLquue1AOMckVszC7UNgXw5vFG6UDqmn22rlZ8rPuYyW5Kxk5ZnM8/9cb?=
 =?us-ascii?Q?CjxfJ/C4h2uBkSmIeo1/jntnUtOZITOVPNRxBoFn48wo/pgebG1i5jyZjOEE?=
 =?us-ascii?Q?RBQod0NK3g28ExcQjJA1IlUSJdEfROMAhTIUjOtrOmnwAw09AAdZ8uWS/8Pu?=
 =?us-ascii?Q?7eMgwCcbEJuP2J24odTM/IPMT79LFQF+qftBYi3MvR4IALj2vpUcVd9xcwhr?=
 =?us-ascii?Q?A9wY2YTBjxKZXLmRH2b5BcPdKVEgTARHZeKtdkdr/kovaRIGzqC7e7eQH/n3?=
 =?us-ascii?Q?MfxId0FNzrH78DZaJXNOCCcLAX82DDvttm0Mj2ouwWeyRnQkyWlZbK4SNw+Y?=
 =?us-ascii?Q?zJiGr3yUfkGuoZV/Z7LceLgMoAzFunKRoF/Gt4o7QclXDLhGRXxpFK07cCdK?=
 =?us-ascii?Q?cH08pgSFBzujCcdyqb4xe4vXC4OjcgV6qGjA1wMS+J6ZNysB2kA3NU8pIDWM?=
 =?us-ascii?Q?476h8M6YesD6vzz7utvj4bBDCShYKOX34x8Mr/Sd2XOaWeJ2D+mr9uiHpx/y?=
 =?us-ascii?Q?T0tEGS6RDw7KacSWqPVpHFmG?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6c14f67a-e5e3-4786-aa45-08d979e78e60
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Sep 2021 14:29:28.4210
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7sQJocu2UeARXFPMVZWFgN53kY/yP68setZtI1HYyw5T6XqRKKeFQfO7bgDuLft1x/Dq5h6L9qAArBAjozrEcQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB5293
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit 86f8b1c01a0a ("net: dsa: Do not make user port errors fatal")
decided it was fine to ignore errors on certain ports that fail to
probe, and go on with the ports that do probe fine.

Commit fb6ec87f7229 ("net: dsa: Fix type was not set for devlink port")
noticed that devlink_port_type_eth_set(dlp, dp->slave); does not get
called, and devlink notices after a timeout of 3600 seconds and prints a
WARN_ON. So it went ahead to unregister the devlink port. And because
there exists an UNUSED port flavour, we actually re-register the devlink
port as UNUSED.

Commit 08156ba430b4 ("net: dsa: Add devlink port regions support to
DSA") added devlink port regions, which are set up by the driver and not
by DSA.

When we trigger the devlink port deregistration and reregistration as
unused, devlink now prints another WARN_ON, from here:

devlink_port_unregister:
	WARN_ON(!list_empty(&devlink_port->region_list));

So the port still has regions, which makes sense, because they were set
up by the driver, and the driver doesn't know we're unregistering the
devlink port.

Somebody needs to tear them down, and optionally (actually it would be
nice, to be consistent) set them up again for the new devlink port.

But DSA's layering stays in our way quite badly here.

The options I've considered are:

1. Introduce a function in devlink to just change a port's type and
   flavour. No dice, devlink keeps a lot of state, it really wants the
   port to not be registered when you set its parameters, so changing
   anything can only be done by destroying what we currently have and
   recreating it.

2. Make DSA cache the parameters passed to dsa_devlink_port_region_create,
   and the region returned, keep those in a list, then when the devlink
   port unregister needs to take place, the existing devlink regions are
   destroyed by DSA, and we replay the creation of new regions using the
   cached parameters. Problem: mv88e6xxx keeps the region pointers in
   chip->ports[port].region, and these will remain stale after DSA frees
   them. There are many things DSA can do, but updating mv88e6xxx's
   private pointers is not one of them.

3. Just let the driver do it (i.e. introduce a very specific method
   called ds->ops->port_reinit_as_unused, which unregisters its devlink
   port devlink regions, then the old devlink port, then registers the
   new one, then the devlink port regions for it). While it does work,
   as opposed to the others, it's pretty horrible from an API
   perspective and we can do better.

4. Introduce a new pair of methods, ->port_setup and ->port_teardown,
   which in the case of mv88e6xxx must register and unregister the
   devlink port regions. Call these 2 methods when the port must be
   reinitialized as unused.

Naturally, I went for the 4th approach.

Fixes: 08156ba430b4 ("net: dsa: Add devlink port regions support to DSA")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/dsa/mv88e6xxx/chip.c    | 16 ++++++-
 drivers/net/dsa/mv88e6xxx/devlink.c | 73 ++++-------------------------
 drivers/net/dsa/mv88e6xxx/devlink.h |  6 ++-
 include/net/dsa.h                   |  8 ++++
 net/dsa/dsa2.c                      | 51 ++++++++++++++++++--
 5 files changed, 81 insertions(+), 73 deletions(-)

diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index c45ca2473743..eb482be9df0d 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -3071,7 +3071,7 @@ static void mv88e6xxx_teardown(struct dsa_switch *ds)
 {
 	mv88e6xxx_teardown_devlink_params(ds);
 	dsa_devlink_resources_unregister(ds);
-	mv88e6xxx_teardown_devlink_regions(ds);
+	mv88e6xxx_teardown_devlink_regions_global(ds);
 }
 
 static int mv88e6xxx_setup(struct dsa_switch *ds)
@@ -3215,7 +3215,7 @@ static int mv88e6xxx_setup(struct dsa_switch *ds)
 	if (err)
 		goto out_resources;
 
-	err = mv88e6xxx_setup_devlink_regions(ds);
+	err = mv88e6xxx_setup_devlink_regions_global(ds);
 	if (err)
 		goto out_params;
 
@@ -3229,6 +3229,16 @@ static int mv88e6xxx_setup(struct dsa_switch *ds)
 	return err;
 }
 
+static int mv88e6xxx_port_setup(struct dsa_switch *ds, int port)
+{
+	return mv88e6xxx_setup_devlink_regions_port(ds, port);
+}
+
+static void mv88e6xxx_port_teardown(struct dsa_switch *ds, int port)
+{
+	mv88e6xxx_teardown_devlink_regions_port(ds, port);
+}
+
 /* prod_id for switch families which do not have a PHY model number */
 static const u16 family_prod_id_table[] = {
 	[MV88E6XXX_FAMILY_6341] = MV88E6XXX_PORT_SWITCH_ID_PROD_6341,
@@ -6116,6 +6126,8 @@ static const struct dsa_switch_ops mv88e6xxx_switch_ops = {
 	.change_tag_protocol	= mv88e6xxx_change_tag_protocol,
 	.setup			= mv88e6xxx_setup,
 	.teardown		= mv88e6xxx_teardown,
+	.port_setup		= mv88e6xxx_port_setup,
+	.port_teardown		= mv88e6xxx_port_teardown,
 	.phylink_validate	= mv88e6xxx_validate,
 	.phylink_mac_link_state	= mv88e6xxx_serdes_pcs_get_state,
 	.phylink_mac_config	= mv88e6xxx_mac_config,
diff --git a/drivers/net/dsa/mv88e6xxx/devlink.c b/drivers/net/dsa/mv88e6xxx/devlink.c
index 0c0f5ea6680c..381068395c63 100644
--- a/drivers/net/dsa/mv88e6xxx/devlink.c
+++ b/drivers/net/dsa/mv88e6xxx/devlink.c
@@ -647,26 +647,25 @@ static struct mv88e6xxx_region mv88e6xxx_regions[] = {
 	},
 };
 
-static void
-mv88e6xxx_teardown_devlink_regions_global(struct mv88e6xxx_chip *chip)
+void mv88e6xxx_teardown_devlink_regions_global(struct dsa_switch *ds)
 {
+	struct mv88e6xxx_chip *chip = ds->priv;
 	int i;
 
 	for (i = 0; i < ARRAY_SIZE(mv88e6xxx_regions); i++)
 		dsa_devlink_region_destroy(chip->regions[i]);
 }
 
-static void
-mv88e6xxx_teardown_devlink_regions_port(struct mv88e6xxx_chip *chip,
-					int port)
+void mv88e6xxx_teardown_devlink_regions_port(struct dsa_switch *ds, int port)
 {
+	struct mv88e6xxx_chip *chip = ds->priv;
+
 	dsa_devlink_region_destroy(chip->ports[port].region);
 }
 
-static int mv88e6xxx_setup_devlink_regions_port(struct dsa_switch *ds,
-						struct mv88e6xxx_chip *chip,
-						int port)
+int mv88e6xxx_setup_devlink_regions_port(struct dsa_switch *ds, int port)
 {
+	struct mv88e6xxx_chip *chip = ds->priv;
 	struct devlink_region *region;
 
 	region = dsa_devlink_port_region_create(ds,
@@ -681,40 +680,10 @@ static int mv88e6xxx_setup_devlink_regions_port(struct dsa_switch *ds,
 	return 0;
 }
 
-static void
-mv88e6xxx_teardown_devlink_regions_ports(struct mv88e6xxx_chip *chip)
-{
-	int port;
-
-	for (port = 0; port < mv88e6xxx_num_ports(chip); port++)
-		mv88e6xxx_teardown_devlink_regions_port(chip, port);
-}
-
-static int mv88e6xxx_setup_devlink_regions_ports(struct dsa_switch *ds,
-						 struct mv88e6xxx_chip *chip)
-{
-	int port;
-	int err;
-
-	for (port = 0; port < mv88e6xxx_num_ports(chip); port++) {
-		err = mv88e6xxx_setup_devlink_regions_port(ds, chip, port);
-		if (err)
-			goto out;
-	}
-
-	return 0;
-
-out:
-	while (port-- > 0)
-		mv88e6xxx_teardown_devlink_regions_port(chip, port);
-
-	return err;
-}
-
-static int mv88e6xxx_setup_devlink_regions_global(struct dsa_switch *ds,
-						  struct mv88e6xxx_chip *chip)
+int mv88e6xxx_setup_devlink_regions_global(struct dsa_switch *ds)
 {
 	bool (*cond)(struct mv88e6xxx_chip *chip);
+	struct mv88e6xxx_chip *chip = ds->priv;
 	struct devlink_region_ops *ops;
 	struct devlink_region *region;
 	u64 size;
@@ -753,30 +722,6 @@ static int mv88e6xxx_setup_devlink_regions_global(struct dsa_switch *ds,
 	return PTR_ERR(region);
 }
 
-int mv88e6xxx_setup_devlink_regions(struct dsa_switch *ds)
-{
-	struct mv88e6xxx_chip *chip = ds->priv;
-	int err;
-
-	err = mv88e6xxx_setup_devlink_regions_global(ds, chip);
-	if (err)
-		return err;
-
-	err = mv88e6xxx_setup_devlink_regions_ports(ds, chip);
-	if (err)
-		mv88e6xxx_teardown_devlink_regions_global(chip);
-
-	return err;
-}
-
-void mv88e6xxx_teardown_devlink_regions(struct dsa_switch *ds)
-{
-	struct mv88e6xxx_chip *chip = ds->priv;
-
-	mv88e6xxx_teardown_devlink_regions_ports(chip);
-	mv88e6xxx_teardown_devlink_regions_global(chip);
-}
-
 int mv88e6xxx_devlink_info_get(struct dsa_switch *ds,
 			       struct devlink_info_req *req,
 			       struct netlink_ext_ack *extack)
diff --git a/drivers/net/dsa/mv88e6xxx/devlink.h b/drivers/net/dsa/mv88e6xxx/devlink.h
index 3d72db3dcf95..65ce6a6858b9 100644
--- a/drivers/net/dsa/mv88e6xxx/devlink.h
+++ b/drivers/net/dsa/mv88e6xxx/devlink.h
@@ -12,8 +12,10 @@ int mv88e6xxx_devlink_param_get(struct dsa_switch *ds, u32 id,
 				struct devlink_param_gset_ctx *ctx);
 int mv88e6xxx_devlink_param_set(struct dsa_switch *ds, u32 id,
 				struct devlink_param_gset_ctx *ctx);
-int mv88e6xxx_setup_devlink_regions(struct dsa_switch *ds);
-void mv88e6xxx_teardown_devlink_regions(struct dsa_switch *ds);
+int mv88e6xxx_setup_devlink_regions_global(struct dsa_switch *ds);
+void mv88e6xxx_teardown_devlink_regions_global(struct dsa_switch *ds);
+int mv88e6xxx_setup_devlink_regions_port(struct dsa_switch *ds, int port);
+void mv88e6xxx_teardown_devlink_regions_port(struct dsa_switch *ds, int port);
 
 int mv88e6xxx_devlink_info_get(struct dsa_switch *ds,
 			       struct devlink_info_req *req,
diff --git a/include/net/dsa.h b/include/net/dsa.h
index 258867eff230..57845fdabd4f 100644
--- a/include/net/dsa.h
+++ b/include/net/dsa.h
@@ -585,8 +585,16 @@ struct dsa_switch_ops {
 	int	(*change_tag_protocol)(struct dsa_switch *ds, int port,
 				       enum dsa_tag_protocol proto);
 
+	/* Optional switch-wide initialization and destruction methods */
 	int	(*setup)(struct dsa_switch *ds);
 	void	(*teardown)(struct dsa_switch *ds);
+
+	/* Per-port initialization and destruction methods. Mandatory if the
+	 * driver registers devlink port regions, optional otherwise.
+	 */
+	int	(*port_setup)(struct dsa_switch *ds, int port);
+	void	(*port_teardown)(struct dsa_switch *ds, int port);
+
 	u32	(*get_phy_flags)(struct dsa_switch *ds, int port);
 
 	/*
diff --git a/net/dsa/dsa2.c b/net/dsa/dsa2.c
index eef13cd20f19..1fa6f9c50782 100644
--- a/net/dsa/dsa2.c
+++ b/net/dsa/dsa2.c
@@ -429,6 +429,7 @@ static int dsa_port_setup(struct dsa_port *dp)
 {
 	struct devlink_port *dlp = &dp->devlink_port;
 	bool dsa_port_link_registered = false;
+	struct dsa_switch *ds = dp->ds;
 	bool dsa_port_enabled = false;
 	int err = 0;
 
@@ -438,6 +439,12 @@ static int dsa_port_setup(struct dsa_port *dp)
 	INIT_LIST_HEAD(&dp->fdbs);
 	INIT_LIST_HEAD(&dp->mdbs);
 
+	if (ds->ops->port_setup) {
+		err = ds->ops->port_setup(ds, dp->index);
+		if (err)
+			return err;
+	}
+
 	switch (dp->type) {
 	case DSA_PORT_TYPE_UNUSED:
 		dsa_port_disable(dp);
@@ -480,8 +487,11 @@ static int dsa_port_setup(struct dsa_port *dp)
 		dsa_port_disable(dp);
 	if (err && dsa_port_link_registered)
 		dsa_port_link_unregister_of(dp);
-	if (err)
+	if (err) {
+		if (ds->ops->port_teardown)
+			ds->ops->port_teardown(ds, dp->index);
 		return err;
+	}
 
 	dp->setup = true;
 
@@ -533,11 +543,15 @@ static int dsa_port_devlink_setup(struct dsa_port *dp)
 static void dsa_port_teardown(struct dsa_port *dp)
 {
 	struct devlink_port *dlp = &dp->devlink_port;
+	struct dsa_switch *ds = dp->ds;
 	struct dsa_mac_addr *a, *tmp;
 
 	if (!dp->setup)
 		return;
 
+	if (ds->ops->port_teardown)
+		ds->ops->port_teardown(ds, dp->index);
+
 	devlink_port_type_clear(dlp);
 
 	switch (dp->type) {
@@ -581,6 +595,36 @@ static void dsa_port_devlink_teardown(struct dsa_port *dp)
 	dp->devlink_port_setup = false;
 }
 
+/* Destroy the current devlink port, and create a new one which has the UNUSED
+ * flavour. At this point, any call to ds->ops->port_setup has been already
+ * balanced out by a call to ds->ops->port_teardown, so we know that any
+ * devlink port regions the driver had are now unregistered. We then call its
+ * ds->ops->port_setup again, in order for the driver to re-create them on the
+ * new devlink port.
+ */
+static int dsa_port_reinit_as_unused(struct dsa_port *dp)
+{
+	struct dsa_switch *ds = dp->ds;
+	int err;
+
+	dsa_port_devlink_teardown(dp);
+	dp->type = DSA_PORT_TYPE_UNUSED;
+	err = dsa_port_devlink_setup(dp);
+	if (err)
+		return err;
+
+	if (ds->ops->port_setup) {
+		/* On error, leave the devlink port registered,
+		 * dsa_switch_teardown will clean it up later.
+		 */
+		err = ds->ops->port_setup(ds, dp->index);
+		if (err)
+			return err;
+	}
+
+	return 0;
+}
+
 static int dsa_devlink_info_get(struct devlink *dl,
 				struct devlink_info_req *req,
 				struct netlink_ext_ack *extack)
@@ -938,12 +982,9 @@ static int dsa_tree_setup_switches(struct dsa_switch_tree *dst)
 	list_for_each_entry(dp, &dst->ports, list) {
 		err = dsa_port_setup(dp);
 		if (err) {
-			dsa_port_devlink_teardown(dp);
-			dp->type = DSA_PORT_TYPE_UNUSED;
-			err = dsa_port_devlink_setup(dp);
+			err = dsa_port_reinit_as_unused(dp);
 			if (err)
 				goto teardown;
-			continue;
 		}
 	}
 
-- 
2.25.1

