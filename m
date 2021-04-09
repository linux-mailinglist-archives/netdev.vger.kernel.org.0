Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B81E03598BE
	for <lists+netdev@lfdr.de>; Fri,  9 Apr 2021 11:08:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233244AbhDIJIT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Apr 2021 05:08:19 -0400
Received: from mail-eopbgr40085.outbound.protection.outlook.com ([40.107.4.85]:42634
        "EHLO EUR03-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232974AbhDIJIG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 9 Apr 2021 05:08:06 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GthQo9SsDo0D/0qDY/DSZJjMWS3A1Nw+TavzpfHp8dhVWeBBiNCw1apm/IP+8VB6abeYusC98pzhzVUspjX+9YwHIOcKAe1WMkFwfz5fFdBT9/4TKNP86dYr842GNgqWPsDO3qKnDSIQCAAUNJxq38hdmCYQ5Olvo3qV/aSwYIELYAJIy9bLyAOHQG5YopCcJG16OwIvEkjhgLn1ar2/kn16YH2l6hN4QjtNvH4dn7ai87PmaGymWnc8hPOJ6JAnAnAeZF/ZzyxRfKCbBJjnsbxx98j1Sni6m59NIHqrIvPy33NZTvAl0AUQw+TSHZTvQLuYewk5zeD47hfmnhSYUQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OMlg2fxi4P7R0H3wJXlXTRCG+pYcSmWvSfNx9ui2a+Y=;
 b=I9lmE5b0t+zSr6Hj9bRSn3/Hz33bdIf2CQ9q9mlsH2He3518h3+sWSYUrTvh46YzNI0oXM8DlbhjgQ/O6UfmxSotG8ZX1vtTQ5xvrHUYL+FwWoeQIGbgWE+QLnIhZRRhkycLTF7p/yIcjfq0S3T5wSqxvg2ecLg7FBDOHhmjnq9vXXygtM0rD0CMXrdiUsxMpwHXxJtBpqATPiUPBH7TkmKQa1sP/7EZYZ4c9Gi+VmSDwkOzo+4mGbqQXi9OzGrElGwvRrLtQHwDHgQw4sKzF988uUYJoC4qUEACZLzawl/YH8hunPPkBEyuWzxVr9e7a8AFxMH5XdQJ/cWWCNuvig==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OMlg2fxi4P7R0H3wJXlXTRCG+pYcSmWvSfNx9ui2a+Y=;
 b=qQxbHK/9+mxq5bfYproiYNqMktq3YjfkQl3JYXgeAMk2WLrZGveN+zoleaGcbmz1usTGnzXUmaT+8Catg0trPQaOal3wdohblr3Skk/y06R+qH6PZ6eNm+9XLti8e/FFUxPMNoFz2rLfWZ/qhP1wVyN3svRAIPzPGUMHWo2QFY4=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=nxp.com;
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com (2603:10a6:10:fa::15)
 by DBAPR04MB7336.eurprd04.prod.outlook.com (2603:10a6:10:1a9::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.20; Fri, 9 Apr
 2021 09:07:52 +0000
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::9598:ace0:4417:d1d5]) by DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::9598:ace0:4417:d1d5%6]) with mapi id 15.20.4020.017; Fri, 9 Apr 2021
 09:07:52 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     davem@davemloft.net, kuba@kernel.org, robh+dt@kernel.org,
        andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk,
        frowand.list@gmail.com
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-imx@nxp.com
Subject: [PATCH net-next 3/3] of_net: add property "nvmem-mac-address" for of_get_mac_addr()
Date:   Fri,  9 Apr 2021 17:07:11 +0800
Message-Id: <20210409090711.27358-4-qiangqing.zhang@nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210409090711.27358-1-qiangqing.zhang@nxp.com>
References: <20210409090711.27358-1-qiangqing.zhang@nxp.com>
Content-Type: text/plain
X-Originating-IP: [119.31.174.71]
X-ClientProxiedBy: HK2PR02CA0184.apcprd02.prod.outlook.com
 (2603:1096:201:21::20) To DB8PR04MB6795.eurprd04.prod.outlook.com
 (2603:10a6:10:fa::15)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (119.31.174.71) by HK2PR02CA0184.apcprd02.prod.outlook.com (2603:1096:201:21::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.16 via Frontend Transport; Fri, 9 Apr 2021 09:07:48 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 00b198d8-fec2-4ef5-38c6-08d8fb36f476
X-MS-TrafficTypeDiagnostic: DBAPR04MB7336:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DBAPR04MB733672AE13684C7395DB2E9FE6739@DBAPR04MB7336.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4125;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: vTFg5CtxOAD4LkUyEi0TFXFbYKHW7GdRx8S/UFZ84+jp1K4eq9YZq+xpMT/8YNBU7iO56d+qKO6g3HofH2jkqKeVFy+3bQewRb8e0ZkYT0F7fVEfW3yqC717Ve/YigqSAWwvmCoIWRHB5M2quf5S1hwGnx1QN16w8yoS6YpAkMPh60JEDBlzZrUfn+//KGAGFM40S7vgY1u5VVbniSLMjPL6I2XlSdrAXKmWyU6ylaag4eBan8QuaDAwdydPJFDva1L3t+s0izNQWw5Be+gsmcCndSUW8inyc3E9FJYcataoa7mu6A5wOViLljDbAAoo0jgOFB+KwmJFuI/sZm9W8rY8lhOoBU/cyu29i+juVlR9VE0OXgIbqSVFNgGbK2KzwIYVtmDM4R/WqVez12d/IWS5Mv9dnKEzn7w8k/J5CpVAW9LFnOT0tjWsf/5P4OYcoSxO0vPgPW5j9LWL5CF0kAmzVJV1yOK/OYTtzIIunZdYRzYgU7NXDgNh2cxHhaeUwtFHtqWUJE3UmTjmFU48zuv8dTQMrfwoCGsmR4KzbfFuPf8FPmGzuw5FF3jorhcZvuEDShYuRCRDtL6GxFbQ3TDkflzoCKSSaRDG9Mc9d6lkmFaFl+4sB29Km0vssT28TkmzQwi/NCtnq5x6MbDv5ILoek9HG4+hZmlsU82G+WKEDUTYyDSw5jDwavbCHtlCAU6NvNaAvYJe9BP4Wl4Pb0hwfZPLFiWXc3JifJS5Jys=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR04MB6795.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(396003)(136003)(366004)(346002)(39860400002)(316002)(36756003)(6506007)(8936002)(8676002)(6486002)(52116002)(6666004)(6512007)(4326008)(956004)(66476007)(38350700001)(66556008)(5660300002)(69590400012)(2616005)(38100700001)(478600001)(7416002)(16526019)(26005)(186003)(2906002)(4744005)(1076003)(66946007)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?deUY06NrfDwdM6YkNBdbfONi2vKqGLn3ZDd/497nU9bvn/bdiKF/Kkb5t3AW?=
 =?us-ascii?Q?+95tlfXnHBQu/1ZLL5b1sr1LJupRvDGppEJzJiwEotOfEFy+3ovZwpkTVmg9?=
 =?us-ascii?Q?u8Edi2jNaWWbvV1gSrBBfSY36X6WJpQTL+v+IjobvAiDTiJAKPsbPXadUTgp?=
 =?us-ascii?Q?X93j64/HjIJS9bMZAjMR/JR8WBsnxTDwjgEuGW6H17P9X7lDoYd5MUP/54pr?=
 =?us-ascii?Q?lW9ZG6kz+FGho7RaEEQXX9TA/GMRdxx88nLkCySTSxv91s36nxWbEX55dUJ4?=
 =?us-ascii?Q?pg6x+eMnzr2X42C1VlDljEOnhhT4Jgfy0NQHLNQWHAIoomlIMTVBOW9z4uQM?=
 =?us-ascii?Q?LuNobog6CDRheZOxhPD8iqLvUQp43ciMP4xDgE2Ya3VTR1rtvIkZTGMRpBkH?=
 =?us-ascii?Q?FaDOsT2cfWxFIUidzfpw5DFHLBK3KTI6pTyP/7u98RbjIcIXQcIL8uZ+oyPB?=
 =?us-ascii?Q?T2ldyTj1qUd8N4BdAFnnkEKAinY3qSmmj/YPT6a1ia+RWWrejSgIK6aCbI1e?=
 =?us-ascii?Q?pz7TTq6M2crfGOFM8vMEC3vLa4XvDnvKHBW3FxY8fn3pFuC8LEHEdvx+1+CW?=
 =?us-ascii?Q?zHXFoSx+kvFtK2BdyMmw930kouGxHbL781APSnGui0R8mVDLVuClTqHJVU8A?=
 =?us-ascii?Q?KtsU5HSUx5l5QghYPLoM4gm/91XeMlA9h0vj76VLQ0S+7ceqMAld2BJAXufH?=
 =?us-ascii?Q?3i/uk+h8JdkBwLSNA/R05bCz5r0eUHNUl9Wdfq9jTtNpiFV9Zck7II1hUa28?=
 =?us-ascii?Q?ZKhcb39og2jI3x4ddGx/eGUszVtIqS6bXo9BmGOdmh8RF9weRlOyIHOVjJxy?=
 =?us-ascii?Q?w+nEoG56QauRl94mQMxtiMXgxTOaMqFXd/dby/f6DeWaFViQlMSJ6VurCYUn?=
 =?us-ascii?Q?lI2Z43zwncK9EV9GJu5P+nc0/da9E6wB5DLgQJP7WUFUNL6cUI7gpYmB6S0Y?=
 =?us-ascii?Q?PyBrXi1X8b3mCk9/EeXPlIBUK/0PrR9xjBC5TT4+BZtat/GX9VWr+ytQqHpw?=
 =?us-ascii?Q?Fp7gKgs7G5mD356InwZtNdueHCTxyh66KS9Ynwl95MeFHwdm59AKJQU60OK5?=
 =?us-ascii?Q?2uFfsc8jld/UN9adaMMcwcd4mzQ9eYimhdMYdQf03c6Lu8gE1MjaK0PPru/K?=
 =?us-ascii?Q?WmjCEBgY9bN4MV4fawBI6deg/EXaCFJTmcjmKEp8ahHUelqbM2uVmQ9AOIrP?=
 =?us-ascii?Q?SHtCP7tNNSgl/h2yV3Oc+1xju9yuR9SPlkdO0W1skZ4oakLScYLlOOaY6841?=
 =?us-ascii?Q?VyRJnyAfHSrLE15iCZ7OoRiFCDcioLXBqptaAgfKMcJXL/36zIO6Fk+6ChL3?=
 =?us-ascii?Q?cpbJyDlwlok5DZjxzaju4FhR?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 00b198d8-fec2-4ef5-38c6-08d8fb36f476
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6795.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Apr 2021 09:07:52.4385
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: k5bSbLVYP70FS2xxNMxjwILJV9C14AGhE0N4Feexo/ggorTuOYFmSWlcTvYmxvaTNB18/K+xto3W1W2Rw2qOkg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBAPR04MB7336
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Fugang Duan <fugang.duan@nxp.com>

If MAC address read from nvmem cell and it is valid mac address,
.of_get_mac_addr_nvmem() add new property "nvmem-mac-address" in
ethernet node. Once user call .of_get_mac_address() to get MAC
address again, it can read valid MAC address from device tree in
directly.

Signed-off-by: Fugang Duan <fugang.duan@nxp.com>
Signed-off-by: Joakim Zhang <qiangqing.zhang@nxp.com>
---
 drivers/of/of_net.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/of/of_net.c b/drivers/of/of_net.c
index 6e411821583e..20c3ae17f95f 100644
--- a/drivers/of/of_net.c
+++ b/drivers/of/of_net.c
@@ -116,6 +116,10 @@ const void *of_get_mac_address(struct device_node *np)
 	if (addr)
 		return addr;
 
+	addr = of_get_mac_addr(np, "nvmem-mac-address");
+	if (addr)
+		return addr;
+
 	return of_get_mac_addr_nvmem(np);
 }
 EXPORT_SYMBOL(of_get_mac_address);
-- 
2.17.1

