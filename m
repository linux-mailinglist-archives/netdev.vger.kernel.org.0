Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0C4225F86D2
	for <lists+netdev@lfdr.de>; Sat,  8 Oct 2022 20:52:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229852AbiJHSwX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 8 Oct 2022 14:52:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229789AbiJHSwN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 8 Oct 2022 14:52:13 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2118.outbound.protection.outlook.com [40.107.94.118])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FC833F301;
        Sat,  8 Oct 2022 11:52:12 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PqRhLX+GsjSWyu/b4mX0rclg01vGhiFQ/8DdT26RNGMOk/PdGyM2MJVQVv529TRtwvzuC55RhouCo9Qj/iPuEoUAGJNaT740zwmMmq9/8pJ1caqSVcLygoEbmdSl8fqzZSoReQFHN75QyKzpWyFxGBgRn1HY8k17vYfG/8pf4IHBsW2VE5uYbKSMaKDnVqxrf2zFF4+3r4uzxWDUHhS/MmkPZV53JAVHbNjx7wsxZRqdOFPM4XZqWdu3FZNFE1Si6fz1saTl9eqcGuuLLpD/gUF64PTewwjdr937fuWZL3Z0o13z0NQjaSoyGmN7R1CD+o6LgL7zHGLUw/ztdfuU0Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4Q0cd1988MgNh2C+zlYXtdN6JeXoqO2yw/CVK5lqrOE=;
 b=QDdlQtmIpUz5DtR8/yMlgpViCgqWR/l4h3dU9v2dviRG6fSmn+r25r52DnsDTP1oEED1WXvsc0N/xNrFUCyT60DZn4QfeCfn+UZBF0MGmAKTQjrvw+1AmV9Z4jHWggjzh/gUBAulfnk5y6Y3mRCko44+cAmnK9DvlQGRMCyAKMNhFxSeCpY5watquq0DeqFCZ28TxOjK9L98Cb2x+HsSh4NR2prn7GRcnZiPBxnek/pXrcYKJZDSXk4/6D9FMBXuh8pYyqEsowwtPkEj0YD6XlOuZyXj5XLymb4tcKbjIRCq5+yCVvQPN27q0lOpbp5XevKDMNMIvnW9kcHCp8vVJw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4Q0cd1988MgNh2C+zlYXtdN6JeXoqO2yw/CVK5lqrOE=;
 b=mG9jyGPpRraqnSmenAsEeCXKLt9oWx6qyZkh1A6g/pQ9Bt+/IZNOWORpHJEaks2MMZiNTmfM8489nlPpe42TG4laeHZ71iTqvCztA/fBnsBTWgw5jME1/1Xj5aUzQmAeM5HaHHbZQnQnCTBs1NuVZDfmDdMSizXzQAEf3PtHIIk=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by PH7PR10MB6129.namprd10.prod.outlook.com
 (2603:10b6:510:1f7::19) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5676.20; Sat, 8 Oct
 2022 18:52:08 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::ee5e:cbf9:e304:942f]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::ee5e:cbf9:e304:942f%7]) with mapi id 15.20.5676.028; Sat, 8 Oct 2022
 18:52:08 +0000
From:   Colin Foster <colin.foster@in-advantage.com>
To:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org
Cc:     Russell King <linux@armlinux.org.uk>, UNGLinuxDriver@microchip.com,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Vladimir Oltean <olteanv@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, Lee Jones <lee@kernel.org>
Subject: [RFC v4 net-next 08/17] net: dsa: felix: populate mac_capabilities for all ports
Date:   Sat,  8 Oct 2022 11:51:43 -0700
Message-Id: <20221008185152.2411007-9-colin.foster@in-advantage.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221008185152.2411007-1-colin.foster@in-advantage.com>
References: <20221008185152.2411007-1-colin.foster@in-advantage.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MW4PR03CA0304.namprd03.prod.outlook.com
 (2603:10b6:303:dd::9) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWHPR1001MB2351:EE_|PH7PR10MB6129:EE_
