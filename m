Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E50142569A
	for <lists+netdev@lfdr.de>; Thu,  7 Oct 2021 17:31:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241107AbhJGPd2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Oct 2021 11:33:28 -0400
Received: from mail-eopbgr140045.outbound.protection.outlook.com ([40.107.14.45]:2526
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232593AbhJGPdY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 7 Oct 2021 11:33:24 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Y5gK9JfQAWnYzm2WMEEOgW0+8BFDNWxQinQBPuT351Fqi1Hb/4ovPa1PvSBvCm8h0VljtzcrmNzUOfEKs640i04Td4B/u/H+L5KuQxVWRk9pt57vpkcyh/PANpYJTrtZzPI+E/LQLJ4ss8Ohq63vz1zXOaVZ+oWWTW6T0Co2psVyQUEirUPvMTK/jIYkHVsgVFP7nonEWKjQB56qrPTpq9oWdHAFmku8aJCfvzN445KInY+Yag0l5g+HSQbrKXYfPnXIvcs9t22QgP3M/yzK5aqekpwE3a0yaSAi8ZB12Mq2ZwYBTeQlq5ekWac2rpHFzBEFUFC2r8VOhZLbo/1b4w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oVnVbBgdhGtCu5xQTnXQakBskmbB//AKp3m6rI8MJsI=;
 b=WG6LhX4WJaBaj3kCSIJNppwAkf+XdS7xQ+O7s/IbNKW7UlYa79AeJpoyDhXGO9EmKxobXklHKWOHKMLAfKzflXNDJ3q+rL0Clj8RwYl6ObsS0UJ6ADsOIwA/PSWBOi0Y75r6E4j7FYyDdGaSmqGdbPeuGwM93cC2agBP5vITJWXnRLu0vlVM8CYn8E87clmMhng1x675f7b7oiof4Uw/KBv6y5VLynLrl9B09AxF0yOrAmZwfbKaox8MBoGL2zb7mpFy6YeYwwfnf8UgLT3qCTdQ6Jv07dljDFmNxh607UV6ya5Li9OkJh01gDfVaiGI3WhylmgikfDuR/k5kcVOoQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oVnVbBgdhGtCu5xQTnXQakBskmbB//AKp3m6rI8MJsI=;
 b=q3Z8Y7zxNG/GO4G9raBhB2MIf/mCYSbto1pClnvBARGPUiHYNvxhUZzc3VZ+k1aHv3NYja5BW4YQR/8XygO1u8hLxJVUg55XdWf9SBBFYDAz7b3M9TNY6H0jAiaVlrmVzRSgMad3P851zwuTYZfNR/SVc1+0swJW7hMd4dT/Jto=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=nxp.com;
Received: from AM4PR0401MB2308.eurprd04.prod.outlook.com
 (2603:10a6:200:4f::13) by AM9PR04MB8212.eurprd04.prod.outlook.com
 (2603:10a6:20b:3b7::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4587.18; Thu, 7 Oct
 2021 15:31:28 +0000
Received: from AM4PR0401MB2308.eurprd04.prod.outlook.com
 ([fe80::6476:5ddb:7bf2:e726]) by AM4PR0401MB2308.eurprd04.prod.outlook.com
 ([fe80::6476:5ddb:7bf2:e726%8]) with mapi id 15.20.4566.023; Thu, 7 Oct 2021
 15:31:28 +0000
From:   Ioana Ciornei <ioana.ciornei@nxp.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, claudiu.manoil@nxp.com,
        vladimir.oltean@nxp.com, Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: [PATCH net-next v2 0/2] net: enetc: add support for software TSO
Date:   Thu,  7 Oct 2021 18:30:41 +0300
Message-Id: <20211007153043.2675008-1-ioana.ciornei@nxp.com>
X-Mailer: git-send-email 2.31.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR02CA0017.eurprd02.prod.outlook.com
 (2603:10a6:208:3e::30) To AM4PR0401MB2308.eurprd04.prod.outlook.com
 (2603:10a6:200:4f::13)
MIME-Version: 1.0
Received: from yoga-910.localhost (188.26.53.217) by AM0PR02CA0017.eurprd02.prod.outlook.com (2603:10a6:208:3e::30) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4587.18 via Frontend Transport; Thu, 7 Oct 2021 15:31:27 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2323a99c-ba49-41b8-6cc2-08d989a787e0
X-MS-TrafficTypeDiagnostic: AM9PR04MB8212:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM9PR04MB821227BAFF2DDEB2820828E5E0B19@AM9PR04MB8212.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2ker39wFn+NQR3UtCdfDUizWR+rbhgUX8RcpC1HiC2vK5UmWUFWm+Bxa4QM/0EXA81tBi84ZUmDM2ZZdUgaK64D6+9kd8uVcXpwYAhzJpOUpGswBOZ9L7MXZhBjImglWwzKovLzkIVeUT7qd2F98pk9lhon8tmhk7NJYXGo2tGIhAtC7i9eWqU2B2iZJxf8lnvCLhC6I2YbhzXMFjfdEw3C5x1rR9Z8ZA0SpFKnQ4razZqwsfVSIqjPjEGx9xeBUu5sL30RH1Y9JULjYTTbgpZnWxCh6xn425/TQt0VaF7lLdV2jpi+S2tlX376YojbCoNc00tyr3zhtKok8dAHukdWr4BxeHxAf7DypZOZhaSRnBIa32ACAZqZUP/psaQzrOvA/qBD5AJuLKo3aLVr+C8xwqo8qWpyeSI851jPg96ZaZOn550GA65OllpE2noAWgW/96m6HE/PXtgtLqdPBF0R5Rpy2EG7E8bWCilFgOQkAIhzTypb8r81tk6V1zUinZI1KBwTk0bstlvSTawopkRUAeln2jB5Jdk1HyzuV2r5mfQCIKOa9RcxXlO6zLTawHoAxR1nDSwWxz+Z2NwMuoWUWqysZ4VKfe4iYVewf7x9CZSL/zNaXuj2/3QGLgKt2wXr5DGo/jqrwJb5OQrJTRk+ar0EdVZiO1HAPB6AHdmHtLnnKfJcAFI98YLfE5+G+A76gStGGpiEEewdSBhV3NQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM4PR0401MB2308.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(6506007)(8936002)(1076003)(86362001)(316002)(52116002)(66946007)(66556008)(66476007)(6486002)(8676002)(83380400001)(36756003)(38100700002)(26005)(5660300002)(2906002)(44832011)(6512007)(2616005)(186003)(956004)(4326008)(6666004)(38350700002)(508600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Snj3JJ89dDz1TnIBWP8HD9WLKvjVlBAP+BFBM2qRHd5FnO7Cg8Y22drzzA/5?=
 =?us-ascii?Q?awL7u2FXTBH1jOFrf7yKqH49l/X9vEruFzIEU3nYdsiHBaUEIpZ91S2ZaHNz?=
 =?us-ascii?Q?hMvevSUeJS/Nhxzsml9Wq8Og+t5vgtcfkQevPwWqToTa//cjZ1jlNP4WShtO?=
 =?us-ascii?Q?UYGBFWaMEzdS9D47Dr6ZEqluuYyr7ODwX0ds4ur5/Hef55m0YY6E1tzZY6H8?=
 =?us-ascii?Q?rjJ7exatWJ+Ly7ZUzjoon79hRZvJ071vP1jHFcPcY+69JIHazu3prfVg7BBU?=
 =?us-ascii?Q?J/FPVv7t43XsJRtwpfOp+6pAv2Ior7AI6crnoA+eQ/rT4s/b6HGqfU5XNVY5?=
 =?us-ascii?Q?w6RKJK7A72Efh2hJDW3uB84xwalJr7mKoAym04mBwGg8RT54n8965adBL0hf?=
 =?us-ascii?Q?xjmqBF3Bjy2mFkKxOeeqPUR+9Df9Yk0Cf46vTel7ZPU7pwyQHfZz4edn1IB+?=
 =?us-ascii?Q?cuam7rLFwqdQmoHNZAAAUDq5gok+lfuX5sfvYPB91x2ExRMlW0K/1VWWRykT?=
 =?us-ascii?Q?mUaKetg9TJ6AUS6PdW0eRLgBjp4ACrZ/HM6eU4iVNr9kVzn0UeWFUTAnYGCL?=
 =?us-ascii?Q?7P4rr/5KWAQmBSrhBmaQfByORhiGPt3OMC6LuCtNuX7ft1qOdOoWNEle5x2k?=
 =?us-ascii?Q?U3sggBDJg/qzNAnxj9TGuhi8w0pEd0XbTOktHTgrsv8Rr0g69jYKGzs5WKNP?=
 =?us-ascii?Q?pCGaWaWLu2tOrPxHjFQVfV7vcMNshE3e5xePVHcpNKzD8Qvdrvm7DLQfOJgX?=
 =?us-ascii?Q?9smkWV38ZeSqUwqqG7c6Gq+O+ocPC6Hid9iYk///e0BW8YqzkvjQEHPhXw5B?=
 =?us-ascii?Q?LGurehT52KAgse85vZOpaqoZQe9xRd/AFanInZBCMWvUYGNDZ4yyTWM3IydK?=
 =?us-ascii?Q?R8jhNwMLBnDUknbEkjQCK735wO6O8TF97wosYRqH4kY/02hvCLpQSPEJ1u8M?=
 =?us-ascii?Q?DlXFUelAkGuDzvkQk10N0bnKwOq6Owg5uU4GirChT4+xIKiWt95q4RGciLq5?=
 =?us-ascii?Q?jyaAB5lm+rUF1hUj7BeSTheMCfikBRXt/dZYoXNSarg3P2/y7xLnpONC1j+d?=
 =?us-ascii?Q?wGoWvEVWCUClaZyMDe9SNY/XD4dBgChrt00HljgfHsNBirhklWuRMJPxvmLb?=
 =?us-ascii?Q?LkRBpuFqd8kxq+aOOL2TGvfb+3A+j+h8nDjZHwZ31wW3dIQpd08ywhNXJKOt?=
 =?us-ascii?Q?hk7PYu4mKSk7KNrBh9gB4LDZa1ieQK9p9lPu6DOdZB537OG6CDT1bXTPqjY5?=
 =?us-ascii?Q?o+8ckvhRBTAdzIRqoTlIWaEFORZtVEb6+VCgkzakOqpjbo6iqEMfg5oZfhou?=
 =?us-ascii?Q?qK9VDLgQtmE9VVh4G/zM+isR?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2323a99c-ba49-41b8-6cc2-08d989a787e0
X-MS-Exchange-CrossTenant-AuthSource: AM4PR0401MB2308.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Oct 2021 15:31:28.5949
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: s2ntTggisyc+DZ53mRPwlywaxyeHnhJBptvh3etJ82Vk0+xNJlWJrlM5qmmqWjz52/rEbL4yhmMZf2saaelZLQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM9PR04MB8212
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series adds support for driver level TSO in the enetc driver.

Ever since the ENETC MDIO erratum workaround is in place, the Tx path is
incurring a penalty (enetc_lock_mdio/enetc_unlock_mdio) for each skb to
be sent out. On top of this, ENETC does not support Tx checksum
offloading. This means that software TSO would help performance just by
the fact that one single mdio lock/unlock sequence would cover multiple
packets sent. On the other hand, checksum needs to be computed in
software since the controller cannot handle it.

This is why, beside using the usual tso_build_hdr()/tso_build_data()
this specific implementation also has to compute the checksum, both IP
and L4, for each resulted segment.

Even with that, the performance improvement of a TCP flow running on a
single A72@1.3GHz of the LS1028A SoC (2.5Gbit/s port) is the following:

before: 1.63 Gbits/sec
after:  2.34 Gbits/sec

Changes in v2:
 - declare NETIF_F_HW_CSUM instead of NETIF_F_IP_CSUM in 1/2
 - add support for TSO over IPv6 (NETIF_F_TSO6 and csum compute) in 2/2

Ioana Ciornei (2):
  net: enetc: declare NETIF_F_HW_CSUM and do it in software
  net: enetc: add support for software TSO

 drivers/net/ethernet/freescale/enetc/enetc.c  | 317 +++++++++++++++++-
 drivers/net/ethernet/freescale/enetc/enetc.h  |   4 +
 .../net/ethernet/freescale/enetc/enetc_pf.c   |   8 +-
 .../net/ethernet/freescale/enetc/enetc_vf.c   |   8 +-
 4 files changed, 317 insertions(+), 20 deletions(-)

-- 
2.31.1

