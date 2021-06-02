Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A010A39891F
	for <lists+netdev@lfdr.de>; Wed,  2 Jun 2021 14:13:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229854AbhFBMO7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Jun 2021 08:14:59 -0400
Received: from mail-eopbgr150052.outbound.protection.outlook.com ([40.107.15.52]:28734
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229823AbhFBMOz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 2 Jun 2021 08:14:55 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MyfZClarUthzildFAnubyiW2afZfd4IHrZNwxQfpJwpX4hhoE8zzzeGmau5IBZ+s3EH5N8seyHc7wtIql0hBGB95e8N2BOMMBWnmClBw15M3DZeFZ2yUhd/ltfCOwf9rF57bQ503CgSyf428sBt55JaIzXESoqGSo7zvPhyzaZw/lEg2WvqEiAMVMubPm7w66maHaH/Wxkfz7JgY/RC85JO9HMacSI5IodlI/QiHi2ycZBSkm0Bf0nPGMZPDJ5eNs8YmTTe0AiIWqkk8GOvOnw72SmJvwX/DHn1szUBBBVEJu0/3NfLRy0y6/GddUfnzeeXILZdCnkcKQI7/D5xC9w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=T+Ru75bR9z+ApdazjQlZA/llUMNktPizvHr7DfmOY0I=;
 b=cQn3nGldCrCs5WPCG0MFqnp/N4QqezfGvRKBUOVjg3FNmle2ME2/u0q0CefTWuxXR7vhaiYl57GJojIUTc/TzXhHX9Z9/PrLFg+QSu28M8PJFyZaGQy4vJeI0jNZ2sKwUFOyY47iGxFFBRaGq6/ATKQn43CRSqgLUKuYjlsgifyP7nqtIe3okuLi7iNPmqLCaHzFst3Ey9gl86J6cNTD6cRDBDxMrpkVKYpj0R3CGLZDAc+dFE/7ksfXZGqcJfxrmkSIGj5KoNbMn0shBiEQt3m2Q5GL7M87yZchYm/7YEVh9gMLOiyE3z6zw7Itcuk17Pcn/4bhC5BVOaVDnetZAg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=T+Ru75bR9z+ApdazjQlZA/llUMNktPizvHr7DfmOY0I=;
 b=FXWLp82p2jssknErZhqpiAGcnk3IOAU2sK0mb9H3DiIiSgzaecS3VromDNqJfiU/xAOt3YsTHVybMcPcbiZMV5ge2n/v+LAtI98IWeMFYT0O8pXzegVOIAysPt01KsegI5jIPxO38R2mvFnvaE8ZDmmcdDY+1qrIxnFQkrBFUtc=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=nxp.com;
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com (2603:10a6:10:fa::15)
 by DB6PR04MB3208.eurprd04.prod.outlook.com (2603:10a6:6:3::11) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4173.24; Wed, 2 Jun 2021 12:13:09 +0000
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::3400:b139:f681:c8cf]) by DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::3400:b139:f681:c8cf%9]) with mapi id 15.20.4173.030; Wed, 2 Jun 2021
 12:13:09 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     davem@davemloft.net, kuba@kernel.org, peppe.cavallaro@st.com,
        alexandre.torgue@foss.st.com, joabreu@synopsys.com,
        mcoquelin.stm32@gmail.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-imx@nxp.com
Subject: [PATCH net 2/3] net: stmmac: avoid kernel panic in tc_setup_taprio()
Date:   Wed,  2 Jun 2021 20:12:37 +0800
Message-Id: <20210602121238.12693-3-qiangqing.zhang@nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210602121238.12693-1-qiangqing.zhang@nxp.com>
References: <20210602121238.12693-1-qiangqing.zhang@nxp.com>
Content-Type: text/plain
X-Originating-IP: [119.31.174.71]
X-ClientProxiedBy: SG2PR02CA0119.apcprd02.prod.outlook.com
 (2603:1096:4:92::35) To DB8PR04MB6795.eurprd04.prod.outlook.com
 (2603:10a6:10:fa::15)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (119.31.174.71) by SG2PR02CA0119.apcprd02.prod.outlook.com (2603:1096:4:92::35) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.20 via Frontend Transport; Wed, 2 Jun 2021 12:13:05 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b5de2588-ba01-4c08-1304-08d925bfc8ce
