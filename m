Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 17EB543AF0A
	for <lists+netdev@lfdr.de>; Tue, 26 Oct 2021 11:26:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235202AbhJZJ3E (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Oct 2021 05:29:04 -0400
Received: from mail-am6eur05on2071.outbound.protection.outlook.com ([40.107.22.71]:6192
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S235081AbhJZJ2i (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 26 Oct 2021 05:28:38 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GLGNPCp+KPcgVRVzX9X/o+/B1hcqzem0YQhOes6jwd5yYxDNjmIJI5SVoTzTucZcRGjR97jT6QqaIU6tQqA/zenDOaK5KBZVziTQIDR0eCtz2ULGa83xLYuoa5LPU0JJY/oIvDHz1YpW4gcSOcxUUWTjtNXn7CatLFkld+HSpy22u+FQ+zMFI372hwVFa7xXy9bucmi8iS3Kvq0yZklfm5fT5okQKxe8arB92ZV9JfUl5XwdRtTQtYSYdbL/enhcHsirYz7AWJfkp4IzotAaIRiOrXUc2s9oiKWG925JSFnOMovmiuStpjsMGfuAk/TGmBTIofvWVqv8PWPcV2YEFw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=daN6WSd/UxGpiGuj/lUrDxszzdEiSWs4lK/PCevXLfY=;
 b=BR5RevNMDuIx8WoXaTv0wc9xqNtE0x9Us/OFA/AgpHtRHE+DNWBkm7juC8BFtPeYaQ+FCdeSbV66TYa0FwGkcma6mErqgt2qZHjMtNwE6lj5wWfFdlHmFtOE50pa7SmhZ2C2FzJPG3rrjzrSvOCTaNV5oFQdUA7uxEBBUEtZutVsNkW4gbhHw3DNpuMpfz9YIzUellku5LhG7gbpHDZiCVWW+DYr+yMbXHDQzgSJZ+cO518+SEebV9eAabfTHNdOvtWOU6kaSediWMsio5/ctCcNc9TbNaOaCwdAURxwPPOWGa+aAjyTlBEvRZRx9N4u4SuvTcW7nr4X3vXXuydo3Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=daN6WSd/UxGpiGuj/lUrDxszzdEiSWs4lK/PCevXLfY=;
 b=etXzKeK6mwxRjvi2GMi2MVc/uJIcMXILdTwYUvj7VKpdhs3GqZQ7qsVWYZKUpAc/CipgD//jI7tMFCe+ZtO33Bro9NXvmPHQ1lEneQbJrw1hg9adh55a7hYUfsWKZOzgqaagQpQyKGwBTHbSEouk2/0ZatTonJjWHCBHok/LR7M=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB7104.eurprd04.prod.outlook.com (2603:10a6:800:126::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.18; Tue, 26 Oct
 2021 09:26:12 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4%5]) with mapi id 15.20.4628.020; Tue, 26 Oct 2021
 09:26:12 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>
Subject: [PATCH net-next 0/2] DSA preparations for FDB isolation between bridges
Date:   Tue, 26 Oct 2021 12:25:54 +0300
Message-Id: <20211026092556.1192120-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM8P251CA0024.EURP251.PROD.OUTLOOK.COM
 (2603:10a6:20b:21b::29) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
Received: from localhost.localdomain (188.25.174.251) by AM8P251CA0024.EURP251.PROD.OUTLOOK.COM (2603:10a6:20b:21b::29) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.16 via Frontend Transport; Tue, 26 Oct 2021 09:26:11 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c3de24c6-82d4-462f-ad5d-08d99862a6ef
X-MS-TrafficTypeDiagnostic: VI1PR04MB7104:
X-Microsoft-Antispam-PRVS: <VI1PR04MB7104BA7B9706027BB1E4C7C4E0849@VI1PR04MB7104.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4125;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: INNVjrRRlBI6ysX8sSu+tI/flEFDbiFdpf4TiUXQDausVJEaDntHnS+nORhM4Wi9GpFJ7OMAxA6801W+rUNxbuvcjYQsExommY6Tq+aZa3UjhkGTAmWgGz67ZasOj9S3eS2j8MynypCUt6LcSaeWJ++jt4/SrodNEDaTJjeGyIKrijzdsZAJYoGiRBwlciW2ClWRMjYpRiAQIPsqe1TBi3o8OTsxiBot7hVc9t8voNTSjo2WxNe5zkEWKxdNRZTzYcwoyzsBQDaCW+wDR9p7eGL4P4lfq+haguG2e+g3AuaSv5ZSQChhuXCxTQDIP+gbi/oL3Nla8XK0GdppKq2onQd+t2rz2ZcJM3VbR5wX2i6Eda+pV/KWTviNDI7nb15MotITfqSv+IHM1qLVD5xwuFdo/LyYzK5TpRbGEZFPHiOcuXpRfcGja74LJGCuqQKKD2mgeaH0AqnNfzCcOA1yudm5BWEIFDRV/xtS60jNJ2FD6hhVCHahDHjOg2Qv4vDRp5AD5nWc9AZJ+D3rpmw956K1kHR4RSht4EI4r5kt8+/ci4KnZKwLSU2VM/MovKYIkGWre7DSFdI5zFJBz70kkXQqVc33N3d2zvPcckQ/h3ueei08k5qh6FpgCrp12bfg4hOmbRbANz8QNb+cTtKRXbFlo5WdbFrlUuEbhQVQSzNXAoPmFv8q/bqJEPlW+2F+9MSII5HuMt+QUfI5AKeP4A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(8676002)(6666004)(1076003)(2616005)(956004)(36756003)(66556008)(6486002)(86362001)(8936002)(4744005)(66946007)(38350700002)(4326008)(186003)(110136005)(44832011)(54906003)(5660300002)(66476007)(6512007)(508600001)(316002)(38100700002)(2906002)(83380400001)(6506007)(52116002)(26005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Ub14mXWWDa6qqq9mIjkfscEkODZXcdC0JyJnxFlXGmL6KpKHMVbUNO7/GTfK?=
 =?us-ascii?Q?ybDSFCdybzlQwevtaNIclBCjf8AOoY8xGAuCv3IzVNC359CWbbmu2Ad3GKhx?=
 =?us-ascii?Q?aZENAuvzEAXP7F4suh8oJbGXDHZFGvyBw7FC3TWG8Bi18m5VSr4iojhtnHCE?=
 =?us-ascii?Q?EaUbKE7CqsJcIv2AceQAvdy4CusmXe9IP3ht91YGdObqdLAS32q/AIrovDWU?=
 =?us-ascii?Q?P6mdWjzxL/n/wU2arCTz0HYELGLXNFrIeZdBt0BhKv5ie4iIkzA0kUbYHwKt?=
 =?us-ascii?Q?l8oSSdzeQHXy6TsaS9O9r3UYnW65QNRs9cdqyfZvIGX87gL+aasDT0ESs50V?=
 =?us-ascii?Q?/aBtgVR96yJAA484U/IYD1f1j/j5bOQICQrWVzrwd/gEiubS2lJRC7V7lSDL?=
 =?us-ascii?Q?Zdjw5Who/zR38j6Ql9/lQmxdrKF6ShBhhoTz3+wZWYmMdDF0mC6Vgxm/kTHh?=
 =?us-ascii?Q?epUAnj0YaX7i7jzmiRp1Vgr57OeaZoGKubOnN1TGBm9LyN4a0ZVWBmSBCQVP?=
 =?us-ascii?Q?bSfFOVQ5uRf/cPH5uKQdPKq6wiHZDQJgcIL2di64DfXWYx0LnK1OVQ1QCsN1?=
 =?us-ascii?Q?CP14d148XgzLrEek8mgFCZHYWETZHzWk/g6EQSDd//XdZagT5R2KyvD7AaOw?=
 =?us-ascii?Q?ePgOYMohLHwKXmA6UAfoJbrNj38aO5sxWEEgclX3JfeU4v1PYC7OuF79fBtI?=
 =?us-ascii?Q?uuAMMcLNVeqOyKIoFQsDDDswKpJLZSEjv8i+UHDrVza09EIoJYsGokZjwdzP?=
 =?us-ascii?Q?UrGh8dtvPf+HYOOihkXzaBgHy7zTou7xhd2b+56qsSzETGATpKG5Rccyth/p?=
 =?us-ascii?Q?R6u1H0yIwET7mc7mwBVM7lsZTvvCKI6Zwl8xyLQp+1FOpi0+LGUjkOkhuM/M?=
 =?us-ascii?Q?tAcolxx+EAqOOEuTJdf7JBlP6XJiK5yF1R2LjGQMqeruEH02i+vVXPwnHzZv?=
 =?us-ascii?Q?qjL+05hsPosjpWAc9HbfbJW3S7FbnnLfZe2G/tN+zcFvv0tW6gRpqEHa9inY?=
 =?us-ascii?Q?fwTb29ctlupP1foaCAFxQnc65VL0O6WqW55pEMbbmaJ4/aZCHcRYYgOspE8u?=
 =?us-ascii?Q?vQnsXMlZ1pxI2Gp5LrMMVqNigHCc+phYTfqThGp7ZhiLacCiNH7p4KGmTav6?=
 =?us-ascii?Q?JYS1IHSYWdBtmwmr8fJ7wVpHqK7GrFWRdbXJFS9St3+kcWCGjEOaLJEozDNy?=
 =?us-ascii?Q?Y+NMu5mgiCYhbd6+cu41rWoIkSWBB4ocp96kwbjKot870pS77XZ/Ksq04UPk?=
 =?us-ascii?Q?bCgfyokNMa3CA8NX8AzloOM7NIiivsIMFhZym3RWnhX4MwuEMpaa/oy5YvIB?=
 =?us-ascii?Q?7WU1VKiafNuE7zNqgs1D5aVKipz2P9xHV3to+fMchZVoU4oIpsD3CSrCGqQE?=
 =?us-ascii?Q?5W3QR3HkQdcv63Fah0zxXlp4wfNTIqtJj+70kSxxBVa2S8ejD0L7fsRnMgKp?=
 =?us-ascii?Q?AgSIKa4sbngajzDyY0ZpIN3zSkBZW7If3MxxMECViiWhHncuuCQJbwb+Zkbb?=
 =?us-ascii?Q?RQuDe8edIIQH0PdqHmoBwJx7q3MTcSS/g4Y1B2HcYLwGH+WNbWdPpnySkfpe?=
 =?us-ascii?Q?t6vhgizsocK3i0fFblGTsuUzViJNZpymcFKVFxj/31eWBfR5Zw4w4mi90nHF?=
 =?us-ascii?Q?XzwC0Zme/iJEyvDDs3MrYh0=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c3de24c6-82d4-462f-ad5d-08d99862a6ef
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Oct 2021 09:26:12.7546
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: sBBkwcUF44W5lefnT25wXG1COujTMq7p+n7lRR2offMnKsyuZbj0diA+6TyhmT8OtBKIeLskcE2lQtqhzUMC2g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB7104
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series makes 2 small changes to DSA's SWITCHDEV_FDB_{ADD,DEL}_TO_DEVICE
handler, which will make it possible to offer switch drivers a stable
association between a FDB entry and a bridge device in a future series.

Vladimir Oltean (2):
  net: dsa: flush switchdev workqueue when leaving the bridge
  net: dsa: stop calling dev_hold in dsa_slave_fdb_event

 net/dsa/port.c  | 2 ++
 net/dsa/slave.c | 3 ---
 2 files changed, 2 insertions(+), 3 deletions(-)

-- 
2.25.1

