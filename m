Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 06DAD5F13EF
	for <lists+netdev@lfdr.de>; Fri, 30 Sep 2022 22:44:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231547AbiI3Uow (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Sep 2022 16:44:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231204AbiI3Uos (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Sep 2022 16:44:48 -0400
Received: from EUR01-DB5-obe.outbound.protection.outlook.com (mail-eopbgr150054.outbound.protection.outlook.com [40.107.15.54])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8370310D3;
        Fri, 30 Sep 2022 13:44:45 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZLlNEq11mg6jzmb9al+0aYMRycpmZjdAapu0Hzil/netycXKnnQ/PVsPCNK13n8Y9gHjGK5zsXw/1KGfz3ga7UcrukKEBsn6gzcDznGBKrIade7wfoMaTG3z8yXsz5iWXPJ0AENVDAwyBAY5LHpdnRXO7IHPmCABn4vIAR7mu02IbYTno9Kms6M4isPZO79gvkCfZKTlRKKFf2Omc2fa5Jt5j8/ZJmjzpNbZYmS6TxJ3/RDiIhpQ0MH5+NxOHPtfG7lHFlLFCJLOrJ8wHchwd62l/Xrx+7tztE2u063nQ/Oj17z83+k7S9E+pEtcZ2vWO/t4a/sTGTFamDhltiKwcQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Na5HY53Xo2VNx48qrcFZKT1F6e8/rpKlySPs48w1fwo=;
 b=fyeGxosnyZJ97+L+pnUYG6hRIMQECjxCkjQu1eeBr7pW+ERxOMObN3DpphK5BfPh80IkG3UnFZ46XEGviq24vMcj+E//YXCSUZf4ix52B+3asHFqBfyRrF5PBMghLdxQFAV0C4cjPgrU+pddYWZ6fMQWejnJXtXVE6gpvahcUzFOL4KQn9QCdUvosJzWCgFxtJgBCvKluns5YhKQfD+Oes5Tyantyl5iD+VJXQ+l2tEsRv+/QRnvmwIpAIZN0yasz4xOKyPY+v4UVUPS3ry7Q8sK9fazia5H1O6hNSjy+YWUb1kbQfoCt5nGvc9bA1kZJgreKc2aCsggQ2587BnaOA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Na5HY53Xo2VNx48qrcFZKT1F6e8/rpKlySPs48w1fwo=;
 b=qUTIEOtVjQeutShB4nBMHlQe+FfpzGolZ+Q41SHe8vkxloWgtpEUN8EVIDNb/aqlwnupO3lMBWqlatmJJ+q3u0FbdlDij+ECs9JjHoeLsGKszsMnlSmLLb6OrVTYTqoDqZaVK+adUOXYx46LhluqGk+2lUnAq6b42BU3+IzRtfo=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from PAXPR04MB9185.eurprd04.prod.outlook.com (2603:10a6:102:231::11)
 by PAXPR04MB8335.eurprd04.prod.outlook.com (2603:10a6:102:1c2::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5676.23; Fri, 30 Sep
 2022 20:44:42 +0000
Received: from PAXPR04MB9185.eurprd04.prod.outlook.com
 ([fe80::a543:fc4e:f6c5:b11f]) by PAXPR04MB9185.eurprd04.prod.outlook.com
 ([fe80::a543:fc4e:f6c5:b11f%9]) with mapi id 15.20.5676.023; Fri, 30 Sep 2022
 20:44:42 +0000
From:   Shenwei Wang <shenwei.wang@nxp.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Andrew Lunn <andrew@lunn.ch>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Wei Fang <wei.fang@nxp.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, imx@lists.linux.dev,
        Shenwei Wang <shenwei.wang@nxp.com>
Subject: [PATCH v2 1/1] net: fec: using page pool to manage RX buffers
Date:   Fri, 30 Sep 2022 15:44:27 -0500
Message-Id: <20220930204427.1299077-1-shenwei.wang@nxp.com>
X-Mailer: git-send-email 2.34.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR05CA0051.namprd05.prod.outlook.com
 (2603:10b6:a03:74::28) To PAXPR04MB9185.eurprd04.prod.outlook.com
 (2603:10a6:102:231::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PAXPR04MB9185:EE_|PAXPR04MB8335:EE_
X-MS-Office365-Filtering-Correlation-Id: dbf06bf2-1b4a-44e3-c2d2-08daa32499cb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Dk1LRo9MOUVDG9JP2H2MKkBDqhh/it7Ph419MtH1hZ6mlzjHYup9QBu1uuQr3uWCNSkPNMXjI90j0M9dIs9euMLZ5GlBVPttPUFq6xc52MXiSivzOI8EFQZGm+J62kv7QbkRNKYtYKhVxPCWpBAYs8xbSOs1GgGfUE4Er9f1Q/WTEKHh6j+WB7oqupjA9EXiG4V7w0BRiHIHxaTK/rSJnuXWerX4FsiW6kx0T6MDina4sjD+fQvNO3nkwRrA5I4V60iCOv8XxFkzJyA99/4wpdMcjuvqBI1GqS+DIFg/cS1oHwMCDaopWftcvv7mAruRQKQNebcx0Qq3laURzT0FYDRScEXfqfbvnhAFJKUWiC+F2vgGMozg1EOT4W9uhquc4vtD0P6dDYkSS30RXHC+49z9+ib0KR8IBvYLxjUs1w4fIEO8ECJWoQmmU4O8Qt7PbrxpQrAQKvq0XddoWIUUE92IIvoRHTs6sfBBM4IGGjptxEoKe4gNaBwLJvSRk++SNsGDBK0W9kE+1NSZ8kkmhf726kXbxc3dZ3NrMnmmxc4xiPaVI+VDDSRQpgIPPKxRnnoVQxLTji9/9a1llnCz5oSffCy3nwIevnAJxdK7u+YYhIxFobOMoWRiWwc+nbe8378obpMaCjmDR4sCWOoYTHCWtNswtJAOsuuI42vfFEFN7Xv7SW9pR1AQ61/ggkve2Ee1K2Z/7bnH+IWvspTij8FKb7WqD0uQLCUE4WBkDAGIYJ+X5/4HdpyOmcukMlR3cfClaHmcnAy3t/kDJwwAXg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PAXPR04MB9185.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(396003)(376002)(136003)(39860400002)(366004)(346002)(451199015)(5660300002)(26005)(6512007)(55236004)(41300700001)(6666004)(6506007)(8936002)(30864003)(7416002)(186003)(52116002)(2616005)(1076003)(83380400001)(36756003)(2906002)(38350700002)(38100700002)(44832011)(54906003)(110136005)(6486002)(478600001)(8676002)(4326008)(66476007)(66556008)(66946007)(86362001)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?K/7Od2d+anFDb4fN8TZYkSFD08aIL8eqiXwmOVS/+UfZSalFFzwhZRyeipSj?=
 =?us-ascii?Q?sdPGCjjEjeMWCNXtIugQadPI1y0xxqO+MsD92FFV6wlQa9RXx7iHcXNcxNWf?=
 =?us-ascii?Q?JDUz7isLwKH37zdcB/fXLwU+zW+E7jcQyJLgd0dDnKV6ewuBXqaFOqfbW8ns?=
 =?us-ascii?Q?UGBt3YVp0GS7owE6hZUlAsW/qiyS3bYkT4gQeR0b3Oev/J+k8hQHixhCaFui?=
 =?us-ascii?Q?kHBO6yEuFa9A/CM2Nn6+yaR9/yY+usG6BJWpVVFHqcYTm02V8WYUuPQYoO84?=
 =?us-ascii?Q?GY458cxfkh/Ikk9XgT8Sb1iT7uG5LyR8ZKH75CzP6EfAn3d6nUyJo2kyfiG0?=
 =?us-ascii?Q?qeeEVo4FcamjpJyyO2MYdp71ladPhvNjVKag5MH2vDy5o5RXb6pKJYVTF1ot?=
 =?us-ascii?Q?EAfQChrz9a7yNFelkqMo8NiKgQONs/0rmDirFUxX1xNdCp/ZZKdP8lfknfWT?=
 =?us-ascii?Q?I2/zk3kEDpFMGkZbDNVM3moVz2X+q9vTfUJfM/1S1soeyx+clAukHUOpABdy?=
 =?us-ascii?Q?H3wdkXp5eLY26Ug5cRU5nLPFYzVWR+I/QH/3RuylZIohw2A+08cZAQSGtg2w?=
 =?us-ascii?Q?O97jF0fo8R8+EXBfGTCxn/Y0pSYXHSsmkOvMggDXAVFVC+xxm0PIewRzx726?=
 =?us-ascii?Q?XQAFH4j1JLN5fUnejRqBD9/GJs57IGSL5341MmmDeFGrqWjQ80C6F/52B6xS?=
 =?us-ascii?Q?NVKbo8Rw0c8bGEhAryXOMS4icBy5twLDdfrH+eI24lJRvS9vV+6g5+vrkFGn?=
 =?us-ascii?Q?7byzHyZCCIqL6tBapY2NaMYC65tqUjGA68MRH9hh0o/l20RHYuj/S0YA8Oof?=
 =?us-ascii?Q?+3lzNNRdFs00e5GqFtVzdpAXgvNeszMrAVzGJoHIXg1WZL1Pa0unmeDq4nmd?=
 =?us-ascii?Q?gGpAY6KecBSyAV7ap6c0BeiueZ/ryGP1hoJ8rVGB/qmNiKsKn7dXsl+O655m?=
 =?us-ascii?Q?VUjyo+KHxYpWiuAa1Te7CCOwdwP+AA2PrzKHF/xLW9v8I3BNVQkO1qawXKY6?=
 =?us-ascii?Q?LVj43qq4Y57sRUBgr6/1Af2UagFgwrQnjeayTK4/36J2vrmg1CT1lJlckrPf?=
 =?us-ascii?Q?B8T+ONZ91uDxB5m1FJlnWtl46hGQALEKyo/zbv8+b+wVm6jf3oshNdk3AHsM?=
 =?us-ascii?Q?ltXLYu/b2/ZJb87E7V5UHa9wkRrAW7EDpjbV1QWcTsb/dgucTualEYKsBAUp?=
 =?us-ascii?Q?cmn+kwzqZu4iooxdBBuiJ1ECu4mlRjZNKQE76yIjo5veOiiXYh9t4J5Qc7ZP?=
 =?us-ascii?Q?VgDIp8QqF1fJG7C7co3Kn8rqpcZmj+QRWtNRAkvCD3iM0vmst4DOh+Yg7T1H?=
 =?us-ascii?Q?V3sjTlDlgp4H5YlaK6WE2elGAEK6UK3F62EJBSEJQPuyeJw+NtTgU3HLiKp6?=
 =?us-ascii?Q?jQBcNEggNxOH8icxj8cFwJr6pkQHufHLb+nBpdlysJntrkiy2BEvS6Tuwyuf?=
 =?us-ascii?Q?4/blyXhvcB/UtU/MpEztzTxSsAENMpH+F+ub5SbUmP3G10fCFqDpD/APOrpb?=
 =?us-ascii?Q?rverKNoGS7NkIfGm/gy5W6Bx1I+aX0jMuG8zys1Jh5pN9zaR2XViaA1Cnqzp?=
 =?us-ascii?Q?MNlL7qRAv1ixPCS1Dvb3m1ZXsX1MGogSHbEsNDA0?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dbf06bf2-1b4a-44e3-c2d2-08daa32499cb
X-MS-Exchange-CrossTenant-AuthSource: PAXPR04MB9185.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Sep 2022 20:44:42.3263
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: AlTpxc0yYEb2GFm7EgIfR/1vLZkJB6Xmz0cI4u6IJek+LBmKS6EJ5ZzOjewACvEX2j/63GWY5/LYiDOlCpOH+w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAXPR04MB8335
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch optimizes the RX buffer management by using the page
pool. The purpose for this change is to prepare for the following
XDP support. The current driver uses one frame per page for easy
management.

Added __maybe_unused attribute to the following functions to avoid
the compiling warning. Those functions will be removed by a separate
patch once this page pool solution is accepted.
 - fec_enet_new_rxbdp
 - fec_enet_copybreak

The following are the comparing result between page pool implementation
and the original implementation (non page pool).

 --- small packet (64 bytes) testing are almost the same
 --- no matter what the implementation is
 --- on both i.MX8 and i.MX6SX platforms.

shenwei@5810:~/pktgen$ iperf -c 10.81.16.245 -w 2m -i 1 -l 64
------------------------------------------------------------
Client connecting to 10.81.16.245, TCP port 5001
TCP window size:  416 KByte (WARNING: requested 1.91 MByte)
------------------------------------------------------------
[  1] local 10.81.17.20 port 39728 connected with 10.81.16.245 port 5001
[ ID] Interval       Transfer     Bandwidth
[  1] 0.0000-1.0000 sec  37.0 MBytes   311 Mbits/sec
[  1] 1.0000-2.0000 sec  36.6 MBytes   307 Mbits/sec
[  1] 2.0000-3.0000 sec  37.2 MBytes   312 Mbits/sec
[  1] 3.0000-4.0000 sec  37.1 MBytes   312 Mbits/sec
[  1] 4.0000-5.0000 sec  37.2 MBytes   312 Mbits/sec
[  1] 5.0000-6.0000 sec  37.2 MBytes   312 Mbits/sec
[  1] 6.0000-7.0000 sec  37.2 MBytes   312 Mbits/sec
[  1] 7.0000-8.0000 sec  37.2 MBytes   312 Mbits/sec
[  1] 0.0000-8.0943 sec   299 MBytes   310 Mbits/sec

 --- Page Pool implementation on i.MX8 ----

shenwei@5810:~$ iperf -c 10.81.16.245 -w 2m -i 1
------------------------------------------------------------
Client connecting to 10.81.16.245, TCP port 5001
TCP window size:  416 KByte (WARNING: requested 1.91 MByte)
------------------------------------------------------------
[  1] local 10.81.17.20 port 43204 connected with 10.81.16.245 port 5001
[ ID] Interval       Transfer     Bandwidth
[  1] 0.0000-1.0000 sec   111 MBytes   933 Mbits/sec
[  1] 1.0000-2.0000 sec   111 MBytes   934 Mbits/sec
[  1] 2.0000-3.0000 sec   112 MBytes   935 Mbits/sec
[  1] 3.0000-4.0000 sec   111 MBytes   933 Mbits/sec
[  1] 4.0000-5.0000 sec   111 MBytes   934 Mbits/sec
[  1] 5.0000-6.0000 sec   111 MBytes   933 Mbits/sec
[  1] 6.0000-7.0000 sec   111 MBytes   931 Mbits/sec
[  1] 7.0000-8.0000 sec   112 MBytes   935 Mbits/sec
[  1] 8.0000-9.0000 sec   111 MBytes   933 Mbits/sec
[  1] 9.0000-10.0000 sec   112 MBytes   935 Mbits/sec
[  1] 0.0000-10.0077 sec  1.09 GBytes   933 Mbits/sec

 --- Non Page Pool implementation on i.MX8 ----

shenwei@5810:~$ iperf -c 10.81.16.245 -w 2m -i 1
------------------------------------------------------------
Client connecting to 10.81.16.245, TCP port 5001
TCP window size:  416 KByte (WARNING: requested 1.91 MByte)
------------------------------------------------------------
[  1] local 10.81.17.20 port 49154 connected with 10.81.16.245 port 5001
[ ID] Interval       Transfer     Bandwidth
[  1] 0.0000-1.0000 sec   104 MBytes   868 Mbits/sec
[  1] 1.0000-2.0000 sec   105 MBytes   878 Mbits/sec
[  1] 2.0000-3.0000 sec   105 MBytes   881 Mbits/sec
[  1] 3.0000-4.0000 sec   105 MBytes   879 Mbits/sec
[  1] 4.0000-5.0000 sec   105 MBytes   878 Mbits/sec
[  1] 5.0000-6.0000 sec   105 MBytes   878 Mbits/sec
[  1] 6.0000-7.0000 sec   104 MBytes   875 Mbits/sec
[  1] 7.0000-8.0000 sec   104 MBytes   875 Mbits/sec
[  1] 8.0000-9.0000 sec   104 MBytes   873 Mbits/sec
[  1] 9.0000-10.0000 sec   104 MBytes   875 Mbits/sec
[  1] 0.0000-10.0073 sec  1.02 GBytes   875 Mbits/sec

 --- Page Pool implementation on i.MX6SX ----

shenwei@5810:~/pktgen$ iperf -c 10.81.16.245 -w 2m -i 1
------------------------------------------------------------
Client connecting to 10.81.16.245, TCP port 5001
TCP window size:  416 KByte (WARNING: requested 1.91 MByte)
------------------------------------------------------------
[  1] local 10.81.17.20 port 57288 connected with 10.81.16.245 port 5001
[ ID] Interval       Transfer     Bandwidth
[  1] 0.0000-1.0000 sec  78.8 MBytes   661 Mbits/sec
[  1] 1.0000-2.0000 sec  82.5 MBytes   692 Mbits/sec
[  1] 2.0000-3.0000 sec  82.4 MBytes   691 Mbits/sec
[  1] 3.0000-4.0000 sec  82.4 MBytes   691 Mbits/sec
[  1] 4.0000-5.0000 sec  82.5 MBytes   692 Mbits/sec
[  1] 5.0000-6.0000 sec  82.4 MBytes   691 Mbits/sec
[  1] 6.0000-7.0000 sec  82.5 MBytes   692 Mbits/sec
[  1] 7.0000-8.0000 sec  82.4 MBytes   691 Mbits/sec
[  1] 8.0000-9.0000 sec  82.4 MBytes   691 Mbits/sec
[  1] 9.0000-9.5506 sec  45.0 MBytes   686 Mbits/sec
[  1] 0.0000-9.5506 sec   783 MBytes   688 Mbits/sec

 --- Non Page Pool implementation on i.MX6SX ----

shenwei@5810:~/pktgen$ iperf -c 10.81.16.245 -w 2m -i 1
------------------------------------------------------------
Client connecting to 10.81.16.245, TCP port 5001
TCP window size:  416 KByte (WARNING: requested 1.91 MByte)
------------------------------------------------------------
[  1] local 10.81.17.20 port 36486 connected with 10.81.16.245 port 5001
[ ID] Interval       Transfer     Bandwidth
[  1] 0.0000-1.0000 sec  70.5 MBytes   591 Mbits/sec
[  1] 1.0000-2.0000 sec  64.5 MBytes   541 Mbits/sec
[  1] 2.0000-3.0000 sec  73.6 MBytes   618 Mbits/sec
[  1] 3.0000-4.0000 sec  73.6 MBytes   618 Mbits/sec
[  1] 4.0000-5.0000 sec  72.9 MBytes   611 Mbits/sec
[  1] 5.0000-6.0000 sec  73.4 MBytes   616 Mbits/sec
[  1] 6.0000-7.0000 sec  73.5 MBytes   617 Mbits/sec
[  1] 7.0000-8.0000 sec  73.4 MBytes   616 Mbits/sec
[  1] 8.0000-9.0000 sec  73.4 MBytes   616 Mbits/sec
[  1] 9.0000-10.0000 sec  73.9 MBytes   620 Mbits/sec
[  1] 0.0000-10.0174 sec   723 MBytes   605 Mbits/sec

Signed-off-by: Shenwei Wang <shenwei.wang@nxp.com>
---

Changes in v2:
 - adding the testing result on i.MX6SX platform.
 - adding the testing result for small packets (64 bytes)
 - remove the used member variable in fec_enet_private.
 - reorder the local variable declarations in function of
   fec_enet_alloc_rxq_buffers.

 drivers/net/ethernet/freescale/Kconfig    |   1 +
 drivers/net/ethernet/freescale/fec.h      |  21 ++-
 drivers/net/ethernet/freescale/fec_main.c | 155 ++++++++++++++--------
 3 files changed, 119 insertions(+), 58 deletions(-)

diff --git a/drivers/net/ethernet/freescale/Kconfig b/drivers/net/ethernet/freescale/Kconfig
index b7bf45cec29d..ce866ae3df03 100644
--- a/drivers/net/ethernet/freescale/Kconfig
+++ b/drivers/net/ethernet/freescale/Kconfig
@@ -28,6 +28,7 @@ config FEC
 	depends on PTP_1588_CLOCK_OPTIONAL
 	select CRC32
 	select PHYLIB
+	select PAGE_POOL
 	imply NET_SELFTESTS
 	help
 	  Say Y here if you want to use the built-in 10/100 Fast ethernet
diff --git a/drivers/net/ethernet/freescale/fec.h b/drivers/net/ethernet/freescale/fec.h
index b0100fe3c9e4..33f84a30e167 100644
--- a/drivers/net/ethernet/freescale/fec.h
+++ b/drivers/net/ethernet/freescale/fec.h
@@ -17,6 +17,7 @@
 #include <linux/clocksource.h>
 #include <linux/net_tstamp.h>
 #include <linux/pm_qos.h>
+#include <linux/bpf.h>
 #include <linux/ptp_clock_kernel.h>
 #include <linux/timecounter.h>
 #include <dt-bindings/firmware/imx/rsrc.h>
@@ -346,8 +347,11 @@ struct bufdesc_ex {
  * the skbuffer directly.
  */

+#define FEC_ENET_XDP_HEADROOM	(XDP_PACKET_HEADROOM)
+
 #define FEC_ENET_RX_PAGES	256
-#define FEC_ENET_RX_FRSIZE	2048
+#define FEC_ENET_RX_FRSIZE	(PAGE_SIZE - FEC_ENET_XDP_HEADROOM \
+		- SKB_DATA_ALIGN(sizeof(struct skb_shared_info)))
 #define FEC_ENET_RX_FRPPG	(PAGE_SIZE / FEC_ENET_RX_FRSIZE)
 #define RX_RING_SIZE		(FEC_ENET_RX_FRPPG * FEC_ENET_RX_PAGES)
 #define FEC_ENET_TX_FRSIZE	2048
@@ -517,6 +521,12 @@ struct bufdesc_prop {
 	unsigned char dsize_log2;
 };

+struct fec_enet_priv_txrx_info {
+	int	offset;
+	struct	page *page;
+	struct  sk_buff *skb;
+};
+
 struct fec_enet_priv_tx_q {
 	struct bufdesc_prop bd;
 	unsigned char *tx_bounce[TX_RING_SIZE];
@@ -532,7 +542,14 @@ struct fec_enet_priv_tx_q {

 struct fec_enet_priv_rx_q {
 	struct bufdesc_prop bd;
-	struct  sk_buff *rx_skbuff[RX_RING_SIZE];
+	struct  fec_enet_priv_txrx_info rx_skb_info[RX_RING_SIZE];
+
+	/* page_pool */
+	struct page_pool *page_pool;
+	struct xdp_rxq_info xdp_rxq;
+
+	/* rx queue number, in the range 0-7 */
+	u8 id;
 };

 struct fec_stop_mode_gpr {
diff --git a/drivers/net/ethernet/freescale/fec_main.c b/drivers/net/ethernet/freescale/fec_main.c
index 59921218a8a4..169950e43b88 100644
--- a/drivers/net/ethernet/freescale/fec_main.c
+++ b/drivers/net/ethernet/freescale/fec_main.c
@@ -66,6 +66,8 @@
 #include <linux/mfd/syscon.h>
 #include <linux/regmap.h>
 #include <soc/imx/cpuidle.h>
+#include <linux/filter.h>
+#include <linux/bpf.h>

 #include <asm/cacheflush.h>

@@ -422,6 +424,48 @@ fec_enet_clear_csum(struct sk_buff *skb, struct net_device *ndev)
 	return 0;
 }

+static int
+fec_enet_create_page_pool(struct fec_enet_private *fep,
+			  struct fec_enet_priv_rx_q *rxq, int size)
+{
+	struct page_pool_params pp_params = {
+		.order = 0,
+		.flags = PP_FLAG_DMA_MAP | PP_FLAG_DMA_SYNC_DEV,
+		.pool_size = size,
+		.nid = dev_to_node(&fep->pdev->dev),
+		.dev = &fep->pdev->dev,
+		.dma_dir = DMA_FROM_DEVICE,
+		.offset = FEC_ENET_XDP_HEADROOM,
+		.max_len = FEC_ENET_RX_FRSIZE,
+	};
+	int err;
+
+	rxq->page_pool = page_pool_create(&pp_params);
+	if (IS_ERR(rxq->page_pool)) {
+		err = PTR_ERR(rxq->page_pool);
+		rxq->page_pool = NULL;
+		return err;
+	}
+
+	err = xdp_rxq_info_reg(&rxq->xdp_rxq, fep->netdev, rxq->id, 0);
+	if (err < 0)
+		goto err_free_pp;
+
+	err = xdp_rxq_info_reg_mem_model(&rxq->xdp_rxq, MEM_TYPE_PAGE_POOL,
+					 rxq->page_pool);
+	if (err)
+		goto err_unregister_rxq;
+
+	return 0;
+
+err_unregister_rxq:
+	xdp_rxq_info_unreg(&rxq->xdp_rxq);
+err_free_pp:
+	page_pool_destroy(rxq->page_pool);
+	rxq->page_pool = NULL;
+	return err;
+}
+
 static struct bufdesc *
 fec_enet_txq_submit_frag_skb(struct fec_enet_priv_tx_q *txq,
 			     struct sk_buff *skb,
@@ -1450,7 +1494,7 @@ static void fec_enet_tx(struct net_device *ndev)
 		fec_enet_tx_queue(ndev, i);
 }

-static int
+static int __maybe_unused
 fec_enet_new_rxbdp(struct net_device *ndev, struct bufdesc *bdp, struct sk_buff *skb)
 {
 	struct  fec_enet_private *fep = netdev_priv(ndev);
@@ -1470,8 +1514,9 @@ fec_enet_new_rxbdp(struct net_device *ndev, struct bufdesc *bdp, struct sk_buff
 	return 0;
 }

-static bool fec_enet_copybreak(struct net_device *ndev, struct sk_buff **skb,
-			       struct bufdesc *bdp, u32 length, bool swap)
+static bool __maybe_unused
+fec_enet_copybreak(struct net_device *ndev, struct sk_buff **skb,
+		   struct bufdesc *bdp, u32 length, bool swap)
 {
 	struct  fec_enet_private *fep = netdev_priv(ndev);
 	struct sk_buff *new_skb;
@@ -1496,6 +1541,21 @@ static bool fec_enet_copybreak(struct net_device *ndev, struct sk_buff **skb,
 	return true;
 }

+static void fec_enet_update_cbd(struct fec_enet_priv_rx_q *rxq,
+				struct bufdesc *bdp, int index)
+{
+	struct page *new_page;
+	dma_addr_t phys_addr;
+
+	new_page = page_pool_dev_alloc_pages(rxq->page_pool);
+	WARN_ON(!new_page);
+	rxq->rx_skb_info[index].page = new_page;
+
+	rxq->rx_skb_info[index].offset = FEC_ENET_XDP_HEADROOM;
+	phys_addr = page_pool_get_dma_addr(new_page) + FEC_ENET_XDP_HEADROOM;
+	bdp->cbd_bufaddr = cpu_to_fec32(phys_addr);
+}
+
 /* During a receive, the bd_rx.cur points to the current incoming buffer.
  * When we update through the ring, if the next incoming buffer has
  * not been given to the system, we just set the empty indicator,
@@ -1508,7 +1568,6 @@ fec_enet_rx_queue(struct net_device *ndev, int budget, u16 queue_id)
 	struct fec_enet_priv_rx_q *rxq;
 	struct bufdesc *bdp;
 	unsigned short status;
-	struct  sk_buff *skb_new = NULL;
 	struct  sk_buff *skb;
 	ushort	pkt_len;
 	__u8 *data;
@@ -1517,8 +1576,8 @@ fec_enet_rx_queue(struct net_device *ndev, int budget, u16 queue_id)
 	bool	vlan_packet_rcvd = false;
 	u16	vlan_tag;
 	int	index = 0;
-	bool	is_copybreak;
 	bool	need_swap = fep->quirks & FEC_QUIRK_SWAP_FRAME;
+	struct page *page;

 #ifdef CONFIG_M532x
 	flush_cache_all();
@@ -1570,31 +1629,25 @@ fec_enet_rx_queue(struct net_device *ndev, int budget, u16 queue_id)
 		ndev->stats.rx_bytes += pkt_len;

 		index = fec_enet_get_bd_index(bdp, &rxq->bd);
-		skb = rxq->rx_skbuff[index];
+		page = rxq->rx_skb_info[index].page;
+		dma_sync_single_for_cpu(&fep->pdev->dev,
+					fec32_to_cpu(bdp->cbd_bufaddr),
+					pkt_len,
+					DMA_FROM_DEVICE);
+		prefetch(page_address(page));
+		fec_enet_update_cbd(rxq, bdp, index);

 		/* The packet length includes FCS, but we don't want to
 		 * include that when passing upstream as it messes up
 		 * bridging applications.
 		 */
-		is_copybreak = fec_enet_copybreak(ndev, &skb, bdp, pkt_len - 4,
-						  need_swap);
-		if (!is_copybreak) {
-			skb_new = netdev_alloc_skb(ndev, FEC_ENET_RX_FRSIZE);
-			if (unlikely(!skb_new)) {
-				ndev->stats.rx_dropped++;
-				goto rx_processing_done;
-			}
-			dma_unmap_single(&fep->pdev->dev,
-					 fec32_to_cpu(bdp->cbd_bufaddr),
-					 FEC_ENET_RX_FRSIZE - fep->rx_align,
-					 DMA_FROM_DEVICE);
-		}
-
-		prefetch(skb->data - NET_IP_ALIGN);
+		skb = build_skb(page_address(page), PAGE_SIZE);
+		skb_reserve(skb, FEC_ENET_XDP_HEADROOM);
 		skb_put(skb, pkt_len - 4);
+		skb_mark_for_recycle(skb);
 		data = skb->data;

-		if (!is_copybreak && need_swap)
+		if (need_swap)
 			swap_buffer(data, pkt_len);

 #if !defined(CONFIG_M5272)
@@ -1649,16 +1702,6 @@ fec_enet_rx_queue(struct net_device *ndev, int budget, u16 queue_id)
 		skb_record_rx_queue(skb, queue_id);
 		napi_gro_receive(&fep->napi, skb);

-		if (is_copybreak) {
-			dma_sync_single_for_device(&fep->pdev->dev,
-						   fec32_to_cpu(bdp->cbd_bufaddr),
-						   FEC_ENET_RX_FRSIZE - fep->rx_align,
-						   DMA_FROM_DEVICE);
-		} else {
-			rxq->rx_skbuff[index] = skb_new;
-			fec_enet_new_rxbdp(ndev, bdp, skb_new);
-		}
-
 rx_processing_done:
 		/* Clear the status flags for this buffer */
 		status &= ~BD_ENET_RX_STATS;
@@ -3002,26 +3045,19 @@ static void fec_enet_free_buffers(struct net_device *ndev)
 	struct fec_enet_private *fep = netdev_priv(ndev);
 	unsigned int i;
 	struct sk_buff *skb;
-	struct bufdesc	*bdp;
 	struct fec_enet_priv_tx_q *txq;
 	struct fec_enet_priv_rx_q *rxq;
 	unsigned int q;

 	for (q = 0; q < fep->num_rx_queues; q++) {
 		rxq = fep->rx_queue[q];
-		bdp = rxq->bd.base;
-		for (i = 0; i < rxq->bd.ring_size; i++) {
-			skb = rxq->rx_skbuff[i];
-			rxq->rx_skbuff[i] = NULL;
-			if (skb) {
-				dma_unmap_single(&fep->pdev->dev,
-						 fec32_to_cpu(bdp->cbd_bufaddr),
-						 FEC_ENET_RX_FRSIZE - fep->rx_align,
-						 DMA_FROM_DEVICE);
-				dev_kfree_skb(skb);
-			}
-			bdp = fec_enet_get_nextdesc(bdp, &rxq->bd);
-		}
+		for (i = 0; i < rxq->bd.ring_size; i++)
+			page_pool_release_page(rxq->page_pool, rxq->rx_skb_info[i].page);
+
+		if (xdp_rxq_info_is_reg(&rxq->xdp_rxq))
+			xdp_rxq_info_unreg(&rxq->xdp_rxq);
+		page_pool_destroy(rxq->page_pool);
+		rxq->page_pool = NULL;
 	}

 	for (q = 0; q < fep->num_tx_queues; q++) {
@@ -3111,24 +3147,31 @@ static int
 fec_enet_alloc_rxq_buffers(struct net_device *ndev, unsigned int queue)
 {
 	struct fec_enet_private *fep = netdev_priv(ndev);
-	unsigned int i;
-	struct sk_buff *skb;
-	struct bufdesc	*bdp;
 	struct fec_enet_priv_rx_q *rxq;
+	dma_addr_t phys_addr;
+	struct bufdesc	*bdp;
+	struct page *page;
+	int i, err;

 	rxq = fep->rx_queue[queue];
 	bdp = rxq->bd.base;
+
+	err = fec_enet_create_page_pool(fep, rxq, rxq->bd.ring_size);
+	if (err < 0) {
+		netdev_err(ndev, "%s failed queue %d (%d)\n", __func__, queue, err);
+		return err;
+	}
+
 	for (i = 0; i < rxq->bd.ring_size; i++) {
-		skb = __netdev_alloc_skb(ndev, FEC_ENET_RX_FRSIZE, GFP_KERNEL);
-		if (!skb)
+		page = page_pool_dev_alloc_pages(rxq->page_pool);
+		if (!page)
 			goto err_alloc;

-		if (fec_enet_new_rxbdp(ndev, bdp, skb)) {
-			dev_kfree_skb(skb);
-			goto err_alloc;
-		}
+		phys_addr = page_pool_get_dma_addr(page) + FEC_ENET_XDP_HEADROOM;
+		bdp->cbd_bufaddr = cpu_to_fec32(phys_addr);

-		rxq->rx_skbuff[i] = skb;
+		rxq->rx_skb_info[i].page = page;
+		rxq->rx_skb_info[i].offset = FEC_ENET_XDP_HEADROOM;
 		bdp->cbd_sc = cpu_to_fec16(BD_ENET_RX_EMPTY);

 		if (fep->bufdesc_ex) {
--
2.34.1