X-MS-TrafficTypeDiagnostic: DB6PR04MB3208:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DB6PR04MB320889016CEC590D59D0925EE63D9@DB6PR04MB3208.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1079;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: TC7K5TI8hoJ/r5LHGLbLYz2Pgov5M/N5BYrwypzUQbj5Q9Shuk7ICQp0DwAyUOUGGuJUCK2FnsCQuSChaBso9o7Z76Tn2h6sfJp9Id+tp0YapYa+otgVCSaqo95GZD2uVwDqcHA/urndzjHh3uEnhiIoTCYu/uXOVK3ZNI8K21u1u2CQaBonfa+xt/vn2JPA0f/bzsWNAmQtPRy5AVtAao5dt9CYfIVLwjlHunWi7qC7VBxp6tVrB9CoeARhG9uSE0Taf0Qvj3dJD3tQbQHTEN7yUTFW2zI8E/PgHLj/ngzeJfvFWhoXKxzgOb4UGVHGvNpsgUsHTVPwqt33x/8BhVsPH07RJj0Cr65XFqkgbzH6RGrRPEdRkqz5k2V5jtlUHHIjEiTO+oBzSIW1pPNBbbTDHmnyMNchMgcSEROOUCn1f9XMzWX78Ccas1UCIjuX7lmQln+LzvUEaeqwZwwdqPNWOXlK+RvEYerjg/iLkebGNvOwx8izXKcz9xRbuOw/qAPC/iOfFgaAO2BFFB19Q/DITKEZ/hYg0h7zvCK2K14vA2sKnqkVIjHoSNHgp95CWjl3Bx4w2LFkh6UTkWuwCNwu7SoB7GOuowp+QJHvTKHkXwS7R6deMVUAWKrSB52ndYDVMY90nU+9wHV5JZX6oahFCJB1QUbb+WOPNWP3aN1PT9DzMZLFw1/E9WJwquqc
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR04MB6795.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(366004)(136003)(346002)(396003)(376002)(66556008)(5660300002)(66476007)(4326008)(2616005)(66946007)(16526019)(38350700002)(956004)(8676002)(36756003)(316002)(26005)(1076003)(83380400001)(478600001)(6512007)(6666004)(8936002)(6506007)(186003)(45080400002)(38100700002)(52116002)(2906002)(86362001)(7416002)(6486002)(69590400013);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?TRUv49Wf+0qXBEJqEe4yYb1NhK5Cls1MLyU9Xz/QPnaPwWARncO4DpaZGTYQ?=
 =?us-ascii?Q?eg/s4MqPXbdNVb1XZUmgB8S4N0OpSatdf0H/vEuwYQNaaxnuM+2O2H7xkhGn?=
 =?us-ascii?Q?PWzYJDadHbrWoehzj1QdtVU6XdJP0aSEcSPUtFvqmne4RDsF4E8pizmoAbsh?=
 =?us-ascii?Q?JQ1nBMIcRgtbXTpJSUdhccQRA9m0coa76aSHasvs5YxAaG0/ryRAknG+KnRT?=
 =?us-ascii?Q?7euE+7RAh7jSoJQTUYfc+ReQbqrId4CNO2dXEmQbDC/LVKhz5W6+Mu7+WMjZ?=
 =?us-ascii?Q?nGYURglry4YsBkoRbZwjaNezEHEvjz3kD1RVjIQSi7WimmY1y2X3dZLs6H0i?=
 =?us-ascii?Q?3NT4WPAn0GSI5SL6CTwWZ0ttsLCBWudMG0gnPbfL7dmDR9K/woYYANOXji/4?=
 =?us-ascii?Q?7LiBhP7u83e+Lk9tojGdk/LTy7D7EZKqDPNgbvh89ESMJcHuc3sxEsXft+fv?=
 =?us-ascii?Q?xmYUDPNlj6pyQk6UeL8ZMPiCnNjfg4iPcjHHn7RLZ5rm1A6hk5yxMmP4cur5?=
 =?us-ascii?Q?aURY+sR739nMgxjSFG6rHq6fhF17qFfLmpa+/BJ6+xlc8nNFjy+QDim5DQL3?=
 =?us-ascii?Q?I0wE7kDSUVYKJjgZ7I9iPhes9H0KmGsYYoG0hNNWqZX+zQ5uWoBcvlnHx9/6?=
 =?us-ascii?Q?UfCYuW7C5yxylfJAnpeyjKJ8L8O14HYNB+D/wMI/p+Tr5SlG4zvc2cAy9LDW?=
 =?us-ascii?Q?z0ZWK6mKZu5bUt6WRX5HJ/jI6mo6E+l4j8MRA7jrjOD3YpOiKnt7YMFK8WuQ?=
 =?us-ascii?Q?Rs580bsPC80WNtpHPkbK0cf4rRSp+0svN5Vud3dOIhWxEvpQPBOG2rIUQwxX?=
 =?us-ascii?Q?AKEO1zZW1R+ZLFqZBwuqIVMT0aQArB/R5KH7m9thDItw4TmbH3odAz3wF0Al?=
 =?us-ascii?Q?p+j7nWPXXHeb7UgwCbd8PfFj4qnXNJLc988tN0m+pX1DM8WfJpc6x+FbUIcI?=
 =?us-ascii?Q?uLoKyywXy4WEQX4xrU4MaeBs+9h/Zpyx1uwzXFQR6VnJHDPoFlBS+kc+W082?=
 =?us-ascii?Q?bAKXOz2b/BIAGRqt+k7DJ1SZw5rWksk8+YF7PrAM6dJK71s2g5rwqTW7vDFv?=
 =?us-ascii?Q?rTNMtniEwCdVHQ6I8zWFTtqiTw1Sl0JxVl0xnnoEpOIrChjx7/ErQSc770BH?=
 =?us-ascii?Q?i3CDPOq0Ucdx6H8eB8iuStTqGAfF23lLn5kBhAnw6pOU8W8obptTfb99ivaA?=
 =?us-ascii?Q?3ScGJmiepE1Oam9wQIl2VzyxjgpAVutKu2DkwpPkPB6dAeju+dMi6i+fzvIA?=
 =?us-ascii?Q?VugoRzGrsuAj7aJmAn8DxUNszCtnmyoAnnz0X+ip44O6EbqukJf/F2HZCU+f?=
 =?us-ascii?Q?WNENgh/lLEsd6Q9u95AOoYcx?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b5de2588-ba01-4c08-1304-08d925bfc8ce
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6795.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jun 2021 12:13:09.0781
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zkg1MrYXVws7YzwpEYQAFLR8GsgSDvfdDVBLxfpYcnpCNbINKh/Lz2ykVjhhtSbXtsOWRiVH5mZ4ETE+TSt9FA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR04MB3208
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use linux tc command to setup the taprio with hardware offload enabled,
in some circumstances when taprio parameter error causing the taprio_init
failure in qdisc_create(), then cause taprio_destroy() which call
tc_setup_taprio() in the stmmac_tc.c and panic on the un-allocated
est structure as below.

