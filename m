Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 90AEF365A2B
	for <lists+netdev@lfdr.de>; Tue, 20 Apr 2021 15:33:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232558AbhDTNcu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Apr 2021 09:32:50 -0400
Received: from mail-eopbgr70098.outbound.protection.outlook.com ([40.107.7.98]:43782
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231422AbhDTNct (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 20 Apr 2021 09:32:49 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iIeyjMFATCmLEDRi/sIwTjeeq6cxUrt4oZIBDZQe6NtTDcVQJRu9mnzBmkQwf/HmVbRQDJk0ThiLqaUPooupcRIHsCbgVeYzm52DdxGDPt2sfUr8LjZ7yBEO+guNBUOTim09IdkcE4nmb1HgV5oa1Qz7HS9SGbzvSzrtPrNnCA8dVDFqfUI9Id93RXTkIrqwDPdrmwW0O11dCf1zczH7ZYE0SVo1/Ac1JcrFv0Z5dEtK820KdTIKLrOLIaYnD/GQlsvTYlumSemDRBl4xGoEk/XZ13SZVNx95lza22REMrGKVrcfPfcO0WTGbPUi4cU0mK7gk40zkpdtpDSRAizE7A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BiX6iY1yZyfBo6SiTv1bREWbo5SagvGMjZD7ylXlANQ=;
 b=ktuXqEavxk3Lxv0YKp2BqzplFrs5H5UtCE1B2Zv3pCqnxQtuTLe1n2HZA99p64ApQ7UVnyAsNXXcGAf8LB2ZJlcqp4GafYMiBS1ygjXC8+oiWMncC/p0vx+eKdWVE1MQGTMUSfHpEjtnlsb6RHjsqZLUC6fGFhfyxcW1zOEoJmtFMsrL4vAqefmgx+BqdPXK/R+6DIVwMd53ZT2KX85Y/LW9SGvHG07vFC+StrqQ5GanDSu1ZXtC5pP0A7fXRE846xssuUqLGHXcBRqdpd/VblkGTjuDl3VALYJpvgYxOrmBB34biYXNTV4DjjMMSSUSqvNN103KG61IQozDqeOCFQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=plvision.eu; dmarc=pass action=none header.from=plvision.eu;
 dkim=pass header.d=plvision.eu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=plvision.eu;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BiX6iY1yZyfBo6SiTv1bREWbo5SagvGMjZD7ylXlANQ=;
 b=GDMobYTPLtSg79S2wrBUWOGIR5EwueeM0NkKngOyPvW7iVZRB4WC7yxL3d0L43ycPLDNGLvpHN6nUhGQrKBQkBWTu2nLGjl02ZAommPsHsmfZ292wxE4b12FLxxMkGFNpz4gyWbShm86T9+FnbtS1/oBA36GyNKxRUGe+xZRxv0=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=plvision.eu;
Received: from HE1P190MB0539.EURP190.PROD.OUTLOOK.COM (2603:10a6:7:56::28) by
 HE1P190MB0122.EURP190.PROD.OUTLOOK.COM (2603:10a6:3:ca::19) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4042.23; Tue, 20 Apr 2021 13:32:13 +0000
Received: from HE1P190MB0539.EURP190.PROD.OUTLOOK.COM
 ([fe80::a03e:2330:7686:125c]) by HE1P190MB0539.EURP190.PROD.OUTLOOK.COM
 ([fe80::a03e:2330:7686:125c%7]) with mapi id 15.20.4065.020; Tue, 20 Apr 2021
 13:32:13 +0000
From:   Vadym Kochan <vadym.kochan@plvision.eu>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     Vadym Kochan <vadym.kochan@plvision.eu>,
        Taras Chornyi <tchornyi@marvell.com>,
        linux-kernel@vger.kernel.org,
        Mickey Rachamim <mickeyr@marvell.com>,
        Vadym Kochan <vkochan@marvell.com>
Subject: [PATCH net] net: marvell: prestera: fix port event handling on init
Date:   Tue, 20 Apr 2021 16:31:51 +0300
Message-Id: <20210420133151.28472-1-vadym.kochan@plvision.eu>
X-Mailer: git-send-email 2.17.1
Content-Type: text/plain
X-Originating-IP: [217.20.186.93]
X-ClientProxiedBy: AM5PR0101CA0033.eurprd01.prod.exchangelabs.com
 (2603:10a6:206:16::46) To HE1P190MB0539.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:7:56::28)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from pc60716vkochan.x.ow.s (217.20.186.93) by AM5PR0101CA0033.eurprd01.prod.exchangelabs.com (2603:10a6:206:16::46) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.16 via Frontend Transport; Tue, 20 Apr 2021 13:32:12 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 069dd3ea-4f4a-4119-26ac-08d90400b4fa
X-MS-TrafficTypeDiagnostic: HE1P190MB0122:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <HE1P190MB01221883D31FFB7569EFC45995489@HE1P190MB0122.EURP190.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: b6Kpvb4JFyzbIx4z9FgUdC7sx1aH5qSa1QbfduZRE8AvooNuVLDrutg4B6DrH+LPoLAvP32zm5cs6TmmVhg0EGJqJ+KRMVe43k3nAlXgfqxa3I4Te8h69J3gaYrhDZgQPcFgtZ3uB0nuGyxXJnG61lXeWbUsl3MV3dpkxwLgY4DqcArb1eh9vVeUDBiWy0DjMIgyT6VFCIk1G4dWCjZAgqFxuqamwgNhck/eEXaJMUUNQwBKNNzvCz1bQcLZaBMgkE+ONvYM7OEwBe4wIX19C6Gl7fcoAKRXIxZhETHmxRJuuVDMM0f634sHsISVwOBlyvhQQzKnunyeEjXQ+YsN8EjG4HTYj0SDDzp1nTF/ivZtLI7DBi+vhqgYKRkoRqYP1IaGwK2nUobF0cb+yeuUg+ajGz6I6gewge931nGx0/FtwDYZzM5uIBIQGQJRx9WBKCAAHuDX75RWCFWu6Uq/n6y+SzU9Aes1FXQjv5KG5nDKotTc1nfoN0D9NlgcMXgV9M/gtwHCWWAw06OKZXGrCSfIZDP3sa2tPLMDxS5yiMT+cV6P+feHSbVYD7gn4c1NWoRCpTIxEQK99kmgdpVgBmow6nUbiT2Bnst3rRIzpaBzXyODLOS00kOZ6HaCHromZ/hPTZPmLB/Ys+PjyVcNJQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HE1P190MB0539.EURP190.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(346002)(366004)(186003)(4326008)(8936002)(66556008)(26005)(8676002)(6666004)(44832011)(16526019)(66476007)(66946007)(2616005)(36756003)(5660300002)(110136005)(2906002)(54906003)(956004)(83380400001)(86362001)(38350700002)(52116002)(38100700002)(6506007)(6512007)(508600001)(45080400002)(6486002)(1076003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?vEaDZvlNzJ+Z1NTRU9McqdaqzdAICMnXP9LSpkevmulBf0CXvpAQGr9Lon8/?=
 =?us-ascii?Q?e1toIhxSAIc4DqLoMv8fY4YBb5f9G3lK8t/ZzWzRPnV6afNat/i4fJGK2tXP?=
 =?us-ascii?Q?mS9DouF9w0xuuw8lf/gHdjLq58PmFP9UdwVksVaOb7jXy9R4eMylJkyxRf9H?=
 =?us-ascii?Q?X715HPN4OOhuh40IEBx8FfqZ8iDB9JjYtT59w1DtEDCrH+FHqJb9ymz8qN4x?=
 =?us-ascii?Q?D4v50HzsSp8TqQX6eNR3KNdMojWPbp3iaM7xJrbRL//rLXcQ/aAepHeeK0mS?=
 =?us-ascii?Q?uUCgPC8qAuWidr8UlEJ258AfWjnhJ1g9NSega6DjFyvRVGQbbv38oTqn/WOb?=
 =?us-ascii?Q?dTWBwFPKP2S8UiiOskzHRyco4soRpExcqvUEb17EQGZt7lRPDftuNlkLZyhs?=
 =?us-ascii?Q?PdlMAvWttQCEftOHEv5lrFUadtCCABibAQZswEuVejq00oCFs887yqexzVqu?=
 =?us-ascii?Q?iKtDTdZJ+38vpCmVqJn0vfkZcK9IYnmWToCjT++hqX5S0SAO+OYDnq/H58Ys?=
 =?us-ascii?Q?COpj+Vq7bgBs1JLTY+ruVAc3erHkq3M2gdS9W5d4APpL8q6Jrc/3JToF99LA?=
 =?us-ascii?Q?XpzpCuZKJv2psKi++OG1MIEFvaWOyMivZftz4y8Y8mOrrnQVhWBKVr41bKM5?=
 =?us-ascii?Q?zcS5z+k5zlWeHO/fBei+52lIIEy+buQs2S0g9qyqPPX3uW/N9c1r1nT/jf8T?=
 =?us-ascii?Q?0Lv5ecTVc6RIFs2+HWUky/JIGLYfdMPcvkD1e5piIPuoHWF+bB/MfM0QCfBN?=
 =?us-ascii?Q?uSLwJCYU3kamYVFbO0glKNUiAMLPMsNG1n3qNhOUCoptaCebHIgEhOSYjoe/?=
 =?us-ascii?Q?KgpGWQdzlZatHSzPZPDuR8+6ubwa4viSw1Xjf1JgVJ/D3Cmmac6xf5aXPR8O?=
 =?us-ascii?Q?zQrBRWzFI/l3GeMfibVABRDTx/UYTpDOthSEc6I/k+ZOPbI/65AZNO52YW0M?=
 =?us-ascii?Q?wpgWN2EeuBbVhaYRB/IHq4jDuaekl4iQw/3lExj4dm4jFDo0th4iezkmmQqp?=
 =?us-ascii?Q?4UfPrMDs1wzkmKHryK5YSkr+uNJ/xM1o1yTX/uxgT9jFXhHrGdTE0SVkPml5?=
 =?us-ascii?Q?sCjAioJU6gSlqjYLrRMVlnEb5jEL2sU2X0acrc4oRihDNFYL8LPchauMr8jl?=
 =?us-ascii?Q?u8JBUg2O6GbP59tWeHHoBWPWsJmqwJsBumzoS3CAIhrGs7WtoFW46OiGXwkM?=
 =?us-ascii?Q?LzlI5H4kkv+3l4ROYTF6VdY3vrNlfAQjEX8K0lSmXM62n0CnPOLJvFn3Gb5u?=
 =?us-ascii?Q?r0sJZPhTpvwoNxYGK5lkaspDpUyJsclSCABTOiAB1KClQBIgJ3965H9aW69Z?=
 =?us-ascii?Q?OxfWDC5zJDMStqs+BjQOMomC?=
X-OriginatorOrg: plvision.eu
X-MS-Exchange-CrossTenant-Network-Message-Id: 069dd3ea-4f4a-4119-26ac-08d90400b4fa
X-MS-Exchange-CrossTenant-AuthSource: HE1P190MB0539.EURP190.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Apr 2021 13:32:13.7107
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 03707b74-30f3-46b6-a0e0-ff0a7438c9c4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vMX88MFOcHHDaKV+gB3PhGSgiKWTTnJVPL9o1cTlufQfQXazMyS7dW3Ynwu983diKGe25Zwqmwi8AwgSy5yrDi1weIyxnGRGME+vFi2IeC8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1P190MB0122
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vadym Kochan <vkochan@marvell.com>

For some reason there might be a crash during ports creation if port
events are handling at the same time  because fw may send initial
port event with down state.

The crash points to cancel_delayed_work() which is called when port went
is down.  Currently I did not find out the real cause of the issue, so
fixed it by cancel port stats work only if previous port's state was up
& runnig.

The following is the crash which can be triggered:

[   28.311104] Unable to handle kernel paging request at virtual address
000071775f776600
[   28.319097] Mem abort info:
[   28.321914]   ESR = 0x96000004
[   28.324996]   EC = 0x25: DABT (current EL), IL = 32 bits
[   28.330350]   SET = 0, FnV = 0
[   28.333430]   EA = 0, S1PTW = 0
[   28.336597] Data abort info:
[   28.339499]   ISV = 0, ISS = 0x00000004
[   28.343362]   CM = 0, WnR = 0
[   28.346354] user pgtable: 4k pages, 48-bit VAs, pgdp=0000000100bf7000
[   28.352842] [000071775f776600] pgd=0000000000000000,
p4d=0000000000000000
[   28.359695] Internal error: Oops: 96000004 [#1] PREEMPT SMP
[   28.365310] Modules linked in: prestera_pci(+) prestera
uio_pdrv_genirq
[   28.372005] CPU: 0 PID: 1291 Comm: kworker/0:1H Not tainted
5.11.0-rc4 #1
[   28.378846] Hardware name: DNI AmazonGo1 A7040 board (DT)
[   28.384283] Workqueue: prestera_fw_wq prestera_fw_evt_work_fn
[prestera_pci]
[   28.391413] pstate: 60000085 (nZCv daIf -PAN -UAO -TCO BTYPE=--)
[   28.397468] pc : get_work_pool+0x48/0x60
[   28.401442] lr : try_to_grab_pending+0x6c/0x1b0
[   28.406018] sp : ffff80001391bc60
[   28.409358] x29: ffff80001391bc60 x28: 0000000000000000
[   28.414725] x27: ffff000104fc8b40 x26: ffff80001127de88
[   28.420089] x25: 0000000000000000 x24: ffff000106119760
[   28.425452] x23: ffff00010775dd60 x22: ffff00010567e000
[   28.430814] x21: 0000000000000000 x20: ffff80001391bcb0
[   28.436175] x19: ffff00010775deb8 x18: 00000000000000c0
[   28.441537] x17: 0000000000000000 x16: 000000008d9b0e88
[   28.446898] x15: 0000000000000001 x14: 00000000000002ba
[   28.452261] x13: 80a3002c00000002 x12: 00000000000005f4
[   28.457622] x11: 0000000000000030 x10: 000000000000000c
[   28.462985] x9 : 000000000000000c x8 : 0000000000000030
[   28.468346] x7 : ffff800014400000 x6 : ffff000106119758
[   28.473708] x5 : 0000000000000003 x4 : ffff00010775dc60
[   28.479068] x3 : 0000000000000000 x2 : 0000000000000060
[   28.484429] x1 : 000071775f776600 x0 : ffff00010775deb8
[   28.489791] Call trace:
[   28.492259]  get_work_pool+0x48/0x60
[   28.495874]  cancel_delayed_work+0x38/0xb0
[   28.500011]  prestera_port_handle_event+0x90/0xa0 [prestera]
[   28.505743]  prestera_evt_recv+0x98/0xe0 [prestera]
[   28.510683]  prestera_fw_evt_work_fn+0x180/0x228 [prestera_pci]
[   28.516660]  process_one_work+0x1e8/0x360
[   28.520710]  worker_thread+0x44/0x480
[   28.524412]  kthread+0x154/0x160
[   28.527670]  ret_from_fork+0x10/0x38
[   28.531290] Code: a8c17bfd d50323bf d65f03c0 9278dc21 (f9400020)
[   28.537429] ---[ end trace 5eced933df3a080b ]---

Fixes: 501ef3066c89 ("net: marvell: prestera: Add driver for Prestera family ASIC devices")
Signed-off-by: Vadym Kochan <vkochan@marvell.com>
---
 drivers/net/ethernet/marvell/prestera/prestera_main.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/marvell/prestera/prestera_main.c b/drivers/net/ethernet/marvell/prestera/prestera_main.c
index 25dd903a3e92..d849b0f65de2 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera_main.c
+++ b/drivers/net/ethernet/marvell/prestera/prestera_main.c
@@ -431,7 +431,8 @@ static void prestera_port_handle_event(struct prestera_switch *sw,
 			netif_carrier_on(port->dev);
 			if (!delayed_work_pending(caching_dw))
 				queue_delayed_work(prestera_wq, caching_dw, 0);
-		} else {
+		} else if (netif_running(port->dev) &&
+			   netif_carrier_ok(port->dev)) {
 			netif_carrier_off(port->dev);
 			if (delayed_work_pending(caching_dw))
 				cancel_delayed_work(caching_dw);
-- 
2.17.1

