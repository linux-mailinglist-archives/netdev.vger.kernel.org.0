Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA2A6479DCB
	for <lists+netdev@lfdr.de>; Sat, 18 Dec 2021 22:51:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234864AbhLRVuc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Dec 2021 16:50:32 -0500
Received: from mail-mw2nam10on2118.outbound.protection.outlook.com ([40.107.94.118]:19424
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234657AbhLRVuS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 18 Dec 2021 16:50:18 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZIAwaJAu2C4oEQPjAMsuNDj+st2L+uT591wIXZ1fccNqmXYBFwurfE6c45Pbpk51lH9K0AD4zNOsHJCvwdwlys5OY88UCh4dfhuEOgu9F6ZU3okV/UdRAfdSpET4NHYaWgnwZKgZQob6YrqB9LeNHONt1Uup4cjy2iQtm/XoBjrQzb7tR+DnmKP2UYdL3iaNFIu7qeGEoOkoE/+C434+ctBCUyFORtR5g4x8gsUu/u+wRN7LdPK7eEycK1dckjPpKe49R7d43oSqQ9qFPfXSIgsuhFUkyMDuCKxihmLqtVyZ29rh45AaOkFlSuyx4IbZpC1zkOhO2kPWXg9VaLjxdA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/MDQpmpKE+PnRLCj55SwiesyejzuT/VnP0S6WITX204=;
 b=jHnv6336JcGMqPnMfz9ZdDzf1klhmq3LZGqR8yXZPdziJF2TX0k0/ButxlZFnKUlqWXtovCymVwkDamxQD4fKZPGkeMa1wyG1Zrn1cYfDJZ7/VENne0GfDVfqeNFr2mGTYoe0apHxvxaJiyGtCpYI0EMzUr9CkC6HjrlEgymsgIyUm22hNQwkOKTS3WFs6eyGJhsU1SzZc9HO2M/3f4sX8QQJTMWnUXdMJEB3QnLsair0gmoBTfe2xtjMSGyxylLqyrpvyQpdv0lYLtQ+aw1zw19+ynjRf3ooLzAYufn5zu8XflZSvq7qU3ghMB9gCJ4QJ5hrEDEtSUvJPX1k4Ddig==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/MDQpmpKE+PnRLCj55SwiesyejzuT/VnP0S6WITX204=;
 b=N7+qRAI1vczepwu4QUXRPHSCWZL2f2RNgydu2ozZDYL2WehlcFi51/hD8o8BmVjtXRdga53A6H/DEMdImZOUm5u0rPiqYn68cZeGFtDwp9rzSUrWB7wayvgzygEdDq4c8E1tKvJ4UZUEH6HejJCPjtwVDL5YkQAbyQzO2xHGyA4=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by CO6PR10MB5633.namprd10.prod.outlook.com
 (2603:10b6:303:148::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4801.17; Sat, 18 Dec
 2021 21:50:15 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::2d52:2a96:7e6c:460f]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::2d52:2a96:7e6c:460f%4]) with mapi id 15.20.4801.017; Sat, 18 Dec 2021
 21:50:15 +0000
From:   Colin Foster <colin.foster@in-advantage.com>
To:     linux-gpio@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Linus Walleij <linus.walleij@linaro.org>,
        Russell King <linux@armlinux.org.uk>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>, UNGLinuxDriver@microchip.com,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Lee Jones <lee.jones@linaro.org>
Subject: [RFC v5 net-next 12/13] pinctrl: ocelot: add MFD functionality through ocelot-core
Date:   Sat, 18 Dec 2021 13:49:53 -0800
Message-Id: <20211218214954.109755-13-colin.foster@in-advantage.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211218214954.109755-1-colin.foster@in-advantage.com>
References: <20211218214954.109755-1-colin.foster@in-advantage.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MWHPR02CA0011.namprd02.prod.outlook.com
 (2603:10b6:300:4b::21) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ee9a673e-7770-4807-88aa-08d9c2705fac