[ 15.417444] 003: Unable to handle kernel NULL pointer dereference at virtual address 0000000000000000
[ 15.417455] 003: Mem abort info:
[ 15.417457] 003: ESR = 0x96000044
[ 15.417460] 003: EC = 0x25: DABT (current EL), IL = 32 bits
[ 15.417464] 003: SET = 0, FnV = 0
[ 15.417467] 003: EA = 0, S1PTW = 0
[ 15.417469] 003: Data abort info:
[ 15.417471] 003: ISV = 0, ISS = 0x00000044
[ 15.417474] 003: CM = 0, WnR = 1
[ 15.417487] 003: Internal
[ 15.417476] 003: user pgtable: 4k pages, 48-bit VAs, pgdp=00000001b71c4000 error: Oops: 96000044 [#1] PREEMPT SMP
[ 15.417482] 003: [0000000000000000] pgd=0000000000000000
[ 15.417487] 003: Internal error: Oops: 96000044 [#1] PREEMPT SMP
[ 15.417492] 003: Modules linked in:
[ 15.417494] 003: CPU: 3 PID: 836 Comm: tc Not tainted 5.4.24-rt15-00033-gdb22403-dirty #3
[ 15.417499] 003: Hardware name: NXP i.MX8MPlus EVK board (DT)
[ 15.417501] 003: pstate: 80000005 (Nzcv daif -PAN -UAO)
[ 15.417504] 003: pc : tc_setup_taprio+0x1b8/0x390
[ 15.417514] 003: lr : stmmac_setup_tc+0xa0/0x3b4
[ 15.417519] 003: sp : ffff8000126c3760
[ 15.417521] 003: x29: ffff8000126c3760 x28: ffff000177712400
[ 15.417526] 003: x27: ffff000176e4b000 x26: ffff8000126c392c
[ 15.417530] 003: x25: 00000000ffffffff x24: ffff800011f903b0
[ 15.417534] 003: x23: ffff8000126c3a80 x22: 0000000000000018
[ 15.417537] 003: x21: ffff000177040080 x20: 0000000000000000
[ 15.417541] 003: x19: ffff000177044840 x18: 0000000000000000
[ 15.417544] 003: x17: 0000000000000000 x16: 0000000000000000
[ 15.417547] 003: x15: 0000000000000000 x14: 000186a000040008
[ 15.417551] 003: x13: ffff8000114db3d8 x12: 0000000000000020
[ 15.417554] 003: x11: 0000000000000030 x10: 0000000000000000
[ 15.417558] 003: x9 : 0000000000000000 x8 : ffff00017088ee00
[ 15.417563] 003: x7 : 0000000000000000 x6 : 000000000000003f
[ 15.417566] 003: x5 : 0000000000000040 x4 : 0000000000000000
[ 15.417570] 003: x3 : ffff800010b94d74 x2 : 0000000000000001
[ 15.417573] 003: x1 : 0000000000000000 x0 : 0000000000000000
[ 15.417576] 003: Call trace:
[ 15.417578] 003: tc_setup_taprio+0x1b8/0x390
[ 15.417581] 003: stmmac_setup_tc+0xa0/0x3b4
[ 15.417585] 003: taprio_disable_offload.isra.30+0x78/0xe8
[ 15.417590] 003: taprio_destroy+0x80/0x11c
[ 15.417592] 003: qdisc_create+0x408/0x4c8
[ 15.417597] 003: tc_modify_qdisc+0x1e0/0x688
[ 15.417600] 003: rtnetlink_rcv_msg+0x120/0x330
[ 15.417603] 003: netlink_rcv_skb+0xec/0x12c
[ 15.417607] 003: rtnetlink_rcv+0x28/0x34
[ 15.417609] 003: netlink_unicast+0x18c/0x21c
[ 15.417612] 003: netlink_sendmsg+0x27c/0x360
[ 15.417616] 003: ____sys_sendmsg+0x284/0x2b4
[ 15.417620] 003: ___sys_sendmsg+0x90/0xd0
[ 15.417623] 003: __sys_sendmsg+0x78/0xd0
[ 15.417626] 003: __arm64_sys_sendmsg+0x2c/0x38
[ 15.417629] 003: el0_svc_common.constprop.2+0xd8/0x178
[ 15.417633] 003: el0_svc_handler+0x34/0x9c
[ 15.417635] 003: el0_svc+0x8/0xc

Fixes: b60189e0392f ("net: stmmac: Integrate EST with TAPRIO scheduler API")
Signed-off-by: Joakim Zhang <qiangqing.zhang@nxp.com>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_tc.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_tc.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_tc.c
index 4e70efc45458..dbd1320c2597 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_tc.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_tc.c
@@ -862,9 +862,11 @@ static int tc_setup_taprio(struct stmmac_priv *priv,
 	return 0;
 
 disable:
-	priv->plat->est->enable = false;
-	stmmac_est_configure(priv, priv->ioaddr, priv->plat->est,
-			     priv->plat->clk_ptp_rate);
+	if (priv->plat->est) {
+		priv->plat->est->enable = false;
+		stmmac_est_configure(priv, priv->ioaddr, priv->plat->est,
+				     priv->plat->clk_ptp_rate);
+	}
 
 	priv->plat->fpe_cfg->enable = false;
 	stmmac_fpe_configure(priv, priv->ioaddr,
-- 
2.17.1

