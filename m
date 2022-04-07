Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DDD5F4F8AC8
	for <lists+netdev@lfdr.de>; Fri,  8 Apr 2022 02:55:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232578AbiDGXrE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Apr 2022 19:47:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231509AbiDGXrD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Apr 2022 19:47:03 -0400
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1anam02on2118.outbound.protection.outlook.com [40.107.96.118])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87703F17;
        Thu,  7 Apr 2022 16:45:01 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nZ2L1BJdU4TDxaEAnPbp2YYXMePUlF7wVFmc2QN1ux65vvpR6MmEZ/0ivhot3hQ5ZrFCfXYAMbHLLsp4+Z/3fxUkKYdbBys+qJ4HwLQO1GckGYvsD4NMX0f4ACqedKa9GEj/oAbUAxdFmZiF6Ulg4esXG/qweHem18mOTGFPbPl3wxd2/QB0ugUG7Y+X7AtJWHBD3cXmmY05qEz5oPigXMb9Rn3Y25+pPMxuIQUKTL+NO1hfHcEUsvhHcAWZLk7SMEa9kYuSfV1WvHbC5tA69g04vzThX0wGsmq75Q/vammJCfyZZpHEWnOHq02YSBqyMiciGG255UT+cyBw6IJUMQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DCqmeAFrRAEKk9+RJibDWQkPN3LjhVVqSf+7qqjwQSU=;
 b=lzW8Vci3I1JPsBS/lkMpnDjCMmwZ6pEhcmEWP8b19F8hqFZpKEpqttI0fzxFIqDJFcqx9DHGjjw/GGybmeI4THpZI9xzgv/SZlWYPZdZs8+cDbfAZ5eMBc5RJu5+X3W1QgqbeURD4j6kEMCszjdavI7Kkm/z6B6sh0FPpY0zlR5ENn5xNV0WHlG0XTn/xaPe+SOa07aq5uj6f1ej3I756xRC3OP0Gz1a0qqL+/vFSMzBSZLllMxqlwdk+JNj41FNHOeJYwdV9FteDIrZCMW1FAqzevzV/w8iCThWSo9qSwIPjbHMlTZSxoY1B4/OVZ6InUJgaAQnVlAW2++PFuJoGQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DCqmeAFrRAEKk9+RJibDWQkPN3LjhVVqSf+7qqjwQSU=;
 b=rmfx/bq4BWL+Mqb+IOy3elhD2QRx9oqmOIlS7sPpM6LDPPk5AM01whMdRlOogKYSazMclh8zu0K4HChY3OgBgATwoRtbStJY4UsIpK/WOotSqBadfo/RPGFRMguntoA9m4nKmdr5Jvt9xEbI17f9fco5JR1EyMwO+G3KxTXCnwM=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by BN6PR10MB1233.namprd10.prod.outlook.com
 (2603:10b6:405:f::7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5144.22; Thu, 7 Apr
 2022 23:44:59 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::4581:787c:1a7a:873e]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::4581:787c:1a7a:873e%3]) with mapi id 15.20.5144.022; Thu, 7 Apr 2022
 23:44:59 +0000
From:   Colin Foster <colin.foster@in-advantage.com>
To:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Cc:     Paolo Abeni <pabeni@redhat.com>, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Russell King <linux@armlinux.org.uk>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Florian Fainelli <f.fainelli@gmail.com>
Subject: [PATCH v2 net-next 0/1] mscc-miim probe cleanup
Date:   Thu,  7 Apr 2022 16:44:44 -0700
Message-Id: <20220407234445.114585-1-colin.foster@in-advantage.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR08CA0047.namprd08.prod.outlook.com
 (2603:10b6:a03:117::24) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5d1ec6c2-842c-4b88-db23-08da18f0a044
