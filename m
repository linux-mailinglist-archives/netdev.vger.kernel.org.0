Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EFF4920F184
	for <lists+netdev@lfdr.de>; Tue, 30 Jun 2020 11:24:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731928AbgF3JYp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jun 2020 05:24:45 -0400
Received: from mail-eopbgr80078.outbound.protection.outlook.com ([40.107.8.78]:21154
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731810AbgF3JYo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 30 Jun 2020 05:24:44 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VNvMZ7pE5ht/ahTZwSWy9P7xqDcAEZF5cc4BugsytPOJNkKz2QyLya6TXDQxulv56fD97cH4IHsbsWIT3iG5hM4E0s+xxuYT1OdDNzOfb1IfWl+Sxo7+OyAvewF/ZldBxY8nldo+RlqXTINcTEwJdthXt2IXLi/MP2phkvvKU+KJfUwRmuqDbaaGrBebmcFMACxHXL3VOocWfHID0OWH8x8dZ0bfe5VySqZavORmNp2mLl67A/5ScNihUNo4S0gMTfsWmIr2P5PZBxMQt6ejHCGCV8vXGkB7fAm4may8tWH1finUaKTKUqQDg6u8Fw0410+eTko3C1m70GDpn8n9xw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aQ9vqUYGw38BhndmGcL8EODSM579oWPFqa0yxMZbjBE=;
 b=GHFjgwHQouCuWa3lGt8mDnYxdAQ4nkFJR9iOwHBFzyW5PHvbWYLY/P4qrY5d3L83dvpVPgM1wAh9x9VtuT5qT5EHhaP6F3BzIONK1/rlnvIl0aaW6YTHbYBb0QrQzXbW0RdHcCZ4KsdBeeUGswAJn7IGZg1OJMYBI0LDxinqUtakIoFsC43ecI5etMSXKUwzOghovgouqh5ADunZPvIJhRowbR5TvXGI8S1cX8DmgR30sMEJWSoCpaGhBAgpNNR+G2M8R4ZlBeHLAovY/sQSV7ybBnQHcjS00KoFUJ3BsCc6UkrQ+wptfDKZbocaEfAKGUw+M3ZOcQDdOPDk9N+9lw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aQ9vqUYGw38BhndmGcL8EODSM579oWPFqa0yxMZbjBE=;
 b=WFQCO358j3w3eo25ble3Bv//LvNE/8Na7U7UB8HI8wne6MiAdVPNcrlQIBSKlQmH3y2RAIcVvd0FKMsrNEuaQg5HmlhR6kOYv+sf2BLFigs8NfAvvGsQDELDu3emPjEnuSfWkosb/jzyO8YElGZYZ6GikaTqM/I35c5ndonyOE4=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=mellanox.com;
Received: from AM0PR0502MB3826.eurprd05.prod.outlook.com
 (2603:10a6:208:1b::25) by AM0PR05MB4450.eurprd05.prod.outlook.com
 (2603:10a6:208:61::32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3131.23; Tue, 30 Jun
 2020 09:24:38 +0000
Received: from AM0PR0502MB3826.eurprd05.prod.outlook.com
 ([fe80::2534:ddc7:1744:fea9]) by AM0PR0502MB3826.eurprd05.prod.outlook.com
 ([fe80::2534:ddc7:1744:fea9%7]) with mapi id 15.20.3131.027; Tue, 30 Jun 2020
 09:24:38 +0000
From:   Amit Cohen <amitc@mellanox.com>
To:     netdev@vger.kernel.org
Cc:     mkubecek@suse.cz, davem@davemloft.net, o.rempel@pengutronix.de,
        andrew@lunn.ch, f.fainelli@gmail.com, jacob.e.keller@intel.com,
        mlxsw@mellanox.com, Amit Cohen <amitc@mellanox.com>
Subject: [PATCH ethtool 1/3] netlink: expand ETHTOOL_LINKSTATE with extended state attributes
Date:   Tue, 30 Jun 2020 12:24:10 +0300
Message-Id: <20200630092412.11432-2-amitc@mellanox.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200630092412.11432-1-amitc@mellanox.com>
References: <20200630092412.11432-1-amitc@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR03CA0044.eurprd03.prod.outlook.com (2603:10a6:208::21)
 To AM0PR0502MB3826.eurprd05.prod.outlook.com (2603:10a6:208:1b::25)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from dev-r-vrt-155.mtr.labs.mlnx (37.142.13.130) by AM0PR03CA0044.eurprd03.prod.outlook.com (2603:10a6:208::21) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3131.20 via Frontend Transport; Tue, 30 Jun 2020 09:24:37 +0000
X-Mailer: git-send-email 2.20.1
X-Originating-IP: [37.142.13.130]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 2ca85aae-9a66-4af2-5470-08d81cd76928
X-MS-TrafficTypeDiagnostic: AM0PR05MB4450:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM0PR05MB4450155AD7C694BC472ECD28D76F0@AM0PR05MB4450.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3383;
X-Forefront-PRVS: 0450A714CB
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: OQKyxAjoo9RjDanccKtaivQgdNUszuuPTu0uG6YGbizhAutg458WX6y0SthbYIMOZJvW4axKWPqGObD81AmCEnBJGd6da0sMp59K2ghaA+WztofzQwsIlfd3TUmfBRHf19OeHCWxQQQcJcxRjr7zamdBxKmolY4FO3OSUHbHJO94J7IExsvLiWP+qPuH4KUyCs+cpwnnde5ijjO7UBJlcoVVc0SGi6iPazsVErHohL2DNjWFgypEC8wcCF6smBqlOMUvdvTr91PI5iNdpFNCFd9/tkT7bl1Zd6eStNskrXRfYqjKJZJW95BpPlfuU2SmoaowF2ppA5QrttJUjWgXYA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR0502MB3826.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(366004)(376002)(396003)(346002)(136003)(39860400002)(52116002)(478600001)(2616005)(956004)(4326008)(2906002)(5660300002)(8936002)(316002)(6512007)(6916009)(66476007)(66556008)(8676002)(66946007)(6666004)(107886003)(86362001)(26005)(6506007)(186003)(36756003)(6486002)(1076003)(16526019);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: ccCqQPyCqr4RZrVuxr5Z6mQDjBJdIgy9/SDDo8YYxIGTmyKjDr1+42M6a3V4P7xlIf64jnLAl5rhHhgmVjErIA29Buq+r30a8k0IPcPJlao1IA42pWlOk24a6iZdPMUw/kA3tTJVnEB/QecL7bE8hnVGVd/EcnCa5msNywE3C8AYKBKnhOerWsiZFeV7Sg87yvEnaun5yPEHapjFvb8+4MtDDSz8yW8QIZOLNV0n2dCGqBC0PZXNT0LrjkiDfEPKNp25BhitHzC0VH6wg/8pCfDbY2yh345JJF7Dv1qU4PlsR1lts1sZMIaJ2rGh10i+yP0wnghrHrdJii1MRiagwP2xieYNrUOXvxLjZw1GOMV6CnYXbqtYmFsoBJyXraj3FrOlyS0QtadpTClMUjEotTFZwWbljYntdU3si3Gc+EvyLhqvVl1zy1bKEDFYr3mulvqYWVm6D19mPyd8h8lm3KlUUngyfiBR0ttN31lfKTs=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2ca85aae-9a66-4af2-5470-08d81cd76928
X-MS-Exchange-CrossTenant-AuthSource: AM0PR0502MB3826.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jun 2020 09:24:38.8078
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HKtaHcQcMzwSucIdlCzfmj7RH+qP3FMesoIo6BkvQ/RGg2s1mBoDuvnh7L4iV7jyBt8Wj6tlbeWQIYhZkRQx/g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR05MB4450
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add ETHTOOL_A_LINKSTATE_EXT_STATE to expose general extended state.

Add ETHTOOL_A_LINKSTATE_EXT_SUBSTATE to expose more information in
addition to the extended state.

Signed-off-by: Amit Cohen <amitc@mellanox.com>
---
 netlink/desc-ethtool.c       | 2 ++
 uapi/linux/ethtool_netlink.h | 2 ++
 2 files changed, 4 insertions(+)

diff --git a/netlink/desc-ethtool.c b/netlink/desc-ethtool.c
index 98b898e..bce22e2 100644
--- a/netlink/desc-ethtool.c
+++ b/netlink/desc-ethtool.c
@@ -95,6 +95,8 @@ static const struct pretty_nla_desc __linkstate_desc[] = {
 	NLATTR_DESC_BOOL(ETHTOOL_A_LINKSTATE_LINK),
 	NLATTR_DESC_U32(ETHTOOL_A_LINKSTATE_SQI),
 	NLATTR_DESC_U32(ETHTOOL_A_LINKSTATE_SQI_MAX),
+	NLATTR_DESC_U8(ETHTOOL_A_LINKSTATE_EXT_STATE),
+	NLATTR_DESC_U8(ETHTOOL_A_LINKSTATE_EXT_SUBSTATE),
 };
 
 static const struct pretty_nla_desc __debug_desc[] = {
diff --git a/uapi/linux/ethtool_netlink.h b/uapi/linux/ethtool_netlink.h
index b18e7bc..0922ca6 100644
--- a/uapi/linux/ethtool_netlink.h
+++ b/uapi/linux/ethtool_netlink.h
@@ -236,6 +236,8 @@ enum {
 	ETHTOOL_A_LINKSTATE_LINK,		/* u8 */
 	ETHTOOL_A_LINKSTATE_SQI,		/* u32 */
 	ETHTOOL_A_LINKSTATE_SQI_MAX,		/* u32 */
+	ETHTOOL_A_LINKSTATE_EXT_STATE,		/* u8 */
+	ETHTOOL_A_LINKSTATE_EXT_SUBSTATE,	/* u8 */
 
 	/* add new constants above here */
 	__ETHTOOL_A_LINKSTATE_CNT,
-- 
2.20.1

