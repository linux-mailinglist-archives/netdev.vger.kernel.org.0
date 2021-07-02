Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 74DC73BA3EF
	for <lists+netdev@lfdr.de>; Fri,  2 Jul 2021 20:30:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230157AbhGBScU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Jul 2021 14:32:20 -0400
Received: from mail-vi1eur05on2124.outbound.protection.outlook.com ([40.107.21.124]:46816
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229455AbhGBScT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 2 Jul 2021 14:32:19 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ouwc2BaIjTi1NFZsyQnGp7/cpo47voJxJF7wjn/NCuitvYO6ZKEjJ530S1uKU1EVyXA3LAOqn5LJP6G1Houct1GaF/6LUx8JfXwIiuY9LC5mCiu2IH+bLnFklezM1Fzx/Zj/vRTbBJ+yyrg1DWvEfQlXjOIZtppmREhj0y7v/5wULt8sedZ/rpasPe1vaKnBBz6eL+soOrYWJ3NwInKPLyJYjD17QKN7znVMIFGQQhqOISGoplXcQodBly1hYCuvf3QlCzjPHDasG7QFfzxDF4ds+Aesmq0FeNSUlzRNqzzC27xu1GXlb1bqSRLvWcm78lJUHiC+TNIxTvbofBlJVQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Updd4LK5y+Mb4J3QtjY2wJ+YrGUTiwmZqwpNzn6iIrQ=;
 b=np/rwfmtBpDF5HxCAI0TVqiCaIT5VrGG4CfgDsl8JUfVROdPAhUsgGu1FIjCe449hM8N06WVCBprILfAIfB5pGd7UBLMPaXvVMitJKD8NVODWGcfprvp5RwIJJEdn3w9BL37IGVLcpLtg5ul9lwKqdLHGLQcsF7nMZrKDtmd9ENbBKLNUsOyKgyKuQKNrOlsXehX5WRF5hjgRo+O3gxh+QO5XzlpbZ/D5RVSjDU33rYRadRJ7T/Z1MgYhaiTSMmXq/464N7LNIFwQZWg3R7rZ2DU3kx9MolJYHNqkk+yXDafvrXIGdLtvTOMag3hGgPYwL9jc13TqqzJQ8jTfLnsFA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=plvision.eu; dmarc=pass action=none header.from=plvision.eu;
 dkim=pass header.d=plvision.eu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=plvision.eu;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Updd4LK5y+Mb4J3QtjY2wJ+YrGUTiwmZqwpNzn6iIrQ=;
 b=ykbU4ZDzF/xYbQZG9R1HiTdnRpZZ/hkAlfzccZPcAufnw9psfRSXQABq260NggE+6DW1mVDzKdOCvjFgTnyPG1LLP7tyLnJ7cc05cVhoWrtfLSK11f54ExQxFlavA8OOwrVZSKqwZA2eZxD6ODq7CnAA5fEbOovU8nP6XbeeZkc=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=plvision.eu;
Received: from HE1P190MB0539.EURP190.PROD.OUTLOOK.COM (2603:10a6:7:56::28) by
 HE1P190MB0394.EURP190.PROD.OUTLOOK.COM (2603:10a6:7:62::31) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4287.23; Fri, 2 Jul 2021 18:29:44 +0000
Received: from HE1P190MB0539.EURP190.PROD.OUTLOOK.COM
 ([fe80::40d:b065:3aa7:ac38]) by HE1P190MB0539.EURP190.PROD.OUTLOOK.COM
 ([fe80::40d:b065:3aa7:ac38%5]) with mapi id 15.20.4264.032; Fri, 2 Jul 2021
 18:29:44 +0000
From:   Vadym Kochan <vadym.kochan@plvision.eu>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>, Jiri Pirko <jiri@mellanox.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Volodymyr Mytnyk <volodymyr.mytnyk@plvision.eu>,
        Serhiy Boiko <serhiy.boiko@plvision.eu>
Cc:     Vadym Kochan <vadym.kochan@plvision.eu>,
        Taras Chornyi <tchornyi@marvell.com>,
        linux-kernel@vger.kernel.org,
        Mickey Rachamim <mickeyr@marvell.com>,
        Vadym Kochan <vkochan@marvell.com>
Subject: [RFC net-next 0/4] Marvell Prestera add policer support
Date:   Fri,  2 Jul 2021 21:29:11 +0300
Message-Id: <20210702182915.1035-1-vadym.kochan@plvision.eu>
X-Mailer: git-send-email 2.17.1
Content-Type: text/plain
X-Originating-IP: [217.20.186.93]
X-ClientProxiedBy: AS8PR04CA0108.eurprd04.prod.outlook.com
 (2603:10a6:20b:31e::23) To HE1P190MB0539.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:7:56::28)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from pc60716vkochan.x.ow.s (217.20.186.93) by AS8PR04CA0108.eurprd04.prod.outlook.com (2603:10a6:20b:31e::23) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4287.22 via Frontend Transport; Fri, 2 Jul 2021 18:29:43 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: bf5b6edc-a36d-4951-7c74-08d93d875cdf