X-MS-TrafficTypeDiagnostic: CO6PR10MB5633:EE_
X-Microsoft-Antispam-PRVS: <CO6PR10MB5633CA3E6FC5214292F73D72A4799@CO6PR10MB5633.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6108;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: PexieaIh+t8htf+72eN5pr46eMC/GTffh/RnVRzfLZVN8U1ayebdgvc7Y8npbmJVCnTSiJtBhLlnXhUw2lgboWjwuckmSXU1JfJ6NabUzkNI45Qd2PTOvWGe/mWvzaMLTEboo1EeDHtq3btFG8WPxnJAdiD5kzJEkcEG0OI92HXo4/WsbCLpQ3xJiQFnNQ3744yEf2d4CUz+opMPOqk6fHM+tPhoSm2eBhY4NRDylTVFkxX7vaoL0LHDpLaa5mW//tS/7/OLvCGvfkPDJ1XDbQl7fNNORnjSqtJ8SrPLy6BHxeK3OqfKDSgvZnTZIVaf/ywHhU3rdCcR8uk+PDTTjnGSQxS45LDofxl/yDCodXPtN86bb3ohzA6wxslnGwwz3fZM2amW/NnszM11g/JjOZ7ywuDtv++EbFFq9+IAnnnorrOXsybw/a35vJlv/kNW3KTPDZzKsEEAkvF/SGHvRIkmuA43nUau6uJArS8knNI9yYwC5SRz9kW3Yfih//0dtdc8jGL5WeeNfoZNJyRoC2DU1CGdXOAGJBA/U7EK4u/aWBT0/ROq0Y925xCpKBa9GuCFkEaBkUds+m3goXy8wBAokhFwVtt2k3vnztegQmbZrWCN7mMtrKrueQK3YVCi06fgVEW6RIBZkgmQGQr284hEOcZRAHh2Tb+jQPann6BlX5LD43v3eaAY5K5XRt89m1Tv6vEfdqV+YYxBFoe9Zw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39830400003)(396003)(366004)(346002)(376002)(136003)(6486002)(6506007)(7416002)(2906002)(36756003)(6512007)(26005)(86362001)(66556008)(66476007)(186003)(1076003)(6666004)(4326008)(83380400001)(66946007)(2616005)(44832011)(8936002)(8676002)(316002)(54906003)(38100700002)(5660300002)(508600001)(52116002)(38350700002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ScATJNDFSwBsomcbiVNyjrnnOGkBbt9qKrww19zvM1ztn75wlpHIp9yLek2W?=
 =?us-ascii?Q?IiZ+t1v54w6nJFToPzykPzihAw2Y6WB9srfxpSq5YQcKX1/CRmFtrXhLPxS+?=
 =?us-ascii?Q?QKkCIxlYNUmkjN9RHG2Ym54TX0lKie244sFZukroUMm7fRldpTB/+D79s9Iq?=
 =?us-ascii?Q?PJkOGjW4DccZrsCoFFSEZSvaKDg1DFy+sRMBDGvFGUVMIZuc/mXqqkgLh84R?=
 =?us-ascii?Q?pxjXK0H75lBb4brV0Ka/fypP8qEwo9HafFjsysCXPBZpPYWEjxnmMIKL6xqp?=
 =?us-ascii?Q?9tSB3DmbCxXb1odcvgHGIGfll76lupCj2ZZXhXqqoL63Yv6F/RQgp0kpWVRs?=
 =?us-ascii?Q?TTKqqOck5psxqxK9SmbTNqUHN7B4pLV0m5KnPa2oukyFQAz1WnmXQkRSkhZ1?=
 =?us-ascii?Q?yGybxwu2sgBcu9XYn/a1xYBdBHlDngTSB+TPVt3Mm3Ee6aGLwYFqSlPrxwDB?=
 =?us-ascii?Q?DWVQpKMXwRBzzx1D0ashdpg/0g50hc+z6ZVvDIeMMnaK99Rq5wPhysFhSS10?=
 =?us-ascii?Q?UOZ8MskJ6Zu/jgUF3cih8BI6f1gWydLGRO/efzth5Gu8h0D25lP+p4isJncj?=
 =?us-ascii?Q?xXqQLK5z3GxA8zUaxcCQgxMLgriXQ3FcOEqU4qAjdzHLGbiq7mPcJgZufg6V?=
 =?us-ascii?Q?xdugxQpOLkDbAkf6F6x/w/YZHeXA8/iKsq0zpn7b6bXbIqCwoH0bbOv0vpZV?=
 =?us-ascii?Q?tCZDw7AIpm3SIDHW1MfskQvEGUfYo/kdqO9XaVJQd+szeTTjBe6P9sC9l0sc?=
 =?us-ascii?Q?iiZTs54V6zJz7UNlIkoC35vqtj2oi1FQ5WgybjuKYyUaq2x5rpA+HxhnZClN?=
 =?us-ascii?Q?LNweLEpMeDOiUtAiYMmi190c6okl4JCFyj+q/U8A1yt+yovDLzrNkqj6nCLt?=
 =?us-ascii?Q?Cxd1zTAHeE+cOhxhPK+cnoVES/61FCI6LNx8OoVz5GY1afcgPQ3fezVG+ssN?=
 =?us-ascii?Q?wDWZvGuoTCndh6p8tnjA8j0JNhua7G7X84EljkFK3Y1C/A6GZ0QIYA4Y1bHP?=
 =?us-ascii?Q?lpy5GX8cngYO6z+OCl4uqx6XmNWXaoFe8ZGTH1HPfah0FvqYS6HR7H8Fl5kh?=
 =?us-ascii?Q?ArSrHA0gBcXEapdsXqMSFhihx0WKhlHzxKGnBFLuXtHU6T2/uS/VML8++FMv?=
 =?us-ascii?Q?QnUByzc5chP780PMCl2JX8hOzB4oJgmCXWb0KGve9cH+qL6Kkwvco0NBtPGw?=
 =?us-ascii?Q?WMhI79ema23XAIxrNpxhZJc0Lz0BW+q7CWQHFVdJuah68jrjUNyjuRvYKbir?=
 =?us-ascii?Q?KHeOVppj2fbpg+8HfvxDYd6T/JRmo/GmB2Peqaz3niaVpcy1U3LyghlCCngE?=
 =?us-ascii?Q?K7nzd74VKwC5uAnl275GUDMflkMUqgzttMO2pBtZdP36B88nBDt4E/nadP3s?=
 =?us-ascii?Q?VQ8PGPRxA7TvRKDwN/cgJCUgJOOYb2bntNvp/y4bwEt5q8vbGYbABaWpnSlW?=
 =?us-ascii?Q?CpBvyinl/OMvRH4mwAV8z896xpXxDmakgiUSFx4TstWiiWRsZrJJotH+Ay4L?=
 =?us-ascii?Q?SHh60U4oIQg3HMpNSfikhbpH+OZ9kZnzWhU9UPRnvjx8x2RBUGlOV5PlVF9N?=
 =?us-ascii?Q?VS0csHVt7BwB9g2naMCKbKHti6B0AxDTAi3h857mrStSjvLwOOaYwjrOIlnG?=
 =?us-ascii?Q?aucrFErgwjlGIJ5wcbCn3ejR6mWjZScDr2NIYPNpy1GL9qWimk0b1JOWUvvw?=
 =?us-ascii?Q?Ocy6hC+kI2nkLiN3E/2GD9UZscQ=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ee9a673e-7770-4807-88aa-08d9c2705fac
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Dec 2021 21:50:14.8935
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fbUrqt0xZ2cmT6tfWjb6snba2tFnUbmqFK+s/MKE7GAMMEHmfQrm0Sk33wQRSMxgN+G0JKnB0AfrOhd99VTy41GXgkkfWly7KxnKeWZKJ8Q=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR10MB5633
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In the MFD case we need to requrest a regmap from the patern device instead
of using mmio. This allows for the driver to be used in either case.

Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
---
 drivers/pinctrl/pinctrl-ocelot.c | 30 ++++++++++++++++++++++++------
 1 file changed, 24 insertions(+), 6 deletions(-)