X-MS-Office365-Filtering-Correlation-Id: c9fb9a7c-2a02-4cd1-5b21-08daa95e3336
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 7uw4zGpvb12oAlJKoGdiRRsfLh1LjxIO6EzHifThDPAyLPlyJmdXkKH0wY34H1ad2dsAfnfZENRPKUQusAPjv3zCKEFPbpDMNkebNSED9X1OExiUUcS2vNXwm2b41SzbVvWarumBu013I7sR/zXbKAmnM9DSoChfZqPHFQ9FtCHvFl+WCN8dP1rzBvvViv1H3x6pTT6x6H52nBADsrzCKsV7Ol0FkMcZaMKVcCnpaVmEx0yn6dCrBrEiRDZKFlmf4swZo4VzZ5sanBUugGh5NKuz6f6YusKbUWjm9xat1kqRQOQkwkpgHiYdo/v3K25A4dtgBQ1t3T4HbWsn99vSToVKu3IWDyjiIyiUMCXKKd2Ua9QdM7oJd4D4BzLFAOr1B9XqF+Be4rnxik//OjgCeY+UXGCQuicbffwsfMJCFIgTbN5ztB7B/cjhO+qlI6fIQpSB1MjsDGXuT3zhLj+xdE/4iN0F4g9pqhItQoUd7Bl5p4bpQ2M7rJiywqQcQgmkrhM0RtgaJgOrc5WxyZTXNNLSNcXAKq/685w0HF93f7chs1dCVnoK5h3NEhQw4kEFxTVcwMoQqh2Al5CtlgOHXHXeZgcBqFUhhA7NdZ0tdL6bBBM7900askXA0F1SvAliO5db0ktBiKhQUL8DYRVlQwk6g40Y+uVjVTbMJmVTeEZIZsb2QfTXtMFGuTA8jd8kShYtcwqROxkN2M1OkOY7KkT/O60b/v6+q4dn6mrsffNXYyiMaPIzTxm1NbSRQX+c8MbuGPCTP4r6tqVmtPs5RQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(346002)(39830400003)(376002)(366004)(136003)(396003)(451199015)(44832011)(186003)(6512007)(6666004)(26005)(6486002)(6506007)(2616005)(316002)(54906003)(38100700002)(38350700002)(52116002)(4326008)(86362001)(83380400001)(1076003)(478600001)(36756003)(7416002)(2906002)(41300700001)(8676002)(66476007)(8936002)(5660300002)(66946007)(66556008);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?gJMaNkYtOmEQjPZCCnbIxyx8NY7fSCoZ+ia1c+9zWF5co+j60AkjkfA1UIfZ?=
 =?us-ascii?Q?sVyM+SiRDvJ7FWeAC7HNRCcv3ILz+0HI+KlOOYUP7L28ZXVU3XrdUrl0VNBx?=
 =?us-ascii?Q?9HTcZDQdPxrvwOK81UyPC202P4dnoIf1QCDfab+PpXTEnihcxFZxzUc8bk8+?=
 =?us-ascii?Q?qb8TsUBZUPWs/xrJz2yFGAMXR+0Lpif3AfrZ5FFtONEMtbznifK7ANXzPFiz?=
 =?us-ascii?Q?Aaf30A5IweFfo/GpGgM1yfjW/5yHD8mSlcZ/nzoj0azthVYg2Q+cyPfS+lP2?=
 =?us-ascii?Q?TB+qq6ty1HqoXEZNSSly0G/JS5NQ8BGbonSFjEkiXoDiP7TOBFPU6XwCytfM?=
 =?us-ascii?Q?/PNhLd+gund+OxTuQqc9Mc3pq/CNByRk1eULMdfJZ0v/HU3XaNauVqUn1HYa?=
 =?us-ascii?Q?uaxtSPlR9tTvZ0gvK1rcdgcHT3K6rq33c0egcK/SykBNLxkp7paq3XBmVmGE?=
 =?us-ascii?Q?v84shAfh8gp06fbZO7u3s83mY3GaYnX7R7ZFYuUOAkQbqrNl+4eUP0nYyixP?=
 =?us-ascii?Q?E8azzYmSNFeS0nCMklZkYqyjYwZHXA05bb31ugRcxK/p3G7d7VJAbg/AN1vh?=
 =?us-ascii?Q?6txfuipLi9ed+oR3inKqmoWFv2ide/mllncgtJw/pCwdNejGN+DMF8lkR/uh?=
 =?us-ascii?Q?34DRnjN0eENtBCXVjInJD0oY0TyRNv8GmSKHtwXHY4GAOa0genZGHXUSw3JN?=
 =?us-ascii?Q?HAuNh93j//6ktKZvi8UEvzcfUFsZUynTw8tLOwr3uv5pjqf10WpxaqVpeUNp?=
 =?us-ascii?Q?ErpnVDMNGw8Xu4Yyl0NFdMFYI5bpfJFah8Qm6pzByOTK+HOk8VBIxL0Lp9/b?=
 =?us-ascii?Q?F/kMWCIPgkzk/Fd2DCmP4wGqIGfVb7d5TBWfUFAyszyEnbNMY9b1wLVJv9jn?=
 =?us-ascii?Q?h8GsN3YfXO1pTB0sf80kNJs2gtQh9pziaYS0/e/XBbYycM9OA9YNp58PiYGF?=
 =?us-ascii?Q?GXn+ZClgURaNFhv6D0W3DOOaomFbrymILyfuorqc73oGdHIGPuXi58mwI84b?=
 =?us-ascii?Q?7eALXxkEdkoRvw1z/1WzUk1vpubjeIxQoHFFqgUHPnfN+87KVao8adkFnbNs?=
 =?us-ascii?Q?MHX2TizmyMqIkA9IdYnpsrCtLwD7N5ki2E627DtFqPVNanNyMzg/HR3drfh+?=
 =?us-ascii?Q?UiMqs+/a5InZXmVtfOzwfiDblikPw5VtNkcc7MYNGQpKLRThX/14Ovd+i31o?=
 =?us-ascii?Q?b5Vdg2MpPghVODVf3CzW06oyaClFyEfoQtzNazNPx1iQc1c+olcvIceLc5Ne?=
 =?us-ascii?Q?JqAw+1G/UrOo/VZiNs5UGYf0qZHnzDdbg01K2RMQH6nbIukgKmueO8upAO4H?=
 =?us-ascii?Q?9QEXOLXYK8ZCoVbhwvXa13F+HfeEmUSeHqBlM09uJfD7YSy1+4DIiRlN7DXp?=
 =?us-ascii?Q?otTSDgzAnu/54N+kxdQ+PRVLnNNH135rzaXexlasHblBy3GO9E5LTKoZ0Odg?=
 =?us-ascii?Q?+W/Fd895mjEaHAA+bzymAT+Yndb+oTvZcHNtz6jykQ0XPFqQAsTRAOmfmK4G?=
 =?us-ascii?Q?ABoScfl7xEVPaTNOx633+lc7iJA4VGXXdmTFzpzdaWbGhjlSsTpUeXeiSuje?=
 =?us-ascii?Q?uXlIBnaNAIQshpmegebewsbnq/idY7dzcSLqMAu3OuTrORDcbBzQzKqggA3o?=
 =?us-ascii?Q?RSg9A7C1O4kisG+s+YUJNaA=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c9fb9a7c-2a02-4cd1-5b21-08daa95e3336
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Oct 2022 18:52:07.9129
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: h0Rm1lWymZVujPG6i0ILLMsSYz6uRDT5S9mY08z6N7piTbwYysUUzZXKuVrf1dl6jGPIFLqEVTAG06KG9D1+md1QjcMDI5eseruR1KVANTs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB6129
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

phylink_generic_validate() requires that mac_capabilities is correctly
populated. While no existing felix drivers have used
phylink_generic_validate(), the ocelot_ext.c driver will. Populate this
element so the use of existing functions is possible.

Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
---

v3-v4
    * No change

v2
    * Updated commit message to indicate "no existing felix drivers"
      instead of "no existing drivers"

v1 from previous RFC:
    * New patch

---
 drivers/net/dsa/ocelot/felix.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/dsa/ocelot/felix.c b/drivers/net/dsa/ocelot/felix.c
index d56f6f67f648..1d938675bd3a 100644
--- a/drivers/net/dsa/ocelot/felix.c
+++ b/drivers/net/dsa/ocelot/felix.c
@@ -1050,6 +1050,9 @@ static void felix_phylink_get_caps(struct dsa_switch *ds, int port,
 
 	__set_bit(ocelot->ports[port]->phy_mode,
 		  config->supported_interfaces);
+
+	config->mac_capabilities = MAC_SYM_PAUSE | MAC_ASYM_PAUSE | MAC_10 |
+				   MAC_100 | MAC_1000FD | MAC_2500FD;
 }
 
 static void felix_phylink_validate(struct dsa_switch *ds, int port,
-- 
2.25.1

