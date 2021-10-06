Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EEF084247C6
	for <lists+netdev@lfdr.de>; Wed,  6 Oct 2021 22:14:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232096AbhJFUQG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Oct 2021 16:16:06 -0400
Received: from mail-eopbgr60043.outbound.protection.outlook.com ([40.107.6.43]:61090
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229992AbhJFUQF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 6 Oct 2021 16:16:05 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Y3lHEwBA5KuXjHY2nVpkG6woy7ut0oHGUZDaJa5jlJEy6b4fXosdIPYCFvx8Z7lb0nFLBAY23/SIpetqymk2SmjutyY/XeMRqNVkQb9120fYtMiVFWo7k7IL/ojxYzZSVpAr1hMNRH+TNI3v9w5rtiMmXUK9RsqAn/q2rhTvTj4XULaHnpK/UmReCOjhcA77AZUroy0uta2QPyfjLq4btiDkjaKkD3RoFfmltH0EuTQuIoZPzUnboSeki+kKTOFN0lxH8EfPGLSla+1TCItsi+/DJxEv8mOmuKr8XwSwLsD/o4VQnJAQSAmtlN6hWeMXJe793mi/Oiv1Wo2iU2WDgQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=px2bxEKNKOgX6/zoI0bw7rFO/CQpRj/xOkV2IWT721I=;
 b=gWeLa/fidy32kHTDQRmCQf7nraG+0w0879fH0U66ND/oojE0XzVQ098JOKX7opX7apQHZSEqSmWJqyMxjR2uVIuplUrvzUrbIdGMnYbVeM1Lp2vmuDv9X+70WcXcyYnKwRAoN7GEITtvU2/qHEZeCtgqWoFwKb/cdDlQO2K1ENJB8s0ewqEqST45ruhBHRfUwmCu6vuJ5hvG+o+XJRSKJhZ2x4BZos49mTtmYdA/Nt9M06iM8gP/BLsOOxl7ZCBAXQWAPdu7ZDiMa/tB2s6js+7HfmcM/gzRq3YN128ENpLsD55+lS9ZuBHrRsdZO5+mmzJ6wMQdO+6Qed6Or54xow==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=px2bxEKNKOgX6/zoI0bw7rFO/CQpRj/xOkV2IWT721I=;
 b=I8mbd9TStd1mHxrG94XFZ52nJYs9FIxaDXN/tUdf6jdkrs4+1ek5z6doirAkGekkI1ZxKHVByYn4OrQhLD86llVmrU89+ahHCp+ggAa1hzMGhsyuQLkM1gynluvZMD7ReH/h5udX9hSVTfDxIwUbOEo/ns3ZSaM3WUofyolRHoE=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=nxp.com;
Received: from AM4PR0401MB2308.eurprd04.prod.outlook.com
 (2603:10a6:200:4f::13) by AM8PR04MB7297.eurprd04.prod.outlook.com
 (2603:10a6:20b:1c5::13) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4587.18; Wed, 6 Oct
 2021 20:14:10 +0000
Received: from AM4PR0401MB2308.eurprd04.prod.outlook.com
 ([fe80::6476:5ddb:7bf2:e726]) by AM4PR0401MB2308.eurprd04.prod.outlook.com
 ([fe80::6476:5ddb:7bf2:e726%8]) with mapi id 15.20.4566.022; Wed, 6 Oct 2021
 20:14:10 +0000
From:   Ioana Ciornei <ioana.ciornei@nxp.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, claudiu.manoil@nxp.com,
        vladimir.oltean@nxp.com, Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: [PATCH net-next 0/2] net: enetc: add support for software TSO
Date:   Wed,  6 Oct 2021 23:13:06 +0300
Message-Id: <20211006201308.2492890-1-ioana.ciornei@nxp.com>
X-Mailer: git-send-email 2.31.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM9P250CA0015.EURP250.PROD.OUTLOOK.COM
 (2603:10a6:20b:21c::20) To AM4PR0401MB2308.eurprd04.prod.outlook.com
 (2603:10a6:200:4f::13)
MIME-Version: 1.0
Received: from yoga-910.localhost (188.26.53.217) by AM9P250CA0015.EURP250.PROD.OUTLOOK.COM (2603:10a6:20b:21c::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.22 via Frontend Transport; Wed, 6 Oct 2021 20:14:10 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 173c8f45-cd04-402c-0928-08d98905dbd9
X-MS-TrafficTypeDiagnostic: AM8PR04MB7297:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM8PR04MB72972618194095CA5C924692E0B09@AM8PR04MB7297.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +n61XX+cVXZbTHZgMIO2mKsbGVF/jAtmB6jAby451MhtFFKcsNZFoarJmxmn9YxV5qcrRMTCt3SYmnwkqms3V7FQuvdnqlnii/asVY+tp1/8qFOSGcXN+addhC5WtSPgepGIUvDDy1ZX9LU4Evp63CioJAhKT/bn16ywbWR8zUOsL+8P5GvwIIwUA+E3KpBfWqpU8kuR/MIRCLGSSfr8oPNfVonRp7G5ucJESb0mm3v8xUJfECGhRAeD0xNsPXJ+lYgxbGc42GYIBhbANvII1e30pK62yJ26pYo104t2G6PgMKq57q8+AJDKmP9+YmMJnz6trJ1ALc2HuyJCZKSdBH/XWCwR6LqkGmxfQMODcig5hJ5tFmLzIIqv2OJPc6ZHhmMwsnJ1lu8hs+yQk3hCZ6ZfcxOkMXve0Xj9yRO0urR0d2U1XrKTm+UFIYNA/0nrEVOq3V/y67GfNdBdveVxq/5ZVuN7VcdBrHrObOookRaUdsynW2GwloVa/vf5kcghH1SxmlKnYikh3Soud6rX17kJ15XWIgvFy1ozsq7uIKNWLxRxriTqfnczTZkzbO988e/8jdvcTmcySc1JkeDvkTZfdkfLSbMEKTpKYDpm2I49/y7zV8oKDIc9lBst7xIOkVOqxR72WNUanYRkB5AMI5NX7eo8owqcNQC8jF2bO/qJFpcwK1LDa9KeRj5KMABRTGbgVU4blyrblo941v8DYw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM4PR0401MB2308.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(956004)(66946007)(2616005)(52116002)(83380400001)(4326008)(66476007)(66556008)(316002)(508600001)(186003)(6512007)(26005)(6506007)(2906002)(38350700002)(86362001)(38100700002)(6666004)(44832011)(8676002)(36756003)(5660300002)(8936002)(6486002)(1076003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?FI8FctWmdqqYi6NdtZo/K2H7viBQ5d2IsjHWWAhze1WOVIIuOmIj+q0PO29v?=
 =?us-ascii?Q?OKy2rQN54XdM7TS98eIgCC6HOcGyGX9m2JtrTaphYYvme48cxxubgEoqTYbT?=
 =?us-ascii?Q?0EdaCvIL/VJ2/eIW1cEvivBoX8JePi6tXA4TYdH2l7yWrWwxrpcr+zJhjb59?=
 =?us-ascii?Q?TCG60qDnIHmOHMIrViWUTTKvRybNfpmLUG/EYotmlNLtrN5MOfDtLeMrT/zU?=
 =?us-ascii?Q?nxqpHd+2+oa9OLg5QZlgTuOIAlxaeBnNRumHZKPzVOnga0Rbjh6MCfSowpai?=
 =?us-ascii?Q?V21pcjRnlVuDNXIOIapVi2/TJjmfFM1BqhHl9oAa5ykM4a1g9ZSA/8RDwn3H?=
 =?us-ascii?Q?hEZJTfjjEge6fe87vtxvHlCbFsVCeRaMkvQErRVQD+rzf4/jVoXSYqa1jK/b?=
 =?us-ascii?Q?2WMMlCmrdm07minDAplAYKJBfgONkzpXHfybPEH2RbbpvZwA6X0rIEg+cjx3?=
 =?us-ascii?Q?zD7iuJPKP8BEgk/1rvWmRQLhtW13wOId6NbNhjqQkJKWUK9SHKuyQ1HobSiI?=
 =?us-ascii?Q?KxTzGyJyz+MNqhvbM9qdVui8UkhNlHr1TbD7lzR3f8BCkUL1VWJj+MaJrEuU?=
 =?us-ascii?Q?LfrX7kQlaxS7/A35azJbsWmYbsL3vp5M5H1iTQOzgmczk+2MxxdNE2E9bhU6?=
 =?us-ascii?Q?3SX9sUWgPHcs3qnPdJmPxltRJmu4UWXRivw3HMNZLsrnr8G6rdo+AjNCaqnc?=
 =?us-ascii?Q?HhP84KPE2pqcPKK8jdszr8JiXcIqoIStSL+UHXNA7++cSO7+NB8xgdjdDgkM?=
 =?us-ascii?Q?tbjZ1s0Bp0Qyw74RavE33O8t9pD9pKJPnbhAwujSWOEjjlKJkaW8qB3ILONJ?=
 =?us-ascii?Q?HTZhDt0s0OVoz0S0dGqcS0T6SJgxn1t285HrwzrVoGraXNZ1vRZf4zwaTSc1?=
 =?us-ascii?Q?euGC1bH8e0R/Jgb9ciJMQPMApN2wxGXE3L3Gy6ygfNTDsQUXb78EMcg2Y0/0?=
 =?us-ascii?Q?Wf4pO6Xc2hRssAYqrcgbVf9rxc06XHwoFWdLaoylrMdLhfcquFmziwFRfpOT?=
 =?us-ascii?Q?JT5YXecT3KoQAxB9dyHoxBf5BaknFHCJoMSX/I4ZdBStrYrHXgbGgMONzHy7?=
 =?us-ascii?Q?UJa0bnwEZLDtQ1QT67JXHikLZhW848tof3z1uHqh47//mM6GmDmT2k93QsbR?=
 =?us-ascii?Q?MbzmdXbjtL4p73VEa7MjIXDwZwwEpTLIZJzyp+Q8UXYcsB66vyT29kFC3PR1?=
 =?us-ascii?Q?+rIsvfRYUBtiUvbdAPUEXkiFh8KHPjvyGdkYhJ7AW0x2P27vwE0v6udhu49r?=
 =?us-ascii?Q?6p2UltKBjax+6PfcGxnSjbcU96f5PG+XAKQiQLH+eXmKDvH7gfZEyOFlvUkN?=
 =?us-ascii?Q?OnybJsYRXkn4RrRUb7QwMibh?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 173c8f45-cd04-402c-0928-08d98905dbd9
X-MS-Exchange-CrossTenant-AuthSource: AM4PR0401MB2308.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Oct 2021 20:14:10.7341
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kCjjO4QMIjeC7jx5myuzsqukiTHKvLWGBRrWhGEAf7CJS1lLr59qNwDmokWXiakWrw7Svq/vH6rZWSz9o8WS5w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM8PR04MB7297
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

Ioana Ciornei (2):
  net: enetc: declare NETIF_F_IP_CSUM and do it in software
  net: enetc: add support for software TSO

 drivers/net/ethernet/freescale/enetc/enetc.c  | 272 +++++++++++++++++-
 drivers/net/ethernet/freescale/enetc/enetc.h  |   4 +
 .../net/ethernet/freescale/enetc/enetc_pf.c   |   7 +-
 .../net/ethernet/freescale/enetc/enetc_vf.c   |   7 +-
 4 files changed, 279 insertions(+), 11 deletions(-)

-- 
2.31.1