diff --git a/drivers/pinctrl/pinctrl-ocelot.c b/drivers/pinctrl/pinctrl-ocelot.c
index 42aab9ba049a..d07ac7a0b487 100644
--- a/drivers/pinctrl/pinctrl-ocelot.c
+++ b/drivers/pinctrl/pinctrl-ocelot.c
@@ -10,6 +10,7 @@
 #include <linux/gpio/driver.h>
 #include <linux/interrupt.h>
 #include <linux/io.h>
+#include <linux/mfd/core.h>
 #include <linux/of_device.h>
 #include <linux/of_irq.h>
 #include <linux/of_platform.h>
@@ -20,6 +21,7 @@
 #include <linux/platform_device.h>
 #include <linux/regmap.h>
 #include <linux/slab.h>
+#include <soc/mscc/ocelot.h>
 
 #include "core.h"
 #include "pinconf.h"
@@ -1123,6 +1125,9 @@ static int lan966x_pinmux_set_mux(struct pinctrl_dev *pctldev,
 	return 0;
 }
 
+#if defined(REG)
+#undef REG
+#endif
 #define REG(r, info, p) ((r) * (info)->stride + (4 * ((p) / 32)))
 
 static int ocelot_gpio_set_direction(struct pinctrl_dev *pctldev,
@@ -1805,6 +1810,7 @@ static int ocelot_pinctrl_probe(struct platform_device *pdev)
 	struct device *dev = &pdev->dev;
 	struct ocelot_pinctrl *info;
 	struct regmap *pincfg;
+	struct resource *res;
 	void __iomem *base;
 	int ret;
 	struct regmap_config regmap_config = {
@@ -1819,16 +1825,28 @@ static int ocelot_pinctrl_probe(struct platform_device *pdev)
 
 	info->desc = (struct pinctrl_desc *)device_get_match_data(dev);
 
-	base = devm_ioremap_resource(dev,
-			platform_get_resource(pdev, IORESOURCE_MEM, 0));
-	if (IS_ERR(base))
-		return PTR_ERR(base);
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (IS_ERR(res)) {
+		dev_err(dev, "Failed to get resource\n");
+		return PTR_ERR(res);
+	}
 
 	info->stride = 1 + (info->desc->npins - 1) / 32;
 
-	regmap_config.max_register = OCELOT_GPIO_SD_MAP * info->stride + 15 * 4;
+	if (!device_is_mfd(pdev)) {
+		base = devm_ioremap_resource(dev, res);
+		if (IS_ERR(base))
+			return PTR_ERR(base);
+
+		regmap_config.max_register =
+			OCELOT_GPIO_SD_MAP * info->stride + 15 * 4;
+
+		info->map = devm_regmap_init_mmio(dev, base, &regmap_config);
+	} else {
+		info->map = ocelot_mfd_get_regmap_from_resource(dev->parent,
+								res);
+	}
 
-	info->map = devm_regmap_init_mmio(dev, base, &regmap_config);
 	if (IS_ERR(info->map)) {
 		dev_err(dev, "Failed to create regmap\n");
 		return PTR_ERR(info->map);
-- 
2.25.1