X-MS-TrafficTypeDiagnostic: BN6PR10MB1233:EE_
X-Microsoft-Antispam-PRVS: <BN6PR10MB12331BC0DB89FFB45D17E88FA4E69@BN6PR10MB1233.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: PZDkHiawLVSvidZwqZdUyG4cZ4S2DSaXyJLUDta83KONo30CrsQpm3LL2LdwqzGUh1rkfCKozvvr3afRfIFpM6kwTEEG2zdT5rFHlnJLjZyV216VgDU66sEcvfByYsUHxCpqqmmsPkOu3RrkRE5ogUTI9C/U8HLukD5pQ16Rt2jshHpZyIo+uCldM5f1DShfb4Pj5eGQRMAIqfCyG5mDS+uSn+EL40rmKY5rrBmGlSmYTkPBTWZPjSISvoPM9/2ZtUt72e3Xl+Bwf9W6t2ZMn7SFAAKr+DjuIrSxNHeBQ+Zasa9PmkCXMUOrYYZI7FO0iNS5TSbZ5tHtfpAgvDFdAEUHIAqYmXT2i1fqc6blqoy/yWjOr06x6o1o+oDFeaX43Y4zylaIpGZe98Zfn8uFlLNKBb6FJf9SYd/Cpke8HP+VUmK9nB+dBLBXwui+JZevSZHvuFjc6ihfEJyCKNWsJ03HGbywnsMQmw7tH/If2GZwwqnNMpaNzEzYuGodC+yAusMWQ7gy9Px+enMaLPrrx1L/6qAiO+TNWLV7uQ4yzBi2juatGDDmkXnukSmsui5pF9Gym9dhnISevtfqxFbOkPb07/yWNDb/rRxnefQfC/fxMBBplo9Gtk5s913/bqqKpQ338M3SbwrQvNgq83cyJab293RcV+o+UQRwdd87I4KCR9HHxlhdHYPJ9ODKz9PGRyU/xASyyfzlLVz/sk2NwQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(396003)(366004)(376002)(39830400003)(346002)(136003)(5660300002)(6512007)(52116002)(8676002)(66476007)(26005)(66946007)(6666004)(66556008)(8936002)(2906002)(83380400001)(186003)(44832011)(2616005)(4744005)(1076003)(7416002)(86362001)(4326008)(54906003)(6506007)(38350700002)(508600001)(38100700002)(6486002)(36756003)(316002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ILSG9b+MJ2jS1nATuq8kPvDJXjYUHDNh151oHEzlglGxTlAvSfas1XhAVAc0?=
 =?us-ascii?Q?62n2x/1ygVTLVAsNeheNvSSL4FCT/JRsfF5d9GeuTmmX686SumnBNZxK+C1u?=
 =?us-ascii?Q?PcWglDo7QqMcMihfhcr6mY20nG8kKPieD9eQ7BHiAs2wTR4UdvKLoshgt/It?=
 =?us-ascii?Q?C7mstMzemJ83SXqA8u/Puxvgu9vXg9gS9UfKBbpJpFouI08yNKVsUAsmukre?=
 =?us-ascii?Q?+kH6odtEP+Gkeo6Up2RAwaUk8cmDMjMuTM6+UfcR5W98K4b7JumuFH8PlYPu?=
 =?us-ascii?Q?53Y+PRtpC7+nSKvyeOl1zdovogn46jnRYHiWqYIxy95EIA2RQT2UehTfEMU+?=
 =?us-ascii?Q?f2d9xMUnWB2m2rxG1IYJIxni6I43Dk7jrGyZouW3vvwHbrdfouMZen1jkZmw?=
 =?us-ascii?Q?63Nx1rG3hi+ovdNsySmJ4U/HXKTDmwYFfiZDlJKcDNaIvCZKmH+XsSFE+Ol0?=
 =?us-ascii?Q?EKU+nUFn0/X1FmbO3J9ZpjaaYWs+NDY+BCMdzbDY4G5JDvEl9Q0EUSQ+IILe?=
 =?us-ascii?Q?uCEpH5D7UXw8LCjRIYwz0ML6s+tpyBUYgBoRUtbFkaf4eZMrfTtJU+Z1JIO+?=
 =?us-ascii?Q?Jvb5Wlr/yX6r9VZPnqx90IjlPms11dW6NY0kgy71gL6T5kr4B/lE8PShIQY7?=
 =?us-ascii?Q?SIwPti7XrtbiSkSNQorjTICt/sG5zqQKbjCc96VkXcnR3fR/uFjzqNNW0uKW?=
 =?us-ascii?Q?oNo2prcyzxCbL7T0FYnatZMC8cnxlf6Nca4Hwru+z6kDMa3f4P+67eF282Rh?=
 =?us-ascii?Q?NFmrTkyRWoRN0aYQKx2Q25kZ9ukHOlY0XNzTkb9B6mIhqbjESh92bKvOnyUC?=
 =?us-ascii?Q?ty5b7RdaB4FkLk1Y2ku/qz01cSrBpZaGsDe14u6Wi4ZA37f2wnswoxptDvxb?=
 =?us-ascii?Q?ufoM6ZjcGvaVccGUMwLrVS+ALU8GwaX6a7LhQXUYK1k/PjMhCDU1Nvozn1/1?=
 =?us-ascii?Q?msEVkz658TxGzPbSRWvy3vetq/ykIKjwIoByZLb2pbs7RlzfuM++LIrhNgID?=
 =?us-ascii?Q?3kt0+BcAfjTHkkrdHpDHSj0HpMti2f+FCKzT+WuvimoyyPohDrLGLLTcH8hD?=
 =?us-ascii?Q?gh1wr0tIRsmW35eD8B21I+fI4LjXwoKPJtlCo2BEfgT0K6ZXgz/Ms8irjkU+?=
 =?us-ascii?Q?JnnCkG5s7Av34NCx32CfwicEpKFnVJxQ155iYFw/lBrcXTsMXVmvfNPUAbZQ?=
 =?us-ascii?Q?4wJhSuF75/pfPOe0piYB6eRse0RKB7JSKeMN8nXYDzZjrxeoChL7F2CFkLw7?=
 =?us-ascii?Q?IzMwLcA73bw3EHvzfF6rWXVTRnxJLIFd1PRt9GuJe1NFSYUpyyJfwaXyWTqT?=
 =?us-ascii?Q?v2AHWUrsUt0Pri2uLn5nIycr5WQmHpJUkknizmfOdqF6dnGPuRi2cwP6HgTu?=
 =?us-ascii?Q?YyqenRHleWHPHBv6qkkgyCa5ubqtT9LFbumjKW2Jcl82yXUQ+ka+G+15B2n9?=
 =?us-ascii?Q?kaC5iz4NYYDAUplE9iUmmlFyiAUntsBWy94k3s3lisCDSPVOZVx6UCeBwc7O?=
 =?us-ascii?Q?uyLKbwi2DjGBe1tupocyiOMqFzYUWrxyzaiG9xinFSl0YC9MBRwR23WZzHyq?=
 =?us-ascii?Q?IdK7u2r4mjhWOvF81MuObvTyYUmaOt3EXXiS9HTh9GfOdQ1Hyw3mer1lrNZy?=
 =?us-ascii?Q?XogRtnvb8oRn7NRCGIMznasBe6KldxN+HP2VWFKCkB4NJmmaHQmWFXBloU6L?=
 =?us-ascii?Q?eSSl3VtmBKjSGm+fmo0+iFu6hfV+2dK/v5v3TLc/WbmRO/PdLocPc4yxVK0x?=
 =?us-ascii?Q?s3x9bTLZQlQb2/hFCL1NcmiDfGWrhUgt0rioAZTQtKFNACAPIfWY?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5d1ec6c2-842c-4b88-db23-08da18f0a044
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Apr 2022 23:44:58.8462
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8oxZHFxJ/DJKAqNf3lrkHy7Yk7bdiWuqA8xd45rVDoFrU38xtGkeooB4xi4V4fb1vd8MEutoGAZekNd5U/EJvPC2U6/bv1KpIpjJz0gxyOk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR10MB1233
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I'm submitting this patch independently from my ongoing patch set to
include external control over Ocelot chips.

Initially the sole patch had reviewed-by tags from Vladimir Oltean and
Florian Fainelli, but since I had to manually resolve some conflicts I
removed the tags.

v1 > v2: Fix incorrect regmap config reference

Colin Foster (1):
  net: mdio: mscc-miim: add local dev variable to cleanup probe function

 drivers/net/mdio/mdio-mscc-miim.c | 29 ++++++++++++++---------------
 1 file changed, 14 insertions(+), 15 deletions(-)

-- 
2.25.1