X-MS-TrafficTypeDiagnostic: HE1P190MB0394:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <HE1P190MB03944C62D15564195D8C2EBC951F9@HE1P190MB0394.EURP190.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: nQbG0K6zmLz44PUqEOGla1alTTvl0BoIy153toEiDoe47TYyZZnKkpowfJ3Bh+2HUaSuvq7NXmDwJtKQH+7ZLp/lPvsi0X6coU75WwX0lo+ssy/c/PLfeLCMKcpUPIifRIu+8btmoQ+r0DGvyoBxDk82FKlSpPskxLuIWCeZ3f30gLU3t08LhgYKk4ztJuLy3zqMZ+WUAlmCSVqRwgnoIyUFwFqF847qFsiHQVrHxhcTOxp4tDDpS2JnpuEucLzQPMRzRyRih6yRO6uALpohz3tCv9qmxHTyWe2x3jBpWTOG6FxDRc1NURsZM6OXRRRxggUq4MCU2l5sO/nGqI7dt9Qf7JGjapTXc8evx+83ZrE6iB2vpoUVk4/uTvAKg2temSm0lvNoqT7sYuCfsd4DlWvmGMwavObVcMsbe5oFwtl1aRrWKIN/90y/n5CmyBw4ajd2L7+MsihXblncogJxmdkTRw4n47OYtamnvGeichWeqgg2eMEaK/4qXkuYBVdPYeSdyO8NeHRYZu9U81kOJjDbta2nAB84BFihfZIGON2XJ6h1VBfxshJyG01rPKe3OVkFZNYkElEtijBWtSXfFZ/XM7fEGI7PutUJVJNyUEz9UVDc6EjCFdxMfRVUya5p4BtqB+W95Z5kfOTRoAssWnm3/XDx9J7ujIhcztxx+KzWaoOMUpkQJHFApRPmQpS1YFI6xT1rHr3tIzd2OsnMAw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HE1P190MB0539.EURP190.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(39830400003)(396003)(366004)(346002)(376002)(136003)(6636002)(7416002)(2906002)(316002)(110136005)(54906003)(44832011)(2616005)(956004)(38350700002)(83380400001)(86362001)(6666004)(36756003)(38100700002)(66476007)(4326008)(1076003)(6506007)(8676002)(8936002)(5660300002)(52116002)(16526019)(66556008)(6486002)(26005)(478600001)(66946007)(6512007)(186003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?/0nsU6rgKRw/iD+Q9RTwmaCSbXthuwFklY2dttZHspie4HFAeQXGjbW54wpN?=
 =?us-ascii?Q?kW7kCpQNBAEmFoyPHh6C43dfV+0WUENhgLQfC+PdwBlIcZugaqt2czT8s6Wo?=
 =?us-ascii?Q?erccYz7FpK0EXuykaIJIFVCiZOYiuWcUvVeR7DyswOM1cW9yr2iVdLM/A4Bl?=
 =?us-ascii?Q?YP13gzE9h5bw56FWZMGcKy43Tx8ZbuxaKsctQfQCIfz/iZGcAZqC7m3uuwjz?=
 =?us-ascii?Q?IhgrHcBcpnGVKMb+vpazvPzTm4Sqhsz39rHqLB8x3fxXXlWegTiau2c+zu2C?=
 =?us-ascii?Q?eMHw5O5XHpHl2m/TkVeu/lTuYilMMmsfWp1+mJJM/2yvguX3MoaXE9BsWu5k?=
 =?us-ascii?Q?jr8/1V7beMlmzLYmGVHhZHTZD1q3yViVU8hnyl2qTLZCf/YubgdoRoH46EWm?=
 =?us-ascii?Q?hq/+iUZRsWEqTtGt39yhfAJW1qlAKzjzTaWus2m0tu0fj4nx7CkPacgY/wl0?=
 =?us-ascii?Q?msENjxwT4CTyzBRVz1OR77r67cOmv9OmCaACI9Ppptl8iXT/tqVHUuLGcBnK?=
 =?us-ascii?Q?UtpwXFpOKY/fIO9PE6Mgb6JUFAnXgxKjdj0AMM9Qxjw6FKvf86Vbr5/52ZBC?=
 =?us-ascii?Q?xsQTC+CbVw7KMoA5Ncs99QOSVRD7qeHbLFb2KRRUxVv8Bz9r2TJ6GoOqYpMD?=
 =?us-ascii?Q?KtlSdDVOoVqhgsvyY34aRVeTd/xUf3KwO/BUYdxJrgnyKhhkVArEJugOuVb/?=
 =?us-ascii?Q?vFroR/vS8aSFVy8xL3JHuDEznkHX+Ry0P1Ruccc/97VHqyzxlPNAX+kWBoBm?=
 =?us-ascii?Q?9xdVxGKzYBvdYY99Lyu+W4rHzFkurtwse4H3khIntweKsj8T/SJjXCDBln2S?=
 =?us-ascii?Q?bMRBRTdtps+7F/AtZa3b7wxv8szuNxPn80YqFC4PGq8RAoTG4sH5ndEOyZOa?=
 =?us-ascii?Q?kOPP3H5yws64Mk3azEgoMjntl/5rX31OH6eFxtnC9iw8acWZZCnvHQKVaJSs?=
 =?us-ascii?Q?av04oT0hFhM4qI2tUQC1i+aGGuhzbUVsxlSTk7O883k3QaUoJzwEQqv6nlAZ?=
 =?us-ascii?Q?vJ4GQdORbD5KwFH+8WZSZGe/VQRcWxPbzGsyCjxXh6Uo9tjGNWeyC6kUbuX/?=
 =?us-ascii?Q?ULYCcGFSDTPAjXIH9Qt4laTX8BUKhOMx6prKcd2h+5ogUcGVMft0riuZV4bv?=
 =?us-ascii?Q?n/IfJzjJy8ZE24qFgVabQcFwY6UD7Ly7iKNdbXIEKdkqrGyCd/uGMAH1DTqJ?=
 =?us-ascii?Q?j4aekfGZSB9sXKB9gos/KSWC+CGwreoO64rLyJqb05McWCdf9btol9kIemTq?=
 =?us-ascii?Q?q4h031id9hRIazm/DdR8yQleuBMcSVXgB4bKKfxweV5Zb/kYO9zrlyyMm6YM?=
 =?us-ascii?Q?8InFX5+Js/NhQXVRTsRqsxa8?=
X-OriginatorOrg: plvision.eu
X-MS-Exchange-CrossTenant-Network-Message-Id: bf5b6edc-a36d-4951-7c74-08d93d875cdf
X-MS-Exchange-CrossTenant-AuthSource: HE1P190MB0539.EURP190.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jul 2021 18:29:43.9964
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 03707b74-30f3-46b6-a0e0-ff0a7438c9c4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: IWskUsxx8gTMVtEZorB6B9N4dTCww+Va5KXLucHknYA1Sj10qSG4l9moF6d+7waf4Zgqq/rBOZ64XYim4LfpUzNx4u/sb1rA6YIQHDOBjJ8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1P190MB0394
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vadym Kochan <vkochan@marvell.com>

Offload action police when keyed to a flower classifier.
Only rate and burst is supported for now. The conform-exceed
drop is assumed as a default value.

Policer support requires FW 3.1 version. Because there are some FW ABI
differences in ACL rule messages between 3.0 and 3.1 so added separate
"_ext" struct version with separate HW helper.

Also added new __tc_classid_to_hwtc() helper which calculates hw tc
without need of netdev but specifying the num of tc instead, because
ingress HW queues are globally and statically per ASIC not per port.

Serhiy Boiko (1):
  net: marvell: prestera: Offload FLOW_ACTION_POLICE

Vadym Kochan (3):
  net: marvell: prestera: do not fail if FW reply is bigger
  net: marvell: prestera: turn FW supported versions into an array
  net: sched: introduce __tc_classid_to_hwtc() helper

 .../ethernet/marvell/prestera/prestera_acl.c  |  14 ++
 .../ethernet/marvell/prestera/prestera_acl.h  |  11 +-
 .../marvell/prestera/prestera_flower.c        |  18 +++
 .../ethernet/marvell/prestera/prestera_hw.c   | 125 +++++++++++++++++-
 .../ethernet/marvell/prestera/prestera_pci.c  |  63 ++++-----
 include/net/sch_generic.h                     |   9 +-
 6 files changed, 197 insertions(+), 43 deletions(-)

-- 
2.17.1

