Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3E0235F1B67
	for <lists+netdev@lfdr.de>; Sat,  1 Oct 2022 11:35:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229768AbiJAJfY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 1 Oct 2022 05:35:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229723AbiJAJey (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 1 Oct 2022 05:34:54 -0400
Received: from EUR04-DB3-obe.outbound.protection.outlook.com (mail-db3eur04hn0239.outbound.protection.outlook.com [52.100.17.239])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C702413CF1;
        Sat,  1 Oct 2022 02:34:45 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CxKUREtZLlaik7PBbxRgMiVhNToJIDIA8R9t/ZEnE91Ky37YkdETbV38ZpGPA5YQ6aaunBDsBKK5wJ3vXBbFOc+/64vRcRPvniJmR2viFMz7Kh4wLdJUCLcJ6EzMHvrx7GCZLXg647OieTU8ImToWQ9OekySVT8W8LHb68xgUFzcaN/32aNEq17VZFbMQ51vaZ27Uguf57WRn7ISVdX8p23MbAA00Dtoq8umYFZLnsmkIEWRFwVGBb5MSKCkZx8gHM1PdI5h6gMtBw9i4N5Qzz6NBec/+tQWfqQCXAYYJb8GY3qHRv5kQmdf0tP5rBKs3tSzsre09hrxUQOQWY77kw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ax4Z8QmwAQ8cwH4bLDHV692v4k+bXZnEjQJP2AR4WEY=;
 b=F3ULNaDyIgO7W3bDGXBSCZwLKyOSKSoQq9OTnwzu88KX0A1p8s3O7R6PrzrsMEKxdtcXd/IJlx70xF0QEcB5KAZnzvz+D+ahpRnQr4lV6+6+Z5D4+m69DetJp/1Cxc4WQ00+y3knaFDJL+DJNv6Hxu2S94thDlqsfMrz/Dy/xYRgLbngNQj3Jx/h9wehCYxSxdSr6d1MG8vhXvVOABsoCYyMca0FHOLSiAVAdTeIw3tvE8Zf4vatjgmdsAz5+ZfBY0E3pciCMpgpAG7o8Xa/wXE4ZSyLTMsi45CKMdrqRv1o3dpLUIAHw3bHzGh7qlcYLzEOolHQHvxX+2IOjkuF1Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=plvision.eu; dmarc=pass action=none header.from=plvision.eu;
 dkim=pass header.d=plvision.eu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=plvision.eu;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ax4Z8QmwAQ8cwH4bLDHV692v4k+bXZnEjQJP2AR4WEY=;
 b=VZucfp0n2DDQBvSkuF0o62DYIu0balgdF6kVHUsxV4xAeF3n+63zwA5I4i5vkR5BUu1tMGbGT5erV6wSl5NJ9H41X0MtaTr0Sfmn3EWzut5uGq33MD2gtOuiLLlHAa1NVo6exQYzccM+OwX0vwTNRU6z7+OiqQTUS/UX6F7AYno=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=plvision.eu;
Received: from PAXP190MB1789.EURP190.PROD.OUTLOOK.COM (2603:10a6:102:283::6)
 by VI1P190MB0733.EURP190.PROD.OUTLOOK.COM (2603:10a6:800:121::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5676.23; Sat, 1 Oct
 2022 09:34:33 +0000
Received: from PAXP190MB1789.EURP190.PROD.OUTLOOK.COM
 ([fe80::8ee:1a5c:9187:3bc0]) by PAXP190MB1789.EURP190.PROD.OUTLOOK.COM
 ([fe80::8ee:1a5c:9187:3bc0%2]) with mapi id 15.20.5676.024; Sat, 1 Oct 2022
 09:34:33 +0000
From:   Yevhen Orlov <yevhen.orlov@plvision.eu>
To:     netdev@vger.kernel.org
Cc:     Volodymyr Mytnyk <volodymyr.mytnyk@plvision.eu>,
        Taras Chornyi <taras.chornyi@plvision.eu>,
        Mickey Rachamim <mickeyr@marvell.com>,
        Serhiy Pshyk <serhiy.pshyk@plvision.eu>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Andrew Lunn <andrew@lunn.ch>,
        Stephen Hemminger <stephen@networkplumber.org>,
        linux-kernel@vger.kernel.org,
        Yevhen Orlov <yevhen.orlov@plvision.eu>,
        Taras Chornyi <tchornyi@marvell.com>,
        Oleksandr Mazur <oleksandr.mazur@plvision.eu>
Subject: [PATCH net-next v7 5/9] net: marvell: prestera: Add length macros for prestera_ip_addr
Date:   Sat,  1 Oct 2022 12:34:13 +0300
Message-Id: <20221001093417.22388-6-yevhen.orlov@plvision.eu>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20221001093417.22388-1-yevhen.orlov@plvision.eu>
References: <20221001093417.22388-1-yevhen.orlov@plvision.eu>
Content-Type: text/plain
X-ClientProxiedBy: AS9PR06CA0696.eurprd06.prod.outlook.com
 (2603:10a6:20b:49f::13) To PAXP190MB1789.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:102:283::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PAXP190MB1789:EE_|VI1P190MB0733:EE_
X-MS-Office365-Filtering-Correlation-Id: 33375581-eccf-4ff2-13e8-08daa39025e3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:5;SRV:;IPV:NLI;SFV:SPM;H:PAXP190MB1789.EURP190.PROD.OUTLOOK.COM;PTR:;CAT:OSPM;SFS:(13230022)(4636009)(376002)(396003)(39830400003)(366004)(346002)(136003)(451199015)(66574015)(38350700002)(38100700002)(5660300002)(86362001)(26005)(7416002)(8936002)(6506007)(6512007)(36756003)(8676002)(52116002)(4326008)(66946007)(66476007)(66556008)(6666004)(107886003)(41300700001)(44832011)(1076003)(186003)(6916009)(2616005)(2906002)(478600001)(316002)(6486002)(54906003)(59833002);DIR:OUT;SFP:1501;
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?YRfjN7laUYbGPJON3rKSf96YqNt9KXv7D+Uih7jvGKRf5x6qLEga5D6Z8GqU?=
 =?us-ascii?Q?G0XL/cOgwqOHv2nH+XbqgccBNF8F/ZJQs7JcjbB9DdSpLqhZ/2WjWcYBJTqb?=
 =?us-ascii?Q?OEB59Jc55uq13XEnIXMIvQ43lm4/bZ205TvDPig+7xQ59w79JAWAyadbtsXB?=
 =?us-ascii?Q?dOGPoRdAJcwcLkpFkhz86Lz7/1QS9emmlHQy2atPd/XtQBC2PQMVxh4h8DrQ?=
 =?us-ascii?Q?pN4kLEZ/EXt/UNmlyGV5H+FoKty7jb7KzolsTgVdJpMdJ9plV/+W4Hg/GCTf?=
 =?us-ascii?Q?IrGia/ZtjM97g/T8opkA8h0lkDDLyRhqOMkaAihNoAwVigrrIqWLt+R0+Uvi?=
 =?us-ascii?Q?u7cw7nPePQmSB2facC67/ZqQDqQ4iEYVcWxopbP0ViIQb07EaoAVHeqNdw8k?=
 =?us-ascii?Q?X/c2+F0Alq5TLD0SgPza2U/HKeJ3xAVuHMH2U+kN8qalpFQFxxyQ8UeCZQQ8?=
 =?us-ascii?Q?pYFqMngJloTryvZNi91MW/jC0qP/ZqMB2HooDBfONHEK35ofZD/zf/4rt0or?=
 =?us-ascii?Q?vpQ5L4loj/rcW5+DGyCmWk4gLAXbvkbRfdchzhkPkFZuAJhQ94OoDbvs+K0q?=
 =?us-ascii?Q?QBqThYee6zKrDgdG4ciOgoWd/n/ntQFKkDnhwmk8PP2gwDh7RYBijOprMi05?=
 =?us-ascii?Q?5JGwXjcrduCwYpKfKtU0tsWKeinKnwYs53MhoDz6cjcp/CWRiw1eOUC/vGSb?=
 =?us-ascii?Q?lFd3dStQbInqOiFOT8QXRDzqkFwXnfJsaYA0ISeaMPkBAEtz99+d2p8iioP1?=
 =?us-ascii?Q?3qePHGOGcIC6gxHK2/k6h/DHR7K0c7fYXxDwvDJiRoTKvvmbQ+Z0QflTg3Am?=
 =?us-ascii?Q?0CHRegskNcPjyPrWmbgg6JbycM8vOVHEysRa31npfb93nb1X5gdW/IMx6+G6?=
 =?us-ascii?Q?kMfrbQXkppcV3Yz4dRMTTrDVBrD0dUhXGIGEiuTs0kyVieQMRCbezoHQYxI2?=
 =?us-ascii?Q?rVYumdmR50YTa77YvmnHednMj7//AgJmnVvX1WrCqxfzYVuM3pejIZ9hsVqI?=
 =?us-ascii?Q?EcSEufb6KiSGruFovvgA0uYY3Wohjx5KRIqSmYXgsc4xTrWhci0N7N9wz9pQ?=
 =?us-ascii?Q?KXOrpYSmYn3ygCWhALvk8kfee4nNH1bpVGo2wXV0LgWumk5OO/+ZAwqqsUwV?=
 =?us-ascii?Q?GGoc7dBoJCie3CfyJjblbs0PhoJf0zfLYS9HpgCzTcJMgiDh3EvcKwU=3D?=
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?q88gGDC4MwmvIJRneVXsLy8RNEV1n9B4+/49zwON+mNDwP/39hKCjl1w5oe8?=
 =?us-ascii?Q?OVTLTky8WhIxqXQ9PXg1w6SAggX1BV/7/t8mYHWr0ZUKVMNzPF3f3MlH+1St?=
 =?us-ascii?Q?9WKKeeq0it/Xs80u8WB6ja6qxP2IU/SjjZihcX4G/jX1bkolVE7g5A55cG8r?=
 =?us-ascii?Q?K2Jqin2sL/8v7DHGdfNG6TeOVZRTD3a/GlOVHu0G629A7meNLL7xfVloh2Xj?=
 =?us-ascii?Q?FYD4s5kJJOX1QrzNGs9JFQ08epdPUXywnyA6nqeLRgwP2cixOaPyB99cq9sn?=
 =?us-ascii?Q?SO8e++djSTUXrIdtZx29TZ/C5H2b5krWaesUTDbXtJgc/rtexyUkbxv/zBWm?=
 =?us-ascii?Q?XpkeQ6Cpc5w13UbhVoz2/VoX4XQ7ebYYF1sfQ9VoTIv7Mwv+pjd7T5n5hcq8?=
 =?us-ascii?Q?ZIG5oiGhdqF2aP0dQQC4KXm+Ot2Dui83NuokhWohoHpMq/wzEkz+usF84eBQ?=
 =?us-ascii?Q?Lml0zsloPbmCJP9fpsIskWLsWJv28HuFCf9NwBlWnfqzR+6MmcpwJwCFRA2D?=
 =?us-ascii?Q?sEJRkK5il1VY70AX+6y7jO8b1HzjFBH51oZpkhrYMrOpwbqfy2YAlcpXEoFr?=
 =?us-ascii?Q?ScLFkczL/BEoQfeiEkQk6g/Sot4vspEyTbHhQxuAuziUK1U5Z6K+W2Zaepwi?=
 =?us-ascii?Q?X54MIyn/Cl4W3DZ2DH/KXoPz1TsYcuSveqDdjCJy9IuABMlJdlth67ln+Ewf?=
 =?us-ascii?Q?Ms41gtQjT7NHFZNhfoWRWirU1zKX8gF7smBffPbz+ItXyqldNHIhL3BLGigq?=
 =?us-ascii?Q?YngL/LMvJEXFQ2hc06mX6+Ru8TSQ4p8i5v9RJLiNjvIP+lVMlnQORE4YSh3c?=
 =?us-ascii?Q?tQ41Tkva1k9p0iFRLK8TgBOJAkOLPWjCaeC1mkqtns5m13iVPpEdCZu3RGu4?=
 =?us-ascii?Q?6mEsBVSvJS1+lEHxfuwBjoPCsMemdIkE2TKQr828vg6mW+Ck78EcT+tApfZQ?=
 =?us-ascii?Q?bgeFLyx/utgIabHJVk7Nexy94p/ANijQYFXYNjJK7Q0TUnHBbhBSYrJ8GxSf?=
 =?us-ascii?Q?COZwsTszJKg2BI8xdeKvMpfSAByGLBq5A5mtMkEeOY+Dup5Mtu0IZyBnJYrJ?=
 =?us-ascii?Q?GmTJ0Q7l1FUt4Z4QdZXoanZfeB+piL3COekc56iqm4dLNCF39/216fev2/pz?=
 =?us-ascii?Q?qLGuErUiyFYVPq6VI0dcNEoy2K+S/YyEsM7BeIfo7pbqE39tHe52ki6mJP9h?=
 =?us-ascii?Q?b1z4RJwpM0nIxEzS/Z7T0PSWG5Rlwa8UTuOaVh+2wPwKDKwKXO0VVAChLx6h?=
 =?us-ascii?Q?+ScHAW/K0cExumsnWC2ssuRyMEN8tDgquHeEbAGs32KckNVdKWrtdnfkhmTP?=
 =?us-ascii?Q?2MbeCs34HGwdILHrlL1YemHRp4Vy87Csf8t9k65HdW/obDgBy+puV5McLlJz?=
 =?us-ascii?Q?iT4CtRrml0QVNHCz7G97gDtls+bebl5/HdqgiFmNwod/hKiChpw2+DJoogft?=
 =?us-ascii?Q?Aj9OyCLCQAbro81vA54s0MtbQYZ10R8vreh+WHH1tC/TcVq4rk78TRLx4KHo?=
 =?us-ascii?Q?wNtap/pOtQQJ2XX8BuWouqyJEoS8QVtir5r6uZ1avxow2Edes1kbZLRswRoy?=
 =?us-ascii?Q?9Nq0ZHr1hjQCU4KgwleUi1F2GXfr6c0Q7MNfIOx11XBEafYoSCPw63ueGU4A?=
 =?us-ascii?Q?pg=3D=3D?=
X-OriginatorOrg: plvision.eu
X-MS-Exchange-CrossTenant-Network-Message-Id: 33375581-eccf-4ff2-13e8-08daa39025e3
X-MS-Exchange-CrossTenant-AuthSource: PAXP190MB1789.EURP190.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Oct 2022 09:34:33.3864
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 03707b74-30f3-46b6-a0e0-ff0a7438c9c4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BpSyOxy3PMR6/5mMc/c0BvBpkiDfwuNaVyK6VYQ/s1qeBlkT3l/Q5mTq774+SfQCKTrmasB++l87j+9QieE4QXh4Q0jtNht8Y1SzmIQCBZ8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1P190MB0733
X-Spam-Status: No, score=0.2 required=5.0 tests=AXB_X_FF_SEZ_S,BAYES_00,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_PASS,SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add macros to determine IP address length (internal driver types).
This will be used in next patches for nexthops logic.

Co-developed-by: Taras Chornyi <tchornyi@marvell.com>
Signed-off-by: Taras Chornyi <tchornyi@marvell.com>
Co-developed-by: Oleksandr Mazur <oleksandr.mazur@plvision.eu>
Signed-off-by: Oleksandr Mazur <oleksandr.mazur@plvision.eu>
Signed-off-by: Yevhen Orlov <yevhen.orlov@plvision.eu>
---
 drivers/net/ethernet/marvell/prestera/prestera_router_hw.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/marvell/prestera/prestera_router_hw.h b/drivers/net/ethernet/marvell/prestera/prestera_router_hw.h
index 43bad23f38ec..9ca97919c863 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera_router_hw.h
+++ b/drivers/net/ethernet/marvell/prestera/prestera_router_hw.h
@@ -31,6 +31,8 @@ struct prestera_ip_addr {
 		PRESTERA_IPV4 = 0,
 		PRESTERA_IPV6
 	} v;
+#define PRESTERA_IP_ADDR_PLEN(V) ((V) == PRESTERA_IPV4 ? 32 : \
+				  /* (V) == PRESTERA_IPV6 ? */ 128 /* : 0 */)
 };
 
 struct prestera_nh_neigh_key {
-- 
2.17.1

