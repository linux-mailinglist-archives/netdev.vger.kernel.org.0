Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C48F467EE38
	for <lists+netdev@lfdr.de>; Fri, 27 Jan 2023 20:36:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229577AbjA0TgW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Jan 2023 14:36:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229502AbjA0TgT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Jan 2023 14:36:19 -0500
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2106.outbound.protection.outlook.com [40.107.93.106])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60510783EF;
        Fri, 27 Jan 2023 11:36:18 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ft8dGppzjKI1kkp9cZTpPXMgYaasD0fNVs6ZCwswXEWCTcKeBCGm0O79HWKy4H//XfGLrcgHxtprB6s9NS9D5UML1gRAv9xjnCq2qpt4fbiqxjdON0ewv05DeJGWvaqNNo4f+uqnre4DOZ7aMS+dFsZt7/6FrAarHmYyanMiIDjVwD8N9GUQ7Bwg960DcnmVm/BTRzOM8Ihh3RCVQpt6BnV+9jZn5/vickG0MCAeAb/2XqMDaYbxvDx7X0ss/0gEL5dq9N0mRk3sqZ+W5ehMRy7uMnO65D8RNF1v9dDfyOpc0YjRWYthH8apnIX7FHsNyfztwxsfdZUupEiB1eKxQA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eO7dIcVQPFkc6w1KvJhnXuOt0hlynzrLIS5vT1u+ncw=;
 b=gSDVs3fQ7XI7yb+OYUDaWFL+a0rMv34tT2n8R8cBX+nSJq4l1+NPgfrhMrFSyfmCRUUKxLpwzB0G4tg/DD/Z5q35SlLKleaHltAouR32mP/nh+EL6zZ4myWSuc/0xO8+wh+u8fkIpAYJNHgfmaz9evTF463J3VfeBo3HYgjO1njv+QwEhCfdxKA+sddQ+ZVtDqUWNnl+x8Lg2fO7xkAKFpFM8qTeKymmV/1ZzHrCtvwAd0B2ueMUaaKW4LiLuHGeekL3aGIyXXVtfEMtvDsu6METYCsFDSkBL+bW9E3F0K16i3f1+fWsQj4aa5FtM15B+hAQtQL8bb+Y1lHn6TQfBg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eO7dIcVQPFkc6w1KvJhnXuOt0hlynzrLIS5vT1u+ncw=;
 b=dDc7UIsE7MI+lDXZ1Q6uMDLMhOprY+7xSWKDaF5JGnkctG7v5/8/X3ocN0WZFJDIDK+yBGHKzsqw2Kyg5SFNUP6su3C0lNToOoP8fr+nKBuBnXyTbZWYFrOOr/4sm6HoA52vaLPktzyeelijCYT9ltaSswKOpsFniyTQLUt45ck=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from DM5PR1001MB2345.namprd10.prod.outlook.com (2603:10b6:4:2d::31)
 by SA2PR10MB4636.namprd10.prod.outlook.com (2603:10b6:806:11e::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.13; Fri, 27 Jan
 2023 19:36:12 +0000
Received: from DM5PR1001MB2345.namprd10.prod.outlook.com
 ([fe80::221:4186:6ea3:9097]) by DM5PR1001MB2345.namprd10.prod.outlook.com
 ([fe80::221:4186:6ea3:9097%7]) with mapi id 15.20.6064.010; Fri, 27 Jan 2023
 19:36:11 +0000
From:   Colin Foster <colin.foster@in-advantage.com>
To:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org
Cc:     Russell King <linux@armlinux.org.uk>,
        Richard Cochran <richardcochran@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>, UNGLinuxDriver@microchip.com,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, Lee Jones <lee@kernel.org>
Subject: [PATCH v5 net-next 00/13] add support for the the vsc7512 internal copper phys
Date:   Fri, 27 Jan 2023 11:35:46 -0800
Message-Id: <20230127193559.1001051-1-colin.foster@in-advantage.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR02CA0011.namprd02.prod.outlook.com
 (2603:10b6:a02:ee::24) To DM5PR1001MB2345.namprd10.prod.outlook.com
 (2603:10b6:4:2d::31)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR1001MB2345:EE_|SA2PR10MB4636:EE_
X-MS-Office365-Filtering-Correlation-Id: b537fcda-e6f4-49a9-eac6-08db009dbe77
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: KwMnrrJH9/3K9JAZNRkAlifcMneXa9/dKDYZ9ov4htlbT+3YiUMMbqCcnckuPtrm3eJm706lX1W8B40kFPGhEVGmq7a+lIXnBGZwMXq1nq2cu4TqI7F20nFyDDw0aUudrIZVfYWojCPidjXFcRYHRJIXrUs3+wft3tNzynzwOQbnbKPxdysUujeSi20IlErTFhkkutMrK1ODVF+06C+O4UhkNTL6iLj7D1M556QzRgS6UuJrqB5u9y1N4IVrv6lrZKIll4mTpCD9ti1dqPHX013vcJLleZQ9dIs/4Ewqk8R+9hQ5SzSRAuvblWdZolBrQf2TSj4mmBKL+Rc0tIGhtwu4TTOIhEdD8THTDtJS62ToVkWeVjjrPTZ9sK0L8giJJNe2pnn4+ZFx7lkkPr2RToqXpw7bvTJqo7Jo8bT/fwSNn6l+tHLSmz8bq5fLrC4/uh9puRSZADF0/ssVv5oX+j8zXTyNhfRdBKvz29e9fkEmk3iDo5tNuWVMw+52iiElxF3UvZ+S317OqegSTGD3FWcz+v4oBX9Ug3HZ0pivjxOa3PVuOK2uVOjXo/OlxWI5MZ0q5DzzFh0dQPywcS56VEmcsNPNfRZt4rXXxlPFGaakyXCnCIN/onIPBzYari+Bn1ysjTcFLq3/GJxIhd8Z8Y9TEy4VDOjoF1FnVUc9V5UkExJd1k0dB58ctpwUrIf4jjcbIK7WL3+7WhljXULuA/y9cS86Dx2UF6L5uFF7jko=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR1001MB2345.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(376002)(39830400003)(136003)(396003)(346002)(366004)(451199018)(36756003)(86362001)(2906002)(2616005)(6512007)(26005)(186003)(66946007)(66556008)(8676002)(4326008)(66476007)(52116002)(316002)(54906003)(6666004)(1076003)(6506007)(966005)(6486002)(478600001)(38350700002)(38100700002)(5660300002)(44832011)(41300700001)(7416002)(8936002)(83380400001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?rMRe78/jBFnInNRhavMd33iiD4HdYe+S155L6QmJXrzFb7bL3XQIax3wwRTK?=
 =?us-ascii?Q?N8D7qgKmoSOuaA8Ig4JdctsiMYldr/l6Qh0KEUH6g27NupHHiHmZzG5SC0w7?=
 =?us-ascii?Q?E4yDBptIzM0G+8mjN75Iv0XM71aFwSLwGhQnyxty0o3WHG+XkWNUAmQPPN0s?=
 =?us-ascii?Q?sV4/1GmRFoVo/k/WblVTRKO7bmTzPRs7KQn1+x/MF8mm6XsUQhk5G9678Zqm?=
 =?us-ascii?Q?67IbSYxNhucHgDmuVnm3yUlgl/2BQu/bJMuvMi4Ukf8gxf7gVrdOnX3DO05B?=
 =?us-ascii?Q?A0Zjh3j3adpsF0f7EwoHFPrdVC2n7cJQXB4WpSwONLtI7GKnVp9kjPa+nb/p?=
 =?us-ascii?Q?6sRFd2X4ZFXhhqgQB8G1HLVl6C2CMy2DX1zwfcjRPn8H6PgqHt0znNFBIPJN?=
 =?us-ascii?Q?hpH+u4Vy0olPuwxRC7P+KvIpTCEzMLaHgUrt3/y8iK9rrNAKHXrvJGsNzxtk?=
 =?us-ascii?Q?3RRRtBi41Idbj9LUHBAWPGtPCFA7YqSdQvo5Ys8WY7E6RMhY1UlwwmHtt5sG?=
 =?us-ascii?Q?KFZDzqB+26+c5n+F4m9VFaU2ef0YzY3sbMq3BBThxk559VLKrkCP99kRU6pO?=
 =?us-ascii?Q?amwvnCOwGTcC7LQ3KJAi5O7oMyUdfor/ny/VuT7xIjDoDCpUVRM7tHD1f50/?=
 =?us-ascii?Q?LmlMPNz+udnTwtHQ9b1TNXheM7bpUBgyaYAIQhL/jbMpbwna59BpGdxw7FN2?=
 =?us-ascii?Q?V19Cd66dVQvRKIN3mjzz5q62Wb7Tf7CNrJE3wy+kOVpdqS0UG3L9qnc4FpfB?=
 =?us-ascii?Q?pNfZZpCaP/sdhJqBAJgGcXtGQjM2w1be6Bv+3P+Szs01OjTthup1sgCuyFdd?=
 =?us-ascii?Q?jFAYfL09IQP9qvBNb+3rZU/zYKJZbdUh0KkS5QppF1mIfx5M/jhJfmFZtn15?=
 =?us-ascii?Q?nt0r2m22UPshdR3flYPscZ/Ay7AO+wG8XjVh/1osCbszRJx3FAsD6CldlOk9?=
 =?us-ascii?Q?PAHh+595TDjWHglBqVuKmOQBAutYO6Io+pjNaYvBopYW8B7O/fLDT2AwMKOA?=
 =?us-ascii?Q?IUY4jgpWSXnCfTL2de0BflxGgvXvt44Tm7UcNRqAvMdemj+lLpnxoYGddXjU?=
 =?us-ascii?Q?Qki1UJVGQ5Bie8vrrEw25z03O/P/4BBOvQwbsKEDxNwRRofv3GYnESIqwgJ2?=
 =?us-ascii?Q?GCWFD/baolNb/j0pwmiCX0JZ+B523/+TIqEAOSSCjRzcF820gi7eOmaq8DHZ?=
 =?us-ascii?Q?QAkN4RXNPknprcP27Ks/y4hMT9rslZyE8CMYKFfhV5tJuHlVUeD73EA3FtUy?=
 =?us-ascii?Q?+pP5F6+YYJ9siPPM51pe/hLl0NPBxOQnBY/xfK3dqLR4NUC1KXYHJRJ8AAlA?=
 =?us-ascii?Q?b+Pc63/vehu5WydADgPXbv3Ks8Jfs45FWwOYXnooS6Z4DHVSScvMfcc+FVdX?=
 =?us-ascii?Q?nkgzJdqamr26EQ7uTV7Gh0gMgxL4n7qxyE8zucdoqDgjZCC7IwLiKm2mbr3l?=
 =?us-ascii?Q?zBSb1wfh2IKXEZoOH1d6vYtMnV0x2AsffpKi8FbJHHOkgOlrLfHiFv+PcYsA?=
 =?us-ascii?Q?uYYn6FE3ElFczg7ko/nalnQl/OtbNF2PDVBR5YM11clbk+h5+JJ77+GM6sSA?=
 =?us-ascii?Q?Sar1Ro/KjRY7621YajayGfLpJn4EJHm8enK168nduDYQ+6xqkM8eXFx4hiJ8?=
 =?us-ascii?Q?TLWUq1/AnP8jmlQwBG+NfyE=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b537fcda-e6f4-49a9-eac6-08db009dbe77
X-MS-Exchange-CrossTenant-AuthSource: DM5PR1001MB2345.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jan 2023 19:36:11.0327
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HbX4CpXjMSnobYIP7+xZ5M9BiJjC9yBmsXSKW/61b+n20hc5Pr1kpoEYEWL3q31bZOgosfEniIxSTfQk3JU1WhwFoWkqFb6d2CWu9mm9UVM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4636
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch series is a continuation to add support for the VSC7512:
https://patchwork.kernel.org/project/netdevbpf/list/?series=674168&state=*

That series added the framework and initial functionality for the
VSC7512 chip. Several of these patches grew during the initial
development of the framework, which is why v1 will include changelogs.
It was during v9 of that original MFD patch set that these were dropped.

With that out of the way, the VSC7512 is mainly a subset of the VSC7514
chip. The 7512 lacks an internal MIPS processor, but otherwise many of
the register definitions are identical. That is why several of these
patches are simply to expose common resources from
drivers/net/ethernet/mscc/*.

This patch only adds support for the first four ports (swp0-swp3). The
remaining ports require more significant changes to the felix driver,
and will be handled in the future.


***
Note on V5: This driver triggers a bug in phy_device.c. A fix has been
sent to 'net': https://lkml.org/lkml/2023/1/27/1105
***

v5
    * Documentation overhauled to use
      /schemas/net/mscc,vsc7514-switch.yaml instead of
      /schemas/net/dsa/mscc,ocelot.yaml
    * Two patches were applied elsewhere, so have been dropped:
      "net: dsa: felix: populate mac_capabilities for all ports" and
      "dt-bindings: mfd: ocelot: remove spi-max-frequency from required
       properties"
    * stats_layout changes are no longer necessary, so the patch
      "net: mscc: ocelot: expose stats layout definition to be used by
       other drivers" has been dropped
    * Common naming macros has been dropped:
      "mfd: ocelot: add shared resource names for switch functionality".
      This changed patches 12-13 slightly.
    * Patch 12 had some small changes due to the rebase - more info there

v4
    * Update documentation to include all ports / modes (patch 15)
    * Fix dt_bindings_check warnings (patch 13, 14, 15)
    * Utilize new "resource_names" reference (patch 9, 12, 16)
    * Drop unnecessary #undef REG patch in pinctl: ocelot
    * Utilize standard MFD resource addition (patch 17)
    * Utilize shared vsc7514_regmap (new patch 6)
    * Allow forward-compatibility on fully-defined device trees
      (patch 10,14)

v3
    * Fix allmodconfig build (patch 8)
    * Change documentation wording (patch 12)
    * Import module namespace (patch 13)
    * Fix array initializer (patch 13)

v2
    * Utilize common ocelot_reset routine (new patch 5, modified patch 13)
    * Change init_regmap() routine to be string-based (new patch 8)
    * Split patches where necessary (patches 9 and 14)
    * Add documentation (patch 12) and MAINTAINERS (patch 13)
    * Upgrade to PATCH status

v1 (from RFC v8 suggested above):
    * Utilize the MFD framework for creating regmaps, as well as
      dev_get_regmap() (patches 7 and 8 of this series)


Colin Foster (13):
  net: mscc: ocelot: expose ocelot wm functions
  net: mscc: ocelot: expose regfield definition to be used by other
    drivers
  net: mscc: ocelot: expose vcap_props structure
  net: mscc: ocelot: expose ocelot_reset routine
  net: mscc: ocelot: expose vsc7514_regmap definition
  net: dsa: felix: add configurable device quirks
  net: dsa: felix: add support for MFD configurations
  net: dsa: felix: add functionality when not all ports are supported
  mfd: ocelot: prepend resource size macros to be 32-bit
  dt-bindings: net: mscc,vsc7514-switch: add dsa binding for the vsc7512
  dt-bindings: mfd: ocelot: add ethernet-switch hardware support
  net: dsa: ocelot: add external ocelot switch control
  mfd: ocelot: add external ocelot switch control

 .../devicetree/bindings/mfd/mscc,ocelot.yaml  |   9 +
 .../bindings/net/mscc,vsc7514-switch.yaml     | 113 ++++++++---
 MAINTAINERS                                   |   1 +
 drivers/mfd/ocelot-core.c                     |  68 ++++++-
 drivers/net/dsa/ocelot/Kconfig                |  20 ++
 drivers/net/dsa/ocelot/Makefile               |   2 +
 drivers/net/dsa/ocelot/felix.c                |  25 ++-
 drivers/net/dsa/ocelot/felix.h                |   2 +
 drivers/net/dsa/ocelot/felix_vsc9959.c        |   1 +
 drivers/net/dsa/ocelot/ocelot_ext.c           | 163 +++++++++++++++
 drivers/net/dsa/ocelot/seville_vsc9953.c      |   1 +
 drivers/net/ethernet/mscc/ocelot.c            |  48 ++++-
 drivers/net/ethernet/mscc/ocelot_devlink.c    |  31 +++
 drivers/net/ethernet/mscc/ocelot_vsc7514.c    | 190 +-----------------
 drivers/net/ethernet/mscc/vsc7514_regs.c      | 117 +++++++++++
 include/soc/mscc/ocelot.h                     |   6 +
 include/soc/mscc/vsc7514_regs.h               |   6 +
 17 files changed, 582 insertions(+), 221 deletions(-)
 create mode 100644 drivers/net/dsa/ocelot/ocelot_ext.c

-- 
2.25.1

